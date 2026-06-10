"""
Shadow Wire Engine — Encrypted ephemeral communication channels.

Implements Shadow Wires with:
- AES-GCM encryption with Authenticated Associated Data (AAD).
- Context-bound key derivation (keys die with context).
- Replay protection via FileReplayCache.
- Public envelope exposes only metadata + commitments (never plaintext).
- TTL enforcement for temporal binding.
"""

from __future__ import annotations

import base64
import json
import os
import time
import uuid
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any

from pythonista.phantom_qsha.errors import IntegrityError, ReplayError
from pythonista.phantom_qsha.keys import MasterKeyProvider, derive_context_key
from pythonista.phantom_qsha.qsha import qsha256_bytes, qsha256_obj
from pythonista.phantom_qsha.receipts import Receipt, ReceiptChain
from pythonista.phantom_qsha.replay import FileReplayCache


@dataclass
class ShadowWireEnvelope:
    """Public envelope — contains only metadata and ciphertext.

    No plaintext is exposed. Route commitment protects intent.
    """

    wire_id: str
    agents: list[str]
    route_commitment: str
    nonce_b64: str
    ciphertext_b64: str
    receipt_hash: str
    ttl_seconds: int
    created_at: float
    metadata: dict[str, Any] = field(default_factory=dict)

    def is_expired(self) -> bool:
        """Check if this envelope has exceeded its TTL."""
        return (time.time() - self.created_at) > self.ttl_seconds

    def to_dict(self) -> dict[str, Any]:
        """Serialize to dictionary."""
        return {
            "wire_id": self.wire_id,
            "agents": self.agents,
            "route_commitment": self.route_commitment,
            "nonce_b64": self.nonce_b64,
            "ciphertext_b64": self.ciphertext_b64,
            "receipt_hash": self.receipt_hash,
            "ttl_seconds": self.ttl_seconds,
            "created_at": self.created_at,
            "metadata": self.metadata,
        }


class ShadowWireEngine:
    """Shadow Wire Engine — encrypted ephemeral channels.

    Generates context-bound AES-GCM keys, encrypts payloads with AAD,
    and produces public envelopes containing only commitments and ciphertext.
    Includes replay protection and TTL enforcement.
    """

    def __init__(
        self,
        key_provider: MasterKeyProvider,
        receipt_chain: ReceiptChain,
        replay_cache_path: str | Path | None = None,
        default_ttl: int = 300,
    ):
        """Initialize the Shadow Wire Engine.

        Args:
            key_provider: Provider for the master key.
            receipt_chain: Receipt chain for logging operations.
            replay_cache_path: Path for replay cache file. None disables caching.
            default_ttl: Default time-to-live in seconds for envelopes.
        """
        self._key_provider = key_provider
        self._receipt_chain = receipt_chain
        self._default_ttl = default_ttl
        self._replay_cache: FileReplayCache | None = None
        if replay_cache_path:
            self._replay_cache = FileReplayCache(replay_cache_path)

    def send(
        self,
        payload: bytes,
        agents: list[str],
        route: str = "",
        ttl: int | None = None,
        wire_id: str | None = None,
    ) -> ShadowWireEnvelope:
        """Send a payload via Shadow Wire.

        Generates a context-bound AES-GCM key, encrypts the payload,
        and produces a public envelope with only commitments visible.

        Args:
            payload: Raw bytes to encrypt and send.
            agents: List of agent identifiers involved.
            route: Routing descriptor (protected via commitment).
            ttl: Time-to-live in seconds (default: engine default).
            wire_id: Optional wire ID (auto-generated if not provided).

        Returns:
            ShadowWireEnvelope containing the encrypted transfer.
        """
        # Use cryptographic import here to avoid top-level dependency issues
        from cryptography.hazmat.primitives.ciphers.aead import AESGCM

        if wire_id is None:
            wire_id = str(uuid.uuid4())

        if ttl is None:
            ttl = self._default_ttl

        timestamp = time.time()

        # Build runtime context for key derivation
        context = {
            "wire_id": wire_id,
            "agents": sorted(agents),
            "timestamp": timestamp,
            "route": route,
        }

        # Derive context-bound ephemeral key
        master_key = self._key_provider.get_master_key()
        ephemeral_key = derive_context_key(master_key, context)

        # Generate nonce (96-bit for AES-GCM)
        nonce = os.urandom(12)

        # Build AAD (authenticated associated data) for integrity
        aad = json.dumps(
            {"wire_id": wire_id, "agents": sorted(agents), "ttl": ttl},
            sort_keys=True,
            separators=(",", ":"),
        ).encode("utf-8")

        # Encrypt with AES-GCM
        aesgcm = AESGCM(ephemeral_key)
        ciphertext = aesgcm.encrypt(nonce, payload, aad)

        # Compute commitments (public proofs, no plaintext exposure)
        route_commitment = qsha256_obj({"route": route, "agents": sorted(agents)})
        input_commitment = qsha256_bytes(payload)
        output_commitment = qsha256_bytes(ciphertext)

        # Create and seal receipt
        receipt = Receipt(
            operation="shadow_wire_transfer",
            timestamp=timestamp,
            input_commitment=input_commitment,
            output_commitment=output_commitment,
            policy_gate="ALLOW",
            resource_estimate_ms=0.0,
            metadata={
                "wire_id": wire_id,
                "agents": sorted(agents),
                "route_commitment": route_commitment,
                "ttl": ttl,
            },
        )
        sealed = self._receipt_chain.append(receipt)

        # Build public envelope
        envelope = ShadowWireEnvelope(
            wire_id=wire_id,
            agents=sorted(agents),
            route_commitment=route_commitment,
            nonce_b64=base64.b64encode(nonce).decode("ascii"),
            ciphertext_b64=base64.b64encode(ciphertext).decode("ascii"),
            receipt_hash=sealed.receipt_hash,
            ttl_seconds=ttl,
            created_at=timestamp,
        )

        return envelope

    def receive(
        self,
        envelope: ShadowWireEnvelope,
        route: str = "",
    ) -> bytes:
        """Receive and decrypt a Shadow Wire envelope.

        Verifies TTL, checks replay cache, re-derives the context-bound key,
        and decrypts the payload.

        Args:
            envelope: The shadow wire envelope to decrypt.
            route: The expected route (must match sender's route).

        Returns:
            Decrypted payload bytes.

        Raises:
            ReplayError: If wire_id has been seen before or TTL expired.
            IntegrityError: If decryption/authentication fails.
        """
        from cryptography.hazmat.primitives.ciphers.aead import AESGCM

        # TTL enforcement
        if envelope.is_expired():
            raise ReplayError(
                f"Envelope expired: wire_id='{envelope.wire_id}', "
                f"age={time.time() - envelope.created_at:.1f}s > ttl={envelope.ttl_seconds}s"
            )

        # Replay protection
        if self._replay_cache:
            self._replay_cache.check_and_record(envelope.wire_id)

        # Re-derive context-bound key
        context = {
            "wire_id": envelope.wire_id,
            "agents": sorted(envelope.agents),
            "timestamp": envelope.created_at,
            "route": route,
        }
        master_key = self._key_provider.get_master_key()
        ephemeral_key = derive_context_key(master_key, context)

        # Decode envelope fields
        nonce = base64.b64decode(envelope.nonce_b64)
        ciphertext = base64.b64decode(envelope.ciphertext_b64)

        # Rebuild AAD
        aad = json.dumps(
            {
                "wire_id": envelope.wire_id,
                "agents": sorted(envelope.agents),
                "ttl": envelope.ttl_seconds,
            },
            sort_keys=True,
            separators=(",", ":"),
        ).encode("utf-8")

        # Decrypt and authenticate
        aesgcm = AESGCM(ephemeral_key)
        try:
            plaintext = aesgcm.decrypt(nonce, ciphertext, aad)
        except Exception as e:
            raise IntegrityError(
                f"Decryption failed for wire_id='{envelope.wire_id}': {e}"
            )

        return plaintext
