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
import Nat8 "mo:core/Nat8";
import Nat16 "mo:core/Nat16";
import Nat32 "mo:core/Nat32";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Iter "mo:core/Iter";
import Text "mo:core/Text";
import Time "mo:core/Time";
import Option "mo:core/Option";
import Principal "mo:core/Principal";

module TeamFormationEngine {

  // ═══════════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let PI : Float = 3.14159265358979323846;
  public let E : Float = 2.71828182845904523536;
  
  // Team limits
  public let MAX_AGENTS : Nat = 100;
  public let MAX_TEAMS : Nat = 20;
  public let MAX_AGENTS_PER_TEAM : Nat = 10;
  
  // Agent parameters
  public let BASE_CAPABILITY : Float = 0.5;
  public let LEARNING_RATE : Float = 0.01;
  public let FATIGUE_RATE : Float = 0.001;
  public let RECOVERY_RATE : Float = 0.01;

  // ═══════════════════════════════════════════════════════════════════════════════
  // AGENT TYPES — Specialist roles
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type Agent = {
    id : Nat;
    name : Text;
    role : AgentRole;
    capabilities : AgentCapabilities;
    state : AgentState;
    personality : AgentPersonality;
    relationships : [AgentRelationship];
    assignedTeam : ?Nat;
    currentTask : ?Nat;
    metrics : AgentMetrics;
    createdAt : Int;
    lastActive : Int;
  };
  
  public type AgentRole = {
    #Researcher;          // Information gathering
    #Analyst;             // Data analysis
    #Strategist;          // Strategy and planning
    #Executor;            // Task execution
    #Communicator;        // Communication specialist
    #Monitor;             // System monitoring
    #Coordinator;         // Team coordination
    #Specialist;          // Domain specialist
    #Generalist;          // General purpose
    #Guardian;            // Security and safety
  };
  
  public type AgentCapabilities = {
    informationGathering : Float;
    dataAnalysis : Float;
    problemSolving : Float;
    communication : Float;
    coordination : Float;
    learning : Float;
    creativity : Float;
    reliability : Float;
    speed : Float;
    accuracy : Float;
  };
  
  public type AgentState = {
    energy : Float;               // [0, 1]
    focus : Float;                // [0, 1]
    stress : Float;               // [0, 1]
    confidence : Float;           // [0, 1]
    isActive : Bool;
    isAvailable : Bool;
    workload : Float;             // [0, 1]
  };
  
  public type AgentPersonality = {
    extraversion : Float;         // [0, 1] Intro vs Extroverted
    agreeableness : Float;        // [0, 1] 
    conscientiousness : Float;    // [0, 1]
    openness : Float;             // [0, 1]
    stability : Float;            // [0, 1] Emotional stability
  };
  
  public type AgentRelationship = {
    agentId : Nat;
    relationshipType : RelationshipType;
    strength : Float;             // [-1, 1] Negative to positive
    trustLevel : Float;           // [0, 1]
    interactionCount : Nat;
    lastInteraction : Int;
  };
  
  public type RelationshipType = {
    #Colleague;
    #Mentor;
    #Mentee;
    #Leader;
    #Follower;
    #Competitor;
    #Collaborator;
  };
  
  public type AgentMetrics = {
    tasksCompleted : Nat;
    tasksFailed : Nat;
    avgCompletionTime : Float;
    avgQuality : Float;
    teamsJoined : Nat;
    contributionScore : Float;
    reputationScore : Float;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // TEAM TYPES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type Team = {
    id : Nat;
    name : Text;
    purpose : Text;
    teamType : TeamType;
    members : [Nat];              // Agent IDs
    leader : ?Nat;                // Leader agent ID
    status : TeamStatus;
    formation : TeamFormation;
    assignedProject : ?Nat;
    metrics : TeamMetrics;
    createdAt : Int;
    dissolvedAt : ?Int;
  };
  
  public type TeamType = {
    #TaskForce;           // Short-term specific task
    #WorkGroup;           // Ongoing work group
    #Committee;           // Advisory committee
    #SwarmTeam;           // Self-organizing swarm
    #HierarchicalTeam;    // Traditional hierarchy
    #NetworkTeam;         // Network-based
  };
  
  public type TeamStatus = {
    #Forming;             // Team is being assembled
    #Storming;            // Working through conflicts
    #Norming;             // Establishing norms
    #Performing;          // High performance
    #Adjourning;          // Wrapping up
    #Dissolved;           // Team dissolved
  };
  
  public type TeamFormation = {
    strategy : FormationStrategy;
    criteria : [SelectionCriterion];
    minSize : Nat;
    maxSize : Nat;
    requiredRoles : [AgentRole];
    preferredCapabilities : AgentCapabilities;
  };
  
  public type FormationStrategy = {
    #CapabilityBased;     // Select by capabilities
    #RoleBased;           // Select by roles
    #AffinityBased;       // Select by relationships
    #RandomSample;        // Random selection
    #Evolutionary;        // Evolve team composition
    #Hybrid;              // Combination of strategies
  };
  
  public type SelectionCriterion = {
    attribute : Text;
    operator : SelectionOperator;
    value : Float;
    weight : Float;
  };
  
  public type SelectionOperator = {
    #GreaterThan;
    #LessThan;
    #Equals;
    #Between;
  };
  
  public type TeamMetrics = {
    productivity : Float;         // Tasks completed per beat
    quality : Float;              // Average quality
    cohesion : Float;             // Team coherence
    communication : Float;        // Communication effectiveness
    adaptability : Float;         // Ability to adapt
    innovation : Float;           // New ideas generated
    conflictLevel : Float;        // Level of conflict
    morale : Float;               // Team morale
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // COMMUNICATION SYSTEM
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type Message = {
    id : Nat;
    sender : Nat;                 // Agent ID
    recipients : [Nat];           // Agent IDs
    messageType : MessageType;
    content : Text;
    priority : MessagePriority;
    timestamp : Int;
    isRead : Bool;
    responses : [Nat];            // Response message IDs
  };
  
  public type MessageType = {
    #Information;         // Sharing information
    #Request;             // Requesting action
    #Response;            // Responding to request
    #Directive;           // Giving direction
    #Query;               // Asking question
    #Alert;               // Urgent alert
    #Status;              // Status update
    #Coordination;        // Coordination message
  };
  
  public type MessagePriority = {
    #Critical;
    #High;
    #Normal;
    #Low;
  };
  
  public type CommunicationChannel = {
    id : Nat;
    name : Text;
    channelType : ChannelType;
    members : [Nat];
    isActive : Bool;
    messageCount : Nat;
    lastActivity : Int;
  };
  
  public type ChannelType = {
    #Direct;              // One-to-one
    #Team;                // Team channel
    #Broadcast;           // All agents
    #Topic;               // Topic-based
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // AGENT FACTORY — Creating new agents
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func createAgent(
    id : Nat,
    name : Text,
    role : AgentRole,
    currentTime : Int
  ) : Agent {
    let baseCaps = roleCapabilities(role);
    
    {
      id = id;
      name = name;
      role = role;
      capabilities = baseCaps;
      state = {
        energy = 1.0;
        focus = 0.8;
        stress = 0.0;
        confidence = 0.7;
        isActive = true;
        isAvailable = true;
        workload = 0.0;
      };
      personality = generatePersonality(role);
      relationships = [];
      assignedTeam = null;
      currentTask = null;
      metrics = {
        tasksCompleted = 0;
        tasksFailed = 0;
        avgCompletionTime = 0.0;
        avgQuality = 0.0;
        teamsJoined = 0;
        contributionScore = 0.0;
        reputationScore = 0.5;
      };
      createdAt = currentTime;
      lastActive = currentTime;
    }
  };
  
  func roleCapabilities(role : AgentRole) : AgentCapabilities {
    switch (role) {
      case (#Researcher) {
        { informationGathering = 0.9; dataAnalysis = 0.7; problemSolving = 0.6; communication = 0.5; coordination = 0.3; learning = 0.9; creativity = 0.7; reliability = 0.8; speed = 0.6; accuracy = 0.85 }
      };
      case (#Analyst) {
        { informationGathering = 0.6; dataAnalysis = 0.95; problemSolving = 0.8; communication = 0.6; coordination = 0.4; learning = 0.7; creativity = 0.5; reliability = 0.9; speed = 0.7; accuracy = 0.95 }
      };
      case (#Strategist) {
        { informationGathering = 0.7; dataAnalysis = 0.8; problemSolving = 0.9; communication = 0.7; coordination = 0.8; learning = 0.7; creativity = 0.85; reliability = 0.75; speed = 0.5; accuracy = 0.8 }
      };
      case (#Executor) {
        { informationGathering = 0.4; dataAnalysis = 0.4; problemSolving = 0.5; communication = 0.5; coordination = 0.5; learning = 0.5; creativity = 0.3; reliability = 0.95; speed = 0.9; accuracy = 0.85 }
      };
      case (#Communicator) {
        { informationGathering = 0.6; dataAnalysis = 0.4; problemSolving = 0.5; communication = 0.95; coordination = 0.7; learning = 0.6; creativity = 0.7; reliability = 0.8; speed = 0.8; accuracy = 0.75 }
      };
      case (#Monitor) {
        { informationGathering = 0.85; dataAnalysis = 0.7; problemSolving = 0.6; communication = 0.6; coordination = 0.5; learning = 0.6; creativity = 0.3; reliability = 0.95; speed = 0.8; accuracy = 0.9 }
      };
      case (#Coordinator) {
        { informationGathering = 0.6; dataAnalysis = 0.5; problemSolving = 0.7; communication = 0.85; coordination = 0.95; learning = 0.6; creativity = 0.5; reliability = 0.85; speed = 0.7; accuracy = 0.8 }
      };
      case (#Specialist) {
        { informationGathering = 0.7; dataAnalysis = 0.8; problemSolving = 0.85; communication = 0.5; coordination = 0.4; learning = 0.8; creativity = 0.6; reliability = 0.85; speed = 0.7; accuracy = 0.9 }
      };
      case (#Generalist) {
        { informationGathering = 0.7; dataAnalysis = 0.7; problemSolving = 0.7; communication = 0.7; coordination = 0.7; learning = 0.7; creativity = 0.7; reliability = 0.7; speed = 0.7; accuracy = 0.7 }
      };
      case (#Guardian) {
        { informationGathering = 0.8; dataAnalysis = 0.7; problemSolving = 0.75; communication = 0.6; coordination = 0.6; learning = 0.6; creativity = 0.4; reliability = 0.95; speed = 0.85; accuracy = 0.9 }
      };
    }
  };
  
  func generatePersonality(role : AgentRole) : AgentPersonality {
    // Role-appropriate personality traits
    switch (role) {
      case (#Researcher) { { extraversion = 0.3; agreeableness = 0.7; conscientiousness = 0.8; openness = 0.9; stability = 0.7 } };
      case (#Analyst) { { extraversion = 0.4; agreeableness = 0.6; conscientiousness = 0.95; openness = 0.7; stability = 0.8 } };
      case (#Strategist) { { extraversion = 0.6; agreeableness = 0.5; conscientiousness = 0.7; openness = 0.85; stability = 0.75 } };
      case (#Executor) { { extraversion = 0.5; agreeableness = 0.7; conscientiousness = 0.9; openness = 0.4; stability = 0.85 } };
      case (#Communicator) { { extraversion = 0.9; agreeableness = 0.85; conscientiousness = 0.7; openness = 0.75; stability = 0.7 } };
      case (#Monitor) { { extraversion = 0.3; agreeableness = 0.6; conscientiousness = 0.95; openness = 0.5; stability = 0.9 } };
      case (#Coordinator) { { extraversion = 0.75; agreeableness = 0.8; conscientiousness = 0.85; openness = 0.65; stability = 0.8 } };
      case (#Specialist) { { extraversion = 0.4; agreeableness = 0.6; conscientiousness = 0.85; openness = 0.7; stability = 0.75 } };
      case (#Generalist) { { extraversion = 0.6; agreeableness = 0.7; conscientiousness = 0.7; openness = 0.75; stability = 0.75 } };
      case (#Guardian) { { extraversion = 0.4; agreeableness = 0.6; conscientiousness = 0.9; openness = 0.4; stability = 0.9 } };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // TEAM FORMATION ALGORITHMS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  // Form team based on capability requirements
  public func formTeamByCapabilities(
    agents : [Agent],
    requirements : AgentCapabilities,
    teamSize : Nat
  ) : [Nat] {
    let scoredAgents = Buffer.Buffer<(Nat, Float)>(agents.size());
    
    // Score each agent
    for (agent in agents.vals()) {
      if (agent.state.isAvailable) {
        let score = computeCapabilityMatch(agent.capabilities, requirements);
        scoredAgents.add((agent.id, score));
      };
    };
    
    // Sort by score (highest first) - simple bubble sort
    let arr = Buffer.toArray(scoredAgents);
    let sorted = Array.sort<(Nat, Float)>(arr, func(a : (Nat, Float), b : (Nat, Float)) : {#less; #equal; #greater} {
      if (a.1 > b.1) { #less }
      else if (a.1 < b.1) { #greater }
      else { #equal }
    });
    
    // Take top N
    let selected = Buffer.Buffer<Nat>(teamSize);
    var count : Nat = 0;
    
    for ((id, _score) in sorted.vals()) {
      if (count < teamSize) {
        selected.add(id);
        count += 1;
      };
    };
    
    Buffer.toArray(selected)
  };
  
  func computeCapabilityMatch(
    agent : AgentCapabilities,
    required : AgentCapabilities
  ) : Float {
    var totalScore : Float = 0.0;
    
    totalScore += matchScore(agent.informationGathering, required.informationGathering);
    totalScore += matchScore(agent.dataAnalysis, required.dataAnalysis);
    totalScore += matchScore(agent.problemSolving, required.problemSolving);
    totalScore += matchScore(agent.communication, required.communication);
    totalScore += matchScore(agent.coordination, required.coordination);
    totalScore += matchScore(agent.learning, required.learning);
    totalScore += matchScore(agent.creativity, required.creativity);
    totalScore += matchScore(agent.reliability, required.reliability);
    totalScore += matchScore(agent.speed, required.speed);
    totalScore += matchScore(agent.accuracy, required.accuracy);
    
    totalScore / 10.0
  };
  
  func matchScore(agent : Float, required : Float) : Float {
    if (agent >= required) {
      1.0
    } else {
      agent / required
    }
  };
  
  // Form team based on roles
  public func formTeamByRoles(
    agents : [Agent],
    requiredRoles : [AgentRole]
  ) : [Nat] {
    let selected = Buffer.Buffer<Nat>(requiredRoles.size());
    let usedAgents = Buffer.Buffer<Nat>(requiredRoles.size());
    
    for (role in requiredRoles.vals()) {
      // Find best available agent for this role
      var bestAgent : ?Nat = null;
      var bestScore : Float = 0.0;
      
      for (agent in agents.vals()) {
        if (agent.state.isAvailable and sameRole(agent.role, role)) {
          var alreadyUsed = false;
          for (usedId in usedAgents.vals()) {
            if (usedId == agent.id) { alreadyUsed := true };
          };
          
          if (not alreadyUsed) {
            let score = agent.metrics.reputationScore + agent.state.energy;
            if (score > bestScore) {
              bestScore := score;
              bestAgent := ?agent.id;
            };
          };
        };
      };
      
      switch (bestAgent) {
        case (?id) {
          selected.add(id);
          usedAgents.add(id);
        };
        case null {};
      };
    };
    
    Buffer.toArray(selected)
  };
  
  func sameRole(a : AgentRole, b : AgentRole) : Bool {
    switch (a, b) {
      case (#Researcher, #Researcher) { true };
      case (#Analyst, #Analyst) { true };
      case (#Strategist, #Strategist) { true };
      case (#Executor, #Executor) { true };
      case (#Communicator, #Communicator) { true };
      case (#Monitor, #Monitor) { true };
      case (#Coordinator, #Coordinator) { true };
      case (#Specialist, #Specialist) { true };
      case (#Generalist, #Generalist) { true };
      case (#Guardian, #Guardian) { true };
      case _ { false };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // TEAM DYNAMICS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  // Update team cohesion based on interactions
  public func updateTeamCohesion(
    team : Team,
    agents : [Agent]
  ) : Float {
    var totalAffinity : Float = 0.0;
    var pairCount : Nat = 0;
    
    // Calculate average relationship strength between members
    for (i in Iter.range(0, team.members.size() - 2)) {
      for (j in Iter.range(i + 1, team.members.size() - 1)) {
        let agentI = findAgent(agents, team.members[i]);
        let agentJ = findAgent(agents, team.members[j]);
        
        switch (agentI, agentJ) {
          case (?a, ?b) {
            // Find relationship between them
            for (rel in a.relationships.vals()) {
              if (rel.agentId == b.id) {
                totalAffinity += (rel.strength + 1.0) / 2.0;  // Normalize to [0, 1]
                pairCount += 1;
              };
            };
          };
          case _ {};
        };
      };
    };
    
    if (pairCount > 0) {
      totalAffinity / Float.fromInt(pairCount)
    } else {
      0.5  // Default cohesion for new teams
    }
  };
  
  func findAgent(agents : [Agent], id : Nat) : ?Agent {
    for (agent in agents.vals()) {
      if (agent.id == id) {
        return ?agent;
      };
    };
    null
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // COMPLETE TEAM STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type TeamState = {
    agents : [var Agent];
    teams : [Team];
    channels : [CommunicationChannel];
    messages : [Message];
    nextAgentId : Nat;
    nextTeamId : Nat;
    nextMessageId : Nat;
    totalAgentsCreated : Nat;
    totalTeamsFormed : Nat;
    lastTick : Int;
  };
  
  public func initTeamState() : TeamState {
    {
      agents = Array.init<Agent>(0, func(_ : Nat) : Agent {
        createAgent(0, "", #Generalist, 0)
      });
      teams = [];
      channels = [];
      messages = [];
      nextAgentId = 1;
      nextTeamId = 1;
      nextMessageId = 1;
      totalAgentsCreated = 0;
      totalTeamsFormed = 0;
      lastTick = 0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // TEAM TICK
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type TeamTickResult = {
    activeAgents : Nat;
    activeTeams : Nat;
    messagesSent : Nat;
    avgCohesion : Float;
    avgProductivity : Float;
  };
  
  public func teamTick(
    state : TeamState,
    currentBeat : Int
  ) : TeamTickResult {
    var activeAgents : Nat = 0;
    var activeTeams : Nat = 0;
    var totalCohesion : Float = 0.0;
    var totalProductivity : Float = 0.0;
    
    // Count active agents
    for (agent in state.agents.vals()) {
      if (agent.state.isActive) {
        activeAgents += 1;
      };
    };
    
    // Count active teams and compute metrics
    for (team in state.teams.vals()) {
      switch (team.status) {
        case (#Performing) {
          activeTeams += 1;
          totalCohesion += team.metrics.cohesion;
          totalProductivity += team.metrics.productivity;
        };
        case (#Norming) {
          activeTeams += 1;
          totalCohesion += team.metrics.cohesion * 0.8;
          totalProductivity += team.metrics.productivity * 0.7;
        };
        case _ {};
      };
    };
    
    {
      activeAgents = activeAgents;
      activeTeams = activeTeams;
      messagesSent = 0;  // Would count recent messages
      avgCohesion = if (activeTeams > 0) { totalCohesion / Float.fromInt(activeTeams) } else { 0.0 };
      avgProductivity = if (activeTeams > 0) { totalProductivity / Float.fromInt(activeTeams) } else { 0.0 };
    }
  };

}
