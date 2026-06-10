"""
Phantom QSHA — Production Buildout
Quantum-inspired cryptographic infrastructure for sovereign agentic systems.

Components:
    - QSHA Commitment Profile (multi-round SHA-256/SHA3-256 mixing)
    - Shadow Wire Engine (AES-GCM + context-bound keys)
    - Sovereign Vault (encrypted on-disk storage with abstracted reads)
    - Receipt Chain (append-only verifiable ledger)
    - Context-Bound Key Derivation (HKDF + QSHA)

Author: Alfredo Medina Hernandez / ItsNotAI Labs / MedinaTech
Reference: Cryptographia Phantasma v1.0 (Zenodo DOI: 10.5281/zenodo.20598320)
"""

from pythonista.phantom_qsha.errors import (
    PhantomError,
    PolicyError,
    IntegrityError,
    ReplayError,
)
from pythonista.phantom_qsha.qsha import qsha256_obj, qsha256_bytes
from pythonista.phantom_qsha.keys import (
    derive_context_key,
    EnvMasterKeyProvider,
    StaticMasterKeyProvider,
)
from pythonista.phantom_qsha.receipts import Receipt, ReceiptChain
from pythonista.phantom_qsha.replay import FileReplayCache
from pythonista.phantom_qsha.shadow_wire import ShadowWireEngine
from pythonista.phantom_qsha.vault import SovereignVault
from pythonista.phantom_qsha.canonical import canonical_json

__version__ = "1.0.0"
__all__ = [
    "PhantomError",
    "PolicyError",
    "IntegrityError",
    "ReplayError",
    "qsha256_obj",
    "qsha256_bytes",
    "derive_context_key",
    "EnvMasterKeyProvider",
    "StaticMasterKeyProvider",
    "Receipt",
    "ReceiptChain",
    "FileReplayCache",
    "ShadowWireEngine",
    "SovereignVault",
    "canonical_json",
]
