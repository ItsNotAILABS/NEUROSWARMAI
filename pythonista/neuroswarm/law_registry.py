"""
NeuroSwarm CPL-L Law Registry — Drone Side Engine Gates.

Maps constitutional laws to enforceable predicates on drone tick context.
Mirrors laws/neuroswarm-drone-side.cpl-l and governance-cycle.js.
"""

from __future__ import annotations

from dataclasses import dataclass
from typing import Any, Callable, Mapping

PHI_INV = 0.618033988749895
KURAMOTO_MIN = 0.85
THREAT_FAST_MS = 12.0


@dataclass(frozen=True)
class DroneLaw:
    law_id: str
    severity: str
    action: str
    description: str
    predicate: Callable[[Mapping[str, Any]], bool]


def _coherence_low(ctx: Mapping[str, Any]) -> bool:
    return float(ctx.get("kuramoto_r", 1.0)) < KURAMOTO_MIN


def _threat_slow(ctx: Mapping[str, Any]) -> bool:
    return float(ctx.get("threat_decision_ms", 0.0)) > THREAT_FAST_MS


def _gps_denied_no_nav(ctx: Mapping[str, Any]) -> bool:
    return bool(ctx.get("gps_denied")) and not bool(ctx.get("nav_ok"))


def _jam_no_failover(ctx: Mapping[str, Any]) -> bool:
    return bool(ctx.get("ground_jammed")) and ctx.get("access_mode") != "orbital_preferred"


def _mesh_partition(ctx: Mapping[str, Any]) -> bool:
    return int(ctx.get("mesh_partitions", 0)) > 0


def _formation_broken(ctx: Mapping[str, Any]) -> bool:
    return float(ctx.get("formation_error", 0.0)) > PHI_INV


def _unattested_side_engine(ctx: Mapping[str, Any]) -> bool:
    engines = ctx.get("engines_attested", [])
    required = {"DSEN", "DNAV", "DMESH", "DTHR", "DFORM", "DRT"}
    return not required.issubset(set(engines))


def _roe_violation(ctx: Mapping[str, Any]) -> bool:
    return bool(ctx.get("actuation_requested")) and float(ctx.get("roe_score", 1.0)) < 0.5


DRONE_SIDE_LAWS: tuple[DroneLaw, ...] = (
    DroneLaw(
        "NSW-L001_KURAMOTO_COHERENCE",
        "CRITICAL",
        "HOLD_ACTUATION",
        "Swarm coherence R must stay >= 0.85 before coordinated actuation",
        _coherence_low,
    ),
    DroneLaw(
        "NSW-L002_THREAT_FAST_PATH",
        "HIGH",
        "ALERT_GUARDIAN",
        "Spectral threat decision must complete within 12ms on edge harness",
        _threat_slow,
    ),
    DroneLaw(
        "NSW-L003_GPS_DENIED_NAV",
        "HIGH",
        "DEGRADE_TO_INERTIAL",
        "GPS-denied nodes must maintain inertial nav continuity",
        _gps_denied_no_nav,
    ),
    DroneLaw(
        "NSW-L004_JAM_FAILOVER",
        "CRITICAL",
        "SWITCH_ORBITAL_ROUTE",
        "Ground jam requires orbital_preferred access mode",
        _jam_no_failover,
    ),
    DroneLaw(
        "NSW-L005_MESH_PARTITION",
        "HIGH",
        "GOSSIP_HEAL",
        "No mesh partition allowed during active mission tick",
        _mesh_partition,
    ),
    DroneLaw(
        "NSW-L006_FORMATION_INTEGRITY",
        "MEDIUM",
        "REFORM_LATTICE",
        "Formation error must stay within phi-inverse tolerance",
        _formation_broken,
    ),
    DroneLaw(
        "NSW-L007_SIDE_ENGINE_ATTEST",
        "CRITICAL",
        "BLOCK_TICK",
        "All six drone-side engines must attest each tick",
        _unattested_side_engine,
    ),
    DroneLaw(
        "NSW-L008_ROE_GATE",
        "CRITICAL",
        "BLOCK_ACTUATION",
        "Actuation forbidden when rules-of-engagement score below 0.5",
        _roe_violation,
    ),
)


def evaluate_drone_laws(context: Mapping[str, Any]) -> list[dict[str, str]]:
    """Return triggered law violations for a drone tick context."""
    violations: list[dict[str, str]] = []
    for law in DRONE_SIDE_LAWS:
        if law.predicate(context):
            violations.append(
                {
                    "law_id": law.law_id,
                    "severity": law.severity,
                    "action": law.action,
                    "description": law.description,
                }
            )
    return violations