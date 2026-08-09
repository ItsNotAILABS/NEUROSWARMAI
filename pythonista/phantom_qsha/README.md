# Phantom QSHA — Production Buildout

**Quantum-inspired cryptographic infrastructure for sovereign agentic systems.**

Author: Alfredo Medina Hernandez / ItsNotAI Labs / MedinaTech  
Reference: [Cryptographia Phantasma v1.0](https://zenodo.org/records/20598320) (DOI: 10.5281/zenodo.20598320)

---

## Overview

Phantom QSHA implements the full Phantom Cryptography stack for production use in NEUROSWARM and MAESI agentic systems. It provides:

- **QSHA Commitment Profile** — Domain-separated, multi-round hashing (SHA-256 ⊕ SHA3-256)
- **Shadow Wire Engine** — AES-GCM encrypted ephemeral channels with context-bound keys
- **Sovereign Vault** — Encrypted on-disk storage with abstracted (safe) and private (privileged) reads
- **Receipt Chain** — Append-only, tamper-evident JSONL ledger with fsync durability
- **Replay Protection** — Filesystem-backed wire ID deduplication
- **Context-Bound Key Derivation** — HKDF-SHA256 seeded with QSHA commitments

## Design Principles

| Principle | Implementation |
|-----------|---------------|
| **Private-core / Public-proof** | Plaintext never leaves private scope; only commitments and proofs are public |
| **Context-bound keys** | Keys derived from runtime context (wire ID, agents, timestamp) — die with context |
| **Chained receipts** | Tamper-evident ledger; each receipt links to previous via QSHA hash |
| **Least privilege** | Vault reads are abstracted by default; private access requires explicit policy token |
| **Filesystem safety** | Atomic writes with fsync throughout; crash-safe persistence |

## Architecture

```
┌─────────────────────────────────────────────────┐
│               Phantom QSHA Stack                │
├─────────────────────────────────────────────────┤
│  Shadow Wire Engine                             │
│  ├── AES-GCM + AAD encryption                  │
│  ├── Context-bound ephemeral keys               │
│  ├── Replay protection (FileReplayCache)        │
│  └── Public envelope (commitments only)         │
├─────────────────────────────────────────────────┤
│  Sovereign Vault                                │
│  ├── write_entry() → private core               │
│  ├── read_abstracted() → safe public view       │
│  └── read_private() → policy-gated privileged   │
├─────────────────────────────────────────────────┤
│  Receipt Chain                                  │
│  ├── Append-only JSONL with fsync               │
│  ├── Chained via prev_receipt_hash              │
│  └── Self-verifying using QSHA                  │
├─────────────────────────────────────────────────┤
│  QSHA Commitment Profile                        │
│  ├── 12-round mixing (min 8)                    │
│  ├── Alternating SHA-256 / SHA3-256             │
│  ├── XOR state mixing + bitwise rotations       │
│  └── Domain: MEDINA.PHANTOM.QSHA.v1            │
├─────────────────────────────────────────────────┤
│  Key Derivation                                 │
│  ├── HKDF-SHA256 (RFC 5869)                     │
│  ├── QSHA commitment of context as info         │
│  └── EnvMasterKeyProvider / StaticMasterKeyProvider │
└─────────────────────────────────────────────────┘
```

## Sovereign Core Advantages

**Optimized Runtime Efficiency** — Pure-native mathematical implementations deliver deterministic, predictable performance with minimal overhead on inference-heavy and small-model agent loops. Quantization and custom kernels unlock exceptional efficiency on edge and constrained hardware, often outperforming general-purpose frameworks by eliminating abstraction layers and dynamic dispatch.

**Streamlined Development Focus** — The absence of heavy external dependencies creates a clean, auditable codebase that prioritizes clarity and control. This sovereign design excels as the hardened core runtime kernel, while higher-level agent logic remains expressive in safe languages through clean, verified interfaces.

**Seamless Hardware Integration** — The architecture naturally complements hardware roots of trust (TPM, Pluton, custom silicon, attestation). Binding produces cryptographically verifiable, tamper-evident deterministic binaries that strengthen compliance, reproducibility, and deployment confidence in high-assurance environments.

## Module Map

| Module | Purpose |
|--------|---------|
| `qsha.py` | QSHA-256 commitment profile (multi-round domain-separated hashing) |
| `canonical.py` | Deterministic JSON serialization for consistent commitments |
| `keys.py` | Context-bound key derivation + master key providers |
| `receipts.py` | Receipt dataclass + append-only ReceiptChain ledger |
| `replay.py` | FileReplayCache — filesystem-backed wire ID deduplication |
| `shadow_wire.py` | ShadowWireEngine — encrypted ephemeral channels |
| `vault.py` | SovereignVault — encrypted storage with abstracted access |
| `sovereign_tensor.py` | NumPy replacement — deterministic tensor ops + int8 quant |
| `sovereign_wire.py` | Protobuf replacement — tagged binary wire format |
| `sovereign_model.py` | ONNX-lite — graph + weight package with commitments |
| `sovereign_compute.py` | CPU inference interpreter (MatMul, Conv2d, Relu, Softmax) |
| `errors.py` | PolicyError, IntegrityError, ReplayError hierarchy |
| `manifest.py` | Build integrity manifest generator |
| `utils.py` | Backward-compatible re-exports |

## Zenodo ↔ Production Alignment

Public release: [Cryptographia Phantasma v1.0](https://zenodo.org/records/20598320) (June 8, 2026).  
Production buildout commitment: `42959fdfa2b66472ca3e7e970d2b05cd1e3e84240e68a2aa3c12dddb432c8cf9`  
Local live manifest: `phantom_qsha_hash_manifest.json` (regenerate after changes).

See `evidence/ZENODO_ALIGNMENT.md` for layer separation (public demo vs sovereign core vs sovereign native).

## MESIE Evidence Bridge

Measured NeuroSwarmAI claims ship in `evidence/mesie/`. Reproduce:

```powershell
.\evidence\mesie\reproduce_neuroswarmai.ps1
```

```bash
python scripts/regenerate_phantom_manifest.py
python -m pytest tests/python/test_sovereign_native.py tests/python/test_phantom_qsha.py -v
```

## Error Hierarchy

```python
PhantomError (base)
├── PolicyError      # Access policy violations
├── IntegrityError   # Tamper detection / commitment mismatches
└── ReplayError      # Duplicate wire IDs / expired TTLs
```

## Quick Start

```python
from pythonista.phantom_qsha import (
    StaticMasterKeyProvider,
    ReceiptChain,
    SovereignVault,
    ShadowWireEngine,
)

# Setup
provider = StaticMasterKeyProvider()  # Use EnvMasterKeyProvider in production
chain = ReceiptChain("/tmp/ledger.jsonl")

# Write to Sovereign Vault
vault = SovereignVault(key_provider=provider, receipt_chain=chain)
vault.write_entry("state_001", "Neural Pattern", b"SECRET DATA")

# Read abstracted (safe — no raw data)
view, receipt = vault.read_abstracted("state_001")
# view.commitment = QSHA hash of original data
# view.label = "Neural Pattern"
# Raw data is NEVER returned here

# Send via Shadow Wire
engine = ShadowWireEngine(
    key_provider=provider,
    receipt_chain=chain,
    replay_cache_path="/tmp/replay.json",
)
envelope = engine.send(
    payload=b"cognitive state transfer",
    agents=["neuroswarm_alpha", "maesi_core"],
    route="internal/cognitive",
)
# envelope contains only: ciphertext, commitments, metadata
# plaintext is NEVER in the envelope

# Receive on other end
decrypted = engine.receive(envelope, route="internal/cognitive")
```

## Testing

```bash
python -m pytest tests/python/test_phantom_qsha.py -v
```

43+ tests covering: QSHA stability, sovereign native stack, vault flows, shadow wire round-trip, replay blocking, receipt chain integrity, and full integration flow.

## Security Notes

- **Not quantum cryptography** — purely classical, quantum-*inspired* (context-bound ephemerality)
- **QSHA** acts as hardened, domain-separated commitment primitive (not a replacement for SHA-256 in TLS)
- **Production use** requires `EnvMasterKeyProvider` with proper key management
- **Replay cache** should be pruned periodically in long-running deployments
- Master key rotation is not yet implemented (single-key design)

## License

Part of the CHIMERIA Defense Systems platform. See repository LICENSE.
