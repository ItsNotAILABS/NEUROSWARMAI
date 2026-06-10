"""
Sovereign Tensor — Pure native tensor engine integrated with MESIE spectral primitives.

COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
Framework: Medina Doctrine | SPDX-License-Identifier: CPEL-1.0

Zero third-party dependencies in the core execution path.
Deterministic, attestable, optimized for spectral neuronets and agent swarms.

MESIE Integration:
    - Spectral metadata (resonance, helix params, lineage) carried through all ops.
    - Direct ingestion from MESIE SpectralComponent objects.
    - Deterministic binary serialization for QSHA commitment binding.
"""

from __future__ import annotations

import math
import struct
from typing import Any, Dict, List, Optional, Tuple


class SovereignTensor:
    """Pure native tensor engine integrated with MESIE spectral primitives."""

    def __init__(
        self,
        data: List[float],
        shape: Tuple[int, ...],
        spectral_meta: Optional[Dict[str, Any]] = None,
    ):
        self.shape = shape
        self.data = data[:]  # flattened, defensive copy
        self.spectral_meta = spectral_meta or {}
        assert len(data) == self._product(shape), "Shape / data mismatch"

        # MESIE-native metadata
        self.resonance_score: float = self.spectral_meta.get("resonance", 1.0)
        self.helix_params: Dict[str, Any] = self.spectral_meta.get("helix", {})
        self.lineage: Any = self.spectral_meta.get("lineage", [])

    # ─────────────────────────────────────────────────────────────────────────
    # Shape utilities
    # ─────────────────────────────────────────────────────────────────────────

    @staticmethod
    def _product(shape: Tuple[int, ...]) -> int:
        p = 1
        for d in shape:
            p *= d
        return p

    @property
    def size(self) -> int:
        return self._product(self.shape)

    @property
    def ndim(self) -> int:
        return len(self.shape)

    # ─────────────────────────────────────────────────────────────────────────
    # Serialization — deterministic binary for QSHA + Vault
    # ─────────────────────────────────────────────────────────────────────────

    def to_bytes(self) -> bytes:
        """Deterministic binary representation for QSHA commitment binding."""
        return struct.pack(f"<{len(self.data)}d", *self.data)

    @classmethod
    def from_bytes(cls, raw: bytes, shape: Tuple[int, ...]) -> "SovereignTensor":
        """Reconstruct tensor from deterministic binary."""
        count = cls._product(shape)
        data = list(struct.unpack(f"<{count}d", raw))
        return cls(data, shape)

    # ─────────────────────────────────────────────────────────────────────────
    # MESIE SpectralComponent ingestion
    # ─────────────────────────────────────────────────────────────────────────

    @classmethod
    def from_mesie_component(cls, component: Dict[str, Any]) -> "SovereignTensor":
        """Direct ingestion from MESIE SpectralComponent (frequency + amplitude)."""
        freq = component.get("frequency", [])
        amp = component.get("amplitude", [])
        # Use amplitude as primary data; frequency informs spectral metadata
        data = amp[:] if amp else freq[:]
        if not data:
            data = [0.0]
        shape = (len(data),)
        meta: Dict[str, Any] = {
            "resonance": component.get("element_weight", 1.0),
            "helix": {"turns": 8, "dimensions": len(data)},
            "lineage": component.get("node_id", []),
            "frequency_band": freq,
        }
        return cls(data, shape, meta)

    @classmethod
    def zeros(cls, shape: Tuple[int, ...]) -> "SovereignTensor":
        """Create zero-filled tensor."""
        return cls([0.0] * cls._product(shape), shape)

    @classmethod
    def ones(cls, shape: Tuple[int, ...]) -> "SovereignTensor":
        """Create tensor filled with ones."""
        return cls([1.0] * cls._product(shape), shape)

    # ─────────────────────────────────────────────────────────────────────────
    # Core arithmetic — fully unrolled for fixed shapes
    # ─────────────────────────────────────────────────────────────────────────

    def add(self, other: "SovereignTensor") -> "SovereignTensor":
        """Element-wise addition."""
        assert self.shape == other.shape, "Shape mismatch for add"
        result = [a + b for a, b in zip(self.data, other.data)]
        return SovereignTensor(result, self.shape, self.spectral_meta)

    def sub(self, other: "SovereignTensor") -> "SovereignTensor":
        """Element-wise subtraction."""
        assert self.shape == other.shape, "Shape mismatch for sub"
        result = [a - b for a, b in zip(self.data, other.data)]
        return SovereignTensor(result, self.shape, self.spectral_meta)

    def scale(self, scalar: float) -> "SovereignTensor":
        """Scalar multiplication."""
        result = [x * scalar for x in self.data]
        return SovereignTensor(result, self.shape, self.spectral_meta)

    def hadamard(self, other: "SovereignTensor") -> "SovereignTensor":
        """Element-wise (Hadamard) product."""
        assert self.shape == other.shape, "Shape mismatch for hadamard"
        result = [a * b for a, b in zip(self.data, other.data)]
        return SovereignTensor(result, self.shape, self.spectral_meta)

    def matmul(self, other: "SovereignTensor") -> "SovereignTensor":
        """Resonance-weighted matrix multiplication optimized for spectral data."""
        assert self.ndim == 2 and other.ndim == 2, "matmul requires 2D tensors"
        assert self.shape[1] == other.shape[0], "Inner dimensions must match"
        m, k = self.shape
        _, n = other.shape
        result = [0.0] * (m * n)

        resonance = self.resonance_score * other.resonance_score

        for i in range(m):
            for j in range(n):
                acc = 0.0
                for p in range(k):
                    acc += self.data[i * k + p] * other.data[p * n + j]
                result[i * n + j] = acc * resonance  # resonance weighting
        return SovereignTensor(result, (m, n), self.spectral_meta)

    def transpose(self) -> "SovereignTensor":
        """Transpose a 2D tensor."""
        assert self.ndim == 2, "transpose requires 2D tensor"
        m, n = self.shape
        result = [0.0] * (m * n)
        for i in range(m):
            for j in range(n):
                result[j * m + i] = self.data[i * n + j]
        return SovereignTensor(result, (n, m), self.spectral_meta)

    def dot(self, other: "SovereignTensor") -> float:
        """Dot product of two 1D tensors."""
        assert self.ndim == 1 and other.ndim == 1, "dot requires 1D tensors"
        assert self.shape == other.shape, "Shape mismatch for dot"
        return sum(a * b for a, b in zip(self.data, other.data))

    # ─────────────────────────────────────────────────────────────────────────
    # Activations (native, no external deps)
    # ─────────────────────────────────────────────────────────────────────────

    def relu(self) -> "SovereignTensor":
        """ReLU activation."""
        result = [max(0.0, x) for x in self.data]
        return SovereignTensor(result, self.shape, self.spectral_meta)

    def sigmoid(self) -> "SovereignTensor":
        """Sigmoid activation."""
        result = [1.0 / (1.0 + math.exp(-x)) for x in self.data]
        return SovereignTensor(result, self.shape, self.spectral_meta)

    def tanh_act(self) -> "SovereignTensor":
        """Tanh activation."""
        result = [math.tanh(x) for x in self.data]
        return SovereignTensor(result, self.shape, self.spectral_meta)

    def softmax(self) -> "SovereignTensor":
        """Softmax (1D tensor)."""
        assert self.ndim == 1, "softmax requires 1D tensor"
        max_val = max(self.data)
        exp_data = [math.exp(x - max_val) for x in self.data]
        total = sum(exp_data)
        result = [e / total for e in exp_data]
        return SovereignTensor(result, self.shape, self.spectral_meta)

    # ─────────────────────────────────────────────────────────────────────────
    # Quantization for edge deployment
    # ─────────────────────────────────────────────────────────────────────────

    def quantize_int8(self) -> "SovereignTensor":
        """Native INT8 quantization for edge deployment."""
        scale = max(abs(x) for x in self.data) or 1.0
        qdata = [float(int((x / scale) * 127)) for x in self.data]
        meta = self.spectral_meta.copy()
        meta["quant_scale"] = scale
        meta["quant_bits"] = 8
        return SovereignTensor(qdata, self.shape, meta)

    def dequantize(self) -> "SovereignTensor":
        """Reverse INT8 quantization using stored scale."""
        scale = self.spectral_meta.get("quant_scale", 1.0)
        data = [(x / 127.0) * scale for x in self.data]
        meta = {k: v for k, v in self.spectral_meta.items() if not k.startswith("quant_")}
        return SovereignTensor(data, self.shape, meta)

    # ─────────────────────────────────────────────────────────────────────────
    # Norms and reductions
    # ─────────────────────────────────────────────────────────────────────────

    def l2_norm(self) -> float:
        """L2 (Euclidean) norm."""
        return math.sqrt(sum(x * x for x in self.data))

    def sum(self) -> float:
        """Sum of all elements."""
        return sum(self.data)

    def mean(self) -> float:
        """Mean of all elements."""
        return self.sum() / self.size if self.size > 0 else 0.0

    # ─────────────────────────────────────────────────────────────────────────
    # QSHA commitment binding
    # ─────────────────────────────────────────────────────────────────────────

    def to_qsha_commitment(self) -> str:
        """Generate QSHA commitment over tensor data + spectral metadata.

        Imports QSHA lazily to avoid circular dependency at module level.
        """
        from pythonista.phantom_qsha.qsha import qsha256_bytes

        payload = self.to_bytes() + str(self.spectral_meta).encode("utf-8")
        return qsha256_bytes(payload)

    def __repr__(self) -> str:
        return f"SovereignTensor(shape={self.shape}, resonance={self.resonance_score})"
