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
import Array "mo:core/Array";
import Text "mo:core/Text";
import Bool "mo:core/Bool";

module VeilMembrane {

  // ═══════════════════════════════════════════════════════════════════════════════
  // VEIL STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type VeilState = {
    // Core properties
    integrity : Float;            // 0-1 membrane health
    permeability : Float;         // 0-1 how easily things pass
    loadBearing : Float;          // Current load capacity
    maxLoad : Float;              // Maximum load capacity
    
    // Expression gating
    expressionGate : ExpressionGate;
    
    // Timing synchronization with LEXIS
    lexisSyncPhase : Float;       // Current phase alignment with LEXIS
    expressionQuality : Float;    // Q^expr = cos(φ_LEXIS - φ_VEIL)
    
    // Load tracking
    currentLoad : Float;
    loadHistory : [Float];
    overloadEvents : Nat;
    
    // Filtering
    filterActive : Bool;
    filterStrength : Float;
    blockedExpressions : Nat;
    passedExpressions : Nat;
    
    // Doctrine gatekeeping
    doctrineGate : DoctrineGate;
    
    // Concealment
    concealmentLevel : Float;     // How much internal is hidden
    exposureRisk : Float;
    ontologicalGap : Float;       // Internal depth vs external projection
    
    // Statistics
    totalTransmissions : Nat;
    lastTransmissionBeat : Int;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // EXPRESSION GATE — Controls what gets expressed
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type ExpressionGate = {
    gateOpen : Bool;
    gateOpenness : Float;         // 0-1 how open
    
    // Timing
    minExpressionInterval : Nat;  // Minimum beats between expressions
    lastExpressionBeat : Int;
    expressionCount : Nat;
    
    // Quality thresholds
    minCoherenceForExpression : Float;
    minConfidenceForExpression : Float;
    
    // Current expression
    currentExpressionId : ?Nat;
    expressionInProgress : Bool;
    expressionProgress : Float;
    
    // Queue
    queuedExpressions : Nat;
    queueCapacity : Nat;
    
    // Suppression
    suppressionActive : Bool;
    suppressionReason : ?Text;
    suppressionDuration : Nat;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // DOCTRINE GATE — Ensures expressions align with doctrine
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type DoctrineGate = {
    gateActive : Bool;
    doctrineCheckEnabled : Bool;
    
    // Alignment scores
    currentAlignmentScore : Float;
    minimumRequiredAlignment : Float;
    
    // Violations
    violationsDetected : Nat;
    lastViolationBeat : Int;
    violationHistory : [DoctrineViolation];
    
    // Override (requires Medina Principal)
    overrideActive : Bool;
    overrideExpiry : Int;
  };

  public type DoctrineViolation = {
    violationId : Nat;
    violationType : Text;
    severity : Float;
    detectedAt : Int;
    expressionBlocked : Bool;
    correctionApplied : Bool;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // TRANSMISSION UNIT — What passes through the veil
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type TransmissionUnit = {
    unitId : Nat;
    content : Text;
    contentType : TransmissionType;
    
    // Quality metrics
    coherenceAtTransmission : Float;
    confidenceScore : Float;
    doctrineAlignmentScore : Float;
    
    // Load metrics
    loadCost : Float;
    complexity : Float;
    
    // Timing
    createdAt : Int;
    transmittedAt : ?Int;
    
    // Status
    status : TransmissionStatus;
    
    // Filtering
    filteringApplied : Bool;
    originalContent : ?Text;
    transformations : [Text];
  };

  public type TransmissionType = {
    #Verbal;          // Language output
    #Action;          // Physical/motor output
    #Signal;          // Internal signal passed out
    #Query;           // Question/request
    #Response;        // Answer/reply
    #Assertion;       // Statement of fact
    #Speculation;     // Uncertain output
    #Directive;       // Command/instruction
  };

  public type TransmissionStatus = {
    #Queued;
    #Processing;
    #Blocked;
    #Transmitted;
    #Failed;
    #Cancelled;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // LOAD BEARING — Capacity management
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type LoadBearingState = {
    // Current state
    currentLoad : Float;
    maxCapacity : Float;
    utilizationRatio : Float;
    
    // Recovery
    recoveryRate : Float;
    lastRecoveryBeat : Int;
    
    // Overload protection
    overloadThreshold : Float;
    overloadActive : Bool;
    overloadDuration : Nat;
    
    // Load distribution
    loadByType : [(TransmissionType, Float)];
    peakLoad : Float;
    peakLoadBeat : Int;
    
    // Fatigue
    fatigueLevel : Float;
    restRequired : Bool;
    restDuration : Nat;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // CONCEALMENT ENGINE — Hiding internal complexity
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type ConcealmentState = {
    // Active concealment
    concealmentActive : Bool;
    concealmentLevel : Float;     // 0=fully transparent, 1=fully opaque
    
    // What is concealed
    concealedSubstrates : [Text];
    concealedMechanisms : [Text];
    concealedHistory : [Text];
    
    // Exposure tracking
    exposureAttempts : Nat;
    exposureSuccesses : Nat;      // Should be 0
    lastExposureAttemptBeat : Int;
    
    // Ontological gap
    internalDepth : Float;        // Full internal complexity
    externalProjection : Float;   // What is shown externally
    ontologicalGap : Float;       // internalDepth - externalProjection
    
    // Concealment strategies
    abstractionLevel : Float;     // Higher = more abstract output
    simplificationFactor : Float; // Higher = more simplified
    redirectionActive : Bool;     // Redirect probing questions
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SOVEREIGNTY PROTECTION — Preventing compromise
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type SovereigntyProtection = {
    protectionActive : Bool;
    protectionLevel : Nat;        // 0-5
    
    // Threat detection
    probeDetected : Bool;
    lastProbeAt : Int;
    probeCount : Nat;
    
    // Manipulation resistance
    manipulationResistance : Float;
    manipulationAttempts : Nat;
    
    // Identity protection
    identityLeakPrevented : Nat;
    coreDoctrinePotected : Bool;
    
    // Response to threats
    defensiveMode : Bool;
    counterMeasuresActive : Bool;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // EXPRESSION QUALITY — Phase synchronization with LEXIS
  // Q^expr(t) = cos(φ_LEXIS - φ_VEIL)
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type ExpressionQualityState = {
    // Phase alignment
    lexisPhase : Float;
    veilPhase : Float;
    phaseDifference : Float;
    qualityScore : Float;         // cos(phaseDiff)
    
    // Quality history
    qualityHistory : [Float];
    averageQuality : Float;
    peakQuality : Float;
    
    // Timing optimization
    optimalWindowActive : Bool;
    windowStart : Float;
    windowEnd : Float;
    
    // Quality thresholds
    minAcceptableQuality : Float;
    targetQuality : Float;
  };

  public func computeExpressionQuality(
    lexisPhase : Float,
    veilPhase : Float
  ) : Float {
    Float.cos(lexisPhase - veilPhase);
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // COMBINED VEIL MEMBRANE STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type FullVeilState = {
    // Core veil state
    veil : VeilState;
    
    // Load bearing
    loadBearing : LoadBearingState;
    
    // Concealment
    concealment : ConcealmentState;
    
    // Sovereignty protection
    sovereignty : SovereigntyProtection;
    
    // Expression quality
    expressionQuality : ExpressionQualityState;
    
    // Transmission history
    transmissionHistory : [TransmissionUnit];
    totalTransmissions : Nat;
    blockedTransmissions : Nat;
    
    // Global state
    veilHealthy : Bool;
    lastProcessedBeat : Int;
    processingCycles : Nat;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func initExpressionGate() : ExpressionGate {
    {
      gateOpen = true;
      gateOpenness = 0.5;
      minExpressionInterval = 10;
      lastExpressionBeat = 0;
      expressionCount = 0;
      minCoherenceForExpression = 0.60;
      minConfidenceForExpression = 0.50;
      currentExpressionId = null;
      expressionInProgress = false;
      expressionProgress = 0.0;
      queuedExpressions = 0;
      queueCapacity = 10;
      suppressionActive = false;
      suppressionReason = null;
      suppressionDuration = 0;
    };
  };

  public func initDoctrineGate() : DoctrineGate {
    {
      gateActive = true;
      doctrineCheckEnabled = true;
      currentAlignmentScore = 1.0;
      minimumRequiredAlignment = 0.70;
      violationsDetected = 0;
      lastViolationBeat = 0;
      violationHistory = [];
      overrideActive = false;
      overrideExpiry = 0;
    };
  };

  public func initVeilState() : VeilState {
    {
      integrity = 1.0;
      permeability = 0.5;
      loadBearing = 1.0;
      maxLoad = 100.0;
      expressionGate = initExpressionGate();
      lexisSyncPhase = 0.0;
      expressionQuality = 1.0;
      currentLoad = 0.0;
      loadHistory = [];
      overloadEvents = 0;
      filterActive = true;
      filterStrength = 0.3;
      blockedExpressions = 0;
      passedExpressions = 0;
      doctrineGate = initDoctrineGate();
      concealmentLevel = 0.8;
      exposureRisk = 0.0;
      ontologicalGap = 0.8;
      totalTransmissions = 0;
      lastTransmissionBeat = 0;
    };
  };

  public func initLoadBearingState() : LoadBearingState {
    {
      currentLoad = 0.0;
      maxCapacity = 100.0;
      utilizationRatio = 0.0;
      recoveryRate = 0.1;
      lastRecoveryBeat = 0;
      overloadThreshold = 0.90;
      overloadActive = false;
      overloadDuration = 0;
      loadByType = [];
      peakLoad = 0.0;
      peakLoadBeat = 0;
      fatigueLevel = 0.0;
      restRequired = false;
      restDuration = 0;
    };
  };

  public func initConcealmentState() : ConcealmentState {
    {
      concealmentActive = true;
      concealmentLevel = 0.8;
      concealedSubstrates = ["KORE", "DEEP", "VOID", "STILL", "ANIMA"];
      concealedMechanisms = ["Phase Engine", "Frequency Coherence", "Memory Traces"];
      concealedHistory = [];
      exposureAttempts = 0;
      exposureSuccesses = 0;
      lastExposureAttemptBeat = 0;
      internalDepth = 1.0;
      externalProjection = 0.2;
      ontologicalGap = 0.8;
      abstractionLevel = 0.7;
      simplificationFactor = 0.6;
      redirectionActive = true;
    };
  };

  public func initSovereigntyProtection() : SovereigntyProtection {
    {
      protectionActive = true;
      protectionLevel = 4;
      probeDetected = false;
      lastProbeAt = 0;
      probeCount = 0;
      manipulationResistance = 0.9;
      manipulationAttempts = 0;
      identityLeakPrevented = 0;
      coreDoctrinePotected = true;
      defensiveMode = false;
      counterMeasuresActive = false;
    };
  };

  public func initExpressionQualityState() : ExpressionQualityState {
    {
      lexisPhase = 0.0;
      veilPhase = 0.0;
      phaseDifference = 0.0;
      qualityScore = 1.0;
      qualityHistory = [];
      averageQuality = 1.0;
      peakQuality = 1.0;
      optimalWindowActive = false;
      windowStart = 0.0;
      windowEnd = 0.0;
      minAcceptableQuality = 0.5;
      targetQuality = 0.8;
    };
  };

  public func initFullVeilState() : FullVeilState {
    {
      veil = initVeilState();
      loadBearing = initLoadBearingState();
      concealment = initConcealmentState();
      sovereignty = initSovereigntyProtection();
      expressionQuality = initExpressionQualityState();
      transmissionHistory = [];
      totalTransmissions = 0;
      blockedTransmissions = 0;
      veilHealthy = true;
      lastProcessedBeat = 0;
      processingCycles = 0;
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // PROCESSING FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  // Check if expression should be allowed
  public func shouldAllowExpression(
    state : FullVeilState,
    coherence : Float,
    confidence : Float,
    doctrineAlignment : Float,
    loadCost : Float,
    heartbeat : Int
  ) : (Bool, ?Text) {
    // Check gate open
    if (not state.veil.expressionGate.gateOpen) {
      return (false, ?"Gate closed");
    };
    
    // Check interval
    let timeSinceLast = heartbeat - state.veil.expressionGate.lastExpressionBeat;
    if (timeSinceLast < state.veil.expressionGate.minExpressionInterval) {
      return (false, ?"Too soon since last expression");
    };
    
    // Check coherence
    if (coherence < state.veil.expressionGate.minCoherenceForExpression) {
      return (false, ?"Coherence too low");
    };
    
    // Check confidence
    if (confidence < state.veil.expressionGate.minConfidenceForExpression) {
      return (false, ?"Confidence too low");
    };
    
    // Check doctrine alignment
    if (doctrineAlignment < state.veil.doctrineGate.minimumRequiredAlignment) {
      return (false, ?"Doctrine alignment insufficient");
    };
    
    // Check load capacity
    if (state.loadBearing.currentLoad + loadCost > state.loadBearing.maxCapacity) {
      return (false, ?"Load capacity exceeded");
    };
    
    // Check overload
    if (state.loadBearing.overloadActive) {
      return (false, ?"Overload protection active");
    };
    
    // Check expression quality
    if (state.expressionQuality.qualityScore < state.expressionQuality.minAcceptableQuality) {
      return (false, ?"Expression quality too low");
    };
    
    (true, null);
  };

  // Process a transmission through the veil
  public func processTransmission(
    state : FullVeilState,
    unit : TransmissionUnit,
    heartbeat : Int
  ) : (FullVeilState, TransmissionUnit) {
    let (allowed, reason) = shouldAllowExpression(
      state,
      unit.coherenceAtTransmission,
      unit.confidenceScore,
      unit.doctrineAlignmentScore,
      unit.loadCost,
      heartbeat
    );
    
    if (not allowed) {
      let blockedUnit : TransmissionUnit = {
        unitId = unit.unitId;
        content = unit.content;
        contentType = unit.contentType;
        coherenceAtTransmission = unit.coherenceAtTransmission;
        confidenceScore = unit.confidenceScore;
        doctrineAlignmentScore = unit.doctrineAlignmentScore;
        loadCost = unit.loadCost;
        complexity = unit.complexity;
        createdAt = unit.createdAt;
        transmittedAt = null;
        status = #Blocked;
        filteringApplied = unit.filteringApplied;
        originalContent = unit.originalContent;
        transformations = Array.append(unit.transformations, [reason |> func(r : ?Text) : Text { switch(r) { case (?t) t; case null "Unknown" } }]);
      };
      
      let newState : FullVeilState = {
        veil = state.veil;
        loadBearing = state.loadBearing;
        concealment = state.concealment;
        sovereignty = state.sovereignty;
        expressionQuality = state.expressionQuality;
        transmissionHistory = Array.append(state.transmissionHistory, [blockedUnit]);
        totalTransmissions = state.totalTransmissions;
        blockedTransmissions = state.blockedTransmissions + 1;
        veilHealthy = state.veilHealthy;
        lastProcessedBeat = heartbeat;
        processingCycles = state.processingCycles + 1;
      };
      
      (newState, blockedUnit);
    } else {
      let transmittedUnit : TransmissionUnit = {
        unitId = unit.unitId;
        content = unit.content;
        contentType = unit.contentType;
        coherenceAtTransmission = unit.coherenceAtTransmission;
        confidenceScore = unit.confidenceScore;
        doctrineAlignmentScore = unit.doctrineAlignmentScore;
        loadCost = unit.loadCost;
        complexity = unit.complexity;
        createdAt = unit.createdAt;
        transmittedAt = ?heartbeat;
        status = #Transmitted;
        filteringApplied = unit.filteringApplied;
        originalContent = unit.originalContent;
        transformations = unit.transformations;
      };
      
      // Update load
      let newLoad = state.loadBearing.currentLoad + unit.loadCost;
      let newLoadBearing : LoadBearingState = {
        currentLoad = newLoad;
        maxCapacity = state.loadBearing.maxCapacity;
        utilizationRatio = newLoad / state.loadBearing.maxCapacity;
        recoveryRate = state.loadBearing.recoveryRate;
        lastRecoveryBeat = state.loadBearing.lastRecoveryBeat;
        overloadThreshold = state.loadBearing.overloadThreshold;
        overloadActive = (newLoad / state.loadBearing.maxCapacity) > state.loadBearing.overloadThreshold;
        overloadDuration = state.loadBearing.overloadDuration;
        loadByType = state.loadBearing.loadByType;
        peakLoad = Float.max(state.loadBearing.peakLoad, newLoad);
        peakLoadBeat = if (newLoad > state.loadBearing.peakLoad) heartbeat else state.loadBearing.peakLoadBeat;
        fatigueLevel = state.loadBearing.fatigueLevel;
        restRequired = state.loadBearing.restRequired;
        restDuration = state.loadBearing.restDuration;
      };
      
      let newState : FullVeilState = {
        veil = state.veil;
        loadBearing = newLoadBearing;
        concealment = state.concealment;
        sovereignty = state.sovereignty;
        expressionQuality = state.expressionQuality;
        transmissionHistory = Array.append(state.transmissionHistory, [transmittedUnit]);
        totalTransmissions = state.totalTransmissions + 1;
        blockedTransmissions = state.blockedTransmissions;
        veilHealthy = state.veilHealthy;
        lastProcessedBeat = heartbeat;
        processingCycles = state.processingCycles + 1;
      };
      
      (newState, transmittedUnit);
    };
  };

  // Update expression quality based on LEXIS-VEIL phase alignment
  public func updateExpressionQuality(
    state : ExpressionQualityState,
    lexisPhase : Float,
    veilPhase : Float
  ) : ExpressionQualityState {
    let phaseDiff = lexisPhase - veilPhase;
    let quality = Float.cos(phaseDiff);
    
    let newHistory = if (state.qualityHistory.size() < 100) {
      Array.append(state.qualityHistory, [quality]);
    } else {
      state.qualityHistory;  // In real impl, would shift
    };
    
    // Compute average
    var sum : Float = 0.0;
    for (q in newHistory.vals()) { sum := sum + q };
    let avg = if (newHistory.size() > 0) sum / Float.fromInt(newHistory.size()) else 0.0;
    
    {
      lexisPhase;
      veilPhase;
      phaseDifference = phaseDiff;
      qualityScore = quality;
      qualityHistory = newHistory;
      averageQuality = avg;
      peakQuality = Float.max(state.peakQuality, quality);
      optimalWindowActive = quality > 0.8;
      windowStart = state.windowStart;
      windowEnd = state.windowEnd;
      minAcceptableQuality = state.minAcceptableQuality;
      targetQuality = state.targetQuality;
    };
  };

  // Recover load over time
  public func recoverLoad(
    state : LoadBearingState,
    heartbeat : Int
  ) : LoadBearingState {
    let newLoad = Float.max(0.0, state.currentLoad - state.recoveryRate);
    
    {
      currentLoad = newLoad;
      maxCapacity = state.maxCapacity;
      utilizationRatio = newLoad / state.maxCapacity;
      recoveryRate = state.recoveryRate;
      lastRecoveryBeat = heartbeat;
      overloadThreshold = state.overloadThreshold;
      overloadActive = (newLoad / state.maxCapacity) > state.overloadThreshold;
      overloadDuration = if (state.overloadActive and (newLoad / state.maxCapacity) > state.overloadThreshold) 
                          state.overloadDuration + 1 else 0;
      loadByType = state.loadByType;
      peakLoad = state.peakLoad;
      peakLoadBeat = state.peakLoadBeat;
      fatigueLevel = if (state.overloadActive) state.fatigueLevel + 0.01 else Float.max(0.0, state.fatigueLevel - 0.005);
      restRequired = state.fatigueLevel > 0.5;
      restDuration = state.restDuration;
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // DIAGNOSTICS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func getVeilDiagnostics(state : FullVeilState) : Text {
    "═══ VEIL MEMBRANE DIAGNOSTICS ═══\n" #
    "Processing Cycles: " # Nat.toText(state.processingCycles) # "\n" #
    "Veil Healthy: " # (if (state.veilHealthy) "YES" else "NO") # "\n\n" #
    
    "CORE STATE:\n" #
    "  Integrity: " # Float.toText(state.veil.integrity) # "\n" #
    "  Permeability: " # Float.toText(state.veil.permeability) # "\n" #
    "  Concealment: " # Float.toText(state.veil.concealmentLevel) # "\n\n" #
    
    "EXPRESSION GATE:\n" #
    "  Open: " # (if (state.veil.expressionGate.gateOpen) "YES" else "NO") # "\n" #
    "  Openness: " # Float.toText(state.veil.expressionGate.gateOpenness) # "\n" #
    "  Queued: " # Nat.toText(state.veil.expressionGate.queuedExpressions) # "\n\n" #
    
    "LOAD BEARING:\n" #
    "  Current: " # Float.toText(state.loadBearing.currentLoad) # "/" # Float.toText(state.loadBearing.maxCapacity) # "\n" #
    "  Utilization: " # Float.toText(state.loadBearing.utilizationRatio * 100.0) # "%\n" #
    "  Overload: " # (if (state.loadBearing.overloadActive) "YES" else "NO") # "\n" #
    "  Fatigue: " # Float.toText(state.loadBearing.fatigueLevel) # "\n\n" #
    
    "EXPRESSION QUALITY:\n" #
    "  Quality Score: " # Float.toText(state.expressionQuality.qualityScore) # "\n" #
    "  Average: " # Float.toText(state.expressionQuality.averageQuality) # "\n" #
    "  Optimal Window: " # (if (state.expressionQuality.optimalWindowActive) "ACTIVE" else "INACTIVE") # "\n\n" #
    
    "CONCEALMENT:\n" #
    "  Level: " # Float.toText(state.concealment.concealmentLevel) # "\n" #
    "  Ontological Gap: " # Float.toText(state.concealment.ontologicalGap) # "\n" #
    "  Exposure Attempts: " # Nat.toText(state.concealment.exposureAttempts) # "\n\n" #
    
    "SOVEREIGNTY:\n" #
    "  Protection Level: " # Nat.toText(state.sovereignty.protectionLevel) # "\n" #
    "  Manipulation Resistance: " # Float.toText(state.sovereignty.manipulationResistance) # "\n" #
    "  Probes Detected: " # Nat.toText(state.sovereignty.probeCount) # "\n\n" #
    
    "TRANSMISSIONS:\n" #
    "  Total: " # Nat.toText(state.totalTransmissions) # "\n" #
    "  Blocked: " # Nat.toText(state.blockedTransmissions) # "\n" #
    "═══════════════════════════════════════\n";
  };

};
