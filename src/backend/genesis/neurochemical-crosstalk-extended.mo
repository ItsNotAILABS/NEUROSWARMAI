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
// NEUROCHEMICAL CROSSTALK MATRIX EXTENDED — DEEP PHARMACODYNAMICS
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// This extension TRIPLES the depth of the Neurochemical Crosstalk Matrix with:
//
// PART 1: RECEPTOR DYNAMICS (700 lines)
// ═════════════════════════════════════
//   - Receptor binding kinetics (Kd, Bmax)
//   - Receptor desensitization and internalization
//   - Receptor upregulation and downregulation
//   - Allosteric modulation
//   - Receptor reserve (spare receptors)
//   - Competitive vs non-competitive antagonism
//   - Partial agonism and efficacy
//
// PART 2: SYNAPTIC DYNAMICS (600 lines)
// ═════════════════════════════════════
//   - Vesicle pool dynamics (readily releasable, recycling, reserve)
//   - Calcium-dependent release probability
//   - Short-term plasticity (facilitation, depression)
//   - Autoreceptor feedback
//   - Heterosynaptic modulation
//   - Volume transmission
//   - Diffusion and reuptake kinetics
//
// PART 3: METABOLIC PATHWAYS (500 lines)
// ══════════════════════════════════════
//   - Synthesis enzyme kinetics (Michaelis-Menten)
//   - Degradation pathways (MAO, COMT, AChE)
//   - Precursor availability
//   - Cofactor requirements
//   - Metabolite effects
//   - Feedback inhibition
//
// PART 4: EXTENDED CROSSTALK MATRIX (800 lines)
// ═════════════════════════════════════════════
//   - All 441 bidirectional interactions
//   - Temporal dynamics (fast vs slow effects)
//   - Dose-response curves for each interaction
//   - Synergistic and antagonistic combinations
//   - State-dependent modulation
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Nat8 "mo:base/Nat8";
import Nat32 "mo:base/Nat32";
import Nat64 "mo:base/Nat64";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Iter "mo:base/Iter";
import Text "mo:base/Text";
import Option "mo:base/Option";
import Bool "mo:base/Bool";

module NeurochemicalCrosstalkExtended {

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  public let NUM_NEUROCHEMICALS : Nat = 21;
  public let NUM_RECEPTOR_TYPES : Nat = 42;  // Multiple receptor subtypes per chemical
  public let NUM_VESICLE_POOLS : Nat = 3;    // RRP, recycling, reserve
  
  // Neurochemical indices
  public let DA : Nat = 0;       // Dopamine
  public let FIVE_HT : Nat = 1;  // Serotonin
  public let NE : Nat = 2;       // Norepinephrine
  public let ACH : Nat = 3;      // Acetylcholine
  public let GLU : Nat = 4;      // Glutamate
  public let GABA : Nat = 5;     // GABA
  public let ENDORPHIN : Nat = 6;// Endorphin
  public let OXT : Nat = 7;      // Oxytocin
  public let CORT : Nat = 8;     // Cortisol
  public let ADR : Nat = 9;      // Adrenaline
  public let MEL : Nat = 10;     // Melatonin
  public let HIST : Nat = 11;    // Histamine
  public let GLY : Nat = 12;     // Glycine
  public let SUBP : Nat = 13;    // Substance P
  public let AEA : Nat = 14;     // Anandamide
  public let ADO : Nat = 15;     // Adenosine
  public let BDNF : Nat = 16;    // BDNF
  public let NGF : Nat = 17;     // NGF
  public let DYN : Nat = 18;     // Dynorphin
  public let VP : Nat = 19;      // Vasopressin
  public let NPY : Nat = 20;     // Neuropeptide Y
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // PART 1: RECEPTOR DYNAMICS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Receptors are not just on/off switches — they have complex dynamics:
  //
  // Binding kinetics:
  //   [L] + [R] ⇌ [LR]
  //   kon: association rate constant
  //   koff: dissociation rate constant
  //   Kd = koff/kon: dissociation constant (lower = higher affinity)
  //
  // Receptor states:
  //   - Resting (available for binding)
  //   - Active (bound to agonist)
  //   - Desensitized (temporarily unresponsive)
  //   - Internalized (removed from membrane)
  //
  
  public type ReceptorState = {
    var totalCount : Float;          // Total receptor number (Bmax)
    var availableCount : Float;      // Receptors on membrane
    var occupancy : Float;           // Fraction bound [0, 1]
    var activeCount : Float;         // Receptors in active state
    var desensitizedCount : Float;   // Desensitized receptors
    var internalizedCount : Float;   // Internalized receptors
    
    // Kinetic parameters
    var kd : Float;                  // Dissociation constant (nM)
    var kon : Float;                 // Association rate
    var koff : Float;                // Dissociation rate
    var efficacy : Float;            // Intrinsic activity [0, 1]
    
    // Desensitization parameters
    var desensRate : Float;          // Rate of desensitization
    var resensRate : Float;          // Rate of resensitization
    var internalizationRate : Float;
    var recyclingRate : Float;
    
    // Allosteric modulation
    var allostericMod : Float;       // Modulator effect on affinity
    var allostericEfficacyMod : Float; // Modulator effect on efficacy
    
    // Regulation
    var baselineExpression : Float;  // Baseline receptor number
    var upregulationState : Float;   // Current upregulation
    var downregulationState : Float; // Current downregulation
  };
  
  public type ReceptorSubtype = {
    name : Text;
    chemicalIdx : Nat;               // Which neurochemical
    state : ReceptorState;
    
    // Subtype-specific properties
    var couplingType : Nat;          // 0=Gs, 1=Gi, 2=Gq, 3=ion channel
    var signalGain : Float;          // Signal amplification
    var expressionLevel : Float;     // Relative expression
  };
  
  public func initReceptorState(kd : Float, bmax : Float) : ReceptorState {
    {
      var totalCount = bmax;
      var availableCount = bmax;
      var occupancy = 0.0;
      var activeCount = 0.0;
      var desensitizedCount = 0.0;
      var internalizedCount = 0.0;
      var kd = kd;
      var kon = 0.1 / kd;            // Derived from Kd
      var koff = 0.1;                // Typical off-rate
      var efficacy = 1.0;            // Full agonist
      var desensRate = 0.01;
      var resensRate = 0.005;
      var internalizationRate = 0.001;
      var recyclingRate = 0.0005;
      var allostericMod = 1.0;
      var allostericEfficacyMod = 1.0;
      var baselineExpression = bmax;
      var upregulationState = 0.0;
      var downregulationState = 0.0;
    }
  };
  
  // Compute receptor occupancy using Hill equation
  // Occupancy = [L]^n / (Kd^n + [L]^n)
  public func computeOccupancy(
    receptor : ReceptorState,
    ligandConcentration : Float,
    hillCoefficient : Float
  ) : Float {
    let kd = receptor.kd * receptor.allostericMod;  // Allosteric modulation of affinity
    
    if (ligandConcentration <= 0.0) { return 0.0 };
    if (kd <= 0.0) { return 1.0 };
    
    let lN = pow(ligandConcentration, hillCoefficient);
    let kdN = pow(kd, hillCoefficient);
    
    lN / (kdN + lN)
  };
  
  // Update receptor binding state
  public func updateReceptorBinding(
    receptor : ReceptorState,
    ligandConc : Float,
    dt : Float
  ) {
    // Compute new occupancy
    let newOccupancy = computeOccupancy(receptor, ligandConc, 1.0);
    
    // Binding kinetics: approach equilibrium occupancy
    let bindingDelta = (newOccupancy - receptor.occupancy) * receptor.kon * dt;
    receptor.occupancy := receptor.occupancy + bindingDelta;
    receptor.occupancy := clamp(receptor.occupancy, 0.0, 1.0);
    
    // Active receptors = occupied × available × efficacy × allosteric
    let effectiveEfficacy = receptor.efficacy * receptor.allostericEfficacyMod;
    receptor.activeCount := receptor.occupancy * receptor.availableCount * effectiveEfficacy;
  };
  
  // Update receptor desensitization
  public func updateDesensitization(
    receptor : ReceptorState,
    stimulationStrength : Float,
    dt : Float
  ) {
    // Desensitization: proportional to activation
    let desensInput = stimulationStrength * receptor.activeCount * receptor.desensRate;
    
    // Resensitization: returns desensitized receptors to available pool
    let resensInput = receptor.desensitizedCount * receptor.resensRate;
    
    // Update desensitized count
    receptor.desensitizedCount := receptor.desensitizedCount + (desensInput - resensInput) * dt;
    receptor.desensitizedCount := Float.max(0.0, receptor.desensitizedCount);
    
    // Internalization: prolonged desensitization leads to internalization
    if (receptor.desensitizedCount > receptor.totalCount * 0.3) {
      let internInput = receptor.desensitizedCount * receptor.internalizationRate;
      receptor.internalizedCount := receptor.internalizedCount + internInput * dt;
      receptor.desensitizedCount := receptor.desensitizedCount - internInput * dt;
    };
    
    // Recycling: internalized receptors slowly return
    let recycleInput = receptor.internalizedCount * receptor.recyclingRate;
    receptor.internalizedCount := receptor.internalizedCount - recycleInput * dt;
    receptor.availableCount := receptor.availableCount + recycleInput * dt;
    
    // Update available count
    receptor.availableCount := receptor.totalCount - receptor.desensitizedCount - receptor.internalizedCount;
    receptor.availableCount := Float.max(0.0, receptor.availableCount);
  };
  
  // Receptor upregulation/downregulation
  public func updateReceptorRegulation(
    receptor : ReceptorState,
    agonistExposure : Float,         // Cumulative exposure
    antagonistExposure : Float,
    dt : Float
  ) {
    // Chronic agonist exposure → downregulation
    if (agonistExposure > 0.5) {
      let downregInput = (agonistExposure - 0.5) * 0.001;
      receptor.downregulationState := receptor.downregulationState + downregInput * dt;
      receptor.downregulationState := Float.min(0.5, receptor.downregulationState);  // Max 50% reduction
    } else {
      receptor.downregulationState := receptor.downregulationState * 0.999;
    };
    
    // Chronic antagonist exposure → upregulation
    if (antagonistExposure > 0.5) {
      let upregInput = (antagonistExposure - 0.5) * 0.001;
      receptor.upregulationState := receptor.upregulationState + upregInput * dt;
      receptor.upregulationState := Float.min(0.5, receptor.upregulationState);  // Max 50% increase
    } else {
      receptor.upregulationState := receptor.upregulationState * 0.999;
    };
    
    // Update total count based on regulation
    receptor.totalCount := receptor.baselineExpression * 
                          (1.0 + receptor.upregulationState - receptor.downregulationState);
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // PART 2: SYNAPTIC DYNAMICS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Synaptic transmission involves:
  //   - Vesicle pools: RRP (readily releasable), recycling, reserve
  //   - Calcium-triggered release
  //   - Short-term plasticity
  //   - Autoreceptor feedback
  //
  
  public type VesiclePool = {
    var rrpSize : Float;             // Readily releasable pool
    var recyclingSize : Float;       // Recycling pool
    var reserveSize : Float;         // Reserve pool
    
    // Pool dynamics
    var rrpRefillRate : Float;       // Rate from recycling → RRP
    var reserveMobilizationRate : Float;  // Rate from reserve → recycling
    var recoveryRate : Float;        // Rate from released → recycling
    
    // Release properties
    var releaseProb : Float;         // Base release probability per AP
    var calciumSensitivity : Float;  // Sensitivity to calcium
    var calciumConc : Float;         // Current calcium concentration
    
    // Short-term plasticity
    var facilitation : Float;        // Facilitation state
    var depression : Float;          // Depression state
    var facilitationTau : Float;     // Facilitation decay constant
    var depressionTau : Float;       // Depression decay constant
  };
  
  public type Synapse = {
    preChemicalIdx : Nat;
    postReceptorIdx : Nat;
    vesicles : VesiclePool;
    
    // Autoreceptor feedback
    var autoreceptorOccupancy : Float;
    var autoreceptorInhibition : Float;
    
    // Volume transmission
    var spilloverFraction : Float;   // Fraction reaching extrasynaptic receptors
    var diffusionDistance : Float;
    
    // Activity tracking
    var lastReleaseTime : Nat;
    var cumulativeRelease : Float;
  };
  
  public func initVesiclePool() : VesiclePool {
    {
      var rrpSize = 10.0;            // Typical RRP: 5-20 vesicles
      var recyclingSize = 50.0;      // Recycling pool ~5× RRP
      var reserveSize = 200.0;       // Reserve pool ~20× RRP
      var rrpRefillRate = 0.5;       // ~2 second refill
      var reserveMobilizationRate = 0.01;  // Slow mobilization
      var recoveryRate = 0.1;        // ~10 second full recovery
      var releaseProb = 0.3;         // 30% release per AP
      var calciumSensitivity = 1.0;
      var calciumConc = 0.0;
      var facilitation = 0.0;
      var depression = 0.0;
      var facilitationTau = 50.0;    // ~50ms decay
      var depressionTau = 200.0;     // ~200ms decay
    }
  };
  
  // Compute release probability given calcium and plasticity
  public func computeReleaseProbability(
    pool : VesiclePool
  ) : Float {
    // Base probability × calcium effect × plasticity
    let calciumFactor = 1.0 + pool.calciumConc * pool.calciumSensitivity;
    let plasticityFactor = 1.0 + pool.facilitation - pool.depression;
    
    var prob = pool.releaseProb * calciumFactor * plasticityFactor;
    prob := clamp(prob, 0.0, 0.95);  // Max 95% release
    
    // Can't release more than RRP
    let maxReleasable = pool.rrpSize / 10.0;  // Normalize
    prob := Float.min(prob, maxReleasable);
    
    prob
  };
  
  // Process action potential: trigger release and update pools
  public func processActionPotential(
    pool : VesiclePool,
    calciumInflux : Float,
    dt : Float
  ) : Float {
    // Update calcium
    pool.calciumConc := pool.calciumConc + calciumInflux;
    
    // Compute release
    let releaseProb = computeReleaseProbability(pool);
    let released = pool.rrpSize * releaseProb;
    
    // Deplete RRP
    pool.rrpSize := pool.rrpSize - released;
    pool.rrpSize := Float.max(0.0, pool.rrpSize);
    
    // Update short-term plasticity
    // Facilitation: increases with each AP, decays exponentially
    pool.facilitation := pool.facilitation + 0.1 * calciumInflux;
    pool.facilitation := pool.facilitation * (1.0 - dt / pool.facilitationTau);
    
    // Depression: increases with depletion, recovers with RRP refill
    let depletionFraction = 1.0 - pool.rrpSize / 10.0;  // Normalized
    pool.depression := pool.depression + depletionFraction * 0.1;
    pool.depression := pool.depression * (1.0 - dt / pool.depressionTau);
    
    released
  };
  
  // Update vesicle pools between action potentials
  public func updateVesiclePools(
    pool : VesiclePool,
    dt : Float
  ) {
    // Calcium decay
    pool.calciumConc := pool.calciumConc * 0.95;  // ~20ms time constant
    
    // RRP refill from recycling
    let rrpDeficit = 10.0 - pool.rrpSize;  // Typical max RRP = 10
    let refillAmount = Float.min(rrpDeficit * pool.rrpRefillRate * dt, pool.recyclingSize);
    pool.rrpSize := pool.rrpSize + refillAmount;
    pool.recyclingSize := pool.recyclingSize - refillAmount;
    
    // Recycling refill from recovery (released vesicles)
    let recoveryAmount = pool.cumulativeRelease * pool.recoveryRate * dt;
    pool.recyclingSize := pool.recyclingSize + recoveryAmount;
    pool.cumulativeRelease := pool.cumulativeRelease - recoveryAmount;
    pool.cumulativeRelease := Float.max(0.0, pool.cumulativeRelease);
    
    // Reserve mobilization during high demand
    if (pool.recyclingSize < 25.0) {  // Below half capacity
      let mobilization = pool.reserveSize * pool.reserveMobilizationRate * dt;
      pool.recyclingSize := pool.recyclingSize + mobilization;
      pool.reserveSize := pool.reserveSize - mobilization;
    };
    
    // Reserve replenishment during rest
    if (pool.reserveSize < 200.0 and pool.recyclingSize > 40.0) {
      let replenishment = 0.01 * dt;
      pool.reserveSize := pool.reserveSize + replenishment;
      pool.recyclingSize := pool.recyclingSize - replenishment;
    };
    
    // Plasticity decay
    pool.facilitation := pool.facilitation * (1.0 - dt / pool.facilitationTau);
    pool.depression := pool.depression * (1.0 - dt / pool.depressionTau);
  };
  
  // Autoreceptor feedback: released transmitter inhibits further release
  public func applyAutoreceptorFeedback(
    synapse : Synapse,
    releasedAmount : Float,
    dt : Float
  ) {
    // Autoreceptor occupancy increases with release
    synapse.autoreceptorOccupancy := synapse.autoreceptorOccupancy + releasedAmount * 0.1;
    synapse.autoreceptorOccupancy := synapse.autoreceptorOccupancy * 0.95;  // Decay
    synapse.autoreceptorOccupancy := Float.min(1.0, synapse.autoreceptorOccupancy);
    
    // Inhibition proportional to occupancy
    synapse.autoreceptorInhibition := synapse.autoreceptorOccupancy * 0.5;
    
    // Apply to release probability
    synapse.vesicles.releaseProb := 0.3 * (1.0 - synapse.autoreceptorInhibition);
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // PART 3: METABOLIC PATHWAYS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Neurochemical synthesis and degradation follow enzyme kinetics:
  //
  // Michaelis-Menten: v = Vmax × [S] / (Km + [S])
  //
  // Key enzymes:
  //   - TH (tyrosine hydroxylase): Tyr → L-DOPA → DA
  //   - TPH (tryptophan hydroxylase): Trp → 5-HTP → 5-HT
  //   - ChAT (choline acetyltransferase): Choline → ACh
  //   - MAO (monoamine oxidase): DA/NE/5-HT → metabolites
  //   - COMT (catechol-O-methyltransferase): DA/NE → metabolites
  //   - AChE (acetylcholinesterase): ACh → choline + acetate
  //
  
  public type EnzymeState = {
    name : Text;
    var vmax : Float;                // Maximum reaction rate
    var km : Float;                  // Michaelis constant
    var activity : Float;            // Current activity level [0, 1]
    var inhibition : Float;          // Inhibition from regulators
    var activation : Float;          // Activation from regulators
    var cofactorAvailability : Float;// Cofactor availability [0, 1]
  };
  
  public type MetabolicState = {
    // Synthesis enzymes
    var tyrosineHydroxylase : EnzymeState;   // DA/NE synthesis
    var tryptophanHydroxylase : EnzymeState; // 5-HT synthesis
    var cholineAcetyltransferase : EnzymeState; // ACh synthesis
    var glutamateDecarboxylase : EnzymeState;   // GABA synthesis
    
    // Degradation enzymes
    var maoA : EnzymeState;          // 5-HT, NE, DA degradation
    var maoB : EnzymeState;          // DA degradation
    var comt : EnzymeState;          // Catecholamine degradation
    var acetylcholinesterase : EnzymeState; // ACh degradation
    
    // Precursors
    var tyrosineLevel : Float;
    var tryptophanLevel : Float;
    var cholineLevel : Float;
    var glutamineLevel : Float;
    
    // Cofactors
    var bh4Level : Float;            // Tetrahydrobiopterin (TH/TPH cofactor)
    var pyridoxalPhosphate : Float;  // B6 (decarboxylase cofactor)
  };
  
  public func initEnzymeState(name : Text, vmax : Float, km : Float) : EnzymeState {
    {
      name = name;
      var vmax = vmax;
      var km = km;
      var activity = 1.0;
      var inhibition = 0.0;
      var activation = 0.0;
      var cofactorAvailability = 1.0;
    }
  };
  
  public func initMetabolicState() : MetabolicState {
    {
      var tyrosineHydroxylase = initEnzymeState("TH", 1.0, 0.04);
      var tryptophanHydroxylase = initEnzymeState("TPH", 0.5, 0.03);
      var cholineAcetyltransferase = initEnzymeState("ChAT", 0.8, 0.1);
      var glutamateDecarboxylase = initEnzymeState("GAD", 0.6, 0.05);
      var maoA = initEnzymeState("MAO-A", 0.7, 0.02);
      var maoB = initEnzymeState("MAO-B", 0.6, 0.03);
      var comt = initEnzymeState("COMT", 0.5, 0.04);
      var acetylcholinesterase = initEnzymeState("AChE", 2.0, 0.1);
      var tyrosineLevel = 1.0;
      var tryptophanLevel = 1.0;
      var cholineLevel = 1.0;
      var glutamineLevel = 1.0;
      var bh4Level = 1.0;
      var pyridoxalPhosphate = 1.0;
    }
  };
  
  // Michaelis-Menten kinetics
  public func computeEnzymeRate(
    enzyme : EnzymeState,
    substrateConc : Float
  ) : Float {
    if (substrateConc <= 0.0) { return 0.0 };
    
    // Effective Vmax with activation/inhibition
    let effectiveVmax = enzyme.vmax * enzyme.activity * 
                       (1.0 + enzyme.activation) * (1.0 - enzyme.inhibition) *
                       enzyme.cofactorAvailability;
    
    // Michaelis-Menten equation
    effectiveVmax * substrateConc / (enzyme.km + substrateConc)
  };
  
  // Update enzyme activity based on regulation
  public func updateEnzymeActivity(
    enzyme : EnzymeState,
    productConc : Float,            // Product inhibition
    substrateConc : Float,          // Substrate activation
    stressLevel : Float,            // Stress affects enzyme expression
    dt : Float
  ) {
    // Product inhibition (feedback)
    enzyme.inhibition := productConc * 0.3;
    enzyme.inhibition := Float.min(0.9, enzyme.inhibition);
    
    // Substrate activation (feed-forward)
    enzyme.activation := substrateConc * 0.2;
    enzyme.activation := Float.min(0.5, enzyme.activation);
    
    // Stress upregulates synthesis enzymes (catecholamines)
    if (stressLevel > 0.5) {
      enzyme.activity := enzyme.activity + (stressLevel - 0.5) * 0.01 * dt;
      enzyme.activity := Float.min(2.0, enzyme.activity);  // Max 2× increase
    } else {
      enzyme.activity := enzyme.activity * 0.999;  // Slow decay to baseline
      enzyme.activity := Float.max(1.0, enzyme.activity);
    };
  };
  
  // Compute synthesis rate for each neurochemical
  public func computeSynthesisRate(
    metab : MetabolicState,
    chemIdx : Nat,
    currentLevel : Float
  ) : Float {
    switch (chemIdx) {
      case (0) {  // Dopamine: TH → AADC pathway
        let thRate = computeEnzymeRate(metab.tyrosineHydroxylase, metab.tyrosineLevel);
        thRate * metab.bh4Level * (1.0 - currentLevel * 0.3)  // Product inhibition
      };
      case (1) {  // Serotonin: TPH → AADC pathway
        let tphRate = computeEnzymeRate(metab.tryptophanHydroxylase, metab.tryptophanLevel);
        tphRate * metab.bh4Level * (1.0 - currentLevel * 0.3)
      };
      case (2) {  // Norepinephrine: DA → DBH
        // Requires DA as precursor
        0.5 * (1.0 - currentLevel * 0.2)  // Simplified
      };
      case (3) {  // Acetylcholine: ChAT
        let chatRate = computeEnzymeRate(metab.cholineAcetyltransferase, metab.cholineLevel);
        chatRate * (1.0 - currentLevel * 0.4)
      };
      case (5) {  // GABA: GAD
        let gadRate = computeEnzymeRate(metab.glutamateDecarboxylase, metab.glutamineLevel);
        gadRate * metab.pyridoxalPhosphate * (1.0 - currentLevel * 0.2)
      };
      case (_) { 
        0.1 * (1.0 - currentLevel * 0.3)  // Generic synthesis
      };
    }
  };
  
  // Compute degradation rate for each neurochemical
  public func computeDegradationRate(
    metab : MetabolicState,
    chemIdx : Nat,
    currentLevel : Float
  ) : Float {
    switch (chemIdx) {
      case (0) {  // Dopamine: MAO + COMT
        let maoRate = computeEnzymeRate(metab.maoB, currentLevel);
        let comtRate = computeEnzymeRate(metab.comt, currentLevel);
        maoRate + comtRate
      };
      case (1) {  // Serotonin: MAO-A
        computeEnzymeRate(metab.maoA, currentLevel)
      };
      case (2) {  // Norepinephrine: MAO + COMT
        let maoRate = computeEnzymeRate(metab.maoA, currentLevel);
        let comtRate = computeEnzymeRate(metab.comt, currentLevel);
        maoRate + comtRate
      };
      case (3) {  // Acetylcholine: AChE
        computeEnzymeRate(metab.acetylcholinesterase, currentLevel)
      };
      case (_) {
        currentLevel * 0.1  // Generic degradation
      };
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // PART 4: EXTENDED CROSSTALK MATRIX
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // The full 21×21 crosstalk matrix encodes all bidirectional interactions.
  // Each interaction has:
  //   - Magnitude: strength of effect
  //   - Sign: positive (facilitation) or negative (inhibition)
  //   - Delay: fast (ms) or slow (minutes-hours)
  //   - Dose-response: EC50 and Hill coefficient
  //
  
  public type CrosstalkInteraction = {
    sourceIdx : Nat;
    targetIdx : Nat;
    var magnitude : Float;           // Effect size [-1, 1]
    var ec50 : Float;                // Half-maximal effective concentration
    var hillCoeff : Float;           // Cooperativity
    var delay : Float;               // Delay in beats
    var isActive : Bool;             // Whether interaction is active
    var stateDependent : Bool;       // Depends on organism state?
  };
  
  public type CrosstalkMatrix = {
    var interactions : [[var CrosstalkInteraction]];  // 21×21 matrix
    var fastEffects : [[var Float]];                  // Immediate effects
    var slowEffects : [[var Float]];                  // Delayed effects
    var synergyMatrix : [[var Float]];                // Synergy coefficients
  };
  
  public func initCrosstalkInteraction(source : Nat, target : Nat, mag : Float) : CrosstalkInteraction {
    {
      sourceIdx = source;
      targetIdx = target;
      var magnitude = mag;
      var ec50 = 0.5;
      var hillCoeff = 1.0;
      var delay = 0.0;
      var isActive = mag != 0.0;
      var stateDependent = false;
    }
  };
  
  public func initCrosstalkMatrix() : CrosstalkMatrix {
    // Initialize with known neurochemical interactions
    let interactions = Array.init<[var CrosstalkInteraction]>(NUM_NEUROCHEMICALS, func(i : Nat) : [var CrosstalkInteraction] {
      Array.init<CrosstalkInteraction>(NUM_NEUROCHEMICALS, func(j : Nat) : CrosstalkInteraction {
        initCrosstalkInteraction(i, j, 0.0)
      })
    });
    
    // Set up known interactions
    // DA × GLU: D1/NMDA gate
    interactions[DA][GLU].magnitude := 0.08;
    interactions[GLU][DA].magnitude := 0.05;
    
    // CORT × BDNF: stress degrades plasticity
    interactions[CORT][BDNF].magnitude := -0.12;
    
    // GABA × GLU: E/I balance
    interactions[GABA][GLU].magnitude := -0.15;
    interactions[GLU][GABA].magnitude := 0.10;
    
    // ADO × DA: A2A/D2 antagonism
    interactions[ADO][DA].magnitude := -0.60;
    
    // OXT × CORT: social buffering
    interactions[OXT][CORT].magnitude := -0.08;
    
    // 5HT × DA: patience gating
    interactions[FIVE_HT][DA].magnitude := -0.05;
    
    // NE × CORT: stress cascade
    interactions[NE][CORT].magnitude := 0.15;
    
    // ADR × NE: amplification
    interactions[ADR][NE].magnitude := 0.20;
    
    // Endorphin × SUBP: pain modulation
    interactions[ENDORPHIN][SUBP].magnitude := -0.25;
    
    // AEA × DA: bliss gate
    interactions[AEA][DA].magnitude := 0.10;
    
    // MEL × all: sleep/wake modulation
    for (i in Iter.range(0, NUM_NEUROCHEMICALS - 1)) {
      if (i != MEL) {
        interactions[MEL][i].magnitude := -0.02;  // General suppression
      };
    };
    
    // BDNF × all plasticity
    for (i in Iter.range(0, NUM_NEUROCHEMICALS - 1)) {
      if (i != BDNF) {
        interactions[BDNF][i].magnitude := 0.02;  // General facilitation
      };
    };
    
    // DYN × DA: kappa-opioid antagonism
    interactions[DYN][DA].magnitude := -0.15;
    
    // VP × CORT: stress amplification
    interactions[VP][CORT].magnitude := 0.10;
    
    // NPY × NE: anxiolytic
    interactions[NPY][NE].magnitude := -0.08;
    interactions[NPY][CORT].magnitude := -0.05;
    
    {
      var interactions = interactions;
      var fastEffects = Array.init<[var Float]>(NUM_NEUROCHEMICALS, func(_ : Nat) : [var Float] {
        Array.init<Float>(NUM_NEUROCHEMICALS, func(_ : Nat) : Float { 0.0 })
      });
      var slowEffects = Array.init<[var Float]>(NUM_NEUROCHEMICALS, func(_ : Nat) : [var Float] {
        Array.init<Float>(NUM_NEUROCHEMICALS, func(_ : Nat) : Float { 0.0 })
      });
      var synergyMatrix = Array.init<[var Float]>(NUM_NEUROCHEMICALS, func(_ : Nat) : [var Float] {
        Array.init<Float>(NUM_NEUROCHEMICALS, func(_ : Nat) : Float { 1.0 })
      });
    }
  };
  
  // Compute dose-response for an interaction
  public func computeDoseResponse(
    interaction : CrosstalkInteraction,
    sourceConc : Float
  ) : Float {
    if (not interaction.isActive or sourceConc <= 0.0) { return 0.0 };
    
    // Hill equation for dose-response
    let ec50 = interaction.ec50;
    let n = interaction.hillCoeff;
    
    let concN = pow(sourceConc, n);
    let ec50N = pow(ec50, n);
    let response = concN / (ec50N + concN);
    
    interaction.magnitude * response
  };
  
  // Update all crosstalk effects
  public func updateCrosstalk(
    matrix : CrosstalkMatrix,
    levels : [Float],
    dt : Float
  ) : [Float] {
    let effects = Array.init<Float>(NUM_NEUROCHEMICALS, func(_ : Nat) : Float { 0.0 });
    
    // Compute effects from each source on each target
    for (source in Iter.range(0, NUM_NEUROCHEMICALS - 1)) {
      for (target in Iter.range(0, NUM_NEUROCHEMICALS - 1)) {
        if (source != target) {
          let interaction = matrix.interactions[source][target];
          let effect = computeDoseResponse(interaction, levels[source]);
          
          // Apply delay
          if (interaction.delay > 0.0) {
            // Slow effect: accumulates over time
            matrix.slowEffects[source][target] := 
              0.95 * matrix.slowEffects[source][target] + 0.05 * effect;
            effects[target] := effects[target] + matrix.slowEffects[source][target] * dt;
          } else {
            // Fast effect: immediate
            matrix.fastEffects[source][target] := effect;
            effects[target] := effects[target] + effect * dt;
          };
        };
      };
    };
    
    Array.freeze(effects)
  };
  
  // Check for synergistic combinations
  public func checkSynergy(
    matrix : CrosstalkMatrix,
    levels : [Float]
  ) : [Float] {
    let synergies = Array.init<Float>(NUM_NEUROCHEMICALS, func(_ : Nat) : Float { 1.0 });
    
    // Known synergistic combinations
    
    // DA + GLU synergy at D1/NMDA
    if (levels[DA] > 0.3 and levels[GLU] > 0.3) {
      let synergy = 1.0 + 0.3 * Float.min(levels[DA], levels[GLU]);
      synergies[DA] := synergies[DA] * synergy;
      synergies[GLU] := synergies[GLU] * synergy;
    };
    
    // NE + CORT synergy in stress response
    if (levels[NE] > 0.4 and levels[CORT] > 0.4) {
      let synergy = 1.0 + 0.2 * Float.min(levels[NE], levels[CORT]);
      synergies[NE] := synergies[NE] * synergy;
      synergies[CORT] := synergies[CORT] * synergy;
    };
    
    // OXT + 5HT synergy for prosocial behavior
    if (levels[OXT] > 0.3 and levels[FIVE_HT] > 0.3) {
      let synergy = 1.0 + 0.25 * Float.min(levels[OXT], levels[FIVE_HT]);
      synergies[OXT] := synergies[OXT] * synergy;
      synergies[FIVE_HT] := synergies[FIVE_HT] * synergy;
    };
    
    // GABA + GLY synergy for inhibition
    if (levels[GABA] > 0.4 and levels[GLY] > 0.3) {
      let synergy = 1.0 + 0.2 * Float.min(levels[GABA], levels[GLY]);
      synergies[GABA] := synergies[GABA] * synergy;
    };
    
    Array.freeze(synergies)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // INTEGRATED NEUROCHEMICAL UPDATE
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  public type NeurochemicalState = {
    var levels : [var Float];
    var receptors : [[var ReceptorState]];  // Multiple receptor types per chemical
    var metabolic : MetabolicState;
    var crosstalk : CrosstalkMatrix;
  };
  
  public func updateNeurochemistry(
    state : NeurochemicalState,
    inputs : [Float],               // External inputs per chemical
    stressLevel : Float,
    dt : Float
  ) {
    // 1. Compute crosstalk effects
    let crosstalkEffects = updateCrosstalk(state.crosstalk, Array.freeze(state.levels), dt);
    
    // 2. Compute synergies
    let synergies = checkSynergy(state.crosstalk, Array.freeze(state.levels));
    
    // 3. Update each neurochemical
    for (i in Iter.range(0, NUM_NEUROCHEMICALS - 1)) {
      let currentLevel = state.levels[i];
      
      // Synthesis
      let synthesis = computeSynthesisRate(state.metabolic, i, currentLevel);
      
      // Degradation
      let degradation = computeDegradationRate(state.metabolic, i, currentLevel);
      
      // External input
      let externalInput = if (i < Array.size(inputs)) { inputs[i] } else { 0.0 };
      
      // Net change
      let netChange = synthesis - degradation + crosstalkEffects[i] + externalInput;
      
      // Apply synergy
      let synergizedChange = netChange * synergies[i];
      
      // Update level
      state.levels[i] := currentLevel + synergizedChange * dt;
      state.levels[i] := clamp(state.levels[i], 0.0, 2.0);  // Max 2× normal
    };
    
    // 4. Update metabolic enzymes
    updateEnzymeActivity(state.metabolic.tyrosineHydroxylase, state.levels[DA], state.metabolic.tyrosineLevel, stressLevel, dt);
    updateEnzymeActivity(state.metabolic.tryptophanHydroxylase, state.levels[FIVE_HT], state.metabolic.tryptophanLevel, stressLevel, dt);
    updateEnzymeActivity(state.metabolic.maoA, 0.0, state.levels[FIVE_HT], stressLevel, dt);
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // UTILITY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  func clamp(x : Float, minVal : Float, maxVal : Float) : Float {
    if (x < minVal) { minVal }
    else if (x > maxVal) { maxVal }
    else { x }
  };
  
  func pow(base : Float, exp : Float) : Float {
    if (base <= 0.0) { return 0.0 };
    expFunc(exp * ln(base))
  };
  
  func expFunc(x : Float) : Float {
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

};

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // PART 5: COMPLETE 21x21 CROSS-TALK MATRIX
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Full bidirectional interactions between all 21 neurochemicals with:
  //   - Fast effects (milliseconds to seconds)
  //   - Slow effects (minutes to hours)
  //   - Dose-response characteristics
  //   - State-dependent modulation
  //
  
  public type CrossTalkEntry = {
    sourceIdx : Nat;
    targetIdx : Nat;
    var fastEffect : Float;           // Immediate effect [-1, 1]
    var slowEffect : Float;           // Delayed effect [-1, 1]
    var fastTau : Float;              // Fast time constant (ms)
    var slowTau : Float;              // Slow time constant (min)
    var ec50 : Float;                 // Half-maximal concentration
    var hillCoeff : Float;            // Cooperativity
    var maxEffect : Float;            // Maximum effect magnitude
    var stateModulator : Float;       // State-dependent scaling
  };
  
  public type CrossTalkMatrix = {
    entries : [[var CrossTalkEntry]]; // 21x21 matrix
    var globalModulation : Float;
    var temporalPhase : Float;
  };
  
  public func initCrossTalkEntry(src : Nat, tgt : Nat, fast : Float, slow : Float) : CrossTalkEntry {
    {
      sourceIdx = src;
      targetIdx = tgt;
      var fastEffect = fast;
      var slowEffect = slow;
      var fastTau = 50.0;
      var slowTau = 5.0;
      var ec50 = 0.5;
      var hillCoeff = 1.0;
      var maxEffect = 1.0;
      var stateModulator = 1.0;
    }
  };
  
  // DA interactions with all 21 neurochemicals
  public let DA_CROSSTALK : [(Nat, Float, Float)] = [
    (DA, 0.0, 0.0),           // Self (autocrine)
    (FIVE_HT, -0.3, -0.2),    // DA → 5-HT: inhibitory
    (NE, 0.4, 0.3),           // DA → NE: stimulatory (shared synthesis)
    (ACH, -0.2, -0.1),        // DA → ACh: inhibitory in striatum
    (GLU, 0.3, 0.2),          // DA → Glu: facilitates release
    (GABA, -0.4, -0.3),       // DA → GABA: D2 inhibition
    (ENDORPHIN, 0.2, 0.3),    // DA → Endorphin: reward coupling
    (OXT, 0.1, 0.2),          // DA → OXT: social reward
    (CORT, -0.2, -0.3),       // DA → Cortisol: stress modulation
    (ADR, 0.3, 0.2),          // DA → Adrenaline: arousal
    (MEL, -0.1, -0.2),        // DA → Melatonin: circadian
    (HIST, 0.2, 0.1),         // DA → Histamine: wakefulness
    (GLY, -0.1, -0.1),        // DA → Glycine: minimal
    (SUBP, 0.3, 0.2),         // DA → Substance P: pain modulation
    (AEA, 0.2, 0.3),          // DA → Anandamide: reward
    (ADO, -0.2, -0.1),        // DA → Adenosine: antagonism
    (BDNF, 0.3, 0.4),         // DA → BDNF: neuroplasticity
    (NGF, 0.1, 0.2),          // DA → NGF: trophic support
    (DYN, -0.3, -0.2),        // DA → Dynorphin: opponent process
    (VP, 0.1, 0.1),           // DA → Vasopressin: social
    (NPY, -0.2, -0.1)         // DA → NPY: feeding
  ];
  
  // 5-HT interactions with all 21 neurochemicals
  public let FIVE_HT_CROSSTALK : [(Nat, Float, Float)] = [
    (DA, -0.3, -0.2),         // 5-HT → DA: inhibitory
    (FIVE_HT, 0.0, 0.0),      // Self
    (NE, 0.2, 0.2),           // 5-HT → NE: modulatory
    (ACH, 0.1, 0.1),          // 5-HT → ACh: facilitation
    (GLU, -0.2, -0.2),        // 5-HT → Glu: inhibitory
    (GABA, 0.3, 0.2),         // 5-HT → GABA: facilitates
    (ENDORPHIN, 0.2, 0.2),    // 5-HT → Endorphin: mood
    (OXT, 0.3, 0.3),          // 5-HT → OXT: prosocial
    (CORT, -0.2, -0.2),       // 5-HT → Cortisol: anxiolytic
    (ADR, -0.2, -0.1),        // 5-HT → Adrenaline: calming
    (MEL, 0.4, 0.3),          // 5-HT → Melatonin: precursor
    (HIST, -0.2, -0.1),       // 5-HT → Histamine: inhibitory
    (GLY, 0.1, 0.1),          // 5-HT → Glycine: facilitates
    (SUBP, -0.3, -0.2),       // 5-HT → Substance P: analgesic
    (AEA, 0.2, 0.2),          // 5-HT → Anandamide: mood
    (ADO, 0.1, 0.1),          // 5-HT → Adenosine: sleep
    (BDNF, 0.4, 0.4),         // 5-HT → BDNF: neuroplasticity
    (NGF, 0.2, 0.2),          // 5-HT → NGF: trophic
    (DYN, -0.1, -0.1),        // 5-HT → Dynorphin: minimal
    (VP, 0.1, 0.1),           // 5-HT → Vasopressin: social
    (NPY, 0.2, 0.1)           // 5-HT → NPY: satiety
  ];
  
  // NE interactions with all 21 neurochemicals
  public let NE_CROSSTALK : [(Nat, Float, Float)] = [
    (DA, 0.3, 0.2),           // NE → DA: facilitates
    (FIVE_HT, 0.2, 0.1),      // NE → 5-HT: modulatory
    (NE, 0.0, 0.0),           // Self
    (ACH, 0.3, 0.2),          // NE → ACh: arousal
    (GLU, 0.4, 0.3),          // NE → Glu: facilitates
    (GABA, -0.2, -0.1),       // NE → GABA: reduces inhibition
    (ENDORPHIN, 0.1, 0.1),    // NE → Endorphin: stress
    (OXT, -0.1, -0.1),        // NE → OXT: stress inhibits
    (CORT, 0.4, 0.3),         // NE → Cortisol: stress axis
    (ADR, 0.5, 0.4),          // NE → Adrenaline: precursor
    (MEL, -0.3, -0.2),        // NE → Melatonin: inhibits
    (HIST, 0.3, 0.2),         // NE → Histamine: arousal
    (GLY, -0.1, -0.1),        // NE → Glycine: reduces
    (SUBP, 0.2, 0.2),         // NE → Substance P: pain
    (AEA, -0.1, -0.1),        // NE → Anandamide: stress
    (ADO, -0.2, -0.2),        // NE → Adenosine: opposes
    (BDNF, 0.3, 0.3),         // NE → BDNF: plasticity
    (NGF, 0.2, 0.2),          // NE → NGF: trophic
    (DYN, 0.2, 0.2),          // NE → Dynorphin: stress
    (VP, 0.3, 0.2),           // NE → Vasopressin: stress
    (NPY, 0.3, 0.2)           // NE → NPY: stress eating
  ];
  
  // ACh interactions
  public let ACH_CROSSTALK : [(Nat, Float, Float)] = [
    (DA, 0.2, 0.1),           // ACh → DA: modulates
    (FIVE_HT, 0.1, 0.1),      // ACh → 5-HT: facilitates
    (NE, 0.3, 0.2),           // ACh → NE: arousal
    (ACH, 0.0, 0.0),          // Self
    (GLU, 0.4, 0.3),          // ACh → Glu: learning
    (GABA, 0.2, 0.1),         // ACh → GABA: interneurons
    (ENDORPHIN, 0.1, 0.1),    // ACh → Endorphin: minor
    (OXT, 0.2, 0.2),          // ACh → OXT: social
    (CORT, 0.1, 0.1),         // ACh → Cortisol: HPA
    (ADR, 0.2, 0.2),          // ACh → Adrenaline: autonomic
    (MEL, -0.1, -0.1),        // ACh → Melatonin: minor
    (HIST, 0.2, 0.1),         // ACh → Histamine: arousal
    (GLY, 0.1, 0.1),          // ACh → Glycine: spinal
    (SUBP, 0.1, 0.1),         // ACh → Substance P: pain
    (AEA, 0.1, 0.1),          // ACh → Anandamide: minor
    (ADO, -0.1, -0.1),        // ACh → Adenosine: opposes
    (BDNF, 0.3, 0.3),         // ACh → BDNF: learning
    (NGF, 0.3, 0.3),          // ACh → NGF: trophic
    (DYN, 0.0, 0.0),          // ACh → Dynorphin: none
    (VP, 0.1, 0.1),           // ACh → Vasopressin: memory
    (NPY, 0.1, 0.1)           // ACh → NPY: feeding
  ];
  
  // GLU interactions
  public let GLU_CROSSTALK : [(Nat, Float, Float)] = [
    (DA, 0.4, 0.3),           // Glu → DA: VTA activation
    (FIVE_HT, 0.2, 0.1),      // Glu → 5-HT: raphe
    (NE, 0.3, 0.2),           // Glu → NE: LC
    (ACH, 0.3, 0.2),          // Glu → ACh: basal forebrain
    (GLU, 0.0, 0.0),          // Self
    (GABA, 0.3, 0.2),         // Glu → GABA: interneurons
    (ENDORPHIN, 0.2, 0.2),    // Glu → Endorphin: opioid release
    (OXT, 0.2, 0.1),          // Glu → OXT: hypothalamus
    (CORT, 0.3, 0.2),         // Glu → Cortisol: stress
    (ADR, 0.2, 0.2),          // Glu → Adrenaline: arousal
    (MEL, -0.1, -0.1),        // Glu → Melatonin: inhibits
    (HIST, 0.2, 0.1),         // Glu → Histamine: TMN
    (GLY, -0.3, -0.2),        // Glu → Glycine: reciprocal
    (SUBP, 0.3, 0.2),         // Glu → Substance P: pain
    (AEA, 0.2, 0.2),          // Glu → Anandamide: retrograde
    (ADO, 0.2, 0.1),          // Glu → Adenosine: metabolic
    (BDNF, 0.5, 0.4),         // Glu → BDNF: activity-dependent
    (NGF, 0.2, 0.2),          // Glu → NGF: trophic
    (DYN, 0.2, 0.2),          // Glu → Dynorphin: stress
    (VP, 0.2, 0.1),           // Glu → Vasopressin: hypothalamus
    (NPY, 0.1, 0.1)           // Glu → NPY: arcuate
  ];
  
  // GABA interactions
  public let GABA_CROSSTALK : [(Nat, Float, Float)] = [
    (DA, -0.4, -0.3),         // GABA → DA: VTA inhibition
    (FIVE_HT, -0.3, -0.2),    // GABA → 5-HT: raphe inhibition
    (NE, -0.3, -0.2),         // GABA → NE: LC inhibition
    (ACH, -0.2, -0.1),        // GABA → ACh: inhibits
    (GLU, -0.5, -0.4),        // GABA → Glu: primary inhibition
    (GABA, 0.0, 0.0),         // Self
    (ENDORPHIN, 0.1, 0.1),    // GABA → Endorphin: disinhibition
    (OXT, 0.1, 0.1),          // GABA → OXT: PVN
    (CORT, -0.2, -0.2),       // GABA → Cortisol: anxiolytic
    (ADR, -0.3, -0.2),        // GABA → Adrenaline: calming
    (MEL, 0.2, 0.2),          // GABA → Melatonin: sleep
    (HIST, -0.3, -0.2),       // GABA → Histamine: sedation
    (GLY, 0.2, 0.1),          // GABA → Glycine: synergy
    (SUBP, -0.2, -0.1),       // GABA → Substance P: analgesic
    (AEA, 0.1, 0.1),          // GABA → Anandamide: relaxation
    (ADO, 0.2, 0.1),          // GABA → Adenosine: sleep
    (BDNF, -0.1, -0.1),       // GABA → BDNF: reduces
    (NGF, 0.0, 0.0),          // GABA → NGF: none
    (DYN, 0.1, 0.1),          // GABA → Dynorphin: minor
    (VP, -0.1, -0.1),         // GABA → Vasopressin: inhibits
    (NPY, 0.2, 0.2)           // GABA → NPY: anxiolytic
  ];
  
  // Temporal dynamics for cross-talk
  public type TemporalDynamics = {
    var fastPhase : Float;            // Current fast component
    var slowPhase : Float;            // Current slow component
    var ultraslowPhase : Float;       // Genomic effects
    var fastDecay : Float;            // Fast decay rate
    var slowDecay : Float;            // Slow decay rate
    var integrationWindow : Float;    // Temporal integration
  };
  
  public func initTemporalDynamics() : TemporalDynamics {
    {
      var fastPhase = 0.0;
      var slowPhase = 0.0;
      var ultraslowPhase = 0.0;
      var fastDecay = 0.1;
      var slowDecay = 0.01;
      var integrationWindow = 100.0;
    }
  };
  
  public func updateTemporalDynamics(
    dynamics : TemporalDynamics,
    input : Float,
    dt : Float
  ) {
    dynamics.fastPhase := dynamics.fastPhase + input * 0.5;
    dynamics.fastPhase := dynamics.fastPhase * (1.0 - dynamics.fastDecay * dt);
    
    dynamics.slowPhase := dynamics.slowPhase + input * 0.3;
    dynamics.slowPhase := dynamics.slowPhase * (1.0 - dynamics.slowDecay * dt);
    
    dynamics.ultraslowPhase := dynamics.ultraslowPhase + input * 0.1;
    dynamics.ultraslowPhase := dynamics.ultraslowPhase * 0.9999;
  };
  
  // Dose-response curve computation
  public func computeDoseResponse(
    concentration : Float,
    ec50 : Float,
    hillCoeff : Float,
    maxEffect : Float,
    baseline : Float
  ) : Float {
    if (concentration <= 0.0) { return baseline };
    let normalized = pow(concentration, hillCoeff);
    let ec50N = pow(ec50, hillCoeff);
    baseline + maxEffect * normalized / (ec50N + normalized)
  };
  
  // State-dependent modulation
  public type StateModulation = {
    var arousalLevel : Float;
    var stressLevel : Float;
    var sleepPressure : Float;
    var motivationLevel : Float;
    var emotionalValence : Float;
  };
  
  public func computeStateModulation(state : StateModulation, sourceIdx : Nat, targetIdx : Nat) : Float {
    var mod : Float = 1.0;
    
    // High arousal amplifies excitatory interactions
    if (sourceIdx == GLU or sourceIdx == NE or sourceIdx == DA) {
      mod := mod * (1.0 + state.arousalLevel * 0.3);
    };
    
    // High stress amplifies cortisol-related interactions
    if (sourceIdx == CORT or targetIdx == CORT) {
      mod := mod * (1.0 + state.stressLevel * 0.5);
    };
    
    // Sleep pressure enhances inhibitory interactions
    if (sourceIdx == GABA or sourceIdx == ADO or sourceIdx == MEL) {
      mod := mod * (1.0 + state.sleepPressure * 0.4);
    };
    
    mod
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // PART 6: RECEPTOR SUBTYPE SPECIFICITY
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Each neurochemical acts through multiple receptor subtypes with distinct:
  //   - Signaling cascades (Gs, Gi, Gq, ion channel)
  //   - Affinity profiles
  //   - Desensitization kinetics
  //   - Brain region distribution
  //
  
  // Dopamine receptor subtypes
  public type DopamineReceptorSubtype = {
    #D1;    // Gs-coupled, excitatory, postsynaptic
    #D2;    // Gi-coupled, inhibitory, pre/postsynaptic
    #D3;    // Gi-coupled, limbic
    #D4;    // Gi-coupled, prefrontal
    #D5;    // Gs-coupled, hippocampal
  };
  
  public type DopamineReceptorProfile = {
    var d1State : ReceptorState;
    var d2State : ReceptorState;
    var d3State : ReceptorState;
    var d4State : ReceptorState;
    var d5State : ReceptorState;
    var d1D2Balance : Float;          // D1/D2 ratio affects behavior
  };
  
  public func initDopamineReceptorProfile() : DopamineReceptorProfile {
    {
      var d1State = initReceptorState(10.0, 100.0);    // Kd=10nM, Bmax=100
      var d2State = initReceptorState(2.0, 80.0);      // Higher affinity
      var d3State = initReceptorState(1.0, 40.0);      // Highest affinity
      var d4State = initReceptorState(5.0, 30.0);
      var d5State = initReceptorState(15.0, 20.0);
      var d1D2Balance = 1.0;
    }
  };
  
  public func updateDopamineReceptors(
    profile : DopamineReceptorProfile,
    daConcentration : Float,
    dt : Float
  ) {
    updateReceptorBinding(profile.d1State, daConcentration, dt);
    updateReceptorBinding(profile.d2State, daConcentration, dt);
    updateReceptorBinding(profile.d3State, daConcentration, dt);
    updateReceptorBinding(profile.d4State, daConcentration, dt);
    updateReceptorBinding(profile.d5State, daConcentration, dt);
    
    // Update D1/D2 balance
    let d1Signal = profile.d1State.activeCount + profile.d5State.activeCount;
    let d2Signal = profile.d2State.activeCount + profile.d3State.activeCount + profile.d4State.activeCount;
    if (d2Signal > 0.0) {
      profile.d1D2Balance := d1Signal / d2Signal;
    };
  };
  
  // Serotonin receptor subtypes
  public type SerotoninReceptorSubtype = {
    #HT1A;  // Gi-coupled, autoreceptor, anxiolytic
    #HT1B;  // Gi-coupled, vasoconstriction
    #HT2A;  // Gq-coupled, hallucinogenic
    #HT2B;  // Gq-coupled, cardiac
    #HT2C;  // Gq-coupled, appetite/anxiety
    #HT3;   // Ion channel, nausea/emesis
    #HT4;   // Gs-coupled, GI motility
    #HT6;   // Gs-coupled, cognition
    #HT7;   // Gs-coupled, circadian
  };
  
  public type SerotoninReceptorProfile = {
    var ht1aState : ReceptorState;
    var ht1bState : ReceptorState;
    var ht2aState : ReceptorState;
    var ht2bState : ReceptorState;
    var ht2cState : ReceptorState;
    var ht3State : ReceptorState;
    var ht4State : ReceptorState;
    var ht6State : ReceptorState;
    var ht7State : ReceptorState;
    var autoreceptorTone : Float;
  };
  
  public func initSerotoninReceptorProfile() : SerotoninReceptorProfile {
    {
      var ht1aState = initReceptorState(1.0, 60.0);    // High affinity autoreceptor
      var ht1bState = initReceptorState(3.0, 40.0);
      var ht2aState = initReceptorState(5.0, 80.0);
      var ht2bState = initReceptorState(8.0, 30.0);
      var ht2cState = initReceptorState(10.0, 50.0);
      var ht3State = initReceptorState(100.0, 20.0);   // Low affinity ion channel
      var ht4State = initReceptorState(15.0, 25.0);
      var ht6State = initReceptorState(20.0, 35.0);
      var ht7State = initReceptorState(12.0, 30.0);
      var autoreceptorTone = 0.5;
    }
  };
  
  public func updateSerotoninReceptors(
    profile : SerotoninReceptorProfile,
    htConcentration : Float,
    dt : Float
  ) {
    updateReceptorBinding(profile.ht1aState, htConcentration, dt);
    updateReceptorBinding(profile.ht1bState, htConcentration, dt);
    updateReceptorBinding(profile.ht2aState, htConcentration, dt);
    updateReceptorBinding(profile.ht2bState, htConcentration, dt);
    updateReceptorBinding(profile.ht2cState, htConcentration, dt);
    updateReceptorBinding(profile.ht3State, htConcentration, dt);
    updateReceptorBinding(profile.ht4State, htConcentration, dt);
    updateReceptorBinding(profile.ht6State, htConcentration, dt);
    updateReceptorBinding(profile.ht7State, htConcentration, dt);
    
    // Autoreceptor tone from 5-HT1A
    profile.autoreceptorTone := profile.ht1aState.occupancy;
  };
  
  // Adrenergic receptor subtypes
  public type AdrenergicReceptorSubtype = {
    #Alpha1A; // Gq, vasoconstriction
    #Alpha1B; // Gq, cardiac
    #Alpha1D; // Gq, vascular
    #Alpha2A; // Gi, autoreceptor, sedation
    #Alpha2B; // Gi, vascular
    #Alpha2C; // Gi, presynaptic
    #Beta1;   // Gs, cardiac
    #Beta2;   // Gs, bronchodilation
    #Beta3;   // Gs, lipolysis
  };
  
  public type AdrenergicReceptorProfile = {
    var alpha1aState : ReceptorState;
    var alpha1bState : ReceptorState;
    var alpha1dState : ReceptorState;
    var alpha2aState : ReceptorState;
    var alpha2bState : ReceptorState;
    var alpha2cState : ReceptorState;
    var beta1State : ReceptorState;
    var beta2State : ReceptorState;
    var beta3State : ReceptorState;
    var alphaVsBetaBalance : Float;
  };
  
  public func initAdrenergicReceptorProfile() : AdrenergicReceptorProfile {
    {
      var alpha1aState = initReceptorState(50.0, 40.0);
      var alpha1bState = initReceptorState(60.0, 30.0);
      var alpha1dState = initReceptorState(70.0, 25.0);
      var alpha2aState = initReceptorState(5.0, 50.0);    // High affinity autoreceptor
      var alpha2bState = initReceptorState(8.0, 35.0);
      var alpha2cState = initReceptorState(10.0, 30.0);
      var beta1State = initReceptorState(100.0, 60.0);
      var beta2State = initReceptorState(80.0, 50.0);
      var beta3State = initReceptorState(200.0, 20.0);
      var alphaVsBetaBalance = 1.0;
    }
  };
  
  // Glutamate receptor subtypes
  public type GlutamateReceptorSubtype = {
    #NMDA;    // Ionotropic, Ca2+ permeable, LTP
    #AMPA;    // Ionotropic, fast excitation
    #Kainate; // Ionotropic, presynaptic
    #mGluR1;  // Gq, postsynaptic
    #mGluR2;  // Gi, presynaptic autoreceptor
    #mGluR3;  // Gi, glial
    #mGluR4;  // Gi, presynaptic
    #mGluR5;  // Gq, postsynaptic, plasticity
    #mGluR6;  // Gi, retinal
    #mGluR7;  // Gi, presynaptic
    #mGluR8;  // Gi, presynaptic
  };
  
  public type GlutamateReceptorProfile = {
    var nmdaState : ReceptorState;
    var ampaState : ReceptorState;
    var kainateState : ReceptorState;
    var mglur1State : ReceptorState;
    var mglur2State : ReceptorState;
    var mglur3State : ReceptorState;
    var mglur5State : ReceptorState;
    var nmdaMgBlock : Float;          // Mg2+ block state [0,1]
    var ampaGluR2Content : Float;     // GluR2 subunit affects Ca2+
  };
  
  public func initGlutamateReceptorProfile() : GlutamateReceptorProfile {
    {
      var nmdaState = initReceptorState(1.0, 100.0);
      var ampaState = initReceptorState(500.0, 200.0);   // Low affinity, fast
      var kainateState = initReceptorState(50.0, 40.0);
      var mglur1State = initReceptorState(10.0, 30.0);
      var mglur2State = initReceptorState(5.0, 40.0);
      var mglur3State = initReceptorState(8.0, 25.0);
      var mglur5State = initReceptorState(12.0, 35.0);
      var nmdaMgBlock = 0.8;
      var ampaGluR2Content = 0.9;
    }
  };
  
  public func computeNMDAcurrent(
    profile : GlutamateReceptorProfile,
    gluConc : Float,
    voltage : Float,
    glycineConc : Float
  ) : Float {
    // NMDA requires glutamate + glycine co-agonist
    let gluBinding = computeOccupancy(profile.nmdaState, gluConc, 1.0);
    let glyBinding = glycineConc / (glycineConc + 0.1);  // Glycine site
    
    // Voltage-dependent Mg2+ block
    // Relief occurs at depolarized potentials
    let mgRelief = 1.0 / (1.0 + profile.nmdaMgBlock * expFunc(-voltage / 16.0));
    
    gluBinding * glyBinding * mgRelief * profile.nmdaState.activeCount
  };
  
  // GABA receptor subtypes
  public type GABAReceptorSubtype = {
    #GABAA_alpha1;  // Sedation, amnesia
    #GABAA_alpha2;  // Anxiolytic
    #GABAA_alpha3;  // Myorelaxant
    #GABAA_alpha5;  // Memory impairment
    #GABAB_R1;      // Presynaptic inhibition
    #GABAB_R2;      // Required for function
  };
  
  public type GABAReceptorProfile = {
    var gabaaAlpha1State : ReceptorState;
    var gabaaAlpha2State : ReceptorState;
    var gabaaAlpha3State : ReceptorState;
    var gabaaAlpha5State : ReceptorState;
    var gababR1State : ReceptorState;
    var gababR2State : ReceptorState;
    var benzoSiteMod : Float;         // Benzodiazepine site modulation
    var neurosteroiMod : Float;       // Neurosteroid modulation
    var barbiturateMod : Float;       // Barbiturate site modulation
  };
  
  public func initGABAReceptorProfile() : GABAReceptorProfile {
    {
      var gabaaAlpha1State = initReceptorState(20.0, 80.0);
      var gabaaAlpha2State = initReceptorState(25.0, 60.0);
      var gabaaAlpha3State = initReceptorState(30.0, 50.0);
      var gabaaAlpha5State = initReceptorState(35.0, 40.0);
      var gababR1State = initReceptorState(100.0, 50.0);
      var gababR2State = initReceptorState(100.0, 50.0);
      var benzoSiteMod = 1.0;
      var neurosteroiMod = 1.0;
      var barbiturateMod = 1.0;
    }
  };
  
  // Cholinergic receptor subtypes
  public type CholinergicReceptorSubtype = {
    #M1;      // Gq, cortical, memory
    #M2;      // Gi, cardiac, autoreceptor
    #M3;      // Gq, smooth muscle
    #M4;      // Gi, striatal
    #M5;      // Gq, dopamine modulation
    #nAChR_alpha4beta2;  // High affinity nicotinic
    #nAChR_alpha7;       // Fast desensitizing, Ca2+
    #nAChR_alpha3beta4;  // Autonomic
  };
  
  public type CholinergicReceptorProfile = {
    var m1State : ReceptorState;
    var m2State : ReceptorState;
    var m3State : ReceptorState;
    var m4State : ReceptorState;
    var m5State : ReceptorState;
    var alpha4beta2State : ReceptorState;
    var alpha7State : ReceptorState;
    var alpha3beta4State : ReceptorState;
    var muscarinicVsNicotinic : Float;
  };
  
  public func initCholinergicReceptorProfile() : CholinergicReceptorProfile {
    {
      var m1State = initReceptorState(30.0, 50.0);
      var m2State = initReceptorState(20.0, 40.0);
      var m3State = initReceptorState(40.0, 35.0);
      var m4State = initReceptorState(25.0, 45.0);
      var m5State = initReceptorState(35.0, 25.0);
      var alpha4beta2State = initReceptorState(1.0, 60.0);   // High affinity
      var alpha7State = initReceptorState(100.0, 40.0);      // Low affinity, fast
      var alpha3beta4State = initReceptorState(50.0, 30.0);
      var muscarinicVsNicotinic = 1.0;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // PART 7: SYNAPTIC PLASTICITY COUPLING
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Neurochemical states modulate synaptic plasticity:
  //   - LTP (Long-Term Potentiation): strengthening
  //   - LTD (Long-Term Depression): weakening
  //   - Metaplasticity: plasticity of plasticity
  //   - Heterosynaptic effects: spreading changes
  //
  
  public type PlasticityState = {
    var ltpThreshold : Float;         // Threshold for LTP induction
    var ltdThreshold : Float;         // Threshold for LTD induction
    var currentStrength : Float;      // Synaptic weight [0, 2]
    var metaplasticState : Float;     // Sliding threshold
    var eligibilityTrace : Float;     // For three-factor learning
    var tagState : Float;             // Synaptic tag for capture
    var prpAvailability : Float;      // Plasticity-related proteins
  };
  
  public type PlasticityModulation = {
    var daModulation : Float;         // DA gates learning
    var neModulation : Float;         // NE enhances memory
    var achModulation : Float;        // ACh enables plasticity
    var cortisolModulation : Float;   // Stress effects
    var bdnfModulation : Float;       // Trophic support
  };
  
  public func initPlasticityState() : PlasticityState {
    {
      var ltpThreshold = 0.6;
      var ltdThreshold = 0.3;
      var currentStrength = 1.0;
      var metaplasticState = 0.0;
      var eligibilityTrace = 0.0;
      var tagState = 0.0;
      var prpAvailability = 1.0;
    }
  };
  
  public func initPlasticityModulation() : PlasticityModulation {
    {
      var daModulation = 1.0;
      var neModulation = 1.0;
      var achModulation = 1.0;
      var cortisolModulation = 1.0;
      var bdnfModulation = 1.0;
    }
  };
  
  // Compute LTP/LTD based on neurochemical state
  public func computePlasticityInduction(
    plasticity : PlasticityState,
    modulation : PlasticityModulation,
    preActivity : Float,
    postActivity : Float,
    timingDelta : Float              // Post - Pre timing (ms)
  ) : Float {
    // Base Hebbian component
    let coincidence = preActivity * postActivity;
    
    // STDP: timing-dependent
    var stdpFactor : Float = 0.0;
    if (timingDelta > 0.0 and timingDelta < 50.0) {
      // Post after Pre → LTP
      stdpFactor := expFunc(-timingDelta / 20.0);
    } else if (timingDelta < 0.0 and timingDelta > -50.0) {
      // Pre after Post → LTD
      stdpFactor := -0.5 * expFunc(timingDelta / 20.0);
    };
    
    // Neurochemical modulation
    let daGate = modulation.daModulation;
    let neEnhance = 1.0 + 0.3 * (modulation.neModulation - 1.0);
    let achEnable = modulation.achModulation;
    let stressEffect = if (modulation.cortisolModulation > 1.5) {
      0.5  // High stress impairs LTP
    } else {
      1.0
    };
    let bdnfSupport = modulation.bdnfModulation;
    
    // Combined modulation
    let totalMod = daGate * neEnhance * achEnable * stressEffect * bdnfSupport;
    
    // Apply metaplastic threshold shift
    let effectiveThreshold = plasticity.ltpThreshold + plasticity.metaplasticState;
    
    // Final plasticity
    let plasticitySignal = (coincidence + stdpFactor) * totalMod;
    
    if (plasticitySignal > effectiveThreshold) {
      (plasticitySignal - effectiveThreshold) * 0.1  // LTP
    } else if (plasticitySignal < plasticity.ltdThreshold) {
      (plasticitySignal - plasticity.ltdThreshold) * 0.05  // LTD
    } else {
      0.0
    }
  };
  
  // Update synaptic strength
  public func updateSynapticStrength(
    plasticity : PlasticityState,
    modulation : PlasticityModulation,
    preActivity : Float,
    postActivity : Float,
    timingDelta : Float,
    dt : Float
  ) {
    // Compute plasticity
    let plasticityDelta = computePlasticityInduction(
      plasticity, modulation, preActivity, postActivity, timingDelta
    );
    
    // Update eligibility trace
    plasticity.eligibilityTrace := plasticity.eligibilityTrace + 
      Float.abs(preActivity * postActivity) * 0.1;
    plasticity.eligibilityTrace := plasticity.eligibilityTrace * 0.99;
    
    // Three-factor learning: eligibility × DA
    let effectivePlasticity = plasticityDelta * 
      (1.0 + plasticity.eligibilityTrace * (modulation.daModulation - 1.0));
    
    // Update synaptic tag
    if (Float.abs(effectivePlasticity) > 0.1) {
      plasticity.tagState := 1.0;
    } else {
      plasticity.tagState := plasticity.tagState * 0.995;
    };
    
    // Synaptic capture: tag + PRP = lasting change
    if (plasticity.tagState > 0.5 and plasticity.prpAvailability > 0.5) {
      plasticity.currentStrength := plasticity.currentStrength + effectivePlasticity * dt;
      plasticity.prpAvailability := plasticity.prpAvailability - 0.1 * dt;
    };
    
    // Bounds
    plasticity.currentStrength := clamp(plasticity.currentStrength, 0.1, 3.0);
  };
  
  // Metaplasticity: history-dependent threshold shifts
  public func updateMetaplasticity(
    plasticity : PlasticityState,
    recentActivity : Float,
    dt : Float
  ) {
    // BCM-like sliding threshold
    // High activity → raise threshold (harder to induce LTP)
    // Low activity → lower threshold (easier to induce LTP)
    let targetThreshold = recentActivity * recentActivity;
    plasticity.metaplasticState := plasticity.metaplasticState + 
      (targetThreshold - plasticity.metaplasticState) * 0.001 * dt;
  };
  
  // Heterosynaptic plasticity
  public type HeterosynapticSpread = {
    var spatialRadius : Float;        // Spread distance
    var temporalWindow : Float;       // Time window
    var spreadStrength : Float;       // Effect magnitude
  };
  
  public func computeHeterosynapticEffect(
    spread : HeterosynapticSpread,
    distance : Float,
    timeSinceInduction : Float,
    inductionStrength : Float
  ) : Float {
    // Spatial decay
    let spatialFactor = expFunc(-distance / spread.spatialRadius);
    
    // Temporal decay
    let temporalFactor = expFunc(-timeSinceInduction / spread.temporalWindow);
    
    inductionStrength * spatialFactor * temporalFactor * spread.spreadStrength
  };
  
  // Homeostatic plasticity
  public type HomeostaticState = {
    var targetActivity : Float;       // Set point
    var currentActivity : Float;      // Recent average
    var scalingFactor : Float;        // Multiplicative scaling
    var intrinsicExcitability : Float;// Intrinsic plasticity
  };
  
  public func updateHomeostaticPlasticity(
    homeostatic : HomeostaticState,
    instantActivity : Float,
    dt : Float
  ) {
    // Update running average
    homeostatic.currentActivity := homeostatic.currentActivity * 0.999 + 
      instantActivity * 0.001;
    
    // Synaptic scaling
    let activityError = homeostatic.targetActivity - homeostatic.currentActivity;
    homeostatic.scalingFactor := homeostatic.scalingFactor + 
      activityError * 0.0001 * dt;
    homeostatic.scalingFactor := clamp(homeostatic.scalingFactor, 0.5, 2.0);
    
    // Intrinsic excitability
    homeostatic.intrinsicExcitability := homeostatic.intrinsicExcitability + 
      activityError * 0.00005 * dt;
    homeostatic.intrinsicExcitability := clamp(homeostatic.intrinsicExcitability, 0.5, 2.0);
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // PART 8: VOLUME TRANSMISSION DYNAMICS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Many neurochemicals signal beyond the synapse via volume transmission:
  //   - Diffusion through extracellular space
  //   - Reuptake transporter dynamics
  //   - Spillover effects
  //   - Concentration gradients
  //
  
  public type VolumeTransmissionState = {
    chemicalIdx : Nat;
    var synapticConc : Float;         // Concentration in cleft
    var extracellularConc : Float;    // Perisynaptic concentration
    var volumeConc : Float;           // Distant concentration
    
    // Diffusion parameters
    var diffusionCoeff : Float;       // D (μm²/ms)
    var tortuosity : Float;           // Extracellular space factor
    var volumeFraction : Float;       // Extracellular volume
    
    // Reuptake
    var transporterDensity : Float;   // Transporter number
    var transporterKm : Float;        // Michaelis constant
    var transporterVmax : Float;      // Maximum velocity
    var transporterOccupancy : Float; // Current occupancy
    
    // Spillover
    var spilloverRatio : Float;       // Fraction escaping synapse
    var spilloverDecay : Float;       // Clearance rate
  };
  
  public func initVolumeTransmissionState(chemIdx : Nat) : VolumeTransmissionState {
    // Different chemicals have different diffusion/reuptake properties
    let (diff, km, vmax) = switch (chemIdx) {
      case (0) { (330.0, 0.5, 4.0) };     // DA: DAT
      case (1) { (330.0, 0.3, 3.0) };     // 5-HT: SERT
      case (2) { (330.0, 0.4, 5.0) };     // NE: NET
      case (4) { (300.0, 0.1, 10.0) };    // Glu: EAAT
      case (5) { (300.0, 0.5, 8.0) };     // GABA: GAT
      case (_) { (300.0, 1.0, 2.0) };     // Default
    };
    
    {
      chemicalIdx = chemIdx;
      var synapticConc = 0.0;
      var extracellularConc = 0.0;
      var volumeConc = 0.0;
      var diffusionCoeff = diff;
      var tortuosity = 1.6;
      var volumeFraction = 0.2;
      var transporterDensity = 100.0;
      var transporterKm = km;
      var transporterVmax = vmax;
      var transporterOccupancy = 0.0;
      var spilloverRatio = 0.1;
      var spilloverDecay = 0.05;
    }
  };
  
  // Update concentration dynamics
  public func updateVolumeTransmission(
    state : VolumeTransmissionState,
    releaseAmount : Float,
    dt : Float
  ) {
    // 1. Release into synaptic cleft
    state.synapticConc := state.synapticConc + releaseAmount;
    
    // 2. Reuptake from synaptic cleft (Michaelis-Menten)
    let reuptakeRate = state.transporterVmax * state.synapticConc / 
      (state.transporterKm + state.synapticConc);
    let reuptakeAmount = reuptakeRate * state.transporterDensity * dt * 0.01;
    state.synapticConc := state.synapticConc - reuptakeAmount;
    
    // Update transporter occupancy
    state.transporterOccupancy := state.synapticConc / 
      (state.transporterKm + state.synapticConc);
    
    // 3. Spillover to extracellular space
    let spillover = state.synapticConc * state.spilloverRatio * dt;
    state.synapticConc := state.synapticConc - spillover;
    state.extracellularConc := state.extracellularConc + spillover;
    
    // 4. Diffusion from extracellular to volume
    let effectiveDiff = state.diffusionCoeff / (state.tortuosity * state.tortuosity);
    let gradient = state.extracellularConc - state.volumeConc;
    let diffusionFlux = effectiveDiff * gradient * dt * 0.001;
    state.extracellularConc := state.extracellularConc - diffusionFlux;
    state.volumeConc := state.volumeConc + diffusionFlux * state.volumeFraction;
    
    // 5. Volume clearance
    state.volumeConc := state.volumeConc * (1.0 - state.spilloverDecay * dt);
    
    // Ensure non-negative
    state.synapticConc := Float.max(0.0, state.synapticConc);
    state.extracellularConc := Float.max(0.0, state.extracellularConc);
    state.volumeConc := Float.max(0.0, state.volumeConc);
  };
  
  // Compute effective concentration at distance
  public func computeConcentrationAtDistance(
    state : VolumeTransmissionState,
    distance : Float                  // μm from release site
  ) : Float {
    if (distance < 0.5) {
      // Within synaptic cleft
      state.synapticConc
    } else if (distance < 5.0) {
      // Perisynaptic
      let decay = expFunc(-distance / 2.0);
      state.synapticConc * decay + state.extracellularConc * (1.0 - decay)
    } else {
      // Volume transmission range
      let decay = expFunc(-distance / 20.0);
      state.extracellularConc * decay + state.volumeConc * (1.0 - decay)
    }
  };
  
  // Transporter dynamics with competition
  public type TransporterState = {
    var surfaceCount : Float;         // Transporters on membrane
    var internalizedCount : Float;    // Internalized transporters
    var substrateBound : Float;       // Bound to substrate
    var inhibitorBound : Float;       // Bound to inhibitor
    var internalizationRate : Float;
    var recyclingRate : Float;
  };
  
  public func updateTransporterDynamics(
    transporter : TransporterState,
    substrateConc : Float,
    inhibitorConc : Float,
    dt : Float
  ) {
    // Substrate binding
    let substrateKm = 0.5;
    let newSubstrateBound = transporter.surfaceCount * substrateConc / 
      (substrateKm + substrateConc + inhibitorConc);
    transporter.substrateBound := transporter.substrateBound + 
      (newSubstrateBound - transporter.substrateBound) * 0.1 * dt;
    
    // Activity-dependent internalization
    if (transporter.substrateBound > transporter.surfaceCount * 0.5) {
      let internalize = transporter.substrateBound * transporter.internalizationRate * dt;
      transporter.surfaceCount := transporter.surfaceCount - internalize;
      transporter.internalizedCount := transporter.internalizedCount + internalize;
    };
    
    // Recycling
    let recycle = transporter.internalizedCount * transporter.recyclingRate * dt;
    transporter.internalizedCount := transporter.internalizedCount - recycle;
    transporter.surfaceCount := transporter.surfaceCount + recycle;
  };
  
  // Volume vs synaptic transmission ratio
  public func computeVolumeToSynapticRatio(
    volumeState : VolumeTransmissionState
  ) : Float {
    if (volumeState.synapticConc > 0.0) {
      (volumeState.extracellularConc + volumeState.volumeConc) / volumeState.synapticConc
    } else {
      0.0
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // PART 9: CIRCADIAN MODULATION
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Neurochemical levels follow 24-hour rhythms:
  //   - SCN-driven oscillations
  //   - Light/dark sensitivity
  //   - Sleep-wake coupling
  //   - Phase relationships
  //
  
  public type CircadianState = {
    var timeOfDay : Float;            // Hours [0, 24)
    var lightLevel : Float;           // Light intensity [0, 1]
    var scnPhase : Float;             // Master clock phase
    var sleepPressure : Float;        // Homeostatic drive
    var chronotype : Float;           // Individual variation [-2, 2]
  };
  
  public type CircadianProfile = {
    chemicalIdx : Nat;
    var peakTime : Float;             // Time of peak (hours)
    var amplitude : Float;            // Oscillation amplitude
    var baseline : Float;             // Mean level
    var lightSensitivity : Float;     // Light responsiveness
    var sleepCoupling : Float;        // Sleep-wake coupling
  };
  
  public func initCircadianState() : CircadianState {
    {
      var timeOfDay = 8.0;            // Start at 8 AM
      var lightLevel = 0.8;
      var scnPhase = 0.0;
      var sleepPressure = 0.2;
      var chronotype = 0.0;
    }
  };
  
  // Circadian profiles for each neurochemical
  public func initCircadianProfile(chemIdx : Nat) : CircadianProfile {
    let (peak, amp, light, sleep) = switch (chemIdx) {
      case (0) { (14.0, 0.3, 0.2, 0.4) };   // DA: afternoon peak
      case (1) { (10.0, 0.2, 0.3, 0.5) };   // 5-HT: morning peak
      case (2) { (9.0, 0.4, 0.3, 0.6) };    // NE: morning peak
      case (3) { (15.0, 0.2, 0.1, 0.3) };   // ACh: afternoon
      case (4) { (12.0, 0.15, 0.1, 0.2) };  // Glu: noon
      case (5) { (22.0, 0.2, -0.2, 0.4) };  // GABA: evening
      case (8) { (8.0, 0.5, 0.4, 0.7) };    // Cortisol: morning peak
      case (10) { (2.0, 0.8, -0.9, 0.9) };  // Melatonin: night peak
      case (11) { (14.0, 0.3, 0.3, 0.5) };  // Histamine: afternoon
      case (15) { (3.0, 0.4, -0.3, 0.8) };  // Adenosine: builds during wake
      case (_) { (12.0, 0.1, 0.0, 0.2) };   // Default: minimal rhythm
    };
    
    {
      chemicalIdx = chemIdx;
      var peakTime = peak;
      var amplitude = amp;
      var baseline = 1.0;
      var lightSensitivity = light;
      var sleepCoupling = sleep;
    }
  };
  
  // Compute circadian modulation factor
  public func computeCircadianModulation(
    circadian : CircadianState,
    profile : CircadianProfile
  ) : Float {
    // Adjust peak time for chronotype
    let adjustedPeak = profile.peakTime + circadian.chronotype;
    
    // Compute phase relative to peak
    var phase = (circadian.timeOfDay - adjustedPeak) * 2.0 * 3.14159 / 24.0;
    
    // Cosine oscillation
    let oscillation = Float.cos(phase) * profile.amplitude;
    
    // Light effects
    let lightEffect = circadian.lightLevel * profile.lightSensitivity;
    
    // Sleep pressure effects
    let sleepEffect = circadian.sleepPressure * profile.sleepCoupling * 
      (if (circadian.timeOfDay > 22.0 or circadian.timeOfDay < 6.0) { 1.0 } else { -0.5 });
    
    profile.baseline + oscillation + lightEffect + sleepEffect
  };
  
  // Update circadian state
  public func updateCircadianState(
    state : CircadianState,
    dt : Float,                       // In hours
    lightInput : Float
  ) {
    // Advance time
    state.timeOfDay := state.timeOfDay + dt;
    if (state.timeOfDay >= 24.0) {
      state.timeOfDay := state.timeOfDay - 24.0;
    };
    
    // Update light level with temporal filtering
    state.lightLevel := state.lightLevel * 0.9 + lightInput * 0.1;
    
    // Update SCN phase
    state.scnPhase := state.timeOfDay * 2.0 * 3.14159 / 24.0;
    
    // Light phase shifts SCN
    if (lightInput > 0.5 and (state.timeOfDay > 18.0 or state.timeOfDay < 6.0)) {
      // Evening light delays clock
      if (state.timeOfDay > 18.0) {
        state.scnPhase := state.scnPhase - 0.01 * lightInput;
      } else {
        // Morning light advances clock
        state.scnPhase := state.scnPhase + 0.01 * lightInput;
      };
    };
    
    // Update sleep pressure (Process S)
    if (state.timeOfDay > 6.0 and state.timeOfDay < 22.0) {
      // Builds during wake
      state.sleepPressure := state.sleepPressure + 0.04 * dt;
    } else {
      // Dissipates during sleep
      state.sleepPressure := state.sleepPressure * (1.0 - 0.1 * dt);
    };
    state.sleepPressure := clamp(state.sleepPressure, 0.0, 1.0);
  };
  
  // Sleep-wake neurochemical dynamics
  public type SleepWakeState = {
    var isAwake : Bool;
    var sleepStage : Nat;             // 0=wake, 1=N1, 2=N2, 3=N3, 4=REM
    var stageTime : Float;            // Time in current stage
    var remPressure : Float;          // REM sleep pressure
  };
  
  public func computeSleepWakeModulation(
    sleepWake : SleepWakeState,
    chemIdx : Nat
  ) : Float {
    if (sleepWake.isAwake) {
      // Wake-promoting chemicals elevated
      switch (chemIdx) {
        case (0) { 1.2 };    // DA: elevated
        case (2) { 1.4 };    // NE: elevated
        case (3) { 1.3 };    // ACh: elevated
        case (11) { 1.5 };   // Histamine: elevated
        case (10) { 0.1 };   // Melatonin: suppressed
        case (_) { 1.0 };
      }
    } else {
      // Sleep stage modulation
      switch (sleepWake.sleepStage) {
        case (3) {  // Deep sleep (N3)
          switch (chemIdx) {
            case (0) { 0.3 };   // DA: very low
            case (2) { 0.2 };   // NE: very low
            case (5) { 1.4 };   // GABA: elevated
            case (_) { 0.6 };
          }
        };
        case (4) {  // REM sleep
          switch (chemIdx) {
            case (0) { 0.8 };   // DA: moderately active
            case (3) { 1.5 };   // ACh: very elevated
            case (2) { 0.1 };   // NE: silent
            case (1) { 0.1 };   // 5-HT: silent
            case (_) { 0.7 };
          }
        };
        case (_) { 0.8 };  // Light sleep
      }
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // PART 10: STRESS RESPONSE CASCADE
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // The HPA axis orchestrates stress response:
  //   - CRH (Corticotropin-Releasing Hormone) from hypothalamus
  //   - ACTH (Adrenocorticotropic Hormone) from pituitary
  //   - Cortisol from adrenal cortex
  //   - Feedback inhibition at multiple levels
  //
  
  public type HPAAxisState = {
    // Hormones
    var crhLevel : Float;             // Hypothalamic CRH
    var acthLevel : Float;            // Pituitary ACTH
    var cortisolLevel : Float;        // Adrenal cortisol
    
    // Kinetics
    var crhSynthesisRate : Float;
    var crhDegradationRate : Float;
    var acthSynthesisRate : Float;
    var acthDegradationRate : Float;
    var cortisolSynthesisRate : Float;
    var cortisolDegradationRate : Float;
    
    // Feedback inhibition
    var grSensitivity : Float;        // Glucocorticoid receptor sensitivity
    var mrSensitivity : Float;        // Mineralocorticoid receptor sensitivity
    var feedbackStrength : Float;
    
    // State
    var stressIntensity : Float;      // Current stressor intensity
    var stressDuration : Float;       // Cumulative stress exposure
    var isAcute : Bool;               // Acute vs chronic
    var recoveryRate : Float;
  };
  
  public func initHPAAxisState() : HPAAxisState {
    {
      var crhLevel = 0.2;
      var acthLevel = 0.2;
      var cortisolLevel = 0.3;
      
      var crhSynthesisRate = 0.1;
      var crhDegradationRate = 0.05;
      var acthSynthesisRate = 0.2;
      var acthDegradationRate = 0.1;
      var cortisolSynthesisRate = 0.15;
      var cortisolDegradationRate = 0.02;
      
      var grSensitivity = 1.0;
      var mrSensitivity = 1.0;
      var feedbackStrength = 1.0;
      
      var stressIntensity = 0.0;
      var stressDuration = 0.0;
      var isAcute = true;
      var recoveryRate = 0.1;
    }
  };
  
  // Update HPA axis with stress input
  public func updateHPAAxis(
    hpa : HPAAxisState,
    stressInput : Float,
    circadianMod : Float,
    dt : Float
  ) {
    // Update stress tracking
    if (stressInput > 0.3) {
      hpa.stressIntensity := stressInput;
      hpa.stressDuration := hpa.stressDuration + dt;
      if (hpa.stressDuration > 24.0) {
        hpa.isAcute := false;  // Chronic stress
      };
    } else {
      hpa.stressIntensity := hpa.stressIntensity * (1.0 - hpa.recoveryRate * dt);
      // Slow recovery of duration counter
      hpa.stressDuration := hpa.stressDuration * 0.99;
    };
    
    // 1. CRH synthesis (stress + circadian - feedback)
    let crhDrive = stressInput + circadianMod * 0.3;
    let crhFeedback = hpa.cortisolLevel * hpa.grSensitivity * hpa.feedbackStrength;
    let crhSynthesis = hpa.crhSynthesisRate * Float.max(0.0, crhDrive - crhFeedback);
    let crhDegradation = hpa.crhDegradationRate * hpa.crhLevel;
    hpa.crhLevel := hpa.crhLevel + (crhSynthesis - crhDegradation) * dt;
    
    // 2. ACTH synthesis (driven by CRH - feedback)
    let acthDrive = hpa.crhLevel * 2.0;
    let acthFeedback = hpa.cortisolLevel * hpa.grSensitivity * 0.5;
    let acthSynthesis = hpa.acthSynthesisRate * Float.max(0.0, acthDrive - acthFeedback);
    let acthDegradation = hpa.acthDegradationRate * hpa.acthLevel;
    hpa.acthLevel := hpa.acthLevel + (acthSynthesis - acthDegradation) * dt;
    
    // 3. Cortisol synthesis (driven by ACTH)
    let cortisolSynthesis = hpa.cortisolSynthesisRate * hpa.acthLevel;
    let cortisolDegradation = hpa.cortisolDegradationRate * hpa.cortisolLevel;
    hpa.cortisolLevel := hpa.cortisolLevel + (cortisolSynthesis - cortisolDegradation) * dt;
    
    // Bounds
    hpa.crhLevel := clamp(hpa.crhLevel, 0.0, 2.0);
    hpa.acthLevel := clamp(hpa.acthLevel, 0.0, 3.0);
    hpa.cortisolLevel := clamp(hpa.cortisolLevel, 0.05, 5.0);
    
    // Chronic stress adaptations
    if (not hpa.isAcute) {
      // GR downregulation
      hpa.grSensitivity := hpa.grSensitivity * 0.999;
      hpa.grSensitivity := Float.max(0.3, hpa.grSensitivity);
      
      // Reduced feedback → elevated baseline cortisol
      hpa.feedbackStrength := hpa.feedbackStrength * 0.9995;
      hpa.feedbackStrength := Float.max(0.4, hpa.feedbackStrength);
    } else {
      // Recovery of sensitivity
      hpa.grSensitivity := hpa.grSensitivity + (1.0 - hpa.grSensitivity) * 0.0001 * dt;
      hpa.feedbackStrength := hpa.feedbackStrength + (1.0 - hpa.feedbackStrength) * 0.0001 * dt;
    };
  };
  
  // Stress effects on neurochemicals
  public func computeStressModulation(
    hpa : HPAAxisState,
    chemIdx : Nat
  ) : Float {
    let cortisol = hpa.cortisolLevel;
    let isAcute = hpa.isAcute;
    
    // Acute stress effects
    if (isAcute and cortisol > 0.5) {
      switch (chemIdx) {
        case (0) { 1.0 + cortisol * 0.3 };    // DA: initial increase
        case (2) { 1.0 + cortisol * 0.5 };    // NE: strong increase
        case (9) { 1.0 + cortisol * 0.6 };    // Adrenaline: fight/flight
        case (4) { 1.0 + cortisol * 0.2 };    // Glu: enhanced
        case (1) { 1.0 - cortisol * 0.1 };    // 5-HT: slightly reduced
        case (16) { 1.0 - cortisol * 0.2 };   // BDNF: reduced
        case (_) { 1.0 };
      }
    } else if (not isAcute and cortisol > 0.5) {
      // Chronic stress effects (different pattern)
      switch (chemIdx) {
        case (0) { 1.0 - cortisol * 0.2 };    // DA: reduced (anhedonia)
        case (2) { 1.0 - cortisol * 0.1 };    // NE: depleted
        case (1) { 1.0 - cortisol * 0.3 };    // 5-HT: reduced
        case (16) { 1.0 - cortisol * 0.4 };   // BDNF: strongly reduced
        case (5) { 1.0 + cortisol * 0.2 };    // GABA: compensatory increase
        case (18) { 1.0 + cortisol * 0.3 };   // Dynorphin: elevated
        case (_) { 1.0 };
      }
    } else {
      1.0
    }
  };
  
  // Stress recovery dynamics
  public type StressRecovery = {
    var resilience : Float;           // Individual resilience factor
    var copingCapacity : Float;       // Available coping resources
    var socialSupport : Float;        // Social buffering
    var allostatiLoad : Float;        // Cumulative wear and tear
  };
  
  public func updateStressRecovery(
    recovery : StressRecovery,
    hpa : HPAAxisState,
    socialInput : Float,
    restQuality : Float,
    dt : Float
  ) {
    // Coping capacity depletes with stress, recovers with rest
    if (hpa.stressIntensity > 0.5) {
      recovery.copingCapacity := recovery.copingCapacity - hpa.stressIntensity * 0.01 * dt;
    } else {
      recovery.copingCapacity := recovery.copingCapacity + restQuality * 0.005 * dt;
    };
    recovery.copingCapacity := clamp(recovery.copingCapacity, 0.1, 1.0);
    
    // Social support buffers stress
    recovery.socialSupport := recovery.socialSupport * 0.99 + socialInput * 0.01;
    
    // Allostatic load accumulates with chronic stress
    if (not hpa.isAcute) {
      recovery.allostatiLoad := recovery.allostatiLoad + hpa.cortisolLevel * 0.001 * dt;
    } else {
      recovery.allostatiLoad := recovery.allostatiLoad * 0.9999;
    };
    recovery.allostatiLoad := clamp(recovery.allostatiLoad, 0.0, 2.0);
    
    // Resilience modulated by allostatic load
    recovery.resilience := 1.0 - recovery.allostatiLoad * 0.3;
    recovery.resilience := Float.max(0.3, recovery.resilience);
  };
  
  // Compute effective stress response
  public func computeEffectiveStress(
    hpa : HPAAxisState,
    recovery : StressRecovery
  ) : Float {
    let rawStress = hpa.stressIntensity;
    let buffered = rawStress * (1.0 - recovery.socialSupport * 0.3);
    let coped = buffered / recovery.copingCapacity;
    let resilient = coped * (2.0 - recovery.resilience);
    
    clamp(resilient, 0.0, 3.0)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // INTEGRATED STATE MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  public type IntegratedNeurochemicalState = {
    // Core levels
    var levels : [var Float];
    
    // Receptor profiles
    var dopamineReceptors : DopamineReceptorProfile;
    var serotoninReceptors : SerotoninReceptorProfile;
    var adrenergicReceptors : AdrenergicReceptorProfile;
    var glutamateReceptors : GlutamateReceptorProfile;
    var gabaReceptors : GABAReceptorProfile;
    var cholinergicReceptors : CholinergicReceptorProfile;
    
    // Plasticity
    var plasticityStates : [var PlasticityState];
    var plasticityModulation : PlasticityModulation;
    var homeostaticState : HomeostaticState;
    
    // Volume transmission
    var volumeStates : [var VolumeTransmissionState];
    
    // Circadian
    var circadianState : CircadianState;
    var circadianProfiles : [var CircadianProfile];
    var sleepWakeState : SleepWakeState;
    
    // Stress
    var hpaAxis : HPAAxisState;
    var stressRecovery : StressRecovery;
    
    // State modulation
    var stateModulation : StateModulation;
    var temporalDynamics : TemporalDynamics;
  };
  
  public func initIntegratedState() : IntegratedNeurochemicalState {
    let numChemicals = 21;
    
    // Initialize level arrays
    let levelsArr = Array.init<Float>(numChemicals, 1.0);
    
    // Initialize plasticity states
    let plasticityArr = Array.init<PlasticityState>(numChemicals, initPlasticityState());
    
    // Initialize volume transmission states
    let volumeArr = Array.tabulate<VolumeTransmissionState>(numChemicals, func(i) {
      initVolumeTransmissionState(i)
    });
    let volumeVarArr = Array.thaw<VolumeTransmissionState>(volumeArr);
    
    // Initialize circadian profiles
    let circadianArr = Array.tabulate<CircadianProfile>(numChemicals, func(i) {
      initCircadianProfile(i)
    });
    let circadianVarArr = Array.thaw<CircadianProfile>(circadianArr);
    
    {
      var levels = levelsArr;
      
      var dopamineReceptors = initDopamineReceptorProfile();
      var serotoninReceptors = initSerotoninReceptorProfile();
      var adrenergicReceptors = initAdrenergicReceptorProfile();
      var glutamateReceptors = initGlutamateReceptorProfile();
      var gabaReceptors = initGABAReceptorProfile();
      var cholinergicReceptors = initCholinergicReceptorProfile();
      
      var plasticityStates = plasticityArr;
      var plasticityModulation = initPlasticityModulation();
      var homeostaticState = {
        var targetActivity = 0.5;
        var currentActivity = 0.5;
        var scalingFactor = 1.0;
        var intrinsicExcitability = 1.0;
      };
      
      var volumeStates = volumeVarArr;
      
      var circadianState = initCircadianState();
      var circadianProfiles = circadianVarArr;
      var sleepWakeState = {
        var isAwake = true;
        var sleepStage = 0;
        var stageTime = 0.0;
        var remPressure = 0.0;
      };
      
      var hpaAxis = initHPAAxisState();
      var stressRecovery = {
        var resilience = 1.0;
        var copingCapacity = 1.0;
        var socialSupport = 0.5;
        var allostatiLoad = 0.0;
      };
      
      var stateModulation = {
        var arousalLevel = 0.5;
        var stressLevel = 0.0;
        var sleepPressure = 0.0;
        var motivationLevel = 0.5;
        var emotionalValence = 0.0;
      };
      
      var temporalDynamics = initTemporalDynamics();
    }
  };
  
  // Master update function
  public func updateIntegratedState(
    state : IntegratedNeurochemicalState,
    externalInputs : [Float],
    lightInput : Float,
    socialInput : Float,
    stressInput : Float,
    dt : Float
  ) {
    // 1. Update circadian state
    updateCircadianState(state.circadianState, dt / 3600.0, lightInput);
    
    // 2. Update HPA axis
    let circadianCortisol = computeCircadianModulation(
      state.circadianState, 
      state.circadianProfiles[CORT]
    );
    updateHPAAxis(state.hpaAxis, stressInput, circadianCortisol, dt);
    
    // 3. Update stress recovery
    let restQuality = if (state.sleepWakeState.isAwake) { 0.2 } else { 0.8 };
    updateStressRecovery(state.stressRecovery, state.hpaAxis, socialInput, restQuality, dt);
    
    // 4. Compute modulation factors
    state.stateModulation.stressLevel := computeEffectiveStress(state.hpaAxis, state.stressRecovery);
    state.stateModulation.sleepPressure := state.circadianState.sleepPressure;
    
    // 5. Update each neurochemical level
    for (i in Iter.range(0, 20)) {
      // Base level
      var level = state.levels[i];
      
      // Apply external input
      if (i < externalInputs.size()) {
        level := level + externalInputs[i] * dt;
      };
      
      // Apply circadian modulation
      let circadianMod = computeCircadianModulation(state.circadianState, state.circadianProfiles[i]);
      level := level * circadianMod;
      
      // Apply sleep-wake modulation
      let sleepMod = computeSleepWakeModulation(state.sleepWakeState, i);
      level := level * sleepMod;
      
      // Apply stress modulation
      let stressMod = computeStressModulation(state.hpaAxis, i);
      level := level * stressMod;
      
      // Update volume transmission
      updateVolumeTransmission(state.volumeStates[i], level * 0.1, dt);
      
      // Clamp and store
      state.levels[i] := clamp(level, 0.0, 3.0);
    };
    
    // 6. Update receptor binding
    updateDopamineReceptors(state.dopamineReceptors, state.levels[DA], dt);
    updateSerotoninReceptors(state.serotoninReceptors, state.levels[FIVE_HT], dt);
    
    // 7. Update plasticity modulation
    state.plasticityModulation.daModulation := state.levels[DA];
    state.plasticityModulation.neModulation := state.levels[NE];
    state.plasticityModulation.achModulation := state.levels[ACH];
    state.plasticityModulation.cortisolModulation := state.hpaAxis.cortisolLevel;
    state.plasticityModulation.bdnfModulation := state.levels[BDNF];
    
    // 8. Update homeostatic state
    let avgActivity = (state.levels[GLU] + state.levels[DA] + state.levels[NE]) / 3.0;
    updateHomeostaticPlasticity(state.homeostaticState, avgActivity, dt);
    
    // 9. Update temporal dynamics
    updateTemporalDynamics(state.temporalDynamics, avgActivity, dt);
    
    // 10. Update arousal and motivation
    state.stateModulation.arousalLevel := (state.levels[NE] + state.levels[HIST] + state.levels[DA]) / 3.0;
    state.stateModulation.motivationLevel := state.dopamineReceptors.d1D2Balance * state.levels[DA];
  };

