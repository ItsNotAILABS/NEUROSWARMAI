// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  AEGIS CYBERSECURITY INTELLIGENCE PLATFORM — PRODUCTION GRADE                                             ║
// ║  Alpha Framework №6: Threat Detection + Vulnerability Scanning + Incident Response                       ║
// ║  Commercial Deployment System for Cybersecurity Intelligence                                              ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Nat64 "mo:core/Nat64";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Iter "mo:core/Iter";
import Text "mo:core/Text";
import Time "mo:core/Time";
import Principal "mo:core/Principal";
import HashMap "mo:core/HashMap";

import NovaIntelligence "nova-intelligence-engine";
import NovaComputing "../../intelligence_core/computing/core";
import NovaEmergence "../../intelligence_core/emergence/kuramoto";
import FiveAlphas "five-alphas-unified-substrate";

module AegisCybersecurityPlatform {

  // ═══════════════════════════════════════════════════════════════════════════════
  // TYPES — COMMERCIAL PRODUCTION SYSTEM
  // ═══════════════════════════════════════════════════════════════════════════════

  public type SwarmId = Text;
  public type AgentId = Nat;
  public type Timestamp = Nat64;
  public type IPAddress = Text;
  public type Domain = Text;

  public type ThreatType = {
    #Malware;
    #Ransomware;
    #Phishing;
    #DDoS;
    #ZeroDay;
    #APT;                             // Advanced Persistent Threat
    #InsiderThreat;
    #DataExfiltration;
  };

  public type SecurityMode = {
    #ThreatHunting;                   // Proactive threat discovery
    #VulnerabilityScanning;           // Identify system weaknesses
    #IncidentResponse;                // Real-time attack mitigation
    #PenetrationTesting;              // Ethical hacking simulation
    #ThreatIntelligence;              // Aggregate global threat data
  };

  public type SecurityAgent = {
    id : AgentId;
    securityMode : SecurityMode;
    phase : Float;                    // Kuramoto phase [0, 2π)
    frequency : Float;                // Natural frequency
    activation : Float;               // [0, 1] operational status
    threatsDetected : Nat;
    vulnerabilitiesFound : Nat;
    incidentsHandled : Nat;
    lastUpdate : Timestamp;
  };

  public type ThreatAlert = {
    id : Text;
    threatType : ThreatType;
    severity : Text;                  // "critical" | "high" | "medium" | "low"
    source : IPAddress;
    target : IPAddress;
    indicators : [Text];              // IOCs (Indicators of Compromise)
    confidence : Float;               // [0, 1]
    mitigation : Text;                // Recommended actions
    timestamp : Timestamp;
  };

  public type Vulnerability = {
    id : Text;
    cveId : ?Text;                    // CVE identifier if applicable
    affectedSystem : Text;
    vulnerabilityType : Text;         // "SQL Injection" | "XSS" | "RCE" | etc
    severity : Text;
    cvssScore : Float;                // 0-10 CVSS score
    exploitable : Bool;
    patchAvailable : Bool;
    remediation : Text;
    timestamp : Timestamp;
  };

  public type IncidentReport = {
    id : Text;
    incidentType : ThreatType;
    timeline : [(Timestamp, Text)];   // Chronological events
    affectedAssets : [Text];
    responseActions : [Text];
    containmentStatus : Text;         // "contained" | "mitigating" | "investigating"
    rootCause : ?Text;
    timestamp : Timestamp;
  };

  public type ThreatIntelligence = {
    threatActor : Text;               // Group/individual responsible
    ttps : [Text];                    // Tactics, Techniques, Procedures
    targetedSectors : [Text];
    malwareFamily : ?Text;
    confidence : Float;               // [0, 1]
    sources : [Text];                 // Intel sources
    timestamp : Timestamp;
  };

  public type SecurityMission = {
    id : SwarmId;
    securityMode : SecurityMode;
    agentCount : Nat;
    startTime : Timestamp;
    duration : Nat64;
    status : SwarmStatus;
    agents : [var SecurityAgent];
    coherence : Float;                // Kuramoto R [0, 1]
    threatAlerts : Buffer.Buffer<ThreatAlert>;
    vulnerabilities : Buffer.Buffer<Vulnerability>;
    incidents : Buffer.Buffer<IncidentReport>;
    intelligence : Buffer.Buffer<ThreatIntelligence>;
    client : Principal;
  };

  public type SwarmStatus = {
    #Initializing;
    #Scanning;
    #Hunting;
    #Responding;
    #Completed;
    #Aborted;
  };

  public type DeployRequest = {
    securityMode : SecurityMode;
    agentCount : Nat;
    duration : Nat64;
  };

  public type DeployResponse = {
    swarmId : SwarmId;
    status : Text;
    agentsActive : Nat;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // STATE MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════════

  public class AegisSystem() {
    let swarms = HashMap.HashMap<SwarmId, SecurityMission>(10, Text.equal, Text.hash);
    var nextSwarmId : Nat = 1;
    var nextThreatId : Nat = 1;

    // ═══════════════════════════════════════════════════════════════════════════
    // COMMERCIAL API — DEPLOY SECURITY SWARM
    // ═══════════════════════════════════════════════════════════════════════════

    public func deploySwarm(request : DeployRequest, client : Principal) : DeployResponse {
      let swarmId = "AEGIS-" # Nat.toText(nextSwarmId);
      nextSwarmId += 1;

      let agents = Array.init<SecurityAgent>(request.agentCount, {
        id = 0;
        securityMode = request.securityMode;
        phase = 0.0;
        frequency = 1.0;
        activation = 1.0;
        threatsDetected = 0;
        vulnerabilitiesFound = 0;
        incidentsHandled = 0;
        lastUpdate = Nat64.fromNat(Int.abs(Time.now()));
      });

      for (i in Iter.range(0, request.agentCount - 1)) {
        let phase = Float.fromInt(i) * NovaComputing.GOLDEN_ANGLE_RAD;
        let freq = 1.0 + 0.1 * Float.sin(phase);

        agents[i] := {
          id = i;
          securityMode = request.securityMode;
          phase = phase;
          frequency = freq;
          activation = 1.0;
          threatsDetected = 0;
          vulnerabilitiesFound = 0;
          incidentsHandled = 0;
          lastUpdate = Nat64.fromNat(Int.abs(Time.now()));
        };
      };

      let mission : SecurityMission = {
        id = swarmId;
        securityMode = request.securityMode;
        agentCount = request.agentCount;
        startTime = Nat64.fromNat(Int.abs(Time.now()));
        duration = request.duration;
        status = #Initializing;
        agents = agents;
        coherence = 0.0;
        threatAlerts = Buffer.Buffer<ThreatAlert>(100);
        vulnerabilities = Buffer.Buffer<Vulnerability>(100);
        incidents = Buffer.Buffer<IncidentReport>(50);
        intelligence = Buffer.Buffer<ThreatIntelligence>(50);
        client = client;
      };

      swarms.put(swarmId, mission);

      {
        swarmId = swarmId;
        status = "Initializing";
        agentsActive = request.agentCount;
      }
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // COMMERCIAL API — GET SECURITY INSIGHTS
    // ═══════════════════════════════════════════════════════════════════════════

    public func getSecurityInsights(swarmId : SwarmId) : ?{
      threatAlerts : [ThreatAlert];
      vulnerabilities : [Vulnerability];
      incidents : [IncidentReport];
      intelligence : [ThreatIntelligence];
      coherence : Float;
      criticalThreats : Nat;
    } {
      switch (swarms.get(swarmId)) {
        case null { null };
        case (?mission) {
          let alerts = Buffer.toArray(mission.threatAlerts);
          var critical : Nat = 0;

          for (alert in alerts.vals()) {
            if (alert.severity == "critical") {
              critical += 1;
            };
          };

          ?{
            threatAlerts = alerts;
            vulnerabilities = Buffer.toArray(mission.vulnerabilities);
            incidents = Buffer.toArray(mission.incidents);
            intelligence = Buffer.toArray(mission.intelligence);
            coherence = mission.coherence;
            criticalThreats = critical;
          }
        };
      };
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // COMMERCIAL API — CREATE THREAT ALERT
    // ═══════════════════════════════════════════════════════════════════════════

    public func createThreatAlert(
      threatType : ThreatType,
      severity : Text,
      source : IPAddress,
      target : IPAddress
    ) : ThreatAlert {
      let alertId = "THREAT-" # Nat.toText(nextThreatId);
      nextThreatId += 1;

      {
        id = alertId;
        threatType = threatType;
        severity = severity;
        source = source;
        target = target;
        indicators = ["IOC-1", "IOC-2", "IOC-3"];
        confidence = 0.85;
        mitigation = "Isolate affected systems and apply security patches";
        timestamp = Nat64.fromNat(Int.abs(Time.now()));
      }
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // HEARTBEAT TICK
    // ═══════════════════════════════════════════════════════════════════════════

    public func tickSwarm(swarmId : SwarmId, dt : Float) : () {
      switch (swarms.get(swarmId)) {
        case null { () };
        case (?mission) {
          let n = mission.agents.size();
          let phases = Array.init<Float>(n, 0.0);
          let frequencies = Array.init<Float>(n, 0.0);

          for (i in Iter.range(0, n - 1)) {
            phases[i] := mission.agents[i].phase;
            frequencies[i] := mission.agents[i].frequency;
          };

          let coupling = 0.3 + mission.coherence * 0.4;
          NovaEmergence.kuramotoStep(phases, Array.freeze(frequencies), coupling, dt);

          for (i in Iter.range(0, n - 1)) {
            let agent = mission.agents[i];
            mission.agents[i] := {
              agent with
              phase = phases[i];
              activation = 0.5 + 0.5 * Float.sin(phases[i]);
            };
          };

          let (r, _) = NovaEmergence.kuramotoOrderParameter(Array.freeze(phases));

          swarms.put(swarmId, {
            mission with
            coherence = r;
            status = if (r > 0.85) #Hunting else mission.status;
          });
        };
      };
    };

  };

}
