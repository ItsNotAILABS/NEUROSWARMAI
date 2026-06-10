import { useEffect, useState } from "react";
import { MOCK_ORGANISMS, type MockOrganism } from "../../data/organisms";
import { useActor } from "../../hooks/useActor";
import { useInternetIdentity } from "../../hooks/useInternetIdentity";
import { useOrganisms } from "../../hooks/useOrganisms";
import { GenesisDashboard } from "./GenesisDashboard";
import { MemoryTimeline } from "./MemoryTimeline";
import { NeuralMap } from "./NeuralMap";
import { NeuroEmergenceCore } from "./NeuroEmergenceCore";
import { OrganismGenerator } from "./OrganismGenerator";
import { OrganismInventory } from "./OrganismInventory";
import { OrganismLiveViewer } from "./OrganismLiveViewer";
import { OrganismMarketplace } from "./OrganismMarketplace";
import { WorkforceChat } from "./WorkforceChat";

type WorkforceTab =
  | "inventory"
  | "viewer"
  | "chat"
  | "generator"
  | "marketplace"
  | "substrate"
  | "genesis"
  | "neural"
  | "memory";

const TABS: { id: WorkforceTab; label: string }[] = [
  { id: "inventory", label: "INVENTORY" },
  { id: "viewer", label: "LIVE VIEWER" },
  { id: "substrate", label: "SUBSTRATE" },
  { id: "genesis", label: "GENESIS" },
  { id: "neural", label: "NEURAL MAP" },
  { id: "memory", label: "MEMORY" },
  { id: "chat", label: "CHAT" },
  { id: "generator", label: "GENERATOR" },
  { id: "marketplace", label: "MARKETPLACE" },
];

interface OrganismWorkforceProps {
  initialTab?: string;
}

export function OrganismWorkforce({ initialTab }: OrganismWorkforceProps) {
  const [activeTab, setActiveTab] = useState<WorkforceTab>(
    (initialTab as WorkforceTab) ?? "inventory",
  );
  const [selectedOrganism, setSelectedOrganism] = useState<MockOrganism | null>(
    null,
  );
  const [chatOrganism, setChatOrganism] = useState<MockOrganism | null>(null);
  const { actor } = useActor();
  const { identity } = useInternetIdentity();
  const { organisms: backendOrganisms, seedOrganisms } = useOrganisms();

  // Merge: backend organisms take precedence, mock fills gaps while loading
  const organisms: MockOrganism[] = (() => {
    if (!identity || backendOrganisms.length === 0) return MOCK_ORGANISMS;
    const mapped: MockOrganism[] = backendOrganisms.map((o) => ({
      id: o.id,
      name: o.name,
      class: o.class_ as "Avatar" | "Entity" | "Worker",
      specializations: o.specializations,
      coherence: o.shell.coherence,
      formaBalance: o.shell.formaBalance,
      activationCount: o.shell.activationCount,
      genesisHash: o.genesisHash,
      hz: o.shell.hz,
      neuroChem: o.shell.neuroChem,
      isForSale: o.isForSale,
      salePrice: o.salePrice,
      driveMode: o.shell.driveMode,
    }));
    const backendIds = new Set(mapped.map((o) => o.id));
    return [...mapped, ...MOCK_ORGANISMS.filter((m) => !backendIds.has(m.id))];
  })();

  // Navigate to initialTab when it changes from outside
  useEffect(() => {
    if (initialTab && TABS.find((t) => t.id === initialTab)) {
      setActiveTab(initialTab as WorkforceTab);
    }
  }, [initialTab]);

  // Auto-seed pre-built organisms on first admin login
  useEffect(() => {
    async function autoSeed() {
      if (!actor || !identity) return;
      try {
        const isAdmin = await (actor as any).isCallerAdmin();
        if (isAdmin) seedOrganisms().catch(() => {});
      } catch {
        // not admin or already seeded
      }
    }
    autoSeed();
  }, [actor, identity, seedOrganisms]);

  function handleOpenViewer(organism: MockOrganism) {
    setSelectedOrganism(organism);
    setActiveTab("viewer");
  }

  function handleOpenChat(organism: MockOrganism) {
    setChatOrganism(organism);
    setActiveTab("chat");
  }

  return (
    <div className="flex flex-col flex-1 min-w-0 h-full overflow-hidden">
      {/* Tab bar — horizontally scrollable on mobile */}
      <div className="flex items-center border-b border-border shrink-0 bg-background overflow-x-auto">
        {TABS.map((tab) => {
          const isDisabled = tab.id === "viewer" && !selectedOrganism;
          const isActive = activeTab === tab.id;
          return (
            <button
              key={tab.id}
              type="button"
              data-ocid="workforce.tab"
              onClick={() => {
                if (!isDisabled) setActiveTab(tab.id);
              }}
              disabled={isDisabled}
              className={`relative shrink-0 px-4 py-3.5 text-[11px] font-semibold uppercase tracking-widest transition-colors border-b-2 touch-manipulation ${
                isActive
                  ? "text-primary border-primary"
                  : isDisabled
                    ? "text-muted-foreground/20 border-transparent cursor-not-allowed"
                    : "text-muted-foreground/50 border-transparent hover:text-muted-foreground hover:border-border"
              }`}
            >
              {tab.label}
              {tab.id === "viewer" && selectedOrganism && (
                <span className="ml-1.5 text-[9px] text-primary/60">
                  · {selectedOrganism.name}
                </span>
              )}
            </button>
          );
        })}
      </div>

      {/* Content */}
      <div className="flex-1 overflow-hidden">
        {activeTab === "inventory" && (
          <OrganismInventory
            organisms={organisms}
            onOpenViewer={handleOpenViewer}
            onOpenChat={handleOpenChat}
          />
        )}
        {activeTab === "viewer" && selectedOrganism && (
          <OrganismLiveViewer
            organism={selectedOrganism}
            onBack={() => setActiveTab("inventory")}
            onChat={handleOpenChat}
          />
        )}
        {activeTab === "substrate" && <NeuroEmergenceCore />}
        {activeTab === "genesis" && selectedOrganism && (
          <GenesisDashboard
            organism={selectedOrganism}
            onBack={() => setActiveTab("inventory")}
          />
        )}
        {activeTab === "genesis" && !selectedOrganism && organisms[0] && (
          <GenesisDashboard
            organism={organisms[0]}
            onBack={() => setActiveTab("inventory")}
          />
        )}
        {activeTab === "neural" && (
          <NeuralMap coherence={selectedOrganism?.coherence ?? 0.85} />
        )}
        {activeTab === "memory" && <MemoryTimeline />}
        {activeTab === "chat" && (
          <WorkforceChat
            organisms={organisms}
            selectedOrganism={chatOrganism ?? undefined}
          />
        )}
        {activeTab === "generator" && <OrganismGenerator />}
        {activeTab === "marketplace" && <OrganismMarketplace />}
      </div>
    </div>
  );
}
