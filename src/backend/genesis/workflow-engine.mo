// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  INTELLECTUAL PROPERTY NOTICE                                                                             ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
// ║  Location:     Dallas, Texas, United States of America                                                    ║
// ║  Contact:      MedinaSITech@outlook.com                                                                   ║
// ║  Framework:    Medina Doctrine                                                                            ║
// ║                                                                                                           ║
// ║  LEGAL PROTECTION                                                                                         ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  This source code, including all algorithms, mathematical formulations, architectural designs,            ║
// ║  naming conventions, data structures, and conceptual frameworks contained herein, constitutes             ║
// ║  the exclusive intellectual property of Alfredo Medina Hernandez.                                        ║
// ║                                                                                                           ║
// ║  PROTECTED UNDER:                                                                                         ║
// ║  • United States Copyright Law (17 U.S.C. §§ 101-1332)                                                   ║
// ║  • Berne Convention for the Protection of Literary and Artistic Works                                     ║
// ║  • WIPO Copyright Treaty (WCT)                                                                            ║
// ║  • Trade Secret Law - Defend Trade Secrets Act (18 U.S.C. § 1836)                                        ║
// ║  • Economic Espionage Act (18 U.S.C. §§ 1831-1839)                                                       ║
// ║                                                                                                           ║
// ║  CONFIDENTIALITY: This code is CONFIDENTIAL and PROPRIETARY.                                             ║
// ║  ENCRYPTION: All transmissions must be encrypted.                                                         ║
// ║  ATTRIBUTION: Required for any use, reproduction, or derivative work.                                     ║
// ║                                                                                                           ║
// ║  Unauthorized access, use, reproduction, distribution, or creation of derivative works                    ║
// ║  is strictly prohibited and will be prosecuted to the fullest extent of applicable law.                  ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝
import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Nat8 "mo:core/Nat8";
import Nat32 "mo:core/Nat32";
import Nat64 "mo:core/Nat64";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Iter "mo:core/Iter";
import Text "mo:core/Text";
import Time "mo:core/Time";
import Option "mo:core/Option";
import Result "mo:core/Result";
import Principal "mo:core/Principal";

module WorkflowEngine {

  // ═══════════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let PI : Float = 3.14159265358979323846;
  public let E : Float = 2.71828182845904523536;
  
  // Workflow limits
  public let MAX_TASKS : Nat = 10000;
  public let MAX_WORKFLOWS : Nat = 1000;
  public let MAX_STEPS_PER_WORKFLOW : Nat = 100;
  public let MAX_RETRIES : Nat = 3;
  
  // Reward parameters
  public let BASE_COMPLETION_REWARD : Float = 1.0;
  public let QUALITY_MULTIPLIER : Float = 2.0;
  public let SPEED_BONUS_FACTOR : Float = 0.5;
  public let FAILURE_PENALTY : Float = -0.2;

  // ═══════════════════════════════════════════════════════════════════════════════
  // TASK TYPES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type Task = {
    id : Nat;
    name : Text;
    description : Text;
    taskType : TaskType;
    priority : TaskPriority;
    status : TaskStatus;
    createdAt : Int;
    startedAt : ?Int;
    completedAt : ?Int;
    deadline : ?Int;
    assignee : ?Text;
    dependencies : [Nat];         // IDs of tasks that must complete first
    subtasks : [Nat];             // Child task IDs
    parentTask : ?Nat;            // Parent task ID
    inputs : [(Text, Text)];      // Input parameters
    outputs : [(Text, Text)];     // Output results
    metrics : TaskMetrics;
    retryCount : Nat;
    lastError : ?Text;
  };
  
  public type TaskType = {
    #Information;         // Information gathering
    #Processing;          // Data processing
    #Communication;       // Sending/receiving messages
    #Analysis;            // Analysis and reasoning
    #Decision;            // Decision making
    #Action;              // Taking action
    #Verification;        // Verifying results
    #Reporting;           // Generating reports
    #Learning;            // Learning new information
    #Maintenance;         // System maintenance
  };
  
  public type TaskPriority = {
    #Critical;            // Must complete immediately
    #High;                // Complete as soon as possible
    #Normal;              // Standard priority
    #Low;                 // Can wait
    #Background;          // Process when idle
  };
  
  public type TaskStatus = {
    #Pending;             // Waiting to start
    #Ready;               // Ready to execute
    #Running;             // Currently executing
    #Paused;              // Temporarily paused
    #Completed;           // Successfully completed
    #Failed;              // Failed to complete
    #Cancelled;           // Cancelled by user
    #Blocked;             // Blocked by dependency
    #Retrying;            // Retrying after failure
  };
  
  public type TaskMetrics = {
    estimatedDuration : Nat;      // Estimated beats to complete
    actualDuration : Nat;         // Actual beats taken
    qualityScore : Float;         // Quality of completion [0, 1]
    efficiencyScore : Float;      // Efficiency [0, 1]
    resourcesUsed : Float;        // Resources consumed
    completionReward : Float;     // Reward earned
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // WORKFLOW TYPES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type Workflow = {
    id : Nat;
    name : Text;
    description : Text;
    workflowType : WorkflowType;
    status : WorkflowStatus;
    steps : [WorkflowStep];
    currentStep : Nat;
    createdAt : Int;
    startedAt : ?Int;
    completedAt : ?Int;
    variables : [(Text, Text)];   // Workflow variables
    metrics : WorkflowMetrics;
    errorHandling : ErrorHandling;
  };
  
  public type WorkflowType = {
    #Sequential;          // Steps execute in order
    #Parallel;            // Steps can execute in parallel
    #Conditional;         // Steps depend on conditions
    #Loop;                // Repeating workflow
    #StateMachine;        // State-based workflow
    #DAG;                 // Directed acyclic graph
  };
  
  public type WorkflowStatus = {
    #Draft;
    #Ready;
    #Running;
    #Paused;
    #Completed;
    #Failed;
    #Cancelled;
  };
  
  public type WorkflowStep = {
    id : Nat;
    name : Text;
    taskType : TaskType;
    status : TaskStatus;
    condition : ?StepCondition;
    inputs : [(Text, Text)];
    outputs : [(Text, Text)];
    timeout : Nat;                // Max beats for this step
    retryPolicy : RetryPolicy;
    onSuccess : ?Nat;             // Next step on success
    onFailure : ?Nat;             // Next step on failure
  };
  
  public type StepCondition = {
    variable : Text;
    operator : ConditionOperator;
    value : Text;
  };
  
  public type ConditionOperator = {
    #Equals;
    #NotEquals;
    #GreaterThan;
    #LessThan;
    #Contains;
    #IsEmpty;
    #IsNotEmpty;
  };
  
  public type RetryPolicy = {
    maxRetries : Nat;
    backoffMultiplier : Float;
    initialDelay : Nat;
    maxDelay : Nat;
  };
  
  public type ErrorHandling = {
    onError : ErrorAction;
    notifyOnFailure : Bool;
    rollbackOnFailure : Bool;
    continueOnPartialFailure : Bool;
  };
  
  public type ErrorAction = {
    #Fail;                // Mark workflow as failed
    #Retry;               // Retry the step
    #Skip;                // Skip and continue
    #Rollback;            // Rollback to checkpoint
    #Notify;              // Notify and pause
  };
  
  public type WorkflowMetrics = {
    totalSteps : Nat;
    completedSteps : Nat;
    failedSteps : Nat;
    totalDuration : Nat;
    avgStepDuration : Float;
    successRate : Float;
    qualityScore : Float;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // TASK QUEUE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type TaskQueue = {
    pending : [Task];
    ready : [Task];
    running : [Task];
    completed : [Task];
    failed : [Task];
    maxConcurrent : Nat;
    currentConcurrent : Nat;
    totalProcessed : Nat;
    totalSucceeded : Nat;
    totalFailed : Nat;
  };
  
  public func initTaskQueue() : TaskQueue {
    {
      pending = [];
      ready = [];
      running = [];
      completed = [];
      failed = [];
      maxConcurrent = 10;
      currentConcurrent = 0;
      totalProcessed = 0;
      totalSucceeded = 0;
      totalFailed = 0;
    }
  };
  
  // Enqueue task
  public func enqueueTask(
    queue : TaskQueue,
    task : Task
  ) : TaskQueue {
    let newPending = Array.append(queue.pending, [task]);
    
    {
      pending = newPending;
      ready = queue.ready;
      running = queue.running;
      completed = queue.completed;
      failed = queue.failed;
      maxConcurrent = queue.maxConcurrent;
      currentConcurrent = queue.currentConcurrent;
      totalProcessed = queue.totalProcessed;
      totalSucceeded = queue.totalSucceeded;
      totalFailed = queue.totalFailed;
    }
  };
  
  // Promote pending to ready (when dependencies met)
  public func promotePending(
    queue : TaskQueue,
    completedIds : [Nat]
  ) : TaskQueue {
    let newReady = Buffer.Buffer<Task>(queue.pending.size());
    let stillPending = Buffer.Buffer<Task>(queue.pending.size());
    
    for (task in queue.pending.vals()) {
      var allDepsMet = true;
      
      for (depId in task.dependencies.vals()) {
        var found = false;
        for (compId in completedIds.vals()) {
          if (depId == compId) { found := true };
        };
        if (not found) { allDepsMet := false };
      };
      
      if (allDepsMet) {
        newReady.add({
          id = task.id;
          name = task.name;
          description = task.description;
          taskType = task.taskType;
          priority = task.priority;
          status = #Ready;
          createdAt = task.createdAt;
          startedAt = task.startedAt;
          completedAt = task.completedAt;
          deadline = task.deadline;
          assignee = task.assignee;
          dependencies = task.dependencies;
          subtasks = task.subtasks;
          parentTask = task.parentTask;
          inputs = task.inputs;
          outputs = task.outputs;
          metrics = task.metrics;
          retryCount = task.retryCount;
          lastError = task.lastError;
        });
      } else {
        stillPending.add(task);
      };
    };
    
    {
      pending = Buffer.toArray(stillPending);
      ready = Array.append(queue.ready, Buffer.toArray(newReady));
      running = queue.running;
      completed = queue.completed;
      failed = queue.failed;
      maxConcurrent = queue.maxConcurrent;
      currentConcurrent = queue.currentConcurrent;
      totalProcessed = queue.totalProcessed;
      totalSucceeded = queue.totalSucceeded;
      totalFailed = queue.totalFailed;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // REWARD SYSTEM — Dopaminergic completion rewards
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type RewardState = {
    totalRewards : Float;
    recentRewards : [RewardEvent];
    averageQuality : Float;
    satisfactionLevel : Float;    // How satisfied the organism feels
    motivationLevel : Float;      // Current motivation
    streakCount : Nat;            // Consecutive successes
    longestStreak : Nat;
  };
  
  public type RewardEvent = {
    taskId : Nat;
    timestamp : Int;
    baseReward : Float;
    qualityBonus : Float;
    speedBonus : Float;
    totalReward : Float;
    rewardType : RewardType;
  };
  
  public type RewardType = {
    #Completion;          // Task completed
    #Quality;             // High quality work
    #Speed;               // Fast completion
    #Streak;              // Streak bonus
    #Learning;            // Learned something new
    #Efficiency;          // Efficient resource use
  };
  
  public func initRewardState() : RewardState {
    {
      totalRewards = 0.0;
      recentRewards = [];
      averageQuality = 0.5;
      satisfactionLevel = 0.5;
      motivationLevel = 0.7;
      streakCount = 0;
      longestStreak = 0;
    }
  };
  
  // Calculate completion reward
  public func calculateReward(
    task : Task,
    currentBeat : Int
  ) : RewardEvent {
    let baseReward = BASE_COMPLETION_REWARD * priorityMultiplier(task.priority);
    
    // Quality bonus
    let qualityBonus = task.metrics.qualityScore * QUALITY_MULTIPLIER;
    
    // Speed bonus (if completed before deadline)
    let speedBonus = switch (task.deadline, task.completedAt) {
      case (?deadline, ?completed) {
        if (completed < deadline) {
          let timeLeft = Float.fromInt(deadline - completed);
          let totalTime = Float.fromInt(deadline - task.createdAt);
          if (totalTime > 0.0) {
            (timeLeft / totalTime) * SPEED_BONUS_FACTOR
          } else { 0.0 }
        } else { 0.0 }
      };
      case _ { 0.0 };
    };
    
    {
      taskId = task.id;
      timestamp = currentBeat;
      baseReward = baseReward;
      qualityBonus = qualityBonus;
      speedBonus = speedBonus;
      totalReward = baseReward + qualityBonus + speedBonus;
      rewardType = #Completion;
    }
  };
  
  func priorityMultiplier(priority : TaskPriority) : Float {
    switch (priority) {
      case (#Critical) { 3.0 };
      case (#High) { 2.0 };
      case (#Normal) { 1.0 };
      case (#Low) { 0.5 };
      case (#Background) { 0.25 };
    }
  };
  
  // Update reward state
  public func updateRewardState(
    state : RewardState,
    event : RewardEvent,
    wasSuccess : Bool
  ) : RewardState {
    let newStreak = if (wasSuccess) { state.streakCount + 1 } else { 0 };
    let newLongest = if (newStreak > state.longestStreak) { newStreak } else { state.longestStreak };
    
    // Update satisfaction based on rewards
    let newSatisfaction = clamp(
      state.satisfactionLevel + event.totalReward * 0.1 - 0.01,
      0.0, 1.0
    );
    
    // Update motivation
    let newMotivation = clamp(
      state.motivationLevel + (if (wasSuccess) { 0.02 } else { -0.05 }),
      0.3, 1.0
    );
    
    // Keep last 100 rewards
    let newRecent = if (state.recentRewards.size() >= 100) {
      let trimmed = Array.subArray(state.recentRewards, 1, 99);
      Array.append(trimmed, [event])
    } else {
      Array.append(state.recentRewards, [event])
    };
    
    {
      totalRewards = state.totalRewards + event.totalReward;
      recentRewards = newRecent;
      averageQuality = computeAvgQuality(newRecent);
      satisfactionLevel = newSatisfaction;
      motivationLevel = newMotivation;
      streakCount = newStreak;
      longestStreak = newLongest;
    }
  };
  
  func computeAvgQuality(rewards : [RewardEvent]) : Float {
    if (rewards.size() == 0) { return 0.5 };
    
    var sum : Float = 0.0;
    for (r in rewards.vals()) {
      sum += r.qualityBonus / QUALITY_MULTIPLIER;
    };
    sum / Float.fromInt(rewards.size())
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // WORKFLOW TEMPLATES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type WorkflowTemplate = {
    id : Text;
    name : Text;
    description : Text;
    category : TemplateCategory;
    steps : [WorkflowStepTemplate];
    variables : [(Text, Text)];   // Default variables
    estimatedDuration : Nat;
    complexity : Float;
    usageCount : Nat;
  };
  
  public type TemplateCategory = {
    #DataPipeline;
    #Communication;
    #Analysis;
    #Learning;
    #Maintenance;
    #Integration;
    #Reporting;
    #Custom;
  };
  
  public type WorkflowStepTemplate = {
    name : Text;
    taskType : TaskType;
    inputMappings : [(Text, Text)];
    outputMappings : [(Text, Text)];
    timeout : Nat;
    isOptional : Bool;
  };
  
  // Pre-defined workflow templates
  public let WORKFLOW_TEMPLATES : [WorkflowTemplate] = [
    {
      id = "info_gather";
      name = "Information Gathering";
      description = "Gather information from multiple sources";
      category = #DataPipeline;
      steps = [
        { name = "Identify Sources"; taskType = #Analysis; inputMappings = []; outputMappings = []; timeout = 100; isOptional = false },
        { name = "Fetch Data"; taskType = #Information; inputMappings = []; outputMappings = []; timeout = 500; isOptional = false },
        { name = "Validate Data"; taskType = #Verification; inputMappings = []; outputMappings = []; timeout = 200; isOptional = false },
        { name = "Process Data"; taskType = #Processing; inputMappings = []; outputMappings = []; timeout = 300; isOptional = false },
        { name = "Store Results"; taskType = #Action; inputMappings = []; outputMappings = []; timeout = 100; isOptional = false },
      ];
      variables = [];
      estimatedDuration = 1200;
      complexity = 0.5;
      usageCount = 0;
    },
    {
      id = "analysis_report";
      name = "Analysis and Reporting";
      description = "Analyze data and generate report";
      category = #Analysis;
      steps = [
        { name = "Load Data"; taskType = #Information; inputMappings = []; outputMappings = []; timeout = 100; isOptional = false },
        { name = "Analyze"; taskType = #Analysis; inputMappings = []; outputMappings = []; timeout = 500; isOptional = false },
        { name = "Generate Insights"; taskType = #Decision; inputMappings = []; outputMappings = []; timeout = 300; isOptional = false },
        { name = "Create Report"; taskType = #Reporting; inputMappings = []; outputMappings = []; timeout = 200; isOptional = false },
        { name = "Deliver Report"; taskType = #Communication; inputMappings = []; outputMappings = []; timeout = 100; isOptional = false },
      ];
      variables = [];
      estimatedDuration = 1200;
      complexity = 0.7;
      usageCount = 0;
    },
    {
      id = "learning_cycle";
      name = "Learning Cycle";
      description = "Learn from new information";
      category = #Learning;
      steps = [
        { name = "Identify Knowledge Gap"; taskType = #Analysis; inputMappings = []; outputMappings = []; timeout = 200; isOptional = false },
        { name = "Seek Information"; taskType = #Information; inputMappings = []; outputMappings = []; timeout = 500; isOptional = false },
        { name = "Process Information"; taskType = #Processing; inputMappings = []; outputMappings = []; timeout = 300; isOptional = false },
        { name = "Integrate Knowledge"; taskType = #Learning; inputMappings = []; outputMappings = []; timeout = 400; isOptional = false },
        { name = "Verify Integration"; taskType = #Verification; inputMappings = []; outputMappings = []; timeout = 200; isOptional = false },
      ];
      variables = [];
      estimatedDuration = 1600;
      complexity = 0.8;
      usageCount = 0;
    },
  ];

  // ═══════════════════════════════════════════════════════════════════════════════
  // COMPLETE WORKFLOW STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type WorkflowState = {
    taskQueue : TaskQueue;
    workflows : [Workflow];
    templates : [WorkflowTemplate];
    rewards : RewardState;
    nextTaskId : Nat;
    nextWorkflowId : Nat;
    totalTasksCreated : Nat;
    totalWorkflowsCreated : Nat;
    lastTick : Int;
  };
  
  public func initWorkflowState() : WorkflowState {
    {
      taskQueue = initTaskQueue();
      workflows = [];
      templates = WORKFLOW_TEMPLATES;
      rewards = initRewardState();
      nextTaskId = 1;
      nextWorkflowId = 1;
      totalTasksCreated = 0;
      totalWorkflowsCreated = 0;
      lastTick = 0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // WORKFLOW TICK
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type WorkflowTickResult = {
    tasksStarted : Nat;
    tasksCompleted : Nat;
    tasksFailed : Nat;
    workflowsProgressed : Nat;
    rewardsEarned : Float;
    satisfactionLevel : Float;
    motivationLevel : Float;
  };
  
  public func workflowTick(
    state : WorkflowState,
    currentBeat : Int
  ) : WorkflowTickResult {
    var tasksStarted : Nat = 0;
    var tasksCompleted : Nat = 0;
    var tasksFailed : Nat = 0;
    var workflowsProgressed : Nat = 0;
    var rewardsEarned : Float = 0.0;
    
    // Process ready tasks
    let availableSlots = state.taskQueue.maxConcurrent - state.taskQueue.currentConcurrent;
    
    // Simulate task completions (in real implementation, would check actual completion)
    for (task in state.taskQueue.running.vals()) {
      // Simple simulation: tasks complete after estimated duration
      switch (task.startedAt) {
        case (?started) {
          let elapsed = Int.abs(currentBeat - started);
          if (elapsed >= task.metrics.estimatedDuration) {
            tasksCompleted += 1;
            
            // Calculate reward
            let reward = calculateReward(task, currentBeat);
            rewardsEarned += reward.totalReward;
          };
        };
        case null {};
      };
    };
    
    // Count workflow progress
    for (workflow in state.workflows.vals()) {
      switch (workflow.status) {
        case (#Running) { workflowsProgressed += 1 };
        case _ {};
      };
    };
    
    {
      tasksStarted = Nat.min(availableSlots, state.taskQueue.ready.size());
      tasksCompleted = tasksCompleted;
      tasksFailed = tasksFailed;
      workflowsProgressed = workflowsProgressed;
      rewardsEarned = rewardsEarned;
      satisfactionLevel = state.rewards.satisfactionLevel;
      motivationLevel = state.rewards.motivationLevel;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // HELPER FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  func clamp(value : Float, min : Float, max : Float) : Float {
    if (value < min) { min }
    else if (value > max) { max }
    else { value }
  };

}
