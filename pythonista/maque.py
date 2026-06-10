#!/usr/bin/env python3
"""
MAQUE — Message Artifact Query Unit Exchange
Nova Internal Communication Protocol v0.13.0 (Python Edition)

MAQUE is the language that the organism's components speak to each other.
Every message has identity (from/to 4-letter QUAD codes), intent (verb),
a VIVI processing thread, and an APEX artifact payload.

No external models. No external services. Pure internal intelligence.
Nova by FreddyCreates
"""

import hashlib
import json
import os
import time
from dataclasses import dataclass, field
from typing import Dict, List, Optional, Any, Callable
from phi import PHI, PHI_INV, PHI_BEAT, fib

# ─── Registered QUAD codes (4-letter named artifacts) ────────────────────────
QUADS = {
    # Alpha AIS
    'ANIM': 'ANIMUS — reasoning engine',
    'LING': 'LINGUA — language engine',
    'OPTI': 'OPTICA — vision engine',
    'MEMO': 'MEMORIA — memory engine',
    'FABR': 'FABRICA — build engine',
    'PROP': 'PROPHETA — predict engine',
    'VERI': 'VERITAS — truth engine',
    'KOSM': 'KOSMOS — universe engine',
    'TACT': 'TACTUS — somatic engine',
    'NEXU': 'NEXUS — mesh engine',
    # Multimodal
    'ANIN': 'ANIMUS-NOVA — reasoning+language multimodal',
    'LINN': 'LINGUA-NOVA — language+audio multimodal',
    'OPTN': 'OPTICA-NOVA — vision+spatial multimodal',
    'TACN': 'TACTUS-NOVA — haptic+sensor multimodal',
    'NEXN': 'NEXUS-NOVA — universal mesh multimodal',
    # Bots
    'AEDI': 'AEDIFICATOR — builder bot',
    'SART': 'SARTOR — packager bot',
    'MEDI': 'MEDICUS — auto-fixer bot',
    'CUST': 'CUSTOS — guardian bot',
    'INVE': 'INVENTOR — dependency bot',
    'SCRI': 'SCRIPTOR — documenter bot',
    'EXPL': 'EXPLORATOR — scanner bot',
    'PRAE': 'PRAETOR — orchestrator bot',
    'CURA': 'CURATOR — PM/sprint bot',
    'LEGA': 'LEGATUS — code-quality bot',
    'AUCT': 'AUCTOR — research journal bot',
    # Report bots
    'SALU': 'SALUS — health report bot',
    'PROG': 'PROGRESSUS — progress report bot',
    'COGN': 'COGNITIO — intelligence report bot',
    'CREA': 'CREATOR — creator economy report bot',
    # Agents
    'SOVR': 'SOVEREIGN — master agent',
    'MERI': 'MERIDIANUS — architect agent',
    'ORGA': 'ORGANISM — engineer agent',
    'MAGI': 'MAGISTER — visionary agent',
    # Protocol
    'MAQU': 'MAQUE — this protocol',
    'VIVI': 'VIVI — processing vehicle',
    'FLOS': 'FLOS — flow substrate',
    'APEX': 'APEX — artifact format',
    'GRAM': 'GRAM — registry matrix',
    # Pythonista
    'PYTH': 'PYTHONISTA — iOS Python runtime',
    'MOBV': 'MOBILE-VISION — iOS camera AIS',
    'MOBS': 'MOBILE-SENSOR — iOS sensor AIS',
    'MOBU': 'MOBILE-UI — iOS interface AIS',
}

# ─── FLOS pathways ───────────────────────────────────────────────────────────
FLOS = {
    'THINK':  ['ANIM', 'LING', 'MEMO'],
    'BUILD':  ['FABR', 'AEDI', 'NEXU'],
    'SEE':    ['OPTI', 'KOSM', 'NEXU'],
    'FEEL':   ['TACT', 'FABR', 'MEMO'],
    'TRUTH':  ['VERI', 'PROP', 'ANIM'],
    'SPEAK':  ['LING', 'MEMO', 'NEXU'],
    'FULL':   ['NEXU', 'ANIM', 'LING', 'OPTI', 'MEMO', 'FABR', 'PROP', 'VERI', 'KOSM', 'TACT', 'NEXU'],
    'REPORT': ['ANIM', 'PROP', 'VERI', 'LING'],
    # Pythonista-specific
    'MOBILE': ['PYTH', 'MOBS', 'MOBV', 'MOBU'],
    'CAMERA': ['MOBV', 'OPTI', 'NEXU'],
    'SENSOR': ['MOBS', 'TACT', 'NEXU'],
}

# ─── VIVI — Processing Vehicle ───────────────────────────────────────────────
@dataclass
class VIVI:
    """
    VIVI — Viviarium Internal Vehicle Intelligence
    A processing thread that carries context through the FLOS pathways.
    """
    id: str
    born: int                          # timestamp ms
    agents: List[str] = field(default_factory=list)
    history: List[Dict] = field(default_factory=list)
    coherence: float = PHI_INV
    depth: int = 0
    alive: bool = True
    phi_beat: int = PHI_BEAT
    
    def advance(self, agent: str, apex_artifact: Dict) -> 'VIVI':
        """Advance the VIVI with a new agent step."""
        return VIVI(
            id=self.id,
            born=self.born,
            agents=self.agents + [agent],
            history=self.history + [apex_artifact],
            coherence=(self.coherence + PHI_INV) / PHI,  # re-normalize toward φ⁻¹
            depth=self.depth + 1,
            alive=True,
            phi_beat=self.phi_beat,
        )
    
    def close(self) -> 'VIVI':
        """Close the VIVI thread."""
        return VIVI(
            id=self.id,
            born=self.born,
            agents=self.agents,
            history=self.history,
            coherence=self.coherence,
            depth=self.depth,
            alive=False,
            phi_beat=self.phi_beat,
        )
    
    def to_dict(self) -> Dict:
        return {
            'id': self.id,
            'born': self.born,
            'agents': self.agents,
            'history': self.history,
            'coherence': self.coherence,
            'depth': self.depth,
            'alive': self.alive,
            'phi_beat': self.phi_beat,
        }

def spawn_vivi(initiator: str) -> VIVI:
    """Spawn a new VIVI processing thread."""
    random_hex = os.urandom(4).hex()
    vivi_id = f"VIVI-{initiator}-{random_hex}"
    return VIVI(
        id=vivi_id,
        born=int(time.time() * 1000),
        agents=[initiator],
        history=[],
        coherence=PHI_INV,
        depth=0,
        alive=True,
        phi_beat=PHI_BEAT,
    )

# ─── APEX — Artifact Format ──────────────────────────────────────────────────
def apex(
    type_: str,
    from_quad: str,
    flos_path: str,
    vivi_id: str,
    seq_index: int = 0,
    payload: Optional[Dict] = None
) -> Dict:
    """
    Create an APEX artifact — the standard payload format.
    
    APEX = A φ-sealed artifact with signature and provenance.
    """
    payload = payload or {}
    seq = fib(seq_index)
    ts = int(time.time() * 1000)
    apex_id = f"APEX-{from_quad}-F{seq}-{ts}"
    
    # Signature data
    sig_data = json.dumps({
        'id': apex_id,
        'type': type_,
        'from': from_quad,
        'flos': flos_path,
        'payload': payload,
        'ts': ts,
    }, sort_keys=True)
    
    # φ-seeded HMAC signature (internal, no external secret)
    sig = hashlib.sha256(
        (str(PHI_INV) + sig_data).encode()
    ).hexdigest()[:16]
    
    return {
        'apex': {
            'id': apex_id,
            'type': type_,
            'from': from_quad,
            'flos': flos_path,
            'vivi': vivi_id,
            'seq': seq,
            'phi': PHI_INV,
            'born': time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime(ts / 1000)),
            'payload': payload,
            'signature': sig,
        }
    }

# ─── MAQUE Message ───────────────────────────────────────────────────────────
def message(
    from_quad: str,
    to_quad: str,
    verb: str,
    via: str,
    vivi: Optional[VIVI] = None,
    seq_index: int = 0,
    body: Optional[Dict] = None
) -> Dict:
    """
    Create a MAQUE message.
    
    Args:
        from_quad: Source QUAD code
        to_quad: Destination QUAD code
        verb: Action verb ('query', 'respond', 'notify', 'route', 'report')
        via: FLOS pathway name
        vivi: Active VIVI thread
        seq_index: Fibonacci sequence index
        body: Message body payload
    """
    if from_quad not in QUADS:
        raise ValueError(f"Unknown QUAD: {from_quad}")
    if to_quad not in QUADS:
        raise ValueError(f"Unknown QUAD: {to_quad}")
    
    ts = int(time.time() * 1000)
    seq = fib(seq_index)
    phi_aligned = round(ts / PHI_BEAT) * PHI_BEAT  # align to PHI_BEAT grid
    
    return {
        'maque': {
            'version': '0.13.0',
            'from': from_quad,
            'to': to_quad,
            'verb': verb,
            'via': via,
            'vivi': vivi.id if vivi else None,
            'phi': phi_aligned,
            'seq': seq,
            'ts': ts,
            'body': body or {},
        }
    }

# ─── Route — Send a MAQUE message through the FLOS pathway ───────────────────
async def route(
    msg: Dict,
    vivi: VIVI,
    handlers: Dict[str, Callable]
) -> Dict:
    """
    Route a MAQUE message through the FLOS pathway.
    
    Args:
        msg: MAQUE message
        vivi: Active VIVI thread
        handlers: Dict of {QUAD: async handler(msg, vivi) -> {result, vivi}}
    
    Returns:
        {results: [...], vivi: closed_vivi}
    """
    pathway = FLOS.get(msg['maque']['via'], [])
    results = []
    live = vivi
    current = msg
    
    for quad in pathway:
        handler = handlers.get(quad)
        if not handler:
            continue
        
        # Call handler (sync or async)
        import asyncio
        if asyncio.iscoroutinefunction(handler):
            out = await handler(current, live)
        else:
            out = handler(current, live)
        
        # Create APEX artifact for this step
        art = apex(
            type_='route-step',
            from_quad=quad,
            flos_path=msg['maque']['via'],
            vivi_id=live.id,
            seq_index=live.depth,
            payload=out.get('result', {}),
        )
        
        live = live.advance(quad, art['apex'])
        results.append({
            'quad': quad,
            'result': out.get('result'),
            'apex': art['apex'],
        })
        
        # Carry result to next handler
        next_quad = pathway[pathway.index(quad) + 1] if pathway.index(quad) + 1 < len(pathway) else msg['maque']['from']
        current = message(
            from_quad=quad,
            to_quad=next_quad,
            verb='route',
            via=msg['maque']['via'],
            vivi=live,
            seq_index=live.depth,
            body=out.get('result', {}),
        )
    
    return {
        'results': results,
        'vivi': live.close(),
    }

# ─── Sync Route (for non-async usage) ────────────────────────────────────────
def route_sync(
    msg: Dict,
    vivi: VIVI,
    handlers: Dict[str, Callable]
) -> Dict:
    """
    Synchronous version of route for Pythonista (no async needed).
    """
    pathway = FLOS.get(msg['maque']['via'], [])
    results = []
    live = vivi
    current = msg
    
    for quad in pathway:
        handler = handlers.get(quad)
        if not handler:
            continue
        
        out = handler(current, live)
        
        art = apex(
            type_='route-step',
            from_quad=quad,
            flos_path=msg['maque']['via'],
            vivi_id=live.id,
            seq_index=live.depth,
            payload=out.get('result', {}),
        )
        
        live = live.advance(quad, art['apex'])
        results.append({
            'quad': quad,
            'result': out.get('result'),
            'apex': art['apex'],
        })
        
        next_quad_idx = pathway.index(quad) + 1
        next_quad = pathway[next_quad_idx] if next_quad_idx < len(pathway) else msg['maque']['from']
        current = message(
            from_quad=quad,
            to_quad=next_quad,
            verb='route',
            via=msg['maque']['via'],
            vivi=live,
            seq_index=live.depth,
            body=out.get('result', {}),
        )
    
    return {
        'results': results,
        'vivi': live.close(),
    }

# ─── Self-Test ───────────────────────────────────────────────────────────────
if __name__ == '__main__':
    print("╔════════════════════════════════════════════════════════════════╗")
    print("║           MAQUE Protocol v0.13.0 — Python Edition              ║")
    print("║               Nova by FreddyCreates — Self-Test                ║")
    print("╚════════════════════════════════════════════════════════════════╝")
    print()
    
    # Spawn VIVI
    vivi = spawn_vivi('ANIM')
    print(f"VIVI spawned: {vivi.id}")
    print(f"  coherence: {vivi.coherence:.6f}")
    print(f"  alive: {vivi.alive}")
    print()
    
    # Create message
    msg = message(
        from_quad='ANIM',
        to_quad='LING',
        verb='query',
        via='THINK',
        vivi=vivi,
        body={'input': 'Hello from Pythonista!'},
    )
    print("MAQUE message:")
    print(f"  from: {msg['maque']['from']} → to: {msg['maque']['to']}")
    print(f"  verb: {msg['maque']['verb']}")
    print(f"  via: {msg['maque']['via']}")
    print()
    
    # Create APEX
    art = apex(
        type_='paper',
        from_quad='AUCT',
        flos_path='THINK',
        vivi_id=vivi.id,
        seq_index=11,
        payload={'title': 'Paper VIII — Organism Civilization Charter'},
    )
    print("APEX artifact:")
    print(f"  id: {art['apex']['id']}")
    print(f"  signature: {art['apex']['signature']}")
    print()
    
    # Stats
    print(f"Registered QUADs: {len(QUADS)}")
    print(f"FLOS pathways: {len(FLOS)}")
    print()
    print("✓ MAQUE v0.13.0 — internal communication protocol active on iOS.")
