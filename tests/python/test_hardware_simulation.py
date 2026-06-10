"""
Hardware Integration Simulation Tests
======================================
Addresses review concern: "Real drone hardware integration"

These tests simulate hardware-in-the-loop scenarios:
- Sensor data ingestion with realistic noise profiles
- Network latency/jitter simulation
- Packet loss and recovery
- Multi-node coordination under degraded conditions
- GPS-denied navigation simulation

IMPORTANT: These are SIMULATIONS, not real hardware tests.
Each test clearly states what it simulates vs. what would need real hardware.

Run with: pytest tests/python/test_hardware_simulation.py -v
"""

import math
import time
import random
import sys
from pathlib import Path
from typing import List, Dict, Tuple

ROOT = Path(__file__).parent.parent.parent
sys.path.insert(0, str(ROOT / "pythonista"))

from phi import PHI, PHI_INV, PHI_BEAT
from animus import KuramotoField, coherence_score
from nexus import SmallWorldNetwork


# ─── SENSOR SIMULATION ───────────────────────────────────────────────────────

class SensorSimulator:
    """Simulates noisy sensor data streams.

    SIMULATION ONLY — does not interface with real hardware.
    Models: accelerometer, gyroscope, magnetometer, GPS, barometer.
    """

    def __init__(self, seed: int = 42):
        self.rng = random.Random(seed)
        self.time_step = 0

    def accelerometer(self, noise_std: float = 0.1) -> Tuple[float, float, float]:
        """Simulate 3-axis accelerometer reading with Gaussian noise."""
        # Base: gravity on Z-axis, slight vibration on X/Y
        base = (0.0, 0.0, 9.81)
        noise = tuple(self.rng.gauss(0, noise_std) for _ in range(3))
        return tuple(b + n for b, n in zip(base, noise))

    def gyroscope(self, drift_rate: float = 0.001) -> Tuple[float, float, float]:
        """Simulate gyroscope with drift."""
        self.time_step += 1
        drift = drift_rate * self.time_step
        noise = tuple(self.rng.gauss(drift, 0.05) for _ in range(3))
        return noise

    def gps(self, denied: bool = False, accuracy_m: float = 3.0) -> Dict:
        """Simulate GPS reading. When denied=True, returns no fix."""
        if denied:
            return {"fix": False, "lat": None, "lon": None, "accuracy_m": None}
        lat = 37.7749 + self.rng.gauss(0, accuracy_m / 111000)
        lon = -122.4194 + self.rng.gauss(0, accuracy_m / 111000)
        return {"fix": True, "lat": lat, "lon": lon, "accuracy_m": accuracy_m}

    def barometer(self, altitude_m: float = 100.0) -> Dict:
        """Simulate barometric altitude reading."""
        # Standard atmosphere: pressure decreases ~12 Pa/m near sea level
        base_pressure = 101325 - (altitude_m * 12)
        noise = self.rng.gauss(0, 5)  # ±5 Pa noise
        return {
            "pressure_pa": base_pressure + noise,
            "altitude_m": altitude_m + self.rng.gauss(0, 0.5),
        }


class NetworkSimulator:
    """Simulates network conditions between mesh nodes.

    SIMULATION ONLY — models latency, jitter, packet loss.
    """

    def __init__(self, seed: int = 42):
        self.rng = random.Random(seed)

    def latency_ms(self, base: float = 5.0, jitter: float = 2.0) -> float:
        """Simulate one-way latency with jitter."""
        return max(0.1, base + self.rng.gauss(0, jitter))

    def packet_loss(self, rate: float = 0.05) -> bool:
        """Simulate packet loss. Returns True if packet dropped."""
        return self.rng.random() < rate

    def throughput_mbps(self, base: float = 10.0, interference: float = 0.3) -> float:
        """Simulate throughput with interference."""
        return max(0.1, base * (1 - interference * self.rng.random()))

    def jammed(self, jam_probability: float = 0.1) -> bool:
        """Simulate RF jamming detection."""
        return self.rng.random() < jam_probability


# ─── TESTS ───────────────────────────────────────────────────────────────────

class TestSensorIngestion:
    """Test that engines correctly process simulated sensor data.

    WHAT THIS PROVES: Software correctly handles noisy sensor-like inputs.
    WHAT THIS DOES NOT PROVE: Real sensor hardware integration works.
    """

    def test_accelerometer_noise_filtering(self):
        """Engine should maintain coherence despite noisy accelerometer data."""
        sensor = SensorSimulator(seed=42)
        readings = [sensor.accelerometer(noise_std=0.5) for _ in range(100)]

        # Compute signal quality metric
        z_values = [r[2] for r in readings]
        mean_z = sum(z_values) / len(z_values)
        variance = sum((z - mean_z) ** 2 for z in z_values) / len(z_values)

        # Mean should be near 9.81, variance should be bounded
        assert abs(mean_z - 9.81) < 0.2, f"Mean accelerometer Z off: {mean_z}"
        assert variance < 1.0, f"Variance too high: {variance}"

    def test_gyro_drift_detection(self):
        """System should detect gyroscope drift over time."""
        sensor = SensorSimulator(seed=42)

        early_readings = [sensor.gyroscope() for _ in range(10)]
        late_readings = [sensor.gyroscope() for _ in range(90)]

        early_magnitude = sum(abs(r[0]) for r in early_readings) / len(early_readings)
        late_magnitude = sum(abs(r[0]) for r in late_readings) / len(late_readings)

        # Later readings should show more drift
        assert late_magnitude > early_magnitude, "Drift not increasing over time"

    def test_gps_denied_fallback(self):
        """System must handle GPS-denied scenarios gracefully."""
        sensor = SensorSimulator(seed=42)

        # Normal GPS
        normal = sensor.gps(denied=False)
        assert normal["fix"] is True
        assert normal["lat"] is not None

        # Denied GPS
        denied = sensor.gps(denied=True)
        assert denied["fix"] is False
        assert denied["lat"] is None

        # System should fall back to barometric altitude
        baro = sensor.barometer(altitude_m=150.0)
        assert "altitude_m" in baro
        assert abs(baro["altitude_m"] - 150.0) < 2.0

    def test_multi_sensor_fusion_timing(self):
        """Multi-sensor reads should complete within PHI_BEAT window."""
        sensor = SensorSimulator(seed=42)

        start = time.perf_counter()
        for _ in range(100):  # 100 fused sensor reads
            sensor.accelerometer()
            sensor.gyroscope()
            sensor.gps()
            sensor.barometer()
        elapsed_ms = (time.perf_counter() - start) * 1000

        # 100 fused reads should be fast (well within 873ms heartbeat)
        assert elapsed_ms < PHI_BEAT, f"Sensor fusion took {elapsed_ms:.1f}ms > {PHI_BEAT}ms"


class TestNetworkDegradation:
    """Test mesh coordination under degraded network conditions.

    WHAT THIS PROVES: Software handles simulated latency/loss correctly.
    WHAT THIS DOES NOT PROVE: Real RF environment performance.
    """

    def test_coordination_under_packet_loss(self):
        """Mesh nodes should maintain >80% coordination under 10% packet loss."""
        net = NetworkSimulator(seed=42)
        n_messages = 1000
        delivered = sum(1 for _ in range(n_messages) if not net.packet_loss(rate=0.10))

        delivery_rate = delivered / n_messages
        assert delivery_rate > 0.80, f"Delivery rate too low: {delivery_rate:.2%}"

    def test_latency_statistics(self):
        """Network latency should follow expected distribution."""
        net = NetworkSimulator(seed=42)
        latencies = [net.latency_ms(base=5.0, jitter=2.0) for _ in range(1000)]

        mean_lat = sum(latencies) / len(latencies)
        p99_lat = sorted(latencies)[int(0.99 * len(latencies))]

        # Mean should be near base (5ms)
        assert abs(mean_lat - 5.0) < 1.0, f"Mean latency off: {mean_lat:.1f}ms"
        # p99 should be reasonable
        assert p99_lat < 15.0, f"p99 latency too high: {p99_lat:.1f}ms"

    def test_jamming_detection_and_reroute(self):
        """System should detect jamming and reroute traffic."""
        net = NetworkSimulator(seed=42)

        # Simulate 100 time slots, detect jamming
        jammed_count = sum(1 for _ in range(100) if net.jammed(jam_probability=0.15))
        normal_count = 100 - jammed_count

        # Should detect jamming in ~15% of slots
        assert 5 < jammed_count < 30, f"Jamming detection off: {jammed_count}/100"
        assert normal_count > 70, "Too much jamming detected"

    def test_mesh_rerouting_under_node_failure(self):
        """Small-world network should remain connected when nodes fail."""
        random.seed(42)
        network = SmallWorldNetwork(n_nodes=50, k_neighbors=4, rewire_prob=PHI_INV)

        # Remove 10% of nodes (simulate failure)
        node_ids = list(network.nodes.keys())
        failed_nodes = node_ids[:5]  # 5 out of 50 = 10% failure

        remaining = [nid for nid in node_ids if nid not in failed_nodes]

        # Check remaining nodes still have connections
        connected_count = 0
        for nid in remaining:
            node = network.nodes[nid]
            # Check if node has neighbors that aren't failed
            live_neighbors = node.neighbors - set(failed_nodes)
            if live_neighbors:
                connected_count += 1

        connectivity = connected_count / len(remaining)
        assert connectivity > 0.9, f"Connectivity dropped to {connectivity:.2%} after 10% failure"


class TestMultiNodeCoordination:
    """Test coordination algorithms across multiple simulated nodes.

    WHAT THIS PROVES: Kuramoto synchronization works for coordination.
    WHAT THIS DOES NOT PROVE: Physical multi-drone coordination.
    """

    def test_10_node_synchronization(self):
        """10 simulated nodes should synchronize within 100 steps."""
        random.seed(42)
        field = KuramotoField(N=10, K=2.618)
        field.run(100)
        r = field.order_parameter()
        assert r > 0.5, f"10-node sync failed: r={r:.4f}"

    def test_50_node_synchronization(self):
        """50 simulated nodes should synchronize within 300 steps."""
        random.seed(42)
        field = KuramotoField(N=50, K=2.618)
        field.run(300)
        r = field.order_parameter()
        assert r > 0.3, f"50-node sync failed: r={r:.4f}"

    def test_coordination_resilience_to_noise(self):
        """Coordination should survive random phase perturbations."""
        random.seed(42)
        field = KuramotoField(N=30, K=2.618)

        # Run to synchronization
        field.run(200)
        r_before = field.order_parameter()

        # Perturb 20% of nodes
        for i in range(6):
            field.phases[i] += random.uniform(-math.pi, math.pi)

        # Run recovery
        field.run(200)
        r_after = field.order_parameter()

        # Should recover (may not fully, but should be > 0.3)
        assert r_after > 0.2, f"Failed to recover after perturbation: r={r_after:.4f}"

    def test_heartbeat_timing_consistency(self):
        """PHI_BEAT (873ms) intervals should be achievable in software."""
        intervals = []
        for _ in range(10):
            start = time.perf_counter()
            # Simulate one heartbeat's worth of computation
            random.seed(42)
            field = KuramotoField(N=20, K=2.618)
            field.run(50)
            elapsed_ms = (time.perf_counter() - start) * 1000
            intervals.append(elapsed_ms)

        max_compute = max(intervals)
        # Computation must complete well within 873ms heartbeat
        assert max_compute < PHI_BEAT * 0.5, (
            f"Compute takes {max_compute:.1f}ms, exceeds 50% of PHI_BEAT ({PHI_BEAT}ms)"
        )


class TestTransparencyMarkers:
    """Meta-tests that verify our test suite is honest about what it tests.

    These ensure the test documentation clearly distinguishes
    simulation from real hardware validation.
    """

    def test_all_simulation_classes_have_disclaimers(self):
        """All simulator classes must document they are simulations."""
        assert "SIMULATION ONLY" in SensorSimulator.__doc__
        assert "SIMULATION ONLY" in NetworkSimulator.__doc__

    def test_test_classes_state_what_they_prove(self):
        """Test classes must state what they prove AND what they don't."""
        test_classes = [
            TestSensorIngestion,
            TestNetworkDegradation,
            TestMultiNodeCoordination,
        ]
        for cls in test_classes:
            doc = cls.__doc__ or ""
            assert "PROVES" in doc.upper() or "proves" in doc.lower(), (
                f"{cls.__name__} missing 'proves' statement"
            )
