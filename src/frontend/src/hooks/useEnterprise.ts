// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  ENTERPRISE ICP HOOKS — COMPLETE INTEGRATION LAYER                                                        ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
// ║  Framework:    Medina Doctrine                                                                            ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { useEffect, useMemo, useState } from "react";
import { useActor } from "./useActor";
import { useInternetIdentity } from "./useInternetIdentity";

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// TYPE DEFINITIONS
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

export interface OrganismHeartbeatResult {
  beat: number;
  kuramotoR: number;
  lawsExecuted: number;
  lawEngineScore: number;
  driftTotal: number;
  heritageAvg: number;
  omnisCharge: number;
  macroSphereR: number;
  isStable: boolean;
}

export interface FullOrganismState {
  systemHeartbeat: number;
  genesisSealed: boolean;
  kuramotoR: number;
  kuramotoPsi: number;
  resonanceLock: boolean;
  lawEngineScore: number;
  driftTotal: number;
  heritageAvg: number;
  dreamPhase: boolean;
  arousalLevel: number;
  omnisActive: boolean;
  omnisCharge: number;
  macroSphereR: number;
  isDoctrineIntact: boolean;
}

export interface Hz26State {
  phases: number[];
  frequencies: number[];
  amplitudes: number[];
  orderParameterR: number;
  orderParameterPsi: number;
}

export interface LawEngineScore {
  score: number;
  lawsExecutedThisBeat: number;
  totalViolations: number;
  totalCorrections: number;
  isDoctrineIntact: boolean;
}

export interface VAELEngine {
  integrity: number;
  threatLevel: number;
  antibodyCount: number;
  quarantineCount: number;
  recoveryRate: number;
}

export interface ArtifactLogEntry {
  beat: number;
  timestamp: number;
  artifactType: string;
  description: string;
  value: number;
}

export interface HeritageState {
  revolucionario: number;
  zapata: number;
  villa: number;
  independencia: number;
  hidalgo: number;
  adelita: number;
  morelos: number;
  average: number;
  pentecostPrecursor: boolean;
}

export interface TokenBalances {
  seed: number;
  forma: number;
  gtk: number;
  cvt: number;
  vct: number;
  knt: number;
  sbt: number;
  hbt: number;
  drt: number;
  omt: number;
  mth: number;
  mrc: number;
}

export interface NeurochemistryState {
  dopamine: number;
  serotonin: number;
  norepinephrine: number;
  acetylcholine: number;
  glutamate: number;
  gaba: number;
  oxytocin: number;
  cortisol: number;
}

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// NEW TYPES: VAEL Fear Substrate & ICP Cycle Economics
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

export interface VAELFearState {
  fearLevel: number;
  cipherProgress: number;
  determination: number;
  resolutionGate: boolean;
  architectAnchor: number;
  amygdalaSignal: number;
  pfcFeedback: number;
  fearFloor: number;
}

export interface ICPCycleEconomics {
  cycleBalance: number;
  cyclesBurnedTotal: number;
  cyclesBurnedToday: number;
  cycleRunwayDays: number;
  cycleAlertLevel: number;
  cycleSustainabilityRatio: number;
  cycleMaxwellDemonYield: number;
  heartbeatCost: number;
}

export interface OrganismBrainState {
  beat: number;
  kuramotoR: number;
  kuramotoPsi: number;
  engCoherence: number;
  formaSupply: number;
  lawsExecuted: number;
  driftTotal: number;
  heritageAvg: number;
  omnisCharge: number;
  macroSphereR: number;
  fearLevel: number;
  isStable: boolean;
}

export interface TreasurySummary {
  totalAccounts: number;
  totalTransactions: number;
  totalForma: number;
  totalSeed: number;
  totalGtk: number;
}

export interface RevenueSummary {
  totalGenerated: number;
  architectTotal: number;
  playerTotal: number;
  pendingDistribution: number;
  eventCount: number;
}

export interface JubileeStatus {
  currentCycle: number;
  cycleStartBeat: number;
  beatsUntilJubilee: number;
  debtForgiven: number;
  slavesFreed: number;
  landReturned: number;
  lastJubileeTimestamp: number;
}

export interface AEGISStatus {
  emergencyMode: boolean;
  shieldStrength: number;
  rollbackCount: number;
  lastRollbackBeat: number;
  currentSlot: number;
  snapshotCount: number;
  eventCount: number;
}

export interface ComplianceSummary {
  overallScore: number;
  totalChecks: number;
  openViolations: number;
  criticalViolations: number;
  lastCheckBeat: number;
  isCompliant: boolean;
}

export interface AuditSummary {
  totalEvents: number;
  successfulEvents: number;
  failedEvents: number;
  eventsByType: [string, number][];
  recentEvents: any[];
}

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// BRAIN STATE HOOKS
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

/**
 * Hook for organism brain state and heartbeat operations
 */
export function useOrganismBrain() {
  const { actor, isFetching } = useActor();
  const { identity } = useInternetIdentity();
  const qc = useQueryClient();

  // Full organism state query
  const fullStateQuery = useQuery<FullOrganismState | null>({
    queryKey: ["organism", "fullState"],
    queryFn: async () => {
      if (!actor || !identity) return null;
      try {
        const state = await (actor as any).getFullOrganismState();
        return {
          systemHeartbeat: Number(state.systemHeartbeat),
          genesisSealed: state.genesisSealed,
          kuramotoR: Number(state.kuramotoR),
          kuramotoPsi: Number(state.kuramotoPsi),
          resonanceLock: state.resonanceLock,
          lawEngineScore: Number(state.lawEngineScore),
          driftTotal: Number(state.driftTotal),
          heritageAvg: Number(state.heritageAvg),
          dreamPhase: state.dreamPhase,
          arousalLevel: Number(state.arousalLevel),
          omnisActive: state.omnisActive,
          omnisCharge: Number(state.omnisCharge),
          macroSphereR: Number(state.macroSphereR),
          isDoctrineIntact: state.isDoctrineIntact,
        };
      } catch (e) {
        console.error("Failed to fetch full organism state:", e);
        return null;
      }
    },
    enabled: !!actor && !isFetching && !!identity,
    staleTime: 3000,
    refetchInterval: 5000, // Auto-refresh every 5 seconds
  });

  // Hz26 state query
  const hz26Query = useQuery<Hz26State | null>({
    queryKey: ["organism", "hz26"],
    queryFn: async () => {
      if (!actor || !identity) return null;
      try {
        const state = await (actor as any).getHz26State();
        return {
          phases: state.phases.map(Number),
          frequencies: state.frequencies.map(Number),
          amplitudes: state.amplitudes.map(Number),
          orderParameterR: Number(state.orderParameterR),
          orderParameterPsi: Number(state.orderParameterPsi),
        };
      } catch (e) {
        console.error("Failed to fetch Hz26 state:", e);
        return null;
      }
    },
    enabled: !!actor && !isFetching && !!identity,
    staleTime: 3000,
  });

  // Law engine score query
  const lawEngineQuery = useQuery<LawEngineScore | null>({
    queryKey: ["organism", "lawEngine"],
    queryFn: async () => {
      if (!actor || !identity) return null;
      try {
        const score = await (actor as any).getLawEngineScore();
        return {
          score: Number(score.score),
          lawsExecutedThisBeat: Number(score.lawsExecutedThisBeat),
          totalViolations: Number(score.totalViolations),
          totalCorrections: Number(score.totalCorrections),
          isDoctrineIntact: score.isDoctrineIntact,
        };
      } catch (e) {
        console.error("Failed to fetch law engine score:", e);
        return null;
      }
    },
    enabled: !!actor && !isFetching && !!identity,
    staleTime: 3000,
  });

  // VAEL engine query
  const vaelQuery = useQuery<VAELEngine | null>({
    queryKey: ["organism", "vael"],
    queryFn: async () => {
      if (!actor || !identity) return null;
      try {
        const state = await (actor as any).getVAELEngine();
        return {
          integrity: Number(state.integrity),
          threatLevel: Number(state.threatLevel),
          antibodyCount: Number(state.antibodyCount),
          quarantineCount: Number(state.quarantineCount),
          recoveryRate: Number(state.recoveryRate),
        };
      } catch (e) {
        console.error("Failed to fetch VAEL engine:", e);
        return null;
      }
    },
    enabled: !!actor && !isFetching && !!identity,
    staleTime: 10000,
  });

  // Heritage state query
  const heritageQuery = useQuery<HeritageState | null>({
    queryKey: ["organism", "heritage"],
    queryFn: async () => {
      if (!actor || !identity) return null;
      try {
        const state = await (actor as any).getHeritageState();
        return {
          revolucionario: Number(state.revolucionario),
          zapata: Number(state.zapata),
          villa: Number(state.villa),
          independencia: Number(state.independencia),
          hidalgo: Number(state.hidalgo),
          adelita: Number(state.adelita),
          morelos: Number(state.morelos),
          average: Number(state.average),
          pentecostPrecursor: state.pentecostPrecursor,
        };
      } catch (e) {
        console.error("Failed to fetch heritage state:", e);
        return null;
      }
    },
    enabled: !!actor && !isFetching && !!identity,
    staleTime: 10000,
  });

  // Neurochemistry state query
  const neurochemQuery = useQuery<NeurochemistryState | null>({
    queryKey: ["organism", "neurochem"],
    queryFn: async () => {
      if (!actor || !identity) return null;
      try {
        const state = await (actor as any).getNeurochemistryState();
        return {
          dopamine: Number(state.dopamine),
          serotonin: Number(state.serotonin),
          norepinephrine: Number(state.norepinephrine),
          acetylcholine: Number(state.acetylcholine),
          glutamate: Number(state.glutamate),
          gaba: Number(state.gaba),
          oxytocin: Number(state.oxytocin),
          cortisol: Number(state.cortisol),
        };
      } catch (e) {
        console.error("Failed to fetch neurochemistry state:", e);
        return null;
      }
    },
    enabled: !!actor && !isFetching && !!identity,
    staleTime: 5000,
  });

  // Core activations query
  const coreActivationsQuery = useQuery<number[] | null>({
    queryKey: ["organism", "coreActivations"],
    queryFn: async () => {
      if (!actor || !identity) return null;
      try {
        const activations = await (actor as any).getCoreActivations();
        return activations.map(Number);
      } catch (e) {
        console.error("Failed to fetch core activations:", e);
        return null;
      }
    },
    enabled: !!actor && !isFetching && !!identity,
    staleTime: 5000,
  });

  // ═══════════════════════════════════════════════════════════════════════════════
  // NEW QUERIES: VAEL Fear Substrate & ICP Cycle Economics
  // ═══════════════════════════════════════════════════════════════════════════════

  // VAEL Fear State query (new - distinct from VAEL immune)
  const vaelFearQuery = useQuery<VAELFearState | null>({
    queryKey: ["organism", "vaelFear"],
    queryFn: async () => {
      if (!actor || !identity) return null;
      try {
        const state = await (actor as any).getVAELFearState();
        return {
          fearLevel: Number(state.fearLevel),
          cipherProgress: Number(state.cipherProgress),
          determination: Number(state.determination),
          resolutionGate: state.resolutionGate,
          architectAnchor: Number(state.architectAnchor),
          amygdalaSignal: Number(state.amygdalaSignal),
          pfcFeedback: Number(state.pfcFeedback),
          fearFloor: Number(state.fearFloor),
        };
      } catch (e) {
        console.error("Failed to fetch VAEL fear state:", e);
        return null;
      }
    },
    enabled: !!actor && !isFetching && !!identity,
    staleTime: 3000,
    refetchInterval: 5000, // Auto-refresh every 5 seconds
  });

  // ICP Cycle Economics query
  const cycleEconomicsQuery = useQuery<ICPCycleEconomics | null>({
    queryKey: ["organism", "cycleEconomics"],
    queryFn: async () => {
      if (!actor || !identity) return null;
      try {
        const state = await (actor as any).getICPCycleEconomics();
        return {
          cycleBalance: Number(state.cycleBalance),
          cyclesBurnedTotal: Number(state.cyclesBurnedTotal),
          cyclesBurnedToday: Number(state.cyclesBurnedToday),
          cycleRunwayDays: Number(state.cycleRunwayDays),
          cycleAlertLevel: Number(state.cycleAlertLevel),
          cycleSustainabilityRatio: Number(state.cycleSustainabilityRatio),
          cycleMaxwellDemonYield: Number(state.cycleMaxwellDemonYield),
          heartbeatCost: Number(state.heartbeatCost),
        };
      } catch (e) {
        console.error("Failed to fetch ICP cycle economics:", e);
        return null;
      }
    },
    enabled: !!actor && !isFetching && !!identity,
    staleTime: 10000,
    refetchInterval: 30000, // Refresh every 30 seconds
  });

  // Organism Brain State (consolidated view)
  const brainStateQuery = useQuery<OrganismBrainState | null>({
    queryKey: ["organism", "brainState"],
    queryFn: async () => {
      if (!actor || !identity) return null;
      try {
        const state = await (actor as any).getOrganismBrainState();
        return {
          beat: Number(state.beat),
          kuramotoR: Number(state.kuramotoR),
          kuramotoPsi: Number(state.kuramotoPsi),
          engCoherence: Number(state.engCoherence),
          formaSupply: Number(state.formaSupply),
          lawsExecuted: Number(state.lawsExecuted),
          driftTotal: Number(state.driftTotal),
          heritageAvg: Number(state.heritageAvg),
          omnisCharge: Number(state.omnisCharge),
          macroSphereR: Number(state.macroSphereR),
          fearLevel: Number(state.fearLevel),
          isStable: state.isStable,
        };
      } catch (e) {
        console.error("Failed to fetch organism brain state:", e);
        return null;
      }
    },
    enabled: !!actor && !isFetching && !!identity,
    staleTime: 2000,
    refetchInterval: 3000, // Auto-refresh every 3 seconds for live view
  });

  // Run heartbeat mutation
  const heartbeatMutation = useMutation<OrganismHeartbeatResult>({
    mutationFn: async () => {
      if (!actor) throw new Error("No actor");
      const result = await (actor as any).runOrganismHeartbeat();
      return {
        beat: Number(result.beat),
        kuramotoR: Number(result.kuramotoR),
        lawsExecuted: Number(result.lawsExecuted),
        lawEngineScore: Number(result.lawEngineScore),
        driftTotal: Number(result.driftTotal),
        heritageAvg: Number(result.heritageAvg),
        omnisCharge: Number(result.omnisCharge),
        macroSphereR: Number(result.macroSphereR),
        isStable: result.isStable,
      };
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["organism"] });
    },
  });

  // Activate OMNIS mutation
  const omnisMutation = useMutation<boolean>({
    mutationFn: async () => {
      if (!actor) throw new Error("No actor");
      return await (actor as any).activateOMNIS();
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["organism"] });
    },
  });

  return {
    // State queries
    fullState: fullStateQuery.data,
    hz26State: hz26Query.data,
    lawEngineScore: lawEngineQuery.data,
    vaelEngine: vaelQuery.data,
    heritageState: heritageQuery.data,
    neurochemState: neurochemQuery.data,
    coreActivations: coreActivationsQuery.data,
    
    // NEW: VAEL Fear Substrate & ICP Cycle Economics
    vaelFearState: vaelFearQuery.data,
    cycleEconomics: cycleEconomicsQuery.data,
    brainState: brainStateQuery.data,
    
    // Loading states
    isLoading: fullStateQuery.isLoading,
    isHz26Loading: hz26Query.isLoading,
    isBrainStateLoading: brainStateQuery.isLoading,
    isCycleEconomicsLoading: cycleEconomicsQuery.isLoading,
    isVaelFearLoading: vaelFearQuery.isLoading,
    
    // Mutations
    runHeartbeat: heartbeatMutation.mutateAsync,
    activateOmnis: omnisMutation.mutateAsync,
    isHeartbeatPending: heartbeatMutation.isPending,
    isOmnisPending: omnisMutation.isPending,
    
    // Refetch functions
    refetchAll: () => qc.invalidateQueries({ queryKey: ["organism"] }),
    refetchBrainState: () => qc.invalidateQueries({ queryKey: ["organism", "brainState"] }),
    refetchFearState: () => qc.invalidateQueries({ queryKey: ["organism", "vaelFear"] }),
    refetchCycleEconomics: () => qc.invalidateQueries({ queryKey: ["organism", "cycleEconomics"] }),
  };
}

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// TREASURY HOOKS
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

/**
 * Hook for treasury and token operations
 */
export function useTreasury() {
  const { actor, isFetching } = useActor();
  const { identity } = useInternetIdentity();
  const qc = useQueryClient();

  // Token balances query
  const tokenBalancesQuery = useQuery<TokenBalances | null>({
    queryKey: ["treasury", "balances"],
    queryFn: async () => {
      if (!actor || !identity) return null;
      try {
        const balances = await (actor as any).getTokenBalances();
        return {
          seed: Number(balances.seed),
          forma: Number(balances.forma),
          gtk: Number(balances.gtk),
          cvt: Number(balances.cvt),
          vct: Number(balances.vct),
          knt: Number(balances.knt),
          sbt: Number(balances.sbt),
          hbt: Number(balances.hbt),
          drt: Number(balances.drt),
          omt: Number(balances.omt),
          mth: Number(balances.mth),
          mrc: Number(balances.mrc),
        };
      } catch (e) {
        console.error("Failed to fetch token balances:", e);
        return null;
      }
    },
    enabled: !!actor && !isFetching && !!identity,
    staleTime: 10000,
  });

  // Treasury summary query
  const summaryQuery = useQuery<TreasurySummary | null>({
    queryKey: ["treasury", "summary"],
    queryFn: async () => {
      if (!actor || !identity) return null;
      try {
        const summary = await (actor as any).getTreasurySummary();
        return {
          totalAccounts: Number(summary.totalAccounts),
          totalTransactions: Number(summary.totalTransactions),
          totalForma: Number(summary.totalForma),
          totalSeed: Number(summary.totalSeed),
          totalGtk: Number(summary.totalGtk),
        };
      } catch (e) {
        console.error("Failed to fetch treasury summary:", e);
        return null;
      }
    },
    enabled: !!actor && !isFetching && !!identity,
    staleTime: 30000,
  });

  // Revenue summary query
  const revenueQuery = useQuery<RevenueSummary | null>({
    queryKey: ["treasury", "revenue"],
    queryFn: async () => {
      if (!actor || !identity) return null;
      try {
        const summary = await (actor as any).getRevenueSummary();
        return {
          totalGenerated: Number(summary.totalGenerated),
          architectTotal: Number(summary.architectTotal),
          playerTotal: Number(summary.playerTotal),
          pendingDistribution: Number(summary.pendingDistribution),
          eventCount: Number(summary.eventCount),
        };
      } catch (e) {
        console.error("Failed to fetch revenue summary:", e);
        return null;
      }
    },
    enabled: !!actor && !isFetching && !!identity,
    staleTime: 30000,
  });

  // Jubilee status query
  const jubileeQuery = useQuery<JubileeStatus | null>({
    queryKey: ["treasury", "jubilee"],
    queryFn: async () => {
      if (!actor || !identity) return null;
      try {
        const status = await (actor as any).getJubileeStatus();
        return {
          currentCycle: Number(status.currentCycle),
          cycleStartBeat: Number(status.cycleStartBeat),
          beatsUntilJubilee: Number(status.beatsUntilJubilee),
          debtForgiven: Number(status.debtForgiven),
          slavesFreed: Number(status.slavesFreed),
          landReturned: Number(status.landReturned),
          lastJubileeTimestamp: Number(status.lastJubileeTimestamp),
        };
      } catch (e) {
        console.error("Failed to fetch jubilee status:", e);
        return null;
      }
    },
    enabled: !!actor && !isFetching && !!identity,
    staleTime: 60000,
  });

  // Create treasury account mutation
  const createAccountMutation = useMutation<string, Error, { accountType: "Personal" | "Organism" | "Team" | "Project" | "System" }>({
    mutationFn: async ({ accountType }) => {
      if (!actor) throw new Error("No actor");
      const variant = { [accountType]: null };
      return await (actor as any).createTreasuryAccount(variant);
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["treasury"] });
    },
  });

  // Transfer tokens mutation
  const transferMutation = useMutation<boolean, Error, { fromAccountId: string; toAccountId: string; tokenType: string; amount: number; memo?: string }>({
    mutationFn: async ({ fromAccountId, toAccountId, tokenType, amount, memo }) => {
      if (!actor) throw new Error("No actor");
      const tokenVariant = { [tokenType]: null };
      const memoOpt = memo ? [memo] : [];
      return await (actor as any).transferTokens(fromAccountId, toAccountId, tokenVariant, amount, memoOpt);
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["treasury"] });
    },
  });

  // Mint tokens mutation (admin only)
  const mintMutation = useMutation<boolean, Error, { toAccountId: string; tokenType: string; amount: number; reason: string }>({
    mutationFn: async ({ toAccountId, tokenType, amount, reason }) => {
      if (!actor) throw new Error("No actor");
      const tokenVariant = { [tokenType]: null };
      return await (actor as any).mintTokens(toAccountId, tokenVariant, amount, reason);
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["treasury"] });
    },
  });

  // Execute Jubilee mutation
  const jubileeMutation = useMutation<boolean>({
    mutationFn: async () => {
      if (!actor) throw new Error("No actor");
      return await (actor as any).executeJubilee();
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["treasury"] });
    },
  });

  return {
    // State queries
    tokenBalances: tokenBalancesQuery.data,
    treasurySummary: summaryQuery.data,
    revenueSummary: revenueQuery.data,
    jubileeStatus: jubileeQuery.data,
    
    // Loading states
    isLoading: tokenBalancesQuery.isLoading,
    
    // Mutations
    createAccount: createAccountMutation.mutateAsync,
    transferTokens: transferMutation.mutateAsync,
    mintTokens: mintMutation.mutateAsync,
    executeJubilee: jubileeMutation.mutateAsync,
    
    // Refetch
    refetchAll: () => qc.invalidateQueries({ queryKey: ["treasury"] }),
  };
}

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// GOVERNANCE HOOKS
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

/**
 * Hook for governance and compliance operations
 */
export function useGovernance() {
  const { actor, isFetching } = useActor();
  const { identity } = useInternetIdentity();
  const qc = useQueryClient();

  // AEGIS status query
  const aegisQuery = useQuery<AEGISStatus | null>({
    queryKey: ["governance", "aegis"],
    queryFn: async () => {
      if (!actor || !identity) return null;
      try {
        const status = await (actor as any).getAEGISStatus();
        return {
          emergencyMode: status.emergencyMode,
          shieldStrength: Number(status.shieldStrength),
          rollbackCount: Number(status.rollbackCount),
          lastRollbackBeat: Number(status.lastRollbackBeat),
          currentSlot: Number(status.currentSlot),
          snapshotCount: Number(status.snapshotCount),
          eventCount: Number(status.eventCount),
        };
      } catch (e) {
        console.error("Failed to fetch AEGIS status:", e);
        return null;
      }
    },
    enabled: !!actor && !isFetching && !!identity,
    staleTime: 5000,
  });

  // Compliance summary query
  const complianceQuery = useQuery<ComplianceSummary | null>({
    queryKey: ["governance", "compliance"],
    queryFn: async () => {
      if (!actor || !identity) return null;
      try {
        const summary = await (actor as any).getComplianceSummary();
        return {
          overallScore: Number(summary.overallScore),
          totalChecks: Number(summary.totalChecks),
          openViolations: Number(summary.openViolations),
          criticalViolations: Number(summary.criticalViolations),
          lastCheckBeat: Number(summary.lastCheckBeat),
          isCompliant: summary.isCompliant,
        };
      } catch (e) {
        console.error("Failed to fetch compliance summary:", e);
        return null;
      }
    },
    enabled: !!actor && !isFetching && !!identity,
    staleTime: 30000,
  });

  // Audit summary query
  const auditQuery = useQuery<AuditSummary | null>({
    queryKey: ["governance", "audit"],
    queryFn: async () => {
      if (!actor || !identity) return null;
      try {
        const summary = await (actor as any).getAuditSummary();
        return {
          totalEvents: Number(summary.totalEvents),
          successfulEvents: Number(summary.successfulEvents),
          failedEvents: Number(summary.failedEvents),
          eventsByType: summary.eventsByType || [],
          recentEvents: summary.recentEvents || [],
        };
      } catch (e) {
        console.error("Failed to fetch audit summary:", e);
        return null;
      }
    },
    enabled: !!actor && !isFetching && !!identity,
    staleTime: 30000,
  });

  // Take AEGIS snapshot mutation
  const snapshotMutation = useMutation<number>({
    mutationFn: async () => {
      if (!actor) throw new Error("No actor");
      return Number(await (actor as any).takeAEGISSnapshot());
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["governance", "aegis"] });
    },
  });

  // Rollback to snapshot mutation
  const rollbackMutation = useMutation<boolean, Error, number>({
    mutationFn: async (slot) => {
      if (!actor) throw new Error("No actor");
      return await (actor as any).rollbackToSnapshot(slot);
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["governance"] });
      qc.invalidateQueries({ queryKey: ["organism"] });
    },
  });

  // Emergency stop mutation
  const emergencyStopMutation = useMutation<boolean, Error, string>({
    mutationFn: async (reason) => {
      if (!actor) throw new Error("No actor");
      return await (actor as any).triggerEmergencyStop(reason);
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["governance", "aegis"] });
    },
  });

  // Run compliance check mutation
  const complianceCheckMutation = useMutation<string, Error, { targetEntity: string; targetType: string; checkType: string }>({
    mutationFn: async ({ targetEntity, targetType, checkType }) => {
      if (!actor) throw new Error("No actor");
      const checkVariant = { [checkType]: null };
      return await (actor as any).runComplianceCheck(targetEntity, targetType, checkVariant);
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["governance", "compliance"] });
    },
  });

  // Generate compliance report mutation
  const generateReportMutation = useMutation<string, Error, string>({
    mutationFn: async (reportType) => {
      if (!actor) throw new Error("No actor");
      const typeVariant = { [reportType]: null };
      return await (actor as any).generateComplianceReport(typeVariant);
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["governance"] });
    },
  });

  return {
    // State queries
    aegisStatus: aegisQuery.data,
    complianceSummary: complianceQuery.data,
    auditSummary: auditQuery.data,
    
    // Loading states
    isLoading: aegisQuery.isLoading,
    
    // Mutations
    takeSnapshot: snapshotMutation.mutateAsync,
    rollbackToSnapshot: rollbackMutation.mutateAsync,
    triggerEmergencyStop: emergencyStopMutation.mutateAsync,
    runComplianceCheck: complianceCheckMutation.mutateAsync,
    generateComplianceReport: generateReportMutation.mutateAsync,
    
    // Pending states
    isSnapshotPending: snapshotMutation.isPending,
    isRollbackPending: rollbackMutation.isPending,
    isEmergencyStopPending: emergencyStopMutation.isPending,
    
    // Refetch
    refetchAll: () => qc.invalidateQueries({ queryKey: ["governance"] }),
  };
}

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// TASK ORCHESTRATION HOOKS
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

export interface Task {
  id: string;
  title: string;
  description: string;
  taskType: string;
  priority: string;
  status: string;
  assignedOrganism: string | null;
  assignedTeam: string | null;
  creator: string;
  createdAt: number;
  updatedAt: number;
  deadline: number | null;
  estimatedHours: number;
  actualHours: number;
  tags: string[];
}

export interface Project {
  id: string;
  name: string;
  description: string;
  owner: string;
  status: string;
  createdAt: number;
  budget: number;
  spent: number;
  tasks: string[];
  sprints: string[];
}

/**
 * Hook for task and project management
 */
export function useTaskOrchestration() {
  const { actor, isFetching } = useActor();
  const { identity } = useInternetIdentity();
  const qc = useQueryClient();

  // Pending tasks query
  const pendingTasksQuery = useQuery<Task[]>({
    queryKey: ["tasks", "pending"],
    queryFn: async () => {
      if (!actor || !identity) return [];
      try {
        const variant = { Pending: null };
        const tasks = await (actor as any).getTasksByStatus(variant);
        return tasks.map((t: any) => ({
          id: t.id,
          title: t.title,
          description: t.description,
          taskType: Object.keys(t.taskType)[0],
          priority: Object.keys(t.priority)[0],
          status: Object.keys(t.status)[0],
          assignedOrganism: t.assignedOrganism?.[0] || null,
          assignedTeam: t.assignedTeam?.[0] || null,
          creator: t.creator.toString(),
          createdAt: Number(t.createdAt),
          updatedAt: Number(t.updatedAt),
          deadline: t.deadline?.[0] ? Number(t.deadline[0]) : null,
          estimatedHours: Number(t.estimatedHours),
          actualHours: Number(t.actualHours),
          tags: t.tags,
        }));
      } catch (e) {
        console.error("Failed to fetch pending tasks:", e);
        return [];
      }
    },
    enabled: !!actor && !isFetching && !!identity,
    staleTime: 10000,
  });

  // All projects query
  const projectsQuery = useQuery<Project[]>({
    queryKey: ["projects"],
    queryFn: async () => {
      if (!actor || !identity) return [];
      try {
        const projects = await (actor as any).getAllProjects();
        return projects.map((p: any) => ({
          id: p.id,
          name: p.name,
          description: p.description,
          owner: p.owner.toString(),
          status: Object.keys(p.status)[0],
          createdAt: Number(p.createdAt),
          budget: Number(p.budget),
          spent: Number(p.spent),
          tasks: p.tasks,
          sprints: p.sprints,
        }));
      } catch (e) {
        console.error("Failed to fetch projects:", e);
        return [];
      }
    },
    enabled: !!actor && !isFetching && !!identity,
    staleTime: 30000,
  });

  // Create task mutation
  const createTaskMutation = useMutation<string, Error, {
    title: string;
    description: string;
    taskType: string;
    priority: string;
    deadline?: number;
    estimatedHours: number;
    parentTaskId?: string;
    dependencies: string[];
    tags: string[];
  }>({
    mutationFn: async (params) => {
      if (!actor) throw new Error("No actor");
      const taskTypeVariant = { [params.taskType]: null };
      const priorityVariant = { [params.priority]: null };
      const deadlineOpt = params.deadline ? [params.deadline] : [];
      const parentOpt = params.parentTaskId ? [params.parentTaskId] : [];
      
      return await (actor as any).createTask(
        params.title,
        params.description,
        taskTypeVariant,
        priorityVariant,
        deadlineOpt,
        params.estimatedHours,
        parentOpt,
        params.dependencies,
        params.tags
      );
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["tasks"] });
    },
  });

  // Create project mutation
  const createProjectMutation = useMutation<string, Error, {
    name: string;
    description: string;
    budget: number;
    startDate?: number;
    endDate?: number;
    tags: string[];
  }>({
    mutationFn: async (params) => {
      if (!actor) throw new Error("No actor");
      const startOpt = params.startDate ? [params.startDate] : [];
      const endOpt = params.endDate ? [params.endDate] : [];
      
      return await (actor as any).createProject(
        params.name,
        params.description,
        params.budget,
        startOpt,
        endOpt,
        params.tags
      );
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["projects"] });
    },
  });

  // Assign task mutation
  const assignTaskMutation = useMutation<boolean, Error, { taskId: string; organismId: string }>({
    mutationFn: async ({ taskId, organismId }) => {
      if (!actor) throw new Error("No actor");
      return await (actor as any).assignTask(taskId, organismId);
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["tasks"] });
    },
  });

  // Decompose task mutation
  const decomposeTaskMutation = useMutation<string[], Error, { taskId: string; subtaskTitles: string[]; reason: string }>({
    mutationFn: async ({ taskId, subtaskTitles, reason }) => {
      if (!actor) throw new Error("No actor");
      return await (actor as any).decomposeTask(taskId, subtaskTitles, reason);
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["tasks"] });
    },
  });

  return {
    // State queries
    pendingTasks: pendingTasksQuery.data ?? [],
    projects: projectsQuery.data ?? [],
    
    // Loading states
    isTasksLoading: pendingTasksQuery.isLoading,
    isProjectsLoading: projectsQuery.isLoading,
    
    // Mutations
    createTask: createTaskMutation.mutateAsync,
    createProject: createProjectMutation.mutateAsync,
    assignTask: assignTaskMutation.mutateAsync,
    decomposeTask: decomposeTaskMutation.mutateAsync,
    
    // Refetch
    refetchTasks: () => qc.invalidateQueries({ queryKey: ["tasks"] }),
    refetchProjects: () => qc.invalidateQueries({ queryKey: ["projects"] }),
  };
}

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// ARTIFACT LOG HOOK
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

/**
 * Hook for artifact log operations
 */
export function useArtifactLog() {
  const { actor, isFetching } = useActor();
  const { identity } = useInternetIdentity();
  const qc = useQueryClient();

  const artifactLogQuery = useQuery<ArtifactLogEntry[]>({
    queryKey: ["artifacts", "log"],
    queryFn: async () => {
      if (!actor || !identity) return [];
      try {
        const logs = await (actor as any).getArtifactLog(100); // Last 100 entries
        return logs.map((entry: any) => ({
          beat: Number(entry.beat),
          timestamp: Number(entry.timestamp),
          artifactType: entry.artifactType,
          description: entry.description,
          value: Number(entry.value),
        }));
      } catch (e) {
        console.error("Failed to fetch artifact log:", e);
        return [];
      }
    },
    enabled: !!actor && !isFetching && !!identity,
    staleTime: 10000,
  });

  return {
    artifactLog: artifactLogQuery.data ?? [],
    isLoading: artifactLogQuery.isLoading,
    refetch: () => qc.invalidateQueries({ queryKey: ["artifacts", "log"] }),
  };
}

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// REAL-TIME LIVE VIEWER HOOK
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

/**
 * Hook for real-time organism live viewing with auto-tick
 */
export function useLiveViewer(autoTick: boolean = false, tickIntervalMs: number = 3000) {
  const { actor, isFetching } = useActor();
  const { identity } = useInternetIdentity();
  const qc = useQueryClient();
  const [lastTickResult, setLastTickResult] = useState<OrganismHeartbeatResult | null>(null);
  const [isTickRunning, setIsTickRunning] = useState(false);

  // Auto-tick effect
  useEffect(() => {
    if (!autoTick || !actor || !identity || isFetching) return;

    const tick = async () => {
      if (isTickRunning) return;
      setIsTickRunning(true);
      try {
        const result = await (actor as any).runOrganismHeartbeat();
        const mapped: OrganismHeartbeatResult = {
          beat: Number(result.beat),
          kuramotoR: Number(result.kuramotoR),
          lawsExecuted: Number(result.lawsExecuted),
          lawEngineScore: Number(result.lawEngineScore),
          driftTotal: Number(result.driftTotal),
          heritageAvg: Number(result.heritageAvg),
          omnisCharge: Number(result.omnisCharge),
          macroSphereR: Number(result.macroSphereR),
          isStable: result.isStable,
        };
        setLastTickResult(mapped);
        qc.invalidateQueries({ queryKey: ["organism"] });
      } catch (e) {
        console.error("Live tick failed:", e);
      } finally {
        setIsTickRunning(false);
      }
    };

    const interval = setInterval(tick, tickIntervalMs);
    return () => clearInterval(interval);
  }, [autoTick, actor, identity, isFetching, tickIntervalMs, isTickRunning, qc]);

  // Manual tick function
  const manualTick = async (): Promise<OrganismHeartbeatResult | null> => {
    if (!actor || !identity) return null;
    setIsTickRunning(true);
    try {
      const result = await (actor as any).runOrganismHeartbeat();
      const mapped: OrganismHeartbeatResult = {
        beat: Number(result.beat),
        kuramotoR: Number(result.kuramotoR),
        lawsExecuted: Number(result.lawsExecuted),
        lawEngineScore: Number(result.lawEngineScore),
        driftTotal: Number(result.driftTotal),
        heritageAvg: Number(result.heritageAvg),
        omnisCharge: Number(result.omnisCharge),
        macroSphereR: Number(result.macroSphereR),
        isStable: result.isStable,
      };
      setLastTickResult(mapped);
      qc.invalidateQueries({ queryKey: ["organism"] });
      return mapped;
    } catch (e) {
      console.error("Manual tick failed:", e);
      return null;
    } finally {
      setIsTickRunning(false);
    }
  };

  return {
    lastTickResult,
    isTickRunning,
    manualTick,
    isConnected: !!actor && !!identity && !isFetching,
  };
}

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// GEO-RESONANCE PATTERN ENGINE (GRPE) HOOKS
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

// Risk level thresholds (phi-derived)
const GRPE_RISK_LOW = 0.25;       // φ⁻³ ≈ 0.236, rounded to 0.25
const GRPE_RISK_MEDIUM = 0.50;   // Mid-point
const GRPE_RISK_HIGH = 0.75;     // φ⁻¹ ≈ 0.618, upper bound

// Helper function to map operational mode number to string
const mapOperationalMode = (mode: number): "NoIoTPassive" | "EdgeIoT" | "Hybrid" => {
  switch (mode) {
    case 0: return "NoIoTPassive";
    case 1: return "EdgeIoT";
    case 2: return "Hybrid";
    default: return "NoIoTPassive";
  }
};

// Helper function to map resonance/risk value to risk level
const mapRiskLevel = (value: number): "Low" | "Medium" | "High" | "Critical" => {
  if (value > GRPE_RISK_HIGH) return "Critical";
  if (value > GRPE_RISK_MEDIUM) return "High";
  if (value > GRPE_RISK_LOW) return "Medium";
  return "Low";
};

export interface GRPEState {
  lastScanLatitude: number;
  lastScanLongitude: number;
  lastScanAltitude: number;
  lastScanTimestamp: number;
  operationalMode: "NoIoTPassive" | "EdgeIoT" | "Hybrid";
  totalScans: number;
  hotspotCount: number;
  forwardPatternsFound: number;
  inversePatternsFound: number;
  overlapHotspotsFound: number;
  maxFieldAnomaly: number;
  minFieldAnomaly: number;
  avgDriftRisk: number;
  memoryIndexCount: number;
}

export interface GRPEScanResult {
  latitude: number;
  longitude: number;
  altitude: number;
  totalResonance: number;
  isHotspot: boolean;
  forwardPatternMatch: boolean;
  inversePatternMatch: boolean;
  isOverlapHotspot: boolean;
  layerScores: {
    geomagnetic: number;
    sacredSite: number;
    hydroKarst: number;
    astroCalendar: number;
    collapseConflict: number;
    canonLegal: number;
    inverseSignature: number;
  };
  magneticField: {
    intensity: number;
    declination: number;
    inclination: number;
  };
  riskLevel: "Low" | "Medium" | "High" | "Critical";
}

export interface GRPECalendarState {
  solarDayOfYear: number;
  solarYear: number;
  lunarPhase: number;
  lunarDaySinceNew: number;
  siderealPrecessionAngle: number;
  zodiacAge: string;
  operationalCycle: number;
  operationalShiftPhase: number;
  missionDayInCycle: number;
  mayanTzolkinDay: number;
  mayanTzolkinTrecena: number;
  mayanHaabDay: number;
  mayanHaabMonth: number;
}

export interface GRPELayerScores {
  geomagnetic: number;
  sacredSite: number;
  hydroKarst: number;
  astroCalendar: number;
  collapseConflict: number;
  canonLegal: number;
  inverseSignature: number;
  totalWeightedResonance: number;
}

export interface GRPERiskSummary {
  driftRiskLevel: "Low" | "Medium" | "High" | "Critical";
  interferenceRisk: number;
  jammingLikelihood: number;
  infrastructureStress: number;
  anomalyScore: number;
}

/**
 * Hook for Geo-Resonance Pattern Engine operations
 * World-scale field scanner for defense, infrastructure, and enterprise
 */
export function useGRPE() {
  const { actor, isFetching } = useActor();
  const { identity } = useInternetIdentity();
  const qc = useQueryClient();

  // GRPE State query
  const stateQuery = useQuery<GRPEState | null>({
    queryKey: ["grpe", "state"],
    queryFn: async () => {
      if (!actor || !identity) return null;
      try {
        const state = await (actor as any).getGRPEState();
        return {
          lastScanLatitude: Number(state.lastScanLatitude),
          lastScanLongitude: Number(state.lastScanLongitude),
          lastScanAltitude: Number(state.lastScanAltitude),
          lastScanTimestamp: Number(state.lastScanTimestamp),
          operationalMode: mapOperationalMode(state.operationalMode),
          totalScans: Number(state.totalScans),
          hotspotCount: Number(state.hotspotCount),
          forwardPatternsFound: Number(state.forwardPatternsFound),
          inversePatternsFound: Number(state.inversePatternsFound),
          overlapHotspotsFound: Number(state.overlapHotspotsFound),
          maxFieldAnomaly: Number(state.maxFieldAnomaly),
          minFieldAnomaly: Number(state.minFieldAnomaly),
          avgDriftRisk: Number(state.avgDriftRisk),
          memoryIndexCount: Number(state.memoryIndexCount),
        };
      } catch (e) {
        console.error("Failed to fetch GRPE state:", e);
        return null;
      }
    },
    enabled: !!actor && !isFetching && !!identity,
    staleTime: 5000,
  });

  // Calendar state query
  const calendarQuery = useQuery<GRPECalendarState | null>({
    queryKey: ["grpe", "calendar"],
    queryFn: async () => {
      if (!actor || !identity) return null;
      try {
        const cal = await (actor as any).getGRPECalendarState();
        return {
          solarDayOfYear: Number(cal.solarDayOfYear),
          solarYear: Number(cal.solarYear),
          lunarPhase: Number(cal.lunarPhase),
          lunarDaySinceNew: Number(cal.lunarDaySinceNew),
          siderealPrecessionAngle: Number(cal.siderealPrecessionAngle),
          zodiacAge: cal.zodiacAge,
          operationalCycle: Number(cal.operationalCycle),
          operationalShiftPhase: Number(cal.operationalShiftPhase),
          missionDayInCycle: Number(cal.missionDayInCycle),
          mayanTzolkinDay: Number(cal.mayanTzolkinDay),
          mayanTzolkinTrecena: Number(cal.mayanTzolkinTrecena),
          mayanHaabDay: Number(cal.mayanHaabDay),
          mayanHaabMonth: Number(cal.mayanHaabMonth),
        };
      } catch (e) {
        console.error("Failed to fetch GRPE calendar state:", e);
        return null;
      }
    },
    enabled: !!actor && !isFetching && !!identity,
    staleTime: 30000,
  });

  // Layer scores query
  const layerScoresQuery = useQuery<GRPELayerScores | null>({
    queryKey: ["grpe", "layers"],
    queryFn: async () => {
      if (!actor || !identity) return null;
      try {
        const scores = await (actor as any).getGRPELayerScores();
        return {
          geomagnetic: Number(scores.geomagnetic),
          sacredSite: Number(scores.sacredSite),
          hydroKarst: Number(scores.hydroKarst),
          astroCalendar: Number(scores.astroCalendar),
          collapseConflict: Number(scores.collapseConflict),
          canonLegal: Number(scores.canonLegal),
          inverseSignature: Number(scores.inverseSignature),
          totalWeightedResonance: Number(scores.totalWeightedResonance),
        };
      } catch (e) {
        console.error("Failed to fetch GRPE layer scores:", e);
        return null;
      }
    },
    enabled: !!actor && !isFetching && !!identity,
    staleTime: 5000,
  });

  // Risk summary query
  const riskQuery = useQuery<GRPERiskSummary | null>({
    queryKey: ["grpe", "risk"],
    queryFn: async () => {
      if (!actor || !identity) return null;
      try {
        const risk = await (actor as any).getGRPERiskSummary();
        const driftLevel = Number(risk.driftRiskLevel);
        return {
          driftRiskLevel: mapRiskLevel(driftLevel),
          interferenceRisk: Number(risk.interferenceRisk),
          jammingLikelihood: Number(risk.jammingLikelihood),
          infrastructureStress: Number(risk.infrastructureStress),
          anomalyScore: Number(risk.anomalyScore),
        };
      } catch (e) {
        console.error("Failed to fetch GRPE risk summary:", e);
        return null;
      }
    },
    enabled: !!actor && !isFetching && !!identity,
    staleTime: 5000,
  });

  // Run scan mutation
  const scanMutation = useMutation<GRPEScanResult, Error, { latitude: number; longitude: number; altitude: number }>({
    mutationFn: async ({ latitude, longitude, altitude }) => {
      if (!actor) throw new Error("No actor");
      const result = await (actor as any).runGRPEScan(latitude, longitude, altitude);
      const totalRes = Number(result.totalResonance);
      return {
        latitude,
        longitude,
        altitude,
        totalResonance: totalRes,
        isHotspot: result.isHotspot,
        forwardPatternMatch: result.forwardPatternMatch,
        inversePatternMatch: result.inversePatternMatch,
        isOverlapHotspot: result.isOverlapHotspot,
        layerScores: {
          geomagnetic: Number(result.layerScores[0] || 0),
          sacredSite: Number(result.layerScores[1] || 0),
          hydroKarst: Number(result.layerScores[2] || 0),
          astroCalendar: Number(result.layerScores[3] || 0),
          collapseConflict: Number(result.layerScores[4] || 0),
          canonLegal: Number(result.layerScores[5] || 0),
          inverseSignature: Number(result.layerScores[6] || 0),
        },
        magneticField: {
          intensity: Number(result.magneticIntensity),
          declination: Number(result.magneticDeclination),
          inclination: Number(result.magneticInclination),
        },
        riskLevel: mapRiskLevel(totalRes),
      };
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["grpe"] });
    },
  });

  // Set operational mode mutation
  const setModeMutation = useMutation<boolean, Error, number>({
    mutationFn: async (mode) => {
      if (!actor) throw new Error("No actor");
      return await (actor as any).setGRPEOperationalMode(mode);
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["grpe", "state"] });
    },
  });

  // Calculate magnetic field at location
  const getMagneticField = async (latitude: number, longitude: number, altitude: number) => {
    if (!actor) return null;
    try {
      const field = await (actor as any).calculateMagneticField(latitude, longitude, altitude);
      return {
        intensity: Number(field.intensity),
        declination: Number(field.declination),
        inclination: Number(field.inclination),
        horizontalIntensity: Number(field.horizontalIntensity),
        inSAA: field.inSAA,
      };
    } catch (e) {
      console.error("Failed to calculate magnetic field:", e);
      return null;
    }
  };

  return {
    // State queries
    state: stateQuery.data,
    calendarState: calendarQuery.data,
    layerScores: layerScoresQuery.data,
    riskSummary: riskQuery.data,
    
    // Loading states
    isLoading: stateQuery.isLoading,
    isScanPending: scanMutation.isPending,
    
    // Mutations
    runScan: scanMutation.mutateAsync,
    setOperationalMode: setModeMutation.mutateAsync,
    getMagneticField,
    
    // Last scan result
    lastScanResult: scanMutation.data,
    
    // Refetch all
    refetchAll: () => qc.invalidateQueries({ queryKey: ["grpe"] }),
  };
}

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// ENTERPRISE COMPOSITE HOOK
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

/**
 * Composite hook that provides heritage and brain state for enterprise components.
 */
export function useEnterprise(_opts?: { enabled?: boolean }) {
  const brain = useOrganismBrain();

  const heritage = useMemo(() => ({
    heritage: brain.heritageState
      ? {
          revolucionario: brain.heritageState.revolucionario,
          zapata: brain.heritageState.zapata,
          villa: brain.heritageState.villa,
          independencia: brain.heritageState.independencia,
          hidalgo: brain.heritageState.hidalgo,
          adelita: brain.heritageState.adelita,
          morelos: brain.heritageState.morelos,
          heritage_avg: brain.heritageState.average,
          pentecostPrecursor: brain.heritageState.pentecostPrecursor,
        }
      : null,
    isLoading: brain.isLoading,
  }), [brain.heritageState, brain.isLoading]);

  return {
    heritage,
    brain: {
      coherence: brain.fullState?.heritageAvg ?? 0,
      brainState: brain.brainState ?? null,
      isLoading: brain.isBrainStateLoading,
    },
  };
}
