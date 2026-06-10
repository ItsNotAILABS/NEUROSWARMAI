"""
Utility functions for Phantom QSHA.

Provides deterministic JSON serialization for consistent hashing
and shared helper functions used across the package.
"""

from __future__ import annotations

# Re-export canonical_json from its dedicated module
from pythonista.phantom_qsha.canonical import canonical_json

__all__ = ["canonical_json"]

