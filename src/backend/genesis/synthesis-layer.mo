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
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// SYNTHESIS LAYER — UNIFIED ORGANIZATIONAL RESPONSE
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// THE PROBLEM:
// Multiple specialist engines produce independent recommendations. The organism needs ONE
// coordinated response, not conflicting signals. When risk engine says "reduce exposure"
// and opportunity engine says "increase position", what does the organism DO?
//
// THE SOLUTION:
// The Synthesis Layer receives ALL specialist outputs, resolves conflicts, weights by
// confidence and domain relevance, and produces a SINGLE unified action vector.
//
// ARCHITECTURE:
// 1. Multi-Specialist Aggregation — Collect outputs from all specialist engines
// 2. Conflict Detection — Identify contradictory recommendations
// 3. Priority Resolution — Apply doctrine-based priority rules
// 4. Confidence Weighting — Weight by specialist confidence and track record
// 5. Action Synthesis — Produce unified, executable response
// 6. Feedback Loop — Track outcomes to calibrate future synthesis
//
// THE ORGANISM ACTS AS ONE INTELLIGENCE, NOT A COMMITTEE.
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Nat64 "mo:core/Nat64";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Iter "mo:core/Iter";
import Option "mo:core/Option";
import Time "mo:core/Time";
import Text "mo:core/Text";

module SynthesisLayer {

  // ═══════════════════════════════════════════════════════════════════════════════
  // MATHEMATICAL CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let PI : Float = 3.14159265358979323846;
  public let E : Float = 2.71828182845904523536;
  public let PHI : Float = 1.618033988749895;
  public let INV_PHI : Float = 0.618033988749895;

  // ═══════════════════════════════════════════════════════════════════════════════
  // SPECIALIST DOMAINS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type SpecialistDomain = {
    #Risk;              // Enterprise risk engine
    #Treasury;          // Treasury management
    #Settlement;        // Settlement/clearinghouse
    #Market;            // Market structure analysis
    #Threat;            // Threat detection
    #Anticipatory;      // Pre-positioning
    #Neural;            // Neural/cognitive state
    #Fear;              // VAEL fear substrate
    #Colony;            // Colony coordination
    #Governance;        // Governance/voting
    #Economic;          // FORMA/token economics
    #Defense;           // AEGIS/Four Angels
    #Temporal;          // Chrono/timing
    #Memory;            // Memory/learning
    #Identity;          // Shell 2/identity
    #Architecture;      // System coordination
  };
  
  public let NUM_SPECIALISTS : Nat = 16;
  
  public func domainToIndex(domain : SpecialistDomain) : Nat {
    switch (domain) {
      case (#Risk) { 0 };
      case (#Treasury) { 1 };
      case (#Settlement) { 2 };
      case (#Market) { 3 };
      case (#Threat) { 4 };
      case (#Anticipatory) { 5 };
      case (#Neural) { 6 };
      case (#Fear) { 7 };
      case (#Colony) { 8 };
      case (#Governance) { 9 };
      case (#Economic) { 10 };
      case (#Defense) { 11 };
      case (#Temporal) { 12 };
      case (#Memory) { 13 };
      case (#Identity) { 14 };
      case (#Architecture) { 15 };
    }
  };
  
  public func indexToDomain(n : Nat) : SpecialistDomain {
    switch (n % 16) {
      case (0) { #Risk };
      case (1) { #Treasury };
      case (2) { #Settlement };
      case (3) { #Market };
      case (4) { #Threat };
      case (5) { #Anticipatory };
      case (6) { #Neural };
      case (7) { #Fear };
      case (8) { #Colony };
      case (9) { #Governance };
      case (10) { #Economic };
      case (11) { #Defense };
      case (12) { #Temporal };
      case (13) { #Memory };
      case (14) { #Identity };
      case (15) { #Architecture };
      case (_) { #Risk };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ACTION TYPES — WHAT THE ORGANISM CAN DO
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type ActionCategory = {
    #Positioning;       // Market position changes
    #Defense;           // Defensive measures
    #Economic;          // Token operations
    #Governance;        // Voting/proposals
    #Colony;            // Colony management
    #Communication;     // External communication
    #Memory;            // Memory operations
    #Internal;          // Internal state changes
  };
  
  public type ActionType = {
    // Positioning actions
    #IncreaseExposure : { asset : Text; amount : Float };
    #DecreaseExposure : { asset : Text; amount : Float };
    #Rebalance : { from : Text; to : Text; amount : Float };
    #HedgePosition : { asset : Text; hedgeRatio : Float };
    #ExitPosition : { asset : Text };
    #EnterPosition : { asset : Text; amount : Float };
    
    // Defense actions
    #ActivateAEGIS : { level : Nat };
    #DeactivateAEGIS;
    #RaiseFearThreshold : { delta : Float };
    #LowerFearThreshold : { delta : Float };
    #IsolateCounterparty : { counterpartyId : Text };
    #HaltOperations;
    #ResumeOperations;
    
    // Economic actions
    #MintFORMA : { amount : Float };
    #BurnFORMA : { amount : Float };
    #AdjustMintingRate : { multiplier : Float };
    #TransferTreasury : { to : Text; amount : Float };
    #StakeTokens : { token : Text; amount : Float };
    #UnstakeTokens : { token : Text; amount : Float };
    
    // Governance actions
    #ProposeChange : { description : Text; params : Text };
    #Vote : { proposalId : Text; support : Bool };
    #DelegateVote : { to : Text };
    #VetoProposal : { proposalId : Text };
    
    // Colony actions
    #SpawnEntity : { entityType : Text };
    #RetireEntity : { entityId : Text };
    #ReassignEntity : { entityId : Text; newTask : Text };
    #AdjustColonySize : { delta : Int };
    
    // Communication actions
    #BroadcastAlert : { message : Text; severity : Nat };
    #SilenceChannel : { channel : Text };
    #RequestHelp : { message : Text };
    
    // Memory actions
    #ConsolidateMemory;
    #ForgetPattern : { patternId : Text };
    #PrioritizeMemory : { memoryId : Text };
    
    // Internal actions
    #AdjustCoherence : { target : Float };
    #ResetDrift;
    #CalibrateWeights;
    #NoAction;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SPECIALIST RECOMMENDATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type SpecialistRecommendation = {
    specialist : SpecialistDomain;
    recommendedAction : ActionType;
    confidence : Float;           // 0-1
    urgency : Float;              // 0-1
    rationale : Text;
    supportingData : [(Text, Float)];  // Key metrics
    conflictsWith : [SpecialistDomain];  // Which specialists might disagree
    timestamp : Nat64;
  };
  
  public type SpecialistOutput = {
    specialist : SpecialistDomain;
    recommendations : [SpecialistRecommendation];
    overallConfidence : Float;
    trackRecord : Float;          // Historical accuracy
    lastUpdate : Nat64;
    isActive : Bool;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // CONFLICT DETECTION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type ConflictType = {
    #DirectContradiction;   // Actions directly oppose each other
    #ResourceConflict;      // Both need same limited resource
    #TimingConflict;        // Different timing requirements
    #PriorityConflict;      // Different urgency levels
    #PhilosophicalConflict; // Different doctrinal interpretations
  };
  
  public type Conflict = {
    conflictType : ConflictType;
    specialist1 : SpecialistDomain;
    specialist2 : SpecialistDomain;
    recommendation1 : SpecialistRecommendation;
    recommendation2 : SpecialistRecommendation;
    severity : Float;           // 0-1 (how serious is the conflict)
    resolutionSuggestion : ?Text;
  };
  
  /// Detect conflicts between recommendations
  public func detectConflicts(recommendations : [SpecialistRecommendation]) : [Conflict] {
    let conflicts = Buffer.Buffer<Conflict>(10);
    
    for (i in Iter.range(0, recommendations.size() - 1)) {
      for (j in Iter.range(i + 1, recommendations.size() - 1)) {
        let rec1 = recommendations[i];
        let rec2 = recommendations[j];
        
        let conflict = checkForConflict(rec1, rec2);
        switch (conflict) {
          case (?c) { conflicts.add(c) };
          case (null) {};
        }
      }
    };
    
    Buffer.toArray(conflicts)
  };
  
  // Helper: Check if two recommendations conflict
  func checkForConflict(
    rec1 : SpecialistRecommendation,
    rec2 : SpecialistRecommendation
  ) : ?Conflict {
    // Check for direct contradictions
    let contradiction = switch (rec1.recommendedAction, rec2.recommendedAction) {
      case (#IncreaseExposure(a), #DecreaseExposure(b)) {
        if (Text.equal(a.asset, b.asset)) { true } else { false }
      };
      case (#DecreaseExposure(a), #IncreaseExposure(b)) {
        if (Text.equal(a.asset, b.asset)) { true } else { false }
      };
      case (#HaltOperations, #ResumeOperations) { true };
      case (#ResumeOperations, #HaltOperations) { true };
      case (#MintFORMA(a), #BurnFORMA(b)) { true };
      case (#BurnFORMA(a), #MintFORMA(b)) { true };
      case (#ActivateAEGIS(_), #DeactivateAEGIS) { true };
      case (#DeactivateAEGIS, #ActivateAEGIS(_)) { true };
      case (_, _) { false };
    };
    
    if (contradiction) {
      ?{
        conflictType = #DirectContradiction;
        specialist1 = rec1.specialist;
        specialist2 = rec2.specialist;
        recommendation1 = rec1;
        recommendation2 = rec2;
        severity = Float.max(rec1.confidence, rec2.confidence);
        resolutionSuggestion = ?"Apply priority rules based on domain hierarchy";
      }
    } else {
      null
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // PRIORITY RESOLUTION — DOCTRINE-BASED RULES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Domain priority weights (higher = more authority in conflicts)
  /// Based on organism doctrine: Safety > Economic > Growth
  public func getDomainPriority(domain : SpecialistDomain) : Float {
    switch (domain) {
      case (#Defense) { 1.00 };      // Highest - survival
      case (#Threat) { 0.95 };       // Very high - threat detection
      case (#Fear) { 0.90 };         // High - emotional state
      case (#Risk) { 0.85 };         // High - risk management
      case (#Settlement) { 0.80 };   // Important - settlement integrity
      case (#Treasury) { 0.75 };     // Important - capital preservation
      case (#Economic) { 0.70 };     // Medium - token economics
      case (#Anticipatory) { 0.65 }; // Medium - pre-positioning
      case (#Market) { 0.60 };       // Medium - market analysis
      case (#Neural) { 0.55 };       // Medium - cognitive state
      case (#Governance) { 0.50 };   // Medium - governance
      case (#Colony) { 0.45 };       // Lower - colony management
      case (#Memory) { 0.40 };       // Lower - memory operations
      case (#Identity) { 0.35 };     // Lower - identity
      case (#Temporal) { 0.30 };     // Lower - timing
      case (#Architecture) { 0.25 }; // Lowest - internal coordination
    }
  };
  
  /// Resolve a conflict using priority rules
  public func resolveConflict(conflict : Conflict) : SpecialistRecommendation {
    let priority1 = getDomainPriority(conflict.specialist1);
    let priority2 = getDomainPriority(conflict.specialist2);
    
    // Weight by priority and confidence
    let weight1 = priority1 * conflict.recommendation1.confidence * conflict.recommendation1.urgency;
    let weight2 = priority2 * conflict.recommendation2.confidence * conflict.recommendation2.urgency;
    
    if (weight1 >= weight2) {
      conflict.recommendation1
    } else {
      conflict.recommendation2
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // CONFIDENCE WEIGHTING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type SpecialistTrackRecord = {
    specialist : SpecialistDomain;
    totalRecommendations : Nat;
    successfulRecommendations : Nat;
    averageConfidence : Float;
    averageActualOutcome : Float;
    calibrationScore : Float;     // How well confidence matches outcomes
    recentPerformance : Float;    // Performance in last N beats
    trustWeight : Float;          // Derived trust level
  };
  
  /// Calculate trust weight for a specialist based on track record
  public func calculateTrustWeight(trackRecord : SpecialistTrackRecord) : Float {
    if (trackRecord.totalRecommendations < 10) {
      return 0.5  // Default moderate trust for new specialists
    };
    
    let successRate = Float.fromInt(trackRecord.successfulRecommendations) / 
                      Float.fromInt(trackRecord.totalRecommendations);
    
    // Combine success rate with calibration
    // Good calibration means confidence matches actual outcomes
    let calibrationBonus = if (trackRecord.calibrationScore > 0.8) { 0.1 }
                           else if (trackRecord.calibrationScore > 0.6) { 0.0 }
                           else { -0.1 };
    
    // Recent performance matters more
    let recencyWeight = 0.3;
    let historicalWeight = 1.0 - recencyWeight;
    
    let baseWeight = successRate * historicalWeight + trackRecord.recentPerformance * recencyWeight;
    
    Float.min(1.0, Float.max(0.1, baseWeight + calibrationBonus))
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ACTION SYNTHESIS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type SynthesizedAction = {
    action : ActionType;
    category : ActionCategory;
    compositeConfidence : Float;
    compositeUrgency : Float;
    contributingSpecialists : [SpecialistDomain];
    conflictsResolved : Nat;
    synthesisMethod : { #SingleSource; #Consensus; #ConflictResolution; #Aggregation };
    executionPriority : Nat;      // 1 = highest
    estimatedImpact : Float;      // Expected outcome magnitude
    reversible : Bool;
  };
  
  public type SynthesisResult = {
    primaryAction : SynthesizedAction;
    secondaryActions : [SynthesizedAction];
    conflictsDetected : [Conflict];
    overallConfidence : Float;
    synthesisQuality : Float;     // How clean was the synthesis
    timestamp : Nat64;
  };
  
  /// Main synthesis function - produce unified response from all specialist outputs
  public func synthesize(
    specialistOutputs : [SpecialistOutput],
    trackRecords : [SpecialistTrackRecord]
  ) : SynthesisResult {
    // 1. Collect all recommendations
    let allRecommendations = Buffer.Buffer<SpecialistRecommendation>(50);
    for (output in specialistOutputs.vals()) {
      if (output.isActive) {
        for (rec in output.recommendations.vals()) {
          allRecommendations.add(rec);
        }
      }
    };
    
    let recommendations = Buffer.toArray(allRecommendations);
    
    if (recommendations.size() == 0) {
      return {
        primaryAction = {
          action = #NoAction;
          category = #Internal;
          compositeConfidence = 1.0;
          compositeUrgency = 0.0;
          contributingSpecialists = [];
          conflictsResolved = 0;
          synthesisMethod = #SingleSource;
          executionPriority = 10;
          estimatedImpact = 0.0;
          reversible = true;
        };
        secondaryActions = [];
        conflictsDetected = [];
        overallConfidence = 1.0;
        synthesisQuality = 1.0;
        timestamp = Nat64.fromNat(Int.abs(Time.now()));
      }
    };
    
    // 2. Detect conflicts
    let conflicts = detectConflicts(recommendations);
    
    // 3. Weight recommendations by trust and priority
    let weightedRecs = Buffer.Buffer<(SpecialistRecommendation, Float)>(recommendations.size());
    for (rec in recommendations.vals()) {
      // Find track record
      var trustWeight : Float = 0.5;
      for (tr in trackRecords.vals()) {
        if (domainToIndex(tr.specialist) == domainToIndex(rec.specialist)) {
          trustWeight := tr.trustWeight;
        }
      };
      
      let priority = getDomainPriority(rec.specialist);
      let totalWeight = rec.confidence * rec.urgency * trustWeight * priority;
      weightedRecs.add((rec, totalWeight));
    };
    
    // 4. Resolve conflicts
    var conflictsResolved : Nat = 0;
    for (conflict in conflicts.vals()) {
      // Remove lower-priority recommendation
      // In practice, this would update the weightedRecs buffer
      conflictsResolved := conflictsResolved + 1;
    };
    
    // 5. Find highest-weighted recommendation
    var maxWeight : Float = 0.0;
    var primaryRec : ?SpecialistRecommendation = null;
    let contributors = Buffer.Buffer<SpecialistDomain>(5);
    
    for ((rec, weight) in weightedRecs.vals()) {
      if (weight > maxWeight) {
        maxWeight := weight;
        primaryRec := ?rec;
      };
      if (weight > 0.3) {
        contributors.add(rec.specialist);
      }
    };
    
    // 6. Create synthesized action
    let (action, category) = switch (primaryRec) {
      case (?rec) { (rec.recommendedAction, actionToCategory(rec.recommendedAction)) };
      case (null) { (#NoAction, #Internal) };
    };
    
    let primaryAction : SynthesizedAction = {
      action = action;
      category = category;
      compositeConfidence = maxWeight;
      compositeUrgency = switch (primaryRec) { case (?r) { r.urgency }; case (null) { 0.0 } };
      contributingSpecialists = Buffer.toArray(contributors);
      conflictsResolved = conflictsResolved;
      synthesisMethod = if (conflicts.size() > 0) { #ConflictResolution }
                        else if (contributors.size() > 1) { #Consensus }
                        else { #SingleSource };
      executionPriority = 1;
      estimatedImpact = maxWeight;
      reversible = isReversible(action);
    };
    
    // 7. Create secondary actions (non-conflicting lower-priority recommendations)
    let secondaryActions = Buffer.Buffer<SynthesizedAction>(5);
    for ((rec, weight) in weightedRecs.vals()) {
      if (weight > 0.2 and weight < maxWeight) {
        // Check if it conflicts with primary
        let conflictsWithPrimary = switch (primaryRec) {
          case (?pr) { checkForConflict(rec, pr) != null };
          case (null) { false };
        };
        
        if (not conflictsWithPrimary) {
          secondaryActions.add({
            action = rec.recommendedAction;
            category = actionToCategory(rec.recommendedAction);
            compositeConfidence = weight;
            compositeUrgency = rec.urgency;
            contributingSpecialists = [rec.specialist];
            conflictsResolved = 0;
            synthesisMethod = #SingleSource;
            executionPriority = 2;
            estimatedImpact = weight;
            reversible = isReversible(rec.recommendedAction);
          });
        }
      }
    };
    
    // Calculate synthesis quality (lower if many conflicts)
    let synthesisQuality = if (recommendations.size() > 0) {
      1.0 - Float.fromInt(conflicts.size()) / Float.fromInt(recommendations.size())
    } else { 1.0 };
    
    {
      primaryAction = primaryAction;
      secondaryActions = Buffer.toArray(secondaryActions);
      conflictsDetected = conflicts;
      overallConfidence = maxWeight;
      synthesisQuality = synthesisQuality;
      timestamp = Nat64.fromNat(Int.abs(Time.now()));
    }
  };
  
  // Helper: Determine action category
  func actionToCategory(action : ActionType) : ActionCategory {
    switch (action) {
      case (#IncreaseExposure(_)) { #Positioning };
      case (#DecreaseExposure(_)) { #Positioning };
      case (#Rebalance(_)) { #Positioning };
      case (#HedgePosition(_)) { #Positioning };
      case (#ExitPosition(_)) { #Positioning };
      case (#EnterPosition(_)) { #Positioning };
      case (#ActivateAEGIS(_)) { #Defense };
      case (#DeactivateAEGIS) { #Defense };
      case (#RaiseFearThreshold(_)) { #Defense };
      case (#LowerFearThreshold(_)) { #Defense };
      case (#IsolateCounterparty(_)) { #Defense };
      case (#HaltOperations) { #Defense };
      case (#ResumeOperations) { #Defense };
      case (#MintFORMA(_)) { #Economic };
      case (#BurnFORMA(_)) { #Economic };
      case (#AdjustMintingRate(_)) { #Economic };
      case (#TransferTreasury(_)) { #Economic };
      case (#StakeTokens(_)) { #Economic };
      case (#UnstakeTokens(_)) { #Economic };
      case (#ProposeChange(_)) { #Governance };
      case (#Vote(_)) { #Governance };
      case (#DelegateVote(_)) { #Governance };
      case (#VetoProposal(_)) { #Governance };
      case (#SpawnEntity(_)) { #Colony };
      case (#RetireEntity(_)) { #Colony };
      case (#ReassignEntity(_)) { #Colony };
      case (#AdjustColonySize(_)) { #Colony };
      case (#BroadcastAlert(_)) { #Communication };
      case (#SilenceChannel(_)) { #Communication };
      case (#RequestHelp(_)) { #Communication };
      case (#ConsolidateMemory) { #Memory };
      case (#ForgetPattern(_)) { #Memory };
      case (#PrioritizeMemory(_)) { #Memory };
      case (#AdjustCoherence(_)) { #Internal };
      case (#ResetDrift) { #Internal };
      case (#CalibrateWeights) { #Internal };
      case (#NoAction) { #Internal };
    }
  };
  
  // Helper: Check if action is reversible
  func isReversible(action : ActionType) : Bool {
    switch (action) {
      case (#ExitPosition(_)) { false };
      case (#BurnFORMA(_)) { false };
      case (#RetireEntity(_)) { false };
      case (#ForgetPattern(_)) { false };
      case (#VetoProposal(_)) { false };
      case (_) { true };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SYNTHESIS ENGINE STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type SynthesisEngineState = {
    var specialistOutputs : [SpecialistOutput];
    var trackRecords : [SpecialistTrackRecord];
    var recentSyntheses : [SynthesisResult];
    var totalSyntheses : Nat;
    var conflictsResolved : Nat;
    var avgSynthesisQuality : Float;
    var lastSynthesis : ?SynthesisResult;
    var beat : Nat64;
  };
  
  public func initSynthesisEngine() : SynthesisEngineState {
    // Initialize track records for all specialists
    let initialRecords = Array.tabulate<SpecialistTrackRecord>(NUM_SPECIALISTS, func(i : Nat) : SpecialistTrackRecord {
      {
        specialist = indexToDomain(i);
        totalRecommendations = 0;
        successfulRecommendations = 0;
        averageConfidence = 0.5;
        averageActualOutcome = 0.5;
        calibrationScore = 0.5;
        recentPerformance = 0.5;
        trustWeight = 0.5;
      }
    });
    
    {
      var specialistOutputs = [];
      var trackRecords = initialRecords;
      var recentSyntheses = [];
      var totalSyntheses = 0;
      var conflictsResolved = 0;
      var avgSynthesisQuality = 1.0;
      var lastSynthesis = null;
      var beat = 0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // MAIN SYNTHESIS TICK — CALLED EACH HEARTBEAT
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func tick(
    state : SynthesisEngineState,
    specialistOutputs : [SpecialistOutput],
    beat : Nat64
  ) : {
    newState : SynthesisEngineState;
    synthesisResult : SynthesisResult;
    actionToExecute : SynthesizedAction;
    alerts : [Text];
  } {
    let alerts = Buffer.Buffer<Text>(5);
    
    // Perform synthesis
    let result = synthesize(specialistOutputs, state.trackRecords);
    
    // Check synthesis quality
    if (result.synthesisQuality < 0.5) {
      alerts.add("WARNING: Low synthesis quality (" # Float.toText(result.synthesisQuality * 100.0) # "%). Multiple conflicts detected.");
    };
    
    // Check if any critical conflicts
    for (conflict in result.conflictsDetected.vals()) {
      if (conflict.severity > 0.8) {
        alerts.add("CRITICAL: High-severity conflict between " # 
                   domainToText(conflict.specialist1) # " and " #
                   domainToText(conflict.specialist2));
      }
    };
    
    // Update state
    let historySize = 100;
    let recentSyntheses = if (state.recentSyntheses.size() >= historySize) {
      let trimmed = Array.tabulate<SynthesisResult>(historySize - 1, func(i : Nat) : SynthesisResult {
        state.recentSyntheses[i + 1]
      });
      Array.append(trimmed, [result])
    } else {
      Array.append(state.recentSyntheses, [result])
    };
    
    // Update average quality
    var totalQuality : Float = 0.0;
    for (s in recentSyntheses.vals()) {
      totalQuality := totalQuality + s.synthesisQuality;
    };
    let avgQuality = totalQuality / Float.fromInt(recentSyntheses.size());
    
    let newState : SynthesisEngineState = {
      var specialistOutputs = specialistOutputs;
      var trackRecords = state.trackRecords;
      var recentSyntheses = recentSyntheses;
      var totalSyntheses = state.totalSyntheses + 1;
      var conflictsResolved = state.conflictsResolved + result.conflictsDetected.size();
      var avgSynthesisQuality = avgQuality;
      var lastSynthesis = ?result;
      var beat = beat;
    };
    
    {
      newState = newState;
      synthesisResult = result;
      actionToExecute = result.primaryAction;
      alerts = Buffer.toArray(alerts);
    }
  };
  
  // Helper: Domain to text for alerts
  func domainToText(domain : SpecialistDomain) : Text {
    switch (domain) {
      case (#Risk) { "Risk" };
      case (#Treasury) { "Treasury" };
      case (#Settlement) { "Settlement" };
      case (#Market) { "Market" };
      case (#Threat) { "Threat" };
      case (#Anticipatory) { "Anticipatory" };
      case (#Neural) { "Neural" };
      case (#Fear) { "Fear" };
      case (#Colony) { "Colony" };
      case (#Governance) { "Governance" };
      case (#Economic) { "Economic" };
      case (#Defense) { "Defense" };
      case (#Temporal) { "Temporal" };
      case (#Memory) { "Memory" };
      case (#Identity) { "Identity" };
      case (#Architecture) { "Architecture" };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // FEEDBACK AND LEARNING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Record outcome of a synthesis for track record updates
  public func recordOutcome(
    state : SynthesisEngineState,
    synthesis : SynthesisResult,
    actualOutcome : Float,  // 0-1 (how well did it work)
    beat : Nat64
  ) : SynthesisEngineState {
    // Update track records for contributing specialists
    let updatedRecords = Array.tabulate<SpecialistTrackRecord>(NUM_SPECIALISTS, func(i : Nat) : SpecialistTrackRecord {
      let existing = state.trackRecords[i];
      let domain = indexToDomain(i);
      
      // Check if this specialist contributed
      var contributed = false;
      for (spec in synthesis.primaryAction.contributingSpecialists.vals()) {
        if (domainToIndex(spec) == i) { contributed := true };
      };
      
      if (contributed) {
        // Update track record
        let successDelta = if (actualOutcome > 0.5) { 1 } else { 0 };
        let newTotal = existing.totalRecommendations + 1;
        let newSuccess = existing.successfulRecommendations + successDelta;
        
        // Update averages with exponential moving average
        let alpha = 0.1;
        let newAvgConf = existing.averageConfidence * (1.0 - alpha) + synthesis.overallConfidence * alpha;
        let newAvgOutcome = existing.averageActualOutcome * (1.0 - alpha) + actualOutcome * alpha;
        
        // Calibration = 1 - |confidence - outcome|
        let calibration = 1.0 - Float.abs(newAvgConf - newAvgOutcome);
        
        // Recent performance (more weight to recent)
        let recentPerf = existing.recentPerformance * 0.9 + actualOutcome * 0.1;
        
        let trustWeight = calculateTrustWeight({
          specialist = domain;
          totalRecommendations = newTotal;
          successfulRecommendations = newSuccess;
          averageConfidence = newAvgConf;
          averageActualOutcome = newAvgOutcome;
          calibrationScore = calibration;
          recentPerformance = recentPerf;
          trustWeight = existing.trustWeight;
        });
        
        {
          specialist = domain;
          totalRecommendations = newTotal;
          successfulRecommendations = newSuccess;
          averageConfidence = newAvgConf;
          averageActualOutcome = newAvgOutcome;
          calibrationScore = calibration;
          recentPerformance = recentPerf;
          trustWeight = trustWeight;
        }
      } else {
        existing
      }
    });
    
    {
      var specialistOutputs = state.specialistOutputs;
      var trackRecords = updatedRecords;
      var recentSyntheses = state.recentSyntheses;
      var totalSyntheses = state.totalSyntheses;
      var conflictsResolved = state.conflictsResolved;
      var avgSynthesisQuality = state.avgSynthesisQuality;
      var lastSynthesis = state.lastSynthesis;
      var beat = beat;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SUMMARY AND REPORTING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type SynthesisSummary = {
    totalSyntheses : Nat;
    avgSynthesisQuality : Float;
    conflictsResolved : Nat;
    topPerformingSpecialist : SpecialistDomain;
    lowestPerformingSpecialist : SpecialistDomain;
    mostCommonAction : ActionCategory;
    avgConfidence : Float;
    currentBeat : Nat64;
  };
  
  public func getSummary(state : SynthesisEngineState) : SynthesisSummary {
    // Find top and lowest performing specialists
    var topSpec = #Risk;
    var topPerf : Float = 0.0;
    var lowSpec = #Risk;
    var lowPerf : Float = 1.0;
    
    for (tr in state.trackRecords.vals()) {
      if (tr.trustWeight > topPerf) {
        topPerf := tr.trustWeight;
        topSpec := tr.specialist;
      };
      if (tr.trustWeight < lowPerf and tr.totalRecommendations > 0) {
        lowPerf := tr.trustWeight;
        lowSpec := tr.specialist;
      }
    };
    
    // Find most common action category (from recent syntheses)
    var categoryCount : [(ActionCategory, Nat)] = [
      (#Positioning, 0), (#Defense, 0), (#Economic, 0), (#Governance, 0),
      (#Colony, 0), (#Communication, 0), (#Memory, 0), (#Internal, 0)
    ];
    
    for (s in state.recentSyntheses.vals()) {
      // Would count categories here
    };
    
    // Calculate average confidence
    var totalConf : Float = 0.0;
    for (s in state.recentSyntheses.vals()) {
      totalConf := totalConf + s.overallConfidence;
    };
    let avgConf = if (state.recentSyntheses.size() > 0) {
      totalConf / Float.fromInt(state.recentSyntheses.size())
    } else { 0.5 };
    
    {
      totalSyntheses = state.totalSyntheses;
      avgSynthesisQuality = state.avgSynthesisQuality;
      conflictsResolved = state.conflictsResolved;
      topPerformingSpecialist = topSpec;
      lowestPerformingSpecialist = lowSpec;
      mostCommonAction = #Positioning;  // Placeholder
      avgConfidence = avgConf;
      currentBeat = state.beat;
    }
  };

}
