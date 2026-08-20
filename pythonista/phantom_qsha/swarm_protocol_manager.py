"""
Sovereign Swarm Protocol Manager — Python bridge to embedded JS sub-protocols.

Maps the 20 embedded protocol identifiers (PROTO-255 through PROTO-274) from
protocols/swarm/swarm-embedded-protocols.js into structural Python payload
builders for the ICP-to-drone terminal pipeline.

Architecture:
  protocols/swarm/swarm-embedded-protocols.js  (φ-encoded JS engine)
        │
        ▼ (Protocol ID mapping)
  pythonista/phantom_qsha/swarm_protocol_manager.py  (Terminal payload builder)
        │
        ▼ (Chaos Bridge integration)
  pythonista/phantom_qsha/chaos_bridge.py  (Chaos + Shadow Wire envelope)
        │
        ▼ (Raw UDP streams)
  VA-1000 Hardware Edges

ZERO EXTERNAL DEPENDENCIES — Complete sovereign execution.
"""

from __future__ import annotations

import math
import struct
import time
from dataclasses import dataclass, field
from typing import Any

from pythonista.phantom_qsha.qsha import qsha256_bytes

# ═══════════════════════════════════════════════════════════════════════════
# CONSTANTS — φ-ALIGNED (mirroring swarm-embedded-protocols.js)
# ═══════════════════════════════════════════════════════════════════════════

GOLDEN_RATIO = (1.0 + math.sqrt(5.0)) / 2.0
PHI_INV = 1.0 / GOLDEN_RATIO
PHI_SQUARED = GOLDEN_RATIO * GOLDEN_RATIO
GOLDEN_ANGLE = 2.39996322972865
PHI_HEARTBEAT_MS = 873
FNV_OFFSET_16 = 0x811C
FNV_PRIME_16 = 0x0101
EPSILON = 1e-10

# First 30 Fibonacci numbers
FIB = [
    0, 1, 1, 2, 3, 5, 8, 13, 21, 34,
    55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181,
    6765, 10946, 17711, 28657, 46368, 75025, 121393, 196418, 317811, 514229,
]

# Protocol registry (mirrors JS exports)
PROTO_HEARTBEAT_SYNC = 255
PROTO_NODE_IDENTITY = 256
PROTO_PHI_HASH = 257
PROTO_SPATIAL_EXCLUSION = 258
PROTO_KURAMOTO_COUPLING = 259
PROTO_FIBONACCI_QUORUM = 260
PROTO_BYZANTINE_FAULT = 261
PROTO_GOLDEN_EPOCH = 262
PROTO_MERKLE_CHAIN = 263
PROTO_ENTROPY_ACCUMULATOR = 264
PROTO_PHI_VOTE = 265
PROTO_HEARTBEAT_MONITOR = 266
PROTO_FIBONACCI_BACKOFF = 267
PROTO_NONCE_GENERATION = 268
PROTO_RING_POSITION = 269
PROTO_SIGNAL_ENVELOPE = 270
PROTO_GRADIENT_CLIPPER = 271
PROTO_ATTESTATION = 272
PROTO_SWARM_BROADCAST = 273
PROTO_EMERGENCY_CASCADE = 274


@dataclass
class ProtocolEnvelope:
    """Structured protocol envelope payload."""

    proto_id: int
    node_id: int
    sequence: int
    phi_tick: int
    payload: bytes
    integrity_signature: bytes
    timestamp_ms: int

    def to_bytes(self) -> bytes:
        """Serialize the complete envelope to raw bytes."""
        return self.header_bytes() + self.payload + self.integrity_signature

    def header_bytes(self) -> bytes:
        """Serialize just the header."""
        return struct.pack(">HHIH", self.proto_id, self.node_id, self.sequence, self.phi_tick)


@dataclass
class HeartbeatPhase:
    """φ-heartbeat phase data for a node."""

    beat_number: int
    phase: float
    node_offset: float
    next_beat_at: int
    sleep_ms: int
    synchronized: bool


@dataclass
class SpatialExclusion:
    """Spatial exclusion validation result."""

    valid: bool
    distance: float
    min_distance: float
    phi_step: float
    zone: str


@dataclass
class QuorumResult:
    """Fibonacci quorum calculation result."""

    fleet_size: int
    quorum: int
    fib_index: int
    ratio: float


class SovereignSwarmProtocolManager:
    """Sovereign Swarm Protocol Manager — maps JS protocol IDs to Python payloads.

    Provides the terminal-side payload builders that structure zero-dependency
    link-layer frames matching the exact index definitions exported by
    swarm-embedded-protocols.js.
    """

    def __init__(self, node_id_seed: int):
        """Initialize the protocol manager.

        Args:
            node_id_seed: Seed for deterministic node identity derivation (PROTO-256).
        """
        self.node_id = self._derive_node_id(node_id_seed)
        self._sequence = 0
        self._swarm_epoch = int(time.time() * 1000)
        self._merkle_chain: list[str] = []

    @property
    def sequence(self) -> int:
        """Current sequence counter."""
        return self._sequence

    # ═══════════════════════════════════════════════════════════════════════
    # CORE ENVELOPE BUILDER
    # ═══════════════════════════════════════════════════════════════════════

    def build_embedded_protocol_envelope(
        self, proto_id: int, payload: bytes
    ) -> ProtocolEnvelope:
        """Build a zero-dependency link-layer payload frame.

        Structures a raw protocol envelope matching the exact index definitions
        exported by swarm-embedded-protocols.js.

        Layout:
          - Header: 2B Proto ID + 2B Node ID + 4B Sequence + 2B φ-Tick = 10 bytes
          - Payload: Variable length
          - Footer: 32B φ-Hash integrity signature

        Args:
            proto_id: Protocol identifier (255–274).
            payload: Raw payload bytes.

        Returns:
            Structured ProtocolEnvelope.
        """
        self._sequence += 1
        timestamp_ms = int(time.time() * 1000)

        # PROTO 255: Calculate position relative to 873ms φ-beat grid
        phi_tick = timestamp_ms % PHI_HEARTBEAT_MS

        # Build header
        header = struct.pack(">HHIH", proto_id, self.node_id, self._sequence, phi_tick)

        # PROTO 257: Generate φ-Hash integrity signature
        integrity_signature = self._compute_phi_hash(header + payload)

        return ProtocolEnvelope(
            proto_id=proto_id,
            node_id=self.node_id,
            sequence=self._sequence,
            phi_tick=phi_tick,
            payload=payload,
            integrity_signature=integrity_signature,
            timestamp_ms=timestamp_ms,
        )

    # ═══════════════════════════════════════════════════════════════════════
    # PROTO-255: φ-HEARTBEAT SYNCHRONIZATION
    # ═══════════════════════════════════════════════════════════════════════

    def heartbeat_sync(self, node_index: int, node_count: int) -> HeartbeatPhase:
        """Compute heartbeat phase for a node on the 873ms φ-beat grid.

        Args:
            node_index: Node's position in the fleet.
            node_count: Total fleet size.

        Returns:
            HeartbeatPhase with timing data.
        """
        now = int(time.time() * 1000)
        elapsed = now - self._swarm_epoch
        beat_number = elapsed // PHI_HEARTBEAT_MS
        phase = (elapsed % PHI_HEARTBEAT_MS) / PHI_HEARTBEAT_MS

        # Golden angle offset to avoid simultaneous firing
        node_offset = (node_index * PHI_INV) % 1.0
        adjusted_phase = (phase + node_offset) % 1.0

        next_beat = self._swarm_epoch + (beat_number + 1) * PHI_HEARTBEAT_MS
        sleep_ms = max(0, next_beat - now + int(node_offset * PHI_HEARTBEAT_MS))

        return HeartbeatPhase(
            beat_number=beat_number,
            phase=adjusted_phase,
            node_offset=node_offset,
            next_beat_at=next_beat,
            sleep_ms=sleep_ms,
            synchronized=phase < PHI_INV,
        )

    # ═══════════════════════════════════════════════════════════════════════
    # PROTO-258: SPATIAL EXCLUSION ENVELOPE
    # ═══════════════════════════════════════════════════════════════════════

    def spatial_exclusion_check(
        self,
        node_pos: tuple[float, float],
        neighbor_pos: tuple[float, float],
        min_base_distance: float = GOLDEN_RATIO,
    ) -> SpatialExclusion:
        """Verify spatial exclusion between two nodes (log-φ floor).

        Args:
            node_pos: (x, y) position of this node.
            neighbor_pos: (x, y) position of neighbor.
            min_base_distance: Minimum separation (default: φ).

        Returns:
            SpatialExclusion validation result.
        """
        dx = node_pos[0] - neighbor_pos[0]
        dy = node_pos[1] - neighbor_pos[1]
        distance = math.sqrt(dx * dx + dy * dy)

        if distance < EPSILON:
            return SpatialExclusion(
                valid=False,
                distance=0.0,
                min_distance=min_base_distance,
                phi_step=0.0,
                zone="COLLISION",
            )

        # log-φ scaling step
        phi_step = math.log(distance / min_base_distance) / math.log(GOLDEN_RATIO)
        valid = distance >= min_base_distance

        if not valid:
            zone = "VIOLATION"
        elif phi_step < 1.0:
            zone = "INNER"
        elif phi_step < PHI_SQUARED:
            zone = "NOMINAL"
        else:
            zone = "OUTER"

        return SpatialExclusion(
            valid=valid,
            distance=distance,
            min_distance=min_base_distance,
            phi_step=phi_step,
            zone=zone,
        )

    # ═══════════════════════════════════════════════════════════════════════
    # PROTO-260: FIBONACCI QUORUM THRESHOLD
    # ═══════════════════════════════════════════════════════════════════════

    def fibonacci_quorum(self, fleet_size: int) -> QuorumResult:
        """Calculate Fibonacci quorum threshold: ⌈N × φ⁻¹⌉ → nearest Fibonacci.

        Args:
            fleet_size: Total nodes in the fleet.

        Returns:
            QuorumResult with threshold data.
        """
        raw_threshold = math.ceil(fleet_size * PHI_INV)

        # Find nearest Fibonacci ≥ threshold
        fib_index = 0
        for i, f in enumerate(FIB):
            if f >= raw_threshold:
                fib_index = i
                break
        else:
            fib_index = len(FIB) - 1

        quorum = FIB[fib_index]
        ratio = quorum / fleet_size if fleet_size > 0 else 0.0

        return QuorumResult(
            fleet_size=fleet_size,
            quorum=quorum,
            fib_index=fib_index,
            ratio=ratio,
        )

    # ═══════════════════════════════════════════════════════════════════════
    # PROTO-261: BYZANTINE FAULT DETECTOR
    # ═══════════════════════════════════════════════════════════════════════

    def byzantine_fault_check(
        self,
        node_metric: float,
        fleet_metrics: list[float],
    ) -> dict[str, Any]:
        """Detect byzantine fault via φ·σ outlier threshold.

        Args:
            node_metric: The suspect node's metric value.
            fleet_metrics: All fleet nodes' metrics.

        Returns:
            Detection result with fault flag and statistics.
        """
        if len(fleet_metrics) < 2:
            return {"proto": 261, "fault_detected": False, "reason": "insufficient_data"}

        mean = sum(fleet_metrics) / len(fleet_metrics)
        variance = sum((x - mean) ** 2 for x in fleet_metrics) / len(fleet_metrics)
        sigma = math.sqrt(variance)

        # φ·σ threshold
        threshold = GOLDEN_RATIO * sigma
        deviation = abs(node_metric - mean)
        fault_detected = deviation > threshold

        return {
            "proto": 261,
            "fault_detected": fault_detected,
            "deviation": deviation,
            "threshold": threshold,
            "mean": mean,
            "sigma": sigma,
            "phi_sigma": threshold,
        }

    # ═══════════════════════════════════════════════════════════════════════
    # PROTO-262: GOLDEN EPOCH TIMER
    # ═══════════════════════════════════════════════════════════════════════

    def golden_epoch_window(self, level: int) -> dict[str, Any]:
        """Compute φ-scaled hierarchical time window.

        Window duration = PHI_HEARTBEAT_MS × φ^level

        Args:
            level: Hierarchy level (0 = base 873ms, 1 = 873×φ, 2 = 873×φ², ...).

        Returns:
            Epoch window configuration.
        """
        window_ms = int(PHI_HEARTBEAT_MS * (GOLDEN_RATIO ** level))
        now = int(time.time() * 1000)
        epoch_number = now // window_ms
        position_in_epoch = (now % window_ms) / window_ms

        return {
            "proto": 262,
            "level": level,
            "window_ms": window_ms,
            "epoch_number": epoch_number,
            "position": position_in_epoch,
            "remaining_ms": window_ms - (now % window_ms),
        }

    # ═══════════════════════════════════════════════════════════════════════
    # PROTO-267: FIBONACCI BACKOFF SCHEDULER
    # ═══════════════════════════════════════════════════════════════════════

    def fibonacci_backoff(self, attempt: int, base_ms: int = 100) -> dict[str, Any]:
        """Calculate Fibonacci-scaled retry delay: F(attempt+2) × base.

        Args:
            attempt: Current retry attempt (0-indexed).
            base_ms: Base delay in milliseconds.

        Returns:
            Backoff schedule with delay and metadata.
        """
        fib_index = min(attempt + 2, len(FIB) - 1)
        delay_ms = FIB[fib_index] * base_ms
        max_delay_ms = FIB[min(attempt + 5, len(FIB) - 1)] * base_ms

        return {
            "proto": 267,
            "attempt": attempt,
            "fib_index": fib_index,
            "delay_ms": delay_ms,
            "max_delay_ms": max_delay_ms,
            "base_ms": base_ms,
            "fib_value": FIB[fib_index],
        }

    # ═══════════════════════════════════════════════════════════════════════
    # PROTO-273: SWARM BROADCAST PRIMITIVE
    # ═══════════════════════════════════════════════════════════════════════

    def swarm_broadcast_targets(
        self, source_index: int, fleet_size: int
    ) -> dict[str, Any]:
        """Compute broadcast relay targets using O(log_φ N) fanout.

        Args:
            source_index: Broadcasting node's index.
            fleet_size: Total fleet size.

        Returns:
            Broadcast plan with relay targets.
        """
        if fleet_size <= 1:
            return {"proto": 273, "targets": [], "hops": 0, "coverage": 1.0}

        # φ-fanout: relay to nodes at distances F(1), F(2), F(3)... from source
        targets = []
        i = 1
        while i < len(FIB) and FIB[i] < fleet_size:
            target = (source_index + FIB[i]) % fleet_size
            if target != source_index:
                targets.append(target)
            i += 1

        # Propagation depth: log_φ(N)
        hops = max(1, int(math.log(fleet_size) / math.log(GOLDEN_RATIO)))
        coverage = min(1.0, len(targets) / fleet_size)

        return {
            "proto": 273,
            "source": source_index,
            "targets": targets,
            "fanout": len(targets),
            "hops": hops,
            "coverage": coverage,
            "fleet_size": fleet_size,
        }

    # ═══════════════════════════════════════════════════════════════════════
    # PRIVATE METHODS
    # ═══════════════════════════════════════════════════════════════════════

    def _derive_node_id(self, seed: int) -> int:
        """PROTO-256: Derive deterministic node identity (FNV-1a 16-bit + φ).

        Args:
            seed: Input seed value.

        Returns:
            16-bit node identifier.
        """
        hash_val = FNV_OFFSET_16
        for byte in str(seed).encode():
            hash_val ^= byte
            hash_val = (hash_val * FNV_PRIME_16) & 0xFFFF
        return int(hash_val * GOLDEN_RATIO) & 0xFFFF

    def _compute_phi_hash(self, data: bytes) -> bytes:
        """PROTO-257: φ-weighted deterministic rotational mixing signature.

        Produces a 32-byte integrity signature using the sovereign QSHA
        commitment profile for full cryptographic strength.

        Args:
            data: Input data to hash.

        Returns:
            32-byte signature.
        """
        hex_hash = qsha256_bytes(data, rounds=12)
        return bytes.fromhex(hex_hash)
