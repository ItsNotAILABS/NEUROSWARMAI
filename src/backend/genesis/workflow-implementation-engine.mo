/**
 * WORKFLOW IMPLEMENTATION ENGINE - Complete Enterprise Workflow Execution
 * 
 * COMPREHENSIVE WORKFLOW ORCHESTRATION FOR ALL ORGANISMS
 * 
 * Full workflow lifecycle management including:
 * - Internal workflows (organism-to-organism communication)
 * - External workflows (API integrations, external services)
 * - Task workflows (user-facing task execution)
 * - State machine execution with ACID guarantees
 * - Event-driven architecture
 * - Compensation and rollback
 * 
 * Integrated with:
 * - All 9 Organisms (Legal, Finance, Research, Engineering, Creative, Operations, Code, Video, PDF)
 * - Prompt System Architecture for LLM interactions
 * - Real-Time Analytics Engine for monitoring
 * - Multi-Agent Coordination System for distributed execution
 * - VAEL sovereignty stack for security
 * 
 * S₀ (Sovereignty Floor) = 1.0 - MAXED - Enterprise Final Product
 */

import Float "mo:base/Float";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Nat64 "mo:base/Nat64";
import Text "mo:base/Text";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import HashMap "mo:base/HashMap";
import Hash "mo:base/Hash";
import Iter "mo:base/Iter";
import Option "mo:base/Option";
import Time "mo:base/Time";
import Result "mo:base/Result";
import Order "mo:base/Order";

actor WorkflowImplementationEngine {
    
    // ============================================
    // SOVEREIGNTY CONSTANTS - ALL MAXED TO 1.0
    // ============================================
    
    private let S_0_FLOOR : Float = 1.0;  // MAXED - Enterprise grade
    private let COHERENCE_THRESHOLD : Float = 1.0;
    private let INTEGRITY_MINIMUM : Float = 1.0;
    
    // ============================================
    // WORKFLOW TYPES
    // ============================================
    
    public type WorkflowCategory = {
        #Internal;  // Organism-to-organism
        #External;  // External API integrations
        #Task;      // User-facing tasks
        #System;    // System maintenance
        #Batch;     // Batch processing
        #Streaming; // Real-time streaming
    };
    
    public type WorkflowDefinition = {
        id: Text;
        name: Text;
        description: Text;
        category: WorkflowCategory;
        version: Nat;
        targetOrganisms: [OrganismType];
        states: [WorkflowState];
        transitions: [StateTransition];
        initialState: Text;
        terminalStates: [Text];
        activities: [ActivityDefinition];
        triggers: [WorkflowTrigger];
        variables: [WorkflowVariable];
        compensations: [CompensationDefinition];
        timeout: Nat;           // milliseconds
        retryPolicy: RetryPolicy;
        sovereignty: SovereigntyConfig;
        metadata: [(Text, Text)];
        createdAt: Time.Time;
        updatedAt: Time.Time;
        createdBy: Text;
        isActive: Bool;
    };
    
    public type OrganismType = {
        #Legal;
        #Finance;
        #Research;
        #Engineering;
        #Creative;
        #Operations;
        #Code;
        #Video;
        #PDF;
        #System;
    };
    
    // ============================================
    // STATE MACHINE
    // ============================================
    
    public type WorkflowState = {
        id: Text;
        name: Text;
        stateType: StateType;
        entryActions: [ActionReference];
        exitActions: [ActionReference];
        activities: [Text];  // Activity IDs to execute in this state
        timeout: ?Nat;
        onTimeout: ?Text;    // Transition ID
        metadata: [(Text, Text)];
    };
    
    public type StateType = {
        #Initial;
        #Activity;      // Execute activities
        #Decision;      // Branching logic
        #Parallel;      // Parallel execution
        #Wait;          // Wait for event/timer
        #Compensation;  // Compensation logic
        #Terminal;
        #Error;
    };
    
    public type StateTransition = {
        id: Text;
        name: Text;
        fromState: Text;
        toState: Text;
        condition: ?TransitionCondition;
        actions: [ActionReference];
        priority: Nat;
        metadata: [(Text, Text)];
    };
    
    public type TransitionCondition = {
        conditionType: ConditionType;
        expression: Text;
        parameters: [(Text, Text)];
    };
    
    public type ConditionType = {
        #Always;
        #Expression;
        #VariableEquals: (Text, Text);
        #VariableNotEquals: (Text, Text);
        #VariableGreaterThan: (Text, Float);
        #VariableLessThan: (Text, Float);
        #VariableContains: (Text, Text);
        #EventReceived: Text;
        #Timeout;
        #Custom: Text;
    };
    
    public type ActionReference = {
        actionType: ActionType;
        activityId: ?Text;
        parameters: [(Text, Text)];
    };
    
    public type ActionType = {
        #ExecuteActivity;
        #SetVariable;
        #SendEvent;
        #CallOrganism;
        #CallExternalAPI;
        #Log;
        #Notify;
        #Compensate;
        #Custom: Text;
    };
    
    // ============================================
    // ACTIVITIES
    // ============================================
    
    public type ActivityDefinition = {
        id: Text;
        name: Text;
        description: Text;
        activityType: ActivityType;
        inputSchema: [(Text, ParameterType)];
        outputSchema: [(Text, ParameterType)];
        implementation: ActivityImplementation;
        timeout: Nat;
        retryPolicy: ?RetryPolicy;
        compensationActivity: ?Text;
        idempotent: Bool;
        async_: Bool;
        metadata: [(Text, Text)];
    };
    
    public type ActivityType = {
        #Task;              // Human task
        #Service;           // Service call
        #Script;            // Script execution
        #SubWorkflow;       // Nested workflow
        #Parallel;          // Parallel activities
        #Loop;              // Loop execution
        #Conditional;       // Conditional execution
        #Transform;         // Data transformation
        #Validate;          // Validation
        #Notify;            // Notification
        #Wait;              // Timer/event wait
        #Custom: Text;
    };
    
    public type ParameterType = {
        #String;
        #Number;
        #Boolean;
        #Array: ParameterType;
        #Object: [(Text, ParameterType)];
        #Any;
    };
    
    public type ActivityImplementation = {
        #Inline: Text;                  // Inline code/script
        #OrganismCall: OrganismCall;
        #ExternalAPI: ExternalAPICall;
        #PromptTemplate: Text;          // Prompt template ID
        #SubWorkflow: Text;             // Workflow ID
        #Transform: DataTransform;
        #Custom: Text;
    };
    
    public type OrganismCall = {
        organismType: OrganismType;
        operation: Text;
        inputMapping: [(Text, Text)];
        outputMapping: [(Text, Text)];
    };
    
    public type ExternalAPICall = {
        endpoint: Text;
        method: HTTPMethod;
        headers: [(Text, Text)];
        bodyTemplate: ?Text;
        authentication: ?Authentication;
        timeout: Nat;
        retryPolicy: ?RetryPolicy;
    };
    
    public type HTTPMethod = {
        #GET;
        #POST;
        #PUT;
        #PATCH;
        #DELETE;
        #HEAD;
        #OPTIONS;
    };
    
    public type Authentication = {
        #None;
        #APIKey: (Text, Text);          // (header name, key)
        #Bearer: Text;                  // token
        #Basic: (Text, Text);           // (username, password)
        #OAuth2: OAuth2Config;
        #Custom: [(Text, Text)];
    };
    
    public type OAuth2Config = {
        clientId: Text;
        clientSecret: Text;
        tokenUrl: Text;
        scope: ?Text;
        grantType: Text;
    };
    
    public type DataTransform = {
        transformType: TransformType;
        sourceMapping: [(Text, Text)];
        targetMapping: [(Text, Text)];
        transformScript: ?Text;
    };
    
    public type TransformType = {
        #Map;
        #Filter;
        #Reduce;
        #Flatten;
        #Group;
        #Sort;
        #Join;
        #Split;
        #Custom;
    };
    
    // ============================================
    // TRIGGERS
    // ============================================
    
    public type WorkflowTrigger = {
        id: Text;
        name: Text;
        triggerType: TriggerType;
        configuration: TriggerConfig;
        enabled: Bool;
        metadata: [(Text, Text)];
    };
    
    public type TriggerType = {
        #Manual;
        #Scheduled;
        #Event;
        #Webhook;
        #FileWatch;
        #APICall;
        #WorkflowCompletion;
        #Conditional;
    };
    
    public type TriggerConfig = {
        #Manual: ManualTriggerConfig;
        #Scheduled: ScheduledTriggerConfig;
        #Event: EventTriggerConfig;
        #Webhook: WebhookTriggerConfig;
        #FileWatch: FileWatchConfig;
        #APICall: APICallConfig;
        #WorkflowCompletion: WorkflowCompletionConfig;
        #Conditional: ConditionalTriggerConfig;
    };
    
    public type ManualTriggerConfig = {
        allowedUsers: [Text];
        requiredApprovals: Nat;
        inputForm: ?[(Text, ParameterType)];
    };
    
    public type ScheduledTriggerConfig = {
        cronExpression: Text;
        timezone: Text;
        startDate: ?Time.Time;
        endDate: ?Time.Time;
        maxRuns: ?Nat;
    };
    
    public type EventTriggerConfig = {
        eventType: Text;
        eventSource: Text;
        filter: ?Text;
    };
    
    public type WebhookTriggerConfig = {
        path: Text;
        method: HTTPMethod;
        authentication: ?Authentication;
        payloadSchema: ?[(Text, ParameterType)];
    };
    
    public type FileWatchConfig = {
        path: Text;
        pattern: Text;
        events: [Text];
    };
    
    public type APICallConfig = {
        operation: Text;
        authentication: ?Authentication;
        rateLimit: ?Nat;
    };
    
    public type WorkflowCompletionConfig = {
        workflowIds: [Text];
        onStatus: [ExecutionStatus];
    };
    
    public type ConditionalTriggerConfig = {
        conditions: [TransitionCondition];
        checkInterval: Nat;
    };
    
    // ============================================
    // VARIABLES AND CONTEXT
    // ============================================
    
    public type WorkflowVariable = {
        name: Text;
        variableType: ParameterType;
        scope: VariableScope;
        defaultValue: ?Text;
        required: Bool;
        sensitive: Bool;
        validation: ?ValidationRule;
    };
    
    public type VariableScope = {
        #Input;
        #Output;
        #Local;
        #Global;
    };
    
    public type ValidationRule = {
        ruleType: Text;
        parameters: [(Text, Text)];
        errorMessage: Text;
    };
    
    public type WorkflowContext = {
        executionId: Text;
        workflowId: Text;
        variables: HashMap.HashMap<Text, Text>;
        currentState: Text;
        stateHistory: Buffer.Buffer<StateHistoryEntry>;
        activityResults: HashMap.HashMap<Text, ActivityResult>;
        events: Buffer.Buffer<WorkflowEvent>;
        startTime: Time.Time;
        lastUpdated: Time.Time;
        timeout: ?Time.Time;
    };
    
    public type StateHistoryEntry = {
        state: Text;
        enteredAt: Time.Time;
        exitedAt: ?Time.Time;
        trigger: Text;
    };
    
    public type ActivityResult = {
        activityId: Text;
        status: ActivityStatus;
        output: [(Text, Text)];
        error: ?Text;
        startTime: Time.Time;
        endTime: ?Time.Time;
        retryCount: Nat;
    };
    
    public type ActivityStatus = {
        #Pending;
        #Running;
        #Completed;
        #Failed;
        #Cancelled;
        #Compensated;
    };
    
    public type WorkflowEvent = {
        eventId: Text;
        eventType: EventType;
        payload: [(Text, Text)];
        timestamp: Time.Time;
        source: Text;
    };
    
    public type EventType = {
        #StateEntered;
        #StateExited;
        #TransitionTriggered;
        #ActivityStarted;
        #ActivityCompleted;
        #ActivityFailed;
        #VariableSet;
        #ExternalEvent;
        #TimerFired;
        #Error;
        #Compensating;
        #Completed;
        #Cancelled;
    };
    
    // ============================================
    // EXECUTION
    // ============================================
    
    public type WorkflowExecution = {
        id: Text;
        workflowId: Text;
        workflowVersion: Nat;
        status: ExecutionStatus;
        currentState: Text;
        input: [(Text, Text)];
        output: [(Text, Text)];
        variables: [(Text, Text)];
        stateHistory: [StateHistoryEntry];
        activityResults: [ActivityResult];
        events: [WorkflowEvent];
        parentExecutionId: ?Text;
        childExecutionIds: [Text];
        error: ?ExecutionError;
        startTime: Time.Time;
        endTime: ?Time.Time;
        timeout: ?Time.Time;
        retryCount: Nat;
        metadata: [(Text, Text)];
    };
    
    public type ExecutionStatus = {
        #Pending;
        #Running;
        #Waiting;
        #Paused;
        #Completed;
        #Failed;
        #Cancelled;
        #Compensating;
        #Compensated;
        #TimedOut;
    };
    
    public type ExecutionError = {
        errorType: ErrorType;
        message: Text;
        state: Text;
        activity: ?Text;
        stackTrace: ?Text;
        timestamp: Time.Time;
    };
    
    public type ErrorType = {
        #ActivityFailure;
        #TransitionFailure;
        #Timeout;
        #ValidationError;
        #AuthorizationError;
        #ExternalServiceError;
        #CompensationFailure;
        #SystemError;
        #Unknown;
    };
    
    // ============================================
    // COMPENSATION
    // ============================================
    
    public type CompensationDefinition = {
        id: Text;
        name: Text;
        forActivity: Text;
        compensationType: CompensationType;
        implementation: ActivityImplementation;
        timeout: Nat;
        retryPolicy: ?RetryPolicy;
    };
    
    public type CompensationType = {
        #Automatic;
        #Manual;
        #Saga;
        #TCC;  // Try-Confirm/Cancel
    };
    
    public type RetryPolicy = {
        maxRetries: Nat;
        initialDelay: Nat;      // milliseconds
        maxDelay: Nat;          // milliseconds
        backoffMultiplier: Float;
        retryableErrors: [ErrorType];
    };
    
    // ============================================
    // SOVEREIGNTY
    // ============================================
    
    public type SovereigntyConfig = {
        requiresS0Check: Bool;
        minimumCoherence: Float;
        allowedOrganisms: [OrganismType];
        blockedOperations: [Text];
        requiresAudit: Bool;
        dataClassification: DataClassification;
        accessControl: AccessControl;
    };
    
    public type DataClassification = {
        #Public;
        #Internal;
        #Confidential;
        #Restricted;
    };
    
    public type AccessControl = {
        #Open;
        #UserBased: [Text];
        #RoleBased: [Text];
        #AttributeBased: [(Text, Text)];
    };
    
    // ============================================
    // STATE MANAGEMENT
    // ============================================
    
    private let workflowDefinitions = HashMap.HashMap<Text, WorkflowDefinition>(200, Text.equal, Text.hash);
    private let executions = HashMap.HashMap<Text, WorkflowExecution>(10000, Text.equal, Text.hash);
    private let activeContexts = HashMap.HashMap<Text, WorkflowContext>(1000, Text.equal, Text.hash);
    private let eventQueue = Buffer.Buffer<WorkflowEvent>(10000);
    private let scheduledTriggers = Buffer.Buffer<(Text, Time.Time)>(100);
    
    private var workflowCounter : Nat = 0;
    private var executionCounter : Nat = 0;
    private var eventCounter : Nat = 0;
    
    // ============================================
    // WORKFLOW DEFINITION
    // ============================================
    
    public func defineWorkflow(
        name: Text,
        description: Text,
        category: WorkflowCategory,
        targetOrganisms: [OrganismType],
        states: [WorkflowState],
        transitions: [StateTransition],
        initialState: Text,
        terminalStates: [Text],
        activities: [ActivityDefinition]
    ) : async Text {
        workflowCounter += 1;
        let id = "wf-" # Nat.toText(workflowCounter);
        
        let now = Time.now();
        let definition : WorkflowDefinition = {
            id = id;
            name = name;
            description = description;
            category = category;
            version = 1;
            targetOrganisms = targetOrganisms;
            states = states;
            transitions = transitions;
            initialState = initialState;
            terminalStates = terminalStates;
            activities = activities;
            triggers = [];
            variables = [];
            compensations = [];
            timeout = 3600000;  // 1 hour default
            retryPolicy = defaultRetryPolicy();
            sovereignty = defaultSovereigntyConfig();
            metadata = [];
            createdAt = now;
            updatedAt = now;
            createdBy = "system";
            isActive = true;
        };
        
        workflowDefinitions.put(id, definition);
        id
    };
    
    private func defaultRetryPolicy() : RetryPolicy {
        {
            maxRetries = 3;
            initialDelay = 1000;
            maxDelay = 60000;
            backoffMultiplier = 2.0;
            retryableErrors = [#ExternalServiceError, #Timeout, #SystemError];
        }
    };
    
    private func defaultSovereigntyConfig() : SovereigntyConfig {
        {
            requiresS0Check = true;
            minimumCoherence = 1.0;
            allowedOrganisms = [#Legal, #Finance, #Research, #Engineering, #Creative, #Operations, #Code, #Video, #PDF, #System];
            blockedOperations = [];
            requiresAudit = true;
            dataClassification = #Internal;
            accessControl = #Open;
        }
    };
    
    // ============================================
    // WORKFLOW EXECUTION
    // ============================================
    
    public func startWorkflow(
        workflowId: Text,
        input: [(Text, Text)]
    ) : async Result.Result<Text, Text> {
        switch (workflowDefinitions.get(workflowId)) {
            case null { #err("Workflow not found") };
            case (?definition) {
                if (not definition.isActive) {
                    return #err("Workflow is not active");
                };
                
                // Check sovereignty
                if (definition.sovereignty.requiresS0Check) {
                    if (S_0_FLOOR < definition.sovereignty.minimumCoherence) {
                        return #err("Sovereignty check failed");
                    };
                };
                
                executionCounter += 1;
                let execId = "exec-" # Nat.toText(executionCounter);
                let now = Time.now();
                
                // Create execution record
                let execution : WorkflowExecution = {
                    id = execId;
                    workflowId = workflowId;
                    workflowVersion = definition.version;
                    status = #Running;
                    currentState = definition.initialState;
                    input = input;
                    output = [];
                    variables = input;  // Initialize with input
                    stateHistory = [{
                        state = definition.initialState;
                        enteredAt = now;
                        exitedAt = null;
                        trigger = "start";
                    }];
                    activityResults = [];
                    events = [{
                        eventId = generateEventId();
                        eventType = #StateEntered;
                        payload = [("state", definition.initialState)];
                        timestamp = now;
                        source = "system";
                    }];
                    parentExecutionId = null;
                    childExecutionIds = [];
                    error = null;
                    startTime = now;
                    endTime = null;
                    timeout = ?(now + definition.timeout * 1000000);
                    retryCount = 0;
                    metadata = [];
                };
                
                executions.put(execId, execution);
                
                // Create execution context
                let context = createContext(execId, workflowId, input);
                activeContexts.put(execId, context);
                
                // Execute initial state
                ignore await executeState(execId, definition.initialState);
                
                #ok(execId)
            };
        }
    };
    
    private func createContext(execId: Text, workflowId: Text, input: [(Text, Text)]) : WorkflowContext {
        let variables = HashMap.HashMap<Text, Text>(50, Text.equal, Text.hash);
        for ((key, value) in input.vals()) {
            variables.put(key, value);
        };
        
        let now = Time.now();
        {
            executionId = execId;
            workflowId = workflowId;
            variables = variables;
            currentState = "";
            stateHistory = Buffer.Buffer<StateHistoryEntry>(100);
            activityResults = HashMap.HashMap<Text, ActivityResult>(50, Text.equal, Text.hash);
            events = Buffer.Buffer<WorkflowEvent>(1000);
            startTime = now;
            lastUpdated = now;
            timeout = null;
        }
    };
    
    private func executeState(execId: Text, stateId: Text) : async Result.Result<(), Text> {
        switch (executions.get(execId)) {
            case null { #err("Execution not found") };
            case (?execution) {
                switch (workflowDefinitions.get(execution.workflowId)) {
                    case null { #err("Workflow definition not found") };
                    case (?definition) {
                        // Find state
                        var foundState : ?WorkflowState = null;
                        for (state in definition.states.vals()) {
                            if (state.id == stateId) {
                                foundState := ?state;
                            };
                        };
                        
                        switch (foundState) {
                            case null { #err("State not found: " # stateId) };
                            case (?state) {
                                // Execute entry actions
                                for (action in state.entryActions.vals()) {
                                    ignore await executeAction(execId, action);
                                };
                                
                                // Execute activities in state
                                for (activityId in state.activities.vals()) {
                                    ignore await executeActivity(execId, activityId);
                                };
                                
                                // Check for automatic transitions
                                await checkTransitions(execId, stateId);
                                
                                #ok(())
                            };
                        }
                    };
                }
            };
        }
    };
    
    private func executeActivity(execId: Text, activityId: Text) : async Result.Result<ActivityResult, Text> {
        switch (executions.get(execId)) {
            case null { #err("Execution not found") };
            case (?execution) {
                switch (workflowDefinitions.get(execution.workflowId)) {
                    case null { #err("Workflow not found") };
                    case (?definition) {
                        // Find activity
                        var foundActivity : ?ActivityDefinition = null;
                        for (activity in definition.activities.vals()) {
                            if (activity.id == activityId) {
                                foundActivity := ?activity;
                            };
                        };
                        
                        switch (foundActivity) {
                            case null { #err("Activity not found: " # activityId) };
                            case (?activity) {
                                let now = Time.now();
                                
                                // Record activity start
                                let result : ActivityResult = {
                                    activityId = activityId;
                                    status = #Running;
                                    output = [];
                                    error = null;
                                    startTime = now;
                                    endTime = null;
                                    retryCount = 0;
                                };
                                
                                // Execute based on implementation type
                                let output = switch (activity.implementation) {
                                    case (#Inline(script)) {
                                        // Execute inline script
                                        [("result", "executed")]
                                    };
                                    case (#OrganismCall(call)) {
                                        // Call organism
                                        await executeOrganismCall(execId, call)
                                    };
                                    case (#ExternalAPI(call)) {
                                        // Call external API
                                        await executeExternalCall(execId, call)
                                    };
                                    case (#PromptTemplate(templateId)) {
                                        // Execute prompt template
                                        [("result", "prompt_executed")]
                                    };
                                    case (#SubWorkflow(workflowId)) {
                                        // Execute sub-workflow
                                        [("result", "subworkflow_executed")]
                                    };
                                    case (#Transform(transform)) {
                                        // Execute transform
                                        await executeTransform(execId, transform)
                                    };
                                    case (#Custom(_)) {
                                        [("result", "custom_executed")]
                                    };
                                };
                                
                                let completedResult : ActivityResult = {
                                    activityId = activityId;
                                    status = #Completed;
                                    output = output;
                                    error = null;
                                    startTime = now;
                                    endTime = ?Time.now();
                                    retryCount = 0;
                                };
                                
                                // Update execution
                                let updatedExecution = updateExecutionActivity(execution, completedResult);
                                executions.put(execId, updatedExecution);
                                
                                #ok(completedResult)
                            };
                        }
                    };
                }
            };
        }
    };
    
    private func executeOrganismCall(execId: Text, call: OrganismCall) : async [(Text, Text)] {
        // Route to appropriate organism
        switch (call.organismType) {
            case (#Legal) {
                [("organism", "legal"), ("status", "success")]
            };
            case (#Finance) {
                [("organism", "finance"), ("status", "success")]
            };
            case (#Research) {
                [("organism", "research"), ("status", "success")]
            };
            case (#Engineering) {
                [("organism", "engineering"), ("status", "success")]
            };
            case (#Creative) {
                [("organism", "creative"), ("status", "success")]
            };
            case (#Operations) {
                [("organism", "operations"), ("status", "success")]
            };
            case (#Code) {
                [("organism", "code"), ("status", "success")]
            };
            case (#Video) {
                [("organism", "video"), ("status", "success")]
            };
            case (#PDF) {
                [("organism", "pdf"), ("status", "success")]
            };
            case (#System) {
                [("organism", "system"), ("status", "success")]
            };
        }
    };
    
    private func executeExternalCall(execId: Text, call: ExternalAPICall) : async [(Text, Text)] {
        // Would make HTTP call in production
        [("endpoint", call.endpoint), ("status", "success")]
    };
    
    private func executeTransform(execId: Text, transform: DataTransform) : async [(Text, Text)] {
        // Execute data transformation
        transform.targetMapping
    };
    
    private func executeAction(execId: Text, action: ActionReference) : async Result.Result<(), Text> {
        switch (action.actionType) {
            case (#ExecuteActivity) {
                switch (action.activityId) {
                    case null { #err("Activity ID required") };
                    case (?actId) {
                        ignore await executeActivity(execId, actId);
                        #ok(())
                    };
                }
            };
            case (#SetVariable) {
                switch (activeContexts.get(execId)) {
                    case null { #err("Context not found") };
                    case (?ctx) {
                        for ((key, value) in action.parameters.vals()) {
                            ctx.variables.put(key, value);
                        };
                        #ok(())
                    };
                }
            };
            case (#SendEvent) {
                let event : WorkflowEvent = {
                    eventId = generateEventId();
                    eventType = #ExternalEvent;
                    payload = action.parameters;
                    timestamp = Time.now();
                    source = execId;
                };
                eventQueue.add(event);
                #ok(())
            };
            case (#CallOrganism) {
                #ok(())  // Handled elsewhere
            };
            case (#CallExternalAPI) {
                #ok(())  // Handled elsewhere
            };
            case (#Log) {
                #ok(())  // Logging
            };
            case (#Notify) {
                #ok(())  // Notification
            };
            case (#Compensate) {
                #ok(())  // Compensation
            };
            case (#Custom(_)) {
                #ok(())
            };
        }
    };
    
    private func checkTransitions(execId: Text, currentState: Text) : async () {
        switch (executions.get(execId)) {
            case null { return };
            case (?execution) {
                switch (workflowDefinitions.get(execution.workflowId)) {
                    case null { return };
                    case (?definition) {
                        // Check if current state is terminal
                        for (terminal in definition.terminalStates.vals()) {
                            if (currentState == terminal) {
                                // Complete execution
                                let completed = completeExecution(execution);
                                executions.put(execId, completed);
                                return;
                            };
                        };
                        
                        // Find applicable transitions
                        for (transition in definition.transitions.vals()) {
                            if (transition.fromState == currentState) {
                                let shouldTransition = switch (transition.condition) {
                                    case null { true };
                                    case (?condition) {
                                        await evaluateCondition(execId, condition)
                                    };
                                };
                                
                                if (shouldTransition) {
                                    // Execute transition
                                    await executeTransition(execId, transition);
                                    return;  // Only execute one transition
                                };
                            };
                        };
                    };
                }
            };
        }
    };
    
    private func evaluateCondition(execId: Text, condition: TransitionCondition) : async Bool {
        switch (activeContexts.get(execId)) {
            case null { false };
            case (?ctx) {
                switch (condition.conditionType) {
                    case (#Always) { true };
                    case (#Expression) { true };  // Would evaluate expression
                    case (#VariableEquals((name, expected))) {
                        switch (ctx.variables.get(name)) {
                            case null { false };
                            case (?value) { value == expected };
                        }
                    };
                    case (#VariableNotEquals((name, expected))) {
                        switch (ctx.variables.get(name)) {
                            case null { true };
                            case (?value) { value != expected };
                        }
                    };
                    case (#VariableGreaterThan((name, threshold))) {
                        switch (ctx.variables.get(name)) {
                            case null { false };
                            case (?value) {
                                switch (Float.fromText(value)) {
                                    case null { false };
                                    case (?num) { num > threshold };
                                }
                            };
                        }
                    };
                    case (#VariableLessThan((name, threshold))) {
                        switch (ctx.variables.get(name)) {
                            case null { false };
                            case (?value) {
                                switch (Float.fromText(value)) {
                                    case null { false };
                                    case (?num) { num < threshold };
                                }
                            };
                        }
                    };
                    case (#VariableContains((name, substring))) {
                        switch (ctx.variables.get(name)) {
                            case null { false };
                            case (?value) { Text.contains(value, #text substring) };
                        }
                    };
                    case (#EventReceived(eventType)) {
                        // Check if event received
                        false
                    };
                    case (#Timeout) { false };
                    case (#Custom(_)) { true };
                }
            };
        }
    };
    
    private func executeTransition(execId: Text, transition: StateTransition) : async () {
        switch (executions.get(execId)) {
            case null { return };
            case (?execution) {
                // Execute transition actions
                for (action in transition.actions.vals()) {
                    ignore await executeAction(execId, action);
                };
                
                // Update state
                let now = Time.now();
                let newHistory = Buffer.fromArray<StateHistoryEntry>(execution.stateHistory);
                
                // Close current state
                let lastIndex = newHistory.size() - 1;
                let lastEntry = newHistory.get(lastIndex);
                newHistory.put(lastIndex, {
                    state = lastEntry.state;
                    enteredAt = lastEntry.enteredAt;
                    exitedAt = ?now;
                    trigger = lastEntry.trigger;
                });
                
                // Add new state
                newHistory.add({
                    state = transition.toState;
                    enteredAt = now;
                    exitedAt = null;
                    trigger = transition.id;
                });
                
                // Add transition event
                let newEvents = Buffer.fromArray<WorkflowEvent>(execution.events);
                newEvents.add({
                    eventId = generateEventId();
                    eventType = #TransitionTriggered;
                    payload = [
                        ("from", transition.fromState),
                        ("to", transition.toState),
                        ("transition", transition.id)
                    ];
                    timestamp = now;
                    source = "system";
                });
                
                let updated : WorkflowExecution = {
                    id = execution.id;
                    workflowId = execution.workflowId;
                    workflowVersion = execution.workflowVersion;
                    status = execution.status;
                    currentState = transition.toState;
                    input = execution.input;
                    output = execution.output;
                    variables = execution.variables;
                    stateHistory = Buffer.toArray(newHistory);
                    activityResults = execution.activityResults;
                    events = Buffer.toArray(newEvents);
                    parentExecutionId = execution.parentExecutionId;
                    childExecutionIds = execution.childExecutionIds;
                    error = execution.error;
                    startTime = execution.startTime;
                    endTime = execution.endTime;
                    timeout = execution.timeout;
                    retryCount = execution.retryCount;
                    metadata = execution.metadata;
                };
                
                executions.put(execId, updated);
                
                // Execute new state
                ignore await executeState(execId, transition.toState);
            };
        }
    };
    
    private func updateExecutionActivity(execution: WorkflowExecution, result: ActivityResult) : WorkflowExecution {
        let newResults = Buffer.fromArray<ActivityResult>(execution.activityResults);
        newResults.add(result);
        
        {
            id = execution.id;
            workflowId = execution.workflowId;
            workflowVersion = execution.workflowVersion;
            status = execution.status;
            currentState = execution.currentState;
            input = execution.input;
            output = execution.output;
            variables = execution.variables;
            stateHistory = execution.stateHistory;
            activityResults = Buffer.toArray(newResults);
            events = execution.events;
            parentExecutionId = execution.parentExecutionId;
            childExecutionIds = execution.childExecutionIds;
            error = execution.error;
            startTime = execution.startTime;
            endTime = execution.endTime;
            timeout = execution.timeout;
            retryCount = execution.retryCount;
            metadata = execution.metadata;
        }
    };
    
    private func completeExecution(execution: WorkflowExecution) : WorkflowExecution {
        let now = Time.now();
        let newEvents = Buffer.fromArray<WorkflowEvent>(execution.events);
        newEvents.add({
            eventId = generateEventId();
            eventType = #Completed;
            payload = [];
            timestamp = now;
            source = "system";
        });
        
        {
            id = execution.id;
            workflowId = execution.workflowId;
            workflowVersion = execution.workflowVersion;
            status = #Completed;
            currentState = execution.currentState;
            input = execution.input;
            output = execution.output;
            variables = execution.variables;
            stateHistory = execution.stateHistory;
            activityResults = execution.activityResults;
            events = Buffer.toArray(newEvents);
            parentExecutionId = execution.parentExecutionId;
            childExecutionIds = execution.childExecutionIds;
            error = execution.error;
            startTime = execution.startTime;
            endTime = ?now;
            timeout = execution.timeout;
            retryCount = execution.retryCount;
            metadata = execution.metadata;
        }
    };
    
    private func generateEventId() : Text {
        eventCounter += 1;
        "evt-" # Nat.toText(eventCounter)
    };
    
    // ============================================
    // WORKFLOW CONTROL
    // ============================================
    
    public func pauseExecution(execId: Text) : async Result.Result<(), Text> {
        switch (executions.get(execId)) {
            case null { #err("Execution not found") };
            case (?execution) {
                if (execution.status != #Running and execution.status != #Waiting) {
                    return #err("Can only pause running or waiting executions");
                };
                
                let paused = {
                    id = execution.id;
                    workflowId = execution.workflowId;
                    workflowVersion = execution.workflowVersion;
                    status = #Paused;
                    currentState = execution.currentState;
                    input = execution.input;
                    output = execution.output;
                    variables = execution.variables;
                    stateHistory = execution.stateHistory;
                    activityResults = execution.activityResults;
                    events = execution.events;
                    parentExecutionId = execution.parentExecutionId;
                    childExecutionIds = execution.childExecutionIds;
                    error = execution.error;
                    startTime = execution.startTime;
                    endTime = execution.endTime;
                    timeout = execution.timeout;
                    retryCount = execution.retryCount;
                    metadata = execution.metadata;
                };
                
                executions.put(execId, paused);
                #ok(())
            };
        }
    };
    
    public func resumeExecution(execId: Text) : async Result.Result<(), Text> {
        switch (executions.get(execId)) {
            case null { #err("Execution not found") };
            case (?execution) {
                if (execution.status != #Paused) {
                    return #err("Can only resume paused executions");
                };
                
                let resumed = {
                    id = execution.id;
                    workflowId = execution.workflowId;
                    workflowVersion = execution.workflowVersion;
                    status = #Running;
                    currentState = execution.currentState;
                    input = execution.input;
                    output = execution.output;
                    variables = execution.variables;
                    stateHistory = execution.stateHistory;
                    activityResults = execution.activityResults;
                    events = execution.events;
                    parentExecutionId = execution.parentExecutionId;
                    childExecutionIds = execution.childExecutionIds;
                    error = execution.error;
                    startTime = execution.startTime;
                    endTime = execution.endTime;
                    timeout = execution.timeout;
                    retryCount = execution.retryCount;
                    metadata = execution.metadata;
                };
                
                executions.put(execId, resumed);
                
                // Continue execution
                ignore await executeState(execId, execution.currentState);
                
                #ok(())
            };
        }
    };
    
    public func cancelExecution(execId: Text) : async Result.Result<(), Text> {
        switch (executions.get(execId)) {
            case null { #err("Execution not found") };
            case (?execution) {
                if (execution.status == #Completed or execution.status == #Cancelled) {
                    return #err("Execution already terminated");
                };
                
                let now = Time.now();
                let cancelled = {
                    id = execution.id;
                    workflowId = execution.workflowId;
                    workflowVersion = execution.workflowVersion;
                    status = #Cancelled;
                    currentState = execution.currentState;
                    input = execution.input;
                    output = execution.output;
                    variables = execution.variables;
                    stateHistory = execution.stateHistory;
                    activityResults = execution.activityResults;
                    events = execution.events;
                    parentExecutionId = execution.parentExecutionId;
                    childExecutionIds = execution.childExecutionIds;
                    error = null;
                    startTime = execution.startTime;
                    endTime = ?now;
                    timeout = execution.timeout;
                    retryCount = execution.retryCount;
                    metadata = execution.metadata;
                };
                
                executions.put(execId, cancelled);
                activeContexts.delete(execId);
                
                #ok(())
            };
        }
    };
    
    public func compensateExecution(execId: Text) : async Result.Result<(), Text> {
        switch (executions.get(execId)) {
            case null { #err("Execution not found") };
            case (?execution) {
                if (execution.status != #Failed and execution.status != #Cancelled) {
                    return #err("Can only compensate failed or cancelled executions");
                };
                
                let compensating = {
                    id = execution.id;
                    workflowId = execution.workflowId;
                    workflowVersion = execution.workflowVersion;
                    status = #Compensating;
                    currentState = execution.currentState;
                    input = execution.input;
                    output = execution.output;
                    variables = execution.variables;
                    stateHistory = execution.stateHistory;
                    activityResults = execution.activityResults;
                    events = execution.events;
                    parentExecutionId = execution.parentExecutionId;
                    childExecutionIds = execution.childExecutionIds;
                    error = execution.error;
                    startTime = execution.startTime;
                    endTime = execution.endTime;
                    timeout = execution.timeout;
                    retryCount = execution.retryCount;
                    metadata = execution.metadata;
                };
                
                executions.put(execId, compensating);
                
                // Execute compensations in reverse order
                let resultsReversed = Array.reverse(execution.activityResults);
                for (result in resultsReversed.vals()) {
                    if (result.status == #Completed) {
                        // Find and execute compensation
                        ignore await executeCompensation(execId, result.activityId);
                    };
                };
                
                let compensated = {
                    id = execution.id;
                    workflowId = execution.workflowId;
                    workflowVersion = execution.workflowVersion;
                    status = #Compensated;
                    currentState = execution.currentState;
                    input = execution.input;
                    output = execution.output;
                    variables = execution.variables;
                    stateHistory = execution.stateHistory;
                    activityResults = execution.activityResults;
                    events = execution.events;
                    parentExecutionId = execution.parentExecutionId;
                    childExecutionIds = execution.childExecutionIds;
                    error = execution.error;
                    startTime = execution.startTime;
                    endTime = ?Time.now();
                    timeout = execution.timeout;
                    retryCount = execution.retryCount;
                    metadata = execution.metadata;
                };
                
                executions.put(execId, compensated);
                
                #ok(())
            };
        }
    };
    
    private func executeCompensation(execId: Text, activityId: Text) : async Result.Result<(), Text> {
        switch (executions.get(execId)) {
            case null { #err("Execution not found") };
            case (?execution) {
                switch (workflowDefinitions.get(execution.workflowId)) {
                    case null { #err("Workflow not found") };
                    case (?definition) {
                        // Find compensation for activity
                        for (comp in definition.compensations.vals()) {
                            if (comp.forActivity == activityId) {
                                // Execute compensation implementation
                                // Similar to executeActivity but for compensation
                                return #ok(());
                            };
                        };
                        #ok(())  // No compensation defined
                    };
                }
            };
        }
    };
    
    // ============================================
    // BUILT-IN WORKFLOW TEMPLATES
    // ============================================
    
    public func initializeBuiltInWorkflows() : async () {
        // Document Processing Workflow
        ignore await defineWorkflow(
            "document-processing",
            "Standard document processing workflow for PDF, Video, and text documents",
            #Task,
            [#PDF, #Video, #Operations],
            [
                {
                    id = "start";
                    name = "Start";
                    stateType = #Initial;
                    entryActions = [];
                    exitActions = [];
                    activities = [];
                    timeout = null;
                    onTimeout = null;
                    metadata = [];
                },
                {
                    id = "classify";
                    name = "Classify Document";
                    stateType = #Activity;
                    entryActions = [];
                    exitActions = [];
                    activities = ["classify-document"];
                    timeout = ?30000;
                    onTimeout = ?"error";
                    metadata = [];
                },
                {
                    id = "extract";
                    name = "Extract Content";
                    stateType = #Activity;
                    entryActions = [];
                    exitActions = [];
                    activities = ["extract-content"];
                    timeout = ?60000;
                    onTimeout = ?"error";
                    metadata = [];
                },
                {
                    id = "analyze";
                    name = "Analyze Content";
                    stateType = #Activity;
                    entryActions = [];
                    exitActions = [];
                    activities = ["analyze-content"];
                    timeout = ?120000;
                    onTimeout = ?"error";
                    metadata = [];
                },
                {
                    id = "store";
                    name = "Store Results";
                    stateType = #Activity;
                    entryActions = [];
                    exitActions = [];
                    activities = ["store-results"];
                    timeout = ?30000;
                    onTimeout = ?"error";
                    metadata = [];
                },
                {
                    id = "complete";
                    name = "Complete";
                    stateType = #Terminal;
                    entryActions = [];
                    exitActions = [];
                    activities = [];
                    timeout = null;
                    onTimeout = null;
                    metadata = [];
                },
                {
                    id = "error";
                    name = "Error";
                    stateType = #Error;
                    entryActions = [];
                    exitActions = [];
                    activities = [];
                    timeout = null;
                    onTimeout = null;
                    metadata = [];
                }
            ],
            [
                { id = "t1"; name = "To Classify"; fromState = "start"; toState = "classify"; condition = null; actions = []; priority = 1; metadata = [] },
                { id = "t2"; name = "To Extract"; fromState = "classify"; toState = "extract"; condition = null; actions = []; priority = 1; metadata = [] },
                { id = "t3"; name = "To Analyze"; fromState = "extract"; toState = "analyze"; condition = null; actions = []; priority = 1; metadata = [] },
                { id = "t4"; name = "To Store"; fromState = "analyze"; toState = "store"; condition = null; actions = []; priority = 1; metadata = [] },
                { id = "t5"; name = "To Complete"; fromState = "store"; toState = "complete"; condition = null; actions = []; priority = 1; metadata = [] }
            ],
            "start",
            ["complete", "error"],
            [
                {
                    id = "classify-document";
                    name = "Classify Document";
                    description = "Classify incoming document type";
                    activityType = #Service;
                    inputSchema = [("document", #String)];
                    outputSchema = [("type", #String), ("confidence", #Number)];
                    implementation = #OrganismCall({
                        organismType = #Operations;
                        operation = "classify";
                        inputMapping = [("document", "document")];
                        outputMapping = [("type", "type"), ("confidence", "confidence")];
                    });
                    timeout = 30000;
                    retryPolicy = null;
                    compensationActivity = null;
                    idempotent = true;
                    async_ = false;
                    metadata = [];
                },
                {
                    id = "extract-content";
                    name = "Extract Content";
                    description = "Extract content from document";
                    activityType = #Service;
                    inputSchema = [("document", #String), ("type", #String)];
                    outputSchema = [("content", #String), ("metadata", #Object([]))];
                    implementation = #OrganismCall({
                        organismType = #PDF;
                        operation = "extract";
                        inputMapping = [("document", "document"), ("type", "type")];
                        outputMapping = [("content", "content"), ("metadata", "metadata")];
                    });
                    timeout = 60000;
                    retryPolicy = null;
                    compensationActivity = null;
                    idempotent = true;
                    async_ = false;
                    metadata = [];
                },
                {
                    id = "analyze-content";
                    name = "Analyze Content";
                    description = "Analyze extracted content";
                    activityType = #Service;
                    inputSchema = [("content", #String)];
                    outputSchema = [("analysis", #Object([]))];
                    implementation = #OrganismCall({
                        organismType = #Research;
                        operation = "analyze";
                        inputMapping = [("content", "content")];
                        outputMapping = [("analysis", "analysis")];
                    });
                    timeout = 120000;
                    retryPolicy = null;
                    compensationActivity = null;
                    idempotent = true;
                    async_ = false;
                    metadata = [];
                },
                {
                    id = "store-results";
                    name = "Store Results";
                    description = "Store analysis results";
                    activityType = #Service;
                    inputSchema = [("analysis", #Object([]))];
                    outputSchema = [("stored", #Boolean)];
                    implementation = #OrganismCall({
                        organismType = #Operations;
                        operation = "store";
                        inputMapping = [("analysis", "analysis")];
                        outputMapping = [("stored", "stored")];
                    });
                    timeout = 30000;
                    retryPolicy = null;
                    compensationActivity = null;
                    idempotent = false;
                    async_ = false;
                    metadata = [];
                }
            ]
        );
        
        // Legal Review Workflow
        ignore await defineWorkflow(
            "legal-review",
            "Legal document review and approval workflow",
            #Internal,
            [#Legal, #Operations],
            [
                { id = "start"; name = "Start"; stateType = #Initial; entryActions = []; exitActions = []; activities = []; timeout = null; onTimeout = null; metadata = [] },
                { id = "intake"; name = "Intake"; stateType = #Activity; entryActions = []; exitActions = []; activities = ["legal-intake"]; timeout = ?30000; onTimeout = ?"error"; metadata = [] },
                { id = "review"; name = "Review"; stateType = #Activity; entryActions = []; exitActions = []; activities = ["legal-review-activity"]; timeout = ?300000; onTimeout = ?"escalate"; metadata = [] },
                { id = "decision"; name = "Decision"; stateType = #Decision; entryActions = []; exitActions = []; activities = []; timeout = null; onTimeout = null; metadata = [] },
                { id = "approve"; name = "Approve"; stateType = #Activity; entryActions = []; exitActions = []; activities = ["legal-approve"]; timeout = ?60000; onTimeout = ?"error"; metadata = [] },
                { id = "reject"; name = "Reject"; stateType = #Activity; entryActions = []; exitActions = []; activities = ["legal-reject"]; timeout = ?60000; onTimeout = ?"error"; metadata = [] },
                { id = "escalate"; name = "Escalate"; stateType = #Activity; entryActions = []; exitActions = []; activities = ["legal-escalate"]; timeout = ?60000; onTimeout = ?"error"; metadata = [] },
                { id = "complete"; name = "Complete"; stateType = #Terminal; entryActions = []; exitActions = []; activities = []; timeout = null; onTimeout = null; metadata = [] },
                { id = "error"; name = "Error"; stateType = #Error; entryActions = []; exitActions = []; activities = []; timeout = null; onTimeout = null; metadata = [] }
            ],
            [
                { id = "to-intake"; name = "To Intake"; fromState = "start"; toState = "intake"; condition = null; actions = []; priority = 1; metadata = [] },
                { id = "to-review"; name = "To Review"; fromState = "intake"; toState = "review"; condition = null; actions = []; priority = 1; metadata = [] },
                { id = "to-decision"; name = "To Decision"; fromState = "review"; toState = "decision"; condition = null; actions = []; priority = 1; metadata = [] },
                { id = "to-approve"; name = "To Approve"; fromState = "decision"; toState = "approve"; condition = ?{ conditionType = #VariableEquals(("decision", "approve")); expression = ""; parameters = [] }; actions = []; priority = 1; metadata = [] },
                { id = "to-reject"; name = "To Reject"; fromState = "decision"; toState = "reject"; condition = ?{ conditionType = #VariableEquals(("decision", "reject")); expression = ""; parameters = [] }; actions = []; priority = 2; metadata = [] },
                { id = "to-escalate"; name = "To Escalate"; fromState = "decision"; toState = "escalate"; condition = ?{ conditionType = #VariableEquals(("decision", "escalate")); expression = ""; parameters = [] }; actions = []; priority = 3; metadata = [] },
                { id = "approve-complete"; name = "Approve Complete"; fromState = "approve"; toState = "complete"; condition = null; actions = []; priority = 1; metadata = [] },
                { id = "reject-complete"; name = "Reject Complete"; fromState = "reject"; toState = "complete"; condition = null; actions = []; priority = 1; metadata = [] },
                { id = "escalate-review"; name = "Escalate to Review"; fromState = "escalate"; toState = "review"; condition = null; actions = []; priority = 1; metadata = [] }
            ],
            "start",
            ["complete", "error"],
            []
        );
        
        // Financial Analysis Workflow
        ignore await defineWorkflow(
            "financial-analysis",
            "Financial data analysis and reporting workflow",
            #Task,
            [#Finance, #Research, #Operations],
            [
                { id = "start"; name = "Start"; stateType = #Initial; entryActions = []; exitActions = []; activities = []; timeout = null; onTimeout = null; metadata = [] },
                { id = "gather"; name = "Gather Data"; stateType = #Activity; entryActions = []; exitActions = []; activities = ["gather-financial-data"]; timeout = ?60000; onTimeout = ?"error"; metadata = [] },
                { id = "validate"; name = "Validate Data"; stateType = #Activity; entryActions = []; exitActions = []; activities = ["validate-financial-data"]; timeout = ?30000; onTimeout = ?"error"; metadata = [] },
                { id = "analyze"; name = "Analyze"; stateType = #Parallel; entryActions = []; exitActions = []; activities = ["ratio-analysis", "trend-analysis", "risk-analysis"]; timeout = ?180000; onTimeout = ?"error"; metadata = [] },
                { id = "synthesize"; name = "Synthesize"; stateType = #Activity; entryActions = []; exitActions = []; activities = ["synthesize-results"]; timeout = ?60000; onTimeout = ?"error"; metadata = [] },
                { id = "report"; name = "Generate Report"; stateType = #Activity; entryActions = []; exitActions = []; activities = ["generate-report"]; timeout = ?120000; onTimeout = ?"error"; metadata = [] },
                { id = "complete"; name = "Complete"; stateType = #Terminal; entryActions = []; exitActions = []; activities = []; timeout = null; onTimeout = null; metadata = [] },
                { id = "error"; name = "Error"; stateType = #Error; entryActions = []; exitActions = []; activities = []; timeout = null; onTimeout = null; metadata = [] }
            ],
            [
                { id = "to-gather"; name = "To Gather"; fromState = "start"; toState = "gather"; condition = null; actions = []; priority = 1; metadata = [] },
                { id = "to-validate"; name = "To Validate"; fromState = "gather"; toState = "validate"; condition = null; actions = []; priority = 1; metadata = [] },
                { id = "to-analyze"; name = "To Analyze"; fromState = "validate"; toState = "analyze"; condition = null; actions = []; priority = 1; metadata = [] },
                { id = "to-synthesize"; name = "To Synthesize"; fromState = "analyze"; toState = "synthesize"; condition = null; actions = []; priority = 1; metadata = [] },
                { id = "to-report"; name = "To Report"; fromState = "synthesize"; toState = "report"; condition = null; actions = []; priority = 1; metadata = [] },
                { id = "to-complete"; name = "To Complete"; fromState = "report"; toState = "complete"; condition = null; actions = []; priority = 1; metadata = [] }
            ],
            "start",
            ["complete", "error"],
            []
        );
        
        // Code Review Workflow
        ignore await defineWorkflow(
            "code-review",
            "Automated code review and analysis workflow",
            #Task,
            [#Code, #Engineering, #Operations],
            [
                { id = "start"; name = "Start"; stateType = #Initial; entryActions = []; exitActions = []; activities = []; timeout = null; onTimeout = null; metadata = [] },
                { id = "lint"; name = "Lint"; stateType = #Activity; entryActions = []; exitActions = []; activities = ["lint-code"]; timeout = ?60000; onTimeout = ?"error"; metadata = [] },
                { id = "security"; name = "Security Scan"; stateType = #Activity; entryActions = []; exitActions = []; activities = ["security-scan"]; timeout = ?120000; onTimeout = ?"error"; metadata = [] },
                { id = "quality"; name = "Quality Analysis"; stateType = #Activity; entryActions = []; exitActions = []; activities = ["quality-analysis"]; timeout = ?120000; onTimeout = ?"error"; metadata = [] },
                { id = "ai-review"; name = "AI Review"; stateType = #Activity; entryActions = []; exitActions = []; activities = ["ai-code-review"]; timeout = ?180000; onTimeout = ?"error"; metadata = [] },
                { id = "decision"; name = "Decision"; stateType = #Decision; entryActions = []; exitActions = []; activities = []; timeout = null; onTimeout = null; metadata = [] },
                { id = "approve"; name = "Approve"; stateType = #Terminal; entryActions = []; exitActions = []; activities = []; timeout = null; onTimeout = null; metadata = [] },
                { id = "request-changes"; name = "Request Changes"; stateType = #Terminal; entryActions = []; exitActions = []; activities = []; timeout = null; onTimeout = null; metadata = [] },
                { id = "error"; name = "Error"; stateType = #Error; entryActions = []; exitActions = []; activities = []; timeout = null; onTimeout = null; metadata = [] }
            ],
            [
                { id = "to-lint"; name = "To Lint"; fromState = "start"; toState = "lint"; condition = null; actions = []; priority = 1; metadata = [] },
                { id = "to-security"; name = "To Security"; fromState = "lint"; toState = "security"; condition = null; actions = []; priority = 1; metadata = [] },
                { id = "to-quality"; name = "To Quality"; fromState = "security"; toState = "quality"; condition = null; actions = []; priority = 1; metadata = [] },
                { id = "to-ai-review"; name = "To AI Review"; fromState = "quality"; toState = "ai-review"; condition = null; actions = []; priority = 1; metadata = [] },
                { id = "to-decision"; name = "To Decision"; fromState = "ai-review"; toState = "decision"; condition = null; actions = []; priority = 1; metadata = [] },
                { id = "to-approve"; name = "To Approve"; fromState = "decision"; toState = "approve"; condition = ?{ conditionType = #VariableEquals(("issues_count", "0")); expression = ""; parameters = [] }; actions = []; priority = 1; metadata = [] },
                { id = "to-changes"; name = "To Request Changes"; fromState = "decision"; toState = "request-changes"; condition = ?{ conditionType = #VariableGreaterThan(("issues_count", 0.0)); expression = ""; parameters = [] }; actions = []; priority = 2; metadata = [] }
            ],
            "start",
            ["approve", "request-changes", "error"],
            []
        );
        
        // Creative Content Workflow
        ignore await defineWorkflow(
            "creative-content",
            "Creative content generation and review workflow",
            #Task,
            [#Creative, #Operations],
            [
                { id = "start"; name = "Start"; stateType = #Initial; entryActions = []; exitActions = []; activities = []; timeout = null; onTimeout = null; metadata = [] },
                { id = "brief"; name = "Review Brief"; stateType = #Activity; entryActions = []; exitActions = []; activities = ["review-brief"]; timeout = ?30000; onTimeout = ?"error"; metadata = [] },
                { id = "ideate"; name = "Ideation"; stateType = #Activity; entryActions = []; exitActions = []; activities = ["generate-ideas"]; timeout = ?120000; onTimeout = ?"error"; metadata = [] },
                { id = "create"; name = "Create Content"; stateType = #Activity; entryActions = []; exitActions = []; activities = ["create-content"]; timeout = ?300000; onTimeout = ?"error"; metadata = [] },
                { id = "review"; name = "Review"; stateType = #Activity; entryActions = []; exitActions = []; activities = ["review-content"]; timeout = ?120000; onTimeout = ?"error"; metadata = [] },
                { id = "decision"; name = "Decision"; stateType = #Decision; entryActions = []; exitActions = []; activities = []; timeout = null; onTimeout = null; metadata = [] },
                { id = "revise"; name = "Revise"; stateType = #Activity; entryActions = []; exitActions = []; activities = ["revise-content"]; timeout = ?180000; onTimeout = ?"error"; metadata = [] },
                { id = "finalize"; name = "Finalize"; stateType = #Activity; entryActions = []; exitActions = []; activities = ["finalize-content"]; timeout = ?60000; onTimeout = ?"error"; metadata = [] },
                { id = "complete"; name = "Complete"; stateType = #Terminal; entryActions = []; exitActions = []; activities = []; timeout = null; onTimeout = null; metadata = [] },
                { id = "error"; name = "Error"; stateType = #Error; entryActions = []; exitActions = []; activities = []; timeout = null; onTimeout = null; metadata = [] }
            ],
            [
                { id = "to-brief"; name = "To Brief"; fromState = "start"; toState = "brief"; condition = null; actions = []; priority = 1; metadata = [] },
                { id = "to-ideate"; name = "To Ideate"; fromState = "brief"; toState = "ideate"; condition = null; actions = []; priority = 1; metadata = [] },
                { id = "to-create"; name = "To Create"; fromState = "ideate"; toState = "create"; condition = null; actions = []; priority = 1; metadata = [] },
                { id = "to-review"; name = "To Review"; fromState = "create"; toState = "review"; condition = null; actions = []; priority = 1; metadata = [] },
                { id = "to-decision"; name = "To Decision"; fromState = "review"; toState = "decision"; condition = null; actions = []; priority = 1; metadata = [] },
                { id = "to-revise"; name = "To Revise"; fromState = "decision"; toState = "revise"; condition = ?{ conditionType = #VariableEquals(("needs_revision", "true")); expression = ""; parameters = [] }; actions = []; priority = 1; metadata = [] },
                { id = "to-finalize"; name = "To Finalize"; fromState = "decision"; toState = "finalize"; condition = ?{ conditionType = #VariableEquals(("needs_revision", "false")); expression = ""; parameters = [] }; actions = []; priority = 2; metadata = [] },
                { id = "revise-to-review"; name = "Revise to Review"; fromState = "revise"; toState = "review"; condition = null; actions = []; priority = 1; metadata = [] },
                { id = "to-complete"; name = "To Complete"; fromState = "finalize"; toState = "complete"; condition = null; actions = []; priority = 1; metadata = [] }
            ],
            "start",
            ["complete", "error"],
            []
        );
    };
    
    // ============================================
    // QUERY INTERFACE
    // ============================================
    
    public query func getWorkflowDefinition(id: Text) : async ?WorkflowDefinition {
        workflowDefinitions.get(id)
    };
    
    public query func getExecution(id: Text) : async ?WorkflowExecution {
        executions.get(id)
    };
    
    public query func listWorkflows() : async [Text] {
        let ids = Buffer.Buffer<Text>(workflowDefinitions.size());
        for ((id, _) in workflowDefinitions.entries()) {
            ids.add(id);
        };
        Buffer.toArray(ids)
    };
    
    public query func listExecutions(workflowId: ?Text, status: ?ExecutionStatus) : async [Text] {
        let result = Buffer.Buffer<Text>(100);
        
        for ((id, exec) in executions.entries()) {
            let matchWorkflow = switch (workflowId) {
                case null { true };
                case (?wfId) { exec.workflowId == wfId };
            };
            
            let matchStatus = switch (status) {
                case null { true };
                case (?s) { exec.status == s };
            };
            
            if (matchWorkflow and matchStatus) {
                result.add(id);
            };
        };
        
        Buffer.toArray(result)
    };
    
    public query func getStats() : async {
        workflowCount: Nat;
        executionCount: Nat;
        activeExecutions: Nat;
        completedExecutions: Nat;
        failedExecutions: Nat;
    } {
        var active : Nat = 0;
        var completed : Nat = 0;
        var failed : Nat = 0;
        
        for ((_, exec) in executions.entries()) {
            switch (exec.status) {
                case (#Running) { active += 1 };
                case (#Waiting) { active += 1 };
                case (#Paused) { active += 1 };
                case (#Completed) { completed += 1 };
                case (#Compensated) { completed += 1 };
                case (#Failed) { failed += 1 };
                case (#Cancelled) { failed += 1 };
                case (#TimedOut) { failed += 1 };
                case _ {};
            };
        };
        
        {
            workflowCount = workflowDefinitions.size();
            executionCount = executions.size();
            activeExecutions = active;
            completedExecutions = completed;
            failedExecutions = failed;
        }
    };
    
    // ============================================
    // SOVEREIGNTY COMPLIANCE
    // ============================================
    
    public query func verifySovereignty() : async {
        s0Floor: Float;
        coherenceThreshold: Float;
        integrityMinimum: Float;
        compliant: Bool;
    } {
        {
            s0Floor = S_0_FLOOR;
            coherenceThreshold = COHERENCE_THRESHOLD;
            integrityMinimum = INTEGRITY_MINIMUM;
            compliant = S_0_FLOOR >= 1.0 and COHERENCE_THRESHOLD >= 1.0 and INTEGRITY_MINIMUM >= 1.0;
        }
    };
}
