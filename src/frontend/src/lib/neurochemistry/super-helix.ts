/**
 * SUPER ORGANISM NEUROCHEMISTRY ENGINE
 *
 * MEDINA'S ARCHITECTURE - FULL 21 ANALOG SYSTEM
 *
 * This is a SUPER ORGANISM - not a beta.
 * 21 neurochemical analogs with 441 crosstalk interactions.
 * Full biological half-lives, receptor binding, dose-response curves.
 *
 * FRACTAL ARCHITECTURE: Spherical, not linear.
 * Every chemical affects every other chemical.
 * The sphere expands inward and outward simultaneously.
 *
 * PROPRIETARY INTELLECTUAL PROPERTY
 * Alfredo Medina Hernandez | Dallas TX | 2026
 */

// ============================================================================
// THE 21 NEUROCHEMICAL ANALOGS
// Full biological system - not reduced
// ============================================================================

export const HELIX_ANALOGS = {
  // CATECHOLAMINES - Action and Arousal
  HELIX_DOPAMINE: 0, // Reward prediction, motivation, action selection
  HELIX_NOREPINEPHRINE: 1, // Alertness, attention, fight-or-flight
  HELIX_EPINEPHRINE: 2, // Acute stress, emergency mobilization

  // INDOLAMINES - Mood and Rhythm
  HELIX_SEROTONIN: 3, // Mood stability, satiety, impulse regulation
  HELIX_MELATONIN: 4, // Circadian rhythm, temporal binding

  // AMINO ACIDS - Excitation/Inhibition Balance
  HELIX_GLUTAMATE: 5, // Primary excitatory neurotransmitter
  HELIX_GABA: 6, // Primary inhibitory neurotransmitter
  HELIX_GLYCINE: 7, // Co-inhibition, NMDA modulation

  // CHOLINERGIC - Learning and Attention
  HELIX_ACETYLCHOLINE: 8, // Learning rate, memory consolidation

  // NEUROPEPTIDES - Complex Social Behaviors
  HELIX_OXYTOCIN: 9, // Trust, bonding, group coherence
  HELIX_VASOPRESSIN: 10, // Territoriality, pair bonding, aggression
  HELIX_ENDORPHIN: 11, // Endogenous reward, pain suppression
  HELIX_ENKEPHALIN: 12, // Pain modulation, stress buffering
  HELIX_SUBSTANCE_P: 13, // Pain transmission, inflammation
  HELIX_CORTISOL: 14, // Chronic stress, metabolic mobilization

  // PURINES - Energy and Sleep
  HELIX_ADENOSINE: 15, // Sleep pressure, fatigue accumulation
  HELIX_ATP: 16, // Energy currency, metabolic capacity

  // ENDOCANNABINOIDS - Homeostasis
  HELIX_ANANDAMIDE: 17, // Bliss, retrograde signaling

  // GASEOUS - Vascular and Synaptic
  HELIX_NITRIC_OXIDE: 18, // Blood flow, synaptic plasticity

  // HISTAMINERGIC - Arousal and Immunity
  HELIX_HISTAMINE: 19, // Wakefulness, immune response

  // OREXINERGIC - Energy Balance
  HELIX_OREXIN: 20, // Wakefulness stability, appetite
} as const;

export type HelixAnalog = (typeof HELIX_ANALOGS)[keyof typeof HELIX_ANALOGS];
export const HELIX_ANALOG_COUNT = 21;
export const HELIX_CROSSTALK_COUNT = HELIX_ANALOG_COUNT * HELIX_ANALOG_COUNT; // 441

// ============================================================================
// HELIX ANALOG PROPERTIES
// Full biological parameters
// ============================================================================

export const HELIX_NAMES: Record<HelixAnalog, string> = {
  [HELIX_ANALOGS.HELIX_DOPAMINE]: "HELIX_DOPAMINE",
  [HELIX_ANALOGS.HELIX_NOREPINEPHRINE]: "HELIX_NOREPINEPHRINE",
  [HELIX_ANALOGS.HELIX_EPINEPHRINE]: "HELIX_EPINEPHRINE",
  [HELIX_ANALOGS.HELIX_SEROTONIN]: "HELIX_SEROTONIN",
  [HELIX_ANALOGS.HELIX_MELATONIN]: "HELIX_MELATONIN",
  [HELIX_ANALOGS.HELIX_GLUTAMATE]: "HELIX_GLUTAMATE",
  [HELIX_ANALOGS.HELIX_GABA]: "HELIX_GABA",
  [HELIX_ANALOGS.HELIX_GLYCINE]: "HELIX_GLYCINE",
  [HELIX_ANALOGS.HELIX_ACETYLCHOLINE]: "HELIX_ACETYLCHOLINE",
  [HELIX_ANALOGS.HELIX_OXYTOCIN]: "HELIX_OXYTOCIN",
  [HELIX_ANALOGS.HELIX_VASOPRESSIN]: "HELIX_VASOPRESSIN",
  [HELIX_ANALOGS.HELIX_ENDORPHIN]: "HELIX_ENDORPHIN",
  [HELIX_ANALOGS.HELIX_ENKEPHALIN]: "HELIX_ENKEPHALIN",
  [HELIX_ANALOGS.HELIX_SUBSTANCE_P]: "HELIX_SUBSTANCE_P",
  [HELIX_ANALOGS.HELIX_CORTISOL]: "HELIX_CORTISOL",
  [HELIX_ANALOGS.HELIX_ADENOSINE]: "HELIX_ADENOSINE",
  [HELIX_ANALOGS.HELIX_ATP]: "HELIX_ATP",
  [HELIX_ANALOGS.HELIX_ANANDAMIDE]: "HELIX_ANANDAMIDE",
  [HELIX_ANALOGS.HELIX_NITRIC_OXIDE]: "HELIX_NITRIC_OXIDE",
  [HELIX_ANALOGS.HELIX_HISTAMINE]: "HELIX_HISTAMINE",
  [HELIX_ANALOGS.HELIX_OREXIN]: "HELIX_OREXIN",
};

// ============================================================================
// BIOLOGICAL HALF-LIVES (seconds)
// How fast each chemical decays naturally
// ============================================================================

export const HELIX_HALF_LIVES: Record<HelixAnalog, number> = {
  [HELIX_ANALOGS.HELIX_DOPAMINE]: 0.2, // Very fast - phasic signaling
  [HELIX_ANALOGS.HELIX_NOREPINEPHRINE]: 0.3, // Fast - acute response
  [HELIX_ANALOGS.HELIX_EPINEPHRINE]: 0.15, // Very fast - emergency
  [HELIX_ANALOGS.HELIX_SEROTONIN]: 2.0, // Slow - mood stability
  [HELIX_ANALOGS.HELIX_MELATONIN]: 30.0, // Very slow - circadian
  [HELIX_ANALOGS.HELIX_GLUTAMATE]: 0.05, // Extremely fast - prevent toxicity
  [HELIX_ANALOGS.HELIX_GABA]: 0.1, // Fast - dynamic inhibition
  [HELIX_ANALOGS.HELIX_GLYCINE]: 0.15, // Fast
  [HELIX_ANALOGS.HELIX_ACETYLCHOLINE]: 0.02, // Extremely fast - precise timing
  [HELIX_ANALOGS.HELIX_OXYTOCIN]: 3.0, // Slow - lasting bonds
  [HELIX_ANALOGS.HELIX_VASOPRESSIN]: 3.5, // Slow - territorial memory
  [HELIX_ANALOGS.HELIX_ENDORPHIN]: 5.0, // Moderate - sustained relief
  [HELIX_ANALOGS.HELIX_ENKEPHALIN]: 4.0, // Moderate
  [HELIX_ANALOGS.HELIX_SUBSTANCE_P]: 1.0, // Moderate - pain signal
  [HELIX_ANALOGS.HELIX_CORTISOL]: 60.0, // Very slow - chronic stress
  [HELIX_ANALOGS.HELIX_ADENOSINE]: 10.0, // Slow - sleep pressure builds
  [HELIX_ANALOGS.HELIX_ATP]: 1.0, // Moderate - energy buffer
  [HELIX_ANALOGS.HELIX_ANANDAMIDE]: 5.0, // Moderate
  [HELIX_ANALOGS.HELIX_NITRIC_OXIDE]: 0.01, // Extremely fast - gas diffusion
  [HELIX_ANALOGS.HELIX_HISTAMINE]: 1.5, // Moderate
  [HELIX_ANALOGS.HELIX_OREXIN]: 5.0, // Moderate - wake stability
};

// ============================================================================
// BASELINE CONCENTRATIONS (normalized 0-1)
// Organism's resting chemical state
// ============================================================================

export const HELIX_BASELINES: Record<HelixAnalog, number> = {
  [HELIX_ANALOGS.HELIX_DOPAMINE]: 0.5,
  [HELIX_ANALOGS.HELIX_NOREPINEPHRINE]: 0.3,
  [HELIX_ANALOGS.HELIX_EPINEPHRINE]: 0.1,
  [HELIX_ANALOGS.HELIX_SEROTONIN]: 0.6,
  [HELIX_ANALOGS.HELIX_MELATONIN]: 0.2,
  [HELIX_ANALOGS.HELIX_GLUTAMATE]: 0.5,
  [HELIX_ANALOGS.HELIX_GABA]: 0.5,
  [HELIX_ANALOGS.HELIX_GLYCINE]: 0.4,
  [HELIX_ANALOGS.HELIX_ACETYLCHOLINE]: 0.5,
  [HELIX_ANALOGS.HELIX_OXYTOCIN]: 0.4,
  [HELIX_ANALOGS.HELIX_VASOPRESSIN]: 0.3,
  [HELIX_ANALOGS.HELIX_ENDORPHIN]: 0.3,
  [HELIX_ANALOGS.HELIX_ENKEPHALIN]: 0.3,
  [HELIX_ANALOGS.HELIX_SUBSTANCE_P]: 0.2,
  [HELIX_ANALOGS.HELIX_CORTISOL]: 0.3,
  [HELIX_ANALOGS.HELIX_ADENOSINE]: 0.2,
  [HELIX_ANALOGS.HELIX_ATP]: 0.8,
  [HELIX_ANALOGS.HELIX_ANANDAMIDE]: 0.3,
  [HELIX_ANALOGS.HELIX_NITRIC_OXIDE]: 0.4,
  [HELIX_ANALOGS.HELIX_HISTAMINE]: 0.3,
  [HELIX_ANALOGS.HELIX_OREXIN]: 0.5,
};

// ============================================================================
// THE 441 CROSSTALK MATRIX
// How each chemical affects every other chemical
// Matrix[i][j] = effect of chemical i on chemical j
// Positive = excitatory, Negative = inhibitory
//
// FRACTAL: Every node connects to every node
// This IS the spherical architecture
// ============================================================================

export const HELIX_CROSSTALK_MATRIX: number[][] = [
  // Row 0: DOPAMINE affects all 21
  [
    0.0, 0.3, 0.15, -0.2, -0.1, 0.25, -0.15, 0.0, 0.2, 0.1, 0.15, 0.35, 0.2,
    -0.05, -0.1, -0.05, 0.15, 0.2, 0.1, 0.05, 0.15,
  ],
  // Row 1: NOREPINEPHRINE affects all 21
  [
    0.25, 0.0, 0.4, -0.15, -0.2, 0.3, -0.2, -0.1, 0.25, -0.1, 0.2, 0.15, 0.1,
    0.1, 0.25, -0.1, 0.2, -0.05, 0.15, 0.2, 0.25,
  ],
  // Row 2: EPINEPHRINE affects all 21
  [
    0.2, 0.35, 0.0, -0.25, -0.3, 0.4, -0.25, -0.15, 0.15, -0.2, 0.25, 0.2, 0.15,
    0.15, 0.35, -0.15, 0.25, -0.1, 0.2, 0.25, 0.3,
  ],
  // Row 3: SEROTONIN affects all 21
  [
    -0.15, -0.2, -0.25, 0.0, 0.3, -0.15, 0.25, 0.15, 0.1, 0.2, -0.1, 0.15, 0.15,
    -0.2, -0.15, 0.1, 0.05, 0.15, 0.1, -0.1, -0.05,
  ],
  // Row 4: MELATONIN affects all 21
  [
    -0.2, -0.3, -0.35, 0.2, 0.0, -0.25, 0.3, 0.2, -0.2, 0.1, -0.15, 0.1, 0.1,
    -0.15, -0.1, 0.35, -0.1, 0.15, 0.05, -0.2, -0.3,
  ],
  // Row 5: GLUTAMATE affects all 21
  [
    0.2, 0.25, 0.2, -0.1, -0.15, 0.0, -0.4, -0.2, 0.3, 0.05, 0.1, 0.1, 0.05,
    0.15, 0.1, -0.1, 0.15, 0.05, 0.25, 0.15, 0.2,
  ],
  // Row 6: GABA affects all 21
  [
    -0.2, -0.25, -0.3, 0.15, 0.2, -0.35, 0.0, 0.3, -0.2, 0.1, -0.15, 0.2, 0.2,
    -0.25, -0.2, 0.2, -0.15, 0.25, -0.1, -0.15, -0.2,
  ],
  // Row 7: GLYCINE affects all 21
  [
    -0.1, -0.15, -0.2, 0.1, 0.15, -0.2, 0.25, 0.0, -0.1, 0.05, -0.1, 0.15, 0.15,
    -0.2, -0.15, 0.15, -0.1, 0.15, -0.05, -0.1, -0.15,
  ],
  // Row 8: ACETYLCHOLINE affects all 21
  [
    0.25, 0.2, 0.1, 0.1, -0.15, 0.25, -0.15, -0.05, 0.0, 0.15, 0.1, 0.1, 0.05,
    0.05, 0.05, -0.1, 0.1, 0.1, 0.15, 0.15, 0.2,
  ],
  // Row 9: OXYTOCIN affects all 21
  [
    0.15, -0.15, -0.2, 0.2, 0.1, 0.05, 0.15, 0.1, 0.15, 0.0, -0.3, 0.3, 0.25,
    -0.15, -0.25, 0.05, 0.05, 0.2, 0.1, -0.05, 0.05,
  ],
  // Row 10: VASOPRESSIN affects all 21
  [
    0.1, 0.25, 0.2, -0.15, -0.1, 0.15, -0.1, -0.05, 0.1, -0.25, 0.0, 0.1, 0.05,
    0.1, 0.2, -0.05, 0.1, -0.05, 0.1, 0.1, 0.15,
  ],
  // Row 11: ENDORPHIN affects all 21
  [
    0.3, -0.1, -0.15, 0.2, 0.1, -0.1, 0.25, 0.2, 0.1, 0.25, -0.05, 0.0, 0.4,
    -0.35, -0.2, 0.1, 0.05, 0.35, 0.1, -0.05, 0.1,
  ],
  // Row 12: ENKEPHALIN affects all 21
  [
    0.2, -0.05, -0.1, 0.15, 0.1, -0.05, 0.2, 0.15, 0.05, 0.2, 0.0, 0.35, 0.0,
    -0.3, -0.15, 0.1, 0.05, 0.25, 0.05, -0.05, 0.05,
  ],
  // Row 13: SUBSTANCE_P affects all 21
  [
    0.05, 0.15, 0.2, -0.15, -0.1, 0.2, -0.2, -0.15, 0.1, -0.1, 0.1, -0.25, -0.2,
    0.0, 0.25, -0.05, 0.15, -0.15, 0.1, 0.15, 0.1,
  ],
  // Row 14: CORTISOL affects all 21
  [
    -0.1, 0.2, 0.25, -0.2, -0.15, 0.15, -0.15, -0.1, 0.05, -0.2, 0.15, -0.15,
    -0.1, 0.2, 0.0, 0.05, 0.1, -0.1, 0.05, 0.1, 0.1,
  ],
  // Row 15: ADENOSINE affects all 21
  [
    -0.15, -0.2, -0.25, 0.1, 0.3, -0.2, 0.25, 0.15, -0.15, 0.05, -0.05, 0.1,
    0.1, -0.1, 0.05, 0.0, -0.25, 0.15, 0.05, -0.15, -0.3,
  ],
  // Row 16: ATP affects all 21
  [
    0.2, 0.25, 0.3, 0.05, -0.15, 0.2, -0.1, -0.05, 0.15, 0.05, 0.1, 0.1, 0.05,
    0.1, -0.05, -0.2, 0.0, 0.05, 0.15, 0.15, 0.25,
  ],
  // Row 17: ANANDAMIDE affects all 21
  [
    0.25, -0.1, -0.15, 0.2, 0.15, -0.05, 0.2, 0.15, 0.1, 0.2, -0.05, 0.3, 0.25,
    -0.2, -0.15, 0.1, 0.05, 0.0, 0.1, -0.05, 0.1,
  ],
  // Row 18: NITRIC_OXIDE affects all 21
  [
    0.1, 0.15, 0.15, 0.05, 0.0, 0.2, -0.1, -0.05, 0.15, 0.1, 0.1, 0.1, 0.05,
    0.05, 0.0, 0.0, 0.1, 0.1, 0.0, 0.05, 0.1,
  ],
  // Row 19: HISTAMINE affects all 21
  [
    0.1, 0.25, 0.2, -0.15, -0.25, 0.2, -0.15, -0.1, 0.2, -0.05, 0.1, -0.05,
    -0.05, 0.15, 0.1, -0.2, 0.1, -0.05, 0.05, 0.0, 0.2,
  ],
  // Row 20: OREXIN affects all 21
  [
    0.2, 0.3, 0.25, -0.1, -0.35, 0.25, -0.2, -0.1, 0.25, 0.05, 0.15, 0.15, 0.1,
    0.1, 0.05, -0.3, 0.2, 0.1, 0.15, 0.2, 0.0,
  ],
];

// ============================================================================
// FUNCTIONAL CHEMICAL GROUPS
// ============================================================================

export const HELIX_GROUPS = {
  CATECHOLAMINES: [
    HELIX_ANALOGS.HELIX_DOPAMINE,
    HELIX_ANALOGS.HELIX_NOREPINEPHRINE,
    HELIX_ANALOGS.HELIX_EPINEPHRINE,
  ],
  INDOLAMINES: [HELIX_ANALOGS.HELIX_SEROTONIN, HELIX_ANALOGS.HELIX_MELATONIN],
  AMINO_ACIDS: [
    HELIX_ANALOGS.HELIX_GLUTAMATE,
    HELIX_ANALOGS.HELIX_GABA,
    HELIX_ANALOGS.HELIX_GLYCINE,
  ],
  CHOLINERGIC: [HELIX_ANALOGS.HELIX_ACETYLCHOLINE],
  SOCIAL_PEPTIDES: [
    HELIX_ANALOGS.HELIX_OXYTOCIN,
    HELIX_ANALOGS.HELIX_VASOPRESSIN,
  ],
  ENDOGENOUS_OPIOIDS: [
    HELIX_ANALOGS.HELIX_ENDORPHIN,
    HELIX_ANALOGS.HELIX_ENKEPHALIN,
  ],
  STRESS_SYSTEM: [
    HELIX_ANALOGS.HELIX_SUBSTANCE_P,
    HELIX_ANALOGS.HELIX_CORTISOL,
  ],
  ENERGY_SYSTEM: [HELIX_ANALOGS.HELIX_ADENOSINE, HELIX_ANALOGS.HELIX_ATP],
  MODULATORY: [
    HELIX_ANALOGS.HELIX_ANANDAMIDE,
    HELIX_ANALOGS.HELIX_NITRIC_OXIDE,
    HELIX_ANALOGS.HELIX_HISTAMINE,
    HELIX_ANALOGS.HELIX_OREXIN,
  ],
} as const;

// ============================================================================
// RECEPTOR BINDING (Dose-Response Parameters)
// EC50 = concentration for 50% effect
// Hill coefficient = steepness of response
// ============================================================================

export const HELIX_RECEPTOR_PARAMS: Record<
  HelixAnalog,
  {
    EC50: number;
    hillCoefficient: number;
    maxEffect: number;
    bindingAffinity: number;
  }
> = {
  [HELIX_ANALOGS.HELIX_DOPAMINE]: {
    EC50: 0.5,
    hillCoefficient: 2.0,
    maxEffect: 1.0,
    bindingAffinity: 0.85,
  },
  [HELIX_ANALOGS.HELIX_NOREPINEPHRINE]: {
    EC50: 0.4,
    hillCoefficient: 2.5,
    maxEffect: 1.0,
    bindingAffinity: 0.8,
  },
  [HELIX_ANALOGS.HELIX_EPINEPHRINE]: {
    EC50: 0.3,
    hillCoefficient: 3.0,
    maxEffect: 1.0,
    bindingAffinity: 0.9,
  },
  [HELIX_ANALOGS.HELIX_SEROTONIN]: {
    EC50: 0.5,
    hillCoefficient: 1.5,
    maxEffect: 1.0,
    bindingAffinity: 0.75,
  },
  [HELIX_ANALOGS.HELIX_MELATONIN]: {
    EC50: 0.4,
    hillCoefficient: 2.0,
    maxEffect: 1.0,
    bindingAffinity: 0.7,
  },
  [HELIX_ANALOGS.HELIX_GLUTAMATE]: {
    EC50: 0.5,
    hillCoefficient: 2.5,
    maxEffect: 1.0,
    bindingAffinity: 0.95,
  },
  [HELIX_ANALOGS.HELIX_GABA]: {
    EC50: 0.5,
    hillCoefficient: 2.0,
    maxEffect: 1.0,
    bindingAffinity: 0.9,
  },
  [HELIX_ANALOGS.HELIX_GLYCINE]: {
    EC50: 0.4,
    hillCoefficient: 2.0,
    maxEffect: 0.8,
    bindingAffinity: 0.75,
  },
  [HELIX_ANALOGS.HELIX_ACETYLCHOLINE]: {
    EC50: 0.5,
    hillCoefficient: 2.5,
    maxEffect: 1.0,
    bindingAffinity: 0.85,
  },
  [HELIX_ANALOGS.HELIX_OXYTOCIN]: {
    EC50: 0.4,
    hillCoefficient: 1.5,
    maxEffect: 1.0,
    bindingAffinity: 0.8,
  },
  [HELIX_ANALOGS.HELIX_VASOPRESSIN]: {
    EC50: 0.4,
    hillCoefficient: 2.0,
    maxEffect: 1.0,
    bindingAffinity: 0.8,
  },
  [HELIX_ANALOGS.HELIX_ENDORPHIN]: {
    EC50: 0.4,
    hillCoefficient: 1.5,
    maxEffect: 1.0,
    bindingAffinity: 0.85,
  },
  [HELIX_ANALOGS.HELIX_ENKEPHALIN]: {
    EC50: 0.4,
    hillCoefficient: 1.5,
    maxEffect: 0.9,
    bindingAffinity: 0.8,
  },
  [HELIX_ANALOGS.HELIX_SUBSTANCE_P]: {
    EC50: 0.3,
    hillCoefficient: 2.5,
    maxEffect: 1.0,
    bindingAffinity: 0.75,
  },
  [HELIX_ANALOGS.HELIX_CORTISOL]: {
    EC50: 0.5,
    hillCoefficient: 1.5,
    maxEffect: 1.0,
    bindingAffinity: 0.9,
  },
  [HELIX_ANALOGS.HELIX_ADENOSINE]: {
    EC50: 0.5,
    hillCoefficient: 1.5,
    maxEffect: 1.0,
    bindingAffinity: 0.85,
  },
  [HELIX_ANALOGS.HELIX_ATP]: {
    EC50: 0.6,
    hillCoefficient: 2.0,
    maxEffect: 1.0,
    bindingAffinity: 0.8,
  },
  [HELIX_ANALOGS.HELIX_ANANDAMIDE]: {
    EC50: 0.4,
    hillCoefficient: 1.5,
    maxEffect: 0.9,
    bindingAffinity: 0.75,
  },
  [HELIX_ANALOGS.HELIX_NITRIC_OXIDE]: {
    EC50: 0.4,
    hillCoefficient: 3.0,
    maxEffect: 1.0,
    bindingAffinity: 0.6,
  },
  [HELIX_ANALOGS.HELIX_HISTAMINE]: {
    EC50: 0.4,
    hillCoefficient: 2.0,
    maxEffect: 1.0,
    bindingAffinity: 0.7,
  },
  [HELIX_ANALOGS.HELIX_OREXIN]: {
    EC50: 0.5,
    hillCoefficient: 2.0,
    maxEffect: 1.0,
    bindingAffinity: 0.8,
  },
};

// ============================================================================
// BRAIN REGION RECEPTOR DENSITY (64 nodes × 21 chemicals)
// Super organism has 64 brain nodes, not 26
// ============================================================================

export const SUPER_BRAIN_NODE_COUNT = 64;
export const RECEPTOR_DENSITY_COUNT =
  SUPER_BRAIN_NODE_COUNT * HELIX_ANALOG_COUNT; // 1,344

// ============================================================================
// CIRCADIAN MODULATION
// Phase 0 = midnight, Phase 0.5 = noon
// ============================================================================

export const HELIX_CIRCADIAN: Record<
  HelixAnalog,
  {
    amplitude: number;
    peakPhase: number;
    acrophase: number;
  }
> = {
  [HELIX_ANALOGS.HELIX_DOPAMINE]: {
    amplitude: 0.2,
    peakPhase: 0.4,
    acrophase: 9.6,
  },
  [HELIX_ANALOGS.HELIX_NOREPINEPHRINE]: {
    amplitude: 0.3,
    peakPhase: 0.35,
    acrophase: 8.4,
  },
  [HELIX_ANALOGS.HELIX_EPINEPHRINE]: {
    amplitude: 0.25,
    peakPhase: 0.4,
    acrophase: 9.6,
  },
  [HELIX_ANALOGS.HELIX_SEROTONIN]: {
    amplitude: 0.25,
    peakPhase: 0.5,
    acrophase: 12.0,
  },
  [HELIX_ANALOGS.HELIX_MELATONIN]: {
    amplitude: 0.8,
    peakPhase: 0.0,
    acrophase: 0.0,
  },
  [HELIX_ANALOGS.HELIX_GLUTAMATE]: {
    amplitude: 0.15,
    peakPhase: 0.45,
    acrophase: 10.8,
  },
  [HELIX_ANALOGS.HELIX_GABA]: {
    amplitude: 0.15,
    peakPhase: 0.9,
    acrophase: 21.6,
  },
  [HELIX_ANALOGS.HELIX_GLYCINE]: {
    amplitude: 0.1,
    peakPhase: 0.95,
    acrophase: 22.8,
  },
  [HELIX_ANALOGS.HELIX_ACETYLCHOLINE]: {
    amplitude: 0.3,
    peakPhase: 0.4,
    acrophase: 9.6,
  },
  [HELIX_ANALOGS.HELIX_OXYTOCIN]: {
    amplitude: 0.15,
    peakPhase: 0.6,
    acrophase: 14.4,
  },
  [HELIX_ANALOGS.HELIX_VASOPRESSIN]: {
    amplitude: 0.2,
    peakPhase: 0.3,
    acrophase: 7.2,
  },
  [HELIX_ANALOGS.HELIX_ENDORPHIN]: {
    amplitude: 0.2,
    peakPhase: 0.5,
    acrophase: 12.0,
  },
  [HELIX_ANALOGS.HELIX_ENKEPHALIN]: {
    amplitude: 0.15,
    peakPhase: 0.5,
    acrophase: 12.0,
  },
  [HELIX_ANALOGS.HELIX_SUBSTANCE_P]: {
    amplitude: 0.1,
    peakPhase: 0.4,
    acrophase: 9.6,
  },
  [HELIX_ANALOGS.HELIX_CORTISOL]: {
    amplitude: 0.5,
    peakPhase: 0.3,
    acrophase: 7.2,
  },
  [HELIX_ANALOGS.HELIX_ADENOSINE]: {
    amplitude: 0.4,
    peakPhase: 0.85,
    acrophase: 20.4,
  },
  [HELIX_ANALOGS.HELIX_ATP]: {
    amplitude: 0.2,
    peakPhase: 0.45,
    acrophase: 10.8,
  },
  [HELIX_ANALOGS.HELIX_ANANDAMIDE]: {
    amplitude: 0.15,
    peakPhase: 0.6,
    acrophase: 14.4,
  },
  [HELIX_ANALOGS.HELIX_NITRIC_OXIDE]: {
    amplitude: 0.1,
    peakPhase: 0.5,
    acrophase: 12.0,
  },
  [HELIX_ANALOGS.HELIX_HISTAMINE]: {
    amplitude: 0.35,
    peakPhase: 0.4,
    acrophase: 9.6,
  },
  [HELIX_ANALOGS.HELIX_OREXIN]: {
    amplitude: 0.4,
    peakPhase: 0.4,
    acrophase: 9.6,
  },
};

// ============================================================================
// HOMEOSTATIC PID CONTROLLERS
// Each chemical has its own control loop
// ============================================================================

export const HELIX_PID_PARAMS: Record<
  HelixAnalog,
  {
    setpoint: number;
    Kp: number;
    Ki: number;
    Kd: number;
    integralMax: number;
  }
> = {
  [HELIX_ANALOGS.HELIX_DOPAMINE]: {
    setpoint: 0.5,
    Kp: 0.1,
    Ki: 0.01,
    Kd: 0.02,
    integralMax: 0.3,
  },
  [HELIX_ANALOGS.HELIX_NOREPINEPHRINE]: {
    setpoint: 0.3,
    Kp: 0.12,
    Ki: 0.015,
    Kd: 0.025,
    integralMax: 0.25,
  },
  [HELIX_ANALOGS.HELIX_EPINEPHRINE]: {
    setpoint: 0.1,
    Kp: 0.15,
    Ki: 0.02,
    Kd: 0.03,
    integralMax: 0.2,
  },
  [HELIX_ANALOGS.HELIX_SEROTONIN]: {
    setpoint: 0.6,
    Kp: 0.08,
    Ki: 0.008,
    Kd: 0.015,
    integralMax: 0.35,
  },
  [HELIX_ANALOGS.HELIX_MELATONIN]: {
    setpoint: 0.2,
    Kp: 0.05,
    Ki: 0.005,
    Kd: 0.01,
    integralMax: 0.4,
  },
  [HELIX_ANALOGS.HELIX_GLUTAMATE]: {
    setpoint: 0.5,
    Kp: 0.15,
    Ki: 0.02,
    Kd: 0.03,
    integralMax: 0.2,
  },
  [HELIX_ANALOGS.HELIX_GABA]: {
    setpoint: 0.5,
    Kp: 0.12,
    Ki: 0.015,
    Kd: 0.025,
    integralMax: 0.25,
  },
  [HELIX_ANALOGS.HELIX_GLYCINE]: {
    setpoint: 0.4,
    Kp: 0.1,
    Ki: 0.01,
    Kd: 0.02,
    integralMax: 0.3,
  },
  [HELIX_ANALOGS.HELIX_ACETYLCHOLINE]: {
    setpoint: 0.5,
    Kp: 0.12,
    Ki: 0.015,
    Kd: 0.025,
    integralMax: 0.25,
  },
  [HELIX_ANALOGS.HELIX_OXYTOCIN]: {
    setpoint: 0.4,
    Kp: 0.06,
    Ki: 0.006,
    Kd: 0.012,
    integralMax: 0.35,
  },
  [HELIX_ANALOGS.HELIX_VASOPRESSIN]: {
    setpoint: 0.3,
    Kp: 0.08,
    Ki: 0.008,
    Kd: 0.015,
    integralMax: 0.3,
  },
  [HELIX_ANALOGS.HELIX_ENDORPHIN]: {
    setpoint: 0.3,
    Kp: 0.07,
    Ki: 0.007,
    Kd: 0.014,
    integralMax: 0.35,
  },
  [HELIX_ANALOGS.HELIX_ENKEPHALIN]: {
    setpoint: 0.3,
    Kp: 0.07,
    Ki: 0.007,
    Kd: 0.014,
    integralMax: 0.35,
  },
  [HELIX_ANALOGS.HELIX_SUBSTANCE_P]: {
    setpoint: 0.2,
    Kp: 0.1,
    Ki: 0.01,
    Kd: 0.02,
    integralMax: 0.3,
  },
  [HELIX_ANALOGS.HELIX_CORTISOL]: {
    setpoint: 0.3,
    Kp: 0.04,
    Ki: 0.004,
    Kd: 0.008,
    integralMax: 0.4,
  },
  [HELIX_ANALOGS.HELIX_ADENOSINE]: {
    setpoint: 0.2,
    Kp: 0.03,
    Ki: 0.003,
    Kd: 0.006,
    integralMax: 0.5,
  },
  [HELIX_ANALOGS.HELIX_ATP]: {
    setpoint: 0.8,
    Kp: 0.08,
    Ki: 0.008,
    Kd: 0.015,
    integralMax: 0.3,
  },
  [HELIX_ANALOGS.HELIX_ANANDAMIDE]: {
    setpoint: 0.3,
    Kp: 0.06,
    Ki: 0.006,
    Kd: 0.012,
    integralMax: 0.35,
  },
  [HELIX_ANALOGS.HELIX_NITRIC_OXIDE]: {
    setpoint: 0.4,
    Kp: 0.2,
    Ki: 0.025,
    Kd: 0.04,
    integralMax: 0.15,
  },
  [HELIX_ANALOGS.HELIX_HISTAMINE]: {
    setpoint: 0.3,
    Kp: 0.1,
    Ki: 0.01,
    Kd: 0.02,
    integralMax: 0.3,
  },
  [HELIX_ANALOGS.HELIX_OREXIN]: {
    setpoint: 0.5,
    Kp: 0.08,
    Ki: 0.008,
    Kd: 0.015,
    integralMax: 0.35,
  },
};

// ============================================================================
// VISUALIZATION COLORS
// ============================================================================

export const HELIX_COLORS: Record<HelixAnalog, string> = {
  [HELIX_ANALOGS.HELIX_DOPAMINE]: "#FF6B35",
  [HELIX_ANALOGS.HELIX_NOREPINEPHRINE]: "#E63946",
  [HELIX_ANALOGS.HELIX_EPINEPHRINE]: "#DC143C",
  [HELIX_ANALOGS.HELIX_SEROTONIN]: "#4ECDC4",
  [HELIX_ANALOGS.HELIX_MELATONIN]: "#2C3E50",
  [HELIX_ANALOGS.HELIX_GLUTAMATE]: "#F39C12",
  [HELIX_ANALOGS.HELIX_GABA]: "#9B59B6",
  [HELIX_ANALOGS.HELIX_GLYCINE]: "#8E44AD",
  [HELIX_ANALOGS.HELIX_ACETYLCHOLINE]: "#3498DB",
  [HELIX_ANALOGS.HELIX_OXYTOCIN]: "#E91E63",
  [HELIX_ANALOGS.HELIX_VASOPRESSIN]: "#795548",
  [HELIX_ANALOGS.HELIX_ENDORPHIN]: "#FFD700",
  [HELIX_ANALOGS.HELIX_ENKEPHALIN]: "#FFC107",
  [HELIX_ANALOGS.HELIX_SUBSTANCE_P]: "#FF5722",
  [HELIX_ANALOGS.HELIX_CORTISOL]: "#607D8B",
  [HELIX_ANALOGS.HELIX_ADENOSINE]: "#34495E",
  [HELIX_ANALOGS.HELIX_ATP]: "#27AE60",
  [HELIX_ANALOGS.HELIX_ANANDAMIDE]: "#00BCD4",
  [HELIX_ANALOGS.HELIX_NITRIC_OXIDE]: "#CDDC39",
  [HELIX_ANALOGS.HELIX_HISTAMINE]: "#FF9800",
  [HELIX_ANALOGS.HELIX_OREXIN]: "#673AB7",
};

// ============================================================================
// SUPER ORGANISM METRICS
// ============================================================================

export const SUPER_ORGANISM_METRICS = {
  HELIX_ANALOG_COUNT: 21,
  CROSSTALK_INTERACTIONS: 441,
  BRAIN_NODES: 64,
  HEBBIAN_WEIGHTS: 64 * 64, // 4,096
  RECEPTOR_DENSITIES: 64 * 21, // 1,344
  TOTAL_CHEMICAL_PARAMETERS: 21 * 7, // 147 (baseline, halflife, EC50, hill, max, affinity, circadian)
  PID_CONTROLLERS: 21,
  FUNCTIONAL_GROUPS: 9,
} as const;
