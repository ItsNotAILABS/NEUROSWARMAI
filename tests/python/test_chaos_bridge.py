"""
Tests for Chaos Bridge and Sovereign Swarm Protocol Manager.

Covers:
- Chaos Emergence Engine envelope generation and validation.
- Packet loss, corruption, and jitter chaos injection.
- SovereignVault fallback on IntegrityError.
- Swarm Protocol Manager envelope building with φ-beat alignment.
- PROTO-255 heartbeat synchronization.
- PROTO-258 spatial exclusion checks.
- PROTO-260 Fibonacci quorum threshold.
- PROTO-261 Byzantine fault detection.
- PROTO-267 Fibonacci backoff scheduling.
- PROTO-273 Swarm broadcast fanout.
"""

from __future__ import annotations

import struct
import time

import pytest

from pythonista.phantom_qsha.chaos_bridge import (
    ChaosConfig,
    ChaosEmergenceEngine,
    TrajectoryVector,
)
from pythonista.phantom_qsha.errors import IntegrityError
from pythonista.phantom_qsha.swarm_protocol_manager import (
    GOLDEN_RATIO,
    PHI_HEARTBEAT_MS,
    PROTO_FIBONACCI_QUORUM,
    PROTO_HEARTBEAT_SYNC,
    PROTO_SPATIAL_EXCLUSION,
    SovereignSwarmProtocolManager,
)


# ═══════════════════════════════════════════════════════════════════════════
# CHAOS EMERGENCE ENGINE TESTS
# ═══════════════════════════════════════════════════════════════════════════


class TestChaosEmergenceEngine:
    """Tests for the Chaos Emergence Engine."""

    def test_envelope_generation_clean(self):
        """Envelope generation without chaos produces valid 54-byte frames."""
        engine = ChaosEmergenceEngine(config=ChaosConfig(enabled=False))
        vec = TrajectoryVector(x=1.0, y=2.0, z=3.0)
        frame = engine.generate_shadow_wire_envelope(agent_id=1, trajectory_vector=vec)

        # 4 magic + 2 agent_id + 4 sequence + 12 payload + 32 signature = 54
        assert len(frame) == 54
        assert frame[:4] == b"NOVA"

    def test_envelope_agent_id_encoding(self):
        """Agent ID is correctly encoded in the header."""
        engine = ChaosEmergenceEngine(config=ChaosConfig(enabled=False))
        vec = TrajectoryVector(x=0.0, y=0.0, z=0.0)
        frame = engine.generate_shadow_wire_envelope(agent_id=42, trajectory_vector=vec)

        _, agent_id, _ = struct.unpack(">4sHI", frame[:10])
        assert agent_id == 42

    def test_envelope_sequence_increments(self):
        """Sequence counter increments on each generation."""
        engine = ChaosEmergenceEngine(config=ChaosConfig(enabled=False))
        vec = TrajectoryVector(x=0.0, y=0.0, z=0.0)

        frame1 = engine.generate_shadow_wire_envelope(agent_id=1, trajectory_vector=vec)
        frame2 = engine.generate_shadow_wire_envelope(agent_id=1, trajectory_vector=vec)

        _, _, seq1 = struct.unpack(">4sHI", frame1[:10])
        _, _, seq2 = struct.unpack(">4sHI", frame2[:10])
        assert seq2 == seq1 + 1

    def test_envelope_trajectory_encoding(self):
        """Trajectory vector is correctly encoded in the payload."""
        engine = ChaosEmergenceEngine(config=ChaosConfig(enabled=False))
        vec = TrajectoryVector(x=1.5, y=-2.5, z=3.7)
        frame = engine.generate_shadow_wire_envelope(agent_id=1, trajectory_vector=vec)

        vx, vy, vz = struct.unpack(">fff", frame[10:22])
        assert abs(vx - 1.5) < 1e-5
        assert abs(vy - (-2.5)) < 1e-5
        assert abs(vz - 3.7) < 1e-4

    def test_validate_envelope_clean(self):
        """Validation passes for clean frames."""
        engine = ChaosEmergenceEngine(config=ChaosConfig(enabled=False))
        vec = TrajectoryVector(x=1.0, y=2.0, z=3.0)
        frame = engine.generate_shadow_wire_envelope(agent_id=1, trajectory_vector=vec)

        assert engine.validate_envelope(frame) is True

    def test_validate_envelope_empty(self):
        """Validation raises IntegrityError for empty frames."""
        engine = ChaosEmergenceEngine()
        with pytest.raises(IntegrityError, match="Empty frame"):
            engine.validate_envelope(b"")

    def test_validate_envelope_corrupted(self):
        """Validation raises IntegrityError for corrupted frames."""
        engine = ChaosEmergenceEngine(config=ChaosConfig(enabled=False))
        vec = TrajectoryVector(x=1.0, y=2.0, z=3.0)
        frame = engine.generate_shadow_wire_envelope(agent_id=1, trajectory_vector=vec)

        # Corrupt a byte
        corrupted = bytearray(frame)
        corrupted[15] ^= 0xFF
        with pytest.raises(IntegrityError, match="signature mismatch"):
            engine.validate_envelope(bytes(corrupted))

    def test_chaos_packet_loss(self):
        """Chaos injection can produce packet loss (empty frames)."""
        config = ChaosConfig(packet_loss_rate=1.0, enabled=True)
        engine = ChaosEmergenceEngine(config=config, seed=42)
        vec = TrajectoryVector(x=1.0, y=2.0, z=3.0)

        frame = engine.generate_shadow_wire_envelope(agent_id=1, trajectory_vector=vec)
        assert frame == b""
        assert len(engine.chaos_log) == 1
        assert engine.chaos_log[0].event_type == "packet_loss"

    def test_chaos_corruption(self):
        """Chaos injection can produce corrupted frames."""
        config = ChaosConfig(
            packet_loss_rate=0.0, corruption_rate=1.0, enabled=True
        )
        engine = ChaosEmergenceEngine(config=config, seed=42)
        vec = TrajectoryVector(x=1.0, y=2.0, z=3.0)

        frame = engine.generate_shadow_wire_envelope(agent_id=1, trajectory_vector=vec)
        assert len(frame) == 54  # Same size but corrupted
        assert engine.chaos_log[0].event_type == "corruption"

        # Should fail validation
        with pytest.raises(IntegrityError):
            engine.validate_envelope(frame)

    def test_receive_with_fallback_clean(self):
        """Receive passes through valid frames."""
        engine = ChaosEmergenceEngine(config=ChaosConfig(enabled=False))
        vec = TrajectoryVector(x=1.0, y=2.0, z=3.0)
        frame = engine.generate_shadow_wire_envelope(agent_id=1, trajectory_vector=vec)

        result = engine.receive_with_fallback(frame, agent_id=1)
        assert result == frame

    def test_receive_with_fallback_corrupted(self):
        """Receive falls back to last valid on corrupted frame."""
        engine = ChaosEmergenceEngine(config=ChaosConfig(enabled=False))
        vec = TrajectoryVector(x=1.0, y=2.0, z=3.0)

        # Generate a good frame first
        good_frame = engine.generate_shadow_wire_envelope(
            agent_id=1, trajectory_vector=vec
        )
        engine.receive_with_fallback(good_frame, agent_id=1)

        # Now corrupt it
        corrupted = bytearray(good_frame)
        corrupted[20] ^= 0xFF
        result = engine.receive_with_fallback(bytes(corrupted), agent_id=1)

        # Should fall back to the good frame
        assert result == good_frame

    def test_receive_with_fallback_no_history(self):
        """Receive raises when no fallback exists."""
        engine = ChaosEmergenceEngine(config=ChaosConfig(enabled=False))
        with pytest.raises(IntegrityError, match="No fallback frame"):
            engine.receive_with_fallback(b"bad", agent_id=99)

    def test_decode_envelope(self):
        """Decode extracts structured data from valid frames."""
        engine = ChaosEmergenceEngine(config=ChaosConfig(enabled=False))
        vec = TrajectoryVector(x=5.0, y=-3.0, z=1.0)
        frame = engine.generate_shadow_wire_envelope(agent_id=7, trajectory_vector=vec)

        decoded = engine.decode_envelope(frame)
        assert decoded["magic"] == "NOVA"
        assert decoded["agent_id"] == 7
        assert decoded["sequence"] == 1
        assert abs(decoded["trajectory"].x - 5.0) < 1e-5

    def test_qsha_signature_determinism(self):
        """QSHA signatures are deterministic for the same input."""
        engine = ChaosEmergenceEngine()
        sig1 = engine.generate_qsha_signature(b"test data")
        sig2 = engine.generate_qsha_signature(b"test data")
        assert sig1 == sig2
        assert len(sig1) == 32


# ═══════════════════════════════════════════════════════════════════════════
# SOVEREIGN SWARM PROTOCOL MANAGER TESTS
# ═══════════════════════════════════════════════════════════════════════════


class TestSovereignSwarmProtocolManager:
    """Tests for the Sovereign Swarm Protocol Manager."""

    def test_node_id_derivation_deterministic(self):
        """Node ID derivation is deterministic for same seed."""
        mgr1 = SovereignSwarmProtocolManager(node_id_seed=12345)
        mgr2 = SovereignSwarmProtocolManager(node_id_seed=12345)
        assert mgr1.node_id == mgr2.node_id

    def test_node_id_derivation_unique(self):
        """Different seeds produce different node IDs."""
        mgr1 = SovereignSwarmProtocolManager(node_id_seed=100)
        mgr2 = SovereignSwarmProtocolManager(node_id_seed=200)
        assert mgr1.node_id != mgr2.node_id

    def test_node_id_16bit(self):
        """Node ID fits in 16 bits."""
        mgr = SovereignSwarmProtocolManager(node_id_seed=99999)
        assert 0 <= mgr.node_id <= 0xFFFF

    def test_build_envelope_structure(self):
        """Envelope has correct header + payload + signature structure."""
        mgr = SovereignSwarmProtocolManager(node_id_seed=42)
        payload = b"\x01\x02\x03\x04"
        envelope = mgr.build_embedded_protocol_envelope(PROTO_HEARTBEAT_SYNC, payload)

        assert envelope.proto_id == PROTO_HEARTBEAT_SYNC
        assert envelope.node_id == mgr.node_id
        assert envelope.sequence == 1
        assert 0 <= envelope.phi_tick < PHI_HEARTBEAT_MS
        assert envelope.payload == payload
        assert len(envelope.integrity_signature) == 32

    def test_build_envelope_sequence_increments(self):
        """Sequence increments with each envelope."""
        mgr = SovereignSwarmProtocolManager(node_id_seed=42)
        e1 = mgr.build_embedded_protocol_envelope(255, b"a")
        e2 = mgr.build_embedded_protocol_envelope(255, b"b")
        assert e2.sequence == e1.sequence + 1

    def test_build_envelope_serialization(self):
        """Envelope serializes to correct byte layout."""
        mgr = SovereignSwarmProtocolManager(node_id_seed=42)
        payload = b"\xAB\xCD"
        envelope = mgr.build_embedded_protocol_envelope(260, payload)

        raw = envelope.to_bytes()
        # Header: 2 + 2 + 4 + 2 = 10 bytes, payload 2, sig 32 = 44
        assert len(raw) == 10 + 2 + 32

    def test_heartbeat_sync(self):
        """Heartbeat sync returns valid phase data."""
        mgr = SovereignSwarmProtocolManager(node_id_seed=42)
        phase = mgr.heartbeat_sync(node_index=3, node_count=10)

        assert phase.beat_number >= 0
        assert 0.0 <= phase.phase < 1.0
        assert 0.0 <= phase.node_offset < 1.0
        assert phase.sleep_ms >= 0

    def test_spatial_exclusion_valid(self):
        """Spatial exclusion passes for distant nodes."""
        mgr = SovereignSwarmProtocolManager(node_id_seed=42)
        result = mgr.spatial_exclusion_check(
            node_pos=(0.0, 0.0), neighbor_pos=(5.0, 5.0)
        )
        assert result.valid is True
        assert result.zone in ("INNER", "NOMINAL", "OUTER")

    def test_spatial_exclusion_violation(self):
        """Spatial exclusion fails for nodes too close."""
        mgr = SovereignSwarmProtocolManager(node_id_seed=42)
        result = mgr.spatial_exclusion_check(
            node_pos=(0.0, 0.0), neighbor_pos=(0.1, 0.1)
        )
        assert result.valid is False
        assert result.zone == "VIOLATION"

    def test_spatial_exclusion_collision(self):
        """Spatial exclusion detects zero-distance collision."""
        mgr = SovereignSwarmProtocolManager(node_id_seed=42)
        result = mgr.spatial_exclusion_check(
            node_pos=(1.0, 1.0), neighbor_pos=(1.0, 1.0)
        )
        assert result.valid is False
        assert result.zone == "COLLISION"

    def test_fibonacci_quorum(self):
        """Fibonacci quorum returns correct threshold."""
        mgr = SovereignSwarmProtocolManager(node_id_seed=42)

        # Fleet of 10: ⌈10 × 0.618⌉ = 7 → nearest Fib ≥ 7 = 8
        result = mgr.fibonacci_quorum(fleet_size=10)
        assert result.quorum == 8
        assert result.fleet_size == 10

    def test_fibonacci_quorum_small(self):
        """Fibonacci quorum works for small fleets."""
        mgr = SovereignSwarmProtocolManager(node_id_seed=42)
        result = mgr.fibonacci_quorum(fleet_size=3)
        # ⌈3 × 0.618⌉ = 2 → nearest Fib ≥ 2 = 2
        assert result.quorum == 2

    def test_byzantine_fault_normal(self):
        """Byzantine fault detector does not flag normal nodes."""
        mgr = SovereignSwarmProtocolManager(node_id_seed=42)
        metrics = [10.0, 10.5, 9.8, 10.2, 10.1]
        result = mgr.byzantine_fault_check(node_metric=10.3, fleet_metrics=metrics)
        assert result["fault_detected"] is False

    def test_byzantine_fault_outlier(self):
        """Byzantine fault detector flags outlier nodes."""
        mgr = SovereignSwarmProtocolManager(node_id_seed=42)
        metrics = [10.0, 10.5, 9.8, 10.2, 10.1]
        result = mgr.byzantine_fault_check(node_metric=50.0, fleet_metrics=metrics)
        assert result["fault_detected"] is True

    def test_fibonacci_backoff(self):
        """Fibonacci backoff scales correctly."""
        mgr = SovereignSwarmProtocolManager(node_id_seed=42)

        # attempt 0: F(2) = 1 → 100ms
        r0 = mgr.fibonacci_backoff(attempt=0, base_ms=100)
        assert r0["delay_ms"] == 100

        # attempt 1: F(3) = 2 → 200ms
        r1 = mgr.fibonacci_backoff(attempt=1, base_ms=100)
        assert r1["delay_ms"] == 200

        # attempt 3: F(5) = 5 → 500ms
        r3 = mgr.fibonacci_backoff(attempt=3, base_ms=100)
        assert r3["delay_ms"] == 500

    def test_swarm_broadcast_targets(self):
        """Swarm broadcast produces valid relay targets."""
        mgr = SovereignSwarmProtocolManager(node_id_seed=42)
        result = mgr.swarm_broadcast_targets(source_index=0, fleet_size=20)

        assert result["proto"] == 273
        assert len(result["targets"]) > 0
        assert result["hops"] >= 1
        # No target should equal source
        assert 0 not in result["targets"]

    def test_swarm_broadcast_single_node(self):
        """Swarm broadcast handles single-node fleet."""
        mgr = SovereignSwarmProtocolManager(node_id_seed=42)
        result = mgr.swarm_broadcast_targets(source_index=0, fleet_size=1)
        assert result["targets"] == []

    def test_golden_epoch_window(self):
        """Golden epoch timer scales by φ^level."""
        mgr = SovereignSwarmProtocolManager(node_id_seed=42)
        w0 = mgr.golden_epoch_window(level=0)
        w1 = mgr.golden_epoch_window(level=1)
        w2 = mgr.golden_epoch_window(level=2)

        assert w0["window_ms"] == PHI_HEARTBEAT_MS
        assert abs(w1["window_ms"] - int(PHI_HEARTBEAT_MS * GOLDEN_RATIO)) <= 1
        assert abs(w2["window_ms"] - int(PHI_HEARTBEAT_MS * GOLDEN_RATIO ** 2)) <= 1
