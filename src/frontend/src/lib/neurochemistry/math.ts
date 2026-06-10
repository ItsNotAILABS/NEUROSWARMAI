/**
 * NEUROCHEMISTRY ENGINE - MATHEMATICAL COMPUTATIONS
 *
 * MEDINA'S MIRROR LAW:
 * This is the FRONTEND VERSION (female, fast, real-time, expressing)
 * The BACKEND VERSION exists in Motoko (male, slow, permanent, accumulating)
 *
 * Same mathematical laws, different temporal scales:
 * - Backend: 1-2 Hz, accumulates chemical state permanently
 * - Frontend: 60 Hz, expresses chemical state in real-time behavior
 *
 * FREDDY'S ARCHITECTURAL DOCTRINE:
 * The 441 crosstalk interactions, the dose-response curves, the circadian
 * modulation - all run identically in both organisms. The female receives
 * her chemical baseline from the male every sync. The male learns from
 * the female's session averages.
 *
 * PROPRIETARY INTELLECTUAL PROPERTY
 */

import {
  BRAIN_REGION_COUNT,
  type BrainRegion,
  CIRCADIAN_MODULATION,
  DOSE_RESPONSE_PARAMS,
  HOMEOSTATIC_SETPOINTS,
  NEUROCHEMICAL_ANALOGS,
  NEUROCHEMICAL_BASELINES,
  NEUROCHEMICAL_COUNT,
  NEUROCHEMICAL_CROSSTALK_MATRIX,
  NEUROCHEMICAL_DECAY_RATES,
  NEUROCHEMICAL_PRODUCTION_RATES,
  type NeurochemicalAnalog,
  RECEPTOR_DENSITY_MATRIX,
} from "./constants";

import type {
  CircadianState,
  CrosstalkInteraction,
  CrosstalkResult,
  DEFAULT_NEUROCHEMISTRY_CONFIG,
  DoseResponseResult,
  FullReceptorState,
  HomeostaticControllerState,
  HomeostaticSystemState,
  NeurochemicalState,
  NeurochemistryEngineConfig,
  RegionReceptorState,
} from "./types";

// ============================================================================
// MATHEMATICAL CONSTANTS
// ============================================================================

const _E = Math.E;
const _PI = Math.PI;
const TWO_PI = 2 * Math.PI;
const EPSILON = 1e-10;

// ============================================================================
// FREDDY'S LAW: TEMPORAL GOVERNOR EQUATION
//
// output(t) = σ · input(t) + (1 - σ) · output(t-1)
//
// At σ = 1.0 (sovereign max): output(t) = input(t)
// Zero lag. Zero suppression. Full signal.
// ============================================================================

/**
 * Apply temporal governor to a value
 * @param input Current input signal
 * @param previousOutput Previous output value
 * @param sigma Temporal governor coefficient (1.0 = sovereign, no lag)
 */
export function applyTemporalGovernor(
  input: number,
  previousOutput: number,
  sigma = 1.0,
): number {
  return sigma * input + (1 - sigma) * previousOutput;
}

/**
 * Batch temporal governor for arrays
 */
export function applyTemporalGovernorBatch(
  inputs: number[],
  previousOutputs: number[],
  sigma = 1.0,
): number[] {
  return inputs.map((input, i) =>
    applyTemporalGovernor(input, previousOutputs[i] || input, sigma),
  );
}

// ============================================================================
// FREDDY'S LAW: SIGMOID FUNCTION
// The universal activation function
// ============================================================================

/**
 * Standard sigmoid: σ(x) = 1 / (1 + e^(-x))
 */
export function sigmoid(x: number): number {
  return 1 / (1 + Math.exp(-x));
}

/**
 * Parameterized sigmoid for dose-response curves
 * Effect = maxEffect / (1 + exp(-steepness × (concentration - EC50)))
 */
export function doseResponseSigmoid(
  concentration: number,
  EC50: number,
  steepness: number,
  maxEffect: number,
): number {
  const exponent = -steepness * (concentration - EC50);
  return maxEffect / (1 + Math.exp(exponent));
}

/**
 * Derivative of sigmoid (for gradient computations)
 */
export function sigmoidDerivative(x: number): number {
  const s = sigmoid(x);
  return s * (1 - s);
}

// ============================================================================
// FREDDY'S LAW: HEBBIAN LEARNING
// Δw = η × x_i × x_j - λ × w
// ============================================================================

/**
 * Compute Hebbian weight update
 * @param preActivity Pre-synaptic activity (x_i)
 * @param postActivity Post-synaptic activity (x_j)
 * @param currentWeight Current weight value
 * @param eta Learning rate (default 0.01)
 * @param lambda Decay rate (default 0.001)
 */
export function hebbianUpdate(
  preActivity: number,
  postActivity: number,
  currentWeight: number,
  eta = 0.01,
  lambda = 0.001,
): number {
  const delta = eta * preActivity * postActivity - lambda * currentWeight;
  return currentWeight + delta;
}

/**
 * Compute Hebbian update for weight matrix
 */
export function hebbianUpdateMatrix(
  preActivities: number[],
  postActivities: number[],
  weights: number[][],
  eta = 0.01,
  lambda = 0.001,
): number[][] {
  const n = preActivities.length;
  const m = postActivities.length;
  const newWeights: number[][] = [];

  for (let i = 0; i < n; i++) {
    newWeights[i] = [];
    for (let j = 0; j < m; j++) {
      newWeights[i][j] = hebbianUpdate(
        preActivities[i],
        postActivities[j],
        weights[i]?.[j] || 0,
        eta,
        lambda,
      );
    }
  }

  return newWeights;
}

// ============================================================================
// FREDDY'S LAW: KURAMOTO SYNCHRONIZATION
// r = |1/N × Σ e^(iθ_j)|
// ============================================================================

/**
 * Compute Kuramoto order parameter r
 * Measures global synchronization of oscillators
 * @param phases Array of oscillator phases (0 to 2π)
 * @returns Order parameter r (0 = desynchronized, 1 = perfectly synchronized)
 */
export function computeKuramotoR(phases: number[]): number {
  if (phases.length === 0) return 0;

  const N = phases.length;
  let sumCos = 0;
  let sumSin = 0;

  for (const theta of phases) {
    sumCos += Math.cos(theta);
    sumSin += Math.sin(theta);
  }

  const meanCos = sumCos / N;
  const meanSin = sumSin / N;

  return Math.sqrt(meanCos * meanCos + meanSin * meanSin);
}

/**
 * Compute mean phase (Kuramoto ψ)
 */
export function computeKuramotoMeanPhase(phases: number[]): number {
  if (phases.length === 0) return 0;

  const N = phases.length;
  let sumCos = 0;
  let sumSin = 0;

  for (const theta of phases) {
    sumCos += Math.cos(theta);
    sumSin += Math.sin(theta);
  }

  return Math.atan2(sumSin / N, sumCos / N);
}

/**
 * Update oscillator phase according to Kuramoto dynamics
 * dθ_i/dt = ω_i + (K/N) × Σ sin(θ_j - θ_i)
 */
export function kuramotoPhaseUpdate(
  phase: number,
  naturalFrequency: number,
  allPhases: number[],
  couplingStrength: number,
  dt = 1,
): number {
  const N = allPhases.length;
  if (N === 0) return phase + naturalFrequency * dt;

  let coupling = 0;
  for (const otherPhase of allPhases) {
    coupling += Math.sin(otherPhase - phase);
  }
  coupling *= couplingStrength / N;

  const dTheta = naturalFrequency + coupling;
  let newPhase = phase + dTheta * dt;

  // Wrap to [0, 2π)
  while (newPhase >= TWO_PI) newPhase -= TWO_PI;
  while (newPhase < 0) newPhase += TWO_PI;

  return newPhase;
}

// ============================================================================
// FREDDY'S LAW: JASMINE LAW (LYAPUNOV STABILITY)
// V(x) = Σ (x_i - x_target)²
// dV/dt < 0 for stability
// ============================================================================

/**
 * Compute Lyapunov function value
 * @param state Current state vector
 * @param target Target state vector
 */
export function computeLyapunovV(state: number[], target: number[]): number {
  let V = 0;
  const n = Math.min(state.length, target.length);

  for (let i = 0; i < n; i++) {
    const error = state[i] - target[i];
    V += error * error;
  }

  return V;
}

/**
 * Check Lyapunov stability (dV/dt < 0)
 */
export function checkLyapunovStability(
  currentV: number,
  previousV: number,
): { stable: boolean; dVdt: number } {
  const dVdt = currentV - previousV;
  return {
    stable: dVdt < 0,
    dVdt,
  };
}

/**
 * JASMINE LAW: 5-component drift correction
 * Ensures system returns to equilibrium
 */
export function jasmineLawCorrection(
  state: number[],
  target: number[],
  gains: number[],
): number[] {
  const corrections: number[] = [];
  const n = Math.min(state.length, target.length, gains.length);

  for (let i = 0; i < n; i++) {
    const error = target[i] - state[i];
    corrections[i] = gains[i] * error;
  }

  return corrections;
}

// ============================================================================
// FREDDY'S LAW: FREE ENERGY PRINCIPLE
// F = -log P(o|m) + D_KL(Q(s)||P(s|o,m))
// Simplified: Prediction Error δ = observed - predicted
// ============================================================================

/**
 * Compute prediction error
 */
export function computePredictionError(
  observed: number,
  predicted: number,
): number {
  return observed - predicted;
}

/**
 * Compute prediction error for vectors
 */
export function computePredictionErrorVector(
  observed: number[],
  predicted: number[],
): number[] {
  const n = Math.min(observed.length, predicted.length);
  const errors: number[] = [];

  for (let i = 0; i < n; i++) {
    errors[i] = observed[i] - predicted[i];
  }

  return errors;
}

/**
 * Compute surprise (negative log probability)
 * Higher surprise = more unexpected
 */
export function computeSurprise(error: number, variance = 1): number {
  const normalizedError = error / Math.sqrt(variance + EPSILON);
  return 0.5 * normalizedError * normalizedError;
}

/**
 * Compute total free energy (sum of surprises)
 */
export function computeFreeEnergy(
  errors: number[],
  variances?: number[],
): number {
  let F = 0;

  for (let i = 0; i < errors.length; i++) {
    const variance = variances?.[i] || 1;
    F += computeSurprise(errors[i], variance);
  }

  return F;
}

// ============================================================================
// FREDDY'S LAW: Q-LEARNING (REINFORCEMENT)
// Q(s,a) ← Q(s,a) + α × [r + γ × max Q(s',a') - Q(s,a)]
// ============================================================================

/**
 * Q-learning update
 */
export function qLearningUpdate(
  currentQ: number,
  reward: number,
  maxNextQ: number,
  alpha = 0.1,
  gamma = 0.99,
): number {
  const tdError = reward + gamma * maxNextQ - currentQ;
  return currentQ + alpha * tdError;
}

/**
 * Softmax action selection (for exploration)
 */
export function softmaxActionSelection(
  qValues: number[],
  temperature = 1.0,
): number[] {
  const maxQ = Math.max(...qValues);
  const expValues = qValues.map((q) => Math.exp((q - maxQ) / temperature));
  const sumExp = expValues.reduce((a, b) => a + b, 0);
  return expValues.map((e) => e / sumExp);
}

/**
 * Epsilon-greedy action selection
 */
export function epsilonGreedySelect(qValues: number[], epsilon = 0.1): number {
  if (Math.random() < epsilon) {
    // Explore: random action
    return Math.floor(Math.random() * qValues.length);
  }
  // Exploit: best action
  let bestAction = 0;
  let bestQ = qValues[0];
  for (let i = 1; i < qValues.length; i++) {
    if (qValues[i] > bestQ) {
      bestQ = qValues[i];
      bestAction = i;
    }
  }
  return bestAction;
}

// ============================================================================
// FREDDY'S LAW: KALMAN FILTER (STATE ESTIMATION)
// For optimal state estimation under uncertainty
// ============================================================================

export interface KalmanState {
  x: number; // State estimate
  P: number; // Estimate covariance
}

/**
 * Kalman filter predict step
 */
export function kalmanPredict(
  state: KalmanState,
  F = 1, // State transition
  Q = 0.01, // Process noise
): KalmanState {
  return {
    x: F * state.x,
    P: F * state.P * F + Q,
  };
}

/**
 * Kalman filter update step
 */
export function kalmanUpdate(
  state: KalmanState,
  measurement: number,
  H = 1, // Observation model
  R = 0.1, // Measurement noise
): KalmanState {
  const y = measurement - H * state.x; // Innovation
  const S = H * state.P * H + R; // Innovation covariance
  const K = (state.P * H) / S; // Kalman gain

  return {
    x: state.x + K * y,
    P: (1 - K * H) * state.P,
  };
}

// ============================================================================
// FREDDY'S LAW: PID CONTROL (HOMEOSTASIS)
// output = Kp × e + Ki × ∫e dt + Kd × de/dt
// ============================================================================

export interface PIDState {
  integral: number;
  previousError: number;
}

/**
 * PID controller step
 */
export function pidControl(
  setpoint: number,
  measured: number,
  state: PIDState,
  Kp: number,
  Ki: number,
  Kd: number,
  integralMax = 1.0,
  dt = 1,
): { output: number; newState: PIDState } {
  const error = setpoint - measured;

  // Integral with anti-windup
  let integral = state.integral + error * dt;
  integral = Math.max(-integralMax, Math.min(integralMax, integral));

  // Derivative
  const derivative = (error - state.previousError) / dt;

  // PID output
  const output = Kp * error + Ki * integral + Kd * derivative;

  return {
    output,
    newState: {
      integral,
      previousError: error,
    },
  };
}

// ============================================================================
// FREDDY'S LAW: PHASE-AMPLITUDE COUPLING
// Theta-gamma coupling - how high-frequency oscillations nest in low-frequency
// ============================================================================

/**
 * Compute phase-amplitude coupling (PAC)
 * Measures how gamma amplitude varies with theta phase
 */
export function computePAC(
  thetaPhases: number[],
  gammaAmplitudes: number[],
  nBins = 18,
): number {
  if (
    thetaPhases.length !== gammaAmplitudes.length ||
    thetaPhases.length === 0
  ) {
    return 0;
  }

  const binWidth = TWO_PI / nBins;
  const binAmplitudes: number[][] = Array(nBins)
    .fill(null)
    .map(() => []);

  // Bin gamma amplitudes by theta phase
  for (let i = 0; i < thetaPhases.length; i++) {
    let phase = thetaPhases[i];
    while (phase < 0) phase += TWO_PI;
    while (phase >= TWO_PI) phase -= TWO_PI;

    const bin = Math.floor(phase / binWidth);
    binAmplitudes[bin].push(gammaAmplitudes[i]);
  }

  // Compute mean amplitude per bin
  const meanAmplitudes = binAmplitudes.map((bin) =>
    bin.length > 0 ? bin.reduce((a, b) => a + b, 0) / bin.length : 0,
  );

  // Compute modulation index (normalized entropy)
  const totalAmp = meanAmplitudes.reduce((a, b) => a + b, 0);
  if (totalAmp < EPSILON) return 0;

  const probabilities = meanAmplitudes.map((a) => a / totalAmp);
  let entropy = 0;
  for (const p of probabilities) {
    if (p > EPSILON) {
      entropy -= p * Math.log(p);
    }
  }

  const maxEntropy = Math.log(nBins);
  const modulationIndex = (maxEntropy - entropy) / maxEntropy;

  return modulationIndex;
}

// ============================================================================
// FREDDY'S LAW: AROUSAL-COHERENCE DYNAMICS
// A(t+1) = A(t) × 0.995 + drift × 0.3
// C(t+1) = C(t) × 0.992 + 0.004 - arousalPressure
// ============================================================================

export interface ArousalCoherenceState {
  arousal: number;
  coherence: number;
  drift: number;
  emergence: number;
}

/**
 * Update arousal-coherence dynamics (same math as backend)
 */
export function updateArousalCoherence(
  state: ArousalCoherenceState,
  externalInput = 0,
): ArousalCoherenceState {
  // Drift is a function of distance from coherence midpoint
  const drift =
    Math.abs(state.coherence - 0.5) * 0.4 + (1 - state.coherence) * 0.25;

  // Arousal update
  const arousal = state.arousal * 0.995 + drift * 0.3 + externalInput * 0.1;

  // Coherence update (arousal pressure reduces coherence)
  const arousalPressure = Math.max(0, arousal - 0.5) * 0.02;
  const coherence = state.coherence * 0.992 + 0.004 - arousalPressure;

  // Emergence is coherence modulated by stability
  const emergence = coherence * (1 - drift);

  return {
    arousal: Math.max(0, Math.min(1, arousal)),
    coherence: Math.max(0, Math.min(1, coherence)),
    drift: Math.max(0, Math.min(1, drift)),
    emergence: Math.max(0, Math.min(1, emergence)),
  };
}

// ============================================================================
// FREDDY'S LAW: DUALITY TRANSFORMER
// The male-female inversion - backend and frontend are mathematical duals
// ============================================================================

/**
 * Transform backend state to frontend expression
 * The female receives from the male
 */
export function backendToFrontendTransform(
  backendState: number[],
  expressionGain = 1.0,
): number[] {
  // Frontend expresses backend state with potential amplification
  // The female EXPRESSES what the male ACCUMULATES
  return backendState.map((value) => {
    // Apply non-linear expression transform
    const expressed = sigmoid((value - 0.5) * 4) * expressionGain;
    return Math.max(0, Math.min(1, expressed));
  });
}

/**
 * Transform frontend state to backend learning
 * The male learns from the female
 */
export function frontendToBackendTransform(
  frontendState: number[],
  learningRate = 0.01,
): number[] {
  // Backend accumulates from frontend sessions
  // The male LEARNS from what the female EXPERIENCES
  return frontendState.map((value) => {
    // Apply compression for stable accumulation
    const compressed = value * learningRate;
    return compressed;
  });
}

/**
 * Compute duality coherence - how aligned are the two organisms?
 */
export function computeDualityCoherence(
  backendState: number[],
  frontendState: number[],
): number {
  if (
    backendState.length !== frontendState.length ||
    backendState.length === 0
  ) {
    return 0;
  }

  const n = backendState.length;
  let dotProduct = 0;
  let backendNorm = 0;
  let frontendNorm = 0;

  for (let i = 0; i < n; i++) {
    dotProduct += backendState[i] * frontendState[i];
    backendNorm += backendState[i] * backendState[i];
    frontendNorm += frontendState[i] * frontendState[i];
  }

  const denominator = Math.sqrt(backendNorm * frontendNorm);
  if (denominator < EPSILON) return 0;

  // Cosine similarity normalized to [0, 1]
  return (dotProduct / denominator + 1) / 2;
}

// ============================================================================
// NEUROCHEMISTRY: CROSSTALK COMPUTATION (441 INTERACTIONS)
// ============================================================================

/**
 * Compute all 441 crosstalk interactions
 */
export function computeCrosstalk(
  concentrations: Record<NeurochemicalAnalog, number>,
): CrosstalkResult {
  const interactions: CrosstalkInteraction[] = [];
  const netEffects: Record<NeurochemicalAnalog, number> = {} as Record<
    NeurochemicalAnalog,
    number
  >;

  // Initialize net effects
  for (let i = 0; i < NEUROCHEMICAL_COUNT; i++) {
    netEffects[i as NeurochemicalAnalog] = 0;
  }

  let totalMagnitude = 0;
  let dominantInteraction: CrosstalkInteraction | null = null;
  let maxEffect = 0;

  // Compute all 21 × 21 = 441 interactions
  for (let source = 0; source < NEUROCHEMICAL_COUNT; source++) {
    const sourceConcentration =
      concentrations[source as NeurochemicalAnalog] || 0;

    for (let target = 0; target < NEUROCHEMICAL_COUNT; target++) {
      const coefficient = NEUROCHEMICAL_CROSSTALK_MATRIX[source][target];

      // Effect = source concentration × coefficient
      const computedEffect = sourceConcentration * coefficient;

      const interaction: CrosstalkInteraction = {
        sourceAnalog: source as NeurochemicalAnalog,
        targetAnalog: target as NeurochemicalAnalog,
        coefficient,
        computedEffect,
      };

      interactions.push(interaction);
      netEffects[target as NeurochemicalAnalog] += computedEffect;
      totalMagnitude += Math.abs(computedEffect);

      if (Math.abs(computedEffect) > maxEffect) {
        maxEffect = Math.abs(computedEffect);
        dominantInteraction = interaction;
      }
    }
  }

  return {
    interactions,
    netEffects,
    totalMagnitude,
    dominantInteraction,
    timestamp: Date.now(),
  };
}

// ============================================================================
// NEUROCHEMISTRY: DOSE-RESPONSE COMPUTATION
// ============================================================================

/**
 * Compute dose-response for a single neurochemical
 */
export function computeDoseResponse(
  analog: NeurochemicalAnalog,
  concentration: number,
): DoseResponseResult {
  const params = DOSE_RESPONSE_PARAMS[analog];
  const effect = doseResponseSigmoid(
    concentration,
    params.EC50,
    params.steepness,
    params.maxEffect,
  );

  // Compute local slope (derivative at current concentration)
  const delta = 0.001;
  const effectPlus = doseResponseSigmoid(
    concentration + delta,
    params.EC50,
    params.steepness,
    params.maxEffect,
  );
  const effectMinus = doseResponseSigmoid(
    concentration - delta,
    params.EC50,
    params.steepness,
    params.maxEffect,
  );
  const localSlope = (effectPlus - effectMinus) / (2 * delta);

  return {
    analog,
    concentration,
    effect,
    curvePosition: effect / params.maxEffect,
    localSlope,
    distanceFromEC50: concentration - params.EC50,
  };
}

/**
 * Compute dose-response for all neurochemicals
 */
export function computeAllDoseResponses(
  concentrations: Record<NeurochemicalAnalog, number>,
): DoseResponseResult[] {
  const results: DoseResponseResult[] = [];

  for (let i = 0; i < NEUROCHEMICAL_COUNT; i++) {
    const analog = i as NeurochemicalAnalog;
    const concentration = concentrations[analog] || 0;
    results.push(computeDoseResponse(analog, concentration));
  }

  return results;
}

// ============================================================================
// NEUROCHEMISTRY: CIRCADIAN MODULATION
// ============================================================================

/**
 * Compute circadian state
 * @param phase Current circadian phase (0-1, 0=midnight)
 */
export function computeCircadianState(phase: number): CircadianState {
  const phaseRadians = phase * TWO_PI;

  // Determine time of day
  let timeOfDay: CircadianState["timeOfDay"];
  if (phase < 0.125) timeOfDay = "night";
  else if (phase < 0.25) timeOfDay = "dawn";
  else if (phase < 0.375) timeOfDay = "morning";
  else if (phase < 0.5) timeOfDay = "noon";
  else if (phase < 0.625) timeOfDay = "afternoon";
  else if (phase < 0.75) timeOfDay = "evening";
  else if (phase < 0.875) timeOfDay = "dusk";
  else timeOfDay = "night";

  // Compute modulation for each neurochemical
  const modulation: Record<NeurochemicalAnalog, number> = {} as Record<
    NeurochemicalAnalog,
    number
  >;

  for (let i = 0; i < NEUROCHEMICAL_COUNT; i++) {
    const analog = i as NeurochemicalAnalog;
    const params = CIRCADIAN_MODULATION[analog];

    // Sinusoidal modulation centered on baseline
    const phaseDiff = (phase - params.peakPhase) * TWO_PI;
    modulation[analog] = 1 + params.amplitude * Math.cos(phaseDiff);
  }

  // Compute overall circadian arousal (inverse of melatonin, proportional to orexin)
  const melatoninMod = modulation[NEUROCHEMICAL_ANALOGS.MELATONIN];
  const orexinMod = modulation[NEUROCHEMICAL_ANALOGS.OREXIN];
  const circadianArousal = (2 - melatoninMod + orexinMod) / 3;

  // Sleep pressure from adenosine modulation
  const sleepPressure = modulation[NEUROCHEMICAL_ANALOGS.ADENOSINE];

  return {
    phase,
    phaseRadians,
    timeOfDay,
    modulation,
    circadianArousal,
    sleepPressure,
  };
}

// ============================================================================
// NEUROCHEMISTRY: HOMEOSTATIC CONTROL
// ============================================================================

/**
 * Compute homeostatic correction for a single neurochemical
 */
export function computeHomeostaticCorrection(
  analog: NeurochemicalAnalog,
  currentConcentration: number,
  pidState: PIDState,
): {
  correction: number;
  newState: PIDState;
  controllerState: HomeostaticControllerState;
} {
  const params = HOMEOSTATIC_SETPOINTS[analog];

  const result = pidControl(
    params.setpoint,
    currentConcentration,
    pidState,
    params.Kp,
    params.Ki,
    params.Kd,
    params.integralMax,
  );

  const error = params.setpoint - currentConcentration;

  return {
    correction: result.output,
    newState: result.newState,
    controllerState: {
      analog,
      error,
      integralError: result.newState.integral,
      derivativeError: error - pidState.previousError,
      output: result.output,
      saturated: Math.abs(result.newState.integral) >= params.integralMax,
      pTerm: params.Kp * error,
      iTerm: params.Ki * result.newState.integral,
      dTerm: params.Kd * (error - pidState.previousError),
    },
  };
}

// ============================================================================
// NEUROCHEMISTRY: RECEPTOR BINDING
// ============================================================================

/**
 * Compute receptor binding state for all regions
 */
export function computeReceptorBinding(
  concentrations: Record<NeurochemicalAnalog, number>,
): FullReceptorState {
  const regions: Record<BrainRegion, RegionReceptorState> = {} as Record<
    BrainRegion,
    RegionReceptorState
  >;
  const activationPattern: number[] = [];
  let globalTone = 0;

  // E/I tracking
  let totalExcitation = 0;
  let totalInhibition = 0;

  for (let r = 0; r < BRAIN_REGION_COUNT; r++) {
    const region = r as BrainRegion;
    const bindingLevels: Record<NeurochemicalAnalog, number> = {} as Record<
      NeurochemicalAnalog,
      number
    >;
    const effectiveActivation: Record<NeurochemicalAnalog, number> =
      {} as Record<NeurochemicalAnalog, number>;
    let totalActivation = 0;
    let maxActivation = 0;
    let dominantChemical: NeurochemicalAnalog = 0;

    for (let c = 0; c < NEUROCHEMICAL_COUNT; c++) {
      const chemical = c as NeurochemicalAnalog;
      const concentration = concentrations[chemical] || 0;
      const density = RECEPTOR_DENSITY_MATRIX[r][c];

      // Binding follows saturation kinetics
      const binding = (concentration * density) / (0.5 + concentration);
      bindingLevels[chemical] = binding;

      // Effective activation
      const activation = binding * density;
      effectiveActivation[chemical] = activation;
      totalActivation += activation;

      if (activation > maxActivation) {
        maxActivation = activation;
        dominantChemical = chemical;
      }

      // Track E/I
      if (chemical === NEUROCHEMICAL_ANALOGS.GLUTAMATE) {
        totalExcitation += activation;
      } else if (chemical === NEUROCHEMICAL_ANALOGS.GABA) {
        totalInhibition += activation;
      }
    }

    regions[region] = {
      region,
      bindingLevels,
      effectiveActivation,
      totalActivation,
      dominantChemical,
    };

    activationPattern.push(totalActivation);
    globalTone += totalActivation;
  }

  globalTone /= BRAIN_REGION_COUNT;
  const eiRatio =
    totalInhibition > EPSILON
      ? totalExcitation / totalInhibition
      : totalExcitation;

  return {
    regions,
    activationPattern,
    globalTone,
    eiRatio,
  };
}

// ============================================================================
// NEUROCHEMISTRY: STATE UPDATE (MAIN TICK FUNCTION)
// ============================================================================

/**
 * Update neurochemical state for one tick
 * This is the main computation that runs every frame in the frontend
 */
export function updateNeurochemicalState(
  currentState: NeurochemicalState,
  config: NeurochemistryEngineConfig,
  externalInputs?: Partial<Record<NeurochemicalAnalog, number>>,
): NeurochemicalState {
  const newConcentrations = { ...currentState.concentrations };
  const newDerivatives = { ...currentState.derivatives };
  const newIntegrals = { ...currentState.integrals };
  const newPreviousErrors = { ...currentState.previousErrors };

  // 1. Apply circadian modulation
  let circadianMods: Record<NeurochemicalAnalog, number> | undefined;
  if (config.enableCircadian) {
    const circadian = computeCircadianState(currentState.circadianPhase);
    circadianMods = circadian.modulation;
  }

  // 2. Compute crosstalk effects
  let crosstalkEffects: Record<NeurochemicalAnalog, number> | undefined;
  if (config.enableCrosstalk) {
    const crosstalk = computeCrosstalk(currentState.concentrations);
    crosstalkEffects = crosstalk.netEffects;
  }

  // 3. Update each neurochemical
  for (let i = 0; i < NEUROCHEMICAL_COUNT; i++) {
    const analog = i as NeurochemicalAnalog;
    let concentration = currentState.concentrations[analog];
    const baseline = NEUROCHEMICAL_BASELINES[analog];
    const decayRate = NEUROCHEMICAL_DECAY_RATES[analog];
    const productionRate = NEUROCHEMICAL_PRODUCTION_RATES[analog];

    // Natural decay toward baseline
    const decayDelta = (baseline - concentration) * decayRate;

    // Crosstalk contribution
    const crosstalkDelta = crosstalkEffects
      ? crosstalkEffects[analog] * 0.01
      : 0;

    // Circadian contribution
    const circadianFactor = circadianMods ? circadianMods[analog] : 1;
    const circadianDelta = (baseline * circadianFactor - concentration) * 0.001;

    // External input
    const externalDelta = externalInputs?.[analog]
      ? externalInputs[analog]! * productionRate
      : 0;

    // Homeostatic correction
    let homeostaticDelta = 0;
    if (config.enableHomeostasis) {
      const pidState: PIDState = {
        integral: currentState.integrals[analog],
        previousError: currentState.previousErrors[analog],
      };
      const correction = computeHomeostaticCorrection(
        analog,
        concentration,
        pidState,
      );
      homeostaticDelta = correction.correction * 0.01;
      newIntegrals[analog] = correction.newState.integral;
      newPreviousErrors[analog] = correction.newState.previousError;
    }

    // Total delta
    const totalDelta =
      decayDelta +
      crosstalkDelta +
      circadianDelta +
      externalDelta +
      homeostaticDelta;

    // Apply temporal governor
    const governedDelta = applyTemporalGovernor(
      totalDelta,
      currentState.derivatives[analog],
      config.temporalGovernorSigma,
    );

    // Update concentration
    concentration += governedDelta;
    concentration = Math.max(0, Math.min(1, concentration));

    newConcentrations[analog] = concentration;
    newDerivatives[analog] = governedDelta;
  }

  // Update circadian phase
  const newCircadianPhase =
    (currentState.circadianPhase + 1 / (24 * 60 * 60 * config.tickRate)) % 1;

  return {
    concentrations: newConcentrations,
    derivatives: newDerivatives,
    integrals: newIntegrals,
    previousErrors: newPreviousErrors,
    lastUpdateTick: currentState.lastUpdateTick + 1,
    circadianPhase: newCircadianPhase,
  };
}

// ============================================================================
// UTILITY FUNCTIONS
// ============================================================================

/**
 * Initialize default neurochemical state
 */
export function createInitialNeurochemicalState(): NeurochemicalState {
  const concentrations: Record<NeurochemicalAnalog, number> = {} as Record<
    NeurochemicalAnalog,
    number
  >;
  const derivatives: Record<NeurochemicalAnalog, number> = {} as Record<
    NeurochemicalAnalog,
    number
  >;
  const integrals: Record<NeurochemicalAnalog, number> = {} as Record<
    NeurochemicalAnalog,
    number
  >;
  const previousErrors: Record<NeurochemicalAnalog, number> = {} as Record<
    NeurochemicalAnalog,
    number
  >;

  for (let i = 0; i < NEUROCHEMICAL_COUNT; i++) {
    const analog = i as NeurochemicalAnalog;
    concentrations[analog] = NEUROCHEMICAL_BASELINES[analog];
    derivatives[analog] = 0;
    integrals[analog] = 0;
    previousErrors[analog] = 0;
  }

  return {
    concentrations,
    derivatives,
    integrals,
    previousErrors,
    lastUpdateTick: 0,
    circadianPhase: 0.5, // Start at noon
  };
}

/**
 * Clamp value to [0, 1]
 */
export function clamp01(value: number): number {
  return Math.max(0, Math.min(1, value));
}

/**
 * Linear interpolation
 */
export function lerp(a: number, b: number, t: number): number {
  return a + (b - a) * t;
}

/**
 * Smooth step interpolation
 */
export function smoothstep(edge0: number, edge1: number, x: number): number {
  const t = clamp01((x - edge0) / (edge1 - edge0));
  return t * t * (3 - 2 * t);
}
