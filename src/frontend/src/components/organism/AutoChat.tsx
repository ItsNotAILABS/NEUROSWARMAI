// ═══════════════════════════════════════════════════════════════════════════
// AUTO CHAT — Context-Aware AGI Chat Interface
// ═══════════════════════════════════════════════════════════════════════════

import { ScrollArea } from "@/components/ui/scroll-area";
import { useCallback, useEffect, useRef, useState } from "react";
import {
  type AutoMessage,
  type AutoState,
  type OrganismContextSnapshot,
  buildContextSnapshot,
  formatContextSidebarLines,
  initAutoState,
  processSendMessage,
} from "../../data/autoEngine";
import type { NovaState } from "../../data/novaEngine";
import type { MockOrganism } from "../../data/organisms";
import type { CouncilNodeState, TASState } from "../../data/tasEngine";
import { useVoice } from "../../hooks/useVoice";

interface AutoChatProps {
  organism: MockOrganism;
  novaState: NovaState;
  tasState: TASState;
  council: CouncilNodeState[];
}

// ── Message bubble ────────────────────────────────────────────────────────────

function MessageBubble({ msg }: { msg: AutoMessage }) {
  const [expanded, setExpanded] = useState(false);
  const isUser = msg.role === "user";
  return (
    <div className={`flex mb-2 ${isUser ? "justify-end" : "justify-start"}`}>
      <div
        className={`max-w-sm rounded px-3 py-2 text-xs font-mono ${
          isUser
            ? "bg-slate-700 text-white"
            : "bg-slate-800 border border-border text-foreground"
        }`}
      >
        {!isUser && (
          <div className="flex items-center gap-1.5 mb-1">
            <span
              className="w-3 h-3 rounded-full inline-block"
              style={{ background: "#22d3ee" }}
            />
            <span className="text-cyan-400 font-bold text-xs">AUTO</span>
          </div>
        )}
        <p className="whitespace-pre-wrap break-words">{msg.content}</p>
        {msg.injectedContext && (
          <div className="mt-1.5">
            <button
              type="button"
              className="text-xs text-cyan-500/70 hover:text-cyan-400 underline underline-offset-2"
              onClick={() => setExpanded((v) => !v)}
            >
              {expanded ? "▲ hide context" : "▼ context injected"}
            </button>
            {expanded && (
              <pre className="mt-1 text-xs text-muted-foreground bg-black/40 rounded p-2 overflow-x-auto max-h-40 whitespace-pre-wrap">
                {msg.injectedContext}
              </pre>
            )}
          </div>
        )}
        <div className="flex justify-between mt-1 text-muted-foreground text-xs opacity-60">
          <span>{new Date(msg.timestamp).toLocaleTimeString()}</span>
          <span>~{msg.tokens}t</span>
        </div>
      </div>
    </div>
  );
}

// ── Sidebar line ──────────────────────────────────────────────────────────────

function SidebarLine({
  label,
  value,
  color,
}: {
  label: string;
  value: string;
  color: string;
}) {
  return (
    <div className="flex justify-between text-xs font-mono py-0.5 border-b border-border/30">
      <span className="text-muted-foreground truncate mr-2">{label}</span>
      <span className="text-right font-medium" style={{ color }}>
        {value}
      </span>
    </div>
  );
}

// ── Main component ────────────────────────────────────────────────────────────

export function AutoChat({
  organism,
  novaState,
  tasState,
  council,
}: AutoChatProps) {
  const [state, setState] = useState<AutoState>(() => initAutoState());
  const [inputText, setInputText] = useState("");
  const [latestContext, setLatestContext] =
    useState<OrganismContextSnapshot | null>(null);
  const messagesEndRef = useRef<HTMLDivElement>(null);
  const textareaRef = useRef<HTMLTextAreaElement>(null);

  // ── Voice layer ────────────────────────────────────────────────────────────
  const handleTranscriptCommit = useCallback(
    (text: string) => {
      // Set the textarea text so the user sees what was heard, then send
      setInputText(text);
      // Trigger send on next tick so state is updated
      setTimeout(() => {
        const ctx = buildContextSnapshot({
          beat: novaState.beat,
          phase: novaState.meanPhase,
          arousal: novaState.arousalLevel,
          driveMode: novaState.driveMode,
          coherence: novaState.coherence,
          qsov: novaState.qsov,
          kuramotoR: novaState.kuramotoR,
          council,
          message: text,
        });
        setLatestContext(ctx);
        setState((prev) => processSendMessage(prev, text, ctx));
        setInputText("");
      }, 50);
    },
    [novaState, council],
  );

  const [voiceState, voiceActions] = useVoice(handleTranscriptCommit);

  // Auto-speak the last AUTO response whenever voice output is enabled
  const lastAutoMsgIdRef = useRef<string | null>(null);
  useEffect(() => {
    if (!voiceState.voiceOutputEnabled) return;
    const lastMsg = state.messages[state.messages.length - 1];
    if (!lastMsg || lastMsg.role !== "auto") return;
    if (lastMsg.id === lastAutoMsgIdRef.current) return;
    lastAutoMsgIdRef.current = lastMsg.id;
    voiceActions.speak(lastMsg.content, latestContext);
  }, [
    state.messages,
    voiceState.voiceOutputEnabled,
    latestContext,
    voiceActions,
  ]);

  // Scroll to bottom on new messages
  // biome-ignore lint/correctness/useExhaustiveDependencies: intentional — triggers on new messages
  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
  }, [state.messages]);

  function buildSnapshot(message: string): OrganismContextSnapshot {
    return buildContextSnapshot({
      beat: novaState.beat,
      phase: novaState.meanPhase,
      arousal: novaState.arousalLevel,
      driveMode: novaState.driveMode,
      coherence: novaState.coherence,
      qsov: novaState.qsov,
      kuramotoR: novaState.kuramotoR,
      council,
      message,
    });
  }

  function handleSend() {
    const text = inputText.trim();
    if (!text || state.isProcessing) return;

    const ctx = buildSnapshot(text);
    setLatestContext(ctx);
    setState((prev) => processSendMessage(prev, text, ctx));
    setInputText("");
  }

  function handleKeyDown(e: React.KeyboardEvent<HTMLTextAreaElement>) {
    if (e.key === "Enter" && !e.shiftKey) {
      e.preventDefault();
      handleSend();
    }
  }

  const sidebarLines = latestContext
    ? formatContextSidebarLines(latestContext)
    : [];

  const lastMsg = state.messages[state.messages.length - 1];
  const lastKeywords =
    lastMsg?.role === "user" && latestContext
      ? latestContext.keywordTriggers
      : [];

  return (
    <div className="flex h-full bg-background text-foreground text-xs font-mono">
      {/* LEFT: Chat column */}
      <div className="flex-1 flex flex-col min-w-0 border-r border-border">
        {/* Header */}
        <div className="flex-shrink-0 px-4 py-2 border-b border-border flex items-center gap-3">
          <span className="text-cyan-400 font-bold text-sm">AUTO</span>
          <span className="text-muted-foreground text-xs">
            Context-aware AGI
          </span>
          {voiceState.isSpeaking && (
            <span className="flex items-center gap-1 text-xs text-cyan-400 animate-pulse">
              <span>▶</span>
              <span>speaking</span>
            </span>
          )}
          {voiceState.isMicActive && (
            <span className="flex items-center gap-1 text-xs text-red-400 animate-pulse">
              <span>●</span>
              <span>listening</span>
            </span>
          )}
          <div className="ml-auto flex items-center gap-2 text-xs text-muted-foreground">
            <span>
              {organism.name} · {organism.class}
            </span>
            <span className="text-cyan-600">
              ~{state.totalTokensUsed}t used
            </span>
          </div>
        </div>

        {/* Emergency banner */}
        {state.isEmergency && state.emergencyBannerEnabled && (
          <div className="flex-shrink-0 bg-red-950/80 border-b border-red-700 px-4 py-2 flex items-center justify-between">
            <span className="text-red-400 font-bold">
              ⚠ {state.emergencyReason}
            </span>
            <button
              type="button"
              className="text-red-400/60 hover:text-red-400 ml-2"
              onClick={() => setState((p) => ({ ...p, isEmergency: false }))}
            >
              ✕
            </button>
          </div>
        )}

        {/* Voice error banner */}
        {voiceState.error && (
          <div className="flex-shrink-0 bg-red-950/60 border-b border-red-800 px-4 py-1.5 flex items-center justify-between">
            <span className="text-red-400 text-xs">{voiceState.error}</span>
            <button
              type="button"
              className="text-red-400/60 hover:text-red-400 ml-2 text-xs"
              onClick={voiceActions.clearError}
            >
              ✕
            </button>
          </div>
        )}

        {/* Messages */}
        <ScrollArea className="flex-1 px-3 py-2">
          {state.messages.map((msg) => (
            <MessageBubble key={msg.id} msg={msg} />
          ))}
          <div ref={messagesEndRef} />
        </ScrollArea>

        {/* Input area */}
        <div className="flex-shrink-0 border-t border-border p-3 flex gap-2 items-end">
          {/* Push-to-talk mic button */}
          {voiceState.sttSupported && (
            <button
              type="button"
              onMouseDown={voiceActions.startListening}
              onMouseUp={voiceActions.stopListening}
              onTouchStart={voiceActions.startListening}
              onTouchEnd={voiceActions.stopListening}
              title={
                voiceState.isMicActive
                  ? "Listening… release to send"
                  : "Hold to speak"
              }
              className={`flex-shrink-0 w-9 h-9 rounded flex items-center justify-center border transition-colors select-none ${
                voiceState.isMicActive
                  ? "bg-red-600 border-red-400 animate-pulse"
                  : "bg-muted/40 border-border hover:border-cyan-500 hover:bg-cyan-900/20"
              }`}
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                strokeWidth={2}
                strokeLinecap="round"
                strokeLinejoin="round"
                className={`w-4 h-4 ${voiceState.isMicActive ? "text-white" : "text-muted-foreground"}`}
                aria-hidden="true"
              >
                <title>
                  {voiceState.isMicActive ? "Microphone active" : "Microphone"}
                </title>
                <path d="M12 2a3 3 0 0 1 3 3v7a3 3 0 0 1-6 0V5a3 3 0 0 1 3-3Z" />
                <path d="M19 10v2a7 7 0 0 1-14 0v-2" />
                <line x1="12" x2="12" y1="19" y2="22" />
              </svg>
            </button>
          )}

          <textarea
            ref={textareaRef}
            value={
              voiceState.isMicActive
                ? voiceState.transcript || inputText
                : inputText
            }
            onChange={(e) => {
              if (!voiceState.isMicActive) setInputText(e.target.value);
            }}
            onKeyDown={handleKeyDown}
            disabled={state.isProcessing || voiceState.isMicActive}
            placeholder={
              voiceState.isMicActive
                ? "Listening…"
                : voiceState.sttSupported
                  ? "Message AUTO… (Enter to send · hold 🎤 to speak)"
                  : "Message AUTO… (Enter to send, Shift+Enter for newline)"
            }
            rows={2}
            className="flex-1 bg-muted/30 border border-border rounded px-2 py-1.5 text-xs font-mono text-foreground placeholder:text-muted-foreground resize-none focus:outline-none focus:ring-1 focus:ring-cyan-500 disabled:opacity-50"
          />

          <div className="flex flex-col gap-1.5">
            <button
              type="button"
              onClick={handleSend}
              disabled={
                state.isProcessing ||
                !inputText.trim() ||
                voiceState.isMicActive
              }
              className="px-3 py-1.5 rounded bg-cyan-600 text-white font-bold text-xs hover:bg-cyan-500 disabled:opacity-40 disabled:cursor-not-allowed"
            >
              {state.isProcessing ? "…" : "SEND"}
            </button>

            {/* Voice output toggle */}
            {voiceState.ttsSupported && (
              <button
                type="button"
                onClick={
                  voiceState.isSpeaking
                    ? voiceActions.cancelSpeech
                    : voiceActions.toggleVoiceOutput
                }
                title={
                  voiceState.isSpeaking
                    ? "Speaking — click to stop"
                    : voiceState.voiceOutputEnabled
                      ? "Voice output ON — click to mute"
                      : "Voice output OFF — click to enable"
                }
                className={`px-2 py-1 rounded text-xs font-mono border transition-colors ${
                  voiceState.isSpeaking
                    ? "bg-cyan-700 border-cyan-400 text-white animate-pulse"
                    : voiceState.voiceOutputEnabled
                      ? "bg-cyan-900/40 border-cyan-600 text-cyan-400"
                      : "bg-muted/30 border-border text-muted-foreground hover:border-cyan-500"
                }`}
              >
                {voiceState.isSpeaking
                  ? "◼ stop"
                  : voiceState.voiceOutputEnabled
                    ? "◉ voice"
                    : "◎ mute"}
              </button>
            )}
          </div>
        </div>
      </div>

      {/* RIGHT: Context sidebar */}
      <div
        className="flex-shrink-0 flex flex-col border-l border-border"
        style={{ width: 280 }}
      >
        {/* Sidebar header */}
        <div className="flex-shrink-0 px-3 py-2 border-b border-border flex items-center justify-between">
          <span className="text-cyan-400 font-bold">LIVE CONTEXT</span>
          <div className="flex items-center gap-2">
            <span
              className="text-xs font-mono px-1 rounded"
              style={{
                color:
                  tasState.currentPhase === "THINK"
                    ? "#a78bfa"
                    : tasState.currentPhase === "ACT"
                      ? "#4ade80"
                      : "#facc15",
                background:
                  tasState.currentPhase === "THINK"
                    ? "#a78bfa18"
                    : tasState.currentPhase === "ACT"
                      ? "#4ade8018"
                      : "#facc1518",
              }}
            >
              TAS: {tasState.currentPhase}
            </span>
            <span className="text-muted-foreground text-xs animate-pulse">
              Reading now →
            </span>
          </div>
        </div>

        <ScrollArea className="flex-1 px-3 py-1">
          {/* Context lines */}
          {sidebarLines.length > 0 ? (
            <div className="mb-3">
              {sidebarLines.map(({ label, value, color }) => (
                <SidebarLine
                  key={label}
                  label={label}
                  value={value}
                  color={color}
                />
              ))}
            </div>
          ) : (
            <p className="text-muted-foreground text-xs py-2">
              Send a message to capture context.
            </p>
          )}

          {/* Council status collapsible section */}
          {latestContext && latestContext.councilStatus.length > 0 && (
            <CollapsibleSection title="COUNCIL STATUS">
              {latestContext.councilStatus.map((c) => (
                <div key={c.id} className="flex justify-between py-0.5 text-xs">
                  <span style={{ color: c.color }}>{c.id}</span>
                  <span className="text-muted-foreground">
                    {(c.activation * 100).toFixed(0)}% — {c.status}
                  </span>
                </div>
              ))}
            </CollapsibleSection>
          )}

          {/* Keyword triggers */}
          {lastKeywords.length > 0 && (
            <div className="mt-3">
              <div className="text-muted-foreground mb-1">KEYWORD TRIGGERS</div>
              <div className="flex flex-wrap gap-1">
                {lastKeywords.map((kw) => (
                  <span
                    key={kw}
                    className="px-1.5 py-0.5 rounded text-xs"
                    style={{
                      background: "#22d3ee20",
                      color: "#22d3ee",
                      border: "1px solid #22d3ee40",
                    }}
                  >
                    {kw}
                  </span>
                ))}
              </div>
            </div>
          )}
        </ScrollArea>

        {/* Toggle row */}
        <div className="flex-shrink-0 border-t border-border px-3 py-2 space-y-1">
          <Toggle
            label="Context Injection"
            value={state.contextInjectionEnabled}
            onChange={(v) =>
              setState((p) => ({ ...p, contextInjectionEnabled: v }))
            }
          />
          <Toggle
            label="Keyword Summary"
            value={state.keywordSummaryEnabled}
            onChange={(v) =>
              setState((p) => ({ ...p, keywordSummaryEnabled: v }))
            }
          />
          <Toggle
            label="Emergency Banner"
            value={state.emergencyBannerEnabled}
            onChange={(v) =>
              setState((p) => ({ ...p, emergencyBannerEnabled: v }))
            }
          />
        </div>
      </div>
    </div>
  );
}

// ── Helpers ───────────────────────────────────────────────────────────────────

function Toggle({
  label,
  value,
  onChange,
}: {
  label: string;
  value: boolean;
  onChange: (v: boolean) => void;
}) {
  return (
    <div className="flex items-center justify-between text-xs">
      <span className="text-muted-foreground">{label}</span>
      <button
        type="button"
        onClick={() => onChange(!value)}
        className={`w-7 h-4 rounded-full transition-colors flex items-center px-0.5 ${
          value ? "bg-cyan-600" : "bg-muted"
        }`}
      >
        <span
          className={`w-3 h-3 rounded-full bg-white transition-transform ${
            value ? "translate-x-3" : "translate-x-0"
          }`}
        />
      </button>
    </div>
  );
}

function CollapsibleSection({
  title,
  children,
}: {
  title: string;
  children: React.ReactNode;
}) {
  const [open, setOpen] = useState(true);
  return (
    <div className="mb-2">
      <button
        type="button"
        className="w-full flex items-center justify-between text-muted-foreground hover:text-foreground py-0.5"
        onClick={() => setOpen((v) => !v)}
      >
        <span>{title}</span>
        <span>{open ? "▲" : "▼"}</span>
      </button>
      {open && <div className="pl-1">{children}</div>}
    </div>
  );
}
