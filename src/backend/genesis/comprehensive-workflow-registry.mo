/**
 * ╔═══════════════════════════════════════════════════════════════════════════════╗
 * ║              COMPREHENSIVE WORKFLOW REGISTRY — ALL WORKFLOWS                   ║
 * ║        Internal (Self-Improvement) + External (Learning) + Task (Work)         ║
 * ╠═══════════════════════════════════════════════════════════════════════════════╣
 * ║  CONFIDENTIAL - PROPRIETARY - TRADE SECRET                                     ║
 * ║  Copyright © 2024-2026 Alfredo Medina Hernandez. All Rights Reserved.         ║
 * ║                                                                                ║
 * ║  CANONICAL ARCHITECTURE COMPLIANCE:                                            ║
 * ║  ✓ HELIX_ALPHA = 0.004 (learning rate for workflow optimization)              ║
 * ║  ✓ SACESI = Nat64 (all workflow IDs)                                          ║
 * ║  ✓ Jasmine's Law 5-condition (gates ALL workflow execution)                   ║
 * ║  ✓ 22 profit streams (workflows generate yield)                               ║
 * ╚═══════════════════════════════════════════════════════════════════════════════╝
 *
 * THREE WORKFLOW CATEGORIES:
 *
 * 1. INTERNAL WORKFLOWS - How the organism makes itself better
 *    - Self-Assessment, Learning From Mistakes, Coherence Restoration
 *    - Memory Consolidation, Weight Optimization, Creator Alignment
 *
 * 2. EXTERNAL WORKFLOWS - How the organism learns about the world
 *    - Deep Dive Research, Quick Lookup, Fact Checking
 *    - Trend Monitoring, Knowledge Synthesis, Source Validation
 *
 * 3. TASK WORKFLOWS - How the organism does work for enterprises
 *    - Write Code, Write Document, Data Analysis, Design Architecture
 *    - Contract Review, Market Analysis, Process Optimization
 */

import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Float "mo:base/Float";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Nat64 "mo:base/Nat64";
import Principal "mo:base/Principal";
import Text "mo:base/Text";
import Time "mo:base/Time";
import Result "mo:base/Result";
import Blob "mo:base/Blob";

module ComprehensiveWorkflowRegistry {
    
    // ═══════════════════════════════════════════════════════════════════════════
    // CANONICAL CONSTANTS
    // ═══════════════════════════════════════════════════════════════════════════
    
    public let HELIX_ALPHA : Float = 0.004;
    
    // ═══════════════════════════════════════════════════════════════════════════
    // SECTION 1: WORKFLOW CATEGORY TYPES
    // ═══════════════════════════════════════════════════════════════════════════
    
    /// Workflow categories
    public type WorkflowCategory = {
        #Internal;      // Self-improvement
        #External;      // World learning
        #Task;          // Enterprise work
        #Emergency;     // Crisis response
        #Maintenance;   // System upkeep
    };
    
    /// Workflow status
    public type WorkflowStatus = {
        #NotStarted;
        #InProgress;
        #Paused;
        #Completed;
        #Failed;
        #Cancelled;
        #Blocked;
    };
    
    /// Workflow priority
    public type WorkflowPriority = {
        #Critical;      // Must execute immediately
        #High;          // Execute soon
        #Normal;        // Standard queue
        #Low;           // When resources available
        #Background;    // Idle time only
    };
    
    // ═══════════════════════════════════════════════════════════════════════════
    // SECTION 2: MASTER WORKFLOW DEFINITION
    // ═══════════════════════════════════════════════════════════════════════════
    
    /// Complete workflow definition
    public type WorkflowDefinition = {
        workflowId: Nat64;               // SACESI: Nat64
        name: Text;
        description: Text;
        category: WorkflowCategory;
        
        // Structure
        phases: [WorkflowPhase];
        totalSteps: Nat;
        estimatedDuration: Nat;          // In beats
        
        // Requirements
        requiredSkills: [SkillRequirement];
        requiredResources: [ResourceRequirement];
        jasminesLawRequired: Bool;       // Most workflows require this
        
        // Rewards
        dopamineReward: Float;
        tokenReward: TokenReward;
        experienceGain: Float;
        
        // Triggers
        triggerConditions: [TriggerCondition];
        autoStart: Bool;
        
        // Metadata
        version: Text;
        createdAt: Nat64;
        lastModified: Nat64;
    };
    
    /// Workflow phase
    public type WorkflowPhase = {
        phaseId: Nat64;
        name: Text;
        description: Text;
        steps: [WorkflowStep];
        
        // Gating
        entryConditions: [Condition];
        exitConditions: [Condition];
        
        // Timing
        estimatedDuration: Nat;
        timeout: ?Nat;
        
        // On completion
        onComplete: PhaseAction;
        onFail: PhaseAction;
    };
    
    /// Workflow step
    public type WorkflowStep = {
        stepId: Nat64;
        name: Text;
        description: Text;
        
        // Execution
        action: StepAction;
        inputs: [StepInput];
        outputs: [StepOutput];
        
        // Quality
        qualityChecks: [QualityCheck];
        minQualityScore: Float;
        
        // Dependencies
        dependsOn: [Nat64];
        blockedBy: [Nat64];
        
        // Retry
        maxRetries: Nat;
        retryDelay: Nat;
    };
    
    /// Step action types
    public type StepAction = {
        #Compute: ComputeAction;
        #Retrieve: RetrieveAction;
        #Store: StoreAction;
        #Transform: TransformAction;
        #Validate: ValidateAction;
        #Decide: DecideAction;
        #Communicate: CommunicateAction;
        #Wait: WaitAction;
        #Custom: CustomAction;
    };
    
    /// Compute action
    public type ComputeAction = {
        computation: Text;
        parameters: [(Text, Text)];
        resourceIntensity: ResourceIntensity;
    };
    
    /// Resource intensity
    public type ResourceIntensity = {
        #Light;
        #Medium;
        #Heavy;
        #Intensive;
    };
    
    /// Retrieve action
    public type RetrieveAction = {
        source: DataSource;
        query: Text;
        cacheEnabled: Bool;
    };
    
    /// Data sources
    public type DataSource = {
        #Memory;
        #EpisodicBuffer;
        #ExternalAPI;
        #ChildOrganism;
        #BigMind;
        #Cache;
    };
    
    /// Store action
    public type StoreAction = {
        destination: DataDestination;
        format: DataFormat;
        ttl: ?Nat;
    };
    
    /// Data destinations
    public type DataDestination = {
        #Memory;
        #EpisodicBuffer;
        #LongTermMemory;
        #Cache;
        #External;
    };
    
    /// Data formats
    public type DataFormat = {
        #Structured;
        #Unstructured;
        #Binary;
        #Compressed;
    };
    
    /// Transform action
    public type TransformAction = {
        transformType: TransformType;
        parameters: [(Text, Text)];
    };
    
    /// Transform types
    public type TransformType = {
        #Summarize;
        #Expand;
        #Translate;
        #Normalize;
        #Aggregate;
        #Filter;
        #Merge;
        #Split;
    };
    
    /// Validate action
    public type ValidateAction = {
        validationType: ValidationType;
        rules: [ValidationRule];
    };
    
    /// Validation types
    public type ValidationType = {
        #Schema;
        #Business;
        #Quality;
        #Security;
        #Compliance;
    };
    
    /// Validation rule
    public type ValidationRule = {
        ruleId: Text;
        description: Text;
        expression: Text;
        severity: RuleSeverity;
    };
    
    /// Rule severity
    public type RuleSeverity = {
        #Error;
        #Warning;
        #Info;
    };
    
    /// Decide action
    public type DecideAction = {
        decisionType: DecisionType;
        options: [DecisionOption];
        defaultOption: Nat;
    };
    
    /// Decision types
    public type DecisionType = {
        #Binary;
        #MultiChoice;
        #Weighted;
        #RLBased;
    };
    
    /// Decision option
    public type DecisionOption = {
        optionId: Nat;
        description: Text;
        nextStep: ?Nat64;
        probability: ?Float;
    };
    
    /// Communicate action
    public type CommunicateAction = {
        communicationType: CommunicationType;
        target: CommunicationTarget;
        message: Text;
    };
    
    /// Communication types
    public type CommunicationType = {
        #Request;
        #Response;
        #Notification;
        #Query;
        #Broadcast;
    };
    
    /// Communication targets
    public type CommunicationTarget = {
        #User;
        #ChildOrganism: Nat64;
        #BigMind;
        #Council: Nat;
        #External;
    };
    
    /// Wait action
    public type WaitAction = {
        waitType: WaitType;
        duration: ?Nat;
        condition: ?Condition;
    };
    
    /// Wait types
    public type WaitType = {
        #Time;
        #Condition;
        #Event;
        #Resource;
    };
    
    /// Custom action
    public type CustomAction = {
        actionName: Text;
        handler: Text;
        parameters: [(Text, Text)];
    };
    
    /// Step input
    public type StepInput = {
        inputId: Text;
        name: Text;
        type_: InputType;
        required: Bool;
        defaultValue: ?Text;
    };
    
    /// Input types
    public type InputType = {
        #Text;
        #Number;
        #Boolean;
        #Array;
        #Object;
        #Binary;
    };
    
    /// Step output
    public type StepOutput = {
        outputId: Text;
        name: Text;
        type_: InputType;
        description: Text;
    };
    
    /// Quality check
    public type QualityCheck = {
        checkId: Text;
        name: Text;
        checkType: QualityCheckType;
        threshold: Float;
    };
    
    /// Quality check types
    public type QualityCheckType = {
        #Completeness;
        #Accuracy;
        #Consistency;
        #Timeliness;
        #Relevance;
    };
    
    /// Condition
    public type Condition = {
        conditionId: Text;
        expression: Text;
        evaluationType: EvaluationType;
    };
    
    /// Evaluation types
    public type EvaluationType = {
        #Boolean;
        #Threshold;
        #Comparison;
        #Pattern;
    };
    
    /// Phase action
    public type PhaseAction = {
        #Continue;
        #Retry;
        #Skip;
        #Abort;
        #Escalate;
        #Branch: Nat64;
    };
    
    /// Skill requirement
    public type SkillRequirement = {
        skillId: Text;
        skillName: Text;
        minLevel: Float;
    };
    
    /// Resource requirement
    public type ResourceRequirement = {
        resourceType: ResourceType;
        amount: Float;
        unit: Text;
    };
    
    /// Resource types
    public type ResourceType = {
        #Cycles;
        #Memory;
        #Bandwidth;
        #Time;
        #ExternalAPI;
    };
    
    /// Token reward
    public type TokenReward = {
        tokenType: Text;
        amount: Float;
        condition: Text;
    };
    
    /// Trigger condition
    public type TriggerCondition = {
        conditionType: TriggerType;
        parameters: [(Text, Text)];
    };
    
    /// Trigger types
    public type TriggerType = {
        #Schedule;
        #Event;
        #Threshold;
        #Request;
        #Dependency;
    };
    
    // ═══════════════════════════════════════════════════════════════════════════
    // SECTION 3: INTERNAL WORKFLOWS (SELF-IMPROVEMENT)
    // ═══════════════════════════════════════════════════════════════════════════
    
    /// All internal workflow types
    public type InternalWorkflowType = {
        // Self-Assessment
        #SelfDiagnosis;
        #PerformanceAudit;
        #CapabilityAssessment;
        #HealthCheck;
        
        // Learning
        #LearnFromMistake;
        #LearnFromSuccess;
        #SkillAcquisition;
        #KnowledgeIntegration;
        
        // Maintenance
        #MemoryConsolidation;
        #WeightOptimization;
        #CacheCleanup;
        #GarbageCollection;
        
        // Restoration
        #CoherenceRestoration;
        #DriveRebalancing;
        #ShellRecalibration;
        #EmergencyRecovery;
        
        // Alignment
        #CreatorAlignmentCheck;
        #ValueRecalibration;
        #EthicalReview;
        #MissionReaffirmation;
        
        // Growth
        #CapabilityExpansion;
        #DomainExpertiseDeepening;
        #CrossDomainLearning;
        #EmergentBehaviorCultivation;
    };
    
    /// Create self-diagnosis workflow
    public func createSelfDiagnosisWorkflow() : WorkflowDefinition {
        let now = Nat64.fromNat(Int.abs(Time.now()));
        
        {
            workflowId = now;
            name = "Self-Diagnosis";
            description = "Comprehensive self-assessment of organism health and capabilities";
            category = #Internal;
            
            phases = [
                {
                    phaseId = now + 1;
                    name = "Gather Metrics";
                    description = "Collect all internal metrics";
                    steps = [
                        createStep(now + 10, "Check Coherence", #Compute({
                            computation = "calculateGlobalCoherence";
                            parameters = [];
                            resourceIntensity = #Light;
                        })),
                        createStep(now + 11, "Check Shell States", #Compute({
                            computation = "auditAllShells";
                            parameters = [];
                            resourceIntensity = #Medium;
                        })),
                        createStep(now + 12, "Check Memory Utilization", #Compute({
                            computation = "measureMemoryUsage";
                            parameters = [];
                            resourceIntensity = #Light;
                        }))
                    ];
                    entryConditions = [];
                    exitConditions = [{ conditionId = "metrics_collected"; expression = "all_metrics_valid"; evaluationType = #Boolean }];
                    estimatedDuration = 10;
                    timeout = ?100;
                    onComplete = #Continue;
                    onFail = #Retry;
                },
                {
                    phaseId = now + 2;
                    name = "Analyze Results";
                    description = "Analyze collected metrics for issues";
                    steps = [
                        createStep(now + 20, "Identify Anomalies", #Compute({
                            computation = "detectAnomalies";
                            parameters = [];
                            resourceIntensity = #Medium;
                        })),
                        createStep(now + 21, "Calculate Health Score", #Compute({
                            computation = "computeHealthScore";
                            parameters = [];
                            resourceIntensity = #Light;
                        }))
                    ];
                    entryConditions = [{ conditionId = "phase1_complete"; expression = "phase_1_done"; evaluationType = #Boolean }];
                    exitConditions = [{ conditionId = "analysis_complete"; expression = "health_score_calculated"; evaluationType = #Boolean }];
                    estimatedDuration = 15;
                    timeout = ?150;
                    onComplete = #Continue;
                    onFail = #Abort;
                },
                {
                    phaseId = now + 3;
                    name = "Generate Report";
                    description = "Create diagnostic report with recommendations";
                    steps = [
                        createStep(now + 30, "Compile Findings", #Transform({
                            transformType = #Aggregate;
                            parameters = [];
                        })),
                        createStep(now + 31, "Generate Recommendations", #Compute({
                            computation = "generateRecommendations";
                            parameters = [];
                            resourceIntensity = #Medium;
                        })),
                        createStep(now + 32, "Store Report", #Store({
                            destination = #EpisodicBuffer;
                            format = #Structured;
                            ttl = null;
                        }))
                    ];
                    entryConditions = [{ conditionId = "analysis_done"; expression = "phase_2_done"; evaluationType = #Boolean }];
                    exitConditions = [{ conditionId = "report_stored"; expression = "report_in_buffer"; evaluationType = #Boolean }];
                    estimatedDuration = 10;
                    timeout = ?100;
                    onComplete = #Continue;
                    onFail = #Abort;
                }
            ];
            
            totalSteps = 8;
            estimatedDuration = 35;
            
            requiredSkills = [];
            requiredResources = [{ resourceType = #Cycles; amount = 1000000000.0; unit = "cycles" }];
            jasminesLawRequired = true;
            
            dopamineReward = 0.05;
            tokenReward = { tokenType = "GTK"; amount = 0.01; condition = "successful_completion" };
            experienceGain = 0.02;
            
            triggerConditions = [{ conditionType = #Schedule; parameters = [("interval", "1000_beats")] }];
            autoStart = true;
            
            version = "1.0.0";
            createdAt = now;
            lastModified = now;
        }
    };
    
    /// Create memory consolidation workflow (dream cycle)
    public func createMemoryConsolidationWorkflow() : WorkflowDefinition {
        let now = Nat64.fromNat(Int.abs(Time.now()));
        
        {
            workflowId = now + 100;
            name = "Memory Consolidation (Dream Cycle)";
            description = "Consolidate short-term memories into long-term storage with causal binding";
            category = #Internal;
            
            phases = [
                {
                    phaseId = now + 101;
                    name = "Identify Candidates";
                    description = "Find memories ready for consolidation";
                    steps = [
                        createStep(now + 110, "Scan Episodic Buffer", #Retrieve({
                            source = #EpisodicBuffer;
                            query = "unconsolidated_episodes";
                            cacheEnabled = false;
                        })),
                        createStep(now + 111, "Score by Importance", #Compute({
                            computation = "calculateMemoryImportance";
                            parameters = [("use_causal_weight", "true")];
                            resourceIntensity = #Medium;
                        })),
                        createStep(now + 112, "Select Top Candidates", #Transform({
                            transformType = #Filter;
                            parameters = [("threshold", "0.5")];
                        }))
                    ];
                    entryConditions = [];
                    exitConditions = [{ conditionId = "candidates_selected"; expression = "candidate_count > 0"; evaluationType = #Threshold }];
                    estimatedDuration = 20;
                    timeout = ?200;
                    onComplete = #Continue;
                    onFail = #Skip;
                },
                {
                    phaseId = now + 102;
                    name = "Build Causal Chains";
                    description = "Link memories by causal relationships";
                    steps = [
                        createStep(now + 120, "Extract Backward Paths", #Compute({
                            computation = "extractCausalPaths";
                            parameters = [];
                            resourceIntensity = #Heavy;
                        })),
                        createStep(now + 121, "Calculate Causal Weights", #Compute({
                            computation = "computeCausalWeights";
                            parameters = [];
                            resourceIntensity = #Medium;
                        })),
                        createStep(now + 122, "Link Parent Events", #Compute({
                            computation = "linkParentEvents";
                            parameters = [];
                            resourceIntensity = #Medium;
                        }))
                    ];
                    entryConditions = [{ conditionId = "candidates_ready"; expression = "phase_1_done"; evaluationType = #Boolean }];
                    exitConditions = [{ conditionId = "chains_built"; expression = "causal_chains_valid"; evaluationType = #Boolean }];
                    estimatedDuration = 50;
                    timeout = ?500;
                    onComplete = #Continue;
                    onFail = #Retry;
                },
                {
                    phaseId = now + 103;
                    name = "Consolidate to LTM";
                    description = "Move consolidated memories to long-term storage";
                    steps = [
                        createStep(now + 130, "Compress Memories", #Transform({
                            transformType = #Summarize;
                            parameters = [("compression_ratio", "0.7")];
                        })),
                        createStep(now + 131, "Update Hebbian Weights", #Compute({
                            computation = "updateHebbianFromMemories";
                            parameters = [("learning_rate", "0.004")];  // HELIX_ALPHA
                            resourceIntensity = #Heavy;
                        })),
                        createStep(now + 132, "Store in LTM", #Store({
                            destination = #LongTermMemory;
                            format = #Compressed;
                            ttl = null;
                        })),
                        createStep(now + 133, "Clear Episodic Buffer", #Compute({
                            computation = "clearConsolidatedEpisodes";
                            parameters = [];
                            resourceIntensity = #Light;
                        }))
                    ];
                    entryConditions = [{ conditionId = "chains_ready"; expression = "phase_2_done"; evaluationType = #Boolean }];
                    exitConditions = [{ conditionId = "consolidated"; expression = "ltm_updated"; evaluationType = #Boolean }];
                    estimatedDuration = 30;
                    timeout = ?300;
                    onComplete = #Continue;
                    onFail = #Abort;
                },
                {
                    phaseId = now + 104;
                    name = "Generate LGT Tokens";
                    description = "Mint LGT tokens for successful consolidation";
                    steps = [
                        createStep(now + 140, "Calculate Consolidation Value", #Compute({
                            computation = "calculateConsolidationValue";
                            parameters = [];
                            resourceIntensity = #Light;
                        })),
                        createStep(now + 141, "Mint LGT", #Compute({
                            computation = "mintLGTTokens";
                            parameters = [];
                            resourceIntensity = #Light;
                        }))
                    ];
                    entryConditions = [{ conditionId = "ltm_updated"; expression = "phase_3_done"; evaluationType = #Boolean }];
                    exitConditions = [{ conditionId = "tokens_minted"; expression = "lgt_balance_increased"; evaluationType = #Boolean }];
                    estimatedDuration = 5;
                    timeout = ?50;
                    onComplete = #Continue;
                    onFail = #Skip;
                }
            ];
            
            totalSteps = 12;
            estimatedDuration = 105;
            
            requiredSkills = [];
            requiredResources = [{ resourceType = #Cycles; amount = 5000000000.0; unit = "cycles" }];
            jasminesLawRequired = true;
            
            dopamineReward = 0.15;
            tokenReward = { tokenType = "LGT"; amount = 0.1; condition = "successful_consolidation" };
            experienceGain = 0.05;
            
            triggerConditions = [{ conditionType = #Schedule; parameters = [("interval", "50_beats")] }];
            autoStart = true;
            
            version = "1.0.0";
            createdAt = now;
            lastModified = now;
        }
    };
    
    /// Create coherence restoration workflow
    public func createCoherenceRestorationWorkflow() : WorkflowDefinition {
        let now = Nat64.fromNat(Int.abs(Time.now()));
        
        {
            workflowId = now + 200;
            name = "Coherence Restoration";
            description = "Restore global coherence when it drops below threshold";
            category = #Internal;
            
            phases = [
                {
                    phaseId = now + 201;
                    name = "Diagnose Incoherence";
                    description = "Identify sources of coherence breakdown";
                    steps = [
                        createStep(now + 210, "Measure Shell Coherences", #Compute({
                            computation = "measureAllShellCoherences";
                            parameters = [];
                            resourceIntensity = #Medium;
                        })),
                        createStep(now + 211, "Identify Desynchronized Shells", #Compute({
                            computation = "findDesyncedShells";
                            parameters = [("threshold", "0.3")];
                            resourceIntensity = #Light;
                        })),
                        createStep(now + 212, "Check Child Organism Sync", #Communicate({
                            communicationType = #Query;
                            target = #BigMind;
                            message = "get_kuramoto_phases";
                        }))
                    ];
                    entryConditions = [{ conditionId = "low_coherence"; expression = "globalCoherence < 0.6"; evaluationType = #Threshold }];
                    exitConditions = [{ conditionId = "diagnosis_complete"; expression = "sources_identified"; evaluationType = #Boolean }];
                    estimatedDuration = 15;
                    timeout = ?150;
                    onComplete = #Continue;
                    onFail = #Retry;
                },
                {
                    phaseId = now + 202;
                    name = "Apply Corrections";
                    description = "Correct identified coherence issues";
                    steps = [
                        createStep(now + 220, "Reset Desynced Phases", #Compute({
                            computation = "resetShellPhases";
                            parameters = [];
                            resourceIntensity = #Medium;
                        })),
                        createStep(now + 221, "Amplify PAC_SKIP Coupling", #Compute({
                            computation = "boostPACSkipCoupling";
                            parameters = [("boost_factor", "1.5")];
                            resourceIntensity = #Light;
                        })),
                        createStep(now + 222, "Inject Synchronizing Signal", #Compute({
                            computation = "injectSyncSignal";
                            parameters = [("frequency", "20.0")];  // 20 Hz anchor
                            resourceIntensity = #Medium;
                        })),
                        createStep(now + 223, "Notify Child Organisms", #Communicate({
                            communicationType = #Broadcast;
                            target = #BigMind;
                            message = "sync_request";
                        }))
                    ];
                    entryConditions = [{ conditionId = "diagnosis_done"; expression = "phase_1_done"; evaluationType = #Boolean }];
                    exitConditions = [{ conditionId = "corrections_applied"; expression = "all_corrections_done"; evaluationType = #Boolean }];
                    estimatedDuration = 25;
                    timeout = ?250;
                    onComplete = #Continue;
                    onFail = #Retry;
                },
                {
                    phaseId = now + 203;
                    name = "Verify Restoration";
                    description = "Confirm coherence has been restored";
                    steps = [
                        createStep(now + 230, "Wait for Stabilization", #Wait({
                            waitType = #Time;
                            duration = ?10;
                            condition = null;
                        })),
                        createStep(now + 231, "Remeasure Coherence", #Compute({
                            computation = "calculateGlobalCoherence";
                            parameters = [];
                            resourceIntensity = #Light;
                        })),
                        createStep(now + 232, "Validate Threshold", #Validate({
                            validationType = #Quality;
                            rules = [{ ruleId = "coh_threshold"; description = "Coherence above 0.6"; expression = "coherence >= 0.6"; severity = #Error }];
                        }))
                    ];
                    entryConditions = [{ conditionId = "corrections_done"; expression = "phase_2_done"; evaluationType = #Boolean }];
                    exitConditions = [{ conditionId = "coherence_restored"; expression = "globalCoherence >= 0.6"; evaluationType = #Threshold }];
                    estimatedDuration = 15;
                    timeout = ?150;
                    onComplete = #Continue;
                    onFail = #Branch(now + 201);  // Retry from diagnosis
                }
            ];
            
            totalSteps = 10;
            estimatedDuration = 55;
            
            requiredSkills = [];
            requiredResources = [{ resourceType = #Cycles; amount = 2000000000.0; unit = "cycles" }];
            jasminesLawRequired = false;  // Can run even when Jasmine's Law blocked (emergency)
            
            dopamineReward = 0.20;
            tokenReward = { tokenType = "GTK"; amount = 0.05; condition = "coherence_restored" };
            experienceGain = 0.03;
            
            triggerConditions = [{ conditionType = #Threshold; parameters = [("metric", "globalCoherence"), ("below", "0.6")] }];
            autoStart = true;
            
            version = "1.0.0";
            createdAt = now;
            lastModified = now;
        }
    };
    
    // ═══════════════════════════════════════════════════════════════════════════
    // SECTION 4: EXTERNAL WORKFLOWS (WORLD LEARNING)
    // ═══════════════════════════════════════════════════════════════════════════
    
    /// All external workflow types
    public type ExternalWorkflowType = {
        // Research
        #DeepDiveResearch;
        #QuickLookup;
        #FactChecking;
        #SourceValidation;
        
        // Monitoring
        #TrendMonitoring;
        #CompetitorAnalysis;
        #MarketWatching;
        #NewsScanning;
        
        // Synthesis
        #KnowledgeSynthesis;
        #CrossReferencing;
        #PatternDetection;
        #InsightExtraction;
        
        // Data Gathering
        #HTTPOutcall;
        #APIQuery;
        #DataScraping;
        #ChildOrganismQuery;
    };
    
    /// Create deep dive research workflow
    public func createDeepDiveResearchWorkflow() : WorkflowDefinition {
        let now = Nat64.fromNat(Int.abs(Time.now()));
        
        {
            workflowId = now + 300;
            name = "Deep Dive Research";
            description = "Comprehensive research on a topic with source validation";
            category = #External;
            
            phases = [
                {
                    phaseId = now + 301;
                    name = "Define Scope";
                    description = "Clarify research question and scope";
                    steps = [
                        createStep(now + 310, "Parse Research Request", #Compute({
                            computation = "parseResearchRequest";
                            parameters = [];
                            resourceIntensity = #Light;
                        })),
                        createStep(now + 311, "Generate Sub-Questions", #Compute({
                            computation = "generateSubQuestions";
                            parameters = [("max_questions", "10")];
                            resourceIntensity = #Medium;
                        })),
                        createStep(now + 312, "Identify Required Sources", #Compute({
                            computation = "identifySources";
                            parameters = [];
                            resourceIntensity = #Light;
                        }))
                    ];
                    entryConditions = [];
                    exitConditions = [{ conditionId = "scope_defined"; expression = "subquestions_generated"; evaluationType = #Boolean }];
                    estimatedDuration = 10;
                    timeout = ?100;
                    onComplete = #Continue;
                    onFail = #Abort;
                },
                {
                    phaseId = now + 302;
                    name = "Gather Information";
                    description = "Collect information from multiple sources";
                    steps = [
                        createStep(now + 320, "Query Internal Knowledge", #Retrieve({
                            source = #Memory;
                            query = "relevant_knowledge";
                            cacheEnabled = true;
                        })),
                        createStep(now + 321, "Query Child Organisms", #Communicate({
                            communicationType = #Query;
                            target = #BigMind;
                            message = "research_query";
                        })),
                        createStep(now + 322, "HTTP Outcall (if needed)", #Retrieve({
                            source = #ExternalAPI;
                            query = "external_sources";
                            cacheEnabled = true;
                        })),
                        createStep(now + 323, "Aggregate Raw Data", #Transform({
                            transformType = #Aggregate;
                            parameters = [];
                        }))
                    ];
                    entryConditions = [{ conditionId = "scope_ready"; expression = "phase_1_done"; evaluationType = #Boolean }];
                    exitConditions = [{ conditionId = "data_gathered"; expression = "raw_data_available"; evaluationType = #Boolean }];
                    estimatedDuration = 50;
                    timeout = ?500;
                    onComplete = #Continue;
                    onFail = #Retry;
                },
                {
                    phaseId = now + 303;
                    name = "Validate Sources";
                    description = "Check source credibility and accuracy";
                    steps = [
                        createStep(now + 330, "Score Source Credibility", #Compute({
                            computation = "scoreSourceCredibility";
                            parameters = [];
                            resourceIntensity = #Medium;
                        })),
                        createStep(now + 331, "Cross-Reference Facts", #Compute({
                            computation = "crossReferenceFacts";
                            parameters = [("min_sources", "2")];
                            resourceIntensity = #Heavy;
                        })),
                        createStep(now + 332, "Flag Conflicts", #Compute({
                            computation = "detectConflicts";
                            parameters = [];
                            resourceIntensity = #Medium;
                        }))
                    ];
                    entryConditions = [{ conditionId = "data_ready"; expression = "phase_2_done"; evaluationType = #Boolean }];
                    exitConditions = [{ conditionId = "validation_complete"; expression = "sources_validated"; evaluationType = #Boolean }];
                    estimatedDuration = 30;
                    timeout = ?300;
                    onComplete = #Continue;
                    onFail = #Continue;  // Continue even with some validation failures
                },
                {
                    phaseId = now + 304;
                    name = "Synthesize Findings";
                    description = "Combine validated information into coherent findings";
                    steps = [
                        createStep(now + 340, "Extract Key Findings", #Transform({
                            transformType = #Summarize;
                            parameters = [];
                        })),
                        createStep(now + 341, "Build Knowledge Graph", #Compute({
                            computation = "buildKnowledgeGraph";
                            parameters = [];
                            resourceIntensity = #Heavy;
                        })),
                        createStep(now + 342, "Generate Insights", #Compute({
                            computation = "generateInsights";
                            parameters = [];
                            resourceIntensity = #Medium;
                        })),
                        createStep(now + 343, "Create Summary", #Transform({
                            transformType = #Summarize;
                            parameters = [("format", "structured")];
                        }))
                    ];
                    entryConditions = [{ conditionId = "validation_done"; expression = "phase_3_done"; evaluationType = #Boolean }];
                    exitConditions = [{ conditionId = "synthesis_complete"; expression = "findings_generated"; evaluationType = #Boolean }];
                    estimatedDuration = 40;
                    timeout = ?400;
                    onComplete = #Continue;
                    onFail = #Retry;
                },
                {
                    phaseId = now + 305;
                    name = "Store & Share";
                    description = "Store findings and contribute to Big Mind";
                    steps = [
                        createStep(now + 350, "Store in Episodic Buffer", #Store({
                            destination = #EpisodicBuffer;
                            format = #Structured;
                            ttl = null;
                        })),
                        createStep(now + 351, "Contribute to Big Mind", #Communicate({
                            communicationType = #Notification;
                            target = #BigMind;
                            message = "new_research_findings";
                        })),
                        createStep(now + 352, "Update Knowledge Base", #Compute({
                            computation = "updateKnowledgeBase";
                            parameters = [];
                            resourceIntensity = #Medium;
                        }))
                    ];
                    entryConditions = [{ conditionId = "synthesis_done"; expression = "phase_4_done"; evaluationType = #Boolean }];
                    exitConditions = [{ conditionId = "stored"; expression = "findings_stored"; evaluationType = #Boolean }];
                    estimatedDuration = 15;
                    timeout = ?150;
                    onComplete = #Continue;
                    onFail = #Abort;
                }
            ];
            
            totalSteps = 17;
            estimatedDuration = 145;
            
            requiredSkills = [{ skillId = "research"; skillName = "Research"; minLevel = 0.5 }];
            requiredResources = [
                { resourceType = #Cycles; amount = 10000000000.0; unit = "cycles" },
                { resourceType = #ExternalAPI; amount = 1.0; unit = "calls" }
            ];
            jasminesLawRequired = true;
            
            dopamineReward = 0.25;
            tokenReward = { tokenType = "SKT"; amount = 0.1; condition = "quality_research" };
            experienceGain = 0.10;
            
            triggerConditions = [{ conditionType = #Request; parameters = [] }];
            autoStart = false;
            
            version = "1.0.0";
            createdAt = now;
            lastModified = now;
        }
    };
    
    // ═══════════════════════════════════════════════════════════════════════════
    // SECTION 5: TASK WORKFLOWS (ENTERPRISE WORK)
    // ═══════════════════════════════════════════════════════════════════════════
    
    /// All task workflow types
    public type TaskWorkflowType = {
        // Development
        #WriteCode;
        #ReviewCode;
        #DebugCode;
        #DesignArchitecture;
        #WriteTests;
        
        // Documentation
        #WriteDocument;
        #EditDocument;
        #TranslateDocument;
        #SummarizeDocument;
        
        // Analysis
        #DataAnalysis;
        #MarketAnalysis;
        #RiskAnalysis;
        #CompetitiveAnalysis;
        
        // Legal
        #ContractReview;
        #ComplianceCheck;
        #RiskAssessment;
        #PatentSearch;
        
        // Operations
        #ProcessOptimization;
        #SupplyChainAnalysis;
        #ResourcePlanning;
        #ScheduleOptimization;
        
        // Creative
        #ContentCreation;
        #Copywriting;
        #BrandStrategy;
        #CampaignPlanning;
        
        // Strategy
        #StrategicPlanning;
        #ScenarioAnalysis;
        #DecisionSupport;
        #ForecastGeneration;
    };
    
    /// Create write code workflow
    public func createWriteCodeWorkflow() : WorkflowDefinition {
        let now = Nat64.fromNat(Int.abs(Time.now()));
        
        {
            workflowId = now + 400;
            name = "Write Code";
            description = "Full code generation workflow from requirements to delivery";
            category = #Task;
            
            phases = [
                {
                    phaseId = now + 401;
                    name = "Understand Requirements";
                    description = "Parse and validate code requirements";
                    steps = [
                        createStep(now + 410, "Parse Request", #Compute({
                            computation = "parseCodeRequest";
                            parameters = [];
                            resourceIntensity = #Light;
                        })),
                        createStep(now + 411, "Identify Language/Framework", #Compute({
                            computation = "identifyTechStack";
                            parameters = [];
                            resourceIntensity = #Light;
                        })),
                        createStep(now + 412, "Extract Constraints", #Compute({
                            computation = "extractConstraints";
                            parameters = [];
                            resourceIntensity = #Light;
                        })),
                        createStep(now + 413, "Validate Feasibility", #Validate({
                            validationType = #Business;
                            rules = [{ ruleId = "feasible"; description = "Request is feasible"; expression = "feasibility_score > 0.5"; severity = #Error }];
                        }))
                    ];
                    entryConditions = [];
                    exitConditions = [{ conditionId = "requirements_clear"; expression = "requirements_validated"; evaluationType = #Boolean }];
                    estimatedDuration = 15;
                    timeout = ?150;
                    onComplete = #Continue;
                    onFail = #Abort;
                },
                {
                    phaseId = now + 402;
                    name = "Design Solution";
                    description = "Design the code structure and approach";
                    steps = [
                        createStep(now + 420, "Generate Design Options", #Compute({
                            computation = "generateDesignOptions";
                            parameters = [("max_options", "3")];
                            resourceIntensity = #Medium;
                        })),
                        createStep(now + 421, "Evaluate Tradeoffs", #Compute({
                            computation = "evaluateTradeoffs";
                            parameters = [];
                            resourceIntensity = #Medium;
                        })),
                        createStep(now + 422, "Select Best Design", #Decide({
                            decisionType = #Weighted;
                            options = [];
                            defaultOption = 0;
                        })),
                        createStep(now + 423, "Create Pseudocode", #Compute({
                            computation = "generatePseudocode";
                            parameters = [];
                            resourceIntensity = #Medium;
                        }))
                    ];
                    entryConditions = [{ conditionId = "requirements_ready"; expression = "phase_1_done"; evaluationType = #Boolean }];
                    exitConditions = [{ conditionId = "design_complete"; expression = "design_selected"; evaluationType = #Boolean }];
                    estimatedDuration = 25;
                    timeout = ?250;
                    onComplete = #Continue;
                    onFail = #Retry;
                },
                {
                    phaseId = now + 403;
                    name = "Write Code";
                    description = "Generate the actual code";
                    steps = [
                        createStep(now + 430, "Generate Code Structure", #Compute({
                            computation = "generateCodeStructure";
                            parameters = [];
                            resourceIntensity = #Medium;
                        })),
                        createStep(now + 431, "Implement Functions", #Compute({
                            computation = "implementFunctions";
                            parameters = [];
                            resourceIntensity = #Heavy;
                        })),
                        createStep(now + 432, "Add Documentation", #Compute({
                            computation = "addDocumentation";
                            parameters = [("style", "comprehensive")];
                            resourceIntensity = #Light;
                        })),
                        createStep(now + 433, "Format Code", #Transform({
                            transformType = #Normalize;
                            parameters = [("formatter", "standard")];
                        }))
                    ];
                    entryConditions = [{ conditionId = "design_ready"; expression = "phase_2_done"; evaluationType = #Boolean }];
                    exitConditions = [{ conditionId = "code_written"; expression = "code_generated"; evaluationType = #Boolean }];
                    estimatedDuration = 50;
                    timeout = ?500;
                    onComplete = #Continue;
                    onFail = #Retry;
                },
                {
                    phaseId = now + 404;
                    name = "Review & Refine";
                    description = "Self-review and improve the code";
                    steps = [
                        createStep(now + 440, "Static Analysis", #Compute({
                            computation = "runStaticAnalysis";
                            parameters = [];
                            resourceIntensity = #Medium;
                        })),
                        createStep(now + 441, "Security Scan", #Validate({
                            validationType = #Security;
                            rules = [];
                        })),
                        createStep(now + 442, "Performance Check", #Compute({
                            computation = "analyzePerformance";
                            parameters = [];
                            resourceIntensity = #Medium;
                        })),
                        createStep(now + 443, "Apply Improvements", #Compute({
                            computation = "applyImprovements";
                            parameters = [];
                            resourceIntensity = #Medium;
                        }))
                    ];
                    entryConditions = [{ conditionId = "code_ready"; expression = "phase_3_done"; evaluationType = #Boolean }];
                    exitConditions = [{ conditionId = "review_complete"; expression = "quality_score >= 0.8"; evaluationType = #Threshold }];
                    estimatedDuration = 30;
                    timeout = ?300;
                    onComplete = #Continue;
                    onFail = #Branch(now + 403);  // Rewrite if quality too low
                },
                {
                    phaseId = now + 405;
                    name = "Deliver";
                    description = "Package and deliver the code";
                    steps = [
                        createStep(now + 450, "Generate Tests", #Compute({
                            computation = "generateTests";
                            parameters = [];
                            resourceIntensity = #Medium;
                        })),
                        createStep(now + 451, "Create Documentation", #Compute({
                            computation = "createReadme";
                            parameters = [];
                            resourceIntensity = #Light;
                        })),
                        createStep(now + 452, "Package Deliverable", #Transform({
                            transformType = #Aggregate;
                            parameters = [];
                        })),
                        createStep(now + 453, "Store in Episodic Buffer", #Store({
                            destination = #EpisodicBuffer;
                            format = #Structured;
                            ttl = null;
                        }))
                    ];
                    entryConditions = [{ conditionId = "review_done"; expression = "phase_4_done"; evaluationType = #Boolean }];
                    exitConditions = [{ conditionId = "delivered"; expression = "deliverable_ready"; evaluationType = #Boolean }];
                    estimatedDuration = 20;
                    timeout = ?200;
                    onComplete = #Continue;
                    onFail = #Abort;
                }
            ];
            
            totalSteps = 20;
            estimatedDuration = 140;
            
            requiredSkills = [
                { skillId = "coding"; skillName = "Coding"; minLevel = 0.6 },
                { skillId = "architecture"; skillName = "Architecture"; minLevel = 0.4 }
            ];
            requiredResources = [{ resourceType = #Cycles; amount = 15000000000.0; unit = "cycles" }];
            jasminesLawRequired = true;
            
            dopamineReward = 0.30;
            tokenReward = { tokenType = "SKT"; amount = 0.15; condition = "code_quality >= 0.8" };
            experienceGain = 0.12;
            
            triggerConditions = [{ conditionType = #Request; parameters = [] }];
            autoStart = false;
            
            version = "1.0.0";
            createdAt = now;
            lastModified = now;
        }
    };
    
    // ═══════════════════════════════════════════════════════════════════════════
    // SECTION 6: HELPER FUNCTIONS
    // ═══════════════════════════════════════════════════════════════════════════
    
    /// Create a workflow step (helper)
    func createStep(id: Nat64, name: Text, action: StepAction) : WorkflowStep {
        {
            stepId = id;
            name = name;
            description = name;
            action = action;
            inputs = [];
            outputs = [];
            qualityChecks = [];
            minQualityScore = 0.7;
            dependsOn = [];
            blockedBy = [];
            maxRetries = 3;
            retryDelay = 10;
        }
    };
    
    // ═══════════════════════════════════════════════════════════════════════════
    // SECTION 7: WORKFLOW REGISTRY
    // ═══════════════════════════════════════════════════════════════════════════
    
    /// Complete workflow registry
    public type WorkflowRegistry = {
        registryId: Nat64;
        
        // Internal workflows
        internalWorkflows: [WorkflowDefinition];
        
        // External workflows
        externalWorkflows: [WorkflowDefinition];
        
        // Task workflows
        taskWorkflows: [WorkflowDefinition];
        
        // Statistics
        totalWorkflows: Nat;
        totalExecutions: Nat64;
        successRate: Float;
        
        // Metadata
        lastUpdated: Nat64;
    };
    
    /// Initialize the workflow registry with all workflows
    public func initializeWorkflowRegistry() : WorkflowRegistry {
        let now = Nat64.fromNat(Int.abs(Time.now()));
        
        {
            registryId = now;
            
            internalWorkflows = [
                createSelfDiagnosisWorkflow(),
                createMemoryConsolidationWorkflow(),
                createCoherenceRestorationWorkflow()
            ];
            
            externalWorkflows = [
                createDeepDiveResearchWorkflow()
            ];
            
            taskWorkflows = [
                createWriteCodeWorkflow()
            ];
            
            totalWorkflows = 5;
            totalExecutions = 0;
            successRate = 0.0;
            
            lastUpdated = now;
        }
    };
}
