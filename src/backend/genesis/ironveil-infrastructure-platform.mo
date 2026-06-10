// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  IRONVEIL INFRASTRUCTURE INTELLIGENCE PLATFORM — PRODUCTION GRADE                                         ║
// ║  Alpha Framework №5: Critical Infrastructure + Cascade Detection + Grid Resilience                       ║
// ║  Commercial Deployment System for Infrastructure Intelligence                                             ║
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

module IronveilInfrastructurePlatform {

  // ═══════════════════════════════════════════════════════════════════════════════
  // TYPES — COMMERCIAL PRODUCTION SYSTEM
  // ═══════════════════════════════════════════════════════════════════════════════

  public type SwarmId = Text;
  public type AgentId = Nat;
  public type NodeId = Nat;
  public type Timestamp = Nat64;

  public type InfrastructureType = {
    #PowerGrid;
    #WaterSupply;
    #Transportation;
    #Telecommunications;
    #FinancialSystems;
    #EmergencyServices;
    #DataCenters;
    #IndustrialControl;
  };

  public type MonitoringMode = {
    #RealTimeMonitoring;          // Live infrastructure health tracking
    #CascadeDetection;            // Identify potential cascade failures
    #LoadBalancing;               // Optimize resource distribution
    #ResilienceAnalysis;          // Assess system robustness
    #ThreatAssessment;            // Security & physical threat analysis
  };

  public type InfrastructureAgent = {
    id : AgentId;
    monitoredInfra : InfrastructureType;
    phase : Float;                    // Kuramoto phase [0, 2π)
    frequency : Float;                // Natural frequency
    activation : Float;               // [0, 1] operational status
    nodesMonitored : [NodeId];
    anomaliesDetected : Nat;
    cascadesIdentified : Nat;
    lastUpdate : Timestamp;
  };

  public type InfrastructureNode = {
    id : NodeId;
    nodeType : InfrastructureType;
    load : Float;                     // Current load [0, 1]
    capacity : Float;                 // Maximum capacity [0, 1]
    health : Float;                   // Operational health [0, 1]
    connections : [NodeId];           // Connected nodes
    cascadeRisk : Float;              // Risk of cascade failure [0, 1]
  };

  public type CascadeAlert = {
    id : Text;
    originNode : NodeId;
    affectedNodes : [NodeId];
    severity : Text;                  // "critical" | "high" | "medium" | "low"
    estimatedImpact : Float;          // [0, 1]
    mitigation : Text;                // Recommended actions
    timestamp : Timestamp;
  };

  public type LoadOptimization = {
    nodeId : NodeId;
    currentLoad : Float;
    optimalLoad : Float;
    adjustment : Float;               // Delta to achieve optimal
    priority : Nat;                   // 1-10
  };

  public type ResilienceMetrics = {
    infrastructureType : InfrastructureType;
    redundancy : Float;               // [0, 1] system redundancy
    robustness : Float;               // [0, 1] resistance to failure
    recovery : Float;                 // [0, 1] recovery speed
    overallScore : Float;             // [0, 1] composite resilience
  };

  public type InfrastructureMission = {
    id : SwarmId;
    monitoringMode : MonitoringMode;
    infrastructures : [InfrastructureType];
    agentCount : Nat;
    startTime : Timestamp;
    duration : Nat64;
    status : SwarmStatus;
    agents : [var InfrastructureAgent];
    nodes : [var InfrastructureNode];
    coherence : Float;                // Kuramoto R [0, 1]
    cascadeAlerts : Buffer.Buffer<CascadeAlert>;
    optimizations : Buffer.Buffer<LoadOptimization>;
    resilienceMetrics : Buffer.Buffer<ResilienceMetrics>;
    client : Principal;
  };

  public type SwarmStatus = {
    #Deploying;
    #Monitoring;
    #Analyzing;
    #Optimizing;
    #Completed;
    #Aborted;
  };

  public type DeployRequest = {
    monitoringMode : MonitoringMode;
    infrastructures : [InfrastructureType];
    agentCount : Nat;
    nodeCount : Nat;                  // Number of infrastructure nodes to monitor
    duration : Nat64;
  };

  public type DeployResponse = {
    swarmId : SwarmId;
    status : Text;
    infrastructuresActive : Nat;
    nodesMonitored : Nat;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // STATE MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════════

  public class IronveilSystem() {
    let swarms = HashMap.HashMap<SwarmId, InfrastructureMission>(10, Text.equal, Text.hash);
    var nextSwarmId : Nat = 1;
    var nextAlertId : Nat = 1;

    // ═══════════════════════════════════════════════════════════════════════════
    // COMMERCIAL API — DEPLOY INFRASTRUCTURE SWARM
    // ═══════════════════════════════════════════════════════════════════════════

    public func deploySwarm(request : DeployRequest, client : Principal) : DeployResponse {
      let swarmId = "IRONVEIL-" # Nat.toText(nextSwarmId);
      nextSwarmId += 1;

      // Initialize agents
      let agents = Array.init<InfrastructureAgent>(request.agentCount, {
        id = 0;
        monitoredInfra = #PowerGrid;
        phase = 0.0;
        frequency = 1.0;
        activation = 1.0;
        nodesMonitored = [];
        anomaliesDetected = 0;
        cascadesIdentified = 0;
        lastUpdate = Nat64.fromNat(Int.abs(Time.now()));
      });

      for (i in Iter.range(0, request.agentCount - 1)) {
        let infraIndex = i % request.infrastructures.size();
        let infra = request.infrastructures[infraIndex];
        let phase = Float.fromInt(i) * NovaComputing.GOLDEN_ANGLE_RAD;
        let freq = 1.0 + 0.1 * Float.sin(phase);

        agents[i] := {
          id = i;
          monitoredInfra = infra;
          phase = phase;
          frequency = freq;
          activation = 1.0;
          nodesMonitored = [];
          anomaliesDetected = 0;
          cascadesIdentified = 0;
          lastUpdate = Nat64.fromNat(Int.abs(Time.now()));
        };
      };

      // Initialize infrastructure nodes with random load/capacity
      let nodes = Array.init<InfrastructureNode>(request.nodeCount, {
        id = 0;
        nodeType = #PowerGrid;
        load = 0.5;
        capacity = 1.0;
        health = 1.0;
        connections = [];
        cascadeRisk = 0.0;
      });

      for (i in Iter.range(0, request.nodeCount - 1)) {
        let infraIndex = i % request.infrastructures.size();
        let infra = request.infrastructures[infraIndex];

        // Create connections (each node connects to 3-5 neighbors)
        let connectionCount = 3 + (i % 3);
        let connections = Array.tabulate<NodeId>(connectionCount, func(j) {
          (i + j + 1) % request.nodeCount
        });

        nodes[i] := {
          id = i;
          nodeType = infra;
          load = 0.4 + 0.3 * Float.sin(Float.fromInt(i));
          capacity = 1.0;
          health = 0.9 + 0.1 * Float.cos(Float.fromInt(i));
          connections = connections;
          cascadeRisk = 0.0;
        };
      };

      let mission : InfrastructureMission = {
        id = swarmId;
        monitoringMode = request.monitoringMode;
        infrastructures = request.infrastructures;
        agentCount = request.agentCount;
        startTime = Nat64.fromNat(Int.abs(Time.now()));
        duration = request.duration;
        status = #Deploying;
        agents = agents;
        nodes = nodes;
        coherence = 0.0;
        cascadeAlerts = Buffer.Buffer<CascadeAlert>(50);
        optimizations = Buffer.Buffer<LoadOptimization>(100);
        resilienceMetrics = Buffer.Buffer<ResilienceMetrics>(10);
        client = client;
      };

      swarms.put(swarmId, mission);

      {
        swarmId = swarmId;
        status = "Deploying";
        infrastructuresActive = request.infrastructures.size();
        nodesMonitored = request.nodeCount;
      }
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // COMMERCIAL API — GET INFRASTRUCTURE INSIGHTS
    // ═══════════════════════════════════════════════════════════════════════════

    public func getInfrastructureInsights(swarmId : SwarmId) : ?{
      cascadeAlerts : [CascadeAlert];
      optimizations : [LoadOptimization];
      resilienceMetrics : [ResilienceMetrics];
      coherence : Float;
      nodesAtRisk : Nat;
    } {
      switch (swarms.get(swarmId)) {
        case null { null };
        case (?mission) {
          var atRisk : Nat = 0;
          for (node in Array.freeze(mission.nodes).vals()) {
            if (node.cascadeRisk > 0.6) {
              atRisk += 1;
            };
          };

          ?{
            cascadeAlerts = Buffer.toArray(mission.cascadeAlerts);
            optimizations = Buffer.toArray(mission.optimizations);
            resilienceMetrics = Buffer.toArray(mission.resilienceMetrics);
            coherence = mission.coherence;
            nodesAtRisk = atRisk;
          }
        };
      };
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // CASCADE RISK COMPUTATION
    // ═══════════════════════════════════════════════════════════════════════════

    public func computeCascadeRisk(swarmId : SwarmId) : () {
      switch (swarms.get(swarmId)) {
        case null { () };
        case (?mission) {
          // Compute cascade risk for each node using recursive formula
          let n = mission.nodes.size();
          let loads = Array.tabulate<Float>(n, func(i) { mission.nodes[i].load });
          let capacities = Array.tabulate<Float>(n, func(i) { mission.nodes[i].capacity });

          // Build coupling matrix
          let couplingMatrix = Array.tabulate<[Float]>(n, func(i) {
            let node = mission.nodes[i];
            Array.tabulate<Float>(n, func(j) {
              // Check if j is in node's connections
              let isConnected = Array.foldLeft<NodeId, Bool>(
                node.connections,
                false,
                func(acc, connId) { acc or (connId == j) }
              );
              if (isConnected) { 0.3 } else { 0.0 }
            })
          });

          let risks = Array.init<Float>(n, 0.0);

          // Compute cascade risk for each node
          for (i in Iter.range(0, n - 1)) {
            let risk = FiveAlphas.cascadeRisk(i, loads, capacities, couplingMatrix, risks, 0);
            mission.nodes[i] := {
              mission.nodes[i] with cascadeRisk = risk;
            };
          };
        };
      };
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
            status = if (r > 0.85) #Monitoring else mission.status;
          });

          // Compute cascade risk if monitoring
          if (r > 0.85) {
            computeCascadeRisk(swarmId);
          };
        };
      };
    };

  };

}
