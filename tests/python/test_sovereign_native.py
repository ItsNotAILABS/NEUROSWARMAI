"""
Tests for Sovereign Native Stack — tensor, wire, model, compute.

Dependency-free replacements for NumPy, protobuf, ONNX-lite, and CPU kernels.
"""

from __future__ import annotations

import pytest

from pythonista.phantom_qsha.errors import IntegrityError
from pythonista.phantom_qsha.sovereign_compute import (
    SovereignInterpreter,
    build_linear_classifier,
    run_forward,
)
from pythonista.phantom_qsha.sovereign_model import ModelNode, SovereignModel
from pythonista.phantom_qsha.sovereign_tensor import SovereignTensor
from pythonista.phantom_qsha.sovereign_wire import (
    WireSchema,
    decode_freeform,
    decode_record,
    encode_freeform,
    encode_record,
    json_fallback_commitment,
    wire_commitment,
)


class TestSovereignTensor:
    def test_matmul(self):
        a = SovereignTensor([1.0, 2.0, 3.0, 4.0], (2, 2))
        b = SovereignTensor([1.0, 0.0, 0.0, 1.0], (2, 2))
        c = a.matmul(b)
        assert c.data == [1.0, 2.0, 3.0, 4.0]

    def test_relu_and_softmax(self):
        t = SovereignTensor([-1.0, 0.0, 2.0], (3,))
        r = t.relu()
        assert r.data == [0.0, 0.0, 2.0]
        s = t.softmax()
        assert abs(sum(s.data) - 1.0) < 1e-6

    def test_bytes_roundtrip(self):
        t = SovereignTensor([1.5, 2.5, 3.5, 4.5], (2, 2))
        restored = SovereignTensor.from_bytes(t.to_bytes(), (2, 2))
        assert t == restored

    def test_quantize_dequantize(self):
        t = SovereignTensor([0.1, 0.2, -0.3, 0.4], (4,))
        q = t.quantize_int8(scale=0.1)
        d = q.dequantize_int8(scale=0.1)
        for orig, val in zip(t.data, d.data):
            assert abs(orig - val) <= 0.15

    def test_conv2d(self):
        x = SovereignTensor([1.0, 2.0, 3.0, 4.0], (1, 1, 2, 2))
        k = SovereignTensor([1.0, 0.0, 0.0, 1.0], (1, 1, 2, 2))
        y = x.conv2d(k)
        assert y.shape == (1, 1, 1, 1)
        assert y.data[0] == 5.0


class TestSovereignWire:
    SCHEMA = WireSchema(
        schema_id=0x7E57,
        name="test.intent",
        fields=("wire_id", "route", "payload_commitment"),
    )

    def test_schema_roundtrip(self):
        obj = {
            "wire_id": "sw-001",
            "route": "internal/cognitive",
            "payload_commitment": "abc123",
        }
        wire = encode_record(self.SCHEMA, obj)
        restored = decode_record(self.SCHEMA, wire)
        assert restored == obj

    def test_freeform_roundtrip(self):
        obj = {"agents": ["alpha", "beta"], "ttl": 30, "nested": [1, 2, 3]}
        wire = encode_freeform(obj)
        restored = decode_freeform(wire)
        assert restored == obj

    def test_commitment_stable(self):
        wire = encode_freeform({"a": 1, "b": 2})
        assert wire_commitment(wire) == wire_commitment(wire)
        assert len(json_fallback_commitment({"b": 2, "a": 1})) == 64

    def test_missing_field_raises(self):
        with pytest.raises(IntegrityError):
            encode_record(self.SCHEMA, {"wire_id": "x"})


class TestSovereignModel:
    def test_package_roundtrip(self):
        model = SovereignModel(
            name="agent_head",
            version="1.0.0",
            inputs=["input"],
            outputs=["probabilities"],
            nodes=[],
        )
        model.set_weight("w", SovereignTensor([1.0, 0.0, 0.0, 1.0], (2, 2)))
        pkg = model.package_bytes()
        restored = SovereignModel.from_package_bytes(pkg)
        assert restored.name == "agent_head"
        assert "w" in restored.weights
        assert restored.package_commitment() == model.package_commitment()

    def test_graph_commitment_changes_with_weights(self):
        m1 = SovereignModel("m", "1", ["x"], ["y"], [])
        m2 = SovereignModel("m", "1", ["x"], ["y"], [])
        m1.set_weight("w", SovereignTensor([1.0], (1,)))
        m2.set_weight("w", SovereignTensor([2.0], (1,)))
        assert m1.graph_commitment() != m2.graph_commitment()


class TestSovereignCompute:
    def test_linear_classifier(self):
        weights = SovereignTensor([1.0, 0.0, 0.0, 1.0], (2, 2))
        bias = SovereignTensor([0.0, 0.0], (1, 2))
        model = build_linear_classifier("cls", 2, 2, weights, bias)
        inp = SovereignTensor([1.0, 0.0], (1, 2))
        out = run_forward(model, {"input": inp})
        probs = out["probabilities"]
        assert abs(sum(probs.data) - 1.0) < 1e-6
        assert probs.argmax() == 0

    def test_int8_matmul_path(self):
        weights = SovereignTensor([0.5, 0.1, 0.1, 0.5], (2, 2))
        bias = SovereignTensor([0.0, 0.0], (1, 2))
        model = build_linear_classifier("cls_q", 2, 2, weights, bias)
        inp = SovereignTensor([1.0, 1.0], (1, 2))
        fp = run_forward(model, {"input": inp}, use_int8_matmul=False)
        q = run_forward(model, {"input": inp}, use_int8_matmul=True)
        assert abs(fp["probabilities"].sum() - 1.0) < 1e-6
        assert abs(q["probabilities"].sum() - 1.0) < 1e-6

    def test_custom_graph(self):
        model = SovereignModel(
            name="relu_chain",
            version="1",
            inputs=["x"],
            outputs=["y"],
            nodes=[
                ModelNode("c", "Const", [], ["w"], {"weight": "w"}),
                ModelNode("mm", "MatMul", ["x", "w"], ["z"]),
                ModelNode("r", "Relu", ["z"], ["y"]),
            ],
        )
        model.set_weight("w", SovereignTensor([2.0], (1, 1)))
        interp = SovereignInterpreter(model)
        interp.bind_input("x", SovereignTensor([-1.0], (1, 1)))
        out = interp.run()
        assert out["y"].data == [0.0]