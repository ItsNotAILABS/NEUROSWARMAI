/**
 * Geometric Key Protocol Test Suite
 * Tests for protocols/geometric-key-protocol.js - PROTO-226
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 */

import { describe, it, expect, beforeEach, afterEach } from 'vitest';
import protocol from '../protocols/geometric-key-protocol.js';

describe('Geometric Key Protocol (PROTO-226)', () => {
  const TEST_CALLER_ID = 'test-caller-' + Date.now();
  const TEST_SECRET = 'test-shared-secret-12345';

  // Clean up after each test
  afterEach(() => {
    protocol.revokeKey(TEST_CALLER_ID);
  });

  describe('registerCaller', () => {
    it('should register a new caller successfully', () => {
      const result = protocol.registerCaller(TEST_CALLER_ID, TEST_SECRET);
      expect(result.ok).toBe(true);
      expect(result.callerId).toBe(TEST_CALLER_ID);
      expect(result.registeredAt).toBeDefined();
    });

    it('should reject invalid caller ID', () => {
      const result = protocol.registerCaller(null, TEST_SECRET);
      expect(result.error).toBe('invalid-caller-id');
    });

    it('should reject invalid shared secret', () => {
      const result = protocol.registerCaller(TEST_CALLER_ID, null);
      expect(result.error).toBe('invalid-shared-secret');
    });

    it('should reject duplicate registration', () => {
      protocol.registerCaller(TEST_CALLER_ID, TEST_SECRET);
      const result = protocol.registerCaller(TEST_CALLER_ID, TEST_SECRET);
      expect(result.error).toBe('caller-already-registered');
    });

    it('should accept optional tier', () => {
      const result = protocol.registerCaller(TEST_CALLER_ID, TEST_SECRET, { tier: 'sovereign' });
      expect(result.ok).toBe(true);
    });

    it('should accept optional description', () => {
      const result = protocol.registerCaller(TEST_CALLER_ID, TEST_SECRET, { description: 'Test caller' });
      expect(result.ok).toBe(true);
    });

    it('should accept optional maxAccess limit', () => {
      const result = protocol.registerCaller(TEST_CALLER_ID, TEST_SECRET, { maxAccess: 100 });
      expect(result.ok).toBe(true);
    });
  });

  describe('revokeKey', () => {
    it('should revoke a registered caller', () => {
      protocol.registerCaller(TEST_CALLER_ID, TEST_SECRET);
      const result = protocol.revokeKey(TEST_CALLER_ID);
      expect(result.ok).toBe(true);
      expect(result.callerId).toBe(TEST_CALLER_ID);
      expect(result.revokedAt).toBeDefined();
    });

    it('should return error for non-existent caller', () => {
      const result = protocol.revokeKey('non-existent-caller');
      expect(result.error).toBe('caller-not-found');
    });

    it('should return error for already revoked caller', () => {
      protocol.registerCaller(TEST_CALLER_ID, TEST_SECRET);
      protocol.revokeKey(TEST_CALLER_ID);
      const result = protocol.revokeKey(TEST_CALLER_ID);
      expect(result.error).toBe('already-revoked');
    });
  });

  describe('generateKey', () => {
    beforeEach(() => {
      protocol.registerCaller(TEST_CALLER_ID, TEST_SECRET);
    });

    it('should generate a valid token', async () => {
      const result = await protocol.generateKey(TEST_CALLER_ID, TEST_SECRET);
      expect(result.token).toBeDefined();
      expect(result.token.callerId).toBe(TEST_CALLER_ID);
      expect(result.token.proto).toBe('PROTO-226');
    });

    it('should include phase vector', async () => {
      const result = await protocol.generateKey(TEST_CALLER_ID, TEST_SECRET);
      expect(result.token.phases).toBeDefined();
      expect(Array.isArray(result.token.phases)).toBe(true);
      expect(result.token.phases.length).toBe(8); // KEY_DIMENSIONS
    });

    it('should include time window', async () => {
      const result = await protocol.generateKey(TEST_CALLER_ID, TEST_SECRET);
      expect(result.token.window).toBeDefined();
      expect(typeof result.token.window).toBe('number');
    });

    it('should include HMAC signature', async () => {
      const result = await protocol.generateKey(TEST_CALLER_ID, TEST_SECRET);
      expect(result.token.signature).toBeDefined();
      expect(typeof result.token.signature).toBe('string');
    });

    it('should include issuedAt timestamp', async () => {
      const result = await protocol.generateKey(TEST_CALLER_ID, TEST_SECRET);
      expect(result.token.issuedAt).toBeDefined();
      expect(result.token.issuedAt).toBeLessThanOrEqual(Date.now());
    });

    it('should return error for missing parameters', async () => {
      const result = await protocol.generateKey(null, TEST_SECRET);
      expect(result.error).toBe('missing-parameters');
    });

    it('should generate different tokens for different time windows', async () => {
      const token1 = await protocol.generateKey(TEST_CALLER_ID, TEST_SECRET, 1000);
      const token2 = await protocol.generateKey(TEST_CALLER_ID, TEST_SECRET, 2000);
      expect(token1.token.signature).not.toBe(token2.token.signature);
    });

    it('should generate same token for same time window', async () => {
      const window = 1000;
      const token1 = await protocol.generateKey(TEST_CALLER_ID, TEST_SECRET, window);
      const token2 = await protocol.generateKey(TEST_CALLER_ID, TEST_SECRET, window);
      expect(token1.token.signature).toBe(token2.token.signature);
    });
  });

  describe('validateKey', () => {
    beforeEach(() => {
      protocol.registerCaller(TEST_CALLER_ID, TEST_SECRET);
    });

    it('should validate a freshly generated token', async () => {
      const { token } = await protocol.generateKey(TEST_CALLER_ID, TEST_SECRET);
      const result = await protocol.validateKey(token);
      expect(result.granted).toBe(true);
      expect(result.r).toBeGreaterThan(0.6); // Should be near 1.0 for valid token
    });

    it('should return Kuramoto order parameter R', async () => {
      const { token } = await protocol.generateKey(TEST_CALLER_ID, TEST_SECRET);
      const result = await protocol.validateKey(token);
      expect(result.r).toBeDefined();
      expect(result.r).toBeGreaterThanOrEqual(0);
      expect(result.r).toBeLessThanOrEqual(1);
    });

    it('should return mean phase psi', async () => {
      const { token } = await protocol.generateKey(TEST_CALLER_ID, TEST_SECRET);
      const result = await protocol.validateKey(token);
      expect(result.psi).toBeDefined();
    });

    it('should return threshold', async () => {
      const { token } = await protocol.generateKey(TEST_CALLER_ID, TEST_SECRET);
      const result = await protocol.validateKey(token);
      expect(result.threshold).toBeDefined();
      expect(result.threshold).toBeCloseTo(0.618, 2); // PHI_INV
    });

    it('should reject null token', async () => {
      const result = await protocol.validateKey(null);
      expect(result.granted).toBe(false);
      expect(result.reason).toBe('invalid-token-format');
    });

    it('should reject token from unregistered caller', async () => {
      const fakeToken = {
        callerId: 'unknown-caller',
        window: 1000,
        phases: [0, 0, 0, 0, 0, 0, 0, 0],
        signature: 'fake-sig',
      };
      const result = await protocol.validateKey(fakeToken);
      expect(result.granted).toBe(false);
      expect(result.reason).toBe('caller-not-registered');
    });

    it('should reject token from revoked caller', async () => {
      const { token } = await protocol.generateKey(TEST_CALLER_ID, TEST_SECRET);
      protocol.revokeKey(TEST_CALLER_ID);
      const result = await protocol.validateKey(token);
      expect(result.granted).toBe(false);
      expect(result.reason).toBe('caller-revoked');
    });

    it('should reject token with invalid phase vector length', async () => {
      const { token } = await protocol.generateKey(TEST_CALLER_ID, TEST_SECRET);
      token.phases = [0, 0, 0]; // Wrong length
      const result = await protocol.validateKey(token);
      expect(result.granted).toBe(false);
      expect(result.reason).toBe('invalid-phase-vector');
    });

    it('should reject token with tampered signature', async () => {
      const { token } = await protocol.generateKey(TEST_CALLER_ID, TEST_SECRET);
      token.signature = 'tampered-signature';
      const result = await protocol.validateKey(token);
      expect(result.granted).toBe(false);
      expect(result.reason).toBe('signature-mismatch');
    });
  });

  describe('getStatus', () => {
    it('should return status for registered caller', () => {
      protocol.registerCaller(TEST_CALLER_ID, TEST_SECRET);
      const status = protocol.getStatus(TEST_CALLER_ID);
      expect(status).toBeDefined();
      expect(status.callerId).toBe(TEST_CALLER_ID);
    });

    it('should indicate caller not found for unknown caller', () => {
      const status = protocol.getStatus('unknown-caller');
      expect(status.error || status.found === false).toBeTruthy();
    });
  });

  describe('getMetrics', () => {
    it('should return protocol metrics', () => {
      const metrics = protocol.getMetrics();
      expect(metrics).toBeDefined();
      expect(metrics).toHaveProperty('totalValidations');
      expect(metrics).toHaveProperty('totalGranted');
      expect(metrics).toHaveProperty('totalDenied');
    });

    it('should track validation counts', async () => {
      protocol.registerCaller(TEST_CALLER_ID, TEST_SECRET);
      const before = protocol.getMetrics();
      const { token } = await protocol.generateKey(TEST_CALLER_ID, TEST_SECRET);
      await protocol.validateKey(token);
      const after = protocol.getMetrics();
      expect(after.totalValidations).toBeGreaterThan(before.totalValidations);
    });
  });

  describe('getAuditLog', () => {
    it('should return audit log entries', () => {
      protocol.registerCaller(TEST_CALLER_ID, TEST_SECRET);
      const log = protocol.getAuditLog(10);
      expect(Array.isArray(log)).toBe(true);
    });

    it('should include recent events', async () => {
      protocol.registerCaller(TEST_CALLER_ID, TEST_SECRET);
      const { token } = await protocol.generateKey(TEST_CALLER_ID, TEST_SECRET);
      await protocol.validateKey(token);
      const log = protocol.getAuditLog(50);
      const events = log.map(e => e.event);
      expect(events).toContain('caller-registered');
      expect(events).toContain('key-generated');
    });

    it('should respect count limit', () => {
      const log = protocol.getAuditLog(5);
      expect(log.length).toBeLessThanOrEqual(5);
    });
  });

  describe('setEmergenceThreshold / getEmergenceThreshold', () => {
    it('should get current emergence threshold', () => {
      const threshold = protocol.getEmergenceThreshold();
      expect(threshold).toBeCloseTo(0.618, 2); // PHI_INV default
    });

    it('should set custom emergence threshold', () => {
      const original = protocol.getEmergenceThreshold();
      protocol.setEmergenceThreshold(0.7);
      expect(protocol.getEmergenceThreshold()).toBe(0.7);
      // Restore
      protocol.setEmergenceThreshold(original);
    });

    it('should affect validation decisions', async () => {
      protocol.registerCaller(TEST_CALLER_ID, TEST_SECRET);
      const original = protocol.getEmergenceThreshold();
      
      // Lower threshold = easier to grant
      protocol.setEmergenceThreshold(0.1);
      const { token } = await protocol.generateKey(TEST_CALLER_ID, TEST_SECRET);
      const easyResult = await protocol.validateKey(token);
      expect(easyResult.granted).toBe(true);
      
      // Restore
      protocol.setEmergenceThreshold(original);
    });
  });
});
