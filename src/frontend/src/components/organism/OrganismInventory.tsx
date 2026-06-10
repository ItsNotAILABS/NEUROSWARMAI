import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Progress } from "@/components/ui/progress";
import { ScrollArea } from "@/components/ui/scroll-area";
import {
  Cpu,
  Database,
  Eye,
  MessageSquare,
  ShoppingBag,
  Tag,
} from "lucide-react";
import { motion } from "motion/react";
import type { MockOrganism, OrganismClass } from "../../data/organisms";

interface OrganismInventoryProps {
  organisms: MockOrganism[];
  onOpenViewer: (organism: MockOrganism) => void;
  onOpenChat: (organism: MockOrganism) => void;
}

function classBadgeStyle(c: OrganismClass): string {
  if (c === "Avatar")
    return "bg-amber-500/15 text-amber-400 border-amber-500/30";
  if (c === "Entity") return "bg-primary/15 text-primary border-primary/30";
  return "bg-slate-500/15 text-slate-400 border-slate-500/30";
}

function OrganismCard({
  organism,
  index,
  onOpenViewer,
  onOpenChat,
}: {
  organism: MockOrganism;
  index: number;
  onOpenViewer: (o: MockOrganism) => void;
  onOpenChat: (o: MockOrganism) => void;
}) {
  return (
    <motion.div
      initial={{ opacity: 0, y: 12 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.2, delay: index * 0.04 }}
      data-ocid={`inventory.item.${index + 1}`}
      className="relative bg-surface border border-border rounded-lg p-4 flex flex-col gap-3 hover:border-border-strong transition-colors"
    >
      {/* Live pulse indicator */}
      <div className="absolute top-3 right-3">
        <span className="w-2 h-2 rounded-full bg-primary block animate-pulse" />
      </div>

      {/* Header */}
      <div className="flex items-start justify-between gap-2 pr-4">
        <div className="flex-1 min-w-0">
          <div className="flex items-center gap-2 mb-1">
            <span className="text-base font-bold text-foreground tracking-tight">
              {organism.name}
            </span>
            <span
              className={`text-[10px] font-semibold uppercase tracking-widest px-1.5 py-0.5 rounded border ${classBadgeStyle(organism.class)}`}
            >
              {organism.class}
            </span>
          </div>
          {/* Specializations */}
          <div className="flex flex-wrap gap-1">
            {organism.specializations.map((s) => (
              <span
                key={s}
                className="text-[10px] px-1.5 py-0.5 rounded bg-surface-elevated text-muted-foreground border border-border/60"
              >
                {s}
              </span>
            ))}
          </div>
        </div>
        {organism.isForSale && (
          <div className="flex items-center gap-1 text-amber-400 text-[10px] font-semibold shrink-0">
            <Tag className="w-3 h-3" />
            <span>{organism.salePrice} FORMA</span>
          </div>
        )}
      </div>

      {/* Coherence */}
      <div>
        <div className="flex items-center justify-between mb-1">
          <span className="text-[10px] uppercase tracking-widest text-muted-foreground/60">
            Coherence
          </span>
          <span className="text-[11px] font-mono text-primary">
            {(organism.coherence * 100).toFixed(1)}%
          </span>
        </div>
        <Progress
          value={organism.coherence * 100}
          className="h-1 bg-surface-elevated"
        />
      </div>

      {/* Stats row */}
      <div className="flex items-center gap-4">
        <div className="flex items-center gap-1.5">
          <Database className="w-3 h-3 text-muted-foreground/50" />
          <span className="text-[11px] text-muted-foreground">
            {organism.formaBalance} FORMA
          </span>
        </div>
        <div className="flex items-center gap-1.5">
          <Cpu className="w-3 h-3 text-muted-foreground/50" />
          <span className="text-[11px] text-muted-foreground">
            {organism.activationCount} activations
          </span>
        </div>
      </div>

      {/* Genesis hash */}
      <div className="font-mono text-[9px] text-muted-foreground/40 truncate border-t border-border/40 pt-2">
        GENESIS:{organism.genesisHash}
      </div>

      {/* Actions */}
      <div className="flex items-center gap-2 pt-0.5">
        <Button
          size="sm"
          data-ocid={`inventory.open_modal_button.${index + 1}`}
          onClick={() => onOpenViewer(organism)}
          className="flex-1 h-7 text-[11px] bg-primary/10 text-primary hover:bg-primary/20 border border-primary/20"
          variant="ghost"
        >
          <Eye className="w-3 h-3 mr-1" />
          OPEN
        </Button>
        <Button
          size="sm"
          data-ocid={`inventory.secondary_button.${index + 1}`}
          onClick={() => onOpenChat(organism)}
          className="flex-1 h-7 text-[11px] text-muted-foreground hover:text-foreground border border-border"
          variant="ghost"
        >
          <MessageSquare className="w-3 h-3 mr-1" />
          CHAT
        </Button>
        {organism.isForSale ? (
          <Button
            size="sm"
            data-ocid={`inventory.delete_button.${index + 1}`}
            className="h-7 text-[11px] text-amber-400 hover:text-amber-300 border border-amber-500/20 hover:border-amber-500/40"
            variant="ghost"
          >
            <ShoppingBag className="w-3 h-3 mr-1" />
            WITHDRAW
          </Button>
        ) : (
          <Button
            size="sm"
            data-ocid={`inventory.edit_button.${index + 1}`}
            className="h-7 text-[11px] text-muted-foreground/60 hover:text-muted-foreground border border-border/50"
            variant="ghost"
          >
            LIST
          </Button>
        )}
      </div>
    </motion.div>
  );
}

export function OrganismInventory({
  organisms,
  onOpenViewer,
  onOpenChat,
}: OrganismInventoryProps) {
  const avatars = organisms.filter((o) => o.class === "Avatar");
  const entities = organisms.filter((o) => o.class === "Entity");
  const workers = organisms.filter((o) => o.class === "Worker");

  function Section({
    title,
    items,
    offset,
  }: {
    title: string;
    items: MockOrganism[];
    offset: number;
  }) {
    return (
      <div>
        <div className="flex items-center gap-3 mb-3">
          <span className="text-[10px] font-semibold uppercase tracking-widest text-muted-foreground/50">
            {title}
          </span>
          <div className="flex-1 h-px bg-border/40" />
          <Badge
            variant="outline"
            className="text-[10px] border-border text-muted-foreground/50"
          >
            {items.length}
          </Badge>
        </div>
        <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-3">
          {items.map((o, i) => (
            <OrganismCard
              key={o.id}
              organism={o}
              index={offset + i}
              onOpenViewer={onOpenViewer}
              onOpenChat={onOpenChat}
            />
          ))}
        </div>
      </div>
    );
  }

  return (
    <ScrollArea className="flex-1 h-full">
      <div className="p-6 space-y-8">
        <div className="flex items-center justify-between">
          <div>
            <h2 className="text-lg font-bold text-foreground tracking-tight">
              Organism Inventory
            </h2>
            <p className="text-xs text-muted-foreground mt-0.5">
              {organisms.length} organisms in your collection · Alfredo Medina
              Hernandez
            </p>
          </div>
          <Badge
            className="text-[10px] bg-primary/10 text-primary border-primary/20"
            variant="outline"
          >
            {organisms.filter((o) => o.isForSale).length} listed
          </Badge>
        </div>

        <Section title="Avatar Class" items={avatars} offset={0} />
        <Section
          title="Entity Class"
          items={entities}
          offset={avatars.length}
        />
        <Section
          title="Worker Class"
          items={workers}
          offset={avatars.length + entities.length}
        />
      </div>
    </ScrollArea>
  );
}
