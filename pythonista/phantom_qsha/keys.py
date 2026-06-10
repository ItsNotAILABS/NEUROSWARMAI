"""
Key Derivation — Context-bound, ephemeral key generation.

Implements quantum-inspired key derivation using HKDF-SHA256 seeded
with QSHA commitment of runtime context. Keys are ephemeral and
context-bound — they die with the context that created them.

Provides master key providers for production (env-based) and testing (static).
"""

from __future__ import annotations

import hashlib
import hmac
import os
from abc import ABC, abstractmethod
from typing import Any

from pythonista.phantom_qsha.qsha import qsha256_obj


class MasterKeyProvider(ABC):
    """Abstract base for master key provision."""

    @abstractmethod
    def get_master_key(self) -> bytes:
        """Return the 32-byte master key."""
        ...


class EnvMasterKeyProvider(MasterKeyProvider):
    """Production master key provider — reads from environment variable.

    Expects PHANTOM_MASTER_KEY as a 64-character hex string in the environment.
    """

    def __init__(self, env_var: str = "PHANTOM_MASTER_KEY"):
        self._env_var = env_var

    def get_master_key(self) -> bytes:
        raw = os.environ.get(self._env_var)
        if not raw:
            raise RuntimeError(
                f"Master key not found in environment variable '{self._env_var}'"
            )
        if len(raw) != 64:
            raise ValueError(
                f"Master key must be 64 hex characters (32 bytes), got {len(raw)}"
            )
        return bytes.fromhex(raw)


class StaticMasterKeyProvider(MasterKeyProvider):
    """Static master key provider — for testing only.

    WARNING: Do not use in production. Key is held in memory.
    """

    def __init__(self, key: bytes | None = None):
        if key is None:
            key = os.urandom(32)
        if len(key) != 32:
            raise ValueError("Master key must be exactly 32 bytes")
        self._key = key

    def get_master_key(self) -> bytes:
        return self._key


def _hkdf_sha256(ikm: bytes, salt: bytes, info: bytes, length: int = 32) -> bytes:
    """HKDF-SHA256 extract-then-expand (RFC 5869)."""
    # Extract
    if not salt:
        salt = b"\x00" * 32
    prk = hmac.new(salt, ikm, hashlib.sha256).digest()

    # Expand
    t = b""
    okm = b""
    counter = 1
    while len(okm) < length:
        t = hmac.new(prk, t + info + bytes([counter]), hashlib.sha256).digest()
        okm += t
        counter += 1
    return okm[:length]


# Fix: hmac.new is the correct call (hmac module exposes `new`)


def derive_context_key(
    master_key: bytes,
    context: dict[str, Any],
) -> bytes:
    """Derive an ephemeral, context-bound AES key using HKDF-SHA256.

    The derivation is seeded with a QSHA commitment of the runtime context,
    binding the key to specific transient conditions (wire ID, agents,
    timestamp, etc.). This prevents replay — the key cannot be recreated
    without the exact same context.

    Args:
        master_key: 32-byte master secret.
        context: Runtime context dict (wire_id, agents, timestamp, etc.).

    Returns:
        32-byte derived AES-256 key.
    """
    # QSHA commitment of context as HKDF info
    context_commitment = qsha256_obj(context).encode("utf-8")

    # Salt derived from domain + context hash for additional binding
    salt = hashlib.sha256(b"PHANTOM.KEY.SALT." + context_commitment).digest()

    return _hkdf_sha256(
        ikm=master_key,
        salt=salt,
        info=b"PHANTOM.CONTEXT.KEY.v1:" + context_commitment,
        length=32,
    )
