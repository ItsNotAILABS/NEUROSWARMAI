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
// =====================================================================
// Governance Module — Voting, Proposals, Consensus Algorithms
// Part of the Organism Command Platform Cognitive Architecture
// =====================================================================

import Time "mo:core/Time";
import Array "mo:core/Array";
import Float "mo:core/Float";
import Nat "mo:core/Nat";
import Int "mo:core/Int";
import Text "mo:core/Text";
import Principal "mo:core/Principal";

module GovernanceModule {

  // ===================== Proposal Types =====================

  public type ProposalType = {
    #ParameterChange;      // Change system parameters
    #OrganismUpgrade;      // Upgrade organism capabilities
    #FeatureRequest;       // Request new features
    #BudgetAllocation;     // Allocate FORMA tokens
    #PolicyChange;         // Change governance policies
    #EmergencyAction;      // Emergency measures
    #CollaborationRequest; // Inter-organism collaboration
    #MarketplaceRule;      // Marketplace policy changes
  };

  public type ProposalStatus = {
    #Draft;
    #Active;
    #Passed;
    #Rejected;
    #Executed;
    #Expired;
    #Cancelled;
    #Vetoed;
  };

  public type VoteType = {
    #Yes;
    #No;
    #Abstain;
    #Veto;
  };

  public type QuorumType = {
    #Simple;            // > 50%
    #SuperMajority;     // > 66.67%
    #Unanimous;         // 100%
    #Weighted;          // Based on FORMA holdings
    #Reputation;        // Based on governance score
  };

  // ===================== Proposal Structure =====================

  public type ProposalMetadata = {
    title : Text;
    description : Text;
    rationale : Text;
    impact : Text;
    risks : [Text];
    dependencies : [Text];
    estimatedCost : Float;
    estimatedDuration : Int;
  };

  public type ProposalThresholds = {
    quorumType : QuorumType;
    minimumVotes : Nat;
    passThreshold : Float;  // Percentage needed to pass (0-1)
    vetoThreshold : Float;  // Percentage of vetos to block (0-1)
    votingPeriod : Int;     // Duration in nanoseconds
    executionDelay : Int;   // Delay before execution
  };

  public type Vote = {
    voter : Principal;
    organismId : ?Text;     // If voting as organism
    voteType : VoteType;
    weight : Float;
    timestamp : Int;
    reason : ?Text;
  };

  public type VoteTally = {
    yesVotes : Float;
    noVotes : Float;
    abstainVotes : Float;
    vetoVotes : Float;
    totalVotes : Float;
    totalVoters : Nat;
    quorumReached : Bool;
    passThresholdMet : Bool;
    vetoThresholdMet : Bool;
  };

  public type Proposal = {
    id : Text;
    proposer : Principal;
    proposerOrganism : ?Text;
    proposalType : ProposalType;
    status : ProposalStatus;
    metadata : ProposalMetadata;
    thresholds : ProposalThresholds;
    votes : [Vote];
    tally : VoteTally;
    createdAt : Int;
    updatedAt : Int;
    votingEndsAt : Int;
    executionAt : ?Int;
    executionResult : ?Text;
  };

  // ===================== Delegation Types =====================

  public type DelegationType = {
    #Full;              // All voting power
    #Partial;           // Percentage of voting power
    #TypeSpecific;      // Only for certain proposal types
    #TimeLimit;         // Delegation expires after time
  };

  public type Delegation = {
    id : Text;
    delegator : Principal;
    delegatorOrganism : ?Text;
    delegate : Principal;
    delegateOrganism : ?Text;
    delegationType : DelegationType;
    percentage : Float;         // For partial delegation
    proposalTypes : [ProposalType]; // For type-specific
    expiresAt : ?Int;
    createdAt : Int;
    isActive : Bool;
  };

  // ===================== Governance Parameters =====================

  public type GovernanceParameters = {
    minimumProposalDeposit : Float;
    defaultVotingPeriod : Int;
    defaultExecutionDelay : Int;
    defaultQuorumType : QuorumType;
    defaultPassThreshold : Float;
    defaultVetoThreshold : Float;
    maxActiveProposals : Nat;
    maxProposalsPerUser : Nat;
    proposalCooldown : Int;
    emergencyVotingPeriod : Int;
    emergencyQuorum : Float;
  };

  // ===================== Governance State =====================

  public type GovernanceState = {
    var proposals : [Proposal];
    var delegations : [Delegation];
    var parameters : GovernanceParameters;
    var proposalCounter : Nat;
    var lastProposalTime : [(Principal, Int)];
    var executedProposals : [Text];
    var vetoedProposals : [Text];
  };

  public func initState() : GovernanceState {
    {
      var proposals = [];
      var delegations = [];
      var parameters = {
        minimumProposalDeposit = 10.0;
        defaultVotingPeriod = 604800_000_000_000;   // 7 days
        defaultExecutionDelay = 86400_000_000_000;  // 1 day
        defaultQuorumType = #Simple;
        defaultPassThreshold = 0.5;
        defaultVetoThreshold = 0.33;
        maxActiveProposals = 10;
        maxProposalsPerUser = 3;
        proposalCooldown = 86400_000_000_000;       // 1 day
        emergencyVotingPeriod = 86400_000_000_000;  // 1 day
        emergencyQuorum = 0.75;
      };
      var proposalCounter = 0;
      var lastProposalTime = [];
      var executedProposals = [];
      var vetoedProposals = [];
    };
  };

  // ===================== Array Utilities =====================

  func arrayAppend<T>(a : [T], b : [T]) : [T] {
    let sa = a.size();
    let sb = b.size();
    if (sa == 0) return b;
    if (sb == 0) return a;
    Array.tabulate(sa + sb, func(i : Nat) : T {
      if (i < sa) a[i] else b[i - sa];
    });
  };

  func arrayFilter<T>(arr : [T], pred : T -> Bool) : [T] {
    var result : [T] = [];
    for (item in arr.vals()) {
      if (pred(item)) {
        result := arrayAppend(result, [item]);
      };
    };
    result;
  };

  func arrayFind<T>(arr : [T], pred : T -> Bool) : ?T {
    for (item in arr.vals()) {
      if (pred(item)) return ?item;
    };
    null;
  };

  func arrayMap<T, U>(arr : [T], f : T -> U) : [U] {
    Array.tabulate(arr.size(), func(i : Nat) : U { f(arr[i]) });
  };

  // ===================== Vote Weight Calculation =====================

  public type VoterInfo = {
    principal : Principal;
    formaBalance : Float;
    governanceScore : Float;
    activationCount : Nat;
    coherence : Float;
  };

  public func calculateVoteWeight(
    voterInfo : VoterInfo,
    quorumType : QuorumType,
  ) : Float {
    switch quorumType {
      case (#Simple) 1.0;
      case (#SuperMajority) 1.0;
      case (#Unanimous) 1.0;
      case (#Weighted) {
        // Weight based on FORMA holdings
        let baseWeight = 1.0;
        let formaWeight = Float.sqrt(voterInfo.formaBalance) / 10.0;
        Float.min(10.0, baseWeight + formaWeight);
      };
      case (#Reputation) {
        // Weight based on governance score and coherence
        let govWeight = voterInfo.governanceScore * 2.0;
        let coherenceWeight = voterInfo.coherence;
        let activationBonus = Float.min(1.0, voterInfo.activationCount.toFloat() / 1000.0);
        govWeight + coherenceWeight + activationBonus;
      };
    };
  };

  // ===================== Proposal Management =====================

  public func createProposal(
    state : GovernanceState,
    proposer : Principal,
    proposerOrganism : ?Text,
    proposalType : ProposalType,
    metadata : ProposalMetadata,
    customThresholds : ?ProposalThresholds,
  ) : Result<Proposal, Text> {
    // Check cooldown
    for ((p, t) in state.lastProposalTime.vals()) {
      if (p == proposer and Time.now() - t < state.parameters.proposalCooldown) {
        return #err("Cooldown period not elapsed");
      };
    };

    // Check active proposal limit
    let activeCount = arrayFilter(state.proposals, func(p : Proposal) : Bool {
      p.proposer == proposer and (p.status == #Draft or p.status == #Active)
    }).size();
    
    if (activeCount >= state.parameters.maxProposalsPerUser) {
      return #err("Maximum active proposals reached");
    };

    state.proposalCounter += 1;
    let now = Time.now();
    
    let thresholds = switch customThresholds {
      case (?t) t;
      case null {
        let votingPeriod = switch proposalType {
          case (#EmergencyAction) state.parameters.emergencyVotingPeriod;
          case _ state.parameters.defaultVotingPeriod;
        };
        {
          quorumType = state.parameters.defaultQuorumType;
          minimumVotes = 1;
          passThreshold = state.parameters.defaultPassThreshold;
          vetoThreshold = state.parameters.defaultVetoThreshold;
          votingPeriod;
          executionDelay = state.parameters.defaultExecutionDelay;
        };
      };
    };

    let proposal : Proposal = {
      id = "prop-" # state.proposalCounter.toText();
      proposer;
      proposerOrganism;
      proposalType;
      status = #Draft;
      metadata;
      thresholds;
      votes = [];
      tally = {
        yesVotes = 0.0;
        noVotes = 0.0;
        abstainVotes = 0.0;
        vetoVotes = 0.0;
        totalVotes = 0.0;
        totalVoters = 0;
        quorumReached = false;
        passThresholdMet = false;
        vetoThresholdMet = false;
      };
      createdAt = now;
      updatedAt = now;
      votingEndsAt = now + thresholds.votingPeriod;
      executionAt = null;
      executionResult = null;
    };

    state.proposals := arrayAppend(state.proposals, [proposal]);
    
    // Update cooldown
    var newCooldown : [(Principal, Int)] = [];
    var found = false;
    for ((p, _) in state.lastProposalTime.vals()) {
      if (p == proposer) {
        newCooldown := arrayAppend(newCooldown, [(p, now)]);
        found := true;
      } else {
        newCooldown := arrayAppend(newCooldown, [(p, now)]);
      };
    };
    if (not found) {
      newCooldown := arrayAppend(newCooldown, [(proposer, now)]);
    };
    state.lastProposalTime := newCooldown;

    #ok(proposal);
  };

  public type Result<T, E> = { #ok : T; #err : E };

  public func activateProposal(
    state : GovernanceState,
    proposalId : Text,
    caller : Principal,
  ) : Result<Proposal, Text> {
    switch (findProposal(state, proposalId)) {
      case null #err("Proposal not found");
      case (?proposal) {
        if (proposal.proposer != caller) {
          return #err("Only proposer can activate");
        };
        if (proposal.status != #Draft) {
          return #err("Proposal not in draft status");
        };
        
        let updated : Proposal = {
          id = proposal.id;
          proposer = proposal.proposer;
          proposerOrganism = proposal.proposerOrganism;
          proposalType = proposal.proposalType;
          status = #Active;
          metadata = proposal.metadata;
          thresholds = proposal.thresholds;
          votes = proposal.votes;
          tally = proposal.tally;
          createdAt = proposal.createdAt;
          updatedAt = Time.now();
          votingEndsAt = Time.now() + proposal.thresholds.votingPeriod;
          executionAt = proposal.executionAt;
          executionResult = proposal.executionResult;
        };
        
        upsertProposal(state, updated);
        #ok(updated);
      };
    };
  };

  func findProposal(state : GovernanceState, id : Text) : ?Proposal {
    arrayFind(state.proposals, func(p : Proposal) : Bool { p.id == id });
  };

  func upsertProposal(state : GovernanceState, updated : Proposal) {
    var found = false;
    var newStore : [Proposal] = [];
    for (p in state.proposals.vals()) {
      if (p.id == updated.id) {
        newStore := arrayAppend(newStore, [updated]);
        found := true;
      } else {
        newStore := arrayAppend(newStore, [p]);
      };
    };
    if (not found) {
      newStore := arrayAppend(newStore, [updated]);
    };
    state.proposals := newStore;
  };

  // ===================== Voting Functions =====================

  public func castVote(
    state : GovernanceState,
    proposalId : Text,
    voter : Principal,
    voterOrganism : ?Text,
    voteType : VoteType,
    voterInfo : VoterInfo,
    reason : ?Text,
  ) : Result<Vote, Text> {
    switch (findProposal(state, proposalId)) {
      case null #err("Proposal not found");
      case (?proposal) {
        if (proposal.status != #Active) {
          return #err("Proposal not active");
        };
        if (Time.now() > proposal.votingEndsAt) {
          return #err("Voting period ended");
        };
        
        // Check if already voted
        for (v in proposal.votes.vals()) {
          if (v.voter == voter) {
            return #err("Already voted");
          };
        };
        
        // Calculate vote weight (including delegations)
        let baseWeight = calculateVoteWeight(voterInfo, proposal.thresholds.quorumType);
        let delegatedWeight = calculateDelegatedWeight(state, voter, proposal.thresholds.quorumType);
        let totalWeight = baseWeight + delegatedWeight;
        
        let vote : Vote = {
          voter;
          organismId = voterOrganism;
          voteType;
          weight = totalWeight;
          timestamp = Time.now();
          reason;
        };
        
        let newVotes = arrayAppend(proposal.votes, [vote]);
        let newTally = calculateTally(newVotes, proposal.thresholds);
        
        let updated : Proposal = {
          id = proposal.id;
          proposer = proposal.proposer;
          proposerOrganism = proposal.proposerOrganism;
          proposalType = proposal.proposalType;
          status = proposal.status;
          metadata = proposal.metadata;
          thresholds = proposal.thresholds;
          votes = newVotes;
          tally = newTally;
          createdAt = proposal.createdAt;
          updatedAt = Time.now();
          votingEndsAt = proposal.votingEndsAt;
          executionAt = proposal.executionAt;
          executionResult = proposal.executionResult;
        };
        
        upsertProposal(state, updated);
        #ok(vote);
      };
    };
  };

  func calculateDelegatedWeight(
    state : GovernanceState,
    voter : Principal,
    quorumType : QuorumType,
  ) : Float {
    var totalDelegated : Float = 0.0;
    
    for (d in state.delegations.vals()) {
      if (d.delegate == voter and d.isActive) {
        // Check expiration
        let expired = switch d.expiresAt {
          case (?exp) Time.now() > exp;
          case null false;
        };
        
        if (not expired) {
          let delegatedPortion = switch d.delegationType {
            case (#Full) 1.0;
            case (#Partial) d.percentage;
            case (#TypeSpecific) 1.0; // Would need proposal type check
            case (#TimeLimit) 1.0;
          };
          totalDelegated += delegatedPortion;
        };
      };
    };
    
    totalDelegated;
  };

  func calculateTally(votes : [Vote], thresholds : ProposalThresholds) : VoteTally {
    var yesVotes : Float = 0.0;
    var noVotes : Float = 0.0;
    var abstainVotes : Float = 0.0;
    var vetoVotes : Float = 0.0;
    var totalVotes : Float = 0.0;
    
    for (v in votes.vals()) {
      totalVotes += v.weight;
      switch v.voteType {
        case (#Yes) yesVotes += v.weight;
        case (#No) noVotes += v.weight;
        case (#Abstain) abstainVotes += v.weight;
        case (#Veto) vetoVotes += v.weight;
      };
    };
    
    let effectiveVotes = yesVotes + noVotes; // Abstains don't count toward threshold
    let quorumReached = votes.size() >= thresholds.minimumVotes;
    let passThresholdMet = if (effectiveVotes > 0) 
      (yesVotes / effectiveVotes) >= thresholds.passThreshold
    else false;
    let vetoThresholdMet = if (totalVotes > 0)
      (vetoVotes / totalVotes) >= thresholds.vetoThreshold
    else false;
    
    {
      yesVotes;
      noVotes;
      abstainVotes;
      vetoVotes;
      totalVotes;
      totalVoters = votes.size();
      quorumReached;
      passThresholdMet;
      vetoThresholdMet;
    };
  };

  // ===================== Proposal Resolution =====================

  public func finalizeProposal(
    state : GovernanceState,
    proposalId : Text,
  ) : Result<Proposal, Text> {
    switch (findProposal(state, proposalId)) {
      case null #err("Proposal not found");
      case (?proposal) {
        if (proposal.status != #Active) {
          return #err("Proposal not active");
        };
        if (Time.now() <= proposal.votingEndsAt) {
          return #err("Voting period not ended");
        };
        
        let newStatus : ProposalStatus = 
          if (proposal.tally.vetoThresholdMet) #Vetoed
          else if (not proposal.tally.quorumReached) #Expired
          else if (proposal.tally.passThresholdMet) #Passed
          else #Rejected;
        
        let executionAt = if (newStatus == #Passed) 
          ?(Time.now() + proposal.thresholds.executionDelay)
        else null;
        
        let updated : Proposal = {
          id = proposal.id;
          proposer = proposal.proposer;
          proposerOrganism = proposal.proposerOrganism;
          proposalType = proposal.proposalType;
          status = newStatus;
          metadata = proposal.metadata;
          thresholds = proposal.thresholds;
          votes = proposal.votes;
          tally = proposal.tally;
          createdAt = proposal.createdAt;
          updatedAt = Time.now();
          votingEndsAt = proposal.votingEndsAt;
          executionAt;
          executionResult = proposal.executionResult;
        };
        
        upsertProposal(state, updated);
        
        if (newStatus == #Vetoed) {
          state.vetoedProposals := arrayAppend(state.vetoedProposals, [proposalId]);
        };
        
        #ok(updated);
      };
    };
  };

  public func executeProposal(
    state : GovernanceState,
    proposalId : Text,
    caller : Principal,
  ) : Result<Proposal, Text> {
    switch (findProposal(state, proposalId)) {
      case null #err("Proposal not found");
      case (?proposal) {
        if (proposal.status != #Passed) {
          return #err("Proposal not passed");
        };
        
        let executionTime = switch proposal.executionAt {
          case (?t) t;
          case null return #err("No execution time set");
        };
        
        if (Time.now() < executionTime) {
          return #err("Execution delay not elapsed");
        };
        
        // Mark as executed
        let updated : Proposal = {
          id = proposal.id;
          proposer = proposal.proposer;
          proposerOrganism = proposal.proposerOrganism;
          proposalType = proposal.proposalType;
          status = #Executed;
          metadata = proposal.metadata;
          thresholds = proposal.thresholds;
          votes = proposal.votes;
          tally = proposal.tally;
          createdAt = proposal.createdAt;
          updatedAt = Time.now();
          votingEndsAt = proposal.votingEndsAt;
          executionAt = proposal.executionAt;
          executionResult = ?"Executed successfully";
        };
        
        upsertProposal(state, updated);
        state.executedProposals := arrayAppend(state.executedProposals, [proposalId]);
        
        #ok(updated);
      };
    };
  };

  // ===================== Delegation Management =====================

  public func createDelegation(
    state : GovernanceState,
    delegator : Principal,
    delegatorOrganism : ?Text,
    delegate : Principal,
    delegateOrganism : ?Text,
    delegationType : DelegationType,
    percentage : Float,
    proposalTypes : [ProposalType],
    expiresAt : ?Int,
  ) : Result<Delegation, Text> {
    if (delegator == delegate) {
      return #err("Cannot delegate to self");
    };
    
    // Check for existing delegation
    for (d in state.delegations.vals()) {
      if (d.delegator == delegator and d.delegate == delegate and d.isActive) {
        return #err("Delegation already exists");
      };
    };
    
    let delegation : Delegation = {
      id = "del-" # Time.now().toText();
      delegator;
      delegatorOrganism;
      delegate;
      delegateOrganism;
      delegationType;
      percentage;
      proposalTypes;
      expiresAt;
      createdAt = Time.now();
      isActive = true;
    };
    
    state.delegations := arrayAppend(state.delegations, [delegation]);
    #ok(delegation);
  };

  public func revokeDelegation(
    state : GovernanceState,
    delegationId : Text,
    caller : Principal,
  ) : Result<(), Text> {
    var found = false;
    state.delegations := arrayMap(state.delegations, func(d : Delegation) : Delegation {
      if (d.id == delegationId and d.delegator == caller) {
        found := true;
        {
          id = d.id;
          delegator = d.delegator;
          delegatorOrganism = d.delegatorOrganism;
          delegate = d.delegate;
          delegateOrganism = d.delegateOrganism;
          delegationType = d.delegationType;
          percentage = d.percentage;
          proposalTypes = d.proposalTypes;
          expiresAt = d.expiresAt;
          createdAt = d.createdAt;
          isActive = false;
        };
      } else d;
    });
    
    if (found) #ok(()) else #err("Delegation not found");
  };

  public func getDelegationsForDelegate(
    state : GovernanceState,
    delegate : Principal,
  ) : [Delegation] {
    arrayFilter(state.delegations, func(d : Delegation) : Bool {
      d.delegate == delegate and d.isActive
    });
  };

  public func getDelegationsForDelegator(
    state : GovernanceState,
    delegator : Principal,
  ) : [Delegation] {
    arrayFilter(state.delegations, func(d : Delegation) : Bool {
      d.delegator == delegator and d.isActive
    });
  };

  // ===================== Query Functions =====================

  public func getActiveProposals(state : GovernanceState) : [Proposal] {
    arrayFilter(state.proposals, func(p : Proposal) : Bool {
      p.status == #Active
    });
  };

  public func getProposalsByStatus(
    state : GovernanceState,
    status : ProposalStatus,
  ) : [Proposal] {
    arrayFilter(state.proposals, func(p : Proposal) : Bool {
      p.status == status
    });
  };

  public func getProposalsByProposer(
    state : GovernanceState,
    proposer : Principal,
  ) : [Proposal] {
    arrayFilter(state.proposals, func(p : Proposal) : Bool {
      p.proposer == proposer
    });
  };

  public func getProposalsByType(
    state : GovernanceState,
    proposalType : ProposalType,
  ) : [Proposal] {
    arrayFilter(state.proposals, func(p : Proposal) : Bool {
      p.proposalType == proposalType
    });
  };

  public func getVoterHistory(
    state : GovernanceState,
    voter : Principal,
  ) : [(Text, Vote)] {
    var result : [(Text, Vote)] = [];
    for (p in state.proposals.vals()) {
      for (v in p.votes.vals()) {
        if (v.voter == voter) {
          result := arrayAppend(result, [(p.id, v)]);
        };
      };
    };
    result;
  };

  // ===================== Parameter Updates =====================

  public func updateParameters(
    state : GovernanceState,
    newParams : GovernanceParameters,
    caller : Principal,
    isAdmin : Bool,
  ) : Result<(), Text> {
    if (not isAdmin) {
      return #err("Unauthorized");
    };
    state.parameters := newParams;
    #ok(());
  };

  // ===================== Cleanup Functions =====================

  public func cleanupExpiredDelegations(state : GovernanceState) {
    let now = Time.now();
    state.delegations := arrayMap(state.delegations, func(d : Delegation) : Delegation {
      let expired = switch d.expiresAt {
        case (?exp) now > exp;
        case null false;
      };
      if (expired and d.isActive) {
        {
          id = d.id;
          delegator = d.delegator;
          delegatorOrganism = d.delegatorOrganism;
          delegate = d.delegate;
          delegateOrganism = d.delegateOrganism;
          delegationType = d.delegationType;
          percentage = d.percentage;
          proposalTypes = d.proposalTypes;
          expiresAt = d.expiresAt;
          createdAt = d.createdAt;
          isActive = false;
        };
      } else d;
    });
  };

  public func archiveOldProposals(
    state : GovernanceState,
    maxAge : Int,
  ) : [Proposal] {
    let cutoff = Time.now() - maxAge;
    let archived = arrayFilter(state.proposals, func(p : Proposal) : Bool {
      p.updatedAt < cutoff and (p.status == #Executed or p.status == #Rejected or p.status == #Expired or p.status == #Vetoed)
    });
    
    state.proposals := arrayFilter(state.proposals, func(p : Proposal) : Bool {
      p.updatedAt >= cutoff or (p.status != #Executed and p.status != #Rejected and p.status != #Expired and p.status != #Vetoed)
    });
    
    archived;
  };

};
