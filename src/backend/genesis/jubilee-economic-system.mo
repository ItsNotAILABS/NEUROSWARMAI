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
// ║  CONFIDENTIALITY: This code is CONFIDENTIAL and PROPRIETARY.                                             ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// JUBILEE ECONOMIC SYSTEM — BACKEND VERSION (MALE)
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// JUBILEE: The periodic celebration and reset mechanism
//
// In ancient Israel, every 50th year was a Jubilee - debts were forgiven, slaves freed,
// land returned to original owners. This organism implements a similar principle:
//
// JUBILEE CYCLES:
// - Minor Jubilee: Every 1,000 beats - small celebration, bonus rewards
// - Major Jubilee: Every 10,000 beats - significant reset, debt forgiveness
// - Grand Jubilee: Every 100,000 beats - massive celebration, system-wide bonus
// - Transcendent Jubilee: Every 1,000,000 beats - legendary event
//
// JUBILEE MECHANICS:
// 1. Knowledge Compounding Milestone - accumulated learning rewarded
// 2. Debt Forgiveness - negative states partially reset
// 3. FORMA Distribution - bonus tokens to all participants
// 4. Emergence Celebration - OMNIS multiplier boost
// 5. Pattern Library Expansion - new patterns unlocked
//
// WHY JUBILEE HASN'T BEEN IMPLEMENTED YET:
// The Jubilee system requires:
// - Complete beat tracking (CHRONOS) ✓
// - FORMA token economy ✓
// - Knowledge compounding formulas ✓
// - Debt/negative state tracking (partially implemented)
// - Multi-participant distribution (requires session management)
// - Pattern library infrastructure (partially implemented)
//
// This module completes the Jubilee system for the main canister.
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Nat64 "mo:core/Nat64";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Iter "mo:core/Iter";
import Time "mo:core/Time";
import Option "mo:core/Option";
import Text "mo:core/Text";
import HashMap "mo:core/HashMap";
import Principal "mo:core/Principal";

module JubileeEconomicSystem {

  // ═══════════════════════════════════════════════════════════════════════════════
  // JUBILEE CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Minor Jubilee interval (beats)
  public let MINOR_JUBILEE_INTERVAL : Nat = 1000;
  
  /// Major Jubilee interval (beats)
  public let MAJOR_JUBILEE_INTERVAL : Nat = 10000;
  
  /// Grand Jubilee interval (beats)
  public let GRAND_JUBILEE_INTERVAL : Nat = 100000;
  
  /// Transcendent Jubilee interval (beats)
  public let TRANSCENDENT_JUBILEE_INTERVAL : Nat = 1000000;
  
  /// Minor Jubilee FORMA multiplier
  public let MINOR_JUBILEE_MULTIPLIER : Float = 1.5;
  
  /// Major Jubilee FORMA multiplier
  public let MAJOR_JUBILEE_MULTIPLIER : Float = 2.5;
  
  /// Grand Jubilee FORMA multiplier
  public let GRAND_JUBILEE_MULTIPLIER : Float = 5.0;
  
  /// Transcendent Jubilee FORMA multiplier
  public let TRANSCENDENT_JUBILEE_MULTIPLIER : Float = 10.0;
  
  /// Debt forgiveness percentage (Minor)
  public let MINOR_DEBT_FORGIVENESS : Float = 0.10;
  
  /// Debt forgiveness percentage (Major)
  public let MAJOR_DEBT_FORGIVENESS : Float = 0.25;
  
  /// Debt forgiveness percentage (Grand)
  public let GRAND_DEBT_FORGIVENESS : Float = 0.50;
  
  /// Debt forgiveness percentage (Transcendent)
  public let TRANSCENDENT_DEBT_FORGIVENESS : Float = 1.00;
  
  /// Knowledge compounding bonus (Minor)
  public let MINOR_KNOWLEDGE_BONUS : Float = 0.05;
  
  /// Knowledge compounding bonus (Major)
  public let MAJOR_KNOWLEDGE_BONUS : Float = 0.15;
  
  /// Knowledge compounding bonus (Grand)
  public let GRAND_KNOWLEDGE_BONUS : Float = 0.30;
  
  /// Knowledge compounding bonus (Transcendent)
  public let TRANSCENDENT_KNOWLEDGE_BONUS : Float = 0.50;
  
  /// Jubilee celebration duration (beats)
  public let JUBILEE_CELEBRATION_DURATION : Nat = 50;
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // JUBILEE TYPES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type JubileeType = {
    #Minor;
    #Major;
    #Grand;
    #Transcendent;
  };
  
  public func jubileeTypeToText(jt : JubileeType) : Text {
    switch (jt) {
      case (#Minor) { "Minor" };
      case (#Major) { "Major" };
      case (#Grand) { "Grand" };
      case (#Transcendent) { "Transcendent" };
    }
  };
  
  public func jubileeTypeToMultiplier(jt : JubileeType) : Float {
    switch (jt) {
      case (#Minor) { MINOR_JUBILEE_MULTIPLIER };
      case (#Major) { MAJOR_JUBILEE_MULTIPLIER };
      case (#Grand) { GRAND_JUBILEE_MULTIPLIER };
      case (#Transcendent) { TRANSCENDENT_JUBILEE_MULTIPLIER };
    }
  };
  
  public func jubileeTypeToDebtForgiveness(jt : JubileeType) : Float {
    switch (jt) {
      case (#Minor) { MINOR_DEBT_FORGIVENESS };
      case (#Major) { MAJOR_DEBT_FORGIVENESS };
      case (#Grand) { GRAND_DEBT_FORGIVENESS };
      case (#Transcendent) { TRANSCENDENT_DEBT_FORGIVENESS };
    }
  };
  
  public func jubileeTypeToKnowledgeBonus(jt : JubileeType) : Float {
    switch (jt) {
      case (#Minor) { MINOR_KNOWLEDGE_BONUS };
      case (#Major) { MAJOR_KNOWLEDGE_BONUS };
      case (#Grand) { GRAND_KNOWLEDGE_BONUS };
      case (#Transcendent) { TRANSCENDENT_KNOWLEDGE_BONUS };
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // PARTICIPANT TRACKING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type ParticipantRecord = {
    principal : Principal;
    joinedBeat : Nat;
    totalSessions : Nat;
    totalPlaytime : Nat; // In beats
    knowledgeLevel : Float;
    debtLevel : Float;
    formaEarned : Float;
    jubileesParticipated : Nat;
    lastActiveBeat : Nat;
    faction : Nat;
    contributionScore : Float;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // JUBILEE EVENT RECORD
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type JubileeEvent = {
    id : Nat;
    jubileeType : JubileeType;
    beat : Nat;
    timestamp : Int;
    
    // Pre-jubilee state
    totalParticipants : Nat;
    totalKnowledge : Float;
    totalDebt : Float;
    totalForma : Float;
    
    // Jubilee effects
    formaDistributed : Float;
    debtForgiven : Float;
    knowledgeBonusApplied : Float;
    patternsUnlocked : Nat;
    
    // Post-jubilee state
    participantRewards : [(Principal, Float)];
    
    // Celebration
    celebrationEndBeat : Nat;
    omnisMultiplierActive : Bool;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // JUBILEE STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type JubileeState = {
    // Counters
    var totalMinorJubilees : Nat;
    var totalMajorJubilees : Nat;
    var totalGrandJubilees : Nat;
    var totalTranscendentJubilees : Nat;
    
    // Last jubilee beats
    var lastMinorJubileeBeat : Nat;
    var lastMajorJubileeBeat : Nat;
    var lastGrandJubileeBeat : Nat;
    var lastTranscendentJubileeBeat : Nat;
    
    // Active celebration
    var isJubileeCelebrationActive : Bool;
    var activeJubileeType : ?JubileeType;
    var celebrationEndBeat : Nat;
    var activeMultiplier : Float;
    
    // Event history
    var eventHistory : Buffer.Buffer<JubileeEvent>;
    
    // Aggregate tracking
    var totalFormaDistributed : Float;
    var totalDebtForgiven : Float;
    var totalKnowledgeBonusApplied : Float;
    var totalPatternsUnlocked : Nat;
    
    // System state
    var isEnabled : Bool;
    var lastCheckBeat : Nat;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // DEBT TRACKING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type DebtType = {
    #Coherence;      // Coherence deficit (below baseline)
    #Energy;         // Energy deficit
    #Trust;          // Negative trust balance
    #Territory;      // Lost territory penalty
    #Sacrifice;      // Sacrifice-related debt
    #Emergence;      // Failed emergence attempts
  };
  
  public type DebtRecord = {
    debtType : DebtType;
    amount : Float;
    incurredBeat : Nat;
    reason : Text;
    canBeForgiven : Bool;
  };
  
  public type ParticipantDebt = {
    principal : Principal;
    debts : [DebtRecord];
    totalDebt : Float;
    debtForgivenLifetime : Float;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func initJubileeState() : JubileeState {
    {
      var totalMinorJubilees = 0;
      var totalMajorJubilees = 0;
      var totalGrandJubilees = 0;
      var totalTranscendentJubilees = 0;
      var lastMinorJubileeBeat = 0;
      var lastMajorJubileeBeat = 0;
      var lastGrandJubileeBeat = 0;
      var lastTranscendentJubileeBeat = 0;
      var isJubileeCelebrationActive = false;
      var activeJubileeType = null;
      var celebrationEndBeat = 0;
      var activeMultiplier = 1.0;
      var eventHistory = Buffer.Buffer<JubileeEvent>(100);
      var totalFormaDistributed = 0.0;
      var totalDebtForgiven = 0.0;
      var totalKnowledgeBonusApplied = 0.0;
      var totalPatternsUnlocked = 0;
      var isEnabled = true;
      var lastCheckBeat = 0;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // JUBILEE DETECTION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Check if a jubilee should trigger at this beat
  public func checkForJubilee(currentBeat : Nat) : ?JubileeType {
    // Check in order of precedence (highest first)
    if (currentBeat > 0 and currentBeat % TRANSCENDENT_JUBILEE_INTERVAL == 0) {
      return ?#Transcendent;
    };
    if (currentBeat > 0 and currentBeat % GRAND_JUBILEE_INTERVAL == 0) {
      return ?#Grand;
    };
    if (currentBeat > 0 and currentBeat % MAJOR_JUBILEE_INTERVAL == 0) {
      return ?#Major;
    };
    if (currentBeat > 0 and currentBeat % MINOR_JUBILEE_INTERVAL == 0) {
      return ?#Minor;
    };
    null
  };
  
  /// Get beats until next jubilee of each type
  public func getBeatsUntilJubilees(currentBeat : Nat) : {
    minor : Nat;
    major : Nat;
    grand : Nat;
    transcendent : Nat;
  } {
    {
      minor = MINOR_JUBILEE_INTERVAL - (currentBeat % MINOR_JUBILEE_INTERVAL);
      major = MAJOR_JUBILEE_INTERVAL - (currentBeat % MAJOR_JUBILEE_INTERVAL);
      grand = GRAND_JUBILEE_INTERVAL - (currentBeat % GRAND_JUBILEE_INTERVAL);
      transcendent = TRANSCENDENT_JUBILEE_INTERVAL - (currentBeat % TRANSCENDENT_JUBILEE_INTERVAL);
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // FORMA DISTRIBUTION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Calculate FORMA distribution for a jubilee
  public func calculateFormaDistribution(
    jubileeType : JubileeType,
    participants : [ParticipantRecord],
    basePool : Float
  ) : [(Principal, Float)] {
    let multiplier = jubileeTypeToMultiplier(jubileeType);
    let totalPool = basePool * multiplier;
    
    // Calculate total contribution score
    var totalContribution : Float = 0.0;
    for (p in participants.vals()) {
      totalContribution += p.contributionScore;
    };
    
    // Distribute proportionally
    let distributions = Buffer.Buffer<(Principal, Float)>(participants.size());
    
    for (p in participants.vals()) {
      let share = if (totalContribution > 0.0) {
        (p.contributionScore / totalContribution) * totalPool
      } else {
        totalPool / Float.fromInt(participants.size())
      };
      distributions.add((p.principal, share));
    };
    
    Buffer.toArray(distributions)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // DEBT FORGIVENESS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Calculate debt forgiveness for a jubilee
  public func calculateDebtForgiveness(
    jubileeType : JubileeType,
    participantDebt : ParticipantDebt
  ) : Float {
    let forgivenessPct = jubileeTypeToDebtForgiveness(jubileeType);
    
    var forgivableDebt : Float = 0.0;
    for (debt in participantDebt.debts.vals()) {
      if (debt.canBeForgiven) {
        forgivableDebt += debt.amount;
      };
    };
    
    forgivableDebt * forgivenessPct
  };
  
  /// Apply debt forgiveness to debt records
  public func applyDebtForgiveness(
    debts : [DebtRecord],
    forgivenAmount : Float
  ) : [DebtRecord] {
    var remaining = forgivenAmount;
    let newDebts = Buffer.Buffer<DebtRecord>(debts.size());
    
    for (debt in debts.vals()) {
      if (debt.canBeForgiven and remaining > 0.0) {
        let forgiven = Float.min(debt.amount, remaining);
        remaining -= forgiven;
        
        let newAmount = debt.amount - forgiven;
        if (newAmount > 0.0) {
          newDebts.add({
            debtType = debt.debtType;
            amount = newAmount;
            incurredBeat = debt.incurredBeat;
            reason = debt.reason;
            canBeForgiven = debt.canBeForgiven;
          });
        };
      } else {
        newDebts.add(debt);
      };
    };
    
    Buffer.toArray(newDebts)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // KNOWLEDGE COMPOUNDING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Calculate knowledge bonus for jubilee
  /// K(t+1) = K(t) × (1 + r_jubilee)
  public func calculateKnowledgeBonus(
    jubileeType : JubileeType,
    currentKnowledge : Float
  ) : Float {
    let bonusRate = jubileeTypeToKnowledgeBonus(jubileeType);
    currentKnowledge * bonusRate
  };
  
  /// Apply knowledge bonus to participant
  public func applyKnowledgeBonus(
    participant : ParticipantRecord,
    bonus : Float
  ) : ParticipantRecord {
    {
      principal = participant.principal;
      joinedBeat = participant.joinedBeat;
      totalSessions = participant.totalSessions;
      totalPlaytime = participant.totalPlaytime;
      knowledgeLevel = participant.knowledgeLevel + bonus;
      debtLevel = participant.debtLevel;
      formaEarned = participant.formaEarned;
      jubileesParticipated = participant.jubileesParticipated + 1;
      lastActiveBeat = participant.lastActiveBeat;
      faction = participant.faction;
      contributionScore = participant.contributionScore;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // PATTERN UNLOCKING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Calculate patterns to unlock during jubilee
  public func calculatePatternsToUnlock(
    jubileeType : JubileeType,
    currentPatternCount : Nat,
    maxPatterns : Nat
  ) : Nat {
    let unlockRate = switch (jubileeType) {
      case (#Minor) { 0.01 };     // 1% of remaining
      case (#Major) { 0.05 };     // 5% of remaining
      case (#Grand) { 0.15 };     // 15% of remaining
      case (#Transcendent) { 0.30 }; // 30% of remaining
    };
    
    let remaining = maxPatterns - currentPatternCount;
    let toUnlock = Float.toInt(Float.fromInt(remaining) * unlockRate);
    
    if (toUnlock > 0) {
      Int.abs(toUnlock)
    } else {
      1 // Always unlock at least 1 pattern
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // JUBILEE EXECUTION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type JubileeInputs = {
    currentBeat : Nat;
    participants : [ParticipantRecord];
    participantDebts : [ParticipantDebt];
    baseFormaPool : Float;
    currentPatternCount : Nat;
    maxPatterns : Nat;
    totalKnowledge : Float;
    totalDebt : Float;
    totalForma : Float;
  };
  
  /// Execute a jubilee event
  public func executeJubilee(
    state : JubileeState,
    jubileeType : JubileeType,
    inputs : JubileeInputs
  ) : JubileeEvent {
    // Calculate distributions
    let formaDistributions = calculateFormaDistribution(
      jubileeType,
      inputs.participants,
      inputs.baseFormaPool
    );
    
    // Calculate total FORMA distributed
    var totalFormaDistributed : Float = 0.0;
    for ((_, amount) in formaDistributions.vals()) {
      totalFormaDistributed += amount;
    };
    
    // Calculate total debt forgiven
    var totalDebtForgiven : Float = 0.0;
    for (pd in inputs.participantDebts.vals()) {
      totalDebtForgiven += calculateDebtForgiveness(jubileeType, pd);
    };
    
    // Calculate knowledge bonus
    let knowledgeBonus = calculateKnowledgeBonus(jubileeType, inputs.totalKnowledge);
    
    // Calculate patterns to unlock
    let patternsToUnlock = calculatePatternsToUnlock(
      jubileeType,
      inputs.currentPatternCount,
      inputs.maxPatterns
    );
    
    // Create event record
    let eventId = state.totalMinorJubilees + state.totalMajorJubilees + 
                  state.totalGrandJubilees + state.totalTranscendentJubilees + 1;
    
    let event : JubileeEvent = {
      id = eventId;
      jubileeType = jubileeType;
      beat = inputs.currentBeat;
      timestamp = Time.now();
      totalParticipants = inputs.participants.size();
      totalKnowledge = inputs.totalKnowledge;
      totalDebt = inputs.totalDebt;
      totalForma = inputs.totalForma;
      formaDistributed = totalFormaDistributed;
      debtForgiven = totalDebtForgiven;
      knowledgeBonusApplied = knowledgeBonus;
      patternsUnlocked = patternsToUnlock;
      participantRewards = formaDistributions;
      celebrationEndBeat = inputs.currentBeat + JUBILEE_CELEBRATION_DURATION;
      omnisMultiplierActive = true;
    };
    
    // Update state based on jubilee type
    switch (jubileeType) {
      case (#Minor) {
        state.totalMinorJubilees += 1;
        state.lastMinorJubileeBeat := inputs.currentBeat;
      };
      case (#Major) {
        state.totalMajorJubilees += 1;
        state.lastMajorJubileeBeat := inputs.currentBeat;
      };
      case (#Grand) {
        state.totalGrandJubilees += 1;
        state.lastGrandJubileeBeat := inputs.currentBeat;
      };
      case (#Transcendent) {
        state.totalTranscendentJubilees += 1;
        state.lastTranscendentJubileeBeat := inputs.currentBeat;
      };
    };
    
    // Update aggregate tracking
    state.totalFormaDistributed += totalFormaDistributed;
    state.totalDebtForgiven += totalDebtForgiven;
    state.totalKnowledgeBonusApplied += knowledgeBonus;
    state.totalPatternsUnlocked += patternsToUnlock;
    
    // Activate celebration
    state.isJubileeCelebrationActive := true;
    state.activeJubileeType := ?jubileeType;
    state.celebrationEndBeat := event.celebrationEndBeat;
    state.activeMultiplier := jubileeTypeToMultiplier(jubileeType);
    
    // Add to history
    state.eventHistory.add(event);
    
    event
  };
  
  /// Update jubilee state each beat
  public func tick(state : JubileeState, currentBeat : Nat) : () {
    // Check if celebration has ended
    if (state.isJubileeCelebrationActive and currentBeat >= state.celebrationEndBeat) {
      state.isJubileeCelebrationActive := false;
      state.activeJubileeType := null;
      state.activeMultiplier := 1.0;
    };
    
    state.lastCheckBeat := currentBeat;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // QUERY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Get current FORMA multiplier
  public func getCurrentMultiplier(state : JubileeState) : Float {
    if (state.isJubileeCelebrationActive) {
      state.activeMultiplier
    } else {
      1.0
    }
  };
  
  /// Check if jubilee celebration is active
  public func isCelebrationActive(state : JubileeState) : Bool {
    state.isJubileeCelebrationActive
  };
  
  /// Get active jubilee type
  public func getActiveJubileeType(state : JubileeState) : ?JubileeType {
    state.activeJubileeType
  };
  
  /// Get jubilee statistics
  public func getStatistics(state : JubileeState) : {
    totalJubilees : Nat;
    minor : Nat;
    major : Nat;
    grand : Nat;
    transcendent : Nat;
    totalFormaDistributed : Float;
    totalDebtForgiven : Float;
    totalKnowledgeBonus : Float;
    totalPatternsUnlocked : Nat;
  } {
    {
      totalJubilees = state.totalMinorJubilees + state.totalMajorJubilees + 
                      state.totalGrandJubilees + state.totalTranscendentJubilees;
      minor = state.totalMinorJubilees;
      major = state.totalMajorJubilees;
      grand = state.totalGrandJubilees;
      transcendent = state.totalTranscendentJubilees;
      totalFormaDistributed = state.totalFormaDistributed;
      totalDebtForgiven = state.totalDebtForgiven;
      totalKnowledgeBonus = state.totalKnowledgeBonusApplied;
      totalPatternsUnlocked = state.totalPatternsUnlocked;
    }
  };
  
  /// Get event history
  public func getEventHistory(state : JubileeState) : [JubileeEvent] {
    Buffer.toArray(state.eventHistory)
  };
  
  /// Get last event
  public func getLastEvent(state : JubileeState) : ?JubileeEvent {
    if (state.eventHistory.size() > 0) {
      ?state.eventHistory.get(state.eventHistory.size() - 1)
    } else {
      null
    }
  };

}
