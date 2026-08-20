"""
Chaos Emergence Engine — ICP-to-Drone Chaos Bridge.

Implements the sovereign chaos testing layer that sits between the
ICP canister state queries and the VA-1000 hardware edges. This bridge:

  1. Serializes agent state into raw link-layer Shadow Wire envelopes
  2. Injects pseudo-random network jitter & packet drops (Chaos Core)
  3. Validates integrity via 12-round QSHA signatures
  4. Falls back to last valid step on IntegrityError (SovereignVault defense)

Architecture:
   [ ICP CANISTER NETWORK ] ◄── Deterministic Agent State
              │
              ▼ (Async State Queries / State Sync)
   [ LAPTOP TERMINAL ENGINE ]
   ├────────────────────────┤
   │ Chaos Emergence Core   │ ◄── Pseudo-Random Jitter & Drops
   ├────────────────────────┤
   │ Shadow Wire Encryption │ ◄── 12-round QSHA + Target Masking
   └──────────┬─────────────┘
              │
              ▼ (Raw UDP Wi-Fi Socket Streams)
   [ VA-1000 HARDWARE EDGES ] ◄── Physical Execution Elements

ZERO EXTERNAL DEPENDENCIES — Complete sovereign execution.
"""

from __future__ import annotations

import math
import random
import struct
import time
from dataclasses import dataclass, field
from typing import Any

from pythonista.phantom_qsha.errors import IntegrityError
from pythonista.phantom_qsha.qsha import qsha256_bytes

# ═══════════════════════════════════════════════════════════════════════════
# CONSTANTS — φ-ALIGNED
# ═══════════════════════════════════════════════════════════════════════════

GOLDEN_RATIO = (1.0 + math.sqrt(5.0)) / 2.0
PHI_INV = 1.0 / GOLDEN_RATIO
PHI_HEARTBEAT_MS = 873
MAGIC_HEADER = b"NOVA"
QSHA_SIGNATURE_BYTES = 32

# Chaos probability thresholds
CHAOS_PACKET_LOSS_THRESHOLD = 0.05       # 5% total packet loss
CHAOS_CORRUPTION_THRESHOLD = 0.10        # 5% corruption (cumulative 10%)
CHAOS_JITTER_THRESHOLD = 0.20            # 10% timing jitter injection
CHAOS_REORDER_THRESHOLD = 0.25           # 5% packet reordering


@dataclass
class TrajectoryVector:
    """3D trajectory vector for VA-1000 hardware edge commands."""

    x: float
    y: float
    z: float

    def to_tuple(self) -> tuple[float, float, float]:
        """Return as (x, y, z) tuple."""
        return (self.x, self.y, self.z)

    def magnitude(self) -> float:
        """Euclidean magnitude of the vector."""
        return math.sqrt(self.x ** 2 + self.y ** 2 + self.z ** 2)


@dataclass
class ChaosEvent:
    """Records a chaos injection event for telemetry."""

    event_type: str  # 'packet_loss', 'corruption', 'jitter', 'reorder'
    timestamp: float
    sequence: int
    agent_id: int
    details: dict[str, Any] = field(default_factory=dict)


@dataclass
class ChaosConfig:
    """Configuration for chaos injection parameters."""

    packet_loss_rate: float = 0.05
    corruption_rate: float = 0.05
    jitter_rate: float = 0.10
    reorder_rate: float = 0.05
    max_jitter_ms: int = 200
    enabled: bool = True


class ChaosEmergenceEngine:
    """Chaos Emergence Engine — ICP-to-Drone bridge with sovereign chaos testing.

    Serializes ICP agent state into raw link-layer bytes payloads bound to
    physical hardware controls, while systematically injecting network chaos
    to stress-test Shadow Wire and SovereignVault integrity.
    """

    def __init__(self, config: ChaosConfig | None = None, seed: int | None = None):
        """Initialize the Chaos Emergence Engine.

        Args:
            config: Chaos injection configuration. Defaults to standard rates.
            seed: Optional RNG seed for reproducible chaos sequences.
        """
        self._config = config or ChaosConfig()
        self._rng = random.Random(seed)
        self._sequence = 0
        self._chaos_log: list[ChaosEvent] = []
        self._last_valid_frames: dict[int, bytes] = {}  # agent_id -> last good frame

    @property
    def chaos_log(self) -> list[ChaosEvent]:
        """Return the chaos event telemetry log."""
        return list(self._chaos_log)

    @property
    def config(self) -> ChaosConfig:
        """Return the current chaos configuration."""
        return self._config

    def generate_qsha_signature(self, data: bytes) -> bytes:
        """Generate a 32-byte QSHA integrity signature.

        Uses the 12-round QSHA commitment profile to produce a
        deterministic cryptographic footer for frame validation.

        Args:
            data: Raw frame data to sign.

        Returns:
            32-byte QSHA signature.
        """
        hex_hash = qsha256_bytes(data, rounds=12)
        return bytes.fromhex(hex_hash)

    def generate_shadow_wire_envelope(
        self,
        agent_id: int,
        trajectory_vector: TrajectoryVector,
        *,
        apply_chaos: bool | None = None,
    ) -> bytes:
        """Serialize agent state into a raw link-layer Shadow Wire envelope.

        Protocol Layout:
          - Header: 4B Magic (NOVA) + 2B Agent ID + 4B Sequence = 10 bytes
          - Payload: 3 × 4B float (X, Y, Z trajectory) = 12 bytes
          - Footer: 32B QSHA-256 integrity signature = 32 bytes
          Total: 54 bytes

        Args:
            agent_id: ICP agent identifier (0–65535).
            trajectory_vector: 3D trajectory for hardware edge.
            apply_chaos: Override chaos injection (None uses config.enabled).

        Returns:
            Raw bytes envelope (may be empty on simulated packet loss,
            or corrupted on chaos injection).
        """
        self._sequence += 1
        sequence = self._sequence

        # Protocol Header: 4B Magic + 2B Agent ID + 4B Sequence
        header = struct.pack(">4sHI", MAGIC_HEADER, agent_id, sequence)

        # Payload: 3 float trajectory values (X, Y, Z)
        vx, vy, vz = trajectory_vector.to_tuple()
        payload = struct.pack(">fff", vx, vy, vz)

        # Cryptographic Validation: 12-round QSHA signature
        frame_body = header + payload
        signature = self.generate_qsha_signature(frame_body)
        full_frame = frame_body + signature

        # Store as last valid frame for fallback
        self._last_valid_frames[agent_id] = full_frame

        # --- CHAOS EMERGENCE SIMULATION LAYER ---
        should_apply = apply_chaos if apply_chaos is not None else self._config.enabled
        if should_apply:
            return self._apply_chaos(full_frame, agent_id, sequence)

        return full_frame

    def validate_envelope(self, frame: bytes) -> bool:
        """Validate a Shadow Wire envelope's QSHA integrity signature.

        Args:
            frame: Raw bytes frame to validate.

        Returns:
            True if the frame integrity is intact.

        Raises:
            IntegrityError: If the frame is corrupted or truncated.
        """
        if len(frame) == 0:
            raise IntegrityError("Empty frame — packet loss detected")

        min_frame_size = 10 + 12 + QSHA_SIGNATURE_BYTES  # header + payload + sig
        if len(frame) < min_frame_size:
            raise IntegrityError(
                f"Frame truncated: {len(frame)} bytes < {min_frame_size} minimum"
            )

        # Split frame body from signature
        frame_body = frame[:-QSHA_SIGNATURE_BYTES]
        received_sig = frame[-QSHA_SIGNATURE_BYTES:]

        # Recompute expected signature
        expected_sig = self.generate_qsha_signature(frame_body)

        if received_sig != expected_sig:
            raise IntegrityError(
                f"QSHA signature mismatch — frame corrupted "
                f"(expected {expected_sig.hex()[:16]}..., "
                f"got {received_sig.hex()[:16]}...)"
            )

        return True

    def receive_with_fallback(self, frame: bytes, agent_id: int) -> bytes:
        """Receive a frame with SovereignVault fallback on integrity failure.

        Implements the defense contract: if the network stream is degraded,
        catch IntegrityError, reject the bad packet, and fall back to the
        last valid step without interrupting the execution loop.

        Args:
            frame: Incoming raw bytes frame.
            agent_id: Expected agent identifier.

        Returns:
            Valid frame (either the incoming frame or last-known-good fallback).
        """
        try:
            self.validate_envelope(frame)
            self._last_valid_frames[agent_id] = frame
            return frame
        except IntegrityError:
            # Fall back to last valid frame (SovereignVault defense)
            fallback = self._last_valid_frames.get(agent_id)
            if fallback is None:
                raise IntegrityError(
                    f"No fallback frame available for agent {agent_id} — "
                    "cannot recover from integrity failure"
                )
            return fallback

    def decode_envelope(self, frame: bytes) -> dict[str, Any]:
        """Decode a validated Shadow Wire envelope into structured data.

        Args:
            frame: Valid raw bytes frame (must pass validate_envelope first).

        Returns:
            Decoded agent state dictionary.
        """
        # Parse header
        magic, agent_id, sequence = struct.unpack(">4sHI", frame[:10])
        if magic != MAGIC_HEADER:
            raise IntegrityError(f"Invalid magic: {magic!r} (expected {MAGIC_HEADER!r})")

        # Parse trajectory payload
        vx, vy, vz = struct.unpack(">fff", frame[10:22])

        return {
            "magic": magic.decode("ascii"),
            "agent_id": agent_id,
            "sequence": sequence,
            "trajectory": TrajectoryVector(x=vx, y=vy, z=vz),
            "signature": frame[22:].hex(),
        }

    def get_last_valid_frame(self, agent_id: int) -> bytes | None:
        """Retrieve the last known-good frame for an agent.

        Args:
            agent_id: Agent identifier.

        Returns:
            Last valid frame bytes, or None if no frame has been stored.
        """
        return self._last_valid_frames.get(agent_id)

    def reset_chaos_log(self) -> None:
        """Clear the chaos telemetry log."""
        self._chaos_log.clear()

    # ─── Private Methods ───────────────────────────────────────────────────

    def _apply_chaos(self, full_frame: bytes, agent_id: int, sequence: int) -> bytes:
        """Apply chaos injection based on configured probabilities.

        Chaos Layers (cumulative probability check):
          - 5%: Total packet loss (empty bytes)
          - 5%: Byte corruption (bit flip at random index)
          - 10%: Timing jitter (frame returned but delayed metadata)
          - 5%: Packet reorder simulation (returns previous frame)
        """
        roll = self._rng.random()
        timestamp = time.time()

        if roll < self._config.packet_loss_rate:
            # Total packet loss
            self._chaos_log.append(ChaosEvent(
                event_type="packet_loss",
                timestamp=timestamp,
                sequence=sequence,
                agent_id=agent_id,
            ))
            return b""

        elif roll < self._config.packet_loss_rate + self._config.corruption_rate:
            # Corrupt a random byte to force IntegrityError on receive
            corrupt_index = self._rng.randint(0, len(full_frame) - 1)
            frame_list = bytearray(full_frame)
            frame_list[corrupt_index] ^= 0xFF
            self._chaos_log.append(ChaosEvent(
                event_type="corruption",
                timestamp=timestamp,
                sequence=sequence,
                agent_id=agent_id,
                details={"corrupt_index": corrupt_index},
            ))
            return bytes(frame_list)

        elif roll < (
            self._config.packet_loss_rate
            + self._config.corruption_rate
            + self._config.jitter_rate
        ):
            # Timing jitter — frame is valid but arrival is delayed
            jitter_ms = self._rng.randint(1, self._config.max_jitter_ms)
            self._chaos_log.append(ChaosEvent(
                event_type="jitter",
                timestamp=timestamp,
                sequence=sequence,
                agent_id=agent_id,
                details={"jitter_ms": jitter_ms},
            ))
            return full_frame  # Valid frame, jitter recorded in telemetry

        elif roll < (
            self._config.packet_loss_rate
            + self._config.corruption_rate
            + self._config.jitter_rate
            + self._config.reorder_rate
        ):
            # Packet reorder — return previous agent frame instead
            prev_frame = self._last_valid_frames.get(agent_id)
            self._chaos_log.append(ChaosEvent(
                event_type="reorder",
                timestamp=timestamp,
                sequence=sequence,
                agent_id=agent_id,
            ))
            return prev_frame if prev_frame else full_frame

        return full_frame
