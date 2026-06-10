/**
 * CHIMERIA Voice — Prosody Controller
 *
 * Controls pitch contour, timing, emphasis, and intonation.
 * Takes a phoneme sequence and annotates it with prosodic features
 * based on punctuation, sentence structure, and CHIMERIA organism state.
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI = 1.618033988749895;

/**
 * @typedef {Object} ProsodyParams
 * @property {number} pitchHz       - Base pitch in Hz
 * @property {number} pitchContour  - Pitch modifier for this segment (-1 to 1)
 * @property {number} rate          - Speaking rate multiplier
 * @property {number} volume        - Volume 0.0 to 1.0
 * @property {number} emphasis      - Emphasis weight 0.0 to 1.0
 * @property {number} breathiness   - Breathiness 0.0 to 1.0
 */

/**
 * Voice presets
 */
export const VOICE_PRESETS = {
  'chimeria-default': {
    pitchHz: 165,
    rate: 1.0,
    volume: 0.85,
    breathiness: 0.12,
    warmth: 0.6,
    description: 'Neutral, clear, authoritative',
  },
  'chimeria-warm': {
    pitchHz: 145,
    rate: 0.92,
    volume: 0.8,
    breathiness: 0.2,
    warmth: 0.85,
    description: 'Warm, measured, reassuring',
  },
  'chimeria-sharp': {
    pitchHz: 180,
    rate: 1.15,
    volume: 0.9,
    breathiness: 0.05,
    warmth: 0.3,
    description: 'Precise, fast, technical',
  },
  'chimeria-deep': {
    pitchHz: 95,
    rate: 0.88,
    volume: 0.9,
    breathiness: 0.08,
    warmth: 0.5,
    description: 'Deep, resonant, commanding',
  },
};

/**
 * Prosody controller — shapes pitch/timing/emphasis from text structure
 */
export class ProsodyController {
  constructor(voicePreset = 'chimeria-default') {
    const preset = VOICE_PRESETS[voicePreset] || VOICE_PRESETS['chimeria-default'];
    this.basePitchHz = preset.pitchHz;
    this.baseRate = preset.rate;
    this.baseVolume = preset.volume;
    this.breathiness = preset.breathiness;
    this.warmth = preset.warmth;
  }

  /**
   * Annotate a phoneme sequence with prosodic features based on text
   * @param {string[]} phonemes - IPA phoneme sequence
   * @param {string} originalText - Original text for punctuation analysis
   * @returns {Array<{phoneme: string, prosody: ProsodyParams}>}
   */
  annotate(phonemes, originalText) {
    const sentences = this.parseSentences(originalText);
    const totalPhonemes = phonemes.length;
    const annotated = [];

    let sentenceIdx = 0;
    let posInSentence = 0;
    let sentenceLength = sentences[0]?.phonemeCount || totalPhonemes;

    for (let i = 0; i < phonemes.length; i++) {
      const phoneme = phonemes[i];
      const progress = totalPhonemes > 1 ? i / (totalPhonemes - 1) : 0;
      const sentenceProgress = sentenceLength > 1 ? posInSentence / (sentenceLength - 1) : 0;

      const sentence = sentences[sentenceIdx] || { type: 'statement' };

      // Compute pitch contour
      const pitchContour = this.computePitchContour(sentenceProgress, sentence.type);

      // Compute timing
      const rate = this.computeRate(sentenceProgress, sentence.type);

      // Emphasis from sentence stress patterns
      const emphasis = this.computeEmphasis(i, phonemes, sentence);

      annotated.push({
        phoneme,
        prosody: {
          pitchHz: this.basePitchHz * (1 + pitchContour * 0.3),
          pitchContour,
          rate: this.baseRate * rate,
          volume: this.baseVolume * (0.85 + emphasis * 0.15),
          emphasis,
          breathiness: this.breathiness,
        },
      });

      posInSentence++;
      if (phoneme === '_' && posInSentence > sentenceLength * 0.8) {
        sentenceIdx++;
        posInSentence = 0;
        sentenceLength = sentences[sentenceIdx]?.phonemeCount || (totalPhonemes - i);
      }
    }

    return annotated;
  }

  /**
   * Compute pitch contour position
   * Statements: rise then fall. Questions: rise at end. Exclamations: high start, drop.
   */
  computePitchContour(progress, sentenceType) {
    switch (sentenceType) {
      case 'question':
        // Rising intonation toward end
        return -0.1 + progress * 0.5;

      case 'exclamation':
        // High start, gradual descent
        return 0.4 * (1 - progress);

      case 'statement':
      default:
        // Gentle arch: rise to ~40%, then fall
        if (progress < 0.4) {
          return progress * 0.3 / 0.4;
        } else {
          return 0.3 * (1 - (progress - 0.4) / 0.6) - 0.1 * ((progress - 0.4) / 0.6);
        }
    }
  }

  /**
   * Compute speaking rate variation
   */
  computeRate(progress, sentenceType) {
    // Slight acceleration in middle, deceleration at end (natural phrasing)
    if (progress < 0.15) return 0.9;   // Slow start
    if (progress > 0.85) return 0.85;  // Slow ending
    return 1.0 + Math.sin(progress * Math.PI) * 0.08;
  }

  /**
   * Compute emphasis for stress patterns
   */
  computeEmphasis(index, phonemes, sentence) {
    // Content words get more emphasis; function words less
    // Approximate: voiced phonemes after a pause get emphasis
    if (index === 0) return 0.7;
    if (phonemes[index - 1] === '_') return 0.8;  // Word-initial after pause
    return 0.4 + Math.random() * 0.2; // Slight natural variation
  }

  /**
   * Parse text into sentence structures for prosody
   */
  parseSentences(text) {
    const parts = text.split(/([.!?]+\s*)/);
    const sentences = [];
    let phonemeEstimate = 0;

    for (let i = 0; i < parts.length; i += 2) {
      const content = parts[i] || '';
      const punct = (parts[i + 1] || '').trim();

      let type = 'statement';
      if (punct.includes('?')) type = 'question';
      else if (punct.includes('!')) type = 'exclamation';

      // Rough phoneme count estimate: ~3 phonemes per word
      const wordCount = content.split(/\s+/).filter(Boolean).length;
      const phonemeCount = wordCount * 3 + wordCount; // +pauses

      sentences.push({ type, phonemeCount, wordCount });
      phonemeEstimate += phonemeCount;
    }

    return sentences;
  }
}
