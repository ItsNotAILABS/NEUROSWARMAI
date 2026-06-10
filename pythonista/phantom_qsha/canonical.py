"""
Canonical JSON — Deterministic serialization for consistent hashing.

Provides a single canonical byte representation of any JSON-serializable
Python object. Used throughout Phantom QSHA to ensure identical objects
always produce identical commitments regardless of insertion order.

This is the foundation for all QSHA commitment operations — receipts,
route commitments, vault entries, and manifest hashes all depend on
canonical serialization for reproducibility.
"""

from __future__ import annotations

import json
from typing import Any


def canonical_json(obj: Any) -> bytes:
    """Deterministic JSON serialization for consistent hashing.

    Produces a canonical byte representation by sorting keys and
    removing whitespace, ensuring identical objects always produce
    identical byte sequences regardless of insertion order.

    Args:
        obj: Any JSON-serializable Python object.

    Returns:
        UTF-8 encoded canonical JSON bytes.
    """
    return json.dumps(
        obj,
        sort_keys=True,
        separators=(",", ":"),
        ensure_ascii=True,
    ).encode("utf-8")
