#!/usr/bin/env python3
"""
Nova Tools — 20 Multimodal AI Tools for Developers
Nova by FreddyCreates — Pythonista iOS

Categories:
- TEXT (4 tools): Summarize, Translate, Sentiment, Extract
- VISION (4 tools): Classify, Detect, Segment, OCR
- AUDIO (4 tools): Transcribe, Synthesize, Classify, Enhance
- CODE (4 tools): Generate, Review, Refactor, Document
- DATA (4 tools): Analyze, Transform, Visualize, Predict

Each tool has:
- QUAD code (4-letter identifier)
- Fibonacci version
- φ-weighted scoring
- IP value tracking
"""

__version__ = '0.1.0'
__author__ = 'FreddyCreates'
__brand__ = 'Nova'

# Import all tools
from .text_tools import (
    summarize, translate, sentiment, extract,
    SummarizeTool, TranslateTool, SentimentTool, ExtractTool
)
from .vision_tools import (
    classify_image, detect_objects, segment_image, ocr,
    ClassifyTool, DetectTool, SegmentTool, OCRTool
)
from .audio_tools import (
    transcribe, synthesize, classify_audio, enhance_audio,
    TranscribeTool, SynthesizeTool, ClassifyAudioTool, EnhanceTool
)
from .code_tools import (
    generate_code, review_code, refactor_code, document_code,
    GenerateTool, ReviewTool, RefactorTool, DocumentTool
)
from .data_tools import (
    analyze_data, transform_data, visualize_data, predict_data,
    AnalyzeTool, TransformTool, VisualizeTool, PredictTool
)

# Tool registry
TOOLS = {
    # TEXT
    'SUMM': SummarizeTool,
    'TRAN': TranslateTool,
    'SENT': SentimentTool,
    'EXTR': ExtractTool,
    # VISION
    'CLAS': ClassifyTool,
    'DETE': DetectTool,
    'SEGM': SegmentTool,
    'OCRR': OCRTool,
    # AUDIO
    'TRNS': TranscribeTool,
    'SYNT': SynthesizeTool,
    'CLAU': ClassifyAudioTool,
    'ENHA': EnhanceTool,
    # CODE
    'GENC': GenerateTool,
    'REVC': ReviewTool,
    'REFC': RefactorTool,
    'DOCC': DocumentTool,
    # DATA
    'ANLD': AnalyzeTool,
    'TRFD': TransformTool,
    'VISD': VisualizeTool,
    'PRED': PredictTool,
}

__all__ = [
    # Functions
    'summarize', 'translate', 'sentiment', 'extract',
    'classify_image', 'detect_objects', 'segment_image', 'ocr',
    'transcribe', 'synthesize', 'classify_audio', 'enhance_audio',
    'generate_code', 'review_code', 'refactor_code', 'document_code',
    'analyze_data', 'transform_data', 'visualize_data', 'predict_data',
    # Classes
    'SummarizeTool', 'TranslateTool', 'SentimentTool', 'ExtractTool',
    'ClassifyTool', 'DetectTool', 'SegmentTool', 'OCRTool',
    'TranscribeTool', 'SynthesizeTool', 'ClassifyAudioTool', 'EnhanceTool',
    'GenerateTool', 'ReviewTool', 'RefactorTool', 'DocumentTool',
    'AnalyzeTool', 'TransformTool', 'VisualizeTool', 'PredictTool',
    # Registry
    'TOOLS',
]
