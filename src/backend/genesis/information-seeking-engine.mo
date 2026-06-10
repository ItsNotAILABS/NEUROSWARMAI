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
import Blob "mo:core/Blob";
import Time "mo:core/Time";
import Option "mo:core/Option";
import Result "mo:core/Result";
import HashMap "mo:core/HashMap";
import Hash "mo:core/Hash";
import Principal "mo:core/Principal";

module InformationSeekingEngine {

  // ═══════════════════════════════════════════════════════════════════════════════
  // CONSTANTS — The metabolism of information
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let PI : Float = 3.14159265358979323846;
  public let E : Float = 2.71828182845904523536;
  
  // Information metabolism constants
  public let BASE_HUNGER : Float = 0.5;           // Base information hunger
  public let SATIATION_DECAY : Float = 0.02;      // How fast satiation decreases
  public let NUTRIENT_ABSORPTION : Float = 0.7;   // Efficiency of knowledge absorption
  public let WASTE_THRESHOLD : Float = 0.1;       // Below this relevance, discard
  public let METABOLIC_RATE : Float = 1.0;        // Base processing speed
  
  // Curiosity drive parameters
  public let CURIOSITY_BASELINE : Float = 0.6;
  public let NOVELTY_BOOST : Float = 0.3;
  public let BOREDOM_RATE : Float = 0.01;
  
  // HTTP outcall limits
  public let MAX_RESPONSE_BYTES : Nat64 = 2_000_000;
  public let OUTCALL_TIMEOUT_NS : Nat64 = 30_000_000_000;  // 30 seconds

  // ═══════════════════════════════════════════════════════════════════════════════
  // INFORMATION TYPES — What the organism can consume
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type InformationType = {
    #Workflow;          // Business process information
    #Technical;         // Technical/programming knowledge
    #Financial;         // Market/economic data
    #Social;            // Social/relational information
    #Scientific;        // Research/scientific data
    #Temporal;          // Time-based/news information
    #Spatial;           // Location/geographic data
    #Procedural;        // How-to/instructional
    #Declarative;       // Facts/assertions
    #Episodic;          // Events/experiences
    #Semantic;          // Meaning/concepts
    #Metacognitive;     // Knowledge about knowledge
  };
  
  public type InformationSource = {
    #API : Text;                    // REST/GraphQL API endpoint
    #RSS : Text;                    // RSS feed URL
    #WebPage : Text;                // Web scraping target
    #Database : Text;               // Database connection
    #Stream : Text;                 // Real-time data stream
    #File : Text;                   // File system path
    #Internal : Text;               // Internal knowledge base
    #PeerOrganism : Principal;      // Another organism
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // RAW INFORMATION — Unprocessed data from sources
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type RawInformation = {
    id : Nat;
    source : InformationSource;
    infoType : InformationType;
    content : Blob;
    contentType : Text;           // MIME type
    fetchedAt : Int;              // Timestamp
    byteSize : Nat;
    checksum : Nat32;             // For deduplication
    metadata : [(Text, Text)];    // Key-value metadata
  };
  
  public type InformationRequest = {
    id : Nat;
    query : Text;
    targetTypes : [InformationType];
    sources : [InformationSource];
    priority : Float;             // 0-1, higher = more urgent
    deadline : ?Int;              // Optional deadline
    requester : Text;             // Which subsystem requested
    context : Text;               // Why this info is needed
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // DIGESTED INFORMATION — Processed, usable knowledge
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type DigestedKnowledge = {
    id : Nat;
    sourceId : Nat;               // Link to raw info
    infoType : InformationType;
    summary : Text;               // Condensed content
    keyFacts : [Text];            // Extracted facts
    entities : [Entity];          // Named entities
    relations : [Relation];       // Entity relationships
    confidence : Float;           // Extraction confidence
    relevance : Float;            // To organism's goals
    novelty : Float;              // How new is this?
    actionability : Float;        // Can we act on it?
    timestamp : Int;
    decayRate : Float;            // How fast it becomes stale
  };
  
  public type Entity = {
    name : Text;
    entityType : Text;            // Person, Org, Place, etc.
    attributes : [(Text, Text)];
    confidence : Float;
  };
  
  public type Relation = {
    subject : Text;
    predicate : Text;
    object : Text;
    confidence : Float;
    source : Text;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // HUNGER STATE — The drive to seek information
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type HungerState = {
    overallHunger : Float;        // Total information hunger [0, 1]
    domainHungers : [Float];      // Hunger per InformationType (12 domains)
    lastFed : Int;                // Beat when last consumed info
    satiation : Float;            // Current fullness [0, 1]
    metabolicRate : Float;        // Current processing speed
    curiosityLevel : Float;       // Active curiosity drive
    boredomLevel : Float;         // Accumulated boredom
    seekingUrgency : Float;       // How urgently seeking
  };
  
  public func initHungerState() : HungerState {
    {
      overallHunger = BASE_HUNGER;
      domainHungers = Array.freeze(Array.init<Float>(12, func(_ : Nat) : Float { 0.5 }));
      lastFed = 0;
      satiation = 0.5;
      metabolicRate = METABOLIC_RATE;
      curiosityLevel = CURIOSITY_BASELINE;
      boredomLevel = 0.0;
      seekingUrgency = 0.3;
    }
  };
  
  // Update hunger based on time and activity
  public func updateHunger(
    state : HungerState,
    currentBeat : Int,
    recentNovelty : Float,
    recentSatiation : Float
  ) : HungerState {
    let beatsSinceLastFed = Int.abs(currentBeat - state.lastFed);
    let timeFactor = Float.fromInt(beatsSinceLastFed) / 1000.0;
    
    // Hunger increases with time
    let newOverallHunger = clamp(
      state.overallHunger + SATIATION_DECAY * timeFactor - recentSatiation * 0.5,
      0.1, 1.0
    );
    
    // Curiosity affected by novelty
    let newCuriosity = clamp(
      state.curiosityLevel + NOVELTY_BOOST * recentNovelty - BOREDOM_RATE,
      0.2, 1.0
    );
    
    // Boredom increases without novelty
    let newBoredom = clamp(
      state.boredomLevel + BOREDOM_RATE - recentNovelty * 0.5,
      0.0, 1.0
    );
    
    // Urgency = hunger × curiosity × (1 + boredom)
    let newUrgency = newOverallHunger * newCuriosity * (1.0 + newBoredom * 0.5);
    
    {
      overallHunger = newOverallHunger;
      domainHungers = state.domainHungers;
      lastFed = state.lastFed;
      satiation = clamp(state.satiation - SATIATION_DECAY, 0.0, 1.0);
      metabolicRate = state.metabolicRate;
      curiosityLevel = newCuriosity;
      boredomLevel = newBoredom;
      seekingUrgency = clamp(newUrgency, 0.0, 1.0);
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // INFORMATION VALUATION — What's worth knowing?
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type ValuationCriteria = {
    relevanceWeight : Float;      // How aligned with current goals
    noveltyWeight : Float;        // How new/surprising
    actionabilityWeight : Float;  // How actionable
    trustWeight : Float;          // Source trustworthiness
    freshnessWeight : Float;      // How recent
    costWeight : Float;           // Cost to acquire (negative)
  };
  
  public let DEFAULT_VALUATION : ValuationCriteria = {
    relevanceWeight = 0.30;
    noveltyWeight = 0.25;
    actionabilityWeight = 0.20;
    trustWeight = 0.15;
    freshnessWeight = 0.10;
    costWeight = -0.05;
  };
  
  public func computeInformationValue(
    knowledge : DigestedKnowledge,
    criteria : ValuationCriteria,
    currentGoals : [Text],
    currentBeat : Int
  ) : Float {
    // Relevance: Does it align with current goals?
    let relevanceScore = knowledge.relevance;
    
    // Novelty: Is it new information?
    let noveltyScore = knowledge.novelty;
    
    // Actionability: Can we do something with it?
    let actionabilityScore = knowledge.actionability;
    
    // Trust: How confident are we in the source?
    let trustScore = knowledge.confidence;
    
    // Freshness: How recent is it?
    let age = Float.fromInt(Int.abs(currentBeat - knowledge.timestamp));
    let freshnessScore = exp(-age * knowledge.decayRate / 1000.0);
    
    // Cost: Already digested, so cost is 0
    let costScore = 0.0;
    
    // Weighted sum
    criteria.relevanceWeight * relevanceScore +
    criteria.noveltyWeight * noveltyScore +
    criteria.actionabilityWeight * actionabilityScore +
    criteria.trustWeight * trustScore +
    criteria.freshnessWeight * freshnessScore +
    criteria.costWeight * costScore
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SEEKING STRATEGY — How to hunt for information
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type SeekingStrategy = {
    #Exploratory;       // Cast wide net, maximize novelty
    #Exploitative;      // Deep dive on known valuable areas
    #Balanced;          // Mix of exploration and exploitation
    #Urgent;            // Fast, focused on immediate needs
    #Background;        // Low-priority, opportunistic
  };
  
  public type SeekingPlan = {
    strategy : SeekingStrategy;
    targetDomains : [InformationType];
    targetSources : [InformationSource];
    queries : [Text];
    maxItems : Nat;
    timeoutBeats : Nat;
    parallelRequests : Nat;
    retryPolicy : RetryPolicy;
  };
  
  public type RetryPolicy = {
    maxRetries : Nat;
    backoffMultiplier : Float;
    initialDelayMs : Nat;
  };
  
  public func generateSeekingPlan(
    hunger : HungerState,
    goals : [Text],
    availableSources : [InformationSource],
    constraints : SeekingConstraints
  ) : SeekingPlan {
    // Choose strategy based on urgency and boredom
    let strategy = if (hunger.seekingUrgency > 0.8) {
      #Urgent
    } else if (hunger.boredomLevel > 0.6) {
      #Exploratory
    } else if (hunger.curiosityLevel > 0.7) {
      #Balanced
    } else {
      #Exploitative
    };
    
    // Identify hungriest domains
    let domainHungers = hunger.domainHungers;
    let sortedDomains = sortByHunger(domainHungers);
    let topDomains = Array.subArray<Nat>(sortedDomains, 0, 3);
    
    // Map domain indices to types
    let targetDomains = Array.map<Nat, InformationType>(topDomains, func(i : Nat) : InformationType {
      indexToInfoType(i)
    });
    
    // Generate queries from goals
    let queries = Array.map<Text, Text>(goals, func(g : Text) : Text {
      g  // In real implementation, would expand/refine queries
    });
    
    {
      strategy = strategy;
      targetDomains = targetDomains;
      targetSources = availableSources;
      queries = queries;
      maxItems = constraints.maxItems;
      timeoutBeats = constraints.timeoutBeats;
      parallelRequests = constraints.parallelRequests;
      retryPolicy = { maxRetries = 3; backoffMultiplier = 2.0; initialDelayMs = 100 };
    }
  };
  
  public type SeekingConstraints = {
    maxItems : Nat;
    timeoutBeats : Nat;
    parallelRequests : Nat;
    maxBytesPerRequest : Nat;
    allowedDomains : [Text];
    blockedDomains : [Text];
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // HTTP OUTCALL TYPES — For reaching external information
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type HttpMethod = {
    #GET;
    #POST;
    #PUT;
    #DELETE;
    #HEAD;
    #OPTIONS;
  };
  
  public type HttpHeader = {
    name : Text;
    value : Text;
  };
  
  public type HttpRequest = {
    url : Text;
    method : HttpMethod;
    headers : [HttpHeader];
    body : ?Blob;
    transform : ?TransformContext;
  };
  
  public type HttpResponse = {
    status : Nat;
    headers : [HttpHeader];
    body : Blob;
  };
  
  public type TransformContext = {
    function : Text;
    context : Blob;
  };
  
  public type OutcallResult = {
    #Success : HttpResponse;
    #Timeout;
    #Error : Text;
    #RateLimited : Nat;  // Retry after N seconds
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // KNOWLEDGE SOURCES — Where to seek information
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type KnowledgeSourceConfig = {
    id : Text;
    name : Text;
    sourceType : InformationSource;
    baseUrl : Text;
    authType : AuthType;
    rateLimit : RateLimit;
    domains : [InformationType];
    trustScore : Float;
    lastAccessed : Int;
    failureCount : Nat;
    successCount : Nat;
  };
  
  public type AuthType = {
    #None;
    #ApiKey : Text;
    #Bearer : Text;
    #Basic : { username : Text; password : Text };
    #OAuth2 : OAuth2Config;
  };
  
  public type OAuth2Config = {
    clientId : Text;
    clientSecret : Text;
    tokenUrl : Text;
    scopes : [Text];
  };
  
  public type RateLimit = {
    requestsPerMinute : Nat;
    requestsPerHour : Nat;
    requestsPerDay : Nat;
    currentMinuteCount : Nat;
    currentHourCount : Nat;
    currentDayCount : Nat;
    lastReset : Int;
  };
  
  // Pre-configured knowledge sources
  public let KNOWLEDGE_SOURCES : [KnowledgeSourceConfig] = [
    // Workflow/Business
    {
      id = "workflow_api";
      name = "Workflow Knowledge API";
      sourceType = #API("https://api.workflow.example.com");
      baseUrl = "https://api.workflow.example.com/v1";
      authType = #None;
      rateLimit = { requestsPerMinute = 60; requestsPerHour = 1000; requestsPerDay = 10000; currentMinuteCount = 0; currentHourCount = 0; currentDayCount = 0; lastReset = 0 };
      domains = [#Workflow, #Procedural];
      trustScore = 0.9;
      lastAccessed = 0;
      failureCount = 0;
      successCount = 0;
    },
    // Technical/Programming
    {
      id = "tech_docs";
      name = "Technical Documentation";
      sourceType = #API("https://api.tech-docs.example.com");
      baseUrl = "https://api.tech-docs.example.com/v1";
      authType = #None;
      rateLimit = { requestsPerMinute = 100; requestsPerHour = 2000; requestsPerDay = 20000; currentMinuteCount = 0; currentHourCount = 0; currentDayCount = 0; lastReset = 0 };
      domains = [#Technical, #Procedural];
      trustScore = 0.85;
      lastAccessed = 0;
      failureCount = 0;
      successCount = 0;
    },
    // Financial/Market
    {
      id = "market_data";
      name = "Market Data Feed";
      sourceType = #Stream("wss://stream.market.example.com");
      baseUrl = "https://api.market.example.com/v1";
      authType = #ApiKey("MARKET_API_KEY");
      rateLimit = { requestsPerMinute = 120; requestsPerHour = 5000; requestsPerDay = 50000; currentMinuteCount = 0; currentHourCount = 0; currentDayCount = 0; lastReset = 0 };
      domains = [#Financial, #Temporal];
      trustScore = 0.95;
      lastAccessed = 0;
      failureCount = 0;
      successCount = 0;
    },
    // News/Temporal
    {
      id = "news_feed";
      name = "News Aggregator";
      sourceType = #RSS("https://news.example.com/feed.rss");
      baseUrl = "https://api.news.example.com/v1";
      authType = #None;
      rateLimit = { requestsPerMinute = 30; requestsPerHour = 500; requestsPerDay = 5000; currentMinuteCount = 0; currentHourCount = 0; currentDayCount = 0; lastReset = 0 };
      domains = [#Temporal, #Social];
      trustScore = 0.7;
      lastAccessed = 0;
      failureCount = 0;
      successCount = 0;
    },
    // Scientific/Research
    {
      id = "research_db";
      name = "Scientific Research Database";
      sourceType = #API("https://api.research.example.com");
      baseUrl = "https://api.research.example.com/v1";
      authType = #None;
      rateLimit = { requestsPerMinute = 20; requestsPerHour = 200; requestsPerDay = 2000; currentMinuteCount = 0; currentHourCount = 0; currentDayCount = 0; lastReset = 0 };
      domains = [#Scientific, #Technical];
      trustScore = 0.95;
      lastAccessed = 0;
      failureCount = 0;
      successCount = 0;
    },
  ];

  // ═══════════════════════════════════════════════════════════════════════════════
  // DIGESTION ENGINE — Processing raw information
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type DigestionState = {
    stomachContents : [RawInformation];   // Pending digestion
    stomachCapacity : Nat;                 // Max items in stomach
    digestiveEnzymes : [DigestiveEnzyme];  // Processing functions
    absorptionRate : Float;                // How efficiently we absorb
    wasteBuffer : [RawInformation];        // Rejected information
  };
  
  public type DigestiveEnzyme = {
    name : Text;
    targetTypes : [InformationType];
    extractionFunction : Text;     // Name of extraction function
    efficiency : Float;
    lastUsed : Int;
  };
  
  public func initDigestionState() : DigestionState {
    {
      stomachContents = [];
      stomachCapacity = 100;
      digestiveEnzymes = [
        { name = "TextExtractor"; targetTypes = [#Declarative, #Semantic]; extractionFunction = "extractText"; efficiency = 0.9; lastUsed = 0 },
        { name = "EntityRecognizer"; targetTypes = [#Social, #Financial]; extractionFunction = "extractEntities"; efficiency = 0.85; lastUsed = 0 },
        { name = "RelationMapper"; targetTypes = [#Workflow, #Procedural]; extractionFunction = "extractRelations"; efficiency = 0.8; lastUsed = 0 },
        { name = "FactExtractor"; targetTypes = [#Scientific, #Technical]; extractionFunction = "extractFacts"; efficiency = 0.9; lastUsed = 0 },
        { name = "TemporalParser"; targetTypes = [#Temporal, #Episodic]; extractionFunction = "extractTemporal"; efficiency = 0.85; lastUsed = 0 },
        { name = "SpatialParser"; targetTypes = [#Spatial]; extractionFunction = "extractSpatial"; efficiency = 0.8; lastUsed = 0 },
      ];
      absorptionRate = NUTRIENT_ABSORPTION;
      wasteBuffer = [];
    }
  };
  
  // Digest a single piece of raw information
  public func digestInformation(
    raw : RawInformation,
    enzymes : [DigestiveEnzyme],
    currentBeat : Int,
    goals : [Text]
  ) : ?DigestedKnowledge {
    // Find appropriate enzyme
    var bestEnzyme : ?DigestiveEnzyme = null;
    var bestEfficiency : Float = 0.0;
    
    for (enzyme in enzymes.vals()) {
      for (targetType in enzyme.targetTypes.vals()) {
        if (sameInfoType(targetType, raw.infoType) and enzyme.efficiency > bestEfficiency) {
          bestEnzyme := ?enzyme;
          bestEfficiency := enzyme.efficiency;
        };
      };
    };
    
    switch (bestEnzyme) {
      case null { null };  // Can't digest this type
      case (?enzyme) {
        // Extract key information (simplified)
        let summary = "Processed content from " # sourceToText(raw.source);
        let keyFacts = ["Fact extracted from raw data"];
        
        // Compute metrics
        let novelty = computeNovelty(raw.checksum, currentBeat);
        let relevance = computeRelevance(raw.infoType, goals);
        let actionability = computeActionability(raw.infoType);
        
        // Apply efficiency
        let confidence = enzyme.efficiency * 0.9;
        
        ?{
          id = raw.id;
          sourceId = raw.id;
          infoType = raw.infoType;
          summary = summary;
          keyFacts = keyFacts;
          entities = [];
          relations = [];
          confidence = confidence;
          relevance = relevance;
          novelty = novelty;
          actionability = actionability;
          timestamp = currentBeat;
          decayRate = getDecayRate(raw.infoType);
        }
      };
    }
  };
  
  // Batch digestion
  public func digestBatch(
    state : DigestionState,
    currentBeat : Int,
    goals : [Text],
    maxItems : Nat
  ) : { digested : [DigestedKnowledge]; waste : [RawInformation]; newState : DigestionState } {
    let digestedBuffer = Buffer.Buffer<DigestedKnowledge>(maxItems);
    let wasteBuffer = Buffer.Buffer<RawInformation>(maxItems);
    let remainingBuffer = Buffer.Buffer<RawInformation>(state.stomachContents.size());
    
    var processed : Nat = 0;
    
    for (raw in state.stomachContents.vals()) {
      if (processed < maxItems) {
        switch (digestInformation(raw, state.digestiveEnzymes, currentBeat, goals)) {
          case (?digested) {
            if (digested.relevance >= WASTE_THRESHOLD) {
              digestedBuffer.add(digested);
            } else {
              wasteBuffer.add(raw);
            };
          };
          case null {
            wasteBuffer.add(raw);  // Can't digest
          };
        };
        processed += 1;
      } else {
        remainingBuffer.add(raw);
      };
    };
    
    {
      digested = Buffer.toArray(digestedBuffer);
      waste = Buffer.toArray(wasteBuffer);
      newState = {
        stomachContents = Buffer.toArray(remainingBuffer);
        stomachCapacity = state.stomachCapacity;
        digestiveEnzymes = state.digestiveEnzymes;
        absorptionRate = state.absorptionRate;
        wasteBuffer = Array.append(state.wasteBuffer, Buffer.toArray(wasteBuffer));
      };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ABSORPTION ENGINE — Integrating knowledge into the organism
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type AbsorptionState = {
    bloodstream : [DigestedKnowledge];     // Currently circulating
    tissueStorage : [StoredKnowledge];     // Long-term storage
    absorptionEfficiency : Float;
    integrationQueue : [DigestedKnowledge];
    totalAbsorbed : Nat;
    totalRejected : Nat;
  };
  
  public type StoredKnowledge = {
    knowledge : DigestedKnowledge;
    storedAt : Int;
    accessCount : Nat;
    lastAccessed : Int;
    strength : Float;                      // How well integrated
    connections : [Nat];                   // Links to other knowledge
  };
  
  public func initAbsorptionState() : AbsorptionState {
    {
      bloodstream = [];
      tissueStorage = [];
      absorptionEfficiency = NUTRIENT_ABSORPTION;
      integrationQueue = [];
      totalAbsorbed = 0;
      totalRejected = 0;
    }
  };
  
  // Absorb digested knowledge into the organism
  public func absorbKnowledge(
    state : AbsorptionState,
    digested : [DigestedKnowledge],
    currentBeat : Int
  ) : AbsorptionState {
    let newBloodstream = Buffer.Buffer<DigestedKnowledge>(state.bloodstream.size() + digested.size());
    let newTissue = Buffer.Buffer<StoredKnowledge>(state.tissueStorage.size() + digested.size());
    
    // Keep existing bloodstream (with decay)
    for (k in state.bloodstream.vals()) {
      let age = Float.fromInt(Int.abs(currentBeat - k.timestamp));
      let retention = exp(-age * k.decayRate / 1000.0);
      if (retention > 0.1) {
        newBloodstream.add(k);
      };
    };
    
    // Add new knowledge to bloodstream
    for (k in digested.vals()) {
      newBloodstream.add(k);
    };
    
    // Keep existing tissue storage
    for (s in state.tissueStorage.vals()) {
      newTissue.add(s);
    };
    
    // Move high-value bloodstream items to tissue
    for (k in newBloodstream.vals()) {
      let value = k.relevance * k.confidence * k.novelty;
      if (value > 0.5) {
        newTissue.add({
          knowledge = k;
          storedAt = currentBeat;
          accessCount = 0;
          lastAccessed = currentBeat;
          strength = value;
          connections = [];
        });
      };
    };
    
    {
      bloodstream = Buffer.toArray(newBloodstream);
      tissueStorage = Buffer.toArray(newTissue);
      absorptionEfficiency = state.absorptionEfficiency;
      integrationQueue = [];
      totalAbsorbed = state.totalAbsorbed + digested.size();
      totalRejected = state.totalRejected;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SEEKING QUEUE — Prioritized requests for information
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type SeekingQueue = {
    pending : [InformationRequest];
    inProgress : [InformationRequest];
    completed : [InformationRequest];
    failed : [InformationRequest];
    maxPending : Nat;
    maxInProgress : Nat;
  };
  
  public func initSeekingQueue() : SeekingQueue {
    {
      pending = [];
      inProgress = [];
      completed = [];
      failed = [];
      maxPending = 100;
      maxInProgress = 10;
    }
  };
  
  public func enqueueRequest(
    queue : SeekingQueue,
    request : InformationRequest
  ) : SeekingQueue {
    if (queue.pending.size() >= queue.maxPending) {
      // Queue full, reject lowest priority
      queue
    } else {
      let newPending = Array.append(queue.pending, [request]);
      // Sort by priority (higher first)
      let sorted = sortByPriority(newPending);
      {
        pending = sorted;
        inProgress = queue.inProgress;
        completed = queue.completed;
        failed = queue.failed;
        maxPending = queue.maxPending;
        maxInProgress = queue.maxInProgress;
      }
    }
  };
  
  public func dequeueForProcessing(
    queue : SeekingQueue
  ) : (?InformationRequest, SeekingQueue) {
    if (queue.pending.size() == 0 or queue.inProgress.size() >= queue.maxInProgress) {
      (null, queue)
    } else {
      let request = queue.pending[0];
      let remaining = Array.subArray<InformationRequest>(queue.pending, 1, queue.pending.size() - 1);
      let newInProgress = Array.append(queue.inProgress, [request]);
      
      (?request, {
        pending = remaining;
        inProgress = newInProgress;
        completed = queue.completed;
        failed = queue.failed;
        maxPending = queue.maxPending;
        maxInProgress = queue.maxInProgress;
      })
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // COMPLETE INFORMATION SEEKING STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type InformationSeekingState = {
    hunger : HungerState;
    digestion : DigestionState;
    absorption : AbsorptionState;
    seekingQueue : SeekingQueue;
    knowledgeSources : [KnowledgeSourceConfig];
    currentPlan : ?SeekingPlan;
    statistics : SeekingStatistics;
  };
  
  public type SeekingStatistics = {
    totalRequests : Nat;
    successfulRequests : Nat;
    failedRequests : Nat;
    totalBytesReceived : Nat;
    totalKnowledgeAbsorbed : Nat;
    averageResponseTime : Float;
    averageNovelty : Float;
    averageRelevance : Float;
  };
  
  public func initInformationSeekingState() : InformationSeekingState {
    {
      hunger = initHungerState();
      digestion = initDigestionState();
      absorption = initAbsorptionState();
      seekingQueue = initSeekingQueue();
      knowledgeSources = KNOWLEDGE_SOURCES;
      currentPlan = null;
      statistics = {
        totalRequests = 0;
        successfulRequests = 0;
        failedRequests = 0;
        totalBytesReceived = 0;
        totalKnowledgeAbsorbed = 0;
        averageResponseTime = 0.0;
        averageNovelty = 0.0;
        averageRelevance = 0.0;
      };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SEEKING TICK — One cycle of information seeking
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type SeekingTickResult = {
    requestsLaunched : Nat;
    itemsDigested : Nat;
    itemsAbsorbed : Nat;
    itemsWasted : Nat;
    currentHunger : Float;
    currentSatiation : Float;
    noveltyGained : Float;
  };
  
  public func seekingTick(
    state : InformationSeekingState,
    currentBeat : Int,
    goals : [Text],
    newRawInfo : [RawInformation]
  ) : (SeekingTickResult, InformationSeekingState) {
    // 1. Update hunger
    let avgNovelty = if (state.absorption.bloodstream.size() > 0) {
      var sum : Float = 0.0;
      for (k in state.absorption.bloodstream.vals()) { sum += k.novelty };
      sum / Float.fromInt(state.absorption.bloodstream.size())
    } else { 0.0 };
    
    let newHunger = updateHunger(state.hunger, currentBeat, avgNovelty, state.hunger.satiation);
    
    // 2. Add new raw info to stomach
    let newStomach = Array.append(state.digestion.stomachContents, newRawInfo);
    let newDigestion = {
      stomachContents = newStomach;
      stomachCapacity = state.digestion.stomachCapacity;
      digestiveEnzymes = state.digestion.digestiveEnzymes;
      absorptionRate = state.digestion.absorptionRate;
      wasteBuffer = state.digestion.wasteBuffer;
    };
    
    // 3. Digest batch
    let digestResult = digestBatch(newDigestion, currentBeat, goals, 10);
    
    // 4. Absorb digested knowledge
    let newAbsorption = absorbKnowledge(state.absorption, digestResult.digested, currentBeat);
    
    // 5. Generate new requests if hungry
    let requestsLaunched = if (newHunger.seekingUrgency > 0.5 and state.seekingQueue.pending.size() < 50) {
      // Would generate requests here
      0  // Placeholder
    } else { 0 };
    
    let result : SeekingTickResult = {
      requestsLaunched = requestsLaunched;
      itemsDigested = digestResult.digested.size();
      itemsAbsorbed = digestResult.digested.size();
      itemsWasted = digestResult.waste.size();
      currentHunger = newHunger.overallHunger;
      currentSatiation = newHunger.satiation;
      noveltyGained = avgNovelty;
    };
    
    let newState : InformationSeekingState = {
      hunger = newHunger;
      digestion = digestResult.newState;
      absorption = newAbsorption;
      seekingQueue = state.seekingQueue;
      knowledgeSources = state.knowledgeSources;
      currentPlan = state.currentPlan;
      statistics = {
        totalRequests = state.statistics.totalRequests + requestsLaunched;
        successfulRequests = state.statistics.successfulRequests;
        failedRequests = state.statistics.failedRequests;
        totalBytesReceived = state.statistics.totalBytesReceived;
        totalKnowledgeAbsorbed = state.statistics.totalKnowledgeAbsorbed + digestResult.digested.size();
        averageResponseTime = state.statistics.averageResponseTime;
        averageNovelty = avgNovelty;
        averageRelevance = state.statistics.averageRelevance;
      };
    };
    
    (result, newState)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // HELPER FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  func exp(x : Float) : Float {
    if (x > 10.0) { return 22026.0 };
    if (x < -10.0) { return 0.0 };
    var result : Float = 1.0;
    var term : Float = 1.0;
    for (n in Iter.range(1, 25)) {
      term := term * x / Float.fromInt(n);
      result += term;
    };
    result
  };
  
  func clamp(value : Float, min : Float, max : Float) : Float {
    if (value < min) { min }
    else if (value > max) { max }
    else { value }
  };
  
  func sortByHunger(hungers : [Float]) : [Nat] {
    // Simple bubble sort returning indices
    let indices = Array.tabulate<Nat>(hungers.size(), func(i : Nat) : Nat { i });
    let indicesMut = Array.thaw<Nat>(indices);
    
    for (i in Iter.range(0, hungers.size() - 2)) {
      for (j in Iter.range(0, hungers.size() - i - 2)) {
        if (hungers[indicesMut[j]] < hungers[indicesMut[j + 1]]) {
          let temp = indicesMut[j];
          indicesMut[j] := indicesMut[j + 1];
          indicesMut[j + 1] := temp;
        };
      };
    };
    
    Array.freeze(indicesMut)
  };
  
  func sortByPriority(requests : [InformationRequest]) : [InformationRequest] {
    // Simple sort by priority (descending)
    let mutable = Array.thaw<InformationRequest>(requests);
    for (i in Iter.range(0, requests.size() - 2)) {
      for (j in Iter.range(0, requests.size() - i - 2)) {
        if (mutable[j].priority < mutable[j + 1].priority) {
          let temp = mutable[j];
          mutable[j] := mutable[j + 1];
          mutable[j + 1] := temp;
        };
      };
    };
    Array.freeze(mutable)
  };
  
  func indexToInfoType(i : Nat) : InformationType {
    switch (i) {
      case 0 { #Workflow };
      case 1 { #Technical };
      case 2 { #Financial };
      case 3 { #Social };
      case 4 { #Scientific };
      case 5 { #Temporal };
      case 6 { #Spatial };
      case 7 { #Procedural };
      case 8 { #Declarative };
      case 9 { #Episodic };
      case 10 { #Semantic };
      case _ { #Metacognitive };
    }
  };
  
  func sameInfoType(a : InformationType, b : InformationType) : Bool {
    switch (a, b) {
      case (#Workflow, #Workflow) { true };
      case (#Technical, #Technical) { true };
      case (#Financial, #Financial) { true };
      case (#Social, #Social) { true };
      case (#Scientific, #Scientific) { true };
      case (#Temporal, #Temporal) { true };
      case (#Spatial, #Spatial) { true };
      case (#Procedural, #Procedural) { true };
      case (#Declarative, #Declarative) { true };
      case (#Episodic, #Episodic) { true };
      case (#Semantic, #Semantic) { true };
      case (#Metacognitive, #Metacognitive) { true };
      case _ { false };
    }
  };
  
  func sourceToText(source : InformationSource) : Text {
    switch (source) {
      case (#API(url)) { "API: " # url };
      case (#RSS(url)) { "RSS: " # url };
      case (#WebPage(url)) { "Web: " # url };
      case (#Database(conn)) { "DB: " # conn };
      case (#Stream(url)) { "Stream: " # url };
      case (#File(path)) { "File: " # path };
      case (#Internal(name)) { "Internal: " # name };
      case (#PeerOrganism(p)) { "Peer: " # Principal.toText(p) };
    }
  };
  
  func computeNovelty(checksum : Nat32, currentBeat : Int) : Float {
    // Simplified novelty computation
    let hash = Nat32.toNat(checksum);
    Float.fromInt(hash % 100) / 100.0
  };
  
  func computeRelevance(infoType : InformationType, goals : [Text]) : Float {
    // Simplified relevance computation
    if (goals.size() == 0) { return 0.5 };
    // Would match info type to goals in real implementation
    0.7
  };
  
  func computeActionability(infoType : InformationType) : Float {
    switch (infoType) {
      case (#Workflow) { 0.9 };
      case (#Procedural) { 0.85 };
      case (#Technical) { 0.8 };
      case (#Financial) { 0.75 };
      case (#Temporal) { 0.7 };
      case (#Declarative) { 0.6 };
      case (#Scientific) { 0.55 };
      case (#Social) { 0.5 };
      case (#Episodic) { 0.45 };
      case (#Semantic) { 0.4 };
      case (#Spatial) { 0.35 };
      case (#Metacognitive) { 0.3 };
    }
  };
  
  func getDecayRate(infoType : InformationType) : Float {
    switch (infoType) {
      case (#Temporal) { 0.1 };      // News decays fast
      case (#Financial) { 0.05 };    // Market data moderately fast
      case (#Social) { 0.03 };
      case (#Workflow) { 0.01 };
      case (#Technical) { 0.005 };   // Technical docs last longer
      case (#Scientific) { 0.002 };  // Scientific knowledge lasts
      case (#Procedural) { 0.003 };
      case (#Declarative) { 0.001 };
      case (#Episodic) { 0.02 };
      case (#Semantic) { 0.0005 };   // Concepts last longest
      case (#Spatial) { 0.001 };
      case (#Metacognitive) { 0.0001 };
    }
  };

}
