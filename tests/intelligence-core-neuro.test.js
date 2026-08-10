/**
 * Intelligence Core — Neuro Math Validation Tests
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 *
 * Validates the mathematical correctness of intelligence_core pillar computations
 * by reimplementing critical functions in JS and checking invariants.
 */

import { describe, it, expect } from 'vitest';

// ═══════════════════════════════════════════════════════════════════════════════
// CONSTANTS (mirror of computing/core.mo)
// ═══════════════════════════════════════════════════════════════════════════════

const PHI = 1.6180339887498948482;
const PHI_INV = 0.618033988749895;
const TWO_PI = 6.2831853071795864769;
const PI = 3.1415926535897932385;
const EPSILON = 0.0001;

// ═══════════════════════════════════════════════════════════════════════════════
// HELPER: JS reimplementation of core functions
// ═══════════════════════════════════════════════════════════════════════════════

function sigmoid(x) { return 1.0 / (1.0 + Math.exp(-x)); }
function tanh(x) { return Math.tanh(x); }
function clamp(v, min, max) { return Math.max(min, Math.min(max, v)); }
function wrapAngle(a) {
  while (a < 0) a += TWO_PI;
  while (a >= TWO_PI) a -= TWO_PI;
  return a;
}
function softmax(values) {
  const max = Math.max(...values);
  const exps = values.map(v => Math.exp(v - max));
  const sum = exps.reduce((a, b) => a + b, 0);
  return exps.map(e => e / sum);
}

// ═══════════════════════════════════════════════════════════════════════════════
// COMPUTING PILLAR TESTS
// ═══════════════════════════════════════════════════════════════════════════════

describe('Intelligence Core — Computing Pillar', () => {
  it('PHI satisfies φ² = φ + 1', () => {
    expect(Math.abs(PHI * PHI - PHI - 1)).toBeLessThan(1e-14);
  });

  it('PHI_INV satisfies 1/φ = φ - 1', () => {
    expect(Math.abs(PHI_INV - (PHI - 1))).toBeLessThan(1e-14);
  });

  it('Fibonacci sequence convergence ratio → φ', () => {
    const fib = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987];
    const ratio = fib[15] / fib[14];
    expect(Math.abs(ratio - PHI)).toBeLessThan(0.001);
  });

  it('sigmoid(0) = 0.5', () => {
    expect(sigmoid(0)).toBe(0.5);
  });

  it('sigmoid is bounded [0, 1]', () => {
    for (let x = -10; x <= 10; x += 0.5) {
      const s = sigmoid(x);
      expect(s).toBeGreaterThanOrEqual(0);
      expect(s).toBeLessThanOrEqual(1);
    }
  });

  it('softmax sums to 1', () => {
    const result = softmax([1.0, 2.0, 3.0, 4.0]);
    const sum = result.reduce((a, b) => a + b, 0);
    expect(Math.abs(sum - 1.0)).toBeLessThan(1e-10);
  });

  it('softmax is monotone', () => {
    const result = softmax([1.0, 2.0, 3.0]);
    expect(result[2]).toBeGreaterThan(result[1]);
    expect(result[1]).toBeGreaterThan(result[0]);
  });
});

// ═══════════════════════════════════════════════════════════════════════════════
// EMERGENCE PILLAR TESTS
// ═══════════════════════════════════════════════════════════════════════════════

describe('Intelligence Core — Emergence Pillar', () => {
  function kuramotoOrderParameter(phases) {
    const n = phases.length;
    if (n === 0) return { r: 0, psi: 0 };
    let sumCos = 0, sumSin = 0;
    for (const theta of phases) {
      sumCos += Math.cos(theta);
      sumSin += Math.sin(theta);
    }
    const meanCos = sumCos / n;
    const meanSin = sumSin / n;
    return {
      r: Math.sqrt(meanCos ** 2 + meanSin ** 2),
      psi: Math.atan2(meanSin, meanCos)
    };
  }

  it('fully synchronized phases → R = 1', () => {
    const phases = [1.0, 1.0, 1.0, 1.0, 1.0];
    const { r } = kuramotoOrderParameter(phases);
    expect(Math.abs(r - 1.0)).toBeLessThan(1e-10);
  });

  it('uniformly distributed phases → R ≈ 0', () => {
    const n = 100;
    const phases = Array.from({ length: n }, (_, i) => (TWO_PI * i) / n);
    const { r } = kuramotoOrderParameter(phases);
    expect(r).toBeLessThan(0.05);
  });

  it('Lorenz attractor step preserves finite values', () => {
    let x = 1, y = 1, z = 1;
    const sigma = 10, rho = 28, beta = 8 / 3, dt = 0.01;
    for (let step = 0; step < 1000; step++) {
      const dx = sigma * (y - x) * dt;
      const dy = (x * (rho - z) - y) * dt;
      const dz = (x * y - beta * z) * dt;
      x += dx; y += dy; z += dz;
    }
    expect(isFinite(x) && isFinite(y) && isFinite(z)).toBe(true);
  });
});

// ═══════════════════════════════════════════════════════════════════════════════
// NEURAL PILLAR TESTS
// ═══════════════════════════════════════════════════════════════════════════════

describe('Intelligence Core — Neural Pillar', () => {
  it('release probability is bounded [0, 1]', () => {
    for (let ca = 0; ca <= 10; ca += 0.5) {
      const p = 1.0 - Math.exp(-ca / 1.0);
      expect(p).toBeGreaterThanOrEqual(0);
      expect(p).toBeLessThanOrEqual(1);
    }
  });

  it('Hill equation saturates at Emax', () => {
    const emax = 1.0, kd = 0.5, n = 2;
    const response = emax * Math.pow(100, n) / (Math.pow(kd, n) + Math.pow(100, n));
    expect(Math.abs(response - emax)).toBeLessThan(0.01);
  });

  it('STDP kernel: pre-before-post → LTP (positive)', () => {
    const deltaT = 5.0; // pre fires 5ms before post
    const aPlus = 0.1, tauPlus = 20;
    const change = aPlus * Math.exp(-deltaT / tauPlus);
    expect(change).toBeGreaterThan(0);
  });

  it('STDP kernel: post-before-pre → LTD (negative)', () => {
    const deltaT = -5.0; // post fires before pre
    const aMinus = 0.1, tauMinus = 20;
    const change = -aMinus * Math.exp(deltaT / tauMinus);
    expect(change).toBeLessThan(0);
  });

  it('LIF neuron decays to resting potential', () => {
    let v = -50; // above rest
    const vRest = -65, tau = 10, dt = 0.1;
    for (let i = 0; i < 1000; i++) {
      v = v + (-(v - vRest) / tau) * dt;
    }
    expect(Math.abs(v - vRest)).toBeLessThan(0.01);
  });
});

// ═══════════════════════════════════════════════════════════════════════════════
// COGNITIVE PILLAR TESTS
// ═══════════════════════════════════════════════════════════════════════════════

describe('Intelligence Core — Cognitive Pillar', () => {
  it('attention scores sum to 1 (softmax property)', () => {
    const query = [1, 0, 1];
    const keys = [[1, 0, 0], [0, 1, 0], [1, 0, 1]];
    const d = query.length;
    const scale = Math.sqrt(d);
    const scores = keys.map(k => {
      let dot = 0;
      for (let i = 0; i < d; i++) dot += query[i] * k[i];
      return dot / scale;
    });
    const result = softmax(scores);
    const sum = result.reduce((a, b) => a + b, 0);
    expect(Math.abs(sum - 1.0)).toBeLessThan(1e-10);
  });

  it('belief entropy is 0 for certainty', () => {
    const beliefs = [1.0, 0.0, 0.0];
    let entropy = 0;
    for (const p of beliefs) {
      if (p > EPSILON) entropy -= p * Math.log(p);
    }
    expect(Math.abs(entropy)).toBeLessThan(1e-10);
  });

  it('belief entropy is maximal for uniform distribution', () => {
    const n = 4;
    const uniform = Array(n).fill(1.0 / n);
    let entropy = 0;
    for (const p of uniform) entropy -= p * Math.log(p);
    expect(Math.abs(entropy - Math.log(n))).toBeLessThan(1e-10);
  });

  it('free energy is non-negative', () => {
    const errors = [0.5, -0.3, 0.2];
    const complexity = 0.1;
    const accuracy = errors.reduce((s, e) => s + e * e, 0) / 2.0;
    const F = accuracy + complexity;
    expect(F).toBeGreaterThanOrEqual(0);
  });
});

// ═══════════════════════════════════════════════════════════════════════════════
// SCALABILITY PILLAR TESTS
// ═══════════════════════════════════════════════════════════════════════════════

describe('Intelligence Core — Scalability Pillar', () => {
  it('load balance sums to 1', () => {
    const capacities = [10, 20, 30, 40];
    const total = capacities.reduce((a, b) => a + b, 0);
    const allocations = capacities.map(c => c / total);
    const sum = allocations.reduce((a, b) => a + b, 0);
    expect(Math.abs(sum - 1.0)).toBeLessThan(1e-10);
  });

  it('Fibonacci tier sizes are Fibonacci numbers', () => {
    const fib = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233];
    // Tier 0 → F₆=8, Tier 1 → F₇=13, Tier 2 → F₈=21, ...
    expect(fib[5 + 0]).toBe(8);
    expect(fib[5 + 1]).toBe(13);
    expect(fib[5 + 2]).toBe(21);
    expect(fib[5 + 3]).toBe(34);
  });

  it('Byzantine fault tolerance: 3f+1 rule', () => {
    // 7 nodes → tolerate 2 faults (3×2+1=7)
    expect(Math.floor((7 - 1) / 3)).toBe(2);
    // 10 nodes → tolerate 3 faults
    expect(Math.floor((10 - 1) / 3)).toBe(3);
  });

  it('signal attenuation decreases with distance', () => {
    const amplitude = 1.0;
    const a1 = amplitude * Math.pow(PHI_INV, 1);
    const a2 = amplitude * Math.pow(PHI_INV, 2);
    const a3 = amplitude * Math.pow(PHI_INV, 3);
    expect(a1).toBeGreaterThan(a2);
    expect(a2).toBeGreaterThan(a3);
    expect(a3).toBeGreaterThan(0);
  });
});

// ═══════════════════════════════════════════════════════════════════════════════
// MACHINE LEARNING PILLAR TESTS
// ═══════════════════════════════════════════════════════════════════════════════

describe('Intelligence Core — Machine Learning Pillar', () => {
  it('Kalman filter converges to true value', () => {
    const trueValue = 5.0;
    let state = { estimate: 0, uncertainty: 10 };
    const processNoise = 0.01;
    const measurementNoise = 1.0;

    for (let i = 0; i < 100; i++) {
      // Predict
      state = { estimate: state.estimate, uncertainty: state.uncertainty + processNoise };
      // Update
      const gain = state.uncertainty / (state.uncertainty + measurementNoise);
      const measurement = trueValue + (Math.random() - 0.5) * 0.5;
      state = {
        estimate: state.estimate + gain * (measurement - state.estimate),
        uncertainty: (1 - gain) * state.uncertainty
      };
    }
    expect(Math.abs(state.estimate - trueValue)).toBeLessThan(1.0);
  });

  it('EMA converges to constant input', () => {
    let ema = 0;
    const alpha = 0.1;
    const target = 7.0;
    for (let i = 0; i < 200; i++) {
      ema = alpha * target + (1 - alpha) * ema;
    }
    expect(Math.abs(ema - target)).toBeLessThan(0.01);
  });

  it('cosine similarity of identical vectors = 1', () => {
    const a = [1, 2, 3, 4, 5];
    let dot = 0, normA = 0;
    for (let i = 0; i < a.length; i++) {
      dot += a[i] * a[i];
      normA += a[i] * a[i];
    }
    const sim = dot / (Math.sqrt(normA) * Math.sqrt(normA));
    expect(Math.abs(sim - 1.0)).toBeLessThan(1e-10);
  });

  it('cosine similarity of orthogonal vectors = 0', () => {
    const a = [1, 0, 0];
    const b = [0, 1, 0];
    let dot = 0, normA = 0, normB = 0;
    for (let i = 0; i < 3; i++) {
      dot += a[i] * b[i];
      normA += a[i] * a[i];
      normB += b[i] * b[i];
    }
    const sim = dot / (Math.sqrt(normA) * Math.sqrt(normB));
    expect(Math.abs(sim)).toBeLessThan(1e-10);
  });

  it('linear regression slope estimation is accurate', () => {
    // y = 2x + 1
    const values = Array.from({ length: 20 }, (_, i) => 2 * i + 1);
    const n = values.length;
    let sumX = 0, sumY = 0, sumXY = 0, sumX2 = 0;
    for (let i = 0; i < n; i++) {
      sumX += i; sumY += values[i];
      sumXY += i * values[i]; sumX2 += i * i;
    }
    const slope = (n * sumXY - sumX * sumY) / (n * sumX2 - sumX * sumX);
    expect(Math.abs(slope - 2.0)).toBeLessThan(1e-10);
  });

  it('phi-discounted reward decays by golden ratio', () => {
    const reward = 10.0;
    const r1 = reward * Math.pow(PHI_INV, 1);
    const r2 = reward * Math.pow(PHI_INV, 2);
    expect(Math.abs(r1 / r2 - PHI)).toBeLessThan(1e-10);
  });
});
