/**
 * Geometry Lock SDK Test Suite
 * Tests for sdk/geometry-lock/geometry-lock-sdk.js
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 */

import { describe, it, expect, beforeEach, afterEach } from 'vitest';
import GeometryLockSDK from '../sdk/geometry-lock/geometry-lock-sdk.js';

describe('Geometry Lock SDK', () => {
  const TEST_CALLER_ID = 'sdk-test-caller-' + Date.now();
  const TEST_SECRET = 'sdk-test-secret-12345';

  // Clean up after each test
  afterEach(() => {
    GeometryLockSDK.revokeKey(TEST_CALLER_ID);
  });

  describe('Constructor', () => {
    it('should require callerId', () => {
      expect(() => new GeometryLockSDK({ sharedSecret: TEST_SECRET })).toThrow('callerId is required');
    });

    it('should require sharedSecret', () => {
      expect(() => new GeometryLockSDK({ callerId: TEST_CALLER_ID })).toThrow('sharedSecret is required');
    });

    it('should create instance with valid parameters', () => {
      GeometryLockSDK.registerCaller(TEST_CALLER_ID, TEST_SECRET);
      const sdk = new GeometryLockSDK({ callerId: TEST_CALLER_ID, sharedSecret: TEST_SECRET });
      expect(sdk).toBeDefined();
      expect(sdk.callerId).toBe(TEST_CALLER_ID);
    });
  });

  describe('Static: registerCaller', () => {
    it('should register a caller via static method', () => {
      const result = GeometryLockSDK.registerCaller(TEST_CALLER_ID, TEST_SECRET);
      expect(result.ok).toBe(true);
      expect(result.callerId).toBe(TEST_CALLER_ID);
    });

    it('should accept optional tier', () => {
      const result = GeometryLockSDK.registerCaller(TEST_CALLER_ID, TEST_SECRET, { tier: 'sovereign' });
      expect(result.ok).toBe(true);
    });

    it('should reject duplicate registration', () => {
      GeometryLockSDK.registerCaller(TEST_CALLER_ID, TEST_SECRET);
      const result = GeometryLockSDK.registerCaller(TEST_CALLER_ID, TEST_SECRET);
      expect(result.error).toBeDefined();
    });
  });

  describe('Static: revokeKey', () => {
    it('should revoke a registered caller', () => {
      GeometryLockSDK.registerCaller(TEST_CALLER_ID, TEST_SECRET);
      const result = GeometryLockSDK.revokeKey(TEST_CALLER_ID);
      expect(result.ok).toBe(true);
    });

    it('should return error for non-existent caller', () => {
      const result = GeometryLockSDK.revokeKey('non-existent-caller');
      expect(result.error).toBeDefined();
    });
  });

  describe('Instance: generateKey', () => {
    let sdk;

    beforeEach(() => {
      GeometryLockSDK.registerCaller(TEST_CALLER_ID, TEST_SECRET);
      sdk = new GeometryLockSDK({ callerId: TEST_CALLER_ID, sharedSecret: TEST_SECRET });
    });

    it('should generate a geometric key token', async () => {
      const result = await sdk.generateKey();
      expect(result.token).toBeDefined();
      expect(result.token.callerId).toBe(TEST_CALLER_ID);
    });

    it('should include phase vector in token', async () => {
      const result = await sdk.generateKey();
      expect(result.token.phases).toBeDefined();
      expect(Array.isArray(result.token.phases)).toBe(true);
    });

    it('should include signature in token', async () => {
      const result = await sdk.generateKey();
      expect(result.token.signature).toBeDefined();
    });
  });

  describe('Instance: validateKey', () => {
    let sdk;

    beforeEach(() => {
      GeometryLockSDK.registerCaller(TEST_CALLER_ID, TEST_SECRET);
      sdk = new GeometryLockSDK({ callerId: TEST_CALLER_ID, sharedSecret: TEST_SECRET });
    });

    it('should validate a freshly generated token', async () => {
      const { token } = await sdk.generateKey();
      const result = await sdk.validateKey(token);
      expect(result.granted).toBe(true);
    });

    it('should return Kuramoto R parameter', async () => {
      const { token } = await sdk.generateKey();
      const result = await sdk.validateKey(token);
      expect(result.r).toBeDefined();
      expect(result.r).toBeGreaterThan(0.5);
    });

    it('should reject invalid tokens', async () => {
      const result = await sdk.validateKey({ invalid: true });
      expect(result.granted).toBe(false);
    });
  });

  describe('Instance: getStatus', () => {
    let sdk;

    beforeEach(() => {
      GeometryLockSDK.registerCaller(TEST_CALLER_ID, TEST_SECRET);
      sdk = new GeometryLockSDK({ callerId: TEST_CALLER_ID, sharedSecret: TEST_SECRET });
    });

    it('should return caller status', () => {
      const status = sdk.getStatus();
      expect(status).toBeDefined();
    });
  });

  describe('Static: validateKey', () => {
    it('should validate tokens via static method', async () => {
      GeometryLockSDK.registerCaller(TEST_CALLER_ID, TEST_SECRET);
      const sdk = new GeometryLockSDK({ callerId: TEST_CALLER_ID, sharedSecret: TEST_SECRET });
      const { token } = await sdk.generateKey();
      
      const result = await GeometryLockSDK.validateKey(token);
      expect(result.granted).toBe(true);
    });
  });

  describe('Static: getMetrics', () => {
    it('should return platform metrics', () => {
      const metrics = GeometryLockSDK.getMetrics();
      expect(metrics).toBeDefined();
      expect(metrics).toHaveProperty('totalValidations');
    });
  });

  describe('Static: getAuditLog', () => {
    it('should return audit log entries', () => {
      GeometryLockSDK.registerCaller(TEST_CALLER_ID, TEST_SECRET);
      const log = GeometryLockSDK.getAuditLog(10);
      expect(Array.isArray(log)).toBe(true);
    });

    it('should include registration events', () => {
      GeometryLockSDK.registerCaller(TEST_CALLER_ID, TEST_SECRET);
      const log = GeometryLockSDK.getAuditLog(50);
      const events = log.map(e => e.event);
      expect(events).toContain('caller-registered');
    });
  });

  describe('Static: protocol', () => {
    it('should expose underlying protocol', () => {
      expect(GeometryLockSDK.protocol).toBeDefined();
      expect(GeometryLockSDK.protocol.generateKey).toBeDefined();
      expect(GeometryLockSDK.protocol.validateKey).toBeDefined();
    });
  });

  describe('Integration: Full key lifecycle', () => {
    it('should support complete key lifecycle', async () => {
      // 1. Register caller
      const registerResult = GeometryLockSDK.registerCaller(TEST_CALLER_ID, TEST_SECRET, { tier: 'sovereign' });
      expect(registerResult.ok).toBe(true);

      // 2. Create SDK instance
      const sdk = new GeometryLockSDK({ callerId: TEST_CALLER_ID, sharedSecret: TEST_SECRET });

      // 3. Generate key
      const { token } = await sdk.generateKey();
      expect(token).toBeDefined();

      // 4. Validate key
      const validation = await sdk.validateKey(token);
      expect(validation.granted).toBe(true);
      expect(validation.r).toBeGreaterThan(0.6);

      // 5. Check status
      const status = sdk.getStatus();
      expect(status).toBeDefined();

      // 6. Revoke key
      const revokeResult = GeometryLockSDK.revokeKey(TEST_CALLER_ID);
      expect(revokeResult.ok).toBe(true);

      // 7. Validate again (should fail)
      const revokedValidation = await sdk.validateKey(token);
      expect(revokedValidation.granted).toBe(false);
      expect(revokedValidation.reason).toBe('caller-revoked');
    });
  });
});
