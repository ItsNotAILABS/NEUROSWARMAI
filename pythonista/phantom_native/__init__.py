"""
Phantom Native — Sovereign NeuroRuntime.

COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
Framework: Medina Doctrine | SPDX-License-Identifier: CPEL-1.0

Core Architecture: Phantom-MESIE Sovereign Runtime
    - Everything starts from MESIE spectral objects (structured, resonance-aware, helix-encoded).
    - All computation stays inside the Private Core (hand-rolled kernels).
    - Public surface = only QSHA commitments, receipts, and Shadow Wire envelopes.
    - Full dry-compile path (C/Zig targetable).

Modules:
    sovereign_tensor: Pure native tensor engine + MESIE spectral primitives.
    neurocore: Native NeuroCore driver (resonance attention + TAURUS memory).
    swarm_runtime: Sovereign swarm orchestration with QSHA proof surface.
"""

from pythonista.phantom_native.neurocore import SovereignNeuroCore
from pythonista.phantom_native.sovereign_tensor import SovereignTensor
from pythonista.phantom_native.swarm_runtime import SovereignSwarmRuntime

__version__ = "1.0.0"
__all__ = [
    "SovereignTensor",
    "SovereignNeuroCore",
    "SovereignSwarmRuntime",
]
