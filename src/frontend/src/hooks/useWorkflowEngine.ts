/**
 * ╔═══════════════════════════════════════════════════════════════════════════════╗
 * ║              WORKFLOW ENGINE HOOK — ICP-WIRED TASK EXECUTION                   ║
 * ║         Real workflow orchestration through Command Center → ICP Backend       ║
 * ╠═══════════════════════════════════════════════════════════════════════════════╣
 * ║  This hook connects the frontend Command Center to real ICP backend execution  ║
 * ║  - Workflows execute through organism workforceChat calls                       ║
 * ║  - Each task maps to a specialized organism                                     ║
 * ║  - Results are stored as artifacts on-chain                                     ║
 * ║  - Enterprise sync through ICP state                                           ║
 * ╚═══════════════════════════════════════════════════════════════════════════════╝
 */

import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { useCallback, useEffect, useMemo, useRef, useState } from "react";
import {
  AGENT_SPECIALIZATIONS,
  type Agent,
  type AgentSpecialization,
  type Alert,
  type CommandCenterMetrics,
  type Task,
  type TaskPriority,
  type TaskStatus,
  createCommandCenter,
} from "../data/commandCenter";
import type {
  Organism,
  OrganismSpecialization,
  WorkforceMessage,
} from "../organisms";
import { useActor } from "./useActor";
import { useInternetIdentity } from "./useInternetIdentity";
import { useOrganisms } from "./useOrganisms";

// ─────────────────────────────────────────────────────────────────────────────────
// WORKFLOW TYPES
// ─────────────────────────────────────────────────────────────────────────────────

/**
 * Workflow categories matching backend
 */
export type WorkflowCategory =
  | "Internal" // Self-improvement
  | "External" // World learning
  | "Task" // Enterprise work
  | "Emergency" // Crisis response
  | "Maintenance"; // System upkeep

/**
 * Workflow execution status
 */
export type WorkflowStatus =
  | "NotStarted"
  | "InProgress"
  | "Paused"
  | "Completed"
  | "Failed"
  | "Cancelled"
  | "Blocked";

/**
 * A workflow execution instance
 */
export interface WorkflowExecution {
  readonly id: string;
  readonly workflowId: string;
  readonly name: string;
  readonly description: string;
  readonly category: WorkflowCategory;
  readonly status: WorkflowStatus;
  readonly priority: TaskPriority;
  readonly assignedOrganismId?: string;
  readonly assignedOrganismName?: string;
  readonly input: Record<string, unknown>;
  readonly output?: Record<string, unknown>;
  readonly artifactIds: string[];
  readonly progress: number;
  readonly startedAt?: number;
  readonly completedAt?: number;
  readonly error?: string;
  readonly threadId: string;
}

/**
 * Workflow definition template
 */
export interface WorkflowTemplate {
  readonly id: string;
  readonly name: string;
  readonly description: string;
  readonly category: WorkflowCategory;
  readonly requiredSpecializations: OrganismSpecialization[];
  readonly estimatedDuration: number; // seconds
  readonly inputSchema: Record<
    string,
    "string" | "number" | "boolean" | "object"
  >;
}

// ─────────────────────────────────────────────────────────────────────────────────
// WORKFLOW TEMPLATES — Maps to backend task-workflows.mo
// ─────────────────────────────────────────────────────────────────────────────────

export const WORKFLOW_TEMPLATES: WorkflowTemplate[] = [
  // CODING WORKFLOWS
  {
    id: "write_code",
    name: "Write Code",
    description: "Generate production-ready code",
    category: "Task",
    requiredSpecializations: ["SoftwareEngineering"],
    estimatedDuration: 180,
    inputSchema: {
      prompt: "string",
      language: "string",
      requirements: "string",
    },
  },
  {
    id: "code_review",
    name: "Code Review",
    description: "Review code for quality, security, and best practices",
    category: "Task",
    requiredSpecializations: ["SoftwareEngineering"],
    estimatedDuration: 120,
    inputSchema: { code: "string", context: "string" },
  },
  {
    id: "architecture_design",
    name: "Architecture Design",
    description: "Design system architecture",
    category: "Task",
    requiredSpecializations: ["Architecture", "SoftwareEngineering"],
    estimatedDuration: 300,
    inputSchema: { requirements: "string", constraints: "string" },
  },
  // ANALYSIS WORKFLOWS
  {
    id: "data_analysis",
    name: "Data Analysis",
    description: "Analyze data and generate insights",
    category: "Task",
    requiredSpecializations: ["DataAnalysis"],
    estimatedDuration: 240,
    inputSchema: { dataset: "string", questions: "string" },
  },
  {
    id: "market_analysis",
    name: "Market Analysis",
    description: "Analyze market trends and competition",
    category: "Task",
    requiredSpecializations: ["Strategy", "DataAnalysis"],
    estimatedDuration: 300,
    inputSchema: { market: "string", competitors: "string" },
  },
  // WRITING WORKFLOWS
  {
    id: "write_document",
    name: "Write Document",
    description: "Create professional documentation",
    category: "Task",
    requiredSpecializations: ["Documentation"],
    estimatedDuration: 180,
    inputSchema: { topic: "string", format: "string", audience: "string" },
  },
  {
    id: "legal_review",
    name: "Legal Review",
    description: "Review documents for legal compliance",
    category: "Task",
    requiredSpecializations: ["Legal", "Compliance"],
    estimatedDuration: 240,
    inputSchema: { document: "string", jurisdiction: "string" },
  },
  // STRATEGY WORKFLOWS
  {
    id: "strategy_planning",
    name: "Strategy Planning",
    description: "Develop strategic plans",
    category: "Task",
    requiredSpecializations: ["Strategy"],
    estimatedDuration: 360,
    inputSchema: {
      objective: "string",
      constraints: "string",
      timeline: "string",
    },
  },
  {
    id: "campaign_design",
    name: "Campaign Design",
    description: "Design marketing campaigns",
    category: "Task",
    requiredSpecializations: ["Campaign", "Marketing"],
    estimatedDuration: 300,
    inputSchema: { product: "string", audience: "string", budget: "string" },
  },
  // OPERATIONS WORKFLOWS
  {
    id: "process_optimization",
    name: "Process Optimization",
    description: "Optimize business processes",
    category: "Task",
    requiredSpecializations: ["Operations"],
    estimatedDuration: 240,
    inputSchema: {
      process: "string",
      metrics: "string",
      constraints: "string",
    },
  },
  {
    id: "security_audit",
    name: "Security Audit",
    description: "Audit security posture",
    category: "Task",
    requiredSpecializations: ["Cybersecurity"],
    estimatedDuration: 360,
    inputSchema: { scope: "string", standards: "string" },
  },
  // INTERNAL WORKFLOWS (self-improvement)
  {
    id: "coherence_restoration",
    name: "Coherence Restoration",
    description: "Restore organism coherence through Hebbian learning",
    category: "Internal",
    requiredSpecializations: ["Orchestration"],
    estimatedDuration: 60,
    inputSchema: { targetCoherence: "number" },
  },
  {
    id: "memory_consolidation",
    name: "Memory Consolidation",
    description: "Consolidate episodic memory to long-term",
    category: "Internal",
    requiredSpecializations: ["Orchestration"],
    estimatedDuration: 120,
    inputSchema: {},
  },
  // EXTERNAL WORKFLOWS (world learning)
  {
    id: "research_deep_dive",
    name: "Research Deep Dive",
    description: "Deep research on a topic",
    category: "External",
    requiredSpecializations: ["DataAnalysis", "Strategy"],
    estimatedDuration: 300,
    inputSchema: { topic: "string", depth: "string", sources: "string" },
  },
];

// ─────────────────────────────────────────────────────────────────────────────────
// SPECIALIZATION MAPPING
// ─────────────────────────────────────────────────────────────────────────────────

/**
 * Maps organism specialization to best-fit agent specialization
 */
function mapOrgToAgentSpec(
  orgSpec: OrganismSpecialization,
): AgentSpecialization {
  const mapping: Record<OrganismSpecialization, AgentSpecialization> = {
    Architecture: "planning",
    Brand: "creativity",
    Campaign: "creativity",
    Communication: "communication",
    Compliance: "verification",
    Cybersecurity: "security",
    DataAnalysis: "analysis",
    DevOps: "execution",
    Documentation: "writing",
    Finance: "analysis",
    Healthcare: "research",
    HumanResources: "communication",
    Legal: "research",
    Marketing: "creativity",
    Media: "creativity",
    Operations: "execution",
    Orchestration: "reasoning",
    Sales: "communication",
    SoftwareEngineering: "coding",
    Strategy: "planning",
  };
  // "reasoning" is the safest general-purpose fallback — it can handle any task
  // that doesn't map cleanly to a more specialized agent type
  return mapping[orgSpec] ?? "reasoning";
}

/**
 * Find best organism for a workflow based on required specializations.
 * Uses mapOrgToAgentSpec to add an agent-alignment bonus: organisms whose
 * primary specialization maps to the same agent category as the required
 * specs score slightly higher, ensuring the right cognitive type is selected.
 */
function findBestOrganism(
  organisms: Organism[],
  requiredSpecs: OrganismSpecialization[],
): Organism | undefined {
  // Pre-compute the set of agent specializations needed for this workflow
  const requiredAgentSpecs = new Set(requiredSpecs.map(mapOrgToAgentSpec));

  // Score organisms by how many required specs they have + coherence
  let bestOrg: Organism | undefined;
  let bestScore = -1;

  for (const org of organisms) {
    let matchCount = 0;
    for (const req of requiredSpecs) {
      if (org.specializations.includes(req)) {
        matchCount++;
      }
    }
    // Score = match percentage + coherence bonus + forma bonus
    const matchScore = matchCount / Math.max(requiredSpecs.length, 1);
    const coherenceBonus = org.shell.coherence * 0.3;
    const formaBonus = Math.min(org.shell.formaBalance / 1000, 0.1);

    // Agent-alignment bonus: organism's primary spec maps to a required agent type
    const primaryAgentSpec = mapOrgToAgentSpec(
      org.specializations[0] ?? "Orchestration",
    );
    const agentAlignmentBonus = requiredAgentSpecs.has(primaryAgentSpec)
      ? 0.05
      : 0;

    const score =
      matchScore + coherenceBonus + formaBonus + agentAlignmentBonus;

    if (score > bestScore) {
      bestScore = score;
      bestOrg = org;
    }
  }

  return bestOrg;
}

// ─────────────────────────────────────────────────────────────────────────────────
// MAIN HOOK
// ─────────────────────────────────────────────────────────────────────────────────

export function useWorkflowEngine() {
  const { actor, isFetching } = useActor();
  const { identity } = useInternetIdentity();
  const { organisms, storeArtifact, refetchOrganisms } = useOrganisms();
  const qc = useQueryClient();

  // Local state for workflow executions
  const [executions, setExecutions] = useState<Map<string, WorkflowExecution>>(
    new Map(),
  );
  const [alerts, setAlerts] = useState<Alert[]>([]);
  const executionCounter = useRef(0);

  // Command center instance for local orchestration
  const _commandCenter = useMemo(() => createCommandCenter(), []);

  // ─────────────────────────────────────────────────────────────────────────────
  // QUERY: Colony Status
  // ─────────────────────────────────────────────────────────────────────────────

  const colonyStatusQuery = useQuery({
    queryKey: ["colonyStatus"],
    queryFn: async () => {
      if (!actor) return null;
      try {
        return await (actor as any).getColonyStatus();
      } catch {
        return null;
      }
    },
    enabled: !!actor && !isFetching,
    staleTime: 5_000,
  });

  // ─────────────────────────────────────────────────────────────────────────────
  // MUTATION: Execute Workflow
  // ─────────────────────────────────────────────────────────────────────────────

  const executeWorkflowMutation = useMutation({
    mutationFn: async ({
      templateId,
      input,
      priority = "normal",
    }: {
      templateId: string;
      input: Record<string, unknown>;
      priority?: TaskPriority;
    }) => {
      if (!actor || !identity) throw new Error("Not authenticated");

      const template = WORKFLOW_TEMPLATES.find((t) => t.id === templateId);
      if (!template)
        throw new Error(`Unknown workflow template: ${templateId}`);

      // Find best organism for this workflow
      const org = findBestOrganism(organisms, template.requiredSpecializations);
      if (!org)
        throw new Error("No suitable organism available for this workflow");

      // Generate execution ID and thread ID
      const executionId = `wf-${Date.now()}-${++executionCounter.current}`;
      const threadId = `thread-${executionId}`;

      // Create execution record
      const execution: WorkflowExecution = {
        id: executionId,
        workflowId: template.id,
        name: template.name,
        description: template.description,
        category: template.category,
        status: "InProgress",
        priority,
        assignedOrganismId: org.id,
        assignedOrganismName: org.name,
        input,
        artifactIds: [],
        progress: 0,
        startedAt: Date.now(),
        threadId,
      };

      // Store in local state
      setExecutions((prev) => new Map(prev).set(executionId, execution));

      // Build the prompt from input
      const promptParts = Object.entries(input).map(
        ([key, value]) => `${key}: ${JSON.stringify(value)}`,
      );
      const prompt = `[WORKFLOW: ${template.name}]\n\n${promptParts.join("\n")}`;

      // Execute via workforceChat on ICP
      const response: WorkforceMessage = await (actor as any).workforceChat(
        org.id,
        threadId,
        prompt,
      );

      // Update execution with result
      const completedExecution: WorkflowExecution = {
        ...execution,
        status: "Completed",
        progress: 1,
        completedAt: Date.now(),
        output: {
          content: response.content,
          artifactType: response.artifactType,
          artifactContent: response.artifactContent,
        },
        artifactIds: response.artifactContent
          ? [
              await storeArtifact({
                organismId: org.id,
                artifactType: response.artifactType ?? "document",
                title: `${template.name} - ${new Date().toISOString()}`,
                content: response.artifactContent,
              }),
            ]
          : [],
      };

      setExecutions((prev) =>
        new Map(prev).set(executionId, completedExecution),
      );

      // Refresh organisms to get updated shell state (FORMA, coherence)
      refetchOrganisms();

      return completedExecution;
    },
    onError: (error, variables) => {
      const _executionId = `wf-${Date.now()}-${executionCounter.current}`;
      setAlerts((prev) => [
        ...prev,
        {
          id: `alert-${Date.now()}`,
          severity: "error",
          source: "workflow_engine",
          message: `Workflow ${variables.templateId} failed: ${error.message}`,
          timestamp: Date.now(),
          acknowledged: false,
        },
      ]);
    },
  });

  // ─────────────────────────────────────────────────────────────────────────────
  // MUTATION: Initialize Colony
  // ─────────────────────────────────────────────────────────────────────────────

  const initColonyMutation = useMutation({
    mutationFn: async () => {
      if (!actor) throw new Error("No actor");
      return await (actor as any).initializeColony();
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["colonyStatus"] });
    },
  });

  // ─────────────────────────────────────────────────────────────────────────────
  // MUTATION: Colony Heartbeat
  // ─────────────────────────────────────────────────────────────────────────────

  const colonyHeartbeatMutation = useMutation({
    mutationFn: async () => {
      if (!actor) throw new Error("No actor");
      return await (actor as any).colonyHeartbeat();
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["colonyStatus"] });
      refetchOrganisms();
    },
  });

  // ─────────────────────────────────────────────────────────────────────────────
  // HELPERS
  // ─────────────────────────────────────────────────────────────────────────────

  const executeWorkflow = useCallback(
    (
      templateId: string,
      input: Record<string, unknown>,
      priority?: TaskPriority,
    ) => {
      return executeWorkflowMutation.mutateAsync({
        templateId,
        input,
        priority,
      });
    },
    [executeWorkflowMutation],
  );

  const getWorkflowsByStatus = useCallback(
    (status: WorkflowStatus): WorkflowExecution[] => {
      return Array.from(executions.values()).filter((e) => e.status === status);
    },
    [executions],
  );

  const getWorkflowsByCategory = useCallback(
    (category: WorkflowCategory): WorkflowExecution[] => {
      return Array.from(executions.values()).filter(
        (e) => e.category === category,
      );
    },
    [executions],
  );

  const acknowledgeAlert = useCallback((alertId: string) => {
    setAlerts((prev) =>
      prev.map((a) => (a.id === alertId ? { ...a, acknowledged: true } : a)),
    );
  }, []);

  // ─────────────────────────────────────────────────────────────────────────────
  // METRICS
  // ─────────────────────────────────────────────────────────────────────────────

  const metrics = useMemo((): CommandCenterMetrics => {
    const allExecutions = Array.from(executions.values());
    const completed = allExecutions.filter((e) => e.status === "Completed");
    const failed = allExecutions.filter((e) => e.status === "Failed");
    const inProgress = allExecutions.filter((e) => e.status === "InProgress");

    return {
      totalTasksCreated: allExecutions.length,
      totalTasksCompleted: completed.length,
      totalTasksFailed: failed.length,
      activeAgents: inProgress.length,
      queueLength: 0,
      averageTaskTime:
        completed.length > 0
          ? completed.reduce(
              (sum, e) => sum + ((e.completedAt ?? 0) - (e.startedAt ?? 0)),
              0,
            ) / completed.length
          : 0,
      throughput: completed.filter(
        (e) => (e.completedAt ?? 0) > Date.now() - 3600000,
      ).length,
      resourceUtilization:
        organisms.length > 0 ? inProgress.length / organisms.length : 0,
      uptime: 0,
    };
  }, [executions, organisms]);

  // ─────────────────────────────────────────────────────────────────────────────
  // RETURN
  // ─────────────────────────────────────────────────────────────────────────────

  return {
    // Templates
    templates: WORKFLOW_TEMPLATES,

    // Executions
    executions: Array.from(executions.values()),
    getWorkflowsByStatus,
    getWorkflowsByCategory,

    // Actions
    executeWorkflow,
    isExecuting: executeWorkflowMutation.isPending,

    // Colony
    colonyStatus: colonyStatusQuery.data,
    initColony: initColonyMutation.mutateAsync,
    colonyHeartbeat: colonyHeartbeatMutation.mutateAsync,
    isColonyInitializing: initColonyMutation.isPending,

    // Alerts
    alerts: alerts.filter((a) => !a.acknowledged),
    acknowledgeAlert,

    // Metrics
    metrics,

    // Organisms for UI
    availableOrganisms: organisms,
    findBestOrganism: (specs: OrganismSpecialization[]) =>
      findBestOrganism(organisms, specs),
  };
}
