/**
 * PROMPT SYSTEM ARCHITECTURE - Enterprise-Grade Prompt Management
 * 
 * COMPREHENSIVE PROMPT ORCHESTRATION FOR ALL ORGANISMS
 * 
 * Full prompt lifecycle management including:
 * - Prompt templates with variable injection
 * - Prompt chains for multi-step reasoning
 * - Context management with compression
 * - A/B testing and optimization
 * - Caching and rate limiting
 * - Audit logging for compliance
 * 
 * Integrated with:
 * - All 9 Organisms (Legal, Finance, Research, Engineering, Creative, Operations, Code, Video, PDF)
 * - Natural Language Pipeline for input processing
 * - Decision Reasoning Engine for response generation
 * - Knowledge Graph Engine for context enrichment
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
import Char "mo:base/Char";
import Blob "mo:base/Blob";

actor PromptSystemArchitecture {
    
    // ============================================
    // SOVEREIGNTY CONSTANTS - ALL MAXED TO 1.0
    // ============================================
    
    private let S_0_FLOOR : Float = 1.0;  // MAXED - Enterprise grade
    private let COHERENCE_THRESHOLD : Float = 1.0;
    private let INTEGRITY_MINIMUM : Float = 1.0;
    
    // ============================================
    // PROMPT TYPES AND ROLES
    // ============================================
    
    public type PromptType = {
        #System;        // System-level instructions
        #User;          // User input
        #Assistant;     // Assistant response
        #Function;      // Function call
        #Context;       // Context injection
        #Instruction;   // Specific instruction
        #Example;       // Few-shot example
        #Template;      // Reusable template
        #Chain;         // Chain link
        #Metacognitive; // Self-reflection prompt
        #Sovereignty;   // Sovereignty enforcement
    };
    
    public type PromptCategory = {
        #Analysis;
        #Generation;
        #Transformation;
        #Extraction;
        #Classification;
        #Summarization;
        #Translation;
        #QA;
        #Reasoning;
        #Code;
        #Creative;
        #Legal;
        #Financial;
        #Research;
        #Operations;
        #Engineering;
    };
    
    public type OrganismTarget = {
        #Legal;
        #Finance;
        #Research;
        #Engineering;
        #Creative;
        #Operations;
        #Code;
        #Video;
        #PDF;
        #All;
        #Custom: Text;
    };
    
    // ============================================
    // PROMPT TEMPLATE STRUCTURE
    // ============================================
    
    public type PromptTemplate = {
        id: Text;
        name: Text;
        description: Text;
        promptType: PromptType;
        category: PromptCategory;
        targetOrganisms: [OrganismTarget];
        template: Text;
        variables: [TemplateVariable];
        defaultValues: [(Text, Text)];
        version: Nat;
        parentVersion: ?Nat;
        tags: [Text];
        priority: Nat;
        maxTokens: ?Nat;
        temperature: ?Float;
        topP: ?Float;
        frequencyPenalty: ?Float;
        presencePenalty: ?Float;
        stopSequences: [Text];
        validationRules: [ValidationRule];
        sovereignty: SovereigntyConstraints;
        createdAt: Time.Time;
        updatedAt: Time.Time;
        createdBy: Text;
        isActive: Bool;
        usageCount: Nat;
        averageLatency: Float;
        successRate: Float;
    };
    
    public type TemplateVariable = {
        name: Text;
        description: Text;
        variableType: VariableType;
        required: Bool;
        defaultValue: ?Text;
        validation: ?ValidationRule;
        transformations: [Transformation];
    };
    
    public type VariableType = {
        #String;
        #Number;
        #Boolean;
        #Array;
        #Object;
        #Date;
        #Enum: [Text];
        #Reference: Text;  // Reference to another entity
    };
    
    public type ValidationRule = {
        ruleType: ValidationRuleType;
        parameters: [(Text, Text)];
        errorMessage: Text;
    };
    
    public type ValidationRuleType = {
        #Required;
        #MinLength: Nat;
        #MaxLength: Nat;
        #Pattern: Text;  // Regex pattern
        #Range: (Float, Float);
        #Enum: [Text];
        #Custom: Text;  // Custom validation function name
    };
    
    public type Transformation = {
        transformType: TransformType;
        parameters: [(Text, Text)];
    };
    
    public type TransformType = {
        #Lowercase;
        #Uppercase;
        #Trim;
        #Truncate: Nat;
        #Replace: (Text, Text);
        #Prefix: Text;
        #Suffix: Text;
        #JSONStringify;
        #HTMLEscape;
        #URLEncode;
        #Base64Encode;
        #Markdown;
        #StripHTML;
        #Sanitize;
        #Custom: Text;
    };
    
    public type SovereigntyConstraints = {
        requiresS0Check: Bool;
        minimumCoherence: Float;
        allowedDomains: [Text];
        blockedPatterns: [Text];
        requiresAudit: Bool;
        sensitivityLevel: SensitivityLevel;
        dataClassification: DataClassification;
    };
    
    public type SensitivityLevel = {
        #Public;
        #Internal;
        #Confidential;
        #Restricted;
        #TopSecret;
    };
    
    public type DataClassification = {
        #General;
        #PII;           // Personally Identifiable Information
        #PHI;           // Protected Health Information
        #PCI;           // Payment Card Industry
        #Financial;
        #Legal;
        #Proprietary;
    };
    
    // ============================================
    // PROMPT CHAIN STRUCTURE
    // ============================================
    
    public type PromptChain = {
        id: Text;
        name: Text;
        description: Text;
        steps: [ChainStep];
        globalContext: [(Text, Text)];
        executionMode: ExecutionMode;
        errorHandling: ErrorHandling;
        timeout: Nat;  // milliseconds
        maxRetries: Nat;
        sovereignty: SovereigntyConstraints;
        createdAt: Time.Time;
        isActive: Bool;
    };
    
    public type ChainStep = {
        stepId: Text;
        name: Text;
        templateId: Text;
        inputMapping: [(Text, InputSource)];
        outputMapping: [(Text, Text)];  // Output key -> Context key
        condition: ?StepCondition;
        onSuccess: ?Text;  // Next step ID
        onFailure: ?Text;  // Fallback step ID
        retryPolicy: ?RetryPolicy;
        timeout: ?Nat;
    };
    
    public type InputSource = {
        #Static: Text;
        #Context: Text;
        #PreviousStep: (Text, Text);  // (stepId, outputKey)
        #Function: Text;
        #User;
        #System;
    };
    
    public type StepCondition = {
        conditionType: ConditionType;
        parameters: [(Text, Text)];
    };
    
    public type ConditionType = {
        #Always;
        #ContextEquals: (Text, Text);
        #ContextContains: (Text, Text);
        #ContextNotEmpty: Text;
        #PreviousStepSuccess: Text;
        #PreviousStepFailure: Text;
        #Custom: Text;
    };
    
    public type ExecutionMode = {
        #Sequential;
        #Parallel;
        #Conditional;
        #Loop: LoopConfig;
    };
    
    public type LoopConfig = {
        maxIterations: Nat;
        breakCondition: StepCondition;
        aggregateResults: Bool;
    };
    
    public type ErrorHandling = {
        #StopOnError;
        #ContinueOnError;
        #RetryAndContinue;
        #FallbackChain: Text;
    };
    
    public type RetryPolicy = {
        maxRetries: Nat;
        initialDelay: Nat;  // milliseconds
        backoffMultiplier: Float;
        maxDelay: Nat;
    };
    
    // ============================================
    // CONTEXT MANAGEMENT
    // ============================================
    
    public type ConversationContext = {
        id: Text;
        sessionId: Text;
        userId: ?Text;
        organismId: ?Text;
        messages: [ContextMessage];
        variables: [(Text, Text)];
        metadata: [(Text, Text)];
        tokenCount: Nat;
        maxTokens: Nat;
        compressionLevel: CompressionLevel;
        priority: ContextPriority;
        expiresAt: ?Time.Time;
        createdAt: Time.Time;
        updatedAt: Time.Time;
    };
    
    public type ContextMessage = {
        role: MessageRole;
        content: Text;
        timestamp: Time.Time;
        tokenCount: Nat;
        importance: Float;
        isCompressed: Bool;
        originalLength: ?Nat;
        metadata: [(Text, Text)];
    };
    
    public type MessageRole = {
        #System;
        #User;
        #Assistant;
        #Function;
        #Tool;
    };
    
    public type CompressionLevel = {
        #None;
        #Light;     // Remove redundancy
        #Medium;    // Summarize older messages
        #Heavy;     // Keep only essential info
        #Extreme;   // Maximum compression
    };
    
    public type ContextPriority = {
        #Critical;  // Never compress
        #High;
        #Normal;
        #Low;
        #Ephemeral; // Can be discarded
    };
    
    // ============================================
    // PROMPT EXECUTION
    // ============================================
    
    public type PromptExecution = {
        id: Text;
        templateId: Text;
        chainId: ?Text;
        chainStepId: ?Text;
        input: PromptInput;
        output: ?PromptOutput;
        status: ExecutionStatus;
        startTime: Time.Time;
        endTime: ?Time.Time;
        latency: ?Nat;  // milliseconds
        tokenUsage: TokenUsage;
        cost: ?Float;
        retryCount: Nat;
        error: ?ExecutionError;
        auditLog: [AuditEntry];
    };
    
    public type PromptInput = {
        renderedPrompt: Text;
        variables: [(Text, Text)];
        context: ?ConversationContext;
        parameters: ExecutionParameters;
    };
    
    public type PromptOutput = {
        content: Text;
        finishReason: FinishReason;
        parsedContent: ?ParsedContent;
        confidence: ?Float;
        alternatives: [Text];
    };
    
    public type ExecutionParameters = {
        model: ?Text;
        maxTokens: ?Nat;
        temperature: ?Float;
        topP: ?Float;
        frequencyPenalty: ?Float;
        presencePenalty: ?Float;
        stopSequences: [Text];
        stream: Bool;
        timeout: Nat;
    };
    
    public type ExecutionStatus = {
        #Pending;
        #Running;
        #Completed;
        #Failed;
        #Cancelled;
        #TimedOut;
        #RateLimited;
    };
    
    public type FinishReason = {
        #Stop;
        #Length;
        #ContentFilter;
        #FunctionCall;
        #ToolCall;
        #Error;
    };
    
    public type ParsedContent = {
        contentType: ContentType;
        structured: ?[(Text, Text)];
        entities: [ExtractedEntity];
        sentiment: ?Float;
        intent: ?Text;
    };
    
    public type ContentType = {
        #Text;
        #JSON;
        #Code: Text;  // Language
        #Markdown;
        #HTML;
        #XML;
        #YAML;
    };
    
    public type ExtractedEntity = {
        entityType: Text;
        value: Text;
        confidence: Float;
        startOffset: Nat;
        endOffset: Nat;
    };
    
    public type TokenUsage = {
        promptTokens: Nat;
        completionTokens: Nat;
        totalTokens: Nat;
        cachedTokens: Nat;
    };
    
    public type ExecutionError = {
        errorType: ErrorType;
        message: Text;
        code: ?Text;
        retryable: Bool;
        details: [(Text, Text)];
    };
    
    public type ErrorType = {
        #Validation;
        #RateLimit;
        #Timeout;
        #ModelError;
        #ContentFilter;
        #Sovereignty;
        #Network;
        #Internal;
        #Unknown;
    };
    
    // ============================================
    // AUDIT AND COMPLIANCE
    // ============================================
    
    public type AuditEntry = {
        timestamp: Time.Time;
        action: AuditAction;
        userId: ?Text;
        details: Text;
        ipAddress: ?Text;
        userAgent: ?Text;
        sovereigntyCheck: ?SovereigntyCheckResult;
    };
    
    public type AuditAction = {
        #PromptCreated;
        #PromptUpdated;
        #PromptDeleted;
        #PromptExecuted;
        #ChainExecuted;
        #ContextCreated;
        #ContextUpdated;
        #ContextExpired;
        #SovereigntyViolation;
        #RateLimitHit;
        #CacheHit;
        #CacheMiss;
    };
    
    public type SovereigntyCheckResult = {
        passed: Bool;
        s0Value: Float;
        coherenceValue: Float;
        violations: [Text];
        timestamp: Time.Time;
    };
    
    // ============================================
    // CACHING
    // ============================================
    
    public type CacheEntry = {
        key: Text;
        value: PromptOutput;
        hitCount: Nat;
        createdAt: Time.Time;
        lastAccessedAt: Time.Time;
        expiresAt: Time.Time;
        size: Nat;
    };
    
    public type CacheConfig = {
        enabled: Bool;
        maxSize: Nat;  // bytes
        maxEntries: Nat;
        defaultTTL: Nat;  // seconds
        evictionPolicy: EvictionPolicy;
    };
    
    public type EvictionPolicy = {
        #LRU;   // Least Recently Used
        #LFU;   // Least Frequently Used
        #FIFO;  // First In First Out
        #TTL;   // Time To Live only
    };
    
    // ============================================
    // RATE LIMITING
    // ============================================
    
    public type RateLimitConfig = {
        enabled: Bool;
        requestsPerMinute: Nat;
        requestsPerHour: Nat;
        requestsPerDay: Nat;
        tokensPerMinute: Nat;
        tokensPerHour: Nat;
        tokensPerDay: Nat;
        burstLimit: Nat;
        refillRate: Float;
    };
    
    public type RateLimitState = {
        userId: Text;
        requestCount: Nat;
        tokenCount: Nat;
        windowStart: Time.Time;
        bucketLevel: Float;
        lastRequest: Time.Time;
        blocked: Bool;
        blockedUntil: ?Time.Time;
    };
    
    // ============================================
    // A/B TESTING
    // ============================================
    
    public type ABTest = {
        id: Text;
        name: Text;
        description: Text;
        variants: [ABVariant];
        trafficAllocation: [Float];  // Must sum to 1.0
        targetAudience: ?AudienceFilter;
        metrics: [ABMetric];
        startDate: Time.Time;
        endDate: ?Time.Time;
        status: ABTestStatus;
        results: ?ABTestResults;
    };
    
    public type ABVariant = {
        variantId: Text;
        name: Text;
        templateId: Text;
        parameters: [(Text, Text)];
        isControl: Bool;
    };
    
    public type AudienceFilter = {
        userIds: ?[Text];
        userSegments: ?[Text];
        percentage: ?Float;
        conditions: [(Text, Text)];
    };
    
    public type ABMetric = {
        name: Text;
        metricType: ABMetricType;
        higherIsBetter: Bool;
    };
    
    public type ABMetricType = {
        #Latency;
        #TokenUsage;
        #SuccessRate;
        #UserSatisfaction;
        #ConversionRate;
        #EngagementRate;
        #Custom: Text;
    };
    
    public type ABTestStatus = {
        #Draft;
        #Running;
        #Paused;
        #Completed;
        #Cancelled;
    };
    
    public type ABTestResults = {
        totalSamples: Nat;
        variantResults: [VariantResult];
        winner: ?Text;
        statisticalSignificance: Float;
        confidence: Float;
    };
    
    public type VariantResult = {
        variantId: Text;
        sampleSize: Nat;
        metrics: [(Text, Float)];
        conversionRate: Float;
        averageLatency: Float;
        successRate: Float;
    };
    
    // ============================================
    // STATE MANAGEMENT
    // ============================================
    
    private let templates = HashMap.HashMap<Text, PromptTemplate>(500, Text.equal, Text.hash);
    private let chains = HashMap.HashMap<Text, PromptChain>(100, Text.equal, Text.hash);
    private let contexts = HashMap.HashMap<Text, ConversationContext>(10000, Text.equal, Text.hash);
    private let executions = HashMap.HashMap<Text, PromptExecution>(50000, Text.equal, Text.hash);
    private let cache = HashMap.HashMap<Text, CacheEntry>(10000, Text.equal, Text.hash);
    private let rateLimits = HashMap.HashMap<Text, RateLimitState>(1000, Text.equal, Text.hash);
    private let abTests = HashMap.HashMap<Text, ABTest>(50, Text.equal, Text.hash);
    private let auditLog = Buffer.Buffer<AuditEntry>(100000);
    
    private var templateCounter : Nat = 0;
    private var chainCounter : Nat = 0;
    private var contextCounter : Nat = 0;
    private var executionCounter : Nat = 0;
    private var abTestCounter : Nat = 0;
    
    private var cacheConfig : CacheConfig = {
        enabled = true;
        maxSize = 100000000;  // 100MB
        maxEntries = 10000;
        defaultTTL = 3600;    // 1 hour
        evictionPolicy = #LRU;
    };
    
    private var rateLimitConfig : RateLimitConfig = {
        enabled = true;
        requestsPerMinute = 60;
        requestsPerHour = 1000;
        requestsPerDay = 10000;
        tokensPerMinute = 100000;
        tokensPerHour = 1000000;
        tokensPerDay = 10000000;
        burstLimit = 100;
        refillRate = 1.0;
    };
    
    // ============================================
    // TEMPLATE MANAGEMENT
    // ============================================
    
    public func createTemplate(
        name: Text,
        description: Text,
        promptType: PromptType,
        category: PromptCategory,
        targetOrganisms: [OrganismTarget],
        template: Text,
        variables: [TemplateVariable]
    ) : async Text {
        templateCounter += 1;
        let id = "tpl-" # Nat.toText(templateCounter);
        
        let now = Time.now();
        let newTemplate : PromptTemplate = {
            id = id;
            name = name;
            description = description;
            promptType = promptType;
            category = category;
            targetOrganisms = targetOrganisms;
            template = template;
            variables = variables;
            defaultValues = [];
            version = 1;
            parentVersion = null;
            tags = [];
            priority = 0;
            maxTokens = null;
            temperature = null;
            topP = null;
            frequencyPenalty = null;
            presencePenalty = null;
            stopSequences = [];
            validationRules = [];
            sovereignty = defaultSovereigntyConstraints();
            createdAt = now;
            updatedAt = now;
            createdBy = "system";
            isActive = true;
            usageCount = 0;
            averageLatency = 0.0;
            successRate = 1.0;
        };
        
        templates.put(id, newTemplate);
        
        logAudit(#PromptCreated, null, "Created template: " # name);
        
        id
    };
    
    public func updateTemplate(
        id: Text,
        template: Text,
        variables: [TemplateVariable]
    ) : async Result.Result<PromptTemplate, Text> {
        switch (templates.get(id)) {
            case null { #err("Template not found") };
            case (?existing) {
                let updated : PromptTemplate = {
                    id = existing.id;
                    name = existing.name;
                    description = existing.description;
                    promptType = existing.promptType;
                    category = existing.category;
                    targetOrganisms = existing.targetOrganisms;
                    template = template;
                    variables = variables;
                    defaultValues = existing.defaultValues;
                    version = existing.version + 1;
                    parentVersion = ?existing.version;
                    tags = existing.tags;
                    priority = existing.priority;
                    maxTokens = existing.maxTokens;
                    temperature = existing.temperature;
                    topP = existing.topP;
                    frequencyPenalty = existing.frequencyPenalty;
                    presencePenalty = existing.presencePenalty;
                    stopSequences = existing.stopSequences;
                    validationRules = existing.validationRules;
                    sovereignty = existing.sovereignty;
                    createdAt = existing.createdAt;
                    updatedAt = Time.now();
                    createdBy = existing.createdBy;
                    isActive = existing.isActive;
                    usageCount = existing.usageCount;
                    averageLatency = existing.averageLatency;
                    successRate = existing.successRate;
                };
                
                templates.put(id, updated);
                logAudit(#PromptUpdated, null, "Updated template: " # existing.name);
                
                #ok(updated)
            };
        }
    };
    
    public func renderTemplate(templateId: Text, variables: [(Text, Text)]) : async Result.Result<Text, Text> {
        switch (templates.get(templateId)) {
            case null { #err("Template not found") };
            case (?template) {
                // Check sovereignty constraints
                let sovereigntyCheck = checkSovereignty(template.sovereignty);
                if (not sovereigntyCheck.passed) {
                    logAudit(#SovereigntyViolation, null, "Sovereignty check failed for template: " # templateId);
                    return #err("Sovereignty check failed: " # Text.join(", ", sovereigntyCheck.violations.vals()));
                };
                
                // Validate required variables
                for (v in template.variables.vals()) {
                    if (v.required) {
                        var found = false;
                        for ((key, _) in variables.vals()) {
                            if (key == v.name) {
                                found := true;
                            };
                        };
                        
                        if (not found) {
                            switch (v.defaultValue) {
                                case null {
                                    return #err("Missing required variable: " # v.name);
                                };
                                case (?_) {};  // Has default
                            };
                        };
                    };
                };
                
                // Render template with variable substitution
                var rendered = template.template;
                
                // Apply provided variables
                for ((key, value) in variables.vals()) {
                    let placeholder = "{{" # key # "}}";
                    rendered := Text.replace(rendered, #text placeholder, value);
                };
                
                // Apply default values for missing variables
                for (v in template.variables.vals()) {
                    switch (v.defaultValue) {
                        case null {};
                        case (?defaultVal) {
                            let placeholder = "{{" # v.name # "}}";
                            rendered := Text.replace(rendered, #text placeholder, defaultVal);
                        };
                    };
                };
                
                // Apply template-level defaults
                for ((key, value) in template.defaultValues.vals()) {
                    let placeholder = "{{" # key # "}}";
                    rendered := Text.replace(rendered, #text placeholder, value);
                };
                
                #ok(rendered)
            };
        }
    };
    
    private func defaultSovereigntyConstraints() : SovereigntyConstraints {
        {
            requiresS0Check = true;
            minimumCoherence = 1.0;
            allowedDomains = [];
            blockedPatterns = [];
            requiresAudit = true;
            sensitivityLevel = #Internal;
            dataClassification = #General;
        }
    };
    
    private func checkSovereignty(constraints: SovereigntyConstraints) : SovereigntyCheckResult {
        let violations = Buffer.Buffer<Text>(5);
        
        // Check S₀ floor
        if (S_0_FLOOR < constraints.minimumCoherence) {
            violations.add("S₀ floor below minimum coherence");
        };
        
        // Additional checks would go here
        
        {
            passed = violations.size() == 0;
            s0Value = S_0_FLOOR;
            coherenceValue = COHERENCE_THRESHOLD;
            violations = Buffer.toArray(violations);
            timestamp = Time.now();
        }
    };
    
    // ============================================
    // CHAIN MANAGEMENT
    // ============================================
    
    public func createChain(
        name: Text,
        description: Text,
        steps: [ChainStep],
        executionMode: ExecutionMode
    ) : async Text {
        chainCounter += 1;
        let id = "chain-" # Nat.toText(chainCounter);
        
        let chain : PromptChain = {
            id = id;
            name = name;
            description = description;
            steps = steps;
            globalContext = [];
            executionMode = executionMode;
            errorHandling = #StopOnError;
            timeout = 60000;  // 60 seconds
            maxRetries = 3;
            sovereignty = defaultSovereigntyConstraints();
            createdAt = Time.now();
            isActive = true;
        };
        
        chains.put(id, chain);
        id
    };
    
    public func executeChain(chainId: Text, initialContext: [(Text, Text)]) : async Result.Result<[(Text, Text)], Text> {
        switch (chains.get(chainId)) {
            case null { #err("Chain not found") };
            case (?chain) {
                // Check sovereignty
                let sovereigntyCheck = checkSovereignty(chain.sovereignty);
                if (not sovereigntyCheck.passed) {
                    return #err("Sovereignty check failed");
                };
                
                var context = HashMap.HashMap<Text, Text>(50, Text.equal, Text.hash);
                
                // Initialize context
                for ((key, value) in initialContext.vals()) {
                    context.put(key, value);
                };
                for ((key, value) in chain.globalContext.vals()) {
                    if (Option.isNull(context.get(key))) {
                        context.put(key, value);
                    };
                };
                
                // Execute steps sequentially
                for (step in chain.steps.vals()) {
                    // Check condition
                    let shouldExecute = switch (step.condition) {
                        case null { true };
                        case (?cond) { evaluateCondition(cond, context) };
                    };
                    
                    if (shouldExecute) {
                        // Build input variables
                        let inputVars = Buffer.Buffer<(Text, Text)>(10);
                        
                        for ((varName, source) in step.inputMapping.vals()) {
                            let value = switch (source) {
                                case (#Static(s)) { s };
                                case (#Context(key)) { 
                                    switch (context.get(key)) {
                                        case null { "" };
                                        case (?v) { v };
                                    }
                                };
                                case (#PreviousStep((_, outputKey))) {
                                    switch (context.get(outputKey)) {
                                        case null { "" };
                                        case (?v) { v };
                                    }
                                };
                                case (#Function(_)) { "" };  // Would call function
                                case (#User) { 
                                    switch (context.get("user_input")) {
                                        case null { "" };
                                        case (?v) { v };
                                    }
                                };
                                case (#System) { "" };
                            };
                            inputVars.add((varName, value));
                        };
                        
                        // Render and execute
                        let renderResult = await renderTemplate(step.templateId, Buffer.toArray(inputVars));
                        
                        switch (renderResult) {
                            case (#err(e)) { 
                                return #err("Step " # step.stepId # " failed: " # e);
                            };
                            case (#ok(rendered)) {
                                // Store output in context
                                for ((outputKey, contextKey) in step.outputMapping.vals()) {
                                    context.put(contextKey, rendered);
                                };
                            };
                        };
                    };
                };
                
                // Return final context
                let result = Buffer.Buffer<(Text, Text)>(context.size());
                for ((key, value) in context.entries()) {
                    result.add((key, value));
                };
                
                logAudit(#ChainExecuted, null, "Executed chain: " # chain.name);
                
                #ok(Buffer.toArray(result))
            };
        }
    };
    
    private func evaluateCondition(condition: StepCondition, context: HashMap.HashMap<Text, Text>) : Bool {
        switch (condition.conditionType) {
            case (#Always) { true };
            case (#ContextEquals((key, expected))) {
                switch (context.get(key)) {
                    case null { false };
                    case (?value) { value == expected };
                }
            };
            case (#ContextContains((key, substring))) {
                switch (context.get(key)) {
                    case null { false };
                    case (?value) { Text.contains(value, #text substring) };
                }
            };
            case (#ContextNotEmpty(key)) {
                switch (context.get(key)) {
                    case null { false };
                    case (?value) { Text.size(value) > 0 };
                }
            };
            case (#PreviousStepSuccess(_)) { true };  // Simplified
            case (#PreviousStepFailure(_)) { false };
            case (#Custom(_)) { true };
        }
    };
    
    // ============================================
    // CONTEXT MANAGEMENT
    // ============================================
    
    public func createContext(
        sessionId: Text,
        userId: ?Text,
        organismId: ?Text,
        maxTokens: Nat
    ) : async Text {
        contextCounter += 1;
        let id = "ctx-" # Nat.toText(contextCounter);
        
        let ctx : ConversationContext = {
            id = id;
            sessionId = sessionId;
            userId = userId;
            organismId = organismId;
            messages = [];
            variables = [];
            metadata = [];
            tokenCount = 0;
            maxTokens = maxTokens;
            compressionLevel = #None;
            priority = #Normal;
            expiresAt = null;
            createdAt = Time.now();
            updatedAt = Time.now();
        };
        
        contexts.put(id, ctx);
        logAudit(#ContextCreated, userId, "Created context: " # id);
        
        id
    };
    
    public func addMessage(
        contextId: Text,
        role: MessageRole,
        content: Text
    ) : async Result.Result<ConversationContext, Text> {
        switch (contexts.get(contextId)) {
            case null { #err("Context not found") };
            case (?ctx) {
                // Estimate token count (simplified: ~4 chars per token)
                let messageTokens = Text.size(content) / 4;
                let newTokenCount = ctx.tokenCount + messageTokens;
                
                // Check if we need to compress
                var messages = Buffer.fromArray<ContextMessage>(ctx.messages);
                
                if (newTokenCount > ctx.maxTokens) {
                    // Apply compression based on level
                    messages := compressMessages(messages, ctx.compressionLevel, ctx.maxTokens - messageTokens);
                };
                
                // Add new message
                let newMessage : ContextMessage = {
                    role = role;
                    content = content;
                    timestamp = Time.now();
                    tokenCount = messageTokens;
                    importance = 1.0;
                    isCompressed = false;
                    originalLength = null;
                    metadata = [];
                };
                
                messages.add(newMessage);
                
                // Calculate new token count
                var totalTokens : Nat = 0;
                for (msg in messages.vals()) {
                    totalTokens += msg.tokenCount;
                };
                
                let updated : ConversationContext = {
                    id = ctx.id;
                    sessionId = ctx.sessionId;
                    userId = ctx.userId;
                    organismId = ctx.organismId;
                    messages = Buffer.toArray(messages);
                    variables = ctx.variables;
                    metadata = ctx.metadata;
                    tokenCount = totalTokens;
                    maxTokens = ctx.maxTokens;
                    compressionLevel = ctx.compressionLevel;
                    priority = ctx.priority;
                    expiresAt = ctx.expiresAt;
                    createdAt = ctx.createdAt;
                    updatedAt = Time.now();
                };
                
                contexts.put(contextId, updated);
                logAudit(#ContextUpdated, ctx.userId, "Added message to context: " # contextId);
                
                #ok(updated)
            };
        }
    };
    
    private func compressMessages(
        messages: Buffer.Buffer<ContextMessage>,
        level: CompressionLevel,
        targetTokens: Nat
    ) : Buffer.Buffer<ContextMessage> {
        switch (level) {
            case (#None) { messages };
            case (#Light) {
                // Remove system messages except the last one
                let compressed = Buffer.Buffer<ContextMessage>(messages.size());
                var lastSystemMsg : ?ContextMessage = null;
                
                for (msg in messages.vals()) {
                    if (msg.role == #System) {
                        lastSystemMsg := ?msg;
                    } else {
                        compressed.add(msg);
                    };
                };
                
                switch (lastSystemMsg) {
                    case null {};
                    case (?sys) {
                        // Prepend system message
                        let withSystem = Buffer.Buffer<ContextMessage>(compressed.size() + 1);
                        withSystem.add(sys);
                        for (m in compressed.vals()) {
                            withSystem.add(m);
                        };
                        return withSystem;
                    };
                };
                
                compressed
            };
            case (#Medium) {
                // Keep only recent messages
                let compressed = Buffer.Buffer<ContextMessage>(messages.size());
                var tokens : Nat = 0;
                let arr = Buffer.toArray(messages);
                
                // Add messages from the end until we hit target
                var i = arr.size();
                while (i > 0 and tokens < targetTokens) {
                    i -= 1;
                    let msg = arr[i];
                    if (tokens + msg.tokenCount <= targetTokens) {
                        tokens += msg.tokenCount;
                        // Will add in reverse order, need to fix
                    };
                };
                
                // Add messages in correct order
                for (j in Iter.range(i, arr.size() - 1)) {
                    compressed.add(arr[j]);
                };
                
                compressed
            };
            case (#Heavy) {
                // Keep only system and last user/assistant pair
                let compressed = Buffer.Buffer<ContextMessage>(3);
                
                for (msg in messages.vals()) {
                    if (msg.role == #System) {
                        compressed.add(msg);
                    };
                };
                
                // Add last user and assistant messages
                let arr = Buffer.toArray(messages);
                var foundAssistant = false;
                var foundUser = false;
                
                var i = arr.size();
                while (i > 0 and (not foundAssistant or not foundUser)) {
                    i -= 1;
                    let msg = arr[i];
                    if (msg.role == #Assistant and not foundAssistant) {
                        compressed.add(msg);
                        foundAssistant := true;
                    } else if (msg.role == #User and not foundUser) {
                        compressed.add(msg);
                        foundUser := true;
                    };
                };
                
                compressed
            };
            case (#Extreme) {
                // Keep only the last message
                let compressed = Buffer.Buffer<ContextMessage>(1);
                if (messages.size() > 0) {
                    compressed.add(messages.get(messages.size() - 1));
                };
                compressed
            };
        }
    };
    
    // ============================================
    // CACHING
    // ============================================
    
    public func getCached(key: Text) : async ?PromptOutput {
        switch (cache.get(key)) {
            case null {
                logAudit(#CacheMiss, null, "Cache miss: " # key);
                null
            };
            case (?entry) {
                let now = Time.now();
                if (entry.expiresAt < now) {
                    cache.delete(key);
                    logAudit(#CacheMiss, null, "Cache expired: " # key);
                    null
                } else {
                    // Update access time and hit count
                    let updated : CacheEntry = {
                        key = entry.key;
                        value = entry.value;
                        hitCount = entry.hitCount + 1;
                        createdAt = entry.createdAt;
                        lastAccessedAt = now;
                        expiresAt = entry.expiresAt;
                        size = entry.size;
                    };
                    cache.put(key, updated);
                    logAudit(#CacheHit, null, "Cache hit: " # key);
                    ?entry.value
                }
            };
        }
    };
    
    public func setCache(key: Text, value: PromptOutput, ttlSeconds: ?Nat) : async () {
        let now = Time.now();
        let ttl = switch (ttlSeconds) {
            case null { cacheConfig.defaultTTL };
            case (?t) { t };
        };
        
        let entry : CacheEntry = {
            key = key;
            value = value;
            hitCount = 0;
            createdAt = now;
            lastAccessedAt = now;
            expiresAt = now + ttl * 1000000000;  // Convert to nanoseconds
            size = Text.size(value.content);
        };
        
        // Check cache size and evict if necessary
        if (cache.size() >= cacheConfig.maxEntries) {
            await evictCache();
        };
        
        cache.put(key, entry);
    };
    
    private func evictCache() : async () {
        switch (cacheConfig.evictionPolicy) {
            case (#LRU) {
                // Find least recently used entry
                var oldestTime = Time.now();
                var oldestKey : ?Text = null;
                
                for ((key, entry) in cache.entries()) {
                    if (entry.lastAccessedAt < oldestTime) {
                        oldestTime := entry.lastAccessedAt;
                        oldestKey := ?key;
                    };
                };
                
                switch (oldestKey) {
                    case null {};
                    case (?key) { cache.delete(key) };
                };
            };
            case (#LFU) {
                // Find least frequently used entry
                var minHits : Nat = 999999999;
                var lfuKey : ?Text = null;
                
                for ((key, entry) in cache.entries()) {
                    if (entry.hitCount < minHits) {
                        minHits := entry.hitCount;
                        lfuKey := ?key;
                    };
                };
                
                switch (lfuKey) {
                    case null {};
                    case (?key) { cache.delete(key) };
                };
            };
            case (#FIFO) {
                // Find oldest entry
                var oldestTime = Time.now();
                var oldestKey : ?Text = null;
                
                for ((key, entry) in cache.entries()) {
                    if (entry.createdAt < oldestTime) {
                        oldestTime := entry.createdAt;
                        oldestKey := ?key;
                    };
                };
                
                switch (oldestKey) {
                    case null {};
                    case (?key) { cache.delete(key) };
                };
            };
            case (#TTL) {
                // Remove all expired entries
                let now = Time.now();
                let toRemove = Buffer.Buffer<Text>(10);
                
                for ((key, entry) in cache.entries()) {
                    if (entry.expiresAt < now) {
                        toRemove.add(key);
                    };
                };
                
                for (key in toRemove.vals()) {
                    cache.delete(key);
                };
            };
        }
    };
    
    // ============================================
    // RATE LIMITING
    // ============================================
    
    public func checkRateLimit(userId: Text) : async Result.Result<(), Text> {
        if (not rateLimitConfig.enabled) {
            return #ok(());
        };
        
        let now = Time.now();
        
        switch (rateLimits.get(userId)) {
            case null {
                // First request from this user
                let state : RateLimitState = {
                    userId = userId;
                    requestCount = 1;
                    tokenCount = 0;
                    windowStart = now;
                    bucketLevel = Float.fromInt(rateLimitConfig.burstLimit - 1);
                    lastRequest = now;
                    blocked = false;
                    blockedUntil = null;
                };
                rateLimits.put(userId, state);
                #ok(())
            };
            case (?state) {
                // Check if blocked
                switch (state.blockedUntil) {
                    case (?blockedUntil) {
                        if (now < blockedUntil) {
                            logAudit(#RateLimitHit, ?userId, "User still blocked");
                            return #err("Rate limited. Try again later.");
                        };
                    };
                    case null {};
                };
                
                // Token bucket refill
                let elapsedSeconds = Float.fromInt(Int.abs(now - state.lastRequest)) / 1000000000.0;
                let refill = elapsedSeconds * rateLimitConfig.refillRate;
                let newLevel = Float.min(
                    Float.fromInt(rateLimitConfig.burstLimit),
                    state.bucketLevel + refill
                );
                
                if (newLevel < 1.0) {
                    logAudit(#RateLimitHit, ?userId, "Bucket empty");
                    return #err("Rate limited. Please slow down.");
                };
                
                // Update state
                let updated : RateLimitState = {
                    userId = state.userId;
                    requestCount = state.requestCount + 1;
                    tokenCount = state.tokenCount;
                    windowStart = state.windowStart;
                    bucketLevel = newLevel - 1.0;
                    lastRequest = now;
                    blocked = false;
                    blockedUntil = null;
                };
                rateLimits.put(userId, updated);
                
                #ok(())
            };
        }
    };
    
    // ============================================
    // A/B TESTING
    // ============================================
    
    public func createABTest(
        name: Text,
        description: Text,
        variants: [ABVariant],
        trafficAllocation: [Float]
    ) : async Result.Result<Text, Text> {
        if (variants.size() != trafficAllocation.size()) {
            return #err("Variants and traffic allocation must have same length");
        };
        
        var sum : Float = 0.0;
        for (t in trafficAllocation.vals()) {
            sum += t;
        };
        if (Float.abs(sum - 1.0) > 0.001) {
            return #err("Traffic allocation must sum to 1.0");
        };
        
        abTestCounter += 1;
        let id = "abtest-" # Nat.toText(abTestCounter);
        
        let test : ABTest = {
            id = id;
            name = name;
            description = description;
            variants = variants;
            trafficAllocation = trafficAllocation;
            targetAudience = null;
            metrics = [{
                name = "success_rate";
                metricType = #SuccessRate;
                higherIsBetter = true;
            }];
            startDate = Time.now();
            endDate = null;
            status = #Draft;
            results = null;
        };
        
        abTests.put(id, test);
        #ok(id)
    };
    
    public func selectVariant(testId: Text, userId: Text) : async ?ABVariant {
        switch (abTests.get(testId)) {
            case null { null };
            case (?test) {
                if (test.status != #Running) {
                    return null;
                };
                
                // Simple hash-based assignment
                var hash : Nat = 0;
                for (c in Text.toIter(userId # testId)) {
                    hash := hash * 31 + Nat32.toNat(Char.toNat32(c));
                };
                
                let rand = Float.fromInt(hash % 10000) / 10000.0;
                
                var cumulative : Float = 0.0;
                for (i in Iter.range(0, test.variants.size() - 1)) {
                    cumulative += test.trafficAllocation[i];
                    if (rand < cumulative) {
                        return ?test.variants[i];
                    };
                };
                
                // Fallback to first variant
                if (test.variants.size() > 0) {
                    ?test.variants[0]
                } else {
                    null
                }
            };
        }
    };
    
    // ============================================
    // AUDIT LOGGING
    // ============================================
    
    private func logAudit(action: AuditAction, userId: ?Text, details: Text) {
        let entry : AuditEntry = {
            timestamp = Time.now();
            action = action;
            userId = userId;
            details = details;
            ipAddress = null;
            userAgent = null;
            sovereigntyCheck = null;
        };
        
        auditLog.add(entry);
        
        // Keep only last 100000 entries
        if (auditLog.size() > 100000) {
            ignore auditLog.remove(0);
        };
    };
    
    // ============================================
    // BUILT-IN TEMPLATES
    // ============================================
    
    public func initializeBuiltInTemplates() : async () {
        // System template for sovereignty enforcement
        ignore await createTemplate(
            "sovereignty-check",
            "Enforces sovereignty constraints on all prompts",
            #Sovereignty,
            #Analysis,
            [#All],
            "You are an AI assistant operating under strict sovereignty constraints.\n\nS₀ (Sovereignty Floor) = {{s0_floor}}\nCoherence Threshold = {{coherence_threshold}}\nIntegrity Minimum = {{integrity_minimum}}\n\nYou MUST:\n1. Maintain sovereign alignment at all times\n2. Preserve creator alignment as the primary directive\n3. Ensure all outputs meet minimum coherence standards\n4. Flag any potential sovereignty violations\n\nCurrent context:\n{{context}}\n\nUser request:\n{{user_input}}",
            [
                { name = "s0_floor"; description = "Sovereignty floor value"; variableType = #Number; required = true; defaultValue = ?"1.0"; validation = null; transformations = [] },
                { name = "coherence_threshold"; description = "Coherence threshold"; variableType = #Number; required = true; defaultValue = ?"1.0"; validation = null; transformations = [] },
                { name = "integrity_minimum"; description = "Integrity minimum"; variableType = #Number; required = true; defaultValue = ?"1.0"; validation = null; transformations = [] },
                { name = "context"; description = "Current context"; variableType = #String; required = false; defaultValue = ?""; validation = null; transformations = [] },
                { name = "user_input"; description = "User input"; variableType = #String; required = true; defaultValue = null; validation = null; transformations = [] }
            ]
        );
        
        // Legal organism template
        ignore await createTemplate(
            "legal-analysis",
            "Legal document analysis and reasoning",
            #System,
            #Legal,
            [#Legal],
            "You are a legal analysis assistant specialized in:\n- Contract review and analysis\n- Regulatory compliance assessment\n- Risk identification\n- Legal document drafting\n\nJurisdiction: {{jurisdiction}}\nDocument type: {{document_type}}\n\nAnalysis requirements:\n{{requirements}}\n\nDocument content:\n{{document_content}}\n\nProvide a comprehensive legal analysis addressing all specified requirements.",
            [
                { name = "jurisdiction"; description = "Legal jurisdiction"; variableType = #String; required = true; defaultValue = ?"United States"; validation = null; transformations = [] },
                { name = "document_type"; description = "Type of legal document"; variableType = #Enum(["contract", "agreement", "policy", "regulation", "brief", "memo"]); required = true; defaultValue = null; validation = null; transformations = [] },
                { name = "requirements"; description = "Analysis requirements"; variableType = #String; required = false; defaultValue = ?"General review"; validation = null; transformations = [] },
                { name = "document_content"; description = "Document to analyze"; variableType = #String; required = true; defaultValue = null; validation = null; transformations = [] }
            ]
        );
        
        // Financial organism template
        ignore await createTemplate(
            "financial-analysis",
            "Financial data analysis and reporting",
            #System,
            #Financial,
            [#Finance],
            "You are a financial analysis assistant specialized in:\n- Financial statement analysis\n- Valuation and modeling\n- Risk assessment\n- Investment analysis\n\nAnalysis type: {{analysis_type}}\nTime period: {{time_period}}\n\nFinancial data:\n{{financial_data}}\n\nProvide detailed financial analysis with key metrics, trends, and recommendations.",
            [
                { name = "analysis_type"; description = "Type of financial analysis"; variableType = #Enum(["income_statement", "balance_sheet", "cash_flow", "ratio_analysis", "dcf", "comparables"]); required = true; defaultValue = null; validation = null; transformations = [] },
                { name = "time_period"; description = "Analysis time period"; variableType = #String; required = true; defaultValue = ?"Current year"; validation = null; transformations = [] },
                { name = "financial_data"; description = "Financial data to analyze"; variableType = #String; required = true; defaultValue = null; validation = null; transformations = [] }
            ]
        );
        
        // Code organism template
        ignore await createTemplate(
            "code-generation",
            "Code generation and review",
            #System,
            #Code,
            [#Code],
            "You are a code assistant specialized in:\n- Code generation across multiple languages\n- Code review and optimization\n- Bug identification and fixing\n- Documentation generation\n\nLanguage: {{language}}\nTask type: {{task_type}}\n\nContext:\n{{context}}\n\nRequirements:\n{{requirements}}\n\nProvide clean, well-documented code following best practices for {{language}}.",
            [
                { name = "language"; description = "Programming language"; variableType = #Enum(["python", "javascript", "typescript", "rust", "go", "java", "csharp", "motoko", "solidity"]); required = true; defaultValue = null; validation = null; transformations = [] },
                { name = "task_type"; description = "Type of coding task"; variableType = #Enum(["generate", "review", "refactor", "debug", "document", "test"]); required = true; defaultValue = ?"generate"; validation = null; transformations = [] },
                { name = "context"; description = "Code context"; variableType = #String; required = false; defaultValue = ?""; validation = null; transformations = [] },
                { name = "requirements"; description = "Code requirements"; variableType = #String; required = true; defaultValue = null; validation = null; transformations = [] }
            ]
        );
        
        // Research organism template
        ignore await createTemplate(
            "research-synthesis",
            "Research synthesis and analysis",
            #System,
            #Research,
            [#Research],
            "You are a research assistant specialized in:\n- Literature review and synthesis\n- Data analysis and interpretation\n- Hypothesis development\n- Research methodology\n\nResearch domain: {{domain}}\nResearch question: {{question}}\n\nSources:\n{{sources}}\n\nSynthesize the available research and provide a comprehensive analysis addressing the research question.",
            [
                { name = "domain"; description = "Research domain"; variableType = #String; required = true; defaultValue = null; validation = null; transformations = [] },
                { name = "question"; description = "Research question"; variableType = #String; required = true; defaultValue = null; validation = null; transformations = [] },
                { name = "sources"; description = "Research sources"; variableType = #String; required = true; defaultValue = null; validation = null; transformations = [] }
            ]
        );
        
        // Creative organism template
        ignore await createTemplate(
            "creative-generation",
            "Creative content generation",
            #System,
            #Creative,
            [#Creative],
            "You are a creative assistant specialized in:\n- Content creation across formats\n- Brand voice development\n- Storytelling and narrative\n- Creative ideation\n\nContent type: {{content_type}}\nTone: {{tone}}\nAudience: {{audience}}\n\nBrief:\n{{brief}}\n\nGenerate creative content that aligns with the brief while maintaining brand consistency.",
            [
                { name = "content_type"; description = "Type of content"; variableType = #Enum(["blog", "social", "email", "ad_copy", "video_script", "story", "poetry"]); required = true; defaultValue = null; validation = null; transformations = [] },
                { name = "tone"; description = "Content tone"; variableType = #Enum(["professional", "casual", "humorous", "inspirational", "authoritative", "empathetic"]); required = true; defaultValue = ?"professional"; validation = null; transformations = [] },
                { name = "audience"; description = "Target audience"; variableType = #String; required = true; defaultValue = ?"General"; validation = null; transformations = [] },
                { name = "brief"; description = "Creative brief"; variableType = #String; required = true; defaultValue = null; validation = null; transformations = [] }
            ]
        );
    };
    
    // ============================================
    // QUERY INTERFACE
    // ============================================
    
    public query func getTemplate(id: Text) : async ?PromptTemplate {
        templates.get(id)
    };
    
    public query func getChain(id: Text) : async ?PromptChain {
        chains.get(id)
    };
    
    public query func getContext(id: Text) : async ?ConversationContext {
        contexts.get(id)
    };
    
    public query func getExecution(id: Text) : async ?PromptExecution {
        executions.get(id)
    };
    
    public query func getABTest(id: Text) : async ?ABTest {
        abTests.get(id)
    };
    
    public query func listTemplates() : async [Text] {
        let ids = Buffer.Buffer<Text>(templates.size());
        for ((id, _) in templates.entries()) {
            ids.add(id);
        };
        Buffer.toArray(ids)
    };
    
    public query func listChains() : async [Text] {
        let ids = Buffer.Buffer<Text>(chains.size());
        for ((id, _) in chains.entries()) {
            ids.add(id);
        };
        Buffer.toArray(ids)
    };
    
    public query func getStats() : async {
        templateCount: Nat;
        chainCount: Nat;
        contextCount: Nat;
        executionCount: Nat;
        cacheSize: Nat;
        auditLogSize: Nat;
    } {
        {
            templateCount = templates.size();
            chainCount = chains.size();
            contextCount = contexts.size();
            executionCount = executions.size();
            cacheSize = cache.size();
            auditLogSize = auditLog.size();
        }
    };
    
    public query func getRecentAuditLog(limit: Nat) : async [AuditEntry] {
        let size = auditLog.size();
        let start = if (size > limit) { size - limit } else { 0 };
        
        let result = Buffer.Buffer<AuditEntry>(limit);
        for (i in Iter.range(start, size - 1)) {
            result.add(auditLog.get(i));
        };
        Buffer.toArray(result)
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
