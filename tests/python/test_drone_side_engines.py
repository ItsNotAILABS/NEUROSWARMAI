"""
Tests for NeuroSwarm drone-side engines, laws, and protocol mapping.
"""

from __future__ import annotations

import sys
from pathlib import Path

import pytest

ROOT = Path(__file__).resolve().parent.parent.parent
sys.path[:0] = [str(ROOT), str(ROOT / "pythonista"), str(ROOT / "src")]

from pythonista.neuroswarm.drone_side_engines import (  # noqa: E402
    DRONE_SIDE_ENGINES,
    DroneSideRuntime,
    EngineLawViolation,
    run_drone_side_tick,
)
from pythonista.neuroswarm.law_registry import DRONE_SIDE_LAWS, evaluate_drone_laws  # noqa: E402


class TestDroneSideEngines:
    def test_all_six_engines_attest(self):
        report = run_drone_side_tick("alpha-001")
        assert set(report.engines_attested) == set(DRONE_SIDE_ENGINES)
        assert "PROTO-255" in report.protocols
        assert "PROTO-262" in report.protocols
        assert report.ok

    def test_jam_failover_orbital(self):
        report = run_drone_side_tick("alpha-002", ground_jammed=True, enforce_laws=False)
        assert report.access_mode == "orbital_preferred"

    def test_gps_denied_nav_continues(self):
        report = run_drone_side_tick("alpha-003", gps_denied=True, enforce_laws=False)
        assert report.nav_ok
        assert report.gps_denied

    def test_kuramoto_law_blocks_critical(self):
        with pytest.raises(EngineLawViolation):
            run_drone_side_tick("alpha-004", kuramoto_r=0.5, enforce_laws=True)

    def test_roe_gate_blocks_actuation(self):
        with pytest.raises(EngineLawViolation):
            run_drone_side_tick(
                "alpha-005",
                actuation_requested=True,
                roe_score=0.2,
                enforce_laws=True,
            )

    def test_law_registry_count(self):
        assert len(DRONE_SIDE_LAWS) == 8

    def test_mesh_partition_detected(self):
        runtime = DroneSideRuntime(agent_id="alpha-006")
        report = runtime.tick(neighbor_votes=[], enforce_laws=False)
        assert report.mesh_partitions == 1
        violations = evaluate_drone_laws(
            {
                "kuramoto_r": 0.9,
                "threat_decision_ms": 0.1,
                "gps_denied": False,
                "nav_ok": True,
                "ground_jammed": False,
                "access_mode": "ground_mesh",
                "mesh_partitions": 1,
                "formation_error": 0.1,
                "engines_attested": list(DRONE_SIDE_ENGINES),
                "roe_score": 1.0,
                "actuation_requested": False,
            }
        )
        assert any(v["law_id"] == "NSW-L005_MESH_PARTITION" for v in violations)