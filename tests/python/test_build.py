"""
Basic build validation tests for the Nova Python SDK.
Ensures all modules compile and core engines initialize.
"""

import sys
from pathlib import Path

# Add pythonista to path
ROOT = Path(__file__).parent.parent.parent
sys.path.insert(0, str(ROOT / "pythonista"))


def test_phi_constants():
    """Verify φ constants are correctly defined."""
    from phi import PHI, PHI_INV, PHI_BEAT

    assert abs(PHI - 1.618033988749895) < 1e-10
    assert abs(PHI_INV - 0.618033988749895) < 1e-10
    assert PHI_BEAT == 873


def test_animus_engine_init():
    """Verify ANIMUS engine initializes."""
    from animus import AnimusEngine

    engine = AnimusEngine()
    assert engine is not None
    status = engine.status()
    assert "name" in status or "quad" in status or isinstance(status, dict)


def test_lingua_engine_init():
    """Verify LINGUA engine initializes."""
    from lingua import LinguaEngine

    engine = LinguaEngine()
    assert engine is not None


def test_optica_engine_init():
    """Verify OPTICA engine initializes."""
    from optica import OpticaEngine

    engine = OpticaEngine()
    assert engine is not None


def test_tactus_engine_init():
    """Verify TACTUS engine initializes."""
    from tactus import TactusEngine

    engine = TactusEngine()
    assert engine is not None


def test_nexus_engine_init():
    """Verify NEXUS engine initializes."""
    from nexus import NexusEngine

    engine = NexusEngine()
    assert engine is not None


def test_maque_quads():
    """Verify MAQUE QUADS and FLOS are populated."""
    from maque import QUADS, FLOS

    assert isinstance(QUADS, dict)
    assert isinstance(FLOS, dict)
    assert len(QUADS) > 0


def test_tools_base():
    """Verify NovaTool base class works."""
    from tools.base import NovaTool

    tool = NovaTool()
    assert tool.QUAD == "TOOL"
    assert tool.version is not None


def test_all_modules_compile():
    """Verify all .py files in pythonista/ have valid syntax."""
    pythonista_dir = ROOT / "pythonista"
    errors = []

    for py_file in pythonista_dir.rglob("*.py"):
        try:
            with open(py_file, "r") as f:
                compile(f.read(), str(py_file), "exec")
        except SyntaxError as e:
            errors.append(f"{py_file.relative_to(ROOT)}: {e}")

    assert errors == [], "Syntax errors found:\n" + "\n".join(errors)
