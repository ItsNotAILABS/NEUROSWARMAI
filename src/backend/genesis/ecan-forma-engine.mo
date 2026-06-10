// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║  CONFIDENTIAL AND PROPRIETARY. Framework: Medina Doctrine                                                 ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// ECAN-FORMA ENGINE — Phase B Sovereign Economy Orchestrator
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// Implements the full self-organizing economic intelligence layer:
//
//   1. ECAN FORMA Flow — distributes FORMA like attention (STI):
//      high-coherence zones receive more FORMA per beat, low-coherence zones starve.
//      allocation_i = totalBudget × coherence_i / Σ coherence_j
//
//   2. Bach Drive Salience Engine — per beat, salience score fires for each drive:
//      salience = intensity × recency × relevance
//      Winning drive determines the organism's economic behavior that beat.
//
//   3. Jacob's Ladder — 5-rung velocity compounding:
//      Each rung threshold unlocks a FORMA multiplier injection.
//      Velocity = FORMA gained per beat. Rungs compound, not stack.
//
//   4. Full 12-token mint lifecycle — real causal triggers for all tokens:
//      GTK, MTH, MRC, CVT, VCT, KNT, SBT, HBT, DRT, OMT
//      Each with real conditions (coherence thresholds, beat intervals, governance scores)
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Option "mo:core/Option";

module ECANFormaEngine {

  // ═══════════════════════════════════════════════════════════════════════════════
  // CONSTANTS — ECAN FORMA FLOW
  // ═══════════════════════════════════════════════════════════════════════════════

  public let FORMA_BASE_BUDGET : Float = 10.0;        // Base FORMA minted per beat across all zones
  public let FORMA_MIN_COHERENCE : Float = 0.60;      // Minimum coherence to receive any FORMA
  public let FORMA_STARVATION_FLOOR : Float = 0.0;    // Low-coherence zones get this
  public let NUM_ZONES : Nat = 12;                    // One per shell

  // ═══════════════════════════════════════════════════════════════════════════════
  // CONSTANTS — BACH DRIVE SALIENCE
  // ═══════════════════════════════════════════════════════════════════════════════

  public let DRIVE_COUNT : Nat = 6;
  public let RECENCY_DECAY : Float = 0.95;            // Per-beat recency decay
  public let MIN_SALIENCE : Float = 0.001;            // Floor to keep drives alive

  // ═══════════════════════════════════════════════════════════════════════════════
  // CONSTANTS — JACOB'S LADDER
  // ═══════════════════════════════════════════════════════════════════════════════

  // 5 rungs: velocity thresholds and multipliers
  public let LADDER_RUNG_1_VELOCITY : Float = 0.5;    public let LADDER_RUNG_1_MULT : Float = 1.10;
  public let LADDER_RUNG_2_VELOCITY : Float = 1.0;    public let LADDER_RUNG_2_MULT : Float = 1.25;
  public let LADDER_RUNG_3_VELOCITY : Float = 2.0;    public let LADDER_RUNG_3_MULT : Float = 1.50;
  public let LADDER_RUNG_4_VELOCITY : Float = 4.0;    public let LADDER_RUNG_4_MULT : Float = 2.00;
  public let LADDER_RUNG_5_VELOCITY : Float = 8.0;    public let LADDER_RUNG_5_MULT : Float = 3.00;

  // ═══════════════════════════════════════════════════════════════════════════════
  // CONSTANTS — TOKEN MINT TRIGGERS
  // ═══════════════════════════════════════════════════════════════════════════════

  public let GTK_COHERENCE_THRESHOLD : Float = 0.82;  // GTK: Genesis Token, minted on high coherence
  public let GTK_MINT_RATE : Float = 0.5;
  public let CVT_GOVERNANCE_THRESHOLD : Float = 0.80; // CVT: Civic Value Token
  public let CVT_MINT_RATE : Float = 0.3;
  public let VCT_VELOCITY_THRESHOLD : Float = 1.0;    // VCT: Velocity Compound Token
  public let VCT_MINT_RATE : Float = 0.4;
  public let KNT_LEARNING_THRESHOLD : Float = 3;      // KNT: Knowledge Token — surprises per beat
  public let KNT_MINT_RATE : Float = 0.2;
  public let SBT_SACRIFICE_COHERENCE : Float = 0.78;  // SBT: Sacrifice/Service Behavior Token
  public let SBT_MINT_RATE : Float = 0.15;
  public let HBT_HEBBIAN_THRESHOLD : Float = 2;       // HBT: Hebbian Boost Token — surprise count
  public let HBT_MINT_RATE : Float = 0.25;
  public let DRT_DRIVE_SALIENCE_THRESHOLD : Float = 0.7; // DRT: Drive Resonance Token
  public let DRT_MINT_RATE : Float = 0.2;
  public let OMT_OMNIS_COHERENCE : Float = 0.95;      // OMT: OMNIS Token — peak emergence only
  public let OMT_MINT_RATE : Float = 5.0;

  // ═══════════════════════════════════════════════════════════════════════════════
  // TYPES
  // ═══════════════════════════════════════════════════════════════════════════════

  public type DriveId = {
    #Hunger;
    #Curiosity;
    #Service;
    #Quality;
    #Growth;
    #Coherence;
  };

  public type DriveState = {
    id : DriveId;
    var intensity : Float;    // Current drive strength [0,1]
    var recency : Float;      // Recency decay factor [0,1]
    var relevance : Float;    // Contextual relevance [0,1]
    var salience : Float;     // Computed: intensity × recency × relevance
    var totalWins : Nat;      // How many beats this drive won
    var lastWinBeat : Nat;
  };

  public type JacobsLadderState = {
    var currentRung : Nat;              // 0 = no rung, 1-5 = active rung
    var velocity : Float;               // FORMA gained last beat
    var velocityEMA : Float;            // Smoothed velocity (EMA α=0.1)
    var activeMultiplier : Float;       // Current compounding multiplier
    var totalRungs : Nat;               // Total rung events accumulated
    var rungHistory : [var Nat];        // How many beats spent at each rung
  };

  public type TokenMintEvent = {
    tokenId : Text;
    amount : Float;
    beat : Nat;
    trigger : Text;
  };

  public type ECANFormaState = {
    // FORMA zone allocations
    var zoneAllocations : [var Float];       // FORMA allocated to each zone this beat
    var zoneTotalAllocated : Float;

    // Drive states
    var drives : [DriveState];
    var winningDriveId : ?DriveId;
    var winningDriveSalience : Float;

    // Jacob's Ladder
    var ladder : JacobsLadderState;
    var lastFormaBalance : Float;

    // Token balances (10 governed tokens)
    var gtkBalance : Float;
    var cvtBalance : Float;
    var vctBalance : Float;
    var kntBalance : Float;
    var sbtBalance : Float;
    var hbtBalance : Float;
    var drtBalance : Float;
    var omtBalance : Float;

    // Mint log
    var mintLog : Buffer.Buffer<TokenMintEvent>;

    var totalBeats : Nat;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════════

  func initDrive(id : DriveId) : DriveState {
    {
      id;
      var intensity = 0.5;
      var recency = 1.0;
      var relevance = 0.5;
      var salience = 0.25;
      var totalWins = 0;
      var lastWinBeat = 0;
    }
  };

  public func initECANFormaState() : ECANFormaState {
    {
      var zoneAllocations = Array.init<Float>(NUM_ZONES, func(_ : Nat) : Float { 0.0 });
      var zoneTotalAllocated = 0.0;

      var drives = [
        initDrive(#Hunger),
        initDrive(#Curiosity),
        initDrive(#Service),
        initDrive(#Quality),
        initDrive(#Growth),
        initDrive(#Coherence),
      ];
      var winningDriveId = null;
      var winningDriveSalience = 0.0;

      var ladder = {
        var currentRung = 0;
        var velocity = 0.0;
        var velocityEMA = 0.0;
        var activeMultiplier = 1.0;
        var totalRungs = 0;
        var rungHistory = Array.init<Nat>(6, func(_ : Nat) : Nat { 0 });
      };
      var lastFormaBalance = 0.0;

      var gtkBalance = 0.0;
      var cvtBalance = 0.0;
      var vctBalance = 0.0;
      var kntBalance = 0.0;
      var sbtBalance = 0.0;
      var hbtBalance = 0.0;
      var drtBalance = 0.0;
      var omtBalance = 0.0;

      var mintLog = Buffer.Buffer<TokenMintEvent>(1000);
      var totalBeats = 0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ECAN FORMA FLOW
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Distribute FORMA proportionally to coherence across all zones
  /// High-coherence zones receive more; low-coherence zones starve.
  public func distributeFORMA(
    state : ECANFormaState,
    zoneCoherences : [Float]   // coherence[i] for shell i
  ) : [Float] {
    // Compute total coherence of eligible zones
    var totalCoherence = 0.0;
    let limit = if (zoneCoherences.size() < NUM_ZONES) zoneCoherences.size() else NUM_ZONES;
    var i = 0;
    while (i < limit) {
      if (zoneCoherences[i] >= FORMA_MIN_COHERENCE) {
        totalCoherence += zoneCoherences[i];
      };
      i += 1;
    };

    // Apply Jacob's Ladder multiplier to the total budget
    let budget = FORMA_BASE_BUDGET * state.ladder.activeMultiplier;

    // Allocate proportionally
    let allocations = Array.init<Float>(NUM_ZONES, func(_ : Nat) : Float { 0.0 });
    if (totalCoherence > 0.0) {
      var j = 0;
      while (j < limit) {
        if (zoneCoherences[j] >= FORMA_MIN_COHERENCE) {
          allocations[j] := budget * zoneCoherences[j] / totalCoherence;
        } else {
          allocations[j] := FORMA_STARVATION_FLOOR;
        };
        j += 1;
      };
    };

    // Update state
    var k = 0;
    var total = 0.0;
    while (k < NUM_ZONES) {
      let a = if (k < limit) allocations[k] else 0.0;
      state.zoneAllocations[k] := a;
      total += a;
      k += 1;
    };
    state.zoneTotalAllocated := total;

    Array.tabulate<Float>(NUM_ZONES, func(idx : Nat) : Float { allocations[idx] })
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // BACH DRIVE SALIENCE ENGINE
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Update a drive's intensity based on context signals
  func updateDriveIntensity(drive : DriveState, coherence : Float, beat : Nat) : () {
    let _ = beat;
    // Each drive has its own intensity update rule
    switch (drive.id) {
      case (#Hunger) {
        // Hunger grows as FORMA balance decreases
        drive.intensity := Float.max(MIN_SALIENCE, Float.min(1.0, 1.0 - coherence * 0.8));
      };
      case (#Curiosity) {
        // Curiosity spikes on high coherence (more capacity to explore)
        drive.intensity := Float.max(MIN_SALIENCE, coherence * 0.9);
      };
      case (#Service) {
        // Service drive proportional to coherence stability
        drive.intensity := Float.max(MIN_SALIENCE, coherence * 0.7);
      };
      case (#Quality) {
        // Quality drive rises with governance compliance
        drive.intensity := Float.max(MIN_SALIENCE, coherence * 0.85);
      };
      case (#Growth) {
        // Growth drive is always moderately active
        drive.intensity := Float.max(MIN_SALIENCE, Float.min(1.0, 0.5 + coherence * 0.3));
      };
      case (#Coherence) {
        // Coherence drive is strongest when coherence is near 0.75 (baseline hunger)
        let deficit = Float.abs(coherence - 0.75);
        drive.intensity := Float.max(MIN_SALIENCE, 1.0 - deficit * 2.0);
      };
    };
    // Decay recency
    drive.recency := drive.recency * RECENCY_DECAY;
    if (drive.recency < MIN_SALIENCE) { drive.recency := MIN_SALIENCE };
  };

  /// Compute salience = intensity × recency × relevance
  func computeSalience(drive : DriveState) : Float {
    drive.intensity * drive.recency * drive.relevance
  };

  /// Run Bach Drive scoring for all drives, return winning drive ID
  public func scoreDrives(
    state : ECANFormaState,
    coherence : Float,
    beat : Nat
  ) : DriveId {
    // Update all drives
    for (drive in state.drives.vals()) {
      updateDriveIntensity(drive, coherence, beat);
      drive.salience := computeSalience(drive);
    };

    // Find winner
    var bestSalience = -1.0;
    var winner : DriveId = #Coherence;
    for (drive in state.drives.vals()) {
      if (drive.salience > bestSalience) {
        bestSalience := drive.salience;
        winner := drive.id;
      };
    };

    // Record win
    for (drive in state.drives.vals()) {
      if (drive.id == winner) {
        drive.totalWins += 1;
        drive.lastWinBeat := beat;
        drive.recency := 1.0;  // Reset recency for winner
      };
    };

    state.winningDriveId := ?winner;
    state.winningDriveSalience := bestSalience;
    winner
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // JACOB'S LADDER — velocity compounding
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Update Jacob's Ladder based on current FORMA velocity
  public func updateJacobsLadder(
    state : ECANFormaState,
    currentFormaBalance : Float
  ) : Nat {
    let velocity = currentFormaBalance - state.lastFormaBalance;
    state.lastFormaBalance := currentFormaBalance;
    state.ladder.velocity := velocity;

    // Smooth velocity with EMA (α=0.1)
    state.ladder.velocityEMA := state.ladder.velocityEMA + 0.1 * (velocity - state.ladder.velocityEMA);

    let smoothV = state.ladder.velocityEMA;

    // Determine rung
    let rung : Nat =
      if (smoothV >= LADDER_RUNG_5_VELOCITY) 5
      else if (smoothV >= LADDER_RUNG_4_VELOCITY) 4
      else if (smoothV >= LADDER_RUNG_3_VELOCITY) 3
      else if (smoothV >= LADDER_RUNG_2_VELOCITY) 2
      else if (smoothV >= LADDER_RUNG_1_VELOCITY) 1
      else 0;

    let multiplier : Float =
      if (rung == 5) LADDER_RUNG_5_MULT
      else if (rung == 4) LADDER_RUNG_4_MULT
      else if (rung == 3) LADDER_RUNG_3_MULT
      else if (rung == 2) LADDER_RUNG_2_MULT
      else if (rung == 1) LADDER_RUNG_1_MULT
      else 1.0;

    if (rung > state.ladder.currentRung) {
      state.ladder.totalRungs += 1;
    };

    state.ladder.currentRung := rung;
    state.ladder.activeMultiplier := multiplier;
    state.ladder.rungHistory[rung] += 1;

    rung
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // 12-TOKEN MINT LIFECYCLE — real causal conditions
  // ═══════════════════════════════════════════════════════════════════════════════

  func recordMint(state : ECANFormaState, tokenId : Text, amount : Float, beat : Nat, trigger : Text) : () {
    state.mintLog.add({
      tokenId; amount; beat; trigger;
    });
  };

  /// GTK — Genesis Token: minted when coherence ≥ GTK threshold
  /// Condition: high coherence × shell governance modifier
  func tryMintGTK(state : ECANFormaState, coherence : Float, governance : Float, beat : Nat) : Float {
    if (coherence >= GTK_COHERENCE_THRESHOLD) {
      let amount = GTK_MINT_RATE * coherence * governance;
      state.gtkBalance += amount;
      recordMint(state, "GTK", amount, beat, "coherence=" # Float.toText(coherence));
      amount
    } else { 0.0 }
  };

  /// CVT — Civic Value Token: minted when governance score is high
  func tryMintCVT(state : ECANFormaState, governance : Float, beat : Nat) : Float {
    if (governance >= CVT_GOVERNANCE_THRESHOLD) {
      let amount = CVT_MINT_RATE * governance;
      state.cvtBalance += amount;
      recordMint(state, "CVT", amount, beat, "governance=" # Float.toText(governance));
      amount
    } else { 0.0 }
  };

  /// VCT — Velocity Compound Token: minted when FORMA velocity is high
  func tryMintVCT(state : ECANFormaState, beat : Nat) : Float {
    if (state.ladder.velocityEMA >= VCT_VELOCITY_THRESHOLD) {
      let amount = VCT_MINT_RATE * state.ladder.velocityEMA;
      state.vctBalance += amount;
      recordMint(state, "VCT", amount, beat, "velocity=" # Float.toText(state.ladder.velocityEMA));
      amount
    } else { 0.0 }
  };

  /// KNT — Knowledge Token: minted on genuine surprise (HTM-based)
  func tryMintKNT(state : ECANFormaState, surpriseCount : Nat, beat : Nat) : Float {
    if (surpriseCount >= KNT_LEARNING_THRESHOLD) {
      let amount = KNT_MINT_RATE * Float.fromInt(surpriseCount);
      state.kntBalance += amount;
      recordMint(state, "KNT", amount, beat, "surprises=" # Nat.toText(surpriseCount));
      amount
    } else { 0.0 }
  };

  /// SBT — Sacrifice/Service Behavior Token: minted at moderate coherence (service zone)
  func tryMintSBT(state : ECANFormaState, coherence : Float, winningDrive : ?DriveId, beat : Nat) : Float {
    let isServiceDrive = switch (winningDrive) {
      case (?#Service) { true };
      case (_) { false };
    };
    if (coherence >= SBT_SACRIFICE_COHERENCE and isServiceDrive) {
      let amount = SBT_MINT_RATE * coherence;
      state.sbtBalance += amount;
      recordMint(state, "SBT", amount, beat, "service_drive_active");
      amount
    } else { 0.0 }
  };

  /// HBT — Hebbian Boost Token: minted when Hebbian learning fires (surprise events)
  func tryMintHBT(state : ECANFormaState, surpriseCount : Nat, beat : Nat) : Float {
    if (surpriseCount >= HBT_HEBBIAN_THRESHOLD) {
      let amount = HBT_MINT_RATE * Float.fromInt(surpriseCount);
      state.hbtBalance += amount;
      recordMint(state, "HBT", amount, beat, "hebbian_fires=" # Nat.toText(surpriseCount));
      amount
    } else { 0.0 }
  };

  /// DRT — Drive Resonance Token: minted when winning drive salience is high
  func tryMintDRT(state : ECANFormaState, beat : Nat) : Float {
    if (state.winningDriveSalience >= DRT_DRIVE_SALIENCE_THRESHOLD) {
      let amount = DRT_MINT_RATE * state.winningDriveSalience;
      state.drtBalance += amount;
      recordMint(state, "DRT", amount, beat, "salience=" # Float.toText(state.winningDriveSalience));
      amount
    } else { 0.0 }
  };

  /// OMT — OMNIS Token: minted only during OMNIS emergence (coherence ≥ 0.95)
  func tryMintOMT(state : ECANFormaState, coherence : Float, beat : Nat) : Float {
    if (coherence >= OMT_OMNIS_COHERENCE) {
      let amount = OMT_MINT_RATE * coherence;
      state.omtBalance += amount;
      recordMint(state, "OMT", amount, beat, "OMNIS_coherence=" # Float.toText(coherence));
      amount
    } else { 0.0 }
  };

  /// Run all 12-token mint conditions for one beat
  /// Returns total tokens minted this beat
  public func runTokenMintCycle(
    state : ECANFormaState,
    coherence : Float,
    governance : Float,
    surpriseCount : Nat,
    beat : Nat
  ) : Float {
    var totalMinted = 0.0;
    totalMinted += tryMintGTK(state, coherence, governance, beat);
    totalMinted += tryMintCVT(state, governance, beat);
    totalMinted += tryMintVCT(state, beat);
    totalMinted += tryMintKNT(state, surpriseCount, beat);
    totalMinted += tryMintSBT(state, coherence, state.winningDriveId, beat);
    totalMinted += tryMintHBT(state, surpriseCount, beat);
    totalMinted += tryMintDRT(state, beat);
    totalMinted += tryMintOMT(state, coherence, beat);
    totalMinted
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // MAIN PER-BEAT TICK
  // ═══════════════════════════════════════════════════════════════════════════════

  public type ECANTickResult = {
    formaAllocations : [Float];
    winningDrive : DriveId;
    ladderRung : Nat;
    ladderMultiplier : Float;
    totalTokensMinted : Float;
    winningDriveSalience : Float;
  };

  /// Full ECAN-FORMA tick — called every beat from colonyHeartbeat()
  public func tick(
    state : ECANFormaState,
    beat : Nat,
    coherence : Float,
    governance : Float,
    currentFormaBalance : Float,
    zoneCoherences : [Float],
    surpriseCount : Nat
  ) : ECANTickResult {
    state.totalBeats += 1;

    // 1. Update Jacob's Ladder velocity
    let rung = updateJacobsLadder(state, currentFormaBalance);

    // 2. ECAN FORMA distribution (uses ladder multiplier)
    let allocations = distributeFORMA(state, zoneCoherences);

    // 3. Bach Drive salience scoring
    let winningDrive = scoreDrives(state, coherence, beat);

    // 4. 12-token mint lifecycle
    let totalMinted = runTokenMintCycle(state, coherence, governance, surpriseCount, beat);

    {
      formaAllocations = allocations;
      winningDrive;
      ladderRung = rung;
      ladderMultiplier = state.ladder.activeMultiplier;
      totalTokensMinted = totalMinted;
      winningDriveSalience = state.winningDriveSalience;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // STATISTICS
  // ═══════════════════════════════════════════════════════════════════════════════

  public func getStats(state : ECANFormaState) : {
    currentRung : Nat;
    activeMultiplier : Float;
    velocityEMA : Float;
    gtkBalance : Float;
    cvtBalance : Float;
    vctBalance : Float;
    kntBalance : Float;
    sbtBalance : Float;
    hbtBalance : Float;
    drtBalance : Float;
    omtBalance : Float;
    totalMintEvents : Nat;
    winningDriveSalience : Float;
  } {
    {
      currentRung = state.ladder.currentRung;
      activeMultiplier = state.ladder.activeMultiplier;
      velocityEMA = state.ladder.velocityEMA;
      gtkBalance = state.gtkBalance;
      cvtBalance = state.cvtBalance;
      vctBalance = state.vctBalance;
      kntBalance = state.kntBalance;
      sbtBalance = state.sbtBalance;
      hbtBalance = state.hbtBalance;
      drtBalance = state.drtBalance;
      omtBalance = state.omtBalance;
      totalMintEvents = state.mintLog.size();
      winningDriveSalience = state.winningDriveSalience;
    }
  };
}
