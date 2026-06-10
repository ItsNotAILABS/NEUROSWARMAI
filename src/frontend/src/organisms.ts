// Organism types and conversion helpers — source of truth for all organism-related data shapes
// Used across hooks and components. This file is NOT auto-generated and is safe to modify.

export type OrganismClass = "Avatar" | "Entity" | "Worker";
export type DriveMode = "Execution" | "Exploration" | "Learning" | "Rest";
export type OrganismSpecialization =
  | "Architecture"
  | "Brand"
  | "Campaign"
  | "Communication"
  | "Compliance"
  | "Cybersecurity"
  | "DataAnalysis"
  | "DevOps"
  | "Documentation"
  | "Finance"
  | "Healthcare"
  | "HumanResources"
  | "Legal"
  | "Marketing"
  | "Media"
  | "Operations"
  | "Orchestration"
  | "Sales"
  | "SoftwareEngineering"
  | "Strategy";

export interface ShellState {
  activationCount: number;
  coherence: number;
  compoundIndex: number;
  driveMode: DriveMode;
  formaBalance: number;
  governanceScore: number;
  hz: number[];
  neuroChem: number[];
}

export interface Organism {
  id: string;
  name: string;
  owner: string;
  class_: OrganismClass;
  specializations: OrganismSpecialization[];
  genesisHash: string;
  shell: ShellState;
  createdAt: number;
  isForSale: boolean;
  salePrice: number;
}

export interface OrganismListing {
  organism: Organism;
  listedAt: number;
}

export interface WorkforceMessage {
  id: string;
  threadId: string;
  organismId: string;
  role: string;
  content: string;
  artifactType?: string;
  artifactContent?: string;
  timestamp: number;
}

export interface ArtifactRecord {
  id: string;
  organismId: string;
  owner: string;
  artifactType: string;
  title: string;
  content: string;
  createdAt: number;
}

// ── Candid conversion helpers ──────────────────────────────────────────────

/** Extract variant key from Candid variant object: { Execution: null } → 'Execution' */
export function extractVariant(v: object): string {
  return Object.keys(v)[0];
}

/** Convert Candid opt ([] | [T]) to T | undefined */
export function fromOpt<T>(v: [] | [T] | unknown): T | undefined {
  if (!Array.isArray(v)) return undefined;
  return v.length === 0 ? undefined : (v[0] as T);
}

/** Convert OrganismClass string to Candid variant */
export function toClassCandid(
  c: OrganismClass,
): { Avatar: null } | { Entity: null } | { Worker: null } {
  return { [c]: null } as
    | { Avatar: null }
    | { Entity: null }
    | { Worker: null };
}

/** Convert specialization string to Candid variant */
export function toSpecCandid(s: string): Record<string, null> {
  return { [s]: null };
}

/** Map a raw backend organism object to our typed Organism interface */
export function mapBackendOrganism(o: any): Organism {
  const cls: OrganismClass =
    "Avatar" in (o.class_ ?? o.class ?? {})
      ? "Avatar"
      : "Entity" in (o.class_ ?? o.class ?? {})
        ? "Entity"
        : "Worker";

  const driveKey = o.shell?.driveMode
    ? extractVariant(o.shell.driveMode)
    : "Execution";
  const driveMode: DriveMode =
    driveKey === "Execution" ||
    driveKey === "Exploration" ||
    driveKey === "Learning" ||
    driveKey === "Rest"
      ? (driveKey as DriveMode)
      : "Execution";

  return {
    id: o.id,
    name: o.name,
    owner: o.owner?.toString?.() ?? "",
    class_: cls,
    specializations: (o.specializations ?? []).map((s: any) =>
      extractVariant(s),
    ) as OrganismSpecialization[],
    genesisHash: o.genesisHash ?? "",
    shell: {
      activationCount: Number(o.shell?.activationCount ?? 0),
      coherence: o.shell?.coherence ?? 0.75,
      compoundIndex: o.shell?.compoundIndex ?? 0.75,
      driveMode,
      formaBalance: o.shell?.formaBalance ?? 0,
      governanceScore: o.shell?.governanceScore ?? 0.75,
      hz: Array.from(o.shell?.hz ?? []),
      neuroChem: Array.from(o.shell?.neuroChem ?? []),
    },
    createdAt: Number(o.createdAt ?? 0),
    isForSale: o.isForSale ?? false,
    salePrice: o.salePrice ?? 0,
  };
}

/** Map a backend WorkforceMessage to our typed interface */
export function mapBackendMessage(m: any): WorkforceMessage {
  return {
    id: m.id,
    threadId: m.threadId,
    organismId: m.organismId,
    role: m.role,
    content: m.content,
    artifactType: fromOpt(m.artifactType),
    artifactContent: fromOpt(m.artifactContent),
    timestamp: Number(m.timestamp ?? 0),
  };
}

/** Map a backend ArtifactRecord to our typed interface */
export function mapBackendArtifact(a: any): ArtifactRecord {
  return {
    id: a.id,
    organismId: a.organismId,
    owner: a.owner?.toString?.() ?? "",
    artifactType: a.artifactType,
    title: a.title,
    content: a.content,
    createdAt: Number(a.createdAt ?? 0),
  };
}
