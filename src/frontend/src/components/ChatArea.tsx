import { Badge } from "@/components/ui/badge";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { ScrollArea } from "@/components/ui/scroll-area";
import {
  BarChart3,
  Brain,
  ChevronDown,
  Code2,
  FileText,
  Menu,
  PanelRight,
  Paperclip,
  Search,
  Send,
  Zap,
} from "lucide-react";
import { AnimatePresence, motion } from "motion/react";
import { useEffect, useRef, useState } from "react";
import type { AgentTask, Message, Thread } from "../data/mockData";
import { MODELS } from "../data/mockData";
import type { MockOrganism } from "../data/organisms";

interface ChatAreaProps {
  thread: Thread;
  onSendMessage: (content: string) => void;
  onWorkflowAction: (action: string) => AgentTask;
  searchQuery: string;
  onSearchChange: (q: string) => void;
  onMenuClick?: () => void;
  onRailClick?: () => void;
  organisms?: MockOrganism[];
  activeOrganismId?: string;
  onOrganismChange?: (id: string) => void;
}

const ACTION_CHIPS = [
  { id: "attach", icon: Paperclip, label: "Attach" },
  { id: "code", icon: Code2, label: "Code" },
  { id: "doc", icon: FileText, label: "Doc" },
  { id: "cognition", icon: Brain, label: "Cognition" },
];

const WORKFLOW_BUTTONS = [
  { id: "execute", icon: Zap, label: "Execute Plan" },
  { id: "report", icon: BarChart3, label: "Create Report" },
  { id: "analyze", icon: Search, label: "Deep Analyze" },
];

/** Full-width stacked message row — no chat bubbles */
function MessageRow({ msg }: { msg: Message }) {
  const isUser = msg.role === "user";
  const initials = isUser
    ? "U"
    : (msg.modelName?.slice(0, 2).toUpperCase() ?? "AI");

  return (
    <motion.div
      initial={{ opacity: 0, y: 6 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.2 }}
      className={`group px-3 py-4 rounded-xl transition-colors ${
        isUser
          ? "bg-surface-elevated/40 hover:bg-surface-elevated/60"
          : "hover:bg-surface/60"
      }`}
    >
      <div className="flex items-start gap-3">
        {/* Avatar */}
        <div
          className={`w-7 h-7 rounded-md shrink-0 flex items-center justify-center text-[10px] font-bold mt-0.5 ${
            isUser
              ? "bg-surface-elevated border border-border text-muted-foreground"
              : "bg-primary/15 text-primary border border-primary/20"
          }`}
        >
          {initials}
        </div>

        {/* Content */}
        <div className="flex-1 min-w-0">
          {/* Sender row */}
          <div className="flex items-baseline gap-2 mb-1.5">
            <span className="text-xs font-semibold text-foreground">
              {isUser ? "You" : (msg.modelName ?? "Organism")}
            </span>
            {!isUser && msg.modelName && (
              <Badge
                variant="secondary"
                className="text-[10px] px-1.5 py-0 h-4 bg-primary/10 text-primary border-0 font-medium leading-none"
              >
                organism
              </Badge>
            )}
            <span className="text-[11px] text-muted-foreground/50 ml-auto">
              {msg.timestamp.toLocaleTimeString([], {
                hour: "2-digit",
                minute: "2-digit",
              })}
            </span>
          </div>

          {/* Message text */}
          <p className="text-sm text-foreground/90 leading-relaxed whitespace-pre-wrap">
            {msg.content}
          </p>
        </div>
      </div>
    </motion.div>
  );
}

export function ChatArea({
  thread,
  onSendMessage,
  onWorkflowAction,
  searchQuery: _searchQuery,
  onSearchChange: _onSearchChange,
  onMenuClick,
  onRailClick,
}: ChatAreaProps) {
  const [input, setInput] = useState("");
  const [activeChips, setActiveChips] = useState<Set<string>>(new Set());
  const [selectedModel, setSelectedModel] = useState(MODELS[0].name);
  const [isTyping, setIsTyping] = useState(false);
  const bottomRef = useRef<HTMLDivElement>(null);
  const msgCount = thread.messages.length;

  // biome-ignore lint/correctness/useExhaustiveDependencies: scroll on new messages or typing
  useEffect(() => {
    bottomRef.current?.scrollIntoView({ behavior: "smooth" });
  }, [msgCount, isTyping]);

  const handleSend = () => {
    const text = input.trim();
    if (!text) return;
    setInput("");
    setIsTyping(true);
    onSendMessage(text);
    setTimeout(() => setIsTyping(false), 1600);
  };

  const toggleChip = (id: string) => {
    setActiveChips((prev) => {
      const next = new Set(prev);
      if (next.has(id)) next.delete(id);
      else next.add(id);
      return next;
    });
  };

  return (
    <main className="flex-1 min-w-0 flex flex-col h-full overflow-hidden">
      {/* Chat header */}
      <div className="px-4 lg:px-6 py-3 lg:py-3.5 border-b border-border flex items-center gap-3 lg:gap-4 shrink-0 bg-background/80 backdrop-blur-sm">
        {/* Hamburger — mobile/tablet only */}
        {onMenuClick && (
          <button
            type="button"
            data-ocid="nav.menu.button"
            onClick={onMenuClick}
            className="w-9 h-9 flex items-center justify-center rounded-lg text-muted-foreground hover:text-foreground hover:bg-surface-elevated transition-colors touch-manipulation lg:hidden shrink-0"
            aria-label="Open navigation"
          >
            <Menu className="w-4 h-4" />
          </button>
        )}

        <div className="flex-1 min-w-0">
          <h1 className="text-sm font-semibold text-foreground truncate">
            {thread.title}
          </h1>
          <div className="hidden sm:flex items-center gap-1.5 mt-0.5">
            <span className="w-1.5 h-1.5 rounded-full bg-success animate-pulse" />
            <span className="text-[11px] text-muted-foreground">
              Active session
            </span>
          </div>
        </div>

        {/* Model selector — hidden on very small screens */}
        <DropdownMenu>
          <DropdownMenuTrigger asChild>
            <button
              type="button"
              data-ocid="model.select"
              className="hidden sm:flex items-center gap-1.5 px-2.5 py-1.5 rounded-lg border border-border bg-surface-elevated text-[11px] text-foreground hover:border-border-strong transition-colors"
            >
              <span className="w-1.5 h-1.5 rounded-full bg-primary shrink-0" />
              <span className="text-muted-foreground font-medium max-w-[80px] truncate">
                {selectedModel}
              </span>
              <ChevronDown className="w-3 h-3 text-muted-foreground" />
            </button>
          </DropdownMenuTrigger>
          <DropdownMenuContent
            className="bg-surface border-border min-w-[200px]"
            align="end"
          >
            {MODELS.map((m) => (
              <DropdownMenuItem
                key={m.id}
                onClick={() => setSelectedModel(m.name)}
                className={`text-xs cursor-pointer ${
                  m.name === selectedModel
                    ? "text-primary"
                    : "text-muted-foreground"
                }`}
              >
                <span className="mr-2">{m.icon}</span>
                {m.name}
              </DropdownMenuItem>
            ))}
          </DropdownMenuContent>
        </DropdownMenu>

        {/* Right rail toggle — mobile/tablet only */}
        {onRailClick && (
          <button
            type="button"
            data-ocid="nav.rail.button"
            onClick={onRailClick}
            className="w-9 h-9 flex items-center justify-center rounded-lg text-muted-foreground hover:text-foreground hover:bg-surface-elevated transition-colors touch-manipulation lg:hidden shrink-0"
            aria-label="Open tasks & artifacts"
          >
            <PanelRight className="w-4 h-4" />
          </button>
        )}
      </div>

      {/* Messages — full-width prose rows, no bubbles */}
      <ScrollArea className="flex-1">
        <div className="px-3 sm:px-4 py-4 space-y-1 max-w-3xl mx-auto w-full">
          <AnimatePresence initial={false}>
            {thread.messages.map((msg) => (
              <MessageRow key={msg.id} msg={msg} />
            ))}
          </AnimatePresence>

          {/* Typing indicator */}
          {isTyping && (
            <motion.div
              initial={{ opacity: 0, y: 4 }}
              animate={{ opacity: 1, y: 0 }}
              exit={{ opacity: 0 }}
              className="px-3 py-4"
            >
              <div className="flex items-start gap-3">
                <div className="w-7 h-7 rounded-md bg-primary/15 border border-primary/20 flex items-center justify-center text-[10px] font-bold text-primary mt-0.5">
                  OC
                </div>
                <div className="flex items-center gap-1 pt-2">
                  <span className="typing-dot" />
                  <span className="typing-dot" />
                  <span className="typing-dot" />
                </div>
              </div>
            </motion.div>
          )}
          <div ref={bottomRef} />
        </div>
      </ScrollArea>

      {/* Composer */}
      <div className="px-3 sm:px-6 py-3 sm:py-4 border-t border-border shrink-0">
        <div className="max-w-3xl mx-auto">
          <div className="rounded-xl border border-border bg-surface-elevated overflow-hidden focus-within:border-border-strong focus-within:ring-1 focus-within:ring-primary/20 transition-all">
            {/* Text input */}
            <div className="flex items-end gap-2 px-4 pt-3 pb-2">
              <textarea
                data-ocid="composer.textarea"
                value={input}
                onChange={(e) => setInput(e.target.value)}
                onKeyDown={(e) => {
                  if (e.key === "Enter" && !e.shiftKey) {
                    e.preventDefault();
                    handleSend();
                  }
                }}
                placeholder="Message Organism..."
                rows={2}
                className="flex-1 bg-transparent text-base sm:text-sm text-foreground placeholder:text-muted-foreground/50 resize-none focus:outline-none leading-relaxed"
              />
            </div>

            {/* Composer footer */}
            <div className="flex items-center justify-between px-3 pb-2.5">
              {/* Action chips — scroll on mobile */}
              <div className="flex items-center gap-1 overflow-x-auto">
                {ACTION_CHIPS.map(({ id, icon: Icon, label }) => (
                  <button
                    type="button"
                    key={id}
                    data-ocid={`composer.${id}.toggle`}
                    onClick={() => toggleChip(id)}
                    className={`flex items-center gap-1.5 px-2 py-1.5 rounded-md text-[11px] transition-colors shrink-0 touch-manipulation min-h-[36px] ${
                      activeChips.has(id)
                        ? "bg-primary/15 text-primary"
                        : "text-muted-foreground/60 hover:text-muted-foreground hover:bg-surface-high"
                    }`}
                  >
                    <Icon className="w-3 h-3" />
                    <span>{label}</span>
                  </button>
                ))}
              </div>
              {/* Send button */}
              <button
                type="button"
                data-ocid="composer.submit_button"
                onClick={handleSend}
                className="w-9 h-9 rounded-md bg-primary flex items-center justify-center hover:bg-primary/90 active:scale-95 transition-all touch-manipulation shrink-0"
              >
                <Send className="w-3.5 h-3.5 text-primary-foreground" />
              </button>
            </div>
          </div>

          {/* Workflow buttons — horizontally scrollable on mobile */}
          <div className="flex items-center gap-2 mt-2.5 px-0.5 overflow-x-auto pb-0.5">
            {WORKFLOW_BUTTONS.map(({ id, icon: Icon, label }) => (
              <button
                type="button"
                key={id}
                data-ocid={`workflow.${id}.button`}
                onClick={() => onWorkflowAction(label)}
                className="flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-[11px] text-muted-foreground/70 hover:text-foreground border border-border/60 hover:border-border-strong hover:bg-surface-elevated transition-all shrink-0 touch-manipulation min-h-[36px]"
              >
                <Icon className="w-3 h-3" />
                <span>{label}</span>
              </button>
            ))}
          </div>

          <p className="text-[10px] text-center text-muted-foreground/40 mt-3">
            © {new Date().getFullYear()}. Built with ♥ using{" "}
            <a
              href={`https://caffeine.ai?utm_source=caffeine-footer&utm_medium=referral&utm_content=${encodeURIComponent(window.location.hostname)}`}
              target="_blank"
              rel="noopener noreferrer"
              className="hover:text-primary/70 transition-colors"
            >
              caffeine.ai
            </a>
          </p>
        </div>
      </div>
    </main>
  );
}
