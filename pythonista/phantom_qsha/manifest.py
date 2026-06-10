"""
Manifest — Build integrity verification.

Generates phantom_qsha_hash_manifest.json containing QSHA commitments
of all package source files for tamper detection.
"""

from __future__ import annotations

import json
import os
from pathlib import Path
from typing import Any

from pythonista.phantom_qsha.qsha import qsha256_bytes


def build_manifest(
    package_dir: str | Path | None = None,
    output_path: str | Path | None = None,
) -> dict[str, Any]:
    """Build a QSHA hash manifest for the package.

    Computes QSHA commitments of all .py files in the package directory
    and produces a manifest with per-file and aggregate hashes.

    Args:
        package_dir: Directory to scan (defaults to this package's dir).
        output_path: Where to write the JSON manifest. None skips writing.

    Returns:
        The manifest dictionary.
    """
    if package_dir is None:
        package_dir = Path(__file__).parent

    package_dir = Path(package_dir)
    files: dict[str, str] = {}

    for py_file in sorted(package_dir.rglob("*.py")):
        rel_path = str(py_file.relative_to(package_dir))
        content = py_file.read_bytes()
        files[rel_path] = qsha256_bytes(content)

    # Aggregate commitment over all file hashes
    aggregate_input = json.dumps(files, sort_keys=True, separators=(",", ":")).encode()
    aggregate_hash = qsha256_bytes(aggregate_input)

    manifest = {
        "package": "phantom_qsha",
        "version": "1.0.0",
        "domain": "MEDINA.PHANTOM.QSHA.v1",
        "files": files,
        "aggregate_commitment": aggregate_hash,
    }

    if output_path:
        output_path = Path(output_path)
        output_path.parent.mkdir(parents=True, exist_ok=True)
        data = json.dumps(manifest, indent=2)

        # Atomic write
        tmp_path = output_path.with_suffix(".tmp")
        fd = os.open(str(tmp_path), os.O_WRONLY | os.O_CREAT | os.O_TRUNC, 0o644)
        try:
            os.write(fd, data.encode("utf-8"))
            os.fsync(fd)
        finally:
            os.close(fd)
        os.replace(str(tmp_path), str(output_path))

    return manifest


if __name__ == "__main__":
    manifest = build_manifest(
        output_path=Path(__file__).parent / "phantom_qsha_hash_manifest.json"
    )
    print(f"Manifest generated: {len(manifest['files'])} files")
    print(f"Aggregate: {manifest['aggregate_commitment']}")
