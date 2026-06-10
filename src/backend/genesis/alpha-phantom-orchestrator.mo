// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  ALPHA II — PHANTOM ORCHESTRATOR                                                                          ║
// ║  Virtual Swarm in ICP Canister Space (Sub-Canister Agents)                                               ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// ALPHA II — PHANTOM: VIRTUAL SWARM ORCHESTRATOR
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// PHANTOM orchestrates virtual agent swarms within ICP canister computational space.
// Each agent is a lightweight computation unit that roams the substrate performing tasks.
//
// FULL ALPHA MODEL INTEGRATION:
// - Kuramoto synchronization across computational tasks
// - ACO stigmergy for workload distribution
// - Quorum sensing for consensus on resource allocation
// - Signal bus for cross-substrate communication
// - Field nodes map to computational regions (not spatial)
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

module AlphaPhantomOrchestrator {

  // ═══════════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════

  public let PHI : Float = 1.618033988749895;
  public let PHI_INV : Float = 0.618033988749895;
  public let PI : Float = 3.14159265358979323846;
  public let TWO_PI : Float = 6.28318530717958647692;

  // Computational field nodes (Fibonacci)
  public let FIELD_NODE_COUNT : Nat = 89;   // F11 computational regions
  public let VIRTUAL_AGENT_COUNT : Nat = 233; // F13 virtual agents

  // ═══════════════════════════════════════════════════════════════════════════════
  // COMPUTATIONAL FIELD NODES
  // ═══════════════════════════════════════════════════════════════════════════════

  public type ComputationalNode = {
    nodeId : Nat;
    domain : ComputationalDomain;
    phase : Float;                    // Kuramoto phase
    frequency : Float;                // Processing rate
    load : Float;                     // CPU utilization
    pheromoneLevel : Float;          // Task attractiveness
    agentCount : Nat;                // Agents working here
    taskQueue : Nat;                 // Pending tasks
  };

  public type ComputationalDomain = {
    #Memory;         // Memory operations
    #Compute;        // CPU-intensive
    #Network;        // I/O operations
    #Storage;        // Data persistence
    #Coordination;   // Inter-agent messaging
    #Analysis;       // Pattern recognition
    #Synthesis;      // Result aggregation
  };

  public type FieldNodeState = {
    var nodes : [ComputationalNode];
    var globalPhase : Float;
    var globalCoherence : Float;
    var totalLoad : Float;
    var totalPheromone : Float;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // VIRTUAL AGENTS
  // ═══════════════════════════════════════════════════════════════════════════════

  public type VirtualAgent = {
    agentId : Nat;
    assignedNode : Nat;
    phase : Float;                    // Kuramoto phase
    role : VirtualRole;
    state : VirtualState;
    workload : Float;                 // Current task complexity
    efficiency : Float;               // Performance metric
    specialization : [ComputationalDomain];
  };

  public type VirtualRole = {
    #Patrol;         // Anomaly detection
    #Worker;         // Task execution
    #Optimizer;      // Resource allocation
    #Monitor;        // System observation
    #Coordinator;    // Multi-agent sync
    #Learner;        // Pattern extraction
  };

  public type VirtualState = {
    #Idle;
    #Processing;
    #Coordinating;
    #Migrating;      // Moving to different node
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SIGNAL BUS INTEGRATION
  // ═══════════════════════════════════════════════════════════════════════════════

  public type PhantomSignal = {
    signalType : PhantomSignalType;
    value : Float;
    timestamp : Int;
    sourceNode : Nat;
    priority : Nat;
  };

  public type PhantomSignalType = {
    #SwarmCoherence;
    #AnomalyDetected;      // KL divergence alert
    #LoadImbalance;        // Resource distribution issue
    #TaskComplete;
    #ConsensusReached;
    #MigrationNeeded;      // Agents should relocate
    #PatternDiscovered;
    #EfficiencyDrop;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // PHANTOM STATE
  // ═══════════════════════════════════════════════════════════════════════════════

  public type PhantomState = {
    var fieldNodes : FieldNodeState;
    var agents : [VirtualAgent];
    var kuramotoCoupling : Float;
    var pheromoneEvaporation : Float;
    var signals : [PhantomSignal];
    var totalBeats : Nat64;
    var klDivergenceThreshold : Float;  // Anomaly detection threshold
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════════

  public func initPhantomState() : PhantomState {
    let domains : [ComputationalDomain] = [
      #Memory, #Compute, #Network, #Storage,
      #Coordination, #Analysis, #Synthesis
    ];

    let nodes = Array.tabulate<ComputationalNode>(FIELD_NODE_COUNT, func(i : Nat) : ComputationalNode {
      {
        nodeId = i;
        domain = domains[i % domains.size()];
        phase = Float.fromInt(i) * TWO_PI / Float.fromInt(FIELD_NODE_COUNT);
        frequency = 1.0 + Float.fromInt(i) * 0.01;
        load = 0.0;
        pheromoneLevel = 0.1;
        agentCount = 0;
        taskQueue = 0;
      }
    });

    let fieldState : FieldNodeState = {
      var nodes = nodes;
      var globalPhase = 0.0;
      var globalCoherence = 0.0;
      var totalLoad = 0.0;
      var totalPheromone = 0.0;
    };

    let agents = Array.tabulate<VirtualAgent>(VIRTUAL_AGENT_COUNT, func(i : Nat) : VirtualAgent {
      {
        agentId = i;
        assignedNode = i % FIELD_NODE_COUNT;
        phase = Float.fromInt(i) * TWO_PI / Float.fromInt(VIRTUAL_AGENT_COUNT);
        role = #Worker;
        state = #Idle;
        workload = 0.0;
        efficiency = 1.0;
        specialization = [];
      }
    });

    {
      var fieldNodes = fieldState;
      var agents = agents;
      var kuramotoCoupling = 0.5;
      var pheromoneEvaporation = 0.1;
      var signals = [];
      var totalBeats = 0;
      var klDivergenceThreshold = 0.5;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // KURAMOTO SYNCHRONIZATION
  // ═══════════════════════════════════════════════════════════════════════════════

  public func updateKuramotoPhases(state : PhantomState, dt : Float) : () {
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

    let updatedNodes = Array.map<ComputationalNode, ComputationalNode>(
      nodes,
      func(node : ComputationalNode) : ComputationalNode {
        var sumSinDiff : Float = 0.0;
        for (other in nodes.vals()) {
          sumSinDiff += Float.sin(other.phase - node.phase);
        };

        let couplingTerm = (state.kuramotoCoupling / Float.fromInt(n)) * sumSinDiff;
        var newPhase = node.phase + (node.frequency + couplingTerm) * dt;

        // Wrap phase
        while (newPhase >= TWO_PI) { newPhase -= TWO_PI };
        while (newPhase < 0.0) { newPhase += TWO_PI };

        {
          nodeId = node.nodeId;
          domain = node.domain;
          phase = newPhase;
          frequency = node.frequency;
          load = node.load;
          pheromoneLevel = node.pheromoneLevel;
          agentCount = node.agentCount;
          taskQueue = node.taskQueue;
        }
      }
    );

    state.fieldNodes.nodes := updatedNodes;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ACO STIGMERGY — WORKLOAD DISTRIBUTION
  // ═══════════════════════════════════════════════════════════════════════════════

  public func updatePheromones(state : PhantomState) : () {
    var totalPheromone : Float = 0.0;
    var totalLoad : Float = 0.0;

    let updatedNodes = Array.map<ComputationalNode, ComputationalNode>(
      state.fieldNodes.nodes,
      func(node : ComputationalNode) : ComputationalNode {
        // Evaporate
        let evaporated = node.pheromoneLevel * (1.0 - state.pheromoneEvaporation);

        // Deposit based on successful completions (inverse of load)
        let successRate = if (node.load < 0.8) { 0.1 } else { 0.01 };
        let deposit = Float.fromInt(node.agentCount) * successRate;

        let newLevel = Float.max(0.01, evaporated + deposit);
        totalPheromone += newLevel;
        totalLoad += node.load;

        {
          nodeId = node.nodeId;
          domain = node.domain;
          phase = node.phase;
          frequency = node.frequency;
          load = node.load;
          pheromoneLevel = newLevel;
          agentCount = node.agentCount;
          taskQueue = node.taskQueue;
        }
      }
    );

    state.fieldNodes.nodes := updatedNodes;
    state.fieldNodes.totalPheromone := totalPheromone;
    state.fieldNodes.totalLoad := totalLoad;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SIGNAL BUS EMISSION
  // ═══════════════════════════════════════════════════════════════════════════════

  public func emitSignals(state : PhantomState) : [PhantomSignal] {
    let signals = Buffer.Buffer<PhantomSignal>(10);

    // Coherence signal
    signals.add({
      signalType = #SwarmCoherence;
      value = state.fieldNodes.globalCoherence;
      timestamp = Time.now();
      sourceNode = 0;
      priority = if (state.fieldNodes.globalCoherence < PHI_INV) { 2 } else { 0 };
    });

    // Load imbalance detection
    let avgLoad = state.fieldNodes.totalLoad / Float.fromInt(state.fieldNodes.nodes.size());
    for (node in state.fieldNodes.nodes.vals()) {
      if (node.load > avgLoad * 1.5) {
        signals.add({
          signalType = #LoadImbalance;
          value = node.load - avgLoad;
          timestamp = Time.now();
          sourceNode = node.nodeId;
          priority = 1;
        });
      };
    };

    Buffer.toArray(signals)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // HEARTBEAT UPDATE
  // ═══════════════════════════════════════════════════════════════════════════════

  public func tickPhantom(state : PhantomState, dt : Float) : () {
    updateKuramotoPhases(state, dt);
    updatePheromones(state);
    state.signals := emitSignals(state);
    state.totalBeats += 1;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // QUERY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════

  public func getPhantomStatus(state : PhantomState) : {
    globalCoherence : Float;
    totalLoad : Float;
    activeAgents : Nat;
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
      totalLoad = state.fieldNodes.totalLoad;
      activeAgents = activeCount;
      signalCount = state.signals.size();
      beats = state.totalBeats;
    }
  };

};
