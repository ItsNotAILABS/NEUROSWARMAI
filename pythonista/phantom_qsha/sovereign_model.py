"""
SovereignModelFormat — Minimal ONNX-lite graph + weights container.

Nodes, attributes, and weight tensors without external graph engines.
Execution via SovereignCompute interpreter.
"""

from __future__ import annotations

from dataclasses import dataclass, field
from typing import Any, Mapping

from pythonista.phantom_qsha.errors import IntegrityError
from pythonista.phantom_qsha.qsha import qsha256_obj
from pythonista.phantom_qsha.sovereign_tensor import SovereignTensor
from pythonista.phantom_qsha.sovereign_wire import (
    HEADER_FMT,
    WireSchema,
    decode_record,
    encode_record,
    wire_commitment,
)
import struct

MODEL_SCHEMA = WireSchema(
    schema_id=0x4D4F,  # 'MO'
    name="sovereign.model.v1",
    fields=("name", "version", "inputs", "outputs", "nodes", "weights_meta"),
)

WEIGHT_BLOB_SCHEMA = WireSchema(
    schema_id=0x5747,  # 'WG'
    name="sovereign.weights.v1",
    fields=("name", "shape", "dtype", "bytes"),
)


@dataclass
class ModelNode:
    """Single graph node."""

    name: str
    op_type: str
    inputs: list[str]
    outputs: list[str]
    attrs: dict[str, Any] = field(default_factory=dict)

    def to_dict(self) -> dict[str, Any]:
        return {
            "name": self.name,
            "op_type": self.op_type,
            "inputs": self.inputs,
            "outputs": self.outputs,
            "attrs": self.attrs,
        }

    @classmethod
    def from_dict(cls, raw: Mapping[str, Any]) -> ModelNode:
        return cls(
            name=str(raw["name"]),
            op_type=str(raw["op_type"]),
            inputs=list(raw.get("inputs", [])),
            outputs=list(raw.get("outputs", [])),
            attrs=dict(raw.get("attrs", {})),
        )


@dataclass
class SovereignModel:
    """Portable model graph with named weight tensors."""

    name: str
    version: str
    inputs: list[str]
    outputs: list[str]
    nodes: list[ModelNode]
    weights: dict[str, SovereignTensor] = field(default_factory=dict)

    def add_node(self, node: ModelNode) -> None:
        self.nodes.append(node)

    def set_weight(self, name: str, tensor: SovereignTensor) -> None:
        self.weights[name] = tensor

    def weights_meta(self) -> dict[str, Any]:
        meta: dict[str, Any] = {}
        for name, tensor in sorted(self.weights.items()):
            meta[name] = {
                "shape": list(tensor.shape),
                "commitment": qsha256_obj(
                    {"shape": list(tensor.shape), "bytes": tensor.to_bytes().hex()}
                ),
            }
        return meta

    def graph_dict(self) -> dict[str, Any]:
        return {
            "name": self.name,
            "version": self.version,
            "inputs": self.inputs,
            "outputs": self.outputs,
            "nodes": [n.to_dict() for n in self.nodes],
            "weights_meta": self.weights_meta(),
        }

    def graph_commitment(self) -> str:
        return qsha256_obj(self.graph_dict())

    def to_wire(self) -> bytes:
        record = {
            "name": self.name,
            "version": self.version,
            "inputs": self.inputs,
            "outputs": self.outputs,
            "nodes": [n.to_dict() for n in self.nodes],
            "weights_meta": self.weights_meta(),
        }
        return encode_record(MODEL_SCHEMA, record)

    @classmethod
    def from_wire(cls, payload: bytes) -> SovereignModel:
        record = decode_record(MODEL_SCHEMA, payload)
        nodes = [ModelNode.from_dict(n) for n in record["nodes"]]
        return cls(
            name=record["name"],
            version=record["version"],
            inputs=list(record["inputs"]),
            outputs=list(record["outputs"]),
            nodes=nodes,
        )

    def weight_blob(self, name: str) -> bytes:
        if name not in self.weights:
            raise IntegrityError(f"unknown weight: {name}")
        tensor = self.weights[name]
        record = {
            "name": name,
            "shape": list(tensor.shape),
            "dtype": "f32",
            "bytes": tensor.to_bytes(),
        }
        return encode_record(WEIGHT_BLOB_SCHEMA, record)

    def load_weight_blob(self, payload: bytes) -> None:
        record = decode_record(WEIGHT_BLOB_SCHEMA, payload)
        shape = tuple(int(x) for x in record["shape"])
        tensor = SovereignTensor.from_bytes(record["bytes"], shape)
        self.weights[record["name"]] = tensor

    def package_bytes(self) -> bytes:
        """Full package: graph wire + length-prefixed weight blobs."""
        parts = [self.to_wire()]
        for name in sorted(self.weights.keys()):
            blob = self.weight_blob(name)
            parts.append(len(blob).to_bytes(4, "big"))
            parts.append(blob)
        return b"".join(parts)

    @classmethod
    def from_package_bytes(cls, payload: bytes) -> SovereignModel:
        if len(payload) < 12:
            raise IntegrityError("model package too short")
        # Graph wire is self-describing via header body_len
        if len(payload) < struct.calcsize(HEADER_FMT):
            raise IntegrityError("truncated model header")
        _, _, _, body_len = struct.unpack(HEADER_FMT, payload[: struct.calcsize(HEADER_FMT)])
        graph_end = struct.calcsize(HEADER_FMT) + body_len
        model = cls.from_wire(payload[:graph_end])
        offset = graph_end
        while offset < len(payload):
            if offset + 4 > len(payload):
                raise IntegrityError("truncated weight length")
            blob_len = int.from_bytes(payload[offset : offset + 4], "big")
            offset += 4
            blob_end = offset + blob_len
            if blob_end > len(payload):
                raise IntegrityError("truncated weight blob")
            model.load_weight_blob(payload[offset:blob_end])
            offset = blob_end
        return model

    def package_commitment(self) -> str:
        return wire_commitment(self.package_bytes())