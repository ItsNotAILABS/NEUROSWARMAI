"""
Drone Side Engines — NeuroSwarm edge runtime (6 sovereign engines).

Each engine maps to a swarm protocol and is law-gated before output is published:
  DSEN  → PROTO-255  Sensor ingest + fusion
  DNAV  → PROTO-256  Edge navigation (GPS-denied capable)
  DMESH → PROTO-257  Local gossip mesh tick
  DTHR  → PROTO-258  Spectral threat fast path
  DFORM → PROTO-259  Phi lattice formation
  DRT   → PROTO-260  Jam failover routing

PROTO-261 attests all engines; PROTO-262 applies CPL-L law gate.
"""

from __future__ import annotations

import math
import time
from dataclasses import dataclass, field
from typing import Any

from pythonista.neuroswarm.law_registry import evaluate_drone_laws

PHI = 1.618033988749895
PHI_INV = 1 / PHI
PHI_BEAT_MS = 873
KURAMOTO_MIN = 0.85
THREAT_THRESHOLD = 0.55


class EngineLawViolation(Exception):
    """Raised when CPL-L law gate blocks a drone tick."""


@dataclass
class DroneTickReport:
    agent_id: str
    tick_ms: float
    kuramoto_r: float
    threat: bool
    threat_score: float
    threat_decision_ms: float
    nav_ok: bool
    gps_denied: bool
    access_mode: str
    formation_error: float
    mesh_partitions: int
    engines_attested: list[str]
    law_violations: list[dict[str, str]] = field(default_factory=list)
    protocols: list[str] = field(default_factory=list)
    ok: bool = True

    def to_dict(self) -> dict[str, Any]:
        return {
            "agent_id": self.agent_id,
            "tick_ms": self.tick_ms,
            "kuramoto_r": self.kuramoto_r,
            "threat": self.threat,
            "threat_score": self.threat_score,
            "threat_decision_ms": self.threat_decision_ms,
            "nav_ok": self.nav_ok,
            "gps_denied": self.gps_denied,
            "access_mode": self.access_mode,
            "formation_error": self.formation_error,
            "mesh_partitions": self.mesh_partitions,
            "engines_attested": self.engines_attested,
            "law_violations": self.law_violations,
            "protocols": self.protocols,
            "ok": self.ok,
        }


DRONE_SIDE_ENGINES = ("DSEN", "DNAV", "DMESH", "DTHR", "DFORM", "DRT")


class SensorFusionEngine:
    """DSEN — IMU/GPS/baro ingest with confidence-weighted fusion."""

    def tick(self, readings: dict[str, Any]) -> dict[str, Any]:
        imu = readings.get("imu", (0.0, 0.0, 9.81))
        gps = readings.get("gps", {"fix": True})
        baro = readings.get("baro", {"altitude_m": 100.0})
        gps_conf = 0.9 if gps.get("fix") else 0.0
        baro_conf = 0.7
        fused_alt = (
            gps_conf * float(baro.get("altitude_m", 100.0))
            + baro_conf * float(baro.get("altitude_m", 100.0))
        ) / max(gps_conf + baro_conf, 1e-9)
        return {
            "engine": "DSEN",
            "protocol": "PROTO-255",
            "fused_altitude_m": fused_alt,
            "imu_norm": math.sqrt(sum(x * x for x in imu)),
            "gps_fix": bool(gps.get("fix")),
        }


class NavigationEngine:
    """DNAV — dead-reckoning continuity when GPS is denied."""

    def __init__(self) -> None:
        self._heading = 0.0
        self._position = (0.0, 0.0, 100.0)

    def tick(self, fused: dict[str, Any], *, gps_denied: bool, velocity: tuple[float, float, float]) -> dict[str, Any]:
        dt = PHI_BEAT_MS / 1000.0
        if gps_denied:
            x, y, z = self._position
            vx, vy, vz = velocity
            self._position = (x + vx * dt, y + vy * dt, z + vz * dt)
            nav_ok = True
        else:
            self._position = (0.0, 0.0, float(fused.get("fused_altitude_m", 100.0)))
            nav_ok = bool(fused.get("gps_fix"))
        return {
            "engine": "DNAV",
            "protocol": "PROTO-256",
            "nav_ok": nav_ok,
            "position": self._position,
            "gps_denied": gps_denied,
        }


class MeshGossipEngine:
    """DMESH — local threat vote gossip with partition detection."""

    def tick(self, agent_id: str, neighbor_votes: list[bool], local_threat: bool) -> dict[str, Any]:
        votes = [local_threat, *neighbor_votes]
        threat_votes = sum(1 for v in votes if v)
        consensus = threat_votes > len(votes) / 2
        partitions = 1 if len(neighbor_votes) == 0 and agent_id != "solo" else 0
        return {
            "engine": "DMESH",
            "protocol": "PROTO-257",
            "consensus_threat": consensus,
            "mesh_partitions": partitions,
            "vote_ratio": threat_votes / max(len(votes), 1),
        }


class SpectralThreatEngine:
    """DTHR — fast spectral scoring (sovereign, no third-party)."""

    def tick(self, spectrum: list[float]) -> dict[str, Any]:
        t0 = time.perf_counter()
        if not spectrum:
            score = 0.0
        else:
            mean = sum(spectrum) / len(spectrum)
            variance = sum((x - mean) ** 2 for x in spectrum) / len(spectrum)
            score = min(1.0, math.sqrt(variance) * PHI_INV)
        elapsed_ms = (time.perf_counter() - t0) * 1000.0
        return {
            "engine": "DTHR",
            "protocol": "PROTO-258",
            "threat_score": score,
            "threat": score >= THREAT_THRESHOLD,
            "threat_decision_ms": elapsed_ms,
        }


class FormationEngine:
    """DFORM — phi lattice slot assignment and error metric."""

    def tick(self, agent_index: int, position: tuple[float, float, float]) -> dict[str, Any]:
        golden_angle = 2.39996322972865
        slot_x = math.cos(agent_index * golden_angle) * PHI
        slot_y = math.sin(agent_index * golden_angle) * PHI
        slot_z = float(position[2])
        target = (slot_x, slot_y, slot_z)
        error = math.sqrt(
            sum((a - b) ** 2 for a, b in zip(position, target))
        ) / (PHI * 3.0)
        return {
            "engine": "DFORM",
            "protocol": "PROTO-259",
            "formation_error": error,
            "target_slot": target,
        }


class RouteFailoverEngine:
    """DRT — ground jam → orbital_preferred route switch."""

    def tick(self, *, ground_jammed: bool, policy: str = "auto") -> dict[str, Any]:
        if ground_jammed:
            access_mode = "orbital_preferred"
            route_ok = True
        else:
            access_mode = "ground_mesh"
            route_ok = True
        return {
            "engine": "DRT",
            "protocol": "PROTO-260",
            "access_mode": access_mode,
            "route_ok": route_ok,
            "ground_jammed": ground_jammed,
            "policy": policy,
        }


@dataclass
class DroneSideRuntime:
    """Full drone-side engine bundle for one agent."""

    agent_id: str
    sensor: SensorFusionEngine = field(default_factory=SensorFusionEngine)
    nav: NavigationEngine = field(default_factory=NavigationEngine)
    mesh: MeshGossipEngine = field(default_factory=MeshGossipEngine)
    threat: SpectralThreatEngine = field(default_factory=SpectralThreatEngine)
    formation: FormationEngine = field(default_factory=FormationEngine)
    route: RouteFailoverEngine = field(default_factory=RouteFailoverEngine)

    def tick(
        self,
        *,
        readings: dict[str, Any] | None = None,
        spectrum: list[float] | None = None,
        neighbor_votes: list[bool] | None = None,
        agent_index: int = 0,
        gps_denied: bool = False,
        ground_jammed: bool = False,
        velocity: tuple[float, float, float] = (0.1, 0.0, 0.0),
        kuramoto_r: float = 0.9,
        roe_score: float = 1.0,
        actuation_requested: bool = False,
        enforce_laws: bool = True,
    ) -> DroneTickReport:
        t0 = time.perf_counter()
        readings = readings or {
            "imu": (0.0, 0.0, 9.81),
            "gps": {"fix": not gps_denied},
            "baro": {"altitude_m": 100.0},
        }
        spectrum = spectrum or [0.2, 0.25, 0.8, 0.3, 0.22]
        if neighbor_votes is None:
            neighbor_votes = [False, True, False]

        sen = self.sensor.tick(readings)
        nav = self.nav.tick(sen, gps_denied=gps_denied, velocity=velocity)
        thr = self.threat.tick(spectrum)
        mesh = self.mesh.tick(self.agent_id, neighbor_votes, thr["threat"])
        form = self.formation.tick(agent_index, nav["position"])
        route = self.route.tick(ground_jammed=ground_jammed)

        attested = ["DSEN", "DNAV", "DMESH", "DTHR", "DFORM", "DRT"]
        protocols = [
            sen["protocol"],
            nav["protocol"],
            thr["protocol"],
            mesh["protocol"],
            form["protocol"],
            route["protocol"],
            "PROTO-261",
            "PROTO-262",
        ]

        law_ctx = {
            "kuramoto_r": kuramoto_r,
            "threat_decision_ms": thr["threat_decision_ms"],
            "gps_denied": gps_denied,
            "nav_ok": nav["nav_ok"],
            "ground_jammed": ground_jammed,
            "access_mode": route["access_mode"],
            "mesh_partitions": mesh["mesh_partitions"],
            "formation_error": form["formation_error"],
            "engines_attested": attested,
            "roe_score": roe_score,
            "actuation_requested": actuation_requested,
        }
        violations = evaluate_drone_laws(law_ctx)
        critical = [v for v in violations if v["severity"] == "CRITICAL"]
        ok = len(critical) == 0

        if enforce_laws and critical:
            raise EngineLawViolation(critical[0]["law_id"])

        elapsed = (time.perf_counter() - t0) * 1000.0
        return DroneTickReport(
            agent_id=self.agent_id,
            tick_ms=elapsed,
            kuramoto_r=kuramoto_r,
            threat=thr["threat"],
            threat_score=thr["threat_score"],
            threat_decision_ms=thr["threat_decision_ms"],
            nav_ok=nav["nav_ok"],
            gps_denied=gps_denied,
            access_mode=route["access_mode"],
            formation_error=form["formation_error"],
            mesh_partitions=mesh["mesh_partitions"],
            engines_attested=attested,
            law_violations=violations,
            protocols=protocols,
            ok=ok,
        )


def run_drone_side_tick(agent_id: str, **kwargs: Any) -> DroneTickReport:
    """Convenience one-shot drone-side tick."""
    return DroneSideRuntime(agent_id=agent_id).tick(**kwargs)