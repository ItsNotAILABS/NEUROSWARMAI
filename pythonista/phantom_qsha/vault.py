"""
Sovereign Vault — Encrypted on-disk private memory with abstracted access.

Implements sovereign memory with strict private-core / public-proof separation:
- write_entry(): Stores secret payload privately; logs only commitment + receipt.
- read_abstracted(): Returns only safe view (hashes + label) — never raw data.
- read_private(): Privileged access with policy gate enforcement.

All operations produce receipts for the verifiable ledger.
Filesystem writes use atomic operations with fsync.
"""

from __future__ import annotations

import json
import os
import tempfile
import time
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any

from pythonista.phantom_qsha.errors import IntegrityError, PolicyError
from pythonista.phantom_qsha.keys import MasterKeyProvider, derive_context_key
from pythonista.phantom_qsha.qsha import qsha256_bytes, qsha256_obj
from pythonista.phantom_qsha.receipts import Receipt, ReceiptChain


@dataclass
class VaultEntry:
    """Internal vault entry (private core — never exposed directly)."""

    entry_id: str
    label: str
    encrypted_payload: bytes
    nonce: bytes
    commitment: str
    created_at: float
    metadata: dict[str, Any] = field(default_factory=dict)


@dataclass
class AbstractedView:
    """Public/safe view of a vault entry — commitment + label only.

    This is the ONLY view returned by read_abstracted().
    Raw data is never exposed through this interface.
    """

    entry_id: str
    label: str
    commitment: str
    created_at: float

    def to_dict(self) -> dict[str, Any]:
        """Serialize the abstracted view."""
        return {
            "entry_id": self.entry_id,
            "label": self.label,
            "commitment": self.commitment,
            "created_at": self.created_at,
        }


class SovereignVault:
    """Sovereign memory vault with encrypted storage and abstracted reads.

    Design principles:
    - Private-core: Raw data is encrypted at rest, never returned by default.
    - Public-proof: Only commitments and receipts are externally visible.
    - Least privilege: read_abstracted() is the default; read_private() requires
      explicit policy gate authorization.
    - Verifiable: Every operation produces a chained receipt.
    """

    def __init__(
        self,
        key_provider: MasterKeyProvider,
        receipt_chain: ReceiptChain,
        vault_dir: str | Path | None = None,
    ):
        """Initialize the Sovereign Vault.

        Args:
            key_provider: Provider for the master encryption key.
            receipt_chain: Receipt chain for logging all operations.
            vault_dir: Directory for encrypted vault entries. None for in-memory only.
        """
        self._key_provider = key_provider
        self._receipt_chain = receipt_chain
        self._vault_dir: Path | None = Path(vault_dir) if vault_dir else None
        self._entries: dict[str, VaultEntry] = {}

        if self._vault_dir:
            self._vault_dir.mkdir(parents=True, exist_ok=True)

    def write_entry(
        self,
        entry_id: str,
        label: str,
        payload: bytes,
        metadata: dict[str, Any] | None = None,
    ) -> Receipt:
        """Store a secret payload privately; log only commitment + receipt.

        The payload is encrypted with a context-bound key and stored.
        Only the QSHA commitment of the plaintext is recorded publicly.

        Args:
            entry_id: Unique identifier for this entry.
            label: Human-readable label (safe to expose).
            payload: Secret data to store (will be encrypted).
            metadata: Optional metadata dict.

        Returns:
            Sealed receipt proving the write occurred.
        """
        from cryptography.hazmat.primitives.ciphers.aead import AESGCM

        timestamp = time.time()

        # Derive context-bound key for this entry
        context = {
            "vault_op": "write",
            "entry_id": entry_id,
            "timestamp": timestamp,
        }
        master_key = self._key_provider.get_master_key()
        entry_key = derive_context_key(master_key, context)

        # Encrypt payload
        nonce = os.urandom(12)
        aesgcm = AESGCM(entry_key)
        aad = json.dumps(
            {"entry_id": entry_id, "label": label},
            sort_keys=True,
            separators=(",", ":"),
        ).encode("utf-8")
        encrypted_payload = aesgcm.encrypt(nonce, payload, aad)

        # Compute commitment (public proof of plaintext, without exposing it)
        commitment = qsha256_bytes(payload)

        # Store entry
        entry = VaultEntry(
            entry_id=entry_id,
            label=label,
            encrypted_payload=encrypted_payload,
            nonce=nonce,
            commitment=commitment,
            created_at=timestamp,
            metadata=metadata or {},
        )
        self._entries[entry_id] = entry

        # Persist to disk if configured
        if self._vault_dir:
            self._persist_entry(entry, context)

        # Create receipt (only commitment is public)
        receipt = Receipt(
            operation="vault_write",
            timestamp=timestamp,
            input_commitment=commitment,
            output_commitment=qsha256_bytes(encrypted_payload),
            policy_gate="ALLOW",
            metadata={
                "entry_id": entry_id,
                "label": label,
            },
        )
        return self._receipt_chain.append(receipt)

    def read_abstracted(self, entry_id: str) -> tuple[AbstractedView, Receipt]:
        """Return only a safe view (hashes + label) — never raw data.

        This is the default and recommended read method. It enforces
        the principle of least privilege by design.

        Args:
            entry_id: ID of the entry to read.

        Returns:
            Tuple of (AbstractedView, Receipt).

        Raises:
            PolicyError: If entry does not exist.
        """
        entry = self._entries.get(entry_id)
        if entry is None:
            raise PolicyError(
                f"Vault entry '{entry_id}' not found or access denied"
            )

        view = AbstractedView(
            entry_id=entry.entry_id,
            label=entry.label,
            commitment=entry.commitment,
            created_at=entry.created_at,
        )

        # Receipt for the abstracted read
        receipt = Receipt(
            operation="vault_read",
            timestamp=time.time(),
            input_commitment=entry.commitment,
            output_commitment=qsha256_obj(view.to_dict()),
            policy_gate="ALLOW_ABSTRACTED",
            metadata={
                "entry_id": entry_id,
                "access_level": "abstracted",
            },
        )
        sealed = self._receipt_chain.append(receipt)
        return view, sealed

    def read_private(
        self,
        entry_id: str,
        policy_token: str,
    ) -> tuple[bytes, Receipt]:
        """Privileged read — returns decrypted payload.

        Requires explicit policy authorization. Only for authorized
        internal components that need raw access.

        Args:
            entry_id: ID of the entry to read.
            policy_token: Authorization token proving privilege.

        Returns:
            Tuple of (decrypted payload bytes, Receipt).

        Raises:
            PolicyError: If entry not found or policy_token invalid.
            IntegrityError: If decryption fails (tamper detected).
        """
        from cryptography.hazmat.primitives.ciphers.aead import AESGCM

        entry = self._entries.get(entry_id)
        if entry is None:
            raise PolicyError(
                f"Vault entry '{entry_id}' not found or access denied"
            )

        # Policy gate: verify authorization token
        expected_token = qsha256_obj({
            "entry_id": entry_id,
            "grant": "private_read",
            "commitment": entry.commitment,
        })
        if policy_token != expected_token:
            raise PolicyError(
                f"Policy gate DENIED: invalid authorization for "
                f"private read of entry '{entry_id}'"
            )

        # Re-derive the context-bound key
        context = {
            "vault_op": "write",
            "entry_id": entry_id,
            "timestamp": entry.created_at,
        }
        master_key = self._key_provider.get_master_key()
        entry_key = derive_context_key(master_key, context)

        # Decrypt
        aesgcm = AESGCM(entry_key)
        aad = json.dumps(
            {"entry_id": entry_id, "label": entry.label},
            sort_keys=True,
            separators=(",", ":"),
        ).encode("utf-8")

        try:
            plaintext = aesgcm.decrypt(entry.nonce, entry.encrypted_payload, aad)
        except Exception as e:
            raise IntegrityError(
                f"Vault entry '{entry_id}' decryption failed — "
                f"possible tampering: {e}"
            )

        # Verify commitment matches
        computed_commitment = qsha256_bytes(plaintext)
        if computed_commitment != entry.commitment:
            raise IntegrityError(
                f"Vault entry '{entry_id}' commitment mismatch after decryption"
            )

        # Receipt for private read
        receipt = Receipt(
            operation="vault_read_private",
            timestamp=time.time(),
            input_commitment=entry.commitment,
            output_commitment=computed_commitment,
            policy_gate="ALLOW_PRIVATE",
            metadata={
                "entry_id": entry_id,
                "access_level": "private",
            },
        )
        sealed = self._receipt_chain.append(receipt)
        return plaintext, sealed

    def _persist_entry(self, entry: VaultEntry, context: dict[str, Any]) -> None:
        """Atomically persist encrypted entry to disk."""
        import base64

        entry_file = self._vault_dir / f"{entry.entry_id}.vault"  # type: ignore[union-attr]
        tmp_file = entry_file.with_suffix(".tmp")

        data = json.dumps({
            "entry_id": entry.entry_id,
            "label": entry.label,
            "encrypted_payload_b64": base64.b64encode(entry.encrypted_payload).decode(),
            "nonce_b64": base64.b64encode(entry.nonce).decode(),
            "commitment": entry.commitment,
            "created_at": entry.created_at,
            "metadata": entry.metadata,
            "context": context,
        }, separators=(",", ":"))

        # Atomic write: write to temp, fsync, rename
        fd = os.open(str(tmp_file), os.O_WRONLY | os.O_CREAT | os.O_TRUNC, 0o600)
        try:
            os.write(fd, data.encode("utf-8"))
            os.fsync(fd)
        finally:
            os.close(fd)

        os.replace(str(tmp_file), str(entry_file))

    def generate_policy_token(self, entry_id: str) -> str:
        """Generate a policy token for private read access.

        In production, this would be issued by a separate authority.
        Here it demonstrates the policy gate mechanism.

        Args:
            entry_id: The entry to authorize access for.

        Returns:
            Policy token string.
        """
        entry = self._entries.get(entry_id)
        if entry is None:
            raise PolicyError(f"Cannot generate token: entry '{entry_id}' not found")

        return qsha256_obj({
            "entry_id": entry_id,
            "grant": "private_read",
            "commitment": entry.commitment,
        })
