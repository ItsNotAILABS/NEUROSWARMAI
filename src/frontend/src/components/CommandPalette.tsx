import { useEffect, useRef, useState } from "react";
import type { AppSection } from "../App";
import type { MockOrganism } from "../data/organisms";

interface CommandPaletteProps {
  open: boolean;
  onClose: () => void;
  organisms: MockOrganism[];
  onNavigate: (section: AppSection, tab?: string) => void;
}

interface CommandItem {
  id: string;
  label: string;
  category: string;
  action: () => void;
  icon?: string;
}

export function CommandPalette({
  open,
  onClose,
  organisms,
  onNavigate,
}: CommandPaletteProps) {
  const [query, setQuery] = useState("");
  const [selectedIndex, setSelectedIndex] = useState(0);
  const inputRef = useRef<HTMLInputElement>(null);

  const allItems: CommandItem[] = [
    {
      id: "nav-command",
      label: "Command Workspace",
      category: "Navigation",
      action: () => onNavigate("command"),
      icon: ">",
    },
    {
      id: "nav-workforce",
      label: "Organism Workforce",
      category: "Navigation",
      action: () => onNavigate("workforce"),
      icon: ">",
    },
    {
      id: "tab-inventory",
      label: "Inventory",
      category: "Workforce",
      action: () => onNavigate("workforce", "inventory"),
      icon: "#",
    },
    {
      id: "tab-viewer",
      label: "Live Viewer",
      category: "Workforce",
      action: () => onNavigate("workforce", "viewer"),
      icon: "#",
    },
    {
      id: "tab-chat",
      label: "Workforce Chat",
      category: "Workforce",
      action: () => onNavigate("workforce", "chat"),
      icon: "#",
    },
    {
      id: "tab-generator",
      label: "Generator",
      category: "Workforce",
      action: () => onNavigate("workforce", "generator"),
      icon: "#",
    },
    {
      id: "tab-marketplace",
      label: "Marketplace",
      category: "Workforce",
      action: () => onNavigate("workforce", "marketplace"),
      icon: "#",
    },
    ...organisms.slice(0, 8).map((o) => ({
      id: `organism-${o.id}`,
      label: o.name,
      category: `${o.class} · ${o.specializations[0]}`,
      action: () => onNavigate("workforce", "chat"),
      icon: o.class === "Avatar" ? "◈" : o.class === "Entity" ? "◆" : "◇",
    })),
    {
      id: "action-execute",
      label: "Execute Plan",
      category: "Actions",
      action: () => onNavigate("command"),
      icon: "!",
    },
    {
      id: "action-report",
      label: "Create Report",
      category: "Actions",
      action: () => onNavigate("command"),
      icon: "!",
    },
    {
      id: "action-analyze",
      label: "Deep Analyze",
      category: "Actions",
      action: () => onNavigate("command"),
      icon: "!",
    },
  ];

  const filtered = query.trim()
    ? allItems.filter(
        (item) =>
          item.label.toLowerCase().includes(query.toLowerCase()) ||
          item.category.toLowerCase().includes(query.toLowerCase()),
      )
    : allItems;

  // Reset selection when query changes (derived from query, not an effect)
  const [prevQuery, setPrevQuery] = useState("");
  if (query !== prevQuery) {
    setPrevQuery(query);
    setSelectedIndex(0);
  }

  useEffect(() => {
    if (open) {
      setQuery("");
      setSelectedIndex(0);
      setTimeout(() => inputRef.current?.focus(), 50);
    }
  }, [open]);

  useEffect(() => {
    if (!open) return;
    function handleKey(e: KeyboardEvent) {
      if (e.key === "Escape") {
        onClose();
      } else if (e.key === "ArrowDown") {
        e.preventDefault();
        setSelectedIndex((i) => Math.min(i + 1, filtered.length - 1));
      } else if (e.key === "ArrowUp") {
        e.preventDefault();
        setSelectedIndex((i) => Math.max(i - 1, 0));
      } else if (e.key === "Enter") {
        e.preventDefault();
        const item = filtered[selectedIndex];
        if (item) {
          item.action();
          onClose();
        }
      }
    }
    window.addEventListener("keydown", handleKey);
    return () => window.removeEventListener("keydown", handleKey);
  }, [open, filtered, selectedIndex, onClose]);

  if (!open) return null;

  // Group by category
  const groups: Record<string, CommandItem[]> = {};
  for (const item of filtered) {
    if (!groups[item.category]) groups[item.category] = [];
    groups[item.category].push(item);
  }

  let runningIndex = 0;

  return (
    // biome-ignore lint/a11y/useKeyWithClickEvents: keyboard is handled globally via window listener
    <div
      data-ocid="command_palette.modal"
      className="fixed inset-0 z-50 flex items-start justify-center pt-24"
      onClick={onClose}
    >
      {/* Backdrop */}
      <div className="absolute inset-0 bg-black/60 backdrop-blur-sm" />

      {/* Panel */}
      {/* biome-ignore lint/a11y/useKeyWithClickEvents: stop propagation only */}
      <div
        className="relative w-full max-w-lg mx-4 bg-surface border border-border rounded-xl shadow-2xl overflow-hidden"
        onClick={(e) => e.stopPropagation()}
        style={{
          boxShadow:
            "0 0 60px oklch(62% 0.145 165 / 0.08), 0 32px 64px rgba(0,0,0,0.6)",
        }}
      >
        {/* Search input */}
        <div className="flex items-center gap-3 px-4 py-3 border-b border-border">
          <span className="text-muted-foreground/40 text-sm font-mono">›</span>
          <input
            ref={inputRef}
            data-ocid="command_palette.search_input"
            value={query}
            onChange={(e) => setQuery(e.target.value)}
            placeholder="Search commands, organisms, actions..."
            className="flex-1 bg-transparent text-sm text-foreground placeholder:text-muted-foreground/40 outline-none"
          />
          <kbd className="text-[10px] text-muted-foreground/30 border border-border rounded px-1.5 py-0.5 font-mono">
            ESC
          </kbd>
        </div>

        {/* Results */}
        <div className="max-h-80 overflow-y-auto py-1">
          {filtered.length === 0 ? (
            <div className="px-4 py-8 text-center text-xs text-muted-foreground/40">
              No results for &ldquo;{query}&rdquo;
            </div>
          ) : (
            Object.entries(groups).map(([category, items]) => (
              <div key={category}>
                <div className="px-4 py-1.5">
                  <span className="text-[10px] uppercase tracking-widest text-muted-foreground/30 font-semibold">
                    {category}
                  </span>
                </div>
                {items.map((item) => {
                  const itemIndex = runningIndex++;
                  const isSelected = itemIndex === selectedIndex;
                  return (
                    <button
                      key={item.id}
                      type="button"
                      data-ocid="command_palette.button"
                      onClick={() => {
                        item.action();
                        onClose();
                      }}
                      onMouseEnter={() => setSelectedIndex(itemIndex)}
                      className={`w-full flex items-center gap-3 px-4 py-2.5 text-left transition-colors ${
                        isSelected
                          ? "bg-primary/10 text-foreground"
                          : "text-muted-foreground hover:bg-surface-elevated/50"
                      }`}
                    >
                      <span
                        className={`text-[11px] font-mono w-3 shrink-0 ${isSelected ? "text-primary" : "text-muted-foreground/30"}`}
                      >
                        {item.icon}
                      </span>
                      <span
                        className={`text-sm font-medium flex-1 ${isSelected ? "text-foreground" : ""}`}
                      >
                        {item.label}
                      </span>
                      {isSelected && (
                        <kbd className="text-[10px] text-muted-foreground/40 border border-border/50 rounded px-1.5 py-0.5 font-mono">
                          ↵
                        </kbd>
                      )}
                    </button>
                  );
                })}
              </div>
            ))
          )}
        </div>

        {/* Footer hint */}
        <div className="px-4 py-2 border-t border-border flex items-center gap-4">
          <div className="flex items-center gap-1.5">
            <kbd className="text-[9px] text-muted-foreground/30 border border-border/50 rounded px-1 py-0.5 font-mono">
              ↑↓
            </kbd>
            <span className="text-[10px] text-muted-foreground/30">
              navigate
            </span>
          </div>
          <div className="flex items-center gap-1.5">
            <kbd className="text-[9px] text-muted-foreground/30 border border-border/50 rounded px-1 py-0.5 font-mono">
              ↵
            </kbd>
            <span className="text-[10px] text-muted-foreground/30">select</span>
          </div>
          <div className="flex items-center gap-1.5">
            <kbd className="text-[9px] text-muted-foreground/30 border border-border/50 rounded px-1 py-0.5 font-mono">
              esc
            </kbd>
            <span className="text-[10px] text-muted-foreground/30">close</span>
          </div>
        </div>
      </div>
    </div>
  );
}
