// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  WORKFLOW ENGINE TYPES — ENTERPRISE WORKFLOW ORCHESTRATION                                                ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
// ║  Location:     Dallas, Texas, United States of America                                                    ║
// ║  Contact:      MedinaSITech@outlook.com                                                                   ║
// ║  Framework:    Medina Doctrine                                                                            ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

import type {
  CompensationType,
  ConditionOperator,
  RetryStrategy,
  TaskPriority,
  TaskStatus,
  TaskType,
  TriggerType,
  WorkflowActionType,
  WorkflowCategory,
  WorkflowStatus,
  WorkflowType,
} from "./constants";

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 1: TASK TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Task metrics
 */
export interface TaskMetrics {
  estimatedDuration: number; // Estimated beats to complete
  actualDuration: number; // Actual beats taken
  qualityScore: number; // Quality of completion [0, 1]
  efficiencyScore: number; // Efficiency [0, 1]
  resourcesUsed: number; // Resources consumed
  completionReward: number; // Reward earned
  retryCount: number; // Number of retries
  errorCount: number; // Number of errors
}

/**
 * Task input/output
 */
export interface TaskIO {
  name: string;
  type: "string" | "number" | "boolean" | "object" | "array" | "any";
  required: boolean;
  defaultValue?: unknown;
  description?: string;
}

/**
 * Task dependency
 */
export interface TaskDependency {
  taskId: string;
  type: "sequential" | "parallel" | "conditional";
  condition?: TaskCondition;
}

/**
 * Task condition
 */
export interface TaskCondition {
  field: string;
  operator: ConditionOperator;
  value: unknown;
  logicalOperator?: "AND" | "OR";
  nestedConditions?: TaskCondition[];
}

/**
 * Task retry policy
 */
export interface TaskRetryPolicy {
  strategy: RetryStrategy;
  maxRetries: number;
  baseDelay: number; // In beats
  maxDelay: number; // In beats
  retryOn: TaskStatus[];
}

/**
 * Complete task definition
 */
export interface Task {
  id: string;
  name: string;
  description: string;
  taskType: TaskType;
  priority: TaskPriority;
  status: TaskStatus;

  // Timing
  createdAt: number;
  startedAt: number | null;
  completedAt: number | null;
  deadline: number | null;

  // Assignment
  assignee: string | null;
  assigneeType: "organism" | "user" | "agent" | "system";

  // Dependencies
  dependencies: TaskDependency[];
  dependents: string[]; // Tasks that depend on this one

  // Hierarchy
  subtasks: string[];
  parentTask: string | null;

  // I/O
  inputs: TaskIO[];
  outputs: TaskIO[];
  inputValues: Record<string, unknown>;
  outputValues: Record<string, unknown>;

  // Execution
  metrics: TaskMetrics;
  retryPolicy: TaskRetryPolicy;
  currentAttempt: number;
  lastError: string | null;

  // Metadata
  tags: string[];
  metadata: Record<string, unknown>;

  // Audit
  createdBy: string;
  modifiedBy: string;
  modifiedAt: number;
  version: number;
}

/**
 * Task summary for lists
 */
export interface TaskSummary {
  id: string;
  name: string;
  taskType: TaskType;
  priority: TaskPriority;
  status: TaskStatus;
  assignee: string | null;
  progress: number;
  deadline: number | null;
  createdAt: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 2: WORKFLOW STEP TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Workflow step action
 */
export interface StepAction {
  id: string;
  actionType: WorkflowActionType;
  name: string;
  config: Record<string, unknown>;
  timeout: number | null;
  retryPolicy: TaskRetryPolicy;
  compensationType: CompensationType;
  compensationAction: string | null;
}

/**
 * Workflow step
 */
export interface WorkflowStep {
  id: string;
  name: string;
  description: string;
  stepNumber: number;

  // Type
  taskType: TaskType;

  // Position in workflow
  previousSteps: string[];
  nextSteps: string[];

  // Branching
  condition: TaskCondition | null;
  branches: {
    condition: TaskCondition;
    targetStep: string;
  }[];

  // Actions
  actions: StepAction[];

  // I/O
  inputs: TaskIO[];
  outputs: TaskIO[];

  // Timeout
  timeout: number | null;

  // Retry
  retryPolicy: TaskRetryPolicy;

  // State
  status: TaskStatus;
  result: unknown | null;
  error: string | null;
  startedAt: number | null;
  completedAt: number | null;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 3: WORKFLOW TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Workflow trigger
 */
export interface WorkflowTrigger {
  id: string;
  type: TriggerType;
  name: string;
  config: Record<string, unknown>;
  schedule?: string; // Cron expression for scheduled triggers
  eventType?: string; // Event type for event triggers
  condition?: TaskCondition; // Condition for conditional triggers
  enabled: boolean;
  lastTriggered: number | null;
}

/**
 * Workflow variable
 */
export interface WorkflowVariable {
  name: string;
  type: "string" | "number" | "boolean" | "object" | "array" | "any";
  scope: "workflow" | "step" | "global";
  value: unknown;
  isSecret: boolean;
}

/**
 * Workflow execution context
 */
export interface WorkflowContext {
  workflowId: string;
  executionId: string;
  variables: Record<string, WorkflowVariable>;
  stepResults: Record<string, unknown>;
  currentStepId: string | null;
  startedAt: number;
  beat: number;
}

/**
 * Complete workflow definition
 */
export interface Workflow {
  id: string;
  name: string;
  description: string;
  version: string;

  // Type
  workflowType: WorkflowType;
  category: WorkflowCategory;

  // Status
  status: WorkflowStatus;

  // Structure
  steps: WorkflowStep[];
  entryStepId: string | null;
  exitStepIds: string[];

  // Triggers
  triggers: WorkflowTrigger[];

  // Variables
  variables: WorkflowVariable[];

  // I/O
  inputs: TaskIO[];
  outputs: TaskIO[];

  // Timing
  createdAt: number;
  startedAt: number | null;
  completedAt: number | null;
  estimatedDuration: number | null;
  maxDuration: number | null;

  // Execution
  currentStep: number;
  currentContext: WorkflowContext | null;

  // Ownership
  owner: string;
  collaborators: string[];

  // Metadata
  priority: TaskPriority;
  tags: string[];
  metadata: Record<string, unknown>;

  // Audit
  createdBy: string;
  modifiedBy: string;
  modifiedAt: number;

  // Stats
  executionCount: number;
  successCount: number;
  failureCount: number;
  avgDuration: number | null;
}

/**
 * Workflow summary for lists
 */
export interface WorkflowSummary {
  id: string;
  name: string;
  workflowType: WorkflowType;
  category: WorkflowCategory;
  status: WorkflowStatus;
  stepCount: number;
  progress: number;
  owner: string;
  createdAt: number;
  lastRun: number | null;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 4: WORKFLOW EXECUTION TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Workflow execution
 */
export interface WorkflowExecution {
  id: string;
  workflowId: string;
  workflowVersion: string;

  // Status
  status: WorkflowStatus;

  // Timing
  startedAt: number;
  completedAt: number | null;
  duration: number | null;

  // Context
  context: WorkflowContext;

  // Progress
  currentStepId: string | null;
  completedSteps: string[];
  failedSteps: string[];

  // I/O
  inputValues: Record<string, unknown>;
  outputValues: Record<string, unknown>;

  // Trigger
  triggerId: string | null;
  triggerType: TriggerType;
  triggeredBy: string;

  // Error
  error: string | null;
  errorStepId: string | null;

  // Metrics
  metrics: {
    totalSteps: number;
    completedSteps: number;
    failedSteps: number;
    retriedSteps: number;
    avgStepDuration: number;
    totalBeats: number;
  };
}

/**
 * Execution history entry
 */
export interface ExecutionHistoryEntry {
  id: string;
  executionId: string;
  stepId: string | null;
  timestamp: number;
  beat: number;
  eventType:
    | "started"
    | "completed"
    | "failed"
    | "retried"
    | "paused"
    | "resumed"
    | "cancelled"
    | "step_started"
    | "step_completed"
    | "step_failed";
  details: Record<string, unknown>;
  actor: string;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 5: WORKFLOW TEMPLATE TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Workflow template
 */
export interface WorkflowTemplate {
  id: string;
  name: string;
  description: string;
  category: WorkflowCategory;

  // Template content
  workflow: Omit<
    Workflow,
    | "id"
    | "createdAt"
    | "startedAt"
    | "completedAt"
    | "currentStep"
    | "currentContext"
    | "status"
    | "executionCount"
    | "successCount"
    | "failureCount"
    | "avgDuration"
  >;

  // Customization points
  parameters: {
    name: string;
    type: "string" | "number" | "boolean" | "select";
    label: string;
    description?: string;
    required: boolean;
    defaultValue?: unknown;
    options?: { value: string; label: string }[];
  }[];

  // Usage
  isPublic: boolean;
  usageCount: number;
  rating: number;

  // Metadata
  author: string;
  createdAt: number;
  modifiedAt: number;
  tags: string[];
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 6: WORKFLOW ANALYTICS TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Workflow analytics
 */
export interface WorkflowAnalytics {
  // Overview
  totalWorkflows: number;
  activeWorkflows: number;
  completedWorkflows: number;
  failedWorkflows: number;

  // Executions
  totalExecutions: number;
  executionsToday: number;
  avgExecutionTime: number;
  successRate: number;

  // Tasks
  totalTasks: number;
  pendingTasks: number;
  runningTasks: number;
  completedTasks: number;

  // Performance
  avgTaskDuration: number;
  avgWorkflowDuration: number;
  throughput: number; // Tasks per beat

  // Trends
  executionsTrend: { timestamp: number; count: number }[];
  successRateTrend: { timestamp: number; rate: number }[];
  durationTrend: { timestamp: number; duration: number }[];

  // Distribution
  typeDistribution: Record<WorkflowType, number>;
  statusDistribution: Record<WorkflowStatus, number>;
  categoryDistribution: Record<WorkflowCategory, number>;
  priorityDistribution: Record<TaskPriority, number>;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 7: WORKFLOW SCHEDULER TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Scheduled workflow
 */
export interface ScheduledWorkflow {
  id: string;
  workflowId: string;
  cronExpression: string;
  timezone: string;
  enabled: boolean;
  nextRun: number | null;
  lastRun: number | null;
  lastStatus: WorkflowStatus | null;
  runCount: number;
  failureCount: number;
  metadata: Record<string, unknown>;
}

/**
 * Scheduler state
 */
export interface SchedulerState {
  isRunning: boolean;
  scheduledWorkflows: ScheduledWorkflow[];
  upcomingRuns: { workflowId: string; scheduledTime: number }[];
  lastCheck: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 8: WORKFLOW QUEUE TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Queued task
 */
export interface QueuedTask {
  id: string;
  taskId: string;
  workflowId: string | null;
  executionId: string | null;
  priority: TaskPriority;
  queuedAt: number;
  scheduledFor: number | null;
  retryCount: number;
  status: "queued" | "processing" | "completed" | "failed";
}

/**
 * Task queue state
 */
export interface TaskQueueState {
  queues: Record<TaskPriority, QueuedTask[]>;
  processingCount: number;
  totalQueued: number;
  avgWaitTime: number;
  throughput: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 9: WORKFLOW NOTIFICATION TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Workflow notification
 */
export interface WorkflowNotification {
  id: string;
  type:
    | "workflow_started"
    | "workflow_completed"
    | "workflow_failed"
    | "task_assigned"
    | "task_completed"
    | "task_failed"
    | "approval_required"
    | "deadline_approaching";
  workflowId: string | null;
  taskId: string | null;
  executionId: string | null;
  title: string;
  message: string;
  timestamp: number;
  read: boolean;
  actionUrl: string | null;
  metadata: Record<string, unknown>;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 10: WORKFLOW FORM TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Create workflow form
 */
export interface CreateWorkflowForm {
  name: string;
  description: string;
  workflowType: WorkflowType;
  category: WorkflowCategory;
  priority: TaskPriority;
  tags: string[];
}

/**
 * Create task form
 */
export interface CreateTaskForm {
  name: string;
  description: string;
  taskType: TaskType;
  priority: TaskPriority;
  assignee: string | null;
  deadline: number | null;
  parentTask: string | null;
  workflowId: string | null;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 11: WORKFLOW VISUALIZATION TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Workflow DAG node
 */
export interface WorkflowDAGNode {
  id: string;
  stepId: string;
  label: string;
  type: TaskType;
  status: TaskStatus;
  x: number;
  y: number;
  width: number;
  height: number;
}

/**
 * Workflow DAG edge
 */
export interface WorkflowDAGEdge {
  id: string;
  source: string;
  target: string;
  label: string | null;
  isConditional: boolean;
  condition: string | null;
}

/**
 * Workflow DAG
 */
export interface WorkflowDAG {
  nodes: WorkflowDAGNode[];
  edges: WorkflowDAGEdge[];
  width: number;
  height: number;
}

/**
 * Task Gantt item
 */
export interface TaskGanttItem {
  id: string;
  taskId: string;
  name: string;
  start: number;
  end: number;
  progress: number;
  status: TaskStatus;
  dependencies: string[];
  assignee: string | null;
}

/**
 * Gantt chart data
 */
export interface GanttChartData {
  items: TaskGanttItem[];
  minTime: number;
  maxTime: number;
  currentTime: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 12: COMPLETE WORKFLOW STATE
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Complete workflow engine state
 */
export interface WorkflowEngineState {
  // Workflows
  workflows: Workflow[];
  activeWorkflows: string[];

  // Tasks
  tasks: Task[];
  taskQueue: TaskQueueState;

  // Executions
  executions: WorkflowExecution[];
  executionHistory: ExecutionHistoryEntry[];

  // Templates
  templates: WorkflowTemplate[];

  // Scheduler
  scheduler: SchedulerState;

  // Analytics
  analytics: WorkflowAnalytics;

  // Notifications
  notifications: WorkflowNotification[];

  // Beat tracking
  currentBeat: number;
  lastUpdateBeat: number;
}
