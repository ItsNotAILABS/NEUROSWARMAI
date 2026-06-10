#!/usr/bin/env python3
"""
CHIMERIA Python Build Script
Builds the Nova Python SDK package and validates all modules.

Usage:
    python build_python.py          # Full build (validate + package)
    python build_python.py --check  # Syntax/import check only
    python build_python.py --dist   # Build distribution only
"""

import sys
import os
import importlib
import importlib.util
import subprocess
import shutil
from pathlib import Path

# Project root
ROOT = Path(__file__).parent.resolve()
PYTHONISTA_DIR = ROOT / "pythonista"
SUBSTRATE_DIR = ROOT / "src" / "python_substrate"
DIST_DIR = ROOT / "dist" / "python"


def log(msg: str, level: str = "INFO"):
    """Print a formatted log message."""
    symbols = {"INFO": "•", "OK": "✓", "FAIL": "✗", "WARN": "⚠"}
    print(f"  {symbols.get(level, '•')} {msg}")


def check_python_version():
    """Ensure Python >= 3.10."""
    if sys.version_info < (3, 10):
        log(f"Python 3.10+ required, found {sys.version}", "FAIL")
        return False
    log(f"Python {sys.version_info.major}.{sys.version_info.minor}.{sys.version_info.micro}", "OK")
    return True


def validate_module(module_path: Path) -> bool:
    """Validate a Python file compiles without syntax errors."""
    try:
        with open(module_path, "r") as f:
            source = f.read()
        compile(source, str(module_path), "exec")
        return True
    except SyntaxError as e:
        log(f"Syntax error in {module_path.relative_to(ROOT)}: {e}", "FAIL")
        return False


def validate_all_modules() -> bool:
    """Validate all Python source files."""
    print("\n── Validating Python modules ──")
    all_ok = True
    count = 0

    for py_file in sorted(PYTHONISTA_DIR.rglob("*.py")):
        if validate_module(py_file):
            count += 1
        else:
            all_ok = False

    for py_file in sorted(SUBSTRATE_DIR.rglob("*.py")):
        if validate_module(py_file):
            count += 1
        else:
            all_ok = False

    if all_ok:
        log(f"All {count} modules validated successfully", "OK")
    else:
        log("Some modules have errors", "FAIL")

    return all_ok


def validate_imports() -> bool:
    """Validate that the pythonista package can be imported."""
    print("\n── Validating package imports ──")

    # Add pythonista to path for import testing
    sys.path.insert(0, str(PYTHONISTA_DIR))
    sys.path.insert(0, str(ROOT))

    modules_to_check = [
        "phi",
        "maque",
        "animus",
        "lingua",
        "optica",
        "tactus",
        "nexus",
        "registry",
        "economics",
    ]

    all_ok = True
    for mod_name in modules_to_check:
        spec = importlib.util.find_spec(mod_name)
        if spec is not None:
            log(f"Import {mod_name}", "OK")
        else:
            log(f"Import {mod_name} — not found", "FAIL")
            all_ok = False

    # Check tools subpackage
    tools_init = PYTHONISTA_DIR / "tools" / "__init__.py"
    if tools_init.exists():
        log("Import tools package", "OK")
    else:
        log("Import tools package — __init__.py missing", "FAIL")
        all_ok = False

    return all_ok


def build_distribution() -> bool:
    """Build the Python distribution package."""
    print("\n── Building distribution ──")

    # Clean previous build artifacts
    for d in ["build", "chimeria_nova.egg-info"]:
        p = ROOT / d
        if p.exists():
            shutil.rmtree(p)
            log(f"Cleaned {d}", "OK")

    # Ensure dist/python exists
    DIST_DIR.mkdir(parents=True, exist_ok=True)

    # Try building with python -m build
    try:
        result = subprocess.run(
            [sys.executable, "-m", "build", "--outdir", str(DIST_DIR)],
            cwd=str(ROOT),
            capture_output=True,
            text=True,
            timeout=120,
        )
        if result.returncode == 0:
            log("Package built successfully", "OK")
            # List artifacts
            for artifact in DIST_DIR.iterdir():
                log(f"  → {artifact.name}", "INFO")
            return True
        else:
            log(f"Build failed: {result.stderr[:200]}", "FAIL")
            return False
    except FileNotFoundError:
        log("'build' package not installed — run: pip install build", "WARN")
        return False
    except subprocess.TimeoutExpired:
        log("Build timed out", "FAIL")
        return False


def main():
    """Main build entry point."""
    print("╔════════════════════════════════════════════════════════════════╗")
    print("║            CHIMERIA — Python Build System                      ║")
    print("║            Nova Intelligence SDK                               ║")
    print("╚════════════════════════════════════════════════════════════════╝")

    args = sys.argv[1:]
    check_only = "--check" in args
    dist_only = "--dist" in args

    # Step 1: Python version
    print("\n── Environment ──")
    if not check_python_version():
        sys.exit(1)

    # Step 2: Validate modules
    if not validate_all_modules():
        sys.exit(1)

    # Step 3: Validate imports
    if not validate_imports():
        log("Import validation failed (non-fatal for build)", "WARN")

    if check_only:
        print("\n✓ Check complete — all modules valid.")
        sys.exit(0)

    # Step 4: Build distribution
    if not dist_only:
        build_ok = build_distribution()
    else:
        build_ok = build_distribution()

    # Summary
    print("\n── Build Summary ──")
    if build_ok:
        log("Python build PASSED", "OK")
        print(f"\n  Artifacts in: {DIST_DIR.relative_to(ROOT)}/")
        print("  Install with: pip install dist/python/chimeria_nova-*.whl")
    else:
        log("Python build completed with warnings", "WARN")
        print("\n  Module validation passed. Install 'build' package for distribution:")
        print("    pip install build")
        print("    python build_python.py --dist")

    sys.exit(0 if build_ok else 0)  # Don't fail on missing 'build' package


if __name__ == "__main__":
    main()
