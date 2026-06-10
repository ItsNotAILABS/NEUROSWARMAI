#!/usr/bin/env python3
"""
PHI — φ Constants and Fibonacci Utilities for Nova
Nova by FreddyCreates — The Golden Ratio as Operating Principle

φ = 1.618033988749895 — the golden ratio
φ⁻¹ = 0.618033988749895 — the inverse, our threshold and learning rate seed
PHI_BEAT = 873ms — the organism's heartbeat (φ⁻¹ × 1413ms)

All constants derived from biology and physics, not arbitrary choices.
"""

import math
from typing import List, Generator

# ─── The Golden Ratio ────────────────────────────────────────────────────────
PHI = 1.6180339887498949       # φ — the golden ratio
PHI_INV = 0.6180339887498949   # φ⁻¹ — 1/φ = φ-1
PHI_SQ = PHI * PHI             # φ² = φ+1 = 2.618...
PHI_BEAT = 873                 # ms — synchronized heartbeat
PHI_COUPLING = PHI + 1         # 2.618 — Kuramoto coupling constant

# ─── Fibonacci Sequence ──────────────────────────────────────────────────────
# F(n) converges to φ as n→∞: lim(F(n+1)/F(n)) = φ
FIB_CACHE = [0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181]

def fib(n: int) -> int:
    """Return the nth Fibonacci number (0-indexed)."""
    if n < len(FIB_CACHE):
        return FIB_CACHE[n]
    a, b = FIB_CACHE[-2], FIB_CACHE[-1]
    for _ in range(len(FIB_CACHE), n + 1):
        a, b = b, a + b
    return b

def fib_gen(max_n: int = 100) -> Generator[int, None, None]:
    """Generate Fibonacci numbers up to index max_n."""
    a, b = 0, 1
    for _ in range(max_n):
        yield a
        a, b = b, a + b

def fib_version(n: int) -> str:
    """Return Fibonacci-versioned string F{n} → 0.{fib(n)}.0"""
    f = fib(n)
    return f"0.{f}.0"

# ─── φ-Encoded Learning Rates ────────────────────────────────────────────────
# These are derived from powers of φ⁻¹, matching biological learning rates
PHI_LR_1 = PHI_INV              # 0.618 — threshold
PHI_LR_2 = PHI_INV ** 2         # 0.382 — decay
PHI_LR_3 = PHI_INV ** 3         # 0.236 — momentum
PHI_LR_4 = PHI_INV ** 4         # 0.146 — fine-tune (Hebbian η)
PHI_LR_5 = PHI_INV ** 5         # 0.090 — micro-adjust

# ─── φ-Loss Function (from Paper VII) ────────────────────────────────────────
def phi_loss(L_CE: float, coherence_score: float) -> float:
    """
    Compute φ-encoded loss from Liquid Language & Phantom Thought Theory.
    L_nova = L_CE × (1 + φ⁻¹ × CS)
    
    Args:
        L_CE: Cross-entropy loss
        coherence_score: Coherence score (0 to 1, capped at φ⁻¹)
    
    Returns:
        φ-weighted loss
    """
    CS = min(coherence_score, PHI_INV)  # hard cap at φ⁻¹
    return L_CE * (1 + PHI_INV * CS)

# ─── φ-Threshold Functions ───────────────────────────────────────────────────
def above_threshold(value: float, threshold: float = PHI_INV) -> bool:
    """Check if value exceeds φ-threshold (default φ⁻¹ = 0.618)."""
    return value > threshold

def phi_normalize(x: float) -> float:
    """Normalize value toward φ⁻¹ equilibrium."""
    return (x + PHI_INV) / PHI

def phi_scale(x: float, depth: int = 1) -> float:
    """Scale value by φ⁻ᵈᵉᵖᵗʰ — exponential decay."""
    return x * (PHI_INV ** depth)

# ─── Time Alignment ──────────────────────────────────────────────────────────
def phi_time_align(timestamp_ms: int) -> int:
    """Align timestamp to PHI_BEAT grid (873ms intervals)."""
    return round(timestamp_ms / PHI_BEAT) * PHI_BEAT

def phi_beat_count(duration_ms: int) -> int:
    """Count PHI_BEAT intervals in a duration."""
    return duration_ms // PHI_BEAT

# ─── Constants Export ────────────────────────────────────────────────────────
CONSTANTS = {
    'PHI': PHI,
    'PHI_INV': PHI_INV,
    'PHI_SQ': PHI_SQ,
    'PHI_BEAT': PHI_BEAT,
    'PHI_COUPLING': PHI_COUPLING,
    'PHI_LR_1': PHI_LR_1,
    'PHI_LR_2': PHI_LR_2,
    'PHI_LR_3': PHI_LR_3,
    'PHI_LR_4': PHI_LR_4,
    'PHI_LR_5': PHI_LR_5,
}

# ─── Self-Test ───────────────────────────────────────────────────────────────
if __name__ == '__main__':
    print("╔════════════════════════════════════════════════════════════════╗")
    print("║                  Nova φ Constants — Self-Test                   ║")
    print("╚════════════════════════════════════════════════════════════════╝")
    print()
    print(f"  φ (PHI)          = {PHI}")
    print(f"  φ⁻¹ (PHI_INV)    = {PHI_INV}")
    print(f"  φ² (PHI_SQ)      = {PHI_SQ}")
    print(f"  PHI_BEAT         = {PHI_BEAT} ms")
    print(f"  PHI_COUPLING     = {PHI_COUPLING}")
    print()
    print("  Fibonacci sequence (first 20):")
    print(f"    {list(fib_gen(20))}")
    print()
    print("  φ-Learning rates:")
    print(f"    φ⁻¹ = {PHI_LR_1:.6f}  (threshold)")
    print(f"    φ⁻² = {PHI_LR_2:.6f}  (decay)")
    print(f"    φ⁻³ = {PHI_LR_3:.6f}  (momentum)")
    print(f"    φ⁻⁴ = {PHI_LR_4:.6f}  (Hebbian η)")
    print(f"    φ⁻⁵ = {PHI_LR_5:.6f}  (micro)")
    print()
    print("  φ-Loss test (L_CE=1.0, CS=0.5):")
    print(f"    L_nova = {phi_loss(1.0, 0.5):.6f}")
    print()
    print("  Verification: φ × φ⁻¹ =", PHI * PHI_INV)  # Should be 1.0
    print("  Verification: φ² - φ =", PHI_SQ - PHI)     # Should be 1.0
    print()
    print("  ✓ Nova φ constants initialized — the golden ratio is alive.")
