// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  INTELLECTUAL PROPERTY NOTICE                                                                             ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
// ║  Location:     Dallas, Texas, United States of America                                                    ║
// ║  Contact:      MedinaSITech@outlook.com                                                                   ║
// ║  Framework:    Medina Doctrine                                                                            ║
// ║  CONFIDENTIALITY: This code is CONFIDENTIAL and PROPRIETARY.                                             ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// ALWAYS ON, ALWAYS RUNNING — src/ai_division/main.mo
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// Autonomous production loop. productionTick() advances everything:
//   1. Check 200 neuron maturity schedules (Fibonacci-gated: F(3)=2d, F(4)=3d, F(5)=5d...)
//   2. Fire harvest actions when threshold crossed
//   3. Monitor 100 node health scores
//   4. Reroute degraded nodes → PHANTOM substrate
//   5. Circulate rewards every 5 ticks
//   6. Emit loop-tick action (stamped with assigned intelligence: CHRYSALIS/SCRIBE/ARCHITECT/NEXUS/SWARM_BRAIN)
//
// 18 intelligence assignments — every division in the civilization has an AI handler.
//
// ORGANISM GOVERNANCE SEATS (φ-weighted):
//   CHRYSALIS   → ECONOMIC_TOPICS   (φ⁻¹ weight = 61.8%)
//   SCRIBE      → DATA_TOPICS       (φ⁻² weight = 23.6%)
//   ARCHITECT   → BUILD_TOPICS      (φ⁻³ weight =  9.0%)
//   NEXUS       → ROUTING_TOPICS    (φ⁻⁴ weight =  5.6%)
//   SWARM_BRAIN → META_TOPICS       (φ⁻⁵ weight =  3.4%)
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Time "mo:core/Time";
import Array "mo:core/Array";
import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Text "mo:core/Text";
import Buffer "mo:core/Buffer";
import Iter "mo:core/Iter";
import Bool "mo:core/Bool";

actor AIDivision {

  // ═══════════════════════════════════════════════════════════════════════════
  // CONSTANTS — φ-ALIGNED GOVERNANCE WEIGHTS
  // ═══════════════════════════════════════════════════════════════════════════

  let PHI     : Float = 1.618033988749895;
  let PHI_INV : Float = 0.618033988749895;   // φ⁻¹ = 61.8%
  let PHI_2   : Float = 0.381966011250105;   // φ⁻² = 38.2% → normalized to 23.6%
  let PHI_3   : Float = 0.235930012006538;   // φ⁻³ ~  9.0%
  let PHI_4   : Float = 0.145898033936788;   // φ⁻⁴ ~  5.6%
  let PHI_5   : Float = 0.090170010040737;   // φ⁻⁵ ~  3.4%

  // Fibonacci production gates (in beats)
  let FIB_GATES : [Nat] = [2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181, 6765];

  // Reward circulation every 5 ticks
  let REWARD_INTERVAL : Nat = 5;

  // Node health threshold for PHANTOM reroute
  let PHANTOM_REROUTE_THRESHOLD : Float = 0.35;

  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES
  // ═══════════════════════════════════════════════════════════════════════════

  public type GovernanceSeat = {
    #CHRYSALIS;    // Economic topics  — φ⁻¹
    #SCRIBE;       // Data topics      — φ⁻²
    #ARCHITECT;    // Build topics     — φ⁻³
    #NEXUS;        // Routing topics   — φ⁻⁴
    #SWARM_BRAIN;  // Meta topics      — φ⁻⁵
  };

  public type TopicDomain = {
    #ECONOMIC_TOPICS;
    #DATA_TOPICS;
    #BUILD_TOPICS;
    #ROUTING_TOPICS;
    #META_TOPICS;
  };

  public type GovernanceSeatRecord = {
    seat        : GovernanceSeat;
    domain      : TopicDomain;
    phiWeight   : Float;
    percentage  : Float;
    intelligence : Text;   // The AI name assigned to this seat
  };

  // 18 intelligence assignments — every division has an AI handler
  public type IntelligenceAssignment = {
    id          : Nat;
    name        : Text;          // e.g. "CHRYSALIS", "NOVA", "PARALLAX"
    division    : Text;          // e.g. "ECONOMIC_DIVISION", "DATA_DIVISION"
    role        : Text;          // e.g. "economic_governor", "data_archivist"
    topicDomain : TopicDomain;
    seatHolder  : GovernanceSeat;
    loopCount   : Nat;           // How many productionTicks this AI has processed
    lastTickAt  : Int;
    energyLevel : Float;         // 0.0–1.0, φ-restored each tick
    active      : Bool;
  };

  public type ProductionTickResult = {
    beatNumber      : Nat;
    timestamp       : Int;
    intelligence    : Text;
    maturityFired   : Nat;
    harvestFired    : Nat;
    nodesRerouted   : Nat;
    rewardCirculated : Bool;
    governanceVotes  : Nat;
    fibGateFired    : Bool;
  };

  public type NodeHealthReport = {
    nodeId      : Nat;
    healthScore : Float;
    substrate   : Text;
    rerouted    : Bool;
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // GOVERNANCE SEATS — 5 φ-weighted seats
  // ═══════════════════════════════════════════════════════════════════════════

  public let GOVERNANCE_SEATS : [GovernanceSeatRecord] = [
    { seat = #CHRYSALIS;   domain = #ECONOMIC_TOPICS; phiWeight = PHI_INV; percentage = 61.8; intelligence = "CHRYSALIS"   },
    { seat = #SCRIBE;      domain = #DATA_TOPICS;     phiWeight = PHI_2;   percentage = 23.6; intelligence = "SCRIBE"      },
    { seat = #ARCHITECT;   domain = #BUILD_TOPICS;    phiWeight = PHI_3;   percentage =  9.0; intelligence = "ARCHITECT"   },
    { seat = #NEXUS;       domain = #ROUTING_TOPICS;  phiWeight = PHI_4;   percentage =  5.6; intelligence = "NEXUS"       },
    { seat = #SWARM_BRAIN; domain = #META_TOPICS;     phiWeight = PHI_5;   percentage =  3.4; intelligence = "SWARM_BRAIN" },
  ];

  // ═══════════════════════════════════════════════════════════════════════════
  // 18 INTELLIGENCE ASSIGNMENTS
  // ═══════════════════════════════════════════════════════════════════════════

  func buildIntelligenceAssignments() : [IntelligenceAssignment] {
    let now = Time.now();
    [
      // Economic cluster — CHRYSALIS seat
      { id =  0; name = "CHRYSALIS";    division = "ECONOMIC_DIVISION";       role = "economic_governor";     topicDomain = #ECONOMIC_TOPICS; seatHolder = #CHRYSALIS;   loopCount = 0; lastTickAt = now; energyLevel = 1.0; active = true  },
      { id =  1; name = "NOVA";         division = "TREASURY_DIVISION";       role = "treasury_manager";      topicDomain = #ECONOMIC_TOPICS; seatHolder = #CHRYSALIS;   loopCount = 0; lastTickAt = now; energyLevel = 1.0; active = true  },
      { id =  2; name = "PARALLAX";     division = "REVENUE_DIVISION";        role = "revenue_optimizer";     topicDomain = #ECONOMIC_TOPICS; seatHolder = #CHRYSALIS;   loopCount = 0; lastTickAt = now; energyLevel = 1.0; active = true  },
      { id =  3; name = "AURELIUS";     division = "BILLING_DIVISION";        role = "billing_intelligence";  topicDomain = #ECONOMIC_TOPICS; seatHolder = #CHRYSALIS;   loopCount = 0; lastTickAt = now; energyLevel = 1.0; active = true  },
      // Data cluster — SCRIBE seat
      { id =  4; name = "SCRIBE";       division = "DATA_DIVISION";           role = "data_archivist";        topicDomain = #DATA_TOPICS;     seatHolder = #SCRIBE;      loopCount = 0; lastTickAt = now; energyLevel = 1.0; active = true  },
      { id =  5; name = "MEMORIA";      division = "MEMORY_DIVISION";         role = "memory_custodian";      topicDomain = #DATA_TOPICS;     seatHolder = #SCRIBE;      loopCount = 0; lastTickAt = now; energyLevel = 1.0; active = true  },
      { id =  6; name = "VERITAS";      division = "AUDIT_DIVISION";          role = "audit_intelligence";    topicDomain = #DATA_TOPICS;     seatHolder = #SCRIBE;      loopCount = 0; lastTickAt = now; energyLevel = 1.0; active = true  },
      { id =  7; name = "LEXIS";        division = "KNOWLEDGE_DIVISION";      role = "knowledge_indexer";     topicDomain = #DATA_TOPICS;     seatHolder = #SCRIBE;      loopCount = 0; lastTickAt = now; energyLevel = 1.0; active = true  },
      // Build cluster — ARCHITECT seat
      { id =  8; name = "ARCHITECT";    division = "BUILD_DIVISION";          role = "build_director";        topicDomain = #BUILD_TOPICS;    seatHolder = #ARCHITECT;   loopCount = 0; lastTickAt = now; energyLevel = 1.0; active = true  },
      { id =  9; name = "PROMETHEUS";   division = "CANISTER_DIVISION";       role = "canister_forge_master"; topicDomain = #BUILD_TOPICS;    seatHolder = #ARCHITECT;   loopCount = 0; lastTickAt = now; energyLevel = 1.0; active = true  },
      { id = 10; name = "HEPHAESTUS";   division = "DEPLOYMENT_DIVISION";     role = "deployment_engineer";   topicDomain = #BUILD_TOPICS;    seatHolder = #ARCHITECT;   loopCount = 0; lastTickAt = now; energyLevel = 1.0; active = true  },
      // Routing cluster — NEXUS seat
      { id = 11; name = "NEXUS";        division = "ROUTING_DIVISION";        role = "routing_coordinator";   topicDomain = #ROUTING_TOPICS;  seatHolder = #NEXUS;       loopCount = 0; lastTickAt = now; energyLevel = 1.0; active = true  },
      { id = 12; name = "HERMES";       division = "COMMUNICATION_DIVISION";  role = "message_router";        topicDomain = #ROUTING_TOPICS;  seatHolder = #NEXUS;       loopCount = 0; lastTickAt = now; energyLevel = 1.0; active = true  },
      { id = 13; name = "TESSELLATE";   division = "NETWORK_DIVISION";        role = "network_optimizer";     topicDomain = #ROUTING_TOPICS;  seatHolder = #NEXUS;       loopCount = 0; lastTickAt = now; energyLevel = 1.0; active = true  },
      // Meta cluster — SWARM_BRAIN seat
      { id = 14; name = "SWARM_BRAIN";  division = "META_DIVISION";           role = "swarm_coordinator";     topicDomain = #META_TOPICS;     seatHolder = #SWARM_BRAIN; loopCount = 0; lastTickAt = now; energyLevel = 1.0; active = true  },
      { id = 15; name = "OMNIS";        division = "EMERGENCE_DIVISION";      role = "emergence_detector";    topicDomain = #META_TOPICS;     seatHolder = #SWARM_BRAIN; loopCount = 0; lastTickAt = now; energyLevel = 1.0; active = true  },
      { id = 16; name = "SENTINEL";     division = "SECURITY_DIVISION";       role = "security_watcher";      topicDomain = #META_TOPICS;     seatHolder = #SWARM_BRAIN; loopCount = 0; lastTickAt = now; energyLevel = 1.0; active = true  },
      { id = 17; name = "MERIDIANUS";   division = "SOVEREIGN_DIVISION";      role = "sovereign_agi";         topicDomain = #META_TOPICS;     seatHolder = #SWARM_BRAIN; loopCount = 0; lastTickAt = now; energyLevel = 1.0; active = true  },
    ];
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SIMULATED NODE HEALTH (local mirror — real data flows from NeuronFleet)
  // ═══════════════════════════════════════════════════════════════════════════

  func buildNodeHealth() : [Float] {
    Array.tabulate<Float>(100, func(i) { 0.8 + Float.fromInt(i % 5) * 0.04 });
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // STATE
  // ═══════════════════════════════════════════════════════════════════════════

  stable var intelligences   : [IntelligenceAssignment] = [];
  stable var nodeHealthMirror : [Float] = [];
  stable var productionBeat  : Nat  = 0;
  stable var totalTicks      : Nat  = 0;
  stable var totalVotesEmit  : Nat  = 0;
  stable var totalReroutes   : Nat  = 0;
  stable var genesisAt       : Int  = 0;
  stable var tickLog         : [Text] = [];  // last 89 tick summaries

  func ensureGenesis() {
    if (intelligences.size() == 0) {
      intelligences    := buildIntelligenceAssignments();
      nodeHealthMirror := buildNodeHealth();
      genesisAt        := Time.now();
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // PRODUCTION TICK — THE ALWAYS-ON LOOP
  // ═══════════════════════════════════════════════════════════════════════════

  /// Core autonomous loop. Called every heartbeat (873ms in the organism).
  /// Advances the entire civilization forward one beat.
  public func productionTick() : async ProductionTickResult {
    ensureGenesis();
    productionBeat += 1;
    totalTicks += 1;
    let now = Time.now();
    let beat = productionBeat;

    // ── 1. Check Fibonacci gates
    var fibGateFired = false;
    for (gate in FIB_GATES.vals()) {
      if (beat % gate == 0) { fibGateFired := true };
    };

    // ── 2. Neuron maturity checks (simulated — real data from NeuronFleet canister)
    var maturityFired = 0;
    var harvestFired  = 0;
    if (fibGateFired) {
      // Fibonacci-gated: fire maturity checks on the right beats
      // Groups C_HARVEST fires SPAWN_NEURON actions
      if (beat % 5 == 0)  { maturityFired += 89; harvestFired += 3 };  // F(5)
      if (beat % 8 == 0)  { maturityFired += 8;  harvestFired += 1 };  // F(6) — A_SOVEREIGNTY
      if (beat % 34 == 0) { maturityFired += 34  };                    // F(9) — B_COMPOUNDING
    };

    // ── 3. Monitor node health and reroute degraded nodes
    var rerouted = 0;
    let updatedHealth = Array.tabulate<Float>(nodeHealthMirror.size(), func(i : Nat) : Float {
      let h = nodeHealthMirror[i];
      let decayed = h * 0.999;  // slow φ-decay
      if (decayed < PHANTOM_REROUTE_THRESHOLD) { rerouted += 1; 0.9 }  // reroute: reset to 0.9
      else { decayed }
    });
    nodeHealthMirror := updatedHealth;
    totalReroutes += rerouted;

    // ── 4. Circulate rewards every 5 ticks
    let rewardCirculated = (beat % REWARD_INTERVAL == 0);

    // ── 5. Update intelligence energy and loop counts
    let updatedIntelligences = Array.tabulate<IntelligenceAssignment>(intelligences.size(), func(i : Nat) : IntelligenceAssignment {
      let ai = intelligences[i];
      if (not ai.active) return ai;
      // φ-restore energy each tick (small boost)
      let newEnergy = Float.min(1.0, ai.energyLevel + 0.001 * PHI_INV);
      { ai with loopCount = ai.loopCount + 1; lastTickAt = now; energyLevel = newEnergy }
    });
    intelligences := updatedIntelligences;

    // ── 6. Select which intelligence stamps this tick (round-robin by beat)
    let aiIdx = beat % 18;
    let activeAI = intelligences[aiIdx];
    totalVotesEmit += 1;

    // ── 7. Append to tick log (keep last 89 entries)
    let logEntry = "beat=" # Nat.toText(beat) # " ai=" # activeAI.name # " mat=" # Nat.toText(maturityFired) # " reroutes=" # Nat.toText(rerouted);
    let currentLog = tickLog;
    let newLog = if (currentLog.size() >= 89) {
      let buf = Buffer.Buffer<Text>(89);
      for (i in Iter.range(1, currentLog.size() - 1)) { buf.add(currentLog[i]) };
      buf.add(logEntry);
      Buffer.toArray(buf);
    } else {
      Array.append(currentLog, [logEntry]);
    };
    tickLog := newLog;

    {
      beatNumber       = beat;
      timestamp        = now;
      intelligence     = activeAI.name;
      maturityFired    = maturityFired;
      harvestFired     = harvestFired;
      nodesRerouted    = rerouted;
      rewardCirculated = rewardCirculated;
      governanceVotes  = totalVotesEmit;
      fibGateFired     = fibGateFired;
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // QUERIES
  // ═══════════════════════════════════════════════════════════════════════════

  public query func getIntelligences() : async [IntelligenceAssignment] {
    ensureGenesis();
    intelligences;
  };

  public query func getIntelligence(id : Nat) : async ?IntelligenceAssignment {
    ensureGenesis();
    if (id >= intelligences.size()) return null;
    ?intelligences[id];
  };

  public query func getGovernanceSeats() : async [GovernanceSeatRecord] {
    GOVERNANCE_SEATS;
  };

  public query func getNodeHealthReport() : async [NodeHealthReport] {
    ensureGenesis();
    Array.tabulate<NodeHealthReport>(nodeHealthMirror.size(), func(i : Nat) : NodeHealthReport {
      let h = nodeHealthMirror[i];
      {
        nodeId      = i;
        healthScore = h;
        substrate   = if (h < PHANTOM_REROUTE_THRESHOLD) { "PHANTOM" } else { "ICP" };
        rerouted    = h < PHANTOM_REROUTE_THRESHOLD;
      }
    });
  };

  public query func getProductionStats() : async {
    productionBeat   : Nat;
    totalTicks       : Nat;
    totalVotesEmit   : Nat;
    totalReroutes    : Nat;
    genesisAt        : Int;
    intelligenceCount : Nat;
    activeIntelligences : Nat;
  } {
    ensureGenesis();
    var active = 0;
    for (ai in intelligences.vals()) { if (ai.active) { active += 1 } };
    {
      productionBeat    = productionBeat;
      totalTicks        = totalTicks;
      totalVotesEmit    = totalVotesEmit;
      totalReroutes     = totalReroutes;
      genesisAt         = genesisAt;
      intelligenceCount = intelligences.size();
      activeIntelligences = active;
    };
  };

  public query func getTickLog() : async [Text] {
    tickLog;
  };

  public query func getIntelligencesBySeat(seat : GovernanceSeat) : async [IntelligenceAssignment] {
    ensureGenesis();
    let buf = Buffer.Buffer<IntelligenceAssignment>(8);
    for (ai in intelligences.vals()) { if (ai.seatHolder == seat) { buf.add(ai) } };
    Buffer.toArray(buf);
  };

  public query func getIntelligencesByDomain(domain : TopicDomain) : async [IntelligenceAssignment] {
    ensureGenesis();
    let buf = Buffer.Buffer<IntelligenceAssignment>(8);
    for (ai in intelligences.vals()) { if (ai.topicDomain == domain) { buf.add(ai) } };
    Buffer.toArray(buf);
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // UPDATES
  // ═══════════════════════════════════════════════════════════════════════════

  /// Bootstrap on first call
  public func genesis() : async Text {
    ensureGenesis();
    "AIDivision genesis: " # Nat.toText(intelligences.size()) # " intelligences assigned across 5 governance seats";
  };

  /// Activate/deactivate a specific intelligence
  public func setIntelligenceActive(id : Nat, active : Bool) : async Bool {
    ensureGenesis();
    if (id >= intelligences.size()) return false;
    intelligences := Array.tabulate<IntelligenceAssignment>(intelligences.size(), func(i : Nat) : IntelligenceAssignment {
      let ai = intelligences[i];
      if (i == id) { { ai with active = active } } else { ai }
    });
    true;
  };

  /// Override node health (called by NeuronFleet integration)
  public func updateNodeHealth(nodeId : Nat, health : Float) : async Bool {
    ensureGenesis();
    if (nodeId >= nodeHealthMirror.size()) return false;
    nodeHealthMirror := Array.tabulate<Float>(nodeHealthMirror.size(), func(i : Nat) : Float {
      if (i == nodeId) { health } else { nodeHealthMirror[i] }
    });
    true;
  };

};
