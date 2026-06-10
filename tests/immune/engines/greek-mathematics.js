/**
 * GREEK MATHEMATICS ENGINE — Ancient Foundations for Modern Chaos
 * Nova by FreddyCreates
 * 
 * "In chaos, we find the golden ratio. In the golden ratio, we find order."
 * 
 * This module implements the mathematical foundations from ancient Greek
 * mathematics that power the Nova Immune System:
 * 
 * THE GOLDEN RATIO (φ):
 * - Discovered by Pythagoras, refined by Euclid
 * - φ = (1 + √5) / 2 ≈ 1.618033988749895
 * - φ⁻¹ = φ - 1 ≈ 0.618033988749895
 * - Self-similar: φ² = φ + 1
 * 
 * FIBONACCI SEQUENCE:
 * - F(n) = F(n-1) + F(n-2)
 * - lim(n→∞) F(n+1)/F(n) = φ
 * - Nature's growth pattern
 * 
 * GREEK LETTER CONSTANTS:
 * - Each Greek letter maps to a fundamental constant
 * - These create the "immune frequencies" for system resonance
 * 
 * @version 1.0.0
 * @copyright Nova Protocol by FreddyCreates
 */

// ═══════════════════════════════════════════════════════════════════════════
// THE GOLDEN RATIO AND DERIVED CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════

/** φ (Phi) — The Golden Ratio */
export const PHI = 1.618033988749895;

/** φ⁻¹ — The Golden Ratio Inverse */
export const PHI_INV = 1 / PHI;  // 0.618033988749895

/** φ² — The Golden Ratio Squared */
export const PHI_SQ = PHI * PHI;  // 2.618033988749895

/** √φ — The Golden Ratio Root */
export const PHI_ROOT = Math.sqrt(PHI);  // 1.272019649514069

/** φ-beat — The heartbeat interval (ms) */
export const PHI_BEAT = 873;  // ms — the organism pulse

// ═══════════════════════════════════════════════════════════════════════════
// GREEK LETTER CONSTANTS — Each letter is a fundamental frequency
// ═══════════════════════════════════════════════════════════════════════════

export const GREEK = {
  // ─── Primary Letters (Core System Frequencies) ─────────────────────────
  
  /** α (Alpha) — The beginning, emergence threshold */
  ALPHA: {
    symbol: 'α',
    name: 'Alpha',
    value: PHI_INV,  // 0.618...
    meaning: 'Emergence threshold — the minimum coherence for system activation',
    frequency: 1 / PHI_INV,  // ~1.618 Hz
    color: '#FF6B6B',
    domain: 'EMERGENCE'
  },
  
  /** β (Beta) — Growth factor, expansion rate */
  BETA: {
    symbol: 'β',
    name: 'Beta',
    value: PHI,  // 1.618...
    meaning: 'Growth factor — the rate of exponential expansion',
    frequency: PHI,  // 1.618 Hz
    color: '#4ECDC4',
    domain: 'GROWTH'
  },
  
  /** γ (Gamma) — Decay constant, entropy rate */
  GAMMA: {
    symbol: 'γ',
    name: 'Gamma',
    value: 0.5772156649015329,  // Euler-Mascheroni constant
    meaning: 'Decay constant — the rate of entropy and forgetting',
    frequency: 0.5772156649015329,
    color: '#45B7D1',
    domain: 'DECAY'
  },
  
  /** δ (Delta) — Change threshold, minimum detectable difference */
  DELTA: {
    symbol: 'δ',
    name: 'Delta',
    value: 1 / (PHI * PHI),  // φ⁻² ≈ 0.382
    meaning: 'Change threshold — minimum detectable perturbation',
    frequency: 1 / (PHI * PHI),
    color: '#96CEB4',
    domain: 'DETECTION'
  },
  
  /** ε (Epsilon) — Tolerance, acceptable error */
  EPSILON: {
    symbol: 'ε',
    name: 'Epsilon',
    value: 1e-7,  // Machine epsilon scaled
    meaning: 'Tolerance — acceptable deviation from expected',
    frequency: 1e-7,
    color: '#FFEAA7',
    domain: 'TOLERANCE'
  },
  
  /** ζ (Zeta) — Damping factor, oscillation control */
  ZETA: {
    symbol: 'ζ',
    name: 'Zeta',
    value: 1.2020569031595942,  // Apéry's constant ζ(3)
    meaning: 'Damping factor — controls oscillation and resonance',
    frequency: 1.2020569031595942,
    color: '#DDA0DD',
    domain: 'DAMPING'
  },
  
  /** η (Eta) — Learning rate, adaptation speed */
  ETA: {
    symbol: 'η',
    name: 'Eta',
    value: 0.01 * PHI,  // φ-scaled learning rate
    meaning: 'Learning rate — speed of Hebbian adaptation',
    frequency: 0.01 * PHI,
    color: '#98D8C8',
    domain: 'LEARNING'
  },
  
  /** θ (Theta) — Phase angle, oscillation position */
  THETA: {
    symbol: 'θ',
    name: 'Theta',
    value: Math.PI / PHI,  // π/φ ≈ 1.942
    meaning: 'Phase angle — position in oscillation cycle',
    frequency: Math.PI / PHI,
    color: '#F7DC6F',
    domain: 'PHASE'
  },
  
  /** ι (Iota) — Infinitesimal, smallest unit */
  IOTA: {
    symbol: 'ι',
    name: 'Iota',
    value: 1 / Math.pow(PHI, 10),  // φ⁻¹⁰ ≈ 0.0081
    meaning: 'Infinitesimal — the smallest meaningful unit',
    frequency: 1 / Math.pow(PHI, 10),
    color: '#BB8FCE',
    domain: 'MINIMAL'
  },
  
  /** κ (Kappa) — Curvature, complexity measure */
  KAPPA: {
    symbol: 'κ',
    name: 'Kappa',
    value: 2 * Math.PI / PHI,  // 2π/φ
    meaning: 'Curvature — measure of complexity and bending',
    frequency: 2 * Math.PI / PHI,
    color: '#85C1E9',
    domain: 'COMPLEXITY'
  },
  
  /** λ (Lambda) — Wavelength, information density */
  LAMBDA: {
    symbol: 'λ',
    name: 'Lambda',
    value: PHI * PHI * PHI,  // φ³ ≈ 4.236
    meaning: 'Wavelength — information density per cycle',
    frequency: PHI * PHI * PHI,
    color: '#F8B500',
    domain: 'DENSITY'
  },
  
  /** μ (Mu) — Mean, central tendency */
  MU: {
    symbol: 'μ',
    name: 'Mu',
    value: 0.5,  // Center
    meaning: 'Mean — the expected central value',
    frequency: 0.5,
    color: '#58D68D',
    domain: 'CENTER'
  },
  
  /** ν (Nu) — Frequency, oscillation rate */
  NU: {
    symbol: 'ν',
    name: 'Nu',
    value: 1000 / PHI_BEAT,  // ~1.145 Hz
    meaning: 'Frequency — base oscillation rate',
    frequency: 1000 / PHI_BEAT,
    color: '#EC7063',
    domain: 'FREQUENCY'
  },
  
  /** ξ (Xi) — Noise, chaos amplitude */
  XI: {
    symbol: 'ξ',
    name: 'Xi',
    value: Math.sqrt(2) / PHI,  // √2/φ ≈ 0.874
    meaning: 'Noise — amplitude of chaos injection',
    frequency: Math.sqrt(2) / PHI,
    color: '#AF7AC5',
    domain: 'NOISE'
  },
  
  /** π (Pi) — Circle constant */
  PI: {
    symbol: 'π',
    name: 'Pi',
    value: Math.PI,  // 3.14159...
    meaning: 'Circle constant — ratio of circumference to diameter',
    frequency: Math.PI,
    color: '#5DADE2',
    domain: 'CIRCLE'
  },
  
  /** ρ (Rho) — Density, concentration */
  RHO: {
    symbol: 'ρ',
    name: 'Rho',
    value: PHI / Math.E,  // φ/e ≈ 0.595
    meaning: 'Density — concentration of active elements',
    frequency: PHI / Math.E,
    color: '#F1948A',
    domain: 'CONCENTRATION'
  },
  
  /** σ (Sigma) — Standard deviation, spread */
  SIGMA: {
    symbol: 'σ',
    name: 'Sigma',
    value: 1 / Math.sqrt(PHI),  // 1/√φ ≈ 0.786
    meaning: 'Standard deviation — spread of distribution',
    frequency: 1 / Math.sqrt(PHI),
    color: '#82E0AA',
    domain: 'SPREAD'
  },
  
  /** τ (Tau) — Time constant, decay rate */
  TAU: {
    symbol: 'τ',
    name: 'Tau',
    value: 2 * Math.PI,  // τ = 2π
    meaning: 'Time constant — full cycle duration',
    frequency: 2 * Math.PI,
    color: '#D7BDE2',
    domain: 'TIME'
  },
  
  /** υ (Upsilon) — Upward force, emergence pressure */
  UPSILON: {
    symbol: 'υ',
    name: 'Upsilon',
    value: Math.E / PHI,  // e/φ ≈ 1.680
    meaning: 'Emergence pressure — force toward higher order',
    frequency: Math.E / PHI,
    color: '#AED6F1',
    domain: 'EMERGENCE_PRESSURE'
  },
  
  /** φ (Phi) — The Golden Ratio itself */
  PHI: {
    symbol: 'φ',
    name: 'Phi',
    value: PHI,
    meaning: 'The Golden Ratio — nature\'s perfect proportion',
    frequency: PHI,
    color: '#F9E79F',
    domain: 'GOLDEN'
  },
  
  /** χ (Chi) — Chi-squared, goodness of fit */
  CHI: {
    symbol: 'χ',
    name: 'Chi',
    value: Math.sqrt(PHI),  // √φ ≈ 1.272
    meaning: 'Goodness of fit — how well reality matches expectation',
    frequency: Math.sqrt(PHI),
    color: '#FADBD8',
    domain: 'FIT'
  },
  
  /** ψ (Psi) — Wave function, probability amplitude */
  PSI: {
    symbol: 'ψ',
    name: 'Psi',
    value: 1 / Math.sqrt(2),  // 1/√2 ≈ 0.707
    meaning: 'Wave function — probability amplitude',
    frequency: 1 / Math.sqrt(2),
    color: '#D5F5E3',
    domain: 'PROBABILITY'
  },
  
  /** ω (Omega) — The end, convergence point */
  OMEGA: {
    symbol: 'ω',
    name: 'Omega',
    value: 0.5671432904097838,  // Omega constant Ω
    meaning: 'Convergence point — where iterations stabilize',
    frequency: 0.5671432904097838,
    color: '#E8DAEF',
    domain: 'CONVERGENCE'
  }
};

// ═══════════════════════════════════════════════════════════════════════════
// FIBONACCI SEQUENCE GENERATOR
// ═══════════════════════════════════════════════════════════════════════════

/**
 * Generate Fibonacci numbers up to n
 * @param {number} n - Count of Fibonacci numbers
 * @returns {number[]} - Array of Fibonacci numbers
 */
export function fibonacci(n) {
  const fib = [0, 1];
  for (let i = 2; i < n; i++) {
    fib[i] = fib[i - 1] + fib[i - 2];
  }
  return fib.slice(0, n);
}

/** First 21 Fibonacci numbers (F₀ to F₂₀) */
export const FIBONACCI_SEQUENCE = fibonacci(21);

/** Fibonacci intervals for immune timing */
export const FIBONACCI_INTERVALS = FIBONACCI_SEQUENCE.slice(2).map(f => f * 100);  // ms

// ═══════════════════════════════════════════════════════════════════════════
// GOLDEN SPIRAL MATHEMATICS
// ═══════════════════════════════════════════════════════════════════════════

/**
 * Calculate point on golden spiral
 * r = a * φ^(θ/90°)
 * @param {number} theta - Angle in radians
 * @param {number} a - Initial radius
 * @returns {{ x: number, y: number }} - Cartesian coordinates
 */
export function goldenSpiralPoint(theta, a = 1) {
  const r = a * Math.pow(PHI, theta / (Math.PI / 2));
  return {
    x: r * Math.cos(theta),
    y: r * Math.sin(theta),
    r,
    theta
  };
}

/**
 * Generate golden spiral points
 * @param {number} points - Number of points
 * @param {number} maxTheta - Maximum angle
 * @returns {Array} - Array of spiral points
 */
export function goldenSpiral(points, maxTheta = 4 * Math.PI) {
  const spiral = [];
  for (let i = 0; i < points; i++) {
    const theta = (i / points) * maxTheta;
    spiral.push(goldenSpiralPoint(theta));
  }
  return spiral;
}

// ═══════════════════════════════════════════════════════════════════════════
// KURAMOTO OSCILLATOR MODEL
// ═══════════════════════════════════════════════════════════════════════════

/**
 * Kuramoto order parameter R — measures synchronization
 * R = |1/N Σ e^(iθⱼ)|
 * 
 * R = 1: Perfect synchronization
 * R = 0: Complete incoherence
 * 
 * @param {number[]} phases - Array of oscillator phases
 * @returns {number} - Order parameter R ∈ [0, 1]
 */
export function kuramotoR(phases) {
  if (phases.length === 0) return 0;
  
  let sumCos = 0;
  let sumSin = 0;
  
  for (const theta of phases) {
    sumCos += Math.cos(theta);
    sumSin += Math.sin(theta);
  }
  
  const n = phases.length;
  return Math.sqrt((sumCos / n) ** 2 + (sumSin / n) ** 2);
}

/**
 * Kuramoto coupling constant K — φ-scaled
 * When K > K_critical, synchronization emerges
 */
export const KURAMOTO_K = PHI;

/**
 * Update oscillator phase using Kuramoto model
 * dθᵢ/dt = ωᵢ + (K/N) Σ sin(θⱼ - θᵢ)
 * 
 * @param {number} theta - Current phase
 * @param {number} omega - Natural frequency
 * @param {number[]} allPhases - All oscillator phases
 * @param {number} K - Coupling constant
 * @param {number} dt - Time step
 * @returns {number} - New phase
 */
export function kuramotoUpdate(theta, omega, allPhases, K = KURAMOTO_K, dt = 0.1) {
  const n = allPhases.length;
  let coupling = 0;
  
  for (const thetaJ of allPhases) {
    coupling += Math.sin(thetaJ - theta);
  }
  
  const dTheta = omega + (K / n) * coupling;
  return (theta + dTheta * dt) % (2 * Math.PI);
}

// ═══════════════════════════════════════════════════════════════════════════
// LYAPUNOV EXPONENT — CHAOS MEASUREMENT
// ═══════════════════════════════════════════════════════════════════════════

/**
 * Estimate Lyapunov exponent from time series
 * λ > 0: Chaotic
 * λ ≈ 0: Edge of chaos
 * λ < 0: Stable/periodic
 * 
 * @param {number[]} series - Time series data
 * @param {number} epsilon - Perturbation size
 * @returns {number} - Estimated Lyapunov exponent
 */
export function estimateLyapunov(series, epsilon = 0.001) {
  if (series.length < 10) return 0;
  
  let sum = 0;
  let count = 0;
  
  for (let i = 0; i < series.length - 1; i++) {
    // Find nearest neighbor
    let minDist = Infinity;
    let nearestIdx = -1;
    
    for (let j = 0; j < series.length - 1; j++) {
      if (Math.abs(i - j) > 5) {  // Temporal separation
        const dist = Math.abs(series[i] - series[j]);
        if (dist < minDist && dist > epsilon) {
          minDist = dist;
          nearestIdx = j;
        }
      }
    }
    
    if (nearestIdx >= 0) {
      const d0 = minDist;
      const d1 = Math.abs(series[i + 1] - series[nearestIdx + 1]);
      
      if (d1 > epsilon && d0 > epsilon) {
        sum += Math.log(d1 / d0);
        count++;
      }
    }
  }
  
  return count > 0 ? sum / count : 0;
}

// ═══════════════════════════════════════════════════════════════════════════
// ENTROPY CALCULATIONS
// ═══════════════════════════════════════════════════════════════════════════

/**
 * Shannon entropy H = -Σ p(x) log₂ p(x)
 * @param {number[]} probabilities - Array of probabilities (must sum to 1)
 * @returns {number} - Entropy in bits
 */
export function shannonEntropy(probabilities) {
  let H = 0;
  for (const p of probabilities) {
    if (p > 0) {
      H -= p * Math.log2(p);
    }
  }
  return H;
}

/**
 * Approximate entropy — measures unpredictability
 * @param {number[]} series - Time series
 * @param {number} m - Embedding dimension
 * @param {number} r - Tolerance
 * @returns {number} - Approximate entropy
 */
export function approximateEntropy(series, m = 2, r = 0.2) {
  const n = series.length;
  if (n < m + 1) return 0;
  
  const std = Math.sqrt(
    series.reduce((sum, x) => sum + x * x, 0) / n -
    Math.pow(series.reduce((sum, x) => sum + x, 0) / n, 2)
  );
  
  const tolerance = r * std;
  
  function phi(dim) {
    let count = 0;
    const patterns = [];
    
    for (let i = 0; i <= n - dim; i++) {
      patterns.push(series.slice(i, i + dim));
    }
    
    for (let i = 0; i < patterns.length; i++) {
      let matches = 0;
      for (let j = 0; j < patterns.length; j++) {
        let maxDiff = 0;
        for (let k = 0; k < dim; k++) {
          maxDiff = Math.max(maxDiff, Math.abs(patterns[i][k] - patterns[j][k]));
        }
        if (maxDiff <= tolerance) matches++;
      }
      count += Math.log(matches / patterns.length);
    }
    
    return count / patterns.length;
  }
  
  return phi(m) - phi(m + 1);
}

// ═══════════════════════════════════════════════════════════════════════════
// GREEK ENGINE CLASS
// ═══════════════════════════════════════════════════════════════════════════

/**
 * GreekMathEngine — The mathematical foundation for all immune operations
 */
export class GreekMathEngine {
  constructor() {
    this.constants = GREEK;
    this.fibonacci = FIBONACCI_SEQUENCE;
    this.phi = PHI;
    this.phiInv = PHI_INV;
    this.phiBeat = PHI_BEAT;
    
    // State
    this.oscillators = [];
    this.entropy = 0;
    this.lyapunov = 0;
    this.coherence = 0;
  }
  
  /**
   * Initialize oscillators for immune system
   */
  initializeOscillators(count = 13) {
    this.oscillators = [];
    
    // Use Fibonacci-spaced natural frequencies
    const fibFreqs = this.fibonacci.slice(1, count + 1);
    
    for (let i = 0; i < count; i++) {
      this.oscillators.push({
        id: i,
        phase: Math.random() * 2 * Math.PI,
        omega: (fibFreqs[i] || (i + 1)) * 0.1,  // Natural frequency
        amplitude: 1
      });
    }
    
    return this.oscillators;
  }
  
  /**
   * Step oscillators forward
   */
  stepOscillators(dt = 0.1) {
    const phases = this.oscillators.map(o => o.phase);
    
    for (const osc of this.oscillators) {
      osc.phase = kuramotoUpdate(osc.phase, osc.omega, phases, KURAMOTO_K, dt);
    }
    
    this.coherence = kuramotoR(this.oscillators.map(o => o.phase));
    return this.coherence;
  }
  
  /**
   * Check if system has reached emergence (coherence > φ⁻¹)
   */
  hasEmergence() {
    return this.coherence > PHI_INV;
  }
  
  /**
   * Get current Greek letter activation based on coherence
   */
  getActiveGreekLetter() {
    const c = this.coherence;
    
    if (c < GREEK.DELTA.value) return GREEK.OMEGA;      // Converging
    if (c < GREEK.ALPHA.value) return GREEK.GAMMA;      // Decaying
    if (c < GREEK.MU.value) return GREEK.DELTA;         // Detecting
    if (c < GREEK.SIGMA.value) return GREEK.MU;         // Centering
    if (c < GREEK.CHI.value) return GREEK.ALPHA;        // Emerging
    return GREEK.PHI;                                     // Golden coherence
  }
  
  /**
   * Calculate system entropy
   */
  calculateEntropy(series) {
    if (!series || series.length < 10) return 0;
    this.entropy = approximateEntropy(series);
    return this.entropy;
  }
  
  /**
   * Calculate Lyapunov exponent
   */
  calculateLyapunov(series) {
    if (!series || series.length < 10) return 0;
    this.lyapunov = estimateLyapunov(series);
    return this.lyapunov;
  }
  
  /**
   * Get golden ratio power
   */
  phiPower(n) {
    return Math.pow(PHI, n);
  }
  
  /**
   * Get inverse golden ratio power
   */
  phiInvPower(n) {
    return Math.pow(PHI_INV, n);
  }
  
  /**
   * Generate φ-weighted sequence (for priority queues)
   */
  phiWeightedSequence(n) {
    const seq = [];
    for (let i = 0; i < n; i++) {
      seq.push(this.phiInvPower(i));
    }
    return seq;
  }
  
  /**
   * Get state snapshot
   */
  getState() {
    return {
      phi: this.phi,
      phiBeat: this.phiBeat,
      coherence: this.coherence,
      emergence: this.hasEmergence(),
      entropy: this.entropy,
      lyapunov: this.lyapunov,
      oscillatorCount: this.oscillators.length,
      activeGreek: this.getActiveGreekLetter(),
      timestamp: Date.now()
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// DEFAULT EXPORT
// ═══════════════════════════════════════════════════════════════════════════

export default {
  // Constants
  PHI,
  PHI_INV,
  PHI_SQ,
  PHI_ROOT,
  PHI_BEAT,
  GREEK,
  FIBONACCI_SEQUENCE,
  FIBONACCI_INTERVALS,
  KURAMOTO_K,
  
  // Functions
  fibonacci,
  goldenSpiralPoint,
  goldenSpiral,
  kuramotoR,
  kuramotoUpdate,
  estimateLyapunov,
  shannonEntropy,
  approximateEntropy,
  
  // Class
  GreekMathEngine
};
