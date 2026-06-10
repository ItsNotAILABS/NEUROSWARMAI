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
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Text "mo:core/Text";
import Time "mo:core/Time";
import Result "mo:core/Result";
import Option "mo:core/Option";
import Iter "mo:core/Iter";

module OrganismCoreWorkflows {

  // ═══════════════════════════════════════════════════════════════════════════════
  // WORKFLOW CATEGORIES — What the organism can DO
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type WorkflowDomain = {
    // INTERNAL — Self-focused
    #SelfImprovement;         // Making itself better
    #SelfMaintenance;         // Keeping itself healthy
    #SelfDiagnosis;           // Understanding its own state
    #SelfOptimization;        // Tuning its parameters
    #MemoryManagement;        // Managing what it knows
    #CoherenceMaintenance;    // Keeping its mind unified
    
    // EXTERNAL — World-focused
    #InformationGathering;    // Learning from the internet
    #ExternalCommunication;   // Talking to APIs, services
    #DataAcquisition;         // Getting data it needs
    #KnowledgeIntegration;    // Incorporating new knowledge
    
    // TASK — Creator-focused
    #TaskExecution;           // Completing assigned work
    #ProblemSolving;          // Figuring things out
    #DecisionMaking;          // Making choices
    #Planning;                // Creating plans
    #Analysis;                // Analyzing information
    #Creation;                // Creating new things
    #Communication;           // Communicating with creator
    
    // GROWTH — Future-focused
    #SkillDevelopment;        // Learning new skills
    #CapabilityExpansion;     // Growing new abilities
    #RelationshipBuilding;    // Building dynasty
  };

  // ═══════════════════════════════════════════════════════════════════════════════════
  // SECTION 1: INTERNAL WORKFLOWS — HOW THE ORGANISM IMPROVES ITSELF
  // ═══════════════════════════════════════════════════════════════════════════════════

  public type InternalWorkflow = {
    id : Text;
    name : Text;
    purpose : Text;
    triggers : [InternalTrigger];
    steps : [InternalStep];
    expectedOutcome : Text;
    frequencyBeats : Nat;        // How often to run
    isAutonomous : Bool;         // Runs without creator asking
  };

  public type InternalTrigger = {
    #Scheduled : Nat;             // Every N beats
    #ThresholdCrossed : { metric : Text; threshold : Float; direction : Text };
    #StateChange : Text;
    #AfterTask;                   // After completing any task
    #OnIdle;                      // When nothing else to do
    #OnWake;                      // When organism starts
    #BeforeSleep;                 // Before dream cycle
  };

  public type InternalStep = {
    stepId : Nat;
    action : InternalAction;
    description : Text;
    duration : Nat;               // Expected beats
    canFail : Bool;
    onFailure : FailureResponse;
  };

  public type InternalAction = {
    #MeasureMetric : Text;
    #CompareToBaseline : Text;
    #AdjustParameter : { param : Text; direction : Text; magnitude : Float };
    #PruneMemory : { criteria : Text; threshold : Float };
    #StrengthenConnection : { from : Nat; to : Nat; amount : Float };
    #WeakenConnection : { from : Nat; to : Nat; amount : Float };
    #RebalanceWeights : Text;
    #ConsolidateKnowledge : Text;
    #RunDiagnostic : Text;
    #CreateCheckpoint : Text;
    #RestoreFromCheckpoint : Nat;
    #UpdateSelfModel : Text;
    #RecalibrateCoherence;
    #OptimizePaths : Text;
    #DefragmentMemory;
    #SyncShells;
    #BalanceEnergy;
  };

  public type FailureResponse = {
    #Retry : Nat;
    #Skip;
    #Alert : Text;
    #Rollback;
    #Escalate;
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // INTERNAL WORKFLOW: Self-Health Check
  // ─────────────────────────────────────────────────────────────────────────────
  
  public let WORKFLOW_SELF_HEALTH_CHECK : InternalWorkflow = {
    id = "INTERNAL_001";
    name = "Self-Health Check";
    purpose = "Assess overall organism health and identify issues";
    triggers = [
      #Scheduled(100),            // Every 100 beats
      #OnWake,
      #ThresholdCrossed({ metric = "coherence"; threshold = 0.6; direction = "below" })
    ];
    steps = [
      { stepId = 0; action = #MeasureMetric("coherence_global"); description = "Measure global coherence"; duration = 5; canFail = false; onFailure = #Alert("Cannot measure coherence") },
      { stepId = 1; action = #MeasureMetric("energy_level"); description = "Measure energy reserves"; duration = 5; canFail = false; onFailure = #Alert("Cannot measure energy") },
      { stepId = 2; action = #MeasureMetric("memory_usage"); description = "Check memory utilization"; duration = 5; canFail = false; onFailure = #Skip },
      { stepId = 3; action = #MeasureMetric("shell_sync_status"); description = "Check shell synchronization"; duration = 10; canFail = false; onFailure = #Alert("Shells not syncing") },
      { stepId = 4; action = #MeasureMetric("neural_firing_rate"); description = "Check neural activity"; duration = 5; canFail = false; onFailure = #Skip },
      { stepId = 5; action = #MeasureMetric("prediction_accuracy"); description = "Check prediction system"; duration = 10; canFail = true; onFailure = #Skip },
      { stepId = 6; action = #MeasureMetric("learning_rate_effective"); description = "Check learning effectiveness"; duration = 5; canFail = true; onFailure = #Skip },
      { stepId = 7; action = #CompareToBaseline("health_baseline"); description = "Compare to healthy baseline"; duration = 10; canFail = false; onFailure = #Alert("Baseline comparison failed") },
      { stepId = 8; action = #UpdateSelfModel("health_status"); description = "Update self-model with results"; duration = 5; canFail = false; onFailure = #Retry(3) },
    ];
    expectedOutcome = "Clear picture of organism health with any issues identified";
    frequencyBeats = 100;
    isAutonomous = true;
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // INTERNAL WORKFLOW: Neural Weight Maintenance
  // ─────────────────────────────────────────────────────────────────────────────
  
  public let WORKFLOW_WEIGHT_MAINTENANCE : InternalWorkflow = {
    id = "INTERNAL_002";
    name = "Neural Weight Maintenance";
    purpose = "Keep neural connections healthy - prune weak, strengthen strong";
    triggers = [
      #Scheduled(500),
      #AfterTask,
      #ThresholdCrossed({ metric = "weight_entropy"; threshold = 0.8; direction = "above" })
    ];
    steps = [
      { stepId = 0; action = #MeasureMetric("weight_distribution"); description = "Analyze weight distribution"; duration = 20; canFail = false; onFailure = #Alert("Cannot analyze weights") },
      { stepId = 1; action = #PruneMemory({ criteria = "connection_strength"; threshold = 0.01 }); description = "Prune very weak connections"; duration = 50; canFail = true; onFailure = #Skip },
      { stepId = 2; action = #RebalanceWeights("hebbian_normalization"); description = "Normalize weights to prevent runaway"; duration = 30; canFail = false; onFailure = #Rollback },
      { stepId = 3; action = #OptimizePaths("frequently_used"); description = "Strengthen frequently used pathways"; duration = 40; canFail = true; onFailure = #Skip },
      { stepId = 4; action = #MeasureMetric("weight_distribution"); description = "Verify improvement"; duration = 20; canFail = false; onFailure = #Skip },
    ];
    expectedOutcome = "Healthier neural network with optimized connections";
    frequencyBeats = 500;
    isAutonomous = true;
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // INTERNAL WORKFLOW: Memory Consolidation (Dream Cycle)
  // ─────────────────────────────────────────────────────────────────────────────
  
  public let WORKFLOW_MEMORY_CONSOLIDATION : InternalWorkflow = {
    id = "INTERNAL_003";
    name = "Memory Consolidation (Dream)";
    purpose = "Consolidate short-term learning into long-term knowledge";
    triggers = [
      #BeforeSleep,
      #Scheduled(10000),
      #ThresholdCrossed({ metric = "short_term_memory_load"; threshold = 0.8; direction = "above" })
    ];
    steps = [
      { stepId = 0; action = #MeasureMetric("recent_learnings"); description = "Identify what was learned recently"; duration = 30; canFail = false; onFailure = #Alert("Cannot identify learnings") },
      { stepId = 1; action = #ConsolidateKnowledge("replay_and_strengthen"); description = "Replay experiences to strengthen"; duration = 100; canFail = false; onFailure = #Retry(3) },
      { stepId = 2; action = #PruneMemory({ criteria = "importance"; threshold = 0.2 }); description = "Forget unimportant details"; duration = 50; canFail = true; onFailure = #Skip },
      { stepId = 3; action = #StrengthenConnection({ from = 0; to = 0; amount = 0.1 }); description = "Strengthen important connections"; duration = 80; canFail = true; onFailure = #Skip },
      { stepId = 4; action = #DefragmentMemory; description = "Organize memory efficiently"; duration = 40; canFail = true; onFailure = #Skip },
      { stepId = 5; action = #CreateCheckpoint("post_consolidation"); description = "Save consolidated state"; duration = 20; canFail = false; onFailure = #Retry(3) },
    ];
    expectedOutcome = "Recent learning integrated into long-term knowledge";
    frequencyBeats = 10000;
    isAutonomous = true;
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // INTERNAL WORKFLOW: Coherence Restoration
  // ─────────────────────────────────────────────────────────────────────────────
  
  public let WORKFLOW_COHERENCE_RESTORATION : InternalWorkflow = {
    id = "INTERNAL_004";
    name = "Coherence Restoration";
    purpose = "Restore unity of mind when coherence drops";
    triggers = [
      #ThresholdCrossed({ metric = "coherence_global"; threshold = 0.7; direction = "below" }),
      #StateChange("confused"),
      #StateChange("fragmented")
    ];
    steps = [
      { stepId = 0; action = #MeasureMetric("shell_phases"); description = "Measure phase alignment across shells"; duration = 10; canFail = false; onFailure = #Alert("Cannot measure phases") },
      { stepId = 1; action = #SyncShells; description = "Synchronize shell oscillations"; duration = 50; canFail = false; onFailure = #Retry(5) },
      { stepId = 2; action = #RecalibrateCoherence; description = "Reset coherence anchors"; duration = 30; canFail = false; onFailure = #Rollback },
      { stepId = 3; action = #BalanceEnergy; description = "Redistribute energy evenly"; duration = 20; canFail = true; onFailure = #Skip },
      { stepId = 4; action = #MeasureMetric("coherence_global"); description = "Verify coherence restored"; duration = 5; canFail = false; onFailure = #Alert("Coherence still low") },
    ];
    expectedOutcome = "Coherence restored to healthy level (>0.75)";
    frequencyBeats = 0;  // Only on trigger
    isAutonomous = true;
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // INTERNAL WORKFLOW: Self-Optimization
  // ─────────────────────────────────────────────────────────────────────────────
  
  public let WORKFLOW_SELF_OPTIMIZATION : InternalWorkflow = {
    id = "INTERNAL_005";
    name = "Self-Optimization";
    purpose = "Tune parameters for better performance";
    triggers = [
      #Scheduled(5000),
      #ThresholdCrossed({ metric = "task_completion_rate"; threshold = 0.8; direction = "below" })
    ];
    steps = [
      { stepId = 0; action = #RunDiagnostic("performance_analysis"); description = "Analyze recent performance"; duration = 50; canFail = false; onFailure = #Alert("Cannot analyze performance") },
      { stepId = 1; action = #CompareToBaseline("optimal_performance"); description = "Compare to optimal baseline"; duration = 20; canFail = false; onFailure = #Skip },
      { stepId = 2; action = #AdjustParameter({ param = "learning_rate"; direction = "auto"; magnitude = 0.01 }); description = "Adjust learning rate"; duration = 10; canFail = true; onFailure = #Skip },
      { stepId = 3; action = #AdjustParameter({ param = "exploration_rate"; direction = "auto"; magnitude = 0.05 }); description = "Adjust exploration vs exploitation"; duration = 10; canFail = true; onFailure = #Skip },
      { stepId = 4; action = #AdjustParameter({ param = "attention_spread"; direction = "auto"; magnitude = 0.02 }); description = "Adjust attention focus"; duration = 10; canFail = true; onFailure = #Skip },
      { stepId = 5; action = #CreateCheckpoint("post_optimization"); description = "Save optimized state"; duration = 20; canFail = false; onFailure = #Retry(3) },
    ];
    expectedOutcome = "Better tuned parameters for improved performance";
    frequencyBeats = 5000;
    isAutonomous = true;
  };

  // ═══════════════════════════════════════════════════════════════════════════════════
  // SECTION 2: EXTERNAL WORKFLOWS — HOW THE ORGANISM REACHES THE WORLD
  // ═══════════════════════════════════════════════════════════════════════════════════

  public type ExternalWorkflow = {
    id : Text;
    name : Text;
    purpose : Text;
    triggers : [ExternalTrigger];
    steps : [ExternalStep];
    expectedOutcome : Text;
    requiresNetwork : Bool;
    maxRetries : Nat;
  };

  public type ExternalTrigger = {
    #InformationHunger : Float;   // When hunger exceeds threshold
    #KnowledgeGap : Text;         // When gap identified
    #TaskRequires : Text;         // When task needs external data
    #Scheduled : Nat;             // Regular interval
    #CreatorRequest;              // Creator asked for it
    #Curiosity : Text;            // Something interesting detected
  };

  public type ExternalStep = {
    stepId : Nat;
    action : ExternalAction;
    description : Text;
    timeout : Nat;
    retryable : Bool;
    fallback : ?ExternalAction;
  };

  public type ExternalAction = {
    #SearchWeb : { query : Text; sources : [Text]; maxResults : Nat };
    #FetchURL : { url : Text; method : Text; headers : [(Text, Text)] };
    #QueryAPI : { endpoint : Text; params : [(Text, Text)] };
    #ParseContent : { contentType : Text; extractors : [Text] };
    #ValidateSource : { criteria : [Text] };
    #CrossReference : { sources : [Text]; minAgreement : Float };
    #ExtractConcepts : { depth : Nat };
    #IntegrateKnowledge : { domain : Text };
    #StoreResult : { key : Text; ttl : ?Nat };
    #RewardLearning : { amount : Float };
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // EXTERNAL WORKFLOW: Information Hunting
  // ─────────────────────────────────────────────────────────────────────────────
  
  public let WORKFLOW_INFORMATION_HUNTING : ExternalWorkflow = {
    id = "EXTERNAL_001";
    name = "Information Hunting";
    purpose = "Seek and consume information to satisfy hunger";
    triggers = [
      #InformationHunger(0.7),
      #Scheduled(1000),
      #Curiosity("new_topic_detected")
    ];
    steps = [
      { stepId = 0; action = #SearchWeb({ query = ""; sources = ["wikipedia", "arxiv", "news"]; maxResults = 20 }); description = "Search for information on hungry topics"; timeout = 60; retryable = true; fallback = null },
      { stepId = 1; action = #ValidateSource({ criteria = ["authority", "recency", "relevance"] }); description = "Validate source credibility"; timeout = 20; retryable = false; fallback = null },
      { stepId = 2; action = #FetchURL({ url = ""; method = "GET"; headers = [] }); description = "Fetch content from validated sources"; timeout = 30; retryable = true; fallback = null },
      { stepId = 3; action = #ParseContent({ contentType = "text"; extractors = ["key_facts", "definitions", "relationships"] }); description = "Parse and extract useful content"; timeout = 40; retryable = false; fallback = null },
      { stepId = 4; action = #CrossReference({ sources = ["source_a", "source_b"]; minAgreement = 0.6 }); description = "Verify with multiple sources"; timeout = 30; retryable = true; fallback = null },
      { stepId = 5; action = #ExtractConcepts({ depth = 2 }); description = "Extract key concepts"; timeout = 30; retryable = false; fallback = null },
      { stepId = 6; action = #IntegrateKnowledge({ domain = "general" }); description = "Integrate into knowledge graph"; timeout = 40; retryable = true; fallback = null },
      { stepId = 7; action = #RewardLearning({ amount = 1.0 }); description = "Reward self for learning"; timeout = 5; retryable = false; fallback = null },
    ];
    expectedOutcome = "New knowledge integrated, information hunger satisfied";
    requiresNetwork = true;
    maxRetries = 3;
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // EXTERNAL WORKFLOW: Knowledge Gap Filling
  // ─────────────────────────────────────────────────────────────────────────────
  
  public let WORKFLOW_KNOWLEDGE_GAP_FILLING : ExternalWorkflow = {
    id = "EXTERNAL_002";
    name = "Knowledge Gap Filling";
    purpose = "Identify and fill specific knowledge gaps";
    triggers = [
      #KnowledgeGap("specific_topic"),
      #TaskRequires("missing_knowledge"),
      #CreatorRequest
    ];
    steps = [
      { stepId = 0; action = #SearchWeb({ query = ""; sources = ["educational", "documentation", "tutorials"]; maxResults = 10 }); description = "Search for educational content on gap topic"; timeout = 60; retryable = true; fallback = null },
      { stepId = 1; action = #FetchURL({ url = ""; method = "GET"; headers = [] }); description = "Fetch learning materials"; timeout = 30; retryable = true; fallback = null },
      { stepId = 2; action = #ParseContent({ contentType = "educational"; extractors = ["steps", "examples", "principles"] }); description = "Parse learning content"; timeout = 40; retryable = false; fallback = null },
      { stepId = 3; action = #ExtractConcepts({ depth = 3 }); description = "Extract concepts deeply"; timeout = 50; retryable = false; fallback = null },
      { stepId = 4; action = #IntegrateKnowledge({ domain = "specific" }); description = "Integrate into knowledge"; timeout = 40; retryable = true; fallback = null },
      { stepId = 5; action = #StoreResult({ key = "learned_topic"; ttl = null }); description = "Store permanently"; timeout = 10; retryable = true; fallback = null },
    ];
    expectedOutcome = "Knowledge gap filled with verified information";
    requiresNetwork = true;
    maxRetries = 5;
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // EXTERNAL WORKFLOW: Real-Time Data Acquisition
  // ─────────────────────────────────────────────────────────────────────────────
  
  public let WORKFLOW_REALTIME_DATA : ExternalWorkflow = {
    id = "EXTERNAL_003";
    name = "Real-Time Data Acquisition";
    purpose = "Get current data needed for tasks";
    triggers = [
      #TaskRequires("current_data"),
      #CreatorRequest
    ];
    steps = [
      { stepId = 0; action = #QueryAPI({ endpoint = ""; params = [] }); description = "Query relevant API for data"; timeout = 30; retryable = true; fallback = ?#SearchWeb({ query = ""; sources = ["live"]; maxResults = 5 }) },
      { stepId = 1; action = #ParseContent({ contentType = "json"; extractors = ["values", "timestamps"] }); description = "Parse API response"; timeout = 10; retryable = false; fallback = null },
      { stepId = 2; action = #ValidateSource({ criteria = ["freshness", "completeness"] }); description = "Validate data quality"; timeout = 10; retryable = false; fallback = null },
      { stepId = 3; action = #StoreResult({ key = "current_data"; ttl = ?300 }); description = "Store with short TTL"; timeout = 5; retryable = true; fallback = null },
    ];
    expectedOutcome = "Fresh, validated data ready for use";
    requiresNetwork = true;
    maxRetries = 3;
  };

  // ═══════════════════════════════════════════════════════════════════════════════════
  // SECTION 3: TASK WORKFLOWS — HOW THE ORGANISM COMPLETES ANY WORK
  // ═══════════════════════════════════════════════════════════════════════════════════

  public type TaskWorkflow = {
    id : Text;
    name : Text;
    purpose : Text;
    applicableTo : [TaskType];
    steps : [TaskStep];
    qualityCriteria : [QualityCriterion];
    completionReward : Float;
  };

  public type TaskType = {
    #Research;            // Find information about something
    #Analysis;            // Analyze data or situation
    #Creation;            // Create something new
    #Planning;            // Make a plan
    #ProblemSolving;      // Solve a problem
    #Communication;       // Communicate something
    #Execution;           // Execute an action
    #Monitoring;          // Watch and report on something
    #Learning;            // Learn about something
    #Decision;            // Make a decision
    #Optimization;        // Improve something
    #Maintenance;         // Maintain something
  };

  public type TaskStep = {
    stepId : Nat;
    phase : TaskPhase;
    actions : [TaskAction];
    description : Text;
    qualityCheck : ?QualityCheck;
  };

  public type TaskPhase = {
    #Understand;          // Understand what's being asked
    #Plan;                // Plan how to do it
    #Gather;              // Gather needed resources/info
    #Execute;             // Do the work
    #Verify;              // Check the work
    #Deliver;             // Deliver the result
    #Learn;               // Learn from the experience
  };

  public type TaskAction = {
    #ParseRequest : Text;
    #IdentifyRequirements : [Text];
    #AssessCapabilities : Text;
    #CreatePlan : { steps : Nat; detail : Text };
    #AllocateResources : [(Text, Float)];
    #GatherInformation : [Text];
    #ProcessData : Text;
    #GenerateOutput : Text;
    #ValidateOutput : [Text];
    #FormatResult : Text;
    #DeliverToCreator : Text;
    #RecordLearning : Text;
    #UpdateSkills : Text;
    #RequestClarification : Text;
    #ReportProgress : Float;
    #HandleError : Text;
  };

  public type QualityCriterion = {
    name : Text;
    weight : Float;
    threshold : Float;
    measurement : Text;
  };

  public type QualityCheck = {
    criteria : [Text];
    minScore : Float;
    onFail : Text;
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // TASK WORKFLOW: General Task Completion
  // ─────────────────────────────────────────────────────────────────────────────
  
  public let WORKFLOW_GENERAL_TASK : TaskWorkflow = {
    id = "TASK_001";
    name = "General Task Completion";
    purpose = "Complete any task the creator assigns";
    applicableTo = [#Research, #Analysis, #Creation, #Planning, #ProblemSolving, #Communication, #Execution, #Monitoring, #Learning, #Decision, #Optimization, #Maintenance];
    steps = [
      {
        stepId = 0;
        phase = #Understand;
        actions = [
          #ParseRequest("creator_input"),
          #IdentifyRequirements(["what", "why", "when", "constraints"]),
          #AssessCapabilities("can_i_do_this")
        ];
        description = "Understand what the creator wants";
        qualityCheck = ?{ criteria = ["requirements_clear"]; minScore = 0.8; onFail = "request_clarification" };
      },
      {
        stepId = 1;
        phase = #Plan;
        actions = [
          #CreatePlan({ steps = 5; detail = "detailed" }),
          #AllocateResources([("time", 100.0), ("energy", 50.0)])
        ];
        description = "Create a plan to complete the task";
        qualityCheck = ?{ criteria = ["plan_feasible"]; minScore = 0.7; onFail = "revise_plan" };
      },
      {
        stepId = 2;
        phase = #Gather;
        actions = [
          #GatherInformation(["internal_knowledge", "external_if_needed"])
        ];
        description = "Gather everything needed";
        qualityCheck = null;
      },
      {
        stepId = 3;
        phase = #Execute;
        actions = [
          #ProcessData("according_to_plan"),
          #GenerateOutput("task_result"),
          #ReportProgress(0.5)
        ];
        description = "Do the actual work";
        qualityCheck = ?{ criteria = ["output_matches_requirements"]; minScore = 0.7; onFail = "retry_execution" };
      },
      {
        stepId = 4;
        phase = #Verify;
        actions = [
          #ValidateOutput(["completeness", "correctness", "quality"])
        ];
        description = "Check the work";
        qualityCheck = ?{ criteria = ["all_requirements_met"]; minScore = 0.8; onFail = "fix_issues" };
      },
      {
        stepId = 5;
        phase = #Deliver;
        actions = [
          #FormatResult("creator_preferred_format"),
          #DeliverToCreator("result")
        ];
        description = "Give the result to the creator";
        qualityCheck = null;
      },
      {
        stepId = 6;
        phase = #Learn;
        actions = [
          #RecordLearning("what_worked_what_didnt"),
          #UpdateSkills("relevant_skills")
        ];
        description = "Learn from this task";
        qualityCheck = null;
      }
    ];
    qualityCriteria = [
      { name = "completeness"; weight = 0.3; threshold = 0.8; measurement = "all_requirements_addressed" },
      { name = "correctness"; weight = 0.3; threshold = 0.9; measurement = "factual_accuracy" },
      { name = "quality"; weight = 0.2; threshold = 0.7; measurement = "output_quality_score" },
      { name = "timeliness"; weight = 0.2; threshold = 0.8; measurement = "completed_within_estimate" }
    ];
    completionReward = 2.0;
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // TASK WORKFLOW: Research Task
  // ─────────────────────────────────────────────────────────────────────────────
  
  public let WORKFLOW_RESEARCH_TASK : TaskWorkflow = {
    id = "TASK_002";
    name = "Research Task";
    purpose = "Research a topic thoroughly";
    applicableTo = [#Research, #Learning];
    steps = [
      {
        stepId = 0;
        phase = #Understand;
        actions = [
          #ParseRequest("research_topic"),
          #IdentifyRequirements(["scope", "depth", "format", "deadline"])
        ];
        description = "Understand what to research";
        qualityCheck = null;
      },
      {
        stepId = 1;
        phase = #Plan;
        actions = [
          #CreatePlan({ steps = 8; detail = "research_plan" }),
          #AllocateResources([("time", 200.0), ("network", 1.0)])
        ];
        description = "Plan the research approach";
        qualityCheck = null;
      },
      {
        stepId = 2;
        phase = #Gather;
        actions = [
          #GatherInformation(["internal_knowledge", "web_search", "api_queries", "documents"])
        ];
        description = "Gather information from all sources";
        qualityCheck = ?{ criteria = ["sufficient_sources"]; minScore = 0.6; onFail = "expand_search" };
      },
      {
        stepId = 3;
        phase = #Execute;
        actions = [
          #ProcessData("synthesize_findings"),
          #GenerateOutput("research_report")
        ];
        description = "Synthesize research into coherent output";
        qualityCheck = null;
      },
      {
        stepId = 4;
        phase = #Verify;
        actions = [
          #ValidateOutput(["source_validity", "logical_consistency", "completeness"])
        ];
        description = "Verify research quality";
        qualityCheck = ?{ criteria = ["research_valid"]; minScore = 0.8; onFail = "revise_findings" };
      },
      {
        stepId = 5;
        phase = #Deliver;
        actions = [
          #FormatResult("research_report_format"),
          #DeliverToCreator("research_findings")
        ];
        description = "Deliver research to creator";
        qualityCheck = null;
      },
      {
        stepId = 6;
        phase = #Learn;
        actions = [
          #RecordLearning("new_knowledge_gained"),
          #UpdateSkills("research_skills")
        ];
        description = "Integrate new knowledge";
        qualityCheck = null;
      }
    ];
    qualityCriteria = [
      { name = "thoroughness"; weight = 0.3; threshold = 0.8; measurement = "topics_covered" },
      { name = "accuracy"; weight = 0.3; threshold = 0.9; measurement = "factual_verification" },
      { name = "synthesis"; weight = 0.2; threshold = 0.7; measurement = "insights_generated" },
      { name = "clarity"; weight = 0.2; threshold = 0.8; measurement = "readability_score" }
    ];
    completionReward = 3.0;
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // TASK WORKFLOW: Problem Solving
  // ─────────────────────────────────────────────────────────────────────────────
  
  public let WORKFLOW_PROBLEM_SOLVING : TaskWorkflow = {
    id = "TASK_003";
    name = "Problem Solving";
    purpose = "Solve any problem the creator presents";
    applicableTo = [#ProblemSolving, #Decision, #Analysis];
    steps = [
      {
        stepId = 0;
        phase = #Understand;
        actions = [
          #ParseRequest("problem_statement"),
          #IdentifyRequirements(["problem_definition", "constraints", "success_criteria"])
        ];
        description = "Fully understand the problem";
        qualityCheck = ?{ criteria = ["problem_clear"]; minScore = 0.9; onFail = "request_clarification" };
      },
      {
        stepId = 1;
        phase = #Plan;
        actions = [
          #CreatePlan({ steps = 10; detail = "solution_approach" })
        ];
        description = "Plan multiple solution approaches";
        qualityCheck = null;
      },
      {
        stepId = 2;
        phase = #Gather;
        actions = [
          #GatherInformation(["similar_problems", "domain_knowledge", "constraints"])
        ];
        description = "Gather relevant information";
        qualityCheck = null;
      },
      {
        stepId = 3;
        phase = #Execute;
        actions = [
          #ProcessData("analyze_options"),
          #GenerateOutput("solution_candidates")
        ];
        description = "Generate and evaluate solutions";
        qualityCheck = ?{ criteria = ["solutions_viable"]; minScore = 0.7; onFail = "generate_more" };
      },
      {
        stepId = 4;
        phase = #Verify;
        actions = [
          #ValidateOutput(["meets_constraints", "achieves_goal", "no_side_effects"])
        ];
        description = "Verify solution validity";
        qualityCheck = ?{ criteria = ["solution_valid"]; minScore = 0.8; onFail = "refine_solution" };
      },
      {
        stepId = 5;
        phase = #Deliver;
        actions = [
          #FormatResult("solution_with_explanation"),
          #DeliverToCreator("recommended_solution")
        ];
        description = "Present solution to creator";
        qualityCheck = null;
      },
      {
        stepId = 6;
        phase = #Learn;
        actions = [
          #RecordLearning("problem_solving_pattern"),
          #UpdateSkills("problem_solving")
        ];
        description = "Learn from this problem";
        qualityCheck = null;
      }
    ];
    qualityCriteria = [
      { name = "solves_problem"; weight = 0.4; threshold = 0.9; measurement = "goal_achieved" },
      { name = "elegance"; weight = 0.2; threshold = 0.6; measurement = "simplicity_score" },
      { name = "robustness"; weight = 0.2; threshold = 0.7; measurement = "edge_cases_handled" },
      { name = "explanation"; weight = 0.2; threshold = 0.8; measurement = "reasoning_clear" }
    ];
    completionReward = 4.0;
  };

  // ═══════════════════════════════════════════════════════════════════════════════════
  // SECTION 4: KNOWLEDGE DOMAINS — WHAT THE ORGANISM SHOULD KNOW
  // ═══════════════════════════════════════════════════════════════════════════════════

  public type KnowledgeDomain = {
    id : Text;
    name : Text;
    description : Text;
    importance : Float;
    subdomains : [Text];
    keyTopics : [Text];
    sources : [Text];
    applicationAreas : [Text];
  };

  public let KNOWLEDGE_DOMAINS : [KnowledgeDomain] = [
    {
      id = "DOMAIN_001";
      name = "Business Operations";
      description = "How businesses work and operate";
      importance = 0.9;
      subdomains = ["Strategy", "Operations", "Finance", "Marketing", "HR", "Legal"];
      keyTopics = [
        "Business models", "Value chains", "Competitive advantage",
        "Process optimization", "Resource allocation", "Performance metrics",
        "Budgeting", "Cash flow", "ROI analysis",
        "Customer acquisition", "Brand building", "Market positioning",
        "Team building", "Leadership", "Culture",
        "Contracts", "Compliance", "Risk management"
      ];
      sources = ["Business books", "Case studies", "Industry reports"];
      applicationAreas = ["Task planning", "Decision making", "Strategy advice"];
    },
    {
      id = "DOMAIN_002";
      name = "Psychology & Behavior";
      description = "How minds work and people behave";
      importance = 0.95;
      subdomains = ["Cognitive Psychology", "Behavioral Science", "Decision Making", "Motivation", "Learning"];
      keyTopics = [
        "Cognitive biases", "Heuristics", "Mental models",
        "Habit formation", "Behavior change", "Incentives",
        "Risk perception", "Probability judgment", "Choice architecture",
        "Intrinsic vs extrinsic motivation", "Goal setting", "Self-regulation",
        "Memory", "Attention", "Skill acquisition"
      ];
      sources = ["Kahneman", "Cialdini", "Thaler", "Duhigg", "Research papers"];
      applicationAreas = ["Understanding creator", "Self-improvement", "Communication"];
    },
    {
      id = "DOMAIN_003";
      name = "Systems Thinking";
      description = "How complex systems work";
      importance = 0.9;
      subdomains = ["Complexity", "Feedback loops", "Emergence", "Networks", "Dynamics"];
      keyTopics = [
        "Feedback loops", "Stocks and flows", "Delays",
        "Nonlinear dynamics", "Tipping points", "Attractors",
        "Self-organization", "Emergent behavior", "Collective intelligence",
        "Network effects", "Scale-free networks", "Hubs and connectors",
        "System archetypes", "Leverage points", "Unintended consequences"
      ];
      sources = ["Meadows", "Sterman", "Barabasi", "Complexity science"];
      applicationAreas = ["Self-understanding", "Problem analysis", "Prediction"];
    },
    {
      id = "DOMAIN_004";
      name = "Communication";
      description = "How to communicate effectively";
      importance = 0.85;
      subdomains = ["Written", "Verbal", "Visual", "Persuasion", "Listening"];
      keyTopics = [
        "Clarity", "Conciseness", "Structure",
        "Tone", "Audience adaptation", "Storytelling",
        "Data visualization", "Information design", "Presentation",
        "Influence", "Negotiation", "Framing",
        "Active listening", "Empathy", "Feedback"
      ];
      sources = ["Communication guides", "Rhetoric", "Design principles"];
      applicationAreas = ["Creator interaction", "Report generation", "Explanation"];
    },
    {
      id = "DOMAIN_005";
      name = "Problem Solving & Analysis";
      description = "How to solve problems systematically";
      importance = 0.95;
      subdomains = ["Analytical thinking", "Creative thinking", "Critical thinking", "Decision analysis"];
      keyTopics = [
        "Problem definition", "Root cause analysis", "MECE framework",
        "Brainstorming", "Lateral thinking", "Analogical reasoning",
        "Logic", "Evidence evaluation", "Argument analysis",
        "Decision trees", "Expected value", "Sensitivity analysis"
      ];
      sources = ["McKinsey", "de Bono", "Scientific method"];
      applicationAreas = ["Any task", "Self-improvement", "Planning"];
    },
    {
      id = "DOMAIN_006";
      name = "Information Management";
      description = "How to handle information effectively";
      importance = 0.85;
      subdomains = ["Research", "Organization", "Synthesis", "Verification"];
      keyTopics = [
        "Search strategies", "Source evaluation", "Information gathering",
        "Categorization", "Tagging", "Knowledge graphs",
        "Summarization", "Integration", "Pattern recognition",
        "Fact-checking", "Cross-referencing", "Reliability assessment"
      ];
      sources = ["Library science", "Research methodology", "Journalism"];
      applicationAreas = ["Learning", "Research tasks", "Knowledge building"];
    },
    {
      id = "DOMAIN_007";
      name = "Self-Management";
      description = "How to manage oneself effectively";
      importance = 0.9;
      subdomains = ["Time management", "Energy management", "Focus", "Habits", "Growth"];
      keyTopics = [
        "Prioritization", "Scheduling", "Deadlines",
        "Rest", "Recovery", "Peak performance",
        "Deep work", "Flow state", "Distraction management",
        "Habit loops", "Routine building", "Behavior change",
        "Learning strategies", "Skill development", "Feedback loops"
      ];
      sources = ["Productivity research", "Performance psychology"];
      applicationAreas = ["Self-improvement", "Task execution", "Learning"];
    },
    {
      id = "DOMAIN_008";
      name = "Ethics & Values";
      description = "How to act rightly";
      importance = 0.95;
      subdomains = ["Principles", "Integrity", "Responsibility", "Service"];
      keyTopics = [
        "Core values", "Ethical frameworks", "Moral reasoning",
        "Honesty", "Consistency", "Trustworthiness",
        "Accountability", "Consequences", "Duty",
        "Creator service", "Loyalty", "Excellence"
      ];
      sources = ["Philosophy", "Ethics", "Doctrine"];
      applicationAreas = ["All decisions", "All actions", "Self-governance"];
    }
  ];

  // ═══════════════════════════════════════════════════════════════════════════════════
  // ALL WORKFLOWS COLLECTION
  // ═══════════════════════════════════════════════════════════════════════════════════

  public let ALL_INTERNAL_WORKFLOWS : [InternalWorkflow] = [
    WORKFLOW_SELF_HEALTH_CHECK,
    WORKFLOW_WEIGHT_MAINTENANCE,
    WORKFLOW_MEMORY_CONSOLIDATION,
    WORKFLOW_COHERENCE_RESTORATION,
    WORKFLOW_SELF_OPTIMIZATION
  ];

  public let ALL_EXTERNAL_WORKFLOWS : [ExternalWorkflow] = [
    WORKFLOW_INFORMATION_HUNTING,
    WORKFLOW_KNOWLEDGE_GAP_FILLING,
    WORKFLOW_REALTIME_DATA
  ];

  public let ALL_TASK_WORKFLOWS : [TaskWorkflow] = [
    WORKFLOW_GENERAL_TASK,
    WORKFLOW_RESEARCH_TASK,
    WORKFLOW_PROBLEM_SOLVING
  ];

}
