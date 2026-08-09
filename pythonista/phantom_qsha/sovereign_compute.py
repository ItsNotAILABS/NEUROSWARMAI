"""
SovereignCompute — CPU inference kernels for SovereignModel graphs.

Pure-Python interpreter with quantized matmul path. No BLAS/CUDA dependencies.
"""

from __future__ import annotations

from typing import Any

from pythonista.phantom_qsha.errors import IntegrityError
from pythonista.phantom_qsha.sovereign_model import ModelNode, SovereignModel
from pythonista.phantom_qsha.sovereign_tensor import SovereignTensor


class SovereignInterpreter:
    """Execute SovereignModel graphs on CPU with deterministic ordering."""

    def __init__(self, model: SovereignModel, use_int8_matmul: bool = False):
        self.model = model
        self.use_int8_matmul = use_int8_matmul
        self._cache: dict[str, SovereignTensor] = {}

    def bind_input(self, name: str, tensor: SovereignTensor) -> None:
        if name not in self.model.inputs:
            raise IntegrityError(f"unknown model input: {name}")
        self._cache[name] = tensor

    def run(self, output_names: list[str] | None = None) -> dict[str, SovereignTensor]:
        self._cache = {k: v for k, v in self._cache.items() if k in self.model.inputs}
        for node in self.model.nodes:
            self._execute_node(node)
        targets = output_names or self.model.outputs
        missing = [n for n in targets if n not in self._cache]
        if missing:
            raise IntegrityError(f"outputs not produced: {missing}")
        return {name: self._cache[name] for name in targets}

    def _execute_node(self, node) -> None:
        op = node.op_type
        if op == "Const":
            weight_name = node.attrs.get("weight")
            if weight_name is None or weight_name not in self.model.weights:
                raise IntegrityError(f"Const node missing weight: {node.name}")
            out = self.model.weights[weight_name]
            for out_name in node.outputs:
                self._cache[out_name] = out
            return

        if op == "MatMul":
            if len(node.inputs) != 2 or len(node.outputs) != 1:
                raise IntegrityError(f"invalid MatMul arity: {node.name}")
            a = self._resolve(node.inputs[0])
            b = self._resolve(node.inputs[1])
            if self.use_int8_matmul:
                scale_a = float(node.attrs.get("scale_a", 0.1))
                scale_b = float(node.attrs.get("scale_b", 0.1))
                qa = a.quantize_int8(scale=scale_a)
                qb = b.quantize_int8(scale=scale_b)
                out = qa.matmul(qb).dequantize_int8(scale=scale_a * scale_b)
            else:
                out = a.matmul(b)
            self._cache[node.outputs[0]] = out
            return

        if op == "Add":
            if len(node.inputs) != 2 or len(node.outputs) != 1:
                raise IntegrityError(f"invalid Add arity: {node.name}")
            out = self._resolve(node.inputs[0]).add(self._resolve(node.inputs[1]))
            self._cache[node.outputs[0]] = out
            return

        if op == "Relu":
            if len(node.inputs) != 1 or len(node.outputs) != 1:
                raise IntegrityError(f"invalid Relu arity: {node.name}")
            self._cache[node.outputs[0]] = self._resolve(node.inputs[0]).relu()
            return

        if op == "Softmax":
            if len(node.inputs) != 1 or len(node.outputs) != 1:
                raise IntegrityError(f"invalid Softmax arity: {node.name}")
            self._cache[node.outputs[0]] = self._resolve(node.inputs[0]).softmax()
            return

        if op == "Conv2d":
            if len(node.inputs) != 2 or len(node.outputs) != 1:
                raise IntegrityError(f"invalid Conv2d arity: {node.name}")
            stride = int(node.attrs.get("stride", 1))
            padding = int(node.attrs.get("padding", 0))
            out = self._resolve(node.inputs[0]).conv2d(
                self._resolve(node.inputs[1]),
                stride=stride,
                padding=padding,
            )
            self._cache[node.outputs[0]] = out
            return

        if op == "Mul":
            if len(node.inputs) != 2 or len(node.outputs) != 1:
                raise IntegrityError(f"invalid Mul arity: {node.name}")
            left = self._resolve(node.inputs[0])
            right = self._resolve(node.inputs[1])
            if isinstance(node.attrs.get("scalar"), (int, float)):
                right = SovereignTensor([float(node.attrs["scalar"])] * left.size(), left.shape)
            out = left.elementwise_mul(right)
            self._cache[node.outputs[0]] = out
            return

        raise IntegrityError(f"unsupported op_type: {op}")

    def _resolve(self, name: str) -> SovereignTensor:
        if name not in self._cache:
            raise IntegrityError(f"tensor not available: {name}")
        return self._cache[name]


def build_linear_classifier(
    name: str,
    in_features: int,
    out_features: int,
    weights: SovereignTensor,
    bias: SovereignTensor,
) -> SovereignModel:
    """Helper: single linear layer + softmax classifier."""
    model = SovereignModel(
        name=name,
        version="1.0.0",
        inputs=["input"],
        outputs=["probabilities"],
        nodes=[
            ModelNode(
                name="weight_const",
                op_type="Const",
                inputs=[],
                outputs=["weight"],
                attrs={"weight": "weight"},
            ),
            ModelNode(
                name="bias_const",
                op_type="Const",
                inputs=[],
                outputs=["bias"],
                attrs={"weight": "bias"},
            ),
            ModelNode(
                name="matmul",
                op_type="MatMul",
                inputs=["input", "weight"],
                outputs=["logits"],
            ),
            ModelNode(
                name="add_bias",
                op_type="Add",
                inputs=["logits", "bias"],
                outputs=["biased"],
            ),
            ModelNode(
                name="softmax",
                op_type="Softmax",
                inputs=["biased"],
                outputs=["probabilities"],
            ),
        ],
    )
    model.set_weight("weight", weights)
    model.set_weight("bias", bias)
    if weights.shape != (in_features, out_features):
        raise IntegrityError("weights shape mismatch")
    if bias.shape != (1, out_features):
        raise IntegrityError("bias shape mismatch")
    return model


def run_forward(
    model: SovereignModel,
    inputs: dict[str, SovereignTensor],
    use_int8_matmul: bool = False,
) -> dict[str, SovereignTensor]:
    """Convenience one-shot inference."""
    interp = SovereignInterpreter(model, use_int8_matmul=use_int8_matmul)
    for name, tensor in inputs.items():
        interp.bind_input(name, tensor)
    return interp.run()