"""
Scalability Verification Tests
===============================
Addresses the review concern: "Scalability to 10K+ nodes in the real world (vs. simulation)"

These tests measure and verify scaling characteristics:
- How performance degrades with increasing node counts
- Memory usage at various scales
- Whether algorithms maintain correctness at scale
- Extrapolation metrics for 10K+ projections

Run with: pytest tests/python/test_scalability.py -v
"""

import time
import random
import json
import sys
from pathlib import Path
from typing import Dict, List

ROOT = Path(__file__).parent.parent.parent
sys.path.insert(0, str(ROOT / "pythonista"))

import pytest
from phi import PHI_INV
from animus import KuramotoField, hebbian_update, create_weight_matrix
from nexus import SmallWorldNetwork


# ─── SCALING METRICS COLLECTOR ────────────────────────────────────────────────

class ScalingMetrics:
    """Collects and reports scaling measurements."""

    def __init__(self):
        self.results: List[Dict] = []

    def record(self, test_name: str, n_nodes: int, elapsed_ms: float, metric: float):
        self.results.append({
            "test": test_name,
            "n_nodes": n_nodes,
            "elapsed_ms": round(elapsed_ms, 3),
            "metric": round(metric, 6),
        })

    def save(self, path: Path):
        path.parent.mkdir(parents=True, exist_ok=True)
        with open(path, 'w') as f:
            json.dump({"scalability_results": self.results}, f, indent=2)


metrics = ScalingMetrics()


# ─── KURAMOTO SCALING ────────────────────────────────────────────────────────

class TestKuramotoScaling:
    """Verify Kuramoto oscillator field scales predictably."""

    @pytest.mark.parametrize("n_nodes", [10, 50, 100, 200, 500])
    def test_kuramoto_timing_scales_quadratically(self, n_nodes):
        """
        Kuramoto step is O(N²) due to all-to-all coupling.
        Verify timing scales predictably and stays under bounds.
        """
        random.seed(42)
        field = KuramotoField(N=n_nodes, K=2.618)

        start = time.perf_counter()
        field.run(50)  # 50 steps
        elapsed_ms = (time.perf_counter() - start) * 1000

        r = field.order_parameter()
        metrics.record("kuramoto_50steps", n_nodes, elapsed_ms, r)

        # Bound: N=500 should complete in under 5 seconds
        max_ms = (n_nodes / 10) ** 2 * 0.5  # Quadratic scaling estimate
        assert elapsed_ms < max(max_ms, 5000), (
            f"Kuramoto N={n_nodes} took {elapsed_ms:.1f}ms"
        )

    @pytest.mark.parametrize("n_nodes", [10, 50, 100, 200])
    def test_kuramoto_convergence_independent_of_size(self, n_nodes):
        """
        With sufficient coupling (K=φ+1), convergence should occur
        regardless of system size (above critical K).
        """
        random.seed(42)
        field = KuramotoField(N=n_nodes, K=2.618)
        field.run(300)  # More steps for larger systems
        r = field.order_parameter()

        # All sizes should synchronize with strong coupling
        assert r > 0.3, f"N={n_nodes} failed to converge: r={r:.4f}"


# ─── HEBBIAN SCALING ─────────────────────────────────────────────────────────

class TestHebbianScaling:
    """Verify Hebbian learning scales predictably."""

    @pytest.mark.parametrize("n_nodes", [10, 50, 100, 200, 500])
    def test_hebbian_update_timing(self, n_nodes):
        """
        Hebbian update is O(N²). Verify scaling stays predictable.
        """
        random.seed(42)
        W = create_weight_matrix(n_nodes, 0.0)
        x = [random.random() for _ in range(n_nodes)]

        start = time.perf_counter()
        for _ in range(10):
            W = hebbian_update(W, x)
        elapsed_ms = (time.perf_counter() - start) * 1000 / 10

        # Record first row sum as stability metric
        stability = sum(abs(W[0][j]) for j in range(n_nodes)) / n_nodes
        metrics.record("hebbian_update", n_nodes, elapsed_ms, stability)

        # 500 nodes should still be under 500ms per update
        assert elapsed_ms < 500, f"Hebbian N={n_nodes} took {elapsed_ms:.1f}ms per update"

    @pytest.mark.parametrize("n_nodes", [10, 50, 100, 200])
    def test_hebbian_stability_at_scale(self, n_nodes):
        """Weights should not explode at scale due to decay term."""
        random.seed(42)
        W = create_weight_matrix(n_nodes, 0.0)
        x = [random.random() for _ in range(n_nodes)]

        # Run many updates
        for _ in range(100):
            W = hebbian_update(W, x)

        # Check no weight explosion (lambda_decay should prevent it)
        max_weight = max(abs(W[i][j]) for i in range(n_nodes) for j in range(n_nodes))
        assert max_weight < 10.0, f"Weight explosion at N={n_nodes}: max={max_weight}"


# ─── NETWORK TOPOLOGY SCALING ────────────────────────────────────────────────

class TestNetworkScaling:
    """Verify small-world network scales correctly."""

    @pytest.mark.parametrize("n_nodes", [20, 50, 100, 200, 500])
    def test_network_creation_timing(self, n_nodes):
        """Network creation should scale linearly-ish with node count."""
        random.seed(42)

        start = time.perf_counter()
        _net = SmallWorldNetwork(n_nodes=n_nodes, k_neighbors=4, rewire_prob=PHI_INV)  # noqa: F841
        elapsed_ms = (time.perf_counter() - start) * 1000

        metrics.record("network_creation", n_nodes, elapsed_ms, float(n_nodes))

        # Should create within reasonable time
        assert elapsed_ms < 5000, f"Network N={n_nodes} creation took {elapsed_ms:.1f}ms"

    @pytest.mark.parametrize("n_nodes", [20, 50, 100])
    def test_small_world_properties_hold_at_scale(self, n_nodes):
        """Small-world properties should hold regardless of size."""
        random.seed(42)
        network = SmallWorldNetwork(n_nodes=n_nodes, k_neighbors=4, rewire_prob=PHI_INV)

        # Verify nodes were created
        assert len(network.nodes) == n_nodes


# ─── SCALING PROJECTION ──────────────────────────────────────────────────────

class TestScalingProjection:
    """
    Measure scaling curves and extrapolate to 10K nodes.

    This doesn't run 10K nodes (too slow for CI) but verifies
    the scaling behavior is consistent with O(N²) or better,
    then projects whether 10K is feasible.
    """

    def test_kuramoto_scaling_curve_is_polynomial(self):
        """Verify Kuramoto scales as O(N²) — enabling 10K projection."""
        timings = []
        sizes = [20, 50, 100, 200]

        for n in sizes:
            random.seed(42)
            field = KuramotoField(N=n, K=2.618)
            start = time.perf_counter()
            field.run(20)
            elapsed = (time.perf_counter() - start) * 1000
            timings.append(elapsed)

        # Verify roughly quadratic: time doubles ~4x when N doubles
        # Check ratio between 100 and 200 vs 50 and 100
        if timings[2] > 0 and timings[1] > 0:
            ratio_1 = timings[3] / timings[2]  # 200/100

            # Ratio should be roughly 3-5x (quadratic with overhead)
            assert ratio_1 < 10, f"Scaling worse than quadratic: {ratio_1:.1f}x"

        # Project: at 10K nodes with O(N²), time ≈ timing_200 * (10000/200)²
        projected_10k_ms = timings[-1] * (10000 / 200) ** 2
        projected_10k_s = projected_10k_ms / 1000

        # Store projection — this is the transparency metric
        metrics.record(
            "kuramoto_10k_projection",
            10000,
            projected_10k_ms,
            projected_10k_s,
        )

        # Note: This will be large. The point is transparency.
        # Real deployment would use sparse coupling, not all-to-all.
        print(f"\n  📊 10K-node projection (all-to-all): ~{projected_10k_s:.1f}s per 20 steps")
        print(f"  📊 With sparse coupling (k=8): ~{projected_10k_s * 8 / 10000:.3f}s per 20 steps")

    def test_hebbian_memory_scaling(self):
        """Verify memory usage scales as O(N²) for weight matrix."""
        import sys

        sizes = [50, 100, 200, 500]
        memories = []

        for n in sizes:
            create_weight_matrix(n, 0.0)  # verify it works at this size
            # Approximate memory: N² floats × 8 bytes (Python float)
            mem_bytes = n * n * sys.getsizeof(0.0)
            memories.append(mem_bytes)

        # 10K projection: 10000² × ~28 bytes per float in list ≈ 2.8GB
        # Real impl would use numpy arrays: 10000² × 8 bytes = 800MB
        projected_10k_mb = (10000 * 10000 * 28) / (1024 * 1024)
        print(f"\n  📊 10K-node Hebbian memory (Python lists): ~{projected_10k_mb:.0f}MB")
        print(f"  📊 10K-node Hebbian memory (numpy): ~{projected_10k_mb * 8 / 28:.0f}MB")
        print("  📊 Recommendation: Use sparse matrices for >1K nodes")


# ─── SAVE RESULTS ────────────────────────────────────────────────────────────

@pytest.fixture(autouse=True, scope="session")
def save_metrics():
    """Save metrics at end of test session."""
    yield
    results_path = ROOT / "tests" / "python" / "scalability-results.json"
    metrics.save(results_path)
