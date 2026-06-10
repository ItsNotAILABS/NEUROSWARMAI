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
// NEUROCHEMICAL CROSSTALK MATRIX — THE 441 INTERACTIONS
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// The brain is not 21 independent chemicals — it is 21 chemicals TALKING TO EACH OTHER.
// This is the 21×21 = 441 interaction matrix expressed as REAL coupled differential equations.
//
// THE 21 NEUROCHEMICALS:
// ══════════════════════
//
//  0. DOPAMINE (DA)      — Reward, motivation, movement, pleasure
//  1. SEROTONIN (5-HT)   — Mood, patience, satiety, sleep
//  2. NOREPINEPHRINE (NE) — Arousal, alertness, fight-or-flight
//  3. ACETYLCHOLINE (ACh) — Attention, memory encoding, muscle control
//  4. GLUTAMATE (Glu)    — Excitation, learning, memory (E)
//  5. GABA               — Inhibition, calm, sleep (I)
//  6. ENDORPHIN (END)    — Pain relief, euphoria, reward
//  7. OXYTOCIN (OXT)     — Social bonding, trust, love
//  8. CORTISOL (CORT)    — Stress response, metabolism, immune suppression
//  9. ADRENALINE (EPI)   — Acute stress, energy mobilization
// 10. MELATONIN (MEL)    — Sleep, circadian rhythm
// 11. HISTAMINE (HIS)    — Wakefulness, inflammation, stomach acid
// 12. GLYCINE (GLY)      — Inhibition (spinal), NMDA co-agonist
// 13. SUBSTANCE P (SP)   — Pain transmission, inflammation
// 14. ANANDAMIDE (AEA)   — Endocannabinoid, bliss, pain modulation
// 15. ADENOSINE (ADO)    — Sleep pressure, fatigue, neuroprotection
// 16. BDNF              — Brain-derived neurotrophic factor, plasticity
// 17. NGF               — Nerve growth factor, survival
// 18. DYNORPHIN (DYN)    — Dysphoria, stress, kappa opioid
// 19. VASOPRESSIN (AVP)  — Social behavior, water balance, aggression
// 20. NEUROPEPTIDE Y (NPY) — Appetite, stress resilience, anxiolytic
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// THE CRITICAL INTERACTIONS (scientifically validated):
// ═════════════════════════════════════════════════════
//
// 1. DOPAMINE × GLUTAMATE (D1/NMDA Gate)
//    D1 receptor activation enhances NMDA receptor function
//    This is the molecular basis of reward-driven learning
//    Δ_glu += D1_occupancy × (glu - baseline) × 0.08
//
// 2. CORTISOL × BDNF (Stress Degrades Plasticity)
//    Chronic cortisol suppresses BDNF expression
//    This is why chronic stress impairs learning
//    Δ_bdnf -= cort × sustained_stress_factor × 0.12
//
// 3. GABA / GLUTAMATE E/I Ratio (Stability Homeostasis)
//    When E/I > 1.2, emergency GABA surge
//    When E/I < 0.6, GABA reduces
//    This prevents seizures and maintains stability
//
// 4. ADENOSINE × DOPAMINE (A2A/D2 Antagonism)
//    Adenosine A2A receptors oppose dopamine D2 receptors
//    Caffeine blocks A2A → enhances dopamine signaling
//    dopa_effective = dopa × (1.0 - adenosine × 0.60)
//
// 5. OXYTOCIN × CORTISOL (Social Bonding Suppresses Stress)
//    Oxytocin release inhibits cortisol release
//    This is why social support reduces stress
//    Δ_cort -= oxt × 0.08
//
// 6. ANANDAMIDE Gating (Endocannabinoid Modulation)
//    When AEA > 0.60 and coherence > 0.70, all positive processes ×1.5
//    The "runner's high" / flow state / bliss gate
//
// 7. SEROTONIN × DOPAMINE (Patience vs Impulse)
//    Serotonin gates WHEN dopamine fires
//    Low 5-HT = impulsive, high 5-HT = patient
//    This is the temporal discounting modulator
//
// 8. NOREPINEPHRINE × CORTISOL (Acute vs Chronic Stress)
//    NE = fast stress response (seconds)
//    CORT = slow stress response (minutes to hours)
//    They co-activate but have different time courses
//
// 9. ACETYLCHOLINE × DOPAMINE (Attention × Reward)
//    ACh marks what to attend to
//    DA marks what is rewarding
//    Together they determine what gets learned
//
// 10. MELATONIN × CORTISOL (Circadian Opposition)
//     Melatonin and cortisol are 180° out of phase
//     Melatonin rises at night, cortisol in morning
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// PHARMACOKINETICS FOR EACH CHEMICAL:
// ═══════════════════════════════════
//
// Each chemical has:
//   - Synthesis rate (production)
//   - Release rate (into synapse)
//   - Reuptake rate (removal from synapse)
//   - Degradation rate (enzymatic breakdown)
//   - Half-life (time to 50% decay)
//   - Receptor binding affinity (Kd)
//   - Receptor saturation curve (Michaelis-Menten)
//
// d[C]/dt = synthesis - release + reuptake - degradation + Σ(crosstalk_ij)
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

module NeurochemicalCrosstalkMatrix {

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  public let PI : Float = 3.14159265358979323846264338327950288;
  public let E : Float = 2.71828182845904523536028747135266250;
  public let PHI : Float = 1.618033988749894848204586834365638;
  
  public let NUM_CHEMICALS : Nat = 21;
  public let MATRIX_SIZE : Nat = 441;  // 21 × 21
  
  // Chemical indices
  public let DA : Nat = 0;    // Dopamine
  public let SER : Nat = 1;   // Serotonin (5-HT)
  public let NE : Nat = 2;    // Norepinephrine
  public let ACH : Nat = 3;   // Acetylcholine
  public let GLU : Nat = 4;   // Glutamate
  public let GABA_IDX : Nat = 5;   // GABA
  public let END : Nat = 6;   // Endorphin
  public let OXT : Nat = 7;   // Oxytocin
  public let CORT : Nat = 8;  // Cortisol
  public let EPI : Nat = 9;   // Adrenaline/Epinephrine
  public let MEL : Nat = 10;  // Melatonin
  public let HIS : Nat = 11;  // Histamine
  public let GLY : Nat = 12;  // Glycine
  public let SP : Nat = 13;   // Substance P
  public let AEA : Nat = 14;  // Anandamide
  public let ADO : Nat = 15;  // Adenosine
  public let BDNF_IDX : Nat = 16;  // BDNF
  public let NGF_IDX : Nat = 17;   // NGF
  public let DYN : Nat = 18;  // Dynorphin
  public let AVP : Nat = 19;  // Vasopressin
  public let NPY : Nat = 20;  // Neuropeptide Y

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 1: NEUROCHEMICAL SPECIES — FULL PHARMACOKINETICS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  public type NeurochemicalSpecies = {
    id : Nat;
    name : Text;
    abbreviation : Text;
    
    // Concentration state
    var concentration : Float;           // Current level [0, 1] normalized
    var synapticConcentration : Float;   // In synapse (where it acts)
    var intracellularConcentration : Float; // Inside cell (storage)
    
    // Kinetic parameters
    var synthesisRate : Float;           // Production rate
    var releaseRate : Float;             // Release into synapse
    var reuptakeRate : Float;            // Removal from synapse
    var degradationRate : Float;         // Enzymatic breakdown
    var halfLife : Float;                // Time to 50% decay (ms)
    
    // Receptor dynamics
    var receptorOccupancy : Float;       // Fraction of receptors bound
    var receptorDensity : Float;         // Number of receptors (normalized)
    var bindingAffinity : Float;         // Kd — dissociation constant
    var receptorDesensitization : Float; // Receptor downregulation
    
    // Homeostasis
    var setpoint : Float;                // Target concentration
    var homeostaticPressure : Float;     // Pressure to return to setpoint
    
    // Dynamics
    var velocity : Float;                // d[C]/dt
    var acceleration : Float;            // d²[C]/dt²
    
    // History
    var peakConcentration : Float;
    var troughConcentration : Float;
    var timeAtPeak : Nat;
    var cumulativeExposure : Float;
  };
  
  // Chemical configurations (name, abbrev, setpoint, halfLife_ms, Kd)
  public let CHEMICAL_CONFIGS : [(Text, Text, Float, Float, Float)] = [
    ("Dopamine", "DA", 0.50, 200.0, 0.01),
    ("Serotonin", "5-HT", 0.55, 400.0, 0.005),
    ("Norepinephrine", "NE", 0.35, 150.0, 0.02),
    ("Acetylcholine", "ACh", 0.45, 50.0, 0.001),
    ("Glutamate", "Glu", 0.50, 10.0, 0.1),
    ("GABA", "GABA", 0.50, 20.0, 0.05),
    ("Endorphin", "END", 0.30, 3000.0, 0.001),
    ("Oxytocin", "OXT", 0.40, 1800.0, 0.002),
    ("Cortisol", "CORT", 0.25, 60000.0, 0.01),
    ("Adrenaline", "EPI", 0.20, 120.0, 0.02),
    ("Melatonin", "MEL", 0.30, 2400.0, 0.005),
    ("Histamine", "HIS", 0.25, 60.0, 0.01),
    ("Glycine", "GLY", 0.40, 15.0, 0.1),
    ("Substance P", "SP", 0.20, 600.0, 0.01),
    ("Anandamide", "AEA", 0.25, 300.0, 0.005),
    ("Adenosine", "ADO", 0.35, 10.0, 0.1),
    ("BDNF", "BDNF", 0.50, 86400000.0, 0.0001),  // Very long half-life
    ("NGF", "NGF", 0.40, 43200000.0, 0.0001),
    ("Dynorphin", "DYN", 0.15, 1200.0, 0.005),
    ("Vasopressin", "AVP", 0.30, 900.0, 0.002),
    ("Neuropeptide Y", "NPY", 0.35, 1500.0, 0.005)
  ];
  
  // Initialize a single neurochemical species
  public func initNeurochemical(id : Nat) : NeurochemicalSpecies {
    let (name, abbrev, setpoint, halfLife, kd) = if (id < Array.size(CHEMICAL_CONFIGS)) {
      CHEMICAL_CONFIGS[id]
    } else {
      ("Unknown", "UNK", 0.5, 1000.0, 0.01)
    };
    
    {
      id = id;
      name = name;
      abbreviation = abbrev;
      var concentration = setpoint;
      var synapticConcentration = setpoint * 0.1;  // 10% in synapse
      var intracellularConcentration = setpoint * 0.9;  // 90% stored
      var synthesisRate = 0.01;
      var releaseRate = 0.1;
      var reuptakeRate = 0.3;
      var degradationRate = ln(2.0) / halfLife;
      var halfLife = halfLife;
      var receptorOccupancy = 0.5;
      var receptorDensity = 1.0;
      var bindingAffinity = kd;
      var receptorDesensitization = 0.0;
      var setpoint = setpoint;
      var homeostaticPressure = 0.0;
      var velocity = 0.0;
      var acceleration = 0.0;
      var peakConcentration = setpoint;
      var troughConcentration = setpoint;
      var timeAtPeak = 0;
      var cumulativeExposure = 0.0;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 2: RECEPTOR DYNAMICS — BINDING, SATURATION, DESENSITIZATION
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Receptor occupancy follows Michaelis-Menten kinetics:
  //   Occupancy = [C] / ([C] + Kd)
  //
  // Receptor desensitization:
  //   d(desens)/dt = k_desens × occupancy - k_resens × (1 - desens)
  //
  // Effective signaling:
  //   Signal = occupancy × (1 - desensitization) × receptor_density
  //
  
  public type ReceptorState = {
    var occupancy : Float;
    var desensitization : Float;
    var density : Float;
    var effectiveSignal : Float;
    var internalization : Float;        // Receptors pulled inside
    var trafficking : Float;            // Receptors returning to surface
  };
  
  // Initialize receptor state
  public func initReceptorState() : ReceptorState {
    {
      var occupancy = 0.5;
      var desensitization = 0.0;
      var density = 1.0;
      var effectiveSignal = 0.5;
      var internalization = 0.0;
      var trafficking = 0.0;
    }
  };
  
  // Update receptor dynamics
  public func updateReceptorDynamics(
    receptor : ReceptorState,
    concentration : Float,
    bindingAffinity : Float,
    dt : Float
  ) {
    // Michaelis-Menten binding
    receptor.occupancy := concentration / (concentration + bindingAffinity + 0.001);
    
    // Desensitization (high occupancy → more desensitization)
    let k_desens = 0.001;
    let k_resens = 0.0001;
    let dDesens = k_desens * receptor.occupancy - k_resens * (1.0 - receptor.desensitization);
    receptor.desensitization := clamp(receptor.desensitization + dDesens * dt, 0.0, 0.9);
    
    // Internalization (high occupancy → internalization)
    let k_intern = 0.0005;
    let k_traffic = 0.0002;
    let dIntern = k_intern * receptor.occupancy * receptor.density - k_traffic * receptor.internalization;
    receptor.internalization := clamp(receptor.internalization + dIntern * dt, 0.0, 0.5);
    
    // Surface density = total - internalized
    receptor.density := clamp(1.0 - receptor.internalization, 0.3, 1.0);
    
    // Effective signal
    receptor.effectiveSignal := receptor.occupancy * (1.0 - receptor.desensitization) * receptor.density;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 3: THE 441 CROSSTALK INTERACTIONS — THE HEART OF THE SYSTEM
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Each pair (i, j) has a crosstalk coefficient α_ij
  // Positive α = chemical i ENHANCES chemical j
  // Negative α = chemical i INHIBITS chemical j
  // Zero α = no direct interaction
  //
  // The crosstalk matrix is NOT symmetric!
  // DA enhancing GLU is different from GLU enhancing DA
  //
  
  public type CrosstalkInteraction = {
    sourceIdx : Nat;
    targetIdx : Nat;
    coefficient : Float;                 // α_ij — strength of interaction
    interactionType : Text;              // "excitatory" | "inhibitory" | "modulatory"
    mechanism : Text;                    // Biological mechanism
    var currentContribution : Float;     // Contribution this beat
    var cumulativeContribution : Float;  // Total contribution over time
    timeConstant : Float;                // How fast the interaction acts
    threshold : Float;                   // Source must exceed this to have effect
    saturation : Float;                  // Maximum effect
  };
  
  // Build the complete 441-interaction matrix
  public func buildCrosstalkMatrix() : [[var Float]] {
    let matrix = Array.init<[var Float]>(NUM_CHEMICALS, func(_ : Nat) : [var Float] {
      Array.init<Float>(NUM_CHEMICALS, func(_ : Nat) : Float { 0.0 })
    });
    
    // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
    // DOPAMINE (DA) INTERACTIONS
    // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
    
    // DA → GLU: D1 receptor enhances NMDA function (+)
    matrix[DA][GLU] := 0.08;
    
    // DA → GABA: D2 receptor inhibits GABA interneurons (complex, net +)
    matrix[DA][GABA_IDX] := 0.03;
    
    // DA → ACh: DA inhibits ACh in striatum (-)
    matrix[DA][ACH] := -0.05;
    
    // DA → 5-HT: DA modulates 5-HT release (+/-)
    matrix[DA][SER] := 0.02;
    
    // DA → END: DA potentiates endorphin release (+)
    matrix[DA][END] := 0.04;
    
    // DA → BDNF: DA promotes BDNF expression (+)
    matrix[DA][BDNF_IDX] := 0.06;
    
    // DA → NE: DA is precursor to NE (+)
    matrix[DA][NE] := 0.03;
    
    // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
    // SEROTONIN (5-HT) INTERACTIONS
    // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
    
    // 5-HT → DA: 5-HT generally inhibits DA (-)
    matrix[SER][DA] := -0.06;
    
    // 5-HT → NE: 5-HT inhibits NE (-)
    matrix[SER][NE] := -0.04;
    
    // 5-HT → GLU: 5-HT modulates glutamate (mixed)
    matrix[SER][GLU] := -0.02;
    
    // 5-HT → GABA: 5-HT enhances GABA (+)
    matrix[SER][GABA_IDX] := 0.05;
    
    // 5-HT → MEL: 5-HT is precursor to melatonin (+)
    matrix[SER][MEL] := 0.08;
    
    // 5-HT → OXT: 5-HT enhances oxytocin (+)
    matrix[SER][OXT] := 0.04;
    
    // 5-HT → CORT: 5-HT reduces cortisol (-)
    matrix[SER][CORT] := -0.03;
    
    // 5-HT → NPY: 5-HT enhances NPY (+)
    matrix[SER][NPY] := 0.03;
    
    // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
    // NOREPINEPHRINE (NE) INTERACTIONS
    // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
    
    // NE → CORT: NE triggers cortisol release (+)
    matrix[NE][CORT] := 0.10;
    
    // NE → EPI: NE triggers adrenaline (+)
    matrix[NE][EPI] := 0.12;
    
    // NE → DA: NE modulates DA (+)
    matrix[NE][DA] := 0.04;
    
    // NE → GLU: NE enhances glutamate (+)
    matrix[NE][GLU] := 0.05;
    
    // NE → ACh: NE enhances ACh (+)
    matrix[NE][ACH] := 0.04;
    
    // NE → BDNF: Acute NE enhances BDNF (+)
    matrix[NE][BDNF_IDX] := 0.03;
    
    // NE → HIS: NE enhances histamine (+)
    matrix[NE][HIS] := 0.03;
    
    // NE → AVP: NE triggers vasopressin (+)
    matrix[NE][AVP] := 0.05;
    
    // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
    // ACETYLCHOLINE (ACh) INTERACTIONS
    // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
    
    // ACh → GLU: ACh enhances glutamate (attention → learning) (+)
    matrix[ACH][GLU] := 0.07;
    
    // ACh → BDNF: ACh promotes BDNF (+)
    matrix[ACH][BDNF_IDX] := 0.05;
    
    // ACh → DA: ACh modulates DA (+)
    matrix[ACH][DA] := 0.03;
    
    // ACh → NE: ACh enhances NE (+)
    matrix[ACH][NE] := 0.03;
    
    // ACh → OXT: ACh enhances oxytocin (+)
    matrix[ACH][OXT] := 0.02;
    
    // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
    // GLUTAMATE (GLU) INTERACTIONS
    // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
    
    // GLU → GABA: Excitation triggers inhibition (homeostasis) (+)
    matrix[GLU][GABA_IDX] := 0.08;
    
    // GLU → DA: Glutamate excites DA neurons (+)
    matrix[GLU][DA] := 0.06;
    
    // GLU → BDNF: Activity promotes BDNF (+)
    matrix[GLU][BDNF_IDX] := 0.09;
    
    // GLU → NE: Glutamate activates NE neurons (+)
    matrix[GLU][NE] := 0.04;
    
    // GLU → SP: Glutamate releases Substance P (+)
    matrix[GLU][SP] := 0.05;
    
    // GLU → DYN: Excessive glutamate triggers dynorphin (+)
    matrix[GLU][DYN] := 0.03;
    
    // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
    // GABA INTERACTIONS
    // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
    
    // GABA → GLU: GABA inhibits glutamate (-)
    matrix[GABA_IDX][GLU] := -0.10;
    
    // GABA → DA: GABA inhibits DA neurons (-)
    matrix[GABA_IDX][DA] := -0.06;
    
    // GABA → NE: GABA inhibits NE (-)
    matrix[GABA_IDX][NE] := -0.05;
    
    // GABA → CORT: GABA reduces cortisol (-)
    matrix[GABA_IDX][CORT] := -0.04;
    
    // GABA → EPI: GABA reduces adrenaline (-)
    matrix[GABA_IDX][EPI] := -0.05;
    
    // GABA → MEL: GABA promotes melatonin (+)
    matrix[GABA_IDX][MEL] := 0.04;
    
    // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
    // ENDORPHIN (END) INTERACTIONS
    // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
    
    // END → DA: Endorphins enhance DA (pleasure) (+)
    matrix[END][DA] := 0.08;
    
    // END → GABA: Endorphins inhibit GABA interneurons (disinhibition) (-)
    matrix[END][GABA_IDX] := -0.04;
    
    // END → SP: Endorphins block Substance P (pain relief) (-)
    matrix[END][SP] := -0.10;
    
    // END → CORT: Endorphins reduce cortisol (-)
    matrix[END][CORT] := -0.05;
    
    // END → NE: Endorphins modulate NE
    matrix[END][NE] := -0.03;
    
    // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
    // OXYTOCIN (OXT) INTERACTIONS — THE LOVE MOLECULE
    // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
    
    // OXT → CORT: Oxytocin SUPPRESSES cortisol (social buffering) (-)
    matrix[OXT][CORT] := -0.08;
    
    // OXT → DA: Oxytocin enhances DA (social reward) (+)
    matrix[OXT][DA] := 0.05;
    
    // OXT → 5-HT: Oxytocin enhances serotonin (+)
    matrix[OXT][SER] := 0.04;
    
    // OXT → GABA: Oxytocin enhances GABA (calming) (+)
    matrix[OXT][GABA_IDX] := 0.05;
    
    // OXT → END: Oxytocin promotes endorphins (+)
    matrix[OXT][END] := 0.04;
    
    // OXT → AVP: Oxytocin modulates vasopressin (complex)
    matrix[OXT][AVP] := -0.02;
    
    // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
    // CORTISOL (CORT) INTERACTIONS — THE STRESS HORMONE
    // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
    
    // CORT → BDNF: Cortisol DEGRADES BDNF (stress impairs plasticity) (-)
    matrix[CORT][BDNF_IDX] := -0.12;
    
    // CORT → NGF: Cortisol reduces NGF (-)
    matrix[CORT][NGF_IDX] := -0.08;
    
    // CORT → 5-HT: Cortisol depletes serotonin (-)
    matrix[CORT][SER] := -0.06;
    
    // CORT → DA: Chronic cortisol impairs DA (-)
    matrix[CORT][DA] := -0.04;
    
    // CORT → GLU: Cortisol increases glutamate (excitotoxicity risk) (+)
    matrix[CORT][GLU] := 0.05;
    
    // CORT → GABA: Cortisol reduces GABA (-)
    matrix[CORT][GABA_IDX] := -0.04;
    
    // CORT → MEL: Cortisol suppresses melatonin (-)
    matrix[CORT][MEL] := -0.06;
    
    // CORT → NPY: Cortisol triggers NPY (stress eating) (+)
    matrix[CORT][NPY] := 0.05;
    
    // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
    // ADRENALINE (EPI) INTERACTIONS
    // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
    
    // EPI → NE: Adrenaline enhances NE (peripheral → central) (+)
    matrix[EPI][NE] := 0.08;
    
    // EPI → CORT: Adrenaline triggers cortisol (+)
    matrix[EPI][CORT] := 0.06;
    
    // EPI → GLU: Adrenaline enhances glutamate (+)
    matrix[EPI][GLU] := 0.04;
    
    // EPI → DA: Adrenaline modulates DA (+)
    matrix[EPI][DA] := 0.03;
    
    // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
    // MELATONIN (MEL) INTERACTIONS
    // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
    
    // MEL → CORT: Melatonin opposes cortisol (circadian) (-)
    matrix[MEL][CORT] := -0.06;
    
    // MEL → GABA: Melatonin enhances GABA (+)
    matrix[MEL][GABA_IDX] := 0.05;
    
    // MEL → DA: Melatonin modulates DA (-)
    matrix[MEL][DA] := -0.02;
    
    // MEL → HIS: Melatonin reduces histamine (-)
    matrix[MEL][HIS] := -0.04;
    
    // MEL → AEA: Melatonin enhances anandamide (+)
    matrix[MEL][AEA] := 0.03;
    
    // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
    // HISTAMINE (HIS) INTERACTIONS
    // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
    
    // HIS → ACh: Histamine enhances ACh (wakefulness) (+)
    matrix[HIS][ACH] := 0.05;
    
    // HIS → NE: Histamine enhances NE (+)
    matrix[HIS][NE] := 0.04;
    
    // HIS → GLU: Histamine enhances glutamate (+)
    matrix[HIS][GLU] := 0.03;
    
    // HIS → GABA: Histamine modulates GABA (-)
    matrix[HIS][GABA_IDX] := -0.02;
    
    // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
    // GLYCINE (GLY) INTERACTIONS
    // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
    
    // GLY → GLU: Glycine is NMDA co-agonist (+)
    matrix[GLY][GLU] := 0.06;
    
    // GLY → GABA: Glycine enhances inhibition (spinal) (+)
    matrix[GLY][GABA_IDX] := 0.04;
    
    // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
    // SUBSTANCE P (SP) INTERACTIONS
    // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
    
    // SP → GLU: Substance P enhances glutamate (+)
    matrix[SP][GLU] := 0.05;
    
    // SP → DA: Substance P enhances DA (stress-induced) (+)
    matrix[SP][DA] := 0.03;
    
    // SP → NE: Substance P enhances NE (+)
    matrix[SP][NE] := 0.04;
    
    // SP → CORT: Substance P enhances cortisol (+)
    matrix[SP][CORT] := 0.04;
    
    // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
    // ANANDAMIDE (AEA) INTERACTIONS — THE BLISS MOLECULE
    // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
    
    // AEA → DA: Anandamide enhances DA (+)
    matrix[AEA][DA] := 0.06;
    
    // AEA → GABA: Anandamide modulates GABA (complex)
    matrix[AEA][GABA_IDX] := 0.03;
    
    // AEA → GLU: Anandamide reduces excessive glutamate (-)
    matrix[AEA][GLU] := -0.04;
    
    // AEA → CORT: Anandamide reduces cortisol (-)
    matrix[AEA][CORT] := -0.05;
    
    // AEA → SP: Anandamide blocks Substance P (pain relief) (-)
    matrix[AEA][SP] := -0.06;
    
    // AEA → END: Anandamide synergizes with endorphins (+)
    matrix[AEA][END] := 0.05;
    
    // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
    // ADENOSINE (ADO) INTERACTIONS — THE FATIGUE SIGNAL
    // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
    
    // ADO → DA: Adenosine BLOCKS dopamine (A2A antagonizes D2) (-)
    matrix[ADO][DA] := -0.06;
    
    // ADO → GLU: Adenosine reduces glutamate (neuroprotection) (-)
    matrix[ADO][GLU] := -0.05;
    
    // ADO → NE: Adenosine reduces NE (-)
    matrix[ADO][NE] := -0.04;
    
    // ADO → ACh: Adenosine reduces ACh (-)
    matrix[ADO][ACH] := -0.03;
    
    // ADO → MEL: Adenosine promotes melatonin (sleep pressure) (+)
    matrix[ADO][MEL] := 0.05;
    
    // ADO → GABA: Adenosine modulates GABA (+)
    matrix[ADO][GABA_IDX] := 0.03;
    
    // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
    // BDNF INTERACTIONS — THE PLASTICITY FACTOR
    // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
    
    // BDNF → DA: BDNF enhances DA neurons (+)
    matrix[BDNF_IDX][DA] := 0.04;
    
    // BDNF → 5-HT: BDNF enhances serotonin neurons (+)
    matrix[BDNF_IDX][SER] := 0.04;
    
    // BDNF → GLU: BDNF enhances glutamate transmission (+)
    matrix[BDNF_IDX][GLU] := 0.05;
    
    // BDNF → NGF: BDNF promotes NGF (+)
    matrix[BDNF_IDX][NGF_IDX] := 0.03;
    
    // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
    // NGF INTERACTIONS — THE SURVIVAL FACTOR
    // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
    
    // NGF → ACh: NGF supports cholinergic neurons (+)
    matrix[NGF_IDX][ACH] := 0.05;
    
    // NGF → BDNF: NGF promotes BDNF (+)
    matrix[NGF_IDX][BDNF_IDX] := 0.03;
    
    // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
    // DYNORPHIN (DYN) INTERACTIONS — THE DYSPHORIA SIGNAL
    // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
    
    // DYN → DA: Dynorphin INHIBITS dopamine (kappa opioid) (-)
    matrix[DYN][DA] := -0.10;
    
    // DYN → END: Dynorphin opposes endorphin effects (-)
    matrix[DYN][END] := -0.06;
    
    // DYN → CORT: Dynorphin triggers cortisol (+)
    matrix[DYN][CORT] := 0.05;
    
    // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
    // VASOPRESSIN (AVP) INTERACTIONS
    // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
    
    // AVP → CORT: Vasopressin enhances cortisol via CRH (+)
    matrix[AVP][CORT] := 0.06;
    
    // AVP → NE: Vasopressin enhances NE (+)
    matrix[AVP][NE] := 0.04;
    
    // AVP → OXT: Vasopressin modulates oxytocin (complex)
    matrix[AVP][OXT] := -0.02;
    
    // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
    // NEUROPEPTIDE Y (NPY) INTERACTIONS — THE STRESS RESILIENCE FACTOR
    // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
    
    // NPY → CORT: NPY reduces cortisol (stress resilience) (-)
    matrix[NPY][CORT] := -0.06;
    
    // NPY → NE: NPY reduces NE (anxiolytic) (-)
    matrix[NPY][NE] := -0.04;
    
    // NPY → GABA: NPY enhances GABA (+)
    matrix[NPY][GABA_IDX] := 0.04;
    
    // NPY → GLU: NPY reduces excessive glutamate (-)
    matrix[NPY][GLU] := -0.03;
    
    matrix
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 4: E/I RATIO HOMEOSTASIS — THE STABILITY SYSTEM
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // The brain maintains a delicate balance between Excitation (E) and Inhibition (I).
  // E/I ratio ~1.0 is optimal
  // E/I > 1.2 → Emergency GABA surge (prevent seizure)
  // E/I < 0.8 → GABA reduces (prevent coma)
  //
  
  public type EIRatioState = {
    var excitation : Float;              // Total excitatory activity (mainly glutamate)
    var inhibition : Float;              // Total inhibitory activity (mainly GABA)
    var eiRatio : Float;                 // E/I ratio
    var eiTarget : Float;                // Target E/I (usually 1.0)
    var homeostasisError : Float;        // Deviation from target
    var gabaEmergencySurge : Float;      // Emergency GABA boost
    var emergencySurgeActive : Bool;
    var eiHistory : [var Float];
    var historyIdx : Nat;
  };
  
  public let EI_HISTORY_LENGTH : Nat = 100;
  
  // Initialize E/I state
  public func initEIRatioState() : EIRatioState {
    {
      var excitation = 0.5;
      var inhibition = 0.5;
      var eiRatio = 1.0;
      var eiTarget = 1.0;
      var homeostasisError = 0.0;
      var gabaEmergencySurge = 0.0;
      var emergencySurgeActive = false;
      var eiHistory = Array.init<Float>(EI_HISTORY_LENGTH, func(_ : Nat) : Float { 1.0 });
      var historyIdx = 0;
    }
  };
  
  // Update E/I ratio
  public func updateEIRatio(
    state : EIRatioState,
    glutamate : Float,
    gaba : Float
  ) : Float {  // Returns GABA adjustment
    state.excitation := glutamate;
    state.inhibition := gaba + 0.01;  // Prevent division by zero
    state.eiRatio := state.excitation / state.inhibition;
    
    // Store in history
    state.eiHistory[state.historyIdx] := state.eiRatio;
    state.historyIdx := (state.historyIdx + 1) % EI_HISTORY_LENGTH;
    
    state.homeostasisError := state.eiRatio - state.eiTarget;
    
    var gabaAdjustment : Float = 0.0;
    
    // Emergency GABA surge if E/I too high
    if (state.eiRatio > 1.2) {
      state.emergencySurgeActive := true;
      state.gabaEmergencySurge := (state.eiRatio - 1.2) * 0.5;
      gabaAdjustment := state.gabaEmergencySurge;
    } else if (state.eiRatio < 0.8) {
      // E/I too low — reduce GABA
      state.emergencySurgeActive := false;
      state.gabaEmergencySurge := 0.0;
      gabaAdjustment := (state.eiRatio - 0.8) * 0.3;  // Negative = reduce GABA
    } else {
      state.emergencySurgeActive := false;
      state.gabaEmergencySurge := state.gabaEmergencySurge * 0.9;  // Decay
    };
    
    gabaAdjustment
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 5: SUSTAINED STRESS FACTOR — CHRONIC STRESS TRACKING
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Acute stress is different from chronic stress.
  // Cortisol's effects depend on DURATION of elevation.
  // Chronic stress degrades BDNF, impairs plasticity, damages hippocampus.
  //
  
  public type SustainedStressState = {
    var acuteStress : Float;             // Current stress level
    var sustainedStressFactor : Float;   // Accumulated chronic stress
    var stressDuration : Nat;            // Beats of elevated cortisol
    var recoveryTime : Nat;              // Beats since last stress peak
    var stressHistory : [var Float];
    var historyIdx : Nat;
    var peakStress : Float;
    var avgStress : Float;
    var allostaticLoad : Float;          // Cumulative wear and tear
  };
  
  public let STRESS_HISTORY_LENGTH : Nat = 200;
  
  // Initialize stress state
  public func initSustainedStressState() : SustainedStressState {
    {
      var acuteStress = 0.0;
      var sustainedStressFactor = 0.0;
      var stressDuration = 0;
      var recoveryTime = 0;
      var stressHistory = Array.init<Float>(STRESS_HISTORY_LENGTH, func(_ : Nat) : Float { 0.0 });
      var historyIdx = 0;
      var peakStress = 0.0;
      var avgStress = 0.0;
      var allostaticLoad = 0.0;
    }
  };
  
  // Update stress tracking
  public func updateSustainedStress(
    state : SustainedStressState,
    cortisol : Float,
    threshold : Float
  ) : Float {  // Returns sustained stress factor
    state.acuteStress := cortisol;
    
    // Track in history
    state.stressHistory[state.historyIdx] := cortisol;
    state.historyIdx := (state.historyIdx + 1) % STRESS_HISTORY_LENGTH;
    
    // Update duration
    if (cortisol > threshold) {
      state.stressDuration += 1;
      state.recoveryTime := 0;
      
      // Sustained stress factor increases with duration
      let durationFactor = Float.fromInt(state.stressDuration) / 100.0;
      state.sustainedStressFactor := Float.min(1.0, 
        state.sustainedStressFactor + durationFactor * 0.01);
    } else {
      state.recoveryTime += 1;
      
      // Sustained stress decays during recovery
      let recoveryFactor = Float.fromInt(state.recoveryTime) / 200.0;
      state.sustainedStressFactor := Float.max(0.0,
        state.sustainedStressFactor - recoveryFactor * 0.005);
      
      // Reset duration after sufficient recovery
      if (state.recoveryTime > 100) {
        state.stressDuration := 0;
      };
    };
    
    // Update peak
    if (cortisol > state.peakStress) {
      state.peakStress := cortisol;
    };
    
    // Compute average
    var sum : Float = 0.0;
    for (i in Iter.range(0, STRESS_HISTORY_LENGTH - 1)) {
      sum += state.stressHistory[i];
    };
    state.avgStress := sum / Float.fromInt(STRESS_HISTORY_LENGTH);
    
    // Allostatic load accumulates with chronic stress
    state.allostaticLoad := state.allostaticLoad + state.sustainedStressFactor * 0.0001;
    
    state.sustainedStressFactor
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 6: ANANDAMIDE GATE — THE BLISS/FLOW STATE DETECTOR
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // When anandamide > 0.60 AND coherence > 0.70, organism enters "flow state"
  // All positive processes get ×1.5 multiplier
  // This is the runner's high, the creative flow, the zone
  //
  
  public type AnandamideGate = {
    var isOpen : Bool;                   // Is the gate open?
    var anandamideLevel : Float;
    var coherenceLevel : Float;
    var gateStrength : Float;            // How strongly open (0-1)
    var multiplier : Float;              // Effect multiplier (1.0-1.5)
    var timeInFlow : Nat;                // Beats in flow state
    var flowHistory : [var Bool];
    var historyIdx : Nat;
    var totalFlowTime : Nat;
  };
  
  public let FLOW_HISTORY_LENGTH : Nat = 100;
  
  // Initialize anandamide gate
  public func initAnandamideGate() : AnandamideGate {
    {
      var isOpen = false;
      var anandamideLevel = 0.25;
      var coherenceLevel = 0.75;
      var gateStrength = 0.0;
      var multiplier = 1.0;
      var timeInFlow = 0;
      var flowHistory = Array.init<Bool>(FLOW_HISTORY_LENGTH, func(_ : Nat) : Bool { false });
      var historyIdx = 0;
      var totalFlowTime = 0;
    }
  };
  
  // Update anandamide gate
  public func updateAnandamideGate(
    gate : AnandamideGate,
    anandamide : Float,
    coherence : Float
  ) : Float {  // Returns multiplier
    gate.anandamideLevel := anandamide;
    gate.coherenceLevel := coherence;
    
    let wasOpen = gate.isOpen;
    
    // Gate opens when both conditions met
    if (anandamide > 0.60 and coherence > 0.70) {
      gate.isOpen := true;
      gate.gateStrength := Float.min(1.0, gate.gateStrength + 0.1);
      gate.timeInFlow += 1;
      gate.totalFlowTime += 1;
    } else {
      gate.isOpen := false;
      gate.gateStrength := Float.max(0.0, gate.gateStrength - 0.05);
      gate.timeInFlow := 0;
    };
    
    // Calculate multiplier (1.0 to 1.5 based on gate strength)
    gate.multiplier := 1.0 + gate.gateStrength * 0.5;
    
    // Track history
    gate.flowHistory[gate.historyIdx] := gate.isOpen;
    gate.historyIdx := (gate.historyIdx + 1) % FLOW_HISTORY_LENGTH;
    
    gate.multiplier
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 7: SEROTONIN-DOPAMINE TIMING GATE — PATIENCE VS IMPULSE
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Serotonin gates WHEN dopamine fires:
  //   - High 5-HT: patient, delayed gratification, considers long-term
  //   - Low 5-HT: impulsive, immediate gratification, short-term
  //
  // This is the neurobiological basis of temporal discounting.
  //
  
  public type SerotoninDopamineGate = {
    var serotoninLevel : Float;
    var dopamineLevel : Float;
    var patienceIndex : Float;           // High = patient, low = impulsive
    var temporalDiscountRate : Float;    // How much future is discounted
    var impulsivityScore : Float;
    var delayedGratificationCapacity : Float;
    var gateTiming : Float;              // When does DA get to fire?
  };
  
  // Initialize serotonin-dopamine gate
  public func initSerotoninDopamineGate() : SerotoninDopamineGate {
    {
      var serotoninLevel = 0.55;
      var dopamineLevel = 0.50;
      var patienceIndex = 0.5;
      var temporalDiscountRate = 0.1;
      var impulsivityScore = 0.5;
      var delayedGratificationCapacity = 0.5;
      var gateTiming = 0.5;
    }
  };
  
  // Update serotonin-dopamine gate
  public func updateSerotoninDopamineGate(
    gate : SerotoninDopamineGate,
    serotonin : Float,
    dopamine : Float
  ) {
    gate.serotoninLevel := serotonin;
    gate.dopamineLevel := dopamine;
    
    // Patience index is proportional to serotonin
    gate.patienceIndex := serotonin;
    
    // Impulsivity is inverse of patience
    gate.impulsivityScore := 1.0 - gate.patienceIndex;
    
    // Temporal discount rate: low 5-HT → high discounting
    // Using hyperbolic discounting: V = A / (1 + k*D)
    // k is the discount rate
    gate.temporalDiscountRate := 0.2 * (1.0 - serotonin) + 0.01;
    
    // Delayed gratification capacity
    gate.delayedGratificationCapacity := serotonin * 0.8 + 0.1;
    
    // Gate timing: when does DA actually fire?
    // High 5-HT = DA fires later (after consideration)
    // Low 5-HT = DA fires immediately
    gate.gateTiming := serotonin;
  };
  
  // Compute discounted value of future reward
  public func computeDiscountedValue(
    gate : SerotoninDopamineGate,
    futureValue : Float,
    delay : Float
  ) : Float {
    // Hyperbolic discounting: V = A / (1 + k*D)
    futureValue / (1.0 + gate.temporalDiscountRate * delay)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 8: COMPLETE NEUROCHEMICAL STATE
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  public type NeurochemicalCrosstalkState = {
    // All 21 neurochemicals
    var chemicals : [var NeurochemicalSpecies];
    
    // All 21 receptor states
    var receptors : [var ReceptorState];
    
    // The 441 crosstalk matrix
    var crosstalkMatrix : [[var Float]];
    
    // Specialized systems
    eiRatio : EIRatioState;
    sustainedStress : SustainedStressState;
    anandamideGate : AnandamideGate;
    serotoninDopamineGate : SerotoninDopamineGate;
    
    // Global state
    var currentBeat : Nat;
    var totalCrosstalkEvents : Nat;
    var dominantChemical : Nat;
    var systemEntropy : Float;
  };
  
  // Initialize complete state
  public func initNeurochemicalCrosstalkState() : NeurochemicalCrosstalkState {
    let chemicals = Array.init<NeurochemicalSpecies>(NUM_CHEMICALS, func(i : Nat) : NeurochemicalSpecies {
      initNeurochemical(i)
    });
    
    let receptors = Array.init<ReceptorState>(NUM_CHEMICALS, func(_ : Nat) : ReceptorState {
      initReceptorState()
    });
    
    {
      var chemicals = chemicals;
      var receptors = receptors;
      var crosstalkMatrix = buildCrosstalkMatrix();
      eiRatio = initEIRatioState();
      sustainedStress = initSustainedStressState();
      anandamideGate = initAnandamideGate();
      serotoninDopamineGate = initSerotoninDopamineGate();
      var currentBeat = 0;
      var totalCrosstalkEvents = 0;
      var dominantChemical = DA;
      var systemEntropy = 0.0;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 9: THE COMPLETE INTERTWINED UPDATE — ALL 441 INTERACTIONS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  public type NeurochemicalHeartbeatResult = {
    concentrations : [Float];
    eiRatio : Float;
    flowState : Bool;
    flowMultiplier : Float;
    sustainedStressFactor : Float;
    patienceIndex : Float;
    dominantChemical : Nat;
    bdnfLevel : Float;
    effectiveDopamine : Float;
  };
  
  // The complete intertwined heartbeat
  public func runNeurochemicalHeartbeat(
    state : NeurochemicalCrosstalkState,
    externalInputs : [Float],            // External stimulation for each chemical
    coherence : Float,                   // ← INTERTWINING: From Kuramoto
    fearLevel : Float,                   // ← INTERTWINING: From Fear Engine
    rewardSignal : Float,                // ← INTERTWINING: From Q-Learning
    dt : Float
  ) : NeurochemicalHeartbeatResult {
    state.currentBeat += 1;
    
    // ───────────────────────────────────────────────────────────────────────────
    // 1. Apply external inputs
    // ───────────────────────────────────────────────────────────────────────────
    for (i in Iter.range(0, NUM_CHEMICALS - 1)) {
      let input = if (i < Array.size(externalInputs)) { externalInputs[i] } else { 0.0 };
      state.chemicals[i].concentration := state.chemicals[i].concentration + input * 0.1;
    };
    
    // ───────────────────────────────────────────────────────────────────────────
    // 2. Apply fear-driven changes
    // ───────────────────────────────────────────────────────────────────────────
    // Fear increases NE, EPI, CORT
    state.chemicals[NE].concentration := state.chemicals[NE].concentration + fearLevel * 0.1;
    state.chemicals[EPI].concentration := state.chemicals[EPI].concentration + fearLevel * 0.08;
    state.chemicals[CORT].concentration := state.chemicals[CORT].concentration + fearLevel * 0.05;
    
    // ───────────────────────────────────────────────────────────────────────────
    // 3. Apply reward-driven changes
    // ───────────────────────────────────────────────────────────────────────────
    // Reward increases DA, END
    state.chemicals[DA].concentration := state.chemicals[DA].concentration + rewardSignal * 0.1;
    state.chemicals[END].concentration := state.chemicals[END].concentration + rewardSignal * 0.05;
    
    // ───────────────────────────────────────────────────────────────────────────
    // 4. Apply ALL 441 crosstalk interactions
    // ───────────────────────────────────────────────────────────────────────────
    let deltas = Array.init<Float>(NUM_CHEMICALS, func(_ : Nat) : Float { 0.0 });
    
    for (i in Iter.range(0, NUM_CHEMICALS - 1)) {
      for (j in Iter.range(0, NUM_CHEMICALS - 1)) {
        if (i != j) {
          let alpha = state.crosstalkMatrix[i][j];
          if (Float.abs(alpha) > 0.001) {
            // Source chemical i affects target chemical j
            let sourceConc = state.chemicals[i].concentration;
            let effect = alpha * sourceConc;
            deltas[j] := deltas[j] + effect;
            state.totalCrosstalkEvents += 1;
          };
        };
      };
    };
    
    // Apply deltas
    for (i in Iter.range(0, NUM_CHEMICALS - 1)) {
      state.chemicals[i].concentration := clamp(
        state.chemicals[i].concentration + deltas[i] * dt,
        0.0,
        1.0
      );
    };
    
    // ───────────────────────────────────────────────────────────────────────────
    // 5. Apply pharmacokinetics (synthesis, release, reuptake, degradation)
    // ───────────────────────────────────────────────────────────────────────────
    for (i in Iter.range(0, NUM_CHEMICALS - 1)) {
      let chem = state.chemicals[i];
      
      // Synthesis (tends toward setpoint)
      let synthesisContrib = chem.synthesisRate * (chem.setpoint - chem.concentration);
      
      // Degradation (proportional to concentration)
      let degradationContrib = -chem.degradationRate * chem.concentration;
      
      // Homeostatic pressure
      chem.homeostaticPressure := chem.setpoint - chem.concentration;
      let homeostaticContrib = chem.homeostaticPressure * 0.01;
      
      // Total change
      let dConc = (synthesisContrib + degradationContrib + homeostaticContrib) * dt;
      chem.velocity := dConc / dt;
      
      chem.concentration := clamp(chem.concentration + dConc, 0.0, 1.0);
      
      // Update cumulative exposure
      chem.cumulativeExposure += chem.concentration * dt;
      
      // Track peak/trough
      if (chem.concentration > chem.peakConcentration) {
        chem.peakConcentration := chem.concentration;
        chem.timeAtPeak := state.currentBeat;
      };
      if (chem.concentration < chem.troughConcentration) {
        chem.troughConcentration := chem.concentration;
      };
    };
    
    // ───────────────────────────────────────────────────────────────────────────
    // 6. Update receptor dynamics
    // ───────────────────────────────────────────────────────────────────────────
    for (i in Iter.range(0, NUM_CHEMICALS - 1)) {
      updateReceptorDynamics(
        state.receptors[i],
        state.chemicals[i].concentration,
        state.chemicals[i].bindingAffinity,
        dt
      );
    };
    
    // ───────────────────────────────────────────────────────────────────────────
    // 7. Update E/I ratio
    // ───────────────────────────────────────────────────────────────────────────
    let gabaAdjust = updateEIRatio(
      state.eiRatio,
      state.chemicals[GLU].concentration,
      state.chemicals[GABA_IDX].concentration
    );
    
    // Apply GABA adjustment from E/I homeostasis
    state.chemicals[GABA_IDX].concentration := clamp(
      state.chemicals[GABA_IDX].concentration + gabaAdjust,
      0.0,
      1.0
    );
    
    // ───────────────────────────────────────────────────────────────────────────
    // 8. Update sustained stress
    // ───────────────────────────────────────────────────────────────────────────
    let sustainedFactor = updateSustainedStress(
      state.sustainedStress,
      state.chemicals[CORT].concentration,
      0.4  // Threshold
    );
    
    // Apply sustained stress effect on BDNF
    // CORT × BDNF interaction: chronic stress degrades plasticity
    let bdnfDegradation = -state.chemicals[CORT].concentration * sustainedFactor * 0.12;
    state.chemicals[BDNF_IDX].concentration := clamp(
      state.chemicals[BDNF_IDX].concentration + bdnfDegradation * dt,
      0.1,  // BDNF never goes to zero
      1.0
    );
    
    // ───────────────────────────────────────────────────────────────────────────
    // 9. Update anandamide gate (flow state)
    // ───────────────────────────────────────────────────────────────────────────
    let flowMultiplier = updateAnandamideGate(
      state.anandamideGate,
      state.chemicals[AEA].concentration,
      coherence
    );
    
    // ───────────────────────────────────────────────────────────────────────────
    // 10. Update serotonin-dopamine gate
    // ───────────────────────────────────────────────────────────────────────────
    updateSerotoninDopamineGate(
      state.serotoninDopamineGate,
      state.chemicals[SER].concentration,
      state.chemicals[DA].concentration
    );
    
    // ───────────────────────────────────────────────────────────────────────────
    // 11. Compute effective dopamine (adenosine antagonism)
    // ───────────────────────────────────────────────────────────────────────────
    // ADO × DA: adenosine blocks dopamine
    let effectiveDopamine = state.chemicals[DA].concentration * 
      (1.0 - state.chemicals[ADO].concentration * 0.6);
    
    // ───────────────────────────────────────────────────────────────────────────
    // 12. Find dominant chemical
    // ───────────────────────────────────────────────────────────────────────────
    var maxConc : Float = 0.0;
    var dominant : Nat = 0;
    
    for (i in Iter.range(0, NUM_CHEMICALS - 1)) {
      let relativeConc = state.chemicals[i].concentration / state.chemicals[i].setpoint;
      if (relativeConc > maxConc) {
        maxConc := relativeConc;
        dominant := i;
      };
    };
    state.dominantChemical := dominant;
    
    // ───────────────────────────────────────────────────────────────────────────
    // Return results
    // ───────────────────────────────────────────────────────────────────────────
    {
      concentrations = Array.tabulate<Float>(NUM_CHEMICALS, func(i : Nat) : Float {
        state.chemicals[i].concentration
      });
      eiRatio = state.eiRatio.eiRatio;
      flowState = state.anandamideGate.isOpen;
      flowMultiplier = flowMultiplier;
      sustainedStressFactor = sustainedFactor;
      patienceIndex = state.serotoninDopamineGate.patienceIndex;
      dominantChemical = dominant;
      bdnfLevel = state.chemicals[BDNF_IDX].concentration;
      effectiveDopamine = effectiveDopamine;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // UTILITY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  func ln(x : Float) : Float {
    if (x <= 0.0) { return -1000.0 };
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
  
  func clamp(x : Float, minVal : Float, maxVal : Float) : Float {
    if (x < minVal) { minVal }
    else if (x > maxVal) { maxVal }
    else { x }
  };

};
