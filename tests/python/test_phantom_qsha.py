"""
Tests for Phantom QSHA Production Buildout.

Covers:
- QSHA commitment stability and determinism.
- Vault write/abstract read/private read flows.
- Shadow Wire round-trip encryption/decryption.
- Replay protection blocking.
- Receipt chain integrity and verification.
- Error handling (PolicyError, IntegrityError, ReplayError).
"""

from __future__ import annotations

import json
import os
import tempfile
import time
from pathlib import Path

import pytest

from pythonista.phantom_qsha.errors import IntegrityError, PolicyError, ReplayError
from pythonista.phantom_qsha.keys import StaticMasterKeyProvider, derive_context_key
from pythonista.phantom_qsha.qsha import qsha256_bytes, qsha256_obj
from pythonista.phantom_qsha.receipts import Receipt, ReceiptChain
from pythonista.phantom_qsha.replay import FileReplayCache
from pythonista.phantom_qsha.shadow_wire import (
    ShadowWireEngine,
    ShadowWireEnvelope,
)
from pythonista.phantom_qsha.utils import canonical_json
from pythonista.phantom_qsha.vault import SovereignVault


# --- QSHA Tests ---


class TestQSHA:
    """QSHA commitment profile tests."""

    def test_determinism(self):
        """Same input always produces same commitment."""
        data = b"hello sovereign world"
        h1 = qsha256_bytes(data)
        h2 = qsha256_bytes(data)
        assert h1 == h2

    def test_different_inputs_different_hashes(self):
        """Different inputs produce different commitments."""
        h1 = qsha256_bytes(b"alpha")
        h2 = qsha256_bytes(b"beta")
        assert h1 != h2

    def test_obj_determinism(self):
        """Object hashing is deterministic regardless of key order."""
        obj1 = {"b": 2, "a": 1}
        obj2 = {"a": 1, "b": 2}
        assert qsha256_obj(obj1) == qsha256_obj(obj2)

    def test_hex_output(self):
        """Output is a valid 64-char hex string (SHA-256 final)."""
        h = qsha256_bytes(b"test")
        assert len(h) == 64
        assert all(c in "0123456789abcdef" for c in h)

    def test_min_rounds_enforced(self):
        """Rounds below minimum are clamped to MIN_ROUNDS."""
        h_low = qsha256_bytes(b"test", rounds=2)
        h_min = qsha256_bytes(b"test", rounds=8)
        assert h_low == h_min  # Both should use min 8 rounds

    def test_round_sensitivity(self):
        """Different round counts (above min) produce different results."""
        h8 = qsha256_bytes(b"test", rounds=8)
        h12 = qsha256_bytes(b"test", rounds=12)
        assert h8 != h12


# --- Key Derivation Tests ---


class TestKeyDerivation:
    """Context-bound key derivation tests."""

    def test_deterministic_derivation(self):
        """Same context produces same key."""
        provider = StaticMasterKeyProvider(b"\x42" * 32)
        ctx = {"wire_id": "w1", "agents": ["a", "b"], "timestamp": 1000.0}
        k1 = derive_context_key(provider.get_master_key(), ctx)
        k2 = derive_context_key(provider.get_master_key(), ctx)
        assert k1 == k2

    def test_context_sensitivity(self):
        """Different contexts produce different keys."""
        provider = StaticMasterKeyProvider(b"\x42" * 32)
        ctx1 = {"wire_id": "w1", "timestamp": 1000.0}
        ctx2 = {"wire_id": "w2", "timestamp": 1000.0}
        k1 = derive_context_key(provider.get_master_key(), ctx1)
        k2 = derive_context_key(provider.get_master_key(), ctx2)
        assert k1 != k2

    def test_key_length(self):
        """Derived keys are 32 bytes (AES-256)."""
        provider = StaticMasterKeyProvider()
        ctx = {"test": True}
        key = derive_context_key(provider.get_master_key(), ctx)
        assert len(key) == 32


# --- Receipt Tests ---


class TestReceipts:
    """Receipt and ReceiptChain tests."""

    def test_seal_and_verify(self):
        """Sealed receipt verifies correctly."""
        r = Receipt(operation="test_op", timestamp=1000.0)
        r.seal()
        assert r.receipt_hash != ""
        assert r.verify()

    def test_tamper_detection(self):
        """Modifying a sealed receipt breaks verification."""
        r = Receipt(operation="test_op", timestamp=1000.0)
        r.seal()
        r.operation = "tampered"
        assert not r.verify()

    def test_chain_linkage(self):
        """Receipts are properly linked in the chain."""
        chain = ReceiptChain()
        r1 = chain.append(Receipt(operation="op1"))
        r2 = chain.append(Receipt(operation="op2"))
        assert r2.prev_receipt_hash == r1.receipt_hash

    def test_chain_verify(self):
        """Chain verification passes for valid chain."""
        chain = ReceiptChain()
        chain.append(Receipt(operation="op1"))
        chain.append(Receipt(operation="op2"))
        chain.append(Receipt(operation="op3"))
        assert chain.verify_chain()
        assert chain.length == 3

    def test_chain_persistence(self):
        """Chain persists to and loads from JSONL file."""
        with tempfile.TemporaryDirectory() as tmp:
            ledger_path = Path(tmp) / "ledger.jsonl"

            # Write
            chain1 = ReceiptChain(ledger_path)
            chain1.append(Receipt(operation="op1"))
            chain1.append(Receipt(operation="op2"))

            # Reload
            chain2 = ReceiptChain(ledger_path)
            assert chain2.length == 2
            assert chain2.verify_chain()

    def test_chain_tamper_detection(self):
        """Corrupted JSONL file raises IntegrityError on load."""
        with tempfile.TemporaryDirectory() as tmp:
            ledger_path = Path(tmp) / "ledger.jsonl"

            chain = ReceiptChain(ledger_path)
            chain.append(Receipt(operation="op1"))

            # Corrupt the file
            with open(ledger_path, "w") as f:
                f.write('{"operation":"op1","receipt_hash":"BOGUS"}\n')

            with pytest.raises(IntegrityError):
                ReceiptChain(ledger_path)

    def test_public_ledger(self):
        """Public ledger returns list of dicts."""
        chain = ReceiptChain()
        chain.append(Receipt(operation="op1"))
        ledger = chain.public_ledger()
        assert len(ledger) == 1
        assert "operation" in ledger[0]
        assert "receipt_hash" in ledger[0]


# --- Shadow Wire Tests ---


class TestShadowWire:
    """Shadow Wire Engine tests."""

    def _make_engine(self, tmp_dir: Path) -> ShadowWireEngine:
        provider = StaticMasterKeyProvider(b"\xAB" * 32)
        chain = ReceiptChain(tmp_dir / "receipts.jsonl")
        cache_path = tmp_dir / "replay.json"
        return ShadowWireEngine(
            key_provider=provider,
            receipt_chain=chain,
            replay_cache_path=cache_path,
        )

    def test_round_trip(self):
        """Send and receive produces original payload."""
        with tempfile.TemporaryDirectory() as tmp:
            tmp_path = Path(tmp)
            engine = self._make_engine(tmp_path)
            payload = b"secret sovereign data"

            envelope = engine.send(
                payload=payload,
                agents=["agent_a", "agent_b"],
                route="internal/cognitive",
            )

            # Verify envelope structure
            assert envelope.wire_id
            assert envelope.route_commitment
            assert envelope.ciphertext_b64
            assert envelope.nonce_b64
            assert envelope.receipt_hash

            # Decrypt
            decrypted = engine.receive(envelope, route="internal/cognitive")
            assert decrypted == payload

    def test_replay_blocked(self):
        """Same wire_id cannot be received twice."""
        with tempfile.TemporaryDirectory() as tmp:
            tmp_path = Path(tmp)
            engine = self._make_engine(tmp_path)

            envelope = engine.send(
                payload=b"data",
                agents=["a"],
                route="r",
            )

            # First receive succeeds
            engine.receive(envelope, route="r")

            # Second receive raises ReplayError
            with pytest.raises(ReplayError):
                engine.receive(envelope, route="r")

    def test_ttl_expiry(self):
        """Expired envelope raises ReplayError."""
        with tempfile.TemporaryDirectory() as tmp:
            tmp_path = Path(tmp)
            engine = self._make_engine(tmp_path)

            envelope = engine.send(
                payload=b"data",
                agents=["a"],
                route="r",
                ttl=1,
            )

            # Manually expire it
            envelope.created_at = time.time() - 100

            with pytest.raises(ReplayError):
                engine.receive(envelope, route="r")

    def test_wrong_route_fails(self):
        """Wrong route produces different key → decryption fails."""
        with tempfile.TemporaryDirectory() as tmp:
            tmp_path = Path(tmp)
            engine = self._make_engine(tmp_path)

            envelope = engine.send(
                payload=b"data",
                agents=["a"],
                route="correct_route",
            )

            with pytest.raises(IntegrityError):
                engine.receive(envelope, route="wrong_route")


# --- Sovereign Vault Tests ---


class TestSovereignVault:
    """Sovereign Vault tests."""

    def _make_vault(self, tmp_dir: Path) -> SovereignVault:
        provider = StaticMasterKeyProvider(b"\xCD" * 32)
        chain = ReceiptChain(tmp_dir / "vault_receipts.jsonl")
        return SovereignVault(
            key_provider=provider,
            receipt_chain=chain,
            vault_dir=tmp_dir / "vault_data",
        )

    def test_write_and_abstract_read(self):
        """Write entry then read abstracted view (no raw data exposed)."""
        with tempfile.TemporaryDirectory() as tmp:
            vault = self._make_vault(Path(tmp))

            receipt = vault.write_entry(
                entry_id="secret_001",
                label="Cognitive State Alpha",
                payload=b"TOP SECRET NEURAL PATTERN",
            )
            assert receipt.receipt_hash
            assert receipt.operation == "vault_write"

            # Abstracted read
            view, read_receipt = vault.read_abstracted("secret_001")
            assert view.label == "Cognitive State Alpha"
            assert view.commitment  # Has QSHA commitment
            assert view.entry_id == "secret_001"
            assert read_receipt.operation == "vault_read"

            # Verify raw data is NOT in the view
            view_dict = view.to_dict()
            assert b"TOP SECRET" not in json.dumps(view_dict).encode()

    def test_private_read_with_valid_token(self):
        """Private read with valid policy token returns plaintext."""
        with tempfile.TemporaryDirectory() as tmp:
            vault = self._make_vault(Path(tmp))
            payload = b"SOVEREIGN MEMORY FRAGMENT"

            vault.write_entry(
                entry_id="priv_001",
                label="Fragment",
                payload=payload,
            )

            # Generate valid policy token
            token = vault.generate_policy_token("priv_001")

            # Private read succeeds
            decrypted, receipt = vault.read_private("priv_001", token)
            assert decrypted == payload
            assert receipt.operation == "vault_read_private"

    def test_private_read_invalid_token_raises(self):
        """Private read with invalid token raises PolicyError."""
        with tempfile.TemporaryDirectory() as tmp:
            vault = self._make_vault(Path(tmp))
            vault.write_entry("e1", "label", b"data")

            with pytest.raises(PolicyError):
                vault.read_private("e1", "invalid_token")

    def test_read_nonexistent_raises(self):
        """Reading non-existent entry raises PolicyError."""
        with tempfile.TemporaryDirectory() as tmp:
            vault = self._make_vault(Path(tmp))

            with pytest.raises(PolicyError):
                vault.read_abstracted("does_not_exist")

    def test_vault_persistence(self):
        """Vault entries persist encrypted files to disk."""
        with tempfile.TemporaryDirectory() as tmp:
            vault = self._make_vault(Path(tmp))
            vault.write_entry("persist_001", "Persisted", b"data here")

            vault_file = Path(tmp) / "vault_data" / "persist_001.vault"
            assert vault_file.exists()

            # File content is JSON but payload is encrypted (base64)
            content = json.loads(vault_file.read_text())
            assert "encrypted_payload_b64" in content
            assert content["label"] == "Persisted"


# --- Canonical JSON Tests ---


class TestCanonicalJSON:
    """Canonical JSON serialization tests."""

    def test_key_order_independence(self):
        """Key order doesn't affect output."""
        a = canonical_json({"z": 1, "a": 2})
        b = canonical_json({"a": 2, "z": 1})
        assert a == b

    def test_no_whitespace(self):
        """Output has no unnecessary whitespace."""
        result = canonical_json({"key": "value"})
        assert b" " not in result
        assert b"\n" not in result

    def test_ascii_encoding(self):
        """Non-ASCII characters are escaped."""
        result = canonical_json({"emoji": "🔐"})
        assert b"\\u" in result


# --- Integration Test ---


class TestIntegration:
    """Full demo execution flow integration test."""

    def test_full_flow(self):
        """Complete flow: vault write → abstracted read → shadow wire transfer."""
        with tempfile.TemporaryDirectory() as tmp:
            tmp_path = Path(tmp)
            provider = StaticMasterKeyProvider(b"\xEF" * 32)
            chain = ReceiptChain(tmp_path / "ledger.jsonl")

            # 1. Write secret to vault
            vault = SovereignVault(
                key_provider=provider,
                receipt_chain=chain,
                vault_dir=tmp_path / "vault",
            )
            vault.write_entry(
                entry_id="cognitive_state_1",
                label="Neural Pattern Alpha",
                payload=b"CLASSIFIED SWARM COORDINATION DATA",
            )

            # 2. Read abstractedly
            view, _ = vault.read_abstracted("cognitive_state_1")

            # 3. Send via shadow wire
            wire_engine = ShadowWireEngine(
                key_provider=provider,
                receipt_chain=chain,
                replay_cache_path=tmp_path / "replay.json",
            )
            envelope = wire_engine.send(
                payload=json.dumps(view.to_dict()).encode(),
                agents=["neuroswarm_alpha", "maesi_core"],
                route="internal/cognitive_transfer",
            )

            # Verify: 3 receipts in chain
            assert chain.length == 3
            assert chain.verify_chain()

            # Verify: envelope contains only commitments
            env_dict = envelope.to_dict()
            assert "CLASSIFIED" not in json.dumps(env_dict)
            assert envelope.route_commitment
            assert envelope.receipt_hash

            # Verify: full public ledger
            ledger = chain.public_ledger()
            assert ledger[0]["operation"] == "vault_write"
            assert ledger[1]["operation"] == "vault_read"
            assert ledger[2]["operation"] == "shadow_wire_transfer"

            # 4. Receive on other end
            decrypted = wire_engine.receive(
                envelope, route="internal/cognitive_transfer"
            )
            received_view = json.loads(decrypted)
            assert received_view["label"] == "Neural Pattern Alpha"
            assert received_view["commitment"] == view.commitment
