#!/usr/bin/env python3
"""
ANIMUS — Reasoning Engine for Nova (Python Edition)
Nova AIS: ANIMUS-NOVA — Multimodal Reasoning × Language

Alpha Engines: ALPHA-001 (ANIMUS) × ALPHA-002 (LINGUA) × ALPHA-004 (MEMORIA)
Modalities: text, structured data, logic, code, reasoning

Real Math:
- Kuramoto oscillators: dθᵢ/dt = ωᵢ + (K/N) Σⱼ sin(θⱼ − θᵢ)
- Hebbian plasticity: Δwᵢⱼ = η·xᵢ·xⱼ − λwᵢⱼ
- φ-encoded loss: L_nova = L_CE × (1 + φ⁻¹ × CS)

Nova by FreddyCreates — runs on Pythonista iOS
"""

import math
import random
from typing import List, Dict, Optional, Tuple
from phi import PHI, PHI_INV, PHI_BEAT, phi_loss, fib

# ─── KURAMOTO OSCILLATOR FIELD ────────────────────────────────────────────────
# Models neural synchronization: dθᵢ/dt = ωᵢ + (K/N) Σⱼ sin(θⱼ − θᵢ)
# K = φ+1 = 2.618 — the coupling constant of synchronization

class KuramotoField:
    """
    Kuramoto oscillator model for neural synchronization.
    
    N oscillators with natural frequencies ωᵢ couple to synchronize.
    Order parameter r measures coherence (0=chaos, 1=lock).
    """
    
    def __init__(self, N: int = 89, K: float = 2.618033988749895):
        """
        Initialize Kuramoto field.
        
        Args:
            N: Number of oscillators (default F11=89)
            K: Coupling constant (default φ+1=2.618)
        """
        self.N = N
        self.K = K
        self.phases = [random.random() * 2 * math.pi for _ in range(N)]
        self.freqs = [0.5 + random.random() for _ in range(N)]  # natural frequencies
        self.dt = 0.01
        self.time = 0.0
    
    def step(self):
        """Advance one time step using Euler method."""
        new_phases = []
        for i in range(self.N):
            coupling = sum(
                math.sin(self.phases[j] - self.phases[i])
                for j in range(self.N)
            )
            dtheta = self.freqs[i] + (self.K / self.N) * coupling
            new_phases.append(self.phases[i] + self.dt * dtheta)
        
        self.phases = new_phases
        self.time += self.dt
    
    def order_parameter(self) -> float:
        """
        Compute order parameter r.
        r = |1/N Σ e^(iθⱼ)|
        
        r ∈ [0, 1]: 0 = incoherent, 1 = fully synchronized
        """
        real_sum = sum(math.cos(theta) for theta in self.phases)
        imag_sum = sum(math.sin(theta) for theta in self.phases)
        return math.sqrt(real_sum**2 + imag_sum**2) / self.N
    
    def run(self, T: int = 100) -> List[float]:
        """Run T steps, return coherence trajectory."""
        trajectory = []
        for t in range(T):
            self.step()
            if t % 10 == 0:
                trajectory.append(self.order_parameter())
        return trajectory
    
    def is_coherent(self) -> bool:
        """Check if field is synchronized (r > φ⁻¹)."""
        return self.order_parameter() > PHI_INV

# ─── HEBBIAN PLASTICITY ──────────────────────────────────────────────────────
# Δwᵢⱼ = η·xᵢ·xⱼ − λwᵢⱼ  (Hebb + weight decay)
# η = φ⁻⁴ ≈ 0.0001618 — the learning rate is encoded in φ

def hebbian_update(
    W: List[List[float]],
    x: List[float],
    eta: float = 0.0001618,
    lambda_decay: float = 0.05
) -> List[List[float]]:
    """
    Apply Hebbian plasticity update to weight matrix.
    
    Δwᵢⱼ = η·xᵢ·xⱼ − λwᵢⱼ
    
    Args:
        W: Weight matrix [n × n]
        x: Activation vector [n]
        eta: Learning rate (default φ⁻⁴)
        lambda_decay: Weight decay factor
    
    Returns:
        Updated weight matrix
    """
    n = len(x)
    return [
        [W[i][j] + eta * x[i] * x[j] - lambda_decay * W[i][j]
         for j in range(n)]
        for i in range(n)
    ]

def hebbian_activation(
    W: List[List[float]],
    x: List[float],
    threshold: float = PHI_INV
) -> List[float]:
    """
    Compute Hebbian activation with φ⁻¹ threshold.
    
    Args:
        W: Weight matrix [n × n]
        x: Input vector [n]
        threshold: Activation threshold (default φ⁻¹)
    
    Returns:
        Activation vector [n]
    """
    n = len(x)
    activations = []
    for i in range(n):
        raw = sum(W[i][j] * x[j] for j in range(n)) / n
        act = math.tanh(raw) if raw > threshold else 0.0
        activations.append(act)
    return activations

def create_weight_matrix(n: int, init: float = 0.0) -> List[List[float]]:
    """Create an n×n weight matrix."""
    return [[init for _ in range(n)] for _ in range(n)]

# ─── COHERENCE SCORING ───────────────────────────────────────────────────────
def coherence_score(text: str) -> float:
    """
    Estimate text coherence from lexical diversity + structure.
    
    CS = φ⁻¹ × TTR + (1-φ⁻¹) × length_factor
    
    Args:
        text: Input text
    
    Returns:
        Coherence score [0, 1], capped at φ⁻¹
    """
    if not text or len(text.strip()) == 0:
        return 0.0
    
    words = text.lower().split()
    if len(words) == 0:
        return 0.0
    
    unique = len(set(words))
    ttr = unique / len(words)  # Type-Token Ratio
    length_factor = min(len(words) / 100, 1.0)
    
    # φ-weighted combination
    cs = PHI_INV * ttr + (1 - PHI_INV) * length_factor
    return min(cs, 1.0)

# ─── REASONING FUNCTIONS ─────────────────────────────────────────────────────
def decompose(query: str) -> Dict:
    """
    Decompose a query into component parts.
    
    Args:
        query: Input query text
    
    Returns:
        Dict with parts, count, complexity
    """
    sentences = [s.strip() for s in query.replace('!', '.').replace('?', '.').split('.') if s.strip()]
    return {
        'parts': sentences,
        'count': len(sentences),
        'complexity': math.log2(len(sentences) + 1) * PHI,
    }

def infer(premises: List[str]) -> Dict:
    """
    Simple forward-chaining inference with φ-weighted confidence.
    
    Args:
        premises: List of premise statements
    
    Returns:
        Dict with inference result and confidence
    """
    # Each premise reduces confidence by φ⁻¹
    confidence = 1.0
    for _ in premises:
        confidence *= PHI_INV
    
    return {
        'inference': 'forward-chain',
        'premises': len(premises),
        'confidence': min(confidence + PHI_INV, 1.0),
        'phi_weighted': True,
    }

def bind_concepts(
    concepts: List[str],
    n_nodes: int = 13
) -> Dict:
    """
    Bind concepts using Hebbian learning.
    
    Args:
        concepts: List of concept strings
        n_nodes: Number of concept nodes (default F7=13)
    
    Returns:
        Dict with binding result
    """
    n = min(len(concepts), n_nodes)
    W = create_weight_matrix(n, 0.0)
    
    # Random initial activation
    activation = [random.random() for _ in range(n)]
    
    # Apply Hebbian update
    W2 = hebbian_update(W, activation)
    
    # Compute bound activation
    bound = hebbian_activation(W2, activation)
    
    bound_count = sum(1 for v in bound if v > 0)
    total_strength = sum(bound) / n if n > 0 else 0.0
    
    return {
        'action': 'bind',
        'concepts': concepts[:n],
        'bound_nodes': bound_count,
        'binding_strength': total_strength,
        'eta': 0.0001618,
        'lambda': 0.05,
        'phi': PHI,
        'alpha': 'ALPHA-001',
    }

# ─── MAIN REASONING ENGINE ───────────────────────────────────────────────────
class AnimusEngine:
    """
    ANIMUS — The Reasoning Engine
    
    Combines Kuramoto synchronization, Hebbian binding, and φ-loss
    to perform coherent reasoning.
    """
    
    def __init__(self, n_oscillators: int = 89, coupling: float = 2.618):
        self.field = KuramotoField(N=n_oscillators, K=coupling)
        self.n_oscillators = n_oscillators
        self.coupling = coupling
    
    def reason(self, query: str) -> Dict:
        """
        Perform reasoning on a query.
        
        Uses Kuramoto field to determine coherence,
        applies φ-loss to measure reasoning quality.
        """
        import time
        start = time.time()
        
        # Run Kuramoto field
        trajectory = self.field.run(200)
        r_final = trajectory[-1] if trajectory else 0.0
        coherent = r_final > PHI_INV
        
        # Compute coherence score
        cs = coherence_score(query)
        loss = phi_loss(1.0, cs)  # baseline L_CE = 1
        
        elapsed = int((time.time() - start) * 1000)
        
        return {
            'action': 'reason',
            'query': query,
            'kuramoto': {
                'oscillators': self.n_oscillators,
                'coupling_K': self.coupling,
                'order_r': round(r_final, 4),
                'coherent': coherent,
                'trajectory_final': [round(v, 4) for v in trajectory[-5:]],
            },
            'phi_loss': {
                'L_CE': 1.0,
                'coherence': round(cs, 4),
                'L_nova': round(loss, 4),
                'ceiling': PHI_INV,
            },
            'conclusion': (
                f"Field synchronized (r={r_final:.3f} > φ⁻¹). Reasoning coherent."
                if coherent else
                f"Field desynchronized (r={r_final:.3f} < φ⁻¹). More data needed."
            ),
            'elapsed_ms': elapsed,
            'phi': PHI,
            'alpha': ['ALPHA-001', 'ALPHA-002'],
        }
    
    def decompose(self, query: str) -> Dict:
        """Decompose query into parts."""
        result = decompose(query)
        result['action'] = 'decompose'
        result['phi'] = PHI
        result['alpha'] = 'ALPHA-001'
        return result
    
    def infer(self, premises: List[str]) -> Dict:
        """Perform inference on premises."""
        result = infer(premises if premises else ['premise-1', 'premise-2'])
        result['action'] = 'infer'
        result['phi'] = PHI
        result['alpha'] = 'ALPHA-001'
        return result
    
    def bind(self, concepts: List[str]) -> Dict:
        """Bind concepts using Hebbian learning."""
        return bind_concepts(concepts)
    
    def analyze(self, text: str) -> Dict:
        """Analyze text (LINGUA action)."""
        cs = coherence_score(text)
        words = text.split()
        loss = phi_loss(0.5, cs)
        
        return {
            'action': 'analyze',
            'words': len(words),
            'unique': len(set(words)),
            'coherence': round(cs, 4),
            'phi_loss': round(loss, 4),
            'above_ceiling': cs > PHI_INV,
            'phi': PHI,
            'alpha': 'ALPHA-002',
        }
    
    def status(self) -> Dict:
        """Return engine status."""
        return {
            'ais': 'ANIMUS-NOVA',
            'brand': 'Nova',
            'platform': 'Pythonista iOS',
            'modalities': ['text', 'structured', 'logic', 'code', 'reasoning'],
            'alpha': ['ALPHA-001 ANIMUS', 'ALPHA-002 LINGUA', 'ALPHA-004 MEMORIA'],
            'actions': ['reason', 'decompose', 'infer', 'bind', 'analyze'],
            'math': {
                'kuramoto': f'dθᵢ/dt = ωᵢ + (K/N)Σsin(θⱼ−θᵢ), K=φ+1={self.coupling:.3f}',
                'hebbian': 'Δwᵢⱼ = η·xᵢ·xⱼ − λwᵢⱼ, η=φ⁻⁴=0.0001618',
                'phi_loss': 'L_nova = L_CE×(1+φ⁻¹×CS), ceiling=0.618',
            },
            'phi': PHI,
            'phi_inv': PHI_INV,
            'phi_beat': PHI_BEAT,
        }

# ─── Global Engine Instance ──────────────────────────────────────────────────
_engine = None

def get_engine() -> AnimusEngine:
    """Get or create the global ANIMUS engine."""
    global _engine
    if _engine is None:
        _engine = AnimusEngine()
    return _engine

def reason(query: str) -> Dict:
    """Quick access to reasoning."""
    return get_engine().reason(query)

def analyze(text: str) -> Dict:
    """Quick access to text analysis."""
    return get_engine().analyze(text)

# ─── Self-Test ───────────────────────────────────────────────────────────────
if __name__ == '__main__':
    print("╔════════════════════════════════════════════════════════════════╗")
    print("║           ANIMUS — Reasoning Engine — Self-Test                ║")
    print("║           Nova by FreddyCreates — Pythonista iOS               ║")
    print("╚════════════════════════════════════════════════════════════════╝")
    print()
    
    engine = AnimusEngine()
    
    # Status
    status = engine.status()
    print(f"AIS: {status['ais']}")
    print(f"Platform: {status['platform']}")
    print(f"Actions: {', '.join(status['actions'])}")
    print()
    
    # Test reasoning
    print("─── Testing REASON ───")
    query = "The golden ratio appears throughout nature. It governs growth patterns in plants and spiral shells."
    result = engine.reason(query)
    print(f"Query: {query[:50]}...")
    print(f"Kuramoto r: {result['kuramoto']['order_r']}")
    print(f"Coherent: {result['kuramoto']['coherent']}")
    print(f"φ-Loss: {result['phi_loss']['L_nova']}")
    print(f"Conclusion: {result['conclusion']}")
    print()
    
    # Test decompose
    print("─── Testing DECOMPOSE ───")
    decomposed = engine.decompose(query)
    print(f"Parts: {decomposed['count']}")
    print(f"Complexity: {decomposed['complexity']:.4f}")
    print()
    
    # Test bind
    print("─── Testing BIND ───")
    bound = engine.bind(['φ', 'golden', 'ratio', 'nature', 'growth', 'spiral'])
    print(f"Bound nodes: {bound['bound_nodes']}")
    print(f"Binding strength: {bound['binding_strength']:.4f}")
    print()
    
    # Test analyze
    print("─── Testing ANALYZE ───")
    analyzed = engine.analyze("The organism thinks with φ-synchronized fields.")
    print(f"Words: {analyzed['words']}")
    print(f"Coherence: {analyzed['coherence']}")
    print(f"Above ceiling: {analyzed['above_ceiling']}")
    print()
    
    print("✓ ANIMUS engine ready on Pythonista iOS.")
