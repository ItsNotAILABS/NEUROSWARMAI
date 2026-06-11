/**
 * Chimeria Hardware Bridge Test Suite
 * Tests for protocols/swarm/chimeria-hardware-bridge.js
 * Validates the asynchronous UDP transmission loop, binary packet serialization,
 * spatial exclusion enforcement, and manifold ingestion pipeline.
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

import { describe, it, expect, beforeEach, afterEach } from 'vitest';
import { ChimeriaHardwareBridge, SwarmUDPFleet } from '../protocols/swarm/chimeria-hardware-bridge.js';

const TEST_EPOCH = 1700000000000;
const TEST_NODE_ID = 3;

describe('ChimeriaHardwareBridge', () => {
  let bridge;

  beforeEach(() => {
    bridge = new ChimeriaHardwareBridge(TEST_NODE_ID, TEST_EPOCH, {
      fleetSize: 8,
      targetHost: '127.0.0.1',
      targetPort: 50000,
    });
  });

  afterEach(() => {
    if (bridge.running) bridge.stop();
  });

  describe('Initialization', () => {
    it('should derive sovereign identity via PROTO-256', () => {
      expect(bridge.identity).toBeDefined();
      expect(bridge.identity.proto).toBe('PROTO-256');
      expect(bridge.identity.nodeIndex).toBe(TEST_NODE_ID);
      expect(bridge.identity.nodeId).toMatch(/^SWARM-[A-F0-9]{8}$/);
    });

    it('should initialize with zero sequence counter', () => {
      expect(bridge.sequence).toBe(0);
    });

    it('should not be running on creation', () => {
      expect(bridge.running).toBe(false);
    });
  });

  describe('Packet Serialization', () => {
    it('should pack a geodesic waypoint into 30-byte binary frame', () => {
      const packet = bridge.packGeodesicWaypoint({ x: 1.618, y: 2.718, z: 3.14159 });
      expect(packet).not.toBeNull();
      expect(packet.length).toBe(30); // 10B header + 12B coords + 8B hash footer
    });

    it('should encode proto ID 258 (Spatial Exclusion) in header', () => {
      const packet = bridge.packGeodesicWaypoint({ x: 0.5, y: 0.5, z: 0.5 });
      const protoId = packet.readUInt16BE(0);
      expect(protoId).toBe(258);
    });

    it('should encode node ID in header', () => {
      const packet = bridge.packGeodesicWaypoint({ x: 1, y: 2, z: 3 });
      const nodeId = packet.readUInt16BE(2);
      expect(nodeId).toBe(TEST_NODE_ID);
    });

    it('should increment sequence on each pack', () => {
      bridge.packGeodesicWaypoint({ x: 1, y: 0, z: 0 });
      bridge.packGeodesicWaypoint({ x: 2, y: 0, z: 0 });
      const packet = bridge.packGeodesicWaypoint({ x: 3, y: 0, z: 0 });
      const seq = packet.readUInt32BE(4);
      expect(seq).toBe(2);
    });

    it('should write Float32 coordinates at correct offsets', () => {
      const coords = { x: 1.5, y: -2.5, z: 3.75 };
      const packet = bridge.packGeodesicWaypoint(coords);
      expect(packet.readFloatBE(10)).toBeCloseTo(1.5, 4);
      expect(packet.readFloatBE(14)).toBeCloseTo(-2.5, 4);
      expect(packet.readFloatBE(18)).toBeCloseTo(3.75, 4);
    });

    it('should include non-zero φ-hash footer', () => {
      const packet = bridge.packGeodesicWaypoint({ x: 1, y: 1, z: 1 });
      const hashWord = packet.readUInt32BE(22);
      expect(hashWord).not.toBe(0);
    });
  });

  describe('Spatial Exclusion (PROTO-258)', () => {
    it('should reject waypoints that violate spatial exclusion', () => {
      // Register a peer very close to our intended position
      bridge.registerPeerPosition(5, 1.0, 1.0);

      // Try to move to nearly the same position (within φ distance)
      const packet = bridge.packGeodesicWaypoint({ x: 1.0, y: 1.0, z: 0 });
      expect(packet).toBeNull();
      expect(bridge.failedFrames).toBe(1);
    });

    it('should allow waypoints that satisfy spatial exclusion', () => {
      bridge.registerPeerPosition(5, 100.0, 100.0);

      // Move to a distant position
      const packet = bridge.packGeodesicWaypoint({ x: 0.0, y: 0.0, z: 0 });
      expect(packet).not.toBeNull();
    });
  });

  describe('Waypoint Queue', () => {
    it('should enqueue waypoints up to Fibonacci limit (FIB[8]=21)', () => {
      for (let i = 0; i < 21; i++) {
        const accepted = bridge.enqueueWaypoint({ x: i * 10, y: 0, z: 0 });
        expect(accepted).toBe(true);
      }
      // 22nd should be rejected
      const rejected = bridge.enqueueWaypoint({ x: 220, y: 0, z: 0 });
      expect(rejected).toBe(false);
    });

    it('should attach nonce to queued waypoints', () => {
      bridge.enqueueWaypoint({ x: 1, y: 2, z: 3 });
      expect(bridge.waypointQueue[0].nonce).toBeDefined();
      expect(bridge.waypointQueue[0].nonce.proto).toBe('PROTO-268');
    });
  });

  describe('Manifold Ingestion', () => {
    it('should ingest dimensio.js manifold() output', () => {
      const manifoldResult = {
        type: 'torus',
        resolution: 8,
        points: [
          { x: 1.0, y: 2.0, z: 0.5 },
          { x: 3.0, y: 4.0, z: 1.5 },
          { x: 5.0, y: 6.0, z: 2.5 },
        ],
      };

      const report = bridge.ingestManifoldPoints(manifoldResult);
      expect(report.proto).toBe('BRIDGE');
      expect(report.source).toBe('dimensio.js');
      expect(report.manifoldType).toBe('torus');
      expect(report.accepted).toBe(3);
      expect(report.rejected).toBe(0);
      expect(bridge.waypointQueue.length).toBe(3);
    });

    it('should ingest dimensio.js navigate() path output', () => {
      const navigateResult = {
        path: [
          [1, 2, 3],
          [4, 5, 6],
          [7, 8, 9],
        ],
      };

      const report = bridge.ingestGeodesicPath(navigateResult);
      expect(report.proto).toBe('BRIDGE');
      expect(report.source).toBe('dimensio.js/navigate');
      expect(report.pathSteps).toBe(3);
      expect(report.accepted).toBe(3);
    });
  });

  describe('UDP Lifecycle', () => {
    it('should start and stop without error', () => {
      bridge.start();
      expect(bridge.running).toBe(true);
      expect(bridge.socket).not.toBeNull();

      bridge.stop();
      expect(bridge.running).toBe(false);
      expect(bridge.socket).toBeNull();
    });

    it('should not start twice', () => {
      bridge.start();
      const socket1 = bridge.socket;
      bridge.start(); // no-op
      expect(bridge.socket).toBe(socket1);
      bridge.stop();
    });
  });

  describe('Status Reporting', () => {
    it('should return comprehensive status', () => {
      const status = bridge.getStatus();
      expect(status.nodeId).toBe(TEST_NODE_ID);
      expect(status.identity).toBe(bridge.identity.nodeId);
      expect(status.running).toBe(false);
      expect(status.sequence).toBe(0);
      expect(status.queueCapacity).toBe(21);
      expect(status.heartbeat).toBeDefined();
      expect(status.heartbeat.beatNumber).toBeGreaterThanOrEqual(0);
    });
  });
});

describe('SwarmUDPFleet', () => {
  let fleet;

  beforeEach(() => {
    fleet = new SwarmUDPFleet(5, TEST_EPOCH, {
      baseHost: '127.0.0.1',
      basePort: 60000,
    });
  });

  afterEach(() => {
    fleet.stopAll();
  });

  it('should create bridges for all nodes in fleet', () => {
    expect(fleet.bridges.size).toBe(5);
  });

  it('should distribute manifold points across fleet using golden-angle', () => {
    const manifoldResult = {
      type: 'torus',
      resolution: 8,
      points: Array.from({ length: 10 }, (_, i) => ({
        x: Math.cos(i) * 10,
        y: Math.sin(i) * 10,
        z: i * 0.5,
      })),
    };

    const report = fleet.distributeManifoldPoints(manifoldResult);
    expect(report.proto).toBe('FLEET_DISTRIBUTE');
    expect(report.distributed).toBe(10);
    expect(report.fleetSize).toBe(5);
  });

  it('should provide aggregate fleet status', () => {
    const status = fleet.getFleetStatus();
    expect(status.fleetSize).toBe(5);
    expect(status.nodes.length).toBe(5);
    expect(status.totalSuccessFrames).toBe(0);
  });

  it('should start and stop all bridges', () => {
    fleet.startAll();
    for (const bridge of fleet.bridges.values()) {
      expect(bridge.running).toBe(true);
    }
    fleet.stopAll();
    for (const bridge of fleet.bridges.values()) {
      expect(bridge.running).toBe(false);
    }
  });
});
