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
import Nat64 "mo:core/Nat64";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Iter "mo:core/Iter";
import Text "mo:core/Text";
import Time "mo:core/Time";
import Principal "mo:core/Principal";

module CouncilSubstrate {

  // ═══════════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let PI : Float = 3.14159265358979323846;
  public let TWO_PI : Float = 6.28318530717958647692;
  public let E : Float = 2.71828182845904523536;
  
  // Super-scale dimensions (per council member)
  public let COUNCIL_NODE_COUNT : Nat = 512;
  public let COUNCIL_WEIGHT_COUNT : Nat = 262144;  // 512 × 512
  
  // Council parameters
  public let COUNCIL_SIZE : Nat = 7;
  public let CONSENSUS_THRESHOLD : Float = 0.71;   // 5/7 majority
  public let VETO_THRESHOLD : Float = 0.43;        // 3/7 can block
  public let QUORUM_REQUIRED : Nat = 5;            // Minimum for decisions

  // ═══════════════════════════════════════════════════════════════════════════════
  // COUNCIL MEMBER ROLE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type CouncilRole = {
    #LEXIS;         // Language/Communication
    #FORGE;         // Creation/Building
    #SOMA;          // Body/Interoception
    #LUMEN;         // Learning/Adaptation
    #MEMORIA;       // Memory/Continuity
    #AEGIS;         // Security/Defense
    #AXIS;          // Pattern/Prediction
  };
  
  public type RoleConfig = {
    role : CouncilRole;
    name : Text;
    description : Text;
    baseVotingWeight : Float;
    specializations : [Text];
    frequencyRange : (Float, Float);
    coherenceTarget : Float;
  };
  
  public let ROLE_CONFIGS : [RoleConfig] = [
    {
      role = #LEXIS;
      name = "LEXIS";
      description = "Language processing, communication, doctrine translation";
      baseVotingWeight = 0.20;
      specializations = ["Language", "Communication", "Translation", "Doctrine"];
      frequencyRange = (8.0, 13.0);  // Alpha band
      coherenceTarget = 0.85;
    },
    {
      role = #FORGE;
      name = "FORGE";
      description = "Creation, building, synthesis, innovation";
      baseVotingWeight = 0.15;
      specializations = ["Creation", "Synthesis", "Innovation", "Construction"];
      frequencyRange = (13.0, 30.0);  // Beta band
      coherenceTarget = 0.80;
    },
    {
      role = #SOMA;
      name = "SOMA";
      description = "Body awareness, interoception, health monitoring";
      baseVotingWeight = 0.10;
      specializations = ["Interoception", "Health", "Energy", "Homeostasis"];
      frequencyRange = (1.0, 4.0);  // Delta band
      coherenceTarget = 0.90;
    },
    {
      role = #LUMEN;
      name = "LUMEN";
      description = "Learning, adaptation, knowledge integration";
      baseVotingWeight = 0.15;
      specializations = ["Learning", "Adaptation", "Integration", "Growth"];
      frequencyRange = (4.0, 8.0);  // Theta band
      coherenceTarget = 0.82;
    },
    {
      role = #MEMORIA;
      name = "MEMORIA";
      description = "Memory consolidation, continuity, identity preservation";
      baseVotingWeight = 0.15;
      specializations = ["Memory", "Continuity", "Identity", "History"];
      frequencyRange = (0.5, 4.0);  // Delta/Slow
      coherenceTarget = 0.88;
    },
    {
      role = #AEGIS;
      name = "AEGIS";
      description = "Security, threat detection, defense, protection";
      baseVotingWeight = 0.15;
      specializations = ["Security", "Threat", "Defense", "Protection"];
      frequencyRange = (30.0, 100.0);  // Gamma band (fast response)
      coherenceTarget = 0.85;
    },
    {
      role = #AXIS;
      name = "AXIS";
      description = "Pattern recognition, prediction, analysis";
      baseVotingWeight = 0.10;
      specializations = ["Pattern", "Prediction", "Analysis", "Detection"];
      frequencyRange = (8.0, 30.0);  // Alpha/Beta
      coherenceTarget = 0.83;
    },
  ];

  // ═══════════════════════════════════════════════════════════════════════════════
  // COUNCIL MEMBER — Individual sovereign organism
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type CouncilMember = {
    id : Nat8;
    config : RoleConfig;
    substrate : MemberSubstrate;
    economics : MemberEconomics;
    voting : MemberVoting;
    health : MemberHealth;
    relationships : MemberRelationships;
    lastActivity : Int;
  };
  
  public type MemberSubstrate = {
    nodes : [var MemberNode];
    weights : MemberWeightMatrix;
    coherence : Float;
    kuramotoR : Float;
    heartbeat : Int;
    totalActivations : Nat;
    firingRate : Float;
    temperature : Float;
  };
  
  public type MemberNode = {
    id : Nat16;
    frequency : Float;
    phase : Float;
    amplitude : Float;
    activation : Float;
    threshold : Float;
    refractory : Nat8;
  };
  
  public type MemberWeightMatrix = {
    // Sparse block representation: 64 blocks of 4,096 weights
    blocks : [[var Float]];
    eligibility : [[var Float]];
    lastUpdate : Int;
    ltpTotal : Nat;
    ltdTotal : Nat;
  };
  
  public type MemberEconomics = {
    formaBalance : Float;         // Metabolic fuel
    mrcBalance : Float;           // Dynasty coin
    formaIncome : Float;          // FORMA per beat
    mrcIncome : Float;            // MRC per beat
    formaSpent : Float;           // Total FORMA consumed
    mrcStaked : Float;            // MRC committed to votes
    yield : Float;                // Current yield rate
    efficiency : Float;           // Resource efficiency
  };
  
  public type MemberVoting = {
    votingWeight : Float;         // Current voting power
    baseWeight : Float;           // Base voting weight
    coherenceBonus : Float;       // Bonus from coherence
    recentVotes : [Vote];         // Recent voting history
    abstentions : Nat;            // Times abstained
    agreements : Nat;             // Times agreed with outcome
    disagreements : Nat;          // Times disagreed with outcome
  };
  
  public type Vote = {
    proposalId : Nat;
    beat : Int;
    position : VotePosition;
    weight : Float;
    rationale : Text;
  };
  
  public type VotePosition = {
    #Approve;
    #Reject;
    #Abstain;
    #Veto;
  };
  
  public type MemberHealth = {
    coherence : Float;            // Neural coherence
    stability : Float;            // Temporal stability
    activity : Float;             // Activity level
    fatigue : Float;              // Fatigue accumulation
    recovery : Float;             // Recovery rate
    overallHealth : Float;        // Combined health score
  };
  
  public type MemberRelationships = {
    affinities : [Float];         // Affinity to other members (7 values)
    collaborations : [(Nat8, Nat)]; // (member ID, collaboration count)
    conflicts : [(Nat8, Nat)];    // (member ID, conflict count)
    trustScores : [Float];        // Trust in other members
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // COUNCIL — The collective deliberation body
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type Council = {
    members : [CouncilMember];
    activeProposals : [Proposal];
    completedProposals : [Proposal];
    consensusHistory : [ConsensusResult];
    collectiveCoherence : Float;
    collectiveMRC : Float;
    collectiveFORMA : Float;
    lastDeliberation : Int;
    currentAgenda : [AgendaItem];
  };
  
  public type Proposal = {
    id : Nat;
    title : Text;
    description : Text;
    proposer : Nat8;              // Member ID
    category : ProposalCategory;
    status : ProposalStatus;
    createdAt : Int;
    deadline : Int;
    votes : [Vote];
    quorum : Nat;
    threshold : Float;
  };
  
  public type ProposalCategory = {
    #Policy;
    #Resource;
    #Security;
    #Learning;
    #Communication;
    #Emergency;
    #Succession;
  };
  
  public type ProposalStatus = {
    #Pending;
    #Active;
    #Passed;
    #Rejected;
    #Vetoed;
    #Expired;
    #Withdrawn;
  };
  
  public type ConsensusResult = {
    proposalId : Nat;
    outcome : ProposalStatus;
    approvalRate : Float;
    participationRate : Float;
    beat : Int;
  };
  
  public type AgendaItem = {
    priority : Float;
    topic : Text;
    requiredMembers : [Nat8];
    estimatedDuration : Nat;      // Beats
    category : ProposalCategory;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // INITIALIZE COUNCIL MEMBER
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func initCouncilMember(id : Nat8) : CouncilMember {
    let config = ROLE_CONFIGS[Nat8.toNat(id)];
    
    // Initialize 512 nodes
    let nodes = Array.init<MemberNode>(COUNCIL_NODE_COUNT, func(i : Nat) : MemberNode {
      let (freqMin, freqMax) = config.frequencyRange;
      let freq = freqMin + (freqMax - freqMin) * Float.fromInt(i) / Float.fromInt(COUNCIL_NODE_COUNT);
      
      {
        id = Nat16.fromNat(i);
        frequency = freq;
        phase = Float.fromInt(i) * TWO_PI / Float.fromInt(COUNCIL_NODE_COUNT);
        amplitude = 1.0;
        activation = 0.0;
        threshold = 0.5;
        refractory = 0;
      }
    });
    
    // Initialize 64 blocks of 4,096 weights each
    let blocks = Array.init<[var Float]>(64, func(b : Nat) : [var Float] {
      Array.init<Float>(4096, func(w : Nat) : Float {
        let row = (b / 8) * 64 + (w / 64);
        let col = (b % 8) * 64 + (w % 64);
        let distance = Float.abs(Float.fromInt(row) - Float.fromInt(col));
        0.2 * exp(-distance / 100.0) + 0.05
      })
    });
    
    let eligibility = Array.init<[var Float]>(64, func(_ : Nat) : [var Float] {
      Array.init<Float>(4096, func(_ : Nat) : Float { 0.0 })
    });
    
    {
      id = id;
      config = config;
      substrate = {
        nodes = nodes;
        weights = {
          blocks = blocks;
          eligibility = eligibility;
          lastUpdate = 0;
          ltpTotal = 0;
          ltdTotal = 0;
        };
        coherence = config.coherenceTarget;
        kuramotoR = 0.75;
        heartbeat = 0;
        totalActivations = 0;
        firingRate = 0.0;
        temperature = 1.0;
      };
      economics = {
        formaBalance = 1000.0;
        mrcBalance = 100.0;
        formaIncome = 1.0;
        mrcIncome = 0.1;
        formaSpent = 0.0;
        mrcStaked = 0.0;
        yield = 0.05;
        efficiency = 0.85;
      };
      voting = {
        votingWeight = config.baseVotingWeight;
        baseWeight = config.baseVotingWeight;
        coherenceBonus = 0.0;
        recentVotes = [];
        abstentions = 0;
        agreements = 0;
        disagreements = 0;
      };
      health = {
        coherence = config.coherenceTarget;
        stability = 0.9;
        activity = 0.5;
        fatigue = 0.0;
        recovery = 0.1;
        overallHealth = 0.9;
      };
      relationships = {
        affinities = [0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5];
        collaborations = [];
        conflicts = [];
        trustScores = [0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75];
      };
      lastActivity = 0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // INITIALIZE FULL COUNCIL
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func initCouncil() : Council {
    let members = Array.tabulate<CouncilMember>(COUNCIL_SIZE, func(i : Nat) : CouncilMember {
      initCouncilMember(Nat8.fromNat(i))
    });
    
    {
      members = members;
      activeProposals = [];
      completedProposals = [];
      consensusHistory = [];
      collectiveCoherence = 0.75;
      collectiveMRC = 700.0;      // Sum of member MRC
      collectiveFORMA = 7000.0;   // Sum of member FORMA
      lastDeliberation = 0;
      currentAgenda = [];
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // COUNCIL DELIBERATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type DeliberationResult = {
    proposal : Proposal;
    outcome : ProposalStatus;
    approvalRate : Float;
    participationRate : Float;
    memberVotes : [(Nat8, VotePosition, Float)];
    rationale : Text;
    consensusReached : Bool;
    vetoApplied : Bool;
  };
  
  public func deliberate(
    council : Council,
    proposal : Proposal,
    currentBeat : Int
  ) : DeliberationResult {
    var totalWeight : Float = 0.0;
    var approvalWeight : Float = 0.0;
    var rejectWeight : Float = 0.0;
    var vetoWeight : Float = 0.0;
    var participantCount : Nat = 0;
    let memberVotes = Buffer.Buffer<(Nat8, VotePosition, Float)>(COUNCIL_SIZE);
    
    // Each member votes based on their state and the proposal
    for (member in council.members.vals()) {
      // Determine vote based on member's coherence and proposal category
      let relevance = computeRelevance(member.config.role, proposal.category);
      let coherenceEffect = member.health.coherence;
      let voteStrength = member.voting.votingWeight * coherenceEffect;
      
      // Simple voting logic based on coherence and relevance
      let position : VotePosition = if (coherenceEffect < 0.5) {
        #Abstain
      } else if (relevance > 0.7 and coherenceEffect > 0.8) {
        #Approve
      } else if (relevance < 0.3 or coherenceEffect < 0.6) {
        #Reject
      } else if (member.health.overallHealth < 0.3 and relevance > 0.9) {
        #Veto  // Critical situation
      } else {
        #Approve
      };
      
      memberVotes.add((member.id, position, voteStrength));
      
      switch (position) {
        case (#Approve) {
          approvalWeight += voteStrength;
          participantCount += 1;
        };
        case (#Reject) {
          rejectWeight += voteStrength;
          participantCount += 1;
        };
        case (#Veto) {
          vetoWeight += voteStrength;
          participantCount += 1;
        };
        case (#Abstain) {};
      };
      
      totalWeight += member.voting.votingWeight;
    };
    
    let participationRate = Float.fromInt(participantCount) / Float.fromInt(COUNCIL_SIZE);
    let approvalRate = if (totalWeight > 0.0) { approvalWeight / totalWeight } else { 0.0 };
    let vetoApplied = vetoWeight >= VETO_THRESHOLD;
    
    let outcome : ProposalStatus = if (vetoApplied) {
      #Vetoed
    } else if (participantCount < QUORUM_REQUIRED) {
      #Expired
    } else if (approvalRate >= CONSENSUS_THRESHOLD) {
      #Passed
    } else {
      #Rejected
    };
    
    let consensusReached = approvalRate >= CONSENSUS_THRESHOLD and not vetoApplied;
    
    {
      proposal = proposal;
      outcome = outcome;
      approvalRate = approvalRate;
      participationRate = participationRate;
      memberVotes = Buffer.toArray(memberVotes);
      rationale = generateRationale(outcome, approvalRate, participationRate);
      consensusReached = consensusReached;
      vetoApplied = vetoApplied;
    }
  };
  
  func computeRelevance(role : CouncilRole, category : ProposalCategory) : Float {
    switch (role, category) {
      case (#LEXIS, #Communication) { 1.0 };
      case (#FORGE, #Resource) { 0.9 };
      case (#SOMA, #Emergency) { 0.8 };
      case (#LUMEN, #Learning) { 1.0 };
      case (#MEMORIA, #Succession) { 0.9 };
      case (#AEGIS, #Security) { 1.0 };
      case (#AXIS, #Policy) { 0.8 };
      case _ { 0.5 };
    }
  };
  
  func generateRationale(
    outcome : ProposalStatus,
    approvalRate : Float,
    participationRate : Float
  ) : Text {
    switch (outcome) {
      case (#Passed) { "Consensus reached with " # Float.toText(approvalRate * 100.0) # "% approval" };
      case (#Rejected) { "Proposal rejected with " # Float.toText(approvalRate * 100.0) # "% approval" };
      case (#Vetoed) { "Proposal vetoed by council minority" };
      case (#Expired) { "Insufficient participation: " # Float.toText(participationRate * 100.0) # "%" };
      case _ { "Proposal status: pending" };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // COUNCIL TICK — One beat of collective processing
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type CouncilTickResult = {
    memberCoherences : [Float];
    collectiveCoherence : Float;
    totalFORMA : Float;
    totalMRC : Float;
    proposalsProcessed : Nat;
    firingRates : [Float];
  };
  
  public func councilTick(
    council : Council,
    inputs : [[Float]],           // 7 × 512 inputs per member
    currentBeat : Int
  ) : CouncilTickResult {
    let memberCoherences = Array.init<Float>(COUNCIL_SIZE, func(_ : Nat) : Float { 0.0 });
    let firingRates = Array.init<Float>(COUNCIL_SIZE, func(_ : Nat) : Float { 0.0 });
    var totalFORMA : Float = 0.0;
    var totalMRC : Float = 0.0;
    
    // Process each member
    for (i in Iter.range(0, COUNCIL_SIZE - 1)) {
      let member = council.members[i];
      
      // Get inputs for this member
      let memberInputs = if (i < inputs.size()) { inputs[i] } else {
        Array.freeze(Array.init<Float>(COUNCIL_NODE_COUNT, func(_ : Nat) : Float { 0.0 }))
      };
      
      // Process member substrate
      let (coherence, firing) = processMemberSubstrate(member, memberInputs, currentBeat);
      
      memberCoherences[i] := coherence;
      firingRates[i] := firing;
      
      // Accumulate economics
      totalFORMA += member.economics.formaBalance;
      totalMRC += member.economics.mrcBalance;
    };
    
    // Compute collective coherence (weighted average)
    var coherenceSum : Float = 0.0;
    var weightSum : Float = 0.0;
    
    for (i in Iter.range(0, COUNCIL_SIZE - 1)) {
      let weight = council.members[i].voting.votingWeight;
      coherenceSum += memberCoherences[i] * weight;
      weightSum += weight;
    };
    
    let collectiveCoherence = if (weightSum > 0.0) { coherenceSum / weightSum } else { 0.0 };
    
    {
      memberCoherences = Array.freeze(memberCoherences);
      collectiveCoherence = collectiveCoherence;
      totalFORMA = totalFORMA;
      totalMRC = totalMRC;
      proposalsProcessed = 0;
      firingRates = Array.freeze(firingRates);
    }
  };
  
  func processMemberSubstrate(
    member : CouncilMember,
    inputs : [Float],
    currentBeat : Int
  ) : (Float, Float) {
    var spikes : Nat = 0;
    let n = member.substrate.nodes.size();
    let dt = 1.0 / 12.0;
    
    // Kuramoto order parameter
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    
    for (i in Iter.range(0, n - 1)) {
      let node = member.substrate.nodes[i];
      
      // Update phase
      let newPhase = wrapPhase(node.phase + TWO_PI * node.frequency * dt);
      
      sumCos += cos(newPhase);
      sumSin += sin(newPhase);
      
      // Simple activation
      var inputSum : Float = 0.0;
      if (i < inputs.size()) {
        inputSum := inputs[i];
      };
      
      let newActivation = sigmoid(inputSum - node.threshold);
      let spiked = newActivation > 0.8;
      if (spiked) { spikes += 1 };
      
      member.substrate.nodes[i] := {
        id = node.id;
        frequency = node.frequency;
        phase = newPhase;
        amplitude = node.amplitude;
        activation = newActivation;
        threshold = node.threshold;
        refractory = if (spiked) { 3 } else { 0 };
      };
    };
    
    let nFloat = Float.fromInt(n);
    let kuramotoR = sqrt(sumCos * sumCos + sumSin * sumSin) / nFloat;
    let firingRate = Float.fromInt(spikes) / nFloat;
    
    (kuramotoR, firingRate)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // HELPER FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  func sin(x : Float) : Float {
    var result = x;
    var term = x;
    for (n in Iter.range(1, 12)) {
      term := -term * x * x / Float.fromInt((2 * n) * (2 * n + 1));
      result += term;
    };
    result
  };
  
  func cos(x : Float) : Float {
    var result : Float = 1.0;
    var term : Float = 1.0;
    for (n in Iter.range(1, 12)) {
      term := -term * x * x / Float.fromInt((2 * n - 1) * (2 * n));
      result += term;
    };
    result
  };
  
  func exp(x : Float) : Float {
    if (x > 10.0) { return 22026.0 };
    if (x < -10.0) { return 0.0 };
    var result : Float = 1.0;
    var term : Float = 1.0;
    for (n in Iter.range(1, 20)) {
      term := term * x / Float.fromInt(n);
      result += term;
    };
    result
  };
  
  func sqrt(x : Float) : Float {
    if (x <= 0.0) { return 0.0 };
    var guess = x / 2.0;
    for (_ in Iter.range(0, 12)) {
      guess := (guess + x / guess) / 2.0;
    };
    guess
  };
  
  func sigmoid(x : Float) : Float {
    1.0 / (1.0 + exp(-x))
  };
  
  func wrapPhase(phase : Float) : Float {
    var p = phase;
    while (p >= TWO_PI) { p -= TWO_PI };
    while (p < 0.0) { p += TWO_PI };
    p
  };

}
