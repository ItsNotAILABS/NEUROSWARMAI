import { Button } from "@/components/ui/button";
import { Progress } from "@/components/ui/progress";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Loader2, ShoppingCart, Tag, TrendingUp } from "lucide-react";
import { motion } from "motion/react";
import { useEffect, useState } from "react";
import { toast } from "sonner";
import { MOCK_ORGANISMS, type MockOrganism } from "../../data/organisms";
import { useActor } from "../../hooks/useActor";

type ListingOrganism = MockOrganism & { listedAt?: string };

export function OrganismMarketplace() {
  const [listings, setListings] = useState<ListingOrganism[]>([]);
  const [buying, setBuying] = useState<string | null>(null);
  const { actor } = useActor();

  useEffect(() => {
    async function load() {
      if (actor) {
        try {
          const data = await (actor as any).getMarketplaceListings();
          // Map to MockOrganism shape
          const mapped: ListingOrganism[] = data.map((l) => ({
            id: l.organism.id,
            name: l.organism.name,
            class:
              "Avatar" in l.organism.class_
                ? "Avatar"
                : "Entity" in l.organism.class_
                  ? "Entity"
                  : "Worker",
            specializations: l.organism.specializations.map(
              (s) => Object.keys(s)[0],
            ),
            coherence: l.organism.shell.coherence,
            formaBalance: l.organism.shell.formaBalance,
            activationCount: Number(l.organism.shell.activationCount),
            genesisHash: l.organism.genesisHash,
            hz: l.organism.shell.hz,
            neuroChem: l.organism.shell.neuroChem,
            isForSale: l.organism.isForSale,
            salePrice: l.organism.salePrice,
            driveMode: "Execution",
            listedAt: new Date(
              Number(l.listedAt / BigInt(1_000_000)),
            ).toLocaleDateString(),
          }));
          if (mapped.length > 0) {
            setListings(mapped);
            return;
          }
        } catch {
          // fallback to mock
        }
      }
      // Mock listings
      setListings(
        MOCK_ORGANISMS.filter((o) => o.isForSale).map((o) => ({
          ...o,
          listedAt: new Date().toLocaleDateString(),
        })),
      );
    }
    load();
  }, [actor]);

  async function handleBuy(organism: ListingOrganism) {
    setBuying(organism.id);
    try {
      if (actor) {
        await (actor as any).buyOrganism(organism.id);
      } else {
        await new Promise((r) => setTimeout(r, 1500));
      }
      setListings((prev) => prev.filter((l) => l.id !== organism.id));
      toast.success(
        `${organism.name} acquired for ${organism.salePrice} FORMA`,
      );
    } catch {
      toast.error("Purchase failed. Please try again.");
    } finally {
      setBuying(null);
    }
  }

  function classBadgeStyle(c: string): string {
    if (c === "Avatar")
      return "text-amber-400 border-amber-500/30 bg-amber-500/10";
    if (c === "Entity") return "text-primary border-primary/30 bg-primary/10";
    return "text-slate-400 border-slate-500/30 bg-slate-500/10";
  }

  return (
    <ScrollArea className="flex-1 h-full">
      <div className="p-6 space-y-6">
        {/* Header */}
        <div className="flex items-center justify-between">
          <div>
            <h2 className="text-lg font-bold text-foreground tracking-tight">
              Organism Marketplace
            </h2>
            <p className="text-xs text-muted-foreground mt-0.5">
              Acquire organisms from the open market. Ownership transfers
              on-chain via ICP canister.
            </p>
          </div>
          <div className="flex items-center gap-1.5 text-[10px] text-muted-foreground/50">
            <TrendingUp className="w-3 h-3" />
            <span>{listings.length} listings</span>
          </div>
        </div>

        {/* Listings grid */}
        {listings.length === 0 ? (
          <div
            data-ocid="marketplace.empty_state"
            className="text-center py-20"
          >
            <Tag className="w-8 h-8 text-muted-foreground/20 mx-auto mb-3" />
            <div className="text-sm text-muted-foreground/50">
              No organisms listed for sale
            </div>
            <div className="text-xs text-muted-foreground/30 mt-1">
              List organisms from your inventory to populate the marketplace
            </div>
          </div>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-4">
            {listings.map((organism, i) => (
              <motion.div
                key={organism.id}
                initial={{ opacity: 0, y: 8 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: i * 0.06 }}
                data-ocid={`marketplace.item.${i + 1}`}
                className="bg-surface border border-border rounded-lg p-4 flex flex-col gap-3 hover:border-border-strong transition-colors"
              >
                {/* Header */}
                <div className="flex items-start justify-between gap-2">
                  <div>
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
                  <div className="text-right shrink-0">
                    <div className="text-base font-bold text-amber-400">
                      {organism.salePrice}
                    </div>
                    <div className="text-[10px] text-muted-foreground/50">
                      FORMA
                    </div>
                  </div>
                </div>

                {/* Coherence */}
                <div>
                  <div className="flex items-center justify-between mb-1">
                    <span className="text-[10px] uppercase tracking-widest text-muted-foreground/50">
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

                {/* Listed date */}
                {organism.listedAt && (
                  <div className="text-[10px] text-muted-foreground/40">
                    Listed {organism.listedAt}
                  </div>
                )}

                {/* Genesis */}
                <div className="font-mono text-[9px] text-muted-foreground/30 truncate border-t border-border/40 pt-2">
                  GENESIS:{organism.genesisHash}
                </div>

                {/* Buy button */}
                <Button
                  data-ocid={`marketplace.primary_button.${i + 1}`}
                  onClick={() => handleBuy(organism)}
                  disabled={buying === organism.id}
                  className="w-full h-8 text-[11px] font-bold bg-amber-500/10 text-amber-400 hover:bg-amber-500/20 border border-amber-500/30"
                  variant="ghost"
                >
                  {buying === organism.id ? (
                    <>
                      <Loader2 className="w-3 h-3 mr-1.5 animate-spin" />
                      ACQUIRING...
                    </>
                  ) : (
                    <>
                      <ShoppingCart className="w-3 h-3 mr-1.5" />
                      BUY · {organism.salePrice} FORMA
                    </>
                  )}
                </Button>
              </motion.div>
            ))}
          </div>
        )}
      </div>
    </ScrollArea>
  );
}
