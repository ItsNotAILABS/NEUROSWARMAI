/**
 * Governance Protocols Macro Test Suite
 * Tests for governance/governance-protocols-macro.js
 * Covers: Temporal, User, Policy, Ethics, Charter, and Macro governance
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 */

import { describe, it, expect } from 'vitest';
import {
  PHI,
  PHI_INV,
  HEARTBEAT,
  GOVERNANCE_VERSION,
  TEMPORAL_EPOCHS,
  TEMPORAL_POLICIES,
  USER_ROLES,
  USER_POLICIES,
  POLICY_DOMAINS,
  POLICY_LIFECYCLE,
  ETHICS_PRINCIPLES,
  ETHICS_CONSTRAINTS,
  CHARTER,
  computeTemporalHealth,
  evaluateUserGovernance,
  evaluatePolicyCompliance,
  validatePolicyTransition,
  evaluateEthics,
  evaluateCharter,
  runGovernanceMacro,
} from '../governance/governance-protocols-macro.js';

describe('Governance Protocols Macro', () => {
  // ─── Constants ─────────────────────────────────────────────────────────────
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

    it('should define GOVERNANCE_VERSION', () => {
      expect(GOVERNANCE_VERSION).toBe('1.0.0');
    });
  });

  // ─── Temporal Governance ───────────────────────────────────────────────────
  describe('Temporal Governance', () => {
    it('should define all temporal epochs', () => {
      expect(Object.keys(TEMPORAL_EPOCHS)).toHaveLength(5);
      expect(TEMPORAL_EPOCHS.GENESIS).toBeDefined();
      expect(TEMPORAL_EPOCHS.GROWTH).toBeDefined();
      expect(TEMPORAL_EPOCHS.MATURITY).toBeDefined();
      expect(TEMPORAL_EPOCHS.EVOLUTION).toBeDefined();
      expect(TEMPORAL_EPOCHS.LEGACY).toBeDefined();
    });

    it('should define temporal policies', () => {
      expect(TEMPORAL_POLICIES.HEARTBEAT_SYNC.interval).toBe(HEARTBEAT);
      expect(TEMPORAL_POLICIES.EPOCH_TRANSITION.requiresQuorum).toBe(0.8);
      expect(TEMPORAL_POLICIES.DECAY_RATE.phi_decay).toBe(PHI_INV);
      expect(TEMPORAL_POLICIES.EVOLUTION_WINDOW.maxProtocolsPerCycle).toBe(5);
    });

    it('should return zero health for null state', () => {
      const result = computeTemporalHealth(null);
      expect(result.health).toBe(0);
      expect(result.epoch).toBe('UNKNOWN');
    });

    it('should return healthy state for valid epoch', () => {
      const result = computeTemporalHealth({ epoch: 'GROWTH', protocolsEvolvedThisCycle: 2 });
      expect(result.health).toBe(1.0);
      expect(result.epoch).toBe('GROWTH');
      expect(result.violations).toHaveLength(0);
    });

    it('should detect invalid epoch', () => {
      const result = computeTemporalHealth({ epoch: 'INVALID_EPOCH' });
      expect(result.violations.length).toBeGreaterThan(0);
      expect(result.violations[0].type).toBe('INVALID_EPOCH');
      expect(result.health).toBeLessThan(1.0);
    });

    it('should detect evolution overflow', () => {
      const result = computeTemporalHealth({ epoch: 'GROWTH', protocolsEvolvedThisCycle: 8 });
      const overflow = result.violations.find(v => v.type === 'EVOLUTION_OVERFLOW');
      expect(overflow).toBeDefined();
      expect(overflow.count).toBe(8);
    });

    it('should include timestamp in result', () => {
      const before = Date.now();
      const result = computeTemporalHealth({ epoch: 'GENESIS' });
      expect(result.timestamp).toBeGreaterThanOrEqual(before);
    });
  });

  // ─── User Governance ───────────────────────────────────────────────────────
  describe('User Governance', () => {
    it('should define all user roles', () => {
      expect(USER_ROLES.SOVEREIGN.level).toBe(0);
      expect(USER_ROLES.ARCHITECT.level).toBe(1);
      expect(USER_ROLES.OPERATOR.level).toBe(2);
      expect(USER_ROLES.OBSERVER.level).toBe(3);
      expect(USER_ROLES.ORGANISM.level).toBe(-1);
    });

    it('should deny access for null user', () => {
      const result = evaluateUserGovernance(null, 'deploy');
      expect(result.allowed).toBe(false);
      expect(result.reason).toBe('MISSING_CONTEXT');
    });

    it('should deny access for null action', () => {
      const result = evaluateUserGovernance({ role: 'OPERATOR' }, null);
      expect(result.allowed).toBe(false);
      expect(result.reason).toBe('MISSING_CONTEXT');
    });

    it('should deny access for invalid role', () => {
      const result = evaluateUserGovernance({ role: 'HACKER' }, 'deploy');
      expect(result.allowed).toBe(false);
      expect(result.reason).toBe('INVALID_ROLE');
    });

    it('should grant sovereign full access', () => {
      const result = evaluateUserGovernance({ role: 'SOVEREIGN' }, 'deploy');
      expect(result.allowed).toBe(true);
      expect(result.reason).toBe('SOVEREIGN_AUTHORITY');
    });

    it('should grant architect deploy permission', () => {
      const result = evaluateUserGovernance({ role: 'ARCHITECT' }, 'deploy');
      expect(result.allowed).toBe(true);
    });

    it('should deny operator deploy permission', () => {
      const result = evaluateUserGovernance({ role: 'OPERATOR' }, 'deploy');
      expect(result.allowed).toBe(false);
      expect(result.reason).toBe('INSUFFICIENT_PERMISSIONS');
    });

    it('should grant operator monitor permission', () => {
      const result = evaluateUserGovernance({ role: 'OPERATOR' }, 'monitor');
      expect(result.allowed).toBe(true);
    });

    it('should grant observer read permission', () => {
      const result = evaluateUserGovernance({ role: 'OBSERVER' }, 'read');
      expect(result.allowed).toBe(true);
    });

    it('should deny observer deploy permission', () => {
      const result = evaluateUserGovernance({ role: 'OBSERVER' }, 'deploy');
      expect(result.allowed).toBe(false);
    });

    it('should grant organism execute permission', () => {
      const result = evaluateUserGovernance({ role: 'ORGANISM' }, 'execute');
      expect(result.allowed).toBe(true);
    });

    it('should deny unknown actions', () => {
      const result = evaluateUserGovernance({ role: 'ARCHITECT' }, 'hack');
      expect(result.allowed).toBe(false);
      expect(result.reason).toBe('UNKNOWN_ACTION');
    });
  });

  // ─── Policy Governance ─────────────────────────────────────────────────────
  describe('Policy Governance', () => {
    it('should define policy domains', () => {
      expect(POLICY_DOMAINS.SECURITY.weight).toBe(1.0);
      expect(POLICY_DOMAINS.SOVEREIGNTY.weight).toBe(1.0);
      expect(POLICY_DOMAINS.QUALITY.weight).toBe(0.9);
    });

    it('should return non-compliant for null input', () => {
      const result = evaluatePolicyCompliance(null, null);
      expect(result.compliant).toBe(false);
      expect(result.score).toBe(0);
    });

    it('should return compliant for empty policies', () => {
      const result = evaluatePolicyCompliance({}, []);
      expect(result.compliant).toBe(true);
      expect(result.score).toBe(0); // 0/0 = 0
    });

    it('should evaluate passing policy', () => {
      const policies = [{ name: 'TEST', weight: 1.0, condition: () => true }];
      const result = evaluatePolicyCompliance({}, policies);
      expect(result.compliant).toBe(true);
      expect(result.score).toBe(1.0);
    });

    it('should detect policy violation', () => {
      const policies = [{ name: 'TEST', weight: 1.0, condition: () => false, description: 'Must pass' }];
      const result = evaluatePolicyCompliance({}, policies);
      expect(result.compliant).toBe(false);
      expect(result.violations).toHaveLength(1);
      expect(result.violations[0].policy).toBe('TEST');
    });

    it('should compute weighted score correctly', () => {
      const policies = [
        { name: 'A', weight: 2.0, condition: () => true },
        { name: 'B', weight: 1.0, condition: () => false },
      ];
      const result = evaluatePolicyCompliance({}, policies);
      expect(result.score).toBeCloseTo(2.0 / 3.0, 5);
    });

    it('should handle policy evaluation errors', () => {
      const policies = [{ name: 'CRASH', weight: 1.0, condition: () => { throw new Error('boom'); } }];
      const result = evaluatePolicyCompliance({}, policies);
      expect(result.compliant).toBe(false);
      expect(result.violations[0].severity).toBe('HIGH');
    });

    it('should validate policy lifecycle transitions', () => {
      expect(validatePolicyTransition('PROPOSED', 'REVIEW').valid).toBe(true);
      expect(validatePolicyTransition('REVIEW', 'ACTIVE').valid).toBe(true);
      expect(validatePolicyTransition('ACTIVE', 'DEPRECATED').valid).toBe(true);
      expect(validatePolicyTransition('DEPRECATED', 'RETIRED').valid).toBe(true);
    });

    it('should reject invalid lifecycle transitions', () => {
      expect(validatePolicyTransition('PROPOSED', 'ACTIVE').valid).toBe(false);
      expect(validatePolicyTransition('RETIRED', 'ACTIVE').valid).toBe(false);
      expect(validatePolicyTransition('ACTIVE', 'PROPOSED').valid).toBe(false);
    });

    it('should handle null state in transitions', () => {
      expect(validatePolicyTransition(null, 'ACTIVE').valid).toBe(false);
      expect(validatePolicyTransition('ACTIVE', null).valid).toBe(false);
    });

    it('should handle invalid current state', () => {
      const result = validatePolicyTransition('NONEXISTENT', 'ACTIVE');
      expect(result.valid).toBe(false);
      expect(result.reason).toBe('INVALID_CURRENT_STATE');
    });
  });

  // ─── Ethics Governance ─────────────────────────────────────────────────────
  describe('Ethics Governance', () => {
    it('should define all ethics principles', () => {
      expect(Object.keys(ETHICS_PRINCIPLES).length).toBeGreaterThanOrEqual(7);
      expect(ETHICS_PRINCIPLES.SOVEREIGNTY.enforcement).toBe('ABSOLUTE');
      expect(ETHICS_PRINCIPLES.NON_MALEFICENCE.enforcement).toBe('ABSOLUTE');
    });

    it('should return non-ethical for null context', () => {
      const result = evaluateEthics(null);
      expect(result.ethical).toBe(false);
      expect(result.score).toBe(0);
    });

    it('should pass fully ethical context', () => {
      const result = evaluateEthics({
        externalDependencies: [],
        auditTrail: true,
        userConsent: true,
        harmScore: 0.0,
        fairnessScore: 0.9,
      });
      expect(result.ethical).toBe(true);
      expect(result.score).toBe(1.0);
    });

    it('should detect external dependency violation', () => {
      const result = evaluateEthics({ externalDependencies: ['lodash'] });
      expect(result.ethical).toBe(false);
      const violation = result.violations.find(v => v.constraint === 'NO_EXTERNAL_DEPENDENCIES');
      expect(violation).toBeDefined();
      expect(violation.severity).toBe('CRITICAL');
    });

    it('should detect missing audit trail', () => {
      const result = evaluateEthics({ auditTrail: false });
      const violation = result.violations.find(v => v.constraint === 'AUDIT_TRAIL_REQUIRED');
      expect(violation).toBeDefined();
    });

    it('should detect missing user consent', () => {
      const result = evaluateEthics({ userConsent: false });
      const violation = result.violations.find(v => v.constraint === 'USER_CONSENT_VERIFIED');
      expect(violation).toBeDefined();
      expect(violation.severity).toBe('CRITICAL');
    });

    it('should detect harm score violation', () => {
      const result = evaluateEthics({ harmScore: 0.5 });
      const violation = result.violations.find(v => v.constraint === 'HARM_ASSESSMENT_PASSED');
      expect(violation).toBeDefined();
    });

    it('should detect fairness violation', () => {
      const result = evaluateEthics({ fairnessScore: 0.3 });
      const violation = result.violations.find(v => v.constraint === 'FAIRNESS_THRESHOLD');
      expect(violation).toBeDefined();
    });

    it('should include timestamp', () => {
      const result = evaluateEthics({});
      expect(result.timestamp).toBeDefined();
    });
  });

  // ─── Charter Governance ────────────────────────────────────────────────────
  describe('Charter Governance', () => {
    it('should define charter with 7 articles', () => {
      expect(Object.keys(CHARTER.articles)).toHaveLength(7);
    });

    it('should have sovereign defined', () => {
      expect(CHARTER.sovereign).toBe('Alfredo Medina Hernandez');
    });

    it('should return non-compliant for null context', () => {
      const result = evaluateCharter(null);
      expect(result.compliant).toBe(false);
    });

    it('should pass clean context', () => {
      const result = evaluateCharter({});
      expect(result.compliant).toBe(true);
      expect(result.score).toBe(1.0);
    });

    it('should detect sovereignty violation', () => {
      const result = evaluateCharter({ externalDependencies: ['react'] });
      expect(result.compliant).toBe(false);
      const violation = result.violations.find(v => v.article === 'ARTICLE_I');
      expect(violation).toBeDefined();
      expect(violation.action).toBe('BLOCK_AND_REVERT');
    });

    it('should detect temporal integrity violation', () => {
      const result = evaluateCharter({ epochTransition: true, quorum: 0.5 });
      const violation = result.violations.find(v => v.article === 'ARTICLE_II');
      expect(violation).toBeDefined();
    });

    it('should detect user rights violation', () => {
      const result = evaluateCharter({ userAction: true, userConsent: false });
      const violation = result.violations.find(v => v.article === 'ARTICLE_III');
      expect(violation).toBeDefined();
    });

    it('should detect ethical operation violation', () => {
      const result = evaluateCharter({ harmScore: 0.5 });
      const violation = result.violations.find(v => v.article === 'ARTICLE_V');
      expect(violation).toBeDefined();
      expect(violation.action).toBe('EMERGENCY_HALT');
    });

    it('should detect audit trail violation', () => {
      const result = evaluateCharter({ auditTrail: false });
      const violation = result.violations.find(v => v.article === 'ARTICLE_VII');
      expect(violation).toBeDefined();
    });

    it('should compute score based on violations', () => {
      const result = evaluateCharter({ externalDependencies: ['x'], auditTrail: false });
      expect(result.score).toBeLessThan(1.0);
      expect(result.violations).toHaveLength(2);
    });
  });

  // ─── Macro Governance Engine ───────────────────────────────────────────────
  describe('Macro Governance Engine', () => {
    it('should return failing result for null context', () => {
      const result = runGovernanceMacro(null);
      expect(result.pass).toBe(false);
      expect(result.overallScore).toBe(0);
    });

    it('should pass fully compliant context', () => {
      const result = runGovernanceMacro({
        temporal: { epoch: 'GROWTH', protocolsEvolvedThisCycle: 1 },
        user: { role: 'SOVEREIGN' },
        action: 'deploy',
        policy: {},
        policies: [],
        ethics: { externalDependencies: [], auditTrail: true, userConsent: true, harmScore: 0, fairnessScore: 0.9 },
        charter: {},
      });
      expect(result.pass).toBe(true);
      expect(result.overallScore).toBeGreaterThan(PHI_INV);
    });

    it('should fail on critical ethics violation', () => {
      const result = runGovernanceMacro({
        temporal: { epoch: 'GROWTH' },
        ethics: { externalDependencies: ['stolen-lib'], userConsent: false },
        charter: {},
      });
      expect(result.pass).toBe(false);
      expect(result.hasCritical).toBe(true);
    });

    it('should fail on critical charter violation', () => {
      const result = runGovernanceMacro({
        temporal: { epoch: 'GROWTH' },
        ethics: {},
        charter: { externalDependencies: ['external'], auditTrail: false },
      });
      expect(result.pass).toBe(false);
    });

    it('should include all governance dimensions', () => {
      const result = runGovernanceMacro({ temporal: {}, ethics: {}, charter: {} });
      expect(result.temporal).toBeDefined();
      expect(result.user).toBeDefined();
      expect(result.policy).toBeDefined();
      expect(result.ethics).toBeDefined();
      expect(result.charter).toBeDefined();
    });

    it('should include timestamp', () => {
      const result = runGovernanceMacro({});
      expect(result.timestamp).toBeDefined();
    });
  });
});
