"""
SovereignWireFormat — Schema-driven binary serialization without protobuf.

Tagged, length-prefixed fields with canonical encoding and QSHA commitments.
Supports deterministic round-trip for agent intents, model blobs, and receipts.
"""

from __future__ import annotations

import struct
from dataclasses import dataclass, field
from typing import Any, Mapping

from pythonista.phantom_qsha.canonical import canonical_json
from pythonista.phantom_qsha.errors import IntegrityError
from pythonista.phantom_qsha.qsha import qsha256_bytes

# Wire type tags (single-byte discriminators)
TAG_NULL = 0x00
TAG_BOOL = 0x01
TAG_INT = 0x02
TAG_FLOAT = 0x03
TAG_STR = 0x04
TAG_BYTES = 0x05
TAG_LIST = 0x06
TAG_MAP = 0x07
TAG_FIELD = 0xF0  # schema field wrapper: u16 name_len + name + value

MAGIC = b"PHSW"
VERSION = 1
HEADER_FMT = "<4sBHI"  # magic, version, schema_id, payload_len


@dataclass(frozen=True)
class WireSchema:
    """Named schema with ordered field names for canonical map encoding."""

    schema_id: int
    name: str
    fields: tuple[str, ...] = field(default_factory=tuple)

    def validate(self, obj: Mapping[str, Any]) -> None:
        missing = [f for f in self.fields if f not in obj]
        if missing:
            raise IntegrityError(f"schema {self.name} missing fields: {missing}")


def _encode_value(value: Any) -> bytes:
    if value is None:
        return bytes([TAG_NULL])
    if isinstance(value, bool):
        return bytes([TAG_BOOL, 1 if value else 0])
    if isinstance(value, int):
        return bytes([TAG_INT]) + struct.pack("<q", value)
    if isinstance(value, float):
        return bytes([TAG_FLOAT]) + struct.pack("<d", value)
    if isinstance(value, str):
        raw = value.encode("utf-8")
        return bytes([TAG_STR]) + struct.pack("<I", len(raw)) + raw
    if isinstance(value, (bytes, bytearray)):
        raw = bytes(value)
        return bytes([TAG_BYTES]) + struct.pack("<I", len(raw)) + raw
    if isinstance(value, list):
        parts = [bytes([TAG_LIST]) + struct.pack("<I", len(value))]
        for item in value:
            parts.append(_encode_value(item))
        return b"".join(parts)
    if isinstance(value, dict):
        keys = sorted(value.keys())
        parts = [bytes([TAG_MAP]) + struct.pack("<I", len(keys))]
        for key in keys:
            key_b = str(key).encode("utf-8")
            parts.append(struct.pack("<I", len(key_b)) + key_b)
            parts.append(_encode_value(value[key]))
        return b"".join(parts)
    raise IntegrityError(f"unsupported wire type: {type(value).__name__}")


def _decode_value(payload: bytes, offset: int) -> tuple[Any, int]:
    if offset >= len(payload):
        raise IntegrityError("unexpected end of wire payload")
    tag = payload[offset]
    offset += 1

    if tag == TAG_NULL:
        return None, offset
    if tag == TAG_BOOL:
        if offset >= len(payload):
            raise IntegrityError("truncated bool")
        return payload[offset] != 0, offset + 1
    if tag == TAG_INT:
        if offset + 8 > len(payload):
            raise IntegrityError("truncated int")
        (val,) = struct.unpack("<q", payload[offset : offset + 8])
        return val, offset + 8
    if tag == TAG_FLOAT:
        if offset + 8 > len(payload):
            raise IntegrityError("truncated float")
        (val,) = struct.unpack("<d", payload[offset : offset + 8])
        return val, offset + 8
    if tag == TAG_STR:
        if offset + 4 > len(payload):
            raise IntegrityError("truncated str length")
        (ln,) = struct.unpack("<I", payload[offset : offset + 4])
        offset += 4
        end = offset + ln
        if end > len(payload):
            raise IntegrityError("truncated str body")
        return payload[offset:end].decode("utf-8"), end
    if tag == TAG_BYTES:
        if offset + 4 > len(payload):
            raise IntegrityError("truncated bytes length")
        (ln,) = struct.unpack("<I", payload[offset : offset + 4])
        offset += 4
        end = offset + ln
        if end > len(payload):
            raise IntegrityError("truncated bytes body")
        return payload[offset:end], end
    if tag == TAG_LIST:
        if offset + 4 > len(payload):
            raise IntegrityError("truncated list length")
        (count,) = struct.unpack("<I", payload[offset : offset + 4])
        offset += 4
        items = []
        for _ in range(count):
            item, offset = _decode_value(payload, offset)
            items.append(item)
        return items, offset
    if tag == TAG_MAP:
        if offset + 4 > len(payload):
            raise IntegrityError("truncated map length")
        (count,) = struct.unpack("<I", payload[offset : offset + 4])
        offset += 4
        result: dict[str, Any] = {}
        for _ in range(count):
            if offset + 4 > len(payload):
                raise IntegrityError("truncated map key length")
            (klen,) = struct.unpack("<I", payload[offset : offset + 4])
            offset += 4
            key_end = offset + klen
            if key_end > len(payload):
                raise IntegrityError("truncated map key")
            key = payload[offset:key_end].decode("utf-8")
            offset = key_end
            val, offset = _decode_value(payload, offset)
            result[key] = val
        return result, offset

    raise IntegrityError(f"unknown wire tag: 0x{tag:02x}")


def encode_record(schema: WireSchema, obj: Mapping[str, Any]) -> bytes:
    """Encode a schema-bound record to sovereign wire bytes."""
    schema.validate(obj)
    body_parts: list[bytes] = []
    for name in schema.fields:
        name_b = name.encode("utf-8")
        value_b = _encode_value(obj[name])
        body_parts.append(
            bytes([TAG_FIELD])
            + struct.pack("<H", len(name_b))
            + name_b
            + value_b
        )
    body = b"".join(body_parts)
    header = struct.pack(HEADER_FMT, MAGIC, VERSION, schema.schema_id, len(body))
    return header + body


def decode_record(schema: WireSchema, payload: bytes) -> dict[str, Any]:
    """Decode sovereign wire bytes into a field-ordered dict."""
    if len(payload) < struct.calcsize(HEADER_FMT):
        raise IntegrityError("wire payload too short for header")
    magic, version, schema_id, body_len = struct.unpack(
        HEADER_FMT, payload[: struct.calcsize(HEADER_FMT)]
    )
    if magic != MAGIC:
        raise IntegrityError("invalid wire magic")
    if version != VERSION:
        raise IntegrityError(f"unsupported wire version: {version}")
    if schema_id != schema.schema_id:
        raise IntegrityError(f"schema id mismatch: {schema_id} != {schema.schema_id}")

    offset = struct.calcsize(HEADER_FMT)
    end = offset + body_len
    if end > len(payload):
        raise IntegrityError("truncated wire body")

    result: dict[str, Any] = {}
    while offset < end:
        if payload[offset] != TAG_FIELD:
            raise IntegrityError("expected TAG_FIELD in schema record")
        offset += 1
        if offset + 2 > end:
            raise IntegrityError("truncated field name length")
        (name_len,) = struct.unpack("<H", payload[offset : offset + 2])
        offset += 2
        name_end = offset + name_len
        if name_end > end:
            raise IntegrityError("truncated field name")
        name = payload[offset:name_end].decode("utf-8")
        offset = name_end
        value, offset = _decode_value(payload, offset)
        result[name] = value

    schema.validate(result)
    return result


def encode_freeform(obj: Any) -> bytes:
    """Encode arbitrary supported value without schema wrapper."""
    body = _encode_value(obj)
    header = struct.pack(HEADER_FMT, MAGIC, VERSION, 0, len(body))
    return header + body


def decode_freeform(payload: bytes) -> Any:
    """Decode freeform sovereign wire payload."""
    if len(payload) < struct.calcsize(HEADER_FMT):
        raise IntegrityError("wire payload too short for header")
    magic, version, schema_id, body_len = struct.unpack(
        HEADER_FMT, payload[: struct.calcsize(HEADER_FMT)]
    )
    if magic != MAGIC:
        raise IntegrityError("invalid wire magic")
    if version != VERSION:
        raise IntegrityError(f"unsupported wire version: {version}")
    if schema_id != 0:
        raise IntegrityError("freeform decode requires schema_id 0")

    offset = struct.calcsize(HEADER_FMT)
    end = offset + body_len
    if end > len(payload):
        raise IntegrityError("truncated wire body")
    value, final = _decode_value(payload, offset)
    if final != end:
        raise IntegrityError("trailing bytes in wire body")
    return value


def wire_commitment(payload: bytes) -> str:
    """QSHA commitment over sovereign wire bytes."""
    return qsha256_bytes(payload)


def json_fallback_commitment(obj: Any) -> str:
    """Canonical JSON commitment for public-proof surfaces."""
    return qsha256_bytes(canonical_json(obj))