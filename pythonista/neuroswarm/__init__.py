"""
NeuroSwarm — Drone-side sovereign engines for CHIMERIA / NeuroSwarmAI.

Edge engines run on each drone node. Laws (CPL-L) and protocols (PROTO-255–262)
gate every tick before mesh gossip or actuation.
"""

from pythonista.neuroswarm.drone_side_engines import (
    DRONE_SIDE_ENGINES,
    DroneSideRuntime,
    DroneTickReport,
    EngineLawViolation,
    run_drone_side_tick,
)
from pythonista.neuroswarm.law_registry import (
    DRONE_SIDE_LAWS,
    evaluate_drone_laws,
)

__all__ = [
    "DRONE_SIDE_ENGINES",
    "DRONE_SIDE_LAWS",
    "DroneSideRuntime",
    "DroneTickReport",
    "EngineLawViolation",
    "run_drone_side_tick",
    "evaluate_drone_laws",
]