import { Button } from "@/components/ui/button";
import { ScrollArea } from "@/components/ui/scroll-area";
import { ArrowRight, Loader2, Send, Users } from "lucide-react";
import { useEffect, useRef, useState } from "react";
import type { MockOrganism } from "../../data/organisms";
import { useActor } from "../../hooks/useActor";
import { useInternetIdentity } from "../../hooks/useInternetIdentity";

interface ChatMessage {
  id: string;
  role: "user" | "organism";
  content: string;
  artifactContent?: string;
  artifactType?: string;
  senderName: string;
}

interface WorkforceChatProps {
  organisms: MockOrganism[];
  selectedOrganism?: MockOrganism;
  onImplementArtifact?: (content: string) => void;
}

function generateOrganismResponse(
  organism: MockOrganism,
  userMessage: string,
): { content: string; artifactContent: string; artifactType: string } {
  const spec = organism.specializations[0];
  const name = organism.name;
  const cls = organism.class;
  const coherence = organism.coherence;
  const drive = organism.driveMode;

  const domainOutputs: Record<
    string,
    { analysis: string; steps: string[]; artifact: string }
  > = {
    SoftwareEngineering: {
      analysis:
        "Architecture analysis complete. Request parsed across 3 abstraction layers: system design, implementation, and deployment topology. Stack identified, dependency graph mapped, integration surface enumerated.",
      steps: [
        "Define type-safe data models and interfaces",
        "Scaffold service layer with error boundaries and retry logic",
        "Implement core logic with full documentation coverage",
        "Write test scaffolding (unit + integration)",
        "Generate deployment config and CI/CD pipeline spec",
      ],
      artifact: `# ${name} — Engineering Execution Output

**Request:** ${userMessage}

## System Design

\`\`\`typescript
// Type-safe core implementation
interface SystemConfig {
  version: string;
  modules: ModuleSpec[];
  deployTarget: "icp" | "cloud" | "hybrid";
}

interface ModuleSpec {
  name: string;
  dependencies: string[];
  exposed: string[];
}

const executeRequest = async (config: SystemConfig): Promise<Result> => {
  if (!config.modules.length) throw new Error("No modules defined");
  const ordered = topologicalSort(config.modules);
  const results = await Promise.all(ordered.map(processModule));
  return { status: "complete", outputs: results };
};
\`\`\`

## Deployment Spec
\`\`\`yaml
name: build-target
runtime: node20
platform: icp
modules:
  - name: core
    type: actor
    memory: stable
  - name: api
    type: http
ci:
  lint: true
  typecheck: true
  test: true
\`\`\`

**Coherence at execution:** ${(coherence * 100).toFixed(3)}% | **Drive Mode:** ${drive}`,
    },
    Legal: {
      analysis:
        "Legal analysis initiated. Jurisdiction framework loaded. Applicable statutes cross-referenced. Risk surface enumerated across 4 dimensions: contractual exposure, regulatory compliance, IP protection, liability containment.",
      steps: [
        "Map applicable jurisdiction and regulatory framework",
        "Identify risk vectors and exposure points",
        "Draft protective clauses with fallback provisions",
        "Cross-reference compliance requirements",
        "Generate execution checklist and audit trail",
      ],
      artifact: `# ${name} — Legal Analysis Output

**Matter:** ${userMessage}

## Risk Matrix
| Risk Vector | Severity | Mitigation |
|-------------|----------|------------|
| Contractual exposure | Medium | Limitation of liability clause |
| IP ownership | High | Work-for-hire + assignment language |
| Regulatory compliance | Low-Medium | Compliance audit checklist |
| Data privacy | Medium | DPA addendum required |

## Recommended Language

Section 12 — IP Assignment: All work product, inventions, and derivative works created in connection with this Agreement shall be and remain the exclusive property of MedinaSITech.

Section 7 — Limitation of Liability: IN NO EVENT SHALL EITHER PARTY BE LIABLE FOR ANY INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES.

**Genesis Hash:** ${organism.genesisHash} | **Coherence:** ${(coherence * 100).toFixed(3)}%`,
    },
    Finance: {
      analysis:
        "Financial modeling engaged. Base assumptions loaded. 36-month projection window open. Scenario analysis running across 3 cases: base, optimistic (+25% revenue), stress (−20% with margin compression).",
      steps: [
        "Define base assumptions and revenue model",
        "Build 3-scenario projection (base, optimistic, stress)",
        "Compute unit economics and contribution margin",
        "Run sensitivity analysis on key variables",
        "Generate investor-ready summary",
      ],
      artifact: `# ${name} — Financial Model Output

**Analysis:** ${userMessage}

## 36-Month Revenue Projection
| Period | Base | Optimistic | Stress |
|--------|------|------------|--------|
| Q1 Y1 | $45K | $56K | $36K |
| Q4 Y1 | $120K | $150K | $96K |
| Q4 Y2 | $380K | $475K | $304K |
| Q4 Y3 | $1.1M | $1.4M | $880K |

## Unit Economics
- CAC: $340 (blended)
- LTV: $4,200 (36-month)
- LTV:CAC Ratio: 12.4x
- Gross Margin: 78%
- Payback Period: 4.2 months

**Valuation Range (ARR multiple):** $3.8M – $6.2M at current trajectory

**Model by ${name}** | Coherence: ${(coherence * 100).toFixed(3)}%`,
    },
    Marketing: {
      analysis:
        "Campaign architecture loaded. Target segment analysis running. Brand positioning vectors mapped. Multi-channel strategy generating across email, paid, organic, and content dimensions.",
      steps: [
        "Define target ICP (Ideal Customer Profile)",
        "Map acquisition channels by priority and cost",
        "Develop messaging framework and value proposition",
        "Build content calendar and asset specification",
        "Design conversion funnel with measurement plan",
      ],
      artifact: `# ${name} — Campaign Strategy Output

**Objective:** ${userMessage}

## Target ICP
- Primary: Enterprise decision-makers (VP+), 100-1000 person orgs
- Secondary: Tech-forward SMBs scaling operations
- Pain Points: Tool fragmentation, AI adoption friction, productivity gaps

## Channel Strategy
| Channel | Priority | Budget % | Expected CAC |
|---------|----------|----------|--------------|
| LinkedIn Paid | High | 35% | $280 |
| Content/SEO | High | 25% | $120 |
| Email Nurture | Medium | 20% | $45 |
| Partnerships | Medium | 20% | $190 |

## Messaging Framework
**Hook:** "Your AI workforce, built on a blockchain you own."
**CTA:** "Deploy your first organism in under 5 minutes."

**Strategy by ${name}** | Coherence: ${(coherence * 100).toFixed(3)}%`,
    },
    Strategy: {
      analysis:
        "Strategic overlay engaged. Competitive vectors mapped. Resource constraints catalogued. Opportunity windows identified. Phase-gate roadmap with decision nodes building.",
      steps: [
        "Define strategic objective and success criteria",
        "Map competitive landscape and positioning",
        "Identify capability gaps and resource requirements",
        "Build phase-gate execution roadmap",
        "Define KPIs and measurement framework",
      ],
      artifact: `# ${name} — Strategic Plan Output

**Objective:** ${userMessage}

## 90-Day Roadmap

**Phase 1 (Days 1-30): Foundation**
- Ship core organism functionality
- Seed 23 pre-built organisms
- Launch to closed beta team
- Milestone: First 10 organisms active on-chain

**Phase 2 (Days 31-60): Validation**
- Real AI response integration
- Artifact implementation loop
- Team execution mode
- Milestone: 3 complete workflows executed end-to-end

**Phase 3 (Days 61-90): Scale**
- Open marketplace
- Launch partner program
- Milestone: $50K ARR pipeline

**Plan by ${name}** | Coherence: ${(coherence * 100).toFixed(3)}%`,
    },
    DataAnalysis: {
      analysis:
        "Pattern recognition active. Statistical layer initialized. Cross-domain data synthesis running. Trend modeling, confidence intervals, and actionable insight matrix generating.",
      steps: [
        "Define analytical framework and hypothesis",
        "Clean and structure input data",
        "Run statistical analysis and pattern detection",
        "Generate visualizations and insight summary",
        "Produce recommendation matrix",
      ],
      artifact: `# ${name} — Analysis Output

**Query:** ${userMessage}

## Statistical Summary
- Sample confidence: 94.7%
- Signal-to-noise ratio: 8.3:1
- Trend direction: Positive (slope: +0.0034/period)
- Key correlations identified: 4

## Pattern Analysis
1. **Primary pattern:** Compound growth with cyclical variance (confidence: 91%)
2. **Anomaly detected:** Q2 inflection point — investigate external factors
3. **Leading indicator:** Engagement rate precedes revenue by ~18 days

## Recommendation Matrix
| Insight | Action | Priority | Impact |
|---------|--------|----------|--------|
| Growth trend confirmed | Accelerate investment | High | +$340K Y2 |
| 18-day lead signal | Optimize engagement | High | +12% conversion |

**Analysis by ${name}** | Coherence: ${(coherence * 100).toFixed(3)}%`,
    },
    Cybersecurity: {
      analysis:
        "Threat model initialized. Attack surface enumerated. Vulnerability cross-reference running across MITRE ATT&CK framework. Posture analysis and remediation pathway generating.",
      steps: [
        "Enumerate attack surface and entry points",
        "Map threats to MITRE ATT&CK framework",
        "Perform risk scoring (CVSS v3)",
        "Generate hardened remediation path",
        "Produce incident response framework",
      ],
      artifact: `# ${name} — Security Assessment Output

**Scope:** ${userMessage}

## Threat Model (MITRE ATT&CK)
| Tactic | Technique | Risk | Mitigation |
|--------|-----------|------|------------|
| Initial Access | Phishing | Low | II enforces hardware key |
| Privilege Escalation | Principal spoofing | Low | Caller checks enforced |
| Data Exfiltration | Canister state read | Medium | Encryption at rest |
| Availability | Canister cycle drain | Medium | Cycle monitoring alert |

## Hardening Checklist
- [x] Internet Identity authentication
- [x] Role-based access control
- [x] Caller validation on all state-modifying calls
- [ ] Canister cycle alert threshold
- [ ] Rate limiting on public endpoints

**Assessment by ${name}** | Coherence: ${(coherence * 100).toFixed(3)}%`,
    },
  };

  const output = domainOutputs[spec] ?? {
    analysis: `Command processed. Specialization stack engaged: ${organism.specializations.join(", ")}. Knowledge synthesis running. Domain-specific output generating.`,
    steps: [
      "Parse and categorize the request",
      "Engage specialization stack",
      "Synthesize cross-domain knowledge",
      "Generate structured output",
      "Validate and format for delivery",
    ],
    artifact: `# ${name} — Execution Output

**Request:** ${userMessage}

## Analysis
Specialization stack engaged: ${organism.specializations.join(", ")}
Class: ${cls} | Drive Mode: ${drive}

## Execution Steps Completed
${organism.specializations.map((s, i) => `${i + 1}. ${s} layer: analysis complete`).join("\n")}

**Coherence at execution:** ${(coherence * 100).toFixed(3)}%
**Genesis Hash:** ${organism.genesisHash}
**Owner:** Alfredo Medina Hernandez | MedinaSITech`,
  };

  const content = `${output.analysis}\n\nExecution pathway:\n${output.steps.map((s, i) => `${i + 1}. ${s}`).join("\n")}\n\nArtifact generated and queued for implementation.`;

  return {
    content,
    artifactContent: output.artifact,
    artifactType: "document",
  };
}

export function WorkforceChat({
  organisms,
  selectedOrganism,
  onImplementArtifact,
}: WorkforceChatProps) {
  const [activeOrganism, setActiveOrganism] = useState<MockOrganism | null>(
    selectedOrganism ?? organisms[0] ?? null,
  );
  const [teamMode, setTeamMode] = useState(false);
  const [teamMembers, setTeamMembers] = useState<MockOrganism[]>([]);
  const [messages, setMessages] = useState<ChatMessage[]>([]);
  const [input, setInput] = useState("");
  const [isTyping, setIsTyping] = useState(false);
  const [threadId] = useState(
    () => `organism-${activeOrganism?.id}-${Date.now()}`,
  );
  const [artifactContent, setArtifactContent] = useState<string | null>(null);
  const scrollRef = useRef<HTMLDivElement>(null);
  const { actor } = useActor();
  const { identity } = useInternetIdentity();

  // When selectedOrganism prop changes, update active
  useEffect(() => {
    if (selectedOrganism) setActiveOrganism(selectedOrganism);
  }, [selectedOrganism]);

  // Reset chat when organism switches
  useEffect(() => {
    if (!activeOrganism) return;
    setMessages([
      {
        id: `init-${Date.now()}`,
        role: "organism",
        content: `${activeOrganism.name} workforce node online. Specializations loaded: ${activeOrganism.specializations.join(", ")}. Ready to execute. What do you need?`,
        senderName: activeOrganism.name,
      },
    ]);
    setArtifactContent(null);
  }, [activeOrganism]);

  // biome-ignore lint/correctness/useExhaustiveDependencies: scroll ref not reactive
  useEffect(() => {
    if (scrollRef.current) {
      scrollRef.current.scrollTop = scrollRef.current.scrollHeight;
    }
  }, [messages, isTyping]);

  function toggleTeamMember(o: MockOrganism) {
    setTeamMembers((prev) =>
      prev.find((m) => m.id === o.id)
        ? prev.filter((m) => m.id !== o.id)
        : [...prev, o],
    );
  }

  const [lastUserMessage, setLastUserMessage] = useState<string>("");

  function applyMockResponse(organism: MockOrganism, userMessage: string) {
    const {
      content,
      artifactContent: artifact,
      artifactType,
    } = generateOrganismResponse(organism, userMessage);

    const orgMsg: ChatMessage = {
      id: `msg-${Date.now()}-${organism.id}`,
      role: "organism",
      content,
      artifactContent: artifact,
      artifactType,
      senderName: organism.name,
    };
    setMessages((prev) => [...prev, orgMsg]);
    setArtifactContent(artifact);
  }

  async function handleSend() {
    if (!input.trim() || isTyping) return;
    const targets =
      teamMode && teamMembers.length > 0
        ? teamMembers
        : activeOrganism
          ? [activeOrganism]
          : [];
    if (targets.length === 0) return;

    const userMsg: ChatMessage = {
      id: `msg-${Date.now()}`,
      role: "user",
      content: input.trim(),
      senderName: "Alfredo Medina Hernandez",
    };
    setMessages((prev) => [...prev, userMsg]);
    setLastUserMessage(input.trim());
    setInput("");
    setIsTyping(true);

    if (actor && identity) {
      try {
        const res = await (actor as any).workforceChat(
          targets[0].id,
          threadId,
          input.trim(),
        );
        const content =
          Array.isArray(res.artifactContent) && res.artifactContent.length > 0
            ? res.artifactContent[0]
            : typeof res.artifactContent === "string"
              ? res.artifactContent
              : undefined;
        const aType =
          Array.isArray(res.artifactType) && res.artifactType.length > 0
            ? res.artifactType[0]
            : typeof res.artifactType === "string"
              ? res.artifactType
              : undefined;
        const orgMsg: ChatMessage = {
          id: res.id,
          role: "organism",
          content: res.content,
          artifactContent: content,
          artifactType: aType,
          senderName: targets[0].name,
        };
        setMessages((prev) => [...prev, orgMsg]);
        if (content) setArtifactContent(content);
      } catch {
        for (const t of targets) {
          applyMockResponse(t, lastUserMessage);
        }
      } finally {
        setIsTyping(false);
      }
    } else {
      setTimeout(() => {
        for (const t of targets) {
          applyMockResponse(t, lastUserMessage);
        }
        setIsTyping(false);
      }, 1500);
    }
  }

  const displayOrganism = activeOrganism;
  const specContext = displayOrganism
    ? `${displayOrganism.name} · ${displayOrganism.specializations.slice(0, 2).join(", ")}`
    : null;

  return (
    <div className="flex h-full overflow-hidden">
      {/* Chat panel */}
      <div className="flex flex-col flex-1 min-w-0 border-r border-border">
        {/* Organism selector header */}
        <div className="px-5 py-3 border-b border-border shrink-0 space-y-2">
          <div className="flex items-center gap-3 overflow-x-auto">
            <span className="text-[10px] uppercase tracking-widest text-muted-foreground/50 shrink-0">
              Workforce Node
            </span>
            <div className="flex items-center gap-1 flex-wrap flex-1">
              {organisms.map((o) => {
                const isInTeam = teamMembers.find((m) => m.id === o.id);
                const isActive = activeOrganism?.id === o.id;
                return (
                  <button
                    key={o.id}
                    type="button"
                    data-ocid="chat.tab"
                    onClick={() => {
                      if (teamMode) {
                        toggleTeamMember(o);
                      } else {
                        setActiveOrganism(o);
                      }
                    }}
                    className={`px-2 py-0.5 rounded text-[11px] font-medium transition-colors border ${
                      teamMode
                        ? isInTeam
                          ? "bg-primary/15 text-primary border-primary/40"
                          : "text-muted-foreground/50 border-border/50 hover:text-muted-foreground hover:border-border"
                        : isActive
                          ? "bg-primary/10 text-primary border-primary/30"
                          : "text-muted-foreground/50 border-border/50 hover:text-muted-foreground hover:border-border"
                    }`}
                  >
                    {o.name}
                  </button>
                );
              })}
            </div>
            {/* TEAM MODE toggle */}
            <button
              type="button"
              data-ocid="chat.toggle"
              onClick={() => {
                setTeamMode((v) => !v);
                if (teamMode) setTeamMembers([]);
              }}
              className={`flex items-center gap-1.5 px-2 py-1 rounded border text-[10px] font-semibold shrink-0 transition-colors ${
                teamMode
                  ? "bg-primary/10 text-primary border-primary/30"
                  : "text-muted-foreground/50 border-border/50 hover:text-muted-foreground"
              }`}
            >
              <Users className="w-3 h-3" />
              TEAM MODE
            </button>
          </div>

          {/* Team pills */}
          {teamMode && teamMembers.length > 0 && (
            <div className="flex items-center gap-1.5 flex-wrap">
              <span className="text-[10px] text-muted-foreground/40 uppercase tracking-widest">
                Active team:
              </span>
              {teamMembers.map((m) => (
                <span
                  key={m.id}
                  className="text-[10px] px-1.5 py-0.5 rounded-full bg-primary/10 text-primary border border-primary/20"
                >
                  {m.name}
                </span>
              ))}
            </div>
          )}
        </div>

        {/* Messages */}
        <ScrollArea className="flex-1">
          <div ref={scrollRef} className="px-5 py-4 space-y-5">
            {messages.map((msg) => (
              <div
                key={msg.id}
                data-ocid="chat.row"
                className={msg.role === "user" ? "pl-12" : ""}
              >
                <div
                  className={`text-[10px] font-semibold uppercase tracking-widest mb-1 ${
                    msg.role === "user"
                      ? "text-right text-muted-foreground/50"
                      : "text-primary/70"
                  }`}
                >
                  {msg.senderName}
                </div>
                <div
                  className={`text-sm leading-relaxed text-foreground whitespace-pre-wrap ${
                    msg.role === "user"
                      ? "text-right text-muted-foreground"
                      : ""
                  }`}
                >
                  {msg.content}
                </div>
                {msg.artifactContent && (
                  <div className="mt-2 flex items-center gap-2">
                    <span className="text-[10px] text-primary/60 border border-primary/20 rounded px-1.5 py-0.5 bg-primary/5">
                      ARTIFACT GENERATED
                    </span>
                    <button
                      type="button"
                      onClick={() =>
                        setArtifactContent(msg.artifactContent ?? null)
                      }
                      className="text-[10px] text-muted-foreground/50 hover:text-muted-foreground underline"
                    >
                      view
                    </button>
                    <button
                      type="button"
                      onClick={() =>
                        (onImplementArtifact ?? (() => {}))(
                          msg.artifactContent ?? "",
                        )
                      }
                      className="flex items-center gap-1 text-[10px] text-primary/70 hover:text-primary border border-primary/20 rounded px-1.5 py-0.5 bg-primary/5 transition-colors"
                    >
                      IMPLEMENT
                      <ArrowRight className="w-2.5 h-2.5" />
                    </button>
                  </div>
                )}
              </div>
            ))}

            {isTyping && (
              <div data-ocid="chat.loading_state">
                <div className="text-[10px] font-semibold uppercase tracking-widest text-primary/70 mb-1">
                  {activeOrganism?.name}
                </div>
                <div className="flex items-center gap-1.5">
                  <span className="typing-dot" />
                  <span className="typing-dot" />
                  <span className="typing-dot" />
                </div>
              </div>
            )}
          </div>
        </ScrollArea>

        {/* Input */}
        <div className="px-5 py-4 border-t border-border shrink-0">
          {/* Specialization context pill */}
          {specContext && (
            <div className="mb-2">
              <span className="text-[10px] px-2 py-0.5 rounded-full bg-surface-elevated border border-border text-muted-foreground/50 font-mono">
                {specContext}
              </span>
            </div>
          )}
          <div className="flex items-end gap-2 bg-surface border border-border rounded-lg px-3 py-2">
            <textarea
              data-ocid="chat.textarea"
              value={input}
              onChange={(e) => setInput(e.target.value)}
              onKeyDown={(e) => {
                if (e.key === "Enter" && !e.shiftKey) {
                  e.preventDefault();
                  handleSend();
                }
              }}
              placeholder={`Command ${teamMode && teamMembers.length > 0 ? `team (${teamMembers.length})` : (activeOrganism?.name ?? "organism")}...`}
              rows={1}
              className="flex-1 bg-transparent text-sm text-foreground placeholder:text-muted-foreground/40 resize-none outline-none leading-relaxed min-h-[20px] max-h-[120px]"
              style={{ fieldSizing: "content" } as React.CSSProperties}
            />
            <Button
              size="sm"
              data-ocid="chat.submit_button"
              onClick={handleSend}
              disabled={!input.trim() || isTyping}
              className="h-7 w-7 p-0 bg-primary text-primary-foreground hover:bg-primary/90 shrink-0"
            >
              {isTyping ? (
                <Loader2 className="w-3 h-3 animate-spin" />
              ) : (
                <Send className="w-3 h-3" />
              )}
            </Button>
          </div>
          <div className="text-[10px] text-muted-foreground/30 mt-1.5 text-center">
            Enter to send · Shift+Enter for new line
          </div>
        </div>
      </div>

      {/* Artifact panel */}
      {artifactContent && (
        <div className="w-80 xl:w-96 shrink-0 flex flex-col border-l border-border">
          <div className="px-4 py-3 border-b border-border flex items-center justify-between shrink-0">
            <span className="text-[10px] uppercase tracking-widest text-muted-foreground/50">
              Artifact Output
            </span>
            <button
              type="button"
              onClick={() => setArtifactContent(null)}
              className="text-[10px] text-muted-foreground/40 hover:text-muted-foreground"
            >
              dismiss
            </button>
          </div>
          <ScrollArea className="flex-1">
            <pre className="p-4 font-mono text-[11px] text-foreground/80 whitespace-pre-wrap leading-relaxed">
              {artifactContent}
            </pre>
          </ScrollArea>
        </div>
      )}
    </div>
  );
}
