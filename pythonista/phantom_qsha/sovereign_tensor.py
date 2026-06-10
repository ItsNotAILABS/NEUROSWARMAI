"""
SovereignTensor — Deterministic tensor engine without NumPy/Torch.

Fixed-shape flat storage, pure-Python ops, and QSHA-bindable binary views.
Designed for small-model agent loops, edge inference, and formal verification.
"""

from __future__ import annotations

import struct
from typing import Iterable, Sequence, Tuple, Union

from pythonista.phantom_qsha.errors import IntegrityError

Shape = Tuple[int, ...]
Number = Union[int, float]


def _product(shape: Shape) -> int:
    if not shape:
        return 0
    total = 1
    for dim in shape:
        if dim < 0:
            raise ValueError(f"negative dimension: {dim}")
        total *= dim
    return total


def _linear_index(shape: Shape, indices: Sequence[int]) -> int:
    if len(indices) != len(shape):
        raise ValueError("index rank mismatch")
    idx = 0
    stride = 1
    for dim, i in zip(reversed(shape), reversed(indices)):
        if i < 0 or i >= dim:
            raise IndexError(f"index {i} out of range for dimension {dim}")
        idx += i * stride
        stride *= dim
    return idx


class SovereignTensor:
    """Minimal deterministic tensor. No external numerical dependencies."""

    __slots__ = ("shape", "data")

    def __init__(self, data: Sequence[Number], shape: Shape):
        self.shape = tuple(shape)
        expected = _product(self.shape)
        flat = [float(x) for x in data]
        if len(flat) != expected:
            raise IntegrityError(
                f"shape {self.shape} expects {expected} elements, got {len(flat)}"
            )
        self.data = flat

    @classmethod
    def zeros(cls, shape: Shape) -> SovereignTensor:
        return cls([0.0] * _product(shape), shape)

    @classmethod
    def ones(cls, shape: Shape) -> SovereignTensor:
        return cls([1.0] * _product(shape), shape)

    @classmethod
    def from_list(cls, nested: Sequence, shape: Shape | None = None) -> SovereignTensor:
        """Flatten nested lists into a tensor."""
        flat: list[float] = []

        def walk(node: Sequence) -> None:
            if not node:
                flat.append(0.0)
                return
            if isinstance(node[0], (int, float)):
                flat.extend(float(x) for x in node)
            else:
                for child in node:
                    walk(child)

        walk(nested)
        if shape is None:
            if len(nested) and not isinstance(nested[0], (int, float)):
                rows = len(nested)
                cols = len(nested[0]) if rows else 0
                shape = (rows, cols)
            else:
                shape = (len(flat),)
        return cls(flat, shape)

    def size(self) -> int:
        return len(self.data)

    def copy(self) -> SovereignTensor:
        return SovereignTensor(list(self.data), self.shape)

    def get(self, *indices: int) -> float:
        return self.data[_linear_index(self.shape, indices)]

    def set(self, value: Number, *indices: int) -> None:
        self.data[_linear_index(self.shape, indices)] = float(value)

    def reshape(self, new_shape: Shape) -> SovereignTensor:
        if _product(new_shape) != self.size():
            raise IntegrityError("reshape size mismatch")
        return SovereignTensor(list(self.data), new_shape)

    def add(self, other: SovereignTensor) -> SovereignTensor:
        self._assert_same_shape(other)
        return SovereignTensor(
            [a + b for a, b in zip(self.data, other.data)],
            self.shape,
        )

    def sub(self, other: SovereignTensor) -> SovereignTensor:
        self._assert_same_shape(other)
        return SovereignTensor(
            [a - b for a, b in zip(self.data, other.data)],
            self.shape,
        )

    def mul_scalar(self, scalar: Number) -> SovereignTensor:
        s = float(scalar)
        return SovereignTensor([x * s for x in self.data], self.shape)

    def elementwise_mul(self, other: SovereignTensor) -> SovereignTensor:
        self._assert_same_shape(other)
        return SovereignTensor(
            [a * b for a, b in zip(self.data, other.data)],
            self.shape,
        )

    def relu(self) -> SovereignTensor:
        return SovereignTensor([x if x > 0.0 else 0.0 for x in self.data], self.shape)

    def sum(self) -> float:
        total = 0.0
        for x in self.data:
            total += x
        return total

    def mean(self) -> float:
        if not self.data:
            return 0.0
        return self.sum() / len(self.data)

    def max(self) -> float:
        if not self.data:
            return 0.0
        best = self.data[0]
        for x in self.data[1:]:
            if x > best:
                best = x
        return best

    def argmax(self) -> int:
        if not self.data:
            return 0
        best_i = 0
        best_v = self.data[0]
        for i, x in enumerate(self.data[1:], start=1):
            if x > best_v:
                best_v = x
                best_i = i
        return best_i

    def softmax(self) -> SovereignTensor:
        if not self.data:
            return SovereignTensor([], self.shape)
        m = self.max()
        exps = [pow(2.718281828459045, x - m) for x in self.data]
        denom = sum(exps)
        if denom == 0.0:
            return SovereignTensor([0.0] * len(self.data), self.shape)
        return SovereignTensor([e / denom for e in exps], self.shape)

    def matmul(self, other: SovereignTensor) -> SovereignTensor:
        if len(self.shape) != 2 or len(other.shape) != 2:
            raise IntegrityError("matmul requires rank-2 tensors")
        m, k = self.shape
        k2, n = other.shape
        if k != k2:
            raise IntegrityError(f"matmul inner dim mismatch: {k} vs {k2}")
        result = [0.0] * (m * n)
        for i in range(m):
            row_base = i * k
            for j in range(n):
                acc = 0.0
                for p in range(k):
                    acc += self.data[row_base + p] * other.data[p * n + j]
                result[i * n + j] = acc
        return SovereignTensor(result, (m, n))

    def conv2d(
        self,
        kernel: SovereignTensor,
        stride: int = 1,
        padding: int = 0,
    ) -> SovereignTensor:
        """Depthwise 2D convolution for NCHW-style rank-4 tensors."""
        if len(self.shape) != 4 or len(kernel.shape) != 4:
            raise IntegrityError("conv2d expects NCHW rank-4 tensors")
        n, c, h, w = self.shape
        kn, kc, kh, kw = kernel.shape
        if n != kn or c != kc:
            raise IntegrityError("conv2d batch/channel mismatch")

        out_h = (h + 2 * padding - kh) // stride + 1
        out_w = (w + 2 * padding - kw) // stride + 1
        if out_h <= 0 or out_w <= 0:
            raise IntegrityError("conv2d output shape non-positive")

        output = [0.0] * (n * c * out_h * out_w)

        def in_offset(batch: int, ch: int, y: int, x: int) -> int:
            return ((batch * c + ch) * h + y) * w + x

        def k_offset(ch: int, ky: int, kx: int) -> int:
            return ((ch) * kh + ky) * kw + kx

        def out_offset(batch: int, ch: int, y: int, x: int) -> int:
            return ((batch * c + ch) * out_h + y) * out_w + x

        for b in range(n):
            for ch in range(c):
                for oy in range(out_h):
                    for ox in range(out_w):
                        acc = 0.0
                        for ky in range(kh):
                            iy = oy * stride + ky - padding
                            if iy < 0 or iy >= h:
                                continue
                            for kx in range(kw):
                                ix = ox * stride + kx - padding
                                if ix < 0 or ix >= w:
                                    continue
                                acc += (
                                    self.data[in_offset(b, ch, iy, ix)]
                                    * kernel.data[k_offset(ch, ky, kx)]
                                )
                        output[out_offset(b, ch, oy, ox)] = acc
        return SovereignTensor(output, (n, c, out_h, out_w))

    def quantize_int8(self, scale: float = 1.0, zero_point: int = 0) -> SovereignTensor:
        if scale == 0.0:
            raise IntegrityError("quantize scale must be non-zero")
        q = []
        for x in self.data:
            raw = int(round(x / scale) + zero_point)
            if raw < -128:
                raw = -128
            elif raw > 127:
                raw = 127
            q.append(float(raw))
        return SovereignTensor(q, self.shape)

    def dequantize_int8(self, scale: float = 1.0, zero_point: int = 0) -> SovereignTensor:
        return SovereignTensor(
            [(x - zero_point) * scale for x in self.data],
            self.shape,
        )

    def to_bytes(self) -> bytes:
        return struct.pack(f"<{len(self.data)}f", *self.data)

    @classmethod
    def from_bytes(cls, payload: bytes, shape: Shape) -> SovereignTensor:
        expected = _product(shape) * 4
        if len(payload) != expected:
            raise IntegrityError(
                f"byte payload length {len(payload)} != expected {expected}"
            )
        data = list(struct.unpack(f"<{len(payload) // 4}f", payload))
        return cls(data, shape)

    def _assert_same_shape(self, other: SovereignTensor) -> None:
        if self.shape != other.shape:
            raise IntegrityError(f"shape mismatch: {self.shape} vs {other.shape}")

    def __eq__(self, other: object) -> bool:
        if not isinstance(other, SovereignTensor):
            return False
        return self.shape == other.shape and self.data == other.data

    def __repr__(self) -> str:
        return f"SovereignTensor(shape={self.shape}, data={self.data[:4]}{'...' if len(self.data) > 4 else ''})"