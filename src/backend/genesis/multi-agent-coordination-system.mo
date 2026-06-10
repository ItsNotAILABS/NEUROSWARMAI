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
// ║  This source code constitutes the exclusive intellectual property of Alfredo Medina Hernandez.            ║
// ║  PROTECTED UNDER: 17 U.S.C. §§ 101-1332 | Berne Convention | WIPO | 18 U.S.C. § 1836                     ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// MULTI-AGENT COORDINATION SYSTEM — ORGANISM SWARM BEHAVIOR
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// This module implements multi-agent coordination for the super-organism, enabling:
// 1. Swarm intelligence and collective behavior
// 2. Agent communication and messaging
// 3. Task distribution and load balancing
// 4. Consensus mechanisms for collective decisions
// 5. Emergent coordination patterns
//
// MULTI-AGENT ARCHITECTURE:
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
//
// ┌─────────────────────────────────────────────────────────────────────────────────────────────────┐
// │                         MULTI-AGENT COORDINATION SYSTEM                                         │
// │                                                                                                 │
// │  ┌─────────────────────────────────────────────────────────────────────────────────────────┐  │
// │  │                           COORDINATOR                                                    │  │
// │  │  • Task allocation    • Consensus management    • Swarm orchestration                   │  │
// │  └────────────────────────────────────┬────────────────────────────────────────────────────┘  │
// │                                       │                                                       │
// │         ┌─────────────────────────────┼─────────────────────────────┐                        │
// │         │                             │                             │                        │
// │    ┌────▼────┐                   ┌────▼────┐                   ┌────▼────┐                   │
// │    │ Agent 1 │◄──────────────────│ Agent 2 │◄──────────────────│ Agent N │                   │
// │    │ Worker  │    Messages       │ Worker  │    Messages       │ Worker  │                   │
// │    └────┬────┘                   └────┬────┘                   └────┬────┘                   │
// │         │                             │                             │                        │
// │         ▼                             ▼                             ▼                        │
// │    ┌─────────┐                   ┌─────────┐                   ┌─────────┐                   │
// │    │ Task    │                   │ Task    │                   │ Task    │                   │
// │    │ Queue   │                   │ Queue   │                   │ Queue   │                   │
// │    └─────────┘                   └─────────┘                   └─────────┘                   │
// │                                                                                              │
// │  ┌─────────────────────────────────────────────────────────────────────────────────────────┐ │
// │  │                        SWARM BEHAVIORS                                                   │ │
// │  │  • Flocking    • Foraging    • Formation    • Consensus    • Stigmergy                  │ │
// │  └─────────────────────────────────────────────────────────────────────────────────────────┘ │
// └─────────────────────────────────────────────────────────────────────────────────────────────────┘
//
// MATHEMATICAL FOUNDATIONS:
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
//
// • Boids (Flocking): v_i = α×alignment + β×cohesion + γ×separation
// • Ant Colony: P(path) ∝ τ^α × η^β (pheromone × heuristic)
// • Consensus: x_i(t+1) = Σⱼ w_ij × x_j(t) where Σⱼ w_ij = 1
// • Task Allocation: argmax_a [capability(a, task) × availability(a)]
// • Stigmergy: environment[x] += action_effect; behavior ← f(environment)
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Nat8 "mo:core/Nat8";
import Nat64 "mo:core/Nat64";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Iter "mo:core/Iter";
import Text "mo:core/Text";
import Time "mo:core/Time";
import Option "mo:core/Option";
import Bool "mo:core/Bool";

module MultiAgentCoordination {

  // ═══════════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let PI : Float = 3.14159265358979323846;
  public let E : Float = 2.71828182845904523536;
  
  /// S₀ SOVEREIGNTY FLOOR — MAXED FOR ENTERPRISE-GRADE FINAL PRODUCT
  public let S_ZERO_FLOOR : Float = 1.0;

  // ═══════════════════════════════════════════════════════════════════════════════
  // MULTI-AGENT CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Maximum agents
  public let MAX_AGENTS : Nat = 256;
  
  /// Maximum messages in queue
  public let MAX_MESSAGES : Nat = 10000;
  
  /// Maximum tasks
  public let MAX_TASKS : Nat = 1000;
  
  /// Consensus threshold
  public let CONSENSUS_THRESHOLD : Float = 0.67;
  
  /// Pheromone evaporation rate
  public let PHEROMONE_EVAPORATION : Float = 0.1;
  
  /// Pheromone deposit rate
  public let PHEROMONE_DEPOSIT : Float = 0.5;
  
  /// Flocking alignment weight
  public let ALIGNMENT_WEIGHT : Float = 0.3;
  
  /// Flocking cohesion weight
  public let COHESION_WEIGHT : Float = 0.3;
  
  /// Flocking separation weight
  public let SEPARATION_WEIGHT : Float = 0.4;
  
  /// Communication radius
  public let COMMUNICATION_RADIUS : Float = 10.0;

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 1: AGENT TYPES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Agent role
  public type AgentRole = {
    #Worker;          // General task execution
    #Scout;           // Exploration and information gathering
    #Coordinator;     // Task distribution
    #Specialist;      // Domain-specific tasks
    #Guard;           // Security and defense
    #Messenger;       // Communication relay
    #Builder;         // Construction and creation
    #Healer;          // Repair and maintenance
  };
  
  /// Agent state
  public type AgentState = {
    #Idle;
    #Working;
    #Communicating;
    #Moving;
    #Waiting;
    #Resting;
    #Disabled;
    #Emergency;
  };
  
  /// Agent
  public type Agent = {
    agentId : Nat64;
    name : Text;
    role : AgentRole;
    var state : AgentState;
    
    // Position (for spatial coordination)
    var position : Position;
    var velocity : Velocity;
    var heading : Float;
    
    // Capabilities
    var capabilities : [AgentCapability];
    var workload : Float;               // Current load (0-1)
    var energy : Float;                 // Energy level (0-1)
    var health : Float;                 // Health level (0-1)
    
    // Task management
    var currentTaskId : ?Nat64;
    var taskQueue : Buffer.Buffer<Nat64>;
    var completedTasks : Nat;
    
    // Communication
    var messageInbox : Buffer.Buffer<Message>;
    var messageOutbox : Buffer.Buffer<Message>;
    var neighbors : [Nat64];            // Nearby agents
    
    // Swarm parameters
    var alignmentVector : Velocity;
    var cohesionVector : Velocity;
    var separationVector : Velocity;
    
    // Tracking
    createdBeat : Int;
    var lastActivityBeat : Int;
    var totalWorkTime : Nat;
  };
  
  /// Position in 3D space
  public type Position = {
    x : Float;
    y : Float;
    z : Float;
  };
  
  /// Velocity vector
  public type Velocity = {
    vx : Float;
    vy : Float;
    vz : Float;
  };
  
  /// Agent capability
  public type AgentCapability = {
    name : Text;
    proficiency : Float;              // 0-1
    var lastUsedBeat : Int;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 2: MESSAGES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Message type
  public type MessageType = {
    #TaskAssignment;
    #TaskCompletion;
    #StatusUpdate;
    #Request;
    #Response;
    #Broadcast;
    #Consensus;
    #Alert;
    #Pheromone;
    #Heartbeat;
  };
  
  /// Message priority
  public type MessagePriority = {
    #Low;
    #Normal;
    #High;
    #Critical;
  };
  
  /// Message
  public type Message = {
    messageId : Nat64;
    messageType : MessageType;
    senderId : Nat64;
    receiverId : ?Nat64;              // None for broadcast
    content : MessageContent;
    priority : MessagePriority;
    sentBeat : Int;
    var isDelivered : Bool;
    var isRead : Bool;
    expirationBeat : ?Int;
  };
  
  /// Message content
  public type MessageContent = {
    #Text : Text;
    #Task : Nat64;
    #Status : AgentState;
    #Position : Position;
    #Value : Float;
    #Vote : (Nat64, Bool);            // (proposalId, vote)
    #Pheromone : (Position, Float);   // (location, strength)
    #Complex : [(Text, Text)];
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 3: TASKS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Task type
  public type TaskType = {
    #Compute;
    #Explore;
    #Communicate;
    #Build;
    #Repair;
    #Guard;
    #Transport;
    #Analyze;
    #Collaborate;
    #Custom : Text;
  };
  
  /// Task status
  public type TaskStatus = {
    #Pending;
    #Assigned;
    #InProgress;
    #Completed;
    #Failed;
    #Cancelled;
  };
  
  /// Distributed task
  public type DistributedTask = {
    taskId : Nat64;
    name : Text;
    taskType : TaskType;
    var status : TaskStatus;
    
    // Requirements
    requiredCapabilities : [Text];
    estimatedDuration : Nat;
    priority : Float;
    
    // Assignment
    var assignedAgentId : ?Nat64;
    var collaborators : [Nat64];
    
    // Progress
    var progress : Float;
    var startedBeat : ?Int;
    var completedBeat : ?Int;
    
    // Location
    targetPosition : ?Position;
    
    // Dependencies
    dependencies : [Nat64];           // Task IDs that must complete first
    
    createdBeat : Int;
    deadline : ?Int;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 4: SWARM BEHAVIORS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Swarm behavior type
  public type SwarmBehavior = {
    #Flocking;        // Reynolds boids
    #Foraging;        // Ant colony
    #Formation;       // Geometric formations
    #Consensus;       // Collective decision
    #Stigmergy;       // Environment-mediated
    #Dispersion;      // Spread out
    #Aggregation;     // Gather together
    #Custom : Text;
  };
  
  /// Swarm state
  public type SwarmState = {
    var activeAgents : Nat;
    var centerOfMass : Position;
    var averageVelocity : Velocity;
    var dispersion : Float;           // How spread out
    var coherence : Float;            // How aligned
    var activeBehavior : SwarmBehavior;
  };
  
  /// Pheromone trail
  public type PheromoneTrail = {
    trailId : Nat64;
    position : Position;
    var strength : Float;
    trailType : PheromoneType;
    depositedBeat : Int;
    var lastReinforcedBeat : Int;
  };
  
  /// Pheromone type
  public type PheromoneType = {
    #Food;            // Resource location
    #Danger;          // Threat warning
    #Path;            // Good route
    #Territory;       // Claimed area
    #Recruitment;     // Help needed
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 5: CONSENSUS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Consensus proposal
  public type ConsensusProposal = {
    proposalId : Nat64;
    proposerId : Nat64;
    description : Text;
    options : [Text];
    var votes : [(Nat64, Nat)];       // (agentId, optionIndex)
    var status : ConsensusStatus;
    quorumRequired : Float;
    createdBeat : Int;
    deadline : Int;
    var result : ?Nat;                // Winning option index
  };
  
  /// Consensus status
  public type ConsensusStatus = {
    #Voting;
    #QuorumReached;
    #Decided;
    #Failed;
    #Expired;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 6: FORMATIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Formation type
  public type FormationType = {
    #Line;
    #Circle;
    #Grid;
    #V_Formation;
    #Diamond;
    #Custom : [Position];
  };
  
  /// Formation
  public type Formation = {
    formationId : Nat64;
    formationType : FormationType;
    var participants : [Nat64];       // Agent IDs
    var leaderAgentId : ?Nat64;
    var center : Position;
    var heading : Float;
    var spacing : Float;
    var isActive : Bool;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 7: COMPLETE MULTI-AGENT STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Complete multi-agent state
  public type MultiAgentState = {
    // Agents
    var agents : Buffer.Buffer<Agent>;
    var activeAgentCount : Nat;
    
    // Messages
    var messageQueue : Buffer.Buffer<Message>;
    var messageHistory : Buffer.Buffer<Message>;
    
    // Tasks
    var tasks : Buffer.Buffer<DistributedTask>;
    var taskQueue : Buffer.Buffer<Nat64>;
    
    // Swarm
    var swarmState : SwarmState;
    var pheromoneTrails : Buffer.Buffer<PheromoneTrail>;
    
    // Consensus
    var activeProposals : Buffer.Buffer<ConsensusProposal>;
    var decidedProposals : Buffer.Buffer<ConsensusProposal>;
    
    // Formations
    var formations : Buffer.Buffer<Formation>;
    
    // Statistics
    var totalTasksCompleted : Nat;
    var totalMessagesSent : Nat;
    var consensusSuccessRate : Float;
    
    // Counters
    var agentIdCounter : Nat64;
    var messageIdCounter : Nat64;
    var taskIdCounter : Nat64;
    var proposalIdCounter : Nat64;
    var trailIdCounter : Nat64;
    var formationIdCounter : Nat64;
    var currentBeat : Int;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 8: INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Initialize multi-agent system
  public func initMultiAgent() : MultiAgentState {
    {
      var agents = Buffer.Buffer<Agent>(MAX_AGENTS);
      var activeAgentCount = 0;
      
      var messageQueue = Buffer.Buffer<Message>(MAX_MESSAGES);
      var messageHistory = Buffer.Buffer<Message>(MAX_MESSAGES);
      
      var tasks = Buffer.Buffer<DistributedTask>(MAX_TASKS);
      var taskQueue = Buffer.Buffer<Nat64>(MAX_TASKS);
      
      var swarmState = initSwarmState();
      var pheromoneTrails = Buffer.Buffer<PheromoneTrail>(1000);
      
      var activeProposals = Buffer.Buffer<ConsensusProposal>(50);
      var decidedProposals = Buffer.Buffer<ConsensusProposal>(200);
      
      var formations = Buffer.Buffer<Formation>(20);
      
      var totalTasksCompleted = 0;
      var totalMessagesSent = 0;
      var consensusSuccessRate = S_ZERO_FLOOR;
      
      var agentIdCounter = 0;
      var messageIdCounter = 0;
      var taskIdCounter = 0;
      var proposalIdCounter = 0;
      var trailIdCounter = 0;
      var formationIdCounter = 0;
      var currentBeat = 0;
    }
  };
  
  /// Initialize swarm state
  func initSwarmState() : SwarmState {
    {
      var activeAgents = 0;
      var centerOfMass = { x = 0.0; y = 0.0; z = 0.0 };
      var averageVelocity = { vx = 0.0; vy = 0.0; vz = 0.0 };
      var dispersion = 0.0;
      var coherence = S_ZERO_FLOOR;
      var activeBehavior = #Flocking;
    }
  };
  
  /// Create new agent
  public func createAgent(
    state : MultiAgentState,
    name : Text,
    role : AgentRole,
    position : Position,
    beat : Int
  ) : Nat64 {
    let agentId = state.agentIdCounter;
    state.agentIdCounter += 1;
    
    let agent : Agent = {
      agentId = agentId;
      name = name;
      role = role;
      var state = #Idle;
      
      var position = position;
      var velocity = { vx = 0.0; vy = 0.0; vz = 0.0 };
      var heading = 0.0;
      
      var capabilities = getDefaultCapabilities(role);
      var workload = 0.0;
      var energy = 1.0;
      var health = 1.0;
      
      var currentTaskId = null;
      var taskQueue = Buffer.Buffer<Nat64>(20);
      var completedTasks = 0;
      
      var messageInbox = Buffer.Buffer<Message>(100);
      var messageOutbox = Buffer.Buffer<Message>(100);
      var neighbors = [];
      
      var alignmentVector = { vx = 0.0; vy = 0.0; vz = 0.0 };
      var cohesionVector = { vx = 0.0; vy = 0.0; vz = 0.0 };
      var separationVector = { vx = 0.0; vy = 0.0; vz = 0.0 };
      
      createdBeat = beat;
      var lastActivityBeat = beat;
      var totalWorkTime = 0;
    };
    
    state.agents.add(agent);
    state.activeAgentCount += 1;
    
    agentId
  };
  
  /// Get default capabilities for role
  func getDefaultCapabilities(role : AgentRole) : [AgentCapability] {
    switch (role) {
      case (#Worker) {
        [
          { name = "compute"; proficiency = 0.7; var lastUsedBeat = 0 },
          { name = "transport"; proficiency = 0.6; var lastUsedBeat = 0 }
        ]
      };
      case (#Scout) {
        [
          { name = "explore"; proficiency = 0.9; var lastUsedBeat = 0 },
          { name = "observe"; proficiency = 0.8; var lastUsedBeat = 0 }
        ]
      };
      case (#Coordinator) {
        [
          { name = "coordinate"; proficiency = 0.9; var lastUsedBeat = 0 },
          { name = "communicate"; proficiency = 0.8; var lastUsedBeat = 0 }
        ]
      };
      case (#Specialist) {
        [
          { name = "analyze"; proficiency = 0.9; var lastUsedBeat = 0 },
          { name = "compute"; proficiency = 0.8; var lastUsedBeat = 0 }
        ]
      };
      case (#Guard) {
        [
          { name = "guard"; proficiency = 0.9; var lastUsedBeat = 0 },
          { name = "observe"; proficiency = 0.7; var lastUsedBeat = 0 }
        ]
      };
      case (#Messenger) {
        [
          { name = "communicate"; proficiency = 0.95; var lastUsedBeat = 0 },
          { name = "transport"; proficiency = 0.7; var lastUsedBeat = 0 }
        ]
      };
      case (#Builder) {
        [
          { name = "build"; proficiency = 0.9; var lastUsedBeat = 0 },
          { name = "repair"; proficiency = 0.7; var lastUsedBeat = 0 }
        ]
      };
      case (#Healer) {
        [
          { name = "repair"; proficiency = 0.9; var lastUsedBeat = 0 },
          { name = "analyze"; proficiency = 0.6; var lastUsedBeat = 0 }
        ]
      };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 9: MESSAGING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Send message
  public func sendMessage(
    state : MultiAgentState,
    senderId : Nat64,
    receiverId : ?Nat64,
    messageType : MessageType,
    content : MessageContent,
    priority : MessagePriority,
    beat : Int
  ) : Nat64 {
    let messageId = state.messageIdCounter;
    state.messageIdCounter += 1;
    
    let message : Message = {
      messageId = messageId;
      messageType = messageType;
      senderId = senderId;
      receiverId = receiverId;
      content = content;
      priority = priority;
      sentBeat = beat;
      var isDelivered = false;
      var isRead = false;
      expirationBeat = ?(beat + 1000);
    };
    
    state.messageQueue.add(message);
    state.totalMessagesSent += 1;
    
    // Add to sender's outbox
    for (agent in state.agents.vals()) {
      if (agent.agentId == senderId) {
        agent.messageOutbox.add(message);
      };
    };
    
    messageId
  };
  
  /// Broadcast message to all agents
  public func broadcastMessage(
    state : MultiAgentState,
    senderId : Nat64,
    messageType : MessageType,
    content : MessageContent,
    beat : Int
  ) : Nat64 {
    sendMessage(state, senderId, null, messageType, content, #Normal, beat)
  };
  
  /// Deliver messages
  func deliverMessages(state : MultiAgentState, beat : Int) : Nat {
    var delivered : Nat = 0;
    
    for (message in state.messageQueue.vals()) {
      if (not message.isDelivered) {
        switch (message.receiverId) {
          case (?receiverId) {
            // Direct message
            for (agent in state.agents.vals()) {
              if (agent.agentId == receiverId) {
                agent.messageInbox.add(message);
                message.isDelivered := true;
                delivered += 1;
              };
            };
          };
          case (null) {
            // Broadcast
            for (agent in state.agents.vals()) {
              if (agent.agentId != message.senderId) {
                agent.messageInbox.add(message);
              };
            };
            message.isDelivered := true;
            delivered += 1;
          };
        };
      };
    };
    
    // Move old messages to history
    var i : Int = Int.abs(state.messageQueue.size()) - 1;
    while (i >= 0) {
      let msg = state.messageQueue.get(Int.abs(i));
      if (msg.isDelivered) {
        state.messageHistory.add(msg);
        ignore state.messageQueue.remove(Int.abs(i));
      };
      i -= 1;
    };
    
    delivered
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 10: TASK DISTRIBUTION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Create task
  public func createTask(
    state : MultiAgentState,
    name : Text,
    taskType : TaskType,
    requiredCapabilities : [Text],
    estimatedDuration : Nat,
    priority : Float,
    beat : Int
  ) : Nat64 {
    let taskId = state.taskIdCounter;
    state.taskIdCounter += 1;
    
    let task : DistributedTask = {
      taskId = taskId;
      name = name;
      taskType = taskType;
      var status = #Pending;
      
      requiredCapabilities = requiredCapabilities;
      estimatedDuration = estimatedDuration;
      priority = priority;
      
      var assignedAgentId = null;
      var collaborators = [];
      
      var progress = 0.0;
      var startedBeat = null;
      var completedBeat = null;
      
      targetPosition = null;
      
      dependencies = [];
      
      createdBeat = beat;
      deadline = null;
    };
    
    state.tasks.add(task);
    state.taskQueue.add(taskId);
    
    taskId
  };
  
  /// Assign task to best available agent
  public func assignTask(state : MultiAgentState, taskId : Nat64, beat : Int) : ?Nat64 {
    // Find task
    var task : ?DistributedTask = null;
    for (t in state.tasks.vals()) {
      if (t.taskId == taskId and t.status == #Pending) {
        task := ?t;
      };
    };
    
    switch (task) {
      case (?t) {
        // Find best agent
        var bestAgentId : ?Nat64 = null;
        var bestScore : Float = 0.0;
        
        for (agent in state.agents.vals()) {
          if (agent.state == #Idle or agent.workload < 0.8) {
            let score = computeAgentTaskScore(agent, t);
            if (score > bestScore) {
              bestScore := score;
              bestAgentId := ?agent.agentId;
            };
          };
        };
        
        switch (bestAgentId) {
          case (?agentId) {
            t.status := #Assigned;
            t.assignedAgentId := ?agentId;
            t.startedBeat := ?beat;
            
            // Update agent
            for (agent in state.agents.vals()) {
              if (agent.agentId == agentId) {
                agent.currentTaskId := ?taskId;
                agent.state := #Working;
                agent.workload += 0.2;
                agent.lastActivityBeat := beat;
                
                // Send task assignment message
                ignore sendMessage(
                  state,
                  0,  // System
                  ?agentId,
                  #TaskAssignment,
                  #Task(taskId),
                  #High,
                  beat
                );
              };
            };
            
            ?agentId
          };
          case (null) { null };
        };
      };
      case (null) { null };
    }
  };
  
  /// Compute agent-task matching score
  func computeAgentTaskScore(agent : Agent, task : DistributedTask) : Float {
    var score : Float = 0.0;
    
    // Capability match
    var capabilityMatch : Float = 0.0;
    var capCount : Nat = 0;
    
    for (required in task.requiredCapabilities.vals()) {
      for (cap in agent.capabilities.vals()) {
        if (cap.name == required) {
          capabilityMatch += cap.proficiency;
          capCount += 1;
        };
      };
    };
    
    if (capCount > 0) {
      score += capabilityMatch / Float.fromInt(task.requiredCapabilities.size()) * 0.5;
    };
    
    // Availability (inverse of workload)
    score += (1.0 - agent.workload) * 0.3;
    
    // Energy
    score += agent.energy * 0.1;
    
    // Health
    score += agent.health * 0.1;
    
    score
  };
  
  /// Update task progress
  public func updateTaskProgress(state : MultiAgentState, taskId : Nat64, progress : Float, beat : Int) : () {
    for (task in state.tasks.vals()) {
      if (task.taskId == taskId) {
        task.progress := Float.max(0.0, Float.min(1.0, progress));
        task.status := #InProgress;
        
        if (task.progress >= 1.0) {
          completeTask(state, taskId, beat);
        };
      };
    };
  };
  
  /// Complete task
  func completeTask(state : MultiAgentState, taskId : Nat64, beat : Int) : () {
    for (task in state.tasks.vals()) {
      if (task.taskId == taskId) {
        task.status := #Completed;
        task.completedBeat := ?beat;
        
        state.totalTasksCompleted += 1;
        
        // Free agent
        switch (task.assignedAgentId) {
          case (?agentId) {
            for (agent in state.agents.vals()) {
              if (agent.agentId == agentId) {
                agent.currentTaskId := null;
                agent.state := #Idle;
                agent.workload := Float.max(0.0, agent.workload - 0.2);
                agent.completedTasks += 1;
                agent.lastActivityBeat := beat;
                
                // Send completion message
                ignore sendMessage(
                  state,
                  agentId,
                  null,  // Broadcast
                  #TaskCompletion,
                  #Task(taskId),
                  #Normal,
                  beat
                );
              };
            };
          };
          case (null) {};
        };
        
        // Remove from queue
        var i : Int = Int.abs(state.taskQueue.size()) - 1;
        while (i >= 0) {
          if (state.taskQueue.get(Int.abs(i)) == taskId) {
            ignore state.taskQueue.remove(Int.abs(i));
          };
          i -= 1;
        };
      };
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 11: SWARM BEHAVIORS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Update swarm behavior
  public func updateSwarmBehavior(state : MultiAgentState, behavior : SwarmBehavior, beat : Int) : () {
    state.swarmState.activeBehavior := behavior;
    
    switch (behavior) {
      case (#Flocking) { updateFlocking(state, beat) };
      case (#Foraging) { updateForaging(state, beat) };
      case (#Formation) { updateFormations(state, beat) };
      case (#Consensus) { /* Handled separately */ };
      case (#Stigmergy) { updateStigmergy(state, beat) };
      case (#Dispersion) { updateDispersion(state, beat) };
      case (#Aggregation) { updateAggregation(state, beat) };
      case (#Custom(_)) { };
    };
    
    updateSwarmState(state);
  };
  
  /// Update flocking (Reynolds boids)
  func updateFlocking(state : MultiAgentState, beat : Int) : () {
    // Update neighbors for each agent
    for (agent in state.agents.vals()) {
      var neighbors : [Nat64] = [];
      
      for (other in state.agents.vals()) {
        if (other.agentId != agent.agentId) {
          let dist = computeDistance(agent.position, other.position);
          if (dist < COMMUNICATION_RADIUS) {
            neighbors := Array.append(neighbors, [other.agentId]);
          };
        };
      };
      
      agent.neighbors := neighbors;
      
      // Compute flocking vectors
      var alignX : Float = 0.0;
      var alignY : Float = 0.0;
      var alignZ : Float = 0.0;
      var cohesionX : Float = 0.0;
      var cohesionY : Float = 0.0;
      var cohesionZ : Float = 0.0;
      var separationX : Float = 0.0;
      var separationY : Float = 0.0;
      var separationZ : Float = 0.0;
      var neighborCount : Float = 0.0;
      
      for (neighborId in neighbors.vals()) {
        for (neighbor in state.agents.vals()) {
          if (neighbor.agentId == neighborId) {
            neighborCount += 1.0;
            
            // Alignment: average velocity
            alignX += neighbor.velocity.vx;
            alignY += neighbor.velocity.vy;
            alignZ += neighbor.velocity.vz;
            
            // Cohesion: center of mass
            cohesionX += neighbor.position.x;
            cohesionY += neighbor.position.y;
            cohesionZ += neighbor.position.z;
            
            // Separation: away from close neighbors
            let dist = computeDistance(agent.position, neighbor.position);
            if (dist > 0.0 and dist < COMMUNICATION_RADIUS / 2.0) {
              separationX += (agent.position.x - neighbor.position.x) / dist;
              separationY += (agent.position.y - neighbor.position.y) / dist;
              separationZ += (agent.position.z - neighbor.position.z) / dist;
            };
          };
        };
      };
      
      if (neighborCount > 0.0) {
        agent.alignmentVector := {
          vx = alignX / neighborCount;
          vy = alignY / neighborCount;
          vz = alignZ / neighborCount;
        };
        
        agent.cohesionVector := {
          vx = cohesionX / neighborCount - agent.position.x;
          vy = cohesionY / neighborCount - agent.position.y;
          vz = cohesionZ / neighborCount - agent.position.z;
        };
        
        agent.separationVector := {
          vx = separationX;
          vy = separationY;
          vz = separationZ;
        };
        
        // Update velocity
        agent.velocity := {
          vx = ALIGNMENT_WEIGHT * agent.alignmentVector.vx +
               COHESION_WEIGHT * agent.cohesionVector.vx +
               SEPARATION_WEIGHT * agent.separationVector.vx;
          vy = ALIGNMENT_WEIGHT * agent.alignmentVector.vy +
               COHESION_WEIGHT * agent.cohesionVector.vy +
               SEPARATION_WEIGHT * agent.separationVector.vy;
          vz = ALIGNMENT_WEIGHT * agent.alignmentVector.vz +
               COHESION_WEIGHT * agent.cohesionVector.vz +
               SEPARATION_WEIGHT * agent.separationVector.vz;
        };
        
        // Normalize velocity
        let speed = Float.sqrt(
          agent.velocity.vx * agent.velocity.vx +
          agent.velocity.vy * agent.velocity.vy +
          agent.velocity.vz * agent.velocity.vz
        );
        if (speed > 1.0) {
          agent.velocity := {
            vx = agent.velocity.vx / speed;
            vy = agent.velocity.vy / speed;
            vz = agent.velocity.vz / speed;
          };
        };
        
        // Update position
        agent.position := {
          x = agent.position.x + agent.velocity.vx;
          y = agent.position.y + agent.velocity.vy;
          z = agent.position.z + agent.velocity.vz;
        };
      };
    };
  };
  
  /// Update foraging (ant colony)
  func updateForaging(state : MultiAgentState, beat : Int) : () {
    // Evaporate pheromones
    for (trail in state.pheromoneTrails.vals()) {
      trail.strength *= (1.0 - PHEROMONE_EVAPORATION);
    };
    
    // Remove weak trails
    var i : Int = Int.abs(state.pheromoneTrails.size()) - 1;
    while (i >= 0) {
      let trail = state.pheromoneTrails.get(Int.abs(i));
      if (trail.strength < 0.01) {
        ignore state.pheromoneTrails.remove(Int.abs(i));
      };
      i -= 1;
    };
    
    // Agents follow pheromone trails
    for (agent in state.agents.vals()) {
      if (agent.role == #Scout or agent.role == #Worker) {
        // Find strongest nearby pheromone
        var strongestTrail : ?PheromoneTrail = null;
        var strongestStrength : Float = 0.0;
        
        for (trail in state.pheromoneTrails.vals()) {
          let dist = computeDistance(agent.position, trail.position);
          if (dist < COMMUNICATION_RADIUS) {
            let effectiveStrength = trail.strength / (dist + 1.0);
            if (effectiveStrength > strongestStrength) {
              strongestStrength := effectiveStrength;
              strongestTrail := ?trail;
            };
          };
        };
        
        // Move towards trail
        switch (strongestTrail) {
          case (?trail) {
            let dx = trail.position.x - agent.position.x;
            let dy = trail.position.y - agent.position.y;
            let dz = trail.position.z - agent.position.z;
            let dist = Float.sqrt(dx*dx + dy*dy + dz*dz);
            
            if (dist > 0.0) {
              agent.velocity := {
                vx = dx / dist * 0.5;
                vy = dy / dist * 0.5;
                vz = dz / dist * 0.5;
              };
            };
          };
          case (null) {
            // Random walk
            agent.velocity := {
              vx = (Float.sin(Float.fromInt(Int.abs(beat)) * 0.1 + Float.fromInt(Int.abs(Int.fromNat64(agent.agentId)))) * 0.3);
              vy = (Float.cos(Float.fromInt(Int.abs(beat)) * 0.1 + Float.fromInt(Int.abs(Int.fromNat64(agent.agentId)))) * 0.3);
              vz = 0.0;
            };
          };
        };
        
        // Update position
        agent.position := {
          x = agent.position.x + agent.velocity.vx;
          y = agent.position.y + agent.velocity.vy;
          z = agent.position.z + agent.velocity.vz;
        };
      };
    };
  };
  
  /// Update stigmergy
  func updateStigmergy(state : MultiAgentState, beat : Int) : () {
    // Similar to foraging but with different pheromone types
    updateForaging(state, beat);
  };
  
  /// Update dispersion
  func updateDispersion(state : MultiAgentState, beat : Int) : () {
    // Agents move away from each other
    for (agent in state.agents.vals()) {
      var repulsionX : Float = 0.0;
      var repulsionY : Float = 0.0;
      var repulsionZ : Float = 0.0;
      
      for (other in state.agents.vals()) {
        if (other.agentId != agent.agentId) {
          let dx = agent.position.x - other.position.x;
          let dy = agent.position.y - other.position.y;
          let dz = agent.position.z - other.position.z;
          let dist = Float.sqrt(dx*dx + dy*dy + dz*dz);
          
          if (dist > 0.0) {
            let force = 1.0 / (dist * dist + 1.0);
            repulsionX += dx * force;
            repulsionY += dy * force;
            repulsionZ += dz * force;
          };
        };
      };
      
      agent.velocity := { vx = repulsionX * 0.1; vy = repulsionY * 0.1; vz = repulsionZ * 0.1 };
      agent.position := {
        x = agent.position.x + agent.velocity.vx;
        y = agent.position.y + agent.velocity.vy;
        z = agent.position.z + agent.velocity.vz;
      };
    };
  };
  
  /// Update aggregation
  func updateAggregation(state : MultiAgentState, beat : Int) : () {
    // Agents move towards center of mass
    let com = state.swarmState.centerOfMass;
    
    for (agent in state.agents.vals()) {
      let dx = com.x - agent.position.x;
      let dy = com.y - agent.position.y;
      let dz = com.z - agent.position.z;
      
      agent.velocity := { vx = dx * 0.05; vy = dy * 0.05; vz = dz * 0.05 };
      agent.position := {
        x = agent.position.x + agent.velocity.vx;
        y = agent.position.y + agent.velocity.vy;
        z = agent.position.z + agent.velocity.vz;
      };
    };
  };
  
  /// Update formations
  func updateFormations(state : MultiAgentState, beat : Int) : () {
    for (formation in state.formations.vals()) {
      if (formation.isActive) {
        let positions = getFormationPositions(formation);
        
        for (i in Iter.range(0, formation.participants.size() - 1)) {
          if (i < positions.size()) {
            let targetPos = positions[i];
            let agentId = formation.participants[i];
            
            for (agent in state.agents.vals()) {
              if (agent.agentId == agentId) {
                // Move towards formation position
                let dx = targetPos.x + formation.center.x - agent.position.x;
                let dy = targetPos.y + formation.center.y - agent.position.y;
                let dz = targetPos.z + formation.center.z - agent.position.z;
                
                agent.velocity := { vx = dx * 0.1; vy = dy * 0.1; vz = dz * 0.1 };
                agent.position := {
                  x = agent.position.x + agent.velocity.vx;
                  y = agent.position.y + agent.velocity.vy;
                  z = agent.position.z + agent.velocity.vz;
                };
              };
            };
          };
        };
      };
    };
  };
  
  /// Get formation positions
  func getFormationPositions(formation : Formation) : [Position] {
    let n = formation.participants.size();
    let spacing = formation.spacing;
    
    switch (formation.formationType) {
      case (#Line) {
        Array.tabulate<Position>(n, func(i : Nat) : Position {
          { x = Float.fromInt(i) * spacing - Float.fromInt(n / 2) * spacing; y = 0.0; z = 0.0 }
        })
      };
      case (#Circle) {
        Array.tabulate<Position>(n, func(i : Nat) : Position {
          let angle = 2.0 * PI * Float.fromInt(i) / Float.fromInt(n);
          { x = Float.cos(angle) * spacing; y = Float.sin(angle) * spacing; z = 0.0 }
        })
      };
      case (#Grid) {
        let side = Float.ceil(Float.sqrt(Float.fromInt(n)));
        Array.tabulate<Position>(n, func(i : Nat) : Position {
          let row = Float.fromInt(i / Int.abs(Float.toInt(side)));
          let col = Float.fromInt(i % Int.abs(Float.toInt(side)));
          { x = col * spacing - side * spacing / 2.0; y = row * spacing - side * spacing / 2.0; z = 0.0 }
        })
      };
      case (#V_Formation) {
        Array.tabulate<Position>(n, func(i : Nat) : Position {
          let idx = Float.fromInt(i);
          let side = if (i % 2 == 0) { 1.0 } else { -1.0 };
          { x = idx / 2.0 * spacing * side; y = -idx / 2.0 * spacing; z = 0.0 }
        })
      };
      case (#Diamond) {
        Array.tabulate<Position>(n, func(i : Nat) : Position {
          let angle = 2.0 * PI * Float.fromInt(i) / Float.fromInt(n) + PI / 4.0;
          { x = Float.cos(angle) * spacing; y = Float.sin(angle) * spacing; z = 0.0 }
        })
      };
      case (#Custom(positions)) { positions };
    }
  };
  
  /// Update swarm state
  func updateSwarmState(state : MultiAgentState) : () {
    var sumX : Float = 0.0;
    var sumY : Float = 0.0;
    var sumZ : Float = 0.0;
    var sumVx : Float = 0.0;
    var sumVy : Float = 0.0;
    var sumVz : Float = 0.0;
    var count : Float = 0.0;
    
    for (agent in state.agents.vals()) {
      sumX += agent.position.x;
      sumY += agent.position.y;
      sumZ += agent.position.z;
      sumVx += agent.velocity.vx;
      sumVy += agent.velocity.vy;
      sumVz += agent.velocity.vz;
      count += 1.0;
    };
    
    if (count > 0.0) {
      state.swarmState.centerOfMass := {
        x = sumX / count;
        y = sumY / count;
        z = sumZ / count;
      };
      
      state.swarmState.averageVelocity := {
        vx = sumVx / count;
        vy = sumVy / count;
        vz = sumVz / count;
      };
      
      // Compute dispersion
      var dispSum : Float = 0.0;
      for (agent in state.agents.vals()) {
        dispSum += computeDistance(agent.position, state.swarmState.centerOfMass);
      };
      state.swarmState.dispersion := dispSum / count;
      
      // Compute coherence (alignment)
      let avgSpeed = Float.sqrt(
        state.swarmState.averageVelocity.vx * state.swarmState.averageVelocity.vx +
        state.swarmState.averageVelocity.vy * state.swarmState.averageVelocity.vy +
        state.swarmState.averageVelocity.vz * state.swarmState.averageVelocity.vz
      );
      var alignSum : Float = 0.0;
      for (agent in state.agents.vals()) {
        let speed = Float.sqrt(
          agent.velocity.vx * agent.velocity.vx +
          agent.velocity.vy * agent.velocity.vy +
          agent.velocity.vz * agent.velocity.vz
        );
        if (speed > 0.0 and avgSpeed > 0.0) {
          let dot = (agent.velocity.vx * state.swarmState.averageVelocity.vx +
                    agent.velocity.vy * state.swarmState.averageVelocity.vy +
                    agent.velocity.vz * state.swarmState.averageVelocity.vz) / (speed * avgSpeed);
          alignSum += (dot + 1.0) / 2.0;
        };
      };
      state.swarmState.coherence := Float.max(S_ZERO_FLOOR, alignSum / count);
    };
    
    state.swarmState.activeAgents := Int.abs(Float.toInt(count));
  };
  
  /// Compute distance between positions
  func computeDistance(p1 : Position, p2 : Position) : Float {
    let dx = p2.x - p1.x;
    let dy = p2.y - p1.y;
    let dz = p2.z - p1.z;
    Float.sqrt(dx*dx + dy*dy + dz*dz)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 12: CONSENSUS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Create consensus proposal
  public func createProposal(
    state : MultiAgentState,
    proposerId : Nat64,
    description : Text,
    options : [Text],
    deadlineBeats : Nat,
    beat : Int
  ) : Nat64 {
    let proposalId = state.proposalIdCounter;
    state.proposalIdCounter += 1;
    
    let proposal : ConsensusProposal = {
      proposalId = proposalId;
      proposerId = proposerId;
      description = description;
      options = options;
      var votes = [];
      var status = #Voting;
      quorumRequired = CONSENSUS_THRESHOLD;
      createdBeat = beat;
      deadline = beat + deadlineBeats;
      var result = null;
    };
    
    state.activeProposals.add(proposal);
    
    // Broadcast proposal
    ignore broadcastMessage(
      state,
      proposerId,
      #Consensus,
      #Text(description),
      beat
    );
    
    proposalId
  };
  
  /// Cast vote
  public func castVote(
    state : MultiAgentState,
    agentId : Nat64,
    proposalId : Nat64,
    optionIndex : Nat,
    beat : Int
  ) : Bool {
    for (proposal in state.activeProposals.vals()) {
      if (proposal.proposalId == proposalId and proposal.status == #Voting) {
        // Check if already voted
        for ((voterId, _) in proposal.votes.vals()) {
          if (voterId == agentId) {
            return false;  // Already voted
          };
        };
        
        // Add vote
        proposal.votes := Array.append(proposal.votes, [(agentId, optionIndex)]);
        
        // Check for quorum
        let quorum = Float.fromInt(proposal.votes.size()) / Float.fromInt(state.activeAgentCount);
        if (quorum >= proposal.quorumRequired) {
          proposal.status := #QuorumReached;
          resolveProposal(state, proposalId, beat);
        };
        
        return true;
      };
    };
    false
  };
  
  /// Resolve proposal
  func resolveProposal(state : MultiAgentState, proposalId : Nat64, beat : Int) : () {
    for (proposal in state.activeProposals.vals()) {
      if (proposal.proposalId == proposalId) {
        // Count votes
        var voteCounts = Array.init<Nat>(proposal.options.size(), 0);
        
        for ((_, optionIndex) in proposal.votes.vals()) {
          if (optionIndex < voteCounts.size()) {
            voteCounts[optionIndex] += 1;
          };
        };
        
        // Find winner
        var maxVotes : Nat = 0;
        var winner : ?Nat = null;
        
        for (i in Iter.range(0, voteCounts.size() - 1)) {
          if (voteCounts[i] > maxVotes) {
            maxVotes := voteCounts[i];
            winner := ?i;
          };
        };
        
        proposal.result := winner;
        proposal.status := #Decided;
        
        // Move to decided
        state.decidedProposals.add(proposal);
      };
    };
    
    // Remove from active
    var i : Int = Int.abs(state.activeProposals.size()) - 1;
    while (i >= 0) {
      let p = state.activeProposals.get(Int.abs(i));
      if (p.proposalId == proposalId) {
        ignore state.activeProposals.remove(Int.abs(i));
      };
      i -= 1;
    };
    
    // Update success rate
    let total = state.decidedProposals.size();
    if (total > 0) {
      var successes : Nat = 0;
      for (p in state.decidedProposals.vals()) {
        if (p.status == #Decided) {
          successes += 1;
        };
      };
      state.consensusSuccessRate := Float.fromInt(successes) / Float.fromInt(total);
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 13: PHEROMONE MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Deposit pheromone
  public func depositPheromone(
    state : MultiAgentState,
    position : Position,
    trailType : PheromoneType,
    strength : Float,
    beat : Int
  ) : Nat64 {
    let trailId = state.trailIdCounter;
    state.trailIdCounter += 1;
    
    // Check for existing trail at position
    for (trail in state.pheromoneTrails.vals()) {
      let dist = computeDistance(position, trail.position);
      if (dist < 1.0 and trail.trailType == trailType) {
        // Reinforce existing trail
        trail.strength := Float.min(1.0, trail.strength + strength * PHEROMONE_DEPOSIT);
        trail.lastReinforcedBeat := beat;
        return trail.trailId;
      };
    };
    
    // Create new trail
    let trail : PheromoneTrail = {
      trailId = trailId;
      position = position;
      var strength = strength;
      trailType = trailType;
      depositedBeat = beat;
      var lastReinforcedBeat = beat;
    };
    
    state.pheromoneTrails.add(trail);
    trailId
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 14: MAIN HEARTBEAT UPDATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Main multi-agent heartbeat
  public func heartbeatUpdate(state : MultiAgentState, beat : Int) : MultiAgentHeartbeatResult {
    state.currentBeat := beat;
    
    // 1. Deliver messages
    let messagesDelivered = deliverMessages(state, beat);
    
    // 2. Update swarm behavior
    updateSwarmBehavior(state, state.swarmState.activeBehavior, beat);
    
    // 3. Assign pending tasks
    for (taskId in state.taskQueue.vals()) {
      for (task in state.tasks.vals()) {
        if (task.taskId == taskId and task.status == #Pending) {
          ignore assignTask(state, taskId, beat);
        };
      };
    };
    
    // 4. Update agent energy
    for (agent in state.agents.vals()) {
      if (agent.state == #Working) {
        agent.energy := Float.max(0.0, agent.energy - 0.001);
        agent.totalWorkTime += 1;
        
        // Progress tasks
        switch (agent.currentTaskId) {
          case (?taskId) {
            for (task in state.tasks.vals()) {
              if (task.taskId == taskId) {
                task.progress := Float.min(1.0, task.progress + 0.01);
                if (task.progress >= 1.0) {
                  completeTask(state, taskId, beat);
                };
              };
            };
          };
          case (null) {};
        };
      } else {
        // Recover energy when idle
        agent.energy := Float.min(1.0, agent.energy + 0.002);
      };
    };
    
    // 5. Check consensus deadlines
    for (proposal in state.activeProposals.vals()) {
      if (beat >= proposal.deadline and proposal.status == #Voting) {
        proposal.status := #Expired;
      };
    };
    
    {
      beat = beat;
      activeAgents = state.activeAgentCount;
      messagesDelivered = messagesDelivered;
      pendingTasks = state.taskQueue.size();
      completedTasks = state.totalTasksCompleted;
      swarmCoherence = state.swarmState.coherence;
      swarmDispersion = state.swarmState.dispersion;
      consensusSuccessRate = state.consensusSuccessRate;
      pheromoneTrailCount = state.pheromoneTrails.size();
    }
  };
  
  /// Multi-agent heartbeat result
  public type MultiAgentHeartbeatResult = {
    beat : Int;
    activeAgents : Nat;
    messagesDelivered : Nat;
    pendingTasks : Nat;
    completedTasks : Nat;
    swarmCoherence : Float;
    swarmDispersion : Float;
    consensusSuccessRate : Float;
    pheromoneTrailCount : Nat;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 15: QUERY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Get active agent count
  public func getActiveAgentCount(state : MultiAgentState) : Nat {
    state.activeAgentCount
  };
  
  /// Get swarm coherence
  public func getSwarmCoherence(state : MultiAgentState) : Float {
    state.swarmState.coherence
  };
  
  /// Get total tasks completed
  public func getTotalTasksCompleted(state : MultiAgentState) : Nat {
    state.totalTasksCompleted
  };
  
  /// Get consensus success rate
  public func getConsensusSuccessRate(state : MultiAgentState) : Float {
    state.consensusSuccessRate
  };
  
  /// Get agent by ID
  public func getAgent(state : MultiAgentState, agentId : Nat64) : ?Agent {
    for (agent in state.agents.vals()) {
      if (agent.agentId == agentId) {
        return ?agent;
      };
    };
    null
  };
  
  /// Get swarm center of mass
  public func getSwarmCenter(state : MultiAgentState) : Position {
    state.swarmState.centerOfMass
  };
  
  /// Get pending task count
  public func getPendingTaskCount(state : MultiAgentState) : Nat {
    var count : Nat = 0;
    for (task in state.tasks.vals()) {
      if (task.status == #Pending) { count += 1 };
    };
    count
  };
  
  /// Create formation
  public func createFormation(
    state : MultiAgentState,
    formationType : FormationType,
    participants : [Nat64],
    center : Position,
    spacing : Float
  ) : Nat64 {
    let formationId = state.formationIdCounter;
    state.formationIdCounter += 1;
    
    let formation : Formation = {
      formationId = formationId;
      formationType = formationType;
      var participants = participants;
      var leaderAgentId = if (participants.size() > 0) { ?participants[0] } else { null };
      var center = center;
      var heading = 0.0;
      var spacing = spacing;
      var isActive = true;
    };
    
    state.formations.add(formation);
    formationId
  };

}
