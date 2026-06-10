/**
 * CHIMERIA Voice — Phoneme Engine
 *
 * Native phoneme-to-audio synthesis using formant modeling.
 * No external TTS dependencies. Pure computational voice generation.
 *
 * Approach: Formant synthesis — models the human vocal tract as a series
 * of resonant filters (formants F1–F4) applied to a source excitation
 * (glottal pulse for voiced, noise for unvoiced).
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

/**
 * IPA phoneme → formant frequency table (Hz)
 * Each entry: [F1, F2, F3, bandwidth1, bandwidth2, bandwidth3, duration_factor, voiced]
 */
export const PHONEME_TABLE = {
  // Vowels (all voiced)
  'i':  [270, 2290, 3010, 60, 90, 150, 1.0, true],   // "ee" in "see"
  'ɪ':  [390, 1990, 2550, 60, 100, 150, 0.8, true],   // "i" in "sit"
  'e':  [530, 1840, 2480, 70, 100, 150, 1.0, true],   // "e" in "bed"
  'æ':  [660, 1720, 2410, 80, 100, 150, 1.0, true],   // "a" in "cat"
  'ɑ':  [730, 1090, 2440, 90, 100, 150, 1.0, true],   // "a" in "father"
  'ɔ':  [570, 840, 2410, 80, 90, 150, 1.0, true],    // "o" in "thought"
  'o':  [490, 830, 2440, 70, 80, 150, 1.0, true],    // "o" in "go"
  'ʊ':  [440, 1020, 2240, 70, 80, 150, 0.8, true],   // "u" in "put"
  'u':  [300, 870, 2240, 60, 80, 150, 1.0, true],    // "oo" in "food"
  'ʌ':  [640, 1190, 2390, 80, 100, 150, 0.8, true],   // "u" in "but"
  'ə':  [500, 1500, 2500, 80, 100, 150, 0.6, true],   // schwa "a" in "about"
  'ɛ':  [530, 1840, 2480, 70, 100, 150, 0.9, true],   // "e" in "get"

  // Diphthongs (treated as transitions)
  'aɪ': [730, 1090, 2440, 80, 100, 150, 1.4, true],   // "i" in "my"
  'aʊ': [730, 1090, 2440, 80, 100, 150, 1.4, true],   // "ou" in "how"
  'eɪ': [530, 1840, 2480, 70, 100, 150, 1.3, true],   // "a" in "say"
  'oʊ': [490, 830, 2440, 70, 80, 150, 1.3, true],    // "o" in "go"
  'ɔɪ': [570, 840, 2410, 80, 90, 150, 1.4, true],    // "oi" in "boy"

  // Consonants — Stops
  'p':  [200, 800, 2000, 200, 200, 200, 0.4, false],  // voiceless bilabial
  'b':  [200, 800, 2000, 200, 200, 200, 0.4, true],   // voiced bilabial
  't':  [400, 1600, 2600, 200, 200, 200, 0.3, false],  // voiceless alveolar
  'd':  [400, 1600, 2600, 200, 200, 200, 0.3, true],   // voiced alveolar
  'k':  [300, 1300, 2400, 200, 200, 200, 0.4, false],  // voiceless velar
  'g':  [300, 1300, 2400, 200, 200, 200, 0.4, true],   // voiced velar

  // Consonants — Fricatives
  'f':  [300, 1000, 2400, 400, 400, 400, 0.5, false],  // voiceless labiodental
  'v':  [300, 1000, 2400, 400, 400, 400, 0.5, true],   // voiced labiodental
  'θ':  [400, 1600, 2600, 500, 400, 400, 0.5, false],  // voiceless dental "th"
  'ð':  [400, 1600, 2600, 500, 400, 400, 0.5, true],   // voiced dental "th"
  's':  [400, 1800, 4500, 200, 300, 300, 0.5, false],  // voiceless alveolar
  'z':  [400, 1800, 4500, 200, 300, 300, 0.5, true],   // voiced alveolar
  'ʃ':  [300, 1600, 3200, 300, 400, 400, 0.5, false],  // "sh"
  'ʒ':  [300, 1600, 3200, 300, 400, 400, 0.5, true],   // "zh" in "measure"
  'h':  [500, 1500, 2500, 500, 500, 500, 0.3, false],  // voiceless glottal

  // Consonants — Nasals (voiced)
  'm':  [300, 1000, 2200, 80, 100, 150, 0.6, true],
  'n':  [400, 1500, 2500, 80, 100, 150, 0.5, true],
  'ŋ':  [300, 1300, 2400, 80, 100, 150, 0.5, true],   // "ng"

  // Consonants — Liquids & Glides (voiced)
  'l':  [400, 1000, 2400, 80, 100, 150, 0.5, true],
  'r':  [420, 1300, 1600, 80, 100, 150, 0.5, true],
  'w':  [300, 870, 2240, 60, 80, 150, 0.4, true],
  'j':  [270, 2290, 3010, 60, 90, 150, 0.4, true],    // "y" sound

  // Affricates
  'tʃ': [400, 1800, 3200, 300, 300, 300, 0.5, false],  // "ch"
  'dʒ': [400, 1800, 3200, 300, 300, 300, 0.5, true],   // "j" in "judge"

  // Silence / pause
  '_':  [0, 0, 0, 0, 0, 0, 0.3, false],
};

/**
 * English grapheme-to-phoneme rules (simplified rule-based G2P)
 * Production systems use trained models; this is a rule-based fallback.
 */
const G2P_RULES = {
  // Common word endings
  'tion': ['ʃ', 'ə', 'n'],
  'sion': ['ʒ', 'ə', 'n'],
  'ight': ['aɪ', 't'],
  'ough': ['ʌ', 'f'],
  'ould': ['ʊ', 'd'],
  'ment': ['m', 'ɛ', 'n', 't'],
  'ness': ['n', 'ɛ', 's'],
  'able': ['eɪ', 'b', 'ə', 'l'],
  'ible': ['ɪ', 'b', 'ə', 'l'],
  'ing':  ['ɪ', 'ŋ'],
  'ck':   ['k'],
  'th':   ['θ'],
  'sh':   ['ʃ'],
  'ch':   ['tʃ'],
  'ph':   ['f'],
  'wh':   ['w'],
  'ng':   ['ŋ'],
  'qu':   ['k', 'w'],
  'oo':   ['u'],
  'ee':   ['i'],
  'ea':   ['i'],
  'ou':   ['aʊ'],
  'ow':   ['oʊ'],
  'ai':   ['eɪ'],
  'ay':   ['eɪ'],
  'oi':   ['ɔɪ'],
  'oy':   ['ɔɪ'],
};

/**
 * Single-letter fallback mapping
 */
const LETTER_PHONEMES = {
  'a': 'æ', 'b': 'b', 'c': 'k', 'd': 'd', 'e': 'ɛ',
  'f': 'f', 'g': 'g', 'h': 'h', 'i': 'ɪ', 'j': 'dʒ',
  'k': 'k', 'l': 'l', 'm': 'm', 'n': 'n', 'o': 'ɑ',
  'p': 'p', 'q': 'k', 'r': 'r', 's': 's', 't': 't',
  'u': 'ʌ', 'v': 'v', 'w': 'w', 'x': 'k', 'y': 'j',
  'z': 'z',
};

/**
 * Convert text to phoneme sequence
 * @param {string} text
 * @returns {string[]} Array of IPA phoneme symbols
 */
export function textToPhonemes(text) {
  const words = text.toLowerCase().replace(/[^a-z\s']/g, '').split(/\s+/);
  const phonemes = [];

  for (let wi = 0; wi < words.length; wi++) {
    const word = words[wi];
    if (!word) continue;

    let i = 0;
    while (i < word.length) {
      let matched = false;

      // Try multi-character rules (longest first)
      for (let len = 5; len >= 2; len--) {
        const chunk = word.slice(i, i + len);
        if (G2P_RULES[chunk]) {
          phonemes.push(...G2P_RULES[chunk]);
          i += len;
          matched = true;
          break;
        }
      }

      if (!matched) {
        const ch = word[i];
        if (LETTER_PHONEMES[ch]) {
          phonemes.push(LETTER_PHONEMES[ch]);
        }
        i++;
      }
    }

    // Word boundary pause
    if (wi < words.length - 1) {
      phonemes.push('_');
    }
  }

  return phonemes;
}

/**
 * Get formant parameters for a phoneme
 * @param {string} phoneme
 * @returns {Object|null}
 */
export function getFormants(phoneme) {
  const entry = PHONEME_TABLE[phoneme];
  if (!entry) return null;

  return {
    f1: entry[0],
    f2: entry[1],
    f3: entry[2],
    bw1: entry[3],
    bw2: entry[4],
    bw3: entry[5],
    durationFactor: entry[6],
    voiced: entry[7],
  };
}
