/**
 * ╔══════════════════════════════════════════════════════════════════════════════╗
 * ║              ORO'S COMMAND CENTER — 指揮中心-SUBSTRATE v1.0                   ║
 * ║         Multi-Agent Orchestration & Task Management System                    ║
 * ╠══════════════════════════════════════════════════════════════════════════════╣
 * ║  The Command Center is Oro's operational hub where multiple specialized       ║
 * ║  agents can be spawned, coordinated, and managed to complete complex tasks.  ║
 * ║  It provides the interface for human operators to interact with the          ║
 * ║  sovereign organism and observe its real-time cognitive processes.           ║
 * ╚══════════════════════════════════════════════════════════════════════════════╝
 */

// ============================================================================
// SECTION 1: COMMAND CENTER CONSTANTS
// ============================================================================

/** Maximum concurrent agents */
export const MAX_AGENTS = 50;

/** Task queue capacity */
export const TASK_QUEUE_SIZE = 1000;

/** Agent heartbeat interval (ms) */
export const HEARTBEAT_INTERVAL = 1000;

/** Task timeout default (ms) */
export const DEFAULT_TASK_TIMEOUT = 300000; // 5 minutes

/** Agent specialization types */
export const AGENT_SPECIALIZATIONS = [
  "research",
  "analysis",
  "coding",
  "writing",
  "planning",
  "execution",
  "verification",
  "communication",
  "memory",
  "reasoning",
  "creativity",
  "optimization",
  "security",
  "monitoring",
] as const;

// ============================================================================
// SECTION 2: TYPE DEFINITIONS
// ============================================================================

/**
 * Agent specialization type
 */
export type AgentSpecialization = (typeof AGENT_SPECIALIZATIONS)[number];

/**
 * Agent status
 */
export type AgentStatus =
  | "idle" // Ready for tasks
  | "busy" // Working on a task
  | "waiting" // Waiting for input/dependencies
  | "suspended" // Temporarily paused
  | "error" // Encountered an error
  | "terminated"; // Shut down

/**
 * Task priority levels
 */
export type TaskPriority =
  | "critical"
  | "high"
  | "normal"
  | "low"
  | "background";

/**
 * Task status
 */
export type TaskStatus =
  | "queued" // Waiting in queue
  | "assigned" // Assigned to agent
  | "in_progress" // Being executed
  | "blocked" // Waiting for dependencies
  | "completed" // Successfully completed
  | "failed" // Failed with error
  | "cancelled"; // Cancelled by user/system

/**
 * Message type for agent communication
 */
export type MessageType =
  | "task_assignment"
  | "task_update"
  | "task_completion"
  | "task_failure"
  | "query"
  | "response"
  | "broadcast"
  | "heartbeat"
  | "alert"
  | "coordination";

/**
 * Agent definition
 */
export interface Agent {
  readonly id: string;
  readonly name: string;
  readonly specialization: AgentSpecialization;
  readonly status: AgentStatus;
  readonly capabilities: AgentCapability[];
  readonly currentTask?: string; // Task ID
  readonly taskHistory: string[]; // Task IDs
  readonly performance: AgentPerformance;
  readonly memory: AgentMemory;
  readonly created: number;
  readonly lastHeartbeat: number;
  readonly metadata: AgentMetadata;
}

/**
 * Agent capability
 */
export interface AgentCapability {
  readonly name: string;
  readonly description: string;
  readonly proficiency: number; // [0, 1]
  readonly costPerUse: number; // Resource cost
  readonly cooldown: number; // ms between uses
  readonly lastUsed?: number;
}

/**
 * Agent performance metrics
 */
export interface AgentPerformance {
  readonly tasksCompleted: number;
  readonly tasksFailed: number;
  readonly averageCompletionTime: number; // ms
  readonly successRate: number; // [0, 1]
  readonly resourceEfficiency: number; // [0, 1]
  readonly qualityScore: number; // [0, 1]
  readonly recentLatency: number[]; // Last 10 task latencies
}

/**
 * Agent memory state
 */
export interface AgentMemory {
  readonly shortTerm: Map<string, unknown>;
  readonly workingMemory: unknown[];
  readonly contextWindow: string[];
  readonly learnedPatterns: string[];
  readonly memoryUsage: number; // bytes
  readonly maxMemory: number;
}

/**
 * Agent metadata
 */
export interface AgentMetadata {
  readonly version: string;
  readonly model?: string;
  readonly tags: string[];
  readonly permissions: string[];
  readonly resourceQuota: number;
  readonly priority: number;
}

/**
 * Task definition
 */
export interface Task {
  readonly id: string;
  readonly name: string;
  readonly description: string;
  readonly type: TaskType;
  readonly priority: TaskPriority;
  readonly status: TaskStatus;
  readonly requiredCapabilities: string[];
  readonly assignedAgent?: string;
  readonly dependencies: string[]; // Task IDs
  readonly subtasks: string[]; // Child task IDs
  readonly parentTask?: string; // Parent task ID
  readonly input: TaskInput;
  readonly output?: TaskOutput;
  readonly progress: number; // [0, 1]
  readonly created: number;
  readonly started?: number;
  readonly completed?: number;
  readonly deadline?: number;
  readonly timeout: number;
  readonly retries: number;
  readonly maxRetries: number;
  readonly error?: TaskError;
  readonly metadata: TaskMetadata;
}

/**
 * Task type classification
 */
export type TaskType =
  | "atomic" // Single indivisible task
  | "composite" // Task with subtasks
  | "parallel" // Subtasks can run in parallel
  | "sequential" // Subtasks must run in order
  | "conditional" // Subtasks depend on conditions
  | "recurring"; // Repeating task

/**
 * Task input
 */
export interface TaskInput {
  readonly prompt?: string;
  readonly data?: unknown;
  readonly files?: string[];
  readonly context?: TaskContext;
  readonly constraints?: TaskConstraints;
}

/**
 * Task context
 */
export interface TaskContext {
  readonly previousTasks: string[];
  readonly relatedMemory: string[];
  readonly userPreferences: Record<string, unknown>;
  readonly environmentState: Record<string, unknown>;
}

/**
 * Task constraints
 */
export interface TaskConstraints {
  readonly maxTime?: number;
  readonly maxResources?: number;
  readonly requiredQuality?: number;
  readonly allowedActions?: string[];
  readonly forbiddenActions?: string[];
}

/**
 * Task output
 */
export interface TaskOutput {
  readonly result: unknown;
  readonly artifacts?: Artifact[];
  readonly sideEffects?: string[];
  readonly metrics?: TaskMetrics;
}

/**
 * Task artifact (produced output)
 */
export interface Artifact {
  readonly id: string;
  readonly type: "text" | "code" | "data" | "image" | "file" | "decision";
  readonly content: unknown;
  readonly metadata: Record<string, unknown>;
}

/**
 * Task metrics
 */
export interface TaskMetrics {
  readonly executionTime: number;
  readonly resourcesUsed: number;
  readonly qualityScore: number;
  readonly confidenceLevel: number;
}

/**
 * Task error
 */
export interface TaskError {
  readonly code: string;
  readonly message: string;
  readonly stack?: string;
  readonly recoverable: boolean;
  readonly suggestedAction?: string;
}

/**
 * Task metadata
 */
export interface TaskMetadata {
  readonly createdBy: string;
  readonly tags: string[];
  readonly category: string;
  readonly version: number;
  readonly annotations: Record<string, string>;
}

/**
 * Message between agents or to Command Center
 */
export interface Message {
  readonly id: string;
  readonly type: MessageType;
  readonly from: string;
  readonly to: string | "broadcast";
  readonly content: unknown;
  readonly timestamp: number;
  readonly priority: number;
  readonly requiresAck: boolean;
  readonly acknowledged?: boolean;
  readonly correlationId?: string;
}

/**
 * Command from operator
 */
export interface OperatorCommand {
  readonly id: string;
  readonly command: CommandType;
  readonly target?: string; // Agent/Task ID
  readonly parameters: Record<string, unknown>;
  readonly timestamp: number;
  readonly operator: string;
  readonly executed: boolean;
  readonly result?: unknown;
}

/**
 * Command types
 */
export type CommandType =
  | "spawn_agent"
  | "terminate_agent"
  | "suspend_agent"
  | "resume_agent"
  | "create_task"
  | "cancel_task"
  | "prioritize_task"
  | "assign_task"
  | "broadcast"
  | "query_status"
  | "configure"
  | "emergency_halt"
  | "reset";

/**
 * Command Center configuration
 */
export interface CommandCenterConfig {
  readonly maxAgents: number;
  readonly maxQueueSize: number;
  readonly defaultTimeout: number;
  readonly autoScaling: boolean;
  readonly loadBalancing:
    | "round_robin"
    | "least_busy"
    | "capability_match"
    | "hybrid";
  readonly priorityBoost: boolean;
  readonly deadlockDetection: boolean;
  readonly autoRecovery: boolean;
  readonly loggingLevel: "debug" | "info" | "warn" | "error";
}

/**
 * Command Center state
 */
export interface CommandCenterState {
  readonly timestamp: number;
  readonly agents: Map<string, Agent>;
  readonly tasks: Map<string, Task>;
  readonly taskQueue: string[]; // Task IDs in priority order
  readonly messageQueue: Message[];
  readonly commandHistory: OperatorCommand[];
  readonly config: CommandCenterConfig;
  readonly metrics: CommandCenterMetrics;
  readonly alerts: Alert[];
  readonly isOperational: boolean;
}

/**
 * Mutable internal state for Command Center operations
 */
type MutableState = {
  -readonly [K in keyof CommandCenterState]: CommandCenterState[K];
};

/**
 * Command Center metrics
 */
export interface CommandCenterMetrics {
  readonly totalTasksCreated: number;
  readonly totalTasksCompleted: number;
  readonly totalTasksFailed: number;
  readonly averageTaskTime: number;
  readonly queueLength: number;
  readonly activeAgents: number;
  readonly resourceUtilization: number;
  readonly throughput: number; // Tasks per hour
  readonly uptime: number;
}

/**
 * Alert
 */
export interface Alert {
  readonly id: string;
  readonly severity: "info" | "warning" | "error" | "critical";
  readonly source: string;
  readonly message: string;
  readonly timestamp: number;
  readonly acknowledged: boolean;
  readonly resolvedAt?: number;
}

// ============================================================================
// SECTION 3: AGENT FACTORY
// ============================================================================

/**
 * Creates and manages agents
 */
export class AgentFactory {
  private agentCounter = 0;

  /**
   * Create a new agent
   */
  createAgent(
    name: string,
    specialization: AgentSpecialization,
    capabilities: string[] = [],
    metadata: Partial<AgentMetadata> = {},
  ): Agent {
    const id = `agent_${++this.agentCounter}_${Date.now().toString(36)}`;

    const defaultCapabilities = this.getDefaultCapabilities(specialization);
    const allCapabilities = [...defaultCapabilities];

    // Add custom capabilities
    for (const cap of capabilities) {
      if (!allCapabilities.find((c) => c.name === cap)) {
        allCapabilities.push({
          name: cap,
          description: `Custom capability: ${cap}`,
          proficiency: 0.5,
          costPerUse: 1,
          cooldown: 0,
        });
      }
    }

    const agent: Agent = {
      id,
      name,
      specialization,
      status: "idle",
      capabilities: allCapabilities,
      taskHistory: [],
      performance: {
        tasksCompleted: 0,
        tasksFailed: 0,
        averageCompletionTime: 0,
        successRate: 1,
        resourceEfficiency: 1,
        qualityScore: 0.8,
        recentLatency: [],
      },
      memory: {
        shortTerm: new Map(),
        workingMemory: [],
        contextWindow: [],
        learnedPatterns: [],
        memoryUsage: 0,
        maxMemory: 1024 * 1024 * 100, // 100MB
      },
      created: Date.now(),
      lastHeartbeat: Date.now(),
      metadata: {
        version: "1.0.0",
        tags: [specialization],
        permissions: ["read", "write", "execute"],
        resourceQuota: 100,
        priority: 5,
        ...metadata,
      },
    };

    return agent;
  }

  /**
   * Get default capabilities for a specialization
   */
  private getDefaultCapabilities(
    specialization: AgentSpecialization,
  ): AgentCapability[] {
    const baseCapabilities: AgentCapability[] = [
      {
        name: "communicate",
        description: "Send and receive messages",
        proficiency: 1,
        costPerUse: 0.1,
        cooldown: 0,
      },
      {
        name: "remember",
        description: "Store and recall information",
        proficiency: 0.9,
        costPerUse: 0.1,
        cooldown: 0,
      },
    ];

    const specializationCapabilities: Record<
      AgentSpecialization,
      AgentCapability[]
    > = {
      research: [
        {
          name: "search",
          description: "Search for information",
          proficiency: 0.9,
          costPerUse: 1,
          cooldown: 1000,
        },
        {
          name: "summarize",
          description: "Summarize documents",
          proficiency: 0.85,
          costPerUse: 2,
          cooldown: 500,
        },
        {
          name: "cite",
          description: "Generate citations",
          proficiency: 0.9,
          costPerUse: 0.5,
          cooldown: 0,
        },
      ],
      analysis: [
        {
          name: "analyze",
          description: "Perform data analysis",
          proficiency: 0.9,
          costPerUse: 2,
          cooldown: 1000,
        },
        {
          name: "visualize",
          description: "Create visualizations",
          proficiency: 0.8,
          costPerUse: 3,
          cooldown: 2000,
        },
        {
          name: "correlate",
          description: "Find correlations",
          proficiency: 0.85,
          costPerUse: 2,
          cooldown: 1000,
        },
      ],
      coding: [
        {
          name: "write_code",
          description: "Write code",
          proficiency: 0.9,
          costPerUse: 3,
          cooldown: 500,
        },
        {
          name: "debug",
          description: "Debug code",
          proficiency: 0.85,
          costPerUse: 2,
          cooldown: 500,
        },
        {
          name: "refactor",
          description: "Refactor code",
          proficiency: 0.8,
          costPerUse: 3,
          cooldown: 1000,
        },
        {
          name: "test",
          description: "Write and run tests",
          proficiency: 0.85,
          costPerUse: 2,
          cooldown: 1000,
        },
      ],
      writing: [
        {
          name: "compose",
          description: "Write content",
          proficiency: 0.9,
          costPerUse: 2,
          cooldown: 500,
        },
        {
          name: "edit",
          description: "Edit and proofread",
          proficiency: 0.85,
          costPerUse: 1,
          cooldown: 0,
        },
        {
          name: "translate",
          description: "Translate text",
          proficiency: 0.8,
          costPerUse: 2,
          cooldown: 500,
        },
      ],
      planning: [
        {
          name: "plan",
          description: "Create plans",
          proficiency: 0.9,
          costPerUse: 2,
          cooldown: 1000,
        },
        {
          name: "schedule",
          description: "Schedule tasks",
          proficiency: 0.85,
          costPerUse: 1,
          cooldown: 500,
        },
        {
          name: "estimate",
          description: "Estimate resources",
          proficiency: 0.8,
          costPerUse: 1,
          cooldown: 500,
        },
      ],
      execution: [
        {
          name: "execute",
          description: "Execute commands",
          proficiency: 0.9,
          costPerUse: 2,
          cooldown: 0,
        },
        {
          name: "monitor",
          description: "Monitor execution",
          proficiency: 0.85,
          costPerUse: 0.5,
          cooldown: 1000,
        },
        {
          name: "rollback",
          description: "Rollback changes",
          proficiency: 0.8,
          costPerUse: 3,
          cooldown: 5000,
        },
      ],
      verification: [
        {
          name: "verify",
          description: "Verify results",
          proficiency: 0.9,
          costPerUse: 2,
          cooldown: 1000,
        },
        {
          name: "validate",
          description: "Validate data",
          proficiency: 0.85,
          costPerUse: 1,
          cooldown: 500,
        },
        {
          name: "audit",
          description: "Audit actions",
          proficiency: 0.8,
          costPerUse: 2,
          cooldown: 2000,
        },
      ],
      communication: [
        {
          name: "notify",
          description: "Send notifications",
          proficiency: 0.95,
          costPerUse: 0.5,
          cooldown: 0,
        },
        {
          name: "coordinate",
          description: "Coordinate agents",
          proficiency: 0.85,
          costPerUse: 1,
          cooldown: 500,
        },
        {
          name: "report",
          description: "Generate reports",
          proficiency: 0.9,
          costPerUse: 2,
          cooldown: 1000,
        },
      ],
      memory: [
        {
          name: "store",
          description: "Store long-term memory",
          proficiency: 0.95,
          costPerUse: 1,
          cooldown: 0,
        },
        {
          name: "recall",
          description: "Recall memories",
          proficiency: 0.9,
          costPerUse: 0.5,
          cooldown: 0,
        },
        {
          name: "consolidate",
          description: "Consolidate memories",
          proficiency: 0.85,
          costPerUse: 3,
          cooldown: 60000,
        },
      ],
      reasoning: [
        {
          name: "infer",
          description: "Make inferences",
          proficiency: 0.9,
          costPerUse: 2,
          cooldown: 500,
        },
        {
          name: "deduce",
          description: "Logical deduction",
          proficiency: 0.85,
          costPerUse: 2,
          cooldown: 500,
        },
        {
          name: "hypothesize",
          description: "Generate hypotheses",
          proficiency: 0.8,
          costPerUse: 2,
          cooldown: 1000,
        },
      ],
      creativity: [
        {
          name: "ideate",
          description: "Generate ideas",
          proficiency: 0.9,
          costPerUse: 2,
          cooldown: 1000,
        },
        {
          name: "design",
          description: "Design solutions",
          proficiency: 0.85,
          costPerUse: 3,
          cooldown: 2000,
        },
        {
          name: "innovate",
          description: "Innovate approaches",
          proficiency: 0.8,
          costPerUse: 3,
          cooldown: 3000,
        },
      ],
      optimization: [
        {
          name: "optimize",
          description: "Optimize processes",
          proficiency: 0.9,
          costPerUse: 3,
          cooldown: 2000,
        },
        {
          name: "tune",
          description: "Fine-tune parameters",
          proficiency: 0.85,
          costPerUse: 2,
          cooldown: 1000,
        },
        {
          name: "benchmark",
          description: "Benchmark performance",
          proficiency: 0.8,
          costPerUse: 2,
          cooldown: 5000,
        },
      ],
      security: [
        {
          name: "scan",
          description: "Security scanning",
          proficiency: 0.9,
          costPerUse: 2,
          cooldown: 5000,
        },
        {
          name: "protect",
          description: "Apply protections",
          proficiency: 0.85,
          costPerUse: 3,
          cooldown: 10000,
        },
        {
          name: "encrypt",
          description: "Encrypt data",
          proficiency: 0.95,
          costPerUse: 1,
          cooldown: 0,
        },
      ],
      monitoring: [
        {
          name: "observe",
          description: "Observe systems",
          proficiency: 0.95,
          costPerUse: 0.1,
          cooldown: 1000,
        },
        {
          name: "alert",
          description: "Generate alerts",
          proficiency: 0.9,
          costPerUse: 0.5,
          cooldown: 0,
        },
        {
          name: "diagnose",
          description: "Diagnose issues",
          proficiency: 0.85,
          costPerUse: 2,
          cooldown: 2000,
        },
      ],
    };

    return [
      ...baseCapabilities,
      ...(specializationCapabilities[specialization] || []),
    ];
  }

  /**
   * Clone an agent with new ID
   */
  cloneAgent(agent: Agent, newName?: string): Agent {
    const id = `agent_${++this.agentCounter}_${Date.now().toString(36)}`;

    return {
      ...agent,
      id,
      name: newName || `${agent.name} (clone)`,
      status: "idle",
      currentTask: undefined,
      taskHistory: [],
      performance: {
        tasksCompleted: 0,
        tasksFailed: 0,
        averageCompletionTime: 0,
        successRate: 1,
        resourceEfficiency: 1,
        qualityScore: agent.performance.qualityScore,
        recentLatency: [],
      },
      memory: {
        shortTerm: new Map(),
        workingMemory: [],
        contextWindow: [],
        learnedPatterns: [...agent.memory.learnedPatterns],
        memoryUsage: 0,
        maxMemory: agent.memory.maxMemory,
      },
      created: Date.now(),
      lastHeartbeat: Date.now(),
    };
  }
}

// ============================================================================
// SECTION 4: TASK MANAGER
// ============================================================================

/**
 * Manages task lifecycle
 */
export class TaskManager {
  private taskCounter = 0;
  private tasks: Map<string, Task> = new Map();
  private taskQueue: string[] = [];

  /**
   * Create a new task
   */
  createTask(
    name: string,
    description: string,
    type: TaskType,
    input: TaskInput,
    options: {
      priority?: TaskPriority;
      dependencies?: string[];
      timeout?: number;
      deadline?: number;
      maxRetries?: number;
      requiredCapabilities?: string[];
      metadata?: Partial<TaskMetadata>;
    } = {},
  ): Task {
    const id = `task_${++this.taskCounter}_${Date.now().toString(36)}`;

    const task: Task = {
      id,
      name,
      description,
      type,
      priority: options.priority || "normal",
      status: "queued",
      requiredCapabilities: options.requiredCapabilities || [],
      dependencies: options.dependencies || [],
      subtasks: [],
      input,
      progress: 0,
      created: Date.now(),
      timeout: options.timeout || DEFAULT_TASK_TIMEOUT,
      retries: 0,
      maxRetries: options.maxRetries || 3,
      metadata: {
        createdBy: "system",
        tags: [],
        category: "general",
        version: 1,
        annotations: {},
        ...options.metadata,
      },
    };

    this.tasks.set(id, task);
    this.enqueue(id, task.priority);

    return task;
  }

  /**
   * Create a composite task with subtasks
   */
  createCompositeTask(
    name: string,
    description: string,
    subtaskDefs: Array<{
      name: string;
      description: string;
      input: TaskInput;
      capabilities?: string[];
    }>,
    parallel = false,
  ): Task {
    const type = parallel ? "parallel" : "sequential";
    const parentTask = this.createTask(name, description, type, {
      prompt: description,
    });

    const subtaskIds: string[] = [];
    let previousTaskId: string | undefined;

    for (const def of subtaskDefs) {
      const subtask = this.createTask(
        def.name,
        def.description,
        "atomic",
        def.input,
        {
          requiredCapabilities: def.capabilities || [],
          dependencies: parallel ? [] : previousTaskId ? [previousTaskId] : [],
          metadata: { createdBy: "composite_task" },
        },
      );

      subtaskIds.push(subtask.id);

      // Update subtask with parent reference
      this.tasks.set(subtask.id, {
        ...subtask,
        parentTask: parentTask.id,
      });

      previousTaskId = subtask.id;
    }

    // Update parent with subtask references
    const updatedParent: Task = {
      ...parentTask,
      subtasks: subtaskIds,
    };
    this.tasks.set(parentTask.id, updatedParent);

    return updatedParent;
  }

  /**
   * Enqueue a task by priority
   */
  private enqueue(taskId: string, priority: TaskPriority): void {
    const priorityOrder: Record<TaskPriority, number> = {
      critical: 0,
      high: 1,
      normal: 2,
      low: 3,
      background: 4,
    };

    const taskPriority = priorityOrder[priority];

    // Find insertion point
    let insertIndex = this.taskQueue.length;
    for (let i = 0; i < this.taskQueue.length; i++) {
      const existingTask = this.tasks.get(this.taskQueue[i]);
      if (existingTask) {
        const existingPriority = priorityOrder[existingTask.priority];
        if (taskPriority < existingPriority) {
          insertIndex = i;
          break;
        }
      }
    }

    this.taskQueue.splice(insertIndex, 0, taskId);
  }

  /**
   * Get next task for an agent
   */
  getNextTask(agentCapabilities: string[]): Task | null {
    for (const taskId of this.taskQueue) {
      const task = this.tasks.get(taskId);
      if (!task) continue;

      // Check if task is ready (dependencies met)
      if (!this.areDependenciesMet(task)) continue;

      // Check if agent has required capabilities
      const hasCapabilities = task.requiredCapabilities.every((cap) =>
        agentCapabilities.includes(cap),
      );

      if (hasCapabilities) {
        // Remove from queue
        const index = this.taskQueue.indexOf(taskId);
        if (index > -1) {
          this.taskQueue.splice(index, 1);
        }
        return task;
      }
    }

    return null;
  }

  /**
   * Check if task dependencies are met
   */
  private areDependenciesMet(task: Task): boolean {
    for (const depId of task.dependencies) {
      const dep = this.tasks.get(depId);
      if (!dep || dep.status !== "completed") {
        return false;
      }
    }
    return true;
  }

  /**
   * Update task status
   */
  updateTaskStatus(
    taskId: string,
    status: TaskStatus,
    output?: TaskOutput,
    error?: TaskError,
  ): Task | null {
    const task = this.tasks.get(taskId);
    if (!task) return null;

    const updated: Task = {
      ...task,
      status,
      output: output || task.output,
      error: error || task.error,
      completed:
        status === "completed" || status === "failed"
          ? Date.now()
          : task.completed,
    };

    this.tasks.set(taskId, updated);

    // If completed, check if parent task can progress
    if (status === "completed" && task.parentTask) {
      this.checkParentTaskProgress(task.parentTask);
    }

    return updated;
  }

  /**
   * Check if parent task can progress
   */
  private checkParentTaskProgress(parentId: string): void {
    const parent = this.tasks.get(parentId);
    if (!parent) return;

    const subtasks = parent.subtasks
      .map((id) => this.tasks.get(id))
      .filter(Boolean) as Task[];

    const allCompleted = subtasks.every((t) => t.status === "completed");
    const anyFailed = subtasks.some((t) => t.status === "failed");
    const completedCount = subtasks.filter(
      (t) => t.status === "completed",
    ).length;

    const progress = subtasks.length > 0 ? completedCount / subtasks.length : 0;

    let newStatus = parent.status;
    if (allCompleted) {
      newStatus = "completed";
    } else if (anyFailed && parent.type !== "parallel") {
      newStatus = "failed";
    }

    this.tasks.set(parentId, {
      ...parent,
      status: newStatus,
      progress,
      completed:
        newStatus === "completed" || newStatus === "failed"
          ? Date.now()
          : undefined,
    });
  }

  /**
   * Update task progress
   */
  updateProgress(taskId: string, progress: number): void {
    const task = this.tasks.get(taskId);
    if (task) {
      this.tasks.set(taskId, {
        ...task,
        progress: Math.max(0, Math.min(1, progress)),
      });
    }
  }

  /**
   * Assign task to agent
   */
  assignTask(taskId: string, agentId: string): Task | null {
    const task = this.tasks.get(taskId);
    if (!task) return null;

    const updated: Task = {
      ...task,
      status: "assigned",
      assignedAgent: agentId,
      started: Date.now(),
    };

    this.tasks.set(taskId, updated);
    return updated;
  }

  /**
   * Cancel a task
   */
  cancelTask(taskId: string): Task | null {
    const task = this.tasks.get(taskId);
    if (!task) return null;

    // Remove from queue if present
    const queueIndex = this.taskQueue.indexOf(taskId);
    if (queueIndex > -1) {
      this.taskQueue.splice(queueIndex, 1);
    }

    const updated: Task = {
      ...task,
      status: "cancelled",
    };

    this.tasks.set(taskId, updated);

    // Also cancel subtasks
    for (const subtaskId of task.subtasks) {
      this.cancelTask(subtaskId);
    }

    return updated;
  }

  /**
   * Retry a failed task
   */
  retryTask(taskId: string): Task | null {
    const task = this.tasks.get(taskId);
    if (!task || task.status !== "failed" || task.retries >= task.maxRetries) {
      return null;
    }

    const updated: Task = {
      ...task,
      status: "queued",
      retries: task.retries + 1,
      error: undefined,
      assignedAgent: undefined,
      started: undefined,
      completed: undefined,
    };

    this.tasks.set(taskId, updated);
    this.enqueue(taskId, task.priority);

    return updated;
  }

  /**
   * Get task by ID
   */
  getTask(taskId: string): Task | undefined {
    return this.tasks.get(taskId);
  }

  /**
   * Get all tasks
   */
  getAllTasks(): Task[] {
    return Array.from(this.tasks.values());
  }

  /**
   * Get queue
   */
  getQueue(): string[] {
    return [...this.taskQueue];
  }

  /**
   * Get task statistics
   */
  getStatistics(): {
    total: number;
    byStatus: Record<TaskStatus, number>;
    byPriority: Record<TaskPriority, number>;
    queueLength: number;
    averageCompletionTime: number;
  } {
    const tasks = Array.from(this.tasks.values());

    const byStatus: Record<TaskStatus, number> = {
      queued: 0,
      assigned: 0,
      in_progress: 0,
      blocked: 0,
      completed: 0,
      failed: 0,
      cancelled: 0,
    };

    const byPriority: Record<TaskPriority, number> = {
      critical: 0,
      high: 0,
      normal: 0,
      low: 0,
      background: 0,
    };

    let totalCompletionTime = 0;
    let completedCount = 0;

    for (const task of tasks) {
      byStatus[task.status]++;
      byPriority[task.priority]++;

      if (task.status === "completed" && task.started && task.completed) {
        totalCompletionTime += task.completed - task.started;
        completedCount++;
      }
    }

    return {
      total: tasks.length,
      byStatus,
      byPriority,
      queueLength: this.taskQueue.length,
      averageCompletionTime:
        completedCount > 0 ? totalCompletionTime / completedCount : 0,
    };
  }
}

// ============================================================================
// SECTION 5: MESSAGE BUS
// ============================================================================

/**
 * Message bus for agent communication
 */
export class MessageBus {
  private messageCounter = 0;
  private messages: Message[] = [];
  private subscribers: Map<string, Array<(message: Message) => void>> =
    new Map();
  private broadcastSubscribers: Array<(message: Message) => void> = [];

  /**
   * Send a message
   */
  send(
    type: MessageType,
    from: string,
    to: string | "broadcast",
    content: unknown,
    options: {
      priority?: number;
      requiresAck?: boolean;
      correlationId?: string;
    } = {},
  ): Message {
    const message: Message = {
      id: `msg_${++this.messageCounter}_${Date.now().toString(36)}`,
      type,
      from,
      to,
      content,
      timestamp: Date.now(),
      priority: options.priority || 0,
      requiresAck: options.requiresAck || false,
      correlationId: options.correlationId,
    };

    this.messages.push(message);

    // Deliver message
    if (to === "broadcast") {
      for (const handler of this.broadcastSubscribers) {
        handler(message);
      }
    } else {
      const handlers = this.subscribers.get(to) || [];
      for (const handler of handlers) {
        handler(message);
      }
    }

    return message;
  }

  /**
   * Subscribe to messages
   */
  subscribe(agentId: string, handler: (message: Message) => void): void {
    if (!this.subscribers.has(agentId)) {
      this.subscribers.set(agentId, []);
    }
    this.subscribers.get(agentId)!.push(handler);
  }

  /**
   * Subscribe to broadcasts
   */
  subscribeToBroadcasts(handler: (message: Message) => void): void {
    this.broadcastSubscribers.push(handler);
  }

  /**
   * Unsubscribe
   */
  unsubscribe(agentId: string): void {
    this.subscribers.delete(agentId);
  }

  /**
   * Acknowledge a message
   */
  acknowledge(messageId: string): void {
    const message = this.messages.find((m) => m.id === messageId);
    if (message) {
      const index = this.messages.indexOf(message);
      this.messages[index] = { ...message, acknowledged: true };
    }
  }

  /**
   * Get messages for an agent
   */
  getMessagesFor(agentId: string, since?: number): Message[] {
    return this.messages.filter(
      (m) =>
        (m.to === agentId || m.to === "broadcast") &&
        (!since || m.timestamp >= since),
    );
  }

  /**
   * Get unacknowledged messages
   */
  getUnacknowledged(): Message[] {
    return this.messages.filter((m) => m.requiresAck && !m.acknowledged);
  }

  /**
   * Clear old messages
   */
  cleanup(olderThan: number): number {
    const cutoff = Date.now() - olderThan;
    const before = this.messages.length;
    this.messages = this.messages.filter((m) => m.timestamp >= cutoff);
    return before - this.messages.length;
  }
}

// ============================================================================
// SECTION 6: LOAD BALANCER
// ============================================================================

/**
 * Load balancer for task distribution
 */
export class LoadBalancer {
  private lastAssignedIndex = 0;

  /**
   * Select best agent for a task
   */
  selectAgent(
    agents: Agent[],
    task: Task,
    strategy: "round_robin" | "least_busy" | "capability_match" | "hybrid",
  ): Agent | null {
    const availableAgents = agents.filter(
      (a) => a.status === "idle" || a.status === "waiting",
    );

    if (availableAgents.length === 0) return null;

    switch (strategy) {
      case "round_robin":
        return this.roundRobin(availableAgents);

      case "least_busy":
        return this.leastBusy(availableAgents);

      case "capability_match":
        return this.capabilityMatch(availableAgents, task);

      case "hybrid":
        return this.hybrid(availableAgents, task);

      default:
        return availableAgents[0];
    }
  }

  /**
   * Round robin selection
   */
  private roundRobin(agents: Agent[]): Agent {
    this.lastAssignedIndex = (this.lastAssignedIndex + 1) % agents.length;
    return agents[this.lastAssignedIndex];
  }

  /**
   * Select least busy agent
   */
  private leastBusy(agents: Agent[]): Agent {
    // Sort by number of tasks in history (proxy for busy-ness)
    const sorted = [...agents].sort(
      (a, b) => a.taskHistory.length - b.taskHistory.length,
    );
    return sorted[0];
  }

  /**
   * Select agent with best capability match
   */
  private capabilityMatch(agents: Agent[], task: Task): Agent | null {
    let bestAgent: Agent | null = null;
    let bestScore = -1;

    for (const agent of agents) {
      let score = 0;
      for (const required of task.requiredCapabilities) {
        const capability = agent.capabilities.find((c) => c.name === required);
        if (capability) {
          score += capability.proficiency;
        }
      }

      if (score > bestScore) {
        bestScore = score;
        bestAgent = agent;
      }
    }

    return bestAgent;
  }

  /**
   * Hybrid selection combining multiple strategies
   */
  private hybrid(agents: Agent[], task: Task): Agent | null {
    // Score agents on multiple factors
    const scores: Map<string, number> = new Map();

    for (const agent of agents) {
      let score = 0;

      // Capability match (40%)
      for (const required of task.requiredCapabilities) {
        const capability = agent.capabilities.find((c) => c.name === required);
        if (capability) {
          score += 0.4 * capability.proficiency;
        }
      }

      // Performance history (30%)
      score += 0.3 * agent.performance.successRate;

      // Resource efficiency (20%)
      score += 0.2 * agent.performance.resourceEfficiency;

      // Availability (10%)
      score += agent.status === "idle" ? 0.1 : 0;

      scores.set(agent.id, score);
    }

    // Select agent with highest score
    let bestAgent: Agent | null = null;
    let bestScore = -1;

    for (const agent of agents) {
      const score = scores.get(agent.id) || 0;
      if (score > bestScore) {
        bestScore = score;
        bestAgent = agent;
      }
    }

    return bestAgent;
  }
}

// ============================================================================
// SECTION 7: COMMAND CENTER
// ============================================================================

/**
 * Main Command Center class
 */
export class CommandCenter {
  private state: MutableState;
  private agentFactory: AgentFactory;
  private taskManager: TaskManager;
  private messageBus: MessageBus;
  private loadBalancer: LoadBalancer;
  private eventListeners: Map<string, Array<(data: unknown) => void>> =
    new Map();

  constructor(config: Partial<CommandCenterConfig> = {}) {
    this.agentFactory = new AgentFactory();
    this.taskManager = new TaskManager();
    this.messageBus = new MessageBus();
    this.loadBalancer = new LoadBalancer();

    const defaultConfig: CommandCenterConfig = {
      maxAgents: MAX_AGENTS,
      maxQueueSize: TASK_QUEUE_SIZE,
      defaultTimeout: DEFAULT_TASK_TIMEOUT,
      autoScaling: true,
      loadBalancing: "hybrid",
      priorityBoost: true,
      deadlockDetection: true,
      autoRecovery: true,
      loggingLevel: "info",
    };

    this.state = {
      timestamp: Date.now(),
      agents: new Map(),
      tasks: new Map(),
      taskQueue: [],
      messageQueue: [],
      commandHistory: [],
      config: { ...defaultConfig, ...config },
      metrics: {
        totalTasksCreated: 0,
        totalTasksCompleted: 0,
        totalTasksFailed: 0,
        averageTaskTime: 0,
        queueLength: 0,
        activeAgents: 0,
        resourceUtilization: 0,
        throughput: 0,
        uptime: 0,
      },
      alerts: [],
      isOperational: true,
    };

    // Set up message handlers
    this.messageBus.subscribeToBroadcasts(this.handleBroadcast.bind(this));
  }

  /**
   * Spawn a new agent
   */
  spawnAgent(
    name: string,
    specialization: AgentSpecialization,
    capabilities: string[] = [],
    metadata: Partial<AgentMetadata> = {},
  ): Agent | null {
    if (this.state.agents.size >= this.state.config.maxAgents) {
      this.addAlert(
        "warning",
        "command_center",
        `Cannot spawn agent: max agents (${this.state.config.maxAgents}) reached`,
      );
      return null;
    }

    const agent = this.agentFactory.createAgent(
      name,
      specialization,
      capabilities,
      metadata,
    );
    this.state.agents.set(agent.id, agent);

    // Subscribe agent to message bus
    this.messageBus.subscribe(agent.id, (message) => {
      this.handleAgentMessage(agent.id, message);
    });

    this.emit("agent_spawned", agent);

    return agent;
  }

  /**
   * Terminate an agent
   */
  terminateAgent(agentId: string): boolean {
    const agent = this.state.agents.get(agentId);
    if (!agent) return false;

    // If agent has current task, requeue it
    if (agent.currentTask) {
      const task = this.taskManager.getTask(agent.currentTask);
      if (task && task.status === "in_progress") {
        this.taskManager.updateTaskStatus(task.id, "queued");
      }
    }

    // Update agent status
    this.state.agents.set(agentId, { ...agent, status: "terminated" });

    // Unsubscribe from message bus
    this.messageBus.unsubscribe(agentId);

    this.emit("agent_terminated", { agentId });

    return true;
  }

  /**
   * Create a task
   */
  createTask(
    name: string,
    description: string,
    prompt: string,
    options: {
      priority?: TaskPriority;
      capabilities?: string[];
      timeout?: number;
      deadline?: number;
      dependencies?: string[];
    } = {},
  ): Task {
    const task = this.taskManager.createTask(
      name,
      description,
      "atomic",
      {
        prompt,
        context: {
          previousTasks: [],
          relatedMemory: [],
          userPreferences: {},
          environmentState: {},
        },
      },
      {
        priority: options.priority,
        requiredCapabilities: options.capabilities || [],
        timeout: options.timeout,
        deadline: options.deadline,
        dependencies: options.dependencies,
      },
    );

    this.state.tasks.set(task.id, task);
    this.state.metrics = {
      ...this.state.metrics,
      totalTasksCreated: this.state.metrics.totalTasksCreated + 1,
      queueLength: this.taskManager.getQueue().length,
    };

    this.emit("task_created", task);

    // Try to assign immediately
    this.assignPendingTasks();

    return task;
  }

  /**
   * Create a composite task
   */
  createCompositeTask(
    name: string,
    description: string,
    subtasks: Array<{
      name: string;
      description: string;
      prompt: string;
      capabilities?: string[];
    }>,
    parallel = false,
  ): Task {
    const subtaskDefs = subtasks.map((s) => ({
      name: s.name,
      description: s.description,
      input: { prompt: s.prompt },
      capabilities: s.capabilities,
    }));

    const task = this.taskManager.createCompositeTask(
      name,
      description,
      subtaskDefs,
      parallel,
    );

    this.state.tasks.set(task.id, task);
    for (const subtaskId of task.subtasks) {
      const subtask = this.taskManager.getTask(subtaskId);
      if (subtask) {
        this.state.tasks.set(subtaskId, subtask);
      }
    }

    this.emit("task_created", task);
    this.assignPendingTasks();

    return task;
  }

  /**
   * Try to assign pending tasks to available agents
   */
  private assignPendingTasks(): void {
    const availableAgents = Array.from(this.state.agents.values()).filter(
      (a) => a.status === "idle",
    );

    for (const agent of availableAgents) {
      const capabilityNames = agent.capabilities.map((c) => c.name);
      const task = this.taskManager.getNextTask(capabilityNames);

      if (task) {
        this.assignTaskToAgent(task.id, agent.id);
      }
    }
  }

  /**
   * Assign a task to an agent
   */
  private assignTaskToAgent(taskId: string, agentId: string): void {
    const task = this.taskManager.assignTask(taskId, agentId);
    if (!task) return;

    const agent = this.state.agents.get(agentId);
    if (!agent) return;

    // Update agent
    this.state.agents.set(agentId, {
      ...agent,
      status: "busy",
      currentTask: taskId,
    });

    // Update task in state
    this.state.tasks.set(taskId, task);

    // Send task assignment message
    this.messageBus.send("task_assignment", "command_center", agentId, {
      task,
    });

    this.emit("task_assigned", { taskId, agentId });
  }

  /**
   * Complete a task
   */
  completeTask(taskId: string, output: TaskOutput): void {
    const task = this.taskManager.updateTaskStatus(taskId, "completed", output);
    if (!task) return;

    // Update state
    this.state.tasks.set(taskId, task);

    // Update agent
    if (task.assignedAgent) {
      const agent = this.state.agents.get(task.assignedAgent);
      if (agent) {
        const completionTime = task.completed! - task.started!;
        const recentLatency = [
          ...agent.performance.recentLatency,
          completionTime,
        ].slice(-10);
        const avgLatency =
          recentLatency.reduce((a, b) => a + b, 0) / recentLatency.length;

        this.state.agents.set(task.assignedAgent, {
          ...agent,
          status: "idle",
          currentTask: undefined,
          taskHistory: [...agent.taskHistory, taskId],
          performance: {
            ...agent.performance,
            tasksCompleted: agent.performance.tasksCompleted + 1,
            averageCompletionTime: avgLatency,
            successRate:
              (agent.performance.tasksCompleted + 1) /
              (agent.performance.tasksCompleted +
                agent.performance.tasksFailed +
                1),
            recentLatency,
          },
        });
      }
    }

    // Update metrics
    this.state.metrics = {
      ...this.state.metrics,
      totalTasksCompleted: this.state.metrics.totalTasksCompleted + 1,
      queueLength: this.taskManager.getQueue().length,
    };

    this.emit("task_completed", { taskId, output });

    // Try to assign more tasks
    this.assignPendingTasks();
  }

  /**
   * Fail a task
   */
  failTask(taskId: string, error: TaskError): void {
    const task = this.taskManager.updateTaskStatus(
      taskId,
      "failed",
      undefined,
      error,
    );
    if (!task) return;

    this.state.tasks.set(taskId, task);

    // Update agent
    if (task.assignedAgent) {
      const agent = this.state.agents.get(task.assignedAgent);
      if (agent) {
        this.state.agents.set(task.assignedAgent, {
          ...agent,
          status: "idle",
          currentTask: undefined,
          performance: {
            ...agent.performance,
            tasksFailed: agent.performance.tasksFailed + 1,
            successRate:
              agent.performance.tasksCompleted /
              (agent.performance.tasksCompleted +
                agent.performance.tasksFailed +
                1),
          },
        });
      }
    }

    // Update metrics
    this.state.metrics = {
      ...this.state.metrics,
      totalTasksFailed: this.state.metrics.totalTasksFailed + 1,
    };

    // Auto-retry if enabled and retries available
    if (
      this.state.config.autoRecovery &&
      error.recoverable &&
      task.retries < task.maxRetries
    ) {
      this.taskManager.retryTask(taskId);
    }

    this.emit("task_failed", { taskId, error });
    this.assignPendingTasks();
  }

  /**
   * Process operator command
   */
  processCommand(command: OperatorCommand): unknown {
    this.state.commandHistory.push(command);

    try {
      let result: unknown;

      switch (command.command) {
        case "spawn_agent":
          result = this.spawnAgent(
            command.parameters.name as string,
            command.parameters.specialization as AgentSpecialization,
            command.parameters.capabilities as string[],
            command.parameters.metadata as Partial<AgentMetadata>,
          );
          break;

        case "terminate_agent":
          result = this.terminateAgent(command.target!);
          break;

        case "create_task":
          result = this.createTask(
            command.parameters.name as string,
            command.parameters.description as string,
            command.parameters.prompt as string,
            command.parameters.options as any,
          );
          break;

        case "cancel_task":
          result = this.taskManager.cancelTask(command.target!);
          break;

        case "query_status":
          result = this.getStatus();
          break;

        case "emergency_halt":
          result = this.emergencyHalt();
          break;

        case "broadcast":
          this.messageBus.send(
            "broadcast",
            "operator",
            "broadcast",
            command.parameters.message,
          );
          result = true;
          break;

        default:
          result = null;
      }

      return result;
    } catch (_error) {
      this.addAlert(
        "error",
        "command_center",
        `Command failed: ${command.command}`,
      );
      return null;
    }
  }

  /**
   * Emergency halt all operations
   */
  private emergencyHalt(): boolean {
    this.state = {
      ...this.state,
      isOperational: false,
    };

    // Suspend all agents
    for (const [id, agent] of this.state.agents) {
      this.state.agents.set(id, { ...agent, status: "suspended" });
    }

    // Cancel all queued tasks
    for (const taskId of this.taskManager.getQueue()) {
      this.taskManager.cancelTask(taskId);
    }

    this.addAlert("critical", "command_center", "Emergency halt executed");
    this.emit("emergency_halt", {});

    return true;
  }

  /**
   * Handle message from agent
   */
  private handleAgentMessage(agentId: string, message: Message): void {
    switch (message.type) {
      case "task_completion":
        this.completeTask(
          (message.content as any).taskId,
          (message.content as any).output,
        );
        break;

      case "task_failure":
        this.failTask(
          (message.content as any).taskId,
          (message.content as any).error,
        );
        break;

      case "heartbeat":
        this.updateAgentHeartbeat(agentId);
        break;

      case "alert":
        this.addAlert(
          (message.content as any).severity,
          agentId,
          (message.content as any).message,
        );
        break;
    }
  }

  /**
   * Handle broadcast message
   */
  private handleBroadcast(message: Message): void {
    this.emit("broadcast", message);
  }

  /**
   * Update agent heartbeat
   */
  private updateAgentHeartbeat(agentId: string): void {
    const agent = this.state.agents.get(agentId);
    if (agent) {
      this.state.agents.set(agentId, {
        ...agent,
        lastHeartbeat: Date.now(),
      });
    }
  }

  /**
   * Add an alert
   */
  private addAlert(
    severity: Alert["severity"],
    source: string,
    message: string,
  ): void {
    const alert: Alert = {
      id: `alert_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`,
      severity,
      source,
      message,
      timestamp: Date.now(),
      acknowledged: false,
    };

    this.state.alerts.push(alert);
    this.emit("alert", alert);
  }

  /**
   * Get current status
   */
  getStatus(): {
    isOperational: boolean;
    agentCount: number;
    activeAgents: number;
    queueLength: number;
    metrics: CommandCenterMetrics;
    alerts: Alert[];
  } {
    const agents = Array.from(this.state.agents.values());

    return {
      isOperational: this.state.isOperational,
      agentCount: agents.length,
      activeAgents: agents.filter((a) => a.status === "busy").length,
      queueLength: this.taskManager.getQueue().length,
      metrics: this.state.metrics,
      alerts: this.state.alerts.filter((a) => !a.acknowledged),
    };
  }

  /**
   * Get all agents
   */
  getAgents(): Agent[] {
    return Array.from(this.state.agents.values());
  }

  /**
   * Get all tasks
   */
  getTasks(): Task[] {
    return this.taskManager.getAllTasks();
  }

  /**
   * Subscribe to events
   */
  on(event: string, handler: (data: unknown) => void): void {
    if (!this.eventListeners.has(event)) {
      this.eventListeners.set(event, []);
    }
    this.eventListeners.get(event)!.push(handler);
  }

  /**
   * Emit an event
   */
  private emit(event: string, data: unknown): void {
    const handlers = this.eventListeners.get(event) || [];
    for (const handler of handlers) {
      try {
        handler(data);
      } catch (error) {
        console.error(`Event handler error for ${event}:`, error);
      }
    }
  }

  /**
   * Tick the command center
   */
  tick(): void {
    if (!this.state.isOperational) return;

    // Check for stale agents
    const now = Date.now();
    for (const [id, agent] of this.state.agents) {
      if (
        agent.status !== "terminated" &&
        now - agent.lastHeartbeat > HEARTBEAT_INTERVAL * 3
      ) {
        this.addAlert(
          "warning",
          "command_center",
          `Agent ${id} missed heartbeat`,
        );

        if (this.state.config.autoRecovery) {
          // Attempt recovery
          if (agent.currentTask) {
            const task = this.taskManager.getTask(agent.currentTask);
            if (task) {
              this.failTask(task.id, {
                code: "AGENT_UNRESPONSIVE",
                message: "Agent became unresponsive",
                recoverable: true,
              });
            }
          }

          this.state.agents.set(id, {
            ...agent,
            status: "error",
            currentTask: undefined,
          });
        }
      }
    }

    // Update metrics
    const agents = Array.from(this.state.agents.values());
    const busyAgents = agents.filter((a) => a.status === "busy").length;

    this.state.metrics = {
      ...this.state.metrics,
      activeAgents: busyAgents,
      queueLength: this.taskManager.getQueue().length,
      resourceUtilization: agents.length > 0 ? busyAgents / agents.length : 0,
      uptime: this.state.metrics.uptime + 1,
    };

    // Compute throughput (tasks per hour based on last hour)
    const oneHourAgo = now - 3600000;
    const tasksLastHour = this.taskManager
      .getAllTasks()
      .filter((t) => t.completed && t.completed >= oneHourAgo).length;
    this.state.metrics = {
      ...this.state.metrics,
      throughput: tasksLastHour,
    };

    // Try to assign pending tasks
    this.assignPendingTasks();

    this.emit("tick", { timestamp: now, metrics: this.state.metrics });
  }
}

// ============================================================================
// SECTION 8: EXPORTS
// ============================================================================

/**
 * Create and initialize a new Command Center
 */
export function createCommandCenter(
  config?: Partial<CommandCenterConfig>,
): CommandCenter {
  return new CommandCenter(config);
}

/**
 * Initialize Command Center with default agents
 */
export function initializeCommandCenterWithAgents(
  config?: Partial<CommandCenterConfig>,
): CommandCenter {
  const cc = new CommandCenter(config);

  // Spawn default agents for each specialization
  const defaultAgents: Array<{
    name: string;
    specialization: AgentSpecialization;
  }> = [
    { name: "Researcher Alpha", specialization: "research" },
    { name: "Analyst Prime", specialization: "analysis" },
    { name: "Coder One", specialization: "coding" },
    { name: "Writer Beta", specialization: "writing" },
    { name: "Planner Zeta", specialization: "planning" },
    { name: "Executor Omega", specialization: "execution" },
    { name: "Verifier Sigma", specialization: "verification" },
    { name: "Coordinator Delta", specialization: "communication" },
    { name: "Memory Keeper", specialization: "memory" },
    { name: "Reasoner Phi", specialization: "reasoning" },
    { name: "Creator Epsilon", specialization: "creativity" },
    { name: "Optimizer Theta", specialization: "optimization" },
    { name: "Guardian Lambda", specialization: "security" },
    { name: "Watcher Kappa", specialization: "monitoring" },
  ];

  for (const { name, specialization } of defaultAgents) {
    cc.spawnAgent(name, specialization);
  }

  return cc;
}
