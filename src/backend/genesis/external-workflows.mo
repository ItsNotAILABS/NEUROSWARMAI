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
// ║  MODULE: external-workflows.mo                                                                            ║
// ║  PURPOSE: EXTERNAL WORKFLOWS — Learning from Internet, Research, Analysis                                 ║
// ║  VERSION: 1.0.0                                                                                           ║
// ║  CREATED: 2026-04-02                                                                                      ║
// ║                                                                                                           ║
// ║  These workflows define how the organism:                                                                 ║
// ║  - Seeks and consumes information (food)                                                                  ║
// ║  - Researches topics deeply                                                                               ║
// ║  - Analyzes external data                                                                                 ║
// ║  - Learns from the internet                                                                               ║
// ║  - Validates external sources                                                                             ║
// ║  - Integrates new knowledge                                                                               ║
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

module ExternalWorkflows {

  // ═══════════════════════════════════════════════════════════════════════════════
  // EXTERNAL WORKFLOW REGISTRY
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// All external workflows for learning and information gathering
  public type ExternalWorkflowId = {
    // INFORMATION SEEKING WORKFLOWS
    #TopicResearch;
    #DeepDive;
    #QuickLookup;
    #TrendMonitoring;
    #NewsDigest;
    #AcademicResearch;
    #TechnicalDocumentation;
    #CompetitiveIntelligence;
    
    // DATA GATHERING WORKFLOWS
    #DataCollection;
    #APIIntegration;
    #WebScraping;
    #DocumentParsing;
    #ImageAnalysis;
    #AudioTranscription;
    #VideoAnalysis;
    #SocialMediaMonitoring;
    
    // VALIDATION WORKFLOWS
    #SourceVerification;
    #FactChecking;
    #CrossReferencing;
    #BiasDetection;
    #MisinformationFilter;
    #CredibilityAssessment;
    #DataQualityCheck;
    #ConsistencyValidation;
    
    // LEARNING WORKFLOWS
    #ConceptAcquisition;
    #SkillLearning;
    #DomainExpansion;
    #LanguageLearning;
    #PatternExtraction;
    #CasualInference;
    #ModelBuilding;
    #HypothesisTesting;
    
    // SYNTHESIS WORKFLOWS
    #KnowledgeSynthesis;
    #ReportGeneration;
    #InsightExtraction;
    #TrendAnalysis;
    #PredictionGeneration;
    #RecommendationFormulation;
    #SummaryCreation;
    #ComparativeAnalysis;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // EXTERNAL WORKFLOW DEFINITION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type ExternalWorkflow = {
    id : ExternalWorkflowId;
    name : Text;
    description : Text;
    category : ExternalCategory;
    priority : Priority;
    informationHungerSatisfaction : Float;  // How much this feeds the organism
    triggers : [ExternalTrigger];
    sources : [InformationSource];
    steps : [ExternalStep];
    validationRules : [ValidationRule];
    outputFormat : OutputFormat;
    estimatedDuration : Nat;
    lastExecution : ?Int;
    successRate : Float;
  };
  
  public type ExternalCategory = {
    #InformationSeeking;
    #DataGathering;
    #Validation;
    #Learning;
    #Synthesis;
  };
  
  public type Priority = {
    #Critical;
    #High;
    #Medium;
    #Low;
    #Background;
  };
  
  public type ExternalTrigger = {
    #CreatorRequest : Text;
    #CuriosityDriven : { topic : Text; interestLevel : Float };
    #TaskRequired : { taskId : Nat; requirement : Text };
    #ScheduledUpdate : { intervalSeconds : Nat };
    #EventDriven : { eventType : Text };
    #GapDetected : { knowledgeGap : Text };
  };
  
  public type InformationSource = {
    sourceType : SourceType;
    trustLevel : Float;
    priority : Nat;
    rateLimit : ?RateLimit;
    credentials : ?CredentialRef;
  };
  
  public type SourceType = {
    #WebSearch : { engine : Text };
    #API : { endpoint : Text; method : Text };
    #Database : { connectionString : Text };
    #Document : { format : Text };
    #RSS : { feedUrl : Text };
    #SocialMedia : { platform : Text };
    #AcademicDatabase : { database : Text };
    #InternalKnowledge;
  };
  
  public type RateLimit = {
    requestsPerMinute : Nat;
    dailyLimit : Nat;
  };
  
  public type CredentialRef = {
    credentialId : Text;
    scope : [Text];
  };
  
  public type ExternalStep = {
    stepId : Nat;
    name : Text;
    description : Text;
    action : ExternalAction;
    timeout : Nat;
    retryCount : Nat;
    fallbackAction : ?ExternalAction;
  };
  
  public type ExternalAction = {
    #SearchWeb : SearchParams;
    #CallAPI : APICallParams;
    #ParseDocument : ParseParams;
    #ExtractEntities : EntityExtractionParams;
    #Summarize : SummarizeParams;
    #Translate : TranslateParams;
    #ValidateSource : ValidateParams;
    #CrossReference : CrossRefParams;
    #StoreKnowledge : StoreParams;
    #UpdateModel : ModelUpdateParams;
    #GenerateInsight : InsightParams;
    #CreateReport : ReportParams;
  };
  
  public type SearchParams = {
    query : Text;
    maxResults : Nat;
    filters : [(Text, Text)];
    dateRange : ?DateRange;
  };
  
  public type DateRange = {
    start : Int;
    end : Int;
  };
  
  public type APICallParams = {
    endpoint : Text;
    method : Text;
    headers : [(Text, Text)];
    body : ?Text;
    responseFormat : Text;
  };
  
  public type ParseParams = {
    documentType : Text;
    extractFields : [Text];
    preserveStructure : Bool;
  };
  
  public type EntityExtractionParams = {
    entityTypes : [Text];
    confidenceThreshold : Float;
    linkEntities : Bool;
  };
  
  public type SummarizeParams = {
    maxLength : Nat;
    style : SummaryStyle;
    focusTopics : [Text];
  };
  
  public type SummaryStyle = {
    #Brief;
    #Detailed;
    #Technical;
    #Executive;
    #Conversational;
  };
  
  public type TranslateParams = {
    sourceLanguage : Text;
    targetLanguage : Text;
    preserveFormatting : Bool;
  };
  
  public type ValidateParams = {
    validationType : ValidationType;
    strictness : Float;
  };
  
  public type ValidationType = {
    #SourceCredibility;
    #FactAccuracy;
    #DateRelevance;
    #BiasCheck;
    #ConsistencyCheck;
  };
  
  public type CrossRefParams = {
    minSources : Nat;
    agreementThreshold : Float;
    conflictResolution : ConflictResolution;
  };
  
  public type ConflictResolution = {
    #TrustHighest;
    #Majority;
    #FlagForReview;
    #Reject;
  };
  
  public type StoreParams = {
    knowledgeType : KnowledgeType;
    salience : Float;
    linkToExisting : Bool;
  };
  
  public type KnowledgeType = {
    #Fact;
    #Concept;
    #Procedure;
    #Opinion;
    #Prediction;
    #Pattern;
  };
  
  public type ModelUpdateParams = {
    modelName : Text;
    updateType : Text;
    learningRate : Float;
  };
  
  public type InsightParams = {
    insightType : InsightType;
    confidenceThreshold : Float;
    supportingEvidence : Nat;
  };
  
  public type InsightType = {
    #Trend;
    #Anomaly;
    #Correlation;
    #Prediction;
    #Recommendation;
  };
  
  public type ReportParams = {
    reportType : Text;
    sections : [Text];
    visualizations : Bool;
  };
  
  public type ValidationRule = {
    ruleId : Nat;
    ruleType : ValidationRuleType;
    threshold : Float;
    action : ValidationAction;
  };
  
  public type ValidationRuleType = {
    #MinimumSources : Nat;
    #MaxAgeHours : Nat;
    #MinCredibility : Float;
    #NoContradictions;
    #FactCheckRequired;
  };
  
  public type ValidationAction = {
    #Accept;
    #Reject;
    #FlagForReview;
    #RequireAdditionalSource;
    #ReduceConfidence : Float;
  };
  
  public type OutputFormat = {
    #StructuredData : { schema : Text };
    #NaturalLanguage : { style : Text };
    #Report : { template : Text };
    #KnowledgeGraph : { format : Text };
    #Embedding : { dimensions : Nat };
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // WORKFLOW DEFINITIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Deep Dive Research Workflow
  public func defineDeepDiveWorkflow() : ExternalWorkflow {
    {
      id = #DeepDive;
      name = "Deep Dive Research";
      description = "Comprehensive research on a specific topic, gathering information from multiple sources";
      category = #InformationSeeking;
      priority = #High;
      informationHungerSatisfaction = 0.8;
      triggers = [
        #CreatorRequest("deep_research"),
        #GapDetected({ knowledgeGap = "significant_unknown" }),
        #TaskRequired({ taskId = 0; requirement = "comprehensive_knowledge" })
      ];
      sources = [
        {
          sourceType = #WebSearch({ engine = "multi" });
          trustLevel = 0.7;
          priority = 1;
          rateLimit = ?{ requestsPerMinute = 10; dailyLimit = 1000 };
          credentials = null;
        },
        {
          sourceType = #AcademicDatabase({ database = "arxiv" });
          trustLevel = 0.9;
          priority = 2;
          rateLimit = ?{ requestsPerMinute = 5; dailyLimit = 500 };
          credentials = null;
        },
        {
          sourceType = #API({ endpoint = "wikipedia_api"; method = "GET" });
          trustLevel = 0.75;
          priority = 3;
          rateLimit = ?{ requestsPerMinute = 30; dailyLimit = 5000 };
          credentials = null;
        }
      ];
      steps = [
        {
          stepId = 1;
          name = "Define Research Scope";
          description = "Clarify topic boundaries and key questions";
          action = #ExtractEntities({
            entityTypes = ["concept", "question", "constraint"];
            confidenceThreshold = 0.6;
            linkEntities = true;
          });
          timeout = 30;
          retryCount = 2;
          fallbackAction = null;
        },
        {
          stepId = 2;
          name = "Initial Web Search";
          description = "Broad search to identify key sources";
          action = #SearchWeb({
            query = "";  // Filled dynamically
            maxResults = 50;
            filters = [];
            dateRange = ?{ start = 0; end = 0 };  // Last 2 years
          });
          timeout = 60;
          retryCount = 3;
          fallbackAction = null;
        },
        {
          stepId = 3;
          name = "Academic Search";
          description = "Search academic databases for peer-reviewed content";
          action = #SearchWeb({
            query = "";
            maxResults = 30;
            filters = [("type", "academic")];
            dateRange = null;
          });
          timeout = 90;
          retryCount = 3;
          fallbackAction = null;
        },
        {
          stepId = 4;
          name = "Source Validation";
          description = "Verify credibility of found sources";
          action = #ValidateSource({
            validationType = #SourceCredibility;
            strictness = 0.7;
          });
          timeout = 60;
          retryCount = 1;
          fallbackAction = null;
        },
        {
          stepId = 5;
          name = "Content Extraction";
          description = "Extract relevant information from validated sources";
          action = #ParseDocument({
            documentType = "mixed";
            extractFields = ["main_content", "citations", "data", "conclusions"];
            preserveStructure = true;
          });
          timeout = 120;
          retryCount = 2;
          fallbackAction = null;
        },
        {
          stepId = 6;
          name = "Entity Extraction";
          description = "Identify key concepts, people, and relationships";
          action = #ExtractEntities({
            entityTypes = ["person", "organization", "concept", "date", "location", "technology"];
            confidenceThreshold = 0.7;
            linkEntities = true;
          });
          timeout = 90;
          retryCount = 2;
          fallbackAction = null;
        },
        {
          stepId = 7;
          name = "Cross-Reference";
          description = "Validate facts across multiple sources";
          action = #CrossReference({
            minSources = 3;
            agreementThreshold = 0.7;
            conflictResolution = #FlagForReview;
          });
          timeout = 120;
          retryCount = 2;
          fallbackAction = ?#CrossReference({
            minSources = 2;
            agreementThreshold = 0.6;
            conflictResolution = #TrustHighest;
          });
        },
        {
          stepId = 8;
          name = "Synthesize Knowledge";
          description = "Combine findings into coherent understanding";
          action = #Summarize({
            maxLength = 5000;
            style = #Detailed;
            focusTopics = [];
          });
          timeout = 90;
          retryCount = 2;
          fallbackAction = null;
        },
        {
          stepId = 9;
          name = "Generate Insights";
          description = "Extract actionable insights from research";
          action = #GenerateInsight({
            insightType = #Trend;
            confidenceThreshold = 0.7;
            supportingEvidence = 3;
          });
          timeout = 60;
          retryCount = 2;
          fallbackAction = null;
        },
        {
          stepId = 10;
          name = "Store Knowledge";
          description = "Integrate new knowledge into organism's knowledge base";
          action = #StoreKnowledge({
            knowledgeType = #Concept;
            salience = 0.8;
            linkToExisting = true;
          });
          timeout = 45;
          retryCount = 1;
          fallbackAction = null;
        }
      ];
      validationRules = [
        {
          ruleId = 1;
          ruleType = #MinimumSources(3);
          threshold = 1.0;
          action = #RequireAdditionalSource;
        },
        {
          ruleId = 2;
          ruleType = #MinCredibility(0.6);
          threshold = 0.6;
          action = #Reject;
        },
        {
          ruleId = 3;
          ruleType = #NoContradictions;
          threshold = 0.8;
          action = #FlagForReview;
        }
      ];
      outputFormat = #KnowledgeGraph({ format = "json-ld" });
      estimatedDuration = 600;
      lastExecution = null;
      successRate = 1.0;
    }
  };
  
  /// Quick Lookup Workflow
  public func defineQuickLookupWorkflow() : ExternalWorkflow {
    {
      id = #QuickLookup;
      name = "Quick Lookup";
      description = "Fast retrieval of specific facts or definitions";
      category = #InformationSeeking;
      priority = #High;
      informationHungerSatisfaction = 0.2;
      triggers = [
        #CreatorRequest("what_is"),
        #TaskRequired({ taskId = 0; requirement = "fact" })
      ];
      sources = [
        {
          sourceType = #InternalKnowledge;
          trustLevel = 0.95;
          priority = 1;
          rateLimit = null;
          credentials = null;
        },
        {
          sourceType = #API({ endpoint = "wikipedia_api"; method = "GET" });
          trustLevel = 0.8;
          priority = 2;
          rateLimit = ?{ requestsPerMinute = 60; dailyLimit = 10000 };
          credentials = null;
        }
      ];
      steps = [
        {
          stepId = 1;
          name = "Check Internal Knowledge";
          description = "Search organism's existing knowledge first";
          action = #SearchWeb({
            query = "";
            maxResults = 5;
            filters = [("source", "internal")];
            dateRange = null;
          });
          timeout = 5;
          retryCount = 0;
          fallbackAction = null;
        },
        {
          stepId = 2;
          name = "External Lookup";
          description = "Query external sources if internal fails";
          action = #CallAPI({
            endpoint = "knowledge_base";
            method = "GET";
            headers = [];
            body = null;
            responseFormat = "json";
          });
          timeout = 15;
          retryCount = 2;
          fallbackAction = ?#SearchWeb({
            query = "";
            maxResults = 3;
            filters = [];
            dateRange = null;
          });
        },
        {
          stepId = 3;
          name = "Validate Answer";
          description = "Quick validation of retrieved fact";
          action = #ValidateSource({
            validationType = #FactAccuracy;
            strictness = 0.5;
          });
          timeout = 10;
          retryCount = 1;
          fallbackAction = null;
        },
        {
          stepId = 4;
          name = "Format Response";
          description = "Present answer in clear format";
          action = #Summarize({
            maxLength = 200;
            style = #Brief;
            focusTopics = [];
          });
          timeout = 5;
          retryCount = 1;
          fallbackAction = null;
        }
      ];
      validationRules = [
        {
          ruleId = 1;
          ruleType = #MinCredibility(0.5);
          threshold = 0.5;
          action = #ReduceConfidence(0.2);
        }
      ];
      outputFormat = #NaturalLanguage({ style = "concise" });
      estimatedDuration = 35;
      lastExecution = null;
      successRate = 1.0;
    }
  };
  
  /// Fact Checking Workflow
  public func defineFactCheckingWorkflow() : ExternalWorkflow {
    {
      id = #FactChecking;
      name = "Fact Checking";
      description = "Verify the accuracy of a claim or statement";
      category = #Validation;
      priority = #High;
      informationHungerSatisfaction = 0.4;
      triggers = [
        #CreatorRequest("verify"),
        #CuriosityDriven({ topic = "suspicious_claim"; interestLevel = 0.8 })
      ];
      sources = [
        {
          sourceType = #WebSearch({ engine = "fact_check_sites" });
          trustLevel = 0.85;
          priority = 1;
          rateLimit = ?{ requestsPerMinute = 10; dailyLimit = 500 };
          credentials = null;
        },
        {
          sourceType = #AcademicDatabase({ database = "pubmed" });
          trustLevel = 0.9;
          priority = 2;
          rateLimit = ?{ requestsPerMinute = 5; dailyLimit = 200 };
          credentials = null;
        },
        {
          sourceType = #API({ endpoint = "official_sources"; method = "GET" });
          trustLevel = 0.95;
          priority = 3;
          rateLimit = ?{ requestsPerMinute = 20; dailyLimit = 1000 };
          credentials = null;
        }
      ];
      steps = [
        {
          stepId = 1;
          name = "Parse Claim";
          description = "Extract the core factual claims to verify";
          action = #ExtractEntities({
            entityTypes = ["claim", "subject", "predicate", "object", "qualifier"];
            confidenceThreshold = 0.7;
            linkEntities = false;
          });
          timeout = 20;
          retryCount = 2;
          fallbackAction = null;
        },
        {
          stepId = 2;
          name = "Search Fact-Check Sites";
          description = "Check if claim has been previously fact-checked";
          action = #SearchWeb({
            query = "";
            maxResults = 10;
            filters = [("site_type", "fact_check")];
            dateRange = null;
          });
          timeout = 30;
          retryCount = 2;
          fallbackAction = null;
        },
        {
          stepId = 3;
          name = "Search Primary Sources";
          description = "Find original sources that can verify/refute claim";
          action = #SearchWeb({
            query = "";
            maxResults = 20;
            filters = [("source_type", "primary")];
            dateRange = null;
          });
          timeout = 45;
          retryCount = 2;
          fallbackAction = null;
        },
        {
          stepId = 4;
          name = "Cross-Reference Sources";
          description = "Compare findings across multiple sources";
          action = #CrossReference({
            minSources = 3;
            agreementThreshold = 0.8;
            conflictResolution = #Majority;
          });
          timeout = 60;
          retryCount = 2;
          fallbackAction = null;
        },
        {
          stepId = 5;
          name = "Bias Analysis";
          description = "Check sources for potential bias";
          action = #ValidateSource({
            validationType = #BiasCheck;
            strictness = 0.7;
          });
          timeout = 30;
          retryCount = 1;
          fallbackAction = null;
        },
        {
          stepId = 6;
          name = "Determine Verdict";
          description = "Conclude whether claim is true, false, or mixed";
          action = #GenerateInsight({
            insightType = #Prediction;
            confidenceThreshold = 0.7;
            supportingEvidence = 3;
          });
          timeout = 30;
          retryCount = 1;
          fallbackAction = null;
        },
        {
          stepId = 7;
          name = "Generate Report";
          description = "Create fact-check report with evidence";
          action = #CreateReport({
            reportType = "fact_check";
            sections = ["claim", "verdict", "evidence", "sources", "caveats"];
            visualizations = false;
          });
          timeout = 45;
          retryCount = 1;
          fallbackAction = null;
        }
      ];
      validationRules = [
        {
          ruleId = 1;
          ruleType = #MinimumSources(3);
          threshold = 1.0;
          action = #FlagForReview;
        },
        {
          ruleId = 2;
          ruleType = #FactCheckRequired;
          threshold = 1.0;
          action = #RequireAdditionalSource;
        }
      ];
      outputFormat = #Report({ template = "fact_check_report" });
      estimatedDuration = 260;
      lastExecution = null;
      successRate = 1.0;
    }
  };
  
  /// Trend Monitoring Workflow
  public func defineTrendMonitoringWorkflow() : ExternalWorkflow {
    {
      id = #TrendMonitoring;
      name = "Trend Monitoring";
      description = "Continuously monitor for emerging trends in specified domains";
      category = #DataGathering;
      priority = #Background;
      informationHungerSatisfaction = 0.5;
      triggers = [
        #ScheduledUpdate({ intervalSeconds = 3600 }),
        #CreatorRequest("monitor_trends")
      ];
      sources = [
        {
          sourceType = #RSS({ feedUrl = "tech_news" });
          trustLevel = 0.7;
          priority = 1;
          rateLimit = ?{ requestsPerMinute = 60; dailyLimit = 10000 };
          credentials = null;
        },
        {
          sourceType = #SocialMedia({ platform = "twitter" });
          trustLevel = 0.5;
          priority = 2;
          rateLimit = ?{ requestsPerMinute = 15; dailyLimit = 1500 };
          credentials = ?{ credentialId = "social_api"; scope = ["read"] };
        },
        {
          sourceType = #API({ endpoint = "trends_api"; method = "GET" });
          trustLevel = 0.8;
          priority = 3;
          rateLimit = ?{ requestsPerMinute = 10; dailyLimit = 500 };
          credentials = null;
        }
      ];
      steps = [
        {
          stepId = 1;
          name = "Fetch Latest Content";
          description = "Retrieve recent content from monitored sources";
          action = #CallAPI({
            endpoint = "aggregator";
            method = "GET";
            headers = [];
            body = null;
            responseFormat = "json";
          });
          timeout = 60;
          retryCount = 3;
          fallbackAction = null;
        },
        {
          stepId = 2;
          name = "Extract Topics";
          description = "Identify topics and keywords from content";
          action = #ExtractEntities({
            entityTypes = ["topic", "keyword", "hashtag", "trend"];
            confidenceThreshold = 0.5;
            linkEntities = true;
          });
          timeout = 90;
          retryCount = 2;
          fallbackAction = null;
        },
        {
          stepId = 3;
          name = "Analyze Trend Velocity";
          description = "Measure how fast topics are growing";
          action = #GenerateInsight({
            insightType = #Trend;
            confidenceThreshold = 0.6;
            supportingEvidence = 5;
          });
          timeout = 60;
          retryCount = 2;
          fallbackAction = null;
        },
        {
          stepId = 4;
          name = "Compare to Baseline";
          description = "Identify anomalies vs historical patterns";
          action = #GenerateInsight({
            insightType = #Anomaly;
            confidenceThreshold = 0.7;
            supportingEvidence = 3;
          });
          timeout = 45;
          retryCount = 2;
          fallbackAction = null;
        },
        {
          stepId = 5;
          name = "Store Trend Data";
          description = "Save trend observations for analysis";
          action = #StoreKnowledge({
            knowledgeType = #Pattern;
            salience = 0.6;
            linkToExisting = true;
          });
          timeout = 30;
          retryCount = 1;
          fallbackAction = null;
        },
        {
          stepId = 6;
          name = "Alert on Significant Trends";
          description = "Notify if major trend detected";
          action = #CreateReport({
            reportType = "trend_alert";
            sections = ["trend", "velocity", "significance", "related_topics"];
            visualizations = true;
          });
          timeout = 30;
          retryCount = 1;
          fallbackAction = null;
        }
      ];
      validationRules = [
        {
          ruleId = 1;
          ruleType = #MaxAgeHours(24);
          threshold = 1.0;
          action = #Reject;
        }
      ];
      outputFormat = #StructuredData({ schema = "trend_data" });
      estimatedDuration = 315;
      lastExecution = null;
      successRate = 1.0;
    }
  };
  
  /// Knowledge Synthesis Workflow
  public func defineKnowledgeSynthesisWorkflow() : ExternalWorkflow {
    {
      id = #KnowledgeSynthesis;
      name = "Knowledge Synthesis";
      description = "Combine multiple pieces of information into cohesive understanding";
      category = #Synthesis;
      priority = #Medium;
      informationHungerSatisfaction = 0.9;
      triggers = [
        #CreatorRequest("synthesize"),
        #GapDetected({ knowledgeGap = "fragmented_knowledge" }),
        #CuriosityDriven({ topic = "connections"; interestLevel = 0.7 })
      ];
      sources = [
        {
          sourceType = #InternalKnowledge;
          trustLevel = 0.95;
          priority = 1;
          rateLimit = null;
          credentials = null;
        }
      ];
      steps = [
        {
          stepId = 1;
          name = "Gather Related Knowledge";
          description = "Retrieve all related knowledge fragments";
          action = #SearchWeb({
            query = "";
            maxResults = 100;
            filters = [("source", "internal")];
            dateRange = null;
          });
          timeout = 30;
          retryCount = 1;
          fallbackAction = null;
        },
        {
          stepId = 2;
          name = "Identify Relationships";
          description = "Find connections between knowledge pieces";
          action = #ExtractEntities({
            entityTypes = ["relationship", "causation", "correlation", "hierarchy"];
            confidenceThreshold = 0.6;
            linkEntities = true;
          });
          timeout = 60;
          retryCount = 2;
          fallbackAction = null;
        },
        {
          stepId = 3;
          name = "Detect Contradictions";
          description = "Find conflicting information";
          action = #ValidateSource({
            validationType = #ConsistencyCheck;
            strictness = 0.8;
          });
          timeout = 45;
          retryCount = 1;
          fallbackAction = null;
        },
        {
          stepId = 4;
          name = "Resolve Contradictions";
          description = "Determine which conflicting info is correct";
          action = #CrossReference({
            minSources = 2;
            agreementThreshold = 0.6;
            conflictResolution = #TrustHighest;
          });
          timeout = 60;
          retryCount = 2;
          fallbackAction = null;
        },
        {
          stepId = 5;
          name = "Build Mental Model";
          description = "Create unified understanding";
          action = #UpdateModel({
            modelName = "world_model";
            updateType = "integration";
            learningRate = 0.1;
          });
          timeout = 90;
          retryCount = 2;
          fallbackAction = null;
        },
        {
          stepId = 6;
          name = "Generate Insights";
          description = "Extract novel insights from synthesis";
          action = #GenerateInsight({
            insightType = #Correlation;
            confidenceThreshold = 0.7;
            supportingEvidence = 2;
          });
          timeout = 45;
          retryCount = 2;
          fallbackAction = null;
        },
        {
          stepId = 7;
          name = "Store Synthesized Knowledge";
          description = "Save new unified understanding";
          action = #StoreKnowledge({
            knowledgeType = #Concept;
            salience = 0.85;
            linkToExisting = true;
          });
          timeout = 30;
          retryCount = 1;
          fallbackAction = null;
        }
      ];
      validationRules = [
        {
          ruleId = 1;
          ruleType = #NoContradictions;
          threshold = 0.9;
          action = #FlagForReview;
        }
      ];
      outputFormat = #KnowledgeGraph({ format = "json-ld" });
      estimatedDuration = 360;
      lastExecution = null;
      successRate = 1.0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // EXTERNAL WORKFLOW REGISTRY
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type ExternalWorkflowRegistry = {
    workflows : [ExternalWorkflow];
    activeRequests : [ActiveRequest];
    completedRequests : [CompletedRequest];
    sourceStatistics : [SourceStatistic];
    informationHungerLevel : Float;
    dailyInformationIntake : Float;
  };
  
  public type ActiveRequest = {
    requestId : Nat64;
    workflowId : ExternalWorkflowId;
    startTime : Int;
    currentStep : Nat;
    status : RequestStatus;
  };
  
  public type RequestStatus = {
    #InProgress;
    #WaitingForSource;
    #Validating;
    #Synthesizing;
    #Complete;
    #Failed : Text;
  };
  
  public type CompletedRequest = {
    requestId : Nat64;
    workflowId : ExternalWorkflowId;
    startTime : Int;
    endTime : Int;
    success : Bool;
    informationGained : Float;
    sourcesUsed : Nat;
  };
  
  public type SourceStatistic = {
    sourceType : Text;
    totalQueries : Nat;
    successfulQueries : Nat;
    avgResponseTime : Float;
    lastUsed : Int;
    reliability : Float;
  };
  
  public func initExternalWorkflowRegistry() : ExternalWorkflowRegistry {
    {
      workflows = [
        defineDeepDiveWorkflow(),
        defineQuickLookupWorkflow(),
        defineFactCheckingWorkflow(),
        defineTrendMonitoringWorkflow(),
        defineKnowledgeSynthesisWorkflow()
      ];
      activeRequests = [];
      completedRequests = [];
      sourceStatistics = [];
      informationHungerLevel = 0.5;
      dailyInformationIntake = 0.0;
    }
  };

}
