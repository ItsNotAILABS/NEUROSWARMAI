/**
 * CHIMERIA Voice — Native Formant Synthesis Engine
 *
 * Pure-JS voice synthesis using formant-based vocal tract modeling.
 * Zero external TTS dependencies. Generates PCM audio from text.
 *
 * Architecture:
 *   Text → G2P (phonemes) → Prosody annotation → Formant synthesis → PCM output
 *
 * Synthesis method: Source-filter model
 *   Source:  Glottal pulse train (voiced) or white noise (unvoiced)
 *   Filter:  Cascade of 2nd-order resonators modeling formants F1–F3
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

import { textToPhonemes, getFormants } from './phonemes.js';
import { ProsodyController } from './prosody.js';

const TWO_PI = 2 * Math.PI;

/**
 * 2nd-order resonator (biquad bandpass) for formant modeling
 */
class FormantFilter {
  constructor(sampleRate) {
    this.sampleRate = sampleRate;
    this.x1 = 0; this.x2 = 0;
    this.y1 = 0; this.y2 = 0;
    this.b0 = 0; this.b1 = 0; this.b2 = 0;
    this.a1 = 0; this.a2 = 0;
  }

  /**
   * Set formant frequency and bandwidth
   */
  setParams(frequency, bandwidth) {
    if (frequency <= 0) {
      this.b0 = 0; this.b1 = 0; this.b2 = 0;
      this.a1 = 0; this.a2 = 0;
      return;
    }

    const w0 = TWO_PI * frequency / this.sampleRate;
    const bw = TWO_PI * bandwidth / this.sampleRate;
    const r = Math.exp(-bw / 2);
    const cosW0 = Math.cos(w0);

    // Resonator coefficients
    this.a1 = -2 * r * cosW0;
    this.a2 = r * r;
    this.b0 = 1 - r;
    this.b1 = 0;
    this.b2 = -r * (1 - r);
  }

  /**
   * Process one sample
   */
  process(input) {
    const output = this.b0 * input + this.b1 * this.x1 + this.b2 * this.x2
                   - this.a1 * this.y1 - this.a2 * this.y2;
    this.x2 = this.x1;
    this.x1 = input;
    this.y2 = this.y1;
    this.y1 = output;
    return output;
  }

  reset() {
    this.x1 = this.x2 = this.y1 = this.y2 = 0;
  }
}

/**
 * Glottal source — generates the excitation signal
 */
class GlottalSource {
  constructor(sampleRate) {
    this.sampleRate = sampleRate;
    this.phase = 0;
    this.period = 0;
  }

  /**
   * Generate one sample of glottal pulse (Rosenberg pulse model)
   */
  voiced(f0) {
    if (f0 <= 0) return 0;

    this.period = this.sampleRate / f0;
    this.phase++;

    const t = (this.phase % Math.floor(this.period)) / this.period;

    // Rosenberg glottal waveform: open phase 40%, closing phase 16%
    if (t < 0.4) {
      return 3 * (t / 0.4) ** 2 - 2 * (t / 0.4) ** 3;
    } else if (t < 0.56) {
      const tc = (t - 0.4) / 0.16;
      return 1 - tc * tc;
    }
    return 0;
  }

  /**
   * Generate noise for unvoiced consonants
   */
  noise() {
    return Math.random() * 2 - 1;
  }
}

/**
 * CHIMERIA Voice Synthesis Engine
 */
export class VoiceEngine {
  constructor(config = {}) {
    this.sampleRate = config.sampleRate || 22050;
    this.baseDurationMs = config.baseDurationMs || 80; // Base phoneme duration

    // Synthesis components
    this.source = new GlottalSource(this.sampleRate);
    this.formants = [
      new FormantFilter(this.sampleRate),
      new FormantFilter(this.sampleRate),
      new FormantFilter(this.sampleRate),
    ];

    // Prosody
    this.prosodyController = new ProsodyController(config.voice || 'chimeria-default');

    // Output buffer
    this.outputBuffer = null;
  }

  /**
   * Synthesize text to Float32Array PCM audio
   * @param {string} text - Input text
   * @param {Object} [options]
   * @returns {{ samples: Float32Array, sampleRate: number, durationMs: number }}
   */
  synthesize(text, options = {}) {
    if (!text || !text.trim()) {
      return { samples: new Float32Array(0), sampleRate: this.sampleRate, durationMs: 0 };
    }

    // Text → Phonemes
    const phonemes = textToPhonemes(text);
    if (phonemes.length === 0) {
      return { samples: new Float32Array(0), sampleRate: this.sampleRate, durationMs: 0 };
    }

    // Annotate with prosody
    const annotated = this.prosodyController.annotate(phonemes, text);

    // Calculate total sample count
    let totalSamples = 0;
    const segments = annotated.map(segment => {
      const formants = getFormants(segment.phoneme);
      const durationFactor = formants ? formants.durationFactor : 0.5;
      const rateFactor = segment.prosody.rate || 1.0;
      const durationMs = (this.baseDurationMs * durationFactor) / rateFactor;
      const sampleCount = Math.ceil((durationMs / 1000) * this.sampleRate);
      totalSamples += sampleCount;
      return { ...segment, formants, sampleCount, durationMs };
    });

    // Synthesize
    const output = new Float32Array(totalSamples);
    let writePos = 0;

    for (let si = 0; si < segments.length; si++) {
      const seg = segments[si];
      const { formants: fData, sampleCount, prosody } = seg;

      // Set formant filters
      if (fData) {
        this.formants[0].setParams(fData.f1, fData.bw1);
        this.formants[1].setParams(fData.f2, fData.bw2);
        this.formants[2].setParams(fData.f3, fData.bw3);
      } else {
        this.formants.forEach(f => f.setParams(0, 0));
      }

      // Generate segment samples
      for (let i = 0; i < sampleCount && writePos < totalSamples; i++) {
        // Excitation source
        let excitation;
        if (fData && fData.voiced) {
          // Add slight aspiration noise for naturalness
          excitation = this.source.voiced(prosody.pitchHz) * 0.85
                     + this.source.noise() * prosody.breathiness;
        } else {
          excitation = this.source.noise() * 0.7;
        }

        // Apply formant cascade (parallel formant synthesis)
        let sample = 0;
        sample += this.formants[0].process(excitation) * 1.0;
        sample += this.formants[1].process(excitation) * 0.7;
        sample += this.formants[2].process(excitation) * 0.4;

        // Apply volume and emphasis
        sample *= prosody.volume * (0.7 + prosody.emphasis * 0.3);

        // Soft clip to prevent distortion
        sample = Math.tanh(sample * 1.5);

        // Crossfade at segment boundaries (5ms)
        const fadeSamples = Math.floor(0.005 * this.sampleRate);
        if (i < fadeSamples) {
          sample *= i / fadeSamples;
        } else if (i > sampleCount - fadeSamples) {
          sample *= (sampleCount - i) / fadeSamples;
        }

        output[writePos++] = sample;
      }
    }

    const durationMs = (totalSamples / this.sampleRate) * 1000;
    return { samples: output.subarray(0, writePos), sampleRate: this.sampleRate, durationMs };
  }

  /**
   * Synthesize to WAV file bytes
   * @param {string} text
   * @returns {Uint8Array} WAV file data
   */
  synthesizeToWav(text, options = {}) {
    const { samples, sampleRate } = this.synthesize(text, options);
    return encodeWav(samples, sampleRate);
  }

  /**
   * Get engine info
   */
  getInfo() {
    return {
      engine: 'CHIMERIA Native Voice',
      version: '1.0.0',
      method: 'Formant synthesis (source-filter model)',
      sampleRate: this.sampleRate,
      features: [
        'Grapheme-to-phoneme conversion',
        'Formant-based vocal tract modeling',
        'Rosenberg glottal pulse source',
        'Prosody control (pitch/rate/emphasis)',
        'Multiple voice presets',
        'Zero external dependencies',
      ],
    };
  }
}

/**
 * Encode Float32 samples to WAV format
 */
function encodeWav(samples, sampleRate) {
  const numChannels = 1;
  const bitsPerSample = 16;
  const bytesPerSample = bitsPerSample / 8;
  const dataLength = samples.length * bytesPerSample;
  const buffer = new ArrayBuffer(44 + dataLength);
  const view = new DataView(buffer);

  // RIFF header
  writeString(view, 0, 'RIFF');
  view.setUint32(4, 36 + dataLength, true);
  writeString(view, 8, 'WAVE');

  // fmt chunk
  writeString(view, 12, 'fmt ');
  view.setUint32(16, 16, true);           // chunk size
  view.setUint16(20, 1, true);            // PCM format
  view.setUint16(22, numChannels, true);
  view.setUint32(24, sampleRate, true);
  view.setUint32(28, sampleRate * numChannels * bytesPerSample, true);
  view.setUint16(32, numChannels * bytesPerSample, true);
  view.setUint16(34, bitsPerSample, true);

  // data chunk
  writeString(view, 36, 'data');
  view.setUint32(40, dataLength, true);

  // PCM samples (Float32 → Int16)
  let offset = 44;
  for (let i = 0; i < samples.length; i++) {
    const s = Math.max(-1, Math.min(1, samples[i]));
    view.setInt16(offset, s * 0x7FFF, true);
    offset += 2;
  }

  return new Uint8Array(buffer);
}

function writeString(view, offset, str) {
  for (let i = 0; i < str.length; i++) {
    view.setUint8(offset + i, str.charCodeAt(i));
  }
}
