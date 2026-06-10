export type MessageRole = "user" | "assistant";

export interface Message {
  id: string;
  role: MessageRole;
  content: string;
  modelName?: string;
  timestamp: Date;
}

export interface Thread {
  id: string;
  title: string;
  messages: Message[];
}

export interface Workspace {
  id: string;
  name: string;
  threads: Thread[];
}

export type TaskStatus = "RUNNING" | "DONE" | "FAILED";

export interface AgentTask {
  id: string;
  name: string;
  agent: string;
  status: TaskStatus;
  progress: number;
  taskType: string;
  createdAt: Date;
}

export type ArtifactType = "code" | "pdf" | "canvas";

export interface Artifact {
  id: string;
  name: string;
  type: ArtifactType;
  language?: string;
  content: string;
  pages?: number;
  size?: string;
}

export const INITIAL_WORKSPACES: Workspace[] = [
  {
    id: "ws-1",
    name: "Engineering Sprint",
    threads: [
      {
        id: "th-1",
        title: "Auth Service: ICP Identity Integration",
        messages: [
          {
            id: "m1",
            role: "user",
            content:
              "FORGE-X, design and implement the authentication service. JWT tokens, refresh logic, and ICP Internet Identity integration. Production-ready.",
            timestamp: new Date(Date.now() - 3600000),
          },
          {
            id: "m2",
            role: "assistant",
            content:
              "FORGE-X — Engineering layer online. Auth request parsed across 3 abstraction layers.\n\nArchitecture complete:\n\n• JWT: RSA-256 signed, 15-min access tokens + 30-day refresh tokens with sliding window\n• ICP bridge: Principal → UserID mapping via Internet Identity delegation chain\n• Session store: Stable variable on ICP canister, survives upgrades\n• Refresh logic: Device fingerprinting to prevent token theft\n\nGenerating production-grade Motoko canister with full error types, 14 test cases covering nominal, edge, and adversarial paths. Do you want the canister first or the frontend bindings?",
            modelName: "FORGE-X",
            timestamp: new Date(Date.now() - 3540000),
          },
          {
            id: "m3",
            role: "user",
            content:
              "Canister first. Include retry logic and circuit breaker for downstream calls.",
            timestamp: new Date(Date.now() - 1800000),
          },
          {
            id: "m4",
            role: "assistant",
            content:
              "FORGE-X — Canister generated. Exponential backoff retry (3 attempts, 100ms/500ms/2s), circuit breaker with 5-failure threshold and 30-second recovery window. Coherence holding at 91.8% — build is clean. Artifact surfaced in the rail.",
            modelName: "FORGE-X",
            timestamp: new Date(Date.now() - 1740000),
          },
        ],
      },
      {
        id: "th-2",
        title: "DB Performance Audit",
        messages: [
          {
            id: "m5",
            role: "user",
            content:
              "CODESMITH, full performance audit on the database access layer. Query optimization and caching strategy.",
            timestamp: new Date(Date.now() - 7200000),
          },
          {
            id: "m6",
            role: "assistant",
            content:
              "CODESMITH — Audit complete. Scanned 847 query patterns across 12 access modules.\n\nCritical findings:\n• 3 N+1 query chains consuming 68% of total DB latency\n• Missing compound index on (user_id, created_at) — this alone drops p99 by ~340ms\n• Cache hit rate: 23% — target is 80%+\n\nCaching strategy: Redis L1 for hot paths (5-min TTL), ICP stable memory L2 for cold paths (24-hour TTL). Estimated latency improvement: 4.2× after full implementation.",
            modelName: "CODESMITH",
            timestamp: new Date(Date.now() - 7140000),
          },
        ],
      },
    ],
  },
  {
    id: "ws-2",
    name: "Strategy & Analysis",
    threads: [
      {
        id: "th-3",
        title: "Q3 Competitive Analysis",
        messages: [
          {
            id: "m7",
            role: "user",
            content:
              "ORACLE, full competitive analysis for Q3. Three main competitors — where are we losing market share and why?",
            timestamp: new Date(Date.now() - 14400000),
          },
          {
            id: "m8",
            role: "assistant",
            content:
              "ORACLE — Dataset ingested. Multi-variate analysis across market signals, pricing data, feature matrices, and 47K user sentiment data points complete.\n\nCompetitive landscape:\n\nCompetitor A — Strong enterprise, weak SMB. Win rate against us: 34%. Vulnerability: integration depth.\nCompetitor B — Price leader, declining on product quality. Annual churn: 28%. Exploit: reliability narrative.\nCompetitor C — Strong product, poor distribution. Market share declining 2.3% QoQ. Exploit: partnership channels.\n\nOur gap: We lead on AI depth and reliability but trail 18% on onboarding friction. Highest-leverage action: reduce time-to-first-value below 10 minutes.",
            modelName: "ORACLE",
            timestamp: new Date(Date.now() - 14340000),
          },
          {
            id: "m9",
            role: "user",
            content:
              "Build the full strategic response plan. Prioritized actions with owners and timelines.",
            timestamp: new Date(Date.now() - 10800000),
          },
          {
            id: "m10",
            role: "assistant",
            content:
              "ORACLE & NEXUS — Strategic response plan assembled. 9 initiatives ranked by impact-to-effort. Top 3:\n\n1. Onboarding redesign — 8-week sprint, targets Competitor A's activation gap (+40% projected)\n2. SMB pricing tier — 2-week ship, closes Competitor B's price advantage\n3. 3 enterprise integration partnerships — addresses Competitor C's distribution gap\n\nFull roadmap with resource allocation surfaced as artifact in the rail.",
            modelName: "ORACLE",
            timestamp: new Date(Date.now() - 10740000),
          },
        ],
      },
      {
        id: "th-4",
        title: "Q4 OKR Planning",
        messages: [
          {
            id: "m11",
            role: "user",
            content:
              "NEXUS, structure our Q4 OKRs. Ambitious but achievable. Focus: revenue growth and product depth.",
            timestamp: new Date(Date.now() - 48000000),
          },
          {
            id: "m12",
            role: "assistant",
            content:
              "NEXUS — Strategic planning layer active. Cross-referencing historical performance, market trajectory, and capacity constraints against 12 comparable benchmarks.\n\nQ4 OKR Framework:\n\nObjective 1: Accelerate Revenue Engine\n• KR1: ARR $2.1M → $3.4M (+62%)\n• KR2: Net Revenue Retention >115%\n• KR3: CAC payback period <14 months\n\nObjective 2: Deepen Product Moat\n• KR1: Ship 3 enterprise-grade features\n• KR2: API call volume 10× current\n• KR3: NPS above 55\n\nAll KRs graded at stretch/base/floor thresholds. Team-level cascade ready on request.",
            modelName: "NEXUS",
            timestamp: new Date(Date.now() - 47940000),
          },
        ],
      },
    ],
  },
  {
    id: "ws-3",
    name: "Legal & Operations",
    threads: [
      {
        id: "th-5",
        title: "Contract Review: Enterprise Partnership",
        messages: [
          {
            id: "m13",
            role: "user",
            content:
              "AXIOM, review the enterprise partnership agreement before we sign. IP ownership, liability caps, and termination clauses are the priority.",
            timestamp: new Date(Date.now() - 21600000),
          },
          {
            id: "m14",
            role: "assistant",
            content:
              "AXIOM — Legal analysis complete. Jurisdiction: Delaware. Document: 47 pages.\n\nHigh-risk findings:\n\n🔴 §8.3 — IP Assignment: Language is overbroad. As written, any work developed using their platform transfers IP to them. Must amend to 'work specifically created under this agreement only.'\n🟡 §11.2 — Liability Cap: One month of fees. Industry standard is 12 months. Push for minimum 6.\n🟡 §15.1 — Termination: 30-day notice. Request 60 days + cure period for material breach.\n\n3 additional moderate-risk clauses flagged. Redlines and amendment letter ready. Shall I send?",
            modelName: "AXIOM",
            timestamp: new Date(Date.now() - 21540000),
          },
        ],
      },
      {
        id: "th-6",
        title: "Operations: Onboarding Audit",
        messages: [
          {
            id: "m15",
            role: "user",
            content:
              "TITANIUM, full audit of our onboarding and internal operations. Where are we losing users and what's slowing the team down?",
            timestamp: new Date(Date.now() - 86400000),
          },
          {
            id: "m16",
            role: "assistant",
            content:
              "TITANIUM — Operations audit complete. 14 workflow nodes analyzed across 6 team functions.\n\nTop friction points:\n\n1. Manual data entry CRM → project management: 2.4 hrs/week per AE\n2. Approval bottleneck at VP level: 3.2-day average delay on standard requests\n3. Onboarding completion rate: 41% — users drop at step 5 (integration setup)\n4. Weekly reporting: 6 hours of manual aggregation across 4 tools\n\nAutomation recovers ~27 hours/week across the team. CRM sync and approval routing should ship first — highest ROI, 2-week implementation each.",
            modelName: "TITANIUM",
            timestamp: new Date(Date.now() - 86340000),
          },
        ],
      },
    ],
  },
];

export const INITIAL_TASKS: AgentTask[] = [
  {
    id: "task-1",
    name: "Auth Canister: Code Review",
    agent: "FORGE-X",
    status: "RUNNING",
    progress: 67,
    taskType: "code",
    createdAt: new Date(Date.now() - 120000),
  },
  {
    id: "task-2",
    name: "Enterprise Contract Analysis",
    agent: "AXIOM",
    status: "DONE",
    progress: 100,
    taskType: "analysis",
    createdAt: new Date(Date.now() - 3600000),
  },
  {
    id: "task-3",
    name: "Q3 Market Report",
    agent: "ORACLE",
    status: "DONE",
    progress: 100,
    taskType: "report",
    createdAt: new Date(Date.now() - 7200000),
  },
  {
    id: "task-4",
    name: "Competitor Pricing Model",
    agent: "STRATUM",
    status: "FAILED",
    progress: 43,
    taskType: "analysis",
    createdAt: new Date(Date.now() - 10800000),
  },
];

// ═══════════════════════════════════════════════════════════════════════════════
// ENTERPRISE AI MODELS — Specialized Organisms for Different Functions
// ═══════════════════════════════════════════════════════════════════════════════

export interface AIModel {
  id: string;
  name: string;
  description: string;
  specialization: string;
  icon: string;
  color: string;
  capabilities: string[];
  coherenceTarget: number;
}

export const MODELS: AIModel[] = [
  {
    id: "forge-x",
    name: "FORGE-X",
    description: "Engineering & Development Specialist",
    specialization: "SoftwareEngineering",
    icon: "⚙️",
    color: "#3b82f6",
    capabilities: [
      "Code generation",
      "Architecture design",
      "Testing",
      "DevOps",
      "Security audit",
    ],
    coherenceTarget: 0.92,
  },
  {
    id: "oracle",
    name: "ORACLE",
    description: "Data Analysis & Strategy Intelligence",
    specialization: "DataAnalysis",
    icon: "📊",
    color: "#8b5cf6",
    capabilities: [
      "Market analysis",
      "Trend prediction",
      "Data synthesis",
      "Report generation",
      "Competitive intelligence",
    ],
    coherenceTarget: 0.88,
  },
  {
    id: "axiom",
    name: "AXIOM",
    description: "Legal & Compliance Expert",
    specialization: "Legal",
    icon: "⚖️",
    color: "#ef4444",
    capabilities: [
      "Contract review",
      "Compliance audit",
      "Risk assessment",
      "IP protection",
      "Regulatory guidance",
    ],
    coherenceTarget: 0.95,
  },
  {
    id: "nexus",
    name: "NEXUS",
    description: "Strategy & Planning Coordinator",
    specialization: "Strategy",
    icon: "🎯",
    color: "#10b981",
    capabilities: [
      "OKR planning",
      "Resource allocation",
      "Roadmap creation",
      "Team coordination",
      "Goal tracking",
    ],
    coherenceTarget: 0.9,
  },
  {
    id: "titanium",
    name: "TITANIUM",
    description: "Operations & Process Optimization",
    specialization: "Operations",
    icon: "🔧",
    color: "#f59e0b",
    capabilities: [
      "Workflow audit",
      "Process automation",
      "Efficiency analysis",
      "Bottleneck detection",
      "SOP creation",
    ],
    coherenceTarget: 0.87,
  },
  {
    id: "stratum",
    name: "STRATUM",
    description: "Financial Modeling & Analysis",
    specialization: "Finance",
    icon: "💰",
    color: "#22c55e",
    capabilities: [
      "Financial modeling",
      "Pricing strategy",
      "Revenue forecasting",
      "Cost analysis",
      "Investment analysis",
    ],
    coherenceTarget: 0.91,
  },
  {
    id: "codesmith",
    name: "CODESMITH",
    description: "Code Quality & Review Specialist",
    specialization: "Architecture",
    icon: "🛠️",
    color: "#6366f1",
    capabilities: [
      "Code review",
      "Refactoring",
      "Performance audit",
      "Best practices",
      "Technical debt analysis",
    ],
    coherenceTarget: 0.93,
  },
  {
    id: "tori",
    name: "TORI",
    description: "Marketing & Communications",
    specialization: "Marketing",
    icon: "📢",
    color: "#ec4899",
    capabilities: [
      "Content creation",
      "Campaign strategy",
      "Brand messaging",
      "Market positioning",
      "Social strategy",
    ],
    coherenceTarget: 0.85,
  },
  {
    id: "pulse",
    name: "PULSE",
    description: "Customer Success & Engagement",
    specialization: "Sales",
    icon: "💫",
    color: "#14b8a6",
    capabilities: [
      "Customer analysis",
      "Engagement strategy",
      "Retention planning",
      "Feedback synthesis",
      "NPS optimization",
    ],
    coherenceTarget: 0.88,
  },
  {
    id: "aegis",
    name: "AEGIS",
    description: "Security & Risk Management",
    specialization: "Cybersecurity",
    icon: "🛡️",
    color: "#dc2626",
    capabilities: [
      "Security audit",
      "Threat detection",
      "Compliance check",
      "Incident response",
      "Access control",
    ],
    coherenceTarget: 0.96,
  },
];

export const INITIAL_ARTIFACTS: Artifact[] = [
  {
    id: "art-1",
    name: "auth_canister.mo",
    type: "code",
    language: "motoko",
    content: `import Principal "mo:base/Principal";
import Text "mo:base/Text";
import Time "mo:base/Time";
import HashMap "mo:base/HashMap";

actor AuthCanister {
  private stable var sessions : [(Text, Principal)] = [];
  private var sessionMap = HashMap.fromIter<Text, Principal>(
    sessions.vals(), 10, Text.equal, Text.hash
  );

  public shared(msg) func login() : async Text {
    let token = generateToken(msg.caller);
    sessionMap.put(token, msg.caller);
    token
  };

  public query func verify(token : Text) : async Bool {
    switch (sessionMap.get(token)) {
      case (?_) { true };
      case null { false };
    }
  };

  public shared(msg) func logout(token : Text) : async () {
    sessionMap.delete(token);
  };

  private func generateToken(p : Principal) : Text {
    let t = Int.toText(Time.now());
    Text.concat(Principal.toText(p), t)
  };
}`,
  },
  {
    id: "art-2",
    name: "Enterprise_Contract_Redlines.pdf",
    type: "pdf",
    content: "AXIOM Legal Analysis — Enterprise Partnership Agreement Redlines",
    pages: 47,
    size: "3.1 MB",
  },
  {
    id: "art-3",
    name: "Q3 Competitive Strategy Map",
    type: "canvas",
    content:
      "Interactive competitive landscape analysis — market position, win/loss vectors, opportunity matrix",
  },
];
