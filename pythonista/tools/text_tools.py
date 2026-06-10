#!/usr/bin/env python3
"""
Text Tools — 4 NLP Tools for Nova
Nova by FreddyCreates — Pythonista iOS

Tools:
- SUMM: Summarize — Extract key points from text
- TRAN: Translate — Language translation
- SENT: Sentiment — Emotion and sentiment analysis
- EXTR: Extract — Entity and keyword extraction
"""

import re
import math
from typing import Dict, List, Optional
from collections import Counter
from .base import NovaTool, PHI, PHI_INV


# ─── SUMMARIZE TOOL ──────────────────────────────────────────────────────────
class SummarizeTool(NovaTool):
    """
    SUMM — Text Summarization Tool
    
    Extracts key sentences using φ-weighted TF-IDF scoring.
    """
    
    QUAD = 'SUMM'
    NAME = 'Summarize'
    DESCRIPTION = 'Extract key points from text using φ-weighted TF-IDF'
    CATEGORY = 'text'
    FIB_INDEX = 1
    MODALITIES = ['text', 'language']
    ALPHA_ENGINES = ['ALPHA-002 LINGUA']
    
    def _run(self, text: str, ratio: float = 0.3, **kwargs) -> Dict:
        """
        Summarize text by extracting key sentences.
        
        Args:
            text: Input text to summarize
            ratio: Fraction of sentences to keep (default 0.3)
        
        Returns:
            Dict with summary and metrics
        """
        # Split into sentences
        sentences = re.split(r'[.!?]+', text)
        sentences = [s.strip() for s in sentences if s.strip()]
        
        if len(sentences) == 0:
            return {
                'summary': '',
                'sentences': 0,
                'confidence': 0.0,
                'completeness': 0.0,
            }
        
        # Compute word frequencies
        words = text.lower().split()
        word_freq = Counter(words)
        max_freq = max(word_freq.values()) if word_freq else 1
        
        # Normalize frequencies
        for word in word_freq:
            word_freq[word] /= max_freq
        
        # Score sentences using φ-weighted TF
        scores = []
        for i, sent in enumerate(sentences):
            sent_words = sent.lower().split()
            if len(sent_words) == 0:
                scores.append(0)
                continue
            
            # TF score
            tf_score = sum(word_freq.get(w, 0) for w in sent_words) / len(sent_words)
            
            # Position weight (earlier sentences weighted by φ)
            position_weight = PHI_INV ** (i / len(sentences))
            
            # Length penalty (prefer medium-length sentences)
            length_factor = min(len(sent_words) / 20, 1.0)
            
            # φ-weighted combination
            score = PHI_INV * tf_score + (1 - PHI_INV) * position_weight * length_factor
            scores.append(score)
        
        # Select top sentences
        n_keep = max(1, int(len(sentences) * ratio))
        ranked = sorted(enumerate(scores), key=lambda x: x[1], reverse=True)
        top_indices = sorted([idx for idx, _ in ranked[:n_keep]])
        
        summary_sentences = [sentences[i] for i in top_indices]
        summary = '. '.join(summary_sentences) + '.'
        
        return {
            'summary': summary,
            'original_sentences': len(sentences),
            'summary_sentences': len(summary_sentences),
            'compression_ratio': round(len(summary) / len(text), 4) if text else 0,
            'top_scores': [round(scores[i], 4) for i in top_indices[:3]],
            'confidence': round(max(scores) if scores else 0, 4),
            'completeness': round(len(summary_sentences) / len(sentences), 4),
        }


# ─── TRANSLATE TOOL ──────────────────────────────────────────────────────────
class TranslateTool(NovaTool):
    """
    TRAN — Translation Tool
    
    Simulates translation with phonetic transformation.
    (Real translation would require external API)
    """
    
    QUAD = 'TRAN'
    NAME = 'Translate'
    DESCRIPTION = 'Language translation with phonetic awareness'
    CATEGORY = 'text'
    FIB_INDEX = 2
    MODALITIES = ['text', 'language']
    ALPHA_ENGINES = ['ALPHA-002 LINGUA', 'ALPHA-004 MEMORIA']
    
    # Simple word mappings for demo
    DEMO_VOCAB = {
        'en_es': {
            'hello': 'hola', 'world': 'mundo', 'the': 'el', 'is': 'es',
            'good': 'bueno', 'morning': 'mañana', 'night': 'noche',
            'golden': 'dorado', 'ratio': 'proporción', 'nature': 'naturaleza',
        },
        'en_fr': {
            'hello': 'bonjour', 'world': 'monde', 'the': 'le', 'is': 'est',
            'good': 'bon', 'morning': 'matin', 'night': 'nuit',
            'golden': 'doré', 'ratio': 'rapport', 'nature': 'nature',
        },
        'en_de': {
            'hello': 'hallo', 'world': 'welt', 'the': 'die', 'is': 'ist',
            'good': 'gut', 'morning': 'morgen', 'night': 'nacht',
            'golden': 'golden', 'ratio': 'verhältnis', 'nature': 'natur',
        },
    }
    
    def _run(self, text: str, source: str = 'en', target: str = 'es', **kwargs) -> Dict:
        """
        Translate text between languages.
        
        Args:
            text: Input text
            source: Source language code
            target: Target language code
        
        Returns:
            Dict with translation and metrics
        """
        vocab_key = f'{source}_{target}'
        vocab = self.DEMO_VOCAB.get(vocab_key, {})
        
        words = text.lower().split()
        translated = []
        matched = 0
        
        for word in words:
            clean = re.sub(r'[^\w]', '', word)
            if clean in vocab:
                translated.append(vocab[clean])
                matched += 1
            else:
                translated.append(word)
        
        translation = ' '.join(translated)
        coverage = matched / len(words) if words else 0
        
        return {
            'translation': translation,
            'source': source,
            'target': target,
            'words': len(words),
            'matched': matched,
            'coverage': round(coverage, 4),
            'confidence': round(coverage * PHI_INV + (1 - PHI_INV) * 0.5, 4),
            'completeness': round(coverage, 4),
            'note': 'Demo translation - real implementation requires API',
        }


# ─── SENTIMENT TOOL ──────────────────────────────────────────────────────────
class SentimentTool(NovaTool):
    """
    SENT — Sentiment Analysis Tool
    
    Analyzes emotional tone using φ-weighted lexicon scoring.
    """
    
    QUAD = 'SENT'
    NAME = 'Sentiment'
    DESCRIPTION = 'Emotion and sentiment analysis with φ-weighted scoring'
    CATEGORY = 'text'
    FIB_INDEX = 3
    MODALITIES = ['text', 'language']
    ALPHA_ENGINES = ['ALPHA-002 LINGUA', 'ALPHA-009 TACTUS']
    
    # Sentiment lexicon
    POSITIVE = {
        'good', 'great', 'excellent', 'amazing', 'wonderful', 'beautiful',
        'love', 'happy', 'joy', 'perfect', 'best', 'awesome', 'fantastic',
        'brilliant', 'golden', 'harmony', 'balance', 'coherent', 'unified',
    }
    NEGATIVE = {
        'bad', 'terrible', 'awful', 'horrible', 'hate', 'sad', 'angry',
        'worst', 'poor', 'ugly', 'broken', 'chaos', 'disorder', 'failed',
    }
    INTENSIFIERS = {'very', 'extremely', 'really', 'absolutely', 'totally'}
    
    def _run(self, text: str, **kwargs) -> Dict:
        """
        Analyze sentiment of text.
        
        Args:
            text: Input text
        
        Returns:
            Dict with sentiment scores and classification
        """
        words = text.lower().split()
        
        pos_count = 0
        neg_count = 0
        intensity = 1.0
        
        prev_word = ''
        for word in words:
            clean = re.sub(r'[^\w]', '', word)
            
            # Check for intensifiers
            if clean in self.INTENSIFIERS:
                intensity = PHI  # Boost by φ
                prev_word = clean
                continue
            
            if clean in self.POSITIVE:
                pos_count += intensity
            elif clean in self.NEGATIVE:
                neg_count += intensity
            
            intensity = 1.0
            prev_word = clean
        
        total = pos_count + neg_count
        
        if total == 0:
            sentiment = 'neutral'
            score = 0.0
            confidence = 0.3
        else:
            score = (pos_count - neg_count) / total
            if score > PHI_INV:
                sentiment = 'positive'
            elif score < -PHI_INV:
                sentiment = 'negative'
            else:
                sentiment = 'neutral'
            confidence = abs(score)
        
        return {
            'sentiment': sentiment,
            'score': round(score, 4),
            'positive_count': round(pos_count, 2),
            'negative_count': round(neg_count, 2),
            'words_analyzed': len(words),
            'confidence': round(confidence, 4),
            'completeness': round(min(len(words) / 50, 1.0), 4),
            'phi_threshold': PHI_INV,
        }


# ─── EXTRACT TOOL ────────────────────────────────────────────────────────────
class ExtractTool(NovaTool):
    """
    EXTR — Entity and Keyword Extraction Tool
    
    Extracts named entities and keywords using pattern matching.
    """
    
    QUAD = 'EXTR'
    NAME = 'Extract'
    DESCRIPTION = 'Entity and keyword extraction with pattern matching'
    CATEGORY = 'text'
    FIB_INDEX = 4
    MODALITIES = ['text', 'language', 'structured']
    ALPHA_ENGINES = ['ALPHA-002 LINGUA', 'ALPHA-001 ANIMUS']
    
    # Entity patterns
    PATTERNS = {
        'email': r'\b[\w.-]+@[\w.-]+\.\w+\b',
        'url': r'https?://[\w./\-?=&]+',
        'number': r'\b\d+\.?\d*\b',
        'date': r'\b\d{1,2}[/-]\d{1,2}[/-]\d{2,4}\b',
        'capitalized': r'\b[A-Z][a-z]+\b',
    }
    
    def _run(self, text: str, **kwargs) -> Dict:
        """
        Extract entities and keywords from text.
        
        Args:
            text: Input text
        
        Returns:
            Dict with extracted entities and keywords
        """
        entities = {}
        
        # Extract by pattern
        for entity_type, pattern in self.PATTERNS.items():
            matches = re.findall(pattern, text)
            if matches:
                entities[entity_type] = list(set(matches))
        
        # Extract keywords (most frequent non-stopwords)
        stopwords = {'the', 'a', 'an', 'is', 'are', 'was', 'were', 'be', 'been',
                     'being', 'have', 'has', 'had', 'do', 'does', 'did', 'will',
                     'would', 'could', 'should', 'may', 'might', 'must', 'shall',
                     'can', 'need', 'dare', 'ought', 'used', 'to', 'of', 'in',
                     'for', 'on', 'with', 'at', 'by', 'from', 'as', 'into',
                     'through', 'during', 'before', 'after', 'above', 'below',
                     'between', 'under', 'again', 'further', 'then', 'once',
                     'and', 'but', 'or', 'nor', 'so', 'yet', 'both', 'either',
                     'neither', 'not', 'only', 'own', 'same', 'than', 'too',
                     'very', 'just', 'also', 'now', 'here', 'there', 'when',
                     'where', 'why', 'how', 'all', 'each', 'every', 'both',
                     'few', 'more', 'most', 'other', 'some', 'such', 'no',
                     'any', 'this', 'that', 'these', 'those', 'it', 'its'}
        
        words = re.findall(r'\b[a-z]+\b', text.lower())
        word_freq = Counter(w for w in words if w not in stopwords and len(w) > 2)
        
        # Top keywords weighted by φ
        n_keywords = max(5, int(len(word_freq) * PHI_INV))
        keywords = [word for word, _ in word_freq.most_common(n_keywords)]
        
        total_entities = sum(len(v) for v in entities.values())
        
        return {
            'entities': entities,
            'keywords': keywords,
            'entity_count': total_entities,
            'keyword_count': len(keywords),
            'unique_words': len(word_freq),
            'confidence': round(min(total_entities / 10, 1.0), 4),
            'completeness': round(min(len(keywords) / 10, 1.0), 4),
        }


# ─── Quick Access Functions ──────────────────────────────────────────────────
_summarize_tool = None
_translate_tool = None
_sentiment_tool = None
_extract_tool = None

def summarize(text: str, ratio: float = 0.3) -> Dict:
    """Quick access to summarization."""
    global _summarize_tool
    if _summarize_tool is None:
        _summarize_tool = SummarizeTool()
    return _summarize_tool.execute(text, ratio=ratio)

def translate(text: str, source: str = 'en', target: str = 'es') -> Dict:
    """Quick access to translation."""
    global _translate_tool
    if _translate_tool is None:
        _translate_tool = TranslateTool()
    return _translate_tool.execute(text, source=source, target=target)

def sentiment(text: str) -> Dict:
    """Quick access to sentiment analysis."""
    global _sentiment_tool
    if _sentiment_tool is None:
        _sentiment_tool = SentimentTool()
    return _sentiment_tool.execute(text)

def extract(text: str) -> Dict:
    """Quick access to entity extraction."""
    global _extract_tool
    if _extract_tool is None:
        _extract_tool = ExtractTool()
    return _extract_tool.execute(text)


# ─── Self-Test ───────────────────────────────────────────────────────────────
if __name__ == '__main__':
    print("╔════════════════════════════════════════════════════════════════╗")
    print("║              Text Tools — Self-Test                            ║")
    print("║              Nova by FreddyCreates                             ║")
    print("╚════════════════════════════════════════════════════════════════╝")
    print()
    
    test_text = """
    The golden ratio, approximately 1.618, appears throughout nature and art.
    It governs the spiral patterns in shells and the arrangement of leaves.
    This beautiful mathematical constant creates harmony and balance.
    Artists and architects have used it for centuries to create pleasing proportions.
    """
    
    print("─── SUMMARIZE ───")
    result = summarize(test_text)
    print(f"Summary: {result['summary'][:100]}...")
    print(f"Compression: {result['compression_ratio']}")
    print()
    
    print("─── TRANSLATE ───")
    result = translate("hello world the golden ratio", target='es')
    print(f"Translation: {result['translation']}")
    print(f"Coverage: {result['coverage']}")
    print()
    
    print("─── SENTIMENT ───")
    result = sentiment("This is a beautiful and wonderful golden harmony!")
    print(f"Sentiment: {result['sentiment']}")
    print(f"Score: {result['score']}")
    print()
    
    print("─── EXTRACT ───")
    result = extract(test_text)
    print(f"Keywords: {result['keywords'][:5]}")
    print(f"Entities: {result['entity_count']}")
    print()
    
    print("✓ Text tools ready.")
