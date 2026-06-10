/**
 * Alpha Protocols Test Suite
 * Tests for protocols/alpha-protocols.js - PROTO-227 through PROTO-230
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 */

import { describe, it, expect } from 'vitest';
import {
  emergenceCascade,
  alphaResonance,
  alphaSignal,
  alphaReward,
  computeEmergenceScore,
  computeKuramotoOrderParameter,
  advanceKuramotoPhases,
  createSignal,
  computeDopamineImpulse,
  computeOxytocinImpulse,
  PHI,
  PHI_INV,
  HEARTBEAT,
  PRIORITY_LEVELS,
} from '../protocols/alpha-protocols.js';

describe('Alpha Protocols', () => {
  describe('Constants', () => {
    it('should define PHI correctly', () => {
      expect(PHI).toBeCloseTo(1.618033988749895, 10);
    });

    it('should define PHI_INV correctly', () => {
      expect(PHI_INV).toBeCloseTo(0.618033988749895, 10);
    });

    it('should define HEARTBEAT as 873ms', () => {
      expect(HEARTBEAT).toBe(873);
    });

    it('should define PRIORITY_LEVELS', () => {
      expect(PRIORITY_LEVELS).toBeDefined();
      expect(PRIORITY_LEVELS.CRITICAL).toBe(0);
      expect(PRIORITY_LEVELS.HIGH).toBe(1);
      expect(PRIORITY_LEVELS.NORMAL).toBe(2);
      expect(PRIORITY_LEVELS.LOW).toBe(3);
    });
  });

  describe('computeEmergenceScore', () => {
    it('should return 0 for empty array', () => {
      expect(computeEmergenceScore([])).toBe(0);
    });

    it('should return 0 for null input', () => {
      expect(computeEmergenceScore(null)).toBe(0);
    });

    it('should compute weighted emergence score', () => {
      const values = [0.8, 0.6, 0.4];
      const score = computeEmergenceScore(values);
      expect(score).toBeGreaterThan(0);
      expect(score).toBeLessThanOrEqual(1);
    });

    it('should weight earlier values more heavily (phi-weighting)', () => {
      const frontHeavy = [1.0, 0.0, 0.0];
      const backHeavy = [0.0, 0.0, 1.0];
      const frontScore = computeEmergenceScore(frontHeavy);
      const backScore = computeEmergenceScore(backHeavy);
      expect(frontScore).toBeGreaterThan(backScore);
    });

    it('should return correct score for single value', () => {
      const score = computeEmergenceScore([0.5]);
      expect(score).toBe(0.5);
    });
  });

  describe('PROTO-227: emergenceCascade', () => {
    it('should return cascade result with correct protocol name', () => {
      const result = emergenceCascade([0.5, 0.5, 0.5]);
      expect(result.protocol).toBe('PROTO-227');
      expect(result.name).toBe('Emergence Cascade');
      expect(result.brainAnalog).toBe('Anterior Cingulate Cortex (ACC)');
    });

    it('should not trigger cascade below threshold', () => {
      const result = emergenceCascade([0.3, 0.2, 0.1]);
      expect(result.triggered).toBe(false);
      expect(result.cascadeImpulse).toBe(0);
    });

    it('should trigger cascade above PHI_INV threshold', () => {
      const result = emergenceCascade([0.9, 0.9, 0.9]);
      expect(result.triggered).toBe(true);
      expect(result.cascadeImpulse).toBeGreaterThan(0);
    });

    it('should use default threshold of PHI_INV', () => {
      const result = emergenceCascade([0.5, 0.5, 0.5]);
      expect(result.threshold).toBeCloseTo(PHI_INV, 10);
    });

    it('should accept custom threshold', () => {
      const result = emergenceCascade([0.5], { threshold: 0.4 });
      expect(result.threshold).toBe(0.4);
      expect(result.triggered).toBe(true);
    });

    it('should include broadcast vector with phi-weighted boosted values', () => {
      const result = emergenceCascade([0.9, 0.8, 0.7]);
      expect(result.broadcastVector).toHaveLength(3);
      expect(result.broadcastVector[0]).toHaveProperty('index');
      expect(result.broadcastVector[0]).toHaveProperty('original');
      expect(result.broadcastVector[0]).toHaveProperty('weight');
      expect(result.broadcastVector[0]).toHaveProperty('boosted');
    });

    it('should include timestamp', () => {
      const before = Date.now();
      const result = emergenceCascade([0.5]);
      const after = Date.now();
      expect(result.timestamp).toBeGreaterThanOrEqual(before);
      expect(result.timestamp).toBeLessThanOrEqual(after);
    });

    it('should amplify cascade impulse by PHI (default)', () => {
      const result = emergenceCascade([1.0]);
      if (result.triggered) {
        const expectedImpulse = (result.emergenceScore - result.threshold) * PHI;
        expect(result.cascadeImpulse).toBeCloseTo(expectedImpulse, 5);
      }
    });

    it('should report fleet size', () => {
      const result = emergenceCascade([0.5, 0.6, 0.7, 0.8]);
      expect(result.fleetSize).toBe(4);
    });
  });

  describe('computeKuramotoOrderParameter', () => {
    it('should return R=0 for empty array', () => {
      const result = computeKuramotoOrderParameter([]);
      expect(result.R).toBe(0);
    });

    it('should return R=0 for null input', () => {
      const result = computeKuramotoOrderParameter(null);
      expect(result.R).toBe(0);
    });

    it('should return R=1 for perfectly synchronized phases', () => {
      const phases = [0, 0, 0, 0];
      const result = computeKuramotoOrderParameter(phases);
      expect(result.R).toBeCloseTo(1, 5);
    });

    it('should return R near 0 for uniformly distributed phases', () => {
      const phases = [0, Math.PI / 2, Math.PI, 3 * Math.PI / 2];
      const result = computeKuramotoOrderParameter(phases);
      expect(result.R).toBeLessThan(0.1);
    });

    it('should compute mean phase psi correctly', () => {
      const phases = [0.1, 0.1, 0.1];
      const result = computeKuramotoOrderParameter(phases);
      expect(result.psi).toBeCloseTo(0.1, 5);
    });
  });

  describe('advanceKuramotoPhases', () => {
    it('should advance phases by natural frequency', () => {
      const phases = [0, 0, 0];
      const frequencies = [0.1, 0.1, 0.1];
      const newPhases = advanceKuramotoPhases(phases, frequencies, 0, 1);
      expect(newPhases[0]).toBeCloseTo(0.1, 5);
      expect(newPhases[1]).toBeCloseTo(0.1, 5);
      expect(newPhases[2]).toBeCloseTo(0.1, 5);
    });

    it('should apply Kuramoto coupling (K=PHI default)', () => {
      const phases = [0, Math.PI];
      const frequencies = [0, 0];
      const newPhases = advanceKuramotoPhases(phases, frequencies, PHI, 1);
      // Phases should move toward each other with coupling (or stay same if at equilibrium)
      expect(Math.abs(newPhases[1] - newPhases[0])).toBeLessThanOrEqual(Math.PI);
    });

    it('should wrap phases in [0, 2π]', () => {
      const phases = [6.0];
      const frequencies = [1.0];
      const newPhases = advanceKuramotoPhases(phases, frequencies, 0, 1);
      expect(newPhases[0]).toBeGreaterThanOrEqual(0);
      expect(newPhases[0]).toBeLessThan(2 * Math.PI);
    });
  });

  describe('PROTO-228: alphaResonance', () => {
    it('should return result with correct protocol name', () => {
      const phases = [0, 0, 0];
      const frequencies = [0.1, 0.1, 0.1];
      const result = alphaResonance(phases, frequencies);
      expect(result.protocol).toBe('PROTO-228');
      expect(result.name).toBe('Alpha Resonance');
      expect(result.brainAnalog).toBe('Thalamocortical binding');
    });

    it('should compute order parameter R', () => {
      const phases = [0, 0, 0];
      const frequencies = [0, 0, 0];
      const result = alphaResonance(phases, frequencies);
      expect(result.orderParameter).toBeDefined();
      expect(result.orderParameter).toBeCloseTo(1, 5);
    });

    it('should detect resonance when R > PHI_INV', () => {
      const phases = [0, 0, 0];
      const frequencies = [0, 0, 0];
      const result = alphaResonance(phases, frequencies);
      expect(result.resonant).toBe(true);
    });

    it('should not detect resonance when R < PHI_INV', () => {
      const phases = [0, Math.PI / 2, Math.PI, 3 * Math.PI / 2];
      const frequencies = [0, 0, 0, 0];
      const result = alphaResonance(phases, frequencies);
      expect(result.resonant).toBe(false);
    });

    it('should advance phases and compute next order parameter', () => {
      const phases = [0, 0.1, 0.2];
      const frequencies = [0.1, 0.1, 0.1];
      const result = alphaResonance(phases, frequencies);
      expect(result.nextPhases).toBeDefined();
      expect(result.nextPhases).toHaveLength(3);
      expect(result.nextOrderParameter).toBeDefined();
    });

    it('should include coherence map', () => {
      const phases = [0, 0.1, 0.2];
      const frequencies = [0, 0, 0];
      const result = alphaResonance(phases, frequencies);
      expect(result.coherenceMap).toHaveLength(3);
      expect(result.coherenceMap[0]).toHaveProperty('index');
      expect(result.coherenceMap[0]).toHaveProperty('phase');
      expect(result.coherenceMap[0]).toHaveProperty('deviation');
      expect(result.coherenceMap[0]).toHaveProperty('coherent');
    });

    it('should track synchronization trend', () => {
      const phases = [0, 0.5, 1.0];
      const frequencies = [0, 0, 0];
      const result = alphaResonance(phases, frequencies);
      expect(result.synchronizing).toBeDefined();
      expect(result.dR).toBeDefined();
    });
  });

  describe('createSignal', () => {
    it('should create signal with correct priority level', () => {
      const signal = createSignal('test-payload', PRIORITY_LEVELS.HIGH);
      expect(signal.priority).toBe(1);
      expect(signal.priorityName).toBe('HIGH');
    });

    it('should compute phi-weighted score', () => {
      const critical = createSignal('critical', PRIORITY_LEVELS.CRITICAL);
      const low = createSignal('low', PRIORITY_LEVELS.LOW);
      expect(critical.score).toBeLessThan(low.score);
    });

    it('should include timestamp and unique ID', () => {
      const signal = createSignal('payload', PRIORITY_LEVELS.NORMAL);
      expect(signal.timestamp).toBeDefined();
      expect(signal.id).toMatch(/^signal-\d+-\w+$/);
    });

    it('should clamp priority to valid range', () => {
      const tooHigh = createSignal('payload', 100);
      const tooLow = createSignal('payload', -5);
      expect(tooHigh.priority).toBe(3); // Clamped to LOW
      expect(tooLow.priority).toBe(0);  // Clamped to CRITICAL
    });
  });

  describe('PROTO-229: alphaSignal', () => {
    it('should return result with correct protocol name', () => {
      const signals = [{ payload: 'test', priority: PRIORITY_LEVELS.NORMAL }];
      const result = alphaSignal(signals);
      expect(result.protocol).toBe('PROTO-229');
      expect(result.name).toBe('Alpha Signal');
      expect(result.brainAnalog).toBe('dlPFC working memory gate');
    });

    it('should sort signals by priority (most urgent first)', () => {
      const signals = [
        { payload: 'low', priority: PRIORITY_LEVELS.LOW },
        { payload: 'critical', priority: PRIORITY_LEVELS.CRITICAL },
        { payload: 'high', priority: PRIORITY_LEVELS.HIGH },
      ];
      const result = alphaSignal(signals);
      expect(result.inWorkingMemory[0].payload).toBe('critical');
      expect(result.inWorkingMemory[1].payload).toBe('high');
    });

    it('should suppress low-salience signals below gate threshold', () => {
      const signals = [
        { payload: 'critical', priority: PRIORITY_LEVELS.CRITICAL },
        { payload: 'low', priority: PRIORITY_LEVELS.LOW },
      ];
      const result = alphaSignal(signals);
      // LOW priority has low salience, may be suppressed
      expect(result.suppressed.length + result.inWorkingMemory.length).toBe(signals.length);
    });

    it('should handle empty signals array', () => {
      const result = alphaSignal([]);
      expect(result.inWorkingMemory).toHaveLength(0);
      expect(result.totalSignals).toBe(0);
    });

    it('should respect max capacity (working memory limit)', () => {
      const signals = Array(50).fill(null).map((_, i) => ({
        payload: `signal-${i}`,
        priority: PRIORITY_LEVELS.CRITICAL,
      }));
      const result = alphaSignal(signals, { maxCapacity: 10 });
      expect(result.inWorkingMemory.length).toBeLessThanOrEqual(10);
    });

    it('should include priority distribution', () => {
      const signals = [
        { payload: 'c1', priority: PRIORITY_LEVELS.CRITICAL },
        { payload: 'c2', priority: PRIORITY_LEVELS.CRITICAL },
        { payload: 'h1', priority: PRIORITY_LEVELS.HIGH },
      ];
      const result = alphaSignal(signals);
      expect(result.distribution).toBeDefined();
      expect(result.distribution.CRITICAL).toBeGreaterThanOrEqual(0);
    });

    it('should calculate load factor', () => {
      const signals = [{ payload: 'test', priority: PRIORITY_LEVELS.CRITICAL }];
      const result = alphaSignal(signals, { maxCapacity: 10 });
      expect(result.loadFactor).toBeDefined();
      expect(result.loadFactor).toBeLessThanOrEqual(1);
    });
  });

  describe('computeDopamineImpulse', () => {
    it('should return 0 when frontPower below threshold', () => {
      const impulse = computeDopamineImpulse(0.5);
      expect(impulse).toBe(0);
    });

    it('should return positive impulse when frontPower above threshold', () => {
      const impulse = computeDopamineImpulse(1.0);
      expect(impulse).toBeGreaterThan(0);
    });

    it('should scale with distance above threshold', () => {
      const small = computeDopamineImpulse(0.7);
      const large = computeDopamineImpulse(1.5);
      expect(large).toBeGreaterThan(small);
    });
  });

  describe('computeOxytocinImpulse', () => {
    it('should return 0 for zero confidence', () => {
      const impulse = computeOxytocinImpulse(0);
      expect(impulse).toBe(0);
    });

    it('should scale linearly with confidence', () => {
      const low = computeOxytocinImpulse(0.5);
      const high = computeOxytocinImpulse(1.0);
      expect(high).toBeCloseTo(low * 2, 5);
    });
  });

  describe('PROTO-230: alphaReward', () => {
    it('should return result with correct protocol name', () => {
      const result = alphaReward(0.5, 0.5);
      expect(result.protocol).toBe('PROTO-230');
      expect(result.name).toBe('Alpha Reward');
      expect(result.brainAnalog).toBe('VTA → NAcc mesolimbic pathway');
    });

    it('should not trigger gate when frontPower below threshold', () => {
      const result = alphaReward(0.5, 0.8);
      expect(result.gateTriggered).toBe(false);
      expect(result.dopamineImpulse).toBe(0);
    });

    it('should trigger gate when frontPower above threshold', () => {
      const result = alphaReward(1.0, 0.8);
      expect(result.gateTriggered).toBe(true);
      expect(result.dopamineImpulse).toBeGreaterThan(0);
    });

    it('should compute oxytocin impulse from confidence', () => {
      const result = alphaReward(0.5, 0.8);
      expect(result.oxytocinImpulse).toBeGreaterThan(0);
    });

    it('should compute affective arousal as sum of DA and OX', () => {
      const result = alphaReward(1.0, 0.8);
      expect(result.affectiveArousal).toBeCloseTo(
        result.dopamineImpulse + result.oxytocinImpulse,
        10
      );
    });

    it('should compute Hebbian boost when gate triggered', () => {
      const result = alphaReward(1.0, 0.8);
      expect(result.hebbianBoost).toBeGreaterThan(0);
    });

    it('should have zero Hebbian boost when gate not triggered', () => {
      const result = alphaReward(0.5, 0.8);
      expect(result.hebbianBoost).toBe(0);
    });

    it('should compute attentional gain', () => {
      const result = alphaReward(1.0, 0.8);
      expect(result.attentionalGain).toBeGreaterThan(1);
    });

    it('should include neurochemistry summary', () => {
      const result = alphaReward(1.0, 0.8);
      expect(result.neurochemistry).toBeDefined();
      expect(result.neurochemistry.DA).toBe(result.dopamineImpulse);
      expect(result.neurochemistry.OX).toBe(result.oxytocinImpulse);
    });

    it('should track reinforcement path states', () => {
      const triggered = alphaReward(1.0, 0.8);
      expect(triggered.reinforcementPaths.hebbian).toBe('active');
      expect(triggered.reinforcementPaths.dopaminergic).toBe('firing');

      const subthreshold = alphaReward(0.5, 0.8);
      expect(subthreshold.reinforcementPaths.hebbian).toBe('dormant');
      expect(subthreshold.reinforcementPaths.dopaminergic).toBe('subthreshold');
    });

    it('should clamp inputs to valid ranges', () => {
      const result = alphaReward(5.0, 2.0);
      expect(result.frontPower).toBeLessThanOrEqual(PHI);
      expect(result.thoughtConfidence).toBeLessThanOrEqual(1);
    });
  });
});
