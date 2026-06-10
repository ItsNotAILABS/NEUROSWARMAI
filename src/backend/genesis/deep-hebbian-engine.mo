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
// DEEP HEBBIAN ENGINE — COMPLETE SYNAPTIC PLASTICITY WITH FULL BIOPHYSICS
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// This module implements the COMPLETE mathematics of synaptic plasticity:
//
// LAYER 1: CALCIUM DYNAMICS
// ────────────────────────
// d[Ca²⁺]/dt = -[Ca²⁺]/τ_Ca + Σ_spikes δ(t - t_spike) × Δ[Ca²⁺]
// Calcium is the universal signal for plasticity — everything flows through it.
//
// LAYER 2: NMDA RECEPTOR KINETICS
// ───────────────────────────────
// g_NMDA(V, [Mg²⁺]) = g_max × B(V) × (1 + [Mg²⁺]/Mg_0 × exp(-V/V_0))⁻¹
// The NMDA receptor is the coincidence detector — requires both pre AND post activity.
//
// LAYER 3: AMPA RECEPTOR TRAFFICKING
// ──────────────────────────────────
// d[AMPA_surface]/dt = k_exo × [AMPA_vesicle] - k_endo × [AMPA_surface]
// Long-term potentiation = more AMPA receptors at surface.
//
// LAYER 4: CAMKII AUTOPHOSPHORYLATION
// ───────────────────────────────────
// d[CaMKII*]/dt = k_on × [Ca⁴·CaM] × [CaMKII] - k_off × [CaMKII*]
// CaMKII is the "memory molecule" — stays active after calcium is gone.
//
// LAYER 5: PROTEIN SYNTHESIS (L-LTP)
// ──────────────────────────────────
// d[Protein]/dt = k_synth × [mRNA] × σ(CaMKII*) - k_deg × [Protein]
// Late-phase LTP requires new protein synthesis.
//
// LAYER 6: DENDRITIC COMPUTATION
// ─────────────────────────────
// V_dend(x, t) = Σ_inputs w_i × EPSP(t - t_i) × exp(-x/λ)
// Dendrites are not passive — they integrate and compute.
//
// LAYER 7: NEUROMODULATION
// ───────────────────────
// η_eff = η_base × (1 + α_DA × [DA]) × (1 + α_ACh × [ACh]) × (1 - α_5HT × [5-HT])
// Dopamine, acetylcholine, serotonin, norepinephrine all modulate plasticity.
//
// LAYER 8: HOMEOSTATIC SCALING
// ───────────────────────────
// w_scaled = w × (r_target / r_actual)^β
// Neurons maintain stable firing rates by scaling all synapses.
//
// LAYER 9: STRUCTURAL PLASTICITY
// ─────────────────────────────
// d[Spines]/dt = k_form × Activity × (1 - [Spines]/Spine_max) - k_elim × (1 - Activity) × [Spines]
// Synapses can form and die — the ultimate plasticity.
//
// LAYER 10: METAPLASTICITY
// ───────────────────────
// θ_BCM(t) = <y²(t)> — sliding threshold based on activity history
// Plasticity of plasticity — the system adapts how it adapts.
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// INTERTWINING WITH OTHER SYSTEMS:
// ════════════════════════════════
//
// 1. KURAMOTO → HEBBIAN:
//    - Kuramoto phases provide spike timing for STDP window
//    - Order parameter r(t) modulates global plasticity rate
//    - Phase coherence marks "teaching moments"
//
// 2. HEBBIAN → KURAMOTO:
//    - Hebbian weights become Kuramoto coupling strengths
//    - Learned associations create synchronization pathways
//    - Strong weights = strong coupling = tendency to sync
//
// 3. FREE ENERGY → HEBBIAN:
//    - Free Energy precision modulates learning rate
//    - Prediction errors drive error-driven learning
//    - Expected Free Energy guides exploration of weight space
//
// 4. HEBBIAN → FREE ENERGY:
//    - Hebbian weights encode the generative model
//    - Weight matrix IS the organism's model of the world
//    - Learning = updating the generative model
//
// 5. Q-LEARNING → HEBBIAN:
//    - TD error gates eligibility traces (three-factor rule)
//    - Reward modulates synaptic consolidation
//    - Value signals mark "important" patterns
//
// 6. HEBBIAN → Q-LEARNING:
//    - Eligibility traces enable credit assignment
//    - Synaptic tags mark candidates for consolidation
//    - Hebbian structure encodes state representations
//
// 7. MEMORY → HEBBIAN:
//    - Recalled patterns provide inputs for learning
//    - Memory replay drives offline consolidation
//    - Salience modulates which patterns get encoded
//
// 8. HEBBIAN → MEMORY:
//    - Weight patterns ARE stored memories
//    - Associative recall through pattern completion
//    - Consolidation transfers weights from fast to slow learning
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

module DeepHebbianEngine {

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // FUNDAMENTAL CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  // Mathematical constants
  public let PI : Float = 3.14159265358979323846264338327950288419716939937510;
  public let E : Float = 2.71828182845904523536028747135266249775724709369996;
  public let LN_2 : Float = 0.69314718055994530941723212145817656807550013436026;
  
  // Organism constants
  public let S_ZERO : Float = 1.0;
  public let S_ZERO_FLOOR : Float = 0.75;
  public let NUM_NODES : Nat = 12;
  public let NUM_SYNAPSES : Nat = 144;  // 12 × 12
  public let NUM_DENDRITES : Nat = 8;   // Per neuron
  public let NUM_COMPARTMENTS : Nat = 5; // Per dendrite
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // LAYER 1: CALCIUM DYNAMICS — THE UNIVERSAL PLASTICITY SIGNAL
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Calcium is THE signal that triggers all forms of plasticity.
  // d[Ca²⁺]/dt = -[Ca²⁺]/τ_Ca + I_NMDA + I_VGCC + I_internal
  //
  // Where:
  //   τ_Ca = calcium decay time constant (~20-50 ms)
  //   I_NMDA = calcium influx through NMDA receptors
  //   I_VGCC = calcium influx through voltage-gated calcium channels
  //   I_internal = calcium release from internal stores (ER)
  //
  
  public type CalciumState = {
    var concentration : Float;          // [Ca²⁺] in μM (resting ~0.1 μM)
    var bufferOccupancy : Float;        // Fraction of calcium bound to buffer
    var erStore : Float;                // Calcium in endoplasmic reticulum
    var mitochondriaStore : Float;      // Calcium in mitochondria
    var influxNMDA : Float;             // Current NMDA influx rate
    var influxVGCC : Float;             // Current VGCC influx rate
    var effluxPump : Float;             // Calcium pump rate
    var lastSpikeCaTransient : Float;   // Peak calcium from last spike
    var integralCalcium : Float;        // Time-integrated calcium (for LTP threshold)
  };
  
  // Calcium dynamics parameters
  public let CA_REST : Float = 0.0001;           // Resting [Ca²⁺] = 100 nM = 0.1 μM
  public let CA_SPIKE_INCREASE : Float = 0.001;  // Spike adds ~1 μM
  public let CA_TAU_DECAY : Float = 20.0;        // Decay time constant (ms)
  public let CA_TAU_BUFFER : Float = 5.0;        // Buffer binding time (ms)
  public let CA_BUFFER_CAPACITY : Float = 0.9;   // 90% of calcium gets buffered
  public let CA_ER_RELEASE_THRESHOLD : Float = 0.5;  // [Ca²⁺] to trigger ER release
  public let CA_ER_RELEASE_AMOUNT : Float = 0.2;     // Amount released from ER
  public let CA_PUMP_RATE : Float = 0.01;        // Active pump rate
  public let CA_LTP_THRESHOLD : Float = 0.5;     // High calcium → LTP
  public let CA_LTD_THRESHOLD : Float = 0.2;     // Low calcium → LTD
  
  // Initialize calcium state
  public func initCalciumState() : CalciumState {
    {
      var concentration = CA_REST;
      var bufferOccupancy = 0.0;
      var erStore = 1.0;  // Full ER store
      var mitochondriaStore = 0.0;
      var influxNMDA = 0.0;
      var influxVGCC = 0.0;
      var effluxPump = 0.0;
      var lastSpikeCaTransient = 0.0;
      var integralCalcium = 0.0;
    }
  };
  
  // Update calcium dynamics for one time step
  // INTERTWINING: Receives NMDA conductance (depends on Hebbian-weighted inputs)
  public func updateCalcium(
    state : CalciumState,
    presynapticActivity : Float,         // Summed presynaptic input
    postsynapticVoltage : Float,         // Membrane potential
    nmdaConductance : Float,             // ← INTERTWINING: From NMDA kinetics
    dt : Float                           // Time step in ms
  ) {
    let ca = state.concentration;
    
    // NMDA influx — depends on both pre activity and post voltage (coincidence detector)
    let mgBlock = 1.0 / (1.0 + 0.28 * exp(-0.062 * postsynapticVoltage));
    state.influxNMDA := nmdaConductance * presynapticActivity * mgBlock * 
                        (postsynapticVoltage + 70.0);  // Driving force
    
    // VGCC influx — purely voltage-dependent
    let vgccGating = sigmoid((postsynapticVoltage + 20.0) / 10.0);
    state.influxVGCC := 0.001 * vgccGating * (postsynapticVoltage + 80.0);
    
    // ER calcium release (calcium-induced calcium release — CICR)
    if (ca > CA_ER_RELEASE_THRESHOLD and state.erStore > 0.1) {
      let release = CA_ER_RELEASE_AMOUNT * state.erStore;
      state.erStore -= release * dt / 10.0;
      state.concentration += release;
    };
    
    // ER refilling when calcium is low
    if (ca < CA_REST * 2.0 and state.erStore < 1.0) {
      let uptake = 0.01 * ca;
      state.erStore += uptake * dt / 10.0;
    };
    
    // Buffer binding/unbinding
    let freeBuffer = 1.0 - state.bufferOccupancy;
    let bufferBinding = 0.1 * ca * freeBuffer;
    let bufferUnbinding = 0.01 * state.bufferOccupancy;
    state.bufferOccupancy += (bufferBinding - bufferUnbinding) * dt / CA_TAU_BUFFER;
    state.bufferOccupancy := clamp(state.bufferOccupancy, 0.0, 1.0);
    
    // Calcium pump (active extrusion)
    state.effluxPump := CA_PUMP_RATE * ca / (ca + 0.0005);  // Michaelis-Menten
    
    // Main calcium ODE: d[Ca]/dt = influx - efflux - buffering - decay
    let dCa = state.influxNMDA + state.influxVGCC - state.effluxPump - 
              (ca - CA_REST) / CA_TAU_DECAY - bufferBinding + bufferUnbinding;
    
    state.concentration := Float.max(CA_REST * 0.5, ca + dCa * dt);
    
    // Update integral (for detecting sustained high calcium)
    state.integralCalcium := 0.99 * state.integralCalcium + 0.01 * state.concentration;
  };
  
  // Spike-triggered calcium transient
  public func triggerCalciumSpike(state : CalciumState, spikeAmplitude : Float) {
    state.concentration += CA_SPIKE_INCREASE * spikeAmplitude;
    state.lastSpikeCaTransient := state.concentration;
  };
  
  // Determine plasticity direction based on calcium level
  public func getPlasticityDirection(ca : Float) : Float {
    // BCM-like rule: low Ca → LTD, high Ca → LTP
    if (ca > CA_LTP_THRESHOLD) {
      // LTP regime — strength proportional to how much above threshold
      (ca - CA_LTP_THRESHOLD) / (1.0 - CA_LTP_THRESHOLD)
    } else if (ca > CA_LTD_THRESHOLD) {
      // No change zone
      0.0
    } else {
      // LTD regime — negative
      -(CA_LTD_THRESHOLD - ca) / CA_LTD_THRESHOLD
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // LAYER 2: NMDA RECEPTOR KINETICS — THE COINCIDENCE DETECTOR
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // NMDA receptors are special: they require BOTH presynaptic glutamate AND postsynaptic depolarization.
  // This makes them natural "AND gates" for Hebbian learning.
  //
  // Kinetic scheme:
  //   Unbound (U) ←→ Bound-Closed (BC) ←→ Bound-Open (BO) → Desensitized (D)
  //
  // g_NMDA = g_max × P_open × B(V)
  // where B(V) = 1 / (1 + [Mg²⁺]/3.57 × exp(-0.062 × V))  is the magnesium block
  //
  
  public type NMDAReceptorState = {
    var unbound : Float;             // Fraction in unbound state
    var boundClosed : Float;         // Fraction bound but channel closed
    var boundOpen : Float;           // Fraction bound and channel open
    var desensitized : Float;        // Fraction desensitized
    var glutamateConcentration : Float;  // Local glutamate [Glu]
    var magnesiumBlock : Float;      // Current Mg²⁺ block factor
    var conductance : Float;         // Current conductance
    var calciumPermeability : Float; // Ca²⁺ vs Na⁺ selectivity
  };
  
  // NMDA kinetic rate constants
  public let NMDA_K_ON : Float = 5.0;         // Glutamate binding (μM⁻¹ ms⁻¹)
  public let NMDA_K_OFF : Float = 0.01;       // Glutamate unbinding (ms⁻¹)
  public let NMDA_ALPHA : Float = 0.5;        // Opening rate (ms⁻¹)
  public let NMDA_BETA : Float = 0.01;        // Closing rate (ms⁻¹)
  public let NMDA_K_DESENS : Float = 0.001;   // Desensitization rate (ms⁻¹)
  public let NMDA_K_RESENS : Float = 0.0001;  // Resensitization rate (ms⁻¹)
  public let NMDA_G_MAX : Float = 0.5;        // Maximum conductance (nS)
  public let NMDA_E_REV : Float = 0.0;        // Reversal potential (mV)
  public let MG_CONCENTRATION : Float = 1.0;  // Extracellular [Mg²⁺] (mM)
  public let MG_HALF_BLOCK : Float = 3.57;    // [Mg²⁺] for half-block at 0mV (mM)
  public let MG_VOLTAGE_DEPENDENCE : Float = 0.062;  // Voltage dependence (mV⁻¹)
  
  // Initialize NMDA receptor state
  public func initNMDAState() : NMDAReceptorState {
    {
      var unbound = 1.0;
      var boundClosed = 0.0;
      var boundOpen = 0.0;
      var desensitized = 0.0;
      var glutamateConcentration = 0.0;
      var magnesiumBlock = 1.0;
      var conductance = 0.0;
      var calciumPermeability = 0.1;  // ~10% of current is Ca²⁺
    }
  };
  
  // Update NMDA receptor kinetics
  // INTERTWINING: Glutamate release depends on presynaptic activity (Hebbian input)
  public func updateNMDA(
    state : NMDAReceptorState,
    presynapticRelease : Float,          // Presynaptic glutamate release
    postsynapticVoltage : Float,         // Membrane potential (mV)
    dt : Float                           // Time step (ms)
  ) {
    // Update glutamate concentration (first-order decay)
    let gluRelease = presynapticRelease * 1.0;  // Concentration from release
    state.glutamateConcentration := 0.9 * state.glutamateConcentration + 0.1 * gluRelease;
    let glu = state.glutamateConcentration;
    
    // Compute magnesium block factor
    // B(V) = 1 / (1 + [Mg²⁺]/Mg₀ × exp(-γV))
    state.magnesiumBlock := 1.0 / (1.0 + MG_CONCENTRATION / MG_HALF_BLOCK * 
                                   exp(-MG_VOLTAGE_DEPENDENCE * postsynapticVoltage));
    
    // Kinetic transitions
    // U → BC: k_on × [Glu]
    let uToBC = NMDA_K_ON * glu * state.unbound;
    // BC → U: k_off
    let bcToU = NMDA_K_OFF * state.boundClosed;
    // BC → BO: α
    let bcToBO = NMDA_ALPHA * state.boundClosed;
    // BO → BC: β
    let boToBC = NMDA_BETA * state.boundOpen;
    // BO → D: k_desens
    let boToD = NMDA_K_DESENS * state.boundOpen;
    // D → BC: k_resens
    let dToBC = NMDA_K_RESENS * state.desensitized;
    
    // Update state fractions
    state.unbound := state.unbound + dt * (-uToBC + bcToU);
    state.boundClosed := state.boundClosed + dt * (uToBC - bcToU - bcToBO + boToBC + dToBC);
    state.boundOpen := state.boundOpen + dt * (bcToBO - boToBC - boToD);
    state.desensitized := state.desensitized + dt * (boToD - dToBC);
    
    // Normalize to ensure sum = 1
    let total = state.unbound + state.boundClosed + state.boundOpen + state.desensitized;
    if (total > 0.0) {
      state.unbound /= total;
      state.boundClosed /= total;
      state.boundOpen /= total;
      state.desensitized /= total;
    };
    
    // Compute conductance: g = g_max × P_open × B(V)
    state.conductance := NMDA_G_MAX * state.boundOpen * state.magnesiumBlock;
  };
  
  // Get NMDA calcium current
  public func getNMDACalciumCurrent(state : NMDAReceptorState, voltage : Float) : Float {
    // I_Ca = P_Ca × g × (V - E_Ca)
    let drivingForce = voltage - 120.0;  // E_Ca ≈ +120 mV
    state.calciumPermeability * state.conductance * drivingForce
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // LAYER 3: AMPA RECEPTOR TRAFFICKING — THE EXPRESSION MECHANISM
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // LTP is expressed by increasing AMPA receptors at the synapse surface.
  // LTD is expressed by removing them (endocytosis).
  //
  // Trafficking equation:
  // d[AMPA_surf]/dt = k_exo × [AMPA_int] × Signal_LTP - k_endo × [AMPA_surf] × Signal_LTD
  //
  
  public type AMPATraffickingState = {
    var surfaceReceptors : Float;        // Number at synapse surface (weight proxy!)
    var internalPool : Float;            // Receptors in internal vesicles
    var recyclingPool : Float;           // Receptors being recycled
    var synthesisRate : Float;           // New receptor synthesis
    var degradationRate : Float;         // Receptor degradation
    var exocytosisRate : Float;          // Current insertion rate
    var endocytosisRate : Float;         // Current removal rate
    var phosphorylationState : Float;    // Affects trafficking rates
  };
  
  // AMPA trafficking parameters
  public let AMPA_K_EXO_BASE : Float = 0.01;     // Base exocytosis rate
  public let AMPA_K_ENDO_BASE : Float = 0.005;   // Base endocytosis rate
  public let AMPA_K_SYNTH : Float = 0.001;       // Synthesis rate
  public let AMPA_K_DEG : Float = 0.0001;        // Degradation rate
  public let AMPA_MAX_SURFACE : Float = 100.0;   // Max receptors at surface
  public let AMPA_TOTAL_POOL : Float = 200.0;    // Total receptor pool
  
  // Initialize AMPA trafficking state
  public func initAMPAState() : AMPATraffickingState {
    {
      var surfaceReceptors = 30.0;  // ~30% at surface initially
      var internalPool = 70.0;      // ~70% internal
      var recyclingPool = 0.0;
      var synthesisRate = AMPA_K_SYNTH;
      var degradationRate = AMPA_K_DEG;
      var exocytosisRate = AMPA_K_EXO_BASE;
      var endocytosisRate = AMPA_K_ENDO_BASE;
      var phosphorylationState = 0.5;
    }
  };
  
  // Update AMPA trafficking based on plasticity signals
  // INTERTWINING: CaMKII activity drives trafficking (from calcium)
  public func updateAMPATrafficking(
    state : AMPATraffickingState,
    camkiiActivity : Float,              // ← INTERTWINING: From CaMKII cascade
    plasticityDirection : Float,         // +1 for LTP, -1 for LTD
    dt : Float
  ) {
    // CaMKII phosphorylates GluA1, promoting surface expression
    state.phosphorylationState := 0.9 * state.phosphorylationState + 
                                  0.1 * camkiiActivity;
    
    // Modulate trafficking rates by plasticity signal
    let ltpSignal = Float.max(0.0, plasticityDirection);
    let ltdSignal = Float.max(0.0, -plasticityDirection);
    
    // Exocytosis enhanced by LTP signal and CaMKII
    state.exocytosisRate := AMPA_K_EXO_BASE * (1.0 + 2.0 * ltpSignal) * 
                           (1.0 + state.phosphorylationState);
    
    // Endocytosis enhanced by LTD signal
    state.endocytosisRate := AMPA_K_ENDO_BASE * (1.0 + 2.0 * ltdSignal);
    
    // Trafficking dynamics
    let exocytosis = state.exocytosisRate * state.internalPool * 
                     (1.0 - state.surfaceReceptors / AMPA_MAX_SURFACE);
    let endocytosis = state.endocytosisRate * state.surfaceReceptors;
    
    // Recycling: internalized receptors go to recycling pool
    let toRecycling = 0.5 * endocytosis;  // 50% recycled
    let toDegradation = 0.5 * endocytosis;  // 50% degraded
    let fromRecycling = 0.1 * state.recyclingPool;
    
    // Synthesis replaces degraded receptors
    let synthesis = state.synthesisRate * (AMPA_TOTAL_POOL - state.surfaceReceptors - 
                   state.internalPool - state.recyclingPool);
    
    // Update compartments
    state.surfaceReceptors := state.surfaceReceptors + dt * (exocytosis - endocytosis);
    state.internalPool := state.internalPool + dt * (fromRecycling + synthesis - exocytosis);
    state.recyclingPool := state.recyclingPool + dt * (toRecycling - fromRecycling);
    
    // Enforce bounds
    state.surfaceReceptors := clamp(state.surfaceReceptors, 1.0, AMPA_MAX_SURFACE);
    state.internalPool := clamp(state.internalPool, 0.0, AMPA_TOTAL_POOL);
  };
  
  // Get synaptic weight from AMPA surface receptors
  public func getSynapticWeight(state : AMPATraffickingState) : Float {
    state.surfaceReceptors / AMPA_MAX_SURFACE
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // LAYER 4: CAMKII BIOCHEMISTRY — THE MOLECULAR MEMORY
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // CaMKII is the "memory molecule" — it stays active even after calcium is gone
  // through autophosphorylation. This is a key mechanism for LTP maintenance.
  //
  // Activation cascade:
  //   Ca²⁺ + Calmodulin → Ca⁴·CaM
  //   Ca⁴·CaM + CaMKII → CaMKII* (active)
  //   CaMKII* + CaMKII* → CaMKII*-P (autophosphorylated, stays active)
  //
  
  public type CaMKIIState = {
    var inactivePool : Float;            // Unphosphorylated CaMKII
    var calciumBound : Float;            // Ca/CaM-bound CaMKII
    var autoPhosphorylated : Float;      // Autophosphorylated (persistent active)
    var totalActivity : Float;           // Total kinase activity
    var calmodulinBound : Float;         // Free calmodulin bound to Ca²⁺
    var phosphataseActivity : Float;     // PP1/PP2A activity (deactivates)
    var substratePhos : Float;           // Phosphorylated substrates
  };
  
  // CaMKII kinetic parameters
  public let CAMKII_K_CAM_BIND : Float = 10.0;   // CaM binding rate
  public let CAMKII_K_CAM_UNBIND : Float = 1.0;  // CaM unbinding rate
  public let CAMKII_K_AUTO : Float = 0.1;        // Autophosphorylation rate
  public let CAMKII_K_DEPHOS : Float = 0.001;    // Dephosphorylation rate
  public let CAMKII_CA_HILL : Float = 4.0;       // Hill coefficient for Ca²⁺
  public let CAMKII_CA_KD : Float = 0.3;         // Ca²⁺ dissociation constant
  public let CAMKII_TOTAL : Float = 1.0;         // Total CaMKII concentration
  
  // Initialize CaMKII state
  public func initCaMKIIState() : CaMKIIState {
    {
      var inactivePool = 1.0;
      var calciumBound = 0.0;
      var autoPhosphorylated = 0.0;
      var totalActivity = 0.0;
      var calmodulinBound = 0.0;
      var phosphataseActivity = 0.01;
      var substratePhos = 0.0;
    }
  };
  
  // Update CaMKII dynamics
  // INTERTWINING: Calcium concentration drives activation
  public func updateCaMKII(
    state : CaMKIIState,
    calciumConcentration : Float,        // ← INTERTWINING: From calcium dynamics
    dt : Float
  ) {
    // Ca²⁺ binding to calmodulin (Hill equation)
    let caHill = Float.pow(calciumConcentration, CAMKII_CA_HILL) /
                 (Float.pow(CAMKII_CA_KD, CAMKII_CA_HILL) + Float.pow(calciumConcentration, CAMKII_CA_HILL));
    state.calmodulinBound := caHill;
    
    // CaM binding to CaMKII
    let camBinding = CAMKII_K_CAM_BIND * state.calmodulinBound * state.inactivePool;
    let camUnbinding = CAMKII_K_CAM_UNBIND * state.calciumBound * (1.0 - state.calmodulinBound);
    
    // Autophosphorylation — requires two adjacent active subunits
    // Rate ∝ [CaMKII*]² (cooperative)
    let autoRate = CAMKII_K_AUTO * state.calciumBound * state.calciumBound;
    
    // Dephosphorylation by PP1/PP2A
    let dephosRate = CAMKII_K_DEPHOS * state.phosphataseActivity * state.autoPhosphorylated;
    
    // Update pools
    state.inactivePool := state.inactivePool + dt * (-camBinding + camUnbinding + dephosRate);
    state.calciumBound := state.calciumBound + dt * (camBinding - camUnbinding - autoRate);
    state.autoPhosphorylated := state.autoPhosphorylated + dt * (autoRate - dephosRate);
    
    // Normalize to total
    let total = state.inactivePool + state.calciumBound + state.autoPhosphorylated;
    if (total > 0.0) {
      let scale = CAMKII_TOTAL / total;
      state.inactivePool *= scale;
      state.calciumBound *= scale;
      state.autoPhosphorylated *= scale;
    };
    
    // Total activity = Ca-bound + autophosphorylated
    state.totalActivity := state.calciumBound + state.autoPhosphorylated;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // LAYER 5: PROTEIN SYNTHESIS — LATE-PHASE LTP
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Early LTP (~1 hour) doesn't need new proteins.
  // Late LTP (>3 hours) requires new protein synthesis at the synapse.
  //
  // Key molecules: Arc/Arg3.1, BDNF, PKMζ, CPEB
  //
  
  public type ProteinSynthesisState = {
    var mrnaCREB : Float;            // CREB-dependent mRNA
    var mrnaArc : Float;             // Arc/Arg3.1 mRNA
    var mrnaBDNF : Float;            // BDNF mRNA
    var proteinArc : Float;          // Arc protein
    var proteinBDNF : Float;         // BDNF protein
    var proteinPKMzeta : Float;      // PKMζ — maintains late LTP
    var crebPhosphorylated : Float;  // Active CREB transcription factor
    var synthesisCapacity : Float;   // Ribosomal/translational capacity
    var synapticTag : Float;         // Tag marking synapse for capture
  };
  
  // Protein synthesis parameters
  public let PROT_K_TRANSCRIPTION : Float = 0.001;  // Transcription rate
  public let PROT_K_TRANSLATION : Float = 0.01;     // Translation rate
  public let PROT_K_MRNA_DECAY : Float = 0.0001;    // mRNA degradation
  public let PROT_K_PROT_DECAY : Float = 0.00001;   // Protein degradation
  public let PROT_TAG_THRESHOLD : Float = 0.3;      // CaMKII level to set tag
  public let PROT_TAG_DURATION : Float = 3600000.0; // Tag lasts ~1 hour (ms)
  
  // Initialize protein synthesis state
  public func initProteinSynthesisState() : ProteinSynthesisState {
    {
      var mrnaCREB = 0.0;
      var mrnaArc = 0.0;
      var mrnaBDNF = 0.0;
      var proteinArc = 0.0;
      var proteinBDNF = 0.0;
      var proteinPKMzeta = 0.0;
      var crebPhosphorylated = 0.0;
      var synthesisCapacity = 1.0;
      var synapticTag = 0.0;
    }
  };
  
  // Update protein synthesis
  // INTERTWINING: CaMKII and calcium drive transcription
  public func updateProteinSynthesis(
    state : ProteinSynthesisState,
    camkiiActivity : Float,              // ← INTERTWINING: From CaMKII
    calciumIntegral : Float,             // ← INTERTWINING: Sustained calcium
    dt : Float
  ) {
    // CREB phosphorylation (by CaMKII and PKA)
    let crebPhos = 0.01 * camkiiActivity + 0.005 * calciumIntegral;
    state.crebPhosphorylated := 0.99 * state.crebPhosphorylated + 0.01 * crebPhos;
    
    // Transcription (requires active CREB)
    let transcriptionRate = PROT_K_TRANSCRIPTION * state.crebPhosphorylated * state.synthesisCapacity;
    state.mrnaCREB := state.mrnaCREB + dt * (transcriptionRate - PROT_K_MRNA_DECAY * state.mrnaCREB);
    state.mrnaArc := state.mrnaArc + dt * (transcriptionRate * 0.5 - PROT_K_MRNA_DECAY * state.mrnaArc);
    state.mrnaBDNF := state.mrnaBDNF + dt * (transcriptionRate * 0.3 - PROT_K_MRNA_DECAY * state.mrnaBDNF);
    
    // Translation
    let translationRate = PROT_K_TRANSLATION * state.synthesisCapacity;
    state.proteinArc := state.proteinArc + dt * (translationRate * state.mrnaArc - PROT_K_PROT_DECAY * state.proteinArc);
    state.proteinBDNF := state.proteinBDNF + dt * (translationRate * state.mrnaBDNF - PROT_K_PROT_DECAY * state.proteinBDNF);
    
    // PKMζ synthesis — driven by strong and sustained activity
    if (camkiiActivity > 0.5 and calciumIntegral > 0.3) {
      state.proteinPKMzeta := state.proteinPKMzeta + dt * 0.001;
    };
    state.proteinPKMzeta := state.proteinPKMzeta - dt * PROT_K_PROT_DECAY * state.proteinPKMzeta;
    
    // Synaptic tag — set by CaMKII activity
    if (camkiiActivity > PROT_TAG_THRESHOLD) {
      state.synapticTag := 1.0;
    } else {
      state.synapticTag := state.synapticTag * (1.0 - dt / PROT_TAG_DURATION);
    };
  };
  
  // Check if synapse can capture plasticity-related proteins
  public func canCaptureProteins(state : ProteinSynthesisState) : Bool {
    state.synapticTag > 0.5
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // LAYER 6: DENDRITIC COMPUTATION — BEYOND POINT NEURONS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Dendrites are not just passive cables — they:
  // 1. Have active conductances (Ca²⁺ spikes, NMDA spikes)
  // 2. Perform local integration (clustered inputs sum nonlinearly)
  // 3. Gate backpropagating action potentials
  // 4. Have their own calcium dynamics
  //
  // Cable equation:
  // τ_m ∂V/∂t = λ² ∂²V/∂x² - V + R_m × I_syn
  //
  
  public type DendriticCompartment = {
    var voltage : Float;                 // Local membrane potential (mV)
    var calcium : Float;                 // Local [Ca²⁺]
    var inputConductance : Float;        // Total synaptic conductance
    var activeSpike : Bool;              // Local dendritic spike?
    var bapAmplitude : Float;            // Backpropagating AP amplitude
    var distanceFromSoma : Float;        // Position along dendrite
    var branchOrder : Nat;               // How many branch points from soma
  };
  
  public type DendriticBranch = {
    id : Nat;
    var compartments : [var DendriticCompartment];
    var totalLength : Float;             // μm
    var diameter : Float;                // μm
    var inputResistance : Float;         // MΩ
    var electrotonicLength : Float;      // λ (space constant)
  };
  
  public type DendriticTree = {
    var branches : [var DendriticBranch];
    var somaVoltage : Float;
    var somaCalcium : Float;
    var totalSynapticInput : Float;
    var spikeCount : Nat;
  };
  
  // Dendritic parameters
  public let DEND_R_M : Float = 20000.0;      // Membrane resistance (Ω·cm²)
  public let DEND_C_M : Float = 1.0;          // Membrane capacitance (μF/cm²)
  public let DEND_R_I : Float = 200.0;        // Internal resistance (Ω·cm)
  public let DEND_TAU_M : Float = 20.0;       // Membrane time constant (ms)
  public let DEND_LAMBDA : Float = 500.0;     // Space constant (μm)
  public let DEND_V_REST : Float = -70.0;     // Resting potential (mV)
  public let DEND_SPIKE_THRESHOLD : Float = -30.0;  // Dendritic spike threshold
  
  // Initialize dendritic tree with 8 branches, 5 compartments each
  public func initDendriticTree() : DendriticTree {
    let branches = Array.init<DendriticBranch>(NUM_DENDRITES, func(b : Nat) : DendriticBranch {
      let compartments = Array.init<DendriticCompartment>(NUM_COMPARTMENTS, func(c : Nat) : DendriticCompartment {
        {
          var voltage = DEND_V_REST;
          var calcium = CA_REST;
          var inputConductance = 0.0;
          var activeSpike = false;
          var bapAmplitude = 0.0;
          var distanceFromSoma = Float.fromInt((c + 1) * 100);  // 100, 200, 300, 400, 500 μm
          var branchOrder = b / 2 + 1;
        }
      });
      {
        id = b;
        var compartments = compartments;
        var totalLength = 500.0;
        var diameter = 2.0 - 0.1 * Float.fromInt(b);  // Thinner distal branches
        var inputResistance = 100.0 + 50.0 * Float.fromInt(b);
        var electrotonicLength = DEND_LAMBDA / (1.0 + 0.1 * Float.fromInt(b));
      }
    });
    
    {
      var branches = branches;
      var somaVoltage = DEND_V_REST;
      var somaCalcium = CA_REST;
      var totalSynapticInput = 0.0;
      var spikeCount = 0;
    }
  };
  
  // Update dendritic computation
  // INTERTWINING: Receives synaptic inputs (Hebbian-weighted)
  public func updateDendriticTree(
    tree : DendriticTree,
    synapticInputs : [[Float]],          // [branch][compartment] input strengths
    somaSpike : Bool,                    // Is soma firing?
    dt : Float
  ) {
    // Process each branch
    for (b in Iter.range(0, NUM_DENDRITES - 1)) {
      let branch = tree.branches[b];
      
      // Process each compartment
      for (c in Iter.range(0, NUM_COMPARTMENTS - 1)) {
        let comp = branch.compartments[c];
        
        // Get synaptic input
        let synInput = if (b < Array.size(synapticInputs) and c < Array.size(synapticInputs[b])) {
          synapticInputs[b][c]
        } else { 0.0 };
        comp.inputConductance := synInput;
        
        // Compute voltage change (simplified cable equation)
        // Current from neighbors
        var neighborCurrent : Float = 0.0;
        if (c > 0) {
          neighborCurrent += (branch.compartments[c-1].voltage - comp.voltage) / 100.0;
        };
        if (c < NUM_COMPARTMENTS - 1) {
          neighborCurrent += (branch.compartments[c+1].voltage - comp.voltage) / 100.0;
        };
        
        // Synaptic current
        let synCurrent = synInput * (0.0 - comp.voltage);  // E_syn = 0 mV
        
        // Leak current
        let leakCurrent = (DEND_V_REST - comp.voltage) / DEND_TAU_M;
        
        // Backpropagating AP (attenuates with distance)
        if (somaSpike) {
          let attenuation = exp(-comp.distanceFromSoma / DEND_LAMBDA);
          comp.bapAmplitude := 100.0 * attenuation;  // 100 mV at soma
        } else {
          comp.bapAmplitude := comp.bapAmplitude * 0.95;  // Decay
        };
        
        // Update voltage
        let dV = neighborCurrent + synCurrent + leakCurrent + comp.bapAmplitude * 0.01;
        comp.voltage := comp.voltage + dt * dV;
        
        // Check for dendritic spike
        if (comp.voltage > DEND_SPIKE_THRESHOLD and not comp.activeSpike) {
          comp.activeSpike := true;
          comp.calcium += 0.001;  // Calcium influx during spike
        } else if (comp.voltage < DEND_SPIKE_THRESHOLD - 10.0) {
          comp.activeSpike := false;
        };
        
        // Calcium decay
        comp.calcium := comp.calcium + dt * (-(comp.calcium - CA_REST) / CA_TAU_DECAY);
      };
      
      // Branch-level integration
      var branchInput : Float = 0.0;
      for (c in Iter.range(0, NUM_COMPARTMENTS - 1)) {
        branchInput += branch.compartments[c].inputConductance;
      };
    };
    
    // Soma integration
    var totalInput : Float = 0.0;
    for (b in Iter.range(0, NUM_DENDRITES - 1)) {
      // Current from proximal compartment of each branch
      let proximal = tree.branches[b].compartments[0];
      totalInput += (proximal.voltage - tree.somaVoltage) / 50.0;
    };
    tree.totalSynapticInput := totalInput;
    tree.somaVoltage := tree.somaVoltage + dt * (totalInput + (DEND_V_REST - tree.somaVoltage) / DEND_TAU_M);
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // LAYER 7: NEUROMODULATION — THE GLOBAL CONTEXT SIGNALS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Neuromodulators provide global context that gates learning:
  // - Dopamine (DA): Reward signal, gates LTP in striatum
  // - Acetylcholine (ACh): Attention signal, promotes encoding
  // - Norepinephrine (NE): Arousal/salience, promotes consolidation
  // - Serotonin (5-HT): Mood/patience, generally inhibits plasticity
  //
  // Effective learning rate: η_eff = η_base × Π_i(1 + α_i × [mod_i])
  //
  
  public type NeuromodulatorState = {
    var dopamine : Float;                // [DA] — reward, motivation
    var acetylcholine : Float;           // [ACh] — attention, encoding
    var norepinephrine : Float;          // [NE] — arousal, salience
    var serotonin : Float;               // [5-HT] — mood, patience
    
    // Receptor states
    var d1Activation : Float;            // D1 receptor (LTP)
    var d2Activation : Float;            // D2 receptor (LTD)
    var m1Activation : Float;            // M1 muscarinic (plasticity)
    var alpha1Activation : Float;        // α1 adrenergic (consolidation)
    var sert5HT1A : Float;               // 5-HT1A (inhibits plasticity)
    
    // Effective modulation
    var plasticityGain : Float;          // Multiplicative factor on η
    var consolidationGain : Float;       // Factor on protein synthesis
    var attentionGain : Float;           // Factor on input salience
  };
  
  // Neuromodulation parameters
  public let NEURO_DA_TAU : Float = 200.0;     // DA clearance time (ms)
  public let NEURO_ACH_TAU : Float = 100.0;    // ACh clearance time
  public let NEURO_NE_TAU : Float = 500.0;     // NE clearance time
  public let NEURO_5HT_TAU : Float = 1000.0;   // 5-HT clearance time
  public let NEURO_DA_GAIN_LTP : Float = 2.0;  // How much DA boosts LTP
  public let NEURO_ACH_GAIN : Float = 1.5;     // How much ACh boosts encoding
  public let NEURO_NE_GAIN : Float = 1.3;      // How much NE boosts consolidation
  public let NEURO_5HT_INHIBIT : Float = 0.5;  // How much 5-HT inhibits
  
  // Initialize neuromodulator state
  public func initNeuromodulatorState() : NeuromodulatorState {
    {
      var dopamine = 0.1;       // Tonic level
      var acetylcholine = 0.2;
      var norepinephrine = 0.1;
      var serotonin = 0.3;
      var d1Activation = 0.0;
      var d2Activation = 0.0;
      var m1Activation = 0.0;
      var alpha1Activation = 0.0;
      var sert5HT1A = 0.0;
      var plasticityGain = 1.0;
      var consolidationGain = 1.0;
      var attentionGain = 1.0;
    }
  };
  
  // Update neuromodulator dynamics
  // INTERTWINING: Receives reward signal (from Q-learning), attention (from Free Energy)
  public func updateNeuromodulators(
    state : NeuromodulatorState,
    rewardSignal : Float,                // ← INTERTWINING: From Q-learning
    attentionSignal : Float,             // ← INTERTWINING: From Free Energy precision
    arousalLevel : Float,                // ← INTERTWINING: From global state
    dt : Float
  ) {
    // Dopamine dynamics (reward-driven)
    let daDrive = 0.1 + rewardSignal * 0.5;
    state.dopamine := state.dopamine + dt * ((daDrive - state.dopamine) / NEURO_DA_TAU);
    
    // Acetylcholine dynamics (attention-driven)
    let achDrive = 0.1 + attentionSignal * 0.4;
    state.acetylcholine := state.acetylcholine + dt * ((achDrive - state.acetylcholine) / NEURO_ACH_TAU);
    
    // Norepinephrine dynamics (arousal-driven)
    let neDrive = 0.1 + arousalLevel * 0.3;
    state.norepinephrine := state.norepinephrine + dt * ((neDrive - state.norepinephrine) / NEURO_NE_TAU);
    
    // Serotonin dynamics (inverse of arousal/stress)
    let serDrive = 0.5 - arousalLevel * 0.2;
    state.serotonin := state.serotonin + dt * ((serDrive - state.serotonin) / NEURO_5HT_TAU);
    
    // Receptor activations
    state.d1Activation := state.dopamine / (state.dopamine + 0.5);  // Michaelis-Menten
    state.d2Activation := state.dopamine / (state.dopamine + 0.2);
    state.m1Activation := state.acetylcholine / (state.acetylcholine + 0.3);
    state.alpha1Activation := state.norepinephrine / (state.norepinephrine + 0.4);
    state.sert5HT1A := state.serotonin / (state.serotonin + 0.5);
    
    // Compute effective gains
    state.plasticityGain := (1.0 + NEURO_DA_GAIN_LTP * state.d1Activation) *
                           (1.0 + NEURO_ACH_GAIN * state.m1Activation) *
                           (1.0 - NEURO_5HT_INHIBIT * state.sert5HT1A);
    
    state.consolidationGain := (1.0 + NEURO_NE_GAIN * state.alpha1Activation) *
                              (1.0 + 0.5 * state.d1Activation);
    
    state.attentionGain := 1.0 + NEURO_ACH_GAIN * state.m1Activation;
  };
  
  // Get effective learning rate
  public func getEffectiveLearningRate(state : NeuromodulatorState, baseLR : Float) : Float {
    baseLR * state.plasticityGain
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // LAYER 8: HOMEOSTATIC SCALING — MAINTAINING STABILITY
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Neurons need to maintain stable firing rates despite Hebbian changes.
  // Homeostatic scaling adjusts ALL synaptic weights globally:
  //
  // w_new = w × (r_target / r_actual)^β
  //
  // Time scale: hours to days (much slower than Hebbian)
  //
  
  public type HomeostaticState = {
    var targetFiringRate : Float;        // r_target (Hz)
    var currentFiringRate : Float;       // r_actual (Hz)
    var firingRateEMA : Float;           // Exponential moving average
    var scalingFactor : Float;           // Current scaling multiplier
    var scalingExponent : Float;         // β in scaling equation
    var intrinsicExcitability : Float;   // Also adjusted homeostatically
    var synapticScalingRate : Float;     // How fast scaling adapts
    var lastScalingUpdate : Int;
  };
  
  // Homeostatic parameters
  public let HOMEO_TARGET_RATE : Float = 5.0;      // Target firing rate (Hz)
  public let HOMEO_TAU : Float = 100000.0;         // Time constant (ms) — very slow!
  public let HOMEO_BETA : Float = 0.5;             // Scaling exponent
  public let HOMEO_MIN_SCALE : Float = 0.5;        // Minimum scaling
  public let HOMEO_MAX_SCALE : Float = 2.0;        // Maximum scaling
  
  // Initialize homeostatic state
  public func initHomeostaticState() : HomeostaticState {
    {
      var targetFiringRate = HOMEO_TARGET_RATE;
      var currentFiringRate = HOMEO_TARGET_RATE;
      var firingRateEMA = HOMEO_TARGET_RATE;
      var scalingFactor = 1.0;
      var scalingExponent = HOMEO_BETA;
      var intrinsicExcitability = 1.0;
      var synapticScalingRate = 0.0001;
      var lastScalingUpdate = 0;
    }
  };
  
  // Update homeostatic scaling
  public func updateHomeostasis(
    state : HomeostaticState,
    recentSpikes : Nat,                  // Spikes in recent window
    windowDuration : Float,              // Duration in ms
    dt : Float
  ) {
    // Compute current firing rate
    state.currentFiringRate := Float.fromInt(recentSpikes) / (windowDuration / 1000.0);
    
    // Update exponential moving average
    let alpha = dt / HOMEO_TAU;
    state.firingRateEMA := (1.0 - alpha) * state.firingRateEMA + alpha * state.currentFiringRate;
    
    // Compute scaling factor
    if (state.firingRateEMA > 0.0) {
      let ratio = state.targetFiringRate / state.firingRateEMA;
      let newScale = Float.pow(ratio, state.scalingExponent);
      
      // Smooth adaptation
      state.scalingFactor := (1.0 - state.synapticScalingRate * dt) * state.scalingFactor +
                            state.synapticScalingRate * dt * newScale;
      
      // Enforce bounds
      state.scalingFactor := clamp(state.scalingFactor, HOMEO_MIN_SCALE, HOMEO_MAX_SCALE);
    };
    
    // Also adjust intrinsic excitability (ion channels)
    let excitabilityError = state.targetFiringRate - state.firingRateEMA;
    state.intrinsicExcitability := state.intrinsicExcitability + 
                                   0.0001 * excitabilityError * dt;
    state.intrinsicExcitability := clamp(state.intrinsicExcitability, 0.5, 2.0);
  };
  
  // Apply scaling to all weights
  public func applyHomeostaticScaling(weights : [[var Float]], scalingFactor : Float) {
    for (i in Iter.range(0, Array.size(weights) - 1)) {
      for (j in Iter.range(0, Array.size(weights[i]) - 1)) {
        weights[i][j] := clamp(weights[i][j] * scalingFactor, 0.0, 1.0);
      };
    };
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // LAYER 9: STRUCTURAL PLASTICITY — SYNAPSE FORMATION AND ELIMINATION
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // The ultimate form of plasticity: synapses can form (synaptogenesis) or die (pruning).
  //
  // d[Synapses]/dt = Formation - Elimination
  // Formation ∝ Activity × AvailableSpace × GrowthFactors
  // Elimination ∝ (1 - Activity) × Age × CompetitionLoss
  //
  
  public type SynapseStructure = {
    var exists : Bool;                   // Does synapse exist?
    var age : Float;                     // Time since formation (ms)
    var stability : Float;               // How stable (0-1)
    var activityHistory : Float;         // Integrated activity
    var competitionScore : Float;        // Relative to neighbors
    var growthConeActive : Bool;         // Actively seeking connections
    var neurotrophins : Float;           // Growth factor level
  };
  
  public type StructuralPlasticityState = {
    var synapses : [[var SynapseStructure]];
    var totalSynapses : Nat;
    var formationRate : Float;
    var eliminationRate : Float;
    var maxSynapses : Nat;
    var recentFormations : Nat;
    var recentEliminations : Nat;
  };
  
  // Structural plasticity parameters
  public let STRUCT_FORM_RATE : Float = 0.00001;   // Base formation rate
  public let STRUCT_ELIM_RATE : Float = 0.000001;  // Base elimination rate
  public let STRUCT_STABILITY_TAU : Float = 86400000.0;  // 1 day to stabilize
  public let STRUCT_MIN_AGE_ELIM : Float = 3600000.0;    // 1 hour before can be eliminated
  public let STRUCT_ACTIVITY_THRESHOLD : Float = 0.2;    // Activity below this → unstable
  public let STRUCT_MAX_SYNAPSES : Nat = 200;
  
  // Initialize structural plasticity
  public func initStructuralPlasticity() : StructuralPlasticityState {
    let synapses = Array.init<[var SynapseStructure]>(NUM_NODES, func(_ : Nat) : [var SynapseStructure] {
      Array.init<SynapseStructure>(NUM_NODES, func(_ : Nat) : SynapseStructure {
        {
          var exists = true;  // All synapses exist initially
          var age = 1000000.0;  // Mature
          var stability = 0.8;
          var activityHistory = 0.3;
          var competitionScore = 1.0;
          var growthConeActive = false;
          var neurotrophins = 0.5;
        }
      })
    });
    
    {
      var synapses = synapses;
      var totalSynapses = NUM_SYNAPSES;
      var formationRate = STRUCT_FORM_RATE;
      var eliminationRate = STRUCT_ELIM_RATE;
      var maxSynapses = STRUCT_MAX_SYNAPSES;
      var recentFormations = 0;
      var recentEliminations = 0;
    }
  };
  
  // Update structural plasticity
  // INTERTWINING: Activity comes from Hebbian weights, growth factors from protein synthesis
  public func updateStructuralPlasticity(
    state : StructuralPlasticityState,
    activityMatrix : [[Float]],          // ← INTERTWINING: From Hebbian activity
    growthFactors : Float,               // ← INTERTWINING: BDNF from protein synthesis
    dt : Float
  ) {
    state.recentFormations := 0;
    state.recentEliminations := 0;
    
    for (i in Iter.range(0, NUM_NODES - 1)) {
      for (j in Iter.range(0, NUM_NODES - 1)) {
        if (i != j) {
          let syn = state.synapses[i][j];
          let activity = if (i < Array.size(activityMatrix) and j < Array.size(activityMatrix[i])) {
            activityMatrix[i][j]
          } else { 0.0 };
          
          if (syn.exists) {
            // Update existing synapse
            syn.age += dt;
            syn.activityHistory := 0.999 * syn.activityHistory + 0.001 * activity;
            syn.neurotrophins := 0.99 * syn.neurotrophins + 0.01 * growthFactors;
            
            // Stability increases with age and activity
            let stabilityGain = (syn.activityHistory / 0.5) * (syn.neurotrophins / 0.5);
            syn.stability := syn.stability + dt * stabilityGain / STRUCT_STABILITY_TAU;
            syn.stability := clamp(syn.stability, 0.0, 1.0);
            
            // Elimination check
            if (syn.age > STRUCT_MIN_AGE_ELIM) {
              let elimProb = STRUCT_ELIM_RATE * (1.0 - syn.stability) * 
                            (1.0 - syn.activityHistory) * dt;
              // Deterministic: eliminate if prob exceeds threshold
              if (elimProb > 0.5 and syn.activityHistory < STRUCT_ACTIVITY_THRESHOLD) {
                syn.exists := false;
                state.totalSynapses -= 1;
                state.recentEliminations += 1;
              };
            };
          } else {
            // Formation check
            if (state.totalSynapses < state.maxSynapses) {
              let availableSpace = Float.fromInt(state.maxSynapses - state.totalSynapses) / 
                                  Float.fromInt(state.maxSynapses);
              let formProb = STRUCT_FORM_RATE * activity * availableSpace * growthFactors * dt;
              
              if (formProb > 0.5) {
                syn.exists := true;
                syn.age := 0.0;
                syn.stability := 0.1;
                syn.activityHistory := activity;
                state.totalSynapses += 1;
                state.recentFormations += 1;
              };
            };
          };
        };
      };
    };
  };
  
  // Get effective weight (0 if synapse doesn't exist)
  public func getEffectiveWeight(structure : StructuralPlasticityState, weight : Float, i : Nat, j : Nat) : Float {
    if (i < NUM_NODES and j < NUM_NODES and structure.synapses[i][j].exists) {
      weight
    } else {
      0.0
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // LAYER 10: METAPLASTICITY — PLASTICITY OF PLASTICITY
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // The BCM rule with sliding threshold:
  // Δw = η × pre × post × (post - θ)
  // dθ/dt = (post² - θ) / τ_θ
  //
  // High activity → raises threshold → makes LTP harder
  // Low activity → lowers threshold → makes LTP easier
  //
  
  public type MetaplasticityState = {
    var bcmThresholds : [var Float];     // θ for each postsynaptic neuron
    var activityIntegrals : [var Float]; // Integrated post activity
    var metaplasticModifiers : [var Float];  // Effective plasticity multipliers
    var thresholdTau : Float;            // Time constant for threshold sliding
    var historyWeights : [var Float];    // How much history affects threshold
  };
  
  // Metaplasticity parameters
  public let META_THETA_INITIAL : Float = 0.5;     // Initial BCM threshold
  public let META_THETA_TAU : Float = 10000.0;     // Threshold adaptation time (ms)
  public let META_THETA_MIN : Float = 0.1;         // Minimum threshold
  public let META_THETA_MAX : Float = 0.9;         // Maximum threshold
  
  // Initialize metaplasticity state
  public func initMetaplasticity() : MetaplasticityState {
    {
      var bcmThresholds = Array.init<Float>(NUM_NODES, func(_ : Nat) : Float { META_THETA_INITIAL });
      var activityIntegrals = Array.init<Float>(NUM_NODES, func(_ : Nat) : Float { 0.0 });
      var metaplasticModifiers = Array.init<Float>(NUM_NODES, func(_ : Nat) : Float { 1.0 });
      var thresholdTau = META_THETA_TAU;
      var historyWeights = Array.init<Float>(NUM_NODES, func(_ : Nat) : Float { 1.0 });
    }
  };
  
  // Update metaplasticity
  public func updateMetaplasticity(
    state : MetaplasticityState,
    postActivations : [Float],
    dt : Float
  ) {
    for (j in Iter.range(0, NUM_NODES - 1)) {
      let post = if (j < Array.size(postActivations)) { postActivations[j] } else { 0.0 };
      
      // Update activity integral
      state.activityIntegrals[j] := 0.999 * state.activityIntegrals[j] + 0.001 * post * post;
      
      // BCM threshold follows activity²
      // dθ/dt = (<post²> - θ) / τ
      let dTheta = (state.activityIntegrals[j] - state.bcmThresholds[j]) / state.thresholdTau;
      state.bcmThresholds[j] := state.bcmThresholds[j] + dt * dTheta;
      state.bcmThresholds[j] := clamp(state.bcmThresholds[j], META_THETA_MIN, META_THETA_MAX);
      
      // Compute effective plasticity modifier
      // High threshold → harder to get LTP → modifier < 1
      state.metaplasticModifiers[j] := 1.0 / (1.0 + state.bcmThresholds[j]);
    };
  };
  
  // Get BCM-modulated weight change
  public func bcmWeightChange(
    pre : Float,
    post : Float,
    theta : Float,
    eta : Float
  ) : Float {
    // Δw = η × pre × post × (post - θ)
    eta * pre * post * (post - theta)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // UNIFIED DEEP SYNAPSE — COMBINING ALL LAYERS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // A single synapse with ALL the biophysics integrated
  //
  
  public type DeepSynapse = {
    // Core state
    var weight : Float;
    preIndex : Nat;
    postIndex : Nat;
    
    // Layer states
    calcium : CalciumState;
    nmda : NMDAReceptorState;
    ampa : AMPATraffickingState;
    camkii : CaMKIIState;
    protein : ProteinSynthesisState;
    
    // Timing
    var lastPreSpike : Int;
    var lastPostSpike : Int;
    var lastUpdate : Int;
  };
  
  // Create a deep synapse
  public func createDeepSynapse(preIdx : Nat, postIdx : Nat, initialWeight : Float) : DeepSynapse {
    {
      var weight = initialWeight;
      preIndex = preIdx;
      postIndex = postIdx;
      calcium = initCalciumState();
      nmda = initNMDAState();
      ampa = initAMPAState();
      camkii = initCaMKIIState();
      protein = initProteinSynthesisState();
      var lastPreSpike = 0;
      var lastPostSpike = 0;
      var lastUpdate = 0;
    }
  };
  
  // Full synapse update — integrating all layers
  // INTERTWINING: Receives signals from all other systems
  public func updateDeepSynapse(
    syn : DeepSynapse,
    preActivity : Float,                 // Presynaptic activity
    postVoltage : Float,                 // Postsynaptic voltage
    postActivity : Float,                // Postsynaptic activity
    neuromodGain : Float,                // ← INTERTWINING: From neuromodulation
    homeostaticScale : Float,            // ← INTERTWINING: From homeostasis
    metaplasticMod : Float,              // ← INTERTWINING: From metaplasticity
    dt : Float
  ) {
    // 1. Update NMDA kinetics
    updateNMDA(syn.nmda, preActivity, postVoltage, dt);
    
    // 2. Update calcium dynamics
    updateCalcium(syn.calcium, preActivity, postVoltage, syn.nmda.conductance, dt);
    
    // 3. Update CaMKII
    updateCaMKII(syn.camkii, syn.calcium.concentration, dt);
    
    // 4. Determine plasticity direction from calcium
    let plasticityDir = getPlasticityDirection(syn.calcium.concentration);
    
    // 5. Update AMPA trafficking (determines weight)
    updateAMPATrafficking(syn.ampa, syn.camkii.totalActivity, plasticityDir, dt);
    
    // 6. Update protein synthesis
    updateProteinSynthesis(syn.protein, syn.camkii.totalActivity, syn.calcium.integralCalcium, dt);
    
    // 7. Compute final weight
    let rawWeight = getSynapticWeight(syn.ampa);
    
    // Apply all modulations
    syn.weight := rawWeight * neuromodGain * homeostaticScale * metaplasticMod;
    syn.weight := clamp(syn.weight, 0.0, 1.0);
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // COMPLETE DEEP HEBBIAN STATE — THE FULL NETWORK
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  public type DeepHebbianState = {
    // Synapse matrix
    var synapses : [[var DeepSynapse]];
    
    // Global states
    neuromodulation : NeuromodulatorState;
    homeostasis : HomeostaticState;
    metaplasticity : MetaplasticityState;
    structuralPlasticity : StructuralPlasticityState;
    dendrites : [var DendriticTree];
    
    // Metrics
    var totalLTP : Nat;
    var totalLTD : Nat;
    var meanWeight : Float;
    var weightVariance : Float;
    var currentBeat : Nat;
  };
  
  // Initialize complete deep Hebbian network
  public func initDeepHebbianState() : DeepHebbianState {
    let synapses = Array.init<[var DeepSynapse]>(NUM_NODES, func(i : Nat) : [var DeepSynapse] {
      Array.init<DeepSynapse>(NUM_NODES, func(j : Nat) : DeepSynapse {
        let initialWeight = if (i == j) { 0.0 } else { 0.3 + 0.1 * sin(Float.fromInt(i * 7 + j * 13)) };
        createDeepSynapse(i, j, initialWeight)
      })
    });
    
    let dendrites = Array.init<DendriticTree>(NUM_NODES, func(_ : Nat) : DendriticTree {
      initDendriticTree()
    });
    
    {
      var synapses = synapses;
      neuromodulation = initNeuromodulatorState();
      homeostasis = initHomeostaticState();
      metaplasticity = initMetaplasticity();
      structuralPlasticity = initStructuralPlasticity();
      dendrites = dendrites;
      var totalLTP = 0;
      var totalLTD = 0;
      var meanWeight = 0.3;
      var weightVariance = 0.01;
      var currentBeat = 0;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // THE COMPLETE INTERTWINED UPDATE
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // This is where ALL THE INTERTWINING HAPPENS
  //
  
  public type DeepHebbianHeartbeatResult = {
    meanWeight : Float;
    totalLTP : Nat;
    totalLTD : Nat;
    plasticityGain : Float;
    homeostaticScale : Float;
    structuralChanges : Nat;
  };
  
  // The full intertwined heartbeat
  public func runDeepHebbianHeartbeat(
    state : DeepHebbianState,
    preActivations : [Float],            // Presynaptic activities
    postActivations : [Float],           // Postsynaptic activities
    postVoltages : [Float],              // Membrane potentials
    
    // INTERTWINED INPUTS FROM OTHER SYSTEMS
    kuramotoCoherence : Float,           // ← INTERTWINING: From Kuramoto
    freeEnergyPrecision : Float,         // ← INTERTWINING: From Free Energy
    qLearningReward : Float,             // ← INTERTWINING: From Q-learning
    memoryReplayPattern : ?[Float],      // ← INTERTWINING: From Memory
    kalmanPrediction : [Float],          // ← INTERTWINING: From Kalman
    
    dt : Float
  ) : DeepHebbianHeartbeatResult {
    state.currentBeat += 1;
    
    // 1. Update neuromodulators (driven by reward and attention)
    updateNeuromodulators(
      state.neuromodulation,
      qLearningReward,                   // ← Q-learning
      freeEnergyPrecision,               // ← Free Energy (attention ~ precision)
      kuramotoCoherence,                 // ← Kuramoto (arousal ~ coherence)
      dt
    );
    let neuromodGain = state.neuromodulation.plasticityGain;
    
    // 2. Update homeostasis (based on recent activity)
    let recentSpikes = Array.foldLeft<Float, Nat>(postActivations, 0, func(acc, a) {
      if (a > 0.5) { acc + 1 } else { acc }
    });
    updateHomeostasis(state.homeostasis, recentSpikes, dt, dt);
    let homeostaticScale = state.homeostasis.scalingFactor;
    
    // 3. Update metaplasticity
    updateMetaplasticity(state.metaplasticity, postActivations, dt);
    
    // 4. Update all synapses
    var weightSum : Float = 0.0;
    var weightSqSum : Float = 0.0;
    var ltpCount : Nat = 0;
    var ltdCount : Nat = 0;
    
    for (i in Iter.range(0, NUM_NODES - 1)) {
      for (j in Iter.range(0, NUM_NODES - 1)) {
        if (i != j) {
          let syn = state.synapses[i][j];
          let preAct = if (i < Array.size(preActivations)) { preActivations[i] } else { 0.0 };
          let postAct = if (j < Array.size(postActivations)) { postActivations[j] } else { 0.0 };
          let postV = if (j < Array.size(postVoltages)) { postVoltages[j] } else { -70.0 };
          let metaMod = state.metaplasticity.metaplasticModifiers[j];
          
          // Memory replay boosts relevant synapses
          let replayBoost = switch (memoryReplayPattern) {
            case (?pattern) {
              if (i < Array.size(pattern) and j < Array.size(pattern)) {
                1.0 + 0.5 * pattern[i] * pattern[j]
              } else { 1.0 }
            };
            case (null) { 1.0 };
          };
          
          // Kalman prediction affects expected activity
          let kalmanMod = if (j < Array.size(kalmanPrediction)) {
            1.0 + 0.1 * (kalmanPrediction[j] - postAct)
          } else { 1.0 };
          
          let oldWeight = syn.weight;
          
          updateDeepSynapse(
            syn,
            preAct,
            postV,
            postAct,
            neuromodGain * replayBoost * kalmanMod,
            homeostaticScale,
            metaMod,
            dt
          );
          
          // Track LTP/LTD
          if (syn.weight > oldWeight) { ltpCount += 1 }
          else if (syn.weight < oldWeight) { ltdCount += 1 };
          
          weightSum += syn.weight;
          weightSqSum += syn.weight * syn.weight;
        };
      };
    };
    
    // 5. Update structural plasticity
    let activityMatrix = Array.tabulate<[Float]>(NUM_NODES, func(i : Nat) : [Float] {
      Array.tabulate<Float>(NUM_NODES, func(j : Nat) : Float {
        state.synapses[i][j].weight
      })
    });
    let growthFactors = state.synapses[0][1].protein.proteinBDNF;
    updateStructuralPlasticity(state.structuralPlasticity, activityMatrix, growthFactors, dt);
    
    // 6. Update dendrites
    for (n in Iter.range(0, NUM_NODES - 1)) {
      let synInputs = Array.tabulate<[Float]>(NUM_DENDRITES, func(b : Nat) : [Float] {
        Array.tabulate<Float>(NUM_COMPARTMENTS, func(c : Nat) : Float {
          // Distribute inputs across dendrite
          let inputIdx = (b * NUM_COMPARTMENTS + c) % NUM_NODES;
          state.synapses[inputIdx][n].weight * preActivations[inputIdx]
        })
      });
      let somaSpike = postActivations[n] > 0.8;
      updateDendriticTree(state.dendrites[n], synInputs, somaSpike, dt);
    };
    
    // Compute statistics
    let n = Float.fromInt(NUM_SYNAPSES - NUM_NODES);  // Exclude self-connections
    state.meanWeight := weightSum / n;
    state.weightVariance := (weightSqSum / n) - (state.meanWeight * state.meanWeight);
    state.totalLTP += ltpCount;
    state.totalLTD += ltdCount;
    
    {
      meanWeight = state.meanWeight;
      totalLTP = ltpCount;
      totalLTD = ltdCount;
      plasticityGain = neuromodGain;
      homeostaticScale = homeostaticScale;
      structuralChanges = state.structuralPlasticity.recentFormations + 
                         state.structuralPlasticity.recentEliminations;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // UTILITY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  func sigmoid(x : Float) : Float {
    1.0 / (1.0 + exp(-x))
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
  
  func sin(x : Float) : Float {
    var result : Float = 0.0;
    var term : Float = x;
    var xSquared : Float = x * x;
    for (n in Iter.range(0, 10)) {
      result += term;
      term := -term * xSquared / Float.fromInt((2 * n + 2) * (2 * n + 3));
    };
    result
  };
  
  func clamp(x : Float, minVal : Float, maxVal : Float) : Float {
    if (x < minVal) { minVal }
    else if (x > maxVal) { maxVal }
    else { x }
  };

};

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // ██████████████████████████████████████████████████████████████████████████████████████████████████████████████
  // ██                                                                                                          ██
  // ██  DEEP HEBBIAN ENGINE EXPANSION — LAYERS 11-30 — COMPLETE NEURAL BIOPHYSICS                              ██
  // ██                                                                                                          ██
  // ██████████████████████████████████████████████████████████████████████████████████████████████████████████████
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // This expansion adds the remaining 20 DEEP LAYERS to achieve mathematical completeness:
  //
  // LAYER 11: SYNAPTIC VESICLE DYNAMICS — Presynaptic release machinery
  // LAYER 12: GLIOTRANSMISSION — Astrocyte-neuron signaling
  // LAYER 13: RETROGRADE SIGNALING — Endocannabinoids, NO, BDNF
  // LAYER 14: SPIKE TIMING-DEPENDENT PLASTICITY — Full STDP window
  // LAYER 15: THREE-FACTOR LEARNING — Eligibility traces + reward
  // LAYER 16: SYNAPTIC CONSOLIDATION — Memory system interactions
  // LAYER 17: NETWORK OSCILLATIONS — Theta-gamma coupling
  // LAYER 18: ATTENTIONAL MODULATION — Top-down control
  // LAYER 19: ENERGY METABOLISM — ATP-dependent processes
  // LAYER 20: CIRCADIAN MODULATION — 24-hour plasticity rhythms
  // LAYER 21: STRESS HORMONES — Glucocorticoid effects
  // LAYER 22: SLEEP-DEPENDENT PLASTICITY — Replay and consolidation
  // LAYER 23: CRITICAL PERIODS — Developmental plasticity windows
  // LAYER 24: MULTISYNAPTIC RULES — Heterosynaptic interactions
  // LAYER 25: INTRINSIC PLASTICITY — Non-synaptic changes
  // LAYER 26: AXONAL PLASTICITY — Presynaptic structural changes
  // LAYER 27: EPIGENETIC REGULATION — Chromatin and methylation
  // LAYER 28: LOCAL FIELD POTENTIALS — Mesoscale dynamics
  // LAYER 29: CRITICALITY — Edge-of-chaos dynamics
  // LAYER 30: SACRED GEOMETRY — φ-ratio in neural organization
  //
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // LAYER 11: SYNAPTIC VESICLE DYNAMICS — THE PRESYNAPTIC RELEASE MACHINERY
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Neurotransmitter release is a complex probabilistic process governed by:
  //
  // 1. VESICLE POOLS:
  //    - Readily Releasable Pool (RRP): Docked vesicles (~5-10 per synapse)
  //    - Recycling Pool: Recently released, being refilled (~20-50)
  //    - Reserve Pool: Backup storage (~200-300)
  //
  // 2. RELEASE PROBABILITY:
  //    P_release = P_0 × f([Ca²⁺]_pre) × f(facilitation) × f(depression)
  //
  // 3. CALCIUM SENSORS:
  //    - Synaptotagmin-1: Fast release sensor
  //    - Synaptotagmin-7: Slow/asynchronous release
  //    - Doc2: Spontaneous release
  //
  // 4. SHORT-TERM PLASTICITY:
  //    - Facilitation: Enhanced P_release after recent activity
  //    - Depression: Reduced P_release due to vesicle depletion
  //    - Augmentation: Longer-lasting enhancement
  //    - Post-tetanic potentiation (PTP): Minutes-scale enhancement
  //

  public type VesiclePool = {
    var rrp : Float;                    // Readily releasable pool (0-1, normalized)
    var recycling : Float;              // Recycling pool
    var reserve : Float;                // Reserve pool
    var rrpCapacity : Nat;              // Max RRP vesicles
    var recyclingCapacity : Nat;        // Max recycling vesicles
    var reserveCapacity : Nat;          // Max reserve vesicles
    var dockingRate : Float;            // RRP refilling rate
    var recyclingRate : Float;          // Recycling → RRP rate
    var mobilizationRate : Float;       // Reserve → Recycling rate
  };

  public type CalciumSensor = {
    var syt1Activity : Float;           // Synaptotagmin-1 (fast)
    var syt7Activity : Float;           // Synaptotagmin-7 (slow)
    var doc2Activity : Float;           // Doc2 (spontaneous)
    var totalSensorActivity : Float;    // Combined sensor activation
    var cooperativity : Float;          // Hill coefficient
    var calcium : Float;                // Local calcium concentration
  };

  public type ShortTermPlasticity = {
    var facilitation : Float;           // Facilitation factor (F)
    var depression : Float;             // Depression factor (D)
    var augmentation : Float;           // Augmentation factor (A)
    var ptp : Float;                    // Post-tetanic potentiation
    var effectiveP : Float;             // Effective release probability
    var baseP : Float;                  // Baseline release probability
    var lastReleaseTime : Float;        // Time since last release
    var releaseHistory : [var Float];   // Recent release times
  };

  public type PresynapticTerminal = {
    vesicles : VesiclePool;
    sensor : CalciumSensor;
    stp : ShortTermPlasticity;
    var actionPotentialArrived : Bool;
    var calciumInflux : Float;          // Calcium entering terminal
    var vgccConductance : Float;        // Voltage-gated Ca channel
    var residualCalcium : Float;        // Leftover from previous spikes
    var releaseAmount : Float;          // Quanta released
    var quanta : Float;                 // Vesicles released per spike
  };

  // Vesicle dynamics parameters
  public let VES_RRP_CAPACITY : Nat = 10;
  public let VES_RECYCLING_CAPACITY : Nat = 50;
  public let VES_RESERVE_CAPACITY : Nat = 300;
  public let VES_DOCKING_TAU : Float = 500.0;     // ms to refill RRP
  public let VES_RECYCLING_TAU : Float = 10000.0; // ms to recycle
  public let VES_MOBILIZATION_TAU : Float = 60000.0; // ms to mobilize reserve
  public let VES_BASE_P : Float = 0.3;            // Baseline release probability
  
  // Calcium sensor parameters
  public let SYT1_KD : Float = 10.0;              // Syt1 Ca²⁺ affinity (μM)
  public let SYT1_HILL : Float = 5.0;             // Syt1 cooperativity
  public let SYT7_KD : Float = 1.0;               // Syt7 Ca²⁺ affinity (μM)
  public let SYT7_HILL : Float = 2.0;             // Syt7 cooperativity
  public let DOC2_KD : Float = 0.3;               // Doc2 Ca²⁺ affinity (μM)

  // Short-term plasticity parameters
  public let STP_F_INCREMENT : Float = 0.2;       // Facilitation per spike
  public let STP_F_TAU : Float = 50.0;            // Facilitation decay (ms)
  public let STP_D_RECOVERY_TAU : Float = 200.0;  // Depression recovery (ms)
  public let STP_A_INCREMENT : Float = 0.02;      // Augmentation per spike
  public let STP_A_TAU : Float = 5000.0;          // Augmentation decay (ms)
  public let STP_PTP_TAU : Float = 30000.0;       // PTP decay (ms)

  public func initVesiclePool() : VesiclePool {
    {
      var rrp = 1.0;              // Start with full RRP
      var recycling = 0.5;        // Half-filled recycling
      var reserve = 0.8;          // Mostly full reserve
      var rrpCapacity = VES_RRP_CAPACITY;
      var recyclingCapacity = VES_RECYCLING_CAPACITY;
      var reserveCapacity = VES_RESERVE_CAPACITY;
      var dockingRate = 1.0 / VES_DOCKING_TAU;
      var recyclingRate = 1.0 / VES_RECYCLING_TAU;
      var mobilizationRate = 1.0 / VES_MOBILIZATION_TAU;
    }
  };

  public func initCalciumSensor() : CalciumSensor {
    {
      var syt1Activity = 0.0;
      var syt7Activity = 0.0;
      var doc2Activity = 0.0;
      var totalSensorActivity = 0.0;
      var cooperativity = SYT1_HILL;
      var calcium = 0.0001;       // Resting ~100 nM
    }
  };

  public func initShortTermPlasticity() : ShortTermPlasticity {
    {
      var facilitation = 1.0;     // Start at baseline
      var depression = 1.0;       // Full vesicles available
      var augmentation = 1.0;     // No augmentation
      var ptp = 1.0;              // No PTP
      var effectiveP = VES_BASE_P;
      var baseP = VES_BASE_P;
      var lastReleaseTime = 0.0;
      var releaseHistory = Array.init<Float>(10, func(_ : Nat) : Float { 0.0 });
    }
  };

  public func initPresynapticTerminal() : PresynapticTerminal {
    {
      vesicles = initVesiclePool();
      sensor = initCalciumSensor();
      stp = initShortTermPlasticity();
      var actionPotentialArrived = false;
      var calciumInflux = 0.0;
      var vgccConductance = 0.1;
      var residualCalcium = 0.0;
      var releaseAmount = 0.0;
      var quanta = 0.0;
    }
  };

  // Update vesicle pool dynamics
  public func updateVesicles(pool : VesiclePool, releaseOccurred : Bool, releaseQuanta : Float, dt : Float) {
    // If release occurred, deplete RRP
    if (releaseOccurred) {
      pool.rrp -= releaseQuanta / Float.fromInt(pool.rrpCapacity);
      pool.rrp := Float.max(0.0, pool.rrp);
    };
    
    // RRP refilling from recycling pool
    let rrpVacancy = 1.0 - pool.rrp;
    let rrpRefill = pool.dockingRate * pool.recycling * rrpVacancy * dt;
    pool.rrp += rrpRefill;
    pool.recycling -= rrpRefill;
    
    // Recycling pool refilling from reserve
    let recyclingVacancy = 1.0 - pool.recycling;
    let recyclingRefill = pool.recyclingRate * pool.reserve * recyclingVacancy * dt;
    pool.recycling += recyclingRefill;
    pool.reserve -= recyclingRefill;
    
    // Reserve pool replenishment (slow synthesis)
    let reserveVacancy = 1.0 - pool.reserve;
    pool.reserve += 0.0001 * reserveVacancy * dt;
    
    // Activity-dependent mobilization — high demand speeds up reserve mobilization
    if (pool.rrp < 0.3) {
      pool.mobilizationRate := 2.0 / VES_MOBILIZATION_TAU;  // Double rate
    } else {
      pool.mobilizationRate := 1.0 / VES_MOBILIZATION_TAU;  // Normal rate
    };
    
    // Clamp values
    pool.rrp := clamp(pool.rrp, 0.0, 1.0);
    pool.recycling := clamp(pool.recycling, 0.0, 1.0);
    pool.reserve := clamp(pool.reserve, 0.0, 1.0);
  };

  // Update calcium sensors
  public func updateCalciumSensors(sensor : CalciumSensor, preCalcium : Float, dt : Float) {
    sensor.calcium := preCalcium;
    
    // Synaptotagmin-1: Fast, low-affinity, high cooperativity
    // Hill equation: activity = [Ca]^n / (Kd^n + [Ca]^n)
    let ca = sensor.calcium * 1000000.0;  // Convert to μM for Hill equation
    let syt1Hill = Float.pow(ca, SYT1_HILL) / (Float.pow(SYT1_KD, SYT1_HILL) + Float.pow(ca, SYT1_HILL));
    sensor.syt1Activity := 0.9 * sensor.syt1Activity + 0.1 * syt1Hill;  // Some temporal smoothing
    
    // Synaptotagmin-7: Slow, high-affinity, lower cooperativity
    let syt7Hill = Float.pow(ca, SYT7_HILL) / (Float.pow(SYT7_KD, SYT7_HILL) + Float.pow(ca, SYT7_HILL));
    sensor.syt7Activity := 0.95 * sensor.syt7Activity + 0.05 * syt7Hill;  // Slower dynamics
    
    // Doc2: Spontaneous release, very high affinity
    let doc2Hill = ca / (DOC2_KD + ca);
    sensor.doc2Activity := 0.9 * sensor.doc2Activity + 0.1 * doc2Hill;
    
    // Total sensor activity (weighted combination)
    sensor.totalSensorActivity := 0.7 * sensor.syt1Activity + 
                                   0.2 * sensor.syt7Activity + 
                                   0.1 * sensor.doc2Activity;
  };

  // Update short-term plasticity
  public func updateShortTermPlasticity(stp : ShortTermPlasticity, spikeOccurred : Bool, currentTime : Float, dt : Float) {
    // Decay of plasticity factors
    stp.facilitation := 1.0 + (stp.facilitation - 1.0) * exp(-dt / STP_F_TAU);
    stp.depression := 1.0 + (stp.depression - 1.0) * exp(-dt / STP_D_RECOVERY_TAU);
    stp.augmentation := 1.0 + (stp.augmentation - 1.0) * exp(-dt / STP_A_TAU);
    stp.ptp := 1.0 + (stp.ptp - 1.0) * exp(-dt / STP_PTP_TAU);
    
    if (spikeOccurred) {
      // Facilitation increases with each spike
      stp.facilitation += STP_F_INCREMENT;
      
      // Augmentation builds up more slowly
      stp.augmentation += STP_A_INCREMENT;
      
      // Check for tetanic stimulation (multiple spikes in short window)
      let timeSinceLast = currentTime - stp.lastReleaseTime;
      if (timeSinceLast < 20.0) {  // Within 20ms
        stp.ptp += 0.05;  // PTP builds up
      };
      
      stp.lastReleaseTime := currentTime;
    };
    
    // Compute effective release probability
    // P_eff = P_base × F × D × A × PTP
    stp.effectiveP := stp.baseP * stp.facilitation * stp.depression * stp.augmentation * stp.ptp;
    stp.effectiveP := clamp(stp.effectiveP, 0.0, 0.99);  // Cap at 99%
  };

  // Full presynaptic release computation
  public func computeRelease(terminal : PresynapticTerminal, presynapticVoltage : Float, currentTime : Float, dt : Float) : Float {
    // Detect action potential
    terminal.actionPotentialArrived := presynapticVoltage > -30.0;
    
    if (terminal.actionPotentialArrived) {
      // Calcium influx through VGCCs
      let vgccGating = sigmoid((presynapticVoltage + 20.0) / 5.0);
      terminal.calciumInflux := terminal.vgccConductance * vgccGating * (presynapticVoltage + 80.0) / 100.0;
      
      // Add to residual calcium
      terminal.residualCalcium += terminal.calciumInflux;
      
      // Update calcium sensors
      updateCalciumSensors(terminal.sensor, terminal.residualCalcium, dt);
      
      // Update short-term plasticity
      updateShortTermPlasticity(terminal.stp, true, currentTime, dt);
      
      // Compute release probability
      let releaseProbability = terminal.stp.effectiveP * terminal.sensor.totalSensorActivity;
      
      // Determine number of quanta released (Poisson-like)
      let expectedQuanta = releaseProbability * terminal.vesicles.rrp * Float.fromInt(terminal.vesicles.rrpCapacity);
      terminal.quanta := expectedQuanta;  // In real simulation, sample from Poisson
      
      // Update vesicle pools
      updateVesicles(terminal.vesicles, true, terminal.quanta, dt);
      
      // Depression from release
      terminal.stp.depression *= (1.0 - terminal.quanta / Float.fromInt(terminal.vesicles.rrpCapacity));
      terminal.stp.depression := Float.max(0.1, terminal.stp.depression);
      
      terminal.releaseAmount := terminal.quanta;
    } else {
      // No spike — just decay residual calcium
      terminal.residualCalcium *= 0.99;  // ~100ms decay
      updateCalciumSensors(terminal.sensor, terminal.residualCalcium, dt);
      updateShortTermPlasticity(terminal.stp, false, currentTime, dt);
      updateVesicles(terminal.vesicles, false, 0.0, dt);
      terminal.releaseAmount := 0.0;
    };
    
    terminal.releaseAmount
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // LAYER 12: GLIOTRANSMISSION — ASTROCYTE-NEURON SIGNALING
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Astrocytes are not passive support cells — they actively modulate synaptic transmission:
  //
  // 1. TRIPARTITE SYNAPSE: Pre + Post + Astrocyte
  // 2. GLIOTRANSMITTERS: Glutamate, D-serine, ATP, GABA
  // 3. CALCIUM WAVES: Propagate through astrocyte network
  // 4. GLUTAMATE UPTAKE: Regulate synaptic glutamate levels
  // 5. K⁺ BUFFERING: Maintain extracellular potassium
  // 6. METABOLIC SUPPORT: Provide lactate to neurons
  //

  public type AstrocyteState = {
    var calcium : Float;                 // Astrocyte [Ca²⁺]
    var ip3 : Float;                     // IP3 second messenger
    var atp : Float;                     // ATP stores
    var glutamateStores : Float;         // Vesicular glutamate
    var dSerineStores : Float;           // D-serine for NMDA
    var gabaStores : Float;              // GABA stores
    var glutamateUptake : Float;         // EAAT transporter activity
    var potassiumUptake : Float;         // Kir channel activity
    var lactateRelease : Float;          // Metabolic support
    var gapJunctionCoupling : Float;     // Connection to other astrocytes
    var calciumWaveActive : Bool;        // Participating in wave
    var lastWaveTime : Float;            // Time since last wave
  };

  public type GliotransmitterRelease = {
    var glutamateRelease : Float;        // Glial glutamate
    var dSerineRelease : Float;          // D-serine co-agonist
    var atpRelease : Float;              // ATP (converts to adenosine)
    var gabaRelease : Float;             // Glial GABA
    var adenosine : Float;               // From ATP breakdown
    var netEffect : Float;               // Net modulation (+/-)
  };

  public type TripartiteSynapse = {
    astrocyte : AstrocyteState;
    gliotransmitters : GliotransmitterRelease;
    var synapticGlutamate : Float;       // Glutamate in cleft
    var extrasynapticGlutamate : Float;  // Spillover glutamate
    var extracellularK : Float;          // [K⁺] outside
    var modulationStrength : Float;      // Astrocyte influence
    var isActive : Bool;                 // Astrocyte responding
  };

  // Astrocyte parameters
  public let ASTRO_CA_REST : Float = 0.00005;     // 50 nM resting
  public let ASTRO_CA_THRESHOLD : Float = 0.0005; // 500 nM for release
  public let ASTRO_IP3_TAU : Float = 1000.0;      // IP3 decay (ms)
  public let ASTRO_GLU_UPTAKE_RATE : Float = 0.1; // Glutamate clearance
  public let ASTRO_K_BUFFER_RATE : Float = 0.05;  // K+ buffering
  public let ASTRO_WAVE_VELOCITY : Float = 20.0;  // μm/s calcium wave
  public let ASTRO_WAVE_THRESHOLD : Float = 0.001; // Ca for wave propagation

  // Gliotransmitter parameters
  public let GLIO_GLU_RELEASE_THRESHOLD : Float = 0.001;
  public let GLIO_DSERINE_RELEASE_THRESHOLD : Float = 0.0008;
  public let GLIO_ATP_RELEASE_THRESHOLD : Float = 0.0005;
  public let GLIO_ADENOSINE_CONVERSION : Float = 0.3;  // ATP → Adenosine

  public func initAstrocyteState() : AstrocyteState {
    {
      var calcium = ASTRO_CA_REST;
      var ip3 = 0.0;
      var atp = 1.0;
      var glutamateStores = 0.8;
      var dSerineStores = 0.9;
      var gabaStores = 0.5;
      var glutamateUptake = ASTRO_GLU_UPTAKE_RATE;
      var potassiumUptake = ASTRO_K_BUFFER_RATE;
      var lactateRelease = 0.1;
      var gapJunctionCoupling = 0.3;
      var calciumWaveActive = false;
      var lastWaveTime = 0.0;
    }
  };

  public func initGliotransmitterRelease() : GliotransmitterRelease {
    {
      var glutamateRelease = 0.0;
      var dSerineRelease = 0.0;
      var atpRelease = 0.0;
      var gabaRelease = 0.0;
      var adenosine = 0.0;
      var netEffect = 0.0;
    }
  };

  public func initTripartiteSynapse() : TripartiteSynapse {
    {
      astrocyte = initAstrocyteState();
      gliotransmitters = initGliotransmitterRelease();
      var synapticGlutamate = 0.0;
      var extrasynapticGlutamate = 0.0;
      var extracellularK = 4.0;  // mM (normal ~4 mM)
      var modulationStrength = 0.3;
      var isActive = false;
    }
  };

  // Update astrocyte calcium dynamics
  public func updateAstrocyteCalcium(astro : AstrocyteState, synapticGlutamate : Float, neighborCalcium : Float, dt : Float) {
    // Metabotropic glutamate receptor → IP3 production
    let mGluRActivation = sigmoid(synapticGlutamate * 10.0 - 1.0);
    let ip3Production = 0.01 * mGluRActivation;
    astro.ip3 := astro.ip3 + ip3Production * dt - astro.ip3 / ASTRO_IP3_TAU * dt;
    
    // IP3 receptor activation → ER calcium release
    let ip3rActivation = astro.ip3 * astro.ip3 / (0.01 + astro.ip3 * astro.ip3);  // Hill n=2
    let erRelease = ip3rActivation * 0.001 * (1.0 - astro.calcium / 0.01);  // Release from ER
    
    // Calcium-induced calcium release (CICR)
    let cicr = if (astro.calcium > ASTRO_CA_REST * 3.0) {
      0.0002 * astro.calcium
    } else { 0.0 };
    
    // Gap junction calcium influx from neighbors
    let gapJunctionInflux = astro.gapJunctionCoupling * (neighborCalcium - astro.calcium);
    
    // SERCA pump — returns calcium to ER
    let sercaPump = 0.01 * astro.calcium;
    
    // Plasma membrane extrusion
    let pmcaExtrusion = 0.005 * astro.calcium;
    
    // Update calcium
    astro.calcium += dt * (erRelease + cicr + gapJunctionInflux - sercaPump - pmcaExtrusion);
    astro.calcium := Float.max(ASTRO_CA_REST * 0.5, astro.calcium);
    
    // Detect calcium wave participation
    if (astro.calcium > ASTRO_WAVE_THRESHOLD) {
      astro.calciumWaveActive := true;
    } else if (astro.calcium < ASTRO_CA_REST * 2.0) {
      astro.calciumWaveActive := false;
    };
  };

  // Compute gliotransmitter release
  public func computeGliotransmitterRelease(glio : GliotransmitterRelease, astro : AstrocyteState, dt : Float) {
    // Glutamate release — calcium-dependent exocytosis
    if (astro.calcium > GLIO_GLU_RELEASE_THRESHOLD) {
      let releaseProb = (astro.calcium - GLIO_GLU_RELEASE_THRESHOLD) / GLIO_GLU_RELEASE_THRESHOLD;
      glio.glutamateRelease := 0.1 * releaseProb * astro.glutamateStores;
      astro.glutamateStores -= glio.glutamateRelease * dt;
    } else {
      glio.glutamateRelease *= 0.9;  // Decay
    };
    
    // D-serine release — enhances NMDA function
    if (astro.calcium > GLIO_DSERINE_RELEASE_THRESHOLD) {
      let releaseProb = (astro.calcium - GLIO_DSERINE_RELEASE_THRESHOLD) / GLIO_DSERINE_RELEASE_THRESHOLD;
      glio.dSerineRelease := 0.05 * releaseProb * astro.dSerineStores;
      astro.dSerineStores -= glio.dSerineRelease * dt;
    } else {
      glio.dSerineRelease *= 0.95;  // Slower decay
    };
    
    // ATP release — becomes adenosine (inhibitory)
    if (astro.calcium > GLIO_ATP_RELEASE_THRESHOLD) {
      glio.atpRelease := 0.02 * astro.atp;
      astro.atp -= glio.atpRelease * dt;
    } else {
      glio.atpRelease *= 0.95;
    };
    
    // ATP → Adenosine conversion
    glio.adenosine := 0.9 * glio.adenosine + GLIO_ADENOSINE_CONVERSION * glio.atpRelease;
    
    // GABA release (activity-dependent)
    if (astro.calcium > 0.002) {
      glio.gabaRelease := 0.01 * astro.gabaStores;
    } else {
      glio.gabaRelease *= 0.9;
    };
    
    // Net effect on synapse
    // Glutamate + D-serine = potentiation; Adenosine + GABA = depression
    glio.netEffect := (glio.glutamateRelease + glio.dSerineRelease) - 
                      (glio.adenosine + glio.gabaRelease);
  };

  // Update tripartite synapse
  public func updateTripartiteSynapse(tri : TripartiteSynapse, neuronalRelease : Float, neuronalActivity : Float, neighborCalcium : Float, dt : Float) {
    // Neuronal glutamate in synaptic cleft
    tri.synapticGlutamate := 0.5 * tri.synapticGlutamate + 0.5 * neuronalRelease;
    
    // Astrocyte glutamate uptake
    let uptake = tri.astrocyte.glutamateUptake * tri.synapticGlutamate;
    tri.synapticGlutamate -= uptake * dt;
    
    // Some spillover to extrasynaptic space
    tri.extrasynapticGlutamate := 0.9 * tri.extrasynapticGlutamate + 0.1 * tri.synapticGlutamate * 0.2;
    
    // K⁺ accumulation from neuronal activity
    tri.extracellularK += 0.1 * neuronalActivity * dt;
    
    // Astrocyte K⁺ buffering
    let kBuffered = tri.astrocyte.potassiumUptake * (tri.extracellularK - 4.0);
    tri.extracellularK -= kBuffered * dt;
    tri.extracellularK := clamp(tri.extracellularK, 3.0, 12.0);  // Dangerous above ~12 mM
    
    // Update astrocyte calcium
    updateAstrocyteCalcium(tri.astrocyte, tri.synapticGlutamate + tri.extrasynapticGlutamate, neighborCalcium, dt);
    
    // Compute gliotransmitter release
    computeGliotransmitterRelease(tri.gliotransmitters, tri.astrocyte, dt);
    
    // Update activity state
    tri.isActive := tri.astrocyte.calcium > ASTRO_CA_REST * 2.0;
    
    // Modulation strength depends on astrocyte activation
    tri.modulationStrength := 0.3 + 0.5 * sigmoid(tri.astrocyte.calcium * 1000.0 - 0.5);
  };

  // Get astrocyte modulation of synaptic transmission
  public func getGlialModulation(tri : TripartiteSynapse) : Float {
    // D-serine enhances NMDA (positive)
    // Adenosine suppresses release (negative)
    // Elevated K⁺ depolarizes neurons (positive acutely, negative long-term)
    
    let dSerineEffect = tri.gliotransmitters.dSerineRelease * 2.0;
    let adenosineEffect = -tri.gliotransmitters.adenosine * 3.0;
    let kEffect = (tri.extracellularK - 4.0) * 0.1;
    
    (dSerineEffect + adenosineEffect + kEffect) * tri.modulationStrength
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // LAYER 13: RETROGRADE SIGNALING — ENDOCANNABINOIDS, NITRIC OXIDE, BDNF
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Postsynaptic neurons can signal BACK to presynaptic terminals:
  //
  // 1. ENDOCANNABINOIDS (eCBs):
  //    - 2-AG and Anandamide
  //    - Synthesized on demand from membrane lipids
  //    - Bind CB1 receptors on presynaptic terminals
  //    - Suppress neurotransmitter release (DSI, DSE)
  //
  // 2. NITRIC OXIDE (NO):
  //    - Gaseous messenger, diffuses freely
  //    - Made by nNOS when calcium rises
  //    - Enhances presynaptic release (LTP)
  //    - Short-lived (~seconds)
  //
  // 3. BDNF (Brain-Derived Neurotrophic Factor):
  //    - Activity-dependent release
  //    - Binds TrkB receptors
  //    - Enhances both pre and post synaptic function
  //    - Required for LTP maintenance
  //

  public type EndocannabinoidState = {
    var twoAG : Float;                   // 2-Arachidonoylglycerol
    var anandamide : Float;              // Anandamide (AEA)
    var cb1Activation : Float;           // CB1 receptor activation
    var daglActivity : Float;            // 2-AG synthesis enzyme
    var mglActivity : Float;             // 2-AG degradation enzyme
    var faahActivity : Float;            // Anandamide degradation
    var suppressionFactor : Float;       // Effect on release
  };

  public type NitricOxideState = {
    var concentration : Float;           // [NO]
    var nnosActivity : Float;            // Neuronal NOS activity
    var sGCActivation : Float;           // Soluble guanylyl cyclase
    var cgmpLevel : Float;               // cGMP second messenger
    var diffusionRadius : Float;         // Effective spread
    var potentiationFactor : Float;      // Effect on release
  };

  public type BDNFState = {
    var proBDNF : Float;                 // Precursor form
    var matureBDNF : Float;              // Active form
    var trkbActivation : Float;          // TrkB receptor
    var p75Activation : Float;           // p75 receptor (proBDNF)
    var plcGammaActivity : Float;        // Downstream signaling
    var mapkActivity : Float;            // MAPK pathway
    var plasticityFactor : Float;        // Effect on plasticity
  };

  public type RetrogradeSignaling = {
    ecb : EndocannabinoidState;
    no : NitricOxideState;
    bdnf : BDNFState;
    var netRetrogradeEffect : Float;     // Combined effect
    var presynapticModulation : Float;   // Effect on presynaptic
    var isActive : Bool;                 // Any retrograde signal?
  };

  // Endocannabinoid parameters
  public let ECB_SYNTHESIS_THRESHOLD : Float = 0.0005;  // [Ca²⁺] for synthesis
  public let ECB_2AG_DECAY : Float = 500.0;             // ms half-life
  public let ECB_AEA_DECAY : Float = 1000.0;            // ms half-life
  public let ECB_CB1_SUPPRESSION : Float = 0.5;         // Max suppression

  // Nitric oxide parameters
  public let NO_SYNTHESIS_THRESHOLD : Float = 0.0003;
  public let NO_DECAY : Float = 100.0;                  // ~100ms half-life
  public let NO_DIFFUSION_RADIUS : Float = 100.0;       // μm spread
  public let NO_POTENTIATION : Float = 0.3;             // Max potentiation

  // BDNF parameters
  public let BDNF_RELEASE_THRESHOLD : Float = 0.5;      // Activity for release
  public let BDNF_MATURATION_RATE : Float = 0.01;       // proBDNF → mBDNF
  public let BDNF_PLASTICITY_GAIN : Float = 2.0;        // LTP enhancement

  public func initEndocannabinoidState() : EndocannabinoidState {
    {
      var twoAG = 0.0;
      var anandamide = 0.0;
      var cb1Activation = 0.0;
      var daglActivity = 0.5;
      var mglActivity = 0.5;
      var faahActivity = 0.5;
      var suppressionFactor = 1.0;
    }
  };

  public func initNitricOxideState() : NitricOxideState {
    {
      var concentration = 0.0;
      var nnosActivity = 0.0;
      var sGCActivation = 0.0;
      var cgmpLevel = 0.0;
      var diffusionRadius = NO_DIFFUSION_RADIUS;
      var potentiationFactor = 1.0;
    }
  };

  public func initBDNFState() : BDNFState {
    {
      var proBDNF = 0.5;
      var matureBDNF = 0.1;
      var trkbActivation = 0.0;
      var p75Activation = 0.0;
      var plcGammaActivity = 0.0;
      var mapkActivity = 0.0;
      var plasticityFactor = 1.0;
    }
  };

  public func initRetrogradeSignaling() : RetrogradeSignaling {
    {
      ecb = initEndocannabinoidState();
      no = initNitricOxideState();
      bdnf = initBDNFState();
      var netRetrogradeEffect = 0.0;
      var presynapticModulation = 1.0;
      var isActive = false;
    }
  };

  // Update endocannabinoid signaling
  public func updateEndocannabinoids(ecb : EndocannabinoidState, postCalcium : Float, postDepolarization : Float, dt : Float) {
    // 2-AG synthesis — calcium and depolarization dependent
    if (postCalcium > ECB_SYNTHESIS_THRESHOLD and postDepolarization > -40.0) {
      let synthesis = ecb.daglActivity * (postCalcium - ECB_SYNTHESIS_THRESHOLD) * 
                      sigmoid((postDepolarization + 40.0) / 10.0);
      ecb.twoAG += synthesis * dt;
    };
    
    // 2-AG degradation by MGL
    ecb.twoAG -= ecb.mglActivity * ecb.twoAG * dt / ECB_2AG_DECAY;
    ecb.twoAG := Float.max(0.0, ecb.twoAG);
    
    // Anandamide synthesis — primarily calcium-dependent
    if (postCalcium > ECB_SYNTHESIS_THRESHOLD * 1.5) {
      ecb.anandamide += 0.5 * (postCalcium - ECB_SYNTHESIS_THRESHOLD * 1.5) * dt;
    };
    
    // Anandamide degradation by FAAH
    ecb.anandamide -= ecb.faahActivity * ecb.anandamide * dt / ECB_AEA_DECAY;
    ecb.anandamide := Float.max(0.0, ecb.anandamide);
    
    // CB1 receptor activation (nonlinear)
    let totalECB = ecb.twoAG + ecb.anandamide;
    ecb.cb1Activation := totalECB / (0.001 + totalECB);  // Saturation
    
    // Suppression of presynaptic release
    ecb.suppressionFactor := 1.0 - ECB_CB1_SUPPRESSION * ecb.cb1Activation;
  };

  // Update nitric oxide signaling
  public func updateNitricOxide(no : NitricOxideState, postCalcium : Float, dt : Float) {
    // nNOS activation by calcium
    if (postCalcium > NO_SYNTHESIS_THRESHOLD) {
      no.nnosActivity := (postCalcium - NO_SYNTHESIS_THRESHOLD) / NO_SYNTHESIS_THRESHOLD;
      no.nnosActivity := clamp(no.nnosActivity, 0.0, 1.0);
    } else {
      no.nnosActivity *= 0.9;  // Decay
    };
    
    // NO production and decay (very fast turnover)
    let production = no.nnosActivity * 0.1;
    let decay = no.concentration / NO_DECAY;
    no.concentration += (production - decay) * dt;
    no.concentration := Float.max(0.0, no.concentration);
    
    // Soluble guanylyl cyclase activation
    no.sGCActivation := no.concentration / (0.001 + no.concentration);
    
    // cGMP production
    no.cgmpLevel := 0.9 * no.cgmpLevel + 0.1 * no.sGCActivation;
    
    // Potentiation of presynaptic release
    no.potentiationFactor := 1.0 + NO_POTENTIATION * no.cgmpLevel;
  };

  // Update BDNF signaling
  public func updateBDNF(bdnf : BDNFState, neuronalActivity : Float, camkiiActivity : Float, dt : Float) {
    // Activity-dependent BDNF transcription
    if (neuronalActivity > BDNF_RELEASE_THRESHOLD) {
      bdnf.proBDNF += 0.001 * (neuronalActivity - BDNF_RELEASE_THRESHOLD) * dt;
    };
    
    // proBDNF → matureBDNF conversion (by plasmin, MMP9)
    let maturation = BDNF_MATURATION_RATE * bdnf.proBDNF * camkiiActivity;
    bdnf.matureBDNF += maturation * dt;
    bdnf.proBDNF -= maturation * dt;
    
    // Degradation
    bdnf.proBDNF *= 0.9999;
    bdnf.matureBDNF *= 0.9995;
    
    // TrkB receptor activation (by mature BDNF)
    bdnf.trkbActivation := bdnf.matureBDNF / (0.1 + bdnf.matureBDNF);
    
    // p75 receptor activation (by proBDNF — promotes LTD!)
    bdnf.p75Activation := bdnf.proBDNF / (0.2 + bdnf.proBDNF);
    
    // Downstream signaling
    bdnf.plcGammaActivity := bdnf.trkbActivation * 0.5;
    bdnf.mapkActivity := bdnf.trkbActivation * 0.3;
    
    // Net plasticity factor
    // TrkB promotes LTP, p75 promotes LTD
    bdnf.plasticityFactor := 1.0 + BDNF_PLASTICITY_GAIN * (bdnf.trkbActivation - 0.5 * bdnf.p75Activation);
  };

  // Compute full retrograde signaling
  public func updateRetrogradeSignaling(retro : RetrogradeSignaling, postCalcium : Float, postVoltage : Float, 
                                        neuronalActivity : Float, camkiiActivity : Float, dt : Float) {
    updateEndocannabinoids(retro.ecb, postCalcium, postVoltage, dt);
    updateNitricOxide(retro.no, postCalcium, dt);
    updateBDNF(retro.bdnf, neuronalActivity, camkiiActivity, dt);
    
    // Combine effects on presynaptic terminal
    // ECB suppresses, NO potentiates, BDNF enhances
    retro.presynapticModulation := retro.ecb.suppressionFactor * 
                                    retro.no.potentiationFactor * 
                                    (1.0 + 0.2 * (retro.bdnf.plasticityFactor - 1.0));
    
    // Net retrograde effect
    retro.netRetrogradeEffect := retro.presynapticModulation - 1.0;
    
    retro.isActive := Float.abs(retro.netRetrogradeEffect) > 0.05;
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // LAYER 14: SPIKE TIMING-DEPENDENT PLASTICITY — THE COMPLETE STDP WINDOW
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // STDP is the canonical Hebbian rule: "Neurons that fire together, wire together"
  //
  // But timing MATTERS:
  //   - Pre before Post (Δt > 0): LTP — the presynaptic neuron predicted the postsynaptic
  //   - Post before Pre (Δt < 0): LTD — the presynaptic neuron was irrelevant
  //
  // The STDP window is NOT symmetric:
  //   - LTP window: ~20ms (τ+ ≈ 16.8 ms)
  //   - LTD window: ~50ms (τ- ≈ 33.7 ms)
  //   - LTD magnitude often larger than LTP at same |Δt|
  //
  // Full STDP equation:
  //   Δw = { A+ × exp(-Δt/τ+)  if Δt > 0 (pre→post)
  //        { -A- × exp(Δt/τ-)  if Δt < 0 (post→pre)
  //

  public type STDPWindow = {
    var tauPlus : Float;                 // LTP time constant (ms)
    var tauMinus : Float;                // LTD time constant (ms)
    var aPlus : Float;                   // LTP amplitude
    var aMinus : Float;                  // LTD amplitude
    var ltpLtdRatio : Float;             // A+/A- ratio
    var windowAsymmetry : Float;         // τ+/τ- ratio
  };

  public type SpikeRecord = {
    var preSpikeTime : Float;            // Last presynaptic spike
    var postSpikeTime : Float;           // Last postsynaptic spike
    var preSpikeHistory : [var Float];   // Recent pre spikes
    var postSpikeHistory : [var Float];  // Recent post spikes
    var historySize : Nat;               // Number of spikes tracked
    var historyIdx : Nat;                // Current write index
  };

  public type STDPState = {
    window : STDPWindow;
    spikes : SpikeRecord;
    var deltaT : Float;                  // Time difference (pre - post)
    var stdpDeltaW : Float;              // Weight change from STDP
    var ltpEvents : Nat;                 // Count of LTP inductions
    var ltdEvents : Nat;                 // Count of LTD inductions
    var cumulativeLTP : Float;           // Cumulative LTP
    var cumulativeLTD : Float;           // Cumulative LTD
    var lastUpdateTime : Float;
  };

  // Extended STDP with triplet and voltage rules
  public type ExtendedSTDPState = {
    basic : STDPState;
    var tripletLTP : Float;              // Triplet rule LTP contribution
    var tripletLTD : Float;              // Triplet rule LTD contribution
    var voltageDependent : Float;        // Voltage-dependent component
    var dendriteDepolarization : Float;  // Local depolarization
    var bapAmplitude : Float;            // Backpropagating AP
    var localCalcium : Float;            // Local [Ca²⁺]
    var eligibilityTrace : Float;        // For three-factor learning
  };

  // STDP parameters
  public let STDP_TAU_PLUS : Float = 16.8;        // LTP time constant
  public let STDP_TAU_MINUS : Float = 33.7;       // LTD time constant
  public let STDP_A_PLUS : Float = 0.1;           // LTP amplitude
  public let STDP_A_MINUS : Float = 0.12;         // LTD amplitude (slightly larger)
  public let STDP_WINDOW : Float = 100.0;         // Max timing window (ms)
  public let STDP_HISTORY_SIZE : Nat = 20;        // Spikes to track

  // Triplet STDP parameters
  public let TRIPLET_TAU_X : Float = 15.0;        // Fast pre trace
  public let TRIPLET_TAU_Y : Float = 20.0;        // Fast post trace
  public let TRIPLET_TAU_X_SLOW : Float = 100.0;  // Slow pre trace
  public let TRIPLET_TAU_Y_SLOW : Float = 120.0;  // Slow post trace
  public let TRIPLET_A2_PLUS : Float = 0.01;      // Triplet LTP
  public let TRIPLET_A3_MINUS : Float = 0.005;    // Triplet LTD

  public func initSTDPWindow() : STDPWindow {
    {
      var tauPlus = STDP_TAU_PLUS;
      var tauMinus = STDP_TAU_MINUS;
      var aPlus = STDP_A_PLUS;
      var aMinus = STDP_A_MINUS;
      var ltpLtdRatio = STDP_A_PLUS / STDP_A_MINUS;
      var windowAsymmetry = STDP_TAU_PLUS / STDP_TAU_MINUS;
    }
  };

  public func initSpikeRecord() : SpikeRecord {
    {
      var preSpikeTime = -1000.0;        // No recent spike
      var postSpikeTime = -1000.0;
      var preSpikeHistory = Array.init<Float>(STDP_HISTORY_SIZE, func(_ : Nat) : Float { -1000.0 });
      var postSpikeHistory = Array.init<Float>(STDP_HISTORY_SIZE, func(_ : Nat) : Float { -1000.0 });
      var historySize = STDP_HISTORY_SIZE;
      var historyIdx = 0;
    }
  };

  public func initSTDPState() : STDPState {
    {
      window = initSTDPWindow();
      spikes = initSpikeRecord();
      var deltaT = 0.0;
      var stdpDeltaW = 0.0;
      var ltpEvents = 0;
      var ltdEvents = 0;
      var cumulativeLTP = 0.0;
      var cumulativeLTD = 0.0;
      var lastUpdateTime = 0.0;
    }
  };

  public func initExtendedSTDPState() : ExtendedSTDPState {
    {
      basic = initSTDPState();
      var tripletLTP = 0.0;
      var tripletLTD = 0.0;
      var voltageDependent = 0.0;
      var dendriteDepolarization = -70.0;
      var bapAmplitude = 0.0;
      var localCalcium = 0.0;
      var eligibilityTrace = 0.0;
    }
  };

  // Record a presynaptic spike
  public func recordPreSpike(spikes : SpikeRecord, currentTime : Float) {
    spikes.preSpikeTime := currentTime;
    spikes.preSpikeHistory[spikes.historyIdx] := currentTime;
  };

  // Record a postsynaptic spike
  public func recordPostSpike(spikes : SpikeRecord, currentTime : Float) {
    spikes.postSpikeTime := currentTime;
    spikes.postSpikeHistory[spikes.historyIdx] := currentTime;
    spikes.historyIdx := (spikes.historyIdx + 1) % spikes.historySize;
  };

  // Compute classic STDP weight change
  public func computeClassicSTDP(stdp : STDPState, currentTime : Float) : Float {
    // Time since spikes
    let timeSincePre = currentTime - stdp.spikes.preSpikeTime;
    let timeSincePost = currentTime - stdp.spikes.postSpikeTime;
    
    // Only compute if both spikes are recent
    if (timeSincePre > STDP_WINDOW and timeSincePost > STDP_WINDOW) {
      return 0.0;
    };
    
    // Δt = t_post - t_pre (positive means pre came before post)
    stdp.deltaT := stdp.spikes.postSpikeTime - stdp.spikes.preSpikeTime;
    
    var deltaW : Float = 0.0;
    
    if (stdp.deltaT > 0.0 and stdp.deltaT < STDP_WINDOW) {
      // Pre before Post → LTP
      deltaW := stdp.window.aPlus * exp(-stdp.deltaT / stdp.window.tauPlus);
      stdp.ltpEvents += 1;
      stdp.cumulativeLTP += deltaW;
    } else if (stdp.deltaT < 0.0 and stdp.deltaT > -STDP_WINDOW) {
      // Post before Pre → LTD
      deltaW := -stdp.window.aMinus * exp(stdp.deltaT / stdp.window.tauMinus);
      stdp.ltdEvents += 1;
      stdp.cumulativeLTD += Float.abs(deltaW);
    };
    
    stdp.stdpDeltaW := deltaW;
    stdp.lastUpdateTime := currentTime;
    
    deltaW
  };

  // Compute triplet STDP (more accurate model)
  // Uses slow traces that capture burst effects
  public func computeTripletSTDP(
    ext : ExtendedSTDPState,
    preSpike : Bool,
    postSpike : Bool,
    preSlow : Float,      // Slow presynaptic trace
    postSlow : Float,     // Slow postsynaptic trace
    preFast : Float,      // Fast presynaptic trace
    postFast : Float,     // Fast postsynaptic trace
    currentTime : Float
  ) : Float {
    var deltaW : Float = 0.0;
    
    // Classic pairwise component
    deltaW += computeClassicSTDP(ext.basic, currentTime);
    
    // Triplet components
    if (postSpike) {
      // LTP: pre trace × slow post trace
      ext.tripletLTP := TRIPLET_A2_PLUS * preFast * postSlow;
      deltaW += ext.tripletLTP;
    };
    
    if (preSpike) {
      // LTD: post trace × slow pre trace
      ext.tripletLTD := -TRIPLET_A3_MINUS * postFast * preSlow;
      deltaW += ext.tripletLTD;
    };
    
    deltaW
  };

  // Compute voltage-dependent STDP
  // Accounts for local dendritic depolarization
  public func computeVoltageSTDP(ext : ExtendedSTDPState, localVoltage : Float, backpropAP : Float) : Float {
    ext.dendriteDepolarization := localVoltage;
    ext.bapAmplitude := backpropAP;
    
    // Voltage-dependent modulation of STDP
    // More depolarized → stronger LTP
    let depolarizationFactor = sigmoid((localVoltage + 50.0) / 10.0);
    
    // BAP amplitude modulates LTP
    let bapFactor = backpropAP / 100.0;  // Normalize to 100 mV spike
    
    ext.voltageDependent := (depolarizationFactor + bapFactor) / 2.0;
    
    ext.voltageDependent
  };

  // Update eligibility trace for three-factor learning
  public func updateEligibilityTrace(ext : ExtendedSTDPState, stdpSignal : Float, dt : Float) {
    // Eligibility trace decays but is boosted by STDP
    let tau_e = 500.0;  // 500ms eligibility window
    ext.eligibilityTrace := ext.eligibilityTrace * exp(-dt / tau_e) + stdpSignal;
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // LAYER 15: THREE-FACTOR LEARNING — ELIGIBILITY TRACES + NEUROMODULATION
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Two-factor Hebbian: Δw ∝ pre × post
  // Three-factor: Δw ∝ pre × post × NEUROMODULATOR
  //
  // The third factor solves the temporal credit assignment problem:
  //   - STDP creates a temporary "eligibility trace" at a synapse
  //   - If reward (dopamine) arrives within seconds, the trace is converted to actual change
  //   - If no reward, the trace fades away
  //
  // This elegantly explains:
  //   - Why reward timing matters
  //   - How distant actions can be credited for later outcomes
  //   - Why attention (acetylcholine) and surprise (norepinephrine) enhance learning
  //

  public type EligibilityTraceState = {
    var preTrace : Float;                // Presynaptic activity trace
    var postTrace : Float;               // Postsynaptic activity trace
    var eligibility : Float;             // Eligibility trace (pre × post)
    var eligibilityTau : Float;          // Decay time constant
    var maxEligibility : Float;          // Maximum value
    var decayRate : Float;               // Per-step decay
  };

  public type ThreeFactorState = {
    eligibility : EligibilityTraceState;
    var dopamineModulation : Float;      // DA third factor
    var acetylcholineModulation : Float; // ACh third factor
    var norepinephrineModulation : Float;// NE third factor
    var serotoninModulation : Float;     // 5-HT third factor
    var combinedThirdFactor : Float;     // Weighted combination
    var actualDeltaW : Float;            // Final weight change
    var rewardPredictionError : Float;   // TD error
    var surpriseSignal : Float;          // Unexpected outcome
  };

  // Three-factor learning parameters
  public let ELIG_TAU_PRE : Float = 100.0;        // Presynaptic trace decay
  public let ELIG_TAU_POST : Float = 100.0;       // Postsynaptic trace decay
  public let ELIG_TAU_ELIGIBILITY : Float = 1000.0; // Eligibility trace decay
  public let ELIG_MAX : Float = 1.0;              // Max eligibility
  
  public let THREE_DA_WEIGHT : Float = 0.4;       // Dopamine importance
  public let THREE_ACH_WEIGHT : Float = 0.2;      // ACh importance
  public let THREE_NE_WEIGHT : Float = 0.3;       // NE importance
  public let THREE_5HT_WEIGHT : Float = 0.1;      // 5-HT importance

  public func initEligibilityTraceState() : EligibilityTraceState {
    {
      var preTrace = 0.0;
      var postTrace = 0.0;
      var eligibility = 0.0;
      var eligibilityTau = ELIG_TAU_ELIGIBILITY;
      var maxEligibility = ELIG_MAX;
      var decayRate = 1.0 / ELIG_TAU_ELIGIBILITY;
    }
  };

  public func initThreeFactorState() : ThreeFactorState {
    {
      eligibility = initEligibilityTraceState();
      var dopamineModulation = 0.0;
      var acetylcholineModulation = 0.5;  // Baseline attention
      var norepinephrineModulation = 0.0;
      var serotoninModulation = 0.5;      // Baseline mood
      var combinedThirdFactor = 0.0;
      var actualDeltaW = 0.0;
      var rewardPredictionError = 0.0;
      var surpriseSignal = 0.0;
    }
  };

  // Update eligibility trace
  public func updateEligibility(
    elig : EligibilityTraceState,
    preActivity : Float,
    postActivity : Float,
    dt : Float
  ) {
    // Update activity traces
    elig.preTrace := elig.preTrace * exp(-dt / ELIG_TAU_PRE) + preActivity;
    elig.postTrace := elig.postTrace * exp(-dt / ELIG_TAU_POST) + postActivity;
    
    // Eligibility = pre × post (the "tag")
    let newEligibility = elig.preTrace * elig.postTrace;
    
    // Decay old eligibility, add new
    elig.eligibility := elig.eligibility * exp(-dt / elig.eligibilityTau) + newEligibility;
    
    // Clamp
    elig.eligibility := clamp(elig.eligibility, 0.0, elig.maxEligibility);
  };

  // Compute three-factor weight change
  public func computeThreeFactorLearning(
    state : ThreeFactorState,
    preActivity : Float,
    postActivity : Float,
    dopamine : Float,
    acetylcholine : Float,
    norepinephrine : Float,
    serotonin : Float,
    rewardPredictionError : Float,
    learningRate : Float,
    dt : Float
  ) : Float {
    // Update eligibility trace
    updateEligibility(state.eligibility, preActivity, postActivity, dt);
    
    // Update neuromodulator values
    state.dopamineModulation := dopamine;
    state.acetylcholineModulation := acetylcholine;
    state.norepinephrineModulation := norepinephrine;
    state.serotoninModulation := serotonin;
    state.rewardPredictionError := rewardPredictionError;
    
    // Compute surprise (unsigned prediction error)
    state.surpriseSignal := Float.abs(rewardPredictionError);
    
    // Combined third factor
    // DA: scales with RPE (signed)
    // ACh: attention/uncertainty
    // NE: arousal/surprise (unsigned)
    // 5-HT: patience/waiting (often negative for plasticity)
    state.combinedThirdFactor := 
      THREE_DA_WEIGHT * rewardPredictionError +
      THREE_ACH_WEIGHT * acetylcholine +
      THREE_NE_WEIGHT * norepinephrine * state.surpriseSignal -
      THREE_5HT_WEIGHT * (1.0 - serotonin);  // Low 5-HT enhances learning
    
    // Final weight change: eligibility × third factor × learning rate
    state.actualDeltaW := learningRate * state.eligibility.eligibility * state.combinedThirdFactor;
    
    state.actualDeltaW
  };

  // Apply reward signal to convert eligibility to weight change
  public func applyRewardSignal(
    state : ThreeFactorState,
    reward : Float,
    expectedReward : Float,
    baselineLearningRate : Float
  ) : Float {
    // TD error
    let tdError = reward - expectedReward;
    state.rewardPredictionError := tdError;
    
    // Learning rate modulated by surprise
    let effectiveLR = baselineLearningRate * (1.0 + Float.abs(tdError));
    
    // Convert eligibility to weight change
    let deltaW = state.eligibility.eligibility * tdError * effectiveLR;
    
    // Decay eligibility after reward
    state.eligibility.eligibility *= 0.5;  // Consume some eligibility
    
    deltaW
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // LAYER 16: SYNAPTIC CONSOLIDATION — MEMORY SYSTEMS INTERACTIONS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Memories are not fixed — they undergo consolidation:
  //
  // 1. SYNAPTIC CONSOLIDATION (hours):
  //    - Early LTP → Late LTP (requires protein synthesis)
  //    - Synaptic tagging and capture
  //    - Local translation at tagged synapses
  //
  // 2. SYSTEMS CONSOLIDATION (days-years):
  //    - Hippocampus → Neocortex transfer
  //    - Schema integration
  //    - Sleep-dependent replay
  //
  // 3. RECONSOLIDATION:
  //    - Retrieved memories become labile again
  //    - Can be updated or weakened
  //    - Requires protein synthesis
  //

  public type SynapticConsolidationState = {
    var earlyLTP : Float;                // E-LTP (1-3 hours)
    var lateLTP : Float;                 // L-LTP (3+ hours)
    var synapticTag : Float;             // "Tag" for capture
    var tagStrength : Float;             // Tag intensity
    var tagSetTime : Float;              // When tag was set
    var tagDuration : Float;             // How long tag lasts
    var proteinsCaptured : Float;        // PRPs captured
    var consolidationProgress : Float;   // 0-1 consolidation
    var isConsolidated : Bool;           // Fully consolidated?
  };

  public type SystemsConsolidationState = {
    var hippocampalStrength : Float;     // HPC representation
    var neocorticalStrength : Float;     // NCx representation
    var schemaIntegration : Float;       // Fit to existing knowledge
    var replayCount : Nat;               // Sleep replay events
    var lastReplayTime : Float;          // Time of last replay
    var transferProgress : Float;        // HPC → NCx progress
    var isRemote : Bool;                 // Fully transferred to NCx?
  };

  public type ReconsolidationState = {
    var memoryRetrieved : Bool;          // Was memory reactivated?
    var retrievalTime : Float;           // When retrieved
    var labilityWindow : Float;          // Duration of lability
    var isLabile : Bool;                 // Currently modifiable?
    var updatePotential : Float;         // How much can change
    var proteinSynthesisRequired : Bool; // Needs PSI for restabilization
    var destabilizationLevel : Float;    // How labile
  };

  public type ConsolidationEngine = {
    synaptic : SynapticConsolidationState;
    systems : SystemsConsolidationState;
    reconsolidation : ReconsolidationState;
    var overallStability : Float;        // Memory stability
    var memoryAge : Float;               // Time since encoding
    var lastUpdate : Float;
  };

  // Consolidation parameters
  public let CONSOL_TAG_THRESHOLD : Float = 0.5;      // Activity to set tag
  public let CONSOL_TAG_DURATION : Float = 3600000.0; // ~1 hour in ms
  public let CONSOL_ELTPLTP_TRANSITION : Float = 10800000.0; // ~3 hours
  public let CONSOL_SYSTEMS_TAU : Float = 86400000.0; // ~1 day
  public let CONSOL_LABILITY_WINDOW : Float = 3600000.0; // ~1 hour

  public func initSynapticConsolidationState() : SynapticConsolidationState {
    {
      var earlyLTP = 0.0;
      var lateLTP = 0.0;
      var synapticTag = 0.0;
      var tagStrength = 0.0;
      var tagSetTime = 0.0;
      var tagDuration = CONSOL_TAG_DURATION;
      var proteinsCaptured = 0.0;
      var consolidationProgress = 0.0;
      var isConsolidated = false;
    }
  };

  public func initSystemsConsolidationState() : SystemsConsolidationState {
    {
      var hippocampalStrength = 1.0;
      var neocorticalStrength = 0.0;
      var schemaIntegration = 0.0;
      var replayCount = 0;
      var lastReplayTime = 0.0;
      var transferProgress = 0.0;
      var isRemote = false;
    }
  };

  public func initReconsolidationState() : ReconsolidationState {
    {
      var memoryRetrieved = false;
      var retrievalTime = 0.0;
      var labilityWindow = CONSOL_LABILITY_WINDOW;
      var isLabile = false;
      var updatePotential = 0.0;
      var proteinSynthesisRequired = false;
      var destabilizationLevel = 0.0;
    }
  };

  public func initConsolidationEngine() : ConsolidationEngine {
    {
      synaptic = initSynapticConsolidationState();
      systems = initSystemsConsolidationState();
      reconsolidation = initReconsolidationState();
      var overallStability = 0.0;
      var memoryAge = 0.0;
      var lastUpdate = 0.0;
    }
  };

  // Update synaptic consolidation
  public func updateSynapticConsolidation(
    consol : SynapticConsolidationState,
    ltpMagnitude : Float,
    camkiiActivity : Float,
    proteinSynthesis : Float,
    currentTime : Float,
    dt : Float
  ) {
    // E-LTP from recent LTP induction
    consol.earlyLTP := 0.99 * consol.earlyLTP + ltpMagnitude;
    
    // Synaptic tag setting
    if (camkiiActivity > CONSOL_TAG_THRESHOLD and consol.synapticTag < 0.5) {
      consol.synapticTag := 1.0;
      consol.tagStrength := camkiiActivity;
      consol.tagSetTime := currentTime;
    };
    
    // Tag decay
    let tagAge = currentTime - consol.tagSetTime;
    if (tagAge > consol.tagDuration) {
      consol.synapticTag := 0.0;
    } else {
      consol.synapticTag *= 0.9999;
    };
    
    // Protein capture — if tag present and proteins available
    if (consol.synapticTag > 0.5 and proteinSynthesis > 0.3) {
      consol.proteinsCaptured += 0.001 * proteinSynthesis * consol.tagStrength * dt;
    };
    
    // E-LTP → L-LTP transition
    if (consol.proteinsCaptured > 0.5) {
      let conversionRate = 0.001 * consol.proteinsCaptured;
      let conversion = conversionRate * consol.earlyLTP * dt;
      consol.lateLTP += conversion;
      consol.earlyLTP -= conversion;
    };
    
    // Consolidation progress
    consol.consolidationProgress := consol.lateLTP / (consol.lateLTP + consol.earlyLTP + 0.001);
    consol.isConsolidated := consol.consolidationProgress > 0.9;
  };

  // Update systems consolidation
  public func updateSystemsConsolidation(
    systems : SystemsConsolidationState,
    sleepReplay : Bool,
    schemaConsistency : Float,
    currentTime : Float,
    dt : Float
  ) {
    // Sleep-dependent replay
    if (sleepReplay) {
      systems.replayCount += 1;
      systems.lastReplayTime := currentTime;
      
      // Each replay strengthens neocortical representation
      let replayStrength = 0.01 * (1.0 + schemaConsistency);
      systems.neocorticalStrength += replayStrength;
    };
    
    // Gradual HPC → NCx transfer
    let transferRate = 1.0 / CONSOL_SYSTEMS_TAU;
    let transfer = transferRate * systems.hippocampalStrength * dt;
    systems.hippocampalStrength -= transfer * 0.1;  // HPC weakens slowly
    systems.neocorticalStrength += transfer;        // NCx strengthens
    
    // Schema integration improves with replay and consistency
    systems.schemaIntegration := 0.999 * systems.schemaIntegration + 
                                  0.001 * schemaConsistency * Float.fromInt(systems.replayCount);
    
    // Transfer progress
    systems.transferProgress := systems.neocorticalStrength / 
                                (systems.neocorticalStrength + systems.hippocampalStrength + 0.001);
    systems.isRemote := systems.transferProgress > 0.8;
    
    // Clamp
    systems.hippocampalStrength := Float.max(0.1, systems.hippocampalStrength);
    systems.neocorticalStrength := clamp(systems.neocorticalStrength, 0.0, 2.0);
  };

  // Update reconsolidation state
  public func updateReconsolidation(
    recon : ReconsolidationState,
    isRetrieved : Bool,
    predictionError : Float,
    proteinSynthesis : Float,
    currentTime : Float,
    dt : Float
  ) {
    if (isRetrieved and not recon.memoryRetrieved) {
      // Memory retrieval initiates lability
      recon.memoryRetrieved := true;
      recon.retrievalTime := currentTime;
      recon.isLabile := true;
      recon.proteinSynthesisRequired := true;
      
      // Destabilization proportional to prediction error
      recon.destabilizationLevel := predictionError;
    };
    
    if (recon.memoryRetrieved) {
      let timeSinceRetrieval = currentTime - recon.retrievalTime;
      
      if (timeSinceRetrieval < recon.labilityWindow) {
        // Within lability window — memory can be updated
        recon.updatePotential := 1.0 - timeSinceRetrieval / recon.labilityWindow;
        recon.isLabile := true;
      } else {
        // Window closed — restabilization if protein synthesis occurred
        if (proteinSynthesis > 0.5) {
          recon.isLabile := false;
          recon.proteinSynthesisRequired := false;
        };
        recon.updatePotential := 0.0;
        recon.memoryRetrieved := false;
      };
    };
  };

  // Full consolidation update
  public func updateConsolidationEngine(
    engine : ConsolidationEngine,
    ltpMagnitude : Float,
    camkiiActivity : Float,
    proteinSynthesis : Float,
    sleepReplay : Bool,
    schemaConsistency : Float,
    isRetrieved : Bool,
    predictionError : Float,
    currentTime : Float,
    dt : Float
  ) {
    updateSynapticConsolidation(engine.synaptic, ltpMagnitude, camkiiActivity, proteinSynthesis, currentTime, dt);
    updateSystemsConsolidation(engine.systems, sleepReplay, schemaConsistency, currentTime, dt);
    updateReconsolidation(engine.reconsolidation, isRetrieved, predictionError, proteinSynthesis, currentTime, dt);
    
    // Overall stability
    engine.overallStability := engine.synaptic.consolidationProgress * 0.3 +
                                engine.systems.transferProgress * 0.5 +
                                (1.0 - Float.fromInt(Bool.toInt(engine.reconsolidation.isLabile))) * 0.2;
    
    engine.memoryAge += dt;
    engine.lastUpdate := currentTime;
  };


  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // LAYER 17: NETWORK OSCILLATIONS — THETA-GAMMA COUPLING
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Neural oscillations are not epiphenomena — they actively coordinate plasticity:
  //
  // 1. THETA (4-8 Hz):
  //    - Hippocampal navigation and memory
  //    - Phase-amplitude coupling with gamma
  //    - Theta phase determines LTP vs LTD
  //
  // 2. GAMMA (30-100 Hz):
  //    - Local processing and binding
  //    - Nested in theta cycles
  //    - Different gamma bands for different functions
  //
  // 3. THETA-GAMMA COUPLING:
  //    - Items stored at different theta phases
  //    - Gamma cycles = individual items
  //    - 7±2 gamma cycles per theta = working memory capacity
  //
  // 4. SHARP-WAVE RIPPLES (150-250 Hz):
  //    - Memory replay during rest/sleep
  //    - Compress experience for consolidation
  //    - Critical for memory transfer
  //

  public type OscillationBand = {
    var frequency : Float;               // Center frequency (Hz)
    var bandwidth : Float;               // Bandwidth (Hz)
    var power : Float;                   // Current power
    var phase : Float;                   // Current phase [0, 2π]
    var amplitude : Float;               // Envelope amplitude
    var phaseVelocity : Float;           // d(phase)/dt
    var instantFreq : Float;             // Instantaneous frequency
  };

  public type ThetaGammaCoupling = {
    theta : OscillationBand;
    gamma : OscillationBand;
    var couplingStrength : Float;        // Modulation index
    var preferredPhase : Float;          // Theta phase of gamma peak
    var phaseAmplitudeCoupling : Float;  // PAC measure
    var gammaPerTheta : Nat;             // Gamma cycles per theta
    var currentThetaPhase : Float;       // Where in theta cycle
    var ltpPhaseWindow : (Float, Float); // Theta phases for LTP
    var ltdPhaseWindow : (Float, Float); // Theta phases for LTD
  };

  public type SharpWaveRipple = {
    var isActive : Bool;                 // Currently rippling?
    var rippleFrequency : Float;         // ~150-250 Hz
    var ripplePower : Float;             // Ripple amplitude
    var duration : Float;                // Ripple duration (ms)
    var replayContent : [var Float];     // Pattern being replayed
    var replaySequence : [var Nat];      // Order of replay
    var compressionFactor : Float;       // Time compression
    var lastRippleTime : Float;
  };

  public type OscillatoryPlasticity = {
    coupling : ThetaGammaCoupling;
    ripple : SharpWaveRipple;
    var oscillationModulatedLTP : Float; // LTP at optimal phase
    var oscillationModulatedLTD : Float; // LTD at suboptimal phase
    var phaseLockedPlasticity : Float;   // Overall modulation
    var crossFrequencyCoupling : Float;  // CFC strength
  };

  // Oscillation parameters
  public let OSC_THETA_FREQ : Float = 6.0;        // 6 Hz theta
  public let OSC_GAMMA_FREQ : Float = 40.0;       // 40 Hz gamma
  public let OSC_RIPPLE_FREQ : Float = 180.0;     // 180 Hz ripples
  public let OSC_LTP_PHASE_MIN : Float = 0.0;     // Peak of theta
  public let OSC_LTP_PHASE_MAX : Float = 1.57;    // First quarter
  public let OSC_LTD_PHASE_MIN : Float = 3.14;    // Trough of theta
  public let OSC_LTD_PHASE_MAX : Float = 4.71;    // Third quarter

  public func initOscillationBand(freq : Float, bw : Float) : OscillationBand {
    {
      var frequency = freq;
      var bandwidth = bw;
      var power = 0.5;
      var phase = 0.0;
      var amplitude = 1.0;
      var phaseVelocity = 2.0 * PI * freq;
      var instantFreq = freq;
    }
  };

  public func initThetaGammaCoupling() : ThetaGammaCoupling {
    {
      theta = initOscillationBand(OSC_THETA_FREQ, 2.0);
      gamma = initOscillationBand(OSC_GAMMA_FREQ, 20.0);
      var couplingStrength = 0.5;
      var preferredPhase = 0.0;
      var phaseAmplitudeCoupling = 0.3;
      var gammaPerTheta = 7;
      var currentThetaPhase = 0.0;
      var ltpPhaseWindow = (OSC_LTP_PHASE_MIN, OSC_LTP_PHASE_MAX);
      var ltdPhaseWindow = (OSC_LTD_PHASE_MIN, OSC_LTD_PHASE_MAX);
    }
  };

  public func initSharpWaveRipple() : SharpWaveRipple {
    {
      var isActive = false;
      var rippleFrequency = OSC_RIPPLE_FREQ;
      var ripplePower = 0.0;
      var duration = 0.0;
      var replayContent = Array.init<Float>(12, func(_ : Nat) : Float { 0.0 });
      var replaySequence = Array.init<Nat>(12, func(i : Nat) : Nat { i });
      var compressionFactor = 20.0;
      var lastRippleTime = 0.0;
    }
  };

  public func initOscillatoryPlasticity() : OscillatoryPlasticity {
    {
      coupling = initThetaGammaCoupling();
      ripple = initSharpWaveRipple();
      var oscillationModulatedLTP = 0.0;
      var oscillationModulatedLTD = 0.0;
      var phaseLockedPlasticity = 0.0;
      var crossFrequencyCoupling = 0.0;
    }
  };

  // Update oscillation band
  public func updateOscillationBand(band : OscillationBand, externalDrive : Float, dt : Float) {
    // Phase evolution
    band.phase += band.phaseVelocity * dt / 1000.0;  // dt in ms, freq in Hz
    if (band.phase > 2.0 * PI) {
      band.phase -= 2.0 * PI;
    };
    
    // Power modulation
    band.power := 0.95 * band.power + 0.05 * externalDrive;
    
    // Amplitude
    band.amplitude := band.power * (1.0 + 0.1 * sin(band.phase));
    
    // Instantaneous frequency (can vary with drive)
    band.instantFreq := band.frequency * (1.0 + 0.1 * (externalDrive - 0.5));
    band.phaseVelocity := 2.0 * PI * band.instantFreq;
  };

  // Update theta-gamma coupling
  public func updateThetaGammaCoupling(coupling : ThetaGammaCoupling, arousal : Float, dt : Float) {
    // Update theta
    updateOscillationBand(coupling.theta, arousal, dt);
    
    // Gamma amplitude modulated by theta phase
    let thetaModulation = 1.0 + coupling.couplingStrength * cos(coupling.theta.phase - coupling.preferredPhase);
    updateOscillationBand(coupling.gamma, arousal * thetaModulation, dt);
    
    // Phase-amplitude coupling measure
    coupling.phaseAmplitudeCoupling := coupling.couplingStrength * 
                                        coupling.gamma.amplitude * 
                                        cos(coupling.theta.phase - coupling.preferredPhase);
    
    coupling.currentThetaPhase := coupling.theta.phase;
  };

  // Get phase-dependent plasticity modulation
  public func getPhaseModulatedPlasticity(coupling : ThetaGammaCoupling, stdpSignal : Float) : Float {
    let thetaPhase = coupling.currentThetaPhase;
    
    // Check if in LTP window
    if (thetaPhase >= coupling.ltpPhaseWindow.0 and thetaPhase <= coupling.ltpPhaseWindow.1) {
      // LTP enhanced at theta peak
      return stdpSignal * 1.5;
    }
    // Check if in LTD window
    else if (thetaPhase >= coupling.ltdPhaseWindow.0 and thetaPhase <= coupling.ltdPhaseWindow.1) {
      // LTD enhanced at theta trough
      return stdpSignal * 0.5;
    }
    // Neutral phase
    else {
      return stdpSignal;
    };
  };

  // Detect and process sharp-wave ripple
  public func processSharpWaveRipple(
    ripple : SharpWaveRipple,
    hippocampalActivity : Float,
    sleepState : Bool,
    memoryPattern : [Float],
    currentTime : Float,
    dt : Float
  ) : Bool {
    // Ripples occur during quiet wakefulness and NREM sleep
    if (sleepState and hippocampalActivity > 0.7 and not ripple.isActive) {
      // Initiate ripple
      ripple.isActive := true;
      ripple.ripplePower := hippocampalActivity;
      ripple.duration := 0.0;
      
      // Load memory pattern for replay
      let patternSize = Nat.min(Array.size(memoryPattern), 12);
      for (i in Iter.range(0, patternSize - 1)) {
        ripple.replayContent[i] := memoryPattern[i];
      };
      
      ripple.lastRippleTime := currentTime;
    };
    
    if (ripple.isActive) {
      ripple.duration += dt;
      
      // Ripples last ~50-100ms
      if (ripple.duration > 80.0) {
        ripple.isActive := false;
        ripple.ripplePower := 0.0;
        return true;  // Replay completed
      };
    };
    
    false  // Replay not completed
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // LAYER 18: ATTENTIONAL MODULATION — TOP-DOWN CONTROL OF PLASTICITY
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Attention is the great gatekeeper of plasticity:
  //
  // 1. ACETYLCHOLINE (Basal Forebrain):
  //    - Released during attention and novelty
  //    - Enhances signal-to-noise ratio
  //    - Enables plasticity in attended stimuli
  //    - Suppresses plasticity in unattended
  //
  // 2. PREFRONTAL TOP-DOWN:
  //    - Task-relevance signals
  //    - Goal-directed attention
  //    - Working memory maintenance
  //
  // 3. UNCERTAINTY MODULATION:
  //    - Novel/uncertain stimuli get more plasticity
  //    - Familiar/predictable get less
  //    - Implements optimal learning
  //

  public type AttentionalState = {
    var globalAttention : Float;         // Overall attention level
    var focalAttention : [var Float];    // Per-input attention weights
    var attentionalSpotlight : Nat;      // Currently attended item
    var spotlightWidth : Float;          // Attention spread
    var topDownBias : [var Float];       // PFC signals
    var bottomUpSalience : [var Float];  // Sensory salience
    var achLevel : Float;                // Acetylcholine
    var neLevel : Float;                 // Norepinephrine (arousal)
    var uncertaintyEstimate : Float;     // Bayesian uncertainty
  };

  public type AttentionalGating = {
    attention : AttentionalState;
    var plasticityGate : Float;          // Overall plasticity gate
    var perSynapseGating : [[var Float]]; // Per-synapse gating
    var attendedEnhancement : Float;     // Factor for attended
    var unattendedSuppression : Float;   // Factor for unattended
    var noveltyBonus : Float;            // Extra for novel stimuli
    var predictionErrorGating : Float;   // Gate based on surprise
  };

  // Attention parameters
  public let ATT_BASELINE_ACH : Float = 0.3;
  public let ATT_ATTENDED_BOOST : Float = 2.0;
  public let ATT_UNATTENDED_SUPPRESS : Float = 0.3;
  public let ATT_NOVELTY_THRESHOLD : Float = 0.5;
  public let ATT_SPOTLIGHT_WIDTH : Float = 2.0;

  public func initAttentionalState(numInputs : Nat) : AttentionalState {
    {
      var globalAttention = 0.5;
      var focalAttention = Array.init<Float>(numInputs, func(_ : Nat) : Float { 0.5 });
      var attentionalSpotlight = 0;
      var spotlightWidth = ATT_SPOTLIGHT_WIDTH;
      var topDownBias = Array.init<Float>(numInputs, func(_ : Nat) : Float { 0.0 });
      var bottomUpSalience = Array.init<Float>(numInputs, func(_ : Nat) : Float { 0.0 });
      var achLevel = ATT_BASELINE_ACH;
      var neLevel = 0.3;
      var uncertaintyEstimate = 0.5;
    }
  };

  public func initAttentionalGating(numInputs : Nat, numOutputs : Nat) : AttentionalGating {
    {
      attention = initAttentionalState(numInputs);
      var plasticityGate = 1.0;
      var perSynapseGating = Array.init<[var Float]>(numInputs, func(_ : Nat) : [var Float] {
        Array.init<Float>(numOutputs, func(_ : Nat) : Float { 1.0 })
      });
      var attendedEnhancement = ATT_ATTENDED_BOOST;
      var unattendedSuppression = ATT_UNATTENDED_SUPPRESS;
      var noveltyBonus = 0.0;
      var predictionErrorGating = 1.0;
    }
  };

  // Update attentional state
  public func updateAttention(
    att : AttentionalState,
    externalSalience : [Float],
    topDownSignals : [Float],
    arousal : Float,
    novelty : Float,
    dt : Float
  ) {
    // Update ACh based on attention demands
    let achDemand = arousal * (1.0 + novelty);
    att.achLevel := 0.9 * att.achLevel + 0.1 * achDemand;
    att.achLevel := clamp(att.achLevel, 0.1, 1.0);
    
    // Update NE based on arousal
    att.neLevel := 0.95 * att.neLevel + 0.05 * arousal;
    
    // Bottom-up salience
    let numInputs = Array.size(att.bottomUpSalience);
    for (i in Iter.range(0, numInputs - 1)) {
      if (i < Array.size(externalSalience)) {
        att.bottomUpSalience[i] := externalSalience[i];
      };
    };
    
    // Top-down bias
    for (i in Iter.range(0, numInputs - 1)) {
      if (i < Array.size(topDownSignals)) {
        att.topDownBias[i] := topDownSignals[i];
      };
    };
    
    // Compute focal attention (combination of bottom-up and top-down)
    var maxAttention : Float = 0.0;
    var maxIdx : Nat = 0;
    
    for (i in Iter.range(0, numInputs - 1)) {
      att.focalAttention[i] := 0.6 * att.bottomUpSalience[i] + 0.4 * att.topDownBias[i];
      if (att.focalAttention[i] > maxAttention) {
        maxAttention := att.focalAttention[i];
        maxIdx := i;
      };
    };
    
    att.attentionalSpotlight := maxIdx;
    
    // Global attention level
    att.globalAttention := att.achLevel * (0.5 + 0.5 * att.neLevel);
    
    // Uncertainty estimate
    att.uncertaintyEstimate := 0.9 * att.uncertaintyEstimate + 0.1 * novelty;
  };

  // Compute attentional gating for plasticity
  public func computeAttentionalGating(
    gating : AttentionalGating,
    predictionError : Float,
    noveltySignal : Float
  ) : Float {
    let att = gating.attention;
    
    // Novelty bonus
    if (noveltySignal > ATT_NOVELTY_THRESHOLD) {
      gating.noveltyBonus := 1.0 + noveltySignal;
    } else {
      gating.noveltyBonus := 1.0;
    };
    
    // Prediction error gating
    gating.predictionErrorGating := 1.0 + Float.abs(predictionError);
    
    // Overall plasticity gate
    gating.plasticityGate := att.achLevel * gating.noveltyBonus * gating.predictionErrorGating;
    
    // Per-synapse gating
    let numInputs = Array.size(att.focalAttention);
    for (i in Iter.range(0, numInputs - 1)) {
      let inputAttention = att.focalAttention[i];
      let numOutputs = Array.size(gating.perSynapseGating[i]);
      
      for (j in Iter.range(0, numOutputs - 1)) {
        if (inputAttention > 0.5) {
          // Attended synapses get enhancement
          gating.perSynapseGating[i][j] := gating.attendedEnhancement * inputAttention;
        } else {
          // Unattended get suppression
          gating.perSynapseGating[i][j] := gating.unattendedSuppression * (1.0 - inputAttention);
        };
      };
    };
    
    gating.plasticityGate
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // LAYER 19: ENERGY METABOLISM — ATP-DEPENDENT PROCESSES
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // The brain consumes 20% of body's energy despite being only 2% of mass.
  // Plasticity is energetically expensive — ATP is the currency.
  //
  // 1. ION PUMPS:
  //    - Na⁺/K⁺-ATPase: ~50% of brain energy
  //    - Ca²⁺-ATPase: Calcium clearance
  //    - Essential for maintaining gradients
  //
  // 2. PROTEIN SYNTHESIS:
  //    - Ribosomal translation costs 4 ATP/amino acid
  //    - Late-phase LTP requires massive synthesis
  //    - Energetically gated
  //
  // 3. VESICLE CYCLING:
  //    - Endocytosis and refilling
  //    - ATP-dependent
  //    - Limits sustained transmission
  //
  // 4. METABOLIC COUPLING:
  //    - Astrocyte-neuron lactate shuttle
  //    - Activity-dependent blood flow
  //    - Oxygen sensing
  //

  public type MetabolicState = {
    var atpLevel : Float;                // ATP concentration
    var adpLevel : Float;                // ADP concentration
    var ampLevel : Float;                // AMP concentration
    var adenylateCharge : Float;         // (ATP + 0.5×ADP)/(ATP+ADP+AMP)
    var glucoseLevel : Float;            // Available glucose
    var lactateLevel : Float;            // From astrocytes
    var oxygenLevel : Float;             // Local O2
    var mitochondrialActivity : Float;   // Oxidative phosphorylation
    var glycolyticRate : Float;          // Anaerobic glycolysis
    var metabolicStress : Bool;          // Energy depleted?
  };

  public type EnergeticConstraints = {
    metabolism : MetabolicState;
    var ionPumpCost : Float;             // Energy for Na/K pump
    var synthesisCost : Float;           // Protein synthesis cost
    var vesicleCost : Float;             // Vesicle cycling cost
    var totalEnergyDemand : Float;       // Sum of demands
    var energyAvailable : Float;         // ATP supply
    var energyBalance : Float;           // Supply - Demand
    var plasticityBudget : Float;        // Energy available for plasticity
    var energyLimitedPlasticity : Float; // Actual plasticity possible
  };

  // Metabolic parameters
  public let MET_ATP_BASELINE : Float = 1.0;
  public let MET_ION_PUMP_FRACTION : Float = 0.5;    // 50% goes to pumps
  public let MET_SYNTHESIS_FRACTION : Float = 0.2;   // 20% to protein synthesis
  public let MET_VESICLE_FRACTION : Float = 0.1;     // 10% to vesicles
  public let MET_PLASTICITY_FRACTION : Float = 0.2;  // 20% available for plasticity
  public let MET_STRESS_THRESHOLD : Float = 0.3;     // ATP below this = stress

  public func initMetabolicState() : MetabolicState {
    {
      var atpLevel = MET_ATP_BASELINE;
      var adpLevel = 0.1;
      var ampLevel = 0.01;
      var adenylateCharge = 0.9;
      var glucoseLevel = 1.0;
      var lactateLevel = 0.3;
      var oxygenLevel = 1.0;
      var mitochondrialActivity = 0.8;
      var glycolyticRate = 0.2;
      var metabolicStress = false;
    }
  };

  public func initEnergeticConstraints() : EnergeticConstraints {
    {
      metabolism = initMetabolicState();
      var ionPumpCost = 0.5;
      var synthesisCost = 0.2;
      var vesicleCost = 0.1;
      var totalEnergyDemand = 0.8;
      var energyAvailable = 1.0;
      var energyBalance = 0.2;
      var plasticityBudget = 0.2;
      var energyLimitedPlasticity = 1.0;
    }
  };

  // Update metabolic state
  public func updateMetabolism(
    met : MetabolicState,
    neuralActivity : Float,
    synapticActivity : Float,
    astrocyteLactate : Float,
    bloodFlow : Float,
    dt : Float
  ) {
    // Glucose delivery depends on blood flow
    let glucoseDelivery = bloodFlow * 0.1;
    met.glucoseLevel := 0.95 * met.glucoseLevel + glucoseDelivery * dt;
    met.glucoseLevel := clamp(met.glucoseLevel, 0.0, 2.0);
    
    // Lactate from astrocytes
    met.lactateLevel := 0.9 * met.lactateLevel + 0.1 * astrocyteLactate;
    
    // Oxygen delivery
    let oxygenDelivery = bloodFlow * 0.2;
    met.oxygenLevel := 0.98 * met.oxygenLevel + oxygenDelivery * dt;
    met.oxygenLevel := clamp(met.oxygenLevel, 0.0, 1.5);
    
    // ATP production
    // Mitochondrial: glucose + O2 → 30-32 ATP (oxidative)
    let oxidativeProduction = met.mitochondrialActivity * met.glucoseLevel * met.oxygenLevel * 0.1;
    
    // Glycolytic: glucose → 2 ATP (anaerobic)
    let glycolyticProduction = met.glycolyticRate * met.glucoseLevel * 0.02;
    
    // Lactate utilization
    let lactateProduction = met.lactateLevel * met.oxygenLevel * 0.05;
    
    let totalProduction = oxidativeProduction + glycolyticProduction + lactateProduction;
    
    // ATP consumption
    let activityConsumption = (neuralActivity + synapticActivity) * 0.3;
    let baselineConsumption = 0.05;
    let totalConsumption = activityConsumption + baselineConsumption;
    
    // Update ATP, ADP, AMP
    let dATP = totalProduction - totalConsumption;
    met.atpLevel := clamp(met.atpLevel + dATP * dt, 0.01, 2.0);
    met.adpLevel := clamp(met.adpLevel - dATP * dt * 0.5, 0.01, 1.0);
    met.ampLevel := clamp(met.ampLevel - dATP * dt * 0.1, 0.001, 0.5);
    
    // Adenylate charge
    met.adenylateCharge := (met.atpLevel + 0.5 * met.adpLevel) / 
                           (met.atpLevel + met.adpLevel + met.ampLevel);
    
    // Metabolic stress
    met.metabolicStress := met.atpLevel < MET_STRESS_THRESHOLD;
    
    // Adjust mitochondrial activity based on demand
    if (met.adpLevel > 0.3) {
      met.mitochondrialActivity := Float.min(1.0, met.mitochondrialActivity + 0.01 * dt);
    } else {
      met.mitochondrialActivity := Float.max(0.3, met.mitochondrialActivity - 0.005 * dt);
    };
    
    // Consume glucose
    met.glucoseLevel -= (totalProduction / 30.0) * dt;  // ~30 ATP per glucose
    met.glucoseLevel := Float.max(0.0, met.glucoseLevel);
  };

  // Compute energy-limited plasticity
  public func computeEnergyLimitedPlasticity(
    energy : EnergeticConstraints,
    plasticityDemand : Float,
    neuralActivity : Float,
    synapticActivity : Float,
    astrocyteLactate : Float,
    bloodFlow : Float,
    dt : Float
  ) : Float {
    // Update metabolism
    updateMetabolism(energy.metabolism, neuralActivity, synapticActivity, astrocyteLactate, bloodFlow, dt);
    
    // Compute costs
    energy.ionPumpCost := MET_ION_PUMP_FRACTION * neuralActivity;
    energy.synthesisCost := MET_SYNTHESIS_FRACTION * plasticityDemand;
    energy.vesicleCost := MET_VESICLE_FRACTION * synapticActivity;
    energy.totalEnergyDemand := energy.ionPumpCost + energy.synthesisCost + energy.vesicleCost;
    
    // Available energy
    energy.energyAvailable := energy.metabolism.atpLevel;
    energy.energyBalance := energy.energyAvailable - energy.totalEnergyDemand;
    
    // Plasticity budget
    if (energy.energyBalance > 0.0) {
      energy.plasticityBudget := MET_PLASTICITY_FRACTION * energy.energyBalance;
    } else {
      energy.plasticityBudget := 0.0;  // No energy for plasticity
    };
    
    // Energy-limited plasticity factor
    if (energy.metabolism.metabolicStress) {
      energy.energyLimitedPlasticity := 0.1;  // Minimal plasticity
    } else if (energy.plasticityBudget > plasticityDemand) {
      energy.energyLimitedPlasticity := 1.0;  // Full plasticity
    } else {
      energy.energyLimitedPlasticity := energy.plasticityBudget / plasticityDemand;
    };
    
    energy.energyLimitedPlasticity
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // LAYER 20: CIRCADIAN MODULATION — 24-HOUR PLASTICITY RHYTHMS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Plasticity follows circadian rhythms controlled by the suprachiasmatic nucleus:
  //
  // 1. CLOCK GENES:
  //    - CLOCK, BMAL1, PER, CRY
  //    - Transcriptional feedback loops
  //    - ~24 hour period
  //
  // 2. MELATONIN:
  //    - Released at night
  //    - Suppresses plasticity
  //    - Promotes sleep consolidation
  //
  // 3. CORTISOL:
  //    - Peaks in morning
  //    - Enhances waking plasticity
  //    - Stress-modulated
  //
  // 4. PLASTICITY WINDOWS:
  //    - LTP enhanced during active phase
  //    - LTD enhanced during rest phase
  //    - Matches learning and consolidation
  //

  public type CircadianState = {
    var phase : Float;                   // Circadian phase [0, 24] hours
    var period : Float;                  // Endogenous period (~24.2 hours)
    var amplitude : Float;               // Rhythm strength
    var entrainment : Float;             // Light-dark coupling
    var clockGeneExpression : Float;     // Clock/BMAL1 activity
    var perCryExpression : Float;        // PER/CRY (inhibitory arm)
    var melatoninLevel : Float;          // Melatonin
    var cortisolLevel : Float;           // Cortisol
    var isNightPhase : Bool;             // Night or day?
  };

  public type CircadianPlasticity = {
    circadian : CircadianState;
    var ltpModulation : Float;           // Time-of-day LTP factor
    var ltdModulation : Float;           // Time-of-day LTD factor
    var proteinSynthesisWindow : Bool;   // Optimal for protein synthesis?
    var consolidationWindow : Bool;      // Optimal for consolidation?
    var learningWindow : Bool;           // Optimal for learning?
    var overallCircadianGain : Float;    // Combined modulation
  };

  // Circadian parameters
  public let CIRC_PERIOD : Float = 24.2;          // Endogenous period (hours)
  public let CIRC_MELATONIN_ONSET : Float = 21.0; // 9 PM
  public let CIRC_MELATONIN_OFFSET : Float = 7.0; // 7 AM
  public let CIRC_CORTISOL_PEAK : Float = 8.0;    // 8 AM
  public let CIRC_LTP_PEAK : Float = 14.0;        // 2 PM
  public let CIRC_LTD_PEAK : Float = 2.0;         // 2 AM

  public func initCircadianState() : CircadianState {
    {
      var phase = 12.0;  // Noon
      var period = CIRC_PERIOD;
      var amplitude = 0.8;
      var entrainment = 0.9;
      var clockGeneExpression = 0.5;
      var perCryExpression = 0.5;
      var melatoninLevel = 0.0;
      var cortisolLevel = 0.5;
      var isNightPhase = false;
    }
  };

  public func initCircadianPlasticity() : CircadianPlasticity {
    {
      circadian = initCircadianState();
      var ltpModulation = 1.0;
      var ltdModulation = 1.0;
      var proteinSynthesisWindow = false;
      var consolidationWindow = false;
      var learningWindow = true;
      var overallCircadianGain = 1.0;
    }
  };

  // Update circadian clock
  public func updateCircadianClock(circ : CircadianState, lightLevel : Float, dtHours : Float) {
    // Phase advance
    circ.phase += dtHours / circ.period * 24.0;
    if (circ.phase >= 24.0) {
      circ.phase -= 24.0;
    };
    
    // Light entrainment (phase response curve)
    let lightPRC = sin(circ.phase / 24.0 * 2.0 * PI);  // Simplified PRC
    circ.phase += circ.entrainment * lightLevel * lightPRC * 0.1 * dtHours;
    
    // Clock gene expression (peaks in day)
    circ.clockGeneExpression := 0.5 + 0.5 * cos((circ.phase - 6.0) / 24.0 * 2.0 * PI);
    
    // PER/CRY expression (peaks ~12 hours later)
    circ.perCryExpression := 0.5 + 0.5 * cos((circ.phase - 18.0) / 24.0 * 2.0 * PI);
    
    // Melatonin (high at night)
    if (circ.phase > CIRC_MELATONIN_ONSET or circ.phase < CIRC_MELATONIN_OFFSET) {
      circ.melatoninLevel := 0.9 * circ.melatoninLevel + 0.1;
      circ.isNightPhase := true;
    } else {
      circ.melatoninLevel := 0.9 * circ.melatoninLevel;
      circ.isNightPhase := false;
    };
    
    // Cortisol (peaks in morning)
    let cortisolPeak = cos((circ.phase - CIRC_CORTISOL_PEAK) / 24.0 * 2.0 * PI);
    circ.cortisolLevel := 0.3 + 0.4 * Float.max(0.0, cortisolPeak);
    
    // Amplitude (can be affected by jet lag, etc.)
    circ.amplitude := 0.999 * circ.amplitude + 0.001 * Float.abs(circ.clockGeneExpression - circ.perCryExpression);
  };

  // Compute circadian modulation of plasticity
  public func computeCircadianPlasticity(
    cp : CircadianPlasticity,
    lightLevel : Float,
    dtHours : Float
  ) {
    updateCircadianClock(cp.circadian, lightLevel, dtHours);
    
    let phase = cp.circadian.phase;
    let amplitude = cp.circadian.amplitude;
    
    // LTP modulation (peaks in afternoon)
    let ltpPeakDist = Float.abs(phase - CIRC_LTP_PEAK);
    cp.ltpModulation := 1.0 + 0.5 * amplitude * exp(-ltpPeakDist * ltpPeakDist / 20.0);
    
    // LTD modulation (peaks at night)
    let ltdPeakDist = Float.abs(phase - CIRC_LTD_PEAK);
    cp.ltdModulation := 1.0 + 0.5 * amplitude * exp(-ltdPeakDist * ltdPeakDist / 20.0);
    
    // Windows
    cp.learningWindow := not cp.circadian.isNightPhase;
    cp.consolidationWindow := cp.circadian.isNightPhase;
    cp.proteinSynthesisWindow := phase > 10.0 and phase < 18.0;  // Mid-day
    
    // Overall circadian gain
    if (cp.learningWindow) {
      cp.overallCircadianGain := cp.ltpModulation * (1.0 + cp.circadian.cortisolLevel);
    } else {
      cp.overallCircadianGain := cp.ltdModulation * (1.0 - 0.5 * cp.circadian.melatoninLevel);
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // LAYER 21: STRESS HORMONES — GLUCOCORTICOID EFFECTS ON PLASTICITY
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Stress profoundly modulates plasticity through glucocorticoids (GCs):
  //
  // 1. ACUTE STRESS:
  //    - Rapid enhancement of emotional memory (amygdala)
  //    - Enhanced consolidation in first hours
  //    - Norepinephrine + cortisol synergy
  //
  // 2. CHRONIC STRESS:
  //    - Hippocampal atrophy
  //    - Impaired LTP
  //    - Dendritic retraction
  //    - Neurogenesis suppression
  //
  // 3. RECEPTOR DYNAMICS:
  //    - MR (mineralocorticoid): High affinity, tonic
  //    - GR (glucocorticoid): Low affinity, phasic
  //    - MR/GR balance determines effect
  //
  // 4. GENOMIC vs NON-GENOMIC:
  //    - Fast effects (seconds): membrane receptors
  //    - Slow effects (hours): gene transcription
  //

  public type StressHormoneState = {
    var corticosterone : Float;          // Rodent cortisol analog
    var norepinephrine : Float;          // Stress catecholamine
    var crh : Float;                     // CRH from hypothalamus
    var acth : Float;                    // ACTH from pituitary
    var mrOccupancy : Float;             // Mineralocorticoid receptor
    var grOccupancy : Float;             // Glucocorticoid receptor
    var mrGrRatio : Float;               // Balance determines effect
    var stressLevel : Float;             // Overall stress
    var chronicStress : Float;           // Accumulated stress
    var stressRecovery : Float;          // Recovery rate
  };

  public type StressPlasticity = {
    stress : StressHormoneState;
    var acuteEnhancement : Float;        // Acute stress boost
    var chronicImpairment : Float;       // Chronic stress suppression
    var emotionalEnhancement : Float;    // Amygdala enhancement
    var hippocampalEffect : Float;       // HPC effect (context-dependent)
    var prefrontalEffect : Float;        // PFC effect
    var overallStressModulation : Float; // Net effect
    var isAcuteStress : Bool;            // In acute response?
    var isChronicStress : Bool;          // Chronic state?
  };

  // Stress parameters
  public let STRESS_CORT_BASELINE : Float = 0.2;
  public let STRESS_CORT_ACUTE_PEAK : Float = 2.0;
  public let STRESS_MR_KD : Float = 0.1;          // MR high affinity
  public let STRESS_GR_KD : Float = 1.0;          // GR low affinity
  public let STRESS_CHRONIC_THRESHOLD : Float = 0.5;
  public let STRESS_RECOVERY_TAU : Float = 3600000.0;  // ~1 hour

  public func initStressHormoneState() : StressHormoneState {
    {
      var corticosterone = STRESS_CORT_BASELINE;
      var norepinephrine = 0.3;
      var crh = 0.2;
      var acth = 0.2;
      var mrOccupancy = 0.8;  // MR ~80% occupied at baseline
      var grOccupancy = 0.2;  // GR ~20% at baseline
      var mrGrRatio = 4.0;
      var stressLevel = 0.2;
      var chronicStress = 0.0;
      var stressRecovery = 1.0;
    }
  };

  public func initStressPlasticity() : StressPlasticity {
    {
      stress = initStressHormoneState();
      var acuteEnhancement = 1.0;
      var chronicImpairment = 1.0;
      var emotionalEnhancement = 1.0;
      var hippocampalEffect = 1.0;
      var prefrontalEffect = 1.0;
      var overallStressModulation = 1.0;
      var isAcuteStress = false;
      var isChronicStress = false;
    }
  };

  // Update stress hormones
  public func updateStressHormones(
    stress : StressHormoneState,
    stressor : Float,              // Current stressor intensity
    novelty : Float,               // Novel stress vs familiar
    controllability : Float,       // Controllable vs uncontrollable
    dt : Float
  ) {
    // CRH release from PVN (hypothalamus)
    stress.crh := 0.9 * stress.crh + 0.1 * stressor * (1.0 + novelty);
    
    // ACTH release from pituitary
    stress.acth := 0.95 * stress.acth + 0.05 * stress.crh;
    
    // Corticosterone release from adrenals
    let cortRelease = stress.acth * (1.0 + 0.5 * stress.norepinephrine);
    stress.corticosterone := 0.98 * stress.corticosterone + 0.02 * cortRelease;
    stress.corticosterone := clamp(stress.corticosterone, 0.05, STRESS_CORT_ACUTE_PEAK);
    
    // Norepinephrine (fast response)
    stress.norepinephrine := 0.85 * stress.norepinephrine + 0.15 * stressor;
    
    // Receptor occupancy (Hill equation)
    let cort = stress.corticosterone;
    stress.mrOccupancy := cort / (STRESS_MR_KD + cort);
    stress.grOccupancy := cort / (STRESS_GR_KD + cort);
    stress.mrGrRatio := (stress.mrOccupancy + 0.01) / (stress.grOccupancy + 0.01);
    
    // Overall stress level
    stress.stressLevel := (stress.corticosterone + stress.norepinephrine) / 2.0;
    
    // Chronic stress accumulation
    if (stress.stressLevel > STRESS_CHRONIC_THRESHOLD) {
      stress.chronicStress += 0.001 * (stress.stressLevel - STRESS_CHRONIC_THRESHOLD) * dt;
    } else {
      stress.chronicStress := Float.max(0.0, stress.chronicStress - 0.0001 * dt);
    };
    
    // Recovery (depends on controllability)
    stress.stressRecovery := 0.99 * stress.stressRecovery + 0.01 * controllability;
  };

  // Compute stress modulation of plasticity
  public func computeStressPlasticity(
    sp : StressPlasticity,
    stressor : Float,
    novelty : Float,
    controllability : Float,
    emotionalContent : Float,
    dt : Float
  ) {
    updateStressHormones(sp.stress, stressor, novelty, controllability, dt);
    
    // Determine stress state
    sp.isAcuteStress := sp.stress.stressLevel > 0.5 and sp.stress.chronicStress < 0.3;
    sp.isChronicStress := sp.stress.chronicStress > STRESS_CHRONIC_THRESHOLD;
    
    // Acute stress effects
    if (sp.isAcuteStress) {
      // Enhanced emotional memory
      sp.emotionalEnhancement := 1.0 + emotionalContent * sp.stress.norepinephrine * sp.stress.corticosterone;
      
      // Hippocampal enhancement (acute only)
      sp.hippocampalEffect := 1.0 + 0.5 * sp.stress.mrOccupancy;
      
      sp.acuteEnhancement := sp.emotionalEnhancement;
    } else {
      sp.emotionalEnhancement := 1.0;
      sp.acuteEnhancement := 1.0;
      sp.hippocampalEffect := 1.0;
    };
    
    // Chronic stress effects
    if (sp.isChronicStress) {
      // Hippocampal impairment
      sp.hippocampalEffect := 1.0 - 0.5 * sp.stress.chronicStress;
      
      // PFC impairment
      sp.prefrontalEffect := 1.0 - 0.3 * sp.stress.chronicStress;
      
      sp.chronicImpairment := 1.0 - 0.5 * sp.stress.chronicStress;
    } else {
      sp.prefrontalEffect := 1.0;
      sp.chronicImpairment := 1.0;
    };
    
    // Overall modulation
    sp.overallStressModulation := sp.acuteEnhancement * sp.chronicImpairment;
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // LAYER 22: SLEEP-DEPENDENT PLASTICITY — REPLAY AND CONSOLIDATION
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Sleep is critical for memory consolidation through distinct mechanisms:
  //
  // 1. NREM SLEEP:
  //    - Slow oscillations (0.5-1 Hz)
  //    - Sleep spindles (12-15 Hz)
  //    - Sharp-wave ripples during UP states
  //    - Systems consolidation (HPC → cortex)
  //
  // 2. REM SLEEP:
  //    - Theta rhythm
  //    - Synaptic consolidation
  //    - Emotional memory processing
  //    - Pruning of weak synapses
  //
  // 3. REPLAY:
  //    - Reactivation of waking patterns
  //    - ~20x time compression
  //    - Bidirectional (forward and reverse)
  //
  // 4. SYNAPTIC HOMEOSTASIS:
  //    - Wake = net strengthening
  //    - Sleep = net downscaling
  //    - Preserves signal while clearing noise
  //

  public type SleepState = {
    var stage : Nat;                     // 0=wake, 1=N1, 2=N2, 3=N3, 4=REM
    var depth : Float;                   // Sleep depth
    var slowOscillationPhase : Float;    // SO phase
    var slowOscillationPower : Float;    // SO power
    var spindlePower : Float;            // Sleep spindle power
    var thetaPower : Float;              // REM theta
    var homeostasisPressure : Float;     // Sleep pressure (adenosine)
    var sleepDuration : Float;           // Time asleep (ms)
    var cycleCount : Nat;                // NREM-REM cycles
    var isInUpState : Bool;              // SO UP state?
  };

  public type SleepPlasticity = {
    sleep : SleepState;
    var nremConsolidation : Float;       // NREM consolidation rate
    var remConsolidation : Float;        // REM consolidation rate
    var replayActivity : Float;          // Current replay strength
    var replayPattern : [var Float];     // Pattern being replayed
    var spindleTriggeredLTP : Float;     // Spindle-induced LTP
    var synapticDownscaling : Float;     // Homeostatic factor
    var overallSleepPlasticity : Float;  // Net plasticity
  };

  // Sleep parameters
  public let SLEEP_SO_FREQ : Float = 0.8;         // Slow oscillation Hz
  public let SLEEP_SPINDLE_FREQ : Float = 13.0;   // Sleep spindle Hz
  public let SLEEP_THETA_FREQ : Float = 6.0;      // REM theta Hz
  public let SLEEP_CYCLE_DURATION : Float = 5400000.0;  // ~90 min cycle
  public let SLEEP_REPLAY_COMPRESSION : Float = 20.0;   // 20x compression

  public func initSleepState() : SleepState {
    {
      var stage = 0;          // Awake
      var depth = 0.0;
      var slowOscillationPhase = 0.0;
      var slowOscillationPower = 0.0;
      var spindlePower = 0.0;
      var thetaPower = 0.0;
      var homeostasisPressure = 0.0;
      var sleepDuration = 0.0;
      var cycleCount = 0;
      var isInUpState = false;
    }
  };

  public func initSleepPlasticity() : SleepPlasticity {
    {
      sleep = initSleepState();
      var nremConsolidation = 0.0;
      var remConsolidation = 0.0;
      var replayActivity = 0.0;
      var replayPattern = Array.init<Float>(12, func(_ : Nat) : Float { 0.0 });
      var spindleTriggeredLTP = 0.0;
      var synapticDownscaling = 1.0;
      var overallSleepPlasticity = 1.0;
    }
  };

  // Update sleep state
  public func updateSleepState(
    sleep : SleepState,
    isAsleep : Bool,
    adenosineLevel : Float,
    melatoninLevel : Float,
    dt : Float
  ) {
    // Homeostasis pressure accumulates while awake
    if (not isAsleep) {
      sleep.homeostasisPressure := sleep.homeostasisPressure + adenosineLevel * 0.001 * dt;
      sleep.stage := 0;
      sleep.depth := 0.0;
      sleep.slowOscillationPower := 0.0;
      sleep.spindlePower := 0.0;
      sleep.thetaPower := 0.0;
      return;
    };
    
    sleep.sleepDuration += dt;
    
    // Determine sleep stage based on time in sleep
    let timeInCycle = Float.fmod(sleep.sleepDuration, SLEEP_CYCLE_DURATION);
    let cycleProgress = timeInCycle / SLEEP_CYCLE_DURATION;
    
    if (cycleProgress < 0.1) {
      sleep.stage := 1;  // N1
      sleep.depth := 0.2;
    } else if (cycleProgress < 0.3) {
      sleep.stage := 2;  // N2
      sleep.depth := 0.5;
      sleep.spindlePower := 0.5 + 0.3 * sin(sleep.sleepDuration / 1000.0 * SLEEP_SPINDLE_FREQ);
    } else if (cycleProgress < 0.6) {
      sleep.stage := 3;  // N3 (deep)
      sleep.depth := 0.9;
      sleep.slowOscillationPower := 0.8;
      sleep.spindlePower := 0.3;
    } else if (cycleProgress < 0.75) {
      sleep.stage := 2;  // N2 again
      sleep.depth := 0.5;
      sleep.spindlePower := 0.5;
    } else {
      sleep.stage := 4;  // REM
      sleep.depth := 0.4;
      sleep.thetaPower := 0.7;
      sleep.slowOscillationPower := 0.1;
    };
    
    // Slow oscillation phase
    if (sleep.stage == 3 or sleep.stage == 2) {
      sleep.slowOscillationPhase += SLEEP_SO_FREQ * dt / 1000.0 * 2.0 * PI;
      if (sleep.slowOscillationPhase > 2.0 * PI) {
        sleep.slowOscillationPhase -= 2.0 * PI;
      };
      sleep.isInUpState := cos(sleep.slowOscillationPhase) > 0.0;
    } else {
      sleep.isInUpState := false;
    };
    
    // Dissipate sleep pressure during sleep
    sleep.homeostasisPressure := Float.max(0.0, sleep.homeostasisPressure - 0.0001 * sleep.depth * dt);
    
    // Count cycles
    if (timeInCycle < dt) {
      sleep.cycleCount += 1;
    };
  };

  // Compute sleep-dependent plasticity
  public func computeSleepPlasticity(
    sp : SleepPlasticity,
    isAsleep : Bool,
    adenosineLevel : Float,
    melatoninLevel : Float,
    memoryPatterns : [[Float]],
    wakingStrengthening : Float,
    dt : Float
  ) {
    updateSleepState(sp.sleep, isAsleep, adenosineLevel, melatoninLevel, dt);
    
    if (not isAsleep) {
      sp.nremConsolidation := 0.0;
      sp.remConsolidation := 0.0;
      sp.replayActivity := 0.0;
      sp.spindleTriggeredLTP := 0.0;
      
      // Synaptic strengthening during wake
      sp.synapticDownscaling := 1.0 + wakingStrengthening * 0.001;
      sp.overallSleepPlasticity := 1.0;
      return;
    };
    
    let stage = sp.sleep.stage;
    
    // NREM consolidation
    if (stage == 2 or stage == 3) {
      sp.nremConsolidation := 0.1 * sp.sleep.depth * sp.sleep.slowOscillationPower;
      
      // Spindle-triggered LTP during UP states
      if (sp.sleep.isInUpState and sp.sleep.spindlePower > 0.3) {
        sp.spindleTriggeredLTP := 0.05 * sp.sleep.spindlePower;
      } else {
        sp.spindleTriggeredLTP := 0.0;
      };
      
      // Replay during ripples (UP states)
      if (sp.sleep.isInUpState) {
        sp.replayActivity := 0.3;
        // Select a pattern to replay
        if (Array.size(memoryPatterns) > 0) {
          let patternIdx = Int.abs(Float.toInt(sp.sleep.sleepDuration)) % Array.size(memoryPatterns);
          let pattern = memoryPatterns[patternIdx];
          let patternSize = Nat.min(Array.size(pattern), 12);
          for (i in Iter.range(0, patternSize - 1)) {
            sp.replayPattern[i] := pattern[i];
          };
        };
      } else {
        sp.replayActivity := 0.0;
      };
    };
    
    // REM consolidation
    if (stage == 4) {
      sp.remConsolidation := 0.08 * sp.sleep.thetaPower;
      sp.nremConsolidation := 0.0;
      sp.spindleTriggeredLTP := 0.0;
      
      // Synaptic downscaling during REM
      sp.synapticDownscaling := 0.999;  // Gradual downscaling
    };
    
    // Overall sleep plasticity
    sp.overallSleepPlasticity := sp.nremConsolidation + sp.remConsolidation + sp.spindleTriggeredLTP;
  };


  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // LAYER 23: CRITICAL PERIODS — DEVELOPMENTAL PLASTICITY WINDOWS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Early in development, plasticity is enhanced during "critical periods":
  //
  // 1. VISUAL CORTEX CRITICAL PERIOD:
  //    - Ocular dominance plasticity
  //    - Opens with sensory experience
  //    - Closes with PNN formation
  //
  // 2. MOLECULAR BRAKES:
  //    - PNNs (perineuronal nets) — physical barrier
  //    - Myelin — molecular stop signal
  //    - PV interneuron maturation
  //
  // 3. REOPENING PLASTICITY:
  //    - Remove PNNs (ChABC enzyme)
  //    - HDAC inhibitors
  //    - Antidepressants (fluoxetine)
  //    - Dark rearing / sensory deprivation
  //
  // 4. ORGANISM RELEVANCE:
  //    - First Breath = critical period opening
  //    - Identity shells form during critical period
  //    - After closure, only incremental change
  //

  public type CriticalPeriodState = {
    var periodOpen : Bool;               // Is CP currently open?
    var periodAge : Float;               // Time since period opened
    var pnnDensity : Float;              // Perineuronal net density
    var myelinLevel : Float;             // Myelination level
    var pvMaturity : Float;              // PV interneuron maturity
    var plasticityPotential : Float;     // Current plasticity capacity
    var closureThreshold : Float;        // When period closes
    var experienceAccumulated : Float;   // Total experience
    var reopeningFactor : Float;         // Intervention effects
  };

  public type CriticalPeriodPlasticity = {
    cp : CriticalPeriodState;
    var cpEnhancement : Float;           // CP plasticity boost
    var adultPlasticity : Float;         // Post-CP baseline
    var experienceBonus : Float;         // Experience-dependent bonus
    var pharmacologicalBonus : Float;    // Drug-induced reopening
    var overallCPModulation : Float;     // Combined effect
    var isInCriticalPeriod : Bool;       // Currently in CP?
    var firstBreathSealed : Bool;        // Organism-specific marker
  };

  // Critical period parameters
  public let CP_DURATION : Float = 86400000.0 * 30.0;  // ~30 days
  public let CP_PNN_CLOSURE_THRESHOLD : Float = 0.8;
  public let CP_MYELIN_CLOSURE_THRESHOLD : Float = 0.7;
  public let CP_ADULT_PLASTICITY : Float = 0.3;
  public let CP_ENHANCEMENT_FACTOR : Float = 3.0;

  public func initCriticalPeriodState() : CriticalPeriodState {
    {
      var periodOpen = true;
      var periodAge = 0.0;
      var pnnDensity = 0.0;
      var myelinLevel = 0.0;
      var pvMaturity = 0.0;
      var plasticityPotential = 1.0;
      var closureThreshold = CP_DURATION;
      var experienceAccumulated = 0.0;
      var reopeningFactor = 0.0;
    }
  };

  public func initCriticalPeriodPlasticity() : CriticalPeriodPlasticity {
    {
      cp = initCriticalPeriodState();
      var cpEnhancement = CP_ENHANCEMENT_FACTOR;
      var adultPlasticity = CP_ADULT_PLASTICITY;
      var experienceBonus = 0.0;
      var pharmacologicalBonus = 0.0;
      var overallCPModulation = CP_ENHANCEMENT_FACTOR;
      var isInCriticalPeriod = true;
      var firstBreathSealed = false;
    }
  };

  // Update critical period state
  public func updateCriticalPeriod(
    cp : CriticalPeriodState,
    experienceInput : Float,
    sensoryDeprivation : Bool,
    pharmacologicalIntervention : Float,
    dt : Float
  ) {
    if (cp.periodOpen) {
      cp.periodAge += dt;
      cp.experienceAccumulated += experienceInput * dt;
      
      // PNN development (experience-dependent)
      if (not sensoryDeprivation) {
        cp.pnnDensity += 0.00001 * experienceInput * dt;
      };
      
      // Myelination (age-dependent)
      cp.myelinLevel += 0.000005 * dt;
      
      // PV interneuron maturation
      cp.pvMaturity += 0.000003 * (1.0 + experienceInput) * dt;
      
      // Check for closure
      if (cp.pnnDensity > CP_PNN_CLOSURE_THRESHOLD or 
          cp.myelinLevel > CP_MYELIN_CLOSURE_THRESHOLD or
          cp.periodAge > cp.closureThreshold) {
        cp.periodOpen := false;
      };
    } else {
      // Period closed — check for reopening
      cp.reopeningFactor := pharmacologicalIntervention;
      
      if (sensoryDeprivation) {
        cp.reopeningFactor += 0.2;
      };
      
      // Partial reopening
      if (cp.reopeningFactor > 0.5) {
        cp.plasticityPotential := CP_ADULT_PLASTICITY + 
                                   (1.0 - CP_ADULT_PLASTICITY) * cp.reopeningFactor;
      } else {
        cp.plasticityPotential := CP_ADULT_PLASTICITY;
      };
    };
    
    // Clamp values
    cp.pnnDensity := clamp(cp.pnnDensity, 0.0, 1.0);
    cp.myelinLevel := clamp(cp.myelinLevel, 0.0, 1.0);
    cp.pvMaturity := clamp(cp.pvMaturity, 0.0, 1.0);
  };

  // Compute critical period plasticity modulation
  public func computeCriticalPeriodPlasticity(
    cpp : CriticalPeriodPlasticity,
    experienceInput : Float,
    sensoryDeprivation : Bool,
    pharmacologicalIntervention : Float,
    firstBreathOccurred : Bool,
    dt : Float
  ) {
    // Track first breath (organism-specific)
    if (firstBreathOccurred and not cpp.firstBreathSealed) {
      cpp.firstBreathSealed := true;
      cpp.cp.periodOpen := true;  // Opens critical period
      cpp.cp.periodAge := 0.0;
    };
    
    updateCriticalPeriod(cpp.cp, experienceInput, sensoryDeprivation, pharmacologicalIntervention, dt);
    
    cpp.isInCriticalPeriod := cpp.cp.periodOpen;
    
    if (cpp.isInCriticalPeriod) {
      cpp.cpEnhancement := CP_ENHANCEMENT_FACTOR;
      cpp.experienceBonus := experienceInput * 0.5;
      cpp.overallCPModulation := cpp.cpEnhancement + cpp.experienceBonus;
    } else {
      cpp.cpEnhancement := 1.0;
      cpp.pharmacologicalBonus := pharmacologicalIntervention * 0.5;
      cpp.overallCPModulation := cpp.cp.plasticityPotential + cpp.pharmacologicalBonus;
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // LAYER 24: MULTISYNAPTIC RULES — HETEROSYNAPTIC INTERACTIONS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Synapses don't exist in isolation — they interact:
  //
  // 1. HETEROSYNAPTIC LTD:
  //    - Strong LTP at one synapse → LTD at neighbors
  //    - Competition for resources
  //    - Normalization of total weight
  //
  // 2. SYNAPTIC CLUSTERING:
  //    - Co-active synapses on same branch strengthen together
  //    - Nonlinear summation
  //    - Branch-specific plasticity
  //
  // 3. GLOBAL SIGNALS:
  //    - Neuromodulators affect all synapses
  //    - Somatic action potential affects all
  //    - But local signals can override
  //
  // 4. COOPERATIVE/COMPETITIVE DYNAMICS:
  //    - Multiple weak inputs can cooperate
  //    - Strong input can win competition
  //    - Complex interaction patterns
  //

  public type SynapticCluster = {
    var synapseIndices : [var Nat];      // Synapses in this cluster
    var branchId : Nat;                  // Dendritic branch
    var clusterActivity : Float;         // Combined activity
    var clusterStrength : Float;         // Average weight
    var cooperativity : Float;           // Cooperative boost
    var isActive : Bool;                 // Currently active?
  };

  public type HeterosynapticState = {
    var neighborWeights : [[var Float]]; // Weights of neighbors
    var localCompetition : Float;        // Competition within cluster
    var globalNormalization : Float;     // Global weight sum target
    var currentWeightSum : Float;        // Current total weight
    var heteroLTD : Float;               // Heterosynaptic LTD factor
    var cooperativeBoost : Float;        // Cooperative LTP
    var clusters : [var SynapticCluster];// Synaptic clusters
  };

  public type MultisynapticRules = {
    heterosynaptic : HeterosynapticState;
    var homosynapticChange : Float;      // Traditional Hebbian
    var heterosynapticChange : Float;    // Neighbor effects
    var clusterEffect : Float;           // Cluster effects
    var normalizationFactor : Float;     // Weight normalization
    var netMultisynapticChange : Float;  // Combined change
  };

  // Heterosynaptic parameters
  public let HETERO_COMPETITION_RANGE : Float = 5.0;   // μm
  public let HETERO_NORM_TARGET : Float = 1.0;         // Target weight sum
  public let HETERO_COOP_THRESHOLD : Nat = 3;          // Synapses for cooperation
  public let HETERO_LTD_FACTOR : Float = 0.3;          // Hetero LTD strength

  public func initSynapticCluster(branch : Nat) : SynapticCluster {
    {
      var synapseIndices = Array.init<Nat>(5, func(_ : Nat) : Nat { 0 });
      var branchId = branch;
      var clusterActivity = 0.0;
      var clusterStrength = 0.0;
      var cooperativity = 0.0;
      var isActive = false;
    }
  };

  public func initHeterosynapticState(numSynapses : Nat, numClusters : Nat) : HeterosynapticState {
    {
      var neighborWeights = Array.init<[var Float]>(numSynapses, func(_ : Nat) : [var Float] {
        Array.init<Float>(5, func(_ : Nat) : Float { 0.5 })  // 5 neighbors max
      });
      var localCompetition = 0.0;
      var globalNormalization = HETERO_NORM_TARGET;
      var currentWeightSum = 0.5 * Float.fromInt(numSynapses);
      var heteroLTD = 0.0;
      var cooperativeBoost = 0.0;
      var clusters = Array.init<SynapticCluster>(numClusters, func(i : Nat) : SynapticCluster {
        initSynapticCluster(i)
      });
    }
  };

  public func initMultisynapticRules(numSynapses : Nat) : MultisynapticRules {
    {
      heterosynaptic = initHeterosynapticState(numSynapses, 8);  // 8 clusters
      var homosynapticChange = 0.0;
      var heterosynapticChange = 0.0;
      var clusterEffect = 0.0;
      var normalizationFactor = 1.0;
      var netMultisynapticChange = 0.0;
    }
  };

  // Update heterosynaptic interactions
  public func updateHeterosynaptic(
    hetero : HeterosynapticState,
    synapseIdx : Nat,
    thisLTP : Float,               // LTP at this synapse
    allWeights : [Float],          // All synaptic weights
    allActivities : [Float],       // All synaptic activities
    dt : Float
  ) {
    // Compute current weight sum
    var weightSum : Float = 0.0;
    for (w in allWeights.vals()) {
      weightSum += w;
    };
    hetero.currentWeightSum := weightSum;
    
    // Heterosynaptic LTD — strong LTP here causes LTD at neighbors
    if (thisLTP > 0.1) {
      hetero.heteroLTD := HETERO_LTD_FACTOR * thisLTP;
    } else {
      hetero.heteroLTD *= 0.9;  // Decay
    };
    
    // Local competition
    let numSynapses = Array.size(allActivities);
    var activeCount : Nat = 0;
    for (a in allActivities.vals()) {
      if (a > 0.5) { activeCount += 1 };
    };
    hetero.localCompetition := Float.fromInt(activeCount) / Float.fromInt(numSynapses);
    
    // Check for cooperative activation in clusters
    hetero.cooperativeBoost := 0.0;
    let numClusters = Array.size(hetero.clusters);
    for (c in Iter.range(0, numClusters - 1)) {
      let cluster = hetero.clusters[c];
      var clusterActiveCount : Nat = 0;
      var clusterActivitySum : Float = 0.0;
      
      for (i in Iter.range(0, 4)) {  // Up to 5 synapses per cluster
        let idx = cluster.synapseIndices[i];
        if (idx < numSynapses and allActivities[idx] > 0.3) {
          clusterActiveCount += 1;
          clusterActivitySum += allActivities[idx];
        };
      };
      
      cluster.clusterActivity := clusterActivitySum;
      cluster.isActive := clusterActiveCount >= HETERO_COOP_THRESHOLD;
      
      if (cluster.isActive) {
        cluster.cooperativity := Float.fromInt(clusterActiveCount) * 0.2;
        hetero.cooperativeBoost := Float.max(hetero.cooperativeBoost, cluster.cooperativity);
      };
    };
  };

  // Compute multisynaptic weight change
  public func computeMultisynapticChange(
    rules : MultisynapticRules,
    synapseIdx : Nat,
    homoLTP : Float,               // Standard Hebbian
    allWeights : [Float],
    allActivities : [Float],
    dt : Float
  ) : Float {
    rules.homosynapticChange := homoLTP;
    
    updateHeterosynaptic(rules.heterosynaptic, synapseIdx, homoLTP, allWeights, allActivities, dt);
    
    // Heterosynaptic change (negative for neighbors of potentiated synapse)
    rules.heterosynapticChange := -rules.heterosynaptic.heteroLTD;
    
    // Cluster effect
    rules.clusterEffect := rules.heterosynaptic.cooperativeBoost;
    
    // Weight normalization
    let targetSum = rules.heterosynaptic.globalNormalization * Float.fromInt(Array.size(allWeights));
    let currentSum = rules.heterosynaptic.currentWeightSum;
    rules.normalizationFactor := targetSum / (currentSum + 0.001);
    
    // Combined change
    rules.netMultisynapticChange := (rules.homosynapticChange + rules.clusterEffect) * 
                                     rules.normalizationFactor + 
                                     rules.heterosynapticChange;
    
    rules.netMultisynapticChange
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // LAYER 25: INTRINSIC PLASTICITY — NON-SYNAPTIC CHANGES
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Not all plasticity is synaptic — neurons can change their intrinsic properties:
  //
  // 1. EXCITABILITY CHANGES:
  //    - Resting potential shifts
  //    - Input resistance changes
  //    - Action potential threshold
  //
  // 2. ION CHANNEL PLASTICITY:
  //    - HCN channel (h-current) regulation
  //    - K⁺ channel expression
  //    - Na⁺ channel availability
  //
  // 3. SPIKE FREQUENCY ADAPTATION:
  //    - Changes in AHP currents
  //    - Burst propensity
  //    - Firing rate gain
  //
  // 4. DENDRITIC EXCITABILITY:
  //    - A-type K⁺ channel distribution
  //    - Backpropagation efficiency
  //    - Local spike threshold
  //

  public type IntrinsicState = {
    var restingPotential : Float;        // V_rest (mV)
    var inputResistance : Float;         // R_in (MΩ)
    var spikeThreshold : Float;          // V_thresh (mV)
    var membraneCapacitance : Float;     // C_m (pF)
    var timeConstant : Float;            // τ_m = R_in × C_m
    var ahpAmplitude : Float;            // After-hyperpolarization
    var ahpDuration : Float;             // AHP decay time
    var firingRateGain : Float;          // f-I slope
    var burstPropensity : Float;         // Tendency to burst
  };

  public type IonChannelState = {
    var hcnConductance : Float;          // HCN (I_h)
    var kdrConductance : Float;          // Delayed rectifier K⁺
    var kaConductance : Float;           // A-type K⁺
    var skConductance : Float;           // SK (Ca²⁺-activated K⁺)
    var navAvailability : Float;         // Na⁺ channel availability
    var caconductance : Float;           // Ca²⁺ channel
    var channelPlasticity : Float;       // Overall change rate
  };

  public type IntrinsicPlasticity = {
    intrinsic : IntrinsicState;
    channels : IonChannelState;
    var excitabilityChange : Float;      // Net excitability change
    var thresholdShift : Float;          // Threshold plasticity
    var gainModulation : Float;          // Gain change
    var homeostasticTarget : Float;      // Target firing rate
    var actualFiringRate : Float;        // Observed rate
    var intrinsicLearningRate : Float;   // Plasticity rate
    var overallIntrinsicPlasticity : Float;
  };

  // Intrinsic plasticity parameters
  public let INTR_V_REST_BASELINE : Float = -70.0;
  public let INTR_V_THRESH_BASELINE : Float = -55.0;
  public let INTR_TARGET_RATE : Float = 5.0;          // Hz
  public let INTR_LEARNING_RATE : Float = 0.001;
  public let INTR_MAX_THRESH_SHIFT : Float = 10.0;    // mV

  public func initIntrinsicState() : IntrinsicState {
    {
      var restingPotential = INTR_V_REST_BASELINE;
      var inputResistance = 100.0;  // MΩ
      var spikeThreshold = INTR_V_THRESH_BASELINE;
      var membraneCapacitance = 100.0;  // pF
      var timeConstant = 10.0;  // ms
      var ahpAmplitude = 5.0;  // mV
      var ahpDuration = 50.0;  // ms
      var firingRateGain = 1.0;
      var burstPropensity = 0.2;
    }
  };

  public func initIonChannelState() : IonChannelState {
    {
      var hcnConductance = 0.5;
      var kdrConductance = 1.0;
      var kaConductance = 0.5;
      var skConductance = 0.3;
      var navAvailability = 1.0;
      var caconductance = 0.5;
      var channelPlasticity = 0.01;
    }
  };

  public func initIntrinsicPlasticity() : IntrinsicPlasticity {
    {
      intrinsic = initIntrinsicState();
      channels = initIonChannelState();
      var excitabilityChange = 0.0;
      var thresholdShift = 0.0;
      var gainModulation = 1.0;
      var homeostasticTarget = INTR_TARGET_RATE;
      var actualFiringRate = INTR_TARGET_RATE;
      var intrinsicLearningRate = INTR_LEARNING_RATE;
      var overallIntrinsicPlasticity = 1.0;
    }
  };

  // Update intrinsic properties based on activity
  public func updateIntrinsicPlasticity(
    ip : IntrinsicPlasticity,
    firingRate : Float,
    calciumLevel : Float,
    bdnfLevel : Float,
    dt : Float
  ) {
    ip.actualFiringRate := 0.9 * ip.actualFiringRate + 0.1 * firingRate;
    
    // Rate error
    let rateError = ip.homeostasticTarget - ip.actualFiringRate;
    
    // Threshold plasticity (homeostatic)
    // Too active → raise threshold; too quiet → lower threshold
    ip.thresholdShift := -rateError * ip.intrinsicLearningRate * dt;
    ip.intrinsic.spikeThreshold := clamp(
      ip.intrinsic.spikeThreshold + ip.thresholdShift,
      INTR_V_THRESH_BASELINE - INTR_MAX_THRESH_SHIFT,
      INTR_V_THRESH_BASELINE + INTR_MAX_THRESH_SHIFT
    );
    
    // Ion channel plasticity
    
    // HCN — increases with low activity
    if (firingRate < ip.homeostasticTarget * 0.5) {
      ip.channels.hcnConductance += 0.001 * dt;
    } else {
      ip.channels.hcnConductance -= 0.0005 * dt;
    };
    ip.channels.hcnConductance := clamp(ip.channels.hcnConductance, 0.1, 1.5);
    
    // SK — increases with high calcium (negative feedback)
    ip.channels.skConductance += 0.0001 * calciumLevel * dt;
    ip.channels.skConductance := clamp(ip.channels.skConductance, 0.1, 1.0);
    
    // Na⁺ availability — decreases with sustained activity
    if (firingRate > ip.homeostasticTarget * 2.0) {
      ip.channels.navAvailability -= 0.001 * dt;
    } else {
      ip.channels.navAvailability += 0.0005 * dt;
    };
    ip.channels.navAvailability := clamp(ip.channels.navAvailability, 0.5, 1.0);
    
    // Firing rate gain modulated by BDNF
    ip.gainModulation := 1.0 + 0.2 * bdnfLevel;
    ip.intrinsic.firingRateGain := ip.gainModulation;
    
    // Input resistance modulated by HCN
    ip.intrinsic.inputResistance := 100.0 / (1.0 + ip.channels.hcnConductance);
    
    // Time constant
    ip.intrinsic.timeConstant := ip.intrinsic.inputResistance * ip.intrinsic.membraneCapacitance / 1000.0;
    
    // Excitability change
    ip.excitabilityChange := (INTR_V_THRESH_BASELINE - ip.intrinsic.spikeThreshold) / INTR_MAX_THRESH_SHIFT;
    
    // Overall plasticity measure
    ip.overallIntrinsicPlasticity := ip.gainModulation * (1.0 + ip.excitabilityChange);
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // LAYER 26: AXONAL PLASTICITY — PRESYNAPTIC STRUCTURAL CHANGES
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Axons are plastic too:
  //
  // 1. AXON INITIAL SEGMENT (AIS):
  //    - Location determines threshold
  //    - Can shift with activity
  //    - Homeostatic regulation
  //
  // 2. MYELINATION PLASTICITY:
  //    - Activity-dependent myelination
  //    - Conduction velocity changes
  //    - Timing precision
  //
  // 3. BOUTON DYNAMICS:
  //    - Bouton formation
  //    - Bouton elimination
  //    - Multi-synapse boutons
  //
  // 4. AXON BRANCHING:
  //    - Activity-dependent branching
  //    - Competition for targets
  //    - Pruning and refinement
  //

  public type AxonInitialSegment = {
    var length : Float;                  // AIS length (μm)
    var distanceFromSoma : Float;        // Position (μm)
    var navDensity : Float;              // Na⁺ channel density
    var threshold : Float;               // Local AP threshold
    var homeostaticShift : Float;        // Activity-dependent shift
  };

  public type MyelinSegment = {
    var isMyelinated : Bool;             // Has myelin?
    var myelinThickness : Float;         // Thickness
    var nodeLength : Float;              // Node of Ranvier length
    var conductionVelocity : Float;      // Conduction speed
    var activityLevel : Float;           // Recent activity
  };

  public type AxonalBouton = {
    var exists : Bool;                   // Bouton present?
    var size : Float;                    // Bouton size
    var synapseCount : Nat;              // Synapses per bouton
    var releaseProb : Float;             // Release probability
    var activityHistory : Float;         // Recent activity
    var stabilityFactor : Float;         // How stable
  };

  public type AxonalPlasticity = {
    ais : AxonInitialSegment;
    myelin : [var MyelinSegment];
    boutons : [var AxonalBouton];
    var aisShift : Float;                // AIS position change
    var myelinationProgress : Float;     // Overall myelination
    var boutonFormation : Nat;           // Recent formations
    var boutonElimination : Nat;         // Recent eliminations
    var axonalBranching : Float;         // Branching factor
    var overallAxonalChange : Float;
  };

  // Axonal parameters
  public let AXON_AIS_LENGTH_BASELINE : Float = 30.0;     // μm
  public let AXON_AIS_POSITION_BASELINE : Float = 20.0;   // μm from soma
  public let AXON_MYELIN_THRESHOLD : Float = 0.5;         // Activity for myelination
  public let AXON_BOUTON_STABILITY_TAU : Float = 86400000.0;  // ~1 day

  public func initAxonInitialSegment() : AxonInitialSegment {
    {
      var length = AXON_AIS_LENGTH_BASELINE;
      var distanceFromSoma = AXON_AIS_POSITION_BASELINE;
      var navDensity = 1.0;
      var threshold = -55.0;
      var homeostaticShift = 0.0;
    }
  };

  public func initMyelinSegment() : MyelinSegment {
    {
      var isMyelinated = false;
      var myelinThickness = 0.0;
      var nodeLength = 1.0;
      var conductionVelocity = 1.0;
      var activityLevel = 0.0;
    }
  };

  public func initAxonalBouton() : AxonalBouton {
    {
      var exists = true;
      var size = 1.0;
      var synapseCount = 1;
      var releaseProb = 0.3;
      var activityHistory = 0.0;
      var stabilityFactor = 0.5;
    }
  };

  public func initAxonalPlasticity(numSegments : Nat, numBoutons : Nat) : AxonalPlasticity {
    {
      ais = initAxonInitialSegment();
      myelin = Array.init<MyelinSegment>(numSegments, func(_ : Nat) : MyelinSegment {
        initMyelinSegment()
      });
      boutons = Array.init<AxonalBouton>(numBoutons, func(_ : Nat) : AxonalBouton {
        initAxonalBouton()
      });
      var aisShift = 0.0;
      var myelinationProgress = 0.0;
      var boutonFormation = 0;
      var boutonElimination = 0;
      var axonalBranching = 0.0;
      var overallAxonalChange = 0.0;
    }
  };

  // Update AIS plasticity
  public func updateAISPlasticity(
    ais : AxonInitialSegment,
    firingRate : Float,
    targetRate : Float,
    dt : Float
  ) {
    let rateError = firingRate - targetRate;
    
    // Too active → AIS moves distally (raises threshold)
    // Too quiet → AIS moves proximally (lowers threshold)
    ais.homeostaticShift := 0.001 * rateError * dt;
    ais.distanceFromSoma := clamp(
      ais.distanceFromSoma + ais.homeostaticShift,
      10.0,  // Min 10 μm from soma
      50.0   // Max 50 μm from soma
    );
    
    // Threshold changes with position
    ais.threshold := -55.0 + (ais.distanceFromSoma - AXON_AIS_POSITION_BASELINE) * 0.2;
    
    // Na⁺ channel density can change
    if (firingRate > targetRate * 2.0) {
      ais.navDensity -= 0.0001 * dt;
    } else if (firingRate < targetRate * 0.5) {
      ais.navDensity += 0.0001 * dt;
    };
    ais.navDensity := clamp(ais.navDensity, 0.5, 1.5);
  };

  // Update myelination
  public func updateMyelination(
    myelin : [var MyelinSegment],
    activityLevels : [Float],
    oligodendrocyteSignal : Float,
    dt : Float
  ) {
    let numSegments = Array.size(myelin);
    var totalMyelinated : Nat = 0;
    
    for (i in Iter.range(0, numSegments - 1)) {
      let seg = myelin[i];
      
      if (i < Array.size(activityLevels)) {
        seg.activityLevel := 0.9 * seg.activityLevel + 0.1 * activityLevels[i];
      };
      
      if (not seg.isMyelinated) {
        // Check if should myelinate
        if (seg.activityLevel > AXON_MYELIN_THRESHOLD and oligodendrocyteSignal > 0.3) {
          seg.isMyelinated := true;
          seg.myelinThickness := 0.1;
        };
      } else {
        // Myelin can thicken with continued activity
        seg.myelinThickness := Float.min(2.0, seg.myelinThickness + 0.0001 * seg.activityLevel * dt);
        
        // Conduction velocity improves with myelination
        seg.conductionVelocity := 1.0 + 10.0 * seg.myelinThickness;
        
        totalMyelinated += 1;
      };
    };
  };

  // Update bouton dynamics
  public func updateBoutons(
    boutons : [var AxonalBouton],
    synapticActivities : [Float],
    bdnfLevel : Float,
    dt : Float
  ) {
    var formationCount : Nat = 0;
    var eliminationCount : Nat = 0;
    let numBoutons = Array.size(boutons);
    
    for (i in Iter.range(0, numBoutons - 1)) {
      let bouton = boutons[i];
      
      if (i < Array.size(synapticActivities)) {
        bouton.activityHistory := 0.99 * bouton.activityHistory + 0.01 * synapticActivities[i];
      };
      
      if (bouton.exists) {
        // Update stability
        bouton.stabilityFactor += 0.0001 * bouton.activityHistory * dt;
        bouton.stabilityFactor := clamp(bouton.stabilityFactor, 0.0, 1.0);
        
        // Low activity → possible elimination
        if (bouton.activityHistory < 0.1 and bouton.stabilityFactor < 0.3) {
          bouton.exists := false;
          eliminationCount += 1;
        };
        
        // Update size based on activity
        bouton.size := 0.99 * bouton.size + 0.01 * (0.5 + bouton.activityHistory);
      } else {
        // Potential reformation with high BDNF
        if (bdnfLevel > 0.7) {
          bouton.exists := true;
          bouton.size := 0.5;
          bouton.stabilityFactor := 0.1;
          formationCount += 1;
        };
      };
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // LAYER 27: EPIGENETIC REGULATION — CHROMATIN AND METHYLATION
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Long-lasting plasticity requires epigenetic changes:
  //
  // 1. DNA METHYLATION:
  //    - CpG methylation silences genes
  //    - DNMT3a for new methylation
  //    - TET enzymes for demethylation
  //    - Memory-related genes affected
  //
  // 2. HISTONE MODIFICATIONS:
  //    - Acetylation → open chromatin → active
  //    - Methylation → context-dependent
  //    - HATs vs HDACs balance
  //
  // 3. CHROMATIN REMODELING:
  //    - Nucleosome positioning
  //    - Transcription factor access
  //    - Gene expression changes
  //
  // 4. NON-CODING RNAs:
  //    - miRNAs regulate translation
  //    - lncRNAs scaffold complexes
  //    - Activity-dependent expression
  //

  public type MethylationState = {
    var globalMethylation : Float;       // Overall methylation level
    var bdnfPromoterMeth : Float;        // BDNF promoter methylation
    var arcPromoterMeth : Float;         // Arc promoter methylation
    var relnPromoterMeth : Float;        // Reelin promoter
    var dnmt3aActivity : Float;          // De novo methylation
    var tetActivity : Float;             // Demethylation
    var methyTransferRate : Float;       // Net methylation change
  };

  public type HistoneState = {
    var h3k4me3 : Float;                 // Activating mark
    var h3k27me3 : Float;                // Repressive mark
    var h3k9ac : Float;                  // Acetylation (active)
    var h4k12ac : Float;                 // Memory-related acetylation
    var hatActivity : Float;             // Histone acetyltransferase
    var hdacActivity : Float;            // Histone deacetylase
    var chromatinAccessibility : Float;  // Open vs closed
  };

  public type EpigeneticState = {
    methylation : MethylationState;
    histones : HistoneState;
    var transcriptionRate : Float;       // Gene expression rate
    var plasticityGenes : Float;         // Plasticity gene expression
    var immediateEarlyGenes : Float;     // IEG expression (Arc, cFos)
    var memoryGenes : Float;             // Memory-related genes
    var epigeneticLearningRate : Float;  // How fast epigenome changes
    var epigeneticStability : Float;     // How stable changes are
  };

  // Epigenetic parameters
  public let EPI_METHYLATION_BASELINE : Float = 0.5;
  public let EPI_ACETYLATION_BASELINE : Float = 0.5;
  public let EPI_ACTIVITY_THRESHOLD : Float = 0.3;

  public func initMethylationState() : MethylationState {
    {
      var globalMethylation = EPI_METHYLATION_BASELINE;
      var bdnfPromoterMeth = 0.3;
      var arcPromoterMeth = 0.2;
      var relnPromoterMeth = 0.4;
      var dnmt3aActivity = 0.3;
      var tetActivity = 0.3;
      var methyTransferRate = 0.0;
    }
  };

  public func initHistoneState() : HistoneState {
    {
      var h3k4me3 = 0.5;
      var h3k27me3 = 0.3;
      var h3k9ac = EPI_ACETYLATION_BASELINE;
      var h4k12ac = 0.5;
      var hatActivity = 0.5;
      var hdacActivity = 0.5;
      var chromatinAccessibility = 0.5;
    }
  };

  public func initEpigeneticState() : EpigeneticState {
    {
      methylation = initMethylationState();
      histones = initHistoneState();
      var transcriptionRate = 0.5;
      var plasticityGenes = 0.5;
      var immediateEarlyGenes = 0.0;
      var memoryGenes = 0.5;
      var epigeneticLearningRate = 0.001;
      var epigeneticStability = 0.9;
    }
  };

  // Update epigenetic state
  public func updateEpigeneticState(
    epi : EpigeneticState,
    neuralActivity : Float,
    calciumLevel : Float,
    crebActivity : Float,
    stressLevel : Float,
    dt : Float
  ) {
    // === Methylation dynamics ===
    let meth = epi.methylation;
    
    // Activity-dependent demethylation
    if (neuralActivity > EPI_ACTIVITY_THRESHOLD) {
      meth.tetActivity += 0.01 * neuralActivity;
    } else {
      meth.tetActivity *= 0.99;
    };
    
    // Stress increases DNMT3a
    meth.dnmt3aActivity := 0.9 * meth.dnmt3aActivity + 0.1 * stressLevel;
    
    // Net methylation change
    meth.methyTransferRate := meth.dnmt3aActivity - meth.tetActivity;
    meth.globalMethylation += meth.methyTransferRate * 0.001 * dt;
    meth.globalMethylation := clamp(meth.globalMethylation, 0.0, 1.0);
    
    // BDNF promoter — activity demethylates
    meth.bdnfPromoterMeth -= 0.001 * neuralActivity * meth.tetActivity * dt;
    meth.bdnfPromoterMeth := clamp(meth.bdnfPromoterMeth, 0.0, 0.8);
    
    // Arc promoter — very activity-sensitive
    meth.arcPromoterMeth -= 0.002 * neuralActivity * dt;
    meth.arcPromoterMeth += 0.0001 * (1.0 - neuralActivity) * dt;
    meth.arcPromoterMeth := clamp(meth.arcPromoterMeth, 0.0, 0.8);
    
    // === Histone dynamics ===
    let hist = epi.histones;
    
    // HAT activity increases with calcium
    hist.hatActivity := 0.9 * hist.hatActivity + 0.1 * calciumLevel;
    
    // HDAC activity (baseline, inhibited by activity)
    hist.hdacActivity := 0.5 * (1.0 - neuralActivity);
    
    // H3K9ac — learning-related
    let acetylationChange = (hist.hatActivity - hist.hdacActivity) * 0.01 * dt;
    hist.h3k9ac += acetylationChange;
    hist.h3k9ac := clamp(hist.h3k9ac, 0.1, 0.9);
    
    // H4K12ac — memory consolidation
    hist.h4k12ac := 0.99 * hist.h4k12ac + 0.01 * crebActivity;
    
    // Chromatin accessibility
    hist.chromatinAccessibility := (hist.h3k9ac + hist.h4k12ac + hist.h3k4me3) / 3.0 -
                                    (hist.h3k27me3 + meth.globalMethylation) / 3.0;
    hist.chromatinAccessibility := clamp(hist.chromatinAccessibility, 0.1, 0.9);
    
    // === Gene expression ===
    
    // Immediate early genes (fast, transient)
    if (neuralActivity > 0.5) {
      epi.immediateEarlyGenes := Float.min(1.0, epi.immediateEarlyGenes + 0.1 * dt);
    } else {
      epi.immediateEarlyGenes := Float.max(0.0, epi.immediateEarlyGenes - 0.01 * dt);
    };
    
    // Plasticity genes
    epi.plasticityGenes := (1.0 - meth.bdnfPromoterMeth) * hist.chromatinAccessibility;
    
    // Memory genes (slower, more stable)
    epi.memoryGenes := 0.999 * epi.memoryGenes + 0.001 * crebActivity * hist.h4k12ac;
    
    // Overall transcription rate
    epi.transcriptionRate := hist.chromatinAccessibility * (0.5 + 0.5 * crebActivity);
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // LAYER 28: LOCAL FIELD POTENTIALS — MESOSCALE DYNAMICS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // LFPs reflect population activity and create the context for plasticity:
  //
  // 1. LFP SOURCES:
  //    - Summed synaptic currents (main source)
  //    - Intrinsic currents
  //    - Gap junction currents
  //    - Reflects dendritic processing
  //
  // 2. LFP AND PLASTICITY:
  //    - LFP phase modulates spike timing
  //    - Cross-frequency coupling coordinates
  //    - Amplitude reflects excitability
  //
  // 3. POPULATION CODING:
  //    - Rate coding
  //    - Phase coding relative to LFP
  //    - Population vectors
  //

  public type LFPState = {
    var raw : Float;                     // Raw LFP signal
    var filtered : [var Float];          // Band-filtered signals
    var deltaPhase : Float;              // Delta band phase
    var thetaPhase : Float;              // Theta band phase
    var alphaPhase : Float;              // Alpha band phase
    var gammaPhase : Float;              // Gamma band phase
    var deltaPower : Float;              // Delta power
    var thetaPower : Float;              // Theta power
    var alphaPower : Float;              // Alpha power
    var gammaPower : Float;              // Gamma power
    var phaseCoherence : Float;          // Phase consistency
  };

  public type PopulationState = {
    var meanFiringRate : Float;          // Population rate
    var rateVariance : Float;            // Rate variability
    var synchrony : Float;               // Spike synchrony
    var populationVector : [var Float];  // Direction/representation
    var phaseCode : Float;               // Phase relative to theta
    var sparseness : Float;              // Population sparseness
  };

  public type MesoscaleDynamics = {
    lfp : LFPState;
    population : PopulationState;
    var lfpPlasticityModulation : Float; // LFP effect on plasticity
    var populationPlasticity : Float;    // Population-level changes
    var crossFrequencyMod : Float;       // CFC modulation
    var phaseAmplitudeCoupling : Float;  // PAC strength
  };

  public func initLFPState() : LFPState {
    {
      var raw = 0.0;
      var filtered = Array.init<Float>(4, func(_ : Nat) : Float { 0.0 });
      var deltaPhase = 0.0;
      var thetaPhase = 0.0;
      var alphaPhase = 0.0;
      var gammaPhase = 0.0;
      var deltaPower = 0.0;
      var thetaPower = 0.0;
      var alphaPower = 0.0;
      var gammaPower = 0.0;
      var phaseCoherence = 0.0;
    }
  };

  public func initPopulationState() : PopulationState {
    {
      var meanFiringRate = 5.0;
      var rateVariance = 2.0;
      var synchrony = 0.3;
      var populationVector = Array.init<Float>(12, func(_ : Nat) : Float { 0.0 });
      var phaseCode = 0.0;
      var sparseness = 0.3;
    }
  };

  public func initMesoscaleDynamics() : MesoscaleDynamics {
    {
      lfp = initLFPState();
      population = initPopulationState();
      var lfpPlasticityModulation = 1.0;
      var populationPlasticity = 0.0;
      var crossFrequencyMod = 0.0;
      var phaseAmplitudeCoupling = 0.0;
    }
  };

  // Update LFP from synaptic currents
  public func updateLFP(
    lfp : LFPState,
    synapticCurrents : [Float],
    dt : Float
  ) {
    // Sum synaptic currents (main LFP source)
    var totalCurrent : Float = 0.0;
    for (c in synapticCurrents.vals()) {
      totalCurrent += c;
    };
    lfp.raw := 0.9 * lfp.raw + 0.1 * totalCurrent;
    
    // Band-pass filtering (simplified)
    // Delta (0.5-4 Hz)
    lfp.filtered[0] := 0.95 * lfp.filtered[0] + 0.05 * lfp.raw;
    lfp.deltaPhase += 2.0 * PI * 2.0 * dt / 1000.0;  // ~2 Hz
    lfp.deltaPower := Float.abs(lfp.filtered[0]);
    
    // Theta (4-8 Hz)
    lfp.filtered[1] := 0.9 * lfp.filtered[1] + 0.1 * lfp.raw;
    lfp.thetaPhase += 2.0 * PI * 6.0 * dt / 1000.0;  // ~6 Hz
    lfp.thetaPower := Float.abs(lfp.filtered[1]);
    
    // Alpha (8-12 Hz)
    lfp.filtered[2] := 0.85 * lfp.filtered[2] + 0.15 * lfp.raw;
    lfp.alphaPhase += 2.0 * PI * 10.0 * dt / 1000.0;
    lfp.alphaPower := Float.abs(lfp.filtered[2]);
    
    // Gamma (30-80 Hz)
    lfp.filtered[3] := 0.7 * lfp.filtered[3] + 0.3 * lfp.raw;
    lfp.gammaPhase += 2.0 * PI * 40.0 * dt / 1000.0;
    lfp.gammaPower := Float.abs(lfp.filtered[3]);
    
    // Wrap phases
    if (lfp.deltaPhase > 2.0 * PI) { lfp.deltaPhase -= 2.0 * PI };
    if (lfp.thetaPhase > 2.0 * PI) { lfp.thetaPhase -= 2.0 * PI };
    if (lfp.alphaPhase > 2.0 * PI) { lfp.alphaPhase -= 2.0 * PI };
    if (lfp.gammaPhase > 2.0 * PI) { lfp.gammaPhase -= 2.0 * PI };
  };

  // Update population state
  public func updatePopulationState(
    pop : PopulationState,
    firingRates : [Float],
    dt : Float
  ) {
    let n = Array.size(firingRates);
    if (n == 0) { return };
    
    // Mean firing rate
    var sum : Float = 0.0;
    var sumSq : Float = 0.0;
    var activeCount : Nat = 0;
    
    for (r in firingRates.vals()) {
      sum += r;
      sumSq += r * r;
      if (r > 0.1) { activeCount += 1 };
    };
    
    pop.meanFiringRate := sum / Float.fromInt(n);
    pop.rateVariance := (sumSq / Float.fromInt(n)) - (pop.meanFiringRate * pop.meanFiringRate);
    
    // Sparseness
    pop.sparseness := 1.0 - Float.fromInt(activeCount) / Float.fromInt(n);
    
    // Population vector (simplified)
    let vecSize = Nat.min(n, 12);
    for (i in Iter.range(0, vecSize - 1)) {
      pop.populationVector[i] := firingRates[i];
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // LAYER 29: CRITICALITY — EDGE-OF-CHAOS DYNAMICS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // The brain may operate at the "edge of chaos" — the critical point:
  //
  // 1. CRITICALITY SIGNATURES:
  //    - Power-law distributions
  //    - Long-range correlations
  //    - Neuronal avalanches
  //    - Scale-free dynamics
  //
  // 2. OPTIMALITY AT CRITICALITY:
  //    - Maximum dynamic range
  //    - Optimal information transmission
  //    - Maximum susceptibility (plasticity)
  //
  // 3. HOMEOSTATIC REGULATION:
  //    - E/I balance maintains criticality
  //    - Self-organized criticality
  //    - Plasticity tunes to critical point
  //

  public type CriticalityState = {
    var branchingRatio : Float;          // σ ≈ 1 at criticality
    var avalancheSize : Float;           // Current avalanche size
    var avalancheDistribution : [var Float]; // Size distribution
    var dynamicRange : Float;            // Response range
    var longRangeCorrelation : Float;    // Temporal correlation
    var susceptibility : Float;          // Sensitivity
    var eiBalance : Float;               // E/I ratio
    var distanceFromCriticality : Float; // How far from σ=1
    var isCritical : Bool;               // At critical point?
  };

  public type CriticalityPlasticity = {
    criticality : CriticalityState;
    var criticalityEnhancement : Float;  // Plasticity at criticality
    var subcriticalSuppression : Float;  // Below criticality
    var supercriticalInstability : Float;// Above criticality
    var selfOrganizingPlasticity : Float;// SOC-driven plasticity
    var overallCriticalityEffect : Float;
  };

  public func initCriticalityState() : CriticalityState {
    {
      var branchingRatio = 1.0;          // Start at critical point
      var avalancheSize = 0.0;
      var avalancheDistribution = Array.init<Float>(20, func(i : Nat) : Float {
        // Power-law initialization
        1.0 / Float.pow(Float.fromInt(i + 1), 1.5)
      });
      var dynamicRange = 10.0;
      var longRangeCorrelation = 0.5;
      var susceptibility = 1.0;
      var eiBalance = 1.0;
      var distanceFromCriticality = 0.0;
      var isCritical = true;
    }
  };

  public func initCriticalityPlasticity() : CriticalityPlasticity {
    {
      criticality = initCriticalityState();
      var criticalityEnhancement = 1.5;
      var subcriticalSuppression = 0.5;
      var supercriticalInstability = 2.0;
      var selfOrganizingPlasticity = 0.0;
      var overallCriticalityEffect = 1.5;
    }
  };

  // Update criticality state
  public func updateCriticality(
    crit : CriticalityState,
    excitation : Float,
    inhibition : Float,
    networkActivity : [Float],
    dt : Float
  ) {
    // E/I balance
    crit.eiBalance := excitation / (inhibition + 0.001);
    
    // Branching ratio estimation
    // σ = (activity at t+1) / (activity at t)
    var currentActivity : Float = 0.0;
    for (a in networkActivity.vals()) {
      currentActivity += a;
    };
    
    if (crit.avalancheSize > 0.01) {
      crit.branchingRatio := 0.9 * crit.branchingRatio + 0.1 * (currentActivity / crit.avalancheSize);
    };
    crit.avalancheSize := currentActivity;
    
    // Distance from criticality
    crit.distanceFromCriticality := Float.abs(crit.branchingRatio - 1.0);
    crit.isCritical := crit.distanceFromCriticality < 0.1;
    
    // Dynamic range (larger at criticality)
    if (crit.isCritical) {
      crit.dynamicRange := 20.0;
    } else if (crit.branchingRatio < 1.0) {
      crit.dynamicRange := 5.0 + 15.0 * (1.0 - crit.distanceFromCriticality);
    } else {
      crit.dynamicRange := 5.0;  // Reduced in supercritical
    };
    
    // Susceptibility (peaks at criticality)
    crit.susceptibility := 1.0 / (crit.distanceFromCriticality + 0.1);
    
    // Long-range correlation
    if (crit.isCritical) {
      crit.longRangeCorrelation := 0.8;
    } else {
      crit.longRangeCorrelation := 0.2;
    };
  };

  // Compute criticality effect on plasticity
  public func computeCriticalityPlasticity(
    cp : CriticalityPlasticity,
    excitation : Float,
    inhibition : Float,
    networkActivity : [Float],
    dt : Float
  ) {
    updateCriticality(cp.criticality, excitation, inhibition, networkActivity, dt);
    
    if (cp.criticality.isCritical) {
      // At criticality — maximum plasticity
      cp.overallCriticalityEffect := cp.criticalityEnhancement * cp.criticality.susceptibility;
    } else if (cp.criticality.branchingRatio < 1.0) {
      // Subcritical — reduced plasticity
      cp.overallCriticalityEffect := cp.subcriticalSuppression * (1.0 - cp.criticality.distanceFromCriticality);
    } else {
      // Supercritical — unstable, plasticity can be excessive
      cp.overallCriticalityEffect := cp.supercriticalInstability;
    };
    
    // Self-organizing plasticity toward criticality
    if (cp.criticality.eiBalance > 1.2) {
      cp.selfOrganizingPlasticity := -0.1;  // Need more inhibition
    } else if (cp.criticality.eiBalance < 0.8) {
      cp.selfOrganizingPlasticity := 0.1;   // Need more excitation
    } else {
      cp.selfOrganizingPlasticity := 0.0;
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // LAYER 30: SACRED GEOMETRY — φ-RATIO IN NEURAL ORGANIZATION
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // The golden ratio φ = 1.618... appears throughout nature and optimal systems:
  //
  // 1. φ IN NEURAL DYNAMICS:
  //    - Optimal coupling ratios
  //    - Fibonacci timing
  //    - Scale-free organization
  //
  // 2. SACRED GEOMETRY IN HEBBIAN:
  //    - Weight floor = φ/144 = 0.01124
  //    - Coupling matrix uses φ, φ², φ³
  //    - 144 = 12² = F₁₂ (12th Fibonacci)
  //
  // 3. NUMEROLOGICAL ANCHORS:
  //    - 444 = sacred beat
  //    - 12 = cycle complete
  //    - 7 = heritage metals
  //
  // 4. ORGANISM DOCTRINE:
  //    - S₀ = 1.0 (root of all values)
  //    - Sacred floor = 0.75
  //    - Never below φ/144
  //

  public type SacredGeometryState = {
    var phi : Float;                     // φ = 1.618033988749894...
    var phiSquared : Float;              // φ²
    var phiCubed : Float;                // φ³
    var phiInverse : Float;              // 1/φ = φ - 1
    var sacredFloor : Float;             // φ/144
    var fibonacciSequence : [var Float]; // First 20 Fibonacci numbers
    var currentFibIndex : Nat;           // Where in sequence
    var sacredBeatCounter : Nat;         // Counting to 444
    var lastSacredBeat : Nat;            // When 444 last fired
  };

  public type SacredCouplingMatrix = {
    var bodyNodesCoupling : Float;       // Nodes 0-3: φ
    var interfaceNodesCoupling : Float;  // Nodes 4-7: φ²
    var brainNodesCoupling : Float;      // Nodes 8-11: φ³
    var crossCoupling : Float;           // Between groups
    var matrix : [[var Float]];          // Full 12×12 matrix
    var geometryType : Text;             // Tetra/Cube/Octahedron
  };

  public type SacredPlasticity = {
    geometry : SacredGeometryState;
    coupling : SacredCouplingMatrix;
    var sacredFloorEnforced : Bool;      // Never below φ/144
    var fibonacciTiming : Bool;          // Use Fibonacci intervals
    var sacredBeatBonus : Float;         // Bonus at beat 444
    var geometryAlignmentBonus : Float;  // Bonus for sacred ratios
    var overallSacredModulation : Float; // Combined effect
  };

  // Sacred constants
  public let SACRED_PHI : Float = 1.618033988749894848204586834365638117720309179805762862135448622705260462818902449707207204189391137;
  public let SACRED_FLOOR : Float = 0.011236068319801175;  // φ/144
  public let SACRED_444 : Nat = 444;
  public let SACRED_12 : Nat = 12;
  public let SACRED_144 : Nat = 144;
  public let SACRED_S_ZERO : Float = 1.0;
  public let SACRED_S_ZERO_FLOOR : Float = 0.75;

  public func initSacredGeometryState() : SacredGeometryState {
    let phi = SACRED_PHI;
    {
      var phi = phi;
      var phiSquared = phi * phi;
      var phiCubed = phi * phi * phi;
      var phiInverse = 1.0 / phi;
      var sacredFloor = SACRED_FLOOR;
      var fibonacciSequence = Array.init<Float>(20, func(i : Nat) : Float {
        // Fibonacci sequence
        let f = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181, 6765];
        Float.fromInt(f[i])
      });
      var currentFibIndex = 0;
      var sacredBeatCounter = 0;
      var lastSacredBeat = 0;
    }
  };

  public func initSacredCouplingMatrix() : SacredCouplingMatrix {
    let phi = SACRED_PHI;
    let phiSq = phi * phi;
    let phiCu = phi * phi * phi;
    
    // Initialize 12×12 matrix with sacred geometry
    let matrix = Array.init<[var Float]>(12, func(i : Nat) : [var Float] {
      Array.init<Float>(12, func(j : Nat) : Float {
        if (i == j) {
          0.0  // No self-coupling
        } else if (i < 4 and j < 4) {
          // Body nodes: tetrahedron coupling = φ
          phi * 0.1
        } else if (i >= 4 and i < 8 and j >= 4 and j < 8) {
          // Interface nodes: cube coupling = φ²
          phiSq * 0.1
        } else if (i >= 8 and j >= 8) {
          // Brain nodes: octahedron coupling = φ³
          phiCu * 0.1
        } else {
          // Cross-group coupling
          phi * 0.05
        }
      })
    });
    
    {
      var bodyNodesCoupling = phi * 0.1;
      var interfaceNodesCoupling = phiSq * 0.1;
      var brainNodesCoupling = phiCu * 0.1;
      var crossCoupling = phi * 0.05;
      var matrix = matrix;
      var geometryType = "Dodecahedron";
    }
  };

  public func initSacredPlasticity() : SacredPlasticity {
    {
      geometry = initSacredGeometryState();
      coupling = initSacredCouplingMatrix();
      var sacredFloorEnforced = true;
      var fibonacciTiming = true;
      var sacredBeatBonus = 0.0;
      var geometryAlignmentBonus = 0.0;
      var overallSacredModulation = 1.0;
    }
  };

  // Enforce sacred floor on weight
  public func enforceSacredFloor(weight : Float) : Float {
    Float.max(SACRED_FLOOR, weight)
  };

  // Check if current beat is sacred (444)
  public func isSacredBeat(beatNumber : Nat) : Bool {
    beatNumber % SACRED_444 == 0
  };

  // Check if current beat aligns with Fibonacci
  public func isFibonacciBeat(sp : SacredPlasticity, beatNumber : Nat) : Bool {
    // Check if beat is a Fibonacci number
    for (i in Iter.range(0, 19)) {
      if (Float.fromInt(beatNumber) == sp.geometry.fibonacciSequence[i]) {
        return true;
      };
    };
    false
  };

  // Update sacred plasticity
  public func updateSacredPlasticity(
    sp : SacredPlasticity,
    currentBeat : Nat,
    weights : [[Float]],
    dt : Float
  ) {
    sp.geometry.sacredBeatCounter := currentBeat;
    
    // Check for sacred beat
    if (isSacredBeat(currentBeat)) {
      sp.geometry.lastSacredBeat := currentBeat;
      sp.sacredBeatBonus := 1.5;  // 50% bonus at sacred beat
    } else {
      sp.sacredBeatBonus := 1.0 + 0.5 * exp(-Float.fromInt(currentBeat - sp.geometry.lastSacredBeat) / 100.0);
    };
    
    // Check geometry alignment
    var alignmentScore : Float = 0.0;
    let phi = sp.geometry.phi;
    let tolerance = 0.01;
    
    for (i in Iter.range(0, 11)) {
      for (j in Iter.range(0, 11)) {
        if (i != j and i < Array.size(weights) and j < Array.size(weights[i])) {
          let w = weights[i][j];
          
          // Check for φ-ratio
          if (Float.abs(w - phi * SACRED_FLOOR) < tolerance) {
            alignmentScore += 0.1;
          };
          // Check for φ²-ratio
          if (Float.abs(w - sp.geometry.phiSquared * SACRED_FLOOR) < tolerance) {
            alignmentScore += 0.2;
          };
        };
      };
    };
    
    sp.geometryAlignmentBonus := 1.0 + alignmentScore;
    
    // Fibonacci timing bonus
    if (isFibonacciBeat(sp, currentBeat)) {
      sp.geometry.currentFibIndex := (sp.geometry.currentFibIndex + 1) % 20;
    };
    
    // Overall modulation
    sp.overallSacredModulation := sp.sacredBeatBonus * sp.geometryAlignmentBonus;
  };

  // Get sacred coupling for specific node pair
  public func getSacredCoupling(sp : SacredPlasticity, nodeI : Nat, nodeJ : Nat) : Float {
    if (nodeI < 12 and nodeJ < 12) {
      sp.coupling.matrix[nodeI][nodeJ]
    } else {
      0.0
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // FINAL INTEGRATION: COMPLETE DEEP HEBBIAN SYSTEM
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

  public type CompleteHebbianState = {
    // Layers 1-10 (existing)
    calcium : [var CalciumState];
    nmda : [var NMDAReceptorState];
    ampa : [var AMPATraffickingState];
    camkii : [var CaMKIIState];
    protein : [var ProteinSynthesisState];
    dendrites : [var DendriticTree];
    neuromodulation : NeuromodulatorState;
    homeostasis : HomeostaticState;
    metaplasticity : MetaplasticityState;
    structural : StructuralPlasticityState;
    
    // Layers 11-20
    presynaptic : [var PresynapticTerminal];
    tripartite : [var TripartiteSynapse];
    retrograde : [var RetrogradeSignaling];
    stdp : [var ExtendedSTDPState];
    threeFactor : [var ThreeFactorState];
    consolidation : [var ConsolidationEngine];
    oscillatory : OscillatoryPlasticity;
    attention : AttentionalGating;
    energy : EnergeticConstraints;
    circadian : CircadianPlasticity;
    
    // Layers 21-30
    stress : StressPlasticity;
    sleep : SleepPlasticity;
    criticalPeriod : CriticalPeriodPlasticity;
    multisynaptic : MultisynapticRules;
    intrinsic : [var IntrinsicPlasticity];
    axonal : [var AxonalPlasticity];
    epigenetic : [var EpigeneticState];
    mesoscale : MesoscaleDynamics;
    criticality : CriticalityPlasticity;
    sacred : SacredPlasticity;
    
    // Global state
    var currentBeat : Nat;
    var totalPlasticityEvents : Nat;
    var meanWeight : Float;
    var isHealthy : Bool;
  };

  public type CompleteHebbianResult = {
    meanWeight : Float;
    totalLTP : Nat;
    totalLTD : Nat;
    plasticityGain : Float;
    energyLimited : Bool;
    circadianPhase : Float;
    sleepStage : Nat;
    isCritical : Bool;
    sacredBeatActive : Bool;
    overallHealth : Float;
  };

  // Note: Full initialization of CompleteHebbianState requires calling all 30 init functions
  // This would be done in actual implementation


  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // ██████████████████████████████████████████████████████████████████████████████████████████████████████████████
  // ██                                                                                                          ██
  // ██  DEEP MATHEMATICAL FOUNDATIONS — COMPLETE NEURONAL BIOPHYSICS                                           ██
  // ██                                                                                                          ██
  // ██████████████████████████████████████████████████████████████████████████████████████████████████████████████
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // HODGKIN-HUXLEY MODEL — THE FOUNDATION OF COMPUTATIONAL NEUROSCIENCE
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // The classic HH model describes action potential generation:
  //
  // C_m × dV/dt = I_ext - g_Na × m³ × h × (V - E_Na) - g_K × n⁴ × (V - E_K) - g_L × (V - E_L)
  //
  // Where:
  //   - C_m = membrane capacitance (~1 μF/cm²)
  //   - V = membrane potential
  //   - I_ext = external current
  //   - g_Na, g_K, g_L = maximal conductances
  //   - m, h, n = gating variables
  //   - E_Na, E_K, E_L = reversal potentials
  //

  public type HodgkinHuxleyState = {
    var voltage : Float;                 // Membrane potential (mV)
    var m : Float;                       // Na activation
    var h : Float;                       // Na inactivation
    var n : Float;                       // K activation
    var iNa : Float;                     // Sodium current
    var iK : Float;                      // Potassium current
    var iL : Float;                      // Leak current
    var spikeDetected : Bool;            // Action potential?
    var lastSpikeTime : Float;           // Time of last spike
    var firingRate : Float;              // Instantaneous rate
  };

  // HH parameters
  public let HH_CM : Float = 1.0;                // μF/cm²
  public let HH_G_NA : Float = 120.0;            // mS/cm²
  public let HH_G_K : Float = 36.0;              // mS/cm²
  public let HH_G_L : Float = 0.3;               // mS/cm²
  public let HH_E_NA : Float = 50.0;             // mV
  public let HH_E_K : Float = -77.0;             // mV
  public let HH_E_L : Float = -54.4;             // mV
  public let HH_V_REST : Float = -65.0;          // mV
  public let HH_SPIKE_THRESHOLD : Float = -20.0; // mV

  public func initHodgkinHuxleyState() : HodgkinHuxleyState {
    let vRest = HH_V_REST;
    {
      var voltage = vRest;
      var m = alphaM(vRest) / (alphaM(vRest) + betaM(vRest));
      var h = alphaH(vRest) / (alphaH(vRest) + betaH(vRest));
      var n = alphaN(vRest) / (alphaN(vRest) + betaN(vRest));
      var iNa = 0.0;
      var iK = 0.0;
      var iL = 0.0;
      var spikeDetected = false;
      var lastSpikeTime = -1000.0;
      var firingRate = 0.0;
    }
  };

  // Rate functions for gating variables
  func alphaM(v : Float) : Float {
    if (Float.abs(v + 40.0) < 0.001) {
      1.0
    } else {
      0.1 * (v + 40.0) / (1.0 - exp(-(v + 40.0) / 10.0))
    }
  };

  func betaM(v : Float) : Float {
    4.0 * exp(-(v + 65.0) / 18.0)
  };

  func alphaH(v : Float) : Float {
    0.07 * exp(-(v + 65.0) / 20.0)
  };

  func betaH(v : Float) : Float {
    1.0 / (1.0 + exp(-(v + 35.0) / 10.0))
  };

  func alphaN(v : Float) : Float {
    if (Float.abs(v + 55.0) < 0.001) {
      0.1
    } else {
      0.01 * (v + 55.0) / (1.0 - exp(-(v + 55.0) / 10.0))
    }
  };

  func betaN(v : Float) : Float {
    0.125 * exp(-(v + 65.0) / 80.0)
  };

  // Update Hodgkin-Huxley dynamics
  public func updateHodgkinHuxley(
    hh : HodgkinHuxleyState,
    iExt : Float,            // External current (μA/cm²)
    currentTime : Float,
    dt : Float               // Time step (ms)
  ) {
    let v = hh.voltage;
    
    // Update gating variables
    let am = alphaM(v);
    let bm = betaM(v);
    let ah = alphaH(v);
    let bh = betaH(v);
    let an = alphaN(v);
    let bn = betaN(v);
    
    // dm/dt = α_m(V)(1-m) - β_m(V)m
    let dm = (am * (1.0 - hh.m) - bm * hh.m) * dt;
    hh.m := clamp(hh.m + dm, 0.0, 1.0);
    
    // dh/dt = α_h(V)(1-h) - β_h(V)h
    let dh = (ah * (1.0 - hh.h) - bh * hh.h) * dt;
    hh.h := clamp(hh.h + dh, 0.0, 1.0);
    
    // dn/dt = α_n(V)(1-n) - β_n(V)n
    let dn = (an * (1.0 - hh.n) - bn * hh.n) * dt;
    hh.n := clamp(hh.n + dn, 0.0, 1.0);
    
    // Compute currents
    hh.iNa := HH_G_NA * hh.m * hh.m * hh.m * hh.h * (v - HH_E_NA);
    hh.iK := HH_G_K * hh.n * hh.n * hh.n * hh.n * (v - HH_E_K);
    hh.iL := HH_G_L * (v - HH_E_L);
    
    // dV/dt = (I_ext - I_Na - I_K - I_L) / C_m
    let dv = (iExt - hh.iNa - hh.iK - hh.iL) / HH_CM * dt;
    let newV = v + dv;
    
    // Spike detection
    let wasAboveThreshold = v > HH_SPIKE_THRESHOLD;
    let isAboveThreshold = newV > HH_SPIKE_THRESHOLD;
    
    if (isAboveThreshold and not wasAboveThreshold) {
      hh.spikeDetected := true;
      let isi = currentTime - hh.lastSpikeTime;
      if (isi > 1.0) {
        hh.firingRate := 1000.0 / isi;  // Hz
      };
      hh.lastSpikeTime := currentTime;
    } else {
      hh.spikeDetected := false;
    };
    
    hh.voltage := newV;
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // INTEGRATE-AND-FIRE VARIANTS — EFFICIENT SPIKING MODELS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Simplified models for large-scale simulation:
  //
  // 1. LEAKY INTEGRATE-AND-FIRE (LIF):
  //    τ_m × dV/dt = -(V - V_rest) + R × I
  //    if V > V_thresh: spike, V → V_reset
  //
  // 2. EXPONENTIAL LIF (AdEx):
  //    τ_m × dV/dt = -(V - V_rest) + Δ_T × exp((V - V_T)/Δ_T) + R × I
  //    Captures spike initiation dynamics
  //
  // 3. IZHIKEVICH:
  //    dv/dt = 0.04v² + 5v + 140 - u + I
  //    du/dt = a(bv - u)
  //    if v ≥ 30: v → c, u → u + d
  //

  public type LIFState = {
    var voltage : Float;
    var refractoryTime : Float;
    var spikeCount : Nat;
    var lastSpikeTime : Float;
    var adaptation : Float;              // Spike frequency adaptation
  };

  public type AdExState = {
    var voltage : Float;
    var w : Float;                       // Adaptation variable
    var spikeDetected : Bool;
    var firingRate : Float;
    var burstCount : Nat;
  };

  public type IzhikevichState = {
    var v : Float;                       // Membrane potential
    var u : Float;                       // Recovery variable
    var a : Float;                       // Time scale of u
    var b : Float;                       // Sensitivity of u to v
    var c : Float;                       // After-spike reset of v
    var d : Float;                       // After-spike reset of u
    var spikeDetected : Bool;
    var neuronType : Text;               // RS, FS, IB, CH, etc.
  };

  // LIF parameters
  public let LIF_TAU_M : Float = 20.0;           // ms
  public let LIF_V_REST : Float = -65.0;         // mV
  public let LIF_V_THRESH : Float = -50.0;       // mV
  public let LIF_V_RESET : Float = -70.0;        // mV
  public let LIF_TAU_REF : Float = 2.0;          // ms refractory

  // AdEx parameters
  public let ADEX_TAU_M : Float = 9.37;          // ms
  public let ADEX_TAU_W : Float = 144.0;         // ms
  public let ADEX_DELTA_T : Float = 2.0;         // mV
  public let ADEX_V_T : Float = -50.0;           // mV
  public let ADEX_A : Float = 4.0;               // nS
  public let ADEX_B : Float = 0.0805;            // nA

  public func initLIFState() : LIFState {
    {
      var voltage = LIF_V_REST;
      var refractoryTime = 0.0;
      var spikeCount = 0;
      var lastSpikeTime = -1000.0;
      var adaptation = 0.0;
    }
  };

  public func initAdExState() : AdExState {
    {
      var voltage = -70.0;
      var w = 0.0;
      var spikeDetected = false;
      var firingRate = 0.0;
      var burstCount = 0;
    }
  };

  public func initIzhikevichState(neuronType : Text) : IzhikevichState {
    // Set parameters based on neuron type
    let (a, b, c, d) = switch (neuronType) {
      case ("RS") { (0.02, 0.2, -65.0, 8.0) };      // Regular spiking
      case ("FS") { (0.1, 0.2, -65.0, 2.0) };       // Fast spiking
      case ("IB") { (0.02, 0.2, -55.0, 4.0) };      // Intrinsically bursting
      case ("CH") { (0.02, 0.2, -50.0, 2.0) };      // Chattering
      case ("LTS") { (0.02, 0.25, -65.0, 2.0) };    // Low-threshold spiking
      case (_) { (0.02, 0.2, -65.0, 8.0) };         // Default: RS
    };
    
    {
      var v = -65.0;
      var u = b * (-65.0);
      var a = a;
      var b = b;
      var c = c;
      var d = d;
      var spikeDetected = false;
      var neuronType = neuronType;
    }
  };

  // Update LIF dynamics
  public func updateLIF(
    lif : LIFState,
    iSyn : Float,            // Synaptic current
    currentTime : Float,
    dt : Float
  ) : Bool {
    // Check refractory period
    if (lif.refractoryTime > 0.0) {
      lif.refractoryTime -= dt;
      return false;
    };
    
    // Leaky integration
    let dv = (-(lif.voltage - LIF_V_REST) + iSyn * 100.0) / LIF_TAU_M * dt;
    lif.voltage += dv;
    
    // Spike adaptation
    lif.adaptation *= 0.999;
    
    // Check threshold
    if (lif.voltage >= LIF_V_THRESH - lif.adaptation) {
      lif.voltage := LIF_V_RESET;
      lif.refractoryTime := LIF_TAU_REF;
      lif.spikeCount += 1;
      lif.adaptation += 2.0;  // Increase adaptation
      lif.lastSpikeTime := currentTime;
      return true;
    };
    
    false
  };

  // Update AdEx dynamics
  public func updateAdEx(
    adex : AdExState,
    iSyn : Float,
    currentTime : Float,
    dt : Float
  ) : Bool {
    let v = adex.voltage;
    let w = adex.w;
    
    // dV/dt = (-(V - E_L) + Δ_T × exp((V - V_T)/Δ_T) - w + I) / τ_m
    let expTerm = ADEX_DELTA_T * exp((v - ADEX_V_T) / ADEX_DELTA_T);
    let dv = (-(v - LIF_V_REST) + expTerm - w + iSyn * 100.0) / ADEX_TAU_M * dt;
    
    // dw/dt = (a × (V - E_L) - w) / τ_w
    let dw = (ADEX_A * (v - LIF_V_REST) - w) / ADEX_TAU_W * dt;
    
    adex.voltage += dv;
    adex.w += dw;
    
    // Spike detection
    if (adex.voltage > 0.0) {
      adex.voltage := LIF_V_RESET;
      adex.w += ADEX_B * 1000.0;
      adex.spikeDetected := true;
      
      // Check for burst
      let timeSinceLast = currentTime - Float.fromInt(adex.burstCount);  // Simplified
      if (timeSinceLast < 20.0) {
        adex.burstCount += 1;
      } else {
        adex.burstCount := 1;
      };
      
      return true;
    };
    
    adex.spikeDetected := false;
    false
  };

  // Update Izhikevich dynamics
  public func updateIzhikevich(
    izh : IzhikevichState,
    iSyn : Float,
    dt : Float
  ) : Bool {
    let v = izh.v;
    let u = izh.u;
    
    // dv/dt = 0.04v² + 5v + 140 - u + I
    let dv = (0.04 * v * v + 5.0 * v + 140.0 - u + iSyn * 10.0) * dt;
    
    // du/dt = a(bv - u)
    let du = izh.a * (izh.b * v - u) * dt;
    
    izh.v += dv;
    izh.u += du;
    
    // Spike and reset
    if (izh.v >= 30.0) {
      izh.v := izh.c;
      izh.u += izh.d;
      izh.spikeDetected := true;
      return true;
    };
    
    izh.spikeDetected := false;
    false
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // CABLE THEORY — DENDRITIC COMPUTATION
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Cable equation for dendritic voltage spread:
  //
  // τ × ∂V/∂t = λ² × ∂²V/∂x² - V + R_m × I_syn
  //
  // Where:
  //   - τ = membrane time constant = R_m × C_m
  //   - λ = length constant = √(R_m / R_i) × √(d/4)
  //   - d = dendrite diameter
  //   - R_m = membrane resistance
  //   - R_i = internal resistance
  //

  public type CableCompartment = {
    var voltage : Float;
    var diameter : Float;                // μm
    var length : Float;                  // μm
    var rm : Float;                      // Membrane resistance (Ω·cm²)
    var ri : Float;                      // Internal resistance (Ω·cm)
    var cm : Float;                      // Membrane capacitance (μF/cm²)
    var lambda : Float;                  // Length constant
    var tau : Float;                     // Time constant
  };

  public type CableModel = {
    compartments : [var CableCompartment];
    var numCompartments : Nat;
    var somaVoltage : Float;
    var totalLength : Float;
    var branchPoints : [var Nat];
    var inputLocations : [var Nat];
  };

  public func initCableCompartment(diameter : Float, length : Float) : CableCompartment {
    let rm = 10000.0;  // Ω·cm²
    let ri = 100.0;    // Ω·cm
    let cm = 1.0;      // μF/cm²
    
    let lambda = Float.sqrt(rm / ri) * Float.sqrt(diameter / 4.0) * 0.01;  // Convert to cm
    let tau = rm * cm;
    
    {
      var voltage = -65.0;
      var diameter = diameter;
      var length = length;
      var rm = rm;
      var ri = ri;
      var cm = cm;
      var lambda = lambda;
      var tau = tau;
    }
  };

  public func initCableModel(numComps : Nat) : CableModel {
    {
      compartments = Array.init<CableCompartment>(numComps, func(i : Nat) : CableCompartment {
        // Taper from thick to thin
        let diameter = 2.0 - Float.fromInt(i) * 0.1;
        let length = 50.0;  // 50 μm each
        initCableCompartment(Float.max(0.5, diameter), length)
      });
      var numCompartments = numComps;
      var somaVoltage = -65.0;
      var totalLength = Float.fromInt(numComps) * 50.0;
      var branchPoints = Array.init<Nat>(5, func(i : Nat) : Nat { i * numComps / 5 });
      var inputLocations = Array.init<Nat>(10, func(i : Nat) : Nat { i });
    }
  };

  // Update cable model with numerical solution
  public func updateCableModel(
    cable : CableModel,
    synapticInputs : [Float],    // Current injection at each compartment
    somaSpike : Bool,            // Backpropagating AP?
    dt : Float
  ) {
    let n = cable.numCompartments;
    if (n < 2) { return };
    
    // Store old voltages
    let oldV = Array.tabulate<Float>(n, func(i : Nat) : Float {
      cable.compartments[i].voltage
    });
    
    // Update each compartment
    for (i in Iter.range(0, n - 1)) {
      let comp = cable.compartments[i];
      let v = oldV[i];
      
      // Coupling to neighbors
      var coupling : Float = 0.0;
      
      if (i > 0) {
        // Coupling to proximal
        let vProx = oldV[i - 1];
        coupling += (vProx - v) / (comp.ri * comp.length / 10000.0);  // Simplified
      } else {
        // Coupling to soma
        coupling += (cable.somaVoltage - v) * 0.1;
      };
      
      if (i < n - 1) {
        // Coupling to distal
        let vDist = oldV[i + 1];
        coupling += (vDist - v) / (comp.ri * comp.length / 10000.0);
      };
      
      // Synaptic input
      let iSyn = if (i < Array.size(synapticInputs)) { synapticInputs[i] } else { 0.0 };
      
      // Cable equation: τ × dV/dt = λ²×d²V/dx² - V + R×I
      let leak = -(v - (-65.0)) / comp.tau;
      let dv = (coupling + leak + iSyn) * dt;
      
      comp.voltage := v + dv;
    };
    
    // Backpropagating action potential
    if (somaSpike) {
      // BAP attenuates with distance
      for (i in Iter.range(0, n - 1)) {
        let attenuation = exp(-Float.fromInt(i) * 0.1);
        cable.compartments[i].voltage += 50.0 * attenuation;
      };
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // KURAMOTO OSCILLATORS — NEURAL SYNCHRONIZATION
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // The Kuramoto model describes coupled oscillators:
  //
  // dθ_i/dt = ω_i + (K/N) × Σ_j sin(θ_j - θ_i)
  //
  // Order parameter: r × exp(iψ) = (1/N) × Σ_j exp(iθ_j)
  //   - r ∈ [0, 1]: synchronization level (0 = incoherent, 1 = fully synchronized)
  //   - ψ: mean phase
  //

  public type KuramotoOscillator = {
    var phase : Float;                   // θ ∈ [0, 2π)
    var naturalFrequency : Float;        // ω (Hz)
    var effectiveFrequency : Float;      // ω + coupling effect
    var amplitude : Float;               // Oscillation amplitude
    var coupling : Float;                // Individual coupling strength
    var phaseVelocity : Float;           // dθ/dt
  };

  public type KuramotoNetwork = {
    oscillators : [var KuramotoOscillator];
    var couplingMatrix : [[var Float]];  // K_ij
    var globalCoupling : Float;          // K
    var orderParameter : Float;          // r
    var meanPhase : Float;               // ψ
    var synchronizationLevel : Float;    // r
    var criticalCoupling : Float;        // K_c
    var isSynchronized : Bool;           // r > 0.5?
  };

  // Kuramoto parameters
  public let KURA_NUM_OSCILLATORS : Nat = 12;
  public let KURA_BASE_COUPLING : Float = 0.1;
  public let KURA_CRITICAL_THRESHOLD : Float = 0.5;

  public func initKuramotoOscillator(index : Nat) : KuramotoOscillator {
    // Natural frequency from fd(k) = 2.5 × 2^(k-4)
    let omega = 2.5 * Float.pow(2.0, Float.fromInt(index) - 4.0);
    
    {
      var phase = Float.fromInt(index) * 2.0 * PI / 12.0;  // Evenly distributed
      var naturalFrequency = omega;
      var effectiveFrequency = omega;
      var amplitude = 1.0;
      var coupling = KURA_BASE_COUPLING;
      var phaseVelocity = omega * 2.0 * PI;
    }
  };

  public func initKuramotoNetwork() : KuramotoNetwork {
    let n = KURA_NUM_OSCILLATORS;
    
    // Initialize coupling matrix with sacred geometry
    let phi = SACRED_PHI;
    let matrix = Array.init<[var Float]>(n, func(i : Nat) : [var Float] {
      Array.init<Float>(n, func(j : Nat) : Float {
        if (i == j) {
          0.0
        } else if (i < 4 and j < 4) {
          phi * KURA_BASE_COUPLING
        } else if (i >= 4 and i < 8 and j >= 4 and j < 8) {
          phi * phi * KURA_BASE_COUPLING
        } else if (i >= 8 and j >= 8) {
          phi * phi * phi * KURA_BASE_COUPLING
        } else {
          KURA_BASE_COUPLING
        }
      })
    });
    
    {
      oscillators = Array.init<KuramotoOscillator>(n, func(i : Nat) : KuramotoOscillator {
        initKuramotoOscillator(i)
      });
      var couplingMatrix = matrix;
      var globalCoupling = KURA_BASE_COUPLING;
      var orderParameter = 0.0;
      var meanPhase = 0.0;
      var synchronizationLevel = 0.0;
      var criticalCoupling = 0.08;  // Estimated K_c
      var isSynchronized = false;
    }
  };

  // Compute order parameter
  public func computeOrderParameter(network : KuramotoNetwork) : (Float, Float) {
    let n = Array.size(network.oscillators);
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    
    for (osc in network.oscillators.vals()) {
      sumCos += cos(osc.phase);
      sumSin += sin(osc.phase);
    };
    
    sumCos /= Float.fromInt(n);
    sumSin /= Float.fromInt(n);
    
    let r = Float.sqrt(sumCos * sumCos + sumSin * sumSin);
    let psi = Float.arctan2(sumSin, sumCos);
    
    (r, psi)
  };

  // Update Kuramoto network
  public func updateKuramotoNetwork(
    network : KuramotoNetwork,
    externalForces : [Float],    // External input to each oscillator
    dt : Float
  ) {
    let n = Array.size(network.oscillators);
    
    // Compute order parameter first
    let (r, psi) = computeOrderParameter(network);
    network.orderParameter := r;
    network.meanPhase := psi;
    network.synchronizationLevel := r;
    network.isSynchronized := r > KURA_CRITICAL_THRESHOLD;
    
    // Update each oscillator
    for (i in Iter.range(0, n - 1)) {
      let osc = network.oscillators[i];
      let theta_i = osc.phase;
      
      // Coupling term: Σ_j K_ij × sin(θ_j - θ_i)
      var couplingSum : Float = 0.0;
      for (j in Iter.range(0, n - 1)) {
        if (i != j) {
          let theta_j = network.oscillators[j].phase;
          let K_ij = network.couplingMatrix[i][j];
          couplingSum += K_ij * sin(theta_j - theta_i);
        };
      };
      
      // External force
      let force = if (i < Array.size(externalForces)) { externalForces[i] } else { 0.0 };
      
      // dθ/dt = ω + coupling + force
      osc.phaseVelocity := osc.naturalFrequency * 2.0 * PI + couplingSum + force;
      osc.effectiveFrequency := osc.phaseVelocity / (2.0 * PI);
      
      // Update phase
      osc.phase += osc.phaseVelocity * dt / 1000.0;  // dt in ms, freq in Hz
      
      // Wrap phase
      if (osc.phase > 2.0 * PI) {
        osc.phase -= 2.0 * PI;
      } else if (osc.phase < 0.0) {
        osc.phase += 2.0 * PI;
      };
    };
  };

  // Learn Kuramoto coupling from activity correlation
  public func updateKuramotoCoupling(
    network : KuramotoNetwork,
    learningRate : Float,
    targetSynchrony : Float,
    dt : Float
  ) {
    let n = Array.size(network.oscillators);
    
    // Error signal
    let syncError = targetSynchrony - network.synchronizationLevel;
    
    // Update coupling matrix
    for (i in Iter.range(0, n - 1)) {
      for (j in Iter.range(0, n - 1)) {
        if (i != j) {
          let theta_i = network.oscillators[i].phase;
          let theta_j = network.oscillators[j].phase;
          
          // Hebbian-like coupling update
          let phaseSimilarity = cos(theta_j - theta_i);
          let dK = learningRate * syncError * phaseSimilarity * dt;
          
          network.couplingMatrix[i][j] += dK;
          network.couplingMatrix[i][j] := clamp(network.couplingMatrix[i][j], 0.0, 1.0);
        };
      };
    };
    
    // Update global coupling
    var meanCoupling : Float = 0.0;
    var count : Nat = 0;
    for (i in Iter.range(0, n - 1)) {
      for (j in Iter.range(0, n - 1)) {
        if (i != j) {
          meanCoupling += network.couplingMatrix[i][j];
          count += 1;
        };
      };
    };
    network.globalCoupling := meanCoupling / Float.fromInt(count);
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // WILSON-COWAN MODEL — POPULATION DYNAMICS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // The Wilson-Cowan model describes excitatory and inhibitory population activity:
  //
  // τ_E × dE/dt = -E + (1 - r_E × E) × S(c_{EE} × E - c_{EI} × I + P)
  // τ_I × dI/dt = -I + (1 - r_I × I) × S(c_{IE} × E - c_{II} × I + Q)
  //
  // Where S(x) = 1/(1 + exp(-a(x - θ))) is the sigmoid
  //

  public type WilsonCowanState = {
    var E : Float;                       // Excitatory activity
    var I : Float;                       // Inhibitory activity
    var cEE : Float;                     // E→E coupling
    var cEI : Float;                     // I→E coupling
    var cIE : Float;                     // E→I coupling
    var cII : Float;                     // I→I coupling
    var tauE : Float;                    // E time constant
    var tauI : Float;                    // I time constant
    var threshE : Float;                 // E threshold
    var threshI : Float;                 // I threshold
    var slopeE : Float;                  // E sigmoid slope
    var slopeI : Float;                  // I sigmoid slope
  };

  public type WilsonCowanNetwork = {
    populations : [var WilsonCowanState];
    var globalE : Float;                 // Mean excitatory
    var globalI : Float;                 // Mean inhibitory
    var eiRatio : Float;                 // E/I balance
    var oscillationFreq : Float;         // Emergent oscillation
    var stabilityIndex : Float;          // Distance from fixed point
  };

  // Wilson-Cowan parameters
  public let WC_TAU_E : Float = 10.0;            // ms
  public let WC_TAU_I : Float = 20.0;            // ms
  public let WC_C_EE : Float = 16.0;
  public let WC_C_EI : Float = 12.0;
  public let WC_C_IE : Float = 15.0;
  public let WC_C_II : Float = 3.0;
  public let WC_THRESH : Float = 4.0;
  public let WC_SLOPE : Float = 1.3;

  public func initWilsonCowanState() : WilsonCowanState {
    {
      var E = 0.1;
      var I = 0.1;
      var cEE = WC_C_EE;
      var cEI = WC_C_EI;
      var cIE = WC_C_IE;
      var cII = WC_C_II;
      var tauE = WC_TAU_E;
      var tauI = WC_TAU_I;
      var threshE = WC_THRESH;
      var threshI = WC_THRESH;
      var slopeE = WC_SLOPE;
      var slopeI = WC_SLOPE;
    }
  };

  public func initWilsonCowanNetwork(numPops : Nat) : WilsonCowanNetwork {
    {
      populations = Array.init<WilsonCowanState>(numPops, func(_ : Nat) : WilsonCowanState {
        initWilsonCowanState()
      });
      var globalE = 0.1;
      var globalI = 0.1;
      var eiRatio = 1.0;
      var oscillationFreq = 0.0;
      var stabilityIndex = 0.0;
    }
  };

  // Sigmoid function for Wilson-Cowan
  func wcSigmoid(x : Float, a : Float, theta : Float) : Float {
    1.0 / (1.0 + exp(-a * (x - theta)))
  };

  // Update Wilson-Cowan dynamics
  public func updateWilsonCowan(
    wc : WilsonCowanState,
    externalE : Float,       // External input to E
    externalI : Float,       // External input to I
    dt : Float
  ) {
    let E = wc.E;
    let I = wc.I;
    
    // E population dynamics
    let inputE = wc.cEE * E - wc.cEI * I + externalE;
    let rateE = wcSigmoid(inputE, wc.slopeE, wc.threshE);
    let dE = (-E + (1.0 - E) * rateE) / wc.tauE * dt;
    
    // I population dynamics
    let inputI = wc.cIE * E - wc.cII * I + externalI;
    let rateI = wcSigmoid(inputI, wc.slopeI, wc.threshI);
    let dI = (-I + (1.0 - I) * rateI) / wc.tauI * dt;
    
    wc.E := clamp(E + dE, 0.0, 1.0);
    wc.I := clamp(I + dI, 0.0, 1.0);
  };

  // Update Wilson-Cowan network
  public func updateWilsonCowanNetwork(
    network : WilsonCowanNetwork,
    externalInputs : [(Float, Float)],   // (E_input, I_input) per population
    interPopCoupling : Float,            // Coupling between populations
    dt : Float
  ) {
    let n = Array.size(network.populations);
    
    // First pass: compute mean activities
    var sumE : Float = 0.0;
    var sumI : Float = 0.0;
    
    for (pop in network.populations.vals()) {
      sumE += pop.E;
      sumI += pop.I;
    };
    
    network.globalE := sumE / Float.fromInt(n);
    network.globalI := sumI / Float.fromInt(n);
    network.eiRatio := network.globalE / (network.globalI + 0.001);
    
    // Second pass: update each population
    for (i in Iter.range(0, n - 1)) {
      let pop = network.populations[i];
      
      // External input
      let (extE, extI) = if (i < Array.size(externalInputs)) {
        externalInputs[i]
      } else {
        (0.0, 0.0)
      };
      
      // Inter-population coupling (adds global activity)
      let coupledE = extE + interPopCoupling * (network.globalE - pop.E);
      let coupledI = extI + interPopCoupling * (network.globalI - pop.I);
      
      updateWilsonCowan(pop, coupledE, coupledI, dt);
    };
    
    // Estimate oscillation frequency from E dynamics
    // (simplified — just track rate of change)
    var maxDerivative : Float = 0.0;
    for (pop in network.populations.vals()) {
      let derivative = Float.abs(pop.E - 0.5);
      if (derivative > maxDerivative) {
        maxDerivative := derivative;
      };
    };
    network.oscillationFreq := maxDerivative * 100.0;  // Rough Hz estimate
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // NEURAL FIELD THEORY — CONTINUOUS SPACE DYNAMICS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Neural field equation (Amari equation):
  //
  // τ × ∂u(x,t)/∂t = -u(x,t) + ∫ w(x,x') × f(u(x',t)) dx' + I_ext(x,t)
  //
  // Where:
  //   - u(x,t) = membrane potential field
  //   - w(x,x') = synaptic connectivity kernel
  //   - f(u) = firing rate function
  //   - I_ext = external input
  //

  public type NeuralFieldState = {
    var activity : [var Float];          // u(x) discretized
    var firingRate : [var Float];        // f(u(x))
    var numPoints : Nat;                 // Spatial discretization
    var spatialExtent : Float;           // Physical extent (mm)
    var dx : Float;                      // Spatial step
    var tau : Float;                     // Time constant
    var threshold : Float;               // Firing threshold
    var gain : Float;                    // Firing rate gain
  };

  public type ConnectivityKernel = {
    var excitationRadius : Float;        // σ_E (mm)
    var inhibitionRadius : Float;        // σ_I (mm)
    var excitationStrength : Float;      // A_E
    var inhibitionStrength : Float;      // A_I
    var kernelType : Text;               // "mexican_hat", "gaussian", etc.
  };

  public type NeuralField = {
    field : NeuralFieldState;
    kernel : ConnectivityKernel;
    var bumpLocations : [var Float];     // Locations of activity bumps
    var bumpWidths : [var Float];        // Widths of bumps
    var totalActivity : Float;           // Integrated activity
    var stabilityIndex : Float;          // Field stability
  };

  // Neural field parameters
  public let NF_NUM_POINTS : Nat = 100;
  public let NF_SPATIAL_EXTENT : Float = 10.0;   // mm
  public let NF_TAU : Float = 10.0;              // ms
  public let NF_THRESHOLD : Float = 0.0;
  public let NF_GAIN : Float = 1.0;
  public let NF_SIGMA_E : Float = 1.0;           // mm
  public let NF_SIGMA_I : Float = 2.0;           // mm
  public let NF_A_E : Float = 1.0;
  public let NF_A_I : Float = 0.5;

  public func initNeuralFieldState() : NeuralFieldState {
    let n = NF_NUM_POINTS;
    let dx = NF_SPATIAL_EXTENT / Float.fromInt(n);
    
    {
      var activity = Array.init<Float>(n, func(_ : Nat) : Float { 0.0 });
      var firingRate = Array.init<Float>(n, func(_ : Nat) : Float { 0.0 });
      var numPoints = n;
      var spatialExtent = NF_SPATIAL_EXTENT;
      var dx = dx;
      var tau = NF_TAU;
      var threshold = NF_THRESHOLD;
      var gain = NF_GAIN;
    }
  };

  public func initConnectivityKernel() : ConnectivityKernel {
    {
      var excitationRadius = NF_SIGMA_E;
      var inhibitionRadius = NF_SIGMA_I;
      var excitationStrength = NF_A_E;
      var inhibitionStrength = NF_A_I;
      var kernelType = "mexican_hat";
    }
  };

  public func initNeuralField() : NeuralField {
    {
      field = initNeuralFieldState();
      kernel = initConnectivityKernel();
      var bumpLocations = Array.init<Float>(5, func(_ : Nat) : Float { 0.0 });
      var bumpWidths = Array.init<Float>(5, func(_ : Nat) : Float { 0.0 });
      var totalActivity = 0.0;
      var stabilityIndex = 1.0;
    }
  };

  // Mexican hat connectivity kernel
  func mexicanHat(x : Float, sigmaE : Float, sigmaI : Float, aE : Float, aI : Float) : Float {
    let excitation = aE * exp(-x * x / (2.0 * sigmaE * sigmaE));
    let inhibition = aI * exp(-x * x / (2.0 * sigmaI * sigmaI));
    excitation - inhibition
  };

  // Firing rate function
  func firingRateFunc(u : Float, threshold : Float, gain : Float) : Float {
    if (u < threshold) {
      0.0
    } else {
      let x = gain * (u - threshold);
      x / (1.0 + x)  // Naka-Rushton
    }
  };

  // Update neural field
  public func updateNeuralField(
    nf : NeuralField,
    externalInput : [Float],
    dt : Float
  ) {
    let n = nf.field.numPoints;
    let dx = nf.field.dx;
    
    // Compute firing rates
    for (i in Iter.range(0, n - 1)) {
      nf.field.firingRate[i] := firingRateFunc(nf.field.activity[i], nf.field.threshold, nf.field.gain);
    };
    
    // Compute synaptic input via convolution with kernel
    let newActivity = Array.init<Float>(n, func(i : Nat) : Float {
      var synInput : Float = 0.0;
      
      for (j in Iter.range(0, n - 1)) {
        // Distance between points
        let xi = Float.fromInt(i) * dx;
        let xj = Float.fromInt(j) * dx;
        let distance = Float.abs(xi - xj);
        
        // Kernel value
        let w = mexicanHat(
          distance,
          nf.kernel.excitationRadius,
          nf.kernel.inhibitionRadius,
          nf.kernel.excitationStrength,
          nf.kernel.inhibitionStrength
        );
        
        synInput += w * nf.field.firingRate[j] * dx;
      };
      
      // External input
      let ext = if (i < Array.size(externalInput)) { externalInput[i] } else { 0.0 };
      
      // Neural field equation
      let u = nf.field.activity[i];
      let du = (-u + synInput + ext) / nf.field.tau * dt;
      
      u + du
    });
    
    // Update activity
    var total : Float = 0.0;
    for (i in Iter.range(0, n - 1)) {
      nf.field.activity[i] := newActivity[i];
      total += nf.field.firingRate[i];
    };
    nf.totalActivity := total * dx;
    
    // Find bump locations (peaks)
    var bumpIdx : Nat = 0;
    for (i in Iter.range(1, n - 2)) {
      if (nf.field.activity[i] > nf.field.activity[i - 1] and
          nf.field.activity[i] > nf.field.activity[i + 1] and
          nf.field.activity[i] > nf.field.threshold and
          bumpIdx < 5) {
        nf.bumpLocations[bumpIdx] := Float.fromInt(i) * dx;
        bumpIdx += 1;
      };
    };
  };


  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SPIKE TIMING NETWORKS — PRECISE TEMPORAL CODING
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Beyond rate coding — neurons communicate via precise spike timing:
  //
  // 1. POLYCHRONIZATION:
  //    - Axonal delays create precise timing groups
  //    - Different patterns for different inputs
  //    - Exponential storage capacity
  //
  // 2. SYNFIRE CHAINS:
  //    - Synchronous volleys propagate through layers
  //    - Temporal precision maintained
  //    - Sequence encoding
  //
  // 3. RESERVOIR COMPUTING:
  //    - High-dimensional state space
  //    - Temporal memory via dynamics
  //    - Linear readout
  //

  public type SpikeEvent = {
    time : Float;
    neuronId : Nat;
    amplitude : Float;
  };

  public type SpikeTimingNetwork = {
    var spikeHistory : [var SpikeEvent];
    var historySize : Nat;
    var writeIdx : Nat;
    var axonalDelays : [[var Float]];    // Delay from i to j (ms)
    var polychronicGroups : [[var Nat]]; // Groups of neurons
    var groupCount : Nat;
    var temporalPrecision : Float;       // Required precision (ms)
  };

  public type SynfireChain = {
    var layers : [[var Nat]];            // Neuron indices per layer
    var numLayers : Nat;
    var neuronsPerLayer : Nat;
    var currentLayer : Nat;
    var volleySize : Float;              // Synchrony measure
    var propagationTime : Float;         // Inter-layer delay
    var chainActive : Bool;
  };

  public type ReservoirState = {
    var states : [var Float];            // Reservoir neuron states
    var weights : [[var Float]];         // Recurrent weights
    var inputWeights : [var Float];      // Input weights
    var outputWeights : [var Float];     // Readout weights
    var spectralRadius : Float;          // Scaling for weights
    var leakRate : Float;                // Leaky integration
    var reservoirSize : Nat;
    var memoryCapacity : Float;          // Estimated memory
  };

  // Spike timing parameters
  public let STN_HISTORY_SIZE : Nat = 1000;
  public let STN_PRECISION : Float = 1.0;          // ms
  public let STN_MAX_DELAY : Float = 20.0;         // ms
  public let STN_MAX_GROUPS : Nat = 100;

  public func initSpikeTimingNetwork(numNeurons : Nat) : SpikeTimingNetwork {
    {
      var spikeHistory = Array.init<SpikeEvent>(STN_HISTORY_SIZE, func(_ : Nat) : SpikeEvent {
        { time = -1000.0; neuronId = 0; amplitude = 0.0 }
      });
      var historySize = STN_HISTORY_SIZE;
      var writeIdx = 0;
      var axonalDelays = Array.init<[var Float]>(numNeurons, func(i : Nat) : [var Float] {
        Array.init<Float>(numNeurons, func(j : Nat) : Float {
          // Random delays based on distance
          Float.fromInt((i * 7 + j * 11) % 20) + 1.0
        })
      });
      var polychronicGroups = Array.init<[var Nat]>(STN_MAX_GROUPS, func(_ : Nat) : [var Nat] {
        Array.init<Nat>(10, func(_ : Nat) : Nat { 0 })
      });
      var groupCount = 0;
      var temporalPrecision = STN_PRECISION;
    }
  };

  public func initSynfireChain(numLayers : Nat, neuronsPerLayer : Nat) : SynfireChain {
    {
      var layers = Array.init<[var Nat]>(numLayers, func(l : Nat) : [var Nat] {
        Array.init<Nat>(neuronsPerLayer, func(n : Nat) : Nat {
          l * neuronsPerLayer + n
        })
      });
      var numLayers = numLayers;
      var neuronsPerLayer = neuronsPerLayer;
      var currentLayer = 0;
      var volleySize = 0.0;
      var propagationTime = 10.0;
      var chainActive = false;
    }
  };

  public func initReservoirState(size : Nat) : ReservoirState {
    let spectralRadius = 0.9;
    
    {
      var states = Array.init<Float>(size, func(_ : Nat) : Float { 0.0 });
      var weights = Array.init<[var Float]>(size, func(i : Nat) : [var Float] {
        Array.init<Float>(size, func(j : Nat) : Float {
          // Sparse random weights
          if ((i * 13 + j * 17) % 10 < 3) {
            (Float.fromInt((i * j) % 100) / 50.0 - 1.0) * spectralRadius / Float.fromInt(size)
          } else {
            0.0
          }
        })
      });
      var inputWeights = Array.init<Float>(size, func(i : Nat) : Float {
        (Float.fromInt(i % 100) / 50.0 - 1.0) * 0.5
      });
      var outputWeights = Array.init<Float>(size, func(_ : Nat) : Float { 0.0 });
      var spectralRadius = spectralRadius;
      var leakRate = 0.3;
      var reservoirSize = size;
      var memoryCapacity = 0.0;
    }
  };

  // Record spike event
  public func recordSpike(stn : SpikeTimingNetwork, neuronId : Nat, time : Float, amplitude : Float) {
    stn.spikeHistory[stn.writeIdx] := { time = time; neuronId = neuronId; amplitude = amplitude };
    stn.writeIdx := (stn.writeIdx + 1) % stn.historySize;
  };

  // Detect polychronic groups
  public func detectPolychronicGroups(stn : SpikeTimingNetwork, threshold : Nat) {
    // Simplified: look for neurons that spike within precision window
    // Real implementation would check for consistent delay-compensated patterns
    
    var groupNeurons = Array.init<Nat>(10, func(_ : Nat) : Nat { 0 });
    var groupSize : Nat = 0;
    var lastTime : Float = -1000.0;
    
    for (i in Iter.range(0, stn.historySize - 1)) {
      let spike = stn.spikeHistory[i];
      if (spike.time > 0.0) {
        if (spike.time - lastTime < stn.temporalPrecision) {
          if (groupSize < 10) {
            groupNeurons[groupSize] := spike.neuronId;
            groupSize += 1;
          };
        } else {
          if (groupSize >= threshold and stn.groupCount < STN_MAX_GROUPS) {
            for (j in Iter.range(0, groupSize - 1)) {
              stn.polychronicGroups[stn.groupCount][j] := groupNeurons[j];
            };
            stn.groupCount += 1;
          };
          groupSize := 1;
          groupNeurons[0] := spike.neuronId;
        };
        lastTime := spike.time;
      };
    };
  };

  // Update synfire chain
  public func updateSynfireChain(
    chain : SynfireChain,
    neuronSpikes : [Bool],
    currentTime : Float,
    dt : Float
  ) {
    if (not chain.chainActive) {
      // Check if first layer is activated
      var firstLayerActive : Nat = 0;
      for (n in Iter.range(0, chain.neuronsPerLayer - 1)) {
        let neuronIdx = chain.layers[0][n];
        if (neuronIdx < Array.size(neuronSpikes) and neuronSpikes[neuronIdx]) {
          firstLayerActive += 1;
        };
      };
      
      if (Float.fromInt(firstLayerActive) > Float.fromInt(chain.neuronsPerLayer) * 0.5) {
        chain.chainActive := true;
        chain.currentLayer := 0;
        chain.volleySize := Float.fromInt(firstLayerActive);
      };
      return;
    };
    
    // Check for propagation to next layer
    if (chain.currentLayer < chain.numLayers - 1) {
      var nextLayerActive : Nat = 0;
      for (n in Iter.range(0, chain.neuronsPerLayer - 1)) {
        let neuronIdx = chain.layers[chain.currentLayer + 1][n];
        if (neuronIdx < Array.size(neuronSpikes) and neuronSpikes[neuronIdx]) {
          nextLayerActive += 1;
        };
      };
      
      if (nextLayerActive > 0) {
        chain.currentLayer += 1;
        chain.volleySize := 0.9 * chain.volleySize + 0.1 * Float.fromInt(nextLayerActive);
      };
    } else {
      // Chain complete
      chain.chainActive := false;
      chain.currentLayer := 0;
    };
  };

  // Update reservoir
  public func updateReservoir(
    res : ReservoirState,
    input : Float,
    dt : Float
  ) : Float {
    let size = res.reservoirSize;
    
    // Compute new states
    for (i in Iter.range(0, size - 1)) {
      var recurrentInput : Float = 0.0;
      for (j in Iter.range(0, size - 1)) {
        recurrentInput += res.weights[i][j] * res.states[j];
      };
      
      let totalInput = recurrentInput + res.inputWeights[i] * input;
      
      // Leaky integration with tanh activation
      res.states[i] := (1.0 - res.leakRate) * res.states[i] + 
                        res.leakRate * (2.0 / (1.0 + exp(-2.0 * totalInput)) - 1.0);
    };
    
    // Compute output
    var output : Float = 0.0;
    for (i in Iter.range(0, size - 1)) {
      output += res.outputWeights[i] * res.states[i];
    };
    
    output
  };

  // Train reservoir readout (simple linear regression step)
  public func trainReservoirReadout(
    res : ReservoirState,
    targetOutput : Float,
    learningRate : Float
  ) {
    // Compute current output
    var output : Float = 0.0;
    for (i in Iter.range(0, res.reservoirSize - 1)) {
      output += res.outputWeights[i] * res.states[i];
    };
    
    // Error
    let error = targetOutput - output;
    
    // Update output weights
    for (i in Iter.range(0, res.reservoirSize - 1)) {
      res.outputWeights[i] += learningRate * error * res.states[i];
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // PREDICTIVE CODING — HIERARCHICAL INFERENCE
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // The brain as a prediction machine (Friston, Clark):
  //
  // Higher levels predict lower levels; only prediction errors propagate up.
  //
  // x̂_l = f_l(x̂_{l+1})     — Top-down prediction
  // ε_l = x_l - x̂_l        — Prediction error
  // x̂_l ← x̂_l + κ × Π_l × ε_l  — Update with precision weighting
  //

  public type PredictiveCodingLayer = {
    idx : Nat;
    var representation : [var Float];    // Current belief
    var prediction : [var Float];        // Prediction from above
    var predictionError : [var Float];   // Mismatch
    var precision : [var Float];         // Confidence weights
    var generativeWeights : [[var Float]]; // Top-down weights
    var inferenceWeights : [[var Float]]; // Bottom-up error weights
    var learningRate : Float;
  };

  public type PredictiveCodingNetwork = {
    var layers : [var PredictiveCodingLayer];
    var numLayers : Nat;
    var freeEnergy : Float;              // Total prediction error
    var complexityTerm : Float;          // KL divergence from prior
    var accuracyTerm : Float;            // Data fit
    var precision : Float;               // Global precision
  };

  // Predictive coding parameters
  public let PC_NUM_LAYERS : Nat = 4;
  public let PC_DIM_PER_LAYER : Nat = 16;
  public let PC_LEARNING_RATE : Float = 0.01;
  public let PC_PRECISION_RATE : Float = 0.001;

  public func initPredictiveCodingLayer(idx : Nat, dim : Nat) : PredictiveCodingLayer {
    {
      idx = idx;
      var representation = Array.init<Float>(dim, func(_ : Nat) : Float { 0.5 });
      var prediction = Array.init<Float>(dim, func(_ : Nat) : Float { 0.5 });
      var predictionError = Array.init<Float>(dim, func(_ : Nat) : Float { 0.0 });
      var precision = Array.init<Float>(dim, func(_ : Nat) : Float { 1.0 });
      var generativeWeights = Array.init<[var Float]>(dim, func(_ : Nat) : [var Float] {
        Array.init<Float>(dim, func(j : Nat) : Float {
          if (j == 0) { 0.5 } else { 0.0 }
        })
      });
      var inferenceWeights = Array.init<[var Float]>(dim, func(_ : Nat) : [var Float] {
        Array.init<Float>(dim, func(j : Nat) : Float {
          if (j == 0) { 0.5 } else { 0.0 }
        })
      });
      var learningRate = PC_LEARNING_RATE;
    }
  };

  public func initPredictiveCodingNetwork() : PredictiveCodingNetwork {
    let layers = Array.init<PredictiveCodingLayer>(PC_NUM_LAYERS, func(i : Nat) : PredictiveCodingLayer {
      let dim = PC_DIM_PER_LAYER / Nat.pow(2, i);  // Hierarchical reduction
      initPredictiveCodingLayer(i, Nat.max(4, dim))
    });
    
    {
      var layers = layers;
      var numLayers = PC_NUM_LAYERS;
      var freeEnergy = 0.0;
      var complexityTerm = 0.0;
      var accuracyTerm = 0.0;
      var precision = 1.0;
    }
  };

  // Generate top-down predictions
  public func generatePredictions(network : PredictiveCodingNetwork) {
    // Start from top layer and predict down
    for (l in Iter.range(1, network.numLayers - 1)) {
      let upperLayer = network.layers[network.numLayers - 1 - l + 1];
      let lowerLayer = network.layers[network.numLayers - 1 - l];
      
      let upperDim = Array.size(upperLayer.representation);
      let lowerDim = Array.size(lowerLayer.prediction);
      
      // Predict lower layer from upper
      for (i in Iter.range(0, lowerDim - 1)) {
        var pred : Float = 0.0;
        for (j in Iter.range(0, Nat.min(upperDim, lowerDim) - 1)) {
          pred += lowerLayer.generativeWeights[i][j] * upperLayer.representation[j];
        };
        lowerLayer.prediction[i] := sigmoid(pred);
      };
    };
  };

  // Compute prediction errors
  public func computePredictionErrors(network : PredictiveCodingNetwork, observation : [Float]) {
    // Bottom layer error is observation - prediction
    let bottomLayer = network.layers[0];
    let bottomDim = Array.size(bottomLayer.predictionError);
    
    var totalError : Float = 0.0;
    
    for (i in Iter.range(0, bottomDim - 1)) {
      let obs = if (i < Array.size(observation)) { observation[i] } else { 0.5 };
      bottomLayer.predictionError[i] := obs - bottomLayer.prediction[i];
      totalError += bottomLayer.predictionError[i] * bottomLayer.predictionError[i] * bottomLayer.precision[i];
    };
    
    // Propagate errors up
    for (l in Iter.range(1, network.numLayers - 1)) {
      let lowerLayer = network.layers[l - 1];
      let upperLayer = network.layers[l];
      
      let lowerDim = Array.size(lowerLayer.predictionError);
      let upperDim = Array.size(upperLayer.predictionError);
      
      for (i in Iter.range(0, upperDim - 1)) {
        var errorSum : Float = 0.0;
        for (j in Iter.range(0, Nat.min(lowerDim, upperDim) - 1)) {
          errorSum += upperLayer.inferenceWeights[i][j] * lowerLayer.predictionError[j] * lowerLayer.precision[j];
        };
        upperLayer.predictionError[i] := errorSum;
        totalError += errorSum * errorSum;
      };
    };
    
    network.freeEnergy := totalError;
  };

  // Update representations to minimize free energy
  public func updateRepresentations(network : PredictiveCodingNetwork, dt : Float) {
    for (l in Iter.range(0, network.numLayers - 1)) {
      let layer = network.layers[l];
      let dim = Array.size(layer.representation);
      
      for (i in Iter.range(0, dim - 1)) {
        // Gradient descent on prediction error
        let update = layer.learningRate * layer.precision[i] * layer.predictionError[i];
        layer.representation[i] += update * dt;
        layer.representation[i] := clamp(layer.representation[i], 0.0, 1.0);
      };
    };
  };

  // Update generative weights (learning)
  public func updateGenerativeWeights(network : PredictiveCodingNetwork, dt : Float) {
    for (l in Iter.range(0, network.numLayers - 2)) {
      let lowerLayer = network.layers[l];
      let upperLayer = network.layers[l + 1];
      
      let lowerDim = Array.size(lowerLayer.generativeWeights);
      let upperDim = Array.size(upperLayer.representation);
      
      // Hebbian-like weight update
      for (i in Iter.range(0, lowerDim - 1)) {
        for (j in Iter.range(0, Nat.min(upperDim, lowerDim) - 1)) {
          let dw = lowerLayer.learningRate * lowerLayer.predictionError[i] * upperLayer.representation[j];
          lowerLayer.generativeWeights[i][j] += dw * dt;
        };
      };
    };
  };

  // Full predictive coding update
  public func updatePredictiveCoding(
    network : PredictiveCodingNetwork,
    observation : [Float],
    dt : Float
  ) {
    generatePredictions(network);
    computePredictionErrors(network, observation);
    updateRepresentations(network, dt);
    updateGenerativeWeights(network, dt);
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // FREE ENERGY PRINCIPLE — ACTIVE INFERENCE
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // The organism minimizes free energy through:
  //   1. Perception: Updating internal model (passive inference)
  //   2. Action: Changing the world to match predictions (active inference)
  //
  // F = E_q[log q(s) - log p(o,s)] = D_KL(q||p) - log p(o)
  //

  public type FreeEnergyState = {
    var freeEnergy : Float;              // F
    var expectedFreeEnergy : [var Float]; // G for each action
    var predictionError : Float;         // Sensory PE
    var complexity : Float;              // KL divergence
    var accuracy : Float;                // Log evidence
    var precision : Float;               // Confidence
    var expectedPrecision : Float;       // Expected precision
    var actionProbabilities : [var Float]; // Policy
    var selectedAction : Nat;            // Chosen action
    var priorPreferences : [var Float];  // Desired outcomes
  };

  public type ActiveInferenceAgent = {
    freeEnergy : FreeEnergyState;
    predictiveCoding : PredictiveCodingNetwork;
    var beliefState : [var Float];       // Current beliefs
    var actionSpace : Nat;               // Number of actions
    var explorationRate : Float;         // Epistemic value weight
    var pragmaticValue : Float;          // Reward-seeking
    var currentAction : Nat;
    var actionHistory : [var Nat];
  };

  // Free energy parameters
  public let FE_EXPLORATION_RATE : Float = 0.1;
  public let FE_PRAGMATIC_WEIGHT : Float = 0.9;
  public let FE_ACTION_SPACE : Nat = 5;

  public func initFreeEnergyState(numActions : Nat) : FreeEnergyState {
    {
      var freeEnergy = 0.0;
      var expectedFreeEnergy = Array.init<Float>(numActions, func(_ : Nat) : Float { 0.0 });
      var predictionError = 0.0;
      var complexity = 0.0;
      var accuracy = 0.0;
      var precision = 1.0;
      var expectedPrecision = 1.0;
      var actionProbabilities = Array.init<Float>(numActions, func(_ : Nat) : Float { 1.0 / Float.fromInt(numActions) });
      var selectedAction = 0;
      var priorPreferences = Array.init<Float>(8, func(i : Nat) : Float {
        if (i < 4) { 0.8 } else { 0.2 }  // Prefer some outcomes
      });
    }
  };

  public func initActiveInferenceAgent() : ActiveInferenceAgent {
    {
      freeEnergy = initFreeEnergyState(FE_ACTION_SPACE);
      predictiveCoding = initPredictiveCodingNetwork();
      var beliefState = Array.init<Float>(16, func(_ : Nat) : Float { 0.5 });
      var actionSpace = FE_ACTION_SPACE;
      var explorationRate = FE_EXPLORATION_RATE;
      var pragmaticValue = FE_PRAGMATIC_WEIGHT;
      var currentAction = 0;
      var actionHistory = Array.init<Nat>(100, func(_ : Nat) : Nat { 0 });
    }
  };

  // Compute expected free energy for action
  public func computeExpectedFreeEnergy(
    agent : ActiveInferenceAgent,
    action : Nat,
    predictedOutcome : [Float]
  ) : Float {
    let fe = agent.freeEnergy;
    
    // Epistemic value (information gain / uncertainty reduction)
    var epistemicValue : Float = 0.0;
    for (i in Iter.range(0, Array.size(predictedOutcome) - 1)) {
      let p = predictedOutcome[i];
      if (p > 0.0 and p < 1.0) {
        epistemicValue -= p * ln(p);  // Entropy
      };
    };
    
    // Pragmatic value (match to preferences)
    var pragmaticValue : Float = 0.0;
    let prefSize = Nat.min(Array.size(predictedOutcome), Array.size(fe.priorPreferences));
    for (i in Iter.range(0, prefSize - 1)) {
      pragmaticValue += predictedOutcome[i] * fe.priorPreferences[i];
    };
    
    // G = -epistemic - pragmatic (we minimize G, so more negative = better)
    -(agent.explorationRate * epistemicValue + agent.pragmaticValue * pragmaticValue)
  };

  // Select action based on expected free energy
  public func selectAction(agent : ActiveInferenceAgent) : Nat {
    let numActions = agent.actionSpace;
    
    // Softmax over negative expected free energy
    var sumExp : Float = 0.0;
    for (a in Iter.range(0, numActions - 1)) {
      let g = agent.freeEnergy.expectedFreeEnergy[a];
      sumExp += exp(-g);  // Minimize G, so -G
    };
    
    // Compute probabilities
    for (a in Iter.range(0, numActions - 1)) {
      let g = agent.freeEnergy.expectedFreeEnergy[a];
      agent.freeEnergy.actionProbabilities[a] := exp(-g) / sumExp;
    };
    
    // Select action (simplified: argmax)
    var bestAction : Nat = 0;
    var bestProb : Float = 0.0;
    for (a in Iter.range(0, numActions - 1)) {
      if (agent.freeEnergy.actionProbabilities[a] > bestProb) {
        bestProb := agent.freeEnergy.actionProbabilities[a];
        bestAction := a;
      };
    };
    
    agent.freeEnergy.selectedAction := bestAction;
    agent.currentAction := bestAction;
    
    bestAction
  };

  // Full active inference update
  public func updateActiveInference(
    agent : ActiveInferenceAgent,
    observation : [Float],
    dt : Float
  ) : Nat {
    // 1. Update beliefs (perception)
    updatePredictiveCoding(agent.predictiveCoding, observation, dt);
    
    // 2. Update free energy
    agent.freeEnergy.freeEnergy := agent.predictiveCoding.freeEnergy;
    agent.freeEnergy.predictionError := agent.predictiveCoding.accuracyTerm;
    agent.freeEnergy.complexity := agent.predictiveCoding.complexityTerm;
    
    // 3. Compute expected free energy for each action
    for (a in Iter.range(0, agent.actionSpace - 1)) {
      // Predict outcome of action (simplified: shift beliefs)
      let predictedOutcome = Array.tabulate<Float>(Array.size(agent.beliefState), func(i : Nat) : Float {
        let shift = Float.fromInt((i + a) % Array.size(agent.beliefState));
        agent.beliefState[Int.abs(Float.toInt(shift))]
      });
      agent.freeEnergy.expectedFreeEnergy[a] := computeExpectedFreeEnergy(agent, a, predictedOutcome);
    };
    
    // 4. Select action
    selectAction(agent)
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // REINFORCEMENT LEARNING INTEGRATION — TD LEARNING + HEBBIAN
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Combining Hebbian plasticity with RL for biologically plausible credit assignment:
  //
  // 1. TD ERROR:
  //    δ = r + γV(s') - V(s)
  //    Encoded by dopamine signals
  //
  // 2. ELIGIBILITY TRACES:
  //    e(s,a) ← γλe(s,a) + ∇w log π(a|s)
  //    "Tags" that mark recently active synapses
  //
  // 3. THREE-FACTOR RULE:
  //    Δw = η × pre × post × δ
  //    Only change weights when reward signal arrives
  //

  public type TDLearningState = {
    var stateValues : [var Float];       // V(s)
    var actionValues : [[var Float]];    // Q(s,a)
    var eligibilityTraces : [[var Float]]; // e(s,a)
    var tdError : Float;                 // δ
    var discountFactor : Float;          // γ
    var traceDecay : Float;              // λ
    var learningRate : Float;            // α
    var currentState : Nat;
    var previousState : Nat;
    var lastAction : Nat;
    var lastReward : Float;
  };

  public type ActorCriticState = {
    var actorWeights : [[var Float]];    // Policy weights
    var criticWeights : [var Float];     // Value function weights
    var policy : [var Float];            // π(a|s)
    var stateValue : Float;              // V(s)
    var actorLR : Float;                 // Actor learning rate
    var criticLR : Float;                // Critic learning rate
    var entropy : Float;                 // Policy entropy
    var entropyCoeff : Float;            // Entropy regularization
  };

  public type BiologicalRLState = {
    td : TDLearningState;
    ac : ActorCriticState;
    var dopamineLevel : Float;           // DA ~ TD error
    var serotoninLevel : Float;          // 5-HT ~ avg reward
    var norepinephrineLevel : Float;     // NE ~ uncertainty
    var acetylcholineLevel : Float;      // ACh ~ attention
    var eligibilityWindow : Float;       // Time eligibility lasts
    var rewardHistory : [var Float];     // Recent rewards
    var exploitExploreBalance : Float;   // Softmax temperature
  };

  // RL parameters
  public let RL_NUM_STATES : Nat = 20;
  public let RL_NUM_ACTIONS : Nat = 5;
  public let RL_GAMMA : Float = 0.99;
  public let RL_LAMBDA : Float = 0.9;
  public let RL_ALPHA : Float = 0.01;

  public func initTDLearningState() : TDLearningState {
    {
      var stateValues = Array.init<Float>(RL_NUM_STATES, func(_ : Nat) : Float { 0.0 });
      var actionValues = Array.init<[var Float]>(RL_NUM_STATES, func(_ : Nat) : [var Float] {
        Array.init<Float>(RL_NUM_ACTIONS, func(_ : Nat) : Float { 0.0 })
      });
      var eligibilityTraces = Array.init<[var Float]>(RL_NUM_STATES, func(_ : Nat) : [var Float] {
        Array.init<Float>(RL_NUM_ACTIONS, func(_ : Nat) : Float { 0.0 })
      });
      var tdError = 0.0;
      var discountFactor = RL_GAMMA;
      var traceDecay = RL_LAMBDA;
      var learningRate = RL_ALPHA;
      var currentState = 0;
      var previousState = 0;
      var lastAction = 0;
      var lastReward = 0.0;
    }
  };

  public func initActorCriticState() : ActorCriticState {
    {
      var actorWeights = Array.init<[var Float]>(RL_NUM_STATES, func(_ : Nat) : [var Float] {
        Array.init<Float>(RL_NUM_ACTIONS, func(_ : Nat) : Float { 0.0 })
      });
      var criticWeights = Array.init<Float>(RL_NUM_STATES, func(_ : Nat) : Float { 0.0 });
      var policy = Array.init<Float>(RL_NUM_ACTIONS, func(_ : Nat) : Float { 1.0 / Float.fromInt(RL_NUM_ACTIONS) });
      var stateValue = 0.0;
      var actorLR = 0.001;
      var criticLR = 0.01;
      var entropy = 0.0;
      var entropyCoeff = 0.01;
    }
  };

  public func initBiologicalRLState() : BiologicalRLState {
    {
      td = initTDLearningState();
      ac = initActorCriticState();
      var dopamineLevel = 0.0;
      var serotoninLevel = 0.5;
      var norepinephrineLevel = 0.3;
      var acetylcholineLevel = 0.5;
      var eligibilityWindow = 1000.0;
      var rewardHistory = Array.init<Float>(100, func(_ : Nat) : Float { 0.0 });
      var exploitExploreBalance = 1.0;
    }
  };

  // Compute TD error
  public func computeTDError(rl : BiologicalRLState, reward : Float, nextState : Nat) {
    let td = rl.td;
    
    // δ = r + γV(s') - V(s)
    let currentValue = td.stateValues[td.currentState];
    let nextValue = if (nextState < RL_NUM_STATES) { td.stateValues[nextState] } else { 0.0 };
    
    td.tdError := reward + td.discountFactor * nextValue - currentValue;
    td.lastReward := reward;
    
    // Map to dopamine
    rl.dopamineLevel := 0.5 + 0.5 * sigmoid(td.tdError * 5.0);
  };

  // Update eligibility traces
  public func updateEligibilityTraces(rl : BiologicalRLState, state : Nat, action : Nat, dt : Float) {
    let td = rl.td;
    
    // Decay all traces
    for (s in Iter.range(0, RL_NUM_STATES - 1)) {
      for (a in Iter.range(0, RL_NUM_ACTIONS - 1)) {
        td.eligibilityTraces[s][a] *= td.discountFactor * td.traceDecay;
      };
    };
    
    // Increment current trace
    if (state < RL_NUM_STATES and action < RL_NUM_ACTIONS) {
      td.eligibilityTraces[state][action] += 1.0;
    };
  };

  // Update values using TD learning
  public func updateTDLearning(rl : BiologicalRLState, reward : Float, nextState : Nat, action : Nat, dt : Float) {
    let td = rl.td;
    
    computeTDError(rl, reward, nextState);
    updateEligibilityTraces(rl, td.currentState, action, dt);
    
    // Update all state-action values using eligibility traces
    for (s in Iter.range(0, RL_NUM_STATES - 1)) {
      // State value
      td.stateValues[s] += td.learningRate * td.tdError * td.eligibilityTraces[s][0];
      
      // Action values
      for (a in Iter.range(0, RL_NUM_ACTIONS - 1)) {
        td.actionValues[s][a] += td.learningRate * td.tdError * td.eligibilityTraces[s][a];
      };
    };
    
    td.previousState := td.currentState;
    td.currentState := nextState;
    td.lastAction := action;
  };

  // Compute policy from action values
  public func computePolicy(rl : BiologicalRLState, state : Nat) {
    let ac = rl.ac;
    let td = rl.td;
    
    if (state >= RL_NUM_STATES) { return };
    
    // Softmax over Q values
    var sumExp : Float = 0.0;
    for (a in Iter.range(0, RL_NUM_ACTIONS - 1)) {
      sumExp += exp(td.actionValues[state][a] / rl.exploitExploreBalance);
    };
    
    for (a in Iter.range(0, RL_NUM_ACTIONS - 1)) {
      ac.policy[a] := exp(td.actionValues[state][a] / rl.exploitExploreBalance) / sumExp;
    };
    
    // Compute entropy
    ac.entropy := 0.0;
    for (a in Iter.range(0, RL_NUM_ACTIONS - 1)) {
      if (ac.policy[a] > 0.0) {
        ac.entropy -= ac.policy[a] * ln(ac.policy[a]);
      };
    };
    
    // NE reflects uncertainty
    rl.norepinephrineLevel := ac.entropy / ln(Float.fromInt(RL_NUM_ACTIONS));
  };

  // Select action from policy
  public func selectRLAction(rl : BiologicalRLState, state : Nat) : Nat {
    computePolicy(rl, state);
    
    // Argmax (greedy) for simplicity
    var bestAction : Nat = 0;
    var bestProb : Float = 0.0;
    for (a in Iter.range(0, RL_NUM_ACTIONS - 1)) {
      if (rl.ac.policy[a] > bestProb) {
        bestProb := rl.ac.policy[a];
        bestAction := a;
      };
    };
    
    bestAction
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // MEMORY SYSTEMS — COMPLEMENTARY LEARNING
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Two complementary memory systems (McClelland et al.):
  //
  // 1. HIPPOCAMPUS (fast):
  //    - Rapid one-shot learning
  //    - Sparse representations
  //    - Episodic memory
  //
  // 2. NEOCORTEX (slow):
  //    - Gradual learning
  //    - Distributed representations
  //    - Semantic memory
  //
  // Interleaved replay bridges the two.
  //

  public type EpisodicMemory = {
    var patterns : [[var Float]];        // Stored patterns
    var contexts : [[var Float]];        // Associated contexts
    var timestamps : [var Float];        // When stored
    var strengths : [var Float];         // Memory strength
    var numMemories : Nat;
    var capacity : Nat;
    var writeIdx : Nat;
    var retrievalCue : [var Float];      // Current query
    var retrievedPattern : [var Float];  // Retrieved memory
    var retrievalStrength : Float;       // Retrieval confidence
  };

  public type SemanticMemory = {
    var conceptVectors : [[var Float]];  // Concept representations
    var associations : [[var Float]];    // Concept-concept weights
    var numConcepts : Nat;
    var vectorDim : Nat;
    var activatedConcepts : [var Float]; // Currently active
    var spreadingActivation : Float;     // How much activation spreads
  };

  public type WorkingMemory = {
    var slots : [[var Float]];           // WM slots
    var numSlots : Nat;
    var slotDim : Nat;
    var activeSlots : [var Bool];        // Which slots are occupied
    var attention : [var Float];         // Attention to each slot
    var decayRate : Float;               // How fast WM decays
    var refreshRate : Float;             // How fast attended items refresh
    var centralExecutive : Float;        // Executive control strength
  };

  public type MemorySystemsState = {
    episodic : EpisodicMemory;
    semantic : SemanticMemory;
    working : WorkingMemory;
    var consolidationActive : Bool;      // During sleep?
    var replayBuffer : [[var Float]];    // For replay
    var replayIdx : Nat;
    var interleavedLearning : Float;     // Mixing ratio
  };

  // Memory parameters
  public let MEM_EPISODIC_CAPACITY : Nat = 100;
  public let MEM_PATTERN_DIM : Nat = 32;
  public let MEM_SEMANTIC_CONCEPTS : Nat = 50;
  public let MEM_WM_SLOTS : Nat = 7;       // 7±2 capacity

  public func initEpisodicMemory() : EpisodicMemory {
    {
      var patterns = Array.init<[var Float]>(MEM_EPISODIC_CAPACITY, func(_ : Nat) : [var Float] {
        Array.init<Float>(MEM_PATTERN_DIM, func(_ : Nat) : Float { 0.0 })
      });
      var contexts = Array.init<[var Float]>(MEM_EPISODIC_CAPACITY, func(_ : Nat) : [var Float] {
        Array.init<Float>(16, func(_ : Nat) : Float { 0.0 })
      });
      var timestamps = Array.init<Float>(MEM_EPISODIC_CAPACITY, func(_ : Nat) : Float { 0.0 });
      var strengths = Array.init<Float>(MEM_EPISODIC_CAPACITY, func(_ : Nat) : Float { 0.0 });
      var numMemories = 0;
      var capacity = MEM_EPISODIC_CAPACITY;
      var writeIdx = 0;
      var retrievalCue = Array.init<Float>(MEM_PATTERN_DIM, func(_ : Nat) : Float { 0.0 });
      var retrievedPattern = Array.init<Float>(MEM_PATTERN_DIM, func(_ : Nat) : Float { 0.0 });
      var retrievalStrength = 0.0;
    }
  };

  public func initSemanticMemory() : SemanticMemory {
    {
      var conceptVectors = Array.init<[var Float]>(MEM_SEMANTIC_CONCEPTS, func(i : Nat) : [var Float] {
        Array.init<Float>(MEM_PATTERN_DIM, func(j : Nat) : Float {
          if ((i + j) % 5 == 0) { 1.0 } else { 0.0 }
        })
      });
      var associations = Array.init<[var Float]>(MEM_SEMANTIC_CONCEPTS, func(_ : Nat) : [var Float] {
        Array.init<Float>(MEM_SEMANTIC_CONCEPTS, func(_ : Nat) : Float { 0.0 })
      });
      var numConcepts = MEM_SEMANTIC_CONCEPTS;
      var vectorDim = MEM_PATTERN_DIM;
      var activatedConcepts = Array.init<Float>(MEM_SEMANTIC_CONCEPTS, func(_ : Nat) : Float { 0.0 });
      var spreadingActivation = 0.3;
    }
  };

  public func initWorkingMemory() : WorkingMemory {
    {
      var slots = Array.init<[var Float]>(MEM_WM_SLOTS, func(_ : Nat) : [var Float] {
        Array.init<Float>(MEM_PATTERN_DIM, func(_ : Nat) : Float { 0.0 })
      });
      var numSlots = MEM_WM_SLOTS;
      var slotDim = MEM_PATTERN_DIM;
      var activeSlots = Array.init<Bool>(MEM_WM_SLOTS, func(_ : Nat) : Bool { false });
      var attention = Array.init<Float>(MEM_WM_SLOTS, func(_ : Nat) : Float { 0.0 });
      var decayRate = 0.001;
      var refreshRate = 0.1;
      var centralExecutive = 0.5;
    }
  };

  public func initMemorySystemsState() : MemorySystemsState {
    {
      episodic = initEpisodicMemory();
      semantic = initSemanticMemory();
      working = initWorkingMemory();
      var consolidationActive = false;
      var replayBuffer = Array.init<[var Float]>(20, func(_ : Nat) : [var Float] {
        Array.init<Float>(MEM_PATTERN_DIM, func(_ : Nat) : Float { 0.0 })
      });
      var replayIdx = 0;
      var interleavedLearning = 0.5;
    }
  };

  // Store pattern in episodic memory
  public func storeEpisodicMemory(
    mem : EpisodicMemory,
    pattern : [Float],
    context : [Float],
    currentTime : Float
  ) {
    let dim = Nat.min(Array.size(pattern), MEM_PATTERN_DIM);
    let contextDim = Nat.min(Array.size(context), 16);
    
    for (i in Iter.range(0, dim - 1)) {
      mem.patterns[mem.writeIdx][i] := pattern[i];
    };
    
    for (i in Iter.range(0, contextDim - 1)) {
      mem.contexts[mem.writeIdx][i] := context[i];
    };
    
    mem.timestamps[mem.writeIdx] := currentTime;
    mem.strengths[mem.writeIdx] := 1.0;
    
    mem.writeIdx := (mem.writeIdx + 1) % mem.capacity;
    if (mem.numMemories < mem.capacity) {
      mem.numMemories += 1;
    };
  };

  // Retrieve from episodic memory (pattern completion)
  public func retrieveEpisodicMemory(
    mem : EpisodicMemory,
    cue : [Float],
    currentTime : Float
  ) : Float {
    let cueDim = Nat.min(Array.size(cue), MEM_PATTERN_DIM);
    
    // Copy cue
    for (i in Iter.range(0, cueDim - 1)) {
      mem.retrievalCue[i] := cue[i];
    };
    
    // Find best match
    var bestMatch : Nat = 0;
    var bestSimilarity : Float = -1.0;
    
    for (m in Iter.range(0, mem.numMemories - 1)) {
      // Compute similarity (dot product)
      var similarity : Float = 0.0;
      for (i in Iter.range(0, cueDim - 1)) {
        similarity += cue[i] * mem.patterns[m][i];
      };
      
      // Weight by strength and recency
      let age = currentTime - mem.timestamps[m];
      let forgetting = exp(-age / 3600000.0);  // ~1 hour decay
      similarity *= mem.strengths[m] * forgetting;
      
      if (similarity > bestSimilarity) {
        bestSimilarity := similarity;
        bestMatch := m;
      };
    };
    
    // Retrieve best match
    if (bestSimilarity > 0.0) {
      for (i in Iter.range(0, MEM_PATTERN_DIM - 1)) {
        mem.retrievedPattern[i] := mem.patterns[bestMatch][i];
      };
      mem.strengths[bestMatch] += 0.1;  // Strengthen retrieved memory
    };
    
    mem.retrievalStrength := bestSimilarity;
    bestSimilarity
  };

  // Update working memory
  public func updateWorkingMemory(
    wm : WorkingMemory,
    newPattern : ?[Float],
    attentionFocus : Nat,
    dt : Float
  ) {
    // Decay unattended slots
    for (i in Iter.range(0, wm.numSlots - 1)) {
      if (wm.activeSlots[i]) {
        if (wm.attention[i] < 0.5) {
          // Decay
          for (j in Iter.range(0, wm.slotDim - 1)) {
            wm.slots[i][j] *= 1.0 - wm.decayRate * dt;
          };
        } else {
          // Refresh
          // (In real implementation, would refresh from LTM)
        };
      };
    };
    
    // Update attention
    for (i in Iter.range(0, wm.numSlots - 1)) {
      if (i == attentionFocus) {
        wm.attention[i] := Float.min(1.0, wm.attention[i] + wm.refreshRate * dt);
      } else {
        wm.attention[i] := Float.max(0.0, wm.attention[i] - wm.decayRate * dt);
      };
    };
    
    // Store new pattern if provided
    switch (newPattern) {
      case (?pattern) {
        // Find empty or weakest slot
        var targetSlot : Nat = 0;
        var minStrength : Float = 1000.0;
        
        for (i in Iter.range(0, wm.numSlots - 1)) {
          if (not wm.activeSlots[i]) {
            targetSlot := i;
            minStrength := 0.0;
          } else if (wm.attention[i] < minStrength) {
            minStrength := wm.attention[i];
            targetSlot := i;
          };
        };
        
        // Store
        let patternDim = Nat.min(Array.size(pattern), wm.slotDim);
        for (j in Iter.range(0, patternDim - 1)) {
          wm.slots[targetSlot][j] := pattern[j];
        };
        wm.activeSlots[targetSlot] := true;
        wm.attention[targetSlot] := 1.0;
      };
      case (null) { };
    };
  };


  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // ATTENTION AND CONSCIOUSNESS — GLOBAL WORKSPACE THEORY
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Global Workspace Theory (Baars, Dehaene):
  //   - Specialized processors compete for access to global workspace
  //   - Winners are broadcast globally → consciousness
  //   - Creates unified, coherent experience
  //

  public type GlobalWorkspaceState = {
    var workspace : [var Float];         // Global workspace content
    var competingModules : [[var Float]];// Module representations
    var moduleStrengths : [var Float];   // Activation strengths
    var numModules : Nat;
    var workspaceDim : Nat;
    var ignitionThreshold : Float;       // Threshold for broadcast
    var currentWinner : Nat;             // Active module
    var isIgnited : Bool;                // Global ignition occurred?
    var coherenceLevel : Float;          // Integration measure
    var broadcastStrength : Float;       // Strength of broadcast
  };

  public type AttentionalBottleneck = {
    var capacity : Nat;                  // How many items
    var items : [[var Float]];           // Items in attention
    var priorities : [var Float];        // Priority of each item
    var numItems : Nat;
    var focusIdx : Nat;                  // Currently focused
    var switchingCost : Float;           // Cost of switching
    var sustainedAttention : Float;      // How long focused
    var vigilance : Float;               // Overall alertness
  };

  public type ConsciousnessState = {
    workspace : GlobalWorkspaceState;
    attention : AttentionalBottleneck;
    var phi : Float;                     // IIT integrated information
    var accessConsciousness : Float;     // Reportability
    var phenomenalConsciousness : Float; // Subjective experience
    var metacognition : Float;           // Awareness of awareness
    var selfModel : [var Float];         // Self-representation
    var timePerception : Float;          // Subjective time
  };

  // Consciousness parameters
  public let GW_NUM_MODULES : Nat = 8;
  public let GW_WORKSPACE_DIM : Nat = 32;
  public let GW_IGNITION_THRESHOLD : Float = 0.7;
  public let ATT_CAPACITY : Nat = 4;

  public func initGlobalWorkspaceState() : GlobalWorkspaceState {
    {
      var workspace = Array.init<Float>(GW_WORKSPACE_DIM, func(_ : Nat) : Float { 0.0 });
      var competingModules = Array.init<[var Float]>(GW_NUM_MODULES, func(_ : Nat) : [var Float] {
        Array.init<Float>(GW_WORKSPACE_DIM, func(_ : Nat) : Float { 0.0 })
      });
      var moduleStrengths = Array.init<Float>(GW_NUM_MODULES, func(_ : Nat) : Float { 0.0 });
      var numModules = GW_NUM_MODULES;
      var workspaceDim = GW_WORKSPACE_DIM;
      var ignitionThreshold = GW_IGNITION_THRESHOLD;
      var currentWinner = 0;
      var isIgnited = false;
      var coherenceLevel = 0.0;
      var broadcastStrength = 0.0;
    }
  };

  public func initAttentionalBottleneck() : AttentionalBottleneck {
    {
      var capacity = ATT_CAPACITY;
      var items = Array.init<[var Float]>(ATT_CAPACITY, func(_ : Nat) : [var Float] {
        Array.init<Float>(GW_WORKSPACE_DIM, func(_ : Nat) : Float { 0.0 })
      });
      var priorities = Array.init<Float>(ATT_CAPACITY, func(_ : Nat) : Float { 0.0 });
      var numItems = 0;
      var focusIdx = 0;
      var switchingCost = 0.1;
      var sustainedAttention = 0.0;
      var vigilance = 0.5;
    }
  };

  public func initConsciousnessState() : ConsciousnessState {
    {
      workspace = initGlobalWorkspaceState();
      attention = initAttentionalBottleneck();
      var phi = 0.0;
      var accessConsciousness = 0.0;
      var phenomenalConsciousness = 0.0;
      var metacognition = 0.0;
      var selfModel = Array.init<Float>(16, func(_ : Nat) : Float { 0.5 });
      var timePerception = 1.0;
    }
  };

  // Module competition for workspace
  public func competitionForWorkspace(gw : GlobalWorkspaceState) : Nat {
    var maxStrength : Float = 0.0;
    var winner : Nat = 0;
    
    for (m in Iter.range(0, gw.numModules - 1)) {
      if (gw.moduleStrengths[m] > maxStrength) {
        maxStrength := gw.moduleStrengths[m];
        winner := m;
      };
    };
    
    gw.currentWinner := winner;
    
    // Check for ignition
    if (maxStrength > gw.ignitionThreshold) {
      gw.isIgnited := true;
      gw.broadcastStrength := maxStrength;
      
      // Copy winner to workspace
      for (i in Iter.range(0, gw.workspaceDim - 1)) {
        gw.workspace[i] := gw.competingModules[winner][i];
      };
    } else {
      gw.isIgnited := false;
      gw.broadcastStrength := 0.0;
    };
    
    winner
  };

  // Broadcast workspace to all modules
  public func broadcastWorkspace(gw : GlobalWorkspaceState) {
    if (not gw.isIgnited) { return };
    
    // All modules receive workspace content
    for (m in Iter.range(0, gw.numModules - 1)) {
      if (m != gw.currentWinner) {
        // Modulatory influence from workspace
        for (i in Iter.range(0, gw.workspaceDim - 1)) {
          gw.competingModules[m][i] := 0.9 * gw.competingModules[m][i] + 
                                        0.1 * gw.broadcastStrength * gw.workspace[i];
        };
      };
    };
  };

  // Update global workspace
  public func updateGlobalWorkspace(
    gw : GlobalWorkspaceState,
    moduleInputs : [[Float]],    // Input from each module
    dt : Float
  ) {
    // Update module strengths
    for (m in Iter.range(0, gw.numModules - 1)) {
      if (m < Array.size(moduleInputs)) {
        var strength : Float = 0.0;
        let inputDim = Nat.min(Array.size(moduleInputs[m]), gw.workspaceDim);
        
        for (i in Iter.range(0, inputDim - 1)) {
          gw.competingModules[m][i] := moduleInputs[m][i];
          strength += moduleInputs[m][i] * moduleInputs[m][i];
        };
        
        gw.moduleStrengths[m] := Float.sqrt(strength / Float.fromInt(inputDim));
      };
    };
    
    // Competition
    let _ = competitionForWorkspace(gw);
    
    // Broadcast
    broadcastWorkspace(gw);
    
    // Compute coherence
    var coherenceSum : Float = 0.0;
    for (i in Iter.range(0, gw.workspaceDim - 1)) {
      coherenceSum += gw.workspace[i] * gw.workspace[i];
    };
    gw.coherenceLevel := Float.sqrt(coherenceSum / Float.fromInt(gw.workspaceDim));
  };

  // Compute integrated information (simplified phi)
  public func computePhi(cs : ConsciousnessState) : Float {
    // Very simplified IIT measure
    // Real phi computation is exponentially complex
    
    let gw = cs.workspace;
    
    // Measure integration: how much is lost by partitioning?
    var wholeInfo : Float = gw.coherenceLevel;
    
    // Partition workspace and compare
    var leftInfo : Float = 0.0;
    var rightInfo : Float = 0.0;
    let half = gw.workspaceDim / 2;
    
    for (i in Iter.range(0, half - 1)) {
      leftInfo += gw.workspace[i] * gw.workspace[i];
    };
    for (i in Iter.range(half, gw.workspaceDim - 1)) {
      rightInfo += gw.workspace[i] * gw.workspace[i];
    };
    
    leftInfo := Float.sqrt(leftInfo / Float.fromInt(half));
    rightInfo := Float.sqrt(rightInfo / Float.fromInt(gw.workspaceDim - half));
    
    // Phi = whole - max(parts)
    cs.phi := wholeInfo - Float.max(leftInfo, rightInfo);
    cs.phi := Float.max(0.0, cs.phi);
    
    cs.phi
  };

  // Update consciousness state
  public func updateConsciousness(
    cs : ConsciousnessState,
    moduleInputs : [[Float]],
    selfSignals : [Float],
    dt : Float
  ) {
    // Update workspace
    updateGlobalWorkspace(cs.workspace, moduleInputs, dt);
    
    // Update phi
    let _ = computePhi(cs);
    
    // Access consciousness (reportability)
    cs.accessConsciousness := cs.workspace.broadcastStrength;
    
    // Phenomenal consciousness (subjective experience)
    // Simplified as function of phi and coherence
    cs.phenomenalConsciousness := cs.phi * cs.workspace.coherenceLevel;
    
    // Metacognition (aware of own states)
    let selfDim = Nat.min(Array.size(selfSignals), 16);
    for (i in Iter.range(0, selfDim - 1)) {
      cs.selfModel[i] := 0.9 * cs.selfModel[i] + 0.1 * selfSignals[i];
    };
    
    // Metacognition as correlation between self-model and workspace
    var metaCorr : Float = 0.0;
    for (i in Iter.range(0, Nat.min(16, cs.workspace.workspaceDim) - 1)) {
      metaCorr += cs.selfModel[i] * cs.workspace.workspace[i];
    };
    cs.metacognition := metaCorr / 16.0;
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // EMOTIONAL PROCESSING — APPRAISAL AND VALENCE
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Emotions modulate plasticity and guide behavior:
  //
  // 1. APPRAISAL:
  //    - Relevance to goals
  //    - Novelty
  //    - Controllability
  //    - Agency
  //
  // 2. CORE AFFECT:
  //    - Valence (pleasant-unpleasant)
  //    - Arousal (activated-deactivated)
  //
  // 3. DISCRETE EMOTIONS:
  //    - Joy, sadness, fear, anger, disgust, surprise
  //    - Each has specific neural and behavioral profile
  //

  public type AppraisalState = {
    var goalRelevance : Float;           // How relevant to goals
    var goalConduciveness : Float;       // Helps or hinders goals
    var novelty : Float;                 // How unexpected
    var certainty : Float;               // Predictability
    var agency : Float;                  // Self vs other caused
    var controllability : Float;         // Can be changed?
    var normCongruence : Float;          // Matches social norms
    var internalStandards : Float;       // Matches personal standards
  };

  public type CoreAffect = {
    var valence : Float;                 // [-1, 1]: unpleasant to pleasant
    var arousal : Float;                 // [0, 1]: calm to excited
    var dominance : Float;               // [0, 1]: submissive to dominant
    var hedonic : Float;                 // Pleasure/pain
    var motivational : Float;            // Approach/avoid
  };

  public type DiscreteEmotion = {
    var joy : Float;
    var sadness : Float;
    var fear : Float;
    var anger : Float;
    var disgust : Float;
    var surprise : Float;
    var contempt : Float;
    var interest : Float;
    var dominant : Text;                 // Currently dominant emotion
  };

  public type EmotionalState = {
    appraisal : AppraisalState;
    affect : CoreAffect;
    discrete : DiscreteEmotion;
    var emotionalIntensity : Float;      // Overall intensity
    var emotionRegulation : Float;       // Regulation capacity
    var moodState : Float;               // Background mood
    var emotionalMemory : [var Float];   // Recent emotional history
    var plasticityModulation : Float;    // Effect on learning
  };

  public func initAppraisalState() : AppraisalState {
    {
      var goalRelevance = 0.5;
      var goalConduciveness = 0.5;
      var novelty = 0.5;
      var certainty = 0.5;
      var agency = 0.5;
      var controllability = 0.5;
      var normCongruence = 0.5;
      var internalStandards = 0.5;
    }
  };

  public func initCoreAffect() : CoreAffect {
    {
      var valence = 0.0;
      var arousal = 0.5;
      var dominance = 0.5;
      var hedonic = 0.0;
      var motivational = 0.0;
    }
  };

  public func initDiscreteEmotion() : DiscreteEmotion {
    {
      var joy = 0.0;
      var sadness = 0.0;
      var fear = 0.0;
      var anger = 0.0;
      var disgust = 0.0;
      var surprise = 0.0;
      var contempt = 0.0;
      var interest = 0.0;
      var dominant = "neutral";
    }
  };

  public func initEmotionalState() : EmotionalState {
    {
      appraisal = initAppraisalState();
      affect = initCoreAffect();
      discrete = initDiscreteEmotion();
      var emotionalIntensity = 0.0;
      var emotionRegulation = 0.5;
      var moodState = 0.0;
      var emotionalMemory = Array.init<Float>(20, func(_ : Nat) : Float { 0.0 });
      var plasticityModulation = 1.0;
    }
  };

  // Perform appraisal
  public func performAppraisal(
    appraisal : AppraisalState,
    stimulus : [Float],
    goals : [Float],
    predictions : [Float]
  ) {
    let stimDim = Array.size(stimulus);
    let goalDim = Array.size(goals);
    let predDim = Array.size(predictions);
    
    // Goal relevance: similarity to goal states
    var relevance : Float = 0.0;
    for (i in Iter.range(0, Nat.min(stimDim, goalDim) - 1)) {
      relevance += stimulus[i] * goals[i];
    };
    appraisal.goalRelevance := sigmoid(relevance * 2.0);
    
    // Novelty: deviation from predictions
    var novelty : Float = 0.0;
    for (i in Iter.range(0, Nat.min(stimDim, predDim) - 1)) {
      novelty += Float.abs(stimulus[i] - predictions[i]);
    };
    appraisal.novelty := novelty / Float.fromInt(Nat.max(1, Nat.min(stimDim, predDim)));
    
    // Goal conduciveness: does stimulus help achieve goals?
    // Simplified: positive if stimulus moves toward goals
    appraisal.goalConduciveness := sigmoid(relevance);
    
    // Certainty: inverse of novelty
    appraisal.certainty := 1.0 - appraisal.novelty;
  };

  // Compute core affect from appraisal
  public func computeCoreAffect(affect : CoreAffect, appraisal : AppraisalState) {
    // Valence from goal conduciveness
    affect.valence := (appraisal.goalConduciveness - 0.5) * 2.0;
    
    // Arousal from relevance and novelty
    affect.arousal := (appraisal.goalRelevance + appraisal.novelty) / 2.0;
    
    // Dominance from controllability and agency
    affect.dominance := (appraisal.controllability + appraisal.agency) / 2.0;
    
    // Hedonic = valence × relevance
    affect.hedonic := affect.valence * appraisal.goalRelevance;
    
    // Motivational = approach if positive, avoid if negative
    affect.motivational := affect.valence * affect.arousal;
  };

  // Map to discrete emotions
  public func computeDiscreteEmotions(discrete : DiscreteEmotion, appraisal : AppraisalState, affect : CoreAffect) {
    // Joy: goal conductive + certain + self-caused
    discrete.joy := Float.max(0.0, appraisal.goalConduciveness * appraisal.certainty * appraisal.agency);
    
    // Sadness: goal obstructive + certain + uncontrollable
    discrete.sadness := Float.max(0.0, (1.0 - appraisal.goalConduciveness) * appraisal.certainty * (1.0 - appraisal.controllability));
    
    // Fear: goal obstructive + uncertain
    discrete.fear := Float.max(0.0, (1.0 - appraisal.goalConduciveness) * (1.0 - appraisal.certainty) * appraisal.goalRelevance);
    
    // Anger: goal obstructive + other-caused + controllable
    discrete.anger := Float.max(0.0, (1.0 - appraisal.goalConduciveness) * (1.0 - appraisal.agency) * appraisal.controllability);
    
    // Disgust: norm violation
    discrete.disgust := Float.max(0.0, 1.0 - appraisal.normCongruence);
    
    // Surprise: high novelty
    discrete.surprise := appraisal.novelty;
    
    // Interest: novel + goal relevant
    discrete.interest := appraisal.novelty * appraisal.goalRelevance;
    
    // Find dominant emotion
    var maxEmotion : Float = 0.0;
    var dominantName = "neutral";
    
    if (discrete.joy > maxEmotion) { maxEmotion := discrete.joy; dominantName := "joy" };
    if (discrete.sadness > maxEmotion) { maxEmotion := discrete.sadness; dominantName := "sadness" };
    if (discrete.fear > maxEmotion) { maxEmotion := discrete.fear; dominantName := "fear" };
    if (discrete.anger > maxEmotion) { maxEmotion := discrete.anger; dominantName := "anger" };
    if (discrete.disgust > maxEmotion) { maxEmotion := discrete.disgust; dominantName := "disgust" };
    if (discrete.surprise > maxEmotion) { maxEmotion := discrete.surprise; dominantName := "surprise" };
    if (discrete.interest > maxEmotion) { maxEmotion := discrete.interest; dominantName := "interest" };
    
    discrete.dominant := dominantName;
  };

  // Update full emotional state
  public func updateEmotionalState(
    es : EmotionalState,
    stimulus : [Float],
    goals : [Float],
    predictions : [Float],
    dt : Float
  ) {
    performAppraisal(es.appraisal, stimulus, goals, predictions);
    computeCoreAffect(es.affect, es.appraisal);
    computeDiscreteEmotions(es.discrete, es.appraisal, es.affect);
    
    // Overall intensity
    es.emotionalIntensity := es.affect.arousal * Float.abs(es.affect.valence);
    
    // Mood (slow-changing background)
    es.moodState := 0.99 * es.moodState + 0.01 * es.affect.valence;
    
    // Plasticity modulation
    // Emotions enhance plasticity, especially for emotional content
    es.plasticityModulation := 1.0 + es.emotionalIntensity * 0.5;
    
    // Emotion regulation (homeostatic)
    es.emotionRegulation := Float.max(0.0, es.emotionRegulation - 0.01 * es.emotionalIntensity * dt / 1000.0);
    es.emotionRegulation := Float.min(1.0, es.emotionRegulation + 0.001 * (1.0 - es.emotionalIntensity) * dt / 1000.0);
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SOCIAL COGNITION — THEORY OF MIND
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Understanding other minds:
  //
  // 1. MENTALIZING:
  //    - Attributing beliefs, desires, intentions
  //    - Predicting behavior from mental states
  //
  // 2. EMPATHY:
  //    - Sharing emotional states
  //    - Perspective taking
  //
  // 3. SOCIAL LEARNING:
  //    - Imitation
  //    - Social referencing
  //    - Cultural transmission
  //

  public type OtherAgentModel = {
    agentId : Nat;
    var beliefs : [var Float];           // Inferred beliefs
    var desires : [var Float];           // Inferred desires
    var intentions : [var Float];        // Inferred intentions
    var emotionalState : [var Float];    // Inferred emotions
    var reliability : Float;             // How reliable is this agent
    var familiarity : Float;             // How well known
    var lastInteraction : Float;         // Time of last interaction
  };

  public type EmpathyState = {
    var emotionalContagion : Float;      // Automatic affect sharing
    var perspectiveTaking : Float;       // Cognitive empathy
    var empathicConcern : Float;         // Motivation to help
    var personalDistress : Float;        // Self-focused distress
    var mirrorActivation : Float;        // Mirror neuron-like
  };

  public type SocialLearningState = {
    var imitationTendency : Float;       // How much to imitate
    var modelSelection : [var Float];    // Who to learn from
    var socialReferencing : Float;       // Look to others for cues
    var conformityPressure : Float;      // Group conformity
    var prestige : [var Float];          // Status of others
  };

  public type SocialCognitionState = {
    var otherAgents : [var OtherAgentModel];
    var numAgents : Nat;
    empathy : EmpathyState;
    socialLearning : SocialLearningState;
    var selfAwareness : Float;           // Own mental state awareness
    var socialAnxiety : Float;           // Fear of judgment
    var affiliationNeed : Float;         // Need for social connection
    var dominanceHierarchy : [var Float];// Perceived social rank
  };

  public func initOtherAgentModel(id : Nat) : OtherAgentModel {
    {
      agentId = id;
      var beliefs = Array.init<Float>(8, func(_ : Nat) : Float { 0.5 });
      var desires = Array.init<Float>(8, func(_ : Nat) : Float { 0.5 });
      var intentions = Array.init<Float>(4, func(_ : Nat) : Float { 0.0 });
      var emotionalState = Array.init<Float>(8, func(_ : Nat) : Float { 0.0 });
      var reliability = 0.5;
      var familiarity = 0.0;
      var lastInteraction = 0.0;
    }
  };

  public func initEmpathyState() : EmpathyState {
    {
      var emotionalContagion = 0.5;
      var perspectiveTaking = 0.5;
      var empathicConcern = 0.5;
      var personalDistress = 0.0;
      var mirrorActivation = 0.0;
    }
  };

  public func initSocialLearningState() : SocialLearningState {
    {
      var imitationTendency = 0.5;
      var modelSelection = Array.init<Float>(10, func(_ : Nat) : Float { 0.1 });
      var socialReferencing = 0.5;
      var conformityPressure = 0.3;
      var prestige = Array.init<Float>(10, func(_ : Nat) : Float { 0.5 });
    }
  };

  public func initSocialCognitionState(numOthers : Nat) : SocialCognitionState {
    {
      var otherAgents = Array.init<OtherAgentModel>(numOthers, func(i : Nat) : OtherAgentModel {
        initOtherAgentModel(i)
      });
      var numAgents = numOthers;
      empathy = initEmpathyState();
      socialLearning = initSocialLearningState();
      var selfAwareness = 0.5;
      var socialAnxiety = 0.3;
      var affiliationNeed = 0.5;
      var dominanceHierarchy = Array.init<Float>(numOthers, func(_ : Nat) : Float { 0.5 });
    }
  };

  // Infer other agent's mental state
  public func inferMentalState(
    agent : OtherAgentModel,
    observedBehavior : [Float],
    observedContext : [Float],
    dt : Float
  ) {
    let behaviorDim = Array.size(observedBehavior);
    
    // Update beliefs based on behavior
    // Simplified: assume behavior reflects beliefs
    for (i in Iter.range(0, Nat.min(behaviorDim, 8) - 1)) {
      agent.beliefs[i] := 0.9 * agent.beliefs[i] + 0.1 * observedBehavior[i];
    };
    
    // Infer desires from context + behavior
    // What are they trying to achieve?
    for (i in Iter.range(0, Nat.min(behaviorDim, 8) - 1)) {
      let contextIdx = i % Array.size(observedContext);
      agent.desires[i] := 0.9 * agent.desires[i] + 
                          0.1 * (observedBehavior[i] * observedContext[contextIdx]);
    };
    
    // Intentions from desires + beliefs
    for (i in Iter.range(0, 3)) {
      agent.intentions[i] := agent.desires[i * 2] * agent.beliefs[i * 2];
    };
    
    // Update familiarity
    agent.familiarity := Float.min(1.0, agent.familiarity + 0.01 * dt / 1000.0);
  };

  // Compute empathic response
  public func computeEmpathy(
    empathy : EmpathyState,
    otherEmotion : [Float],
    selfEmotion : [Float],
    contextSafety : Float
  ) {
    // Emotional contagion (automatic)
    var contagionSum : Float = 0.0;
    for (e in otherEmotion.vals()) {
      contagionSum += Float.abs(e);
    };
    empathy.emotionalContagion := contagionSum / Float.fromInt(Array.size(otherEmotion));
    
    // Mirror activation
    empathy.mirrorActivation := empathy.emotionalContagion * 0.8;
    
    // Perspective taking (cognitive)
    // Ability to understand other's viewpoint
    empathy.perspectiveTaking := 0.5 + 0.5 * contextSafety;
    
    // Empathic concern vs personal distress
    // Safe context → empathic concern; threat → personal distress
    empathy.empathicConcern := empathy.emotionalContagion * contextSafety;
    empathy.personalDistress := empathy.emotionalContagion * (1.0 - contextSafety);
  };

  // Social learning update
  public func updateSocialLearning(
    sl : SocialLearningState,
    observedActions : [[Float]],
    outcomes : [Float],
    prestige : [Float],
    dt : Float
  ) {
    let numModels = Array.size(observedActions);
    
    // Update prestige based on outcomes
    for (i in Iter.range(0, Nat.min(numModels, 10) - 1)) {
      if (i < Array.size(outcomes)) {
        sl.prestige[i] := 0.9 * sl.prestige[i] + 0.1 * outcomes[i];
      };
    };
    
    // Model selection: prefer prestigious and successful
    for (i in Iter.range(0, Nat.min(numModels, 10) - 1)) {
      sl.modelSelection[i] := sl.prestige[i];
    };
    
    // Normalize model selection
    var sumSelection : Float = 0.0;
    for (i in Iter.range(0, Nat.min(numModels, 10) - 1)) {
      sumSelection += sl.modelSelection[i];
    };
    if (sumSelection > 0.0) {
      for (i in Iter.range(0, Nat.min(numModels, 10) - 1)) {
        sl.modelSelection[i] /= sumSelection;
      };
    };
    
    // Conformity pressure
    // Higher when more models agree
    var agreement : Float = 0.0;
    if (numModels > 1) {
      for (i in Iter.range(0, numModels - 2)) {
        for (j in Iter.range(i + 1, numModels - 1)) {
          var similarity : Float = 0.0;
          let actionDim = Nat.min(Array.size(observedActions[i]), Array.size(observedActions[j]));
          for (k in Iter.range(0, actionDim - 1)) {
            similarity += 1.0 - Float.abs(observedActions[i][k] - observedActions[j][k]);
          };
          agreement += similarity / Float.fromInt(actionDim);
        };
      };
      sl.conformityPressure := agreement / Float.fromInt(numModels * (numModels - 1) / 2);
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // UTILITY FUNCTIONS — ADDITIONAL MATHEMATICS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

  func cos(x : Float) : Float {
    sin(x + PI / 2.0)
  };

  func pow(base : Float, exp : Float) : Float {
    if (base <= 0.0) { return 0.0 };
    exp(exp * ln(base))
  };

  func sqrt(x : Float) : Float {
    if (x <= 0.0) { return 0.0 };
    var guess = x / 2.0;
    for (_ in Iter.range(0, 20)) {
      guess := 0.5 * (guess + x / guess);
    };
    guess
  };

  func ln(x : Float) : Float {
    if (x <= 0.0) { return -1000.0 };
    let z = (x - 1.0) / (x + 1.0);
    let zSq = z * z;
    var result : Float = 0.0;
    var term : Float = z;
    for (n in Iter.range(0, 30)) {
      result += term / Float.fromInt(2 * n + 1);
      term := term * zSq;
    };
    2.0 * result
  };

  func fmod(x : Float, y : Float) : Float {
    if (y == 0.0) { return x };
    x - y * Float.floor(x / y)
  };

  func arctan2(y : Float, x : Float) : Float {
    if (x > 0.0) {
      arctan(y / x)
    } else if (x < 0.0 and y >= 0.0) {
      arctan(y / x) + PI
    } else if (x < 0.0 and y < 0.0) {
      arctan(y / x) - PI
    } else if (x == 0.0 and y > 0.0) {
      PI / 2.0
    } else if (x == 0.0 and y < 0.0) {
      -PI / 2.0
    } else {
      0.0
    }
  };

  func arctan(x : Float) : Float {
    // Taylor series approximation
    if (Float.abs(x) > 1.0) {
      if (x > 0.0) {
        PI / 2.0 - arctan(1.0 / x)
      } else {
        -PI / 2.0 - arctan(1.0 / x)
      }
    } else {
      var result : Float = 0.0;
      var term : Float = x;
      let xSq = x * x;
      for (n in Iter.range(0, 20)) {
        result += term / Float.fromInt(2 * n + 1);
        term := -term * xSq;
      };
      result
    }
  };


  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // MOTOR CONTROL — ACTION GENERATION AND EXECUTION
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Motor systems transform goals into actions:
  //
  // 1. MOTOR HIERARCHY:
  //    - Cortex: Abstract goals, sequence planning
  //    - Basal ganglia: Action selection
  //    - Cerebellum: Timing and coordination
  //    - Spinal cord: Execution
  //
  // 2. MOTOR PRIMITIVES:
  //    - Basic movement elements
  //    - Combined into complex actions
  //    - Stored in motor memory
  //
  // 3. MOTOR LEARNING:
  //    - Error-driven (cerebellar)
  //    - Reward-driven (basal ganglia)
  //    - Use-dependent plasticity
  //

  public type MotorPrimitive = {
    var pattern : [var Float];           // Motor pattern
    var timing : [var Float];            // Timing sequence
    var duration : Float;                // Total duration
    var effort : Float;                  // Energy cost
    var precision : Float;               // Required precision
    var isActive : Bool;
    var progress : Float;                // 0-1 completion
  };

  public type MotorPlan = {
    var primitives : [var MotorPrimitive];
    var sequenceOrder : [var Nat];       // Order of primitives
    var numPrimitives : Nat;
    var currentPrimitive : Nat;
    var planGoal : [var Float];          // Desired end state
    var planCost : Float;                // Estimated cost
    var isPlanValid : Bool;
    var planConfidence : Float;
  };

  public type BasalGangliaState = {
    var directPathway : [var Float];     // Go pathway
    var indirectPathway : [var Float];   // NoGo pathway
    var hyperdirectPathway : [var Float];// Stop pathway
    var striatumActivity : [var Float];  // Striatal neurons
    var gpiOutput : [var Float];         // Output nucleus
    var dopamineModulation : Float;      // DA influence
    var actionValues : [var Float];      // Q(a) for each action
    var selectedAction : Nat;
    var selectionConfidence : Float;
  };

  public type CerebellarState = {
    var granuleCells : [var Float];      // Massive expansion
    var purkinjeOutput : [var Float];    // Cerebellar output
    var climbingFiberError : Float;      // Teaching signal
    var parallelFiberWeights : [[var Float]]; // Learned weights
    var mossyFiberInput : [var Float];   // Input
    var timingPrediction : Float;        // Timing anticipation
    var coordinationIndex : Float;       // Movement coordination
  };

  public type MotorControlState = {
    primitives : [var MotorPrimitive];
    plan : MotorPlan;
    basalGanglia : BasalGangliaState;
    cerebellum : CerebellarState;
    var motorOutput : [var Float];       // Final motor command
    var efferenceCopy : [var Float];     // Copy for prediction
    var sensorimotorError : Float;       // Feedback error
    var motorLearningRate : Float;
    var fatigueLevel : Float;
  };

  // Motor parameters
  public let MOTOR_NUM_PRIMITIVES : Nat = 10;
  public let MOTOR_DIM : Nat = 8;
  public let MOTOR_NUM_ACTIONS : Nat = 10;
  public let CEREBELLAR_GRANULES : Nat = 100;

  public func initMotorPrimitive() : MotorPrimitive {
    {
      var pattern = Array.init<Float>(MOTOR_DIM, func(_ : Nat) : Float { 0.0 });
      var timing = Array.init<Float>(10, func(_ : Nat) : Float { 0.0 });
      var duration = 100.0;
      var effort = 0.5;
      var precision = 0.8;
      var isActive = false;
      var progress = 0.0;
    }
  };

  public func initMotorPlan() : MotorPlan {
    {
      var primitives = Array.init<MotorPrimitive>(MOTOR_NUM_PRIMITIVES, func(_ : Nat) : MotorPrimitive {
        initMotorPrimitive()
      });
      var sequenceOrder = Array.init<Nat>(MOTOR_NUM_PRIMITIVES, func(i : Nat) : Nat { i });
      var numPrimitives = MOTOR_NUM_PRIMITIVES;
      var currentPrimitive = 0;
      var planGoal = Array.init<Float>(MOTOR_DIM, func(_ : Nat) : Float { 0.0 });
      var planCost = 0.0;
      var isPlanValid = false;
      var planConfidence = 0.0;
    }
  };

  public func initBasalGangliaState() : BasalGangliaState {
    {
      var directPathway = Array.init<Float>(MOTOR_NUM_ACTIONS, func(_ : Nat) : Float { 0.0 });
      var indirectPathway = Array.init<Float>(MOTOR_NUM_ACTIONS, func(_ : Nat) : Float { 0.0 });
      var hyperdirectPathway = Array.init<Float>(MOTOR_NUM_ACTIONS, func(_ : Nat) : Float { 0.0 });
      var striatumActivity = Array.init<Float>(MOTOR_NUM_ACTIONS * 2, func(_ : Nat) : Float { 0.0 });
      var gpiOutput = Array.init<Float>(MOTOR_NUM_ACTIONS, func(_ : Nat) : Float { 0.5 });
      var dopamineModulation = 0.5;
      var actionValues = Array.init<Float>(MOTOR_NUM_ACTIONS, func(_ : Nat) : Float { 0.0 });
      var selectedAction = 0;
      var selectionConfidence = 0.0;
    }
  };

  public func initCerebellarState() : CerebellarState {
    {
      var granuleCells = Array.init<Float>(CEREBELLAR_GRANULES, func(_ : Nat) : Float { 0.0 });
      var purkinjeOutput = Array.init<Float>(10, func(_ : Nat) : Float { 0.0 });
      var climbingFiberError = 0.0;
      var parallelFiberWeights = Array.init<[var Float]>(10, func(_ : Nat) : [var Float] {
        Array.init<Float>(CEREBELLAR_GRANULES, func(_ : Nat) : Float { 0.1 })
      });
      var mossyFiberInput = Array.init<Float>(20, func(_ : Nat) : Float { 0.0 });
      var timingPrediction = 0.0;
      var coordinationIndex = 0.5;
    }
  };

  public func initMotorControlState() : MotorControlState {
    {
      primitives = Array.init<MotorPrimitive>(MOTOR_NUM_PRIMITIVES, func(_ : Nat) : MotorPrimitive {
        initMotorPrimitive()
      });
      plan = initMotorPlan();
      basalGanglia = initBasalGangliaState();
      cerebellum = initCerebellarState();
      var motorOutput = Array.init<Float>(MOTOR_DIM, func(_ : Nat) : Float { 0.0 });
      var efferenceCopy = Array.init<Float>(MOTOR_DIM, func(_ : Nat) : Float { 0.0 });
      var sensorimotorError = 0.0;
      var motorLearningRate = 0.01;
      var fatigueLevel = 0.0;
    }
  };

  // Basal ganglia action selection
  public func selectAction(bg : BasalGangliaState, contextInput : [Float], reward : Float) : Nat {
    // Update action values with TD-like learning
    for (a in Iter.range(0, MOTOR_NUM_ACTIONS - 1)) {
      if (a == bg.selectedAction) {
        bg.actionValues[a] += 0.1 * (reward - bg.actionValues[a]);
      };
    };
    
    // Direct pathway: promotes selected action (D1)
    // Indirect pathway: suppresses other actions (D2)
    for (a in Iter.range(0, MOTOR_NUM_ACTIONS - 1)) {
      let contextInfluence = if (a < Array.size(contextInput)) { contextInput[a] } else { 0.0 };
      
      // D1 striatal neurons → direct pathway
      bg.directPathway[a] := (1.0 + bg.dopamineModulation) * 
                              (bg.actionValues[a] + contextInfluence);
      
      // D2 striatal neurons → indirect pathway
      bg.indirectPathway[a] := (1.0 - bg.dopamineModulation * 0.5) * 
                                (1.0 - bg.actionValues[a]);
      
      // GPi output (inhibition of thalamus)
      // Less GPi = more action (disinhibition)
      bg.gpiOutput[a] := bg.indirectPathway[a] - bg.directPathway[a] + 0.5;
      bg.gpiOutput[a] := clamp(bg.gpiOutput[a], 0.0, 1.0);
    };
    
    // Select action with lowest GPi output (least inhibition)
    var bestAction : Nat = 0;
    var lowestInhibition : Float = 1.0;
    
    for (a in Iter.range(0, MOTOR_NUM_ACTIONS - 1)) {
      if (bg.gpiOutput[a] < lowestInhibition) {
        lowestInhibition := bg.gpiOutput[a];
        bestAction := a;
      };
    };
    
    bg.selectedAction := bestAction;
    bg.selectionConfidence := 1.0 - lowestInhibition;
    
    bestAction
  };

  // Cerebellar timing and coordination
  public func updateCerebellum(
    cb : CerebellarState,
    mossyInput : [Float],
    movementError : Float,
    dt : Float
  ) {
    // Copy mossy fiber input
    let inputDim = Nat.min(Array.size(mossyInput), 20);
    for (i in Iter.range(0, inputDim - 1)) {
      cb.mossyFiberInput[i] := mossyInput[i];
    };
    
    // Granule cell expansion
    // Creates sparse, high-dimensional representation
    for (g in Iter.range(0, CEREBELLAR_GRANULES - 1)) {
      var sum : Float = 0.0;
      for (i in Iter.range(0, inputDim - 1)) {
        // Random projection (fixed)
        let weight = Float.fromInt((g * 7 + i * 13) % 100) / 100.0 - 0.5;
        sum += weight * cb.mossyFiberInput[i];
      };
      // Sparse activation
      cb.granuleCells[g] := if (sum > 0.3) { sigmoid(sum * 2.0) } else { 0.0 };
    };
    
    // Purkinje cell output
    for (p in Iter.range(0, 9)) {
      var sum : Float = 0.0;
      for (g in Iter.range(0, CEREBELLAR_GRANULES - 1)) {
        sum += cb.parallelFiberWeights[p][g] * cb.granuleCells[g];
      };
      cb.purkinjeOutput[p] := sigmoid(sum);
    };
    
    // Climbing fiber teaching signal
    cb.climbingFiberError := movementError;
    
    // LTD at parallel fiber-Purkinje synapses (when CF active)
    if (Float.abs(cb.climbingFiberError) > 0.1) {
      for (p in Iter.range(0, 9)) {
        for (g in Iter.range(0, CEREBELLAR_GRANULES - 1)) {
          if (cb.granuleCells[g] > 0.1) {
            // LTD proportional to error and activity
            cb.parallelFiberWeights[p][g] -= 0.001 * cb.climbingFiberError * cb.granuleCells[g] * dt;
            cb.parallelFiberWeights[p][g] := clamp(cb.parallelFiberWeights[p][g], 0.0, 1.0);
          };
        };
      };
    };
    
    // Timing prediction
    var timing : Float = 0.0;
    for (p in Iter.range(0, 9)) {
      timing += cb.purkinjeOutput[p] * Float.fromInt(p);
    };
    cb.timingPrediction := timing / 45.0;  // Normalize
    
    // Coordination index
    cb.coordinationIndex := 1.0 - Float.abs(cb.climbingFiberError);
  };

  // Execute motor primitive
  public func executeMotorPrimitive(
    primitive : MotorPrimitive,
    currentState : [Float],
    dt : Float
  ) : [Float] {
    if (not primitive.isActive) {
      return Array.tabulate<Float>(MOTOR_DIM, func(_ : Nat) : Float { 0.0 });
    };
    
    primitive.progress += dt / primitive.duration;
    
    if (primitive.progress >= 1.0) {
      primitive.isActive := false;
      primitive.progress := 1.0;
    };
    
    // Interpolate pattern based on progress
    let output = Array.tabulate<Float>(MOTOR_DIM, func(i : Nat) : Float {
      primitive.pattern[i] * primitive.progress
    });
    
    output
  };

  // Update motor control
  public func updateMotorControl(
    mc : MotorControlState,
    goalState : [Float],
    currentState : [Float],
    sensoryFeedback : [Float],
    reward : Float,
    dt : Float
  ) {
    // 1. Action selection via basal ganglia
    let selectedAction = selectAction(mc.basalGanglia, currentState, reward);
    
    // 2. Activate corresponding primitive
    if (selectedAction < mc.plan.numPrimitives) {
      mc.plan.primitives[selectedAction].isActive := true;
    };
    
    // 3. Execute active primitives
    for (i in Iter.range(0, MOTOR_DIM - 1)) {
      mc.motorOutput[i] := 0.0;
    };
    
    for (p in Iter.range(0, mc.plan.numPrimitives - 1)) {
      if (mc.plan.primitives[p].isActive) {
        let primitiveOutput = executeMotorPrimitive(mc.plan.primitives[p], currentState, dt);
        for (i in Iter.range(0, MOTOR_DIM - 1)) {
          mc.motorOutput[i] += primitiveOutput[i];
        };
      };
    };
    
    // 4. Efference copy
    for (i in Iter.range(0, MOTOR_DIM - 1)) {
      mc.efferenceCopy[i] := mc.motorOutput[i];
    };
    
    // 5. Compute sensorimotor error
    var error : Float = 0.0;
    let feedbackDim = Nat.min(Array.size(sensoryFeedback), MOTOR_DIM);
    for (i in Iter.range(0, feedbackDim - 1)) {
      error += Float.abs(mc.efferenceCopy[i] - sensoryFeedback[i]);
    };
    mc.sensorimotorError := error / Float.fromInt(feedbackDim);
    
    // 6. Cerebellar learning
    updateCerebellum(mc.cerebellum, currentState, mc.sensorimotorError, dt);
    
    // 7. Fatigue
    var effort : Float = 0.0;
    for (i in Iter.range(0, MOTOR_DIM - 1)) {
      effort += Float.abs(mc.motorOutput[i]);
    };
    mc.fatigueLevel += 0.001 * effort * dt;
    mc.fatigueLevel := Float.max(0.0, mc.fatigueLevel - 0.0001 * dt);
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // DECISION MAKING — EVIDENCE ACCUMULATION AND CHOICE
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Decision processes:
  //
  // 1. DRIFT-DIFFUSION MODEL:
  //    dx = A × dt + σ × dW
  //    Decision when x crosses threshold
  //
  // 2. RACE MODEL:
  //    Multiple accumulators race to threshold
  //
  // 3. URGENCY-GATING:
  //    Threshold decreases over time
  //

  public type DriftDiffusionState = {
    var evidence : Float;                // Accumulated evidence
    var driftRate : Float;               // A (signal strength)
    var threshold : Float;               // Decision boundary
    var noiseLevel : Float;              // σ (variability)
    var startPoint : Float;              // Initial bias
    var nonDecisionTime : Float;         // Motor/encoding time
    var isDecided : Bool;
    var choice : Nat;                    // 0 or 1
    var reactionTime : Float;
    var confidence : Float;
  };

  public type RaceModelState = {
    var accumulators : [var Float];      // One per option
    var driftRates : [var Float];        // Drift rate per option
    var threshold : Float;               // Common threshold
    var noiseLevel : Float;
    var numOptions : Nat;
    var winner : Nat;
    var isDecided : Bool;
    var raceTime : Float;
  };

  public type UrgencyGatingState = {
    var urgency : Float;                 // Time pressure
    var urgencySlope : Float;            // Rate of urgency increase
    var effectiveThreshold : Float;      // Threshold after urgency
    var baseThreshold : Float;
    var elapsedTime : Float;
    var maxTime : Float;                 // Deadline
    var isUrgent : Bool;
  };

  public type DecisionState = {
    ddm : DriftDiffusionState;
    race : RaceModelState;
    urgency : UrgencyGatingState;
    var currentDecisionType : Text;      // "ddm", "race", "urgency"
    var valueComparison : Float;         // Expected value difference
    var speedAccuracyTradeoff : Float;   // Balance
    var decisionConfidence : Float;
    var postDecisionRegret : Float;
  };

  // Decision parameters
  public let DDM_THRESHOLD : Float = 1.0;
  public let DDM_NOISE : Float = 0.3;
  public let RACE_NUM_OPTIONS : Nat = 4;
  public let URGENCY_SLOPE : Float = 0.01;

  public func initDriftDiffusionState() : DriftDiffusionState {
    {
      var evidence = 0.0;
      var driftRate = 0.5;
      var threshold = DDM_THRESHOLD;
      var noiseLevel = DDM_NOISE;
      var startPoint = 0.0;
      var nonDecisionTime = 100.0;
      var isDecided = false;
      var choice = 0;
      var reactionTime = 0.0;
      var confidence = 0.0;
    }
  };

  public func initRaceModelState() : RaceModelState {
    {
      var accumulators = Array.init<Float>(RACE_NUM_OPTIONS, func(_ : Nat) : Float { 0.0 });
      var driftRates = Array.init<Float>(RACE_NUM_OPTIONS, func(_ : Nat) : Float { 0.5 });
      var threshold = DDM_THRESHOLD;
      var noiseLevel = DDM_NOISE;
      var numOptions = RACE_NUM_OPTIONS;
      var winner = 0;
      var isDecided = false;
      var raceTime = 0.0;
    }
  };

  public func initUrgencyGatingState() : UrgencyGatingState {
    {
      var urgency = 0.0;
      var urgencySlope = URGENCY_SLOPE;
      var effectiveThreshold = DDM_THRESHOLD;
      var baseThreshold = DDM_THRESHOLD;
      var elapsedTime = 0.0;
      var maxTime = 1000.0;
      var isUrgent = false;
    }
  };

  public func initDecisionState() : DecisionState {
    {
      ddm = initDriftDiffusionState();
      race = initRaceModelState();
      urgency = initUrgencyGatingState();
      var currentDecisionType = "ddm";
      var valueComparison = 0.0;
      var speedAccuracyTradeoff = 0.5;
      var decisionConfidence = 0.0;
      var postDecisionRegret = 0.0;
    }
  };

  // Update drift-diffusion model
  public func updateDDM(
    ddm : DriftDiffusionState,
    sensoryEvidence : Float,
    dt : Float
  ) : Bool {
    if (ddm.isDecided) { return true };
    
    ddm.reactionTime += dt;
    
    // Drift-diffusion dynamics
    // dx = A × dt + σ × dW
    let drift = ddm.driftRate * sensoryEvidence * dt / 1000.0;
    let noise = ddm.noiseLevel * Float.sqrt(dt / 1000.0) * 
                (Float.fromInt(Int.abs(Float.toInt(ddm.reactionTime * 1000.0)) % 100) / 50.0 - 1.0);
    
    ddm.evidence += drift + noise;
    
    // Check threshold
    if (Float.abs(ddm.evidence) >= ddm.threshold) {
      ddm.isDecided := true;
      ddm.choice := if (ddm.evidence > 0.0) { 1 } else { 0 };
      
      // Confidence from distance to threshold
      ddm.confidence := Float.abs(ddm.evidence) / ddm.threshold;
      ddm.confidence := clamp(ddm.confidence, 0.0, 1.0);
      
      return true;
    };
    
    false
  };

  // Update race model
  public func updateRaceModel(
    race : RaceModelState,
    evidencePerOption : [Float],
    dt : Float
  ) : Bool {
    if (race.isDecided) { return true };
    
    race.raceTime += dt;
    
    // Update each accumulator
    for (i in Iter.range(0, race.numOptions - 1)) {
      let evidence = if (i < Array.size(evidencePerOption)) { evidencePerOption[i] } else { 0.0 };
      let drift = race.driftRates[i] * evidence * dt / 1000.0;
      let noise = race.noiseLevel * Float.sqrt(dt / 1000.0) * 
                  (Float.fromInt((Int.abs(Float.toInt(race.raceTime * 1000.0)) + i * 37) % 100) / 50.0 - 1.0);
      
      race.accumulators[i] += drift + noise;
      race.accumulators[i] := Float.max(0.0, race.accumulators[i]);  // No negative evidence
      
      // Check threshold
      if (race.accumulators[i] >= race.threshold) {
        race.isDecided := true;
        race.winner := i;
        return true;
      };
    };
    
    false
  };

  // Update urgency gating
  public func updateUrgencyGating(urg : UrgencyGatingState, dt : Float) {
    urg.elapsedTime += dt;
    
    // Urgency increases with time
    urg.urgency := urg.urgencySlope * urg.elapsedTime / 1000.0;
    urg.urgency := clamp(urg.urgency, 0.0, 1.0);
    
    // Effective threshold decreases
    urg.effectiveThreshold := urg.baseThreshold * (1.0 - urg.urgency);
    urg.effectiveThreshold := Float.max(0.1, urg.effectiveThreshold);
    
    // Check if urgent
    urg.isUrgent := urg.elapsedTime > urg.maxTime * 0.7;
  };

  // Full decision update
  public func updateDecision(
    decision : DecisionState,
    sensoryEvidence : [Float],
    valueEstimates : [Float],
    dt : Float
  ) : ?Nat {
    // Update urgency
    updateUrgencyGating(decision.urgency, dt);
    
    // Apply urgency to thresholds
    decision.ddm.threshold := decision.urgency.effectiveThreshold;
    decision.race.threshold := decision.urgency.effectiveThreshold;
    
    // Run appropriate model
    switch (decision.currentDecisionType) {
      case ("ddm") {
        let mainEvidence = if (Array.size(sensoryEvidence) > 0) { sensoryEvidence[0] } else { 0.0 };
        if (updateDDM(decision.ddm, mainEvidence, dt)) {
          decision.decisionConfidence := decision.ddm.confidence;
          return ?decision.ddm.choice;
        };
      };
      case ("race") {
        if (updateRaceModel(decision.race, sensoryEvidence, dt)) {
          decision.decisionConfidence := decision.race.accumulators[decision.race.winner] / decision.race.threshold;
          return ?decision.race.winner;
        };
      };
      case (_) {
        let mainEvidence = if (Array.size(sensoryEvidence) > 0) { sensoryEvidence[0] } else { 0.0 };
        if (updateDDM(decision.ddm, mainEvidence, dt)) {
          return ?decision.ddm.choice;
        };
      };
    };
    
    // Compute value comparison
    if (Array.size(valueEstimates) >= 2) {
      decision.valueComparison := valueEstimates[0] - valueEstimates[1];
    };
    
    null
  };

  // Reset decision state
  public func resetDecision(decision : DecisionState) {
    decision.ddm.evidence := decision.ddm.startPoint;
    decision.ddm.isDecided := false;
    decision.ddm.reactionTime := 0.0;
    decision.ddm.confidence := 0.0;
    
    for (i in Iter.range(0, decision.race.numOptions - 1)) {
      decision.race.accumulators[i] := 0.0;
    };
    decision.race.isDecided := false;
    decision.race.raceTime := 0.0;
    
    decision.urgency.elapsedTime := 0.0;
    decision.urgency.urgency := 0.0;
    decision.urgency.effectiveThreshold := decision.urgency.baseThreshold;
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // LANGUAGE PROCESSING — BASIC LINGUISTIC REPRESENTATION
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Simplified linguistic processing:
  //
  // 1. SEMANTIC REPRESENTATION:
  //    - Word embeddings
  //    - Semantic similarity
  //
  // 2. SYNTACTIC STRUCTURE:
  //    - Basic phrase structure
  //    - Dependency relations
  //
  // 3. SENTENCE PROCESSING:
  //    - Incremental parsing
  //    - Prediction-based processing
  //

  public type WordEmbedding = {
    var vector : [var Float];            // Semantic vector
    var frequency : Float;               // Word frequency
    var concreteness : Float;            // Abstract vs concrete
    var valence : Float;                 // Emotional valence
    var arousal : Float;                 // Emotional arousal
  };

  public type SemanticMemoryLang = {
    var embeddings : [var WordEmbedding];
    var numWords : Nat;
    var embeddingDim : Nat;
    var similarityThreshold : Float;
  };

  public type SyntacticState = {
    var parseStack : [var Nat];          // Stack for parsing
    var stackTop : Nat;
    var currentPhrase : [var Float];     // Current phrase representation
    var dependencyLinks : [[var Float]]; // Dependency strengths
    var syntacticExpectations : [var Float]; // What's expected next
    var parseConfidence : Float;
  };

  public type LanguageProcessingState = {
    semantic : SemanticMemoryLang;
    syntax : SyntacticState;
    var inputBuffer : [var Float];       // Current input
    var outputBuffer : [var Float];      // Generated output
    var comprehensionScore : Float;
    var productionFluency : Float;
    var processingDepth : Float;
  };

  // Language parameters
  public let LANG_EMBEDDING_DIM : Nat = 32;
  public let LANG_VOCAB_SIZE : Nat = 100;
  public let LANG_STACK_SIZE : Nat = 20;

  public func initWordEmbedding() : WordEmbedding {
    {
      var vector = Array.init<Float>(LANG_EMBEDDING_DIM, func(i : Nat) : Float {
        (Float.fromInt(i % 10) / 5.0) - 1.0
      });
      var frequency = 0.01;
      var concreteness = 0.5;
      var valence = 0.0;
      var arousal = 0.5;
    }
  };

  public func initSemanticMemoryLang() : SemanticMemoryLang {
    {
      var embeddings = Array.init<WordEmbedding>(LANG_VOCAB_SIZE, func(_ : Nat) : WordEmbedding {
        initWordEmbedding()
      });
      var numWords = LANG_VOCAB_SIZE;
      var embeddingDim = LANG_EMBEDDING_DIM;
      var similarityThreshold = 0.7;
    }
  };

  public func initSyntacticState() : SyntacticState {
    {
      var parseStack = Array.init<Nat>(LANG_STACK_SIZE, func(_ : Nat) : Nat { 0 });
      var stackTop = 0;
      var currentPhrase = Array.init<Float>(LANG_EMBEDDING_DIM, func(_ : Nat) : Float { 0.0 });
      var dependencyLinks = Array.init<[var Float]>(10, func(_ : Nat) : [var Float] {
        Array.init<Float>(10, func(_ : Nat) : Float { 0.0 })
      });
      var syntacticExpectations = Array.init<Float>(10, func(_ : Nat) : Float { 0.1 });
      var parseConfidence = 0.5;
    }
  };

  public func initLanguageProcessingState() : LanguageProcessingState {
    {
      semantic = initSemanticMemoryLang();
      syntax = initSyntacticState();
      var inputBuffer = Array.init<Float>(LANG_EMBEDDING_DIM, func(_ : Nat) : Float { 0.0 });
      var outputBuffer = Array.init<Float>(LANG_EMBEDDING_DIM, func(_ : Nat) : Float { 0.0 });
      var comprehensionScore = 0.0;
      var productionFluency = 0.0;
      var processingDepth = 0.5;
    }
  };

  // Compute semantic similarity
  public func semanticSimilarity(a : [Float], b : [Float]) : Float {
    let dim = Nat.min(Array.size(a), Array.size(b));
    if (dim == 0) { return 0.0 };
    
    var dotProduct : Float = 0.0;
    var normA : Float = 0.0;
    var normB : Float = 0.0;
    
    for (i in Iter.range(0, dim - 1)) {
      dotProduct += a[i] * b[i];
      normA += a[i] * a[i];
      normB += b[i] * b[i];
    };
    
    if (normA > 0.0 and normB > 0.0) {
      dotProduct / (Float.sqrt(normA) * Float.sqrt(normB))
    } else {
      0.0
    }
  };

  // Find most similar word
  public func findSimilarWord(
    semantic : SemanticMemoryLang,
    query : [Float]
  ) : Nat {
    var bestIdx : Nat = 0;
    var bestSim : Float = -1.0;
    
    for (i in Iter.range(0, semantic.numWords - 1)) {
      let wordVec = Array.tabulate<Float>(LANG_EMBEDDING_DIM, func(j : Nat) : Float {
        semantic.embeddings[i].vector[j]
      });
      let sim = semanticSimilarity(query, wordVec);
      if (sim > bestSim) {
        bestSim := sim;
        bestIdx := i;
      };
    };
    
    bestIdx
  };

  // Process linguistic input
  public func processLanguageInput(
    lp : LanguageProcessingState,
    input : [Float],
    dt : Float
  ) {
    let inputDim = Nat.min(Array.size(input), LANG_EMBEDDING_DIM);
    
    // Copy to input buffer
    for (i in Iter.range(0, inputDim - 1)) {
      lp.inputBuffer[i] := input[i];
    };
    
    // Find best matching word
    let matchedWord = findSimilarWord(lp.semantic, input);
    
    // Update comprehension
    let matchSim = semanticSimilarity(
      input,
      Array.tabulate<Float>(LANG_EMBEDDING_DIM, func(j : Nat) : Float {
        lp.semantic.embeddings[matchedWord].vector[j]
      })
    );
    
    lp.comprehensionScore := 0.9 * lp.comprehensionScore + 0.1 * matchSim;
    
    // Update current phrase representation
    for (i in Iter.range(0, LANG_EMBEDDING_DIM - 1)) {
      lp.syntax.currentPhrase[i] := 0.8 * lp.syntax.currentPhrase[i] + 
                                     0.2 * lp.inputBuffer[i];
    };
    
    // Update syntactic expectations (simplified)
    for (i in Iter.range(0, 9)) {
      lp.syntax.syntacticExpectations[i] := 0.9 * lp.syntax.syntacticExpectations[i] + 
                                             0.1 * lp.syntax.currentPhrase[i * 3];
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // NAVIGATION AND SPATIAL COGNITION
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Spatial processing:
  //
  // 1. PLACE CELLS: Fire at specific locations
  // 2. GRID CELLS: Hexagonal firing patterns
  // 3. HEAD DIRECTION CELLS: Compass-like
  // 4. BORDER CELLS: Fire at boundaries
  //

  public type PlaceCell = {
    var placeField : [var Float];        // 2D place field
    var centerX : Float;
    var centerY : Float;
    var fieldWidth : Float;
    var firingRate : Float;
    var active : Bool;
  };

  public type GridCell = {
    var phase : [var Float];             // 3 phases for hex grid
    var spacing : Float;                 // Grid spacing
    var orientation : Float;             // Grid orientation
    var firingRate : Float;
  };

  public type HeadDirectionCell = {
    var preferredDirection : Float;      // Preferred heading (radians)
    var tuningWidth : Float;             // Width of tuning curve
    var currentFiring : Float;
    var attractor : Float;               // Attractor dynamics
  };

  public type SpatialCognitionState = {
    var placeCells : [var PlaceCell];
    var gridCells : [var GridCell];
    var headDirectionCells : [var HeadDirectionCell];
    var currentPosition : (Float, Float); // x, y
    var currentHeading : Float;          // radians
    var pathIntegration : (Float, Float);// Integrated position
    var cognitiveMap : [[var Float]];    // Internal map
    var mapSize : Nat;
    var navigationGoal : (Float, Float);
    var distanceToGoal : Float;
  };

  // Spatial parameters
  public let SPATIAL_NUM_PLACE : Nat = 20;
  public let SPATIAL_NUM_GRID : Nat = 10;
  public let SPATIAL_NUM_HD : Nat = 8;
  public let SPATIAL_MAP_SIZE : Nat = 20;

  public func initPlaceCell(x : Float, y : Float) : PlaceCell {
    {
      var placeField = Array.init<Float>(100, func(_ : Nat) : Float { 0.0 });
      var centerX = x;
      var centerY = y;
      var fieldWidth = 0.3;
      var firingRate = 0.0;
      var active = false;
    }
  };

  public func initGridCell(spacing : Float, orientation : Float) : GridCell {
    {
      var phase = Array.init<Float>(3, func(_ : Nat) : Float { 0.0 });
      var spacing = spacing;
      var orientation = orientation;
      var firingRate = 0.0;
    }
  };

  public func initHeadDirectionCell(prefDir : Float) : HeadDirectionCell {
    {
      var preferredDirection = prefDir;
      var tuningWidth = 0.5;
      var currentFiring = 0.0;
      var attractor = prefDir;
    }
  };

  public func initSpatialCognitionState() : SpatialCognitionState {
    {
      var placeCells = Array.init<PlaceCell>(SPATIAL_NUM_PLACE, func(i : Nat) : PlaceCell {
        let x = Float.fromInt(i % 5) / 4.0;
        let y = Float.fromInt(i / 5) / 4.0;
        initPlaceCell(x, y)
      });
      var gridCells = Array.init<GridCell>(SPATIAL_NUM_GRID, func(i : Nat) : GridCell {
        let spacing = 0.2 + Float.fromInt(i) * 0.1;
        let orientation = Float.fromInt(i) * PI / Float.fromInt(SPATIAL_NUM_GRID);
        initGridCell(spacing, orientation)
      });
      var headDirectionCells = Array.init<HeadDirectionCell>(SPATIAL_NUM_HD, func(i : Nat) : HeadDirectionCell {
        let prefDir = Float.fromInt(i) * 2.0 * PI / Float.fromInt(SPATIAL_NUM_HD);
        initHeadDirectionCell(prefDir)
      });
      var currentPosition = (0.5, 0.5);
      var currentHeading = 0.0;
      var pathIntegration = (0.5, 0.5);
      var cognitiveMap = Array.init<[var Float]>(SPATIAL_MAP_SIZE, func(_ : Nat) : [var Float] {
        Array.init<Float>(SPATIAL_MAP_SIZE, func(_ : Nat) : Float { 0.0 })
      });
      var mapSize = SPATIAL_MAP_SIZE;
      var navigationGoal = (1.0, 1.0);
      var distanceToGoal = 1.0;
    }
  };

  // Update place cell firing
  public func updatePlaceCells(
    spatial : SpatialCognitionState,
    position : (Float, Float)
  ) {
    spatial.currentPosition := position;
    let (x, y) = position;
    
    for (i in Iter.range(0, SPATIAL_NUM_PLACE - 1)) {
      let pc = spatial.placeCells[i];
      
      // Gaussian tuning curve
      let dx = x - pc.centerX;
      let dy = y - pc.centerY;
      let distSq = dx * dx + dy * dy;
      
      pc.firingRate := exp(-distSq / (2.0 * pc.fieldWidth * pc.fieldWidth));
      pc.active := pc.firingRate > 0.3;
    };
  };

  // Update head direction cells
  public func updateHeadDirectionCells(
    spatial : SpatialCognitionState,
    heading : Float,
    angularVelocity : Float,
    dt : Float
  ) {
    spatial.currentHeading := heading;
    
    for (i in Iter.range(0, SPATIAL_NUM_HD - 1)) {
      let hd = spatial.headDirectionCells[i];
      
      // Circular tuning curve
      var angleDiff = heading - hd.preferredDirection;
      while (angleDiff > PI) { angleDiff -= 2.0 * PI };
      while (angleDiff < -PI) { angleDiff += 2.0 * PI };
      
      hd.currentFiring := exp(-angleDiff * angleDiff / (2.0 * hd.tuningWidth * hd.tuningWidth));
      
      // Attractor dynamics for persistent firing
      hd.attractor := 0.95 * hd.attractor + 0.05 * heading;
    };
  };

  // Path integration
  public func updatePathIntegration(
    spatial : SpatialCognitionState,
    velocity : (Float, Float),
    dt : Float
  ) {
    let (vx, vy) = velocity;
    let (px, py) = spatial.pathIntegration;
    
    spatial.pathIntegration := (
      px + vx * dt / 1000.0,
      py + vy * dt / 1000.0
    );
    
    // Update cognitive map
    let (x, y) = spatial.currentPosition;
    let mapX = Int.abs(Float.toInt(x * Float.fromInt(spatial.mapSize)));
    let mapY = Int.abs(Float.toInt(y * Float.fromInt(spatial.mapSize)));
    
    if (mapX < spatial.mapSize and mapY < spatial.mapSize) {
      spatial.cognitiveMap[mapX][mapY] += 0.1;
    };
    
    // Compute distance to goal
    let (gx, gy) = spatial.navigationGoal;
    let dx = gx - x;
    let dy = gy - y;
    spatial.distanceToGoal := Float.sqrt(dx * dx + dy * dy);
  };


  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // HOMEOSTATIC DRIVES — BIOLOGICAL MOTIVATION
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Primary drives maintain organism viability:
  //
  // 1. ENERGY HOMEOSTASIS:
  //    - Hunger/satiety
  //    - Metabolic regulation
  //
  // 2. FLUID HOMEOSTASIS:
  //    - Thirst
  //    - Osmotic balance
  //
  // 3. TEMPERATURE HOMEOSTASIS:
  //    - Thermoregulation
  //    - Behavioral adjustments
  //
  // 4. SAFETY/THREAT:
  //    - Fear circuits
  //    - Defensive behaviors
  //

  public type HomeostaticDrive = {
    var setpoint : Float;                // Desired level
    var currentLevel : Float;            // Actual level
    var error : Float;                   // Setpoint - current
    var driveStrength : Float;           // Motivational urgency
    var satisfactionRate : Float;        // How fast satisfied
    var depletionRate : Float;           // How fast depletes
    var lastSatisfied : Float;           // Time since last satisfied
    var chronicity : Float;              // Chronic deviation
  };

  public type EnergyDrive = {
    core : HomeostaticDrive;
    var glucoseLevel : Float;            // Blood glucose
    var leptin : Float;                  // Satiety hormone
    var ghrelin : Float;                 // Hunger hormone
    var insulinSensitivity : Float;
    var fatStores : Float;
    var metabolicRate : Float;
    var isHungry : Bool;
    var isSatiated : Bool;
  };

  public type FluidDrive = {
    core : HomeostaticDrive;
    var osmolarity : Float;              // Blood salt concentration
    var bloodVolume : Float;
    var vasopressin : Float;             // ADH
    var angiotensin : Float;
    var isThirsty : Bool;
  };

  public type TemperatureDrive = {
    core : HomeostaticDrive;
    var coreTemp : Float;                // °C
    var skinTemp : Float;
    var hypothalamusTemp : Float;
    var shivering : Float;
    var sweating : Float;
    var vasoconstriction : Float;
    var thermalComfort : Float;
  };

  public type SafetyDrive = {
    core : HomeostaticDrive;
    var threatLevel : Float;
    var fearLevel : Float;
    var anxietyLevel : Float;
    var safetySignals : Float;
    var escapeUrge : Float;
    var freezeResponse : Float;
    var fightResponse : Float;
    var flightResponse : Float;
  };

  public type DriveSystemState = {
    energy : EnergyDrive;
    fluid : FluidDrive;
    temperature : TemperatureDrive;
    safety : SafetyDrive;
    var dominantDrive : Text;            // Current strongest drive
    var overallMotivation : Float;       // Total drive strength
    var allostasis : Float;              // Adaptive setpoint changes
    var driveConflict : Float;           // Competing drives
  };

  // Drive parameters
  public let DRIVE_ENERGY_SETPOINT : Float = 0.7;
  public let DRIVE_FLUID_SETPOINT : Float = 0.8;
  public let DRIVE_TEMP_SETPOINT : Float = 37.0;
  public let DRIVE_SAFETY_SETPOINT : Float = 0.9;

  public func initHomeostaticDrive(setpoint : Float) : HomeostaticDrive {
    {
      var setpoint = setpoint;
      var currentLevel = setpoint;
      var error = 0.0;
      var driveStrength = 0.0;
      var satisfactionRate = 0.1;
      var depletionRate = 0.01;
      var lastSatisfied = 0.0;
      var chronicity = 0.0;
    }
  };

  public func initEnergyDrive() : EnergyDrive {
    {
      core = initHomeostaticDrive(DRIVE_ENERGY_SETPOINT);
      var glucoseLevel = 1.0;
      var leptin = 0.5;
      var ghrelin = 0.3;
      var insulinSensitivity = 0.8;
      var fatStores = 0.5;
      var metabolicRate = 1.0;
      var isHungry = false;
      var isSatiated = false;
    }
  };

  public func initFluidDrive() : FluidDrive {
    {
      core = initHomeostaticDrive(DRIVE_FLUID_SETPOINT);
      var osmolarity = 290.0;
      var bloodVolume = 1.0;
      var vasopressin = 0.3;
      var angiotensin = 0.2;
      var isThirsty = false;
    }
  };

  public func initTemperatureDrive() : TemperatureDrive {
    {
      core = initHomeostaticDrive(DRIVE_TEMP_SETPOINT);
      var coreTemp = 37.0;
      var skinTemp = 33.0;
      var hypothalamusTemp = 37.0;
      var shivering = 0.0;
      var sweating = 0.0;
      var vasoconstriction = 0.0;
      var thermalComfort = 1.0;
    }
  };

  public func initSafetyDrive() : SafetyDrive {
    {
      core = initHomeostaticDrive(DRIVE_SAFETY_SETPOINT);
      var threatLevel = 0.0;
      var fearLevel = 0.0;
      var anxietyLevel = 0.0;
      var safetySignals = 0.8;
      var escapeUrge = 0.0;
      var freezeResponse = 0.0;
      var fightResponse = 0.0;
      var flightResponse = 0.0;
    }
  };

  public func initDriveSystemState() : DriveSystemState {
    {
      energy = initEnergyDrive();
      fluid = initFluidDrive();
      temperature = initTemperatureDrive();
      safety = initSafetyDrive();
      var dominantDrive = "none";
      var overallMotivation = 0.0;
      var allostasis = 0.0;
      var driveConflict = 0.0;
    }
  };

  // Update homeostatic drive
  public func updateHomeostaticDrive(
    drive : HomeostaticDrive,
    consumption : Float,
    expenditure : Float,
    dt : Float
  ) {
    // Update current level
    drive.currentLevel += consumption * drive.satisfactionRate * dt / 1000.0;
    drive.currentLevel -= expenditure * drive.depletionRate * dt / 1000.0;
    drive.currentLevel := clamp(drive.currentLevel, 0.0, 1.5);
    
    // Compute error
    drive.error := drive.setpoint - drive.currentLevel;
    
    // Drive strength increases nonlinearly with error
    if (drive.error > 0.0) {
      drive.driveStrength := drive.error * drive.error;  // Quadratic urgency
    } else {
      drive.driveStrength := 0.0;  // Satisfied
    };
    
    // Chronicity
    if (drive.driveStrength > 0.3) {
      drive.chronicity += 0.001 * dt / 1000.0;
    } else {
      drive.chronicity := Float.max(0.0, drive.chronicity - 0.0005 * dt / 1000.0);
    };
    
    // Track last satisfied
    if (drive.driveStrength < 0.1) {
      drive.lastSatisfied := 0.0;
    } else {
      drive.lastSatisfied += dt;
    };
  };

  // Update energy drive
  public func updateEnergyDrive(
    energy : EnergyDrive,
    foodIntake : Float,
    activityLevel : Float,
    dt : Float
  ) {
    // Glucose dynamics
    energy.glucoseLevel += foodIntake * 0.5;
    energy.glucoseLevel -= activityLevel * 0.1 * energy.metabolicRate * dt / 1000.0;
    energy.glucoseLevel := clamp(energy.glucoseLevel, 0.1, 2.0);
    
    // Hormones
    energy.ghrelin := 1.0 - energy.glucoseLevel * 0.5;  // Inverse of glucose
    energy.leptin := energy.fatStores;
    
    // Update core drive
    updateHomeostaticDrive(energy.core, foodIntake, activityLevel * energy.metabolicRate, dt);
    
    // States
    energy.isHungry := energy.ghrelin > 0.6;
    energy.isSatiated := energy.leptin > 0.7 and energy.glucoseLevel > 1.0;
    
    // Fat stores (slow dynamics)
    if (energy.glucoseLevel > 1.2) {
      energy.fatStores += 0.0001 * dt / 1000.0;
    } else if (energy.glucoseLevel < 0.5) {
      energy.fatStores -= 0.0001 * dt / 1000.0;
    };
    energy.fatStores := clamp(energy.fatStores, 0.0, 1.0);
  };

  // Update safety drive
  public func updateSafetyDrive(
    safety : SafetyDrive,
    threatInput : Float,
    safetyInput : Float,
    dt : Float
  ) {
    // Threat integration
    safety.threatLevel := 0.9 * safety.threatLevel + 0.1 * threatInput;
    safety.safetySignals := 0.9 * safety.safetySignals + 0.1 * safetyInput;
    
    // Fear response
    safety.fearLevel := safety.threatLevel * (1.0 - safety.safetySignals);
    
    // Anxiety (anticipatory)
    safety.anxietyLevel := 0.99 * safety.anxietyLevel + 0.01 * safety.threatLevel;
    
    // Defense responses (mutual inhibition)
    let totalThreat = safety.fearLevel + safety.anxietyLevel;
    
    if (totalThreat > 0.7) {
      // High threat: fight or flight
      if (safety.core.currentLevel > 0.5) {
        safety.fightResponse := totalThreat * 0.5;
        safety.flightResponse := totalThreat * 0.3;
      } else {
        safety.flightResponse := totalThreat * 0.7;
        safety.fightResponse := totalThreat * 0.2;
      };
      safety.freezeResponse := 0.1;
    } else if (totalThreat > 0.3) {
      // Moderate threat: freeze
      safety.freezeResponse := totalThreat;
      safety.fightResponse := 0.0;
      safety.flightResponse := 0.0;
    } else {
      // Low threat: all responses decay
      safety.freezeResponse *= 0.95;
      safety.fightResponse *= 0.95;
      safety.flightResponse *= 0.95;
    };
    
    // Escape urge
    safety.escapeUrge := safety.flightResponse + 0.5 * safety.fearLevel;
    
    // Update core
    safety.core.currentLevel := safety.safetySignals;
    updateHomeostaticDrive(safety.core, safetyInput, threatInput, dt);
  };

  // Update full drive system
  public func updateDriveSystem(
    ds : DriveSystemState,
    foodIntake : Float,
    fluidIntake : Float,
    ambientTemp : Float,
    threatInput : Float,
    safetyInput : Float,
    activityLevel : Float,
    dt : Float
  ) {
    // Update individual drives
    updateEnergyDrive(ds.energy, foodIntake, activityLevel, dt);
    
    // Fluid drive (simplified)
    updateHomeostaticDrive(ds.fluid.core, fluidIntake, 0.5, dt);
    ds.fluid.isThirsty := ds.fluid.core.error > 0.2;
    
    // Temperature drive (simplified)
    ds.temperature.coreTemp := 0.99 * ds.temperature.coreTemp + 0.01 * ambientTemp;
    ds.temperature.core.currentLevel := 1.0 - Float.abs(ds.temperature.coreTemp - DRIVE_TEMP_SETPOINT) / 5.0;
    updateHomeostaticDrive(ds.temperature.core, 0.0, Float.abs(ambientTemp - DRIVE_TEMP_SETPOINT) * 0.1, dt);
    
    // Safety drive
    updateSafetyDrive(ds.safety, threatInput, safetyInput, dt);
    
    // Find dominant drive
    var maxDrive : Float = 0.0;
    ds.dominantDrive := "none";
    
    if (ds.energy.core.driveStrength > maxDrive) {
      maxDrive := ds.energy.core.driveStrength;
      ds.dominantDrive := "energy";
    };
    if (ds.fluid.core.driveStrength > maxDrive) {
      maxDrive := ds.fluid.core.driveStrength;
      ds.dominantDrive := "fluid";
    };
    if (ds.temperature.core.driveStrength > maxDrive) {
      maxDrive := ds.temperature.core.driveStrength;
      ds.dominantDrive := "temperature";
    };
    if (ds.safety.core.driveStrength > maxDrive) {
      maxDrive := ds.safety.core.driveStrength;
      ds.dominantDrive := "safety";
    };
    
    // Overall motivation
    ds.overallMotivation := (ds.energy.core.driveStrength + 
                              ds.fluid.core.driveStrength + 
                              ds.temperature.core.driveStrength + 
                              ds.safety.core.driveStrength) / 4.0;
    
    // Drive conflict
    let drives = [ds.energy.core.driveStrength, ds.fluid.core.driveStrength, 
                  ds.temperature.core.driveStrength, ds.safety.core.driveStrength];
    var variance : Float = 0.0;
    for (d in drives.vals()) {
      let diff = d - ds.overallMotivation;
      variance += diff * diff;
    };
    ds.driveConflict := variance / 4.0;
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SELF AND IDENTITY — ORGANISM BOUNDARY
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // The organism's sense of self:
  //
  // 1. BODY OWNERSHIP:
  //    - Multisensory integration
  //    - Rubber hand illusion
  //
  // 2. AGENCY:
  //    - Sense of causing actions
  //    - Prediction-based
  //
  // 3. AUTOBIOGRAPHICAL SELF:
  //    - Personal history
  //    - Future projection
  //

  public type BodySchema = {
    var bodyParts : [[var Float]];       // Representation of body parts
    var numParts : Nat;
    var proprioception : [var Float];    // Joint angles
    var vestibular : [var Float];        // Balance
    var interoception : [var Float];     // Internal state
    var bodyBoundary : Float;            // Sense of body boundary
    var embodiment : Float;              // Embodiment strength
  };

  public type AgencyState = {
    var predictedOutcome : [var Float];  // What I expect
    var actualOutcome : [var Float];     // What happened
    var predictionError : Float;         // Mismatch
    var agencySense : Float;             // "I did it"
    var effortLevel : Float;             // Motor effort
    var intentionStrength : Float;       // How intentional
    var controlBelief : Float;           // Belief in control
  };

  public type AutobiographicalSelf = {
    var episodicMemories : [var Float];  // Personal memories
    var semanticSelf : [var Float];      // Self-concept
    var goals : [var Float];             // Personal goals
    var values : [var Float];            // Core values
    var futureProjection : [var Float];  // Expected future
    var narrativeCoherence : Float;      // Story of self
    var identityStrength : Float;        // Strength of identity
  };

  public type SelfState = {
    body : BodySchema;
    agency : AgencyState;
    autobiographical : AutobiographicalSelf;
    var minimalSelf : Float;             // Basic self-awareness
    var narrativeSelf : Float;           // Extended self
    var selfOtherBoundary : Float;       // Distinction from others
    var selfContinuity : Float;          // Persistence over time
  };

  // Self parameters
  public let SELF_NUM_BODY_PARTS : Nat = 10;
  public let SELF_PROPRIOCEPTION_DIM : Nat = 12;

  public func initBodySchema() : BodySchema {
    {
      var bodyParts = Array.init<[var Float]>(SELF_NUM_BODY_PARTS, func(_ : Nat) : [var Float] {
        Array.init<Float>(8, func(_ : Nat) : Float { 0.0 })
      });
      var numParts = SELF_NUM_BODY_PARTS;
      var proprioception = Array.init<Float>(SELF_PROPRIOCEPTION_DIM, func(_ : Nat) : Float { 0.0 });
      var vestibular = Array.init<Float>(3, func(_ : Nat) : Float { 0.0 });
      var interoception = Array.init<Float>(8, func(_ : Nat) : Float { 0.5 });
      var bodyBoundary = 1.0;
      var embodiment = 1.0;
    }
  };

  public func initAgencyState() : AgencyState {
    {
      var predictedOutcome = Array.init<Float>(8, func(_ : Nat) : Float { 0.0 });
      var actualOutcome = Array.init<Float>(8, func(_ : Nat) : Float { 0.0 });
      var predictionError = 0.0;
      var agencySense = 1.0;
      var effortLevel = 0.0;
      var intentionStrength = 0.0;
      var controlBelief = 0.8;
    }
  };

  public func initAutobiographicalSelf() : AutobiographicalSelf {
    {
      var episodicMemories = Array.init<Float>(50, func(_ : Nat) : Float { 0.0 });
      var semanticSelf = Array.init<Float>(16, func(_ : Nat) : Float { 0.5 });
      var goals = Array.init<Float>(8, func(_ : Nat) : Float { 0.5 });
      var values = Array.init<Float>(8, func(_ : Nat) : Float { 0.5 });
      var futureProjection = Array.init<Float>(16, func(_ : Nat) : Float { 0.5 });
      var narrativeCoherence = 0.5;
      var identityStrength = 0.5;
    }
  };

  public func initSelfState() : SelfState {
    {
      body = initBodySchema();
      agency = initAgencyState();
      autobiographical = initAutobiographicalSelf();
      var minimalSelf = 1.0;
      var narrativeSelf = 0.5;
      var selfOtherBoundary = 1.0;
      var selfContinuity = 1.0;
    }
  };

  // Update body schema
  public func updateBodySchema(
    body : BodySchema,
    somatosensory : [Float],
    vestibularInput : [Float],
    interoceptiveInput : [Float]
  ) {
    // Update proprioception
    let propDim = Nat.min(Array.size(somatosensory), SELF_PROPRIOCEPTION_DIM);
    for (i in Iter.range(0, propDim - 1)) {
      body.proprioception[i] := 0.9 * body.proprioception[i] + 0.1 * somatosensory[i];
    };
    
    // Update vestibular
    let vestDim = Nat.min(Array.size(vestibularInput), 3);
    for (i in Iter.range(0, vestDim - 1)) {
      body.vestibular[i] := 0.8 * body.vestibular[i] + 0.2 * vestibularInput[i];
    };
    
    // Update interoception
    let interoDim = Nat.min(Array.size(interoceptiveInput), 8);
    for (i in Iter.range(0, interoDim - 1)) {
      body.interoception[i] := 0.95 * body.interoception[i] + 0.05 * interoceptiveInput[i];
    };
    
    // Embodiment from multimodal coherence
    var coherence : Float = 0.0;
    for (i in Iter.range(0, propDim - 1)) {
      coherence += Float.abs(body.proprioception[i]);
    };
    body.embodiment := coherence / Float.fromInt(propDim);
  };

  // Update agency
  public func updateAgency(
    agency : AgencyState,
    prediction : [Float],
    outcome : [Float],
    effort : Float,
    intention : Float
  ) {
    // Copy prediction and outcome
    let dim = Nat.min(Array.size(prediction), 8);
    for (i in Iter.range(0, dim - 1)) {
      agency.predictedOutcome[i] := prediction[i];
    };
    
    let outDim = Nat.min(Array.size(outcome), 8);
    for (i in Iter.range(0, outDim - 1)) {
      agency.actualOutcome[i] := outcome[i];
    };
    
    // Compute prediction error
    var error : Float = 0.0;
    for (i in Iter.range(0, Nat.min(dim, outDim) - 1)) {
      error += Float.abs(agency.predictedOutcome[i] - agency.actualOutcome[i]);
    };
    agency.predictionError := error / Float.fromInt(Nat.min(dim, outDim));
    
    // Agency sense (inverse of prediction error)
    agency.agencySense := 1.0 - agency.predictionError;
    agency.agencySense := agency.agencySense * intention;  // Modulate by intention
    
    agency.effortLevel := effort;
    agency.intentionStrength := intention;
    
    // Update control belief
    agency.controlBelief := 0.95 * agency.controlBelief + 0.05 * agency.agencySense;
  };

  // Update full self state
  public func updateSelfState(
    self : SelfState,
    somatosensory : [Float],
    vestibularInput : [Float],
    interoceptiveInput : [Float],
    prediction : [Float],
    outcome : [Float],
    effort : Float,
    intention : Float,
    dt : Float
  ) {
    updateBodySchema(self.body, somatosensory, vestibularInput, interoceptiveInput);
    updateAgency(self.agency, prediction, outcome, effort, intention);
    
    // Minimal self from body and agency
    self.minimalSelf := (self.body.embodiment + self.agency.agencySense) / 2.0;
    
    // Self-other boundary
    self.selfOtherBoundary := self.body.bodyBoundary * self.agency.controlBelief;
    
    // Narrative self (slower dynamics)
    self.narrativeSelf := 0.999 * self.narrativeSelf + 0.001 * self.minimalSelf;
    
    // Self-continuity
    let currentState = self.minimalSelf;
    let continuityError = Float.abs(currentState - self.narrativeSelf);
    self.selfContinuity := 1.0 - continuityError;
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // ORGANISM INTEGRATION — UNIFIED SYSTEM
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // The complete integrated organism:
  //
  // All systems interacting:
  // - Perception → Cognition → Action
  // - Emotion → Motivation → Behavior
  // - Memory → Learning → Adaptation
  // - Self → Social → Culture
  //

  public type OrganismState = {
    // Neural systems
    hebbian : DeepHebbianHeartbeatState;
    kuramoto : KuramotoNetwork;
    
    // Cognitive systems
    consciousness : ConsciousnessState;
    memory : MemorySystemsState;
    decision : DecisionState;
    attention : AttentionalGating;
    
    // Emotional systems
    emotion : EmotionalState;
    stress : StressPlasticity;
    
    // Motor systems
    motor : MotorControlState;
    spatial : SpatialCognitionState;
    
    // Homeostatic systems
    drives : DriveSystemState;
    circadian : CircadianPlasticity;
    
    // Self systems
    self : SelfState;
    social : SocialCognitionState;
    
    // Language
    language : LanguageProcessingState;
    
    // Global state
    var currentBeat : Nat;               // Heartbeat counter
    var organismCoherence : Float;       // Global coherence
    var viability : Float;               // Overall health
    var adaptationLevel : Float;         // Plasticity level
    var sacredAlignment : Float;         // φ alignment
  };

  public type OrganismHeartbeatResult = {
    coherence : Float;
    viability : Float;
    dominantDrive : Text;
    currentEmotion : Text;
    consciousnessLevel : Float;
    learningRate : Float;
    actionSelected : Nat;
    sacredBeat : Bool;
  };

  public func initOrganismState() : OrganismState {
    {
      hebbian = initDeepHebbianState();
      kuramoto = initKuramotoNetwork();
      consciousness = initConsciousnessState();
      memory = initMemorySystemsState();
      decision = initDecisionState();
      attention = initAttentionalGating(12, 12);
      emotion = initEmotionalState();
      stress = initStressPlasticity();
      motor = initMotorControlState();
      spatial = initSpatialCognitionState();
      drives = initDriveSystemState();
      circadian = initCircadianPlasticity();
      self = initSelfState();
      social = initSocialCognitionState(5);
      language = initLanguageProcessingState();
      var currentBeat = 0;
      var organismCoherence = 1.0;
      var viability = 1.0;
      var adaptationLevel = 0.5;
      var sacredAlignment = 1.0;
    }
  };

  // Run one organism heartbeat
  public func organismHeartbeat(
    org : OrganismState,
    sensoryInput : [Float],
    reward : Float,
    threat : Float,
    socialInput : [[Float]],
    dt : Float
  ) : OrganismHeartbeatResult {
    org.currentBeat += 1;
    
    // 1. Update circadian clock
    let lightLevel = if (Array.size(sensoryInput) > 0) { sensoryInput[0] } else { 0.5 };
    computeCircadianPlasticity(org.circadian, lightLevel, dt / 3600000.0);
    
    // 2. Update drives
    let foodIntake = if (Array.size(sensoryInput) > 1) { sensoryInput[1] } else { 0.0 };
    let fluidIntake = if (Array.size(sensoryInput) > 2) { sensoryInput[2] } else { 0.0 };
    updateDriveSystem(org.drives, foodIntake, fluidIntake, 25.0, threat, 1.0 - threat, 0.5, dt);
    
    // 3. Update emotion
    let goals = Array.tabulate<Float>(8, func(i : Nat) : Float {
      if (i < 4) { 1.0 - org.drives.energy.core.error }
      else { org.drives.safety.safetySignals }
    });
    let predictions = Array.tabulate<Float>(8, func(i : Nat) : Float {
      if (i < Array.size(sensoryInput)) { sensoryInput[i] * 0.9 } else { 0.5 }
    });
    updateEmotionalState(org.emotion, sensoryInput, goals, predictions, dt);
    
    // 4. Update stress
    let novelty = if (Array.size(sensoryInput) > 3) { Float.abs(sensoryInput[3] - 0.5) } else { 0.0 };
    computeStressPlasticity(org.stress, threat, novelty, 0.5, org.emotion.emotionalIntensity, dt);
    
    // 5. Update attention
    let salience = Array.tabulate<Float>(Array.size(sensoryInput), func(i : Nat) : Float {
      Float.abs(sensoryInput[i] - 0.5) + threat
    });
    updateAttention(org.attention.attention, salience, [], org.drives.overallMotivation, novelty, dt);
    let _ = computeAttentionalGating(org.attention, org.emotion.emotionalIntensity, novelty);
    
    // 6. Update Kuramoto
    updateKuramotoNetwork(org.kuramoto, sensoryInput, dt);
    
    // 7. Update consciousness
    let moduleInputs = Array.tabulate<[Float]>(8, func(i : Nat) : [Float] {
      if (i < Array.size(sensoryInput)) {
        [sensoryInput[i], org.emotion.affect.valence, org.drives.overallMotivation]
      } else {
        [0.0, 0.0, 0.0]
      }
    });
    updateConsciousness(org.consciousness, moduleInputs, [], dt);
    
    // 8. Update memory
    if (org.emotion.emotionalIntensity > 0.5 or reward > 0.5) {
      let context = Array.tabulate<Float>(16, func(i : Nat) : Float {
        if (i < 8) { sensoryInput[i % Array.size(sensoryInput)] }
        else { org.emotion.affect.valence }
      });
      storeEpisodicMemory(org.memory.episodic, sensoryInput, context, Float.fromInt(org.currentBeat));
    };
    
    // 9. Update decision
    let valueEstimates = [org.drives.energy.core.driveStrength, org.drives.safety.core.driveStrength];
    let decisionResult = updateDecision(org.decision, sensoryInput, valueEstimates, dt);
    
    // 10. Update motor
    let goalState = Array.tabulate<Float>(8, func(i : Nat) : Float {
      1.0 - org.drives.energy.core.error
    });
    let currentState = sensoryInput;
    updateMotorControl(org.motor, goalState, currentState, sensoryInput, reward, dt);
    
    // 11. Update spatial
    let (px, py) = org.spatial.currentPosition;
    let velocity = (org.motor.motorOutput[0], org.motor.motorOutput[1]);
    updatePlaceCells(org.spatial, (px, py));
    updatePathIntegration(org.spatial, velocity, dt);
    
    // 12. Update self
    let vestibular = [0.0, 0.0, 0.0];
    let interoceptive = Array.tabulate<Float>(8, func(i : Nat) : Float {
      org.drives.energy.core.currentLevel
    });
    updateSelfState(
      org.self,
      sensoryInput,
      vestibular,
      interoceptive,
      Array.freeze(org.motor.efferenceCopy),
      sensoryInput,
      org.motor.fatigueLevel,
      org.decision.ddm.confidence,
      dt
    );
    
    // 13. Compute global state
    org.organismCoherence := (org.kuramoto.synchronizationLevel + 
                               org.consciousness.phi + 
                               org.self.selfContinuity) / 3.0;
    
    org.viability := (1.0 - org.drives.overallMotivation) * org.self.minimalSelf;
    
    org.adaptationLevel := org.stress.overallStressModulation * org.circadian.overallCircadianGain;
    
    // 14. Sacred beat check
    let sacredBeat = isSacredBeat(org.currentBeat);
    
    // 15. Build result
    let selectedAction = switch (decisionResult) {
      case (?a) { a };
      case (null) { org.motor.basalGanglia.selectedAction };
    };
    
    {
      coherence = org.organismCoherence;
      viability = org.viability;
      dominantDrive = org.drives.dominantDrive;
      currentEmotion = org.emotion.discrete.dominant;
      consciousnessLevel = org.consciousness.accessConsciousness;
      learningRate = org.adaptationLevel;
      actionSelected = selectedAction;
      sacredBeat = sacredBeat;
    }
  };


  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // EXECUTIVE FUNCTIONS — COGNITIVE CONTROL
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Prefrontal cortex functions:
  //
  // 1. WORKING MEMORY:
  //    - Active maintenance
  //    - Manipulation
  //
  // 2. INHIBITORY CONTROL:
  //    - Response inhibition
  //    - Interference control
  //
  // 3. COGNITIVE FLEXIBILITY:
  //    - Task switching
  //    - Rule updating
  //
  // 4. PLANNING:
  //    - Goal hierarchies
  //    - Sequencing
  //

  public type WorkingMemoryExecutive = {
    var slots : [[var Float]];
    var slotDim : Nat;
    var numSlots : Nat;
    var activeSlots : [var Bool];
    var updateGate : [var Float];        // What gets updated
    var outputGate : [var Float];        // What gets output
    var forgetGate : [var Float];        // What gets forgotten
    var centralExecutive : Float;        // Control strength
    var maintenanceLoad : Float;         // Cognitive load
  };

  public type InhibitoryControl = {
    var prepotentResponse : [var Float]; // Default response
    var inhibitionStrength : Float;      // Go/NoGo threshold
    var stopSignalLatency : Float;       // SSRT
    var proactiveControl : Float;        // Anticipatory control
    var reactiveControl : Float;         // Stimulus-driven
    var interferenceLevel : Float;       // Competing responses
    var stroop : Float;                  // Conflict level
    var isInhibiting : Bool;
  };

  public type CognitiveFlexibility = {
    var currentRule : [var Float];       // Active rule
    var ruleSet : [[var Float]];         // Available rules
    var numRules : Nat;
    var switchCost : Float;              // Cost of switching
    var perseverationTendency : Float;   // Sticking to old rule
    var setShiftingAbility : Float;      // Flexibility measure
    var lastSwitchTime : Float;
    var ruleConfidence : Float;
  };

  public type PlanningState = {
    var goalStack : [[var Float]];       // Hierarchical goals
    var stackDepth : Nat;
    var currentSubgoal : [var Float];
    var planSteps : [[var Float]];       // Planned action sequence
    var numSteps : Nat;
    var currentStep : Nat;
    var lookAhead : Nat;                 // Planning horizon
    var planQuality : Float;
    var replanning : Bool;
  };

  public type ExecutiveFunctionState = {
    wm : WorkingMemoryExecutive;
    inhibition : InhibitoryControl;
    flexibility : CognitiveFlexibility;
    planning : PlanningState;
    var overallExecutiveControl : Float;
    var cognitiveLoad : Float;
    var mentalFatigue : Float;
    var metacognitiveMonitoring : Float;
  };

  // Executive parameters
  public let EXEC_WM_SLOTS : Nat = 7;
  public let EXEC_WM_DIM : Nat = 16;
  public let EXEC_NUM_RULES : Nat = 5;
  public let EXEC_PLAN_DEPTH : Nat = 10;

  public func initWorkingMemoryExecutive() : WorkingMemoryExecutive {
    {
      var slots = Array.init<[var Float]>(EXEC_WM_SLOTS, func(_ : Nat) : [var Float] {
        Array.init<Float>(EXEC_WM_DIM, func(_ : Nat) : Float { 0.0 })
      });
      var slotDim = EXEC_WM_DIM;
      var numSlots = EXEC_WM_SLOTS;
      var activeSlots = Array.init<Bool>(EXEC_WM_SLOTS, func(_ : Nat) : Bool { false });
      var updateGate = Array.init<Float>(EXEC_WM_SLOTS, func(_ : Nat) : Float { 0.5 });
      var outputGate = Array.init<Float>(EXEC_WM_SLOTS, func(_ : Nat) : Float { 0.5 });
      var forgetGate = Array.init<Float>(EXEC_WM_SLOTS, func(_ : Nat) : Float { 0.1 });
      var centralExecutive = 0.8;
      var maintenanceLoad = 0.0;
    }
  };

  public func initInhibitoryControl() : InhibitoryControl {
    {
      var prepotentResponse = Array.init<Float>(8, func(_ : Nat) : Float { 0.0 });
      var inhibitionStrength = 0.5;
      var stopSignalLatency = 200.0;
      var proactiveControl = 0.5;
      var reactiveControl = 0.5;
      var interferenceLevel = 0.0;
      var stroop = 0.0;
      var isInhibiting = false;
    }
  };

  public func initCognitiveFlexibility() : CognitiveFlexibility {
    {
      var currentRule = Array.init<Float>(8, func(_ : Nat) : Float { 0.0 });
      var ruleSet = Array.init<[var Float]>(EXEC_NUM_RULES, func(r : Nat) : [var Float] {
        Array.init<Float>(8, func(i : Nat) : Float {
          if ((r + i) % 3 == 0) { 1.0 } else { 0.0 }
        })
      });
      var numRules = EXEC_NUM_RULES;
      var switchCost = 0.2;
      var perseverationTendency = 0.3;
      var setShiftingAbility = 0.7;
      var lastSwitchTime = 0.0;
      var ruleConfidence = 0.5;
    }
  };

  public func initPlanningState() : PlanningState {
    {
      var goalStack = Array.init<[var Float]>(5, func(_ : Nat) : [var Float] {
        Array.init<Float>(8, func(_ : Nat) : Float { 0.0 })
      });
      var stackDepth = 0;
      var currentSubgoal = Array.init<Float>(8, func(_ : Nat) : Float { 0.0 });
      var planSteps = Array.init<[var Float]>(EXEC_PLAN_DEPTH, func(_ : Nat) : [var Float] {
        Array.init<Float>(8, func(_ : Nat) : Float { 0.0 })
      });
      var numSteps = 0;
      var currentStep = 0;
      var lookAhead = 3;
      var planQuality = 0.0;
      var replanning = false;
    }
  };

  public func initExecutiveFunctionState() : ExecutiveFunctionState {
    {
      wm = initWorkingMemoryExecutive();
      inhibition = initInhibitoryControl();
      flexibility = initCognitiveFlexibility();
      planning = initPlanningState();
      var overallExecutiveControl = 0.5;
      var cognitiveLoad = 0.0;
      var mentalFatigue = 0.0;
      var metacognitiveMonitoring = 0.5;
    }
  };

  // Update working memory with gating
  public func updateExecutiveWM(
    wm : WorkingMemoryExecutive,
    input : [Float],
    inputGate : Float,
    outputRequest : Nat,
    dt : Float
  ) {
    // Compute maintenance load
    var activeCount : Nat = 0;
    for (i in Iter.range(0, wm.numSlots - 1)) {
      if (wm.activeSlots[i]) { activeCount += 1 };
    };
    wm.maintenanceLoad := Float.fromInt(activeCount) / Float.fromInt(wm.numSlots);
    
    // Find least active slot for input
    var targetSlot : Nat = 0;
    var minActivity : Float = 1000.0;
    for (i in Iter.range(0, wm.numSlots - 1)) {
      if (wm.updateGate[i] > inputGate and not wm.activeSlots[i]) {
        targetSlot := i;
        minActivity := 0.0;
      } else if (wm.outputGate[i] < minActivity) {
        minActivity := wm.outputGate[i];
        targetSlot := i;
      };
    };
    
    // Gate input
    if (inputGate > 0.5) {
      let inputDim = Nat.min(Array.size(input), wm.slotDim);
      for (j in Iter.range(0, inputDim - 1)) {
        wm.slots[targetSlot][j] := input[j];
      };
      wm.activeSlots[targetSlot] := true;
      wm.updateGate[targetSlot] := 1.0;
    };
    
    // Decay inactive slots
    for (i in Iter.range(0, wm.numSlots - 1)) {
      if (wm.activeSlots[i]) {
        for (j in Iter.range(0, wm.slotDim - 1)) {
          wm.slots[i][j] *= 1.0 - wm.forgetGate[i] * dt / 1000.0;
        };
        
        // Check if slot has decayed enough to be inactive
        var slotMagnitude : Float = 0.0;
        for (j in Iter.range(0, wm.slotDim - 1)) {
          slotMagnitude += Float.abs(wm.slots[i][j]);
        };
        if (slotMagnitude < 0.1) {
          wm.activeSlots[i] := false;
        };
      };
      
      // Decay gates
      wm.updateGate[i] *= 0.99;
    };
  };

  // Inhibitory control update
  public func updateInhibitoryControl(
    inh : InhibitoryControl,
    stimulus : [Float],
    stopSignal : Bool,
    conflictLevel : Float,
    dt : Float
  ) {
    // Prepotent response builds up
    let stimDim = Nat.min(Array.size(stimulus), 8);
    for (i in Iter.range(0, stimDim - 1)) {
      inh.prepotentResponse[i] := 0.9 * inh.prepotentResponse[i] + 0.1 * stimulus[i];
    };
    
    // Conflict detection
    inh.stroop := conflictLevel;
    inh.interferenceLevel := 0.8 * inh.interferenceLevel + 0.2 * conflictLevel;
    
    // Proactive control (anticipatory)
    inh.proactiveControl := 0.95 * inh.proactiveControl + 0.05 * inh.interferenceLevel;
    
    // Reactive control (stop signal)
    if (stopSignal) {
      inh.reactiveControl := 1.0;
      inh.isInhibiting := true;
    } else {
      inh.reactiveControl *= 0.9;
      if (inh.reactiveControl < 0.2) {
        inh.isInhibiting := false;
      };
    };
    
    // Combined inhibition
    inh.inhibitionStrength := Float.max(inh.proactiveControl, inh.reactiveControl);
    
    // Clear prepotent response if inhibiting
    if (inh.isInhibiting) {
      for (i in Iter.range(0, 7)) {
        inh.prepotentResponse[i] *= 0.5;
      };
    };
  };

  // Cognitive flexibility update
  public func updateCognitiveFlexibility(
    flex : CognitiveFlexibility,
    feedback : Float,                     // 0 = error, 1 = correct
    switchCue : Bool,
    currentTime : Float,
    dt : Float
  ) {
    // Update rule confidence based on feedback
    flex.ruleConfidence := 0.9 * flex.ruleConfidence + 0.1 * feedback;
    
    // Check for rule switch
    if (switchCue or flex.ruleConfidence < 0.3) {
      // Need to switch rules
      let timeSinceSwitch = currentTime - flex.lastSwitchTime;
      
      // Switch cost
      if (timeSinceSwitch < flex.switchCost * 1000.0) {
        // Still paying switch cost
        flex.setShiftingAbility := 0.5;
      } else {
        // Find new rule
        var bestRule : Nat = 0;
        var bestScore : Float = -1.0;
        
        for (r in Iter.range(0, flex.numRules - 1)) {
          var similarity : Float = 0.0;
          for (i in Iter.range(0, 7)) {
            similarity += flex.currentRule[i] * flex.ruleSet[r][i];
          };
          // Prefer different rules (avoid perseveration)
          let noveltyBonus = 1.0 - similarity;
          let score = noveltyBonus * (1.0 - flex.perseverationTendency);
          
          if (score > bestScore) {
            bestScore := score;
            bestRule := r;
          };
        };
        
        // Switch to new rule
        for (i in Iter.range(0, 7)) {
          flex.currentRule[i] := flex.ruleSet[bestRule][i];
        };
        flex.lastSwitchTime := currentTime;
        flex.ruleConfidence := 0.5;
        flex.setShiftingAbility := 0.8;
      };
    };
    
    // Perseveration decays
    flex.perseverationTendency *= 0.999;
  };

  // Planning update
  public func updatePlanning(
    plan : PlanningState,
    currentState : [Float],
    goalState : [Float],
    actionOutcome : Float,                // How well last action worked
    dt : Float
  ) {
    // Check if current subgoal achieved
    var goalDistance : Float = 0.0;
    let dim = Nat.min(Array.size(currentState), 8);
    for (i in Iter.range(0, dim - 1)) {
      goalDistance += Float.abs(currentState[i] - plan.currentSubgoal[i]);
    };
    
    if (goalDistance < 0.2) {
      // Subgoal achieved - move to next
      plan.currentStep += 1;
      
      if (plan.currentStep >= plan.numSteps) {
        // Plan complete - pop goal stack
        if (plan.stackDepth > 0) {
          plan.stackDepth -= 1;
          for (i in Iter.range(0, 7)) {
            plan.currentSubgoal[i] := plan.goalStack[plan.stackDepth][i];
          };
        };
        plan.currentStep := 0;
      } else {
        // Set next subgoal from plan
        for (i in Iter.range(0, 7)) {
          plan.currentSubgoal[i] := plan.planSteps[plan.currentStep][i];
        };
      };
    };
    
    // Check if replanning needed
    if (actionOutcome < 0.3 or goalDistance > 1.0) {
      plan.replanning := true;
    };
    
    // Simple replanning: direct path to goal
    if (plan.replanning) {
      let goalDim = Nat.min(Array.size(goalState), 8);
      let steps = plan.lookAhead;
      
      for (s in Iter.range(0, steps - 1)) {
        let progress = Float.fromInt(s + 1) / Float.fromInt(steps);
        for (i in Iter.range(0, goalDim - 1)) {
          let current = if (i < dim) { currentState[i] } else { 0.0 };
          plan.planSteps[s][i] := current + progress * (goalState[i] - current);
        };
      };
      plan.numSteps := steps;
      plan.currentStep := 0;
      plan.replanning := false;
    };
    
    // Plan quality
    plan.planQuality := actionOutcome * (1.0 - goalDistance / 2.0);
  };

  // Full executive function update
  public func updateExecutiveFunctions(
    exec : ExecutiveFunctionState,
    input : [Float],
    stimulus : [Float],
    feedback : Float,
    stopSignal : Bool,
    conflictLevel : Float,
    currentState : [Float],
    goalState : [Float],
    actionOutcome : Float,
    currentTime : Float,
    dt : Float
  ) {
    // Update all components
    updateExecutiveWM(exec.wm, input, 0.6, 0, dt);
    updateInhibitoryControl(exec.inhibition, stimulus, stopSignal, conflictLevel, dt);
    updateCognitiveFlexibility(exec.flexibility, feedback, feedback < 0.3, currentTime, dt);
    updatePlanning(exec.planning, currentState, goalState, actionOutcome, dt);
    
    // Cognitive load
    exec.cognitiveLoad := (exec.wm.maintenanceLoad + 
                           exec.inhibition.interferenceLevel + 
                           (1.0 - exec.flexibility.setShiftingAbility) +
                           Float.fromInt(exec.planning.stackDepth) / 5.0) / 4.0;
    
    // Mental fatigue accumulates with load
    exec.mentalFatigue += exec.cognitiveLoad * 0.001 * dt / 1000.0;
    exec.mentalFatigue := Float.max(0.0, exec.mentalFatigue - 0.0001 * dt / 1000.0);
    
    // Overall executive control (inverse of fatigue, modulated by load)
    exec.overallExecutiveControl := (1.0 - exec.mentalFatigue) * exec.wm.centralExecutive;
    
    // Metacognitive monitoring
    exec.metacognitiveMonitoring := (exec.flexibility.ruleConfidence + exec.planning.planQuality) / 2.0;
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // DEVELOPMENTAL PROCESSES — GROWTH AND MATURATION
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // The organism changes over developmental time:
  //
  // 1. SYNAPTOGENESIS:
  //    - Initial overproduction
  //    - Activity-dependent pruning
  //
  // 2. MYELINATION:
  //    - Gradual process
  //    - Front-to-back gradient
  //
  // 3. EXECUTIVE DEVELOPMENT:
  //    - PFC matures last
  //    - Gradual control improvement
  //

  public type SynaptogenesisState = {
    var synapseCount : Float;            // Normalized synapse density
    var overproductionPeak : Float;      // Age of peak
    var pruningRate : Float;             // How fast pruning
    var activityDependentSurvival : Float; // Activity benefit
    var currentAge : Float;              // Developmental age
    var developmentalStage : Text;       // Infant, child, adolescent, adult
  };

  public type MyelinationDevelopment = {
    var frontToBackGradient : Float;     // Spatial gradient
    var overallMyelination : Float;      // Total myelination
    var regionMyelination : [var Float]; // Per-region
    var numRegions : Nat;
    var myelinationRate : Float;
    var maturationAge : Float;           // Age of full myelination
  };

  public type ExecutiveDevelopment = {
    var pfcMaturation : Float;           // PFC maturity [0,1]
    var inhibitoryControlDev : Float;
    var workingMemoryDev : Float;
    var cognitiveFlexibilityDev : Float;
    var planningAbilityDev : Float;
    var riskTaking : Float;              // High in adolescence
    var rewardSensitivity : Float;
  };

  public type DevelopmentalState = {
    synaptogenesis : SynaptogenesisState;
    myelination : MyelinationDevelopment;
    executive : ExecutiveDevelopment;
    var overallMaturation : Float;
    var developmentalAge : Float;        // Years equivalent
    var criticalPeriodStatus : Float;    // 0=closed, 1=open
    var experienceAccumulation : Float;
  };

  // Developmental parameters
  public let DEV_SYNAPSE_PEAK_AGE : Float = 2.0;     // Years
  public let DEV_MYELIN_MATURE_AGE : Float = 25.0;   // Years
  public let DEV_PFC_MATURE_AGE : Float = 25.0;      // Years
  public let DEV_NUM_REGIONS : Nat = 6;

  public func initSynaptogenesisState() : SynaptogenesisState {
    {
      var synapseCount = 0.5;
      var overproductionPeak = DEV_SYNAPSE_PEAK_AGE;
      var pruningRate = 0.01;
      var activityDependentSurvival = 0.5;
      var currentAge = 0.0;
      var developmentalStage = "infant";
    }
  };

  public func initMyelinationDevelopment() : MyelinationDevelopment {
    {
      var frontToBackGradient = 0.0;
      var overallMyelination = 0.1;
      var regionMyelination = Array.init<Float>(DEV_NUM_REGIONS, func(i : Nat) : Float {
        // Posterior regions myelinate first
        (Float.fromInt(DEV_NUM_REGIONS - i)) / Float.fromInt(DEV_NUM_REGIONS) * 0.1
      });
      var numRegions = DEV_NUM_REGIONS;
      var myelinationRate = 0.01;
      var maturationAge = DEV_MYELIN_MATURE_AGE;
    }
  };

  public func initExecutiveDevelopment() : ExecutiveDevelopment {
    {
      var pfcMaturation = 0.1;
      var inhibitoryControlDev = 0.1;
      var workingMemoryDev = 0.1;
      var cognitiveFlexibilityDev = 0.1;
      var planningAbilityDev = 0.1;
      var riskTaking = 0.3;
      var rewardSensitivity = 0.8;
    }
  };

  public func initDevelopmentalState() : DevelopmentalState {
    {
      synaptogenesis = initSynaptogenesisState();
      myelination = initMyelinationDevelopment();
      executive = initExecutiveDevelopment();
      var overallMaturation = 0.1;
      var developmentalAge = 0.0;
      var criticalPeriodStatus = 1.0;
      var experienceAccumulation = 0.0;
    }
  };

  // Update synaptogenesis
  public func updateSynaptogenesis(
    syn : SynaptogenesisState,
    activityLevel : Float,
    age : Float
  ) {
    syn.currentAge := age;
    
    // Determine stage
    if (age < 2.0) {
      syn.developmentalStage := "infant";
      // Synapse overproduction
      syn.synapseCount := Float.min(1.5, syn.synapseCount + 0.1 * (2.0 - age) / 2.0);
    } else if (age < 12.0) {
      syn.developmentalStage := "child";
      // Plateau
      syn.synapseCount := 1.0 + 0.1 * (12.0 - age) / 10.0;
    } else if (age < 25.0) {
      syn.developmentalStage := "adolescent";
      // Pruning
      let pruningProgress = (age - 12.0) / 13.0;
      syn.synapseCount := 1.0 - 0.3 * pruningProgress;
      syn.pruningRate := 0.03;
    } else {
      syn.developmentalStage := "adult";
      syn.synapseCount := 0.7;
      syn.pruningRate := 0.001;
    };
    
    // Activity-dependent survival
    syn.activityDependentSurvival := activityLevel;
    syn.synapseCount := syn.synapseCount * (0.9 + 0.1 * activityLevel);
  };

  // Update myelination
  public func updateMyelination(
    myelin : MyelinationDevelopment,
    activityLevels : [Float],
    age : Float
  ) {
    // Front-to-back gradient (posterior first)
    myelin.frontToBackGradient := Float.min(1.0, age / myelin.maturationAge);
    
    // Update each region
    for (r in Iter.range(0, myelin.numRegions - 1)) {
      // Posterior regions (high index) develop first
      let regionDelay = Float.fromInt(r) * 2.0;  // Years delay for anterior
      let effectiveAge = Float.max(0.0, age - regionDelay);
      
      // Myelination curve (sigmoidal)
      let myelinProgress = effectiveAge / (myelin.maturationAge - regionDelay);
      let myelinLevel = 1.0 / (1.0 + exp(-5.0 * (myelinProgress - 0.5)));
      
      // Activity enhances myelination
      let activityBonus = if (r < Array.size(activityLevels)) { activityLevels[r] * 0.1 } else { 0.0 };
      
      myelin.regionMyelination[r] := myelinLevel + activityBonus;
      myelin.regionMyelination[r] := clamp(myelin.regionMyelination[r], 0.0, 1.0);
    };
    
    // Overall myelination
    var total : Float = 0.0;
    for (r in Iter.range(0, myelin.numRegions - 1)) {
      total += myelin.regionMyelination[r];
    };
    myelin.overallMyelination := total / Float.fromInt(myelin.numRegions);
  };

  // Update executive development
  public func updateExecutiveDevelopment(
    exec : ExecutiveDevelopment,
    age : Float,
    trainingExperience : Float
  ) {
    // PFC maturation (very slow)
    let pfcProgress = age / DEV_PFC_MATURE_AGE;
    exec.pfcMaturation := 1.0 / (1.0 + exp(-5.0 * (pfcProgress - 0.5)));
    exec.pfcMaturation := exec.pfcMaturation * (0.9 + 0.1 * trainingExperience);
    
    // Component functions develop at different rates
    exec.inhibitoryControlDev := exec.pfcMaturation * 0.8;
    exec.workingMemoryDev := exec.pfcMaturation * 0.9;
    exec.cognitiveFlexibilityDev := exec.pfcMaturation * 0.7;
    exec.planningAbilityDev := exec.pfcMaturation * 0.6;
    
    // Risk taking peaks in adolescence
    if (age > 12.0 and age < 25.0) {
      let adolescentProgress = (age - 12.0) / 13.0;
      exec.riskTaking := 0.3 + 0.5 * sin(adolescentProgress * PI);
    } else {
      exec.riskTaking := 0.3;
    };
    
    // Reward sensitivity decreases with maturation
    exec.rewardSensitivity := 1.0 - 0.3 * exec.pfcMaturation;
  };

  // Full developmental update
  public func updateDevelopment(
    dev : DevelopmentalState,
    activityLevel : Float,
    activityLevels : [Float],
    trainingExperience : Float,
    ageIncrement : Float              // Years
  ) {
    dev.developmentalAge += ageIncrement;
    
    updateSynaptogenesis(dev.synaptogenesis, activityLevel, dev.developmentalAge);
    updateMyelination(dev.myelination, activityLevels, dev.developmentalAge);
    updateExecutiveDevelopment(dev.executive, dev.developmentalAge, trainingExperience);
    
    // Critical period status
    if (dev.developmentalAge < 5.0) {
      dev.criticalPeriodStatus := 1.0;
    } else if (dev.developmentalAge < 12.0) {
      dev.criticalPeriodStatus := 1.0 - (dev.developmentalAge - 5.0) / 7.0;
    } else {
      dev.criticalPeriodStatus := 0.0;
    };
    
    // Experience accumulation
    dev.experienceAccumulation += activityLevel * ageIncrement;
    
    // Overall maturation
    dev.overallMaturation := (dev.synaptogenesis.synapseCount / 1.5 +
                               dev.myelination.overallMyelination +
                               dev.executive.pfcMaturation) / 3.0;
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // AGING AND SENESCENCE
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Changes with advancing age:
  //
  // 1. COGNITIVE DECLINE:
  //    - Processing speed
  //    - Working memory
  //    - But wisdom/knowledge preserved
  //
  // 2. NEURAL CHANGES:
  //    - Synapse loss
  //    - White matter decline
  //    - Reduced plasticity
  //

  public type AgingState = {
    var chronologicalAge : Float;        // Years
    var biologicalAge : Float;           // Effective age
    var processingSpeed : Float;         // Cognitive speed
    var fluidIntelligence : Float;       // Reasoning, novel problems
    var crystallizedIntelligence : Float;// Knowledge, wisdom
    var synapticDensity : Float;         // Remaining synapses
    var whiteMatteintegrity : Float;     // Myelin health
    var neurotrophicSupport : Float;     // BDNF etc
    var neuroplasticity : Float;         // Remaining plasticity
    var cognitiveReserve : Float;        // Protective factor
    var healthyAging : Bool;
  };

  public func initAgingState() : AgingState {
    {
      var chronologicalAge = 25.0;
      var biologicalAge = 25.0;
      var processingSpeed = 1.0;
      var fluidIntelligence = 1.0;
      var crystallizedIntelligence = 0.5;
      var synapticDensity = 0.7;
      var whiteMatteintegrity = 1.0;
      var neurotrophicSupport = 1.0;
      var neuroplasticity = 0.8;
      var cognitiveReserve = 0.5;
      var healthyAging = true;
    }
  };

  // Update aging
  public func updateAging(
    aging : AgingState,
    ageIncrement : Float,
    activityLevel : Float,
    cognitiveEngagement : Float,
    physicalExercise : Float,
    socialEngagement : Float
  ) {
    aging.chronologicalAge += ageIncrement;
    
    // Lifestyle factors affect biological age
    let lifestyleProtection = (activityLevel + cognitiveEngagement + physicalExercise + socialEngagement) / 4.0;
    let biologicalAgingRate = 1.0 - 0.3 * lifestyleProtection;
    aging.biologicalAge += ageIncrement * biologicalAgingRate;
    
    // Processing speed declines
    if (aging.biologicalAge > 30.0) {
      let declineYears = aging.biologicalAge - 30.0;
      aging.processingSpeed := 1.0 - 0.01 * declineYears;
      aging.processingSpeed := Float.max(0.4, aging.processingSpeed);
    };
    
    // Fluid intelligence declines
    if (aging.biologicalAge > 40.0) {
      let declineYears = aging.biologicalAge - 40.0;
      aging.fluidIntelligence := 1.0 - 0.015 * declineYears;
      aging.fluidIntelligence := Float.max(0.5, aging.fluidIntelligence);
    };
    
    // Crystallized intelligence can keep growing
    aging.crystallizedIntelligence := Float.min(1.5, aging.crystallizedIntelligence + 0.01 * cognitiveEngagement * ageIncrement);
    
    // Neural changes
    if (aging.biologicalAge > 50.0) {
      let declineYears = aging.biologicalAge - 50.0;
      aging.synapticDensity := 0.7 - 0.005 * declineYears;
      aging.whiteMatteintegrity := 1.0 - 0.01 * declineYears;
      aging.synapticDensity := Float.max(0.4, aging.synapticDensity);
      aging.whiteMatteintegrity := Float.max(0.5, aging.whiteMatteintegrity);
    };
    
    // Neurotrophic support affected by exercise
    aging.neurotrophicSupport := 0.5 + 0.5 * physicalExercise;
    
    // Neuroplasticity
    aging.neuroplasticity := aging.synapticDensity * aging.neurotrophicSupport * (0.5 + 0.5 * cognitiveEngagement);
    
    // Cognitive reserve
    aging.cognitiveReserve := (aging.crystallizedIntelligence + cognitiveEngagement + socialEngagement) / 3.0;
    
    // Healthy aging
    aging.healthyAging := aging.biologicalAge < aging.chronologicalAge * 1.1 and 
                           aging.fluidIntelligence > 0.6;
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // COMPLETE DEEP HEBBIAN ENGINE — FINAL STRUCTURE
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

  // This module now contains 30+ deep layers of neural biophysics:
  // - Calcium dynamics, NMDA kinetics, AMPA trafficking, CaMKII, protein synthesis
  // - Dendritic computation, neuromodulation, homeostasis, metaplasticity
  // - Structural plasticity, vesicle dynamics, gliotransmission, retrograde signaling
  // - STDP, three-factor learning, consolidation, oscillations, attention
  // - Metabolism, circadian, stress, sleep, critical periods, heterosynaptic
  // - Intrinsic plasticity, axonal plasticity, epigenetics, LFP, criticality
  // - Sacred geometry integration
  //
  // Plus complete cognitive systems:
  // - Hodgkin-Huxley, LIF, cable theory, Kuramoto, Wilson-Cowan, neural fields
  // - Spike timing networks, predictive coding, free energy, RL, memory systems
  // - Consciousness, emotion, social cognition, motor control, decision making
  // - Language, spatial cognition, drives, self/identity, executive functions
  // - Development and aging
  //
  // Total: 15,000+ lines of complete neurobiological simulation


};
