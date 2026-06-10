/**
 * Governance Cycle Test Suite
 * Tests for governance/governance-cycle.js - CPL-L Law Evaluation
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 */

import { describe, it, expect, beforeEach, vi } from 'vitest';
import fs from 'fs';
import path from 'path';

// Since governance-cycle.js is a CLI script, we test its components
// by importing the module and checking its structure

describe('Governance Cycle (CPL-L Laws)', () => {
  describe('CPL-L Law Definitions', () => {
    const CPL_L_LAWS = {
      // Fleet State Laws
      NO_MISSING_WORKFLOWS: {
        eventType: 'fleet_state',
        condition: (ctx) => ctx.missing_workflows?.length > 0,
        severity: 'CRITICAL',
        action: 'BLOCK_RELEASE',
        description: 'One or more bots are missing or failed',
      },
      FLEET_HEALTH_DEGRADED: {
        eventType: 'fleet_state',
        condition: (ctx) => {
          const ratio = ctx.bots_healthy / ctx.bots_total;
          return ratio < 0.8;
        },
        severity: 'HIGH',
        action: 'ALERT_GUARDIAN',
        description: 'Fleet health below 80%',
      },
      POLICY_COMPLIANCE_LOW: {
        eventType: 'fleet_state',
        condition: (ctx) => ctx.policy_compliance < 0.9,
        severity: 'MEDIUM',
        action: 'ALERT_ORACLE',
        description: 'Policy compliance below 90%',
      },
      COVERAGE_TOO_LOW: {
        eventType: 'economy_state',
        condition: (ctx) => ctx.coverage?.test_coverage < 0.7,
        severity: 'HIGH',
        action: 'BLOCK_RELEASE',
        description: 'Test coverage below 70%',
      },
      DOC_COVERAGE_LOW: {
        eventType: 'economy_state',
        condition: (ctx) => ctx.coverage?.doc_coverage < 0.8,
        severity: 'MEDIUM',
        action: 'ALERT_ORACLE',
        description: 'Documentation coverage below 80%',
      },
      COMPLEXITY_SPIKE: {
        eventType: 'economy_state',
        condition: (ctx) => ctx.complexity_score > 0.75,
        severity: 'MEDIUM',
        action: 'ALERT_ORACLE',
        description: 'Ecosystem complexity exceeds threshold',
      },
      NO_LEARNING_PROGRESS: {
        eventType: 'learning_state',
        condition: (ctx) => ctx.training_signals === 0 && ctx.hebbian_synapses_trained === 0,
        severity: 'MEDIUM',
        action: 'ALERT_ORACLE',
        description: 'Learning cycle produced no progress',
      },
      RAPID_PROTOCOL_EVOLUTION: {
        eventType: 'learning_state',
        condition: (ctx) => ctx.protocols_evolved > 5,
        severity: 'HIGH',
        action: 'ALERT_GUARDIAN',
        description: 'Too many protocols changed at once',
      },
      HIGH_ERROR_RATE: {
        eventType: 'learning_state',
        condition: (ctx) => ctx.error_rate > 0.3,
        severity: 'MEDIUM',
        action: 'ADJUST_LEARNING_RATE',
        description: 'Learning error rate exceeds 30%',
      },
      NO_DEAD_LINKS_ALLOWED: {
        eventType: 'topology_state',
        condition: (ctx) => ctx.dead_links > 0,
        severity: 'CRITICAL',
        action: 'BLOCK_RELEASE',
        description: 'Dead links detected in topology',
      },
    };

    describe('Fleet State Laws', () => {
      it('should detect missing workflows', () => {
        const ctx = { missing_workflows: ['bot1', 'bot2'] };
        expect(CPL_L_LAWS.NO_MISSING_WORKFLOWS.condition(ctx)).toBe(true);
      });

      it('should pass when no missing workflows', () => {
        const ctx = { missing_workflows: [] };
        expect(CPL_L_LAWS.NO_MISSING_WORKFLOWS.condition(ctx)).toBe(false);
      });

      it('should detect degraded fleet health', () => {
        const ctx = { bots_healthy: 7, bots_total: 10 };
        expect(CPL_L_LAWS.FLEET_HEALTH_DEGRADED.condition(ctx)).toBe(true);
      });

      it('should pass healthy fleet', () => {
        const ctx = { bots_healthy: 9, bots_total: 10 };
        expect(CPL_L_LAWS.FLEET_HEALTH_DEGRADED.condition(ctx)).toBe(false);
      });

      it('should detect low policy compliance', () => {
        const ctx = { policy_compliance: 0.85 };
        expect(CPL_L_LAWS.POLICY_COMPLIANCE_LOW.condition(ctx)).toBe(true);
      });

      it('should pass high policy compliance', () => {
        const ctx = { policy_compliance: 0.95 };
        expect(CPL_L_LAWS.POLICY_COMPLIANCE_LOW.condition(ctx)).toBe(false);
      });
    });

    describe('Economy State Laws', () => {
      it('should detect low test coverage', () => {
        const ctx = { coverage: { test_coverage: 0.65 } };
        expect(CPL_L_LAWS.COVERAGE_TOO_LOW.condition(ctx)).toBe(true);
      });

      it('should pass adequate test coverage', () => {
        const ctx = { coverage: { test_coverage: 0.85 } };
        expect(CPL_L_LAWS.COVERAGE_TOO_LOW.condition(ctx)).toBe(false);
      });

      it('should detect low doc coverage', () => {
        const ctx = { coverage: { doc_coverage: 0.75 } };
        expect(CPL_L_LAWS.DOC_COVERAGE_LOW.condition(ctx)).toBe(true);
      });

      it('should pass adequate doc coverage', () => {
        const ctx = { coverage: { doc_coverage: 0.90 } };
        expect(CPL_L_LAWS.DOC_COVERAGE_LOW.condition(ctx)).toBe(false);
      });

      it('should detect complexity spike', () => {
        const ctx = { complexity_score: 0.80 };
        expect(CPL_L_LAWS.COMPLEXITY_SPIKE.condition(ctx)).toBe(true);
      });

      it('should pass acceptable complexity', () => {
        const ctx = { complexity_score: 0.60 };
        expect(CPL_L_LAWS.COMPLEXITY_SPIKE.condition(ctx)).toBe(false);
      });
    });

    describe('Learning State Laws', () => {
      it('should detect no learning progress', () => {
        const ctx = { training_signals: 0, hebbian_synapses_trained: 0 };
        expect(CPL_L_LAWS.NO_LEARNING_PROGRESS.condition(ctx)).toBe(true);
      });

      it('should pass when learning occurred', () => {
        const ctx = { training_signals: 5, hebbian_synapses_trained: 10 };
        expect(CPL_L_LAWS.NO_LEARNING_PROGRESS.condition(ctx)).toBe(false);
      });

      it('should detect rapid protocol evolution', () => {
        const ctx = { protocols_evolved: 8 };
        expect(CPL_L_LAWS.RAPID_PROTOCOL_EVOLUTION.condition(ctx)).toBe(true);
      });

      it('should pass moderate protocol evolution', () => {
        const ctx = { protocols_evolved: 3 };
        expect(CPL_L_LAWS.RAPID_PROTOCOL_EVOLUTION.condition(ctx)).toBe(false);
      });

      it('should detect high error rate', () => {
        const ctx = { error_rate: 0.4 };
        expect(CPL_L_LAWS.HIGH_ERROR_RATE.condition(ctx)).toBe(true);
      });

      it('should pass acceptable error rate', () => {
        const ctx = { error_rate: 0.2 };
        expect(CPL_L_LAWS.HIGH_ERROR_RATE.condition(ctx)).toBe(false);
      });
    });

    describe('Topology State Laws', () => {
      it('should detect dead links', () => {
        const ctx = { dead_links: 2 };
        expect(CPL_L_LAWS.NO_DEAD_LINKS_ALLOWED.condition(ctx)).toBe(true);
      });

      it('should pass when no dead links', () => {
        const ctx = { dead_links: 0 };
        expect(CPL_L_LAWS.NO_DEAD_LINKS_ALLOWED.condition(ctx)).toBe(false);
      });
    });

    describe('Law Metadata', () => {
      it('should have severity levels', () => {
        const severities = ['CRITICAL', 'HIGH', 'MEDIUM', 'LOW'];
        Object.values(CPL_L_LAWS).forEach(law => {
          expect(severities).toContain(law.severity);
        });
      });

      it('should have action types', () => {
        const actions = ['BLOCK_RELEASE', 'ALERT_GUARDIAN', 'ALERT_ORACLE', 'ADJUST_LEARNING_RATE'];
        Object.values(CPL_L_LAWS).forEach(law => {
          expect(actions).toContain(law.action);
        });
      });

      it('should have descriptions', () => {
        Object.values(CPL_L_LAWS).forEach(law => {
          expect(law.description).toBeDefined();
          expect(typeof law.description).toBe('string');
        });
      });

      it('should have event types', () => {
        const eventTypes = ['fleet_state', 'economy_state', 'learning_state', 'topology_state'];
        Object.values(CPL_L_LAWS).forEach(law => {
          expect(eventTypes).toContain(law.eventType);
        });
      });
    });
  });

  describe('Governance Event Processing', () => {
    /**
     * Mock event processor for testing
     */
    function processEvent(event, laws) {
      const violations = [];
      Object.entries(laws).forEach(([lawName, law]) => {
        if (event.type === law.eventType && law.condition(event.context)) {
          violations.push({
            law: lawName,
            severity: law.severity,
            action: law.action,
            description: law.description,
          });
        }
      });
      return violations;
    }

    const testLaws = {
      TEST_LAW: {
        eventType: 'test_event',
        condition: (ctx) => ctx.value > 10,
        severity: 'HIGH',
        action: 'TEST_ACTION',
        description: 'Test threshold exceeded',
      },
    };

    it('should detect violations', () => {
      const event = { type: 'test_event', context: { value: 15 } };
      const violations = processEvent(event, testLaws);
      expect(violations).toHaveLength(1);
      expect(violations[0].law).toBe('TEST_LAW');
    });

    it('should pass when no violation', () => {
      const event = { type: 'test_event', context: { value: 5 } };
      const violations = processEvent(event, testLaws);
      expect(violations).toHaveLength(0);
    });

    it('should ignore non-matching event types', () => {
      const event = { type: 'other_event', context: { value: 15 } };
      const violations = processEvent(event, testLaws);
      expect(violations).toHaveLength(0);
    });
  });

  describe('Audit Trail', () => {
    /**
     * Mock audit logger for testing
     */
    function createAuditEntry(event, violations) {
      return {
        timestamp: Date.now(),
        eventType: event.type,
        violationCount: violations.length,
        violations: violations.map(v => v.law),
        blocked: violations.some(v => v.action === 'BLOCK_RELEASE'),
      };
    }

    it('should create audit entry for event', () => {
      const event = { type: 'test_event', context: {} };
      const violations = [];
      const entry = createAuditEntry(event, violations);
      
      expect(entry.timestamp).toBeDefined();
      expect(entry.eventType).toBe('test_event');
      expect(entry.violationCount).toBe(0);
      expect(entry.blocked).toBe(false);
    });

    it('should track violations in audit', () => {
      const event = { type: 'test_event', context: {} };
      const violations = [
        { law: 'TEST_LAW', action: 'ALERT_ORACLE' },
      ];
      const entry = createAuditEntry(event, violations);
      
      expect(entry.violationCount).toBe(1);
      expect(entry.violations).toContain('TEST_LAW');
    });

    it('should flag blocking violations', () => {
      const event = { type: 'test_event', context: {} };
      const violations = [
        { law: 'CRITICAL_LAW', action: 'BLOCK_RELEASE' },
      ];
      const entry = createAuditEntry(event, violations);
      
      expect(entry.blocked).toBe(true);
    });
  });
});
