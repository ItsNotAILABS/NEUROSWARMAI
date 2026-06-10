"""
Nova Python SDK for Pythonista iOS
Nova by FreddyCreates

The complete multimodal AI intelligence system on your phone.
20 AI tools across 5 categories with IP value tracking.

Quick Start:
    from nova_app import Nova
    nova = Nova()
    nova.reason("Your query")
    nova.analyze("Your text")
    nova.sense()  # Uses real iOS sensors!

Tools (20 total):
    TEXT:   summarize, translate, sentiment, extract
    VISION: classify_image, detect_objects, segment_image, ocr
    AUDIO:  transcribe, synthesize, classify_audio, enhance_audio
    CODE:   generate_code, review_code, refactor_code, document_code
    DATA:   analyze_data, transform_data, visualize_data, predict_data

Engines:
    - ANIMUS: Reasoning (Kuramoto + Hebbian + φ-loss)
    - LINGUA: Language (Liquid Language + memory)
    - OPTICA: Vision (Gabor + entropy saliency)
    - TACTUS: Somatic (sensors + PID + morphogenesis)
    - NEXUS: Mesh routing (small-world + Bayesian)

φ Constants:
    PHI = 1.618033988749895
    PHI_INV = 0.618033988749895
    PHI_BEAT = 873 ms
"""

__version__ = '0.2.0'
__author__ = 'FreddyCreates'
__brand__ = 'Nova'

from .phi import PHI, PHI_INV, PHI_BEAT, fib, phi_loss
from .maque import QUADS, FLOS, spawn_vivi, message, apex
from .animus import AnimusEngine
from .lingua import LinguaEngine
from .optica import OpticaEngine
from .tactus import TactusEngine
from .nexus import NexusEngine
from .registry import get_registry, list_tools, get_tool, search_tools, get_portfolio
from .economics import get_economics, record_usage, get_balance, get_usage_stats

# Import all 20 tools
from .tools.text_tools import summarize, translate, sentiment, extract
from .tools.vision_tools import classify_image, detect_objects, segment_image, ocr
from .tools.audio_tools import transcribe, synthesize, classify_audio, enhance_audio
from .tools.code_tools import generate_code, review_code, refactor_code, document_code
from .tools.data_tools import analyze_data, transform_data, visualize_data, predict_data

__all__ = [
    # Constants
    'PHI', 'PHI_INV', 'PHI_BEAT',
    # Functions
    'fib', 'phi_loss', 'spawn_vivi', 'message', 'apex',
    # Registry
    'QUADS', 'FLOS',
    # Engines
    'AnimusEngine', 'LinguaEngine', 'OpticaEngine', 'TactusEngine', 'NexusEngine',
    # Registry & Economics
    'get_registry', 'list_tools', 'get_tool', 'search_tools', 'get_portfolio',
    'get_economics', 'record_usage', 'get_balance', 'get_usage_stats',
    # TEXT Tools
    'summarize', 'translate', 'sentiment', 'extract',
    # VISION Tools
    'classify_image', 'detect_objects', 'segment_image', 'ocr',
    # AUDIO Tools
    'transcribe', 'synthesize', 'classify_audio', 'enhance_audio',
    # CODE Tools
    'generate_code', 'review_code', 'refactor_code', 'document_code',
    # DATA Tools
    'analyze_data', 'transform_data', 'visualize_data', 'predict_data',
]
