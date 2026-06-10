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
// ╠═══════════════════════════════════════════════════════════════════════════════════════════════════════════╣
// ║                                                                                                           ║
// ║  MODULE: task-workflows.mo                                                                                ║
// ║  PURPOSE: TASK WORKFLOWS — Completing Any Work (Coding, Writing, Analysis, etc.)                         ║
// ║  VERSION: 1.0.0                                                                                           ║
// ║  CREATED: 2026-04-02                                                                                      ║
// ║                                                                                                           ║
// ║  These workflows define how the organism:                                                                 ║
// ║  - Writes code in any language                                                                            ║
// ║  - Creates documents and content                                                                          ║
// ║  - Performs analysis and calculations                                                                     ║
// ║  - Solves problems and makes decisions                                                                    ║
// ║  - Plans and executes projects                                                                            ║
// ║  - Learns and applies new skills                                                                          ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Nat64 "mo:core/Nat64";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Text "mo:core/Text";
import Time "mo:core/Time";
import Option "mo:core/Option";
import Result "mo:core/Result";
import Iter "mo:core/Iter";

module TaskWorkflows {

  // ═══════════════════════════════════════════════════════════════════════════════
  // TASK WORKFLOW REGISTRY
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// All task workflows for completing work
  public type TaskWorkflowId = {
    // CODING WORKFLOWS
    #WriteCode;
    #ReviewCode;
    #RefactorCode;
    #DebugCode;
    #TestCode;
    #DocumentCode;
    #OptimizeCode;
    #SecurityAudit;
    #ArchitectureDesign;
    #APIDesign;
    #DatabaseDesign;
    #SystemIntegration;
    
    // WRITING WORKFLOWS
    #WriteDocument;
    #EditDocument;
    #TranslateDocument;
    #SummarizeDocument;
    #ProofreadDocument;
    #ResearchAndWrite;
    #TechnicalWriting;
    #CreativeWriting;
    #BusinessWriting;
    #AcademicWriting;
    
    // ANALYSIS WORKFLOWS
    #DataAnalysis;
    #StatisticalAnalysis;
    #TrendAnalysis;
    #CompetitiveAnalysis;
    #RiskAnalysis;
    #CostBenefitAnalysis;
    #RequirementsAnalysis;
    #GapAnalysis;
    #RootCauseAnalysis;
    #SWOTAnalysis;
    
    // PROBLEM SOLVING WORKFLOWS
    #ProblemDecomposition;
    #SolutionDesign;
    #DecisionMaking;
    #Brainstorming;
    #Troubleshooting;
    #Optimization;
    #Prioritization;
    #ResourceAllocation;
    
    // PROJECT WORKFLOWS
    #ProjectPlanning;
    #TaskBreakdown;
    #TimelineCreation;
    #MilestoneTracking;
    #RiskManagement;
    #QualityAssurance;
    #DeliverableCreation;
    #StatusReporting;
    
    // COMMUNICATION WORKFLOWS
    #EmailDrafting;
    #PresentationCreation;
    #MeetingPreparation;
    #ProposalWriting;
    #ReportGeneration;
    #FeedbackFormulation;
    #NegotiationPrep;
    #ConflictResolution;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // TASK DEFINITION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type Task = {
    taskId : Nat64;
    workflowId : TaskWorkflowId;
    title : Text;
    description : Text;
    status : TaskStatus;
    priority : TaskPriority;
    createdAt : Int;
    startedAt : ?Int;
    completedAt : ?Int;
    deadline : ?Int;
    creator : Text;
    inputs : [TaskInput];
    outputs : [TaskOutput];
    subtasks : [Nat64];
    dependencies : [Nat64];
    context : TaskContext;
    quality : QualityMetrics;
    reward : TaskReward;
  };
  
  public type TaskStatus = {
    #Pending;
    #InProgress;
    #Blocked : Text;
    #Review;
    #Completed;
    #Failed : Text;
    #Cancelled : Text;
  };
  
  public type TaskPriority = {
    #Critical;
    #High;
    #Medium;
    #Low;
  };
  
  public type TaskInput = {
    inputType : InputType;
    name : Text;
    value : Text;
    required : Bool;
    validated : Bool;
  };
  
  public type InputType = {
    #Text;
    #Code : Text;  // Language
    #Data : Text;  // Format
    #File : Text;  // MIME type
    #Reference : Text;  // Reference type
  };
  
  public type TaskOutput = {
    outputType : OutputType;
    name : Text;
    value : Text;
    qualityScore : Float;
    deliveredAt : ?Int;
  };
  
  public type OutputType = {
    #Code : CodeOutput;
    #Document : DocumentOutput;
    #Analysis : AnalysisOutput;
    #Plan : PlanOutput;
    #Data : DataOutput;
    #Presentation : PresentationOutput;
  };
  
  public type CodeOutput = {
    language : Text;
    lineCount : Nat;
    functions : Nat;
    testCoverage : Float;
    complexity : Float;
  };
  
  public type DocumentOutput = {
    format : Text;
    wordCount : Nat;
    sections : Nat;
    readability : Float;
  };
  
  public type AnalysisOutput = {
    dataPoints : Nat;
    findings : Nat;
    confidence : Float;
    recommendations : Nat;
  };
  
  public type PlanOutput = {
    phases : Nat;
    tasks : Nat;
    duration : Nat;
    resources : Nat;
  };
  
  public type DataOutput = {
    format : Text;
    records : Nat;
    fields : Nat;
    validated : Bool;
  };
  
  public type PresentationOutput = {
    slides : Nat;
    visualizations : Nat;
    duration : Nat;  // Minutes
  };
  
  public type TaskContext = {
    domain : Text;
    constraints : [Text];
    preferences : [(Text, Text)];
    relatedTasks : [Nat64];
    knowledgeRequired : [Text];
  };
  
  public type QualityMetrics = {
    accuracy : Float;
    completeness : Float;
    clarity : Float;
    efficiency : Float;
    creativity : Float;
    overallScore : Float;
  };
  
  public type TaskReward = {
    dopamineReward : Float;
    formaEarned : Float;
    learningValue : Float;
    creatorSatisfaction : Float;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // TASK WORKFLOW DEFINITION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type TaskWorkflow = {
    id : TaskWorkflowId;
    name : Text;
    description : Text;
    category : TaskCategory;
    skillsRequired : [Skill];
    phases : [WorkflowPhase];
    qualityChecks : [QualityCheck];
    estimatedDuration : Nat;
    complexityLevel : ComplexityLevel;
    dopamineRewardPotential : Float;
  };
  
  public type TaskCategory = {
    #Coding;
    #Writing;
    #Analysis;
    #ProblemSolving;
    #Project;
    #Communication;
  };
  
  public type Skill = {
    skillName : Text;
    proficiencyRequired : Float;
    isPrimary : Bool;
  };
  
  public type WorkflowPhase = {
    phaseId : Nat;
    name : Text;
    description : Text;
    steps : [WorkflowStep];
    exitCriteria : [ExitCriterion];
    rollbackPossible : Bool;
  };
  
  public type WorkflowStep = {
    stepId : Nat;
    name : Text;
    action : TaskAction;
    duration : Nat;
    canParallelize : Bool;
    dependencies : [Nat];
  };
  
  public type TaskAction = {
    // THINKING ACTIONS
    #Understand : UnderstandParams;
    #Analyze : AnalyzeParams;
    #Plan : PlanParams;
    #Decide : DecideParams;
    #Evaluate : EvaluateParams;
    
    // CREATION ACTIONS
    #Generate : GenerateParams;
    #Write : WriteParams;
    #Code : CodeParams;
    #Design : DesignParams;
    #Build : BuildParams;
    
    // REFINEMENT ACTIONS
    #Review : ReviewParams;
    #Edit : EditParams;
    #Refactor : RefactorParams;
    #Optimize : OptimizeParams;
    #Test : TestParams;
    
    // VALIDATION ACTIONS
    #Validate : ValidateParams;
    #Verify : VerifyParams;
    #QualityCheck : QualityCheckParams;
    
    // DELIVERY ACTIONS
    #Package : PackageParams;
    #Deliver : DeliverParams;
    #Document : DocumentParams;
  };
  
  public type UnderstandParams = {
    inputType : Text;
    extractRequirements : Bool;
    identifyConstraints : Bool;
    clarifyAmbiguities : Bool;
  };
  
  public type AnalyzeParams = {
    analysisType : Text;
    depth : AnalysisDepth;
    focusAreas : [Text];
  };
  
  public type AnalysisDepth = {
    #Surface;
    #Standard;
    #Deep;
    #Exhaustive;
  };
  
  public type PlanParams = {
    planType : Text;
    horizonSteps : Nat;
    includeContingencies : Bool;
    optimizeFor : Text;
  };
  
  public type DecideParams = {
    decisionType : Text;
    criteria : [Text];
    weightings : [Float];
    riskTolerance : Float;
  };
  
  public type EvaluateParams = {
    evaluationType : Text;
    metrics : [Text];
    benchmarks : [(Text, Float)];
  };
  
  public type GenerateParams = {
    outputType : Text;
    quantity : Nat;
    diversity : Float;
    constraints : [Text];
  };
  
  public type WriteParams = {
    documentType : Text;
    style : WritingStyle;
    tone : WritingTone;
    targetAudience : Text;
    length : LengthSpec;
  };
  
  public type WritingStyle = {
    #Technical;
    #Business;
    #Academic;
    #Creative;
    #Conversational;
    #Formal;
  };
  
  public type WritingTone = {
    #Professional;
    #Friendly;
    #Authoritative;
    #Empathetic;
    #Urgent;
    #Neutral;
  };
  
  public type LengthSpec = {
    #Brief : Nat;      // Word count
    #Standard : Nat;
    #Detailed : Nat;
    #Comprehensive : Nat;
  };
  
  public type CodeParams = {
    language : Text;
    paradigm : CodingParadigm;
    style : CodingStyle;
    includeTests : Bool;
    includeComments : Bool;
    optimizeFor : CodeOptimization;
  };
  
  public type CodingParadigm = {
    #Functional;
    #ObjectOriented;
    #Procedural;
    #Declarative;
    #Mixed;
  };
  
  public type CodingStyle = {
    #Clean;
    #Defensive;
    #Performance;
    #Minimal;
    #Verbose;
  };
  
  public type CodeOptimization = {
    #Readability;
    #Performance;
    #MemoryEfficiency;
    #Security;
    #Maintainability;
  };
  
  public type DesignParams = {
    designType : Text;
    scope : DesignScope;
    constraints : [Text];
    stakeholders : [Text];
  };
  
  public type DesignScope = {
    #Component;
    #Module;
    #System;
    #Architecture;
    #Enterprise;
  };
  
  public type BuildParams = {
    buildType : Text;
    incremental : Bool;
    targetEnvironment : Text;
  };
  
  public type ReviewParams = {
    reviewType : Text;
    thoroughness : Float;
    focusAreas : [Text];
    checklistItems : [Text];
  };
  
  public type EditParams = {
    editType : Text;
    preserveIntent : Bool;
    improvementGoals : [Text];
  };
  
  public type RefactorParams = {
    refactorType : Text;
    preserveBehavior : Bool;
    targetMetrics : [(Text, Float)];
  };
  
  public type OptimizeParams = {
    optimizationType : Text;
    targetMetric : Text;
    constraints : [Text];
    maxIterations : Nat;
  };
  
  public type TestParams = {
    testType : TestType;
    coverage : Float;
    edgeCases : Bool;
    stressTest : Bool;
  };
  
  public type TestType = {
    #Unit;
    #Integration;
    #System;
    #Acceptance;
    #Performance;
    #Security;
  };
  
  public type ValidateParams = {
    validationType : Text;
    criteria : [Text];
    strictness : Float;
  };
  
  public type VerifyParams = {
    verifyAgainst : Text;
    tolerance : Float;
    reportDiscrepancies : Bool;
  };
  
  public type QualityCheckParams = {
    qualityDimensions : [Text];
    thresholds : [(Text, Float)];
    failFast : Bool;
  };
  
  public type PackageParams = {
    packageFormat : Text;
    includeDocumentation : Bool;
    includeDependencies : Bool;
  };
  
  public type DeliverParams = {
    deliveryMethod : Text;
    verifyReceipt : Bool;
    format : Text;
  };
  
  public type DocumentParams = {
    documentationType : DocumentationType;
    detailLevel : DetailLevel;
    includeExamples : Bool;
  };
  
  public type DocumentationType = {
    #UserGuide;
    #TechnicalSpec;
    #APIReference;
    #Tutorial;
    #QuickStart;
    #Changelog;
  };
  
  public type DetailLevel = {
    #Minimal;
    #Standard;
    #Detailed;
    #Exhaustive;
  };
  
  public type ExitCriterion = {
    criterion : Text;
    measurementMethod : Text;
    threshold : Float;
    mandatory : Bool;
  };
  
  public type QualityCheck = {
    checkName : Text;
    checkType : QualityCheckType;
    threshold : Float;
    weight : Float;
  };
  
  public type QualityCheckType = {
    #Correctness;
    #Completeness;
    #Consistency;
    #Clarity;
    #Efficiency;
    #Security;
    #Usability;
    #Maintainability;
  };
  
  public type ComplexityLevel = {
    #Trivial;
    #Simple;
    #Moderate;
    #Complex;
    #VeryComplex;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // WORKFLOW DEFINITIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Write Code Workflow
  public func defineWriteCodeWorkflow() : TaskWorkflow {
    {
      id = #WriteCode;
      name = "Write Code";
      description = "Create new code to implement specified functionality";
      category = #Coding;
      skillsRequired = [
        { skillName = "programming"; proficiencyRequired = 0.7; isPrimary = true },
        { skillName = "problem_solving"; proficiencyRequired = 0.6; isPrimary = true },
        { skillName = "system_design"; proficiencyRequired = 0.5; isPrimary = false }
      ];
      phases = [
        {
          phaseId = 1;
          name = "Understand Requirements";
          description = "Fully understand what needs to be built";
          steps = [
            {
              stepId = 1;
              name = "Parse Requirements";
              action = #Understand({
                inputType = "requirements";
                extractRequirements = true;
                identifyConstraints = true;
                clarifyAmbiguities = true;
              });
              duration = 60;
              canParallelize = false;
              dependencies = [];
            },
            {
              stepId = 2;
              name = "Identify Edge Cases";
              action = #Analyze({
                analysisType = "edge_case";
                depth = #Deep;
                focusAreas = ["inputs", "outputs", "error_conditions"];
              });
              duration = 45;
              canParallelize = false;
              dependencies = [1];
            }
          ];
          exitCriteria = [
            {
              criterion = "requirements_understood";
              measurementMethod = "checklist_complete";
              threshold = 1.0;
              mandatory = true;
            }
          ];
          rollbackPossible = true;
        },
        {
          phaseId = 2;
          name = "Design Solution";
          description = "Design the code structure and approach";
          steps = [
            {
              stepId = 3;
              name = "Design Architecture";
              action = #Design({
                designType = "code_architecture";
                scope = #Module;
                constraints = [];
                stakeholders = [];
              });
              duration = 90;
              canParallelize = false;
              dependencies = [];
            },
            {
              stepId = 4;
              name = "Plan Implementation";
              action = #Plan({
                planType = "implementation";
                horizonSteps = 10;
                includeContingencies = true;
                optimizeFor = "maintainability";
              });
              duration = 45;
              canParallelize = false;
              dependencies = [3];
            }
          ];
          exitCriteria = [
            {
              criterion = "design_approved";
              measurementMethod = "design_review";
              threshold = 0.8;
              mandatory = true;
            }
          ];
          rollbackPossible = true;
        },
        {
          phaseId = 3;
          name = "Write Code";
          description = "Implement the designed solution";
          steps = [
            {
              stepId = 5;
              name = "Write Core Logic";
              action = #Code({
                language = "dynamic";  // Determined by task
                paradigm = #Mixed;
                style = #Clean;
                includeTests = false;
                includeComments = true;
                optimizeFor = #Readability;
              });
              duration = 180;
              canParallelize = false;
              dependencies = [];
            },
            {
              stepId = 6;
              name = "Handle Edge Cases";
              action = #Code({
                language = "dynamic";
                paradigm = #Defensive;
                style = #Defensive;
                includeTests = false;
                includeComments = true;
                optimizeFor = #Security;
              });
              duration = 90;
              canParallelize = false;
              dependencies = [5];
            },
            {
              stepId = 7;
              name = "Write Tests";
              action = #Code({
                language = "dynamic";
                paradigm = #Mixed;
                style = #Clean;
                includeTests = true;
                includeComments = true;
                optimizeFor = #Maintainability;
              });
              duration = 120;
              canParallelize = true;
              dependencies = [5];
            }
          ];
          exitCriteria = [
            {
              criterion = "code_compiles";
              measurementMethod = "compilation";
              threshold = 1.0;
              mandatory = true;
            },
            {
              criterion = "tests_pass";
              measurementMethod = "test_execution";
              threshold = 0.95;
              mandatory = true;
            }
          ];
          rollbackPossible = true;
        },
        {
          phaseId = 4;
          name = "Review and Refine";
          description = "Review code quality and refine";
          steps = [
            {
              stepId = 8;
              name = "Self Review";
              action = #Review({
                reviewType = "code_review";
                thoroughness = 0.9;
                focusAreas = ["logic", "security", "performance", "readability"];
                checklistItems = ["no_bugs", "handles_errors", "follows_style", "documented"];
              });
              duration = 60;
              canParallelize = false;
              dependencies = [];
            },
            {
              stepId = 9;
              name = "Refactor if Needed";
              action = #Refactor({
                refactorType = "cleanup";
                preserveBehavior = true;
                targetMetrics = [("complexity", 10.0), ("duplication", 0.05)];
              });
              duration = 45;
              canParallelize = false;
              dependencies = [8];
            }
          ];
          exitCriteria = [
            {
              criterion = "quality_acceptable";
              measurementMethod = "quality_score";
              threshold = 0.8;
              mandatory = true;
            }
          ];
          rollbackPossible = true;
        },
        {
          phaseId = 5;
          name = "Document and Deliver";
          description = "Document the code and deliver";
          steps = [
            {
              stepId = 10;
              name = "Add Documentation";
              action = #Document({
                documentationType = #TechnicalSpec;
                detailLevel = #Standard;
                includeExamples = true;
              });
              duration = 45;
              canParallelize = true;
              dependencies = [];
            },
            {
              stepId = 11;
              name = "Package Deliverable";
              action = #Package({
                packageFormat = "source";
                includeDocumentation = true;
                includeDependencies = true;
              });
              duration = 15;
              canParallelize = false;
              dependencies = [10];
            },
            {
              stepId = 12;
              name = "Deliver Code";
              action = #Deliver({
                deliveryMethod = "output";
                verifyReceipt = true;
                format = "code";
              });
              duration = 10;
              canParallelize = false;
              dependencies = [11];
            }
          ];
          exitCriteria = [
            {
              criterion = "delivered";
              measurementMethod = "delivery_confirmation";
              threshold = 1.0;
              mandatory = true;
            }
          ];
          rollbackPossible = false;
        }
      ];
      qualityChecks = [
        { checkName = "correctness"; checkType = #Correctness; threshold = 0.95; weight = 0.3 },
        { checkName = "completeness"; checkType = #Completeness; threshold = 0.9; weight = 0.2 },
        { checkName = "clarity"; checkType = #Clarity; threshold = 0.8; weight = 0.15 },
        { checkName = "efficiency"; checkType = #Efficiency; threshold = 0.7; weight = 0.15 },
        { checkName = "maintainability"; checkType = #Maintainability; threshold = 0.8; weight = 0.2 }
      ];
      estimatedDuration = 760;  // ~12.7 minutes for simple code
      complexityLevel = #Moderate;
      dopamineRewardPotential = 0.8;
    }
  };
  
  /// Write Document Workflow
  public func defineWriteDocumentWorkflow() : TaskWorkflow {
    {
      id = #WriteDocument;
      name = "Write Document";
      description = "Create a written document for specified purpose";
      category = #Writing;
      skillsRequired = [
        { skillName = "writing"; proficiencyRequired = 0.7; isPrimary = true },
        { skillName = "research"; proficiencyRequired = 0.5; isPrimary = false },
        { skillName = "organization"; proficiencyRequired = 0.6; isPrimary = false }
      ];
      phases = [
        {
          phaseId = 1;
          name = "Understand Purpose";
          description = "Understand what document is needed and why";
          steps = [
            {
              stepId = 1;
              name = "Analyze Request";
              action = #Understand({
                inputType = "document_request";
                extractRequirements = true;
                identifyConstraints = true;
                clarifyAmbiguities = true;
              });
              duration = 30;
              canParallelize = false;
              dependencies = [];
            },
            {
              stepId = 2;
              name = "Identify Audience";
              action = #Analyze({
                analysisType = "audience";
                depth = #Standard;
                focusAreas = ["knowledge_level", "interests", "needs"];
              });
              duration = 20;
              canParallelize = false;
              dependencies = [1];
            }
          ];
          exitCriteria = [
            {
              criterion = "purpose_clear";
              measurementMethod = "can_state_purpose";
              threshold = 1.0;
              mandatory = true;
            }
          ];
          rollbackPossible = true;
        },
        {
          phaseId = 2;
          name = "Research and Outline";
          description = "Gather information and create structure";
          steps = [
            {
              stepId = 3;
              name = "Gather Information";
              action = #Analyze({
                analysisType = "information_gathering";
                depth = #Deep;
                focusAreas = ["topic", "context", "examples"];
              });
              duration = 60;
              canParallelize = false;
              dependencies = [];
            },
            {
              stepId = 4;
              name = "Create Outline";
              action = #Plan({
                planType = "document_outline";
                horizonSteps = 20;
                includeContingencies = false;
                optimizeFor = "flow";
              });
              duration = 30;
              canParallelize = false;
              dependencies = [3];
            }
          ];
          exitCriteria = [
            {
              criterion = "outline_complete";
              measurementMethod = "outline_sections";
              threshold = 0.9;
              mandatory = true;
            }
          ];
          rollbackPossible = true;
        },
        {
          phaseId = 3;
          name = "Write Content";
          description = "Write the actual document content";
          steps = [
            {
              stepId = 5;
              name = "Write Draft";
              action = #Write({
                documentType = "dynamic";
                style = #Professional;
                tone = #Professional;
                targetAudience = "dynamic";
                length = #Standard(1000);
              });
              duration = 120;
              canParallelize = false;
              dependencies = [];
            },
            {
              stepId = 6;
              name = "Add Supporting Content";
              action = #Generate({
                outputType = "supporting_content";
                quantity = 5;
                diversity = 0.7;
                constraints = [];
              });
              duration = 45;
              canParallelize = true;
              dependencies = [5];
            }
          ];
          exitCriteria = [
            {
              criterion = "draft_complete";
              measurementMethod = "word_count";
              threshold = 0.9;
              mandatory = true;
            }
          ];
          rollbackPossible = true;
        },
        {
          phaseId = 4;
          name = "Edit and Polish";
          description = "Refine the document";
          steps = [
            {
              stepId = 7;
              name = "Self Edit";
              action = #Edit({
                editType = "comprehensive";
                preserveIntent = true;
                improvementGoals = ["clarity", "flow", "conciseness"];
              });
              duration = 45;
              canParallelize = false;
              dependencies = [];
            },
            {
              stepId = 8;
              name = "Proofread";
              action = #Review({
                reviewType = "proofreading";
                thoroughness = 0.95;
                focusAreas = ["grammar", "spelling", "punctuation", "formatting"];
                checklistItems = ["no_typos", "consistent_style", "proper_citations"];
              });
              duration = 30;
              canParallelize = false;
              dependencies = [7];
            }
          ];
          exitCriteria = [
            {
              criterion = "error_free";
              measurementMethod = "error_count";
              threshold = 0.0;
              mandatory = true;
            }
          ];
          rollbackPossible = true;
        },
        {
          phaseId = 5;
          name = "Deliver";
          description = "Format and deliver the document";
          steps = [
            {
              stepId = 9;
              name = "Format Document";
              action = #Package({
                packageFormat = "document";
                includeDocumentation = false;
                includeDependencies = false;
              });
              duration = 15;
              canParallelize = false;
              dependencies = [];
            },
            {
              stepId = 10;
              name = "Deliver Document";
              action = #Deliver({
                deliveryMethod = "output";
                verifyReceipt = true;
                format = "text";
              });
              duration = 5;
              canParallelize = false;
              dependencies = [9];
            }
          ];
          exitCriteria = [
            {
              criterion = "delivered";
              measurementMethod = "delivery_confirmation";
              threshold = 1.0;
              mandatory = true;
            }
          ];
          rollbackPossible = false;
        }
      ];
      qualityChecks = [
        { checkName = "clarity"; checkType = #Clarity; threshold = 0.85; weight = 0.3 },
        { checkName = "completeness"; checkType = #Completeness; threshold = 0.9; weight = 0.25 },
        { checkName = "correctness"; checkType = #Correctness; threshold = 0.95; weight = 0.25 },
        { checkName = "usability"; checkType = #Usability; threshold = 0.8; weight = 0.2 }
      ];
      estimatedDuration = 400;
      complexityLevel = #Moderate;
      dopamineRewardPotential = 0.7;
    }
  };
  
  /// Data Analysis Workflow
  public func defineDataAnalysisWorkflow() : TaskWorkflow {
    {
      id = #DataAnalysis;
      name = "Data Analysis";
      description = "Analyze data to extract insights and patterns";
      category = #Analysis;
      skillsRequired = [
        { skillName = "statistics"; proficiencyRequired = 0.7; isPrimary = true },
        { skillName = "data_manipulation"; proficiencyRequired = 0.7; isPrimary = true },
        { skillName = "visualization"; proficiencyRequired = 0.5; isPrimary = false }
      ];
      phases = [
        {
          phaseId = 1;
          name = "Understand Data";
          description = "Understand the data and analysis objectives";
          steps = [
            {
              stepId = 1;
              name = "Parse Analysis Request";
              action = #Understand({
                inputType = "analysis_request";
                extractRequirements = true;
                identifyConstraints = true;
                clarifyAmbiguities = true;
              });
              duration = 30;
              canParallelize = false;
              dependencies = [];
            },
            {
              stepId = 2;
              name = "Explore Data Structure";
              action = #Analyze({
                analysisType = "exploratory";
                depth = #Standard;
                focusAreas = ["schema", "types", "distributions"];
              });
              duration = 45;
              canParallelize = false;
              dependencies = [1];
            }
          ];
          exitCriteria = [
            {
              criterion = "data_understood";
              measurementMethod = "schema_documented";
              threshold = 1.0;
              mandatory = true;
            }
          ];
          rollbackPossible = true;
        },
        {
          phaseId = 2;
          name = "Clean and Prepare";
          description = "Clean and prepare data for analysis";
          steps = [
            {
              stepId = 3;
              name = "Validate Data Quality";
              action = #Validate({
                validationType = "data_quality";
                criteria = ["completeness", "consistency", "accuracy"];
                strictness = 0.8;
              });
              duration = 30;
              canParallelize = false;
              dependencies = [];
            },
            {
              stepId = 4;
              name = "Clean Data";
              action = #Edit({
                editType = "data_cleaning";
                preserveIntent = true;
                improvementGoals = ["remove_nulls", "fix_formats", "handle_outliers"];
              });
              duration = 45;
              canParallelize = false;
              dependencies = [3];
            },
            {
              stepId = 5;
              name = "Transform Data";
              action = #Build({
                buildType = "data_transformation";
                incremental = false;
                targetEnvironment = "analysis";
              });
              duration = 30;
              canParallelize = false;
              dependencies = [4];
            }
          ];
          exitCriteria = [
            {
              criterion = "data_clean";
              measurementMethod = "quality_score";
              threshold = 0.9;
              mandatory = true;
            }
          ];
          rollbackPossible = true;
        },
        {
          phaseId = 3;
          name = "Analyze";
          description = "Perform the actual analysis";
          steps = [
            {
              stepId = 6;
              name = "Descriptive Analysis";
              action = #Analyze({
                analysisType = "descriptive";
                depth = #Deep;
                focusAreas = ["central_tendency", "dispersion", "distribution"];
              });
              duration = 45;
              canParallelize = false;
              dependencies = [];
            },
            {
              stepId = 7;
              name = "Statistical Analysis";
              action = #Analyze({
                analysisType = "statistical";
                depth = #Deep;
                focusAreas = ["correlations", "significance", "trends"];
              });
              duration = 60;
              canParallelize = true;
              dependencies = [6];
            },
            {
              stepId = 8;
              name = "Pattern Detection";
              action = #Analyze({
                analysisType = "pattern";
                depth = #Deep;
                focusAreas = ["clusters", "anomalies", "sequences"];
              });
              duration = 45;
              canParallelize = true;
              dependencies = [6];
            }
          ];
          exitCriteria = [
            {
              criterion = "analysis_complete";
              measurementMethod = "findings_count";
              threshold = 0.8;
              mandatory = true;
            }
          ];
          rollbackPossible = true;
        },
        {
          phaseId = 4;
          name = "Interpret and Report";
          description = "Interpret findings and create report";
          steps = [
            {
              stepId = 9;
              name = "Interpret Findings";
              action = #Evaluate({
                evaluationType = "interpretation";
                metrics = ["significance", "practical_impact", "confidence"];
                benchmarks = [("significance", 0.05), ("confidence", 0.95)];
              });
              duration = 45;
              canParallelize = false;
              dependencies = [];
            },
            {
              stepId = 10;
              name = "Generate Recommendations";
              action = #Decide({
                decisionType = "recommendations";
                criteria = ["impact", "feasibility", "urgency"];
                weightings = [0.4, 0.3, 0.3];
                riskTolerance = 0.3;
              });
              duration = 30;
              canParallelize = false;
              dependencies = [9];
            },
            {
              stepId = 11;
              name = "Create Report";
              action = #Write({
                documentType = "analysis_report";
                style = #Technical;
                tone = #Professional;
                targetAudience = "stakeholders";
                length = #Detailed(2000);
              });
              duration = 60;
              canParallelize = false;
              dependencies = [10];
            }
          ];
          exitCriteria = [
            {
              criterion = "report_complete";
              measurementMethod = "sections_complete";
              threshold = 1.0;
              mandatory = true;
            }
          ];
          rollbackPossible = true;
        },
        {
          phaseId = 5;
          name = "Deliver";
          description = "Deliver analysis results";
          steps = [
            {
              stepId = 12;
              name = "Package Results";
              action = #Package({
                packageFormat = "analysis_package";
                includeDocumentation = true;
                includeDependencies = true;
              });
              duration = 20;
              canParallelize = false;
              dependencies = [];
            },
            {
              stepId = 13;
              name = "Deliver Results";
              action = #Deliver({
                deliveryMethod = "output";
                verifyReceipt = true;
                format = "analysis";
              });
              duration = 10;
              canParallelize = false;
              dependencies = [12];
            }
          ];
          exitCriteria = [
            {
              criterion = "delivered";
              measurementMethod = "delivery_confirmation";
              threshold = 1.0;
              mandatory = true;
            }
          ];
          rollbackPossible = false;
        }
      ];
      qualityChecks = [
        { checkName = "correctness"; checkType = #Correctness; threshold = 0.95; weight = 0.35 },
        { checkName = "completeness"; checkType = #Completeness; threshold = 0.9; weight = 0.25 },
        { checkName = "clarity"; checkType = #Clarity; threshold = 0.85; weight = 0.2 },
        { checkName = "consistency"; checkType = #Consistency; threshold = 0.9; weight = 0.2 }
      ];
      estimatedDuration = 525;
      complexityLevel = #Complex;
      dopamineRewardPotential = 0.85;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // TASK WORKFLOW REGISTRY
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type TaskWorkflowRegistry = {
    workflows : [TaskWorkflow];
    activeTasks : [Task];
    completedTasks : [Task];
    taskMetrics : TaskMetrics;
    skillProficiencies : [(Text, Float)];
  };
  
  public type TaskMetrics = {
    totalTasksCompleted : Nat;
    totalTasksFailed : Nat;
    avgCompletionTime : Float;
    avgQualityScore : Float;
    totalDopamineEarned : Float;
    totalFormaEarned : Float;
    tasksByCategory : [(TaskCategory, Nat)];
    successRateByComplexity : [(ComplexityLevel, Float)];
  };
  
  public func initTaskWorkflowRegistry() : TaskWorkflowRegistry {
    {
      workflows = [
        defineWriteCodeWorkflow(),
        defineWriteDocumentWorkflow(),
        defineDataAnalysisWorkflow()
      ];
      activeTasks = [];
      completedTasks = [];
      taskMetrics = {
        totalTasksCompleted = 0;
        totalTasksFailed = 0;
        avgCompletionTime = 0.0;
        avgQualityScore = 0.0;
        totalDopamineEarned = 0.0;
        totalFormaEarned = 0.0;
        tasksByCategory = [];
        successRateByComplexity = [];
      };
      skillProficiencies = [
        ("programming", 0.8),
        ("writing", 0.8),
        ("analysis", 0.7),
        ("problem_solving", 0.8),
        ("research", 0.7),
        ("communication", 0.7)
      ];
    }
  };

}
