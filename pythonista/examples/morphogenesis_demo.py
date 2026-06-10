#!/usr/bin/env python3
"""
Example: Turing Morphogenesis Patterns
Nova by FreddyCreates — Pythonista iOS

This example runs Turing reaction-diffusion morphogenesis
using the Gray-Scott model. Watch patterns emerge!
"""

from tactus import TuringMorphogenesis
from phi import PHI, PHI_INV

def run_morphogenesis_demo(
    width: int = 40,
    height: int = 20,
    steps: int = 500,
    display_interval: int = 50
):
    """
    Run Turing morphogenesis demonstration.
    
    The Turing reaction-diffusion model shows how complex patterns
    can emerge from simple rules. This is the FABRICA engine's
    pattern generation capability.
    
    Math:
        du/dt = Du∇²u + f(u,v)
        dv/dt = Dv∇²v + g(u,v)
    
    Gray-Scott model:
        f = -uv² + F(1-u)
        g = uv² - (F+k)v
    """
    print("╔════════════════════════════════════════════════════════════════╗")
    print("║         Turing Morphogenesis — Nova FABRICA                    ║")
    print("╚════════════════════════════════════════════════════════════════╝")
    print()
    print(f"Grid: {width}×{height} | Steps: {steps}")
    print(f"Parameters: Du=0.16, Dv=0.08, F=0.055, k=0.062")
    print()
    
    morph = TuringMorphogenesis(width=width, height=height)
    
    print("Initial state:")
    display_pattern(morph.v, width, height)
    print()
    
    for step in range(0, steps + 1, display_interval):
        if step > 0:
            morph.run(steps=display_interval)
        
        if step % display_interval == 0:
            entropy = morph.pattern_entropy()
            print(f"Step {step:4d} | Entropy: {entropy:.4f}")
            display_pattern(morph.v, width, height)
            print()
    
    # Final state
    print("─" * 60)
    final_entropy = morph.pattern_entropy()
    print(f"Final entropy: {final_entropy:.4f}")
    print(f"φ⁻¹ reference: {PHI_INV:.4f}")
    print()
    
    return morph

def display_pattern(field, width, height):
    """Display pattern using ASCII characters."""
    chars = " ░▒▓█"  # 5 levels
    
    for y in range(height):
        line = ""
        for x in range(width):
            v = field[y][x]
            # Map to character level
            level = int(v * (len(chars) - 1))
            level = max(0, min(len(chars) - 1, level))
            line += chars[level]
        print(line)

def explore_parameters():
    """Explore different parameter combinations."""
    print("\n" + "═" * 60)
    print("Exploring parameter space:")
    print("═" * 60 + "\n")
    
    # Different parameter sets produce different patterns
    params = [
        (0.055, 0.062, "Spots"),           # Default
        (0.035, 0.065, "Maze/Coral"),
        (0.025, 0.060, "Unstable"),
        (0.040, 0.060, "Stripes"),
    ]
    
    for F, k, name in params:
        print(f"\n{name} (F={F}, k={k}):")
        morph = TuringMorphogenesis(width=30, height=10, F=F, k=k)
        morph.run(steps=200)
        display_pattern(morph.v, 30, 10)
        print(f"Entropy: {morph.pattern_entropy():.4f}")
    
    print()

if __name__ == '__main__':
    morph = run_morphogenesis_demo(width=40, height=15, steps=300, display_interval=100)
    explore_parameters()
    print("✓ Morphogenesis demo complete.")
