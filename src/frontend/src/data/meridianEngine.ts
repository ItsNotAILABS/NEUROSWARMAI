/**
 * ╔══════════════════════════════════════════════════════════════════════════════╗
 * ║              MERIDIAN ENGINE — 經絡-SUBSTRATE v1.0                            ║
 * ║         Biological Rhythms, Circadian Dynamics & Temporal Coherence          ║
 * ╠══════════════════════════════════════════════════════════════════════════════╣
 * ║  This engine governs all biological rhythms within the organism including:   ║
 * ║  - Circadian rhythms (24-hour cycles)                                         ║
 * ║  - Ultradian rhythms (< 24 hours: heartbeat, respiration, brain waves)       ║
 * ║  - Infradian rhythms (> 24 hours: lunar, seasonal, annual)                   ║
 * ║  - Entrainment to environmental zeitgebers                                    ║
 * ║  - Phase-response curves and chronobiology                                   ║
 * ╚══════════════════════════════════════════════════════════════════════════════╝
 */

// ============================================================================
// SECTION 1: FUNDAMENTAL CONSTANTS & BIOLOGICAL TIME UNITS
// ============================================================================

/** Circadian period in hours */
export const CIRCADIAN_PERIOD_HOURS = 24.2; // Slightly longer than 24h without zeitgeber

/** Circadian period in seconds */
export const CIRCADIAN_PERIOD_SECONDS = CIRCADIAN_PERIOD_HOURS * 3600;

/** Ultradian BRAC (Basic Rest-Activity Cycle) period in minutes */
export const BRAC_PERIOD_MINUTES = 90;

/** Lunar cycle period in days */
export const LUNAR_PERIOD_DAYS = 29.53;

/** Heart rate base frequency (Hz) - resting adult */
export const HEART_RATE_BASE_HZ = 1.167; // ~70 bpm

/** Respiratory rate base frequency (Hz) - resting adult */
export const RESPIRATORY_RATE_BASE_HZ = 0.25; // ~15 breaths/min

/** Alpha brain wave frequency (Hz) */
export const ALPHA_WAVE_HZ = 10;

/** Theta brain wave frequency (Hz) */
export const THETA_WAVE_HZ = 6;

/** Delta brain wave frequency (Hz) */
export const DELTA_WAVE_HZ = 2;

/** Beta brain wave frequency (Hz) */
export const BETA_WAVE_HZ = 20;

/** Gamma brain wave frequency (Hz) */
export const GAMMA_WAVE_HZ = 40;

/** Seasonal variation amplitude */
export const SEASONAL_AMPLITUDE = 0.15;

/** Melatonin synthesis onset delay after sunset (hours) */
export const MELATONIN_DELAY_HOURS = 2;

/** Core body temperature variation (°C) */
export const CORE_TEMP_VARIATION = 0.5;

/** Cortisol awakening response magnitude */
export const CAR_MAGNITUDE = 0.75;

// ============================================================================
// SECTION 2: TYPE DEFINITIONS FOR BIOLOGICAL RHYTHMS
// ============================================================================

/**
 * Rhythm type classification
 */
export type RhythmType =
  | "circadian" // ~24 hours
  | "ultradian" // < 24 hours (minutes to hours)
  | "infradian" // > 24 hours (days to months)
  | "circalunar" // ~29.5 days
  | "circannual" // ~365 days
  | "circhoral" // ~1 hour
  | "circasemidian" // ~12 hours
  | "circaseptan"; // ~7 days

/**
 * Phase state of a biological oscillator
 */
export interface PhaseState {
  readonly phase: number; // Current phase [0, 2π]
  readonly period: number; // Natural period in seconds
  readonly amplitude: number; // Oscillation amplitude [0, 1]
  readonly acrophase: number; // Time of peak (hours from midnight)
  readonly mesor: number; // Rhythm-adjusted mean
  readonly robustness: number; // Phase coherence strength [0, 1]
}

/**
 * Environmental zeitgeber (time-giver)
 */
export interface Zeitgeber {
  readonly type:
    | "light"
    | "temperature"
    | "food"
    | "social"
    | "exercise"
    | "melatonin";
  readonly strength: number; // Entrainment strength [0, 1]
  readonly timing: number; // Time of presentation (hours from midnight)
  readonly duration: number; // Duration of exposure (hours)
  readonly phaseShift: number; // Induced phase shift (hours)
}

/**
 * Phase Response Curve (PRC) - how oscillator responds to perturbation at different phases
 */
export interface PhaseResponseCurve {
  readonly zeitgeberType: Zeitgeber["type"];
  readonly phasePoints: number[]; // Phases at which response measured
  readonly responses: number[]; // Phase shift at each phase point
  readonly sensitivity: number; // Overall sensitivity
  readonly deadZone: [number, number]; // Phase range with minimal response
}

/**
 * Circadian clock gene expression
 */
export interface ClockGeneExpression {
  readonly CLOCK: number; // CLOCK protein level
  readonly BMAL1: number; // BMAL1 protein level
  readonly PER1: number; // PER1 protein level
  readonly PER2: number; // PER2 protein level
  readonly CRY1: number; // CRY1 protein level
  readonly CRY2: number; // CRY2 protein level
  readonly REV_ERB_alpha: number; // REV-ERBα level
  readonly REV_ERB_beta: number; // REV-ERBβ level
  readonly ROR_alpha: number; // RORα level
}

/**
 * Sleep stage
 */
export type SleepStage = "wake" | "N1" | "N2" | "N3" | "REM";

/**
 * Sleep architecture - structure of sleep through the night
 */
export interface SleepArchitecture {
  readonly currentStage: SleepStage;
  readonly cycleNumber: number; // Which NREM-REM cycle
  readonly timeInStage: number; // Minutes in current stage
  readonly sleepOnset: number; // Time of sleep onset (hours from midnight)
  readonly totalSleepTime: number; // Total accumulated sleep (minutes)
  readonly sleepEfficiency: number; // Time asleep / Time in bed [0, 1]
  readonly REMLatency: number; // Time to first REM (minutes)
  readonly slowWaveActivity: number; // Delta power in EEG
}

/**
 * Hormone circadian profile
 */
export interface HormoneProfile {
  readonly name: string;
  readonly currentLevel: number; // Normalized [0, 1]
  readonly peakTime: number; // Acrophase (hours from midnight)
  readonly nadir: number; // Lowest level time (hours from midnight)
  readonly amplitude: number; // Peak-to-trough amplitude
  readonly halfLife: number; // Biological half-life (hours)
}

/**
 * Body temperature rhythm
 */
export interface TemperatureRhythm {
  readonly coreTemperature: number; // °C
  readonly peripheralTemperature: number; // °C
  readonly gradient: number; // Core - peripheral
  readonly phase: number; // Circadian phase
  readonly minimum: number; // Daily minimum time (hours)
  readonly maximum: number; // Daily maximum time (hours)
}

/**
 * Alertness and performance rhythm
 */
export interface AlertnessRhythm {
  readonly alertness: number; // Subjective alertness [0, 1]
  readonly cognitivePerformance: number; // Performance capacity [0, 1]
  readonly reactionTime: number; // Relative reaction time [0.5, 1.5]
  readonly memoryConsolidation: number; // Memory function [0, 1]
  readonly creativityIndex: number; // Creative thinking capacity [0, 1]
  readonly timeOfDayEffect: number; // Phase-dependent performance modifier
}

/**
 * Metabolic rhythm
 */
export interface MetabolicRhythm {
  readonly glucoseLevel: number; // Relative blood glucose
  readonly insulinSensitivity: number; // Insulin response [0, 1]
  readonly lipidOxidation: number; // Fat metabolism rate
  readonly thermalEffectOfFood: number; // Postprandial thermogenesis
  readonly metabolicRate: number; // Basal metabolic rate modifier
  readonly feedingWindow: [number, number]; // Optimal eating times
}

/**
 * Cardiovascular rhythm
 */
export interface CardiovascularRhythm {
  readonly heartRate: number; // bpm
  readonly heartRateVariability: number; // RMSSD in ms
  readonly bloodPressureSystolic: number; // mmHg
  readonly bloodPressureDiastolic: number; // mmHg
  readonly vascularResistance: number; // Relative resistance
  readonly cardiacOutput: number; // Liters/minute
  readonly morningPressureSurge: number; // mm Hg increase on waking
}

/**
 * Immune system rhythm
 */
export interface ImmuneRhythm {
  readonly lymphocyteCount: number; // Relative count
  readonly cytokineActivity: number; // Inflammatory marker
  readonly antibodyProduction: number; // Immune response capacity
  readonly phagocyticActivity: number; // Pathogen clearance
  readonly vaccineResponse: number; // Optimal vaccination time effect
  readonly infectionSusceptibility: number; // Disease vulnerability
}

/**
 * Complete meridian state
 */
export interface MeridianState {
  readonly timestamp: number;
  readonly localTime: number; // Hours from midnight [0, 24)
  readonly circadianPhase: PhaseState;
  readonly ultradianPhases: Map<string, PhaseState>;
  readonly infradianPhases: Map<string, PhaseState>;
  readonly clockGenes: ClockGeneExpression;
  readonly sleepState: SleepArchitecture;
  readonly hormones: Map<string, HormoneProfile>;
  readonly temperature: TemperatureRhythm;
  readonly alertness: AlertnessRhythm;
  readonly metabolism: MetabolicRhythm;
  readonly cardiovascular: CardiovascularRhythm;
  readonly immune: ImmuneRhythm;
  readonly zeitgebers: Zeitgeber[];
  readonly phaseResponseCurves: Map<string, PhaseResponseCurve>;
  readonly entrainmentStrength: number;
  readonly chronotype: "morning" | "intermediate" | "evening";
  readonly jetLagStatus: JetLagStatus;
  readonly seasonalAdaptation: SeasonalState;
}

/**
 * Jet lag / shift work status
 */
export interface JetLagStatus {
  readonly timeZoneOffset: number; // Hours from home time zone
  readonly daysInNewZone: number;
  readonly adaptationProgress: number; // [0, 1] how adapted
  readonly symptomSeverity: number; // [0, 1] symptom intensity
  readonly reentrainmentRate: number; // Hours of adjustment per day
}

/**
 * Seasonal adaptation state
 */
export interface SeasonalState {
  readonly dayLength: number; // Hours of daylight
  readonly season: "spring" | "summer" | "autumn" | "winter";
  readonly latitude: number; // Degrees from equator
  readonly lightExposure: number; // Daily lux-hours
  readonly seasonalAffect: number; // Mood variation [-1, 1]
  readonly photoperiodAdaptation: number; // Adaptation to day length
}

// ============================================================================
// SECTION 3: CIRCADIAN OSCILLATOR MODELS
// ============================================================================

/**
 * Goodwin Oscillator - classic circadian clock model
 * Three-variable negative feedback loop
 */
export class GoodwinOscillator {
  private mRNA: number; // Clock gene mRNA
  private protein: number; // Clock protein
  private inhibitor: number; // Nuclear inhibitor complex

  private readonly alpha: number = 1.0; // mRNA production rate
  private readonly beta: number = 0.2; // mRNA degradation rate
  private readonly gamma: number = 1.0; // Protein translation rate
  private readonly delta: number = 0.2; // Protein degradation rate
  private readonly epsilon: number = 1.0; // Inhibitor formation rate
  private readonly zeta: number = 0.1; // Inhibitor degradation rate
  private readonly K: number = 1.0; // Hill function threshold
  private readonly n: number = 4; // Hill coefficient (cooperativity)

  constructor() {
    // Initialize near limit cycle
    this.mRNA = 0.5;
    this.protein = 0.5;
    this.inhibitor = 0.5;
  }

  /**
   * Hill function for transcriptional repression
   */
  private hillRepression(x: number): number {
    const xn = x ** this.n;
    const Kn = this.K ** this.n;
    return Kn / (Kn + xn);
  }

  /**
   * Compute derivatives
   */
  private derivatives(): [number, number, number] {
    const dmRNA =
      this.alpha * this.hillRepression(this.inhibitor) - this.beta * this.mRNA;
    const dProtein = this.gamma * this.mRNA - this.delta * this.protein;
    const dInhibitor = this.epsilon * this.protein - this.zeta * this.inhibitor;

    return [dmRNA, dProtein, dInhibitor];
  }

  /**
   * Advance by dt using RK4
   */
  step(dt: number): void {
    const [k1m, k1p, k1i] = this.derivatives();

    const savedM = this.mRNA;
    const savedP = this.protein;
    const savedI = this.inhibitor;

    // k2
    this.mRNA = savedM + 0.5 * dt * k1m;
    this.protein = savedP + 0.5 * dt * k1p;
    this.inhibitor = savedI + 0.5 * dt * k1i;
    const [k2m, k2p, k2i] = this.derivatives();

    // k3
    this.mRNA = savedM + 0.5 * dt * k2m;
    this.protein = savedP + 0.5 * dt * k2p;
    this.inhibitor = savedI + 0.5 * dt * k2i;
    const [k3m, k3p, k3i] = this.derivatives();

    // k4
    this.mRNA = savedM + dt * k3m;
    this.protein = savedP + dt * k3p;
    this.inhibitor = savedI + dt * k3i;
    const [k4m, k4p, k4i] = this.derivatives();

    // Update
    this.mRNA = savedM + (dt / 6) * (k1m + 2 * k2m + 2 * k3m + k4m);
    this.protein = savedP + (dt / 6) * (k1p + 2 * k2p + 2 * k3p + k4p);
    this.inhibitor = savedI + (dt / 6) * (k1i + 2 * k2i + 2 * k3i + k4i);

    // Ensure positive values
    this.mRNA = Math.max(0.001, this.mRNA);
    this.protein = Math.max(0.001, this.protein);
    this.inhibitor = Math.max(0.001, this.inhibitor);
  }

  /**
   * Get current phase (estimated from oscillator state)
   */
  getPhase(): number {
    return Math.atan2(this.protein - 0.5, this.mRNA - 0.5) + Math.PI;
  }

  /**
   * Get current amplitude
   */
  getAmplitude(): number {
    return Math.sqrt((this.mRNA - 0.5) ** 2 + (this.protein - 0.5) ** 2);
  }

  /**
   * Get state
   */
  getState(): { mRNA: number; protein: number; inhibitor: number } {
    return {
      mRNA: this.mRNA,
      protein: this.protein,
      inhibitor: this.inhibitor,
    };
  }

  /**
   * Apply light pulse (phase shift)
   */
  applyLightPulse(intensity: number, duration: number): void {
    // Light increases mRNA transcription
    this.mRNA += intensity * duration * 0.1;
    this.mRNA = Math.min(2, this.mRNA);
  }
}

/**
 * Leloup-Goldbeter Model - more detailed mammalian circadian clock
 * Models PER/CRY and CLOCK/BMAL1 loops
 */
export class LeloupGoldbeterModel {
  // State variables (concentrations)
  private Mp = 0.5; // PER mRNA
  private Mc = 0.5; // CRY mRNA
  private Mb = 0.5; // BMAL1 mRNA
  private P0 = 0.5; // PER protein (cytoplasm)
  private P1 = 0.5; // PER protein (phosphorylated 1x)
  private P2 = 0.5; // PER protein (phosphorylated 2x)
  private C0 = 0.5; // CRY protein (cytoplasm)
  private C1 = 0.5; // CRY protein (phosphorylated 1x)
  private C2 = 0.5; // CRY protein (phosphorylated 2x)
  private PC = 0.5; // PER-CRY complex (cytoplasm)
  private PCn = 0.5; // PER-CRY complex (nucleus)
  private B0 = 0.5; // BMAL1 protein (cytoplasm)
  private B1 = 0.5; // BMAL1 protein (phosphorylated)
  private Bn = 0.5; // BMAL1 protein (nucleus)
  private IN = 0.5; // Inactive complex (nuclear)

  // Parameters (simplified)
  private readonly vsP = 1.0; // PER transcription max rate
  private readonly vsC = 1.0; // CRY transcription max rate
  private readonly vsB = 1.0; // BMAL1 transcription max rate
  private readonly vmP = 0.7; // PER mRNA degradation max rate
  private readonly vmC = 0.7; // CRY mRNA degradation max rate
  private readonly vmB = 0.9; // BMAL1 mRNA degradation max rate
  private readonly KmP = 0.3; // PER degradation Km
  private readonly KmC = 0.4; // CRY degradation Km
  private readonly KmB = 0.4; // BMAL1 degradation Km
  private readonly KIP = 1.0; // PER transcription inhibition
  private readonly KIB = 2.2; // BMAL1 transcription activation
  private readonly n = 4; // Hill coefficient

  /**
   * Hill function for activation
   */
  private hillActivation(x: number, K: number, n: number): number {
    const xn = x ** n;
    const Kn = K ** n;
    return xn / (Kn + xn);
  }

  /**
   * Hill function for repression
   */
  private hillRepression(x: number, K: number, n: number): number {
    const Kn = K ** n;
    const xn = x ** n;
    return Kn / (Kn + xn);
  }

  /**
   * Compute all derivatives (simplified 16-variable model)
   */
  private computeDerivatives(): number[] {
    // Active nuclear CLOCK-BMAL1 (promoter binding)
    const _CB = Math.max(0.001, this.Bn);

    // PER transcription (repressed by nuclear PER-CRY)
    const dMp =
      this.vsP * this.hillRepression(this.PCn, this.KIP, this.n) -
      (this.vmP * this.Mp) / (this.KmP + this.Mp);

    // CRY transcription
    const dMc =
      this.vsC * this.hillRepression(this.PCn, this.KIP, this.n) -
      (this.vmC * this.Mc) / (this.KmC + this.Mc);

    // BMAL1 transcription (activated by ROR, repressed by REV-ERB, simplified to PER-CRY repression)
    const dMb =
      this.vsB * this.hillActivation(this.PCn, this.KIB, this.n) -
      (this.vmB * this.Mb) / (this.KmB + this.Mb);

    // PER protein dynamics
    const ksP = 0.9; // Translation rate
    const V1P = 0.8; // Phosphorylation rate
    const V2P = 0.1; // Dephosphorylation rate
    const V3P = 0.8;
    const V4P = 0.1;
    const KdP = 0.2; // Degradation rate
    const K1P = 2.0; // Phosphorylation Km
    const K2P = 2.0;
    const K3P = 2.0;
    const K4P = 2.0;
    const KdPn = 0.2;

    const dP0 =
      ksP * this.Mp -
      (V1P * this.P0) / (K1P + this.P0) +
      (V2P * this.P1) / (K2P + this.P1) -
      KdP * this.P0;
    const dP1 =
      (V1P * this.P0) / (K1P + this.P0) -
      (V2P * this.P1) / (K2P + this.P1) -
      (V3P * this.P1) / (K3P + this.P1) +
      (V4P * this.P2) / (K4P + this.P2) -
      KdP * this.P1;
    const dP2 =
      (V3P * this.P1) / (K3P + this.P1) -
      (V4P * this.P2) / (K4P + this.P2) -
      KdPn * this.P2 -
      this.P2 * this.C2 * 0.5; // Complex formation

    // CRY protein dynamics (similar structure)
    const ksC = 0.9;
    const V1C = 0.6;
    const V2C = 0.1;
    const V3C = 0.6;
    const V4C = 0.1;
    const KdC = 0.2;
    const K1C = 2.0;
    const K2C = 2.0;
    const K3C = 2.0;
    const K4C = 2.0;

    const dC0 =
      ksC * this.Mc -
      (V1C * this.C0) / (K1C + this.C0) +
      (V2C * this.C1) / (K2C + this.C1) -
      KdC * this.C0;
    const dC1 =
      (V1C * this.C0) / (K1C + this.C0) -
      (V2C * this.C1) / (K2C + this.C1) -
      (V3C * this.C1) / (K3C + this.C1) +
      (V4C * this.C2) / (K4C + this.C2) -
      KdC * this.C1;
    const dC2 =
      (V3C * this.C1) / (K3C + this.C1) -
      (V4C * this.C2) / (K4C + this.C2) -
      KdC * this.C2 -
      this.P2 * this.C2 * 0.5;

    // PER-CRY complex
    const k3 = 0.5; // Complex formation rate
    const k4 = 0.1; // Complex dissociation rate
    const k1 = 0.4; // Nuclear import rate
    const k2 = 0.2; // Nuclear export rate
    const kdPC = 0.1;
    const kdPCn = 0.1;

    const dPC =
      k3 * this.P2 * this.C2 -
      k4 * this.PC -
      k1 * this.PC +
      k2 * this.PCn -
      kdPC * this.PC;
    const dPCn = k1 * this.PC - k2 * this.PCn - kdPCn * this.PCn;

    // BMAL1 protein dynamics
    const ksB = 0.9;
    const V1B = 0.5;
    const V2B = 0.1;
    const V3B = 0.5;
    const V4B = 0.2;
    const KdB = 0.2;
    const K1B = 2.0;
    const K2B = 2.0;
    const K3B = 2.0;
    const K4B = 2.0;

    const dB0 =
      ksB * this.Mb -
      (V1B * this.B0) / (K1B + this.B0) +
      (V2B * this.B1) / (K2B + this.B1) -
      KdB * this.B0;
    const dB1 =
      (V1B * this.B0) / (K1B + this.B0) -
      (V2B * this.B1) / (K2B + this.B1) -
      (V3B * this.B1) / (K3B + this.B1) +
      (V4B * this.Bn) / (K4B + this.Bn) -
      KdB * this.B1;
    const dBn =
      (V3B * this.B1) / (K3B + this.B1) -
      (V4B * this.Bn) / (K4B + this.Bn) -
      KdB * this.Bn;

    // Inactive complex
    const dIN = kdPCn * this.PCn * 0.1 - 0.1 * this.IN;

    return [
      dMp,
      dMc,
      dMb,
      dP0,
      dP1,
      dP2,
      dC0,
      dC1,
      dC2,
      dPC,
      dPCn,
      dB0,
      dB1,
      dBn,
      dIN,
    ];
  }

  /**
   * Set state from array
   */
  private setStateFromArray(arr: number[]): void {
    this.Mp = arr[0];
    this.Mc = arr[1];
    this.Mb = arr[2];
    this.P0 = arr[3];
    this.P1 = arr[4];
    this.P2 = arr[5];
    this.C0 = arr[6];
    this.C1 = arr[7];
    this.C2 = arr[8];
    this.PC = arr[9];
    this.PCn = arr[10];
    this.B0 = arr[11];
    this.B1 = arr[12];
    this.Bn = arr[13];
    this.IN = arr[14];
  }

  /**
   * Get state as array
   */
  private getStateAsArray(): number[] {
    return [
      this.Mp,
      this.Mc,
      this.Mb,
      this.P0,
      this.P1,
      this.P2,
      this.C0,
      this.C1,
      this.C2,
      this.PC,
      this.PCn,
      this.B0,
      this.B1,
      this.Bn,
      this.IN,
    ];
  }

  /**
   * Advance by dt using RK4
   */
  step(dt: number): void {
    const state = this.getStateAsArray();

    const k1 = this.computeDerivatives();

    // k2
    const s2 = state.map((s, i) => s + 0.5 * dt * k1[i]);
    this.setStateFromArray(s2);
    const k2 = this.computeDerivatives();

    // k3
    const s3 = state.map((s, i) => s + 0.5 * dt * k2[i]);
    this.setStateFromArray(s3);
    const k3 = this.computeDerivatives();

    // k4
    const s4 = state.map((s, i) => s + dt * k3[i]);
    this.setStateFromArray(s4);
    const k4 = this.computeDerivatives();

    // Update
    const newState = state.map((s, i) =>
      Math.max(0.001, s + (dt / 6) * (k1[i] + 2 * k2[i] + 2 * k3[i] + k4[i])),
    );
    this.setStateFromArray(newState);
  }

  /**
   * Get clock gene expression
   */
  getClockGenes(): ClockGeneExpression {
    return {
      CLOCK: 1.0, // Assumed constant
      BMAL1: this.B0 + this.B1 + this.Bn,
      PER1: this.P0 + this.P1 + this.P2,
      PER2: this.P0 + this.P1 + this.P2, // Simplified: same as PER1
      CRY1: this.C0 + this.C1 + this.C2,
      CRY2: this.C0 + this.C1 + this.C2,
      REV_ERB_alpha: this.PCn, // Simplified proxy
      REV_ERB_beta: this.PCn * 0.8,
      ROR_alpha: this.Bn,
    };
  }

  /**
   * Get circadian phase
   */
  getPhase(): number {
    // Use PER mRNA as phase marker
    return Math.atan2(this.P0 - 0.5, this.Mp - 0.5) + Math.PI;
  }

  /**
   * Apply light pulse at current phase
   */
  applyLight(intensity: number): void {
    // Light induces PER transcription
    this.Mp += intensity * 0.2;
    this.Mp = Math.min(2, this.Mp);
  }
}

// ============================================================================
// SECTION 4: ULTRADIAN RHYTHM GENERATORS
// ============================================================================

/**
 * Heart Rate Variability (HRV) Generator
 * Models beat-to-beat heart rate variations
 */
export class HRVGenerator {
  private readonly baseHR: number; // Base heart rate (bpm)
  private currentRR: number; // Current RR interval (ms)
  private previousRR: number;
  private readonly rmssd: number; // Target RMSSD
  private phase = 0;

  // Spectral components
  private readonly vlfPower: number; // Very low frequency power
  private readonly lfPower: number; // Low frequency power (sympathetic)
  private readonly hfPower: number; // High frequency power (parasympathetic)

  constructor(baseHR = 70, rmssd = 40) {
    this.baseHR = baseHR;
    this.rmssd = rmssd;
    this.currentRR = 60000 / baseHR;
    this.previousRR = this.currentRR;

    // Default power distribution
    this.vlfPower = 0.4;
    this.lfPower = 0.3;
    this.hfPower = 0.3;
  }

  /**
   * Generate next RR interval
   */
  nextBeat(respiratoryPhase: number): number {
    const baseRR = 60000 / this.baseHR;

    // VLF component (~0.003-0.04 Hz)
    const vlfFreq = 0.02;
    const vlfComponent =
      Math.sin(2 * Math.PI * vlfFreq * this.phase) * this.vlfPower * 50;

    // LF component (~0.04-0.15 Hz) - Mayer waves, blood pressure regulation
    const lfFreq = 0.1;
    const lfComponent =
      Math.sin(2 * Math.PI * lfFreq * this.phase) * this.lfPower * 30;

    // HF component (~0.15-0.4 Hz) - Respiratory sinus arrhythmia
    const hfComponent = Math.sin(respiratoryPhase) * this.hfPower * 20;

    // Random component (Gaussian noise)
    const noise = this.gaussianRandom() * 10;

    this.previousRR = this.currentRR;
    this.currentRR = baseRR + vlfComponent + lfComponent + hfComponent + noise;
    this.currentRR = Math.max(400, Math.min(1500, this.currentRR)); // Physiological limits

    this.phase += this.currentRR / 1000; // Advance phase

    return this.currentRR;
  }

  /**
   * Box-Muller transform for Gaussian random
   */
  private gaussianRandom(): number {
    const u1 = Math.random();
    const u2 = Math.random();
    return Math.sqrt(-2 * Math.log(u1)) * Math.cos(2 * Math.PI * u2);
  }

  /**
   * Compute HRV metrics
   */
  computeMetrics(rrIntervals: number[]): {
    meanRR: number;
    sdnn: number;
    rmssd: number;
    pnn50: number;
    lfhfRatio: number;
  } {
    const n = rrIntervals.length;
    if (n < 2) return { meanRR: 0, sdnn: 0, rmssd: 0, pnn50: 0, lfhfRatio: 0 };

    // Mean RR
    const meanRR = rrIntervals.reduce((a, b) => a + b, 0) / n;

    // SDNN (standard deviation of all RR intervals)
    const variance =
      rrIntervals.reduce((sum, rr) => sum + (rr - meanRR) ** 2, 0) / n;
    const sdnn = Math.sqrt(variance);

    // RMSSD (root mean square of successive differences)
    let sumSquaredDiff = 0;
    let countNN50 = 0;
    for (let i = 1; i < n; i++) {
      const diff = rrIntervals[i] - rrIntervals[i - 1];
      sumSquaredDiff += diff ** 2;
      if (Math.abs(diff) > 50) countNN50++;
    }
    const rmssd = Math.sqrt(sumSquaredDiff / (n - 1));

    // pNN50
    const pnn50 = countNN50 / (n - 1);

    // LF/HF ratio (simplified estimate)
    const lfhfRatio = this.lfPower / this.hfPower;

    return { meanRR, sdnn, rmssd, pnn50, lfhfRatio };
  }

  /**
   * Get current state
   */
  getCurrentRR(): number {
    return this.currentRR;
  }

  /**
   * Get instantaneous heart rate
   */
  getHeartRate(): number {
    return 60000 / this.currentRR;
  }
}

/**
 * Respiratory Rhythm Generator
 * Models breathing cycle with variability
 */
export class RespiratoryRhythmGenerator {
  private phase = 0;
  private readonly baseRate: number; // Breaths per minute
  private currentDepth = 1; // Relative tidal volume
  private readonly ieRatio: number; // Inspiration:Expiration ratio

  constructor(baseRate = 15, ieRatio = 0.4) {
    this.baseRate = baseRate;
    this.ieRatio = ieRatio;
  }

  /**
   * Advance respiratory cycle
   */
  step(dt: number): void {
    const frequency = this.baseRate / 60; // Hz
    this.phase += 2 * Math.PI * frequency * dt;
    this.phase = this.phase % (2 * Math.PI);

    // Add some variability to depth
    this.currentDepth =
      1 + 0.1 * Math.sin(this.phase * 0.1) + 0.05 * (Math.random() - 0.5);
    this.currentDepth = Math.max(0.5, Math.min(1.5, this.currentDepth));
  }

  /**
   * Get current respiratory phase
   */
  getPhase(): number {
    return this.phase;
  }

  /**
   * Get current flow (positive = inspiration, negative = expiration)
   */
  getFlow(): number {
    // Modified sine wave for asymmetric breathing
    const normalizedPhase = this.phase / (2 * Math.PI);

    if (normalizedPhase < this.ieRatio) {
      // Inspiration
      return (
        this.currentDepth * Math.sin((Math.PI * normalizedPhase) / this.ieRatio)
      );
    }
    // Expiration
    const expPhase = (normalizedPhase - this.ieRatio) / (1 - this.ieRatio);
    return -this.currentDepth * Math.sin(Math.PI * expPhase);
  }

  /**
   * Is currently inspiring?
   */
  isInspiring(): boolean {
    return this.phase < 2 * Math.PI * this.ieRatio;
  }

  /**
   * Get current respiratory rate
   */
  getRate(): number {
    return this.baseRate;
  }

  /**
   * Modulate rate (e.g., due to stress, exercise)
   */
  modulateRate(factor: number): number {
    return this.baseRate * factor;
  }
}

/**
 * Brain Wave Generator
 * Generates EEG-like signals for different states
 */
export class BrainWaveGenerator {
  private readonly samplingRate: number; // Hz
  private time = 0;

  // Band powers (relative)
  private deltaPower = 0.1; // 0.5-4 Hz
  private thetaPower = 0.15; // 4-8 Hz
  private alphaPower = 0.4; // 8-13 Hz
  private betaPower = 0.25; // 13-30 Hz
  private gammaPower = 0.1; // 30-100 Hz

  constructor(samplingRate = 256) {
    this.samplingRate = samplingRate;
  }

  /**
   * Set state-dependent band powers
   */
  setState(
    state:
      | "awake_alert"
      | "awake_relaxed"
      | "drowsy"
      | "light_sleep"
      | "deep_sleep"
      | "REM",
  ): void {
    switch (state) {
      case "awake_alert":
        this.deltaPower = 0.05;
        this.thetaPower = 0.1;
        this.alphaPower = 0.2;
        this.betaPower = 0.45;
        this.gammaPower = 0.2;
        break;
      case "awake_relaxed":
        this.deltaPower = 0.05;
        this.thetaPower = 0.15;
        this.alphaPower = 0.5;
        this.betaPower = 0.2;
        this.gammaPower = 0.1;
        break;
      case "drowsy":
        this.deltaPower = 0.1;
        this.thetaPower = 0.35;
        this.alphaPower = 0.35;
        this.betaPower = 0.15;
        this.gammaPower = 0.05;
        break;
      case "light_sleep":
        this.deltaPower = 0.2;
        this.thetaPower = 0.4;
        this.alphaPower = 0.2;
        this.betaPower = 0.15;
        this.gammaPower = 0.05;
        break;
      case "deep_sleep":
        this.deltaPower = 0.7;
        this.thetaPower = 0.2;
        this.alphaPower = 0.05;
        this.betaPower = 0.04;
        this.gammaPower = 0.01;
        break;
      case "REM":
        this.deltaPower = 0.1;
        this.thetaPower = 0.35;
        this.alphaPower = 0.15;
        this.betaPower = 0.25;
        this.gammaPower = 0.15;
        break;
    }
  }

  /**
   * Generate next sample
   */
  nextSample(): number {
    this.time += 1 / this.samplingRate;

    // Generate each frequency band
    const delta = this.deltaPower * this.bandNoise(0.5, 4);
    const theta = this.thetaPower * this.bandNoise(4, 8);
    const alpha = this.alphaPower * this.bandNoise(8, 13);
    const beta = this.betaPower * this.bandNoise(13, 30);
    const gamma = this.gammaPower * this.bandNoise(30, 50);

    return delta + theta + alpha + beta + gamma;
  }

  /**
   * Generate band-limited noise (sum of sinusoids)
   */
  private bandNoise(fLow: number, fHigh: number): number {
    let sum = 0;
    const numComponents = 5;

    for (let i = 0; i < numComponents; i++) {
      const f = fLow + (fHigh - fLow) * Math.random();
      const phase = Math.random() * 2 * Math.PI;
      const amp = 1 / numComponents;
      sum += amp * Math.sin(2 * Math.PI * f * this.time + phase);
    }

    return sum;
  }

  /**
   * Get current dominant frequency
   */
  getDominantFrequency(): number {
    const powers = [
      { band: "delta", power: this.deltaPower, freq: 2 },
      { band: "theta", power: this.thetaPower, freq: 6 },
      { band: "alpha", power: this.alphaPower, freq: 10 },
      { band: "beta", power: this.betaPower, freq: 20 },
      { band: "gamma", power: this.gammaPower, freq: 40 },
    ];

    powers.sort((a, b) => b.power - a.power);
    return powers[0].freq;
  }

  /**
   * Get band powers
   */
  getBandPowers(): {
    delta: number;
    theta: number;
    alpha: number;
    beta: number;
    gamma: number;
  } {
    return {
      delta: this.deltaPower,
      theta: this.thetaPower,
      alpha: this.alphaPower,
      beta: this.betaPower,
      gamma: this.gammaPower,
    };
  }
}

// ============================================================================
// SECTION 5: SLEEP-WAKE REGULATION MODEL
// ============================================================================

/**
 * Two-Process Model of Sleep Regulation
 * Process S (homeostatic sleep drive) + Process C (circadian modulation)
 */
export class TwoProcessSleepModel {
  private S: number; // Sleep homeostatic pressure
  private C: number; // Circadian alertness signal
  private readonly Smax: number = 1.0; // Maximum sleep pressure
  private readonly Smin: number = 0.0; // Minimum sleep pressure
  private readonly tauW: number = 18.2; // Wake time constant (hours)
  private readonly tauS: number = 4.2; // Sleep time constant (hours)
  private isAsleep = false;
  private timeAsleep = 0;
  private timeAwake = 0;

  constructor(initialS = 0.3) {
    this.S = initialS;
    this.C = 0.5;
  }

  /**
   * Update homeostatic process S
   */
  private updateS(dt: number): void {
    const dtHours = dt / 3600;

    if (this.isAsleep) {
      // Exponential decay during sleep
      this.S = this.S * Math.exp(-dtHours / this.tauS);
      this.S = Math.max(this.Smin, this.S);
      this.timeAsleep += dtHours;
    } else {
      // Exponential rise during wake
      this.S =
        this.Smax - (this.Smax - this.S) * Math.exp(-dtHours / this.tauW);
      this.S = Math.min(this.Smax, this.S);
      this.timeAwake += dtHours;
    }
  }

  /**
   * Update circadian process C
   */
  private updateC(circadianPhase: number): void {
    // C follows circadian oscillation - peaks in late afternoon, nadir in early morning
    // Phase 0 = midnight, π = noon
    this.C = 0.5 + 0.5 * Math.cos(circadianPhase - Math.PI * 0.75); // Shifted to peak ~16:00

    // Add wake maintenance zone (early evening dip in sleepiness)
    const eveningTime = (circadianPhase / (2 * Math.PI)) * 24; // Hours from midnight
    if (eveningTime > 19 && eveningTime < 22) {
      this.C += 0.2 * Math.sin(((eveningTime - 19) * Math.PI) / 3);
    }
  }

  /**
   * Compute sleep propensity
   */
  getSleepPropensity(): number {
    // High S and low C → high sleep propensity
    return this.S * (1 - this.C);
  }

  /**
   * Compute alertness
   */
  getAlertness(): number {
    // Low S and high C → high alertness
    return (1 - this.S) * this.C;
  }

  /**
   * Step the model
   */
  step(dt: number, circadianPhase: number): void {
    this.updateS(dt);
    this.updateC(circadianPhase);

    // Automatic sleep/wake transitions
    const propensity = this.getSleepPropensity();

    if (!this.isAsleep && propensity > 0.7 && this.timeAwake > 14) {
      // Fall asleep if very sleepy and awake long enough
      this.isAsleep = true;
      this.timeAsleep = 0;
    } else if (this.isAsleep && (propensity < 0.2 || this.timeAsleep > 9)) {
      // Wake up if not sleepy or slept enough
      this.isAsleep = false;
      this.timeAwake = 0;
    }
  }

  /**
   * Force sleep state
   */
  setSleepState(asleep: boolean): void {
    if (asleep !== this.isAsleep) {
      this.isAsleep = asleep;
      if (asleep) {
        this.timeAsleep = 0;
      } else {
        this.timeAwake = 0;
      }
    }
  }

  /**
   * Get current state
   */
  getState(): {
    S: number;
    C: number;
    isAsleep: boolean;
    propensity: number;
    alertness: number;
  } {
    return {
      S: this.S,
      C: this.C,
      isAsleep: this.isAsleep,
      propensity: this.getSleepPropensity(),
      alertness: this.getAlertness(),
    };
  }
}

/**
 * Sleep Stage Sequencer
 * Models progression through sleep stages
 */
export class SleepStageSequencer {
  private currentStage: SleepStage = "wake";
  private timeInStage = 0;
  private cycleNumber = 0;
  private totalSleepTime = 0;
  private sleepOnset = 0;

  // Stage durations (minutes) - vary by cycle
  private readonly stageDurations: Map<SleepStage, number[]> = new Map([
    ["wake", [0, 0, 0, 0, 0]],
    ["N1", [5, 3, 2, 2, 2]],
    ["N2", [25, 30, 35, 40, 45]],
    ["N3", [30, 20, 10, 5, 0]],
    ["REM", [10, 20, 25, 30, 35]],
  ]);

  // Transition probabilities
  private readonly transitions: Map<SleepStage, SleepStage[]> = new Map([
    ["wake", ["N1"]],
    ["N1", ["N2"]],
    ["N2", ["N3", "REM"]], // Early cycles → N3, later cycles → REM
    ["N3", ["N2"]],
    ["REM", ["N2", "wake"]],
  ]);

  /**
   * Initialize sleep onset
   */
  beginSleep(onsetTime: number): void {
    this.sleepOnset = onsetTime;
    this.currentStage = "N1";
    this.timeInStage = 0;
    this.cycleNumber = 0;
    this.totalSleepTime = 0;
  }

  /**
   * Advance sleep by dt minutes
   */
  step(dt: number, sleepPressure: number): void {
    if (this.currentStage === "wake") return;

    this.timeInStage += dt;
    this.totalSleepTime += dt;

    // Get expected duration for current stage in current cycle
    const durations = this.stageDurations.get(this.currentStage) || [15];
    const cycleIdx = Math.min(this.cycleNumber, durations.length - 1);
    const expectedDuration = durations[cycleIdx] * (0.8 + Math.random() * 0.4); // Add variability

    // Check for stage transition
    if (this.timeInStage >= expectedDuration) {
      this.transitionStage(sleepPressure);
    }
  }

  /**
   * Transition to next stage
   */
  private transitionStage(sleepPressure: number): void {
    const possibleNext = this.transitions.get(this.currentStage) || ["N2"];

    let nextStage: SleepStage;

    if (this.currentStage === "N2") {
      // Early cycles favor deep sleep, later cycles favor REM
      nextStage = this.cycleNumber < 2 && sleepPressure > 0.3 ? "N3" : "REM";
    } else if (this.currentStage === "REM") {
      // After REM, usually go back to N2 (start new cycle) or wake up
      if (this.cycleNumber >= 4 && Math.random() < 0.3) {
        nextStage = "wake";
      } else {
        nextStage = "N2";
        this.cycleNumber++;
      }
    } else {
      nextStage = possibleNext[0];
    }

    this.currentStage = nextStage;
    this.timeInStage = 0;
  }

  /**
   * Get current state
   */
  getState(): SleepArchitecture {
    return {
      currentStage: this.currentStage,
      cycleNumber: this.cycleNumber,
      timeInStage: this.timeInStage,
      sleepOnset: this.sleepOnset,
      totalSleepTime: this.totalSleepTime,
      sleepEfficiency: 0.9, // Simplified
      REMLatency: 90, // Approximate
      slowWaveActivity:
        this.currentStage === "N3"
          ? 0.8
          : this.currentStage === "N2"
            ? 0.3
            : 0.1,
    };
  }

  /**
   * Get current stage
   */
  getCurrentStage(): SleepStage {
    return this.currentStage;
  }

  /**
   * Is currently in REM?
   */
  isREM(): boolean {
    return this.currentStage === "REM";
  }

  /**
   * Is currently in deep sleep?
   */
  isDeepSleep(): boolean {
    return this.currentStage === "N3";
  }
}

// ============================================================================
// SECTION 6: HORMONE CIRCADIAN PROFILES
// ============================================================================

/**
 * Hormone Rhythm Generator
 * Models circadian hormone secretion patterns
 */
export class HormoneRhythmGenerator {
  private profiles: Map<string, HormoneProfile> = new Map();
  private currentLevels: Map<string, number> = new Map();

  constructor() {
    this.initializeHormones();
  }

  /**
   * Initialize hormone profiles with their circadian patterns
   */
  private initializeHormones(): void {
    // Cortisol: peaks early morning (CAR), nadir at midnight
    this.profiles.set("cortisol", {
      name: "cortisol",
      currentLevel: 0.5,
      peakTime: 8, // 8 AM
      nadir: 0, // Midnight
      amplitude: 0.6,
      halfLife: 1,
    });

    // Melatonin: peaks at night, suppressed by light
    this.profiles.set("melatonin", {
      name: "melatonin",
      currentLevel: 0.5,
      peakTime: 3, // 3 AM
      nadir: 14, // 2 PM
      amplitude: 0.8,
      halfLife: 0.5,
    });

    // Growth Hormone: peaks during deep sleep
    this.profiles.set("growth_hormone", {
      name: "growth_hormone",
      currentLevel: 0.3,
      peakTime: 1, // 1 AM
      nadir: 12, // Noon
      amplitude: 0.7,
      halfLife: 0.3,
    });

    // Testosterone: peaks in early morning
    this.profiles.set("testosterone", {
      name: "testosterone",
      currentLevel: 0.5,
      peakTime: 8, // 8 AM
      nadir: 20, // 8 PM
      amplitude: 0.3,
      halfLife: 2,
    });

    // TSH (Thyroid Stimulating Hormone): nocturnal rise
    this.profiles.set("TSH", {
      name: "TSH",
      currentLevel: 0.5,
      peakTime: 2, // 2 AM
      nadir: 14, // 2 PM
      amplitude: 0.4,
      halfLife: 1,
    });

    // Prolactin: nocturnal rise
    this.profiles.set("prolactin", {
      name: "prolactin",
      currentLevel: 0.5,
      peakTime: 4, // 4 AM
      nadir: 15, // 3 PM
      amplitude: 0.5,
      halfLife: 0.4,
    });

    // Leptin: nocturnal rise
    this.profiles.set("leptin", {
      name: "leptin",
      currentLevel: 0.5,
      peakTime: 2, // 2 AM
      nadir: 13, // 1 PM
      amplitude: 0.4,
      halfLife: 0.75,
    });

    // Ghrelin: peaks before meals
    this.profiles.set("ghrelin", {
      name: "ghrelin",
      currentLevel: 0.5,
      peakTime: 7, // 7 AM (before breakfast)
      nadir: 9, // After breakfast
      amplitude: 0.4,
      halfLife: 0.3,
    });

    // Initialize current levels
    for (const [name] of this.profiles) {
      this.currentLevels.set(name, 0.5);
    }
  }

  /**
   * Update hormone levels based on time of day
   */
  update(timeOfDay: number, sleepState: SleepStage): void {
    for (const [name, profile] of this.profiles) {
      let level = this.computeCircadianLevel(timeOfDay, profile);

      // Modulate based on sleep state
      level = this.modulateBySleep(name, level, sleepState);

      this.currentLevels.set(name, level);
    }
  }

  /**
   * Compute base circadian level
   */
  private computeCircadianLevel(
    timeOfDay: number,
    profile: HormoneProfile,
  ): number {
    const phase = ((timeOfDay - profile.peakTime) / 24) * 2 * Math.PI;
    // Use currentLevel as baseline (mesor-equivalent) + amplitude modulation
    const level = profile.currentLevel + profile.amplitude * Math.cos(phase);
    return Math.max(0, Math.min(1, level));
  }

  /**
   * Modulate hormone level based on sleep state
   */
  private modulateBySleep(
    hormone: string,
    baseLevel: number,
    sleepState: SleepStage,
  ): number {
    let modifier = 1;

    switch (hormone) {
      case "growth_hormone":
        // Peaks during deep sleep (N3)
        if (sleepState === "N3") modifier = 1.5;
        else if (sleepState === "wake") modifier = 0.3;
        break;

      case "cortisol":
        // Suppressed during sleep, surges on waking
        if (sleepState === "wake") modifier = 1.2;
        else modifier = 0.6;
        break;

      case "melatonin":
        // High during sleep, suppressed by waking/light
        if (sleepState === "wake") modifier = 0.2;
        else modifier = 1.3;
        break;

      case "prolactin":
        // Elevated during sleep, especially REM
        if (sleepState === "REM") modifier = 1.4;
        else if (sleepState === "wake") modifier = 0.7;
        break;
    }

    return Math.max(0, Math.min(1, baseLevel * modifier));
  }

  /**
   * Get current level of a hormone
   */
  getLevel(hormone: string): number {
    return this.currentLevels.get(hormone) || 0.5;
  }

  /**
   * Get all hormone levels
   */
  getAllLevels(): Map<string, number> {
    return new Map(this.currentLevels);
  }

  /**
   * Get hormone profiles
   */
  getProfiles(): Map<string, HormoneProfile> {
    return new Map(this.profiles);
  }

  /**
   * Apply external hormone (e.g., melatonin supplement)
   */
  applyExternalHormone(hormone: string, dose: number): void {
    const current = this.currentLevels.get(hormone) || 0.5;
    this.currentLevels.set(hormone, Math.min(1, current + dose));
  }
}

// ============================================================================
// SECTION 7: TEMPERATURE REGULATION
// ============================================================================

/**
 * Body Temperature Rhythm Controller
 * Models core and peripheral temperature circadian rhythms
 */
export class TemperatureRhythmController {
  private coreTemp = 37.0; // °C
  private peripheralTemp = 33.0; // °C
  private readonly setPoint: number = 37.0;

  // Circadian variation parameters
  private readonly coreAmplitude: number = 0.5; // °C
  private readonly coreAcrophase: number = 18; // 6 PM
  private readonly coreBathyphase: number = 5; // 5 AM

  /**
   * Update temperatures based on time and state
   */
  update(
    timeOfDay: number,
    sleepState: SleepStage,
    metabolicRate: number,
  ): void {
    // Compute circadian core temperature
    const phase = ((timeOfDay - this.coreAcrophase) / 24) * 2 * Math.PI;
    const circadianCore = this.setPoint + this.coreAmplitude * Math.cos(phase);

    // Modify based on sleep state
    let sleepModifier = 0;
    if (sleepState === "N3") {
      sleepModifier = -0.3; // Deeper sleep = lower temp
    } else if (sleepState === "REM") {
      sleepModifier = -0.1;
    } else if (sleepState === "wake") {
      sleepModifier = 0.2; // Active = higher temp
    }

    // Modify based on metabolic rate
    const metabolicModifier = (metabolicRate - 1) * 0.5;

    // Update core temperature with some smoothing
    const targetCore = circadianCore + sleepModifier + metabolicModifier;
    this.coreTemp = 0.9 * this.coreTemp + 0.1 * targetCore;

    // Peripheral temperature follows core with lag and larger variation
    // Also affected by vasodilation before sleep
    const preSleepVasodilation = timeOfDay > 21 || timeOfDay < 5 ? 1 : 0;
    const targetPeripheral = this.coreTemp - 4 + preSleepVasodilation * 2;
    this.peripheralTemp = 0.85 * this.peripheralTemp + 0.15 * targetPeripheral;
  }

  /**
   * Get current temperature state
   */
  getState(): TemperatureRhythm {
    return {
      coreTemperature: this.coreTemp,
      peripheralTemperature: this.peripheralTemp,
      gradient: this.coreTemp - this.peripheralTemp,
      phase: 0, // Would need to track
      minimum: this.coreBathyphase,
      maximum: this.coreAcrophase,
    };
  }

  /**
   * Get distal-proximal gradient (sleep propensity indicator)
   */
  getDPG(): number {
    // Higher DPG = better heat dissipation = sleepier
    return this.peripheralTemp - (this.coreTemp - 4);
  }

  /**
   * Apply external temperature challenge
   */
  applyChallenge(deltaCore: number, deltaPeripheral: number): void {
    this.coreTemp += deltaCore;
    this.peripheralTemp += deltaPeripheral;
  }
}

// ============================================================================
// SECTION 8: PERFORMANCE AND ALERTNESS RHYTHMS
// ============================================================================

/**
 * Alertness and Performance Rhythm Calculator
 */
export class AlertnessCalculator {
  /**
   * Compute alertness based on circadian and homeostatic factors
   */
  computeAlertness(
    circadianPhase: number,
    sleepPressure: number,
    timeAwake: number,
    caffeineLevel = 0,
  ): AlertnessRhythm {
    // Base circadian alertness (peaks around 10 AM and 7 PM)
    const circadianAlertness =
      0.5 +
      0.3 * Math.cos(circadianPhase - Math.PI * 0.4) +
      0.1 * Math.cos(2 * circadianPhase - Math.PI);

    // Homeostatic component (decreases with time awake)
    const homeostaticAlertness = Math.exp(-timeAwake / 15);

    // Sleep inertia (if recently woke up)
    const sleepInertia = timeAwake < 0.5 ? (timeAwake / 0.5) ** 2 : 1;

    // Caffeine effect (blocks adenosine)
    const caffeineEffect = caffeineLevel * 0.3;

    // Combined alertness
    let alertness =
      circadianAlertness * homeostaticAlertness * sleepInertia + caffeineEffect;
    alertness = Math.max(0, Math.min(1, alertness));

    // Cognitive performance follows similar pattern
    const cognitivePerformance = 0.8 * alertness + 0.2 * circadianAlertness;

    // Reaction time (inverse of alertness)
    const reactionTime = 0.5 + 0.5 * (1 - alertness);

    // Memory consolidation (best in morning after sleep)
    const memoryConsolidation = Math.max(
      0,
      0.5 + 0.3 * Math.cos(circadianPhase) - sleepPressure * 0.3,
    );

    // Creativity (best in late evening, especially for night owls)
    const creativityIndex =
      0.5 + 0.2 * Math.sin(circadianPhase - Math.PI * 0.7);

    return {
      alertness,
      cognitivePerformance,
      reactionTime,
      memoryConsolidation,
      creativityIndex,
      timeOfDayEffect: circadianAlertness,
    };
  }

  /**
   * Compute optimal time for specific tasks
   */
  computeOptimalTaskTimes(): {
    analyticalWork: [number, number];
    creativeWork: [number, number];
    physicalExercise: [number, number];
    learning: [number, number];
    decisionMaking: [number, number];
  } {
    return {
      analyticalWork: [9, 11], // Morning peak
      creativeWork: [20, 23], // Evening, lower inhibition
      physicalExercise: [16, 19], // Afternoon, peak body temp
      learning: [10, 12], // Morning, good attention
      decisionMaking: [10, 14], // Late morning to early afternoon
    };
  }
}

// ============================================================================
// SECTION 9: METABOLIC RHYTHMS
// ============================================================================

/**
 * Metabolic Rhythm Controller
 * Models circadian aspects of metabolism
 */
export class MetabolicRhythmController {
  private glucoseLevel = 1.0; // Relative
  private insulinSensitivity = 1.0;
  private metabolicRate = 1.0;

  /**
   * Update metabolic state
   */
  update(
    timeOfDay: number,
    lastMealTime: number,
    exerciseLevel: number,
  ): MetabolicRhythm {
    // Circadian glucose tolerance (best in morning)
    const _glucoseTolerance =
      0.8 + 0.2 * Math.cos(((timeOfDay - 8) / 24) * 2 * Math.PI);

    // Insulin sensitivity follows circadian pattern (higher in morning)
    this.insulinSensitivity =
      0.7 + 0.3 * Math.cos(((timeOfDay - 6) / 24) * 2 * Math.PI);

    // Postprandial glucose rise depends on time since meal
    const timeSinceMeal = (timeOfDay - lastMealTime + 24) % 24;
    const postprandialRise =
      timeSinceMeal < 2 ? 0.3 * Math.exp(-timeSinceMeal) : 0;

    this.glucoseLevel =
      1.0 + postprandialRise - (this.insulinSensitivity - 0.7) * 0.5;

    // Basal metabolic rate (higher in late afternoon)
    this.metabolicRate =
      1.0 + 0.1 * Math.cos(((timeOfDay - 17) / 24) * 2 * Math.PI);
    this.metabolicRate *= 1 + exerciseLevel * 0.5;

    // Lipid oxidation (higher in morning, fasted state)
    const lipidOxidation =
      0.5 + 0.3 * Math.cos(((timeOfDay - 8) / 24) * 2 * Math.PI);

    // Thermic effect of food
    const thermalEffectOfFood =
      timeSinceMeal < 4 ? 0.1 * Math.exp(-timeSinceMeal / 2) : 0;

    return {
      glucoseLevel: this.glucoseLevel,
      insulinSensitivity: this.insulinSensitivity,
      lipidOxidation,
      thermalEffectOfFood,
      metabolicRate: this.metabolicRate,
      feedingWindow: [7, 19], // Optimal eating window
    };
  }

  /**
   * Get glycemic response prediction
   */
  predictGlycemicResponse(carbLoad: number, timeOfDay: number): number {
    // Higher glycemic response in evening
    const timeModifier =
      1 + 0.3 * (1 - Math.cos(((timeOfDay - 8) / 24) * 2 * Math.PI));
    return (carbLoad * timeModifier) / this.insulinSensitivity;
  }
}

// ============================================================================
// SECTION 10: CARDIOVASCULAR RHYTHMS
// ============================================================================

/**
 * Cardiovascular Rhythm Controller
 */
export class CardiovascularRhythmController {
  private readonly baseHR: number = 70; // bpm
  private readonly baseSBP: number = 120; // mmHg
  private readonly baseDBP: number = 80; // mmHg

  /**
   * Compute cardiovascular state
   */
  compute(
    timeOfDay: number,
    sleepState: SleepStage,
    stressLevel: number,
    physicalActivity: number,
  ): CardiovascularRhythm {
    // Heart rate: lower at night, morning surge on waking
    let hr = this.baseHR;

    // Circadian component
    hr += 10 * Math.cos(((timeOfDay - 15) / 24) * 2 * Math.PI); // Peak afternoon

    // Sleep effect
    if (sleepState !== "wake") {
      hr *= 0.8; // Lower during sleep
      if (sleepState === "N3") hr *= 0.9; // Even lower in deep sleep
    }

    // Activity and stress
    hr *= 1 + physicalActivity * 0.5 + stressLevel * 0.2;

    // Blood pressure
    let sbp = this.baseSBP;
    let dbp = this.baseDBP;

    // Circadian BP (nocturnal dipping)
    const bpDip = sleepState !== "wake" ? 0.85 : 1.0;
    sbp *= bpDip;
    dbp *= bpDip;

    // Morning surge
    const isMorningSurge =
      timeOfDay > 6 && timeOfDay < 9 && sleepState === "wake";
    const morningSurge = isMorningSurge ? 15 : 0;
    sbp += morningSurge;

    // Activity effect
    sbp += physicalActivity * 30;
    dbp += physicalActivity * 10;

    // HRV (higher at rest and during sleep)
    let hrv = 40; // RMSSD in ms
    if (sleepState !== "wake") hrv *= 1.3;
    hrv *= 1 / (1 + stressLevel);
    hrv *= 1 / (1 + physicalActivity);

    return {
      heartRate: hr,
      heartRateVariability: hrv,
      bloodPressureSystolic: sbp,
      bloodPressureDiastolic: dbp,
      vascularResistance: 1 + stressLevel * 0.2,
      cardiacOutput: (hr * 0.07) / 1000, // Simplified stroke volume
      morningPressureSurge: morningSurge,
    };
  }
}

// ============================================================================
// SECTION 11: IMMUNE RHYTHM CONTROLLER
// ============================================================================

/**
 * Immune System Circadian Controller
 */
export class ImmuneRhythmController {
  /**
   * Compute immune state
   */
  compute(
    timeOfDay: number,
    sleepState: SleepStage,
    infectionLoad: number,
  ): ImmuneRhythm {
    // Lymphocyte count: higher at night
    const lymphocytes =
      0.7 + 0.3 * Math.cos(((timeOfDay - 2) / 24) * 2 * Math.PI);

    // Cytokine activity: nocturnal rise
    let cytokines = 0.6 + 0.4 * Math.cos(((timeOfDay - 3) / 24) * 2 * Math.PI);
    if (sleepState !== "wake") cytokines *= 1.2;
    cytokines += infectionLoad * 0.3;

    // Antibody production: peaks during sleep
    const antibodyProduction =
      sleepState !== "wake"
        ? 0.8 + 0.2 * Math.random()
        : 0.5 + 0.1 * Math.random();

    // Phagocytic activity
    const phagocytic =
      0.6 + 0.2 * Math.cos(((timeOfDay - 4) / 24) * 2 * Math.PI);

    // Vaccine response (best in morning)
    const vaccineResponse =
      0.6 + 0.3 * Math.cos(((timeOfDay - 10) / 24) * 2 * Math.PI);

    // Infection susceptibility (higher at night/early morning)
    const susceptibility =
      0.7 - 0.2 * Math.cos(((timeOfDay - 4) / 24) * 2 * Math.PI);

    return {
      lymphocyteCount: lymphocytes,
      cytokineActivity: cytokines,
      antibodyProduction,
      phagocyticActivity: phagocytic,
      vaccineResponse,
      infectionSusceptibility: susceptibility,
    };
  }
}

// ============================================================================
// SECTION 12: JET LAG AND SHIFT WORK
// ============================================================================

/**
 * Jet Lag and Circadian Disruption Model
 */
export class JetLagModel {
  private homeTimeZone = 0; // Hours from UTC
  private currentTimeZone = 0;
  private daysInNewZone = 0;
  private internalPhase = 0; // Internal clock phase (radians)

  constructor(homeTimeZone = 0) {
    this.homeTimeZone = homeTimeZone;
    this.currentTimeZone = homeTimeZone;
  }

  /**
   * Simulate travel to new time zone
   */
  travel(newTimeZone: number): void {
    this.currentTimeZone = newTimeZone;
    this.daysInNewZone = 0;
  }

  /**
   * Update jet lag status
   */
  update(dt: number): JetLagStatus {
    const dtDays = dt / (24 * 3600);
    this.daysInNewZone += dtDays;

    const timeZoneOffset = this.currentTimeZone - this.homeTimeZone;

    // Reentrainment rate: ~1 hour per day (faster eastward, slower westward)
    const direction = timeZoneOffset > 0 ? "east" : "west";
    const reentrainmentRate = direction === "east" ? 0.7 : 1.0; // Hours per day

    // Adaptation progress
    const totalShift = Math.abs(timeZoneOffset);
    const adapted = Math.min(
      1,
      (this.daysInNewZone * reentrainmentRate) / totalShift,
    );

    // Symptom severity
    const symptomSeverity = (1 - adapted) * Math.min(1, totalShift / 12);

    // Update internal phase
    const targetPhase = ((this.currentTimeZone * 15) / 180) * Math.PI;
    const currentPhase = this.internalPhase;
    this.internalPhase +=
      ((targetPhase - currentPhase) * reentrainmentRate * dtDays) / 24;

    return {
      timeZoneOffset,
      daysInNewZone: this.daysInNewZone,
      adaptationProgress: adapted,
      symptomSeverity,
      reentrainmentRate,
    };
  }

  /**
   * Get recommended light exposure times for faster adaptation
   */
  getLightRecommendations(): {
    seekLight: [number, number];
    avoidLight: [number, number];
  } {
    const offset = this.currentTimeZone - this.homeTimeZone;

    if (offset > 0) {
      // Traveled east: seek morning light, avoid evening light
      return {
        seekLight: [6, 10],
        avoidLight: [16, 20],
      };
    }
    // Traveled west: seek evening light, avoid morning light
    return {
      seekLight: [16, 20],
      avoidLight: [6, 10],
    };
  }
}

// ============================================================================
// SECTION 13: SEASONAL ADAPTATION
// ============================================================================

/**
 * Seasonal and Photoperiodic Adaptation Model
 */
export class SeasonalAdaptationModel {
  private latitude: number;
  private dayOfYear = 172; // Summer solstice
  private lightExposure = 8; // Hours

  constructor(latitude = 45) {
    this.latitude = latitude;
  }

  /**
   * Compute day length
   */
  computeDayLength(dayOfYear: number): number {
    // Approximate formula for day length
    const declination =
      23.45 * Math.sin((2 * Math.PI * (284 + dayOfYear)) / 365);
    const latRad = (this.latitude * Math.PI) / 180;
    const decRad = (declination * Math.PI) / 180;

    const cosHourAngle = -Math.tan(latRad) * Math.tan(decRad);

    if (cosHourAngle >= 1) return 0; // Polar night
    if (cosHourAngle <= -1) return 24; // Polar day

    const hourAngle = Math.acos(cosHourAngle);
    return (24 * hourAngle) / Math.PI;
  }

  /**
   * Compute seasonal state
   */
  compute(dayOfYear: number, dailyLightExposure: number): SeasonalState {
    this.dayOfYear = dayOfYear;
    this.lightExposure = dailyLightExposure;

    const dayLength = this.computeDayLength(dayOfYear);

    // Determine season (Northern Hemisphere)
    let season: "spring" | "summer" | "autumn" | "winter";
    if (dayOfYear >= 80 && dayOfYear < 172) season = "spring";
    else if (dayOfYear >= 172 && dayOfYear < 264) season = "summer";
    else if (dayOfYear >= 264 && dayOfYear < 355) season = "autumn";
    else season = "winter";

    // Seasonal affect (SAD risk)
    // Higher in winter at high latitudes with low light exposure
    const lightDeficit = Math.max(0, 8 - dailyLightExposure) / 8;
    const winterFactor =
      season === "winter" ? 1 : season === "autumn" ? 0.5 : 0;
    const latitudeFactor = Math.abs(this.latitude) / 90;

    const seasonalAffect = -lightDeficit * winterFactor * latitudeFactor;

    // Photoperiod adaptation
    const photoperiodAdaptation = dailyLightExposure / dayLength;

    return {
      dayLength,
      season,
      latitude: this.latitude,
      lightExposure: dailyLightExposure,
      seasonalAffect,
      photoperiodAdaptation,
    };
  }

  /**
   * Get light therapy recommendation
   */
  getLightTherapyRecommendation(): {
    needed: boolean;
    duration: number;
    timing: number;
  } {
    const _dayLength = this.computeDayLength(this.dayOfYear);
    const deficit = Math.max(0, 8 - this.lightExposure);

    return {
      needed: deficit > 2,
      duration: Math.min(60, deficit * 15), // Minutes
      timing: 7, // 7 AM is generally best
    };
  }
}

// ============================================================================
// SECTION 14: COMPLETE MERIDIAN STATE MANAGEMENT
// ============================================================================

/**
 * Create initial meridian state
 */
export function createInitialMeridianState(): MeridianState {
  const ultradianPhases = new Map<string, PhaseState>();
  ultradianPhases.set("BRAC", {
    phase: 0,
    period: BRAC_PERIOD_MINUTES * 60,
    amplitude: 0.5,
    acrophase: 0,
    mesor: 0.5,
    robustness: 0.8,
  });
  ultradianPhases.set("heartbeat", {
    phase: 0,
    period: 1 / HEART_RATE_BASE_HZ,
    amplitude: 1,
    acrophase: 0,
    mesor: 0.5,
    robustness: 0.95,
  });
  ultradianPhases.set("respiration", {
    phase: 0,
    period: 1 / RESPIRATORY_RATE_BASE_HZ,
    amplitude: 1,
    acrophase: 0,
    mesor: 0.5,
    robustness: 0.9,
  });

  const infradianPhases = new Map<string, PhaseState>();
  infradianPhases.set("lunar", {
    phase: 0,
    period: LUNAR_PERIOD_DAYS * 24 * 3600,
    amplitude: 0.1,
    acrophase: 0,
    mesor: 0.5,
    robustness: 0.3,
  });

  const hormones = new Map<string, HormoneProfile>();
  const hormoneGen = new HormoneRhythmGenerator();
  for (const [name, profile] of hormoneGen.getProfiles()) {
    hormones.set(name, profile);
  }

  const prcMap = new Map<string, PhaseResponseCurve>();
  prcMap.set("light", {
    zeitgeberType: "light",
    phasePoints: Array.from({ length: 24 }, (_, i) => (i / 24) * 2 * Math.PI),
    responses: Array.from({ length: 24 }, (_, i) => {
      // Classic PRC for light: delay in early night, advance in late night
      const phase = (i / 24) * 2 * Math.PI;
      if (phase < Math.PI / 2) return 1; // Delay
      if (phase < Math.PI) return 0.5;
      if (phase < (3 * Math.PI) / 2) return -0.5;
      return -1; // Advance
    }),
    sensitivity: 0.8,
    deadZone: [Math.PI * 0.4, Math.PI * 0.6],
  });

  return {
    timestamp: Date.now(),
    localTime: 12, // Noon
    circadianPhase: {
      phase: Math.PI, // Noon = π
      period: CIRCADIAN_PERIOD_SECONDS,
      amplitude: 0.8,
      acrophase: 15, // 3 PM
      mesor: 0.5,
      robustness: 0.85,
    },
    ultradianPhases,
    infradianPhases,
    clockGenes: {
      CLOCK: 1.0,
      BMAL1: 0.5,
      PER1: 0.5,
      PER2: 0.5,
      CRY1: 0.5,
      CRY2: 0.5,
      REV_ERB_alpha: 0.5,
      REV_ERB_beta: 0.5,
      ROR_alpha: 0.5,
    },
    sleepState: {
      currentStage: "wake",
      cycleNumber: 0,
      timeInStage: 0,
      sleepOnset: 23,
      totalSleepTime: 0,
      sleepEfficiency: 0.9,
      REMLatency: 90,
      slowWaveActivity: 0,
    },
    hormones,
    temperature: {
      coreTemperature: 37.0,
      peripheralTemperature: 33.0,
      gradient: 4.0,
      phase: Math.PI,
      minimum: 5,
      maximum: 18,
    },
    alertness: {
      alertness: 0.7,
      cognitivePerformance: 0.7,
      reactionTime: 0.8,
      memoryConsolidation: 0.6,
      creativityIndex: 0.5,
      timeOfDayEffect: 0.7,
    },
    metabolism: {
      glucoseLevel: 1.0,
      insulinSensitivity: 0.9,
      lipidOxidation: 0.5,
      thermalEffectOfFood: 0,
      metabolicRate: 1.0,
      feedingWindow: [7, 19],
    },
    cardiovascular: {
      heartRate: 70,
      heartRateVariability: 40,
      bloodPressureSystolic: 120,
      bloodPressureDiastolic: 80,
      vascularResistance: 1.0,
      cardiacOutput: 5,
      morningPressureSurge: 0,
    },
    immune: {
      lymphocyteCount: 0.7,
      cytokineActivity: 0.5,
      antibodyProduction: 0.6,
      phagocyticActivity: 0.6,
      vaccineResponse: 0.7,
      infectionSusceptibility: 0.5,
    },
    zeitgebers: [],
    phaseResponseCurves: prcMap,
    entrainmentStrength: 0.8,
    chronotype: "intermediate",
    jetLagStatus: {
      timeZoneOffset: 0,
      daysInNewZone: 0,
      adaptationProgress: 1,
      symptomSeverity: 0,
      reentrainmentRate: 1,
    },
    seasonalAdaptation: {
      dayLength: 14,
      season: "summer",
      latitude: 40,
      lightExposure: 10,
      seasonalAffect: 0,
      photoperiodAdaptation: 0.7,
    },
  };
}

/**
 * Tick the meridian engine forward
 */
export function tickMeridian(
  state: MeridianState,
  dt: number,
  externalInputs: {
    lightLevel?: number;
    exerciseLevel?: number;
    mealTime?: number;
    stressLevel?: number;
  },
): MeridianState {
  const dtHours = dt / 3600;
  const newLocalTime = (state.localTime + dtHours) % 24;

  // Update circadian phase
  const newCircadianPhase =
    (state.circadianPhase.phase +
      (2 * Math.PI * dt) / state.circadianPhase.period) %
    (2 * Math.PI);

  // Create sub-systems
  const sleepModel = new TwoProcessSleepModel(state.circadianPhase.amplitude);
  sleepModel.step(dt, newCircadianPhase);
  const sleepState = sleepModel.getState();

  const hormoneGen = new HormoneRhythmGenerator();
  hormoneGen.update(newLocalTime, sleepState.isAsleep ? "N2" : "wake");

  const tempController = new TemperatureRhythmController();
  tempController.update(newLocalTime, sleepState.isAsleep ? "N2" : "wake", 1);

  const alertnessCalc = new AlertnessCalculator();
  const alertness = alertnessCalc.computeAlertness(
    newCircadianPhase,
    sleepState.S,
    sleepState.isAsleep ? 0 : 8, // Simplified time awake
    0,
  );

  const metabolicController = new MetabolicRhythmController();
  const metabolism = metabolicController.update(
    newLocalTime,
    externalInputs.mealTime || 12,
    externalInputs.exerciseLevel || 0,
  );

  const cvController = new CardiovascularRhythmController();
  const cardiovascular = cvController.compute(
    newLocalTime,
    sleepState.isAsleep ? "N2" : "wake",
    externalInputs.stressLevel || 0,
    externalInputs.exerciseLevel || 0,
  );

  const immuneController = new ImmuneRhythmController();
  const immune = immuneController.compute(
    newLocalTime,
    sleepState.isAsleep ? "N2" : "wake",
    0,
  );

  return {
    ...state,
    timestamp: Date.now(),
    localTime: newLocalTime,
    circadianPhase: {
      ...state.circadianPhase,
      phase: newCircadianPhase,
    },
    sleepState: {
      ...state.sleepState,
      currentStage: sleepState.isAsleep ? "N2" : "wake",
    },
    hormones: hormoneGen.getProfiles(),
    temperature: tempController.getState(),
    alertness,
    metabolism,
    cardiovascular,
    immune,
  };
}

// ============================================================================
// SECTION 15: EXPORTS
// ============================================================================

// All classes are already exported with 'export class'
