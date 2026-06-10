// ═══════════════════════════════════════════════════════════════════════════════
// MERIDIANUS COMMAND CENTER — SOVEREIGN AGI PRODUCT DASHBOARD
// ═══════════════════════════════════════════════════════════════════════════════
// Owner: Alfredo Medina Hernandez | Dallas TX | MedinaSITech@outlook.com

import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Progress } from "@/components/ui/progress";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Separator } from "@/components/ui/separator";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import {
  Activity,
  Bot,
  CheckCircle2,
  Clock,
  Cloud,
  Download,
  Edit3,
  FileText,
  Globe,
  Loader2,
  MessageSquare,
  Monitor,
  Plus,
  QrCode,
  Send,
  StickyNote,
  Terminal,
  Trash2,
  Upload,
  User,
  Wifi,
  XCircle,
  Zap,
} from "lucide-react";
import { motion } from "motion/react";
import { useCallback, useState } from "react";

// ─────────────────────────────────────────────────────────────────────────────
// TYPES
// ─────────────────────────────────────────────────────────────────────────────

interface CommandEntry {
  id: string;
  timestamp: string;
  source: "extension" | "chat" | "canister" | "system";
  command: string;
  status: "success" | "pending" | "failed";
}

interface ChatMessage {
  id: string;
  sender: "user" | "jarvis";
  text: string;
  timestamp: string;
}

interface Note {
  id: string;
  title: string;
  preview: string;
  timestamp: string;
  tags: string[];
}

interface Document {
  id: string;
  title: string;
  type: "PDF" | "DOC" | "TXT" | "MD";
  size: string;
  timestamp: string;
}

interface AlphaAI {
  name: string;
  role: string;
  online: boolean;
}

// ─────────────────────────────────────────────────────────────────────────────
// CONSTANTS
// ─────────────────────────────────────────────────────────────────────────────

const STATUS_STYLES: Record<CommandEntry["status"], string> = {
  success: "bg-green-500/20 text-green-400 border-green-500/40",
  pending: "bg-yellow-500/20 text-yellow-400 border-yellow-500/40",
  failed: "bg-red-500/20 text-red-400 border-red-500/40",
};

const SOURCE_STYLES: Record<CommandEntry["source"], string> = {
  extension: "bg-cyan-500/20 text-cyan-400 border-cyan-500/40",
  chat: "bg-purple-500/20 text-purple-400 border-purple-500/40",
  canister: "bg-blue-500/20 text-blue-400 border-blue-500/40",
  system: "bg-slate-500/20 text-slate-400 border-slate-500/40",
};

const DOC_TYPE_STYLES: Record<Document["type"], string> = {
  PDF: "bg-red-500/20 text-red-400 border-red-500/40",
  DOC: "bg-blue-500/20 text-blue-400 border-blue-500/40",
  TXT: "bg-slate-500/20 text-slate-300 border-slate-500/40",
  MD: "bg-purple-500/20 text-purple-400 border-purple-500/40",
};

const INITIAL_COMMANDS: CommandEntry[] = [
  {
    id: "cmd-1",
    timestamp: "12:04:31",
    source: "extension",
    command: "switch to tab 3 — Canister Dashboard",
    status: "success",
  },
  {
    id: "cmd-2",
    timestamp: "12:04:28",
    source: "chat",
    command: "open https://dashboard.internetcomputer.org",
    status: "success",
  },
  {
    id: "cmd-3",
    timestamp: "12:04:22",
    source: "canister",
    command: "note created: 'Colony Architecture v2 Draft'",
    status: "success",
  },
  {
    id: "cmd-4",
    timestamp: "12:04:18",
    source: "extension",
    command: "capture screen — PDF saved to canister",
    status: "success",
  },
  {
    id: "cmd-5",
    timestamp: "12:04:12",
    source: "system",
    command: "heartbeat #4,217 — coherence R=0.94",
    status: "success",
  },
  {
    id: "cmd-6",
    timestamp: "12:03:58",
    source: "chat",
    command: "close tab — legacy dashboard removed",
    status: "success",
  },
  {
    id: "cmd-7",
    timestamp: "12:03:41",
    source: "extension",
    command: "switch to tab 1 — MERIDIAN main",
    status: "success",
  },
  {
    id: "cmd-8",
    timestamp: "12:03:30",
    source: "canister",
    command: "document sync: 'Medina Doctrine.pdf' uploaded",
    status: "success",
  },
  {
    id: "cmd-9",
    timestamp: "12:03:22",
    source: "system",
    command: "Alpha Script AI cluster — all 10 nodes online",
    status: "success",
  },
  {
    id: "cmd-10",
    timestamp: "12:03:10",
    source: "extension",
    command: "open https://github.com/FreddyCreates",
    status: "pending",
  },
  {
    id: "cmd-11",
    timestamp: "12:02:55",
    source: "chat",
    command: "list tabs — 7 tabs enumerated",
    status: "success",
  },
  {
    id: "cmd-12",
    timestamp: "12:02:40",
    source: "system",
    command: "canister memory compaction — 2.1 MB freed",
    status: "success",
  },
];

const INITIAL_MESSAGES: ChatMessage[] = [
  {
    id: "msg-1",
    sender: "jarvis",
    text: "MERIDIANUS online. All systems nominal. Canister connection established. Per aspera ad astra, Alfredo.",
    timestamp: "12:00:00",
  },
  {
    id: "msg-2",
    sender: "user",
    text: "open https://dashboard.internetcomputer.org",
    timestamp: "12:04:28",
  },
  {
    id: "msg-3",
    sender: "jarvis",
    text: "Opening URL: https://dashboard.internetcomputer.org — New tab created and focused.",
    timestamp: "12:04:28",
  },
];

const INITIAL_NOTES: Note[] = [
  {
    id: "n-1",
    title: "Colony Architecture v2",
    preview:
      "Redesign the colony substrate to support multi-canister state sharding across subnet boundaries...",
    timestamp: "Dec 15, 2025",
    tags: ["architecture", "ICP"],
  },
  {
    id: "n-2",
    title: "GRPE Layer Integration",
    preview:
      "Connect geomagnetic data feed to heritage node activation. Real IGRF coefficients mapped to phi weights...",
    timestamp: "Dec 14, 2025",
    tags: ["GRPE", "phi"],
  },
  {
    id: "n-3",
    title: "Alpha Script Deployment",
    preview:
      "Deploy all 10 AI nodes to production canister. Verify heartbeat sync and coherence thresholds...",
    timestamp: "Dec 13, 2025",
    tags: ["alpha", "deploy"],
  },
  {
    id: "n-4",
    title: "Extension Manifest v3",
    preview:
      "Migrate Chrome extension to Manifest v3. Update service worker registration and content script injection...",
    timestamp: "Dec 12, 2025",
    tags: ["extension", "chrome"],
  },
  {
    id: "n-5",
    title: "Medina Doctrine — Chapter 7",
    preview:
      "Sovereignty is not granted — it is engineered. Every system that depends on external validation...",
    timestamp: "Dec 11, 2025",
    tags: ["doctrine", "sovereignty"],
  },
  {
    id: "n-6",
    title: "ORO Workflow Templates",
    preview:
      "Define standard workflow templates for ORO command center: inventory scan, market analysis, deployment...",
    timestamp: "Dec 10, 2025",
    tags: ["ORO", "workflows"],
  },
  {
    id: "n-7",
    title: "Canister Backup Strategy",
    preview:
      "Implement automated canister state snapshots every 1000 heartbeats. Store compressed deltas on-chain...",
    timestamp: "Dec 9, 2025",
    tags: ["backup", "ICP"],
  },
];

const INITIAL_DOCUMENTS: Document[] = [
  {
    id: "d-1",
    title: "Medina Doctrine — Full Text",
    type: "PDF",
    size: "2.4 MB",
    timestamp: "Dec 15, 2025",
  },
  {
    id: "d-2",
    title: "Colony Architecture Whitepaper",
    type: "PDF",
    size: "1.8 MB",
    timestamp: "Dec 14, 2025",
  },
  {
    id: "d-3",
    title: "GRPE Technical Specification",
    type: "DOC",
    size: "890 KB",
    timestamp: "Dec 13, 2025",
  },
  {
    id: "d-4",
    title: "Extension Installation Guide",
    type: "TXT",
    size: "12 KB",
    timestamp: "Dec 12, 2025",
  },
  {
    id: "d-5",
    title: "Alpha Script Node Configuration",
    type: "MD",
    size: "45 KB",
    timestamp: "Dec 11, 2025",
  },
  {
    id: "d-6",
    title: "ICP Canister Deployment Log",
    type: "TXT",
    size: "156 KB",
    timestamp: "Dec 10, 2025",
  },
];

const ALPHA_AIS: AlphaAI[] = [
  { name: "ATLAS", role: "Infrastructure Orchestrator", online: true },
  { name: "CIPHER", role: "Cryptographic Sentinel", online: true },
  { name: "DELTA", role: "Data Pipeline Manager", online: true },
  { name: "ECHO", role: "Communication Relay", online: true },
  { name: "FORGE", role: "Build & Deploy Engine", online: true },
  { name: "GHOST", role: "Stealth Operations", online: true },
  { name: "HELIX", role: "Genetic Algorithm Processor", online: true },
  { name: "IRIS", role: "Visual Recognition Core", online: false },
  { name: "NEXUS", role: "Network Intelligence", online: true },
  { name: "OMEGA", role: "Final Decision Validator", online: true },
];

// ─────────────────────────────────────────────────────────────────────────────
// HELPERS
// ─────────────────────────────────────────────────────────────────────────────

function currentTime(): string {
  const d = new Date();
  return `${String(d.getHours()).padStart(2, "0")}:${String(d.getMinutes()).padStart(2, "0")}:${String(d.getSeconds()).padStart(2, "0")}`;
}

function processJarvisCommand(input: string): string {
  const lower = input.toLowerCase().trim();
  if (lower.startsWith("open "))
    return `Opening URL: ${input.slice(5).trim()} — New tab created and focused.`;
  if (lower.startsWith("switch to tab"))
    return `Switching to tab ${input.replace(/\D/g, "") || "next"}. View updated.`;
  if (lower.startsWith("close tab"))
    return "Closing current tab. Focus returned to previous tab.";
  if (lower.startsWith("take note")) {
    const parts = input.slice(9).trim();
    const colonIdx = parts.indexOf(":");
    const title = colonIdx > -1 ? parts.slice(0, colonIdx).trim() : parts;
    return `Note saved: "${title}". Synced to canister storage.`;
  }
  if (lower.startsWith("capture screen"))
    return "Screenshot captured. PDF generated and stored in canister document library.";
  if (lower.startsWith("create document"))
    return `Document created: "${input.slice(15).trim()}". Available in Documents tab.`;
  if (lower.startsWith("list tabs"))
    return "Listing all open tabs:\n1. MERIDIAN — Main Dashboard\n2. Canister Explorer\n3. GitHub — FreddyCreates\n4. ICP Dashboard\n5. Colony Viewer";
  return "Command processed. Routing through organism network. Result will appear in the command feed.";
}

let nextId = 100;
function uid(prefix: string): string {
  return `${prefix}-${++nextId}`;
}

// ─────────────────────────────────────────────────────────────────────────────
// SUB-COMPONENTS
// ─────────────────────────────────────────────────────────────────────────────

function LivePulse() {
  return (
    <div className="flex items-center gap-2">
      <span className="relative flex h-2.5 w-2.5">
        <span className="absolute inline-flex h-full w-full animate-ping rounded-full bg-green-400 opacity-75" />
        <span className="relative inline-flex h-2.5 w-2.5 rounded-full bg-green-500" />
      </span>
      <span className="text-[10px] font-semibold uppercase tracking-widest text-green-400">
        Live
      </span>
    </div>
  );
}

function CommandFeedEntry({
  entry,
  index,
}: { entry: CommandEntry; index: number }) {
  const sourceIcon = {
    extension: <Monitor className="h-3.5 w-3.5" />,
    chat: <MessageSquare className="h-3.5 w-3.5" />,
    canister: <Cloud className="h-3.5 w-3.5" />,
    system: <Activity className="h-3.5 w-3.5" />,
  }[entry.source];

  return (
    <motion.div
      initial={{ opacity: 0, x: -12 }}
      animate={{ opacity: 1, x: 0 }}
      transition={{ duration: 0.2, delay: index * 0.03 }}
      className="flex items-start gap-3 rounded-lg border border-slate-700/50 bg-slate-800/50 p-3 hover:border-slate-600/60 transition-colors"
    >
      <div className="mt-0.5 text-slate-400">{sourceIcon}</div>
      <div className="flex-1 min-w-0">
        <div className="flex items-center gap-2 mb-1">
          <span className="text-[10px] font-mono text-slate-500">
            {entry.timestamp}
          </span>
          <Badge
            variant="outline"
            className={`text-[9px] px-1.5 py-0 ${SOURCE_STYLES[entry.source]}`}
          >
            {entry.source}
          </Badge>
        </div>
        <p className="text-xs text-slate-200 leading-relaxed truncate">
          {entry.command}
        </p>
      </div>
      <Badge
        variant="outline"
        className={`text-[9px] px-1.5 py-0 shrink-0 ${STATUS_STYLES[entry.status]}`}
      >
        {entry.status}
      </Badge>
    </motion.div>
  );
}

function ChatBubble({ message }: { message: ChatMessage }) {
  const isJarvis = message.sender === "jarvis";
  return (
    <div className={`flex gap-3 ${isJarvis ? "" : "flex-row-reverse"}`}>
      <div
        className={`flex h-7 w-7 shrink-0 items-center justify-center rounded-full text-xs font-bold ${
          isJarvis
            ? "bg-cyan-500/20 text-cyan-400 border border-cyan-500/40"
            : "bg-purple-500/20 text-purple-400 border border-purple-500/40"
        }`}
      >
        {isJarvis ? "J" : "A"}
      </div>
      <div className={`max-w-[75%] ${isJarvis ? "" : "text-right"}`}>
        <div
          className={`rounded-lg px-3 py-2 text-xs leading-relaxed ${
            isJarvis
              ? "bg-slate-800/80 text-slate-200 border border-slate-700/50"
              : "bg-cyan-600/20 text-cyan-100 border border-cyan-500/30"
          }`}
        >
          <p className="whitespace-pre-wrap">{message.text}</p>
        </div>
        <span className="text-[10px] text-slate-500 mt-1 inline-block">
          {message.timestamp}
        </span>
      </div>
    </div>
  );
}

function NoteCard({
  note,
  index,
  onDelete,
}: {
  note: Note;
  index: number;
  onDelete: (id: string) => void;
}) {
  return (
    <motion.div
      initial={{ opacity: 0, y: 10 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.2, delay: index * 0.04 }}
    >
      <Card className="bg-slate-800/50 border-slate-700/50 hover:border-cyan-500/30 transition-colors">
        <CardHeader className="p-3 pb-1">
          <div className="flex items-start justify-between">
            <CardTitle className="text-sm text-slate-100 leading-tight">
              {note.title}
            </CardTitle>
            <div className="flex gap-1 shrink-0 ml-2">
              <Button
                variant="ghost"
                size="icon"
                className="h-6 w-6 text-slate-500 hover:text-cyan-400"
              >
                <Edit3 className="h-3 w-3" />
              </Button>
              <Button
                variant="ghost"
                size="icon"
                className="h-6 w-6 text-slate-500 hover:text-red-400"
                onClick={() => onDelete(note.id)}
              >
                <Trash2 className="h-3 w-3" />
              </Button>
            </div>
          </div>
        </CardHeader>
        <CardContent className="p-3 pt-0">
          <p className="text-[11px] text-slate-400 leading-relaxed line-clamp-2 mb-2">
            {note.preview}
          </p>
          <div className="flex items-center justify-between">
            <div className="flex gap-1 flex-wrap">
              {note.tags.map((tag) => (
                <Badge
                  key={tag}
                  variant="outline"
                  className="text-[9px] px-1.5 py-0 bg-cyan-500/10 text-cyan-400 border-cyan-500/30"
                >
                  {tag}
                </Badge>
              ))}
            </div>
            <span className="text-[10px] text-slate-500 shrink-0">
              {note.timestamp}
            </span>
          </div>
        </CardContent>
      </Card>
    </motion.div>
  );
}

function DocumentCard({ doc, index }: { doc: Document; index: number }) {
  return (
    <motion.div
      initial={{ opacity: 0, y: 10 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.2, delay: index * 0.04 }}
    >
      <Card className="bg-slate-800/50 border-slate-700/50 hover:border-cyan-500/30 transition-colors">
        <CardContent className="p-3">
          <div className="flex items-start gap-3">
            <div className="flex h-9 w-9 shrink-0 items-center justify-center rounded-lg bg-slate-700/60 text-slate-300">
              <FileText className="h-4 w-4" />
            </div>
            <div className="flex-1 min-w-0">
              <p className="text-sm text-slate-100 font-medium truncate">
                {doc.title}
              </p>
              <div className="flex items-center gap-2 mt-1">
                <Badge
                  variant="outline"
                  className={`text-[9px] px-1.5 py-0 ${DOC_TYPE_STYLES[doc.type]}`}
                >
                  {doc.type}
                </Badge>
                <span className="text-[10px] text-slate-500">{doc.size}</span>
                <span className="text-[10px] text-slate-500">
                  {doc.timestamp}
                </span>
              </div>
            </div>
            <Button
              variant="ghost"
              size="icon"
              className="h-7 w-7 text-slate-500 hover:text-cyan-400 shrink-0"
            >
              <Download className="h-3.5 w-3.5" />
            </Button>
          </div>
        </CardContent>
      </Card>
    </motion.div>
  );
}

function QRCodePlaceholder() {
  const cells = Array.from({ length: 49 }, (_, i) => {
    const row = Math.floor(i / 7);
    const col = i % 7;
    const isCorner =
      (row < 2 && col < 2) || (row < 2 && col > 4) || (row > 4 && col < 2);
    const isCenter = row === 3 && col === 3;
    const filled = isCorner || isCenter || Math.random() > 0.55;
    return filled;
  });

  return (
    <div className="flex flex-col items-center gap-3">
      <div className="rounded-xl border-2 border-dashed border-cyan-500/40 bg-slate-800/80 p-4">
        <div className="grid grid-cols-7 gap-0.5 w-[84px] h-[84px]">
          {cells.map((filled, i) => (
            <div
              key={`qr-${i}-${filled ? "f" : "e"}`}
              className={`rounded-[1px] ${filled ? "bg-cyan-400" : "bg-slate-700/60"}`}
            />
          ))}
        </div>
      </div>
      <div className="flex items-center gap-1.5 text-cyan-400">
        <QrCode className="h-3 w-3" />
        <span className="text-[10px] font-medium uppercase tracking-wider">
          Scan to Install
        </span>
      </div>
    </div>
  );
}

function StatusDot({ online }: { online: boolean }) {
  return online ? (
    <span className="relative flex h-2 w-2">
      <span className="absolute inline-flex h-full w-full animate-ping rounded-full bg-green-400 opacity-75" />
      <span className="relative inline-flex h-2 w-2 rounded-full bg-green-500" />
    </span>
  ) : (
    <span className="inline-flex h-2 w-2 rounded-full bg-slate-500" />
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// MAIN COMPONENT
// ─────────────────────────────────────────────────────────────────────────────

export function JarvisCommandCenter() {
  const [activeTab, setActiveTab] = useState("feed");
  const [commands, setCommands] = useState<CommandEntry[]>(INITIAL_COMMANDS);
  const [messages, setMessages] = useState<ChatMessage[]>(INITIAL_MESSAGES);
  const [notes, setNotes] = useState<Note[]>(INITIAL_NOTES);
  const [documents] = useState<Document[]>(INITIAL_DOCUMENTS);
  const [chatInput, setChatInput] = useState("");
  const [isOnline] = useState(true);
  const [heartbeatCount] = useState(4217);

  // Note form state
  const [noteTitle, setNoteTitle] = useState("");
  const [noteContent, setNoteContent] = useState("");

  const handleSendMessage = useCallback(() => {
    const text = chatInput.trim();
    if (!text) return;

    const ts = currentTime();
    const userMsg: ChatMessage = {
      id: uid("msg"),
      sender: "user",
      text,
      timestamp: ts,
    };
    const jarvisReply: ChatMessage = {
      id: uid("msg"),
      sender: "jarvis",
      text: processJarvisCommand(text),
      timestamp: ts,
    };

    setMessages((prev) => [...prev, userMsg, jarvisReply]);

    const newCmd: CommandEntry = {
      id: uid("cmd"),
      timestamp: ts,
      source: "chat",
      command: text,
      status: "success",
    };
    setCommands((prev) => [newCmd, ...prev]);

    setChatInput("");
  }, [chatInput]);

  const handleAddNote = useCallback(() => {
    if (!noteTitle.trim()) return;
    const newNote: Note = {
      id: uid("n"),
      title: noteTitle.trim(),
      preview: noteContent.trim() || "No content yet...",
      timestamp: new Date().toLocaleDateString("en-US", {
        month: "short",
        day: "numeric",
        year: "numeric",
      }),
      tags: ["new"],
    };
    setNotes((prev) => [newNote, ...prev]);
    setNoteTitle("");
    setNoteContent("");
  }, [noteTitle, noteContent]);

  const handleDeleteNote = useCallback((id: string) => {
    setNotes((prev) => prev.filter((n) => n.id !== id));
  }, []);

  return (
    <div className="flex h-full flex-col bg-slate-900 text-slate-100">
      {/* ── HEADER ── */}
      <div className="flex items-center justify-between border-b border-slate-800 px-5 py-3">
        <div className="flex items-center gap-3">
          <div className="flex h-9 w-9 items-center justify-center rounded-lg bg-cyan-500/15 border border-cyan-500/30">
            <Bot className="h-5 w-5 text-cyan-400" />
          </div>
          <div>
            <h1 className="text-base font-bold tracking-tight">
              <span className="text-cyan-400">MERIDIANUS</span>
            </h1>
            <p className="text-[11px] text-slate-400">
              Sovereign AGI Product — Per aspera ad astra
            </p>
          </div>
        </div>
        <div className="flex items-center gap-3">
          <div className="flex items-center gap-2">
            <StatusDot online={isOnline} />
            <span className="text-[10px] text-slate-400">
              {isOnline ? "Connected" : "Offline"}
            </span>
          </div>
          <Badge
            variant="outline"
            className="text-[9px] px-2 py-0 bg-cyan-500/10 text-cyan-400 border-cyan-500/30"
          >
            v3.1.0-alpha
          </Badge>
        </div>
      </div>

      {/* ── TABS ── */}
      <Tabs
        value={activeTab}
        onValueChange={setActiveTab}
        className="flex-1 flex flex-col min-h-0"
      >
        <TabsList className="mx-5 mt-3 bg-slate-800/60 border border-slate-700/50 justify-start w-auto">
          <TabsTrigger
            value="feed"
            className="text-xs gap-1.5 data-[state=active]:bg-cyan-500/15 data-[state=active]:text-cyan-400"
          >
            <Terminal className="h-3.5 w-3.5" />
            Command Feed
          </TabsTrigger>
          <TabsTrigger
            value="chat"
            className="text-xs gap-1.5 data-[state=active]:bg-cyan-500/15 data-[state=active]:text-cyan-400"
          >
            <MessageSquare className="h-3.5 w-3.5" />
            Chat
          </TabsTrigger>
          <TabsTrigger
            value="notes"
            className="text-xs gap-1.5 data-[state=active]:bg-cyan-500/15 data-[state=active]:text-cyan-400"
          >
            <StickyNote className="h-3.5 w-3.5" />
            Notes
          </TabsTrigger>
          <TabsTrigger
            value="documents"
            className="text-xs gap-1.5 data-[state=active]:bg-cyan-500/15 data-[state=active]:text-cyan-400"
          >
            <FileText className="h-3.5 w-3.5" />
            Documents
          </TabsTrigger>
          <TabsTrigger
            value="system"
            className="text-xs gap-1.5 data-[state=active]:bg-cyan-500/15 data-[state=active]:text-cyan-400"
          >
            <Activity className="h-3.5 w-3.5" />
            System
          </TabsTrigger>
        </TabsList>

        {/* ── TAB 1: COMMAND FEED ── */}
        <TabsContent value="feed" className="flex-1 min-h-0 px-5 pb-4 mt-3">
          <div className="flex flex-col h-full gap-3">
            <div className="flex items-center justify-between">
              <LivePulse />
              <span className="text-[10px] text-slate-500 font-mono">
                {commands.length} commands logged
              </span>
            </div>
            <ScrollArea className="flex-1 rounded-lg border border-slate-700/50 bg-slate-800/30 p-3">
              <div className="space-y-2">
                {commands.map((cmd, i) => (
                  <CommandFeedEntry key={cmd.id} entry={cmd} index={i} />
                ))}
              </div>
            </ScrollArea>
          </div>
        </TabsContent>

        {/* ── TAB 2: CHAT ── */}
        <TabsContent value="chat" className="flex-1 min-h-0 px-5 pb-4 mt-3">
          <div className="flex flex-col h-full gap-3">
            <ScrollArea className="flex-1 rounded-lg border border-slate-700/50 bg-slate-800/30 p-4">
              <div className="space-y-4">
                {messages.map((msg) => (
                  <ChatBubble key={msg.id} message={msg} />
                ))}
              </div>
            </ScrollArea>
            <div className="flex gap-2">
              <Input
                value={chatInput}
                onChange={(e) => setChatInput(e.target.value)}
                onKeyDown={(e) => e.key === "Enter" && handleSendMessage()}
                placeholder="Issue a command to MERIDIANUS..."
                className="bg-slate-800/60 border-slate-700/50 text-sm text-slate-200 placeholder:text-slate-500 focus-visible:ring-cyan-500/40"
              />
              <Button
                onClick={handleSendMessage}
                disabled={!chatInput.trim()}
                className="bg-cyan-600 hover:bg-cyan-500 text-white px-4 disabled:bg-slate-700 disabled:text-slate-500"
              >
                <Send className="h-4 w-4" />
              </Button>
            </div>
          </div>
        </TabsContent>

        {/* ── TAB 3: NOTES ── */}
        <TabsContent value="notes" className="flex-1 min-h-0 px-5 pb-4 mt-3">
          <div className="flex flex-col h-full gap-3">
            {/* Add note form */}
            <Card className="bg-slate-800/50 border-slate-700/50">
              <CardContent className="p-3">
                <div className="flex gap-2">
                  <Input
                    value={noteTitle}
                    onChange={(e) => setNoteTitle(e.target.value)}
                    placeholder="Note title..."
                    className="bg-slate-900/60 border-slate-700/50 text-sm text-slate-200 placeholder:text-slate-500 focus-visible:ring-cyan-500/40"
                  />
                  <Input
                    value={noteContent}
                    onChange={(e) => setNoteContent(e.target.value)}
                    placeholder="Content preview..."
                    className="bg-slate-900/60 border-slate-700/50 text-sm text-slate-200 placeholder:text-slate-500 focus-visible:ring-cyan-500/40"
                  />
                  <Button
                    onClick={handleAddNote}
                    disabled={!noteTitle.trim()}
                    className="bg-cyan-600 hover:bg-cyan-500 text-white px-3 disabled:bg-slate-700 disabled:text-slate-500 shrink-0"
                  >
                    <Plus className="h-4 w-4 mr-1" />
                    Add
                  </Button>
                </div>
              </CardContent>
            </Card>
            <ScrollArea className="flex-1">
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                {notes.map((note, i) => (
                  <NoteCard
                    key={note.id}
                    note={note}
                    index={i}
                    onDelete={handleDeleteNote}
                  />
                ))}
              </div>
            </ScrollArea>
          </div>
        </TabsContent>

        {/* ── TAB 4: DOCUMENTS ── */}
        <TabsContent
          value="documents"
          className="flex-1 min-h-0 px-5 pb-4 mt-3"
        >
          <ScrollArea className="h-full">
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
              {documents.map((doc, i) => (
                <DocumentCard key={doc.id} doc={doc} index={i} />
              ))}
            </div>
          </ScrollArea>
        </TabsContent>

        {/* ── TAB 5: SYSTEM ── */}
        <TabsContent value="system" className="flex-1 min-h-0 px-5 pb-4 mt-3">
          <ScrollArea className="h-full">
            <div className="space-y-5">
              {/* Connection & Canister */}
              <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
                <Card className="bg-slate-800/50 border-slate-700/50">
                  <CardContent className="p-3 flex items-center gap-3">
                    <div className="flex h-9 w-9 items-center justify-center rounded-lg bg-green-500/15 border border-green-500/30">
                      <Wifi className="h-4 w-4 text-green-400" />
                    </div>
                    <div>
                      <p className="text-[10px] uppercase tracking-wider text-slate-500">
                        Connection
                      </p>
                      <p className="text-sm font-semibold text-green-400">
                        {isOnline ? "Online" : "Offline"}
                      </p>
                    </div>
                  </CardContent>
                </Card>
                <Card className="bg-slate-800/50 border-slate-700/50">
                  <CardContent className="p-3 flex items-center gap-3">
                    <div className="flex h-9 w-9 items-center justify-center rounded-lg bg-cyan-500/15 border border-cyan-500/30">
                      <Globe className="h-4 w-4 text-cyan-400" />
                    </div>
                    <div>
                      <p className="text-[10px] uppercase tracking-wider text-slate-500">
                        Canister ID
                      </p>
                      <p className="text-xs font-mono text-slate-200 truncate">
                        bkyz2-fmaaa-aaaaa-qaaaq-cai
                      </p>
                    </div>
                  </CardContent>
                </Card>
                <Card className="bg-slate-800/50 border-slate-700/50">
                  <CardContent className="p-3 flex items-center gap-3">
                    <div className="flex h-9 w-9 items-center justify-center rounded-lg bg-purple-500/15 border border-purple-500/30">
                      <Zap className="h-4 w-4 text-purple-400" />
                    </div>
                    <div>
                      <p className="text-[10px] uppercase tracking-wider text-slate-500">
                        Heartbeats
                      </p>
                      <p className="text-sm font-semibold text-purple-400">
                        {heartbeatCount.toLocaleString()}
                      </p>
                    </div>
                  </CardContent>
                </Card>
              </div>

              <Separator className="bg-slate-700/50" />

              {/* Extension Install */}
              <Card className="bg-slate-800/50 border-slate-700/50">
                <CardHeader className="p-4 pb-2">
                  <CardTitle className="text-sm text-slate-100 flex items-center gap-2">
                    <Upload className="h-4 w-4 text-cyan-400" />
                    MERIDIANUS Chrome Extension
                  </CardTitle>
                  <CardDescription className="text-[11px] text-slate-400">
                    Install the browser extension to enable tab control, screen
                    capture, and full MERIDIANUS integration.
                  </CardDescription>
                </CardHeader>
                <CardContent className="p-4 pt-2">
                  <div className="flex flex-col sm:flex-row items-center gap-6">
                    <QRCodePlaceholder />
                    <div className="flex-1 space-y-3">
                      <Button className="w-full bg-cyan-600 hover:bg-cyan-500 text-white text-sm gap-2">
                        <Download className="h-4 w-4" />
                        Install Extension
                      </Button>
                      <div className="space-y-1.5">
                        <p className="text-[11px] text-slate-400 flex items-center gap-1.5">
                          <CheckCircle2 className="h-3 w-3 text-green-400" />
                          Chrome / Brave / Edge compatible
                        </p>
                        <p className="text-[11px] text-slate-400 flex items-center gap-1.5">
                          <CheckCircle2 className="h-3 w-3 text-green-400" />
                          Manifest v3 — privacy-first design
                        </p>
                        <p className="text-[11px] text-slate-400 flex items-center gap-1.5">
                          <CheckCircle2 className="h-3 w-3 text-green-400" />
                          Auto-connects to MERIDIAN canister
                        </p>
                      </div>
                    </div>
                  </div>
                </CardContent>
              </Card>

              <Separator className="bg-slate-700/50" />

              {/* Alpha Script AIs */}
              <Card className="bg-slate-800/50 border-slate-700/50">
                <CardHeader className="p-4 pb-2">
                  <div className="flex items-center justify-between">
                    <CardTitle className="text-sm text-slate-100 flex items-center gap-2">
                      <Zap className="h-4 w-4 text-cyan-400" />
                      Alpha Script AIs
                    </CardTitle>
                    <Badge
                      variant="outline"
                      className="text-[9px] px-2 py-0 bg-green-500/10 text-green-400 border-green-500/30"
                    >
                      {ALPHA_AIS.filter((a) => a.online).length}/
                      {ALPHA_AIS.length} online
                    </Badge>
                  </div>
                </CardHeader>
                <CardContent className="p-4 pt-2">
                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-2">
                    {ALPHA_AIS.map((ai) => (
                      <div
                        key={ai.name}
                        className="flex items-center gap-2.5 rounded-md border border-slate-700/50 bg-slate-900/50 px-3 py-2"
                      >
                        <StatusDot online={ai.online} />
                        <div className="flex-1 min-w-0">
                          <p className="text-xs font-semibold text-slate-200">
                            {ai.name}
                          </p>
                          <p className="text-[10px] text-slate-500 truncate">
                            {ai.role}
                          </p>
                        </div>
                      </div>
                    ))}
                  </div>
                </CardContent>
              </Card>

              {/* Uptime */}
              <Card className="bg-slate-800/50 border-slate-700/50">
                <CardContent className="p-4 flex items-center gap-3">
                  <div className="flex h-9 w-9 items-center justify-center rounded-lg bg-cyan-500/15 border border-cyan-500/30">
                    <Clock className="h-4 w-4 text-cyan-400" />
                  </div>
                  <div className="flex-1">
                    <p className="text-[10px] uppercase tracking-wider text-slate-500">
                      System Uptime
                    </p>
                    <p className="text-sm font-semibold text-slate-200">
                      14d 7h 32m 18s
                    </p>
                  </div>
                  <Progress value={92} className="w-24 h-1.5" />
                  <span className="text-[10px] text-cyan-400 font-mono">
                    99.97%
                  </span>
                </CardContent>
              </Card>
            </div>
          </ScrollArea>
        </TabsContent>
      </Tabs>
    </div>
  );
}

export default JarvisCommandCenter;
