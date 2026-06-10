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

module NexumConnectiveTissue {

  // ═══════════════════════════════════════════════════════════════════════════════
  // CONNECTION — A link between two substrates
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type Connection = {
    connectionId : Nat;
    sourceSubstrate : Text;
    targetSubstrate : Text;
    
    // Connection properties
    connectionType : ConnectionType;
    direction : ConnectionDirection;
    
    // Strength
    weight : Float;               // 0-1 connection strength
    baseWeight : Float;           // Resting weight
    plasticity : Float;           // How easily weight changes
    
    // Activity
    messagesTransmitted : Nat;
    lastActivityBeat : Int;
    utilizationRate : Float;
    
    // Bandwidth
    bandwidth : Float;            // Max messages per beat
    currentLoad : Float;
    congested : Bool;
    
    // Latency
    latencyBeats : Float;
    jitter : Float;
    
    // Health
    connectionHealthy : Bool;
    errorRate : Float;
    lastErrorBeat : Int;
  };

  public type ConnectionType = {
    #Excitatory;      // Increases target activity
    #Inhibitory;      // Decreases target activity
    #Modulatory;      // Changes target's response properties
    #Bidirectional;   // Both directions
    #Broadcast;       // One-to-many
    #Convergent;      // Many-to-one
  };

  public type ConnectionDirection = {
    #Feedforward;     // Lower to higher
    #Feedback;        // Higher to lower
    #Lateral;         // Same level
    #Skip;            // Skip levels
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // MESSAGE — Information transmitted through connections
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type Message = {
    messageId : Nat;
    sourceSubstrate : Text;
    targetSubstrate : Text;
    
    // Content
    messageType : MessageType;
    payload : [Float];            // Numerical payload
    metadata : Text;
    
    // Priority
    priority : MessagePriority;
    urgency : Float;
    
    // Timing
    createdAt : Int;
    sentAt : ?Int;
    receivedAt : ?Int;
    processedAt : ?Int;
    
    // Status
    status : MessageStatus;
    retries : Nat;
    maxRetries : Nat;
    
    // Routing
    path : [Text];                // Substrates traversed
    hops : Nat;
  };

  public type MessageType = {
    #Signal;          // Simple activation signal
    #Gradient;        // Gradient information
    #Phase;           // Phase synchronization
    #Error;           // Prediction error
    #Control;         // Control command
    #Query;           // Request for information
    #Response;        // Response to query
    #Broadcast;       // System-wide announcement
  };

  public type MessagePriority = {
    #Critical;        // Immediate processing required
    #High;            // Prioritized
    #Normal;          // Standard
    #Low;             // Background
    #Deferred;        // Can wait
  };

  public type MessageStatus = {
    #Queued;
    #InTransit;
    #Delivered;
    #Processed;
    #Failed;
    #Expired;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ROUTING — How messages find their paths
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type RoutingTable = {
    routes : [Route];
    lastUpdateBeat : Int;
    
    // Routing metrics
    totalRoutes : Nat;
    activeRoutes : Nat;
    failedRoutes : Nat;
    
    // Optimization
    routeOptimizations : Nat;
    averagePathLength : Float;
  };

  public type Route = {
    routeId : Nat;
    source : Text;
    destination : Text;
    path : [Text];
    
    // Route quality
    cost : Float;
    reliability : Float;
    latency : Float;
    
    // Usage
    usageCount : Nat;
    lastUsedBeat : Int;
    
    // Alternatives
    alternativeRoutes : [Nat];
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // BANDWIDTH ALLOCATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type BandwidthState = {
    // Total system bandwidth
    totalBandwidth : Float;
    allocatedBandwidth : Float;
    availableBandwidth : Float;
    
    // Per-substrate allocation
    allocations : [SubstrateBandwidth];
    
    // Congestion management
    congestionLevel : Float;
    congestionThreshold : Float;
    congestionActive : Bool;
    
    // Quality of service
    guaranteedBandwidth : Float;
    bestEffortBandwidth : Float;
    
    // History
    peakBandwidth : Float;
    peakBandwidthBeat : Int;
  };

  public type SubstrateBandwidth = {
    substrate : Text;
    allocated : Float;
    used : Float;
    reserved : Float;
    priority : Nat;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // NETWORK TOPOLOGY
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type NetworkTopology = {
    // Nodes
    nodes : [TopologyNode];
    totalNodes : Nat;
    
    // Edges
    edges : [TopologyEdge];
    totalEdges : Nat;
    
    // Topology metrics
    averageDegree : Float;        // Average connections per node
    clusteringCoefficient : Float;
    pathLength : Float;           // Average shortest path
    diameter : Nat;               // Longest shortest path
    
    // Small-world properties
    smallWorldIndex : Float;
    
    // Hubs
    hubs : [Text];                // High-degree nodes
    bottlenecks : [Text];         // Critical path nodes
    
    // Modularity
    modules : [[Text]];           // Clusters of substrates
    modularity : Float;
  };

  public type TopologyNode = {
    nodeId : Nat;
    substrate : Text;
    
    // Degree
    inDegree : Nat;
    outDegree : Nat;
    totalDegree : Nat;
    
    // Centrality
    betweennessCentrality : Float;
    closenessCentrality : Float;
    eigenvectorCentrality : Float;
    
    // Activity
    messagesSent : Nat;
    messagesReceived : Nat;
    
    // Status
    active : Bool;
    lastActivityBeat : Int;
  };

  public type TopologyEdge = {
    edgeId : Nat;
    sourceNode : Nat;
    targetNode : Nat;
    
    // Properties
    weight : Float;
    capacity : Float;
    
    // Usage
    utilization : Float;
    messagesTransmitted : Nat;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // MESSAGE QUEUES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type MessageQueue = {
    queueId : Nat;
    substrate : Text;
    
    // Queue state
    messages : [Message];
    queueLength : Nat;
    maxLength : Nat;
    
    // Priority queues
    criticalQueue : [Message];
    normalQueue : [Message];
    deferredQueue : [Message];
    
    // Processing
    processedCount : Nat;
    droppedCount : Nat;
    processingRate : Float;
    
    // Waiting time
    averageWaitTime : Float;
    maxWaitTime : Float;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // CROSS-SUBSTRATE COHERENCE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type CrossSubstrateCoherence = {
    // Pairwise coherence
    coherenceMatrix : [[Float]];  // substrate × substrate
    substrateOrder : [Text];      // Order of substrates in matrix
    
    // Global coherence
    globalCoherence : Float;
    coherenceVariance : Float;
    
    // Coherence clusters
    coherentClusters : [[Text]];
    clusterCoherences : [Float];
    
    // Desynchronization
    desyncDetected : Bool;
    desyncSubstrates : [Text];
    lastDesyncBeat : Int;
    
    // Binding
    bindingStrength : Float;
    bindingScope : Nat;           // How many substrates are bound
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SIGNAL PROPAGATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type SignalPropagation = {
    // Propagation waves
    activeWaves : [PropagationWave];
    completedWaves : Nat;
    
    // Speed
    propagationSpeed : Float;
    speedVariance : Float;
    
    // Attenuation
    attenuationRate : Float;
    minSignalStrength : Float;
    
    // Amplification
    amplificationNodes : [Text];
    amplificationFactor : Float;
    
    // Interference
    constructiveInterference : Nat;
    destructiveInterference : Nat;
  };

  public type PropagationWave = {
    waveId : Nat;
    origin : Text;
    
    // Wave state
    currentSubstrates : [Text];
    visitedSubstrates : [Text];
    
    // Signal
    signalStrength : Float;
    signalContent : [Float];
    
    // Timing
    startedAt : Int;
    currentBeat : Int;
    
    // Properties
    waveType : Text;
    decaying : Bool;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // CONNECTION PLASTICITY
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type ConnectionPlasticity = {
    // Hebbian learning
    hebbianActive : Bool;
    hebbianRate : Float;
    
    // Anti-Hebbian
    antiHebbianActive : Bool;
    antiHebbianRate : Float;
    
    // Homeostatic
    homeostaticActive : Bool;
    targetActivity : Float;
    scalingRate : Float;
    
    // Structural plasticity
    newConnectionsFormed : Nat;
    connectionsPruned : Nat;
    
    // Weight statistics
    averageWeight : Float;
    weightVariance : Float;
    maxWeight : Float;
    minWeight : Float;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // COMBINED NEXUM STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type FullNexumState = {
    // Connections
    connections : [Connection];
    totalConnections : Nat;
    activeConnections : Nat;
    
    // Messages
    messageQueues : [MessageQueue];
    messagesInFlight : Nat;
    
    // Routing
    routing : RoutingTable;
    
    // Bandwidth
    bandwidth : BandwidthState;
    
    // Topology
    topology : NetworkTopology;
    
    // Coherence
    coherence : CrossSubstrateCoherence;
    
    // Propagation
    propagation : SignalPropagation;
    
    // Plasticity
    plasticity : ConnectionPlasticity;
    
    // Global state
    nexumHealthy : Bool;
    lastProcessedBeat : Int;
    processingCycles : Nat;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func initConnection(
    id : Nat,
    source : Text,
    target : Text,
    connType : ConnectionType
  ) : Connection {
    {
      connectionId = id;
      sourceSubstrate = source;
      targetSubstrate = target;
      connectionType = connType;
      direction = #Feedforward;
      weight = 0.5;
      baseWeight = 0.5;
      plasticity = 0.1;
      messagesTransmitted = 0;
      lastActivityBeat = 0;
      utilizationRate = 0.0;
      bandwidth = 10.0;
      currentLoad = 0.0;
      congested = false;
      latencyBeats = 1.0;
      jitter = 0.1;
      connectionHealthy = true;
      errorRate = 0.0;
      lastErrorBeat = 0;
    };
  };

  public func initRoutingTable() : RoutingTable {
    {
      routes = [];
      lastUpdateBeat = 0;
      totalRoutes = 0;
      activeRoutes = 0;
      failedRoutes = 0;
      routeOptimizations = 0;
      averagePathLength = 0.0;
    };
  };

  public func initBandwidth() : BandwidthState {
    {
      totalBandwidth = 1000.0;
      allocatedBandwidth = 0.0;
      availableBandwidth = 1000.0;
      allocations = [];
      congestionLevel = 0.0;
      congestionThreshold = 0.8;
      congestionActive = false;
      guaranteedBandwidth = 500.0;
      bestEffortBandwidth = 500.0;
      peakBandwidth = 0.0;
      peakBandwidthBeat = 0;
    };
  };

  public func initTopology() : NetworkTopology {
    {
      nodes = [];
      totalNodes = 0;
      edges = [];
      totalEdges = 0;
      averageDegree = 0.0;
      clusteringCoefficient = 0.0;
      pathLength = 0.0;
      diameter = 0;
      smallWorldIndex = 0.0;
      hubs = [];
      bottlenecks = [];
      modules = [];
      modularity = 0.0;
    };
  };

  public func initCoherence() : CrossSubstrateCoherence {
    {
      coherenceMatrix = [];
      substrateOrder = [];
      globalCoherence = 1.0;
      coherenceVariance = 0.0;
      coherentClusters = [];
      clusterCoherences = [];
      desyncDetected = false;
      desyncSubstrates = [];
      lastDesyncBeat = 0;
      bindingStrength = 0.8;
      bindingScope = 0;
    };
  };

  public func initPropagation() : SignalPropagation {
    {
      activeWaves = [];
      completedWaves = 0;
      propagationSpeed = 1.0;
      speedVariance = 0.1;
      attenuationRate = 0.1;
      minSignalStrength = 0.1;
      amplificationNodes = [];
      amplificationFactor = 1.5;
      constructiveInterference = 0;
      destructiveInterference = 0;
    };
  };

  public func initPlasticity() : ConnectionPlasticity {
    {
      hebbianActive = true;
      hebbianRate = 0.01;
      antiHebbianActive = false;
      antiHebbianRate = 0.005;
      homeostaticActive = true;
      targetActivity = 0.1;
      scalingRate = 0.001;
      newConnectionsFormed = 0;
      connectionsPruned = 0;
      averageWeight = 0.5;
      weightVariance = 0.0;
      maxWeight = 1.0;
      minWeight = 0.0;
    };
  };

  public func initFullNexumState() : FullNexumState {
    {
      connections = [];
      totalConnections = 0;
      activeConnections = 0;
      messageQueues = [];
      messagesInFlight = 0;
      routing = initRoutingTable();
      bandwidth = initBandwidth();
      topology = initTopology();
      coherence = initCoherence();
      propagation = initPropagation();
      plasticity = initPlasticity();
      nexumHealthy = true;
      lastProcessedBeat = 0;
      processingCycles = 0;
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // PROCESSING FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  // Update connection weight (Hebbian)
  public func hebbianUpdate(
    connection : Connection,
    sourceActivity : Float,
    targetActivity : Float,
    learningRate : Float
  ) : Connection {
    let delta = learningRate * sourceActivity * targetActivity;
    let newWeight = Float.min(1.0, Float.max(0.0, connection.weight + delta));
    
    {
      connectionId = connection.connectionId;
      sourceSubstrate = connection.sourceSubstrate;
      targetSubstrate = connection.targetSubstrate;
      connectionType = connection.connectionType;
      direction = connection.direction;
      weight = newWeight;
      baseWeight = connection.baseWeight;
      plasticity = connection.plasticity;
      messagesTransmitted = connection.messagesTransmitted;
      lastActivityBeat = connection.lastActivityBeat;
      utilizationRate = connection.utilizationRate;
      bandwidth = connection.bandwidth;
      currentLoad = connection.currentLoad;
      congested = connection.congested;
      latencyBeats = connection.latencyBeats;
      jitter = connection.jitter;
      connectionHealthy = connection.connectionHealthy;
      errorRate = connection.errorRate;
      lastErrorBeat = connection.lastErrorBeat;
    };
  };

  // Route a message
  public func routeMessage(
    routing : RoutingTable,
    source : Text,
    destination : Text
  ) : ?[Text] {
    // Find route
    for (route in routing.routes.vals()) {
      if (route.source == source and route.destination == destination) {
        return ?route.path;
      };
    };
    null;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // DIAGNOSTICS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func getNexumDiagnostics(state : FullNexumState) : Text {
    "═══ NEXUM CONNECTIVE TISSUE DIAGNOSTICS ═══\n" #
    "Processing Cycles: " # Nat.toText(state.processingCycles) # "\n" #
    "Nexum Healthy: " # (if (state.nexumHealthy) "YES" else "NO") # "\n\n" #
    
    "CONNECTIONS:\n" #
    "  Total: " # Nat.toText(state.totalConnections) # "\n" #
    "  Active: " # Nat.toText(state.activeConnections) # "\n\n" #
    
    "BANDWIDTH:\n" #
    "  Total: " # Float.toText(state.bandwidth.totalBandwidth) # "\n" #
    "  Available: " # Float.toText(state.bandwidth.availableBandwidth) # "\n" #
    "  Congestion: " # Float.toText(state.bandwidth.congestionLevel * 100.0) # "%\n\n" #
    
    "TOPOLOGY:\n" #
    "  Nodes: " # Nat.toText(state.topology.totalNodes) # "\n" #
    "  Edges: " # Nat.toText(state.topology.totalEdges) # "\n" #
    "  Clustering: " # Float.toText(state.topology.clusteringCoefficient) # "\n" #
    "  Small-World: " # Float.toText(state.topology.smallWorldIndex) # "\n\n" #
    
    "COHERENCE:\n" #
    "  Global: " # Float.toText(state.coherence.globalCoherence) # "\n" #
    "  Binding: " # Float.toText(state.coherence.bindingStrength) # "\n" #
    "  Desync: " # (if (state.coherence.desyncDetected) "DETECTED" else "NONE") # "\n\n" #
    
    "PLASTICITY:\n" #
    "  Hebbian: " # (if (state.plasticity.hebbianActive) "ACTIVE" else "OFF") # "\n" #
    "  New Connections: " # Nat.toText(state.plasticity.newConnectionsFormed) # "\n" #
    "  Pruned: " # Nat.toText(state.plasticity.connectionsPruned) # "\n" #
    "═══════════════════════════════════════\n";
  };

};
