#!/usr/bin/env python3
"""
Nova Tool Registry — IP Value Portfolio for Nova Tools
Nova by FreddyCreates — Pythonista iOS

The registry tracks:
- All 20 multimodal AI tools
- IP value accumulation
- Usage analytics
- Fibonacci versioning
- QUAD code mapping
"""

import json
import time
from typing import Dict, List, Optional, Any
from dataclasses import dataclass, field, asdict

# Import φ constants
try:
    from phi import PHI, PHI_INV, fib
except ImportError:
    PHI = 1.618033988749895
    PHI_INV = 0.618033988749895
    def fib(n):
        if n <= 1: return n
        a, b = 0, 1
        for _ in range(n - 1):
            a, b = b, a + b
        return b


@dataclass
class ToolEntry:
    """Registry entry for a Nova tool."""
    quad: str
    name: str
    description: str
    category: str
    fib_index: int
    modalities: List[str]
    alpha_engines: List[str]
    version: str = '0.1.0'
    ip_value: float = 0.0
    total_calls: int = 0
    total_time_ms: int = 0
    success_rate: float = 1.0
    created_at: float = field(default_factory=time.time)
    
    @property
    def fib_value(self) -> int:
        return fib(self.fib_index)
    
    def to_dict(self) -> Dict:
        d = asdict(self)
        d['fib_value'] = self.fib_value
        return d


class NovaRegistry:
    """
    Nova Tool Registry — Central registry for all Nova AI tools.
    
    Tracks IP value, usage, and provides tool discovery.
    """
    
    def __init__(self):
        self.tools: Dict[str, ToolEntry] = {}
        self.categories: Dict[str, List[str]] = {}
        self.total_ip_value: float = 0.0
        self.created_at = time.time()
        
        # Initialize with all 20 tools
        self._register_all_tools()
    
    def _register_all_tools(self):
        """Register all 20 Nova tools."""
        
        # TEXT TOOLS (4)
        self.register(ToolEntry(
            quad='SUMM', name='Summarize', category='text', fib_index=1,
            description='Extract key points from text using φ-weighted TF-IDF',
            modalities=['text', 'language'],
            alpha_engines=['ALPHA-002 LINGUA'],
        ))
        self.register(ToolEntry(
            quad='TRAN', name='Translate', category='text', fib_index=2,
            description='Language translation with phonetic awareness',
            modalities=['text', 'language'],
            alpha_engines=['ALPHA-002 LINGUA', 'ALPHA-004 MEMORIA'],
        ))
        self.register(ToolEntry(
            quad='SENT', name='Sentiment', category='text', fib_index=3,
            description='Emotion and sentiment analysis with φ-weighted scoring',
            modalities=['text', 'language'],
            alpha_engines=['ALPHA-002 LINGUA', 'ALPHA-009 TACTUS'],
        ))
        self.register(ToolEntry(
            quad='EXTR', name='Extract', category='text', fib_index=4,
            description='Entity and keyword extraction with pattern matching',
            modalities=['text', 'language', 'structured'],
            alpha_engines=['ALPHA-002 LINGUA', 'ALPHA-001 ANIMUS'],
        ))
        
        # VISION TOOLS (4)
        self.register(ToolEntry(
            quad='CLAS', name='Classify Image', category='vision', fib_index=5,
            description='Image classification with Gabor-inspired features',
            modalities=['image', 'visual'],
            alpha_engines=['ALPHA-003 OPTICA'],
        ))
        self.register(ToolEntry(
            quad='DETE', name='Detect Objects', category='vision', fib_index=6,
            description='Object detection with φ-scaled anchor boxes',
            modalities=['image', 'video', 'spatial'],
            alpha_engines=['ALPHA-003 OPTICA', 'ALPHA-010 NEXUS'],
        ))
        self.register(ToolEntry(
            quad='SEGM', name='Segment Image', category='vision', fib_index=7,
            description='Image segmentation with entropy-based region growing',
            modalities=['image', 'spatial'],
            alpha_engines=['ALPHA-003 OPTICA', 'ALPHA-008 KOSMOS'],
        ))
        self.register(ToolEntry(
            quad='OCRR', name='OCR', category='vision', fib_index=8,
            description='Optical character recognition with pattern matching',
            modalities=['image', 'text', 'document'],
            alpha_engines=['ALPHA-003 OPTICA', 'ALPHA-002 LINGUA'],
        ))
        
        # AUDIO TOOLS (4)
        self.register(ToolEntry(
            quad='TRNS', name='Transcribe', category='audio', fib_index=9,
            description='Speech to text transcription with phoneme recognition',
            modalities=['audio', 'speech', 'text'],
            alpha_engines=['ALPHA-002 LINGUA', 'ALPHA-004 MEMORIA'],
        ))
        self.register(ToolEntry(
            quad='SYNT', name='Synthesize', category='audio', fib_index=10,
            description='Text to speech synthesis with prosody control',
            modalities=['text', 'audio', 'speech'],
            alpha_engines=['ALPHA-002 LINGUA'],
        ))
        self.register(ToolEntry(
            quad='CLAU', name='Classify Audio', category='audio', fib_index=11,
            description='Audio classification with spectral feature analysis',
            modalities=['audio', 'music', 'speech'],
            alpha_engines=['ALPHA-002 LINGUA', 'ALPHA-003 OPTICA'],
        ))
        self.register(ToolEntry(
            quad='ENHA', name='Enhance Audio', category='audio', fib_index=12,
            description='Audio enhancement with φ-weighted noise reduction',
            modalities=['audio', 'speech', 'music'],
            alpha_engines=['ALPHA-008 KOSMOS', 'ALPHA-009 TACTUS'],
        ))
        
        # CODE TOOLS (4)
        self.register(ToolEntry(
            quad='GENC', name='Generate Code', category='code', fib_index=13,
            description='Code generation from natural language with φ-structured templates',
            modalities=['text', 'code', 'structured'],
            alpha_engines=['ALPHA-001 ANIMUS', 'ALPHA-005 FABRICA'],
        ))
        self.register(ToolEntry(
            quad='REVC', name='Review Code', category='code', fib_index=14,
            description='Code review with φ-weighted quality scoring',
            modalities=['code', 'text'],
            alpha_engines=['ALPHA-001 ANIMUS', 'ALPHA-007 VERITAS'],
        ))
        self.register(ToolEntry(
            quad='REFC', name='Refactor Code', category='code', fib_index=15,
            description='Code refactoring with φ-optimal structure',
            modalities=['code', 'structured'],
            alpha_engines=['ALPHA-005 FABRICA', 'ALPHA-001 ANIMUS'],
        ))
        self.register(ToolEntry(
            quad='DOCC', name='Document Code', category='code', fib_index=16,
            description='Auto-generate documentation with φ-structured format',
            modalities=['code', 'text', 'documentation'],
            alpha_engines=['ALPHA-002 LINGUA', 'ALPHA-001 ANIMUS'],
        ))
        
        # DATA TOOLS (4)
        self.register(ToolEntry(
            quad='ANLD', name='Analyze Data', category='data', fib_index=17,
            description='Statistical data analysis with φ-weighted metrics',
            modalities=['structured', 'numerical', 'tabular'],
            alpha_engines=['ALPHA-007 VERITAS', 'ALPHA-006 PROPHETA'],
        ))
        self.register(ToolEntry(
            quad='TRFD', name='Transform Data', category='data', fib_index=18,
            description='Data transformation with φ-optimal scaling',
            modalities=['structured', 'numerical'],
            alpha_engines=['ALPHA-005 FABRICA'],
        ))
        self.register(ToolEntry(
            quad='VISD', name='Visualize Data', category='data', fib_index=19,
            description='Data visualization with φ-proportioned layouts',
            modalities=['structured', 'visual'],
            alpha_engines=['ALPHA-003 OPTICA'],
        ))
        self.register(ToolEntry(
            quad='PRED', name='Predict Data', category='data', fib_index=20,
            description='Time series prediction with Kalman filtering',
            modalities=['time-series', 'numerical'],
            alpha_engines=['ALPHA-006 PROPHETA', 'ALPHA-007 VERITAS'],
        ))
    
    def register(self, tool: ToolEntry):
        """Register a tool in the registry."""
        self.tools[tool.quad] = tool
        
        if tool.category not in self.categories:
            self.categories[tool.category] = []
        if tool.quad not in self.categories[tool.category]:
            self.categories[tool.category].append(tool.quad)
    
    def get(self, quad: str) -> Optional[ToolEntry]:
        """Get a tool by QUAD code."""
        return self.tools.get(quad)
    
    def list_all(self) -> List[Dict]:
        """List all registered tools."""
        return [t.to_dict() for t in self.tools.values()]
    
    def list_by_category(self, category: str) -> List[Dict]:
        """List tools in a category."""
        quads = self.categories.get(category, [])
        return [self.tools[q].to_dict() for q in quads if q in self.tools]
    
    def search(self, query: str) -> List[Dict]:
        """Search tools by name or description."""
        query = query.lower()
        results = []
        for tool in self.tools.values():
            if query in tool.name.lower() or query in tool.description.lower():
                results.append(tool.to_dict())
        return results
    
    def update_metrics(self, quad: str, calls: int = 0, time_ms: int = 0, 
                       ip_value: float = 0.0, success_rate: float = 1.0):
        """Update tool metrics."""
        if quad in self.tools:
            tool = self.tools[quad]
            tool.total_calls += calls
            tool.total_time_ms += time_ms
            tool.ip_value += ip_value
            tool.success_rate = (tool.success_rate + success_rate) / 2
            self.total_ip_value += ip_value
    
    def get_ip_portfolio(self) -> Dict:
        """Get IP value portfolio summary."""
        portfolio = {
            'total_ip_value': round(self.total_ip_value, 4),
            'total_tools': len(self.tools),
            'categories': {},
            'top_tools': [],
        }
        
        # By category
        for category, quads in self.categories.items():
            cat_value = sum(self.tools[q].ip_value for q in quads if q in self.tools)
            cat_calls = sum(self.tools[q].total_calls for q in quads if q in self.tools)
            portfolio['categories'][category] = {
                'tools': len(quads),
                'ip_value': round(cat_value, 4),
                'total_calls': cat_calls,
            }
        
        # Top tools by IP value
        sorted_tools = sorted(self.tools.values(), key=lambda t: t.ip_value, reverse=True)
        portfolio['top_tools'] = [
            {'quad': t.quad, 'name': t.name, 'ip_value': round(t.ip_value, 4)}
            for t in sorted_tools[:5]
        ]
        
        return portfolio
    
    def export_jsonl(self) -> str:
        """Export registry as JSONL."""
        lines = []
        for tool in self.tools.values():
            lines.append(json.dumps(tool.to_dict()))
        return '\n'.join(lines)
    
    def status(self) -> Dict:
        """Get registry status."""
        return {
            'name': 'Nova Tool Registry',
            'brand': 'Nova by FreddyCreates',
            'total_tools': len(self.tools),
            'categories': list(self.categories.keys()),
            'tools_per_category': {k: len(v) for k, v in self.categories.items()},
            'total_ip_value': round(self.total_ip_value, 4),
            'uptime_seconds': int(time.time() - self.created_at),
            'phi': PHI,
        }


# ─── Global Registry Instance ────────────────────────────────────────────────
_registry = None

def get_registry() -> NovaRegistry:
    """Get or create the global registry."""
    global _registry
    if _registry is None:
        _registry = NovaRegistry()
    return _registry


# ─── Quick Access Functions ──────────────────────────────────────────────────
def list_tools() -> List[Dict]:
    """List all tools."""
    return get_registry().list_all()

def get_tool(quad: str) -> Optional[Dict]:
    """Get a tool by QUAD code."""
    tool = get_registry().get(quad)
    return tool.to_dict() if tool else None

def search_tools(query: str) -> List[Dict]:
    """Search tools."""
    return get_registry().search(query)

def get_portfolio() -> Dict:
    """Get IP portfolio."""
    return get_registry().get_ip_portfolio()


# ─── Self-Test ───────────────────────────────────────────────────────────────
if __name__ == '__main__':
    print("╔════════════════════════════════════════════════════════════════╗")
    print("║              Nova Tool Registry — Self-Test                    ║")
    print("║              Nova by FreddyCreates                             ║")
    print("╚════════════════════════════════════════════════════════════════╝")
    print()
    
    registry = get_registry()
    
    print("─── STATUS ───")
    status = registry.status()
    print(f"Total tools: {status['total_tools']}")
    print(f"Categories: {status['categories']}")
    print()
    
    print("─── TOOLS BY CATEGORY ───")
    for category in status['categories']:
        tools = registry.list_by_category(category)
        print(f"\n{category.upper()} ({len(tools)} tools):")
        for t in tools:
            print(f"  [{t['quad']}] {t['name']} - F{t['fib_index']}")
    print()
    
    print("─── SEARCH ───")
    results = registry.search('image')
    print(f"Search 'image': {len(results)} results")
    for r in results:
        print(f"  [{r['quad']}] {r['name']}")
    print()
    
    print("─── IP PORTFOLIO ───")
    portfolio = registry.get_ip_portfolio()
    print(f"Total IP value: {portfolio['total_ip_value']}")
    print(f"Categories: {list(portfolio['categories'].keys())}")
    print()
    
    print("✓ Registry ready with 20 tools.")
