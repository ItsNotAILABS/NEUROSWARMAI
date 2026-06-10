#!/usr/bin/env python3
"""
Base Tool Class — Foundation for all Nova AI Tools
Nova by FreddyCreates — Pythonista iOS

Every tool inherits from NovaTool and gets:
- QUAD code identification
- Fibonacci versioning
- φ-weighted quality scoring
- IP value tracking
- Usage analytics
"""

import time
import hashlib
from typing import Dict, Any, Optional, List
from dataclasses import dataclass, field

# Import φ constants
import sys
sys.path.insert(0, '..')
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
class ToolMetrics:
    """Metrics for tool usage and IP value."""
    calls: int = 0
    total_time_ms: int = 0
    success_count: int = 0
    error_count: int = 0
    quality_sum: float = 0.0
    ip_value: float = 0.0
    
    @property
    def avg_time_ms(self) -> float:
        return self.total_time_ms / self.calls if self.calls > 0 else 0.0
    
    @property
    def success_rate(self) -> float:
        total = self.success_count + self.error_count
        return self.success_count / total if total > 0 else 0.0
    
    @property
    def avg_quality(self) -> float:
        return self.quality_sum / self.calls if self.calls > 0 else 0.0


class NovaTool:
    """
    Base class for all Nova AI tools.
    
    Provides:
    - QUAD code identification
    - Fibonacci versioning
    - φ-weighted quality scoring
    - IP value tracking
    - Usage analytics
    """
    
    # Override in subclasses
    QUAD = 'TOOL'
    NAME = 'Nova Tool'
    DESCRIPTION = 'Base Nova AI tool'
    CATEGORY = 'base'
    FIB_INDEX = 1
    MODALITIES = ['any']
    ALPHA_ENGINES = []
    
    def __init__(self):
        self.metrics = ToolMetrics()
        self.created_at = time.time()
        self._version = f'0.{fib(self.FIB_INDEX)}.0'
    
    @property
    def version(self) -> str:
        return self._version
    
    @property
    def fib_value(self) -> int:
        return fib(self.FIB_INDEX)
    
    def _compute_quality(self, result: Dict) -> float:
        """
        Compute φ-weighted quality score.
        
        Quality = φ⁻¹ × confidence + (1-φ⁻¹) × completeness
        """
        confidence = result.get('confidence', 0.5)
        completeness = result.get('completeness', 0.5)
        return PHI_INV * confidence + (1 - PHI_INV) * completeness
    
    def _compute_ip_value(self, quality: float, time_ms: int) -> float:
        """
        Compute IP value contribution.
        
        IP = quality × φ × (1 / log(time_ms + 1))
        Faster, higher quality = more IP value
        """
        import math
        time_factor = 1 / math.log(time_ms + 2)
        return quality * PHI * time_factor
    
    def _generate_artifact_id(self, result: Dict) -> str:
        """Generate APEX-style artifact ID."""
        content = str(result) + str(time.time())
        hash_val = hashlib.sha256(content.encode()).hexdigest()[:12]
        return f"APEX-{self.QUAD}-F{self.FIB_INDEX}-{hash_val}"
    
    def execute(self, *args, **kwargs) -> Dict:
        """
        Execute the tool with metrics tracking.
        Override _run() in subclasses.
        """
        start = time.time()
        
        try:
            result = self._run(*args, **kwargs)
            elapsed_ms = int((time.time() - start) * 1000)
            
            # Compute quality
            quality = self._compute_quality(result)
            ip_value = self._compute_ip_value(quality, elapsed_ms)
            
            # Update metrics
            self.metrics.calls += 1
            self.metrics.total_time_ms += elapsed_ms
            self.metrics.success_count += 1
            self.metrics.quality_sum += quality
            self.metrics.ip_value += ip_value
            
            # Enrich result
            result['_meta'] = {
                'tool': self.QUAD,
                'name': self.NAME,
                'version': self.version,
                'fib_index': self.FIB_INDEX,
                'fib_value': self.fib_value,
                'elapsed_ms': elapsed_ms,
                'quality': round(quality, 4),
                'ip_value': round(ip_value, 4),
                'artifact_id': self._generate_artifact_id(result),
                'phi': PHI,
            }
            
            return result
            
        except Exception as e:
            elapsed_ms = int((time.time() - start) * 1000)
            self.metrics.calls += 1
            self.metrics.total_time_ms += elapsed_ms
            self.metrics.error_count += 1
            
            return {
                'error': str(e),
                '_meta': {
                    'tool': self.QUAD,
                    'name': self.NAME,
                    'version': self.version,
                    'elapsed_ms': elapsed_ms,
                    'success': False,
                }
            }
    
    def _run(self, *args, **kwargs) -> Dict:
        """Override in subclasses."""
        raise NotImplementedError("Subclasses must implement _run()")
    
    def status(self) -> Dict:
        """Get tool status and metrics."""
        return {
            'quad': self.QUAD,
            'name': self.NAME,
            'description': self.DESCRIPTION,
            'category': self.CATEGORY,
            'version': self.version,
            'fib_index': self.FIB_INDEX,
            'fib_value': self.fib_value,
            'modalities': self.MODALITIES,
            'alpha_engines': self.ALPHA_ENGINES,
            'metrics': {
                'calls': self.metrics.calls,
                'avg_time_ms': round(self.metrics.avg_time_ms, 2),
                'success_rate': round(self.metrics.success_rate, 4),
                'avg_quality': round(self.metrics.avg_quality, 4),
                'ip_value': round(self.metrics.ip_value, 4),
            },
            'phi': PHI,
        }
    
    def __repr__(self):
        return f"<{self.NAME} [{self.QUAD}] v{self.version}>"


# ─── Tool Categories ─────────────────────────────────────────────────────────
CATEGORIES = {
    'text': {
        'name': 'Text Processing',
        'description': 'Natural language understanding and generation',
        'modalities': ['text', 'language'],
        'alpha_engines': ['ALPHA-002 LINGUA'],
    },
    'vision': {
        'name': 'Computer Vision',
        'description': 'Image and video analysis',
        'modalities': ['image', 'video', 'spatial'],
        'alpha_engines': ['ALPHA-003 OPTICA'],
    },
    'audio': {
        'name': 'Audio Processing',
        'description': 'Speech and sound analysis',
        'modalities': ['audio', 'speech', 'music'],
        'alpha_engines': ['ALPHA-002 LINGUA', 'ALPHA-004 MEMORIA'],
    },
    'code': {
        'name': 'Code Intelligence',
        'description': 'Code generation and analysis',
        'modalities': ['code', 'structured'],
        'alpha_engines': ['ALPHA-001 ANIMUS', 'ALPHA-005 FABRICA'],
    },
    'data': {
        'name': 'Data Science',
        'description': 'Data analysis and prediction',
        'modalities': ['structured', 'time-series'],
        'alpha_engines': ['ALPHA-006 PROPHETA', 'ALPHA-007 VERITAS'],
    },
}
