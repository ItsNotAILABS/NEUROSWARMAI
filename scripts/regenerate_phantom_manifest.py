#!/usr/bin/env python3
"""Regenerate phantom_qsha_hash_manifest.json with QSHA commitments."""

from __future__ import annotations

import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path[:0] = [str(ROOT), str(ROOT / "pythonista"), str(ROOT / "src")]

from pythonista.phantom_qsha.manifest import build_manifest  # noqa: E402


def main() -> int:
    out = ROOT / "pythonista" / "phantom_qsha" / "phantom_qsha_hash_manifest.json"
    manifest = build_manifest(output_path=out)
    print(f"Manifest: {len(manifest['files'])} files")
    print(f"Aggregate: {manifest['aggregate_commitment']}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())