/**
 * CHIMERIA Voice — Entry Point
 *
 * Native voice synthesis engine. No external TTS providers.
 * Formant-based speech synthesis built from scratch.
 *
 * Usage:
 *   import { VoiceEngine, VOICE_PRESETS } from './voice/index.js';
 *
 *   const voice = new VoiceEngine({ voice: 'chimeria-default' });
 *   const { samples, sampleRate, durationMs } = voice.synthesize('Hello world');
 *   const wavBytes = voice.synthesizeToWav('Hello world');
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

export { VoiceEngine } from './engine.js';
export { ProsodyController, VOICE_PRESETS } from './prosody.js';
export { textToPhonemes, getFormants, PHONEME_TABLE } from './phonemes.js';
