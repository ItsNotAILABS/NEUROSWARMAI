#!/usr/bin/env python3
"""
Quality Gate — Self-contained packet verification tool.
Zero external dependencies. Exit 0 = pass, exit 1 = fail.

This is the builder's own quality gate. It verifies the builder packet itself.

Copyright © 2024-2026 Alfredo Medina Hernandez. All rights reserved.
SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
"""

import json
import sys
import os
from pathlib import Path


def check_structure(packet_dir):
    """Check all required artifacts exist."""
    required = [
        "README.md",
        "PACKET_POLICY.md",
        "manifest.json",
        "release_manifest.json",
        "reports/build_report.md",
        "reports/scores.json",
        "tools/quality_gate.py",
    ]
    missing = []
    for f in required:
        if not (Path(packet_dir) / f).exists():
            missing.append(f)
    return missing


def check_manifest_integrity(packet_dir):
    """Verify manifest lists real files."""
    manifest_path = Path(packet_dir) / "manifest.json"
    if not manifest_path.exists():
        return ["manifest.json missing"]
    with open(manifest_path) as fh:
        data = json.load(fh)
    errors = []
    for f in data.get("files", []):
        if not (Path(packet_dir) / f).exists():
            errors.append(f"listed in manifest but missing: {f}")
    return errors


def check_readme_completeness(packet_dir):
    """README must have at least 3 headings."""
    readme = Path(packet_dir) / "README.md"
    if not readme.exists():
        return ["README.md missing"]
    text = readme.read_text()
    headings = [line for line in text.splitlines() if line.startswith("#")]
    if len(headings) < 3:
        return [f"README has {len(headings)} headings, need >= 3"]
    return []


def check_scores(packet_dir):
    """All scores must be >= 0.7."""
    scores_path = Path(packet_dir) / "reports" / "scores.json"
    if not scores_path.exists():
        return ["reports/scores.json missing"]
    with open(scores_path) as fh:
        data = json.load(fh)
    errors = []
    for key, val in data.get("scores", {}).items():
        if val < 0.7:
            errors.append(f"score {key} = {val} < 0.7")
    return errors


def run_gate(packet_dir):
    """Run all quality checks."""
    packet_dir = str(Path(packet_dir).resolve())
    all_errors = []

    print(f"[GATE] Checking: {packet_dir}")

    errors = check_structure(packet_dir)
    if errors:
        all_errors.extend([f"STRUCTURE: {e}" for e in errors])

    errors = check_manifest_integrity(packet_dir)
    if errors:
        all_errors.extend([f"MANIFEST: {e}" for e in errors])

    errors = check_readme_completeness(packet_dir)
    if errors:
        all_errors.extend([f"README: {e}" for e in errors])

    errors = check_scores(packet_dir)
    if errors:
        all_errors.extend([f"SCORES: {e}" for e in errors])

    if all_errors:
        print("[GATE] FAILED:")
        for e in all_errors:
            print(f"  ✗ {e}")
        return False
    else:
        print("[GATE] PASSED ✓")
        return True


if __name__ == "__main__":
    target = sys.argv[1] if len(sys.argv) > 1 else "."
    success = run_gate(target)
    sys.exit(0 if success else 1)
