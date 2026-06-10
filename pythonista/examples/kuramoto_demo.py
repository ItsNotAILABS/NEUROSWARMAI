#!/usr/bin/env python3
"""
Example: Kuramoto Oscillator Visualization
Nova by FreddyCreates — Pythonista iOS

This example runs the Kuramoto oscillator field and visualizes
the synchronization trajectory. In Pythonista with matplotlib,
you can see the beautiful emergence of coherence.
"""

from animus import KuramotoField
from phi import PHI, PHI_INV

def run_kuramoto_demo(
    n_oscillators: int = 89,  # F11 = 89
    coupling: float = 2.618,   # φ+1
    steps: int = 500
):
    """
    Run Kuramoto oscillator demonstration.
    
    The Kuramoto model shows how many oscillators can synchronize
    when coupled together. This is the mathematical foundation
    of neural synchronization in ANIMUS.
    
    Math: dθᵢ/dt = ωᵢ + (K/N) Σⱼ sin(θⱼ − θᵢ)
    
    K = φ+1 = 2.618 is the critical coupling constant
    r = order parameter (0=chaos, 1=sync)
    Threshold: r > φ⁻¹ = 0.618 indicates coherent reasoning
    """
    print("╔════════════════════════════════════════════════════════════════╗")
    print("║            Kuramoto Oscillator Field — Nova ANIMUS             ║")
    print("╚════════════════════════════════════════════════════════════════╝")
    print()
    print(f"N oscillators: {n_oscillators} (F11 Fibonacci)")
    print(f"Coupling K: {coupling:.3f} (φ+1)")
    print(f"Coherence threshold: {PHI_INV:.3f} (φ⁻¹)")
    print()
    print("Running simulation...")
    print()
    
    field = KuramotoField(N=n_oscillators, K=coupling)
    
    # Run and collect trajectory
    trajectory = []
    for step in range(steps):
        field.step()
        if step % 10 == 0:
            r = field.order_parameter()
            trajectory.append(r)
            
            # Print progress bar
            if step % 50 == 0:
                bar_len = int(r * 30)
                bar = '█' * bar_len + '░' * (30 - bar_len)
                status = '✓ COHERENT' if r > PHI_INV else '  chaos'
                print(f"Step {step:4d}: r={r:.4f} |{bar}| {status}")
    
    print()
    
    # Final state
    r_final = trajectory[-1]
    coherent = r_final > PHI_INV
    
    print("─" * 60)
    print("Result:")
    print(f"  Final order parameter (r): {r_final:.4f}")
    print(f"  Coherent (r > φ⁻¹): {coherent}")
    print(f"  Synchronization: {'ACHIEVED' if coherent else 'NOT ACHIEVED'}")
    print()
    
    # ASCII visualization of trajectory
    print("Trajectory (r over time):")
    print()
    
    # Downsample for display
    display_points = 40
    step_size = len(trajectory) // display_points
    
    for row in range(10, -1, -1):
        threshold = row / 10
        line = ""
        for i in range(0, len(trajectory), step_size):
            if i < len(trajectory):
                if trajectory[i] >= threshold:
                    line += "█"
                else:
                    line += " "
        
        # Mark φ⁻¹ threshold
        if abs(threshold - PHI_INV) < 0.05:
            print(f"φ⁻¹ → {threshold:.1f} |{line}|")
        else:
            print(f"     {threshold:.1f} |{line}|")
    
    print(f"          {'─' * display_points}")
    print(f"          0{' ' * (display_points - 6)}time→")
    print()
    
    return trajectory, coherent

def compare_couplings():
    """Compare synchronization with different coupling constants."""
    print("\n" + "═" * 60)
    print("Comparing coupling constants:")
    print("═" * 60 + "\n")
    
    couplings = [
        (1.0, "K=1.0 (weak)"),
        (PHI, "K=φ (golden)"),
        (PHI + 1, "K=φ+1 (critical)"),
        (3.0, "K=3.0 (strong)"),
    ]
    
    for K, label in couplings:
        field = KuramotoField(N=50, K=K)
        trajectory = field.run(T=200)
        r_final = trajectory[-1]
        status = "✓" if r_final > PHI_INV else "✗"
        print(f"  {label:20s}: r={r_final:.4f} {status}")
    
    print()
    print("Note: K=φ+1=2.618 is the optimal coupling for Nova.")

if __name__ == '__main__':
    trajectory, coherent = run_kuramoto_demo()
    compare_couplings()
    print("✓ Kuramoto demo complete.")
