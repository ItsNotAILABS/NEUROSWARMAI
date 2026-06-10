"""
Tests for Phantom Native — Sovereign NeuroRuntime.

Covers:
- SovereignTensor creation, arithmetic, MESIE ingestion, QSHA binding.
- SovereignNeuroCore forward pass, TAURUS memory, helix weights.
- SovereignSwarmRuntime spawning, execution, commitments, zeroization.
"""

from __future__ import annotations

import pytest

from pythonista.phantom_native.neurocore import SovereignNeuroCore
from pythonista.phantom_native.sovereign_tensor import SovereignTensor
from pythonista.phantom_native.swarm_runtime import SovereignSwarmRuntime


# --- SovereignTensor Tests ---


class TestSovereignTensor:
    """SovereignTensor core operations."""

    def test_creation_and_shape(self):
        t = SovereignTensor([1.0, 2.0, 3.0, 4.0], (2, 2))
        assert t.shape == (2, 2)
        assert t.size == 4
        assert t.ndim == 2

    def test_shape_mismatch_raises(self):
        with pytest.raises(AssertionError):
            SovereignTensor([1.0, 2.0], (3, 3))

    def test_add(self):
        a = SovereignTensor([1.0, 2.0, 3.0], (3,))
        b = SovereignTensor([4.0, 5.0, 6.0], (3,))
        c = a.add(b)
        assert c.data == [5.0, 7.0, 9.0]

    def test_sub(self):
        a = SovereignTensor([10.0, 20.0], (2,))
        b = SovereignTensor([3.0, 7.0], (2,))
        c = a.sub(b)
        assert c.data == [7.0, 13.0]

    def test_scale(self):
        t = SovereignTensor([2.0, 4.0], (2,))
        s = t.scale(3.0)
        assert s.data == [6.0, 12.0]

    def test_hadamard(self):
        a = SovereignTensor([2.0, 3.0], (2,))
        b = SovereignTensor([4.0, 5.0], (2,))
        c = a.hadamard(b)
        assert c.data == [8.0, 15.0]

    def test_matmul(self):
        a = SovereignTensor([1.0, 2.0, 3.0, 4.0], (2, 2))
        b = SovereignTensor([5.0, 6.0, 7.0, 8.0], (2, 2))
        c = a.matmul(b)
        assert c.shape == (2, 2)
        assert c.data == [19.0, 22.0, 43.0, 50.0]

    def test_matmul_resonance_weighting(self):
        a = SovereignTensor([1.0, 0.0, 0.0, 1.0], (2, 2), {"resonance": 0.5})
        b = SovereignTensor([2.0, 0.0, 0.0, 2.0], (2, 2), {"resonance": 2.0})
        c = a.matmul(b)
        # resonance = 0.5 * 2.0 = 1.0, so identity matmul * 1.0
        assert c.data == [2.0, 0.0, 0.0, 2.0]

    def test_transpose(self):
        t = SovereignTensor([1.0, 2.0, 3.0, 4.0, 5.0, 6.0], (2, 3))
        tr = t.transpose()
        assert tr.shape == (3, 2)
        assert tr.data == [1.0, 4.0, 2.0, 5.0, 3.0, 6.0]

    def test_dot(self):
        a = SovereignTensor([1.0, 2.0, 3.0], (3,))
        b = SovereignTensor([4.0, 5.0, 6.0], (3,))
        assert a.dot(b) == 32.0

    def test_relu(self):
        t = SovereignTensor([-1.0, 0.0, 1.0, -0.5], (4,))
        r = t.relu()
        assert r.data == [0.0, 0.0, 1.0, 0.0]

    def test_softmax_sums_to_one(self):
        t = SovereignTensor([1.0, 2.0, 3.0], (3,))
        s = t.softmax()
        assert abs(sum(s.data) - 1.0) < 1e-7

    def test_quantize_dequantize(self):
        t = SovereignTensor([0.5, -0.5, 1.0, -1.0], (4,))
        q = t.quantize_int8()
        d = q.dequantize()
        for orig, recovered in zip(t.data, d.data):
            assert abs(orig - recovered) < 0.01

    def test_from_mesie_component(self):
        comp = {
            "frequency": [440.0, 880.0],
            "amplitude": [0.8, 0.6],
            "element_weight": 0.9,
            "node_id": "node_abc",
        }
        t = SovereignTensor.from_mesie_component(comp)
        assert t.shape == (2,)
        assert t.data == [0.8, 0.6]
        assert t.resonance_score == 0.9

    def test_to_bytes_deterministic(self):
        t = SovereignTensor([1.0, 2.0, 3.0], (3,))
        assert t.to_bytes() == t.to_bytes()  # deterministic

    def test_from_bytes_roundtrip(self):
        t = SovereignTensor([1.5, 2.5, 3.5, 4.5], (2, 2))
        raw = t.to_bytes()
        recovered = SovereignTensor.from_bytes(raw, (2, 2))
        assert recovered.data == t.data

    def test_qsha_commitment_stable(self):
        t = SovereignTensor([1.0, 2.0], (2,))
        c1 = t.to_qsha_commitment()
        c2 = t.to_qsha_commitment()
        assert c1 == c2
        assert len(c1) == 64  # hex-encoded 32 bytes

    def test_l2_norm(self):
        t = SovereignTensor([3.0, 4.0], (2,))
        assert abs(t.l2_norm() - 5.0) < 1e-7

    def test_zeros_and_ones(self):
        z = SovereignTensor.zeros((3, 3))
        assert all(x == 0.0 for x in z.data)
        o = SovereignTensor.ones((2, 2))
        assert all(x == 1.0 for x in o.data)


# --- SovereignNeuroCore Tests ---


class TestSovereignNeuroCore:
    """NeuroCore driver tests."""

    def test_creation(self):
        core = SovereignNeuroCore({"d_model": 64, "n_heads": 4})
        assert core.d_model == 64
        assert core.n_heads == 4
        assert core.head_dim == 16

    def test_helix_weights_deterministic(self):
        c1 = SovereignNeuroCore({"d_model": 32, "n_heads": 2})
        c2 = SovereignNeuroCore({"d_model": 32, "n_heads": 2})
        assert c1.weights["query"] == c2.weights["query"]
        assert c1.weights["key"] == c2.weights["key"]

    def test_forward_produces_output(self):
        core = SovereignNeuroCore({"d_model": 64, "n_heads": 4})
        t = SovereignTensor([0.5, 0.3], (2,))
        out = core.forward(t)
        assert out.shape == t.shape
        assert len(out.data) == len(t.data)

    def test_taurus_memory_accumulates(self):
        core = SovereignNeuroCore({"d_model": 32, "n_heads": 2, "taurus_capacity": 5})
        t = SovereignTensor([1.0, 2.0, 3.0], (3,))
        for _ in range(7):
            core.forward(t)
        assert len(core.taurus_memory) == 5  # bounded

    def test_clear_taurus(self):
        core = SovereignNeuroCore({"d_model": 32, "n_heads": 2})
        t = SovereignTensor([1.0], (1,))
        core.forward(t)
        assert len(core.taurus_memory) == 1
        core.clear_taurus()
        assert len(core.taurus_memory) == 0


# --- SovereignSwarmRuntime Tests ---


class TestSovereignSwarmRuntime:
    """Swarm runtime orchestration tests."""

    def test_spawn_neuronet(self):
        runtime = SovereignSwarmRuntime()
        cid = runtime.spawn_neuronet({"d_model": 64, "n_heads": 4})
        assert len(cid) == 64  # QSHA hex hash
        assert runtime.swarm_size == 1

    def test_spawn_deterministic_id(self):
        r1 = SovereignSwarmRuntime()
        r2 = SovereignSwarmRuntime()
        config = {"d_model": 128, "n_heads": 8}
        assert r1.spawn_neuronet(config) == r2.spawn_neuronet(config)

    def test_execute_spectrum(self):
        runtime = SovereignSwarmRuntime()
        runtime.spawn_neuronet({"d_model": 64, "n_heads": 4})
        spectrum = {"frequency": [100.0], "amplitude": [0.7], "element_weight": 1.0}
        proof = runtime.execute_spectrum(spectrum)
        assert "commitment" in proof
        assert "receipt_hash" in proof
        assert proof["swarm_size"] == 1
        assert proof["latency_ms"] > 0

    def test_execute_sealed_intent(self):
        runtime = SovereignSwarmRuntime()
        runtime.spawn_neuronet({"d_model": 32, "n_heads": 2})
        sealed = b"\x01\x02\x03\x04" * 32
        proof = runtime.execute_sealed_intent(sealed)
        assert proof["sealed"] is True
        assert "commitment" in proof

    def test_manifest_commitment(self):
        runtime = SovereignSwarmRuntime()
        runtime.spawn_neuronet({"d_model": 32, "n_heads": 2})
        c = runtime.get_manifest_commitment()
        assert len(c) == 64

    def test_zeroize_core(self):
        runtime = SovereignSwarmRuntime()
        cid = runtime.spawn_neuronet({"d_model": 32, "n_heads": 2})
        assert runtime.zeroize_core(cid) is True
        assert runtime.swarm_size == 0

    def test_zeroize_nonexistent(self):
        runtime = SovereignSwarmRuntime()
        assert runtime.zeroize_core("fake_id") is False

    def test_zeroize_all(self):
        runtime = SovereignSwarmRuntime()
        runtime.spawn_neuronet({"d_model": 32, "n_heads": 2})
        runtime.spawn_neuronet({"d_model": 64, "n_heads": 4})
        runtime.zeroize_all()
        assert runtime.swarm_size == 0

    def test_multi_core_execution(self):
        runtime = SovereignSwarmRuntime()
        runtime.spawn_neuronet({"d_model": 32, "n_heads": 2})
        runtime.spawn_neuronet({"d_model": 64, "n_heads": 4})
        spectrum = {"amplitude": [0.5, 0.5], "element_weight": 1.0}
        proof = runtime.execute_spectrum(spectrum)
        assert proof["swarm_size"] == 2
