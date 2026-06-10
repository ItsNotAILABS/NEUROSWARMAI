"""
Replay Protection — Filesystem-backed wire ID deduplication.

Provides crash-safe replay detection for Shadow Wires. Ensures that
each wire_id can only be processed once, preventing replay attacks
in agentic communication channels.

Uses atomic writes with fsync for durability — even a power failure
mid-write will not corrupt the cache state.
"""

from __future__ import annotations

import json
import os
import time
from pathlib import Path

from pythonista.phantom_qsha.errors import ReplayError


class FileReplayCache:
    """Filesystem-backed replay protection cache.

    Stores seen wire_ids with timestamps. Rejects duplicates.
    Uses atomic writes with fsync for crash safety.

    In production NEUROSWARM/MAESI deployments, this prevents
    replayed Shadow Wire envelopes from being accepted — each
    wire_id is bound to a single context and cannot be reused.
    """

    def __init__(self, cache_path: str | Path):
        """Initialize the replay cache.

        Args:
            cache_path: Path to the JSON cache file.
        """
        self._path = Path(cache_path)
        self._seen: dict[str, float] = {}
        self._load()

    def _load(self) -> None:
        """Load existing cache from disk."""
        if self._path.exists():
            try:
                with open(self._path, "r") as f:
                    self._seen = json.load(f)
            except (json.JSONDecodeError, OSError):
                self._seen = {}

    def _persist(self) -> None:
        """Atomically persist cache to disk with fsync."""
        self._path.parent.mkdir(parents=True, exist_ok=True)
        tmp_path = self._path.with_suffix(".tmp")
        data = json.dumps(self._seen, separators=(",", ":"))

        fd = os.open(str(tmp_path), os.O_WRONLY | os.O_CREAT | os.O_TRUNC, 0o600)
        try:
            os.write(fd, data.encode("utf-8"))
            os.fsync(fd)
        finally:
            os.close(fd)

        os.replace(str(tmp_path), str(self._path))

    def check_and_record(self, wire_id: str) -> None:
        """Check if wire_id is new; record it.

        Args:
            wire_id: The wire identifier to check.

        Raises:
            ReplayError: If wire_id has already been processed.
        """
        if wire_id in self._seen:
            raise ReplayError(
                f"Replay detected: wire_id '{wire_id}' already processed "
                f"at timestamp {self._seen[wire_id]}"
            )
        self._seen[wire_id] = time.time()
        self._persist()

    def prune_expired(self, max_age_seconds: float = 3600) -> int:
        """Remove entries older than max_age_seconds.

        Keeps cache size bounded for long-running systems.

        Args:
            max_age_seconds: Maximum age before eviction (default: 1 hour).

        Returns:
            Number of entries removed.
        """
        cutoff = time.time() - max_age_seconds
        expired = [k for k, v in self._seen.items() if v < cutoff]
        for k in expired:
            del self._seen[k]
        if expired:
            self._persist()
        return len(expired)

    @property
    def size(self) -> int:
        """Number of wire_ids currently tracked."""
        return len(self._seen)
