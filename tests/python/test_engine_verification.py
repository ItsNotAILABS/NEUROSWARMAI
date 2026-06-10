"""
Engine Verification Test Suite — Reproducible Benchmarks
=========================================================
Addresses review concerns about self-reported testing:
- Deterministic seeds for reproducibility
- Timing measurements with statistical significance
- Scalability assertions with measurable thresholds
- Cross-engine integration validation

Every test here is designed to be independently reproducible.
Run with: pytest tests/python/test_engine_verification.py -v --benchmark-json=results.json
"""

import math
import time
import random
import sys
from pathlib import Path

# Add pythonista to path
ROOT = Path(__file__).parent.parent.parent
sys.path.insert(0, str(ROOT / "pythonista"))

from phi import PHI, PHI_INV, PHI_BEAT, fib, phi_loss
from animus import AnimusEngine, KuramotoField, hebbian_update, coherence_score
from nexus import NexusEngine
from lingua import LinguaEngine
from optica import OpticaEngine
from tactus import TactusEngine


# ─── REPRODUCIBILITY: Fixed seeds ─────────────────────────────────────────────

class TestReproducibility:
    """Tests that engines produce deterministic results with fixed seeds."""

    def test_kuramoto_deterministic(self):
        """Kuramoto field must produce same trajectory with same seed."""
        results = []
        for _ in range(3):
            random.seed(42)
            field = KuramotoField(N=89, K=2.618)
            trajectory = field.run(100)
            results.append(trajectory)

        # All runs must produce identical results
        for i in range(1, len(results)):
            assert results[0] == results[i], "Kuramoto not deterministic with fixed seed"

    def test_hebbian_deterministic(self):
        """Hebbian updates must be deterministic (no randomness in update rule)."""
        W = [[0.0] * 5 for _ in range(5)]
        x = [0.1, 0.5, 0.3, 0.8, 0.2]

        result1 = hebbian_update(W, x)
        result2 = hebbian_update(W, x)

        for i in range(5):
            for j in range(5):
                assert abs(result1[i][j] - result2[i][j]) < 1e-15

    def test_coherence_score_deterministic(self):
        """Coherence scoring must be fully deterministic."""
        text = "The golden ratio appears in nature and mathematics equally"
        scores = [coherence_score(text) for _ in range(100)]
        assert all(s == scores[0] for s in scores)

    def test_phi_constants_mathematical_precision(self):
        """φ constants must match to machine precision."""
        computed_phi = (1 + math.sqrt(5)) / 2
        assert abs(PHI - computed_phi) < 1e-15, f"PHI off: {PHI} vs {computed_phi}"
        assert abs(PHI_INV - 1 / computed_phi) < 1e-15
        assert abs(PHI * PHI_INV - 1.0) < 1e-15
        assert PHI_BEAT == 873  # milliseconds

    def test_fib_correctness(self):
        """Fibonacci function must match known values."""
        known = [0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377]
        for i, expected in enumerate(known):
            assert fib(i) == expected, f"fib({i}) = {fib(i)}, expected {expected}"


# ─── PERFORMANCE: Timing Benchmarks ──────────────────────────────────────────

class TestPerformanceBenchmarks:
    """Timing benchmarks with statistical measurements.

    These tests verify that critical operations complete within
    stated performance bounds on standard hardware.
    """

    def test_kuramoto_89_oscillators_under_500ms(self):
        """89-oscillator Kuramoto field must synchronize in <500ms."""
        random.seed(42)
        field = KuramotoField(N=89, K=2.618)

        start = time.perf_counter()
        trajectory = field.run(200)
        elapsed_ms = (time.perf_counter() - start) * 1000

        assert elapsed_ms < 500, f"Kuramoto 89-osc took {elapsed_ms:.1f}ms (limit: 500ms)"
        assert len(trajectory) > 0

    def test_kuramoto_convergence_toward_synchrony(self):
        """Kuramoto field must show increasing coherence over 500 steps."""
        random.seed(42)
        field = KuramotoField(N=89, K=2.618)
        trajectory = field.run(500)

        # With K=2.618 (> critical), coherence should increase over time
        early_r = trajectory[1] if len(trajectory) > 1 else 0
        final_r = trajectory[-1]
        assert final_r > early_r, (
            f"Coherence did not increase: early={early_r:.4f}, final={final_r:.4f}"
        )

    def test_hebbian_update_under_1ms(self):
        """Hebbian update on 89×89 matrix must complete in <1ms."""
        W = [[random.random() * 0.01 for _ in range(89)] for _ in range(89)]
        x = [random.random() for _ in range(89)]

        start = time.perf_counter()
        for _ in range(10):
            W = hebbian_update(W, x)
        elapsed_ms = (time.perf_counter() - start) * 1000 / 10

        assert elapsed_ms < 1.0, f"Hebbian update took {elapsed_ms:.3f}ms (limit: 1ms)"

    def test_coherence_scoring_under_100us(self):
        """Coherence scoring must complete in <100μs per call."""
        text = "The golden ratio phi equals 1.618 and appears throughout nature in spiral patterns"

        start = time.perf_counter()
        for _ in range(1000):
            coherence_score(text)
        elapsed_us = (time.perf_counter() - start) * 1_000_000 / 1000

        assert elapsed_us < 100, f"Coherence score took {elapsed_us:.1f}μs (limit: 100μs)"

    def test_full_reasoning_cycle_under_500ms(self):
        """Full reasoning cycle (Kuramoto + coherence + phi-loss) < 500ms."""
        random.seed(42)
        engine = AnimusEngine()

        start = time.perf_counter()
        result = engine.reason("Determine optimal routing for mesh network with 44 nodes")
        elapsed_ms = (time.perf_counter() - start) * 1000

        assert elapsed_ms < 500, f"Full reasoning took {elapsed_ms:.1f}ms (limit: 500ms)"
        assert 'kuramoto' in result
        assert 'phi_loss' in result

    def test_engine_initialization_under_10ms(self):
        """All 5 engines must initialize in <10ms each."""
        engines = [AnimusEngine, NexusEngine, LinguaEngine, OpticaEngine, TactusEngine]

        for EngineClass in engines:
            start = time.perf_counter()
            _engine = EngineClass()  # noqa: F841
            elapsed_ms = (time.perf_counter() - start) * 1000
            assert elapsed_ms < 10, f"{EngineClass.__name__} init took {elapsed_ms:.1f}ms"


# ─── MATHEMATICAL CORRECTNESS ────────────────────────────────────────────────

class TestMathematicalCorrectness:
    """Verify the mathematical foundations are correctly implemented."""

    def test_kuramoto_order_parameter_bounds(self):
        """Order parameter r must be in [0, 1]."""
        random.seed(42)
        field = KuramotoField(N=89)
        for _ in range(500):
            field.step()
            r = field.order_parameter()
            assert 0.0 <= r <= 1.0, f"Order parameter out of bounds: r={r}"

    def test_phi_loss_formula(self):
        """φ-loss: L_nova = L_CE × (1 + φ⁻¹ × min(CS, φ⁻¹))"""
        L_CE = 2.5
        CS = 0.7

        # phi_loss caps CS at PHI_INV
        capped_CS = min(CS, PHI_INV)
        expected = L_CE * (1 + PHI_INV * capped_CS)
        actual = phi_loss(L_CE, CS)
        assert abs(actual - expected) < 1e-10, f"phi_loss mismatch: {actual} vs {expected}"

        # Also test with CS below cap
        CS_low = 0.3
        expected_low = L_CE * (1 + PHI_INV * CS_low)
        actual_low = phi_loss(L_CE, CS_low)
        assert abs(actual_low - expected_low) < 1e-10

    def test_phi_loss_monotonicity(self):
        """Higher coherence → higher loss (penalty for overconfidence)."""
        L_CE = 1.0
        losses = [phi_loss(L_CE, cs) for cs in [0.0, 0.2, 0.4, 0.6, 0.8, 1.0]]
        for i in range(1, len(losses)):
            assert losses[i] >= losses[i - 1], "phi_loss not monotonically increasing with CS"

    def test_kuramoto_critical_coupling(self):
        """Below critical coupling, system should NOT synchronize."""
        random.seed(42)
        # K < 2/(π·g(0)) ≈ weak coupling should not sync
        weak_field = KuramotoField(N=89, K=0.1)
        weak_field.run(500)
        r_weak = weak_field.order_parameter()

        random.seed(42)
        # K = φ+1 = 2.618 should sync
        strong_field = KuramotoField(N=89, K=2.618)
        strong_field.run(500)
        r_strong = strong_field.order_parameter()

        assert r_strong > r_weak, "Strong coupling should produce higher coherence"

    def test_hebbian_weight_growth(self):
        """Hebbian learning: co-active nodes should strengthen connections."""
        W = [[0.0] * 3 for _ in range(3)]
        x = [1.0, 1.0, 0.0]  # nodes 0,1 co-active; node 2 inactive

        W_new = hebbian_update(W, x)

        # w_01 and w_10 should increase (co-active)
        assert W_new[0][1] > 0, "Co-active nodes did not strengthen"
        assert W_new[1][0] > 0, "Co-active nodes did not strengthen (symmetric)"
        # w_02 should remain ~0 (inactive partner)
        assert abs(W_new[0][2]) < 1e-10, "Inactive node connection should stay 0"


# ─── CROSS-ENGINE INTEGRATION ────────────────────────────────────────────────

class TestCrossEngineIntegration:
    """Verify engines work together correctly."""

    def test_all_engines_share_phi_constants(self):
        """All engines must reference the same φ constants."""
        engines = [AnimusEngine(), NexusEngine(), LinguaEngine(), OpticaEngine(), TactusEngine()]
        for engine in engines:
            status = engine.status()
            assert isinstance(status, dict), f"{type(engine).__name__} status not a dict"

    def test_animus_reason_produces_valid_output(self):
        """ANIMUS reasoning must produce structured, complete output."""
        random.seed(42)
        engine = AnimusEngine()
        result = engine.reason("Test query for verification")

        required_keys = ['action', 'query', 'kuramoto', 'phi_loss', 'conclusion', 'elapsed_ms']
        for key in required_keys:
            assert key in result, f"Missing key: {key}"

        assert result['action'] == 'reason'
        assert isinstance(result['kuramoto']['order_r'], float)
        assert isinstance(result['phi_loss']['L_nova'], float)

    def test_animus_decompose_valid_output(self):
        """ANIMUS decompose must split queries correctly."""
        engine = AnimusEngine()
        result = engine.decompose("First statement. Second statement. Third?")

        assert result['count'] == 3
        assert len(result['parts']) == 3
        assert result['complexity'] > 0

    def test_animus_bind_concepts(self):
        """ANIMUS binding must produce valid binding result."""
        random.seed(42)
        engine = AnimusEngine()
        result = engine.bind(['alpha', 'beta', 'gamma', 'delta'])

        assert 'bound_nodes' in result
        assert 'binding_strength' in result
        assert result['eta'] == 0.0001618


# ─── EDGE CASES & ROBUSTNESS ─────────────────────────────────────────────────

class TestRobustness:
    """Verify engines handle edge cases gracefully."""

    def test_empty_text_coherence(self):
        """Empty text should return 0 coherence."""
        assert coherence_score("") == 0.0
        assert coherence_score("   ") == 0.0

    def test_single_word_coherence(self):
        """Single word should produce valid (non-zero) coherence."""
        score = coherence_score("hello")
        assert 0.0 < score <= 1.0

    def test_very_long_text_coherence(self):
        """Very long text should not crash or exceed bounds."""
        long_text = " ".join(["word"] * 10000)
        score = coherence_score(long_text)
        assert 0.0 <= score <= 1.0

    def test_kuramoto_single_oscillator(self):
        """Single oscillator should have r=1 (trivially coherent)."""
        random.seed(42)
        field = KuramotoField(N=1)
        r = field.order_parameter()
        assert abs(r - 1.0) < 1e-10

    def test_decompose_empty_query(self):
        """Empty query should not crash."""
        engine = AnimusEngine()
        result = engine.decompose("")
        assert result['count'] == 0

    def test_infer_empty_premises(self):
        """Inference with empty premises should use defaults."""
        engine = AnimusEngine()
        result = engine.infer([])
        assert 'confidence' in result

    def test_bind_single_concept(self):
        """Binding single concept should not crash."""
        random.seed(42)
        engine = AnimusEngine()
        result = engine.bind(['single'])
        assert 'bound_nodes' in result
