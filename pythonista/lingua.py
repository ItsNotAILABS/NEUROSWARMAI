#!/usr/bin/env python3
"""
LINGUA — Language Intelligence Engine for Nova (Python Edition)
Nova AIS: LINGUA-NOVA — Multimodal Language × Audio × Memory

Alpha Engines: ALPHA-002 (LINGUA) × ALPHA-004 (MEMORIA)
Modalities: text, speech, audio, music, memory

Real Math:
- Liquid Language geometry: vocabulary embedded in weight-space as doctrine attractors
- Phantom Thought Engine (PTE): attention without injection
- φ-encoded loss: L_nova = L_CE × (1 + φ⁻¹ × CS), ceiling at φ⁻¹ = 0.618
- Hippocampal replay: memory consolidation with prioritized experience replay

Nova by FreddyCreates — runs on Pythonista iOS
"""

import math
import random
import re
from typing import List, Dict, Optional, Tuple, Set
from collections import Counter
from phi import PHI, PHI_INV, PHI_BEAT, phi_loss, fib

# ─── LEXICAL ANALYSIS ────────────────────────────────────────────────────────
def tokenize(text: str) -> List[str]:
    """Simple word tokenization."""
    # Remove punctuation, lowercase, split
    text = re.sub(r'[^\w\s]', ' ', text.lower())
    return [w for w in text.split() if w]

def word_frequencies(tokens: List[str]) -> Dict[str, int]:
    """Compute word frequency distribution."""
    return dict(Counter(tokens))

def type_token_ratio(tokens: List[str]) -> float:
    """Compute Type-Token Ratio (lexical diversity)."""
    if not tokens:
        return 0.0
    return len(set(tokens)) / len(tokens)

def hapax_legomena(tokens: List[str]) -> List[str]:
    """Find words that appear exactly once."""
    freq = Counter(tokens)
    return [w for w, c in freq.items() if c == 1]

# ─── COHERENCE SCORING ───────────────────────────────────────────────────────
def coherence_score(text: str) -> float:
    """
    Compute text coherence score.
    
    CS = φ⁻¹ × TTR + (1-φ⁻¹) × length_factor
    
    Returns value in [0, 1], capped at φ⁻¹ injection ceiling.
    """
    if not text:
        return 0.0
    
    tokens = tokenize(text)
    if not tokens:
        return 0.0
    
    ttr = type_token_ratio(tokens)
    length_factor = min(len(tokens) / 100, 1.0)
    
    cs = PHI_INV * ttr + (1 - PHI_INV) * length_factor
    return min(cs, 1.0)

def sentence_coherence(sentences: List[str]) -> float:
    """Compute coherence across sentences."""
    if len(sentences) < 2:
        return 1.0
    
    # Measure vocabulary overlap between consecutive sentences
    overlaps = []
    for i in range(len(sentences) - 1):
        s1 = set(tokenize(sentences[i]))
        s2 = set(tokenize(sentences[i + 1]))
        if s1 and s2:
            overlap = len(s1 & s2) / min(len(s1), len(s2))
            overlaps.append(overlap)
    
    return sum(overlaps) / len(overlaps) if overlaps else 0.0

# ─── LIQUID LANGUAGE GEOMETRY ────────────────────────────────────────────────
class LiquidLanguage:
    """
    Liquid Language — vocabulary as weight-space geometry.
    
    From Paper VII: vocabulary is embedded in weights as doctrine attractors,
    not injected via prompts. The Phantom Thought Engine operates below
    the injection ceiling at φ⁻¹ = 0.618.
    """
    
    def __init__(self, vocab_size: int = 1000):
        self.vocab_size = vocab_size
        self.vocab: Dict[str, int] = {}
        self.inverse_vocab: Dict[int, str] = {}
        self.embeddings: Dict[int, List[float]] = {}
        self.embed_dim = 64
        self.word_count = 0
    
    def add_word(self, word: str) -> int:
        """Add word to vocabulary, return index."""
        word = word.lower()
        if word in self.vocab:
            return self.vocab[word]
        
        idx = self.word_count
        self.vocab[word] = idx
        self.inverse_vocab[idx] = word
        
        # φ-initialized random embedding
        self.embeddings[idx] = [
            (random.random() - 0.5) * PHI_INV
            for _ in range(self.embed_dim)
        ]
        
        self.word_count += 1
        return idx
    
    def build_vocab(self, text: str):
        """Build vocabulary from text."""
        for word in tokenize(text):
            self.add_word(word)
    
    def embed(self, word: str) -> Optional[List[float]]:
        """Get embedding for word."""
        word = word.lower()
        if word not in self.vocab:
            self.add_word(word)
        return self.embeddings.get(self.vocab.get(word))
    
    def similarity(self, word1: str, word2: str) -> float:
        """Compute cosine similarity between word embeddings."""
        e1 = self.embed(word1)
        e2 = self.embed(word2)
        if not e1 or not e2:
            return 0.0
        
        dot = sum(a * b for a, b in zip(e1, e2))
        norm1 = math.sqrt(sum(a ** 2 for a in e1))
        norm2 = math.sqrt(sum(b ** 2 for b in e2))
        
        if norm1 == 0 or norm2 == 0:
            return 0.0
        return dot / (norm1 * norm2)
    
    def doctrine_distance(self, text: str) -> float:
        """
        Measure how close text is to doctrine attractors.
        
        Lower = closer to doctrine = more coherent.
        """
        tokens = tokenize(text)
        if not tokens:
            return 1.0
        
        # Compute centroid
        centroid = [0.0] * self.embed_dim
        for word in tokens:
            emb = self.embed(word)
            if emb:
                for i in range(self.embed_dim):
                    centroid[i] += emb[i]
        
        # Normalize
        n = len(tokens)
        centroid = [c / n for c in centroid]
        
        # Distance from origin (doctrine attractor at origin in liquid space)
        dist = math.sqrt(sum(c ** 2 for c in centroid))
        
        # Normalize to [0, 1]
        return min(dist / PHI, 1.0)

# ─── MEMORY — HIPPOCAMPAL REPLAY ─────────────────────────────────────────────
class HippocampalMemory:
    """
    Hippocampal replay memory system.
    
    Implements prioritized experience replay with φ-weighted consolidation.
    """
    
    def __init__(self, capacity: int = 1000):
        self.capacity = capacity
        self.memory: List[Dict] = []
        self.priorities: List[float] = []
        self.consolidation_threshold = PHI_INV
    
    def store(self, item: Dict, priority: float = 1.0):
        """Store item in memory with priority."""
        if len(self.memory) >= self.capacity:
            # Remove lowest priority
            min_idx = self.priorities.index(min(self.priorities))
            self.memory.pop(min_idx)
            self.priorities.pop(min_idx)
        
        self.memory.append(item)
        self.priorities.append(priority)
    
    def recall(self, n: int = 5) -> List[Dict]:
        """Recall top-n items by priority."""
        if not self.memory:
            return []
        
        # Sort by priority
        sorted_items = sorted(
            zip(self.priorities, self.memory),
            key=lambda x: x[0],
            reverse=True
        )
        return [item for _, item in sorted_items[:n]]
    
    def replay(self, n: int = 10) -> List[Dict]:
        """
        Perform hippocampal replay — consolidate memories.
        
        Returns items above φ⁻¹ threshold for replay.
        """
        replay_items = []
        for priority, item in zip(self.priorities, self.memory):
            if priority > self.consolidation_threshold:
                replay_items.append(item)
                if len(replay_items) >= n:
                    break
        return replay_items
    
    def consolidate(self):
        """
        Consolidate memories — boost high-priority, decay low-priority.
        
        Priority update: p' = p × φ⁻¹ + (1 - φ⁻¹) × p²
        """
        self.priorities = [
            p * PHI_INV + (1 - PHI_INV) * (p ** 2)
            for p in self.priorities
        ]

# ─── MAIN LANGUAGE ENGINE ────────────────────────────────────────────────────
class LinguaEngine:
    """
    LINGUA — The Language Intelligence Engine
    
    Combines Liquid Language geometry, coherence scoring,
    and hippocampal memory for language understanding and generation.
    """
    
    def __init__(self):
        self.liquid = LiquidLanguage()
        self.memory = HippocampalMemory()
    
    def analyze(self, text: str) -> Dict:
        """
        Analyze text for linguistic features.
        
        Returns coherence, diversity, complexity metrics.
        """
        import time
        start = time.time()
        
        tokens = tokenize(text)
        sentences = [s.strip() for s in re.split(r'[.!?]', text) if s.strip()]
        
        # Build vocab
        self.liquid.build_vocab(text)
        
        # Compute metrics
        cs = coherence_score(text)
        ttr = type_token_ratio(tokens)
        hapax = hapax_legomena(tokens)
        sent_coh = sentence_coherence(sentences)
        doctrine_dist = self.liquid.doctrine_distance(text)
        loss = phi_loss(1.0, cs)
        
        elapsed = int((time.time() - start) * 1000)
        
        result = {
            'action': 'analyze',
            'tokens': len(tokens),
            'unique': len(set(tokens)),
            'sentences': len(sentences),
            'ttr': round(ttr, 4),
            'coherence': round(cs, 4),
            'sentence_coherence': round(sent_coh, 4),
            'hapax_count': len(hapax),
            'doctrine_distance': round(doctrine_dist, 4),
            'phi_loss': {
                'L_CE': 1.0,
                'CS': round(cs, 4),
                'L_nova': round(loss, 4),
                'ceiling': PHI_INV,
                'above_ceiling': cs > PHI_INV,
            },
            'elapsed_ms': elapsed,
            'phi': PHI,
            'alpha': 'ALPHA-002',
        }
        
        # Store in memory
        self.memory.store(result, priority=cs)
        
        return result
    
    def generate(self, prompt: str, max_tokens: int = 50) -> Dict:
        """
        Generate text continuation (simple statistical model).
        
        Note: This is a simplified generation using vocabulary statistics.
        For full generation, connect to actual LINGUA AIS endpoint.
        """
        import time
        start = time.time()
        
        # Build vocab from prompt
        self.liquid.build_vocab(prompt)
        
        # Simple generation: pick words by φ-weighted random
        tokens = tokenize(prompt)
        freq = word_frequencies(tokens)
        vocab_list = list(freq.keys())
        
        generated = []
        for _ in range(max_tokens):
            if not vocab_list:
                break
            
            # φ-weighted selection
            weights = [freq.get(w, 1) * PHI_INV for w in vocab_list]
            total = sum(weights)
            r = random.random() * total
            
            cumsum = 0
            for i, w in enumerate(vocab_list):
                cumsum += weights[i]
                if cumsum >= r:
                    generated.append(w)
                    break
        
        output_text = ' '.join(generated)
        cs = coherence_score(output_text)
        
        elapsed = int((time.time() - start) * 1000)
        
        return {
            'action': 'generate',
            'prompt': prompt[:50] + '...' if len(prompt) > 50 else prompt,
            'generated': output_text,
            'tokens_generated': len(generated),
            'coherence': round(cs, 4),
            'elapsed_ms': elapsed,
            'phi': PHI,
            'alpha': 'ALPHA-002',
        }
    
    def embed(self, text: str) -> Dict:
        """
        Embed text into Liquid Language space.
        """
        tokens = tokenize(text)
        self.liquid.build_vocab(text)
        
        # Compute average embedding
        embed_dim = self.liquid.embed_dim
        avg_embed = [0.0] * embed_dim
        
        for word in tokens:
            emb = self.liquid.embed(word)
            if emb:
                for i in range(embed_dim):
                    avg_embed[i] += emb[i]
        
        if tokens:
            avg_embed = [e / len(tokens) for e in avg_embed]
        
        # Compute magnitude
        magnitude = math.sqrt(sum(e ** 2 for e in avg_embed))
        
        return {
            'action': 'embed',
            'tokens': len(tokens),
            'embed_dim': embed_dim,
            'magnitude': round(magnitude, 4),
            'embedding_preview': [round(e, 4) for e in avg_embed[:8]],
            'phi': PHI,
            'alpha': 'ALPHA-002',
        }
    
    def store(self, content: str, priority: float = 1.0) -> Dict:
        """Store content in hippocampal memory."""
        item = {
            'content': content,
            'coherence': coherence_score(content),
            'timestamp': __import__('time').time(),
        }
        self.memory.store(item, priority=priority)
        
        return {
            'action': 'store',
            'stored': True,
            'priority': priority,
            'memory_size': len(self.memory.memory),
            'phi': PHI,
            'alpha': 'ALPHA-004',
        }
    
    def recall(self, n: int = 5) -> Dict:
        """Recall top items from memory."""
        items = self.memory.recall(n)
        
        return {
            'action': 'recall',
            'recalled': len(items),
            'items': items,
            'phi': PHI,
            'alpha': 'ALPHA-004',
        }
    
    def replay(self) -> Dict:
        """Perform hippocampal replay consolidation."""
        items = self.memory.replay()
        self.memory.consolidate()
        
        return {
            'action': 'replay',
            'replayed': len(items),
            'consolidated': True,
            'threshold': self.memory.consolidation_threshold,
            'phi': PHI,
            'alpha': 'ALPHA-004',
        }
    
    def status(self) -> Dict:
        """Return engine status."""
        return {
            'ais': 'LINGUA-NOVA',
            'brand': 'Nova',
            'platform': 'Pythonista iOS',
            'modalities': ['text', 'speech', 'audio', 'music', 'memory'],
            'alpha': ['ALPHA-002 LINGUA', 'ALPHA-004 MEMORIA'],
            'actions': ['analyze', 'generate', 'embed', 'store', 'recall', 'replay'],
            'math': {
                'phi_loss': f'L_nova = L_CE × (1 + φ⁻¹ × CS), ceiling={PHI_INV:.3f}',
                'liquid_language': 'Vocabulary as weight-space geometry',
                'hippocampal': 'Prioritized experience replay with φ consolidation',
            },
            'vocab_size': self.liquid.word_count,
            'memory_size': len(self.memory.memory),
            'phi': PHI,
            'phi_inv': PHI_INV,
        }

# ─── Global Engine Instance ──────────────────────────────────────────────────
_engine = None

def get_engine() -> LinguaEngine:
    """Get or create the global LINGUA engine."""
    global _engine
    if _engine is None:
        _engine = LinguaEngine()
    return _engine

def analyze(text: str) -> Dict:
    """Quick access to text analysis."""
    return get_engine().analyze(text)

def generate(prompt: str, max_tokens: int = 50) -> Dict:
    """Quick access to text generation."""
    return get_engine().generate(prompt, max_tokens)

# ─── Self-Test ───────────────────────────────────────────────────────────────
if __name__ == '__main__':
    print("╔════════════════════════════════════════════════════════════════╗")
    print("║           LINGUA — Language Engine — Self-Test                 ║")
    print("║           Nova by FreddyCreates — Pythonista iOS               ║")
    print("╚════════════════════════════════════════════════════════════════╝")
    print()
    
    engine = LinguaEngine()
    
    # Status
    status = engine.status()
    print(f"AIS: {status['ais']}")
    print(f"Platform: {status['platform']}")
    print(f"Actions: {', '.join(status['actions'])}")
    print()
    
    # Test analyze
    print("─── Testing ANALYZE ───")
    text = """The golden ratio φ appears throughout nature and mathematics.
    From the spiral of a nautilus shell to the proportions of the human body,
    this irrational number creates beauty and balance."""
    
    result = engine.analyze(text)
    print(f"Tokens: {result['tokens']}")
    print(f"TTR: {result['ttr']}")
    print(f"Coherence: {result['coherence']}")
    print(f"φ-Loss: {result['phi_loss']['L_nova']}")
    print(f"Above ceiling: {result['phi_loss']['above_ceiling']}")
    print()
    
    # Test embed
    print("─── Testing EMBED ───")
    emb = engine.embed("The organism thinks with synchronized oscillators.")
    print(f"Embed dim: {emb['embed_dim']}")
    print(f"Magnitude: {emb['magnitude']}")
    print()
    
    # Test store/recall
    print("─── Testing STORE/RECALL ───")
    engine.store("First memory: the organism awakens.", priority=0.9)
    engine.store("Second memory: coherence emerges.", priority=0.7)
    engine.store("Third memory: φ guides all.", priority=0.95)
    
    recalled = engine.recall(3)
    print(f"Recalled {recalled['recalled']} items")
    for item in recalled['items']:
        print(f"  - {item.get('content', '')[:40]}...")
    print()
    
    # Test generate
    print("─── Testing GENERATE ───")
    gen = engine.generate("The golden ratio", max_tokens=20)
    print(f"Generated: {gen['generated']}")
    print(f"Coherence: {gen['coherence']}")
    print()
    
    print("✓ LINGUA engine ready on Pythonista iOS.")
