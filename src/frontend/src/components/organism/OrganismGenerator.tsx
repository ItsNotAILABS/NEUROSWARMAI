import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Progress } from "@/components/ui/progress";
import { ScrollArea } from "@/components/ui/scroll-area";
import {
  CheckCircle2,
  Cpu,
  Database,
  Loader2,
  Sparkles,
  User,
  Zap,
} from "lucide-react";
import { useState } from "react";
import { toast } from "sonner";
import { SPECIALIZATION_LIST, fnv1a } from "../../data/organisms";
import { useActor } from "../../hooks/useActor";

type OrgClass = "Avatar" | "Entity" | "Worker";

const CLASS_INFO = {
  Avatar: {
    icon: User,
    label: "Avatar",
    desc: "Your sovereign face. Represents you in communications and executive output. Personal AI identity layer.",
    color: "border-amber-500/30 text-amber-400",
    activeBg: "bg-amber-500/10 border-amber-500/50",
  },
  Entity: {
    icon: Cpu,
    label: "Entity",
    desc: "Deep domain specialist. Knows one domain better than any generalist. Enterprise-grade output on demand.",
    color: "border-primary/30 text-primary",
    activeBg: "bg-primary/10 border-primary/50",
  },
  Worker: {
    icon: Zap,
    label: "Worker",
    desc: "Pure task executor. Fast. No strategy overhead. Receives input, delivers complete output immediately.",
    color: "border-slate-500/30 text-slate-400",
    activeBg: "bg-slate-500/10 border-slate-500/50",
  },
} as const;

function classBadgeStyle(c: OrgClass): string {
  if (c === "Avatar")
    return "bg-amber-500/15 text-amber-400 border-amber-500/30";
  if (c === "Entity") return "bg-primary/15 text-primary border-primary/30";
  return "bg-slate-500/15 text-slate-400 border-slate-500/30";
}

export function OrganismGenerator() {
  const [name, setName] = useState("");
  const [selectedClass, setSelectedClass] = useState<OrgClass>("Entity");
  const [selectedSpecs, setSelectedSpecs] = useState<string[]>([]);
  const [seedPhrase, setSeedPhrase] = useState("");
  const [isGenerating, setIsGenerating] = useState(false);
  const [success, setSuccess] = useState(false);
  const { actor } = useActor();

  const genesisPreview = fnv1a((seedPhrase || name || "organism") + name);

  function toggleSpec(spec: string) {
    setSelectedSpecs((prev) => {
      if (prev.includes(spec)) return prev.filter((s) => s !== spec);
      if (prev.length >= 5) return prev;
      return [...prev, spec];
    });
  }

  async function handleGenerate() {
    if (!name.trim()) {
      toast.error("Organism name is required");
      return;
    }
    if (selectedSpecs.length === 0) {
      toast.error("Select at least one specialization");
      return;
    }

    setIsGenerating(true);
    try {
      if (actor) {
        const classArg =
          selectedClass === "Avatar"
            ? { Avatar: null }
            : selectedClass === "Entity"
              ? { Entity: null }
              : { Worker: null };
        const specsArg = selectedSpecs.map(
          (s) => ({ [s]: null }) as Record<string, null>,
        );
        await (actor as any).generateOrganism(
          name.trim(),
          classArg as any,
          specsArg as any,
          seedPhrase.trim(),
        );
      } else {
        // Mock generation
        await new Promise((r) => setTimeout(r, 2200));
      }
      setSuccess(true);
      toast.success(
        `${name.toUpperCase()} minted on-chain · Genesis: ${genesisPreview}`,
      );
      setTimeout(() => {
        setSuccess(false);
      }, 8000);
    } catch {
      toast.error("Generation failed. Please try again.");
    } finally {
      setIsGenerating(false);
    }
  }

  function handleReset() {
    setSuccess(false);
    setName("");
    setSelectedSpecs([]);
    setSeedPhrase("");
  }

  return (
    <ScrollArea className="flex-1 h-full">
      <div className="max-w-2xl mx-auto p-8 space-y-8">
        {/* Title */}
        <div>
          <div className="flex items-center gap-3 mb-1">
            <Sparkles className="w-5 h-5 text-primary" />
            <h2 className="text-lg font-bold text-foreground tracking-tight">
              GENERATE ORGANISM
            </h2>
          </div>
          <p className="text-xs text-muted-foreground">
            Mint a new organism on the ICP blockchain. Genesis hash is seeded
            from FNV-1a and locked permanently at creation.
          </p>
        </div>

        {/* Name */}
        <div className="space-y-2">
          <Label className="text-[10px] uppercase tracking-widest text-muted-foreground/60">
            Organism Name
          </Label>
          <Input
            data-ocid="generator.input"
            value={name}
            onChange={(e) => setName(e.target.value.toUpperCase())}
            placeholder="E.g. AXIOM, FORGE-X, HERALD..."
            className="bg-surface border-border text-foreground font-mono text-sm placeholder:text-muted-foreground/30"
          />
        </div>

        {/* Class selector */}
        <div className="space-y-3">
          <Label className="text-[10px] uppercase tracking-widest text-muted-foreground/60">
            Class
          </Label>
          <div className="grid grid-cols-3 gap-3">
            {(Object.keys(CLASS_INFO) as OrgClass[]).map((cls) => {
              const {
                icon: Icon,
                label,
                desc,
                color,
                activeBg,
              } = CLASS_INFO[cls];
              const isActive = selectedClass === cls;
              return (
                <button
                  key={cls}
                  type="button"
                  data-ocid="generator.radio"
                  onClick={() => setSelectedClass(cls)}
                  className={`p-4 rounded-lg border text-left transition-all ${
                    isActive
                      ? `${activeBg}`
                      : "border-border bg-surface hover:border-border-strong"
                  }`}
                >
                  <Icon
                    className={`w-4 h-4 mb-2 ${isActive ? color.split(" ")[1] : "text-muted-foreground/40"}`}
                  />
                  <div
                    className={`text-xs font-bold mb-1 ${
                      isActive ? color.split(" ")[1] : "text-foreground"
                    }`}
                  >
                    {label}
                  </div>
                  <div className="text-[10px] text-muted-foreground/60 leading-relaxed">
                    {desc}
                  </div>
                </button>
              );
            })}
          </div>
        </div>

        {/* Specialization picker */}
        <div className="space-y-3">
          <div className="flex items-center justify-between">
            <Label className="text-[10px] uppercase tracking-widest text-muted-foreground/60">
              Specializations
            </Label>
            <span className="text-[10px] text-muted-foreground/40">
              {selectedSpecs.length} / 5 selected
            </span>
          </div>
          <div className="flex flex-wrap gap-2">
            {SPECIALIZATION_LIST.map((spec) => {
              const isSelected = selectedSpecs.includes(spec);
              const maxed = selectedSpecs.length >= 5 && !isSelected;
              return (
                <button
                  key={spec}
                  type="button"
                  data-ocid="generator.toggle"
                  onClick={() => toggleSpec(spec)}
                  disabled={maxed}
                  className={`px-2.5 py-1 rounded text-[11px] border transition-all ${
                    isSelected
                      ? "bg-primary/15 text-primary border-primary/40"
                      : maxed
                        ? "text-muted-foreground/20 border-border/30 cursor-not-allowed"
                        : "text-muted-foreground border-border hover:border-border-strong hover:text-foreground"
                  }`}
                >
                  {spec}
                </button>
              );
            })}
          </div>
        </div>

        {/* Seed phrase */}
        <div className="space-y-2">
          <Label className="text-[10px] uppercase tracking-widest text-muted-foreground/60">
            Seed Phrase
          </Label>
          <Input
            data-ocid="generator.textarea"
            value={seedPhrase}
            onChange={(e) => setSeedPhrase(e.target.value)}
            placeholder="Leave blank to auto-generate from timestamp + principal"
            className="bg-surface border-border text-foreground font-mono text-xs placeholder:text-muted-foreground/30"
          />
        </div>

        {/* Genesis hash preview */}
        <div className="bg-surface border border-border rounded-lg p-4 space-y-2">
          <div className="text-[10px] uppercase tracking-widest text-muted-foreground/50">
            Genesis Hash Preview
          </div>
          <div className="font-mono text-sm text-primary">{genesisPreview}</div>
          <div className="text-[10px] text-muted-foreground/30">
            FNV-1a hash of seed + name. This will be permanently locked on-chain
            at mint.
          </div>
        </div>

        {/* Generate button */}
        <Button
          data-ocid="generator.submit_button"
          onClick={handleGenerate}
          disabled={isGenerating || success}
          className="w-full h-11 text-sm font-bold tracking-wider bg-primary text-primary-foreground hover:bg-primary/90 disabled:opacity-50"
        >
          {success ? (
            <>
              <CheckCircle2 className="w-4 h-4 mr-2" />
              MINTED ON-CHAIN
            </>
          ) : isGenerating ? (
            <>
              <Loader2 className="w-4 h-4 mr-2 animate-spin" />
              MINTING ORGANISM ON-CHAIN...
            </>
          ) : (
            <>
              <Sparkles className="w-4 h-4 mr-2" />
              GENERATE
            </>
          )}
        </Button>

        {isGenerating && (
          <div
            data-ocid="generator.loading_state"
            className="text-center text-xs text-muted-foreground/50 space-y-1"
          >
            <div>Anchoring genesis hash to ICP canister...</div>
            <div>Seeding shell state at S₀=0.75 coherence floor...</div>
            <div>Initializing 26 Hz nodes and neurochemical substrate...</div>
          </div>
        )}

        {/* Inline success preview card */}
        {success && name && (
          <div
            data-ocid="generator.success_state"
            className="bg-surface border border-primary/30 rounded-lg p-5 space-y-4"
          >
            <div className="flex items-center gap-2 mb-1">
              <CheckCircle2 className="w-4 h-4 text-primary" />
              <span className="text-[10px] uppercase tracking-widest font-semibold text-primary">
                Organism Minted
              </span>
            </div>

            {/* Card header */}
            <div className="flex items-start justify-between gap-3">
              <div>
                <div className="flex items-center gap-2 mb-1.5">
                  <span className="text-base font-bold text-foreground tracking-tight">
                    {name}
                  </span>
                  <span
                    className={`text-[10px] font-semibold uppercase tracking-widest px-1.5 py-0.5 rounded border ${classBadgeStyle(selectedClass)}`}
                  >
                    {selectedClass}
                  </span>
                </div>
                <div className="flex flex-wrap gap-1">
                  {selectedSpecs.map((s) => (
                    <span
                      key={s}
                      className="text-[10px] px-1.5 py-0.5 rounded bg-primary/10 text-primary border border-primary/20"
                    >
                      {s}
                    </span>
                  ))}
                </div>
              </div>
            </div>

            {/* Coherence bar */}
            <div>
              <div className="flex items-center justify-between mb-1">
                <span className="text-[10px] uppercase tracking-widest text-muted-foreground/60">
                  Initial Coherence
                </span>
                <span className="text-[11px] font-mono text-primary">
                  75.00%
                </span>
              </div>
              <Progress value={75} className="h-1 bg-surface-elevated" />
            </div>

            {/* Stats */}
            <div className="flex items-center gap-4">
              <div className="flex items-center gap-1.5">
                <Database className="w-3 h-3 text-muted-foreground/50" />
                <span className="text-[11px] text-muted-foreground">
                  0 FORMA
                </span>
              </div>
              <div className="flex items-center gap-1.5">
                <Zap className="w-3 h-3 text-muted-foreground/50" />
                <span className="text-[11px] text-muted-foreground">
                  0 activations
                </span>
              </div>
            </div>

            {/* Genesis hash */}
            <div className="font-mono text-[9px] text-muted-foreground/40 truncate border-t border-border/40 pt-2">
              GENESIS:{genesisPreview}
            </div>

            <button
              type="button"
              onClick={handleReset}
              className="text-[11px] text-muted-foreground/50 hover:text-muted-foreground underline transition-colors"
            >
              Generate another organism
            </button>
          </div>
        )}
      </div>
    </ScrollArea>
  );
}
