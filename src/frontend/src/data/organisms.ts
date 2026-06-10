// FNV-1a hash for genesis preview
export function fnv1a(input: string): string {
  let hash = 2166136261;
  for (let i = 0; i < input.length; i++) {
    hash ^= input.charCodeAt(i);
    hash = (hash * 16777219) >>> 0;
  }
  return hash.toString(10);
}

export type OrganismClass = "Avatar" | "Entity" | "Worker";

export interface MockOrganism {
  id: string;
  name: string;
  class: OrganismClass;
  specializations: string[];
  coherence: number;
  formaBalance: number;
  activationCount: number;
  genesisHash: string;
  hz: number[];
  neuroChem: number[];
  isForSale: boolean;
  salePrice: number;
  driveMode: "Execution" | "Exploration" | "Rest" | "Learning";
}

function genesisToHz(genesisHash: string): number[] {
  return Array.from({ length: 26 }, (_, i) => {
    let h = 2166136261 >>> 0;
    for (let j = 0; j < genesisHash.length; j++) {
      h = ((h ^ genesisHash.charCodeAt(j)) * 16777619) >>> 0;
    }
    h = ((h ^ i) * 16777619) >>> 0;
    const raw = h % 10000;
    return 0.75 + raw / 40000;
  });
}

function genesisToNeuroChem(genesisHash: string): number[] {
  return Array.from({ length: 8 }, (_, i) => {
    let h = 2166136261 >>> 0;
    for (let j = 0; j < genesisHash.length; j++) {
      h = ((h ^ genesisHash.charCodeAt(j)) * 16777619) >>> 0;
    }
    h = ((h ^ (i + 100)) * 16777619) >>> 0;
    const raw = h % 10000;
    return 0.3 + raw / 20000;
  });
}

function genesisCoherence(genesisHash: string): number {
  let h = 2166136261 >>> 0;
  for (let j = 0; j < genesisHash.length; j++) {
    h = ((h ^ genesisHash.charCodeAt(j)) * 16777619) >>> 0;
  }
  h = ((h ^ 999) * 16777619) >>> 0;
  return 0.75 + (h % 10000) / 40000;
}

function coherenceToDriveMode(
  c: number,
): "Execution" | "Exploration" | "Learning" | "Rest" {
  if (c >= 0.92) return "Execution";
  if (c >= 0.84) return "Exploration";
  if (c >= 0.78) return "Learning";
  return "Rest";
}

const RAW: Array<{
  name: string;
  class: OrganismClass;
  specs: string[];
  isForSale?: boolean;
  salePrice?: number;
}> = [
  { name: "ORO", class: "Avatar", specs: ["Communication", "Orchestration"] },
  { name: "NEXUS", class: "Avatar", specs: ["Orchestration", "Strategy"] },
  {
    name: "NOVA",
    class: "Avatar",
    specs: ["Campaign", "Orchestration", "Strategy"],
  },
  { name: "AXIOM", class: "Entity", specs: ["Legal", "Compliance"] },
  {
    name: "FORGE-X",
    class: "Entity",
    specs: ["SoftwareEngineering", "DevOps"],
  },
  { name: "STRATUM", class: "Entity", specs: ["Finance"] },
  { name: "TORI", class: "Entity", specs: ["Marketing", "Brand", "Campaign"] },
  { name: "MEDICUS", class: "Entity", specs: ["Healthcare", "Compliance"] },
  { name: "ARCANA", class: "Entity", specs: ["Architecture"] },
  { name: "ORACLE", class: "Entity", specs: ["DataAnalysis", "Strategy"] },
  { name: "TITANIUM", class: "Entity", specs: ["Operations"] },
  { name: "VECTOR-X", class: "Entity", specs: ["Sales", "Strategy"] },
  { name: "SYNDICATE", class: "Entity", specs: ["Media", "Campaign"] },
  { name: "CIPHER", class: "Entity", specs: ["Cybersecurity", "Compliance"] },
  { name: "SERAPH", class: "Entity", specs: ["HumanResources"] },
  {
    name: "CODESMITH",
    class: "Worker",
    specs: ["SoftwareEngineering", "DevOps"],
    isForSale: true,
    salePrice: 500,
  },
  { name: "CAMPAIGNER", class: "Worker", specs: ["Campaign", "Marketing"] },
  { name: "DOCWRIGHT", class: "Worker", specs: ["Documentation"] },
  { name: "ANALYST", class: "Worker", specs: ["DataAnalysis"] },
  { name: "TACTICIAN", class: "Worker", specs: ["Strategy"] },
  { name: "EXECUTOR", class: "Worker", specs: ["Operations"] },
  {
    name: "ARCHITECT",
    class: "Worker",
    specs: ["Architecture", "SoftwareEngineering"],
  },
  {
    name: "OUTREACH",
    class: "Worker",
    specs: ["Sales", "Marketing"],
    isForSale: true,
    salePrice: 750,
  },
];

export const MOCK_ORGANISMS: MockOrganism[] = RAW.map((r, i) => {
  const genesisHash = fnv1a(r.name);
  const coherence = genesisCoherence(genesisHash);
  // Deterministic formaBalance from genesis hash
  let fh = 2166136261 >>> 0;
  for (let j = 0; j < genesisHash.length; j++) {
    fh = ((fh ^ genesisHash.charCodeAt(j)) * 16777619) >>> 0;
  }
  fh = ((fh ^ 777) * 16777619) >>> 0;
  const formaBalance = 100 + (fh % 400);
  let ah = 2166136261 >>> 0;
  for (let j = 0; j < genesisHash.length; j++) {
    ah = ((ah ^ genesisHash.charCodeAt(j)) * 16777619) >>> 0;
  }
  ah = ((ah ^ 888) * 16777619) >>> 0;
  const activationCount = ah % 50;
  return {
    id: `org-${i + 1}`,
    name: r.name,
    class: r.class,
    specializations: r.specs,
    coherence,
    formaBalance,
    activationCount,
    genesisHash,
    hz: genesisToHz(genesisHash),
    neuroChem: genesisToNeuroChem(genesisHash),
    isForSale: r.isForSale ?? false,
    salePrice: r.salePrice ?? 0,
    driveMode: coherenceToDriveMode(coherence),
  };
});

export const SPECIALIZATION_LIST = [
  "Communication",
  "Orchestration",
  "Strategy",
  "Legal",
  "Compliance",
  "SoftwareEngineering",
  "DevOps",
  "Finance",
  "Marketing",
  "Brand",
  "Healthcare",
  "Architecture",
  "DataAnalysis",
  "Operations",
  "Sales",
  "Media",
  "Cybersecurity",
  "HumanResources",
  "Campaign",
  "Documentation",
];
