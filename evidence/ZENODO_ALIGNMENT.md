# Cryptographia Phantasma ↔ Phantom QSHA Alignment

**Public release:** [Cryptographia Phantasma v1.0](https://zenodo.org/records/20598320) (DOI: 10.5281/zenodo.20598320)  
**Author:** Alfredo Medina Hernandez / MedinaTech / ItsNotAI Labs  
**Published:** June 8, 2026

**Production buildout artifact:** `PHANTOM-QSHA-PRODUCTION-BUILDOUT-20260609`  
**Zenodo manifest commitment:** `42959fdfa2b66472ca3e7e970d2b05cd1e3e84240e68a2aa3c12dddb432c8cf9`

---

## Layer separation

| Layer | Location | Dependencies | Purpose |
|-------|----------|--------------|---------|
| **Public proof** | Zenodo package | `cryptography` reference demo | Paper, schemas, executed notebook, `phantom_crypto_demo.py` |
| **Sovereign core** | `pythonista/phantom_qsha/` | Stdlib + optional `cryptography` for AES-GCM wire/vault | Production QSHA, Shadow Wire, Vault, Receipts, Replay |
| **Sovereign native** | `sovereign_*.py` | **Zero third-party** | NumPy/protobuf/ONNX-lite/CPU kernel replacements |

The Zenodo demo and this repo share the same **design contract**:

- QSHA as deterministic commitment engine (12-round profile, domain `MEDINA.PHANTOM.QSHA.v1`)
- Shadow Wire masks payload **and** routing intent
- Sovereign Vault exposes commitments on abstract reads; raw memory is policy-gated
- Receipt chain provides public verifiable surface without private pathway leakage

## Manifest commitments

This repository maintains a live QSHA hash manifest:

```
pythonista/phantom_qsha/phantom_qsha_hash_manifest.json
```

Regenerate after any source change:

```bash
python -m pythonista.phantom_qsha.manifest
```

The local aggregate commitment will differ from the Zenodo buildout snapshot when sovereign native modules or other production extensions are added. That is expected: the Zenodo commitment seals the **June 9 buildout snapshot**; this manifest seals the **current sovereign production tree**.

To verify file-level integrity against either manifest:

1. Compare per-file QSHA entries in `files`
2. Recompute aggregate over sorted file hashes (see `manifest.py`)

## Sovereign native stack (v1.1.0+)

| Module | Replaces | Notes |
|--------|----------|-------|
| `sovereign_tensor.py` | NumPy | Fixed-shape ops, int8 quant path, QSHA-bindable bytes |
| `sovereign_wire.py` | Protobuf | Tagged binary + schema records + JSON fallback commitments |
| `sovereign_model.py` | ONNX-lite | Graph + weight blobs, package commitments |
| `sovereign_compute.py` | BLAS/CUDA (CPU) | Deterministic graph interpreter |

## Formal verification targets

Minimal dependency surface enables:

- **CBMC / Frama-C** on transpiled tensor/compute kernels
- **TLA+** models for ReceiptChain + ShadowWire state machines
- Manifest commitments binding graph, weights, and wire payloads

## MESIE evidence bridge

Measured NeuroSwarmAI claims (latency, swarm sim, theater week) live in `evidence/mesie/`.  
Reproduce:

```powershell
.\evidence\mesie\reproduce_neuroswarmai.ps1
```

Full harness requires sibling clone of `Multi-Element-Spectral-Intelligence-Engine-MESIE-`.