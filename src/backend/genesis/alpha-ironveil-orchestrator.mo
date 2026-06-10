// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  ALPHA IV — IRONVEIL ORCHESTRATOR                                                                         ║
// ║  Critical Infrastructure Cascade Mathematics                                                              ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// ALPHA IV — IRONVEIL: INFRASTRUCTURE CASCADE ORCHESTRATOR
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// IRONVEIL orchestrates monitoring and protection of critical infrastructure networks.
// Models cascade failures, predicts systemic risks, coordinates defensive responses.
//
// FULL ALPHA MODEL INTEGRATION:
// - Kuramoto synchronization of infrastructure monitoring
// - ACO stigmergy for cascade path prediction
// - Quorum sensing for threat severity consensus
// - Signal bus for multi-sector alerts
// - Field nodes map to infrastructure sectors (Power, Water, Comm, Transport, Finance)
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Nat64 "mo:core/Nat64";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Text "mo:core/Text";
import Time "mo:core/Time";

module AlphaIronveilOrchestrator {

  // ═══════════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════

  public let PHI : Float = 1.618033988749895;
  public let PHI_INV : Float = 0.618033988749895;
  public let PI : Float = 3.14159265358979323846;
  public let TWO_PI : Float = 6.28318530717958647692;

  // Infrastructure sectors (Fibonacci)
  public let FIELD_NODE_COUNT : Nat = 55;    // F10 infrastructure nodes
  public let SENTINEL_AGENT_COUNT : Nat = 89; // F11 sentinel agents

  // ═══════════════════════════════════════════════════════════════════════════════
  // INFRASTRUCTURE FIELD NODES
  // ═══════════════════════════════════════════════════════════════════════════════

  public type InfrastructureNode = {
    nodeId : Nat;
    sector : InfrastructureSector;
    phase : Float;                    // Kuramoto phase
    frequency : Float;                // Monitoring frequency
    health : Float;                   // Operational status (0-1)
    load : Float;                     // Resource utilization
    cascadeRisk : Float;              // Failure propagation risk
    pheromoneLevel : Float;          // Attention priority
    dependencies : [Nat];             // Connected nodes
  };

  public type InfrastructureSector = {
    #Power;          // Electrical grid
    #Water;          // Water/sanitation
    #Communications; // Internet/telecom
    #Transport;      // Roads/rail/air
    #Financial;      // Banking/markets
    #Healthcare;     // Medical systems
    #Government;     // Gov services
    #Food;           // Supply chain
  };

  public type FieldNodeState = {
    var nodes : [InfrastructureNode];
    var globalPhase : Float;
    var globalCoherence : Float;
    var avgHealth : Float;
    var maxCascadeRisk : Float;
    var criticalNodes : Nat;          // Nodes below health threshold
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SENTINEL AGENTS
  // ═══════════════════════════════════════════════════════════════════════════════

  public type SentinelAgent = {
    agentId : Nat;
    assignedNode : Nat;
    phase : Float;
    role : SentinelRole;
    state : SentinelState;
    cascadePath : [Nat];              // Predicted failure cascade
    interventionReady : Bool;
  };

  public type SentinelRole = {
    #Monitor;          // Health monitoring
    #CascadeAnalyst;   // Failure prediction
    #Defender;         // Active protection
    #Coordinator;      // Multi-sector sync
  };

  public type SentinelState = {
    #Monitoring;
    #AnalyzingCascade;
    #Intervening;
    #Coordinating;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SIGNAL BUS INTEGRATION
  // ═══════════════════════════════════════════════════════════════════════════════

  public type IronveilSignal = {
    signalType : IronveilSignalType;
    value : Float;
    timestamp : Int;
    sourceNode : Nat;
    priority : Nat;
  };

  public type IronveilSignalType = {
    #SwarmCoherence;
    #NodeDegraded;
    #CascadeRiskElevated;
    #CascadeDetected;
    #SectorFailure;
    #InterventionNeeded;
    #DependencyBroken;
    #SystemicRisk;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // IRONVEIL STATE
  // ═══════════════════════════════════════════════════════════════════════════════

  public type IronveilState = {
    var fieldNodes : FieldNodeState;
    var agents : [SentinelAgent];
    var kuramotoCoupling : Float;
    var pheromoneEvaporation : Float;
    var signals : [IronveilSignal];
    var totalBeats : Nat64;
    var healthThreshold : Float;
    var cascadeThreshold : Float;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════════

  public func initIronveilState() : IronveilState {
    let sectors : [InfrastructureSector] = [
      #Power, #Water, #Communications, #Transport,
      #Financial, #Healthcare, #Government, #Food
    ];

    let nodes = Array.tabulate<InfrastructureNode>(FIELD_NODE_COUNT, func(i : Nat) : InfrastructureNode {
      // Create dependency graph (each node depends on 2-3 others)
      let deps = if (i > 2) {
        [i - 1, i - 2]
      } else {
        []
      };

      {
        nodeId = i;
        sector = sectors[i % sectors.size()];
        phase = Float.fromInt(i) * TWO_PI / Float.fromInt(FIELD_NODE_COUNT);
        frequency = 1.0 + Float.fromInt(i) * 0.01;
        health = 1.0;
        load = 0.5;
        cascadeRisk = 0.0;
        pheromoneLevel = 0.1;
        dependencies = deps;
      }
    });

    let fieldState : FieldNodeState = {
      var nodes = nodes;
      var globalPhase = 0.0;
      var globalCoherence = 0.0;
      var avgHealth = 1.0;
      var maxCascadeRisk = 0.0;
      var criticalNodes = 0;
    };

    let agents = Array.tabulate<SentinelAgent>(SENTINEL_AGENT_COUNT, func(i : Nat) : SentinelAgent {
      {
        agentId = i;
        assignedNode = i % FIELD_NODE_COUNT;
        phase = Float.fromInt(i) * TWO_PI / Float.fromInt(SENTINEL_AGENT_COUNT);
        role = #Monitor;
        state = #Monitoring;
        cascadePath = [];
        interventionReady = false;
      }
    });

    {
      var fieldNodes = fieldState;
      var agents = agents;
      var kuramotoCoupling = 0.5;
      var pheromoneEvaporation = 0.1;
      var signals = [];
      var totalBeats = 0;
      var healthThreshold = 0.7;
      var cascadeThreshold = 0.5;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // CASCADE RISK CALCULATION
  // ═══════════════════════════════════════════════════════════════════════════════

  public func computeCascadeRisk(node : InfrastructureNode, allNodes : [InfrastructureNode]) : Float {
    // Risk = (1 - health) × load × dependency_factor
    var depHealthSum : Float = 0.0;
    var depCount = 0;

    for (depId in node.dependencies.vals()) {
      if (depId < allNodes.size()) {
        depHealthSum += allNodes[depId].health;
        depCount += 1;
      };
    };

    let depFactor = if (depCount > 0) {
      1.0 - (depHealthSum / Float.fromInt(depCount))
    } else {
      0.0
    };

    (1.0 - node.health) * node.load * (1.0 + depFactor)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // KURAMOTO SYNCHRONIZATION
  // ═══════════════════════════════════════════════════════════════════════════════

  public func updateKuramotoPhases(state : IronveilState, dt : Float) : () {
    let nodes = state.fieldNodes.nodes;
    let n = nodes.size();

    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    for (node in nodes.vals()) {
      sumCos += Float.cos(node.phase);
      sumSin += Float.sin(node.phase);
    };

    let r = Float.sqrt(sumCos * sumCos + sumSin * sumSin) / Float.fromInt(n);
    let psi = Float.arctan2(sumSin, sumCos);

    state.fieldNodes.globalCoherence := r;
    state.fieldNodes.globalPhase := psi;

    var totalHealth : Float = 0.0;
    var maxRisk : Float = 0.0;
    var criticalCount = 0;

    let updatedNodes = Array.map<InfrastructureNode, InfrastructureNode>(
      nodes,
      func(node : InfrastructureNode) : InfrastructureNode {
        var sumSinDiff : Float = 0.0;
        for (other in nodes.vals()) {
          sumSinDiff += Float.sin(other.phase - node.phase);
        };

        let couplingTerm = (state.kuramotoCoupling / Float.fromInt(n)) * sumSinDiff;
        var newPhase = node.phase + (node.frequency + couplingTerm) * dt;

        while (newPhase >= TWO_PI) { newPhase -= TWO_PI };
        while (newPhase < 0.0) { newPhase += TWO_PI };

        // Compute cascade risk
        let risk = computeCascadeRisk(node, nodes);
        if (risk > maxRisk) { maxRisk := risk };

        totalHealth += node.health;
        if (node.health < state.healthThreshold) {
          criticalCount += 1;
        };

        {
          nodeId = node.nodeId;
          sector = node.sector;
          phase = newPhase;
          frequency = node.frequency;
          health = node.health;
          load = node.load;
          cascadeRisk = risk;
          pheromoneLevel = node.pheromoneLevel;
          dependencies = node.dependencies;
        }
      }
    );

    state.fieldNodes.nodes := updatedNodes;
    state.fieldNodes.avgHealth := totalHealth / Float.fromInt(n);
    state.fieldNodes.maxCascadeRisk := maxRisk;
    state.fieldNodes.criticalNodes := criticalCount;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SIGNAL BUS EMISSION
  // ═══════════════════════════════════════════════════════════════════════════════

  public func emitSignals(state : IronveilState) : [IronveilSignal] {
    let signals = Buffer.Buffer<IronveilSignal>(10);

    signals.add({
      signalType = #SwarmCoherence;
      value = state.fieldNodes.globalCoherence;
      timestamp = Time.now();
      sourceNode = 0;
      priority = 0;
    });

    // Systemic risk alert
    if (state.fieldNodes.maxCascadeRisk > state.cascadeThreshold) {
      signals.add({
        signalType = #SystemicRisk;
        value = state.fieldNodes.maxCascadeRisk;
        timestamp = Time.now();
        sourceNode = 0;
        priority = 3;
      });
    };

    // Per-node alerts
    for (node in state.fieldNodes.nodes.vals()) {
      if (node.health < state.healthThreshold) {
        signals.add({
          signalType = #NodeDegraded;
          value = node.health;
          timestamp = Time.now();
          sourceNode = node.nodeId;
          priority = 2;
        });
      };

      if (node.cascadeRisk > state.cascadeThreshold) {
        signals.add({
          signalType = #CascadeRiskElevated;
          value = node.cascadeRisk;
          timestamp = Time.now();
          sourceNode = node.nodeId;
          priority = 2;
        });
      };
    };

    Buffer.toArray(signals)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // HEARTBEAT UPDATE
  // ═══════════════════════════════════════════════════════════════════════════════

  public func tickIronveil(state : IronveilState, dt : Float) : () {
    updateKuramotoPhases(state, dt);
    state.signals := emitSignals(state);
    state.totalBeats += 1;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // QUERY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════

  public func getIronveilStatus(state : IronveilState) : {
    globalCoherence : Float;
    avgHealth : Float;
    maxCascadeRisk : Float;
    criticalNodes : Nat;
    signalCount : Nat;
    beats : Nat64;
  } {
    {
      globalCoherence = state.fieldNodes.globalCoherence;
      avgHealth = state.fieldNodes.avgHealth;
      maxCascadeRisk = state.fieldNodes.maxCascadeRisk;
      criticalNodes = state.fieldNodes.criticalNodes;
      signalCount = state.signals.size();
      beats = state.totalBeats;
    }
  };

};
