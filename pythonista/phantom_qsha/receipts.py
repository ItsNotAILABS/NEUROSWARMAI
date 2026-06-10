"""
Receipt & ReceiptChain — Verifiable, tamper-evident proof ledger.

Receipt: Immutable-style proof object with timestamps, commitments
(input/output hashes), policy gate results, resource estimates, and
chaining via prev_receipt_hash.

ReceiptChain: Append-only JSONL ledger with fsync durability.
Public view exposes only proofs — never plaintext.
"""

from __future__ import annotations

import json
import os
import tempfile
import time
from dataclasses import asdict, dataclass, field
from pathlib import Path
from typing import Any

from pythonista.phantom_qsha.errors import IntegrityError
from pythonista.phantom_qsha.qsha import qsha256_obj
from pythonista.phantom_qsha.utils import canonical_json


@dataclass(frozen=False)
class Receipt:
    """Immutable-style cryptographic proof object.

    Contains all metadata needed to verify an operation occurred
    without exposing the underlying data.
    """

    operation: str
    timestamp: float = field(default_factory=time.time)
    input_commitment: str = ""
    output_commitment: str = ""
    policy_gate: str = "ALLOW"
    resource_estimate_ms: float = 0.0
    prev_receipt_hash: str = ""
    metadata: dict[str, Any] = field(default_factory=dict)
    receipt_hash: str = ""

    def seal(self) -> "Receipt":
        """Compute self-consistent receipt_hash over all fields.

        Uses QSHA commitment over the canonical representation of
        all fields except receipt_hash itself. Once sealed, the
        receipt is self-verifying.

        Returns:
            Self (for chaining).
        """
        # Build hashable representation excluding receipt_hash
        hashable = {
            "operation": self.operation,
            "timestamp": self.timestamp,
            "input_commitment": self.input_commitment,
            "output_commitment": self.output_commitment,
            "policy_gate": self.policy_gate,
            "resource_estimate_ms": self.resource_estimate_ms,
            "prev_receipt_hash": self.prev_receipt_hash,
            "metadata": self.metadata,
        }
        self.receipt_hash = qsha256_obj(hashable)
        return self

    def verify(self) -> bool:
        """Verify that the receipt_hash is consistent with fields."""
        if not self.receipt_hash:
            return False
        hashable = {
            "operation": self.operation,
            "timestamp": self.timestamp,
            "input_commitment": self.input_commitment,
            "output_commitment": self.output_commitment,
            "policy_gate": self.policy_gate,
            "resource_estimate_ms": self.resource_estimate_ms,
            "prev_receipt_hash": self.prev_receipt_hash,
            "metadata": self.metadata,
        }
        expected = qsha256_obj(hashable)
        return self.receipt_hash == expected

    def to_dict(self) -> dict[str, Any]:
        """Serialize to dictionary for JSON storage."""
        return asdict(self)

    @classmethod
    def from_dict(cls, data: dict[str, Any]) -> "Receipt":
        """Reconstruct a Receipt from dictionary."""
        return cls(**data)


class ReceiptChain:
    """Append-only, chained receipt ledger with filesystem durability.

    Each receipt links to the previous via prev_receipt_hash, forming
    a tamper-evident chain. Writes are fsync'd for crash safety.

    Public view exposes only proofs — never plaintext payloads.
    """

    def __init__(self, ledger_path: str | Path | None = None):
        """Initialize the receipt chain.

        Args:
            ledger_path: Path to JSONL ledger file. If None, uses
                         in-memory only (no persistence).
        """
        self._receipts: list[Receipt] = []
        self._ledger_path: Path | None = (
            Path(ledger_path) if ledger_path else None
        )

        # Load existing chain if file exists
        if self._ledger_path and self._ledger_path.exists():
            self._load_chain()

    def _load_chain(self) -> None:
        """Load and verify existing chain from JSONL file."""
        with open(self._ledger_path, "r") as f:  # type: ignore[arg-type]
            for line_num, line in enumerate(f, 1):
                line = line.strip()
                if not line:
                    continue
                try:
                    data = json.loads(line)
                    receipt = Receipt.from_dict(data)
                except (json.JSONDecodeError, TypeError) as e:
                    raise IntegrityError(
                        f"Corrupted receipt at line {line_num}: {e}"
                    )

                if not receipt.verify():
                    raise IntegrityError(
                        f"Receipt integrity check failed at line {line_num}"
                    )

                # Verify chain linkage
                if self._receipts:
                    expected_prev = self._receipts[-1].receipt_hash
                    if receipt.prev_receipt_hash != expected_prev:
                        raise IntegrityError(
                            f"Chain linkage broken at line {line_num}: "
                            f"expected prev={expected_prev}, "
                            f"got prev={receipt.prev_receipt_hash}"
                        )

                self._receipts.append(receipt)

    def append(self, receipt: Receipt) -> Receipt:
        """Append a receipt to the chain.

        Automatically sets prev_receipt_hash and seals the receipt.
        Persists to disk with fsync if ledger_path is configured.

        Args:
            receipt: Receipt to append (will be sealed).

        Returns:
            The sealed receipt.
        """
        # Link to previous
        if self._receipts:
            receipt.prev_receipt_hash = self._receipts[-1].receipt_hash

        # Seal with QSHA
        receipt.seal()

        # Persist atomically
        if self._ledger_path:
            self._persist_receipt(receipt)

        self._receipts.append(receipt)
        return receipt

    def _persist_receipt(self, receipt: Receipt) -> None:
        """Append receipt to JSONL with fsync for durability."""
        self._ledger_path.parent.mkdir(parents=True, exist_ok=True)  # type: ignore[union-attr]

        # Atomic append: write to temp then append
        line = json.dumps(receipt.to_dict(), separators=(",", ":")) + "\n"
        line_bytes = line.encode("utf-8")

        # Open in append mode with fsync
        fd = os.open(
            str(self._ledger_path),
            os.O_WRONLY | os.O_CREAT | os.O_APPEND,
            0o600,
        )
        try:
            os.write(fd, line_bytes)
            os.fsync(fd)
        finally:
            os.close(fd)

    def verify_chain(self) -> bool:
        """Verify the entire chain integrity.

        Returns:
            True if all receipts are valid and properly linked.
        """
        for i, receipt in enumerate(self._receipts):
            if not receipt.verify():
                return False
            if i > 0:
                if receipt.prev_receipt_hash != self._receipts[i - 1].receipt_hash:
                    return False
        return True

    @property
    def last_hash(self) -> str:
        """Hash of the most recent receipt, or empty string."""
        if self._receipts:
            return self._receipts[-1].receipt_hash
        return ""

    @property
    def length(self) -> int:
        """Number of receipts in the chain."""
        return len(self._receipts)

    def public_ledger(self) -> list[dict[str, Any]]:
        """Return the public view of the ledger (proofs only, no plaintext)."""
        return [r.to_dict() for r in self._receipts]
