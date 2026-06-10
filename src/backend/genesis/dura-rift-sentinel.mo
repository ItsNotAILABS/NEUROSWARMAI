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

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// DURA-RIFT-SENTINEL — 6-AXIS HELIX COVERAGE, CONSEQUENCE DEPTH, AND DEVIATION MONITORING
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// CONFIRMED GAPS FILLED:
// ─────────────────────
// 1. DURA — 6-axis helix coverage tracking with _updateDURA() and dura_coverage
// 2. RIFT — Consequence depth tracking with _updateRIFT() and riftConsequenceDepth
// 3. SENTINEL — Deviation monitoring with _updateSENTINEL() and sentinelDeviation
//
// DURA (Deep Universal Rotational Anchor):
// The 6-axis helix that covers the full spherical surface over time, ensuring no blind spots.
// Built on Jasmine's architecture with two additional axes for complete coverage.
//
// RIFT (Reality Integration Feedback Terminus):
// Tracks the consequence depth of decisions and actions — how far the ripples travel.
//
// SENTINEL (Security Enforcement Network Through Integrated Nexus of Elevated Logic):
// Monitors all system deviations and triggers alerts when thresholds are exceeded.
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Nat8 "mo:core/Nat8";
import Nat32 "mo:core/Nat32";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Iter "mo:core/Iter";
import Text "mo:core/Text";
import Time "mo:core/Time";
import Option "mo:core/Option";
import Bool "mo:core/Bool";

module DURALRIFTSENTINELModule {

  // ═══════════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let PI : Float = 3.14159265358979323846;
  public let TWO_PI : Float = 6.28318530717958647692;
  
  // DURA 6-axis helix rates
  public let DURA_AXIS1_RATE : Float = 0.031415;   // ~2° per beat
  public let DURA_AXIS2_RATE : Float = 0.017453;   // ~1° per beat
  public let DURA_AXIS3_RATE : Float = 0.012217;   // ~0.7° per beat
  public let DURA_AXIS4_RATE : Float = 0.008727;   // ~0.5° per beat
  public let DURA_AXIS5_RATE : Float = 0.006109;   // ~0.35° per beat
  public let DURA_AXIS6_RATE : Float = 0.004363;   // ~0.25° per beat
  
  // RIFT consequence depth constants
  public let RIFT_DECAY_RATE : Float = 0.95;       // Consequence decay per beat
  public let RIFT_MAX_DEPTH : Nat = 100;           // Maximum consequence depth
  public let RIFT_PROPAGATION_FACTOR : Float = 0.8;
  
  // SENTINEL deviation thresholds
  public let SENTINEL_WARNING_THRESHOLD : Float = 0.1;
  public let SENTINEL_ALERT_THRESHOLD : Float = 0.2;
  public let SENTINEL_CRITICAL_THRESHOLD : Float = 0.3;
  public let SENTINEL_EMERGENCY_THRESHOLD : Float = 0.5;

  // ═══════════════════════════════════════════════════════════════════════════════
  // DURA — 6-AXIS HELIX COVERAGE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// DURAState for 6-axis helix coverage tracking
  public type DURAState = {
    /// 6 axis angles
    axis1 : Float;  // Primary rotation (Jasmine theta)
    axis2 : Float;  // Secondary rotation (Jasmine phi)
    axis3 : Float;  // Tertiary rotation
    axis4 : Float;  // Quaternary rotation
    axis5 : Float;  // Quinary rotation
    axis6 : Float;  // Senary rotation
    
    /// Coverage metric [0, 1] — how much of the spherical surface has been covered
    dura_coverage : Float;
    
    /// Coverage map (simplified: sectors visited)
    sectorsVisited : Nat;
    totalSectors : Nat;
    
    /// Current position on the 6D hypersphere
    currentPosition : [Float];  // 6 values
    
    /// Accumulated coverage score
    accumulatedCoverage : Float;
    
    /// Total rotations completed per axis
    rotationsCompleted : [Nat];  // 6 values
    
    /// Is coverage complete? (visited all sectors at least once)
    isCoverageComplete : Bool;
    
    /// Heartbeat
    heartbeat : Nat;
  };
  
  /// Update DURA state — THE MISSING _updateDURA() FUNCTION
  public func _updateDURA(state : DURAState) : DURAState {
    // Advance all 6 axes
    let newAxis1 = normalizeAngle(state.axis1 + DURA_AXIS1_RATE);
    let newAxis2 = normalizeAngle(state.axis2 + DURA_AXIS2_RATE);
    let newAxis3 = normalizeAngle(state.axis3 + DURA_AXIS3_RATE);
    let newAxis4 = normalizeAngle(state.axis4 + DURA_AXIS4_RATE);
    let newAxis5 = normalizeAngle(state.axis5 + DURA_AXIS5_RATE);
    let newAxis6 = normalizeAngle(state.axis6 + DURA_AXIS6_RATE);
    
    // Compute current position on 6D hypersphere
    let position = [
      Float.sin(newAxis1) * Float.cos(newAxis2),
      Float.sin(newAxis1) * Float.sin(newAxis2),
      Float.cos(newAxis1) * Float.cos(newAxis3),
      Float.cos(newAxis1) * Float.sin(newAxis3),
      Float.sin(newAxis4) * Float.cos(newAxis5),
      Float.sin(newAxis4) * Float.sin(newAxis5) * Float.cos(newAxis6)
    ];
    
    // Track sector visits (simplified: discretize position)
    let sectorIndex = computeSectorIndex(position);
    let newSectorsVisited = if (sectorIndex > state.sectorsVisited) {
      state.sectorsVisited + 1
    } else { state.sectorsVisited };
    
    // Compute coverage
    let dura_coverage = Float.fromInt(newSectorsVisited) / Float.fromInt(state.totalSectors);
    let accumulatedCoverage = state.accumulatedCoverage + dura_coverage * 0.001;
    
    // Track rotation completions
    let rotations = [
      countRotations(state.axis1, newAxis1, state.rotationsCompleted[0]),
      countRotations(state.axis2, newAxis2, state.rotationsCompleted[1]),
      countRotations(state.axis3, newAxis3, state.rotationsCompleted[2]),
      countRotations(state.axis4, newAxis4, state.rotationsCompleted[3]),
      countRotations(state.axis5, newAxis5, state.rotationsCompleted[4]),
      countRotations(state.axis6, newAxis6, state.rotationsCompleted[5])
    ];
    
    {
      axis1 = newAxis1;
      axis2 = newAxis2;
      axis3 = newAxis3;
      axis4 = newAxis4;
      axis5 = newAxis5;
      axis6 = newAxis6;
      dura_coverage = dura_coverage;
      sectorsVisited = newSectorsVisited;
      totalSectors = state.totalSectors;
      currentPosition = position;
      accumulatedCoverage = accumulatedCoverage;
      rotationsCompleted = rotations;
      isCoverageComplete = dura_coverage >= 0.99;
      heartbeat = state.heartbeat + 1;
    }
  };
  
  // Helper functions
  func normalizeAngle(angle : Float) : Float {
    var a = angle;
    while (a >= TWO_PI) { a -= TWO_PI; };
    while (a < 0.0) { a += TWO_PI; };
    a
  };
  
  func computeSectorIndex(position : [Float]) : Nat {
    var hash : Nat = 0;
    for (i in Iter.range(0, 5)) {
      let discretized = Float.toInt(position[i] * 100.0 + 100.0);
      hash := hash * 200 + Int.abs(discretized);
    };
    hash % 10000  // 10000 sectors
  };
  
  func countRotations(oldAngle : Float, newAngle : Float, current : Nat) : Nat {
    if (oldAngle > PI and newAngle < PI) { current + 1 }
    else { current }
  };
  
  /// Create default DURA state
  public func createDefaultDURAState() : DURAState {
    {
      axis1 = 0.0;
      axis2 = 0.0;
      axis3 = 0.0;
      axis4 = 0.0;
      axis5 = 0.0;
      axis6 = 0.0;
      dura_coverage = 0.0;
      sectorsVisited = 0;
      totalSectors = 10000;
      currentPosition = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
      accumulatedCoverage = 0.0;
      rotationsCompleted = [0, 0, 0, 0, 0, 0];
      isCoverageComplete = false;
      heartbeat = 0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // RIFT — CONSEQUENCE DEPTH TRACKING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// RIFTEvent represents a consequence-generating event
  public type RIFTEvent = {
    eventId : Nat;
    eventType : Text;
    initialMagnitude : Float;
    currentMagnitude : Float;
    depth : Nat;  // How many steps the consequence has propagated
    originHeartbeat : Nat;
    lastPropagation : Nat;
    isActive : Bool;
  };
  
  /// RIFTState for consequence depth tracking
  public type RIFTState = {
    /// Active events with their consequence depths
    activeEvents : [RIFTEvent];
    
    /// Total consequence depth (sum of all active event depths)
    riftConsequenceDepth : Nat;
    
    /// Maximum observed depth
    maxObservedDepth : Nat;
    
    /// Average consequence magnitude
    averageMagnitude : Float;
    
    /// Total events tracked
    totalEventsTracked : Nat;
    
    /// Events that reached maximum depth
    eventsAtMaxDepth : Nat;
    
    /// Heartbeat
    heartbeat : Nat;
  };
  
  /// Update RIFT state — THE MISSING _updateRIFT() FUNCTION
  public func _updateRIFT(state : RIFTState) : RIFTState {
    let heartbeat = state.heartbeat + 1;
    
    // Propagate all active events
    let updatedEvents = Buffer.Buffer<RIFTEvent>(Array.size(state.activeEvents));
    var totalDepth : Nat = 0;
    var maxDepth : Nat = state.maxObservedDepth;
    var sumMagnitude : Float = 0.0;
    var eventsAtMax : Nat = state.eventsAtMaxDepth;
    
    for (i in Iter.range(0, Array.size(state.activeEvents) - 1)) {
      let event = state.activeEvents[i];
      
      if (event.isActive) {
        // Decay magnitude
        let newMagnitude = event.currentMagnitude * RIFT_DECAY_RATE;
        
        // Propagate depth if magnitude is still significant
        let (newDepth, stillActive) = if (newMagnitude > 0.01 and event.depth < RIFT_MAX_DEPTH) {
          (event.depth + 1, true)
        } else if (event.depth >= RIFT_MAX_DEPTH) {
          eventsAtMax += 1;
          (event.depth, false)
        } else {
          (event.depth, false)
        };
        
        if (newDepth > maxDepth) { maxDepth := newDepth; };
        
        let updatedEvent = {
          eventId = event.eventId;
          eventType = event.eventType;
          initialMagnitude = event.initialMagnitude;
          currentMagnitude = newMagnitude;
          depth = newDepth;
          originHeartbeat = event.originHeartbeat;
          lastPropagation = heartbeat;
          isActive = stillActive;
        };
        
        if (stillActive) {
          updatedEvents.add(updatedEvent);
          totalDepth += newDepth;
          sumMagnitude += newMagnitude;
        };
      };
    };
    
    let activeCount = updatedEvents.size();
    let avgMag = if (activeCount > 0) { sumMagnitude / Float.fromInt(activeCount) } else { 0.0 };
    
    {
      activeEvents = Buffer.toArray(updatedEvents);
      riftConsequenceDepth = totalDepth;
      maxObservedDepth = maxDepth;
      averageMagnitude = avgMag;
      totalEventsTracked = state.totalEventsTracked;
      eventsAtMaxDepth = eventsAtMax;
      heartbeat = heartbeat;
    }
  };
  
  /// Add new RIFT event
  public func addRIFTEvent(
    state : RIFTState,
    eventType : Text,
    magnitude : Float
  ) : RIFTState {
    let newEvent = {
      eventId = state.totalEventsTracked;
      eventType = eventType;
      initialMagnitude = magnitude;
      currentMagnitude = magnitude;
      depth = 0;
      originHeartbeat = state.heartbeat;
      lastPropagation = state.heartbeat;
      isActive = true;
    };
    
    let events = Buffer.fromArray<RIFTEvent>(state.activeEvents);
    events.add(newEvent);
    
    {
      activeEvents = Buffer.toArray(events);
      riftConsequenceDepth = state.riftConsequenceDepth;
      maxObservedDepth = state.maxObservedDepth;
      averageMagnitude = state.averageMagnitude;
      totalEventsTracked = state.totalEventsTracked + 1;
      eventsAtMaxDepth = state.eventsAtMaxDepth;
      heartbeat = state.heartbeat;
    }
  };
  
  /// Create default RIFT state
  public func createDefaultRIFTState() : RIFTState {
    {
      activeEvents = [];
      riftConsequenceDepth = 0;
      maxObservedDepth = 0;
      averageMagnitude = 0.0;
      totalEventsTracked = 0;
      eventsAtMaxDepth = 0;
      heartbeat = 0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SENTINEL — DEVIATION MONITORING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// SENTINELAlert represents a deviation alert
  public type SENTINELAlert = {
    alertId : Nat;
    systemName : Text;
    deviationType : DeviationType;
    deviation : Float;
    threshold : Float;
    detectedAt : Nat;
    isAcknowledged : Bool;
    isResolved : Bool;
  };
  
  /// DeviationType classification
  public type DeviationType = {
    #Warning;
    #Alert;
    #Critical;
    #Emergency;
  };
  
  /// MonitoredSystem for SENTINEL tracking
  public type MonitoredSystem = {
    systemName : Text;
    currentValue : Float;
    expectedValue : Float;
    deviation : Float;
    deviationType : ?DeviationType;
    lastUpdate : Nat;
  };
  
  /// SENTINELState for deviation monitoring
  public type SENTINELState = {
    /// All monitored systems
    monitoredSystems : [MonitoredSystem];
    
    /// Total deviation (sum of all system deviations)
    sentinelDeviation : Float;
    
    /// Maximum single-system deviation
    maxDeviation : Float;
    
    /// System with maximum deviation
    maxDeviationSystem : Text;
    
    /// Active alerts
    activeAlerts : [SENTINELAlert];
    
    /// Total alerts generated
    totalAlerts : Nat;
    
    /// Resolved alerts
    resolvedAlerts : Nat;
    
    /// Is system in alert mode?
    inAlertMode : Bool;
    
    /// Is system in emergency mode?
    inEmergencyMode : Bool;
    
    /// Heartbeat
    heartbeat : Nat;
  };
  
  /// Classify deviation type
  func classifyDeviation(deviation : Float) : ?DeviationType {
    if (deviation >= SENTINEL_EMERGENCY_THRESHOLD) { ?#Emergency }
    else if (deviation >= SENTINEL_CRITICAL_THRESHOLD) { ?#Critical }
    else if (deviation >= SENTINEL_ALERT_THRESHOLD) { ?#Alert }
    else if (deviation >= SENTINEL_WARNING_THRESHOLD) { ?#Warning }
    else { null }
  };
  
  /// Update SENTINEL state — THE MISSING _updateSENTINEL() FUNCTION
  public func _updateSENTINEL(
    state : SENTINELState,
    systemUpdates : [(Text, Float, Float)]  // (systemName, currentValue, expectedValue)
  ) : SENTINELState {
    let heartbeat = state.heartbeat + 1;
    
    // Update all monitored systems
    let updatedSystems = Buffer.Buffer<MonitoredSystem>(Array.size(systemUpdates));
    var totalDeviation : Float = 0.0;
    var maxDev : Float = 0.0;
    var maxDevSystem : Text = "";
    let newAlerts = Buffer.Buffer<SENTINELAlert>(0);
    var alertCount = state.totalAlerts;
    var inAlert = false;
    var inEmergency = false;
    
    for (i in Iter.range(0, Array.size(systemUpdates) - 1)) {
      let (name, current, expected) = systemUpdates[i];
      let deviation = Float.abs(current - expected) / Float.max(0.001, expected);
      
      totalDeviation += deviation;
      if (deviation > maxDev) {
        maxDev := deviation;
        maxDevSystem := name;
      };
      
      let devType = classifyDeviation(deviation);
      
      let system = {
        systemName = name;
        currentValue = current;
        expectedValue = expected;
        deviation = deviation;
        deviationType = devType;
        lastUpdate = heartbeat;
      };
      updatedSystems.add(system);
      
      // Generate alert if needed
      switch (devType) {
        case (?#Warning) { inAlert := true; };
        case (?#Alert) { inAlert := true; };
        case (?#Critical) { inAlert := true; };
        case (?#Emergency) { 
          inAlert := true;
          inEmergency := true;
          
          // Create emergency alert
          let alert = {
            alertId = alertCount;
            systemName = name;
            deviationType = #Emergency;
            deviation = deviation;
            threshold = SENTINEL_EMERGENCY_THRESHOLD;
            detectedAt = heartbeat;
            isAcknowledged = false;
            isResolved = false;
          };
          newAlerts.add(alert);
          alertCount += 1;
        };
        case (null) {};
      };
    };
    
    // Combine existing unresolved alerts with new ones
    let allAlerts = Buffer.fromArray<SENTINELAlert>(state.activeAlerts);
    for (alert in newAlerts.vals()) {
      allAlerts.add(alert);
    };
    
    let sentinelDeviation = totalDeviation / Float.fromInt(Array.size(systemUpdates));
    
    {
      monitoredSystems = Buffer.toArray(updatedSystems);
      sentinelDeviation = sentinelDeviation;
      maxDeviation = maxDev;
      maxDeviationSystem = maxDevSystem;
      activeAlerts = Buffer.toArray(allAlerts);
      totalAlerts = alertCount;
      resolvedAlerts = state.resolvedAlerts;
      inAlertMode = inAlert;
      inEmergencyMode = inEmergency;
      heartbeat = heartbeat;
    }
  };
  
  /// Acknowledge alert
  public func acknowledgeAlert(state : SENTINELState, alertId : Nat) : SENTINELState {
    let updatedAlerts = Array.tabulate<SENTINELAlert>(Array.size(state.activeAlerts), func(i : Nat) : SENTINELAlert {
      let alert = state.activeAlerts[i];
      if (alert.alertId == alertId) {
        {
          alertId = alert.alertId;
          systemName = alert.systemName;
          deviationType = alert.deviationType;
          deviation = alert.deviation;
          threshold = alert.threshold;
          detectedAt = alert.detectedAt;
          isAcknowledged = true;
          isResolved = alert.isResolved;
        }
      } else {
        alert
      }
    });
    
    {
      monitoredSystems = state.monitoredSystems;
      sentinelDeviation = state.sentinelDeviation;
      maxDeviation = state.maxDeviation;
      maxDeviationSystem = state.maxDeviationSystem;
      activeAlerts = updatedAlerts;
      totalAlerts = state.totalAlerts;
      resolvedAlerts = state.resolvedAlerts;
      inAlertMode = state.inAlertMode;
      inEmergencyMode = state.inEmergencyMode;
      heartbeat = state.heartbeat;
    }
  };
  
  /// Resolve alert
  public func resolveAlert(state : SENTINELState, alertId : Nat) : SENTINELState {
    let remainingAlerts = Buffer.Buffer<SENTINELAlert>(0);
    var resolved = state.resolvedAlerts;
    
    for (i in Iter.range(0, Array.size(state.activeAlerts) - 1)) {
      let alert = state.activeAlerts[i];
      if (alert.alertId == alertId) {
        resolved += 1;
      } else {
        remainingAlerts.add(alert);
      };
    };
    
    // Check if still in alert/emergency mode
    var stillInAlert = false;
    var stillInEmergency = false;
    for (alert in remainingAlerts.vals()) {
      if (not alert.isResolved) {
        stillInAlert := true;
        switch (alert.deviationType) {
          case (#Emergency) { stillInEmergency := true; };
          case _ {};
        };
      };
    };
    
    {
      monitoredSystems = state.monitoredSystems;
      sentinelDeviation = state.sentinelDeviation;
      maxDeviation = state.maxDeviation;
      maxDeviationSystem = state.maxDeviationSystem;
      activeAlerts = Buffer.toArray(remainingAlerts);
      totalAlerts = state.totalAlerts;
      resolvedAlerts = resolved;
      inAlertMode = stillInAlert;
      inEmergencyMode = stillInEmergency;
      heartbeat = state.heartbeat;
    }
  };
  
  /// Create default SENTINEL state
  public func createDefaultSENTINELState() : SENTINELState {
    {
      monitoredSystems = [];
      sentinelDeviation = 0.0;
      maxDeviation = 0.0;
      maxDeviationSystem = "";
      activeAlerts = [];
      totalAlerts = 0;
      resolvedAlerts = 0;
      inAlertMode = false;
      inEmergencyMode = false;
      heartbeat = 0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // COMBINED STATE AND PROCESSING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// CombinedDRSState for DURA, RIFT, and SENTINEL
  public type CombinedDRSState = {
    dura : DURAState;
    rift : RIFTState;
    sentinel : SENTINELState;
    heartbeat : Nat;
    lastUpdate : Int;
  };
  
  /// Create default combined state
  public func createDefaultCombinedState() : CombinedDRSState {
    {
      dura = createDefaultDURAState();
      rift = createDefaultRIFTState();
      sentinel = createDefaultSENTINELState();
      heartbeat = 0;
      lastUpdate = Time.now();
    }
  };
  
  /// Process combined heartbeat
  public func processCombinedHeartbeat(
    state : CombinedDRSState,
    systemUpdates : [(Text, Float, Float)]
  ) : CombinedDRSState {
    {
      dura = _updateDURA(state.dura);
      rift = _updateRIFT(state.rift);
      sentinel = _updateSENTINEL(state.sentinel, systemUpdates);
      heartbeat = state.heartbeat + 1;
      lastUpdate = Time.now();
    }
  };
  
  // Query functions
  public func getDuraCoverage(state : CombinedDRSState) : Float { state.dura.dura_coverage };
  public func getRiftConsequenceDepth(state : CombinedDRSState) : Nat { state.rift.riftConsequenceDepth };
  public func getSentinelDeviation(state : CombinedDRSState) : Float { state.sentinel.sentinelDeviation };
  public func isInEmergency(state : CombinedDRSState) : Bool { state.sentinel.inEmergencyMode };

}
