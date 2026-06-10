#!/usr/bin/env python3
"""
Nova Tools Demo — All 20 AI Tools in One Script
Nova by FreddyCreates — Pythonista iOS

This script demonstrates all 20 multimodal AI tools.
Copy to Pythonista and run!
"""

import sys
sys.path.insert(0, '..')

# Import all tools
from tools.text_tools import summarize, translate, sentiment, extract
from tools.vision_tools import classify_image, detect_objects, segment_image, ocr
from tools.audio_tools import transcribe, synthesize, classify_audio, enhance_audio
from tools.code_tools import generate_code, review_code, refactor_code, document_code
from tools.data_tools import analyze_data, transform_data, visualize_data, predict_data
from registry import get_registry, get_portfolio
from economics import get_economics, get_balance

def main():
    print("╔════════════════════════════════════════════════════════════════╗")
    print("║           Nova Tools Demo — 20 AI Tools                        ║")
    print("║           Nova by FreddyCreates — Pythonista iOS               ║")
    print("╚════════════════════════════════════════════════════════════════╝")
    print()
    
    # ─── TEXT TOOLS ──────────────────────────────────────────────────────────
    print("═══ TEXT TOOLS ═══")
    print()
    
    test_text = """
    The golden ratio, approximately 1.618, appears throughout nature and art.
    It governs the spiral patterns in shells and the arrangement of leaves.
    This beautiful mathematical constant creates harmony and balance.
    """
    
    print("1. SUMM — Summarize")
    result = summarize(test_text)
    print(f"   Summary: {result['summary'][:60]}...")
    print(f"   Compression: {result['compression_ratio']}")
    print()
    
    print("2. TRAN — Translate")
    result = translate("hello world golden ratio", target='es')
    print(f"   Translation: {result['translation']}")
    print()
    
    print("3. SENT — Sentiment")
    result = sentiment("This is a beautiful and wonderful golden harmony!")
    print(f"   Sentiment: {result['sentiment']} (score: {result['score']})")
    print()
    
    print("4. EXTR — Extract")
    result = extract(test_text)
    print(f"   Keywords: {result['keywords'][:5]}")
    print()
    
    # ─── VISION TOOLS ────────────────────────────────────────────────────────
    print("═══ VISION TOOLS ═══")
    print()
    
    print("5. CLAS — Classify Image")
    result = classify_image()
    print(f"   Class: {result['class']} ({result['probability']:.2%})")
    print()
    
    print("6. DETE — Detect Objects")
    result = detect_objects()
    print(f"   Detections: {result['count']}")
    for d in result['detections'][:2]:
        print(f"     - {d['class']}: {d['confidence']:.2%}")
    print()
    
    print("7. SEGM — Segment Image")
    result = segment_image()
    print(f"   Segments: {result['count']}")
    print(f"   Total entropy: {result['total_entropy']:.4f}")
    print()
    
    print("8. OCRR — OCR")
    result = ocr()
    print(f"   Text: {result['text'][:50]}...")
    print()
    
    # ─── AUDIO TOOLS ─────────────────────────────────────────────────────────
    print("═══ AUDIO TOOLS ═══")
    print()
    
    print("9. TRNS — Transcribe")
    result = transcribe(duration_ms=5000)
    print(f"   Text: {result['text']}")
    print()
    
    print("10. SYNT — Synthesize")
    result = synthesize("The golden ratio governs nature.")
    print(f"    Duration: {result['duration_ms']}ms")
    print()
    
    print("11. CLAU — Classify Audio")
    result = classify_audio()
    print(f"    Class: {result['class']} ({result['probability']:.2%})")
    print()
    
    print("12. ENHA — Enhance Audio")
    result = enhance_audio(noise_reduction=0.7)
    print(f"    SNR improvement: {result['improvements']['snr_improvement_db']:.1f}dB")
    print()
    
    # ─── CODE TOOLS ──────────────────────────────────────────────────────────
    print("═══ CODE TOOLS ═══")
    print()
    
    print("13. GENC — Generate Code")
    result = generate_code("calculate fibonacci with number n")
    print(f"    Function: {result['function_name']}")
    print(f"    Lines: {result['lines']}")
    print()
    
    test_code = '''
def calc(x):
    # TODO: fix this
    result = x * 1000
    print(result)
    return result
'''
    
    print("14. REVC — Review Code")
    result = review_code(test_code)
    print(f"    Quality: {result['quality_score']:.2%}")
    print(f"    Issues: {result['issue_count']}")
    print()
    
    print("15. REFC — Refactor Code")
    result = refactor_code(test_code)
    print(f"    Suggestions: {result['suggestion_count']}")
    print()
    
    print("16. DOCC — Document Code")
    result = document_code(test_code)
    print(f"    Doc lines: {result['doc_lines']}")
    print()
    
    # ─── DATA TOOLS ──────────────────────────────────────────────────────────
    print("═══ DATA TOOLS ═══")
    print()
    
    print("17. ANLD — Analyze Data")
    result = analyze_data()
    print(f"    Mean: {result['statistics']['mean']:.4f}")
    print(f"    φ-aligned: {result['phi_metrics']['phi_aligned']}")
    print()
    
    print("18. TRFD — Transform Data")
    result = transform_data(method='phi_scale')
    print(f"    Method: {result['method']}")
    print(f"    Transformed mean: {result['transformed']['stats']['mean']:.4f}")
    print()
    
    print("19. VISD — Visualize Data")
    result = visualize_data()
    print(f"    Chart: {result['chart_type']}")
    print(f"    Dimensions: {result['specification']['dimensions']['width']}×{result['specification']['dimensions']['height']}")
    print()
    
    print("20. PRED — Predict Data")
    result = predict_data(n_predict=3)
    print(f"    Predictions:")
    for p in result['predictions']:
        print(f"      Step {p['step']}: {p['value']:.4f} ± {p['uncertainty']:.4f}")
    print()
    
    # ─── REGISTRY & ECONOMICS ────────────────────────────────────────────────
    print("═══ REGISTRY & ECONOMICS ═══")
    print()
    
    registry = get_registry()
    print(f"Total tools: {registry.status()['total_tools']}")
    print(f"Categories: {registry.status()['categories']}")
    print()
    
    portfolio = get_portfolio()
    print(f"IP Portfolio:")
    for cat, info in portfolio['categories'].items():
        print(f"  {cat}: {info['tools']} tools, {info['ip_value']} IP")
    print()
    
    balance = get_balance()
    print(f"Token Balance: {balance['net_balance']}")
    print()
    
    print("═══════════════════════════════════════════════════════════════════")
    print("✓ All 20 Nova tools demonstrated successfully!")
    print("  Copy this folder to Pythonista and run nova_app.py for the full UI.")
    print("═══════════════════════════════════════════════════════════════════")


if __name__ == '__main__':
    main()
