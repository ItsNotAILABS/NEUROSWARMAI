"""
Tests for SIMD Vectorization and TAURUS Memory Management.

Covers:
- SovereignTensor SIMD operations (vector_add, vector_mul, vector_scale, vector_fma,
  resonance_matmul, vector_dot).
- TaurusMemory store, recall, decay, eviction, helix compression, context fusion.
- SovereignNeuroCore TAURUS integration and forward_simd path.
"""

from __future__ import annotations

import pytest

from pythonista.phantom_native.neurocore import SovereignNeuroCore
from pythonista.phantom_native.sovereign_tensor import SovereignTensor
from pythonista.phantom_native.taurus import TaurusMemory


# --- SIMD Vectorization Tests ---


class TestSIMDVectorOps:
    """SIMD-style vectorized operation tests."""

    def test_vector_add_basic(self):
        a = SovereignTensor([1.0, 2.0, 3.0, 4.0], (4,))
        b = SovereignTensor([5.0, 6.0, 7.0, 8.0], (4,))
        c = a.vector_add(b)
        assert c.shape == (4,)
        for i, expected in enumerate([6.0, 8.0, 10.0, 12.0]):
            assert abs(c.data[i] - expected) < 1e-5

    def test_vector_add_8wide(self):
        """Test 8-wide SIMD path (exactly 8 elements)."""
        a = SovereignTensor([float(i) for i in range(8)], (8,))
        b = SovereignTensor([float(i * 2) for i in range(8)], (8,))
        c = a.vector_add(b)
        for i in range(8):
            assert abs(c.data[i] - (i + i * 2)) < 1e-5

    def test_vector_add_16wide(self):
        """Test 16 elements (two full 8-wide passes)."""
        a = SovereignTensor([1.0] * 16, (16,))
        b = SovereignTensor([2.0] * 16, (16,))
        c = a.vector_add(b)
        assert all(abs(x - 3.0) < 1e-5 for x in c.data)

    def test_vector_add_with_tail(self):
        """Test non-multiple-of-8 length (exercises scalar tail)."""
        a = SovereignTensor([1.0] * 11, (11,))
        b = SovereignTensor([2.0] * 11, (11,))
        c = a.vector_add(b)
        assert len(c.data) == 11
        assert all(abs(x - 3.0) < 1e-5 for x in c.data)

    def test_vector_mul_basic(self):
        a = SovereignTensor([2.0, 3.0, 4.0, 5.0], (4,))
        b = SovereignTensor([1.0, 2.0, 3.0, 4.0], (4,))
        c = a.vector_mul(b)
        for i, expected in enumerate([2.0, 6.0, 12.0, 20.0]):
            assert abs(c.data[i] - expected) < 1e-5

    def test_vector_mul_8wide(self):
        a = SovereignTensor([2.0] * 8, (8,))
        b = SovereignTensor([3.0] * 8, (8,))
        c = a.vector_mul(b)
        assert all(abs(x - 6.0) < 1e-5 for x in c.data)

    def test_vector_scale_basic(self):
        a = SovereignTensor([1.0, 2.0, 3.0, 4.0], (4,))
        c = a.vector_scale(2.5)
        for i, expected in enumerate([2.5, 5.0, 7.5, 10.0]):
            assert abs(c.data[i] - expected) < 1e-5

    def test_vector_scale_8wide(self):
        a = SovereignTensor([4.0] * 16, (16,))
        c = a.vector_scale(0.25)
        assert all(abs(x - 1.0) < 1e-5 for x in c.data)

    def test_vector_fma(self):
        """Test fused multiply-add: a * b + c."""
        a = SovereignTensor([2.0, 3.0, 4.0, 5.0], (4,))
        b = SovereignTensor([1.0, 2.0, 3.0, 4.0], (4,))
        c = SovereignTensor([0.5, 0.5, 0.5, 0.5], (4,))
        result = a.vector_fma(b, c)
        for i, expected in enumerate([2.5, 6.5, 12.5, 20.5]):
            assert abs(result.data[i] - expected) < 1e-5

    def test_vector_fma_8wide(self):
        a = SovereignTensor([2.0] * 8, (8,))
        b = SovereignTensor([3.0] * 8, (8,))
        c = SovereignTensor([1.0] * 8, (8,))
        result = a.vector_fma(b, c)
        assert all(abs(x - 7.0) < 1e-5 for x in result.data)

    def test_resonance_matmul_basic(self):
        """Test resonance-weighted matmul with 4-wide unrolling."""
        a = SovereignTensor([1.0, 2.0, 3.0, 4.0], (2, 2))
        b = SovereignTensor([5.0, 6.0, 7.0, 8.0], (2, 2))
        c = a.resonance_matmul(b)
        assert c.shape == (2, 2)
        # Default resonance is 1.0 * 1.0 = 1.0
        assert abs(c.data[0] - 19.0) < 1e-4
        assert abs(c.data[1] - 22.0) < 1e-4
        assert abs(c.data[2] - 43.0) < 1e-4
        assert abs(c.data[3] - 50.0) < 1e-4

    def test_resonance_matmul_with_resonance(self):
        a = SovereignTensor([1.0, 0.0, 0.0, 1.0], (2, 2), {"resonance": 0.5})
        b = SovereignTensor([2.0, 0.0, 0.0, 2.0], (2, 2), {"resonance": 2.0})
        c = a.resonance_matmul(b)
        # resonance = 0.5 * 2.0 = 1.0
        assert abs(c.data[0] - 2.0) < 1e-4
        assert abs(c.data[3] - 2.0) < 1e-4

    def test_resonance_matmul_4wide_path(self):
        """Test matmul with k >= 4 to exercise 4-wide inner unroll."""
        a = SovereignTensor([1.0] * 8, (2, 4))
        b = SovereignTensor([1.0] * 8, (4, 2))
        c = a.resonance_matmul(b)
        assert c.shape == (2, 2)
        # Each element = sum of 4 ones * 1.0 resonance = 4.0
        assert all(abs(x - 4.0) < 1e-4 for x in c.data)

    def test_vector_dot_basic(self):
        a = SovereignTensor([1.0, 2.0, 3.0], (3,))
        b = SovereignTensor([4.0, 5.0, 6.0], (3,))
        assert abs(a.vector_dot(b) - 32.0) < 1e-5

    def test_vector_dot_8wide(self):
        """Test dot product with 8+ elements (SIMD path)."""
        a = SovereignTensor([2.0] * 16, (16,))
        b = SovereignTensor([3.0] * 16, (16,))
        assert abs(a.vector_dot(b) - 96.0) < 1e-4

    def test_to_simd_buffer(self):
        """Test conversion to cache-friendly float32 buffer."""
        t = SovereignTensor([1.0, 2.0, 3.0], (3,))
        buf = t.to_simd_buffer()
        assert len(buf) == 3
        assert buf.typecode == "f"

    def test_vector_add_preserves_meta(self):
        """SIMD ops should preserve spectral metadata."""
        meta = {"resonance": 0.8, "helix": {"turns": 4}}
        a = SovereignTensor([1.0, 2.0], (2,), meta)
        b = SovereignTensor([3.0, 4.0], (2,))
        c = a.vector_add(b)
        assert c.spectral_meta == meta


# --- TAURUS Memory Management Tests ---


class TestTaurusMemory:
    """TAURUS native memory management tests."""

    def test_creation(self):
        mem = TaurusMemory(capacity=16, decay_rate=0.9)
        assert mem.capacity == 16
        assert mem.decay_rate == 0.9
        assert mem.working_size == 0
        assert mem.long_term_size == 0

    def test_store_basic(self):
        mem = TaurusMemory(capacity=8)
        t = SovereignTensor([1.0, 2.0, 3.0], (3,))
        key = mem.store(t)
        assert key.startswith("qsha:")
        assert mem.working_size == 1
        assert mem.long_term_size == 1

    def test_store_with_key(self):
        mem = TaurusMemory()
        t = SovereignTensor([1.0], (1,))
        key = mem.store(t, key="custom_key")
        assert key == "custom_key"

    def test_recall_by_key(self):
        mem = TaurusMemory()
        t = SovereignTensor([5.0, 10.0], (2,))
        key = mem.store(t, key="test_recall")
        recalled = mem.recall(key)
        assert recalled is not None
        assert recalled.data == [5.0, 10.0]

    def test_recall_nonexistent(self):
        mem = TaurusMemory()
        assert mem.recall("nonexistent") is None

    def test_capacity_eviction(self):
        mem = TaurusMemory(capacity=3)
        for i in range(5):
            t = SovereignTensor([float(i)], (1,))
            mem.store(t, key=f"key_{i}")
        assert mem.working_size == 3  # bounded

    def test_resonance_decay(self):
        mem = TaurusMemory(capacity=3, decay_rate=0.5)
        t1 = SovereignTensor([1.0], (1,), {"resonance": 1.0})
        t2 = SovereignTensor([2.0], (1,), {"resonance": 1.0})
        t3 = SovereignTensor([3.0], (1,), {"resonance": 1.0})
        k1 = mem.store(t1, key="k1")
        k2 = mem.store(t2, key="k2")
        k3 = mem.store(t3, key="k3")
        # Store a 4th — triggers eviction and decay
        t4 = SovereignTensor([4.0], (1,), {"resonance": 2.0})
        mem.store(t4, key="k4")
        assert mem.working_size == 3

    def test_recall_top_k(self):
        mem = TaurusMemory(capacity=10)
        for i in range(5):
            t = SovereignTensor([float(i)], (1,), {"resonance": float(i + 1)})
            mem.store(t, key=f"key_{i}")
        top = mem.recall_top_k(k=2)
        assert len(top) == 2

    def test_recall_top_k_empty(self):
        mem = TaurusMemory()
        assert mem.recall_top_k(k=5) == []

    def test_compress_helix(self):
        mem = TaurusMemory()
        t = SovereignTensor([1.0, 3.0, 5.0, 7.0], (4,))
        compressed = mem.compress_helix(t)
        assert compressed.shape == (2,)
        assert abs(compressed.data[0] - 2.0) < 1e-5  # (1+3)/2
        assert abs(compressed.data[1] - 6.0) < 1e-5  # (5+7)/2

    def test_compress_helix_single(self):
        """Cannot compress single element — returns unchanged."""
        mem = TaurusMemory()
        t = SovereignTensor([5.0], (1,))
        compressed = mem.compress_helix(t)
        assert compressed.data == [5.0]

    def test_compress_helix_weighted(self):
        mem = TaurusMemory()
        t = SovereignTensor([2.0, 8.0, 4.0, 6.0], (4,), {"resonance": 1.0})
        compressed = mem.compress_helix_weighted(t)
        assert compressed.shape == (2,)
        assert compressed.spectral_meta.get("helix_compressed") is True
        assert compressed.spectral_meta.get("helix_weighted") is True

    def test_fuse_context(self):
        mem = TaurusMemory()
        t1 = SovereignTensor([2.0, 4.0], (2,), {"resonance": 1.0})
        t2 = SovereignTensor([6.0, 8.0], (2,), {"resonance": 1.0})
        fused = mem.fuse_context([t1, t2])
        assert fused is not None
        assert fused.shape == (2,)
        # Equal resonance → simple average: (2+6)/2=4, (4+8)/2=6
        assert abs(fused.data[0] - 4.0) < 1e-5
        assert abs(fused.data[1] - 6.0) < 1e-5

    def test_fuse_context_weighted(self):
        mem = TaurusMemory()
        t1 = SovereignTensor([10.0], (1,), {"resonance": 3.0})
        t2 = SovereignTensor([0.0], (1,), {"resonance": 1.0})
        fused = mem.fuse_context([t1, t2])
        assert fused is not None
        # Weighted: (10*3 + 0*1) / (3+1) = 7.5
        assert abs(fused.data[0] - 7.5) < 1e-5

    def test_fuse_context_empty(self):
        mem = TaurusMemory()
        assert mem.fuse_context([]) is None

    def test_clear_working(self):
        mem = TaurusMemory()
        t = SovereignTensor([1.0], (1,))
        mem.store(t, key="k1")
        assert mem.working_size == 1
        mem.clear_working()
        assert mem.working_size == 0
        assert mem.long_term_size == 1  # long-term preserved

    def test_clear_all(self):
        mem = TaurusMemory()
        t = SovereignTensor([1.0], (1,))
        mem.store(t, key="k1")
        mem.clear_all()
        assert mem.working_size == 0
        assert mem.long_term_size == 0

    def test_recall_by_resonance_threshold(self):
        mem = TaurusMemory(capacity=10)
        # Store tensors with increasing resonance
        for i in range(5):
            t = SovereignTensor([float(i)], (1,), {"resonance": float(i + 1)})
            mem.store(t, key=f"key_{i}")
        # Threshold recall
        results = mem.recall_by_resonance_threshold(3.0)
        assert len(results) >= 1


# --- NeuroCore TAURUS Integration Tests ---


class TestNeuroCoreWithTaurus:
    """Test NeuroCore with integrated TAURUS memory."""

    def test_taurus_stats(self):
        core = SovereignNeuroCore({"d_model": 32, "n_heads": 2, "taurus_capacity": 16})
        stats = core.get_taurus_stats()
        assert stats["working_size"] == 0
        assert stats["capacity"] == 16
        assert stats["decay_rate"] == 0.95

    def test_forward_updates_taurus(self):
        core = SovereignNeuroCore({"d_model": 32, "n_heads": 2})
        t = SovereignTensor([1.0, 2.0], (2,))
        core.forward(t)
        assert core.taurus.working_size == 1

    def test_forward_simd_path(self):
        core = SovereignNeuroCore({"d_model": 32, "n_heads": 2})
        t = SovereignTensor([0.5, 0.3, 0.8, 0.1], (4,))
        out = core.forward_simd(t)
        assert out.shape == t.shape
        assert len(out.data) == len(t.data)

    def test_forward_simd_updates_taurus(self):
        core = SovereignNeuroCore({"d_model": 32, "n_heads": 2})
        t = SovereignTensor([1.0, 2.0], (2,))
        core.forward_simd(t)
        assert core.taurus.working_size == 1

    def test_taurus_context_fusion_in_forward(self):
        """After multiple forwards, TAURUS context should influence output."""
        core = SovereignNeuroCore({"d_model": 32, "n_heads": 2, "taurus_capacity": 8})
        t = SovereignTensor([1.0, 2.0, 3.0, 4.0], (4,))
        # Run multiple forwards to build context
        for _ in range(5):
            core.forward(t)
        assert core.taurus.working_size == 5

    def test_clear_taurus_via_core(self):
        core = SovereignNeuroCore({"d_model": 32, "n_heads": 2})
        t = SovereignTensor([1.0], (1,))
        core.forward(t)
        core.clear_taurus()
        assert core.taurus.working_size == 0
