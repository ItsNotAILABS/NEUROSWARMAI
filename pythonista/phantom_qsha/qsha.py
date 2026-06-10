"""
QSHA Commitment Profile — Quantum-inspired Secure Hashing Algorithm.

A custom domain-separated, multi-round commitment profile built on
SHA-256 and SHA3-256. Provides stronger proof surfaces than plain SHA-256
through alternating hash rounds with XOR state mixing and rotations.

Domain: MEDINA.PHANTOM.QSHA.v1
Rounds: 12 (minimum 8)
"""

from __future__ import annotations

import hashlib
from typing import Any

from pythonista.phantom_qsha.utils import canonical_json

DOMAIN_SEPARATOR = b"MEDINA.PHANTOM.QSHA.v1"
MIN_ROUNDS = 8
DEFAULT_ROUNDS = 12


def _rotate_bytes(data: bytes, shift: int) -> bytes:
    """Bitwise left-rotate a byte sequence by shift bits."""
    if not data:
        return data
    n_bits = len(data) * 8
    shift = shift % n_bits
    int_val = int.from_bytes(data, "big")
    rotated = ((int_val << shift) | (int_val >> (n_bits - shift))) & ((1 << n_bits) - 1)
    return rotated.to_bytes(len(data), "big")


def _xor_bytes(a: bytes, b: bytes) -> bytes:
    """XOR two byte sequences of equal length."""
    return bytes(x ^ y for x, y in zip(a, b))


def _sha256(data: bytes) -> bytes:
    """Standard SHA-256 hash."""
    return hashlib.sha256(data).digest()


def _sha3_256(data: bytes) -> bytes:
    """SHA3-256 hash."""
    return hashlib.sha3_256(data).digest()


def qsha256_bytes(data: bytes, rounds: int = DEFAULT_ROUNDS) -> str:
    """QSHA-256 commitment from raw bytes.

    Multi-round mixing using alternating SHA-256 and SHA3-256 with
    domain separation, XOR state mixing, and bitwise rotations.

    Args:
        data: Input bytes to commit.
        rounds: Number of mixing rounds (minimum 8, default 12).

    Returns:
        Hex-encoded QSHA commitment string.
    """
    if rounds < MIN_ROUNDS:
        rounds = MIN_ROUNDS

    # Initialize left/right state with domain separation
    left = _sha256(DOMAIN_SEPARATOR + b"\x00" + data)
    right = _sha3_256(DOMAIN_SEPARATOR + b"\x01" + data)

    for i in range(rounds):
        round_tag = i.to_bytes(4, "big")

        if i % 2 == 0:
            # Even rounds: SHA-256 on left mixed with rotated right
            mixed = _xor_bytes(left, _rotate_bytes(right, (i + 1) * 3))
            left = _sha256(round_tag + mixed + right)
        else:
            # Odd rounds: SHA3-256 on right mixed with rotated left
            mixed = _xor_bytes(right, _rotate_bytes(left, (i + 1) * 5))
            right = _sha3_256(round_tag + mixed + left)

    # Final combination
    final = _sha256(DOMAIN_SEPARATOR + left + right)
    return final.hex()


def qsha256_obj(obj: Any, rounds: int = DEFAULT_ROUNDS) -> str:
    """QSHA-256 commitment from any JSON-serializable object.

    Canonicalizes the object to deterministic JSON bytes, then applies
    the QSHA multi-round mixing function.

    Args:
        obj: JSON-serializable Python object.
        rounds: Number of mixing rounds (minimum 8, default 12).

    Returns:
        Hex-encoded QSHA commitment string.
    """
    return qsha256_bytes(canonical_json(obj), rounds=rounds)
