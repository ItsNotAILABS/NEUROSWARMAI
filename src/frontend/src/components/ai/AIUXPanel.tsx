// ══════════════════════════════════════════════════════════════════════════════
// AI UX PANEL — Full AI User Experience Interface
// Unified chat + engine routing + context-aware responses + multi-model support
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// ══════════════════════════════════════════════════════════════════════════════

import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import {
  Bot,
  Brain,
  ChevronRight,
  Cpu,
  Layers,
  MessageSquare,
  Send,
  Settings2,
  Sparkles,
  Zap,
} from "lucide-react";
import { useCallback, useEffect, useRef, useState } from "react";
import {
  type EngineCategory,
  type EngineNode,
  type MultiEngineState,
  type PipelineResult,
  executePipeline,
  getActiveEngines,
  getEnginesByCategory,
  initMultiEngineState,
  tickMultiEngine,
} from "../../data/multiEngineOrchestrator";

// ─── Types ───────────────────────────────────────────────────────────────────

interface AIMessage {
  id: string;
  role: "user" | "ai" | "system";
  content: string;
  timestamp: number;
  enginePath?: string[];
  latencyMs?: number;
  tokensUsed?: number;
  confidence?: number;
}

interface AIUXPanelProps {
  className?: string;
}

// ─── Constants ───────────────────────────────────────────────────────────────

const CATEGORY_COLORS: Record<EngineCategory, string> = {
  cognitive: "#a78bfa",
  intelligence: "#22d3ee",
  organism: "#34d399",
  pipeline: "#fbbf24",
  governance: "#f87171",
  substrate: "#818cf8",
};

const CATEGORY_LABELS: Record<EngineCategory, string> = {
  cognitive: "Cognitive",
  intelligence: "Intelligence",
  organism: "Organism",
  pipeline: "Pipeline",
  governance: "Governance",
  substrate: "Substrate",
};

// ─── Component ───────────────────────────────────────────────────────────────

export function AIUXPanel({ className }: AIUXPanelProps) {
  const [engineState, setEngineState] = useState<MultiEngineState>(initMultiEngineState);
  const [messages, setMessages] = useState<AIMessage[]>([
    {
      id: "sys-0",
      role: "system",
      content: "CHIMERIA AI UX Online. 27 engines registered. Multi-engine pipeline ready. Type a message to route through the cognitive stack.",
      timestamp: Date.now(),
    },
  ]);
  const [inputValue, setInputValue] = useState("");
  const [selectedPipeline, setSelectedPipeline] = useState<string[]>(["auto-runtime", "ocl", "cpl-pipeline", "nova-runtime"]);
  const [isProcessing, setIsProcessing] = useState(false);
  const scrollRef = useRef<HTMLDivElement>(null);

  // PHI-beat tick
  useEffect(() => {
    const interval = setInterval(() => {
      setEngineState((prev) => tickMultiEngine(prev));
    }, 873);
    return () => clearInterval(interval);
  }, []);

  // Auto-scroll
  useEffect(() => {
    if (scrollRef.current) {
      scrollRef.current.scrollTop = scrollRef.current.scrollHeight;
    }
  }, [messages]);

  const handleSend = useCallback(() => {
    if (!inputValue.trim() || isProcessing) return;

    const userMsg: AIMessage = {
      id: `user-${Date.now()}`,
      role: "user",
      content: inputValue.trim(),
      timestamp: Date.now(),
    };

    setMessages((prev) => [...prev, userMsg]);
    setInputValue("");
    setIsProcessing(true);

    // Simulate async engine pipeline execution
    setTimeout(() => {
      const result: PipelineResult = executePipeline(engineState, userMsg.content, selectedPipeline);

      const aiMsg: AIMessage = {
        id: `ai-${Date.now()}`,
        role: "ai",
        content: result.finalOutput,
        timestamp: Date.now(),
        enginePath: result.pipelinePath,
        latencyMs: result.totalLatencyMs,
        tokensUsed: result.totalTokens,
        confidence: result.steps[result.steps.length - 1]?.confidence,
      };

      setMessages((prev) => [...prev, aiMsg]);
      setIsProcessing(false);
    }, 300 + Math.random() * 400);
  }, [inputValue, isProcessing, engineState, selectedPipeline]);

  const activeEngines = getActiveEngines(engineState);
  const enginesByCategory = getEnginesByCategory(engineState);

  return (
    <div className={`flex flex-col h-full bg-background ${className || ""}`}>
      {/* Header */}
      <div className="flex items-center justify-between px-4 py-3 border-b border-border">
        <div className="flex items-center gap-2">
          <Sparkles className="w-5 h-5 text-cyan-400" />
          <h2 className="text-sm font-bold text-foreground">AI UX — Multi-Engine Interface</h2>
        </div>
        <div className="flex items-center gap-2">
          <Badge variant="outline" className="text-xs font-mono">
            <Cpu className="w-3 h-3 mr-1" />
            {activeEngines.length}/{engineState.engines.length} active
          </Badge>
          <Badge variant="outline" className="text-xs font-mono text-cyan-400">
            φ {engineState.phiCoherence.toFixed(3)}
          </Badge>
        </div>
      </div>

      <Tabs defaultValue="chat" className="flex-1 flex flex-col overflow-hidden">
        <TabsList className="mx-4 mt-2 justify-start bg-muted/50">
          <TabsTrigger value="chat" className="text-xs">
            <MessageSquare className="w-3 h-3 mr-1" /> Chat
          </TabsTrigger>
          <TabsTrigger value="engines" className="text-xs">
            <Layers className="w-3 h-3 mr-1" /> Engines
          </TabsTrigger>
          <TabsTrigger value="pipeline" className="text-xs">
            <Zap className="w-3 h-3 mr-1" /> Pipeline
          </TabsTrigger>
        </TabsList>

        {/* ─── Chat Tab ─────────────────────────────────────────────────── */}
        <TabsContent value="chat" className="flex-1 flex flex-col overflow-hidden m-0 px-4 pb-4">
          <ScrollArea className="flex-1 mt-2" ref={scrollRef}>
            <div className="space-y-3 pr-2">
              {messages.map((msg) => (
                <MessageBubble key={msg.id} message={msg} />
              ))}
              {isProcessing && (
                <div className="flex items-center gap-2 text-xs text-muted-foreground font-mono">
                  <div className="w-2 h-2 rounded-full bg-cyan-400 animate-pulse" />
                  Processing through {selectedPipeline.length} engines...
                </div>
              )}
            </div>
          </ScrollArea>

          {/* Input */}
          <div className="flex items-center gap-2 mt-3">
            <Input
              placeholder="Message the AI engine stack..."
              value={inputValue}
              onChange={(e) => setInputValue(e.target.value)}
              onKeyDown={(e) => e.key === "Enter" && handleSend()}
              className="flex-1 text-xs font-mono bg-muted/50"
              disabled={isProcessing}
            />
            <Button
              size="sm"
              onClick={handleSend}
              disabled={isProcessing || !inputValue.trim()}
              className="bg-cyan-600 hover:bg-cyan-700"
            >
              <Send className="w-3 h-3" />
            </Button>
          </div>

          {/* Active pipeline indicator */}
          <div className="flex items-center gap-1 mt-2 overflow-x-auto">
            <span className="text-[10px] text-muted-foreground font-mono shrink-0">Pipeline:</span>
            {selectedPipeline.map((id, i) => (
              <span key={id} className="flex items-center">
                <Badge variant="secondary" className="text-[9px] font-mono px-1 py-0">
                  {id}
                </Badge>
                {i < selectedPipeline.length - 1 && (
                  <ChevronRight className="w-2.5 h-2.5 text-muted-foreground mx-0.5" />
                )}
              </span>
            ))}
          </div>
        </TabsContent>

        {/* ─── Engines Tab ──────────────────────────────────────────────── */}
        <TabsContent value="engines" className="flex-1 overflow-hidden m-0 px-4 pb-4">
          <ScrollArea className="h-full mt-2">
            <div className="space-y-4">
              {(Object.entries(enginesByCategory) as [EngineCategory, EngineNode[]][]).map(
                ([category, engines]) => (
                  <div key={category}>
                    <div className="flex items-center gap-2 mb-2">
                      <div
                        className="w-2 h-2 rounded-full"
                        style={{ background: CATEGORY_COLORS[category] }}
                      />
                      <span className="text-xs font-bold text-foreground uppercase tracking-wider">
                        {CATEGORY_LABELS[category]}
                      </span>
                      <span className="text-[10px] text-muted-foreground">({engines.length})</span>
                    </div>
                    <div className="grid grid-cols-1 gap-1.5">
                      {engines.map((engine) => (
                        <EngineCard key={engine.id} engine={engine} categoryColor={CATEGORY_COLORS[category]} />
                      ))}
                    </div>
                  </div>
                )
              )}
            </div>
          </ScrollArea>
        </TabsContent>

        {/* ─── Pipeline Tab ─────────────────────────────────────────────── */}
        <TabsContent value="pipeline" className="flex-1 overflow-hidden m-0 px-4 pb-4">
          <ScrollArea className="h-full mt-2">
            <div className="space-y-4">
              <Card className="bg-muted/30 border-border">
                <CardHeader className="pb-2">
                  <CardTitle className="text-xs flex items-center gap-2">
                    <Settings2 className="w-3.5 h-3.5" />
                    Active Pipeline Configuration
                  </CardTitle>
                </CardHeader>
                <CardContent>
                  <div className="space-y-2">
                    {selectedPipeline.map((id, i) => {
                      const engine = engineState.engines.find((e) => e.id === id);
                      return (
                        <div key={id} className="flex items-center gap-2">
                          <span className="text-[10px] text-muted-foreground font-mono w-4">
                            {i + 1}.
                          </span>
                          <div className="flex-1 flex items-center gap-2 bg-background/50 rounded px-2 py-1.5 border border-border">
                            <Brain className="w-3 h-3 text-cyan-400" />
                            <span className="text-xs font-mono">{engine?.name || id}</span>
                            <Badge variant="outline" className="text-[9px] ml-auto">
                              {engine?.status || "unknown"}
                            </Badge>
                          </div>
                        </div>
                      );
                    })}
                  </div>
                </CardContent>
              </Card>

              {/* Preset Pipelines */}
              <Card className="bg-muted/30 border-border">
                <CardHeader className="pb-2">
                  <CardTitle className="text-xs">Preset Pipelines</CardTitle>
                </CardHeader>
                <CardContent className="space-y-2">
                  <PipelinePreset
                    name="Standard Chat"
                    engines={["auto-runtime", "ocl", "cpl-pipeline", "nova-runtime"]}
                    active={selectedPipeline.join(",") === "auto-runtime,ocl,cpl-pipeline,nova-runtime"}
                    onSelect={setSelectedPipeline}
                  />
                  <PipelinePreset
                    name="Deep Intelligence"
                    engines={["cognitive-core", "neural-core", "emergence-core", "adaptation-core", "nova-runtime"]}
                    active={selectedPipeline.join(",") === "cognitive-core,neural-core,emergence-core,adaptation-core,nova-runtime"}
                    onSelect={setSelectedPipeline}
                  />
                  <PipelinePreset
                    name="Governance Check"
                    engines={["meta-governor", "cpl-law", "cpl-contract", "ocl"]}
                    active={selectedPipeline.join(",") === "meta-governor,cpl-law,cpl-contract,ocl"}
                    onSelect={setSelectedPipeline}
                  />
                  <PipelinePreset
                    name="Full Cognitive Stack"
                    engines={["cil", "cdl", "sil", "til", "eel", "ocl", "cpl-pipeline"]}
                    active={selectedPipeline.join(",") === "cil,cdl,sil,til,eel,ocl,cpl-pipeline"}
                    onSelect={setSelectedPipeline}
                  />
                </CardContent>
              </Card>

              {/* System Stats */}
              <Card className="bg-muted/30 border-border">
                <CardHeader className="pb-2">
                  <CardTitle className="text-xs">System Statistics</CardTitle>
                </CardHeader>
                <CardContent>
                  <div className="grid grid-cols-2 gap-2 text-xs font-mono">
                    <div className="flex flex-col">
                      <span className="text-muted-foreground">Total Executions</span>
                      <span className="text-foreground font-bold">{engineState.totalExecutions.toLocaleString()}</span>
                    </div>
                    <div className="flex flex-col">
                      <span className="text-muted-foreground">System Load</span>
                      <span className="text-foreground font-bold">{(engineState.avgSystemLoad * 100).toFixed(1)}%</span>
                    </div>
                    <div className="flex flex-col">
                      <span className="text-muted-foreground">φ Coherence</span>
                      <span className="text-cyan-400 font-bold">{engineState.phiCoherence.toFixed(4)}</span>
                    </div>
                    <div className="flex flex-col">
                      <span className="text-muted-foreground">Active Routes</span>
                      <span className="text-foreground font-bold">{engineState.routes.filter((r) => r.active).length}</span>
                    </div>
                  </div>
                </CardContent>
              </Card>
            </div>
          </ScrollArea>
        </TabsContent>
      </Tabs>
    </div>
  );
}

// ─── Sub-Components ──────────────────────────────────────────────────────────

function MessageBubble({ message }: { message: AIMessage }) {
  const isUser = message.role === "user";
  const isSystem = message.role === "system";

  return (
    <div className={`flex ${isUser ? "justify-end" : "justify-start"}`}>
      <div
        className={`max-w-[85%] rounded-lg px-3 py-2 text-xs font-mono ${
          isUser
            ? "bg-slate-700 text-white"
            : isSystem
              ? "bg-slate-900 border border-cyan-800/50 text-cyan-300"
              : "bg-slate-800 border border-border text-foreground"
        }`}
      >
        {!isUser && !isSystem && (
          <div className="flex items-center gap-1.5 mb-1">
            <Bot className="w-3 h-3 text-cyan-400" />
            <span className="text-cyan-400 font-bold text-[10px]">CHIMERIA AI</span>
          </div>
        )}
        {isSystem && (
          <div className="flex items-center gap-1.5 mb-1">
            <Sparkles className="w-3 h-3 text-cyan-400" />
            <span className="text-cyan-500 font-bold text-[10px]">SYSTEM</span>
          </div>
        )}
        <p className="whitespace-pre-wrap leading-relaxed">{message.content}</p>
        {message.enginePath && (
          <div className="flex items-center gap-1 mt-1.5 pt-1.5 border-t border-border/50">
            <span className="text-[9px] text-muted-foreground">
              {message.enginePath.join(" → ")} · {message.latencyMs}ms · {message.tokensUsed} tokens · {((message.confidence || 0) * 100).toFixed(0)}% conf
            </span>
          </div>
        )}
      </div>
    </div>
  );
}

function EngineCard({ engine, categoryColor }: { engine: EngineNode; categoryColor: string }) {
  const statusColors: Record<string, string> = {
    idle: "text-muted-foreground",
    active: "text-green-400",
    processing: "text-cyan-400",
    error: "text-red-400",
    cooldown: "text-yellow-400",
  };

  return (
    <div className="flex items-center gap-2 bg-background/50 rounded px-2 py-1.5 border border-border/50">
      <div className="w-1.5 h-1.5 rounded-full" style={{ background: categoryColor }} />
      <div className="flex-1 min-w-0">
        <div className="flex items-center gap-1.5">
          <span className="text-[10px] font-bold text-foreground truncate">{engine.name}</span>
          <span className={`text-[9px] ${statusColors[engine.status]}`}>●</span>
        </div>
        <span className="text-[9px] text-muted-foreground truncate block">{engine.description}</span>
      </div>
      <div className="text-right shrink-0">
        <div className="text-[9px] font-mono text-muted-foreground">{(engine.load * 100).toFixed(0)}%</div>
        <div className="w-8 h-1 bg-muted rounded-full overflow-hidden">
          <div
            className="h-full rounded-full transition-all"
            style={{ width: `${engine.load * 100}%`, background: categoryColor }}
          />
        </div>
      </div>
    </div>
  );
}

function PipelinePreset({
  name,
  engines,
  active,
  onSelect,
}: {
  name: string;
  engines: string[];
  active: boolean;
  onSelect: (engines: string[]) => void;
}) {
  return (
    <Button
      variant={active ? "default" : "outline"}
      size="sm"
      className="w-full justify-start text-xs font-mono h-auto py-2"
      onClick={() => onSelect(engines)}
    >
      <div className="flex flex-col items-start gap-0.5">
        <span className="font-bold">{name}</span>
        <span className="text-[9px] text-muted-foreground">
          {engines.length} engines: {engines.slice(0, 3).join(" → ")}{engines.length > 3 ? " →..." : ""}
        </span>
      </div>
    </Button>
  );
}
