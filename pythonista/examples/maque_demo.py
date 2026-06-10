#!/usr/bin/env python3
"""
Example: MAQUE Protocol Communication
Nova by FreddyCreates — Pythonista iOS

This example demonstrates the MAQUE protocol for internal
communication between AIS components.
"""

from maque import (
    QUADS, FLOS, 
    spawn_vivi, message, apex, route_sync,
    VIVI
)
from phi import PHI, PHI_INV, PHI_BEAT

def demonstrate_maque():
    """Demonstrate MAQUE protocol features."""
    print("╔════════════════════════════════════════════════════════════════╗")
    print("║            MAQUE Protocol — Internal Communication             ║")
    print("╚════════════════════════════════════════════════════════════════╝")
    print()
    
    # 1. Show registered QUADs
    print("─── REGISTERED QUAD CODES ───")
    print(f"Total QUADs: {len(QUADS)}")
    print()
    for code, desc in list(QUADS.items())[:10]:
        print(f"  {code}: {desc}")
    print(f"  ... and {len(QUADS) - 10} more")
    print()
    
    # 2. Show FLOS pathways
    print("─── FLOS PATHWAYS ───")
    for name, path in FLOS.items():
        print(f"  {name:8s}: {' → '.join(path)}")
    print()
    
    # 3. Spawn a VIVI
    print("─── VIVI PROCESSING THREAD ───")
    vivi = spawn_vivi('ANIM')
    print(f"Spawned: {vivi.id}")
    print(f"Born: {vivi.born}")
    print(f"Coherence: {vivi.coherence:.4f} (φ⁻¹)")
    print(f"Alive: {vivi.alive}")
    print()
    
    # 4. Create a MAQUE message
    print("─── MAQUE MESSAGE ───")
    msg = message(
        from_quad='ANIM',
        to_quad='LING',
        verb='query',
        via='THINK',
        vivi=vivi,
        body={'input': 'What is the golden ratio?'}
    )
    print(f"Version: {msg['maque']['version']}")
    print(f"From: {msg['maque']['from']} → To: {msg['maque']['to']}")
    print(f"Verb: {msg['maque']['verb']}")
    print(f"Via pathway: {msg['maque']['via']}")
    print(f"VIVI: {msg['maque']['vivi']}")
    print(f"Sequence: F{msg['maque']['seq']}")
    print(f"Body: {msg['maque']['body']}")
    print()
    
    # 5. Create an APEX artifact
    print("─── APEX ARTIFACT ───")
    art = apex(
        type_='paper',
        from_quad='AUCT',
        flos_path='THINK',
        vivi_id=vivi.id,
        seq_index=11,  # F11 = 89
        payload={
            'title': 'Paper VIII: Organism Civilization Charter',
            'author': 'Nova AUCTOR',
            'phi_reference': PHI,
        }
    )
    print(f"ID: {art['apex']['id']}")
    print(f"Type: {art['apex']['type']}")
    print(f"From: {art['apex']['from']}")
    print(f"Sequence: F{art['apex']['seq']}")
    print(f"Signature: {art['apex']['signature']}")
    print(f"Born: {art['apex']['born']}")
    print()
    
    # 6. Demonstrate routing (with mock handlers)
    print("─── ROUTING THROUGH FLOS PATHWAY ───")
    
    # Define handlers for each QUAD
    def make_handler(quad_name):
        def handler(msg, vivi):
            print(f"  [{quad_name}] Processing...")
            return {'result': f'{quad_name}_processed', 'vivi': vivi}
        return handler
    
    handlers = {
        'ANIM': make_handler('ANIM'),
        'LING': make_handler('LING'),
        'MEMO': make_handler('MEMO'),
    }
    
    # Route through THINK pathway
    print(f"Routing through THINK: {FLOS['THINK']}")
    result = route_sync(msg, vivi, handlers)
    
    print(f"Results: {len(result['results'])} steps")
    for step in result['results']:
        print(f"  {step['quad']}: {step['result']}")
    
    print(f"VIVI closed: {not result['vivi'].alive}")
    print(f"Final depth: {result['vivi'].depth}")
    print()
    
    # 7. Summary
    print("─── PROTOCOL SUMMARY ───")
    print(f"PHI: {PHI}")
    print(f"PHI_INV: {PHI_INV}")
    print(f"PHI_BEAT: {PHI_BEAT}ms")
    print()
    print("MAQUE enables:")
    print("  • Typed messages between QUAD components")
    print("  • VIVI threads for context tracking")
    print("  • APEX artifacts with φ-sealed signatures")
    print("  • FLOS pathways for structured processing")
    print()

if __name__ == '__main__':
    demonstrate_maque()
    print("✓ MAQUE protocol demonstration complete.")
