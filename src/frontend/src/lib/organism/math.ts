// ============================================================================
// ARCHITECTURAL MATH LAWS - PROOF OF LIFE
// The Same Mathematical Laws Running in Both Organisms
// ============================================================================
//
// DUALITY ARCHITECTURE:
//   BACKEND (Male) ←→ FRONTEND (Female)
//   Structured      ←→ Creative
//   Permanent       ←→ Ephemeral
//   Sovereign       ←→ Expressive
//   Seed            ←→ Flower
//   Accumulates     ←→ Expresses
//   1-2 Hz          ←→ 60 Hz
//
// The female comes from the male. The frontend is seeded by the backend.
// They are INVERSES of each other, running the SAME MATH in opposite directions.
// Together they create what neither could create alone.
// ============================================================================

// ----------------------------------------------------------------------------
// KURAMOTO SYNCHRONIZATION
// The order parameter r measures global synchrony
// ----------------------------------------------------------------------------

/**
 * Kuramoto Order Parameter
 *
 * r = (1/N) × |Σ exp(i × θⱼ)|
 *
 * where:
 *   N = number of oscillators
 *   θⱼ = phase of oscillator j
 *   r ∈ [0, 1] where 0 = no sync, 1 = perfect sync
 *
 * This is the SAME MATH in backend and frontend.
 * Backend computes r across biomes (slow, permanent).
 * Frontend computes r across entities (fast, real-time).
 */
export class KuramotoSynchronization {
  private phases: Float64Array;
  private frequencies: Float64Array;
  private couplingStrength: number;
  private n: number;

  constructor(n: number, couplingStrength = 0.5) {
    this.n = n;
    this.couplingStrength = couplingStrength;
    this.phases = new Float64Array(n);
    this.frequencies = new Float64Array(n);

    // Initialize with random phases and natural frequencies
    for (let i = 0; i < n; i++) {
      this.phases[i] = Math.random() * 2 * Math.PI;
      this.frequencies[i] = 0.8 + Math.random() * 0.4; // Natural frequency ω ∈ [0.8, 1.2]
    }
  }

  /**
   * Compute the Kuramoto order parameter r
   * r = (1/N) × |Σ exp(i × θⱼ)|
   */
  computeOrderParameter(): { r: number; psi: number } {
    let sumCos = 0;
    let sumSin = 0;

    for (let i = 0; i < this.n; i++) {
      sumCos += Math.cos(this.phases[i]);
      sumSin += Math.sin(this.phases[i]);
    }

    const r = Math.sqrt(sumCos * sumCos + sumSin * sumSin) / this.n;
    const psi = Math.atan2(sumSin, sumCos); // Mean phase

    return { r, psi };
  }

  /**
   * Update phases according to Kuramoto dynamics
   * dθᵢ/dt = ωᵢ + (K/N) × Σⱼ sin(θⱼ - θᵢ)
   */
  tick(dt: number): { r: number; psi: number } {
    const { r, psi } = this.computeOrderParameter();
    const newPhases = new Float64Array(this.n);

    for (let i = 0; i < this.n; i++) {
      // Kuramoto equation: dθᵢ/dt = ωᵢ + K × r × sin(ψ - θᵢ)
      const dTheta =
        this.frequencies[i] +
        this.couplingStrength * r * Math.sin(psi - this.phases[i]);
      newPhases[i] = (this.phases[i] + dTheta * dt) % (2 * Math.PI);
    }

    this.phases = newPhases;
    return { r, psi };
  }

  /**
   * Set the phase of a specific oscillator (for external input)
   */
  setPhase(index: number, phase: number): void {
    if (index >= 0 && index < this.n) {
      this.phases[index] = phase % (2 * Math.PI);
    }
  }

  /**
   * Get current phases
   */
  getPhases(): Float64Array {
    return this.phases;
  }

  /**
   * Set coupling strength (can be modulated by backend coherence)
   */
  setCouplingStrength(k: number): void {
    this.couplingStrength = Math.max(0, Math.min(1, k));
  }
}

// ----------------------------------------------------------------------------
// HEBBIAN PLASTICITY
// "Neurons that fire together, wire together"
// ----------------------------------------------------------------------------

/**
 * Hebbian Learning Rule
 *
 * Δwᵢⱼ = η × xᵢ × xⱼ - λ × wᵢⱼ
 *
 * where:
 *   η = learning rate
 *   xᵢ, xⱼ = activation of neurons i and j
 *   λ = decay rate (prevents unbounded growth)
 *   wᵢⱼ = synaptic weight from i to j
 *
 * SAME MATH in backend (Shells 2-11) and frontend (entity brains).
 */
export class HebbianPlasticity {
  private weights: Float64Array;
  private n: number;
  private learningRate: number;
  private decayRate: number;
  private minWeight: number;
  private maxWeight: number;

  constructor(
    n: number,
    learningRate = 0.01,
    decayRate = 0.001,
    minWeight = -1.0,
    maxWeight = 1.0,
  ) {
    this.n = n;
    this.learningRate = learningRate;
    this.decayRate = decayRate;
    this.minWeight = minWeight;
    this.maxWeight = maxWeight;

    // Initialize weight matrix (n × n)
    this.weights = new Float64Array(n * n);
    for (let i = 0; i < n * n; i++) {
      this.weights[i] = (Math.random() - 0.5) * 0.2; // Small random initial weights
    }
  }

  /**
   * Get weight from neuron i to neuron j
   */
  getWeight(i: number, j: number): number {
    return this.weights[i * this.n + j];
  }

  /**
   * Set weight from neuron i to neuron j
   */
  setWeight(i: number, j: number, w: number): void {
    this.weights[i * this.n + j] = Math.max(
      this.minWeight,
      Math.min(this.maxWeight, w),
    );
  }

  /**
   * Apply Hebbian learning rule
   * Δwᵢⱼ = η × xᵢ × xⱼ - λ × wᵢⱼ
   */
  learn(activations: Float64Array, learningBoost = 1.0): void {
    const eta = this.learningRate * learningBoost;

    for (let i = 0; i < this.n; i++) {
      for (let j = 0; j < this.n; j++) {
        if (i !== j) {
          const currentWeight = this.getWeight(i, j);

          // Hebbian term: η × xᵢ × xⱼ
          const hebbianTerm = eta * activations[i] * activations[j];

          // Decay term: -λ × wᵢⱼ
          const decayTerm = this.decayRate * currentWeight;

          // Update: Δw = hebbianTerm - decayTerm
          const newWeight = currentWeight + hebbianTerm - decayTerm;

          this.setWeight(i, j, newWeight);
        }
      }
    }
  }

  /**
   * Compute output activations given input
   * yⱼ = σ(Σᵢ wᵢⱼ × xᵢ)
   */
  propagate(input: Float64Array): Float64Array {
    const output = new Float64Array(this.n);

    for (let j = 0; j < this.n; j++) {
      let sum = 0;
      for (let i = 0; i < this.n; i++) {
        sum += this.getWeight(i, j) * input[i];
      }
      // Sigmoid activation
      output[j] = 1 / (1 + Math.exp(-sum));
    }

    return output;
  }

  /**
   * Get total synaptic strength (sum of absolute weights)
   */
  getTotalStrength(): number {
    let sum = 0;
    for (let i = 0; i < this.weights.length; i++) {
      sum += Math.abs(this.weights[i]);
    }
    return sum;
  }

  /**
   * Export weights as array (for persistence to backend)
   */
  exportWeights(): number[] {
    return Array.from(this.weights);
  }

  /**
   * Import weights from array (for loading from backend)
   */
  importWeights(weights: number[]): void {
    for (let i = 0; i < Math.min(weights.length, this.weights.length); i++) {
      this.weights[i] = weights[i];
    }
  }
}

// ----------------------------------------------------------------------------
// JASMINE LAW (LYAPUNOV STABILITY)
// 5-component drift correction for system stability
// ----------------------------------------------------------------------------

/**
 * Jasmine Law - Lyapunov Stability
 *
 * The system has a Lyapunov function V(x) that decreases over time,
 * guaranteeing stability. The 5 components are:
 *
 * 1. Coherence term: pulls toward target coherence
 * 2. Arousal term: bounds arousal within safe range
 * 3. Drift term: corrects accumulated drift
 * 4. Emergence term: maintains emergence above threshold
 * 5. Entropy term: prevents system from freezing
 *
 * V̇ ≤ 0 guarantees asymptotic stability
 */
export class JasmineLaw {
  // Target states
  private targetCoherence = 0.7;
  private targetArousal = 0.5;
  private targetDrift = 0.0;
  private targetEmergence = 0.5;
  private targetEntropy = 0.3;

  // Correction gains
  private coherenceGain = 0.1;
  private arousalGain = 0.15;
  private driftGain = 0.2;
  private emergenceGain = 0.1;
  private entropyGain = 0.05;

  // Current state
  private coherence = 0.7;
  private arousal = 0.5;
  private drift = 0.0;
  private emergence = 0.5;
  private entropy = 0.3;

  /**
   * Compute Lyapunov function value
   * V = (1/2) × Σ kᵢ × (xᵢ - x*ᵢ)²
   */
  computeLyapunov(): number {
    const v1 =
      this.coherenceGain * (this.coherence - this.targetCoherence) ** 2;
    const v2 = this.arousalGain * (this.arousal - this.targetArousal) ** 2;
    const v3 = this.driftGain * (this.drift - this.targetDrift) ** 2;
    const v4 =
      this.emergenceGain * (this.emergence - this.targetEmergence) ** 2;
    const v5 = this.entropyGain * (this.entropy - this.targetEntropy) ** 2;

    return 0.5 * (v1 + v2 + v3 + v4 + v5);
  }

  /**
   * Compute correction vector to decrease V
   * Δx = -k × (x - x*)
   */
  computeCorrection(): {
    dCoherence: number;
    dArousal: number;
    dDrift: number;
    dEmergence: number;
    dEntropy: number;
  } {
    return {
      dCoherence: -this.coherenceGain * (this.coherence - this.targetCoherence),
      dArousal: -this.arousalGain * (this.arousal - this.targetArousal),
      dDrift: -this.driftGain * (this.drift - this.targetDrift),
      dEmergence: -this.emergenceGain * (this.emergence - this.targetEmergence),
      dEntropy: -this.entropyGain * (this.entropy - this.targetEntropy),
    };
  }

  /**
   * Apply one step of Jasmine Law correction
   */
  tick(dt = 1.0): void {
    const correction = this.computeCorrection();

    this.coherence = Math.max(
      0,
      Math.min(1, this.coherence + correction.dCoherence * dt),
    );
    this.arousal = Math.max(
      0,
      Math.min(1, this.arousal + correction.dArousal * dt),
    );
    this.drift = Math.max(0, Math.min(1, this.drift + correction.dDrift * dt));
    this.emergence = Math.max(
      0,
      Math.min(1, this.emergence + correction.dEmergence * dt),
    );
    this.entropy = Math.max(
      0,
      Math.min(1, this.entropy + correction.dEntropy * dt),
    );
  }

  /**
   * Check if system is stable (V below threshold)
   */
  isStable(threshold = 0.01): boolean {
    return this.computeLyapunov() < threshold;
  }

  /**
   * Set current state (from backend sync)
   */
  setState(coherence: number, arousal: number, drift: number): void {
    this.coherence = coherence;
    this.arousal = arousal;
    this.drift = drift;
    this.emergence = coherence * (1 - drift); // Derived
    this.entropy = 1 - coherence; // Approximation
  }

  /**
   * Get current state
   */
  getState(): {
    coherence: number;
    arousal: number;
    drift: number;
    emergence: number;
    entropy: number;
    lyapunov: number;
    isStable: boolean;
  } {
    return {
      coherence: this.coherence,
      arousal: this.arousal,
      drift: this.drift,
      emergence: this.emergence,
      entropy: this.entropy,
      lyapunov: this.computeLyapunov(),
      isStable: this.isStable(),
    };
  }
}

// ----------------------------------------------------------------------------
// FREE ENERGY PRINCIPLE
// Minimize prediction error through perception and action
// ----------------------------------------------------------------------------

/**
 * Free Energy Principle
 *
 * F = E_q[log q(s) - log p(o,s)]
 *
 * Simplified to prediction error minimization:
 * F ≈ (1/2) × Σ (x_predicted - x_actual)²
 *
 * The organism minimizes F through:
 * 1. Perception: update internal model to match observations
 * 2. Action: change the world to match predictions
 */
export class FreeEnergyMinimizer {
  private predictions: Float64Array;
  private observations: Float64Array;
  private n: number;
  private learningRate: number;
  private predictionError = 0;
  private errorHistory: number[] = [];
  private maxHistory = 100;

  constructor(n: number, learningRate = 0.1) {
    this.n = n;
    this.learningRate = learningRate;
    this.predictions = new Float64Array(n).fill(0.5);
    this.observations = new Float64Array(n).fill(0.5);
  }

  /**
   * Compute free energy (prediction error)
   * F = (1/2) × Σ (predicted - actual)²
   */
  computeFreeEnergy(): number {
    let sum = 0;
    for (let i = 0; i < this.n; i++) {
      const error = this.predictions[i] - this.observations[i];
      sum += error * error;
    }
    return 0.5 * sum;
  }

  /**
   * Update observations (perception)
   */
  observe(observations: Float64Array): void {
    this.observations = observations;
    this.predictionError = this.computeFreeEnergy();

    // Track error history
    this.errorHistory.push(this.predictionError);
    if (this.errorHistory.length > this.maxHistory) {
      this.errorHistory.shift();
    }
  }

  /**
   * Update predictions to minimize free energy (perceptual inference)
   * Δp = -η × ∂F/∂p = η × (o - p)
   */
  updatePredictions(): void {
    for (let i = 0; i < this.n; i++) {
      const gradient = this.predictions[i] - this.observations[i];
      this.predictions[i] -= this.learningRate * gradient;
    }
  }

  /**
   * Compute action to minimize free energy (active inference)
   * Returns desired change in observations
   */
  computeAction(): Float64Array {
    const action = new Float64Array(this.n);
    for (let i = 0; i < this.n; i++) {
      // Action = move observations toward predictions
      action[i] = this.predictions[i] - this.observations[i];
    }
    return action;
  }

  /**
   * Get surprise level (normalized prediction error)
   */
  getSurprise(): number {
    const maxPossibleError = this.n * 0.5; // Maximum when all errors are 1
    return Math.min(1, this.predictionError / maxPossibleError);
  }

  /**
   * Get learning boost based on surprise
   * High surprise = high learning boost
   */
  getLearningBoost(threshold = 0.3, maxBoost = 3.0): number {
    const surprise = this.getSurprise();
    if (surprise < threshold) return 1.0;
    return 1.0 + ((surprise - threshold) / (1 - threshold)) * (maxBoost - 1.0);
  }

  /**
   * Get predictions
   */
  getPredictions(): Float64Array {
    return this.predictions;
  }

  /**
   * Set predictions (from external model)
   */
  setPredictions(predictions: Float64Array): void {
    this.predictions = predictions;
  }

  /**
   * Get average prediction error over history
   */
  getAverageError(): number {
    if (this.errorHistory.length === 0) return 0;
    return (
      this.errorHistory.reduce((a, b) => a + b, 0) / this.errorHistory.length
    );
  }
}

// ----------------------------------------------------------------------------
// TEMPORAL GOVERNOR
// Zero-lag signal processing at sovereign max
// ----------------------------------------------------------------------------

/**
 * Temporal Governor Equation
 *
 * output(t) = σ × input(t) + (1 - σ) × output(t-1)
 *
 * At σ = 1.0 (sovereign max):
 *   output(t) = input(t)
 *   Zero lag. Zero suppression. Full signal.
 *
 * At σ = 0.0 (classical):
 *   output(t) = output(t-1)
 *   Full lag. Full smoothing.
 */
export class TemporalGovernor {
  private sigma: number;
  private outputs: Float64Array;
  private n: number;

  constructor(n: number, sigma = 1.0) {
    this.n = n;
    this.sigma = Math.max(0, Math.min(1, sigma));
    this.outputs = new Float64Array(n).fill(0);
  }

  /**
   * Process input through temporal governor
   * output(t) = σ × input(t) + (1 - σ) × output(t-1)
   */
  process(input: Float64Array): Float64Array {
    for (let i = 0; i < this.n; i++) {
      this.outputs[i] =
        this.sigma * input[i] + (1 - this.sigma) * this.outputs[i];
    }
    return this.outputs;
  }

  /**
   * Set sigma (can be modulated by backend state)
   * At sovereign max: σ = 1.0
   */
  setSigma(sigma: number): void {
    this.sigma = Math.max(0, Math.min(1, sigma));
  }

  /**
   * Get current sigma
   */
  getSigma(): number {
    return this.sigma;
  }

  /**
   * Get current outputs
   */
  getOutputs(): Float64Array {
    return this.outputs;
  }

  /**
   * Reset outputs to initial state
   */
  reset(): void {
    this.outputs.fill(0);
  }
}

// ----------------------------------------------------------------------------
// Q-LEARNING (REINFORCEMENT LEARNING)
// Learn optimal actions through reward signals
// ----------------------------------------------------------------------------

/**
 * Q-Learning Update Rule
 *
 * Q(s,a) ← Q(s,a) + α × [r + γ × max_a' Q(s',a') - Q(s,a)]
 *
 * where:
 *   α = learning rate
 *   γ = discount factor
 *   r = reward
 *   s = current state
 *   a = action taken
 *   s' = next state
 *   a' = possible next actions
 */
export class QLearning {
  private qTable: Map<string, Float64Array>;
  private numActions: number;
  private learningRate: number;
  private discountFactor: number;
  private explorationRate: number;

  constructor(
    numActions: number,
    learningRate = 0.1,
    discountFactor = 0.95,
    explorationRate = 0.1,
  ) {
    this.numActions = numActions;
    this.learningRate = learningRate;
    this.discountFactor = discountFactor;
    this.explorationRate = explorationRate;
    this.qTable = new Map();
  }

  /**
   * Get Q-values for a state (initialize if not exists)
   */
  private getQValues(state: string): Float64Array {
    if (!this.qTable.has(state)) {
      this.qTable.set(state, new Float64Array(this.numActions).fill(0));
    }
    return this.qTable.get(state)!;
  }

  /**
   * Select action using ε-greedy policy
   */
  selectAction(state: string): number {
    if (Math.random() < this.explorationRate) {
      // Explore: random action
      return Math.floor(Math.random() * this.numActions);
    }
    // Exploit: best action
    return this.getBestAction(state);
  }

  /**
   * Get best action for a state
   */
  getBestAction(state: string): number {
    const qValues = this.getQValues(state);
    let bestAction = 0;
    let bestValue = qValues[0];

    for (let a = 1; a < this.numActions; a++) {
      if (qValues[a] > bestValue) {
        bestValue = qValues[a];
        bestAction = a;
      }
    }

    return bestAction;
  }

  /**
   * Update Q-value after taking action
   * Q(s,a) ← Q(s,a) + α × [r + γ × max Q(s',a') - Q(s,a)]
   */
  update(
    state: string,
    action: number,
    reward: number,
    nextState: string,
  ): void {
    const qValues = this.getQValues(state);
    const nextQValues = this.getQValues(nextState);

    // Find max Q(s', a')
    let maxNextQ = nextQValues[0];
    for (let a = 1; a < this.numActions; a++) {
      if (nextQValues[a] > maxNextQ) {
        maxNextQ = nextQValues[a];
      }
    }

    // Q-learning update
    const tdTarget = reward + this.discountFactor * maxNextQ;
    const tdError = tdTarget - qValues[action];
    qValues[action] += this.learningRate * tdError;
  }

  /**
   * Decay exploration rate over time
   */
  decayExploration(decayRate = 0.995, minRate = 0.01): void {
    this.explorationRate = Math.max(minRate, this.explorationRate * decayRate);
  }

  /**
   * Get current exploration rate
   */
  getExplorationRate(): number {
    return this.explorationRate;
  }

  /**
   * Export Q-table for persistence
   */
  exportQTable(): { state: string; values: number[] }[] {
    const result: { state: string; values: number[] }[] = [];
    this.qTable.forEach((values, state) => {
      result.push({ state, values: Array.from(values) });
    });
    return result;
  }

  /**
   * Import Q-table from persistence
   */
  importQTable(data: { state: string; values: number[] }[]): void {
    this.qTable.clear();
    for (const entry of data) {
      this.qTable.set(entry.state, new Float64Array(entry.values));
    }
  }
}

// ----------------------------------------------------------------------------
// KALMAN FILTER
// Optimal state estimation under uncertainty
// ----------------------------------------------------------------------------

/**
 * Kalman Filter
 *
 * Predict:
 *   x̂⁻ = A × x̂
 *   P⁻ = A × P × A' + Q
 *
 * Update:
 *   K = P⁻ × H' × (H × P⁻ × H' + R)⁻¹
 *   x̂ = x̂⁻ + K × (z - H × x̂⁻)
 *   P = (I - K × H) × P⁻
 */
export class KalmanFilter {
  private state: Float64Array;
  private covariance: Float64Array;
  private processNoise: number;
  private measurementNoise: number;
  private n: number;

  constructor(n: number, processNoise = 0.1, measurementNoise = 0.1) {
    this.n = n;
    this.processNoise = processNoise;
    this.measurementNoise = measurementNoise;

    // Initialize state and covariance
    this.state = new Float64Array(n).fill(0.5);
    this.covariance = new Float64Array(n).fill(1.0);
  }

  /**
   * Predict step
   * x̂⁻ = x̂ (assuming identity transition)
   * P⁻ = P + Q
   */
  predict(): void {
    // Covariance grows by process noise
    for (let i = 0; i < this.n; i++) {
      this.covariance[i] += this.processNoise;
    }
  }

  /**
   * Update step with measurement
   * K = P / (P + R)
   * x̂ = x̂ + K × (z - x̂)
   * P = (1 - K) × P
   */
  update(measurement: Float64Array): void {
    for (let i = 0; i < this.n; i++) {
      // Kalman gain
      const k =
        this.covariance[i] / (this.covariance[i] + this.measurementNoise);

      // State update
      this.state[i] += k * (measurement[i] - this.state[i]);

      // Covariance update
      this.covariance[i] = (1 - k) * this.covariance[i];
    }
  }

  /**
   * Run one full predict-update cycle
   */
  filter(measurement: Float64Array): Float64Array {
    this.predict();
    this.update(measurement);
    return this.state;
  }

  /**
   * Get current state estimate
   */
  getState(): Float64Array {
    return this.state;
  }

  /**
   * Get current uncertainty (covariance diagonal)
   */
  getUncertainty(): Float64Array {
    return this.covariance;
  }

  /**
   * Reset filter
   */
  reset(): void {
    this.state.fill(0.5);
    this.covariance.fill(1.0);
  }
}

// ----------------------------------------------------------------------------
// PHASE-AMPLITUDE COUPLING (PAC)
// Cross-frequency neural coupling
// ----------------------------------------------------------------------------

/**
 * Phase-Amplitude Coupling
 *
 * The phase of slow oscillations modulates the amplitude of fast oscillations.
 * This is how theta (4-8 Hz) gates gamma (30-100 Hz) activity.
 *
 * PAC_strength = |mean(A_fast × exp(i × φ_slow))|
 */
export class PhaseAmplitudeCoupling {
  private slowPhase = 0;
  private fastAmplitude = 0.5;
  private couplingHistory: number[] = [];
  private maxHistory = 100;

  /**
   * Update slow phase (e.g., theta rhythm)
   */
  setSlowPhase(phase: number): void {
    this.slowPhase = phase % (2 * Math.PI);
  }

  /**
   * Update fast amplitude (e.g., gamma power)
   */
  setFastAmplitude(amplitude: number): void {
    this.fastAmplitude = Math.max(0, amplitude);
  }

  /**
   * Compute instantaneous coupling
   * Returns complex number as [real, imag]
   */
  computeCoupling(): { real: number; imag: number; magnitude: number } {
    const real = this.fastAmplitude * Math.cos(this.slowPhase);
    const imag = this.fastAmplitude * Math.sin(this.slowPhase);
    const magnitude = Math.sqrt(real * real + imag * imag);

    this.couplingHistory.push(magnitude);
    if (this.couplingHistory.length > this.maxHistory) {
      this.couplingHistory.shift();
    }

    return { real, imag, magnitude };
  }

  /**
   * Compute mean coupling strength over history
   */
  getMeanCoupling(): number {
    if (this.couplingHistory.length === 0) return 0;
    return (
      this.couplingHistory.reduce((a, b) => a + b, 0) /
      this.couplingHistory.length
    );
  }

  /**
   * Get preferred phase (phase at which amplitude is highest)
   */
  getPreferredPhase(): number {
    // Simplified: return current slow phase if coupling is strong
    return this.slowPhase;
  }

  /**
   * Modulate signal based on phase
   * Output = input × (1 + coupling_strength × cos(φ_slow - preferred_phase))
   */
  modulateSignal(input: number, preferredPhase = 0): number {
    const modulation =
      1 + this.getMeanCoupling() * Math.cos(this.slowPhase - preferredPhase);
    return input * modulation;
  }
}

// ----------------------------------------------------------------------------
// AROUSAL-COHERENCE DYNAMICS
// The fundamental backend equations running in frontend
// ----------------------------------------------------------------------------

/**
 * Arousal-Coherence-Drift-Emergence Dynamics
 *
 * SAME EQUATIONS as backend (main.mo), running in frontend for local prediction:
 *
 * A(t+1) = A(t) × 0.995 + drift × 0.3
 * C(t+1) = C(t) × 0.992 + 0.004 − arousalPressure
 * drift = |coherence - 0.5| × 0.4 + (1 - coherence) × 0.25
 * emergence = coherence × (1 - drift)
 */
export class ArousalCoherenceDynamics {
  private arousal = 0.5;
  private coherence = 0.7;
  private drift = 0.0;
  private emergence = 0.5;
  private heartbeat: bigint = BigInt(0);

  // Constants (SAME as backend)
  private readonly AROUSAL_DECAY = 0.995;
  private readonly AROUSAL_DRIFT_COUPLING = 0.3;
  private readonly COHERENCE_DECAY = 0.992;
  private readonly COHERENCE_RECOVERY = 0.004;
  private readonly DRIFT_COHERENCE_FACTOR = 0.4;
  private readonly DRIFT_INSTABILITY_FACTOR = 0.25;

  /**
   * Tick one heartbeat (same as backend)
   */
  tick(): void {
    // Increment heartbeat
    this.heartbeat = this.heartbeat + BigInt(1);

    // Compute drift: |coherence - 0.5| × 0.4 + (1 - coherence) × 0.25
    this.drift =
      Math.abs(this.coherence - 0.5) * this.DRIFT_COHERENCE_FACTOR +
      (1 - this.coherence) * this.DRIFT_INSTABILITY_FACTOR;
    this.drift = Math.max(0, Math.min(1, this.drift));

    // Compute arousal pressure
    const arousalPressure = Math.max(0, this.arousal - 0.5) * 0.1;

    // Update arousal: A(t+1) = A(t) × 0.995 + drift × 0.3
    this.arousal =
      this.arousal * this.AROUSAL_DECAY +
      this.drift * this.AROUSAL_DRIFT_COUPLING;
    this.arousal = Math.max(0, Math.min(1, this.arousal));

    // Update coherence: C(t+1) = C(t) × 0.992 + 0.004 - arousalPressure
    this.coherence =
      this.coherence * this.COHERENCE_DECAY +
      this.COHERENCE_RECOVERY -
      arousalPressure;
    this.coherence = Math.max(0, Math.min(1, this.coherence));

    // Compute emergence: E = coherence × (1 - drift)
    this.emergence = this.coherence * (1 - this.drift);
  }

  /**
   * Sync from backend state
   */
  syncFromBackend(pulse: {
    heartbeat: bigint;
    arousal: number;
    coherence: number;
    drift: number;
    emergence: number;
  }): void {
    this.heartbeat = pulse.heartbeat;
    this.arousal = pulse.arousal;
    this.coherence = pulse.coherence;
    this.drift = pulse.drift;
    this.emergence = pulse.emergence;
  }

  /**
   * Apply external input (events that affect arousal)
   */
  applyInput(arousalDelta: number, coherenceDelta: number): void {
    this.arousal = Math.max(0, Math.min(1, this.arousal + arousalDelta));
    this.coherence = Math.max(0, Math.min(1, this.coherence + coherenceDelta));
  }

  /**
   * Get current state
   */
  getState(): {
    heartbeat: bigint;
    arousal: number;
    coherence: number;
    drift: number;
    emergence: number;
  } {
    return {
      heartbeat: this.heartbeat,
      arousal: this.arousal,
      coherence: this.coherence,
      drift: this.drift,
      emergence: this.emergence,
    };
  }
}

// ----------------------------------------------------------------------------
// DUALITY TRANSFORMER
// Transforms between Male (Backend) and Female (Frontend) representations
// ----------------------------------------------------------------------------

/**
 * Duality Transformer
 *
 * The Backend (Male) and Frontend (Female) are INVERSES:
 *
 * Backend: Accumulates, Structures, Persists, Seeds
 * Frontend: Expresses, Creates, Flows, Flowers
 *
 * Transform: Backend State → Frontend Expression
 * Inverse:   Frontend Creation → Backend Persistence
 */
export class DualityTransformer {
  /**
   * Transform backend state to frontend expression
   * Male → Female: Structure becomes Creation
   */
  backendToFrontend(backendState: {
    coherence: number;
    arousal: number;
    drift: number;
    emergence: number;
  }): {
    creativity: number;
    expression: number;
    flow: number;
    bloom: number;
  } {
    // Inverse transformations
    return {
      // High coherence (male order) → High creativity (female expression)
      creativity: backendState.coherence,

      // Low arousal (male calm) → High flow (female ease)
      expression: 1 - backendState.arousal * 0.5,

      // Low drift (male stability) → High bloom (female flourishing)
      flow: 1 - backendState.drift,

      // High emergence (male potential) → High bloom (female actualization)
      bloom: backendState.emergence,
    };
  }

  /**
   * Transform frontend creation to backend persistence
   * Female → Male: Creation becomes Structure
   */
  frontendToBackend(frontendState: {
    creativity: number;
    expression: number;
    flow: number;
    bloom: number;
  }): {
    coherence: number;
    arousal: number;
    drift: number;
    emergence: number;
  } {
    // Inverse of inverse = original (with some transformation)
    return {
      // High creativity → Increased coherence (learning consolidates)
      coherence: frontendState.creativity * 0.8 + 0.2,

      // High expression → Moderate arousal (activity creates energy)
      arousal: (1 - frontendState.expression) * 0.5 + 0.25,

      // High flow → Low drift (smooth operation)
      drift: (1 - frontendState.flow) * 0.5,

      // High bloom → High emergence (creation manifests)
      emergence: frontendState.bloom,
    };
  }

  /**
   * Compute duality balance
   * Perfect balance = 0.5, Male dominant < 0.5, Female dominant > 0.5
   */
  computeDualityBalance(backendWeight: number, frontendWeight: number): number {
    const total = backendWeight + frontendWeight;
    if (total === 0) return 0.5;
    return frontendWeight / total;
  }

  /**
   * Generate creative output based on duality
   * Creation emerges from the union of structure (male) and expression (female)
   */
  generateCreation(
    structure: number, // Backend contribution
    expression: number, // Frontend contribution
  ): number {
    // Creation = geometric mean (requires both)
    return Math.sqrt(structure * expression);
  }
}

// ----------------------------------------------------------------------------
// EXPORT ALL MATHEMATICAL COMPONENTS
// ----------------------------------------------------------------------------

export const ARCHITECTURAL_MATH = {
  KuramotoSynchronization,
  HebbianPlasticity,
  JasmineLaw,
  FreeEnergyMinimizer,
  TemporalGovernor,
  QLearning,
  KalmanFilter,
  PhaseAmplitudeCoupling,
  ArousalCoherenceDynamics,
  DualityTransformer,
} as const;

export default ARCHITECTURAL_MATH;
