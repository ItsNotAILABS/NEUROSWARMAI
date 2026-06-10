// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  PHANTOM VIRTUAL INTELLIGENCE PLATFORM — PRODUCTION GRADE                                                 ║
// ║  Alpha Framework №2: Virtual Swarm + ACO Optimization + Pattern Mining                                   ║
// ║  Commercial Deployment System for Computational Intelligence                                              ║
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
import Hash "mo:core/Hash";

import NovaIntelligence "nova-intelligence-engine";
import NovaComputing "../../intelligence_core/computing/core";
import NovaEmergence "../../intelligence_core/emergence/kuramoto";
import FiveAlphas "five-alphas-unified-substrate";

module PhantomVirtualPlatform {

  // ═══════════════════════════════════════════════════════════════════════════════
  // TYPES — COMMERCIAL PRODUCTION SYSTEM
  // ═══════════════════════════════════════════════════════════════════════════════

  public type SwarmId = Text;
  public type AgentId = Nat;
  public type Timestamp = Nat64;

  public type TaskType = {
    #FinancialAnalytics;
    #SupplyChainOptimization;
    #Cybersecurity;
    #ResearchAndDevelopment;
    #CustomerIntelligence;
  };

  public type VirtualAgent = {
    id : AgentId;
    position : (Float, Float);    // 2D virtual space coordinates
    phase : Float;                // Kuramoto phase [0, 2π)
    frequency : Float;            // Natural frequency
    activation : Float;           // [0, 1] operational status
    pheromoneLevel : Float;       // Stigmergic trail strength
    pathQuality : Float;          // Current path evaluation
    discoveries : Buffer.Buffer<Discovery>;
    lastUpdate : Timestamp;
  };

  public type Discovery = {
    id : Nat;
    timestamp : Timestamp;
    discoveryType : Text;         // "pattern" | "anomaly" | "prediction" | "insight"
    confidence : Float;           // [0, 1]
    data : Text;                  // JSON-encoded discovery data
    agentId : AgentId;
  };

  public type Pattern = {
    id : Text;
    signal : [Float];
    repeatCount : Nat;
    coherence : Float;
    graduated : Bool;             // Has it graduated to schema?
  };

  public type Anomaly = {
    id : Text;
    location : (Float, Float);
    severity : Float;             // [0, 1]
    klDivergence : Float;         // KL divergence score
    description : Text;
  };

  public type Prediction = {
    id : Text;
    target : Text;
    value : Float;
    confidence : Float;           // [0, 1]
    horizon : Nat64;              // milliseconds into future
  };

  public type VirtualMission = {
    id : SwarmId;
    task : TaskType;
    dataSource : Text;
    agentCount : Nat;
    startTime : Timestamp;
    duration : Nat64;
    status : SwarmStatus;
    agents : [var VirtualAgent];
    coherence : Float;            // Kuramoto R [0, 1]
    pheromoneMap : [[var Float]]; // 2D grid of pheromone trails
    patterns : Buffer.Buffer<Pattern>;
    anomalies : Buffer.Buffer<Anomaly>;
    predictions : Buffer.Buffer<Prediction>;
    client : Principal;
  };

  public type SwarmStatus = {
    #Spawning;
    #Active;
    #Paused;
    #Completed;
    #Aborted;
  };

  public type SpawnRequest = {
    task : TaskType;
    dataSource : Text;
    agentCount : Nat;
    duration : Nat64;
  };

  public type SpawnResponse = {
    swarmId : SwarmId;
    status : Text;
    agentsActive : Nat;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // STATE MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════════

  public class PhantomSystem() {
    let swarms = HashMap.HashMap<SwarmId, VirtualMission>(10, Text.equal, Text.hash);
    var nextSwarmId : Nat = 1;
    var nextDiscoveryId : Nat = 1;

    // ═══════════════════════════════════════════════════════════════════════════
    // COMMERCIAL API — SPAWN VIRTUAL SWARM
    // ═══════════════════════════════════════════════════════════════════════════

    public func spawnSwarm(request : SpawnRequest, client : Principal) : SpawnResponse {
      let swarmId = "PHANTOM-" # Nat.toText(nextSwarmId);
      nextSwarmId += 1;

      // Initialize virtual agents with random positions
      let agents = Array.init<VirtualAgent>(request.agentCount, {
        id = 0;
        position = (0.0, 0.0);
        phase = 0.0;
        frequency = 1.0;
        activation = 1.0;
        pheromoneLevel = 0.5;
        pathQuality = 0.5;
        discoveries = Buffer.Buffer<Discovery>(10);
        lastUpdate = Nat64.fromNat(Int.abs(Time.now()));
      });

      // Fibonacci lattice placement in virtual space
      for (i in Iter.range(0, request.agentCount - 1)) {
        let (x, y) = NovaComputing.fibonacciLatticePoint(i, request.agentCount);
        let phase = Float.fromInt(i) * NovaComputing.GOLDEN_ANGLE_RAD;
        let freq = 1.0 + 0.1 * Float.sin(phase);

        agents[i] := {
          id = i;
          position = (x, y);
          phase = phase;
          frequency = freq;
          activation = 1.0;
          pheromoneLevel = 0.5;
          pathQuality = 0.5;
          discoveries = Buffer.Buffer<Discovery>(10);
          lastUpdate = Nat64.fromNat(Int.abs(Time.now()));
        };
      };

      // Initialize pheromone map (100x100 grid)
      let pheromoneMap = Array.init<[var Float]>(100, Array.init<Float>(100, 0.0));
      for (i in Iter.range(0, 99)) {
        pheromoneMap[i] := Array.init<Float>(100, 0.1); // Base level
      };

      let mission : VirtualMission = {
        id = swarmId;
        task = request.task;
        dataSource = request.dataSource;
        agentCount = request.agentCount;
        startTime = Nat64.fromNat(Int.abs(Time.now()));
        duration = request.duration;
        status = #Spawning;
        agents = agents;
        coherence = 0.0;
        pheromoneMap = pheromoneMap;
        patterns = Buffer.Buffer<Pattern>(50);
        anomalies = Buffer.Buffer<Anomaly>(50);
        predictions = Buffer.Buffer<Prediction>(50);
        client = client;
      };

      swarms.put(swarmId, mission);

      {
        swarmId = swarmId;
        status = "Spawning";
        agentsActive = request.agentCount;
      }
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // COMMERCIAL API — GET SWARM INSIGHTS
    // ═══════════════════════════════════════════════════════════════════════════

    public func getSwarmInsights(swarmId : SwarmId) : ?{
      patterns : [Pattern];
      anomalies : [Anomaly];
      predictions : [Prediction];
      coherence : Float;
    } {
      switch (swarms.get(swarmId)) {
        case null { null };
        case (?mission) {
          ?{
            patterns = Buffer.toArray(mission.patterns);
            anomalies = Buffer.toArray(mission.anomalies);
            predictions = Buffer.toArray(mission.predictions);
            coherence = mission.coherence;
          }
        };
      };
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // COMMERCIAL API — ACO PATH OPTIMIZATION
    // ═══════════════════════════════════════════════════════════════════════════

    public type Node = {
      id : Nat;
      x : Float;
      y : Float;
    };

    public type OptimizationResult = {
      optimalPath : [Nat];
      cost : Float;
      confidence : Float;
    };

    public func optimizePath(nodes : [Node], alpha : Float, beta : Float) : OptimizationResult {
      if (nodes.size() < 2) {
        return {
          optimalPath = [];
          cost = 0.0;
          confidence = 0.0;
        };
      };

      // Simple greedy ACO approximation for demonstration
      let n = nodes.size();
      let visited = Array.init<Bool>(n, false);
      let path = Buffer.Buffer<Nat>(n);

      // Start at node 0
      var current = 0;
      visited[current] := true;
      path.add(current);

      var totalCost : Float = 0.0;

      // Greedy nearest-neighbor with pheromone bias
      while (path.size() < n) {
        var bestNext : ?Nat = null;
        var bestProb : Float = 0.0;

        for (next in Iter.range(0, n - 1)) {
          if (not visited[next]) {
            let dx = nodes[next].x - nodes[current].x;
            let dy = nodes[next].y - nodes[current].y;
            let dist = Float.sqrt(dx * dx + dy * dy);

            // ACO probability: τ^α × η^β
            let pheromone = 1.0; // Assume uniform pheromone for now
            let heuristic = 1.0 / Float.max(NovaComputing.EPSILON, dist);
            let prob = FiveAlphas.acoPathProbability(pheromone, heuristic, alpha, beta);

            if (prob > bestProb) {
              bestProb := prob;
              bestNext := ?next;
            };
          };
        };

        switch (bestNext) {
          case null { /* No more nodes */ };
          case (?next) {
            visited[next] := true;
            path.add(next);

            let dx = nodes[next].x - nodes[current].x;
            let dy = nodes[next].y - nodes[current].y;
            totalCost += Float.sqrt(dx * dx + dy * dy);

            current := next;
          };
        };
      };

      {
        optimalPath = Buffer.toArray(path);
        cost = totalCost;
        confidence = 0.85; // Fixed confidence for demo
      }
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // HEARTBEAT TICK — STIGMERGY UPDATE
    // ═══════════════════════════════════════════════════════════════════════════

    public func tickSwarm(swarmId : SwarmId, dt : Float) : () {
      switch (swarms.get(swarmId)) {
        case null { () };
        case (?mission) {
          // Kuramoto synchronization
          let n = mission.agents.size();
          let phases = Array.init<Float>(n, 0.0);
          let frequencies = Array.init<Float>(n, 0.0);

          for (i in Iter.range(0, n - 1)) {
            phases[i] := mission.agents[i].phase;
            frequencies[i] := mission.agents[i].frequency;
          };

          let coupling = 0.3 + mission.coherence * 0.4;
          NovaEmergence.kuramotoStep(phases, Array.freeze(frequencies), coupling, dt);

          // Update agents
          for (i in Iter.range(0, n - 1)) {
            let agent = mission.agents[i];
            mission.agents[i] := {
              agent with
              phase = phases[i];
              activation = 0.5 + 0.5 * Float.sin(phases[i]);
            };
          };

          // Pheromone evaporation (ρ = 0.1)
          for (i in Iter.range(0, 99)) {
            for (j in Iter.range(0, 99)) {
              mission.pheromoneMap[i][j] := mission.pheromoneMap[i][j] * 0.9;
            };
          };

          // Compute coherence
          let (r, _) = NovaEmergence.kuramotoOrderParameter(Array.freeze(phases));

          // Update mission
          let updatedMission = {
            mission with
            coherence = r;
            status = if (r > 0.85) #Active else mission.status;
          };

          swarms.put(swarmId, updatedMission);
        };
      };
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // UTILITIES
    // ═══════════════════════════════════════════════════════════════════════════

    public func getAllSwarms() : [(SwarmId, Text)] {
      Iter.toArray(Iter.map<(SwarmId, VirtualMission), (SwarmId, Text)>(
        swarms.entries(),
        func((id, mission)) {
          let status = switch (mission.status) {
            case (#Spawning) { "Spawning" };
            case (#Active) { "Active" };
            case (#Paused) { "Paused" };
            case (#Completed) { "Completed" };
            case (#Aborted) { "Aborted" };
          };
          (id, status)
        }
      ))
    };

  };

}
