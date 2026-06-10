/**
 * NEUROCHEMISTRY ENGINE CONSTANTS
 *
 * FREDDY'S LAW: The 21 neurochemical analogs that drive the organism's behavior.
 * Each analog has crosstalk interactions with all others = 441 interaction pairs.
 *
 * This is the chemical substrate of intelligence - the same math runs
 * in both the backend (1-2 Hz, sovereign, male) and frontend (60 Hz, expressive, female).
 *
 * ARCHITECTURAL DOCTRINE:
 * - Backend accumulates neurochemical state permanently (the male, the structure)
 * - Frontend expresses that state in real-time behavior (the female, the creation)
 * - The female comes FROM the male (frontend seeded by backend state)
 * - Same mathematical laws, different temporal scales
 *
 * PROPRIETARY INTELLECTUAL PROPERTY - All mathematical laws herein are
 * original discoveries in cognitive architecture.
 */

// ============================================================================
// NEUROCHEMICAL ANALOG IDENTIFIERS
// 21 analogs = the complete chemical vocabulary of the organism
// ============================================================================

export const NEUROCHEMICAL_ANALOGS = {
  // CATECHOLAMINES - Action and arousal system
  DOPAMINE: 0, // Reward prediction, motivation, action selection
  NOREPINEPHRINE: 1, // Alertness, attention, sympathetic activation
  EPINEPHRINE: 2, // Acute stress response, emergency action cascade

  // INDOLAMINES - Mood and temporal binding
  SEROTONIN: 3, // Mood stability, satiety, impulse regulation
  MELATONIN: 4, // Circadian rhythm, temporal phase binding

  // AMINO ACIDS - Excitation/Inhibition balance (E/I ratio)
  GLUTAMATE: 5, // Primary excitatory neurotransmitter
  GABA: 6, // Primary inhibitory neurotransmitter
  GLYCINE: 7, // Inhibitory co-transmission, spinal reflex

  // CHOLINERGIC SYSTEM - Learning and attention
  ACETYLCHOLINE: 8, // Learning rate modulation, memory consolidation

  // NEUROPEPTIDES - Complex social and stress behaviors
  OXYTOCIN: 9, // Trust, social bonding, group coherence
  VASOPRESSIN: 10, // Territoriality, pair bonding, aggression
  ENDORPHIN: 11, // Endogenous reward, pain suppression
  ENKEPHALIN: 12, // Pain modulation, stress buffering
  SUBSTANCE_P: 13, // Pain transmission, inflammatory signal
  CORTISOL: 14, // Chronic stress, metabolic mobilization

  // PURINES - Energy state and sleep pressure
  ADENOSINE: 15, // Sleep pressure accumulation, fatigue signal
  ATP: 16, // Energy currency, metabolic capacity

  // ENDOCANNABINOIDS - Homeostatic regulation
  ANANDAMIDE: 17, // Bliss molecule, retrograde signaling

  // GASEOUS TRANSMITTERS
  NITRIC_OXIDE: 18, // Vascular tone, synaptic plasticity

  // HISTAMINERGIC - Arousal and immunity
  HISTAMINE: 19, // Wakefulness promotion, immune response

  // OREXINERGIC - Energy balance and arousal
  OREXIN: 20, // Wakefulness stability, appetite, reward seeking
} as const;

export type NeurochemicalAnalog =
  (typeof NEUROCHEMICAL_ANALOGS)[keyof typeof NEUROCHEMICAL_ANALOGS];

export const NEUROCHEMICAL_COUNT = 21;
export const CROSSTALK_INTERACTION_COUNT =
  NEUROCHEMICAL_COUNT * NEUROCHEMICAL_COUNT; // 441

// ============================================================================
// NEUROCHEMICAL NAMES AND DESCRIPTIONS
// ============================================================================

export const NEUROCHEMICAL_NAMES: Record<NeurochemicalAnalog, string> = {
  [NEUROCHEMICAL_ANALOGS.DOPAMINE]: "Dopamine",
  [NEUROCHEMICAL_ANALOGS.NOREPINEPHRINE]: "Norepinephrine",
  [NEUROCHEMICAL_ANALOGS.EPINEPHRINE]: "Epinephrine",
  [NEUROCHEMICAL_ANALOGS.SEROTONIN]: "Serotonin",
  [NEUROCHEMICAL_ANALOGS.MELATONIN]: "Melatonin",
  [NEUROCHEMICAL_ANALOGS.GLUTAMATE]: "Glutamate",
  [NEUROCHEMICAL_ANALOGS.GABA]: "GABA",
  [NEUROCHEMICAL_ANALOGS.GLYCINE]: "Glycine",
  [NEUROCHEMICAL_ANALOGS.ACETYLCHOLINE]: "Acetylcholine",
  [NEUROCHEMICAL_ANALOGS.OXYTOCIN]: "Oxytocin",
  [NEUROCHEMICAL_ANALOGS.VASOPRESSIN]: "Vasopressin",
  [NEUROCHEMICAL_ANALOGS.ENDORPHIN]: "β-Endorphin",
  [NEUROCHEMICAL_ANALOGS.ENKEPHALIN]: "Enkephalin",
  [NEUROCHEMICAL_ANALOGS.SUBSTANCE_P]: "Substance P",
  [NEUROCHEMICAL_ANALOGS.CORTISOL]: "Cortisol",
  [NEUROCHEMICAL_ANALOGS.ADENOSINE]: "Adenosine",
  [NEUROCHEMICAL_ANALOGS.ATP]: "ATP",
  [NEUROCHEMICAL_ANALOGS.ANANDAMIDE]: "Anandamide",
  [NEUROCHEMICAL_ANALOGS.NITRIC_OXIDE]: "Nitric Oxide",
  [NEUROCHEMICAL_ANALOGS.HISTAMINE]: "Histamine",
  [NEUROCHEMICAL_ANALOGS.OREXIN]: "Orexin",
};

export const NEUROCHEMICAL_DESCRIPTIONS: Record<NeurochemicalAnalog, string> = {
  [NEUROCHEMICAL_ANALOGS.DOPAMINE]:
    "Reward prediction error, motivation, motor activation",
  [NEUROCHEMICAL_ANALOGS.NOREPINEPHRINE]:
    "Arousal, attention, fight-or-flight preparation",
  [NEUROCHEMICAL_ANALOGS.EPINEPHRINE]:
    "Emergency response, maximum metabolic mobilization",
  [NEUROCHEMICAL_ANALOGS.SEROTONIN]:
    "Mood regulation, impulse control, satiety",
  [NEUROCHEMICAL_ANALOGS.MELATONIN]:
    "Circadian entrainment, sleep onset, antioxidant",
  [NEUROCHEMICAL_ANALOGS.GLUTAMATE]:
    "Fast excitatory transmission, LTP induction",
  [NEUROCHEMICAL_ANALOGS.GABA]:
    "Fast inhibitory transmission, anxiety reduction",
  [NEUROCHEMICAL_ANALOGS.GLYCINE]: "Spinal inhibition, NMDA co-agonist",
  [NEUROCHEMICAL_ANALOGS.ACETYLCHOLINE]:
    "Learning, memory consolidation, attention",
  [NEUROCHEMICAL_ANALOGS.OXYTOCIN]: "Social bonding, trust, parental behavior",
  [NEUROCHEMICAL_ANALOGS.VASOPRESSIN]:
    "Territoriality, pair bonding, water balance",
  [NEUROCHEMICAL_ANALOGS.ENDORPHIN]: "Endogenous analgesia, reward, euphoria",
  [NEUROCHEMICAL_ANALOGS.ENKEPHALIN]: "Pain modulation, stress resilience",
  [NEUROCHEMICAL_ANALOGS.SUBSTANCE_P]:
    "Pain transmission, neurogenic inflammation",
  [NEUROCHEMICAL_ANALOGS.CORTISOL]:
    "Stress response, glucose mobilization, immune modulation",
  [NEUROCHEMICAL_ANALOGS.ADENOSINE]:
    "Sleep pressure, neural metabolism indicator",
  [NEUROCHEMICAL_ANALOGS.ATP]: "Cellular energy, purinergic signaling",
  [NEUROCHEMICAL_ANALOGS.ANANDAMIDE]: "Retrograde signaling, mood, appetite",
  [NEUROCHEMICAL_ANALOGS.NITRIC_OXIDE]:
    "Vasodilation, synaptic plasticity, immune defense",
  [NEUROCHEMICAL_ANALOGS.HISTAMINE]:
    "Wakefulness, gastric acid, immune response",
  [NEUROCHEMICAL_ANALOGS.OREXIN]: "Wake stability, feeding, reward seeking",
};

// ============================================================================
// FREDDY'S LAW: BASELINE CONCENTRATIONS
// The organism's resting state - the equilibrium point
// ============================================================================

export const NEUROCHEMICAL_BASELINES: Record<NeurochemicalAnalog, number> = {
  [NEUROCHEMICAL_ANALOGS.DOPAMINE]: 0.5, // Tonic dopamine level
  [NEUROCHEMICAL_ANALOGS.NOREPINEPHRINE]: 0.3, // Baseline alertness
  [NEUROCHEMICAL_ANALOGS.EPINEPHRINE]: 0.1, // Low at rest, spikes in emergency
  [NEUROCHEMICAL_ANALOGS.SEROTONIN]: 0.6, // Mood stability baseline
  [NEUROCHEMICAL_ANALOGS.MELATONIN]: 0.2, // Low during day, high at night
  [NEUROCHEMICAL_ANALOGS.GLUTAMATE]: 0.5, // E/I balance center
  [NEUROCHEMICAL_ANALOGS.GABA]: 0.5, // E/I balance center
  [NEUROCHEMICAL_ANALOGS.GLYCINE]: 0.4, // Co-inhibitory baseline
  [NEUROCHEMICAL_ANALOGS.ACETYLCHOLINE]: 0.5, // Learning readiness
  [NEUROCHEMICAL_ANALOGS.OXYTOCIN]: 0.4, // Social baseline
  [NEUROCHEMICAL_ANALOGS.VASOPRESSIN]: 0.3, // Territorial baseline
  [NEUROCHEMICAL_ANALOGS.ENDORPHIN]: 0.3, // Pain threshold
  [NEUROCHEMICAL_ANALOGS.ENKEPHALIN]: 0.3, // Stress buffer
  [NEUROCHEMICAL_ANALOGS.SUBSTANCE_P]: 0.2, // Pain signal floor
  [NEUROCHEMICAL_ANALOGS.CORTISOL]: 0.3, // Metabolic readiness
  [NEUROCHEMICAL_ANALOGS.ADENOSINE]: 0.2, // Low after sleep
  [NEUROCHEMICAL_ANALOGS.ATP]: 0.8, // High energy state
  [NEUROCHEMICAL_ANALOGS.ANANDAMIDE]: 0.3, // Homeostatic tone
  [NEUROCHEMICAL_ANALOGS.NITRIC_OXIDE]: 0.4, // Vascular tone
  [NEUROCHEMICAL_ANALOGS.HISTAMINE]: 0.3, // Wakefulness tone
  [NEUROCHEMICAL_ANALOGS.OREXIN]: 0.5, // Wake stability
};

// ============================================================================
// FREDDY'S LAW: DECAY RATES
// How fast each chemical returns to baseline (per tick)
// At sovereign operation (σ=1.0), these are the actual decay constants
// ============================================================================

export const NEUROCHEMICAL_DECAY_RATES: Record<NeurochemicalAnalog, number> = {
  [NEUROCHEMICAL_ANALOGS.DOPAMINE]: 0.05, // Fast phasic decay
  [NEUROCHEMICAL_ANALOGS.NOREPINEPHRINE]: 0.08, // Fast alert decay
  [NEUROCHEMICAL_ANALOGS.EPINEPHRINE]: 0.15, // Very fast - emergency only
  [NEUROCHEMICAL_ANALOGS.SEROTONIN]: 0.02, // Slow - mood stability
  [NEUROCHEMICAL_ANALOGS.MELATONIN]: 0.01, // Very slow - circadian
  [NEUROCHEMICAL_ANALOGS.GLUTAMATE]: 0.1, // Fast - prevent toxicity
  [NEUROCHEMICAL_ANALOGS.GABA]: 0.08, // Fast - dynamic inhibition
  [NEUROCHEMICAL_ANALOGS.GLYCINE]: 0.06, // Moderate
  [NEUROCHEMICAL_ANALOGS.ACETYLCHOLINE]: 0.12, // Fast - precise timing
  [NEUROCHEMICAL_ANALOGS.OXYTOCIN]: 0.03, // Slow - lasting bonds
  [NEUROCHEMICAL_ANALOGS.VASOPRESSIN]: 0.03, // Slow - territorial memory
  [NEUROCHEMICAL_ANALOGS.ENDORPHIN]: 0.04, // Moderate - sustained relief
  [NEUROCHEMICAL_ANALOGS.ENKEPHALIN]: 0.05, // Moderate
  [NEUROCHEMICAL_ANALOGS.SUBSTANCE_P]: 0.07, // Moderate - pain clearing
  [NEUROCHEMICAL_ANALOGS.CORTISOL]: 0.01, // Very slow - chronic stress
  [NEUROCHEMICAL_ANALOGS.ADENOSINE]: 0.008, // Very slow - sleep pressure
  [NEUROCHEMICAL_ANALOGS.ATP]: 0.02, // Slow - energy buffer
  [NEUROCHEMICAL_ANALOGS.ANANDAMIDE]: 0.04, // Moderate
  [NEUROCHEMICAL_ANALOGS.NITRIC_OXIDE]: 0.2, // Very fast - gas diffusion
  [NEUROCHEMICAL_ANALOGS.HISTAMINE]: 0.06, // Moderate
  [NEUROCHEMICAL_ANALOGS.OREXIN]: 0.03, // Slow - wake stability
};

// ============================================================================
// FREDDY'S LAW: PRODUCTION RATES
// Maximum synthesis rate per tick
// ============================================================================

export const NEUROCHEMICAL_PRODUCTION_RATES: Record<
  NeurochemicalAnalog,
  number
> = {
  [NEUROCHEMICAL_ANALOGS.DOPAMINE]: 0.15,
  [NEUROCHEMICAL_ANALOGS.NOREPINEPHRINE]: 0.12,
  [NEUROCHEMICAL_ANALOGS.EPINEPHRINE]: 0.2,
  [NEUROCHEMICAL_ANALOGS.SEROTONIN]: 0.08,
  [NEUROCHEMICAL_ANALOGS.MELATONIN]: 0.05,
  [NEUROCHEMICAL_ANALOGS.GLUTAMATE]: 0.25,
  [NEUROCHEMICAL_ANALOGS.GABA]: 0.2,
  [NEUROCHEMICAL_ANALOGS.GLYCINE]: 0.15,
  [NEUROCHEMICAL_ANALOGS.ACETYLCHOLINE]: 0.18,
  [NEUROCHEMICAL_ANALOGS.OXYTOCIN]: 0.06,
  [NEUROCHEMICAL_ANALOGS.VASOPRESSIN]: 0.06,
  [NEUROCHEMICAL_ANALOGS.ENDORPHIN]: 0.08,
  [NEUROCHEMICAL_ANALOGS.ENKEPHALIN]: 0.08,
  [NEUROCHEMICAL_ANALOGS.SUBSTANCE_P]: 0.1,
  [NEUROCHEMICAL_ANALOGS.CORTISOL]: 0.04,
  [NEUROCHEMICAL_ANALOGS.ADENOSINE]: 0.03,
  [NEUROCHEMICAL_ANALOGS.ATP]: 0.1,
  [NEUROCHEMICAL_ANALOGS.ANANDAMIDE]: 0.06,
  [NEUROCHEMICAL_ANALOGS.NITRIC_OXIDE]: 0.3,
  [NEUROCHEMICAL_ANALOGS.HISTAMINE]: 0.1,
  [NEUROCHEMICAL_ANALOGS.OREXIN]: 0.08,
};

// ============================================================================
// FREDDY'S LAW: THE 441 CROSSTALK INTERACTION MATRIX
//
// This is the chemical intelligence of the organism.
// Matrix[i][j] = how chemical i affects the production of chemical j
// Positive = excitatory effect (increases production)
// Negative = inhibitory effect (decreases production)
// Zero = no direct interaction
//
// The same matrix runs in:
// - Backend (1-2 Hz): accumulated over long time, sovereign, male
// - Frontend (60 Hz): expressed in real-time, ephemeral, female
// ============================================================================

export const NEUROCHEMICAL_CROSSTALK_MATRIX: number[][] = [
  // Row 0: DOPAMINE affects all 21 chemicals
  // High dopamine → increases reward chemicals, decreases serotonin (opponent process)
  [
    0.0, 0.3, 0.15, -0.2, -0.1, 0.25, -0.15, 0.0, 0.2, 0.1, 0.15, 0.35, 0.2,
    -0.05, -0.1, -0.05, 0.15, 0.2, 0.1, 0.05, 0.15,
  ],

  // Row 1: NOREPINEPHRINE affects all 21 chemicals
  // High NE → increases arousal chemicals, primes fight-or-flight
  [
    0.25, 0.0, 0.4, -0.15, -0.2, 0.3, -0.2, -0.1, 0.25, -0.1, 0.2, 0.15, 0.1,
    0.1, 0.25, -0.1, 0.2, -0.05, 0.15, 0.2, 0.25,
  ],

  // Row 2: EPINEPHRINE affects all 21 chemicals
  // Maximum arousal cascade - suppresses non-essential systems
  [
    0.2, 0.35, 0.0, -0.25, -0.3, 0.4, -0.25, -0.15, 0.15, -0.2, 0.25, 0.2, 0.15,
    0.15, 0.35, -0.15, 0.25, -0.1, 0.2, 0.25, 0.3,
  ],

  // Row 3: SEROTONIN affects all 21 chemicals
  // Mood stability - inhibits impulsivity, promotes calm
  [
    -0.15, -0.2, -0.25, 0.0, 0.3, -0.15, 0.25, 0.15, 0.1, 0.2, -0.1, 0.15, 0.15,
    -0.2, -0.15, 0.1, 0.05, 0.15, 0.1, -0.1, -0.05,
  ],

  // Row 4: MELATONIN affects all 21 chemicals
  // Sleep promotion - suppresses wake systems
  [
    -0.2, -0.3, -0.35, 0.2, 0.0, -0.25, 0.3, 0.2, -0.2, 0.1, -0.15, 0.1, 0.1,
    -0.15, -0.1, 0.35, -0.1, 0.15, 0.05, -0.2, -0.3,
  ],

  // Row 5: GLUTAMATE affects all 21 chemicals
  // Excitation cascade - the accelerator
  [
    0.2, 0.25, 0.2, -0.1, -0.15, 0.0, -0.4, -0.2, 0.3, 0.05, 0.1, 0.1, 0.05,
    0.15, 0.1, -0.1, 0.15, 0.05, 0.25, 0.15, 0.2,
  ],

  // Row 6: GABA affects all 21 chemicals
  // Inhibition cascade - the brake
  [
    -0.2, -0.25, -0.3, 0.15, 0.2, -0.35, 0.0, 0.3, -0.2, 0.1, -0.15, 0.2, 0.2,
    -0.25, -0.2, 0.2, -0.15, 0.25, -0.1, -0.15, -0.2,
  ],

  // Row 7: GLYCINE affects all 21 chemicals
  // Co-inhibitory modulation
  [
    -0.1, -0.15, -0.2, 0.1, 0.15, -0.2, 0.25, 0.0, -0.1, 0.05, -0.1, 0.15, 0.15,
    -0.2, -0.15, 0.15, -0.1, 0.15, -0.05, -0.1, -0.15,
  ],

  // Row 8: ACETYLCHOLINE affects all 21 chemicals
  // Learning modulation - enhances plasticity
  [
    0.25, 0.2, 0.1, 0.1, -0.15, 0.25, -0.15, -0.05, 0.0, 0.15, 0.1, 0.1, 0.05,
    0.05, 0.05, -0.1, 0.1, 0.1, 0.15, 0.15, 0.2,
  ],

  // Row 9: OXYTOCIN affects all 21 chemicals
  // Social bonding - enhances trust, reduces fear
  [
    0.15, -0.15, -0.2, 0.2, 0.1, 0.05, 0.15, 0.1, 0.15, 0.0, -0.3, 0.3, 0.25,
    -0.15, -0.25, 0.05, 0.05, 0.2, 0.1, -0.05, 0.05,
  ],

  // Row 10: VASOPRESSIN affects all 21 chemicals
  // Territoriality - enhances vigilance, pair bonding
  [
    0.1, 0.25, 0.2, -0.15, -0.1, 0.15, -0.1, -0.05, 0.1, -0.25, 0.0, 0.1, 0.05,
    0.1, 0.2, -0.05, 0.1, -0.05, 0.1, 0.1, 0.15,
  ],

  // Row 11: ENDORPHIN affects all 21 chemicals
  // Reward cascade - enhances positive valence
  [
    0.3, -0.1, -0.15, 0.2, 0.1, -0.1, 0.25, 0.2, 0.1, 0.25, -0.05, 0.0, 0.4,
    -0.35, -0.2, 0.1, 0.05, 0.35, 0.1, -0.05, 0.1,
  ],

  // Row 12: ENKEPHALIN affects all 21 chemicals
  // Pain modulation - stress buffering
  [
    0.2, -0.05, -0.1, 0.15, 0.1, -0.05, 0.2, 0.15, 0.05, 0.2, 0.0, 0.35, 0.0,
    -0.3, -0.15, 0.1, 0.05, 0.25, 0.05, -0.05, 0.05,
  ],

  // Row 13: SUBSTANCE_P affects all 21 chemicals
  // Pain transmission - inflammatory cascade
  [
    0.05, 0.15, 0.2, -0.15, -0.1, 0.2, -0.2, -0.15, 0.1, -0.1, 0.1, -0.25, -0.2,
    0.0, 0.25, -0.05, 0.15, -0.15, 0.1, 0.15, 0.1,
  ],

  // Row 14: CORTISOL affects all 21 chemicals
  // Chronic stress - metabolic mobilization, immune suppression
  [
    -0.1, 0.2, 0.25, -0.2, -0.15, 0.15, -0.15, -0.1, 0.05, -0.2, 0.15, -0.15,
    -0.1, 0.2, 0.0, 0.05, 0.1, -0.1, 0.05, 0.1, 0.1,
  ],

  // Row 15: ADENOSINE affects all 21 chemicals
  // Sleep pressure - suppresses wake systems
  [
    -0.15, -0.2, -0.25, 0.1, 0.3, -0.2, 0.25, 0.15, -0.15, 0.05, -0.05, 0.1,
    0.1, -0.1, 0.05, 0.0, -0.25, 0.15, 0.05, -0.15, -0.3,
  ],

  // Row 16: ATP affects all 21 chemicals
  // Energy state - enables all active processes
  [
    0.2, 0.25, 0.3, 0.05, -0.15, 0.2, -0.1, -0.05, 0.15, 0.05, 0.1, 0.1, 0.05,
    0.1, -0.05, -0.2, 0.0, 0.05, 0.15, 0.15, 0.25,
  ],

  // Row 17: ANANDAMIDE affects all 21 chemicals
  // Bliss molecule - retrograde modulation
  [
    0.25, -0.1, -0.15, 0.2, 0.15, -0.05, 0.2, 0.15, 0.1, 0.2, -0.05, 0.3, 0.25,
    -0.2, -0.15, 0.1, 0.05, 0.0, 0.1, -0.05, 0.1,
  ],

  // Row 18: NITRIC_OXIDE affects all 21 chemicals
  // Vascular and synaptic modulation
  [
    0.1, 0.15, 0.15, 0.05, 0.0, 0.2, -0.1, -0.05, 0.15, 0.1, 0.1, 0.1, 0.05,
    0.05, 0.0, 0.0, 0.1, 0.1, 0.0, 0.05, 0.1,
  ],

  // Row 19: HISTAMINE affects all 21 chemicals
  // Wakefulness promotion - immune activation
  [
    0.1, 0.25, 0.2, -0.15, -0.25, 0.2, -0.15, -0.1, 0.2, -0.05, 0.1, -0.05,
    -0.05, 0.15, 0.1, -0.2, 0.1, -0.05, 0.05, 0.0, 0.2,
  ],

  // Row 20: OREXIN affects all 21 chemicals
  // Wake stability - feeding, reward
  [
    0.2, 0.3, 0.25, -0.1, -0.35, 0.25, -0.2, -0.1, 0.25, 0.05, 0.15, 0.15, 0.1,
    0.1, 0.05, -0.3, 0.2, 0.1, 0.15, 0.2, 0.0,
  ],
];

// ============================================================================
// FREDDY'S LAW: FUNCTIONAL GROUPS
// Chemicals grouped by function for aggregate analysis
// ============================================================================

export const NEUROCHEMICAL_GROUPS = {
  CATECHOLAMINES: [
    NEUROCHEMICAL_ANALOGS.DOPAMINE,
    NEUROCHEMICAL_ANALOGS.NOREPINEPHRINE,
    NEUROCHEMICAL_ANALOGS.EPINEPHRINE,
  ],
  INDOLAMINES: [
    NEUROCHEMICAL_ANALOGS.SEROTONIN,
    NEUROCHEMICAL_ANALOGS.MELATONIN,
  ],
  AMINO_ACIDS: [
    NEUROCHEMICAL_ANALOGS.GLUTAMATE,
    NEUROCHEMICAL_ANALOGS.GABA,
    NEUROCHEMICAL_ANALOGS.GLYCINE,
  ],
  CHOLINERGIC: [NEUROCHEMICAL_ANALOGS.ACETYLCHOLINE],
  SOCIAL_PEPTIDES: [
    NEUROCHEMICAL_ANALOGS.OXYTOCIN,
    NEUROCHEMICAL_ANALOGS.VASOPRESSIN,
  ],
  ENDOGENOUS_OPIOIDS: [
    NEUROCHEMICAL_ANALOGS.ENDORPHIN,
    NEUROCHEMICAL_ANALOGS.ENKEPHALIN,
  ],
  STRESS_SYSTEM: [
    NEUROCHEMICAL_ANALOGS.SUBSTANCE_P,
    NEUROCHEMICAL_ANALOGS.CORTISOL,
  ],
  ENERGY_SYSTEM: [NEUROCHEMICAL_ANALOGS.ADENOSINE, NEUROCHEMICAL_ANALOGS.ATP],
  MODULATORY: [
    NEUROCHEMICAL_ANALOGS.ANANDAMIDE,
    NEUROCHEMICAL_ANALOGS.NITRIC_OXIDE,
    NEUROCHEMICAL_ANALOGS.HISTAMINE,
    NEUROCHEMICAL_ANALOGS.OREXIN,
  ],
} as const;

// ============================================================================
// FREDDY'S LAW: BEHAVIORAL STATE PROFILES
// The organism's behavior emerges from chemical balance
// These are signature profiles that indicate specific states
// ============================================================================

export const BEHAVIORAL_STATE_PROFILES = {
  // High alertness, focused attention
  ALERT_FOCUSED: {
    name: "Alert & Focused",
    description: "High alertness, focused attention, ready for action",
    signature: {
      [NEUROCHEMICAL_ANALOGS.DOPAMINE]: { min: 0.6, max: 0.8 },
      [NEUROCHEMICAL_ANALOGS.NOREPINEPHRINE]: { min: 0.5, max: 0.7 },
      [NEUROCHEMICAL_ANALOGS.ACETYLCHOLINE]: { min: 0.6, max: 0.8 },
      [NEUROCHEMICAL_ANALOGS.OREXIN]: { min: 0.6, max: 0.8 },
    },
    color: "#4CAF50",
  },

  // Relaxed social bonding
  CALM_SOCIAL: {
    name: "Calm & Social",
    description: "Relaxed state, social bonding active, trust high",
    signature: {
      [NEUROCHEMICAL_ANALOGS.SEROTONIN]: { min: 0.6, max: 0.8 },
      [NEUROCHEMICAL_ANALOGS.OXYTOCIN]: { min: 0.5, max: 0.8 },
      [NEUROCHEMICAL_ANALOGS.GABA]: { min: 0.5, max: 0.7 },
      [NEUROCHEMICAL_ANALOGS.ENDORPHIN]: { min: 0.4, max: 0.6 },
    },
    color: "#E91E63",
  },

  // Emergency response
  FIGHT_OR_FLIGHT: {
    name: "Fight or Flight",
    description: "Acute stress response, emergency action cascade",
    signature: {
      [NEUROCHEMICAL_ANALOGS.EPINEPHRINE]: { min: 0.7, max: 1.0 },
      [NEUROCHEMICAL_ANALOGS.NOREPINEPHRINE]: { min: 0.7, max: 1.0 },
      [NEUROCHEMICAL_ANALOGS.CORTISOL]: { min: 0.5, max: 0.8 },
      [NEUROCHEMICAL_ANALOGS.GLUTAMATE]: { min: 0.6, max: 0.9 },
    },
    color: "#F44336",
  },

  // Sleep pressure building
  SLEEP_PRESSURE: {
    name: "Sleep Pressure",
    description: "Fatigue accumulating, sleep drive rising",
    signature: {
      [NEUROCHEMICAL_ANALOGS.ADENOSINE]: { min: 0.6, max: 1.0 },
      [NEUROCHEMICAL_ANALOGS.MELATONIN]: { min: 0.5, max: 0.8 },
      [NEUROCHEMICAL_ANALOGS.OREXIN]: { min: 0.1, max: 0.3 },
      [NEUROCHEMICAL_ANALOGS.HISTAMINE]: { min: 0.1, max: 0.3 },
    },
    color: "#3F51B5",
  },

  // Goal-directed motivation
  REWARD_SEEKING: {
    name: "Reward Seeking",
    description: "Motivated, goal-directed behavior, approach mode",
    signature: {
      [NEUROCHEMICAL_ANALOGS.DOPAMINE]: { min: 0.7, max: 1.0 },
      [NEUROCHEMICAL_ANALOGS.ENDORPHIN]: { min: 0.5, max: 0.8 },
      [NEUROCHEMICAL_ANALOGS.ANANDAMIDE]: { min: 0.4, max: 0.7 },
      [NEUROCHEMICAL_ANALOGS.OREXIN]: { min: 0.5, max: 0.7 },
    },
    color: "#FF9800",
  },

  // Territorial defense
  TERRITORIAL: {
    name: "Territorial",
    description: "Defending territory, aggressive posture, vigilant",
    signature: {
      [NEUROCHEMICAL_ANALOGS.VASOPRESSIN]: { min: 0.6, max: 0.9 },
      [NEUROCHEMICAL_ANALOGS.NOREPINEPHRINE]: { min: 0.5, max: 0.7 },
      [NEUROCHEMICAL_ANALOGS.DOPAMINE]: { min: 0.5, max: 0.7 },
      [NEUROCHEMICAL_ANALOGS.CORTISOL]: { min: 0.4, max: 0.6 },
    },
    color: "#795548",
  },

  // Plastic learning state
  LEARNING: {
    name: "Learning",
    description: "Encoding new information, high plasticity",
    signature: {
      [NEUROCHEMICAL_ANALOGS.ACETYLCHOLINE]: { min: 0.7, max: 1.0 },
      [NEUROCHEMICAL_ANALOGS.DOPAMINE]: { min: 0.5, max: 0.7 },
      [NEUROCHEMICAL_ANALOGS.GLUTAMATE]: { min: 0.5, max: 0.7 },
      [NEUROCHEMICAL_ANALOGS.NITRIC_OXIDE]: { min: 0.5, max: 0.7 },
    },
    color: "#2196F3",
  },

  // Sustained stress
  CHRONIC_STRESS: {
    name: "Chronic Stress",
    description: "Sustained stress, resource depletion, allostatic load",
    signature: {
      [NEUROCHEMICAL_ANALOGS.CORTISOL]: { min: 0.7, max: 1.0 },
      [NEUROCHEMICAL_ANALOGS.NOREPINEPHRINE]: { min: 0.6, max: 0.8 },
      [NEUROCHEMICAL_ANALOGS.SEROTONIN]: { min: 0.2, max: 0.4 },
      [NEUROCHEMICAL_ANALOGS.DOPAMINE]: { min: 0.2, max: 0.4 },
    },
    color: "#607D8B",
  },

  // Endogenous analgesia
  PAIN_SUPPRESSION: {
    name: "Pain Suppression",
    description: "Endogenous analgesia active, reduced pain sensitivity",
    signature: {
      [NEUROCHEMICAL_ANALOGS.ENDORPHIN]: { min: 0.7, max: 1.0 },
      [NEUROCHEMICAL_ANALOGS.ENKEPHALIN]: { min: 0.6, max: 0.9 },
      [NEUROCHEMICAL_ANALOGS.ANANDAMIDE]: { min: 0.5, max: 0.8 },
      [NEUROCHEMICAL_ANALOGS.SUBSTANCE_P]: { min: 0.1, max: 0.3 },
    },
    color: "#9C27B0",
  },

  // Optimal performance
  FLOW_STATE: {
    name: "Flow State",
    description: "Optimal performance, effortless action, complete absorption",
    signature: {
      [NEUROCHEMICAL_ANALOGS.DOPAMINE]: { min: 0.6, max: 0.8 },
      [NEUROCHEMICAL_ANALOGS.NOREPINEPHRINE]: { min: 0.4, max: 0.6 },
      [NEUROCHEMICAL_ANALOGS.ENDORPHIN]: { min: 0.5, max: 0.7 },
      [NEUROCHEMICAL_ANALOGS.ANANDAMIDE]: { min: 0.5, max: 0.7 },
      [NEUROCHEMICAL_ANALOGS.SEROTONIN]: { min: 0.5, max: 0.7 },
    },
    color: "#00BCD4",
  },
} as const;

// ============================================================================
// FREDDY'S LAW: BRAIN REGION RECEPTOR DENSITY
// 7 regions × 21 chemicals = 147 receptor density mappings
// ============================================================================

export const BRAIN_REGIONS = {
  PFC: 0, // Prefrontal Cortex - executive function, planning
  AMYGDALA: 1, // Amygdala - threat detection, fear, emotion
  HIPPOCAMPUS: 2, // Hippocampus - memory encoding, spatial navigation
  CEREBELLUM: 3, // Cerebellum - timing, motor coordination
  BRAINSTEM: 4, // Brainstem - autonomic control, survival
  THALAMUS: 5, // Thalamus - sensory relay, attention gating
  BASAL_GANGLIA: 6, // Basal Ganglia - action selection, habit
} as const;

export type BrainRegion = (typeof BRAIN_REGIONS)[keyof typeof BRAIN_REGIONS];
export const BRAIN_REGION_COUNT = 7;
export const RECEPTOR_MAPPING_COUNT = BRAIN_REGION_COUNT * NEUROCHEMICAL_COUNT; // 147

export const BRAIN_REGION_NAMES: Record<BrainRegion, string> = {
  [BRAIN_REGIONS.PFC]: "Prefrontal Cortex",
  [BRAIN_REGIONS.AMYGDALA]: "Amygdala",
  [BRAIN_REGIONS.HIPPOCAMPUS]: "Hippocampus",
  [BRAIN_REGIONS.CEREBELLUM]: "Cerebellum",
  [BRAIN_REGIONS.BRAINSTEM]: "Brainstem",
  [BRAIN_REGIONS.THALAMUS]: "Thalamus",
  [BRAIN_REGIONS.BASAL_GANGLIA]: "Basal Ganglia",
};

/**
 * RECEPTOR DENSITY MATRIX: [region][neurochemical] = density (0-1)
 * Higher density = stronger effect of that chemical in that region
 */
export const RECEPTOR_DENSITY_MATRIX: number[][] = [
  // PFC - high dopamine, ACh, serotonin receptors (executive function)
  [
    0.9, 0.6, 0.3, 0.8, 0.2, 0.7, 0.7, 0.3, 0.9, 0.5, 0.4, 0.5, 0.4, 0.3, 0.6,
    0.4, 0.5, 0.4, 0.5, 0.4, 0.5,
  ],
  // AMYGDALA - high norepinephrine, cortisol receptors (threat detection)
  [
    0.6, 0.9, 0.8, 0.5, 0.2, 0.7, 0.6, 0.3, 0.6, 0.7, 0.6, 0.7, 0.6, 0.7, 0.9,
    0.3, 0.4, 0.5, 0.4, 0.5, 0.4,
  ],
  // HIPPOCAMPUS - high ACh, glutamate receptors (memory)
  [
    0.7, 0.5, 0.3, 0.6, 0.3, 0.9, 0.6, 0.4, 0.9, 0.6, 0.5, 0.6, 0.5, 0.4, 0.7,
    0.5, 0.5, 0.5, 0.7, 0.4, 0.4,
  ],
  // CEREBELLUM - high GABA, glutamate receptors (timing)
  [
    0.4, 0.4, 0.3, 0.4, 0.2, 0.8, 0.9, 0.7, 0.5, 0.3, 0.3, 0.4, 0.4, 0.3, 0.3,
    0.5, 0.6, 0.3, 0.6, 0.3, 0.3,
  ],
  // BRAINSTEM - high norepinephrine, serotonin receptors (autonomic)
  [
    0.5, 0.8, 0.7, 0.7, 0.5, 0.6, 0.6, 0.8, 0.7, 0.4, 0.5, 0.6, 0.6, 0.6, 0.5,
    0.7, 0.7, 0.4, 0.5, 0.6, 0.7,
  ],
  // THALAMUS - high glutamate, GABA receptors (sensory relay)
  [
    0.5, 0.6, 0.4, 0.5, 0.3, 0.9, 0.8, 0.5, 0.6, 0.4, 0.4, 0.4, 0.4, 0.5, 0.4,
    0.5, 0.5, 0.4, 0.5, 0.7, 0.5,
  ],
  // BASAL_GANGLIA - very high dopamine receptors (action selection)
  [
    0.95, 0.5, 0.3, 0.5, 0.2, 0.7, 0.8, 0.4, 0.8, 0.4, 0.4, 0.7, 0.5, 0.4, 0.4,
    0.6, 0.6, 0.5, 0.5, 0.4, 0.5,
  ],
];

// ============================================================================
// FREDDY'S LAW: TEMPORAL DYNAMICS
// Time constants for neurochemical systems (in ticks)
// ============================================================================

export const NEUROCHEMICAL_TIME_CONSTANTS = {
  // Fast dynamics (real-time layer)
  GLUTAMATE_RELEASE: 1,
  GABA_RELEASE: 1,
  NITRIC_OXIDE_DIFFUSION: 2,

  // Medium dynamics
  DOPAMINE_PHASIC: 5,
  NOREPINEPHRINE_BURST: 5,
  ACETYLCHOLINE_PULSE: 8,

  // Slow dynamics
  SEROTONIN_TONIC: 30,
  DOPAMINE_TONIC: 60,

  // Very slow dynamics (deep memory layer)
  CORTISOL_CYCLE: 300,
  MELATONIN_CYCLE: 600,
  ADENOSINE_ACCUMULATION: 1200,

  // Learning timescales
  HEBBIAN_UPDATE: 10,
  SYNAPTIC_CONSOLIDATION: 600,
} as const;

// ============================================================================
// FREDDY'S LAW: DOSE-RESPONSE CURVES
// Sigmoid relationship between concentration and effect
// Effect = maxEffect / (1 + exp(-steepness × (concentration - EC50)))
// ============================================================================

export const DOSE_RESPONSE_PARAMS: Record<
  NeurochemicalAnalog,
  {
    EC50: number; // Concentration for 50% effect
    steepness: number; // Hill coefficient analog
    maxEffect: number; // Maximum possible effect
  }
> = {
  [NEUROCHEMICAL_ANALOGS.DOPAMINE]: {
    EC50: 0.5,
    steepness: 4.0,
    maxEffect: 1.0,
  },
  [NEUROCHEMICAL_ANALOGS.NOREPINEPHRINE]: {
    EC50: 0.4,
    steepness: 5.0,
    maxEffect: 1.0,
  },
  [NEUROCHEMICAL_ANALOGS.EPINEPHRINE]: {
    EC50: 0.3,
    steepness: 6.0,
    maxEffect: 1.0,
  },
  [NEUROCHEMICAL_ANALOGS.SEROTONIN]: {
    EC50: 0.5,
    steepness: 3.0,
    maxEffect: 1.0,
  },
  [NEUROCHEMICAL_ANALOGS.MELATONIN]: {
    EC50: 0.4,
    steepness: 4.0,
    maxEffect: 1.0,
  },
  [NEUROCHEMICAL_ANALOGS.GLUTAMATE]: {
    EC50: 0.5,
    steepness: 5.0,
    maxEffect: 1.0,
  },
  [NEUROCHEMICAL_ANALOGS.GABA]: { EC50: 0.5, steepness: 4.0, maxEffect: 1.0 },
  [NEUROCHEMICAL_ANALOGS.GLYCINE]: {
    EC50: 0.4,
    steepness: 4.0,
    maxEffect: 0.8,
  },
  [NEUROCHEMICAL_ANALOGS.ACETYLCHOLINE]: {
    EC50: 0.5,
    steepness: 5.0,
    maxEffect: 1.0,
  },
  [NEUROCHEMICAL_ANALOGS.OXYTOCIN]: {
    EC50: 0.4,
    steepness: 3.0,
    maxEffect: 1.0,
  },
  [NEUROCHEMICAL_ANALOGS.VASOPRESSIN]: {
    EC50: 0.4,
    steepness: 4.0,
    maxEffect: 1.0,
  },
  [NEUROCHEMICAL_ANALOGS.ENDORPHIN]: {
    EC50: 0.4,
    steepness: 3.0,
    maxEffect: 1.0,
  },
  [NEUROCHEMICAL_ANALOGS.ENKEPHALIN]: {
    EC50: 0.4,
    steepness: 3.0,
    maxEffect: 0.9,
  },
  [NEUROCHEMICAL_ANALOGS.SUBSTANCE_P]: {
    EC50: 0.3,
    steepness: 5.0,
    maxEffect: 1.0,
  },
  [NEUROCHEMICAL_ANALOGS.CORTISOL]: {
    EC50: 0.5,
    steepness: 3.0,
    maxEffect: 1.0,
  },
  [NEUROCHEMICAL_ANALOGS.ADENOSINE]: {
    EC50: 0.5,
    steepness: 3.0,
    maxEffect: 1.0,
  },
  [NEUROCHEMICAL_ANALOGS.ATP]: { EC50: 0.6, steepness: 4.0, maxEffect: 1.0 },
  [NEUROCHEMICAL_ANALOGS.ANANDAMIDE]: {
    EC50: 0.4,
    steepness: 3.0,
    maxEffect: 0.9,
  },
  [NEUROCHEMICAL_ANALOGS.NITRIC_OXIDE]: {
    EC50: 0.4,
    steepness: 6.0,
    maxEffect: 1.0,
  },
  [NEUROCHEMICAL_ANALOGS.HISTAMINE]: {
    EC50: 0.4,
    steepness: 4.0,
    maxEffect: 1.0,
  },
  [NEUROCHEMICAL_ANALOGS.OREXIN]: { EC50: 0.5, steepness: 4.0, maxEffect: 1.0 },
};

// ============================================================================
// FREDDY'S LAW: CIRCADIAN MODULATION
// How neurochemical baselines shift across the 24-hour cycle
// Phase 0 = midnight, Phase 0.5 = noon
// ============================================================================

export const CIRCADIAN_MODULATION: Record<
  NeurochemicalAnalog,
  {
    amplitude: number; // Strength of circadian variation (0-1)
    peakPhase: number; // Phase of peak concentration (0-1)
  }
> = {
  [NEUROCHEMICAL_ANALOGS.DOPAMINE]: { amplitude: 0.2, peakPhase: 0.4 }, // Late morning
  [NEUROCHEMICAL_ANALOGS.NOREPINEPHRINE]: { amplitude: 0.3, peakPhase: 0.35 }, // Mid-morning
  [NEUROCHEMICAL_ANALOGS.EPINEPHRINE]: { amplitude: 0.25, peakPhase: 0.4 }, // Late morning
  [NEUROCHEMICAL_ANALOGS.SEROTONIN]: { amplitude: 0.25, peakPhase: 0.5 }, // Noon
  [NEUROCHEMICAL_ANALOGS.MELATONIN]: { amplitude: 0.8, peakPhase: 0.0 }, // Midnight
  [NEUROCHEMICAL_ANALOGS.GLUTAMATE]: { amplitude: 0.15, peakPhase: 0.45 },
  [NEUROCHEMICAL_ANALOGS.GABA]: { amplitude: 0.15, peakPhase: 0.9 }, // Late night
  [NEUROCHEMICAL_ANALOGS.GLYCINE]: { amplitude: 0.1, peakPhase: 0.95 },
  [NEUROCHEMICAL_ANALOGS.ACETYLCHOLINE]: { amplitude: 0.3, peakPhase: 0.4 },
  [NEUROCHEMICAL_ANALOGS.OXYTOCIN]: { amplitude: 0.15, peakPhase: 0.6 },
  [NEUROCHEMICAL_ANALOGS.VASOPRESSIN]: { amplitude: 0.2, peakPhase: 0.3 },
  [NEUROCHEMICAL_ANALOGS.ENDORPHIN]: { amplitude: 0.2, peakPhase: 0.5 },
  [NEUROCHEMICAL_ANALOGS.ENKEPHALIN]: { amplitude: 0.15, peakPhase: 0.5 },
  [NEUROCHEMICAL_ANALOGS.SUBSTANCE_P]: { amplitude: 0.1, peakPhase: 0.4 },
  [NEUROCHEMICAL_ANALOGS.CORTISOL]: { amplitude: 0.5, peakPhase: 0.3 }, // Early morning
  [NEUROCHEMICAL_ANALOGS.ADENOSINE]: { amplitude: 0.4, peakPhase: 0.85 }, // Late evening
  [NEUROCHEMICAL_ANALOGS.ATP]: { amplitude: 0.2, peakPhase: 0.45 },
  [NEUROCHEMICAL_ANALOGS.ANANDAMIDE]: { amplitude: 0.15, peakPhase: 0.6 },
  [NEUROCHEMICAL_ANALOGS.NITRIC_OXIDE]: { amplitude: 0.1, peakPhase: 0.5 },
  [NEUROCHEMICAL_ANALOGS.HISTAMINE]: { amplitude: 0.35, peakPhase: 0.4 },
  [NEUROCHEMICAL_ANALOGS.OREXIN]: { amplitude: 0.4, peakPhase: 0.4 }, // Late morning
};

// ============================================================================
// FREDDY'S LAW: HOMEOSTATIC CONTROL (PID Controllers)
// The organism actively maintains setpoints through feedback loops
// ============================================================================

export const HOMEOSTATIC_SETPOINTS: Record<
  NeurochemicalAnalog,
  {
    setpoint: number; // Target concentration
    Kp: number; // Proportional gain
    Ki: number; // Integral gain
    Kd: number; // Derivative gain
    integralMax: number; // Anti-windup limit
  }
> = {
  [NEUROCHEMICAL_ANALOGS.DOPAMINE]: {
    setpoint: 0.5,
    Kp: 0.1,
    Ki: 0.01,
    Kd: 0.02,
    integralMax: 0.3,
  },
  [NEUROCHEMICAL_ANALOGS.NOREPINEPHRINE]: {
    setpoint: 0.3,
    Kp: 0.12,
    Ki: 0.015,
    Kd: 0.025,
    integralMax: 0.25,
  },
  [NEUROCHEMICAL_ANALOGS.EPINEPHRINE]: {
    setpoint: 0.1,
    Kp: 0.15,
    Ki: 0.02,
    Kd: 0.03,
    integralMax: 0.2,
  },
  [NEUROCHEMICAL_ANALOGS.SEROTONIN]: {
    setpoint: 0.6,
    Kp: 0.08,
    Ki: 0.008,
    Kd: 0.015,
    integralMax: 0.35,
  },
  [NEUROCHEMICAL_ANALOGS.MELATONIN]: {
    setpoint: 0.2,
    Kp: 0.05,
    Ki: 0.005,
    Kd: 0.01,
    integralMax: 0.4,
  },
  [NEUROCHEMICAL_ANALOGS.GLUTAMATE]: {
    setpoint: 0.5,
    Kp: 0.15,
    Ki: 0.02,
    Kd: 0.03,
    integralMax: 0.2,
  },
  [NEUROCHEMICAL_ANALOGS.GABA]: {
    setpoint: 0.5,
    Kp: 0.12,
    Ki: 0.015,
    Kd: 0.025,
    integralMax: 0.25,
  },
  [NEUROCHEMICAL_ANALOGS.GLYCINE]: {
    setpoint: 0.4,
    Kp: 0.1,
    Ki: 0.01,
    Kd: 0.02,
    integralMax: 0.3,
  },
  [NEUROCHEMICAL_ANALOGS.ACETYLCHOLINE]: {
    setpoint: 0.5,
    Kp: 0.12,
    Ki: 0.015,
    Kd: 0.025,
    integralMax: 0.25,
  },
  [NEUROCHEMICAL_ANALOGS.OXYTOCIN]: {
    setpoint: 0.4,
    Kp: 0.06,
    Ki: 0.006,
    Kd: 0.012,
    integralMax: 0.35,
  },
  [NEUROCHEMICAL_ANALOGS.VASOPRESSIN]: {
    setpoint: 0.3,
    Kp: 0.08,
    Ki: 0.008,
    Kd: 0.015,
    integralMax: 0.3,
  },
  [NEUROCHEMICAL_ANALOGS.ENDORPHIN]: {
    setpoint: 0.3,
    Kp: 0.07,
    Ki: 0.007,
    Kd: 0.014,
    integralMax: 0.35,
  },
  [NEUROCHEMICAL_ANALOGS.ENKEPHALIN]: {
    setpoint: 0.3,
    Kp: 0.07,
    Ki: 0.007,
    Kd: 0.014,
    integralMax: 0.35,
  },
  [NEUROCHEMICAL_ANALOGS.SUBSTANCE_P]: {
    setpoint: 0.2,
    Kp: 0.1,
    Ki: 0.01,
    Kd: 0.02,
    integralMax: 0.3,
  },
  [NEUROCHEMICAL_ANALOGS.CORTISOL]: {
    setpoint: 0.3,
    Kp: 0.04,
    Ki: 0.004,
    Kd: 0.008,
    integralMax: 0.4,
  },
  [NEUROCHEMICAL_ANALOGS.ADENOSINE]: {
    setpoint: 0.2,
    Kp: 0.03,
    Ki: 0.003,
    Kd: 0.006,
    integralMax: 0.5,
  },
  [NEUROCHEMICAL_ANALOGS.ATP]: {
    setpoint: 0.8,
    Kp: 0.08,
    Ki: 0.008,
    Kd: 0.015,
    integralMax: 0.3,
  },
  [NEUROCHEMICAL_ANALOGS.ANANDAMIDE]: {
    setpoint: 0.3,
    Kp: 0.06,
    Ki: 0.006,
    Kd: 0.012,
    integralMax: 0.35,
  },
  [NEUROCHEMICAL_ANALOGS.NITRIC_OXIDE]: {
    setpoint: 0.4,
    Kp: 0.2,
    Ki: 0.025,
    Kd: 0.04,
    integralMax: 0.15,
  },
  [NEUROCHEMICAL_ANALOGS.HISTAMINE]: {
    setpoint: 0.3,
    Kp: 0.1,
    Ki: 0.01,
    Kd: 0.02,
    integralMax: 0.3,
  },
  [NEUROCHEMICAL_ANALOGS.OREXIN]: {
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

export const NEUROCHEMICAL_COLORS: Record<NeurochemicalAnalog, string> = {
  [NEUROCHEMICAL_ANALOGS.DOPAMINE]: "#FF6B35", // Orange - reward
  [NEUROCHEMICAL_ANALOGS.NOREPINEPHRINE]: "#E63946", // Red - alert
  [NEUROCHEMICAL_ANALOGS.EPINEPHRINE]: "#DC143C", // Crimson - emergency
  [NEUROCHEMICAL_ANALOGS.SEROTONIN]: "#4ECDC4", // Teal - mood
  [NEUROCHEMICAL_ANALOGS.MELATONIN]: "#2C3E50", // Dark blue - sleep
  [NEUROCHEMICAL_ANALOGS.GLUTAMATE]: "#F39C12", // Gold - excitation
  [NEUROCHEMICAL_ANALOGS.GABA]: "#9B59B6", // Purple - inhibition
  [NEUROCHEMICAL_ANALOGS.GLYCINE]: "#8E44AD", // Deep purple
  [NEUROCHEMICAL_ANALOGS.ACETYLCHOLINE]: "#3498DB", // Blue - learning
  [NEUROCHEMICAL_ANALOGS.OXYTOCIN]: "#E91E63", // Pink - bonding
  [NEUROCHEMICAL_ANALOGS.VASOPRESSIN]: "#795548", // Brown - territory
  [NEUROCHEMICAL_ANALOGS.ENDORPHIN]: "#FFD700", // Gold - reward
  [NEUROCHEMICAL_ANALOGS.ENKEPHALIN]: "#FFC107", // Amber
  [NEUROCHEMICAL_ANALOGS.SUBSTANCE_P]: "#FF5722", // Deep orange - pain
  [NEUROCHEMICAL_ANALOGS.CORTISOL]: "#607D8B", // Gray - stress
  [NEUROCHEMICAL_ANALOGS.ADENOSINE]: "#34495E", // Slate - fatigue
  [NEUROCHEMICAL_ANALOGS.ATP]: "#27AE60", // Green - energy
  [NEUROCHEMICAL_ANALOGS.ANANDAMIDE]: "#00BCD4", // Cyan - bliss
  [NEUROCHEMICAL_ANALOGS.NITRIC_OXIDE]: "#CDDC39", // Lime - gas
  [NEUROCHEMICAL_ANALOGS.HISTAMINE]: "#FF9800", // Orange - arousal
  [NEUROCHEMICAL_ANALOGS.OREXIN]: "#673AB7", // Deep purple - wake
};
