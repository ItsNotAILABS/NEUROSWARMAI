// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  ALPHA I — CHIMERA ORCHESTRATOR                                                                           ║
// ║  Physical + EM + Orbital Substrate (Drones as Organs)                                                    ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// ALPHA I — CHIMERA: PHYSICAL SWARM ORCHESTRATOR
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// CHIMERA orchestrates physical drone swarms as extensions of the organism's body.
// Each drone is an organ - sensors are eyes, actuators are limbs, communication is nervous system.
//
// FULL ALPHA MODEL INTEGRATION:
// - Kuramoto synchronization for swarm phase-locking
// - ACO stigmergy for path optimization
// - Quorum sensing for collective decisions
// - Signal bus for instant cross-domain communication
// - Field nodes for spatial intelligence distribution
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
import Option "mo:core/Option";

module AlphaChimeraOrchestrator {

  // ═══════════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════

  public let PHI : Float = 1.618033988749895;
  public let PHI_INV : Float = 0.618033988749895;
  public let PI : Float = 3.14159265358979323846;
  public let TWO_PI : Float = 6.28318530717958647692;

  // Field node count (Fibonacci)
  public let FIELD_NODE_COUNT : Nat = 89;  // F11 spatial intelligence nodes
  public let SWARM_AGENT_COUNT : Nat = 144; // F12 physical agents

  // ═══════════════════════════════════════════════════════════════════════════════
  // FIELD NODES — SPATIAL INTELLIGENCE DISTRIBUTION
  // ═══════════════════════════════════════════════════════════════════════════════

  public type FieldNode = {
    nodeId : Nat;
    position : (Float, Float, Float);  // 3D spatial coordinates
    phase : Float;                      // Kuramoto phase
    frequency : Float;                  // Natural frequency
    amplitude : Float;                  // Signal strength
    pheromoneLevel : Float;            // ACO stigmergy
    agentCount : Nat;                  // Agents in this node's region
    isActive : Bool;                   // Node active state
  };

  public type FieldNodeState = {
    var nodes : [FieldNode];
    var globalPhase : Float;           // Mean phase across all nodes
    var globalCoherence : Float;       // R parameter (order)
    var spatialCoverage : Float;       // % of space covered
    var totalPheromone : Float;        // Sum of all pheromones
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SWARM AGENTS — PHYSICAL UNITS
  // ═══════════════════════════════════════════════════════════════════════════════

  public type SwarmAgent = {
    agentId : Nat;
    position : (Float, Float, Float);
    velocity : (Float, Float, Float);
    phase : Float;                     // Kuramoto phase
    assignedNode : Nat;                // Which field node region
    role : AgentRole;
    state : AgentState;
    energy : Float;                    // Battery/fuel level
    sensorData : [Float];             // Multi-modal sensor readings
  };

  public type AgentRole = {
    #Scout;        // Exploration
    #Harvester;    // Resource collection
    #Builder;      // Construction
    #Defender;     // Security
    #Relay;        // Communication
    #Sensor;       // Observation
  };

  public type AgentState = {
    #Idle;
    #Moving;
    #Working;
    #Charging;
    #Emergency;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SIGNAL BUS INTEGRATION
  // ═══════════════════════════════════════════════════════════════════════════════

  public type ChimeraSignal = {
    signalType : ChimeraSignalType;
    value : Float;
    timestamp : Int;
    sourceNode : Nat;
    priority : Nat;
  };

  public type ChimeraSignalType = {
    #SwarmCoherence;       // R parameter from Kuramoto
    #ThreatDetected;       // Security alert
    #ResourceFound;        // Discovery signal
    #PathOptimized;        // ACO result
    #NodeSaturated;        // Too many agents in region
    #EnergyLow;           // Battery alert
    #FormationComplete;    // Task completion
    #CollisionWarning;     // Safety alert
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // CHIMERA STATE
  // ═══════════════════════════════════════════════════════════════════════════════

  public type ChimeraState = {
    var fieldNodes : FieldNodeState;
    var agents : [SwarmAgent];
    var kuramotoCoupling : Float;      // K parameter
    var pheromoneEvaporation : Float;  // ρ parameter
    var signals : [ChimeraSignal];
    var totalBeats : Nat64;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════════

  public func initChimeraState() : ChimeraState {
    let nodes = Array.tabulate<FieldNode>(FIELD_NODE_COUNT, func(i : Nat) : FieldNode {
      // Distribute nodes in golden spiral in 3D space
      let goldenAngle = 2.39996322972865; // radians
      let angle = Float.fromInt(i) * goldenAngle;
      let radius = Float.sqrt(Float.fromInt(i)) * 10.0;

      {
        nodeId = i;
        position = (
          radius * Float.cos(angle),
          radius * Float.sin(angle),
          Float.fromInt(i) * 0.5  // Vertical spacing
        );
        phase = Float.fromInt(i) * TWO_PI / Float.fromInt(FIELD_NODE_COUNT);
        frequency = 1.0 + Float.fromInt(i) * 0.01;
        amplitude = 1.0;
        pheromoneLevel = 0.0;
        agentCount = 0;
        isActive = true;
      }
    });

    let fieldState : FieldNodeState = {
      var nodes = nodes;
      var globalPhase = 0.0;
      var globalCoherence = 0.0;
      var spatialCoverage = 0.0;
      var totalPheromone = 0.0;
    };

    let agents = Array.tabulate<SwarmAgent>(SWARM_AGENT_COUNT, func(i : Nat) : SwarmAgent {
      let nodeIdx = i % FIELD_NODE_COUNT;
      let node = nodes[nodeIdx];

      {
        agentId = i;
        position = node.position;
        velocity = (0.0, 0.0, 0.0);
        phase = Float.fromInt(i) * TWO_PI / Float.fromInt(SWARM_AGENT_COUNT);
        assignedNode = nodeIdx;
        role = #Scout;
        state = #Idle;
        energy = 1.0;
        sensorData = [];
      }
    });

    {
      var fieldNodes = fieldState;
      var agents = agents;
      var kuramotoCoupling = 0.5;
      var pheromoneEvaporation = 0.1;
      var signals = [];
      var totalBeats = 0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // KURAMOTO SYNCHRONIZATION — SWARM PHASE-LOCKING
  // ═══════════════════════════════════════════════════════════════════════════════

  public func updateKuramotoPhases(state : ChimeraState, dt : Float) : () {
    let nodes = state.fieldNodes.nodes;
    let n = nodes.size();

    // Compute order parameter
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

    // Update each node's phase via Kuramoto coupling
    let updatedNodes = Array.map<FieldNode, FieldNode>(nodes, func(node : FieldNode) : FieldNode {
      var sumSinDiff : Float = 0.0;
      for (other in nodes.vals()) {
        sumSinDiff += Float.sin(other.phase - node.phase);
      };

      let couplingTerm = (state.kuramotoCoupling / Float.fromInt(n)) * sumSinDiff;
      let newPhase = node.phase + (node.frequency + couplingTerm) * dt;

      // Wrap to [0, 2π)
      let wrappedPhase = if (newPhase >= TWO_PI) {
        newPhase - TWO_PI
      } else if (newPhase < 0.0) {
        newPhase + TWO_PI
      } else {
        newPhase
      };

      {
        nodeId = node.nodeId;
        position = node.position;
        phase = wrappedPhase;
        frequency = node.frequency;
        amplitude = node.amplitude;
        pheromoneLevel = node.pheromoneLevel;
        agentCount = node.agentCount;
        isActive = node.isActive;
      }
    });

    state.fieldNodes.nodes := updatedNodes;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ACO STIGMERGY — PATH OPTIMIZATION
  // ═══════════════════════════════════════════════════════════════════════════════

  public func updatePheromones(state : ChimeraState) : () {
    var totalPheromone : Float = 0.0;

    let updatedNodes = Array.map<FieldNode, FieldNode>(
      state.fieldNodes.nodes,
      func(node : FieldNode) : FieldNode {
        // Evaporate
        let evaporated = node.pheromoneLevel * (1.0 - state.pheromoneEvaporation);

        // Deposit based on agent activity
        let deposit = Float.fromInt(node.agentCount) * 0.01;

        let newLevel = evaporated + deposit;
        totalPheromone += newLevel;

        {
          nodeId = node.nodeId;
          position = node.position;
          phase = node.phase;
          frequency = node.frequency;
          amplitude = node.amplitude;
          pheromoneLevel = newLevel;
          agentCount = node.agentCount;
          isActive = node.isActive;
        }
      }
    );

    state.fieldNodes.nodes := updatedNodes;
    state.fieldNodes.totalPheromone := totalPheromone;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SIGNAL BUS EMISSION
  // ═══════════════════════════════════════════════════════════════════════════════

  public func emitSignals(state : ChimeraState) : [ChimeraSignal] {
    let signals = Buffer.Buffer<ChimeraSignal>(10);

    // Coherence signal
    signals.add({
      signalType = #SwarmCoherence;
      value = state.fieldNodes.globalCoherence;
      timestamp = Time.now();
      sourceNode = 0;
      priority = if (state.fieldNodes.globalCoherence < PHI_INV) { 2 } else { 0 };
    });

    // Check for saturated nodes
    for (node in state.fieldNodes.nodes.vals()) {
      if (node.agentCount > 5) {
        signals.add({
          signalType = #NodeSaturated;
          value = Float.fromInt(node.agentCount);
          timestamp = Time.now();
          sourceNode = node.nodeId;
          priority = 1;
        });
      };
    };

    // Energy alerts
    var lowEnergyCount : Nat = 0;
    for (agent in state.agents.vals()) {
      if (agent.energy < 0.2) {
        lowEnergyCount += 1;
      };
    };

    if (lowEnergyCount > 0) {
      signals.add({
        signalType = #EnergyLow;
        value = Float.fromInt(lowEnergyCount) / Float.fromInt(state.agents.size());
        timestamp = Time.now();
        sourceNode = 0;
        priority = 2;
      });
    };

    Buffer.toArray(signals)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // HEARTBEAT UPDATE
  // ═══════════════════════════════════════════════════════════════════════════════

  public func tickChimera(state : ChimeraState, dt : Float) : () {
    // Update Kuramoto phases
    updateKuramotoPhases(state, dt);

    // Update pheromones (ACO stigmergy)
    updatePheromones(state);

    // Emit signals
    state.signals := emitSignals(state);

    // Increment beat
    state.totalBeats += 1;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // QUERY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════

  public func getChimeraStatus(state : ChimeraState) : {
    globalCoherence : Float;
    activeAgents : Nat;
    totalPheromone : Float;
    signalCount : Nat;
    beats : Nat64;
  } {
    var activeCount = 0;
    for (agent in state.agents.vals()) {
      if (agent.state != #Idle) {
        activeCount += 1;
      };
    };

    {
      globalCoherence = state.fieldNodes.globalCoherence;
      activeAgents = activeCount;
      totalPheromone = state.fieldNodes.totalPheromone;
      signalCount = state.signals.size();
      beats = state.totalBeats;
    }
  };

};
