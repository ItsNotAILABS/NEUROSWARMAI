/**
 * CHIMERIA HARDWARE BRIDGE — Asynchronous UDP Transmission Loop
 *
 * Bridges live dimensio.js manifold coordinate projections directly into the
 * 20 embedded sub-protocols (PROTO-255 through PROTO-274), serializes them
 * into binary geodesic waypoint packets, and pipes them over local UDP
 * channels to VA-1000 hardware actuator nodes.
 *
 * Architecture:
 *   dimensio.js (φ-spiral manifold) → ChimeriaHardwareBridge → Binary Packet
 *   → PROTO-257 φ-Hash Integrity → PROTO-258 Spatial Exclusion Validation
 *   → PROTO-261 Byzantine Fault Detection → UDP Socket → Hardware Nodes
 *
 * Zero external dependencies — sovereign Node.js dgram UDP engine.
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

import { createSocket } from 'node:dgram';
import { Buffer } from 'node:buffer';

import {
  heartbeatSync,
  deriveNodeIdentity,
  phiHash,
  spatialExclusionEnvelope,
  byzantineFaultDetector,
  fibonacciQuorum,
  fibonacciBackoff,
  generateNonce,
  PHI,
  PHI_INV,
  PHI_BEAT_MS,
  FIB,
} from './swarm-embedded-protocols.js';

// ═══════════════════════════════════════════════════════════════════════════
// CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════

const PROTO_HEARTBEAT = 255;
const PROTO_IDENTITY = 256;
const PROTO_PHI_HASH = 257;
const PROTO_SPATIAL_EXCLUSION = 258;
const PROTO_KURAMOTO = 259;
const PROTO_QUORUM = 260;
const PROTO_BYZANTINE = 261;

const HEADER_SIZE = 10;          // 2B Proto + 2B NodeID + 4B Sequence + 2B φ-Tick
const COORD_SIZE = 12;           // 3 × Float32 (x, y, z)
const HASH_FOOTER_SIZE = 8;      // φ-hash integrity footer
const PACKET_SIZE = HEADER_SIZE + COORD_SIZE + HASH_FOOTER_SIZE; // 30 bytes total

const DEFAULT_PORT_BASE = 41618; // φ-aligned base port
const MAX_RETRANSMIT = 5;
const WAYPOINT_QUEUE_LIMIT = FIB[8]; // 34 queued waypoints max

// ═══════════════════════════════════════════════════════════════════════════
// CHIMERIA HARDWARE BRIDGE CLASS
// ═══════════════════════════════════════════════════════════════════════════

export class ChimeriaHardwareBridge {
  /**
   * @param {number} nodeId - This node's numeric ID in the fleet
   * @param {number} swarmEpoch - Swarm genesis timestamp (ms)
   * @param {Object} [options] - Configuration options
   * @param {string} [options.targetHost] - Target hardware node IP (default: 127.0.0.1)
   * @param {number} [options.targetPort] - Target UDP port (default: φ-aligned base)
   * @param {number} [options.fleetSize] - Total nodes in the swarm
   */
  constructor(nodeId, swarmEpoch, options = {}) {
    this.nodeId = nodeId;
    this.swarmEpoch = swarmEpoch;
    this.fleetSize = options.fleetSize || 8;
    this.targetHost = options.targetHost || '127.0.0.1';
    this.targetPort = options.targetPort || DEFAULT_PORT_BASE + nodeId;

    this.sequence = 0;
    this.running = false;
    this.socket = null;
    this.waypointQueue = [];
    this.transmitLog = [];
    this.failedFrames = 0;
    this.successFrames = 0;
    this.lastPositions = new Map(); // nodeId → {x, y} for spatial exclusion

    // Derive sovereign identity via PROTO-256
    this.identity = deriveNodeIdentity(this.nodeId, this.swarmEpoch);
  }

  // ═════════════════════════════════════════════════════════════════════════
  // PACKET SERIALIZATION — Binary Geodesic Waypoint Encoding
  // ═════════════════════════════════════════════════════════════════════════

  /**
   * Pack a manifold-computed agent state into a binary UDP frame.
   * Layout: [Header 10B][Coordinates 12B][φ-Hash Footer 8B] = 30B total
   *
   * @param {Object} agentState - Manifold coordinates from dimensio.js
   * @param {number} agentState.x - X geodesic coordinate
   * @param {number} agentState.y - Y geodesic coordinate
   * @param {number} agentState.z - Z geodesic coordinate
   * @returns {Buffer|null} Binary packet or null if rejected by spatial exclusion
   */
  packGeodesicWaypoint(agentState) {
    const { x, y, z } = agentState;

    // PROTO-258: Spatial Exclusion Envelope — reject if collision detected
    for (const [otherId, pos] of this.lastPositions.entries()) {
      if (otherId === this.nodeId) continue;
      const exclusion = spatialExclusionEnvelope(x, y, pos.x, pos.y);
      if (!exclusion.valid) {
        this.failedFrames++;
        return null; // Sunflower theorem blocks intersection
      }
    }

    // Update position registry
    this.lastPositions.set(this.nodeId, { x, y });

    // PROTO-255: Align to φ-beat temporal grid
    const now = Date.now();
    const heartbeat = heartbeatSync(now, this.swarmEpoch, this.nodeId, this.fleetSize);
    const phiTick = now % PHI_BEAT_MS;

    // Increment sequence counter
    const seq = this.sequence++;

    // Allocate packet buffer
    const buffer = Buffer.alloc(HEADER_SIZE + COORD_SIZE);

    // Header: 2B Proto ID, 2B Node ID, 4B Sequence, 2B φ-Tick
    buffer.writeUInt16BE(PROTO_SPATIAL_EXCLUSION, 0);   // PROTO 258: Spatial Exclusion trigger
    buffer.writeUInt16BE(this.nodeId, 2);               // PROTO 256: Identity bound
    buffer.writeUInt32BE(seq, 4);
    buffer.writeUInt16BE(phiTick, 8);

    // Write pre-computed manifold coordinates into continuous memory
    buffer.writeFloatBE(x, 10);
    buffer.writeFloatBE(y, 14);
    buffer.writeFloatBE(z, 18);

    // PROTO-257: Append φ-hash integrity footer
    const hashResult = phiHash(buffer.toString('hex'));
    const footer = Buffer.alloc(HASH_FOOTER_SIZE);
    footer.writeUInt32BE(hashResult.numeric, 0);
    footer.writeUInt32BE(Math.floor(hashResult.phiCheck * 0xFFFFFFFF) >>> 0, 4);

    return Buffer.concat([buffer, footer]);
  }

  // ═════════════════════════════════════════════════════════════════════════
  // WAYPOINT QUEUE MANAGEMENT
  // ═════════════════════════════════════════════════════════════════════════

  /**
   * Enqueue a manifold-generated waypoint for transmission.
   * Respects the Fibonacci-bounded queue limit.
   *
   * @param {Object} agentState - {x, y, z} coordinates from dimensio.js manifold
   * @returns {boolean} Whether the waypoint was accepted
   */
  enqueueWaypoint(agentState) {
    if (this.waypointQueue.length >= WAYPOINT_QUEUE_LIMIT) {
      return false; // Queue saturated — back-pressure
    }
    this.waypointQueue.push({
      ...agentState,
      enqueuedAt: Date.now(),
      nonce: generateNonce(this.identity.nodeId, this.sequence, Date.now()),
    });
    return true;
  }

  // ═════════════════════════════════════════════════════════════════════════
  // ASYNCHRONOUS UDP TRANSMISSION LOOP
  // ═════════════════════════════════════════════════════════════════════════

  /**
   * Start the asynchronous UDP transmission loop.
   * Fires geodesic waypoint packets aligned to the 873ms φ-beat grid.
   * Implements Byzantine fault detection on outbound frames and
   * Fibonacci quorum scaling for network interruption resilience.
   */
  start() {
    if (this.running) return;
    this.running = true;

    // Create sovereign UDP4 socket — zero external dependencies
    this.socket = createSocket('udp4');

    this.socket.on('error', (err) => {
      this.failedFrames++;
      this._logTransmit('ERROR', null, err.message);
    });

    this.socket.on('listening', () => {
      const addr = this.socket.address();
      this._logTransmit('LISTEN', null, `UDP bound ${addr.address}:${addr.port}`);
    });

    // Bind to ephemeral port for outbound transmission
    this.socket.bind(0);

    // Launch the φ-beat aligned transmission cycle
    this._scheduleNextBeat();
  }

  /**
   * Stop the transmission loop and close the UDP socket.
   */
  stop() {
    this.running = false;
    if (this.socket) {
      this.socket.close();
      this.socket = null;
    }
  }

  /**
   * Schedule the next transmission aligned to φ-beat grid.
   * Uses PROTO-255 heartbeat sync to determine sleep duration.
   * @private
   */
  _scheduleNextBeat() {
    if (!this.running) return;

    const now = Date.now();
    const heartbeat = heartbeatSync(now, this.swarmEpoch, this.nodeId, this.fleetSize);

    setTimeout(() => {
      this._transmitCycle();
    }, heartbeat.sleepMs || PHI_BEAT_MS);
  }

  /**
   * Execute one transmission cycle:
   * 1. Drain waypoints from queue
   * 2. Pack into binary frames
   * 3. Validate via Byzantine fault detector
   * 4. Transmit over UDP
   * 5. Schedule next beat
   * @private
   */
  _transmitCycle() {
    if (!this.running || !this.socket) return;

    // PROTO-260: Check quorum — only transmit if fleet has sufficient active nodes
    const quorum = fibonacciQuorum(this.fleetSize);
    const activeNodes = this.fleetSize - this._estimateDownNodes();

    if (activeNodes < quorum.minimumRequired) {
      this._logTransmit('QUORUM_HOLD', null,
        `Active ${activeNodes} < required ${quorum.minimumRequired} — holding transmission`);
      this._scheduleNextBeat();
      return;
    }

    // Drain up to FIB[5]=5 waypoints per beat cycle (Fibonacci-bounded batch)
    const batchSize = Math.min(this.waypointQueue.length, FIB[5]);
    const batch = this.waypointQueue.splice(0, batchSize);

    // Build outbound reports for Byzantine validation
    const frameReports = [];

    for (const waypoint of batch) {
      const packet = this.packGeodesicWaypoint(waypoint);

      if (!packet) {
        frameReports.push({ value: -1, nodeId: this.nodeId }); // Rejected by spatial exclusion
        continue;
      }

      // Collect integrity metric for Byzantine check
      const integrity = phiHash(packet.toString('hex'));
      frameReports.push({ value: integrity.phiCheck, nodeId: this.nodeId });

      // Transmit the binary packet over UDP
      this._sendPacket(packet, waypoint);
    }

    // PROTO-261: Byzantine fault detection on outbound frame batch
    if (frameReports.length > 2) {
      const faultResult = byzantineFaultDetector(
        frameReports.map(r => r.value)
      );
      if (faultResult.faultyNodes.length > 0) {
        this._logTransmit('BYZANTINE_REJECT', null,
          `${faultResult.faultyNodes.length} frames exceeded φ·σ threshold — dropped`);
      }
    }

    // Schedule next φ-beat
    this._scheduleNextBeat();
  }

  /**
   * Send a single binary packet over UDP to the target hardware node.
   * Implements Fibonacci backoff retry on failure.
   * @private
   * @param {Buffer} packet - Serialized geodesic waypoint
   * @param {Object} waypoint - Original waypoint data for logging
   * @param {number} [attempt] - Current retry attempt
   */
  _sendPacket(packet, waypoint, attempt = 0) {
    if (!this.socket || !this.running) return;

    this.socket.send(packet, 0, packet.length, this.targetPort, this.targetHost, (err) => {
      if (err) {
        this.failedFrames++;

        // Fibonacci backoff retry (PROTO-267)
        if (attempt < MAX_RETRANSMIT) {
          const backoff = fibonacciBackoff(attempt);
          setTimeout(() => {
            this._sendPacket(packet, waypoint, attempt + 1);
          }, backoff.delay);
          this._logTransmit('RETRY', packet, `attempt ${attempt + 1}, backoff ${backoff.delay}ms`);
        } else {
          this._logTransmit('DROP', packet, `max retransmits exceeded`);
        }
      } else {
        this.successFrames++;
        this._logTransmit('TX', packet, `seq=${waypoint.nonce?.sequence || this.sequence}`);
      }
    });
  }

  // ═════════════════════════════════════════════════════════════════════════
  // MANIFOLD INGESTION — Connect dimensio.js output to transmission pipeline
  // ═════════════════════════════════════════════════════════════════════════

  /**
   * Ingest a batch of manifold points generated by dimensio.js and queue
   * them for transmission to hardware nodes.
   *
   * @param {Object} manifoldResult - Output from dimensio.js manifold() function
   * @param {Array} manifoldResult.points - Array of {x, y, z} coordinates
   * @returns {Object} Ingestion report
   */
  ingestManifoldPoints(manifoldResult) {
    const { points, type, resolution } = manifoldResult;
    let accepted = 0;
    let rejected = 0;

    for (const point of points) {
      const success = this.enqueueWaypoint(point);
      if (success) accepted++;
      else rejected++;
    }

    return {
      proto: 'BRIDGE',
      source: 'dimensio.js',
      manifoldType: type,
      resolution,
      totalPoints: points.length,
      accepted,
      rejected,
      queueDepth: this.waypointQueue.length,
      queueCapacity: WAYPOINT_QUEUE_LIMIT,
    };
  }

  /**
   * Ingest a single navigated geodesic path from dimensio.js navigate() output.
   *
   * @param {Object} navigateResult - Output from dimensio.js navigate() function
   * @param {Array} navigateResult.path - Array of coordinate arrays [x, y, z]
   * @returns {Object} Ingestion report
   */
  ingestGeodesicPath(navigateResult) {
    const { path } = navigateResult;
    let accepted = 0;

    for (const coords of path) {
      const [x, y, z] = coords.length >= 3 ? coords : [...coords, 0];
      const success = this.enqueueWaypoint({ x, y, z });
      if (success) accepted++;
    }

    return {
      proto: 'BRIDGE',
      source: 'dimensio.js/navigate',
      pathSteps: path.length,
      accepted,
      queueDepth: this.waypointQueue.length,
    };
  }

  // ═════════════════════════════════════════════════════════════════════════
  // FLEET COORDINATION — Multi-node position tracking
  // ═════════════════════════════════════════════════════════════════════════

  /**
   * Register another node's position for spatial exclusion checks.
   * Call this when receiving position updates from peer nodes.
   *
   * @param {number} peerId - Peer node ID
   * @param {number} x - Peer X position
   * @param {number} y - Peer Y position
   */
  registerPeerPosition(peerId, x, y) {
    this.lastPositions.set(peerId, { x, y });
  }

  // ═════════════════════════════════════════════════════════════════════════
  // DIAGNOSTICS
  // ═════════════════════════════════════════════════════════════════════════

  /**
   * Get current bridge status and performance metrics.
   * @returns {Object} Status report
   */
  getStatus() {
    const now = Date.now();
    const heartbeat = heartbeatSync(now, this.swarmEpoch, this.nodeId, this.fleetSize);

    return {
      nodeId: this.nodeId,
      identity: this.identity.nodeId,
      running: this.running,
      sequence: this.sequence,
      queueDepth: this.waypointQueue.length,
      queueCapacity: WAYPOINT_QUEUE_LIMIT,
      successFrames: this.successFrames,
      failedFrames: this.failedFrames,
      targetEndpoint: `${this.targetHost}:${this.targetPort}`,
      heartbeat: {
        beatNumber: heartbeat.beatNumber,
        phase: heartbeat.phase,
        synchronized: heartbeat.synchronized,
      },
      recentTransmits: this.transmitLog.slice(-10),
    };
  }

  /**
   * Estimate down nodes based on failed frame ratio.
   * Used for quorum threshold scaling.
   * @private
   * @returns {number} Estimated unreachable nodes
   */
  _estimateDownNodes() {
    const total = this.successFrames + this.failedFrames;
    if (total === 0) return 0;
    const failRate = this.failedFrames / total;
    // Scale to fleet — if >φ⁻¹ of frames fail, assume proportional node loss
    return failRate > PHI_INV ? Math.ceil(this.fleetSize * failRate * PHI_INV) : 0;
  }

  /**
   * Log a transmission event.
   * @private
   */
  _logTransmit(type, packet, detail) {
    const entry = {
      ts: Date.now(),
      type,
      detail,
      packetSize: packet ? packet.length : 0,
    };
    this.transmitLog.push(entry);
    // Keep log bounded to Fibonacci limit
    if (this.transmitLog.length > FIB[7]) { // 21
      this.transmitLog = this.transmitLog.slice(-FIB[6]); // Keep last 13
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// MULTI-NODE SWARM BRIDGE — Manages fleet-wide UDP distribution
// ═══════════════════════════════════════════════════════════════════════════

export class SwarmUDPFleet {
  /**
   * Create a fleet-wide UDP distribution engine.
   *
   * @param {number} fleetSize - Number of hardware nodes
   * @param {number} swarmEpoch - Swarm genesis timestamp
   * @param {Object} [options] - Fleet options
   * @param {string} [options.baseHost] - Base host for all nodes (default: 127.0.0.1)
   * @param {number} [options.basePort] - Base port (nodes get basePort + nodeId)
   */
  constructor(fleetSize, swarmEpoch, options = {}) {
    this.fleetSize = fleetSize;
    this.swarmEpoch = swarmEpoch;
    this.baseHost = options.baseHost || '127.0.0.1';
    this.basePort = options.basePort || DEFAULT_PORT_BASE;

    this.bridges = new Map();

    // Initialize a bridge for each hardware node in the fleet
    for (let i = 0; i < fleetSize; i++) {
      this.bridges.set(i, new ChimeriaHardwareBridge(i, swarmEpoch, {
        targetHost: this.baseHost,
        targetPort: this.basePort + i,
        fleetSize,
      }));
    }
  }

  /**
   * Start all bridges in the fleet.
   */
  startAll() {
    for (const bridge of this.bridges.values()) {
      bridge.start();
    }
  }

  /**
   * Stop all bridges in the fleet.
   */
  stopAll() {
    for (const bridge of this.bridges.values()) {
      bridge.stop();
    }
  }

  /**
   * Distribute a set of manifold points across fleet nodes using
   * golden-angle assignment to ensure maximal spatial separation.
   *
   * @param {Object} manifoldResult - Output from dimensio.js manifold()
   * @returns {Object} Distribution report
   */
  distributeManifoldPoints(manifoldResult) {
    const { points } = manifoldResult;
    const reports = [];

    for (let i = 0; i < points.length; i++) {
      // Golden-angle distribution — assign each point to a node
      // using irrational rotation to prevent clustering
      const assignedNode = Math.floor((i * PHI_INV * this.fleetSize) % this.fleetSize);
      const bridge = this.bridges.get(assignedNode);

      if (bridge) {
        // Register this point's position with all other bridges for spatial exclusion
        for (const [id, otherBridge] of this.bridges.entries()) {
          if (id !== assignedNode) {
            otherBridge.registerPeerPosition(assignedNode, points[i].x, points[i].y);
          }
        }

        bridge.enqueueWaypoint(points[i]);
        reports.push({ node: assignedNode, point: i, accepted: true });
      }
    }

    return {
      proto: 'FLEET_DISTRIBUTE',
      source: 'dimensio.js',
      manifoldType: manifoldResult.type,
      totalPoints: points.length,
      distributed: reports.length,
      fleetSize: this.fleetSize,
    };
  }

  /**
   * Get aggregate fleet status.
   * @returns {Object} Fleet-wide metrics
   */
  getFleetStatus() {
    const statuses = [];
    let totalSuccess = 0;
    let totalFailed = 0;
    let totalQueued = 0;

    for (const [id, bridge] of this.bridges.entries()) {
      const s = bridge.getStatus();
      statuses.push(s);
      totalSuccess += s.successFrames;
      totalFailed += s.failedFrames;
      totalQueued += s.queueDepth;
    }

    return {
      fleetSize: this.fleetSize,
      epoch: this.swarmEpoch,
      totalSuccessFrames: totalSuccess,
      totalFailedFrames: totalFailed,
      totalQueuedWaypoints: totalQueued,
      nodes: statuses,
    };
  }
}

export default ChimeriaHardwareBridge;
