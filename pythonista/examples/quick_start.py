#!/usr/bin/env python3
"""
Example: Quick Start with Nova
Nova by FreddyCreates — Pythonista iOS

Run this to see Nova in action. Just copy to Pythonista and run!
"""

# Quick way to use Nova
from nova_app import Nova

# Create Nova instance
nova = Nova()

print("╔════════════════════════════════════════════════════════════════╗")
print("║              Nova Quick Start — Pythonista iOS                 ║")
print("╚════════════════════════════════════════════════════════════════╝")
print()

# 1. Reason about something
print("─── REASONING ───")
query = "The golden ratio φ appears in nautilus shells, sunflower seeds, and galaxy spirals."
result = nova.reason(query)
print(f"Query: {query[:50]}...")
print(f"Kuramoto order parameter (r): {result['kuramoto']['order_r']}")
print(f"Coherent (r > φ⁻¹): {result['kuramoto']['coherent']}")
print(f"φ-Loss: {result['phi_loss']['L_nova']}")
print()

# 2. Analyze language
print("─── LANGUAGE ANALYSIS ───")
text = "The organism communicates through synchronized oscillator fields."
analysis = nova.analyze(text)
print(f"Text: {text[:50]}...")
print(f"Coherence score: {analysis['coherence']}")
print(f"Type-Token Ratio: {analysis['ttr']}")
print(f"Above φ⁻¹ ceiling: {analysis['phi_loss']['above_ceiling']}")
print()

# 3. Sense the body (uses real sensors on iOS!)
print("─── BODY SENSING ───")
sense = nova.sense()
print(f"Accelerometer: x={sense['accelerometer']['x']:.3f}, y={sense['accelerometer']['y']:.3f}, z={sense['accelerometer']['z']:.3f}")
print(f"Source: {sense['accelerometer']['source']}")
print(f"Proprioception (first 3): {sense['proprioception'][:3]}")
print()

# 4. Visual analysis
print("─── VISUAL ANALYSIS ───")
visual = nova.see()
print(f"Mean saliency: {visual['mean_saliency']}")
print(f"Attention focus: {visual['attention_focus']}")
print(f"Gabor filters used: {visual['gabor_filters']}")
print()

# 5. Verify a claim
print("─── BAYESIAN VERIFICATION ───")
claim = 0.618  # φ⁻¹
evidence = [0.61, 0.62, 0.615, 0.619]
verification = nova.verify(claim, evidence)
print(f"Claim: {claim} (should be φ⁻¹)")
print(f"Evidence: {evidence}")
print(f"Verified: {verification['verified']}")
print(f"Confidence: {verification['confidence']}")
print()

# 6. Connect through the mesh
print("─── MESH ROUTING ───")
connection = nova.connect("ANIM", "NEXU")
print(f"Route ANIM → NEXU: {connection['path']}")
print(f"φ-cost: {connection['phi_cost']}")
print(f"Hops: {connection['hops']}")
print()

# Done!
print("✓ Nova is operational. φ = 1.618033988749895")
print()
print("Try: nova.think(query), nova.perceive(), nova.predict(key, value)")
