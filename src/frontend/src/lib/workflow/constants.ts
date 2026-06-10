// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  WORKFLOW ENGINE CONSTANTS — ENTERPRISE WORKFLOW ORCHESTRATION                                            ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
// ║  Location:     Dallas, Texas, United States of America                                                    ║
// ║  Contact:      MedinaSITech@outlook.com                                                                   ║
// ║  Framework:    Medina Doctrine                                                                            ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════
// WORKFLOW LIMITS
// ═══════════════════════════════════════════════════════════════════════════════

export const WORKFLOW_LIMITS = {
  MAX_TASKS: 10000,
  MAX_WORKFLOWS: 1000,
  MAX_STEPS_PER_WORKFLOW: 100,
  MAX_RETRIES: 3,
  MAX_PARALLEL_TASKS: 50,
  MAX_TASK_DURATION_BEATS: 10000,
  MAX_WORKFLOW_DURATION_BEATS: 100000,
  TASK_TIMEOUT_DEFAULT_BEATS: 1000,
} as const;

// ═══════════════════════════════════════════════════════════════════════════════
// REWARD PARAMETERS
// ═══════════════════════════════════════════════════════════════════════════════

export const WORKFLOW_REWARDS = {
  BASE_COMPLETION_REWARD: 1.0,
  QUALITY_MULTIPLIER: 2.0,
  SPEED_BONUS_FACTOR: 0.5,
  FAILURE_PENALTY: -0.2,
  EARLY_COMPLETION_BONUS: 0.25,
  COLLABORATION_BONUS: 0.1,
  CONSISTENCY_BONUS: 0.15,
} as const;

// ═══════════════════════════════════════════════════════════════════════════════
// TASK TYPES
// ═══════════════════════════════════════════════════════════════════════════════

export const TASK_TYPES = [
  "Information", // Information gathering
  "Processing", // Data processing
  "Communication", // Sending/receiving messages
  "Analysis", // Analysis and reasoning
  "Decision", // Decision making
  "Action", // Taking action
  "Verification", // Verifying results
  "Reporting", // Generating reports
  "Learning", // Learning new information
  "Maintenance", // System maintenance
  "Creation", // Creating new content
  "Review", // Reviewing work
  "Approval", // Approval workflows
  "Integration", // Integration tasks
  "Monitoring", // Monitoring and alerting
] as const;

export type TaskType = (typeof TASK_TYPES)[number];

// ═══════════════════════════════════════════════════════════════════════════════
// TASK PRIORITIES
// ═══════════════════════════════════════════════════════════════════════════════

export const TASK_PRIORITIES = [
  "Critical", // Must complete immediately
  "High", // Complete as soon as possible
  "Normal", // Standard priority
  "Low", // Can wait
  "Background", // Process when idle
] as const;

export type TaskPriority = (typeof TASK_PRIORITIES)[number];

// ═══════════════════════════════════════════════════════════════════════════════
// TASK STATUSES
// ═══════════════════════════════════════════════════════════════════════════════

export const TASK_STATUSES = [
  "Pending", // Waiting to start
  "Ready", // Ready to execute
  "Running", // Currently executing
  "Paused", // Temporarily paused
  "Completed", // Successfully completed
  "Failed", // Failed to complete
  "Cancelled", // Cancelled by user
  "Blocked", // Blocked by dependency
  "Retrying", // Retrying after failure
  "Timeout", // Timed out
] as const;

export type TaskStatus = (typeof TASK_STATUSES)[number];

// ═══════════════════════════════════════════════════════════════════════════════
// WORKFLOW TYPES
// ═══════════════════════════════════════════════════════════════════════════════

export const WORKFLOW_TYPES = [
  "Sequential", // Steps execute in order
  "Parallel", // Steps can execute concurrently
  "Conditional", // Steps depend on conditions
  "Iterative", // Steps repeat until condition
  "EventDriven", // Steps triggered by events
  "Hybrid", // Combination of above
  "Pipeline", // Data flows through stages
  "StateMachine", // State-based transitions
  "DAG", // Directed acyclic graph
] as const;

export type WorkflowType = (typeof WORKFLOW_TYPES)[number];

// ═══════════════════════════════════════════════════════════════════════════════
// WORKFLOW STATUSES
// ═══════════════════════════════════════════════════════════════════════════════

export const WORKFLOW_STATUSES = [
  "Draft", // Being designed
  "Pending", // Ready to start
  "Running", // Currently executing
  "Paused", // Temporarily paused
  "Completed", // Successfully completed
  "Failed", // Failed to complete
  "Cancelled", // Cancelled by user
  "Scheduled", // Scheduled for future
] as const;

export type WorkflowStatus = (typeof WORKFLOW_STATUSES)[number];

// ═══════════════════════════════════════════════════════════════════════════════
// TRIGGER TYPES
// ═══════════════════════════════════════════════════════════════════════════════

export const TRIGGER_TYPES = [
  "Manual", // User initiated
  "Scheduled", // Time-based
  "Event", // Event-driven
  "Webhook", // External webhook
  "Condition", // Condition-based
  "ChainedWorkflow", // Triggered by another workflow
  "API", // API call
] as const;

export type TriggerType = (typeof TRIGGER_TYPES)[number];

// ═══════════════════════════════════════════════════════════════════════════════
// CONDITION OPERATORS
// ═══════════════════════════════════════════════════════════════════════════════

export const CONDITION_OPERATORS = [
  "equals",
  "notEquals",
  "greaterThan",
  "lessThan",
  "greaterThanOrEqual",
  "lessThanOrEqual",
  "contains",
  "notContains",
  "startsWith",
  "endsWith",
  "matches",
  "in",
  "notIn",
  "isNull",
  "isNotNull",
  "isEmpty",
  "isNotEmpty",
] as const;

export type ConditionOperator = (typeof CONDITION_OPERATORS)[number];

// ═══════════════════════════════════════════════════════════════════════════════
// ACTION TYPES
// ═══════════════════════════════════════════════════════════════════════════════

export const WORKFLOW_ACTION_TYPES = [
  "Execute", // Execute code
  "Transform", // Transform data
  "Validate", // Validate data
  "Notify", // Send notification
  "Store", // Store data
  "Retrieve", // Retrieve data
  "CallAPI", // Call external API
  "CallCanister", // Call ICP canister
  "Branch", // Conditional branch
  "Loop", // Loop iteration
  "Wait", // Wait for condition
  "Delay", // Fixed delay
  "Aggregate", // Aggregate results
  "Split", // Split workflow
  "Join", // Join parallel paths
  "Rollback", // Rollback changes
] as const;

export type WorkflowActionType = (typeof WORKFLOW_ACTION_TYPES)[number];

// ═══════════════════════════════════════════════════════════════════════════════
// RETRY STRATEGIES
// ═══════════════════════════════════════════════════════════════════════════════

export const RETRY_STRATEGIES = [
  "None", // No retry
  "Immediate", // Retry immediately
  "Linear", // Linear backoff
  "Exponential", // Exponential backoff
  "Fibonacci", // Fibonacci backoff
] as const;

export type RetryStrategy = (typeof RETRY_STRATEGIES)[number];

// ═══════════════════════════════════════════════════════════════════════════════
// COMPENSATION TYPES
// ═══════════════════════════════════════════════════════════════════════════════

export const COMPENSATION_TYPES = [
  "None", // No compensation
  "Rollback", // Rollback changes
  "Compensate", // Execute compensation action
  "Skip", // Skip and continue
  "Abort", // Abort entire workflow
] as const;

export type CompensationType = (typeof COMPENSATION_TYPES)[number];

// ═══════════════════════════════════════════════════════════════════════════════
// WORKFLOW CATEGORIES
// ═══════════════════════════════════════════════════════════════════════════════

export const WORKFLOW_CATEGORIES = [
  "DataProcessing",
  "DocumentGeneration",
  "Approval",
  "Onboarding",
  "Compliance",
  "Reporting",
  "Integration",
  "Notification",
  "Maintenance",
  "Analytics",
  "Security",
  "Financial",
  "HR",
  "Marketing",
  "Sales",
  "Support",
  "Custom",
] as const;

export type WorkflowCategory = (typeof WORKFLOW_CATEGORIES)[number];

// ═══════════════════════════════════════════════════════════════════════════════
// COLORS
// ═══════════════════════════════════════════════════════════════════════════════

export const TASK_STATUS_COLORS: Record<TaskStatus, string> = {
  Pending: "oklch(60% 0.1 240)",
  Ready: "oklch(65% 0.15 180)",
  Running: "oklch(70% 0.2 210)",
  Paused: "oklch(65% 0.15 60)",
  Completed: "oklch(70% 0.2 150)",
  Failed: "oklch(60% 0.2 30)",
  Cancelled: "oklch(50% 0.05 240)",
  Blocked: "oklch(60% 0.15 0)",
  Retrying: "oklch(65% 0.2 60)",
  Timeout: "oklch(55% 0.15 30)",
};

export const WORKFLOW_STATUS_COLORS: Record<WorkflowStatus, string> = {
  Draft: "oklch(55% 0.1 240)",
  Pending: "oklch(60% 0.1 240)",
  Running: "oklch(70% 0.2 210)",
  Paused: "oklch(65% 0.15 60)",
  Completed: "oklch(70% 0.2 150)",
  Failed: "oklch(60% 0.2 30)",
  Cancelled: "oklch(50% 0.05 240)",
  Scheduled: "oklch(65% 0.15 270)",
};

export const TASK_PRIORITY_COLORS: Record<TaskPriority, string> = {
  Critical: "oklch(60% 0.25 0)",
  High: "oklch(65% 0.2 30)",
  Normal: "oklch(65% 0.15 210)",
  Low: "oklch(60% 0.1 180)",
  Background: "oklch(55% 0.05 240)",
};

export const TASK_TYPE_COLORS: Record<TaskType, string> = {
  Information: "oklch(65% 0.15 210)",
  Processing: "oklch(65% 0.15 270)",
  Communication: "oklch(65% 0.15 180)",
  Analysis: "oklch(65% 0.15 300)",
  Decision: "oklch(65% 0.2 330)",
  Action: "oklch(65% 0.2 30)",
  Verification: "oklch(65% 0.15 150)",
  Reporting: "oklch(65% 0.15 120)",
  Learning: "oklch(65% 0.15 90)",
  Maintenance: "oklch(60% 0.1 240)",
  Creation: "oklch(70% 0.2 60)",
  Review: "oklch(65% 0.15 240)",
  Approval: "oklch(65% 0.2 150)",
  Integration: "oklch(60% 0.15 210)",
  Monitoring: "oklch(60% 0.15 180)",
};

// ═══════════════════════════════════════════════════════════════════════════════
// UTILITY FUNCTIONS
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Calculate task reward
 */
export function calculateTaskReward(
  baseReward: number,
  qualityScore: number,
  speedRatio: number,
  isEarlyCompletion: boolean,
): number {
  let reward = baseReward;

  // Quality multiplier
  reward *= 1 + (qualityScore - 0.5) * WORKFLOW_REWARDS.QUALITY_MULTIPLIER;

  // Speed bonus (if completed faster than estimated)
  if (speedRatio < 1) {
    reward *= 1 + (1 - speedRatio) * WORKFLOW_REWARDS.SPEED_BONUS_FACTOR;
  }

  // Early completion bonus
  if (isEarlyCompletion) {
    reward *= 1 + WORKFLOW_REWARDS.EARLY_COMPLETION_BONUS;
  }

  return Math.max(0, reward);
}

/**
 * Calculate retry delay
 */
export function calculateRetryDelay(
  strategy: RetryStrategy,
  attemptNumber: number,
  baseDelay: number,
): number {
  switch (strategy) {
    case "None":
      return 0;
    case "Immediate":
      return 0;
    case "Linear":
      return baseDelay * attemptNumber;
    case "Exponential":
      return baseDelay * 2 ** (attemptNumber - 1);
    case "Fibonacci": {
      const fib = (n: number): number => (n <= 1 ? n : fib(n - 1) + fib(n - 2));
      return baseDelay * fib(attemptNumber + 1);
    }
    default:
      return baseDelay;
  }
}

/**
 * Check if task can be retried
 */
export function canRetryTask(
  currentAttempt: number,
  maxRetries: number,
  status: TaskStatus,
): boolean {
  return (
    currentAttempt < maxRetries && (status === "Failed" || status === "Timeout")
  );
}

/**
 * Calculate workflow progress
 */
export function calculateWorkflowProgress(
  completedSteps: number,
  totalSteps: number,
): number {
  if (totalSteps === 0) return 0;
  return (completedSteps / totalSteps) * 100;
}

/**
 * Estimate time remaining
 */
export function estimateTimeRemaining(
  completedSteps: number,
  totalSteps: number,
  elapsedBeats: number,
): number {
  if (completedSteps === 0) return totalSteps * 100; // Default estimate
  const avgBeatsPerStep = elapsedBeats / completedSteps;
  return (totalSteps - completedSteps) * avgBeatsPerStep;
}

/**
 * Format duration in beats
 */
export function formatDurationBeats(
  beats: number,
  beatsPerSecond = 12,
): string {
  const seconds = beats / beatsPerSecond;
  if (seconds < 60) return `${seconds.toFixed(0)}s`;
  if (seconds < 3600) return `${(seconds / 60).toFixed(1)}m`;
  if (seconds < 86400) return `${(seconds / 3600).toFixed(1)}h`;
  return `${(seconds / 86400).toFixed(1)}d`;
}

/**
 * Validate condition
 */
export function evaluateCondition(
  value: unknown,
  operator: ConditionOperator,
  target: unknown,
): boolean {
  switch (operator) {
    case "equals":
      return value === target;
    case "notEquals":
      return value !== target;
    case "greaterThan":
      return Number(value) > Number(target);
    case "lessThan":
      return Number(value) < Number(target);
    case "greaterThanOrEqual":
      return Number(value) >= Number(target);
    case "lessThanOrEqual":
      return Number(value) <= Number(target);
    case "contains":
      return String(value).includes(String(target));
    case "notContains":
      return !String(value).includes(String(target));
    case "startsWith":
      return String(value).startsWith(String(target));
    case "endsWith":
      return String(value).endsWith(String(target));
    case "matches":
      return new RegExp(String(target)).test(String(value));
    case "in":
      return Array.isArray(target) && target.includes(value);
    case "notIn":
      return Array.isArray(target) && !target.includes(value);
    case "isNull":
      return value === null || value === undefined;
    case "isNotNull":
      return value !== null && value !== undefined;
    case "isEmpty":
      return value === "" || (Array.isArray(value) && value.length === 0);
    case "isNotEmpty":
      return value !== "" && !(Array.isArray(value) && value.length === 0);
    default:
      return false;
  }
}

/**
 * Get task icon name based on type
 */
export function getTaskTypeIcon(type: TaskType): string {
  const icons: Record<TaskType, string> = {
    Information: "info",
    Processing: "cpu",
    Communication: "message-square",
    Analysis: "bar-chart",
    Decision: "git-branch",
    Action: "play",
    Verification: "check-circle",
    Reporting: "file-text",
    Learning: "book-open",
    Maintenance: "wrench",
    Creation: "plus-circle",
    Review: "eye",
    Approval: "thumbs-up",
    Integration: "link",
    Monitoring: "activity",
  };
  return icons[type] || "circle";
}

/**
 * Get status icon name
 */
export function getStatusIcon(status: TaskStatus | WorkflowStatus): string {
  const icons: Record<string, string> = {
    Pending: "clock",
    Ready: "check",
    Running: "play",
    Paused: "pause",
    Completed: "check-circle",
    Failed: "x-circle",
    Cancelled: "x",
    Blocked: "lock",
    Retrying: "refresh-cw",
    Timeout: "alert-circle",
    Draft: "file",
    Scheduled: "calendar",
  };
  return icons[status] || "circle";
}
