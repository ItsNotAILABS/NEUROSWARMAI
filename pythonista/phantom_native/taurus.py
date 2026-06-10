"""
TAURUS Native Memory Management — Resonance decay + helix compression.

COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
Framework: Medina Doctrine | SPDX-License-Identifier: CPEL-1.0

Architecture:
    - Working memory: bounded short-term buffer with resonance scoring.
    - Long-term memory: persistent key-value store indexed by QSHA.
    - Resonance decay: older entries lose activation over time.
    - Helix compression: downsample + rotate for efficient long-term storage.
    - Context fusion: recall top-k resonant memories for attention augmentation.

Zero external dependencies. Pure native memory engine.
"""

from __future__ import annotations

import array
import math
from typing import Any, Dict, List, Optional

from pythonista.phantom_native.sovereign_tensor import SovereignTensor


class TaurusMemory:
    """Native working + persistent memory with resonance decay + helix compression."""

    def __init__(self, capacity: int = 64, decay_rate: float = 0.95):
        self.working_memory: List[SovereignTensor] = []  # short-term
        self.long_term: Dict[str, SovereignTensor] = {}  # keyed by QSHA
        self.capacity = capacity
        self.decay_rate = decay_rate
        self.resonance_scores: Dict[str, float] = {}
        self._key_index: List[str] = []  # ordered keys for working memory

    def store(self, tensor: SovereignTensor, key: Optional[str] = None) -> str:
        """Store tensor with resonance weighting and decay.

        Args:
            tensor: SovereignTensor to store.
            key: Optional QSHA key. Auto-generated if None.

        Returns:
            Key under which the tensor is stored.
        """
        if key is None:
            key = "qsha:" + format(hash(tensor.to_bytes()) & 0xFFFFFFFFFFFFFFFF, "016x")

        # Resonance boost based on memory depth
        current_res = tensor.resonance_score * (1.0 + len(self.working_memory) * 0.05)

        if len(self.working_memory) >= self.capacity:
            # Apply resonance decay to all entries before eviction
            self._apply_decay()
            # Evict lowest-resonance entry
            evict_idx = self._find_lowest_resonance()
            evict_key = self._key_index[evict_idx]
            self.working_memory.pop(evict_idx)
            self._key_index.pop(evict_idx)
            # Keep in long-term but remove from active scores
            if evict_key in self.resonance_scores:
                self.resonance_scores[evict_key] *= 0.5  # demote

        self.working_memory.append(tensor)
        self._key_index.append(key)
        self.resonance_scores[key] = current_res
        self.long_term[key] = tensor  # persistent reference

        return key

    def recall(self, key: str) -> Optional[SovereignTensor]:
        """Recall tensor by QSHA key from long-term memory."""
        tensor = self.long_term.get(key)
        if tensor is not None:
            # Boost resonance on recall (reinforcement)
            self.resonance_scores[key] = self.resonance_scores.get(key, 1.0) * 1.1
        return tensor

    def recall_top_k(self, k: int = 8) -> List[SovereignTensor]:
        """Return highest resonance items from working memory (MESIE spectral matching)."""
        if not self.working_memory:
            return []

        scored = []
        for i, tensor in enumerate(self.working_memory):
            mem_key = self._key_index[i] if i < len(self._key_index) else ""
            score = self.resonance_scores.get(mem_key, 0.0)
            scored.append((score, tensor))

        scored.sort(key=lambda x: x[0], reverse=True)
        return [t for _, t in scored[:k]]

    def recall_by_resonance_threshold(self, threshold: float) -> List[SovereignTensor]:
        """Return all working memory items above resonance threshold."""
        results = []
        for i, tensor in enumerate(self.working_memory):
            mem_key = self._key_index[i] if i < len(self._key_index) else ""
            score = self.resonance_scores.get(mem_key, 0.0)
            if score >= threshold:
                results.append(tensor)
        return results

    def compress_helix(self, tensor: SovereignTensor) -> SovereignTensor:
        """Helix-style compression: rotate + downsample by factor of 2.

        Pairs adjacent elements with averaging — preserves spectral envelope
        while halving memory footprint. Suitable for long-term storage.
        """
        n = len(tensor.data)
        if n < 2:
            return tensor  # Cannot compress single element

        half = n // 2
        compressed = array.array("f", [0.0] * half)
        for i in range(half):
            # Average adjacent pairs (spectral envelope preservation)
            compressed[i] = (tensor.data[2 * i] + tensor.data[2 * i + 1]) * 0.5

        meta = tensor.spectral_meta.copy()
        meta["helix_compressed"] = True
        meta["original_size"] = n
        return SovereignTensor(list(compressed), (half,), meta)

    def compress_helix_weighted(self, tensor: SovereignTensor) -> SovereignTensor:
        """Helix compression with resonance-weighted averaging.

        Higher-resonance elements contribute more to the compressed representation.
        """
        n = len(tensor.data)
        if n < 2:
            return tensor

        half = n // 2
        compressed = array.array("f", [0.0] * half)
        resonance = tensor.resonance_score

        for i in range(half):
            a = tensor.data[2 * i]
            b = tensor.data[2 * i + 1]
            # Helix rotation weighting
            phase = math.sin(i * 0.1 * resonance)
            weight_a = 0.5 + phase * 0.25
            weight_b = 1.0 - weight_a
            compressed[i] = a * weight_a + b * weight_b

        meta = tensor.spectral_meta.copy()
        meta["helix_compressed"] = True
        meta["helix_weighted"] = True
        meta["original_size"] = n
        return SovereignTensor(list(compressed), (half,), meta)

    def fuse_context(self, tensors: List[SovereignTensor]) -> Optional[SovereignTensor]:
        """Fuse multiple context tensors via resonance-weighted averaging.

        Used to merge top-k recalled memories into a single context vector
        for attention augmentation.
        """
        if not tensors:
            return None

        # Find common minimum length for fusion
        min_len = min(len(t.data) for t in tensors)
        if min_len == 0:
            return None

        fused = array.array("f", [0.0] * min_len)
        total_resonance = 0.0

        for tensor in tensors:
            weight = tensor.resonance_score
            total_resonance += weight
            for i in range(min_len):
                fused[i] += tensor.data[i] * weight

        # Normalize by total resonance
        if total_resonance > 0:
            for i in range(min_len):
                fused[i] /= total_resonance

        meta = {"resonance": total_resonance / len(tensors), "fused_count": len(tensors)}
        return SovereignTensor(list(fused), (min_len,), meta)

    def _apply_decay(self) -> None:
        """Apply resonance decay to all working memory entries."""
        for key in self._key_index:
            if key in self.resonance_scores:
                self.resonance_scores[key] *= self.decay_rate

    def _find_lowest_resonance(self) -> int:
        """Find index of lowest-resonance entry in working memory."""
        if not self._key_index:
            return 0
        min_score = float("inf")
        min_idx = 0
        for i, key in enumerate(self._key_index):
            score = self.resonance_scores.get(key, 0.0)
            if score < min_score:
                min_score = score
                min_idx = i
        return min_idx

    def clear_working(self) -> None:
        """Clear working memory (keep long-term intact)."""
        self.working_memory.clear()
        self._key_index.clear()

    def clear_all(self) -> None:
        """Full zeroization — emergency memory wipe."""
        self.working_memory.clear()
        self.long_term.clear()
        self.resonance_scores.clear()
        self._key_index.clear()

    @property
    def working_size(self) -> int:
        return len(self.working_memory)

    @property
    def long_term_size(self) -> int:
        return len(self.long_term)

    def __repr__(self) -> str:
        return (
            f"TaurusMemory(working={self.working_size}, "
            f"long_term={self.long_term_size}, "
            f"capacity={self.capacity})"
        )
