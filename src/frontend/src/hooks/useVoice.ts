// ═══════════════════════════════════════════════════════════════════════════
// useVoice — Web Speech API hook for AUTO voice layer
//
// INPUT:  SpeechRecognition  (push-to-talk, browser STT, zero cost)
// OUTPUT: SpeechSynthesis    (browser TTS, params shaped by organism state)
//
// Voice shaping rules:
//   driveMode   → base rate & pitch
//   arousal     → modulates both (> 800 = emergency: clipped, fast)
//   coherence   → high coherence = more measured cadence
//   qsov.overall → volume (sovereign = louder)
// ═══════════════════════════════════════════════════════════════════════════

import { useCallback, useEffect, useRef, useState } from "react";
import type { OrganismContextSnapshot } from "../data/autoEngine";

// ── Ambient declarations for Web Speech API (not fully typed in lib.dom.d.ts) ─

interface SpeechRecognitionResultItem {
  readonly transcript: string;
  readonly confidence: number;
}

interface SpeechRecognitionResult {
  readonly isFinal: boolean;
  readonly length: number;
  item(index: number): SpeechRecognitionResultItem;
  [index: number]: SpeechRecognitionResultItem;
}

interface SpeechRecognitionResultList {
  readonly length: number;
  item(index: number): SpeechRecognitionResult;
  [index: number]: SpeechRecognitionResult;
}

interface SpeechRecognitionEvent extends Event {
  readonly resultIndex: number;
  readonly results: SpeechRecognitionResultList;
}

interface SpeechRecognitionErrorEvent extends Event {
  readonly error: string;
  readonly message: string;
}

interface ISpeechRecognition extends EventTarget {
  continuous: boolean;
  interimResults: boolean;
  lang: string;
  maxAlternatives: number;
  onresult: ((event: SpeechRecognitionEvent) => void) | null;
  onerror: ((event: SpeechRecognitionErrorEvent) => void) | null;
  onend: (() => void) | null;
  start(): void;
  stop(): void;
  abort(): void;
}

// ── Types ─────────────────────────────────────────────────────────────────────

export interface VoiceState {
  /** True while the mic is open and listening */
  isMicActive: boolean;
  /** True while speech synthesis is playing */
  isSpeaking: boolean;
  /** Transcript received from STT (interim or final) */
  transcript: string;
  /** Whether voice output (TTS) is enabled */
  voiceOutputEnabled: boolean;
  /** Whether STT is supported in this browser */
  sttSupported: boolean;
  /** Whether TTS is supported in this browser */
  ttsSupported: boolean;
  /** Last error message, if any */
  error: string | null;
}

export interface VoiceActions {
  /** Start listening (push-to-talk: call on mousedown / touchstart) */
  startListening: () => void;
  /** Stop listening and commit the transcript */
  stopListening: () => void;
  /** Speak text, shaping voice params from the organism context snapshot */
  speak: (text: string, ctx: OrganismContextSnapshot | null) => void;
  /** Cancel any in-progress speech */
  cancelSpeech: () => void;
  /** Toggle voice output on/off */
  toggleVoiceOutput: () => void;
  /** Clear the last error message */
  clearError: () => void;
}

// ── Voice shaping from substrate ──────────────────────────────────────────────

function computeVoiceParams(ctx: OrganismContextSnapshot | null): {
  rate: number;
  pitch: number;
  volume: number;
} {
  if (!ctx) return { rate: 1.0, pitch: 1.0, volume: 1.0 };

  // ── 1. Base from drive mode ─────────────────────────────────────────────────
  let rate = 1.0;
  let pitch = 1.0;

  switch (ctx.driveMode) {
    case "Execution":
      rate = 1.1;
      pitch = 1.0;
      break;
    case "Exploration":
      rate = 0.88;
      pitch = 1.1;
      break;
    case "Rest":
      rate = 0.72;
      pitch = 0.88;
      break;
    case "Learning":
      rate = 0.92;
      pitch = 1.05;
      break;
  }

  // ── 2. Emergency override (arousal > 800) ──────────────────────────────────
  if (ctx.arousal > 800) {
    rate = 1.35;
    pitch = 1.22;
  } else {
    // ── 3. Arousal modulation [0, 1000] → [−0.5, 0.5] scalar ─────────────────
    const arousalNorm = ctx.arousal / 1000; // 0–1
    const arousalDelta = arousalNorm - 0.5; // −0.5 → 0.5
    rate += arousalDelta * 0.28;
    pitch += arousalDelta * 0.14;
  }

  // ── 4. Coherence: high coherence = more measured (slower, calmer) ──────────
  //   coherence [0, 1]. Pull rate toward measured: 1.0 at coherence=1
  rate = rate * (0.88 + ctx.coherence * 0.24);

  // ── 5. QSOV overall → volume ───────────────────────────────────────────────
  //   overall [0, 1] → volume [0.7, 1.0]
  const volume = 0.72 + ctx.qsov.overall * 0.28;

  // ── 6. Clamp ───────────────────────────────────────────────────────────────
  return {
    rate: Math.min(1.6, Math.max(0.5, rate)),
    pitch: Math.min(1.5, Math.max(0.5, pitch)),
    volume: Math.min(1.0, Math.max(0.6, volume)),
  };
}

// ── Hook ──────────────────────────────────────────────────────────────────────

export function useVoice(
  onTranscriptCommit: (text: string) => void,
): [VoiceState, VoiceActions] {
  const recognitionRef = useRef<ISpeechRecognition | null>(null);
  const synthRef = useRef<SpeechSynthesis | null>(null);
  const interimRef = useRef<string>("");

  const sttSupported =
    typeof window !== "undefined" &&
    ("SpeechRecognition" in window || "webkitSpeechRecognition" in window);
  const ttsSupported =
    typeof window !== "undefined" && "speechSynthesis" in window;

  const [voiceState, setVoiceState] = useState<VoiceState>({
    isMicActive: false,
    isSpeaking: false,
    transcript: "",
    voiceOutputEnabled: false,
    sttSupported,
    ttsSupported,
    error: null,
  });

  // ── Initialise SpeechSynthesis ref ─────────────────────────────────────────
  useEffect(() => {
    if (ttsSupported) {
      synthRef.current = window.speechSynthesis;
    }
    return () => {
      synthRef.current?.cancel();
      recognitionRef.current?.abort();
    };
  }, [ttsSupported]);

  // ── startListening ─────────────────────────────────────────────────────────
  const startListening = useCallback(() => {
    if (!sttSupported) {
      setVoiceState((p) => ({
        ...p,
        error: "SpeechRecognition not supported in this browser.",
      }));
      return;
    }
    if (recognitionRef.current) {
      recognitionRef.current.abort();
      recognitionRef.current = null;
    }

    // Cancel any in-progress TTS so mic picks up cleanly
    synthRef.current?.cancel();
    setVoiceState((p) => ({ ...p, isSpeaking: false }));

    const SpeechRecognitionCtor =
      (window as any).SpeechRecognition ??
      (window as any).webkitSpeechRecognition;

    const rec: ISpeechRecognition = new SpeechRecognitionCtor();
    rec.continuous = true;
    rec.interimResults = true;
    rec.lang = "en-US";
    rec.maxAlternatives = 1;

    rec.onresult = (event: SpeechRecognitionEvent) => {
      let interim = "";
      let final = "";
      for (let i = event.resultIndex; i < event.results.length; i++) {
        const t = event.results[i][0].transcript;
        if (event.results[i].isFinal) {
          final += t;
        } else {
          interim += t;
        }
      }
      if (final) {
        interimRef.current += final;
      }
      setVoiceState((p) => ({
        ...p,
        transcript: interimRef.current + interim,
        error: null,
      }));
    };

    rec.onerror = (event: SpeechRecognitionErrorEvent) => {
      const msg =
        event.error === "not-allowed"
          ? "Mic permission denied. Allow microphone access and try again."
          : `STT error: ${event.error}`;
      setVoiceState((p) => ({ ...p, isMicActive: false, error: msg }));
    };

    rec.onend = () => {
      setVoiceState((p) => ({ ...p, isMicActive: false }));
    };

    interimRef.current = "";
    recognitionRef.current = rec;
    rec.start();
    setVoiceState((p) => ({
      ...p,
      isMicActive: true,
      transcript: "",
      error: null,
    }));
  }, [sttSupported]);

  // ── stopListening ──────────────────────────────────────────────────────────
  const stopListening = useCallback(() => {
    recognitionRef.current?.stop();
    recognitionRef.current = null;
    setVoiceState((p) => ({ ...p, isMicActive: false }));

    // Commit whatever we captured
    const committed = interimRef.current.trim();
    interimRef.current = "";
    if (committed) {
      setVoiceState((p) => ({ ...p, transcript: "" }));
      onTranscriptCommit(committed);
    }
  }, [onTranscriptCommit]);

  // ── speak ──────────────────────────────────────────────────────────────────
  const speak = useCallback(
    (text: string, ctx: OrganismContextSnapshot | null) => {
      if (!ttsSupported || !synthRef.current) return;

      synthRef.current.cancel();

      const { rate, pitch, volume } = computeVoiceParams(ctx);

      const utt = new SpeechSynthesisUtterance(text);
      utt.rate = rate;
      utt.pitch = pitch;
      utt.volume = volume;
      utt.lang = "en-US";

      utt.onstart = () => setVoiceState((p) => ({ ...p, isSpeaking: true }));
      utt.onend = () => setVoiceState((p) => ({ ...p, isSpeaking: false }));
      utt.onerror = () => setVoiceState((p) => ({ ...p, isSpeaking: false }));

      synthRef.current.speak(utt);
    },
    [ttsSupported],
  );

  // ── cancelSpeech ──────────────────────────────────────────────────────────
  const cancelSpeech = useCallback(() => {
    synthRef.current?.cancel();
    setVoiceState((p) => ({ ...p, isSpeaking: false }));
  }, []);

  // ── toggleVoiceOutput ─────────────────────────────────────────────────────
  const toggleVoiceOutput = useCallback(() => {
    setVoiceState((p) => {
      const next = !p.voiceOutputEnabled;
      // If turning off mid-speech, cancel
      if (!next) synthRef.current?.cancel();
      return {
        ...p,
        voiceOutputEnabled: next,
        isSpeaking: next ? p.isSpeaking : false,
      };
    });
  }, []);

  // ── clearError ────────────────────────────────────────────────────────────
  const clearError = useCallback(() => {
    setVoiceState((p) => ({ ...p, error: null }));
  }, []);

  return [
    voiceState,
    {
      startListening,
      stopListening,
      speak,
      cancelSpeech,
      toggleVoiceOutput,
      clearError,
    },
  ];
}
