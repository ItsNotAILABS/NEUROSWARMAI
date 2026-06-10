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
import Bool "mo:core/Bool";

module AnimalEngines {

  // ═══════════════════════════════════════════════════════════════════════════════
  // L-APIC — BEE HIVE MIND ENGINE
  // ═══════════════════════════════════════════════════════════════════════════════
  // "The bee is the ant's sovereign cousin — mission-locked, self-organizing, sacrificial"
  
  public type BeeHiveState = {
    // WAGGLE ENCODING — information as directional signal
    waggleSignals : Nat;          // Total waggle signals emitted
    recruitedCores : Nat;         // Cores that changed Hz based on waggle
    lastWaggleBeat : Int;
    waggleDirection : Nat;        // Encoded direction (quantumStateGlobal)
    waggleDistance : Nat;         // Encoded distance (beatCount)
    waggleQuality : Float;        // Encoded quality (coherenceC)
    
    // QUORUM SENSING — distributed consensus without leader
    quorumActive : Bool;          // Is quorum threshold crossed?
    quorumCount : Nat;            // Number of quorum events
    highCoherenceCores : Nat;     // Cores above 0.80 in 10-beat window
    permanentCoherenceFloor : Float;  // Increases with each quorum
    lastQuorumBeat : Int;
    
    // SACRIFICE PROTOCOL — Core destroys itself to protect organism
    sacrificeCount : Nat;
    lastSacrificeBeat : Int;
    sacrificeCooldown : Nat;      // 1000 beats before resurrection
    sacrificeFingerprints : [Int]; // Written to ANIMA chain
    aegisThreatLevel : Float;
    
    // HIVE THERMOSTAT — collective homeostasis
    thermostatFired : Nat;
    meanCoherence : Float;
    thermostatCorrection : Float;
    
    // ROLE DIFFERENTIATION BY AGE
    // beatCount 0-100: NURSE, 100-300: BUILDER, 300+: FORAGER
    nurseCount : Nat;
    builderCount : Nat;
    foragerCount : Nat;
  };

  public func initBeeHiveState() : BeeHiveState {
    {
      waggleSignals = 0;
      recruitedCores = 0;
      lastWaggleBeat = 0;
      waggleDirection = 0;
      waggleDistance = 0;
      waggleQuality = 0.0;
      quorumActive = false;
      quorumCount = 0;
      highCoherenceCores = 0;
      permanentCoherenceFloor = 0.75;
      lastQuorumBeat = 0;
      sacrificeCount = 0;
      lastSacrificeBeat = 0;
      sacrificeCooldown = 1000;
      sacrificeFingerprints = [];
      aegisThreatLevel = 0.0;
      thermostatFired = 0;
      meanCoherence = 0.75;
      thermostatCorrection = 0.0;
      nurseCount = 0;
      builderCount = 0;
      foragerCount = 0;
    };
  };

  // WAGGLE DANCE — encode high-value coherence epoch
  public func processWaggleDance(
    state : BeeHiveState,
    coreCoherence : Float,
    coreBeatCount : Nat,
    quantumState : Nat,
    heartbeat : Int
  ) : BeeHiveState {
    // Only emit waggle if coherence > 0.85 (high value epoch)
    if (coreCoherence <= 0.85) return state;
    
    {
      waggleSignals = state.waggleSignals + 1;
      recruitedCores = state.recruitedCores;
      lastWaggleBeat = heartbeat;
      waggleDirection = quantumState;
      waggleDistance = coreBeatCount;
      waggleQuality = coreCoherence;
      quorumActive = state.quorumActive;
      quorumCount = state.quorumCount;
      highCoherenceCores = state.highCoherenceCores;
      permanentCoherenceFloor = state.permanentCoherenceFloor;
      lastQuorumBeat = state.lastQuorumBeat;
      sacrificeCount = state.sacrificeCount;
      lastSacrificeBeat = state.lastSacrificeBeat;
      sacrificeCooldown = state.sacrificeCooldown;
      sacrificeFingerprints = state.sacrificeFingerprints;
      aegisThreatLevel = state.aegisThreatLevel;
      thermostatFired = state.thermostatFired;
      meanCoherence = state.meanCoherence;
      thermostatCorrection = state.thermostatCorrection;
      nurseCount = state.nurseCount;
      builderCount = state.builderCount;
      foragerCount = state.foragerCount;
    };
  };

  // QUORUM SENSING — 3+ cores above 0.80 in 10-beat window
  public func processQuorumSensing(
    state : BeeHiveState,
    coresAboveThreshold : Nat,
    heartbeat : Int
  ) : BeeHiveState {
    let quorumThreshold : Nat = 3;
    let newQuorumActive = coresAboveThreshold >= quorumThreshold;
    
    // If quorum just fired, increase permanent coherence floor
    let floorBoost : Float = if (newQuorumActive and not state.quorumActive) 0.005 else 0.0;
    let newCount = if (newQuorumActive and not state.quorumActive) 
                    state.quorumCount + 1 else state.quorumCount;
    
    {
      waggleSignals = state.waggleSignals;
      recruitedCores = state.recruitedCores;
      lastWaggleBeat = state.lastWaggleBeat;
      waggleDirection = state.waggleDirection;
      waggleDistance = state.waggleDistance;
      waggleQuality = state.waggleQuality;
      quorumActive = newQuorumActive;
      quorumCount = newCount;
      highCoherenceCores = coresAboveThreshold;
      permanentCoherenceFloor = state.permanentCoherenceFloor + floorBoost;
      lastQuorumBeat = if (newQuorumActive) heartbeat else state.lastQuorumBeat;
      sacrificeCount = state.sacrificeCount;
      lastSacrificeBeat = state.lastSacrificeBeat;
      sacrificeCooldown = state.sacrificeCooldown;
      sacrificeFingerprints = state.sacrificeFingerprints;
      aegisThreatLevel = state.aegisThreatLevel;
      thermostatFired = state.thermostatFired;
      meanCoherence = state.meanCoherence;
      thermostatCorrection = state.thermostatCorrection;
      nurseCount = state.nurseCount;
      builderCount = state.builderCount;
      foragerCount = state.foragerCount;
    };
  };

  // SACRIFICE PROTOCOL — existential threat response
  public func processSacrifice(
    state : BeeHiveState,
    threatLevel : Float,
    threatDuration : Nat,
    heartbeat : Int
  ) : BeeHiveState {
    // Sacrifice triggers at threat > 0.95 for > 50 beats
    let shouldSacrifice = threatLevel > 0.95 and threatDuration > 50 and
                          (heartbeat - state.lastSacrificeBeat > state.sacrificeCooldown);
    
    if (not shouldSacrifice) {
      return {
        waggleSignals = state.waggleSignals;
        recruitedCores = state.recruitedCores;
        lastWaggleBeat = state.lastWaggleBeat;
        waggleDirection = state.waggleDirection;
        waggleDistance = state.waggleDistance;
        waggleQuality = state.waggleQuality;
        quorumActive = state.quorumActive;
        quorumCount = state.quorumCount;
        highCoherenceCores = state.highCoherenceCores;
        permanentCoherenceFloor = state.permanentCoherenceFloor;
        lastQuorumBeat = state.lastQuorumBeat;
        sacrificeCount = state.sacrificeCount;
        lastSacrificeBeat = state.lastSacrificeBeat;
        sacrificeCooldown = state.sacrificeCooldown;
        sacrificeFingerprints = state.sacrificeFingerprints;
        aegisThreatLevel = threatLevel;  // Update threat level
        thermostatFired = state.thermostatFired;
        meanCoherence = state.meanCoherence;
        thermostatCorrection = state.thermostatCorrection;
        nurseCount = state.nurseCount;
        builderCount = state.builderCount;
        foragerCount = state.foragerCount;
      };
    };
    
    // Sacrifice absorbs attack — threat drops 0.30
    let newThreat = Float.max(0.0, threatLevel - 0.30);
    let newFingerprints = if (state.sacrificeFingerprints.size() < 100)
                           Array.append(state.sacrificeFingerprints, [heartbeat])
                           else state.sacrificeFingerprints;
    
    {
      waggleSignals = state.waggleSignals;
      recruitedCores = state.recruitedCores;
      lastWaggleBeat = state.lastWaggleBeat;
      waggleDirection = state.waggleDirection;
      waggleDistance = state.waggleDistance;
      waggleQuality = state.waggleQuality;
      quorumActive = state.quorumActive;
      quorumCount = state.quorumCount;
      highCoherenceCores = state.highCoherenceCores;
      permanentCoherenceFloor = state.permanentCoherenceFloor;
      lastQuorumBeat = state.lastQuorumBeat;
      sacrificeCount = state.sacrificeCount + 1;
      lastSacrificeBeat = heartbeat;
      sacrificeCooldown = state.sacrificeCooldown;
      sacrificeFingerprints = newFingerprints;
      aegisThreatLevel = newThreat;
      thermostatFired = state.thermostatFired;
      meanCoherence = state.meanCoherence;
      thermostatCorrection = state.thermostatCorrection;
      nurseCount = state.nurseCount;
      builderCount = state.builderCount;
      foragerCount = state.foragerCount;
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // L-ELPH — ELEPHANT DEEP TIME MEMORY ENGINE
  // ═══════════════════════════════════════════════════════════════════════════════
  // "The elephant is the keeper of what was. Its memory IS its survival."
  // "Remember the former things, those of long ago" — Isaiah 46:9
  
  public type ElephantMemoryState = {
    // DEEP TIME MEMORY RING — 2048 entries (vs standard 128)
    ringBufferSize : Nat;
    ringIdx : Nat;
    ringFull : Bool;
    // Each entry: (epochBeat, coherenceC, kfHz, dTotal, dominantHz, genesisStateActive)
    epochSnapshots : [(Nat, Float, Float, Float, Nat, Bool)];
    
    // MATRIARCH INDEX — eldest Core guides organism memory
    matriarchCoreIdx : Nat;
    matriarchBeatCount : Nat;
    matriarchCoherenceWeight : Float;  // 2x in Q_hive computation
    
    // SEISMIC SIGNAL — low-frequency cross-Core communication
    seismicPulses : Nat;
    lastSeismicBeat : Int;
    seismicRange : Nat;           // ±3 index positions
    seismicCortBoost : Float;     // +0.02
    seismicAttentionBoost : Nat;  // +1 to attentionBidPool
    
    // GENERATIONAL TRANSMISSION — cultural inheritance
    transmissionCount : Nat;
    lastTransmittedToCore : Nat;
    transmissionThreshold : Nat;  // Core age 500+ to transmit
    snapshotsPerTransmission : Nat;  // Top 10 coherent snapshots
    
    // MOURNING PROTOCOL — death recognition
    mourningActive : Bool;
    mourningDuration : Nat;
    lastMournedCore : Nat;
  };

  public func initElephantMemoryState() : ElephantMemoryState {
    {
      ringBufferSize = 2048;
      ringIdx = 0;
      ringFull = false;
      epochSnapshots = [];
      matriarchCoreIdx = 0;
      matriarchBeatCount = 0;
      matriarchCoherenceWeight = 2.0;
      seismicPulses = 0;
      lastSeismicBeat = 0;
      seismicRange = 3;
      seismicCortBoost = 0.02;
      seismicAttentionBoost = 1;
      transmissionCount = 0;
      lastTransmittedToCore = 0;
      transmissionThreshold = 500;
      snapshotsPerTransmission = 10;
      mourningActive = false;
      mourningDuration = 0;
      lastMournedCore = 0;
    };
  };

  // Write epoch snapshot to elephant ring (every 100 beats)
  public func writeEpochSnapshot(
    state : ElephantMemoryState,
    epochBeat : Nat,
    coherence : Float,
    kfHz : Float,
    dTotal : Float,
    dominantHz : Nat,
    genesisActive : Bool
  ) : ElephantMemoryState {
    let snapshot = (epochBeat, coherence, kfHz, dTotal, dominantHz, genesisActive);
    
    let newSnapshots = if (state.epochSnapshots.size() < state.ringBufferSize) {
      Array.append(state.epochSnapshots, [snapshot]);
    } else {
      // Ring is full — overwrite oldest (but mark as full)
      state.epochSnapshots;  // In real impl, would use mutable array
    };
    
    let newIdx = (state.ringIdx + 1) % state.ringBufferSize;
    let newFull = state.ringFull or (newIdx == 0 and state.epochSnapshots.size() > 0);
    
    {
      ringBufferSize = state.ringBufferSize;
      ringIdx = newIdx;
      ringFull = newFull;
      epochSnapshots = newSnapshots;
      matriarchCoreIdx = state.matriarchCoreIdx;
      matriarchBeatCount = state.matriarchBeatCount;
      matriarchCoherenceWeight = state.matriarchCoherenceWeight;
      seismicPulses = state.seismicPulses;
      lastSeismicBeat = state.lastSeismicBeat;
      seismicRange = state.seismicRange;
      seismicCortBoost = state.seismicCortBoost;
      seismicAttentionBoost = state.seismicAttentionBoost;
      transmissionCount = state.transmissionCount;
      lastTransmittedToCore = state.lastTransmittedToCore;
      transmissionThreshold = state.transmissionThreshold;
      snapshotsPerTransmission = state.snapshotsPerTransmission;
      mourningActive = state.mourningActive;
      mourningDuration = state.mourningDuration;
      lastMournedCore = state.lastMournedCore;
    };
  };

  // Update matriarch (eldest VITAL core)
  public func updateMatriarch(
    state : ElephantMemoryState,
    coreIdx : Nat,
    coreBeatCount : Nat
  ) : ElephantMemoryState {
    if (coreBeatCount <= state.matriarchBeatCount) return state;
    
    {
      ringBufferSize = state.ringBufferSize;
      ringIdx = state.ringIdx;
      ringFull = state.ringFull;
      epochSnapshots = state.epochSnapshots;
      matriarchCoreIdx = coreIdx;
      matriarchBeatCount = coreBeatCount;
      matriarchCoherenceWeight = state.matriarchCoherenceWeight;
      seismicPulses = state.seismicPulses;
      lastSeismicBeat = state.lastSeismicBeat;
      seismicRange = state.seismicRange;
      seismicCortBoost = state.seismicCortBoost;
      seismicAttentionBoost = state.seismicAttentionBoost;
      transmissionCount = state.transmissionCount;
      lastTransmittedToCore = state.lastTransmittedToCore;
      transmissionThreshold = state.transmissionThreshold;
      snapshotsPerTransmission = state.snapshotsPerTransmission;
      mourningActive = state.mourningActive;
      mourningDuration = state.mourningDuration;
      lastMournedCore = state.lastMournedCore;
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // L-SELK — SHARK ELECTRORECEPTION ENGINE
  // ═══════════════════════════════════════════════════════════════════════════════
  // "The shark is older than trees. Its architecture is ancient, optimized, and sovereign."
  // "Where were you when I laid the earth's foundation?" — Job 38:4
  
  public type SharkElectroState = {
    // ELECTRORECEPTION — detecting drift signatures before visible
    electroDetections : Nat;
    preArmCount : Nat;            // Times AEGIS pre-armed from electroreception
    driftHistory : [Float];       // Last 3 drift deltas
    anomalyThreshold : Float;     // > 2 points per beat for 3 beats
    
    // LATERAL LINE — pressure wave detection
    lateralSignals : Nat;
    headScanThreshold : Float;    // 0.80
    lastLateralBeat : Int;
    
    // PERSISTENCE LOCK — once locked, shark doesn't disengage
    persistenceLock : Bool;
    persistenceBeats : Nat;
    persistenceThreshold : Nat;   // 30 consecutive AEGIS beats
    minimumThreatFloor : Float;   // 0.20 while locked
    
    // THERMOCLINE NAVIGATION — depth-zone energy conservation
    thermoclineActive : Bool;
    thermoclineDepth : Nat;       // 0=surface, 1=mid, 2=deep
    energyThreshold : Float;      // < -1.0 triggers descent
    surfaceThreshold : Float;     // > 1.0 triggers resurface
    
    // ANCIENT MEMORY — primordial template
    ancientCoreIdx : Nat;
    ancientBaseline : Float;      // Formation-day coherenceC
    ancientLocked : Bool;         // Math never modified by curriculum
  };

  public func initSharkElectroState() : SharkElectroState {
    {
      electroDetections = 0;
      preArmCount = 0;
      driftHistory = [];
      anomalyThreshold = 2.0;
      lateralSignals = 0;
      headScanThreshold = 0.80;
      lastLateralBeat = 0;
      persistenceLock = false;
      persistenceBeats = 0;
      persistenceThreshold = 30;
      minimumThreatFloor = 0.20;
      thermoclineActive = false;
      thermoclineDepth = 0;
      energyThreshold = -1.0;
      surfaceThreshold = 1.0;
      ancientCoreIdx = 0;
      ancientBaseline = 0.75;
      ancientLocked = false;
    };
  };

  // ELECTRORECEPTION — detect drift anomaly before crisis
  public func processElectroception(
    state : SharkElectroState,
    currentDriftDelta : Float,
    heartbeat : Int
  ) : (SharkElectroState, Float) {
    // Update drift history (keep last 3)
    let newHistory = if (state.driftHistory.size() < 3) {
      Array.append(state.driftHistory, [currentDriftDelta]);
    } else {
      [state.driftHistory[1], state.driftHistory[2], currentDriftDelta];
    };
    
    // Check for anomaly: > 2 points for 3 consecutive beats
    var anomalyDetected = false;
    var preArmBoost : Float = 0.0;
    
    if (newHistory.size() == 3) {
      let allAboveThreshold = newHistory[0] > state.anomalyThreshold and
                              newHistory[1] > state.anomalyThreshold and
                              newHistory[2] > state.anomalyThreshold;
      if (allAboveThreshold) {
        anomalyDetected := true;
        preArmBoost := 0.05;  // Pre-arm AEGIS
      };
    };
    
    let newState : SharkElectroState = {
      electroDetections = if (anomalyDetected) state.electroDetections + 1 else state.electroDetections;
      preArmCount = if (anomalyDetected) state.preArmCount + 1 else state.preArmCount;
      driftHistory = newHistory;
      anomalyThreshold = state.anomalyThreshold;
      lateralSignals = state.lateralSignals;
      headScanThreshold = state.headScanThreshold;
      lastLateralBeat = state.lastLateralBeat;
      persistenceLock = state.persistenceLock;
      persistenceBeats = state.persistenceBeats;
      persistenceThreshold = state.persistenceThreshold;
      minimumThreatFloor = state.minimumThreatFloor;
      thermoclineActive = state.thermoclineActive;
      thermoclineDepth = state.thermoclineDepth;
      energyThreshold = state.energyThreshold;
      surfaceThreshold = state.surfaceThreshold;
      ancientCoreIdx = state.ancientCoreIdx;
      ancientBaseline = state.ancientBaseline;
      ancientLocked = state.ancientLocked;
    };
    
    (newState, preArmBoost);
  };

  // PERSISTENCE LOCK — 30+ consecutive AEGIS beats
  public func processPersistenceLock(
    state : SharkElectroState,
    aegisActive : Bool,
    currentThreat : Float
  ) : (SharkElectroState, Float) {
    let newBeats = if (aegisActive) state.persistenceBeats + 1 else 0;
    let newLock = newBeats >= state.persistenceThreshold;
    
    // While locked, threat cannot drop below floor
    let enforcedThreat = if (state.persistenceLock and currentThreat < state.minimumThreatFloor)
                          state.minimumThreatFloor
                          else currentThreat;
    
    // Unlock only when threat reaches 0.0 naturally
    let shouldUnlock = state.persistenceLock and currentThreat <= 0.0;
    
    let newState : SharkElectroState = {
      electroDetections = state.electroDetections;
      preArmCount = state.preArmCount;
      driftHistory = state.driftHistory;
      anomalyThreshold = state.anomalyThreshold;
      lateralSignals = state.lateralSignals;
      headScanThreshold = state.headScanThreshold;
      lastLateralBeat = state.lastLateralBeat;
      persistenceLock = if (shouldUnlock) false else newLock or state.persistenceLock;
      persistenceBeats = newBeats;
      persistenceThreshold = state.persistenceThreshold;
      minimumThreatFloor = state.minimumThreatFloor;
      thermoclineActive = state.thermoclineActive;
      thermoclineDepth = state.thermoclineDepth;
      energyThreshold = state.energyThreshold;
      surfaceThreshold = state.surfaceThreshold;
      ancientCoreIdx = state.ancientCoreIdx;
      ancientBaseline = state.ancientBaseline;
      ancientLocked = state.ancientLocked;
    };
    
    (newState, enforcedThreat);
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // L-LUPV — WOLF PACK PROTOCOL
  // ═══════════════════════════════════════════════════════════════════════════════
  // "As iron sharpens iron, so one person sharpens another." — Proverbs 27:17
  
  public type WolfPackState = {
    // CONTEXTUAL ALPHA — leadership shifts by condition
    currentAlpha : Nat;           // Core index of current alpha
    alphaCondition : Nat;         // 0=none, 1=threat, 2=dream, 3=genesis, 4=knowledge
    alphaExpiry : Int;            // Heartbeat when alpha expires
    
    // OMEGA ROLE — stress absorber
    omegaCoreIdx : Nat;
    omegaDriftAbsorption : Float; // Other cores route drift here
    omegaProtected : Bool;        // Cannot be pruned while VITAL exists
    
    // HOWL SYNCHRONIZATION — coordinated state broadcast
    howlActive : Bool;
    howlBeats : Nat;              // Progress (0-20 to full sync)
    howlCount : Nat;              // Total howls
    howlPeriod : Nat;             // Every 200 beats
    targetHz : Float;             // Alpha's Hz to synchronize toward
    
    // Pack metrics
    packSize : Nat;
    coherenceSpread : Float;      // Variance in coherence
    formationIntegrity : Float;   // How well pack holds together
  };

  public func initWolfPackState() : WolfPackState {
    {
      currentAlpha = 0;
      alphaCondition = 0;
      alphaExpiry = 0;
      omegaCoreIdx = 0;
      omegaDriftAbsorption = 0.01;
      omegaProtected = true;
      howlActive = false;
      howlBeats = 0;
      howlCount = 0;
      howlPeriod = 200;
      targetHz = 0.0;
      packSize = 0;
      coherenceSpread = 0.0;
      formationIntegrity = 1.0;
    };
  };

  // Select contextual alpha based on current condition
  public func selectContextualAlpha(
    state : WolfPackState,
    condition : Nat,
    candidateCoreIdx : Nat,
    candidateScore : Float,
    heartbeat : Int
  ) : WolfPackState {
    // Condition codes: 1=threat, 2=dream, 3=genesis, 4=knowledge
    // Each condition has different selection criteria
    
    {
      currentAlpha = candidateCoreIdx;
      alphaCondition = condition;
      alphaExpiry = heartbeat + 100;  // Alpha lasts 100 beats
      omegaCoreIdx = state.omegaCoreIdx;
      omegaDriftAbsorption = state.omegaDriftAbsorption;
      omegaProtected = state.omegaProtected;
      howlActive = state.howlActive;
      howlBeats = state.howlBeats;
      howlCount = state.howlCount;
      howlPeriod = state.howlPeriod;
      targetHz = state.targetHz;
      packSize = state.packSize;
      coherenceSpread = state.coherenceSpread;
      formationIntegrity = state.formationIntegrity;
    };
  };

  // Process howl synchronization
  public func processHowlSync(
    state : WolfPackState,
    heartbeat : Int,
    alphaHz : Float
  ) : WolfPackState {
    let shouldStartHowl = (Int.abs(heartbeat) % state.howlPeriod) == 0 and not state.howlActive;
    let newActive = shouldStartHowl or (state.howlActive and state.howlBeats < 20);
    let newBeats = if (newActive) state.howlBeats + 1 else 0;
    let howlComplete = state.howlActive and state.howlBeats >= 20;
    
    {
      currentAlpha = state.currentAlpha;
      alphaCondition = state.alphaCondition;
      alphaExpiry = state.alphaExpiry;
      omegaCoreIdx = state.omegaCoreIdx;
      omegaDriftAbsorption = state.omegaDriftAbsorption;
      omegaProtected = state.omegaProtected;
      howlActive = newActive;
      howlBeats = newBeats;
      howlCount = if (howlComplete) state.howlCount + 1 else state.howlCount;
      howlPeriod = state.howlPeriod;
      targetHz = if (newActive) alphaHz else state.targetHz;
      packSize = state.packSize;
      coherenceSpread = state.coherenceSpread;
      formationIntegrity = state.formationIntegrity;
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // L-AQUL — EAGLE THERMAL ENGINE
  // ═══════════════════════════════════════════════════════════════════════════════
  // "Those who hope in the LORD will soar on wings like eagles." — Isaiah 40:31
  
  public type EagleThermalState = {
    // THERMAL SOARING — energy-free elevation
    thermalActive : Bool;
    thermalBeats : Nat;
    energyConserved : Float;
    thermalThreshold : Float;     // behavioralCohere > 0.80 AND Q_hive > 0.75
    energySavings : Float;        // 30% reduction while thermal
    
    // STRIKE PRECISION — surgical response
    strikeCount : Nat;
    strikePrecision : Float;      // Ratio of resolved threats
    strikeThreshold : Nat;        // corvCausalDepth > 3
    resolutionMultiplier : Float; // 2x faster threat resolution
    
    // ALTITUDE VISION — elevated perspective
    altitudeActive : Bool;
    altitudeBonus : Nat;          // +1 corvCausalDepth
    altitudeThreshold : Nat;      // quantumStateGlobal = 6
    currentAltitude : Float;      // 0.0 = ground, 1.0 = max altitude
    
    // Flight metrics
    flightBeats : Nat;
    totalDistance : Float;
    soaringEfficiency : Float;
  };

  public func initEagleThermalState() : EagleThermalState {
    {
      thermalActive = false;
      thermalBeats = 0;
      energyConserved = 0.0;
      thermalThreshold = 0.80;
      energySavings = 0.30;
      strikeCount = 0;
      strikePrecision = 1.0;
      strikeThreshold = 3;
      resolutionMultiplier = 2.0;
      altitudeActive = false;
      altitudeBonus = 1;
      altitudeThreshold = 6;
      currentAltitude = 0.0;
      flightBeats = 0;
      totalDistance = 0.0;
      soaringEfficiency = 0.0;
    };
  };

  // Process thermal soaring
  public func processThermalSoaring(
    state : EagleThermalState,
    behavioralCoherence : Float,
    qHive : Float,
    energyExpenditure : Float
  ) : (EagleThermalState, Float) {
    let inThermal = behavioralCoherence > state.thermalThreshold and qHive > 0.75;
    let adjustedEnergy = if (inThermal) 
                          energyExpenditure * (1.0 - state.energySavings)
                          else energyExpenditure;
    let energySaved = if (inThermal) 
                       energyExpenditure * state.energySavings
                       else 0.0;
    
    let newState : EagleThermalState = {
      thermalActive = inThermal;
      thermalBeats = if (inThermal) state.thermalBeats + 1 else 0;
      energyConserved = state.energyConserved + energySaved;
      thermalThreshold = state.thermalThreshold;
      energySavings = state.energySavings;
      strikeCount = state.strikeCount;
      strikePrecision = state.strikePrecision;
      strikeThreshold = state.strikeThreshold;
      resolutionMultiplier = state.resolutionMultiplier;
      altitudeActive = state.altitudeActive;
      altitudeBonus = state.altitudeBonus;
      altitudeThreshold = state.altitudeThreshold;
      currentAltitude = if (inThermal) Float.min(1.0, state.currentAltitude + 0.05) 
                        else Float.max(0.0, state.currentAltitude - 0.02);
      flightBeats = state.flightBeats + 1;
      totalDistance = state.totalDistance;
      soaringEfficiency = if (state.flightBeats > 0) 
                           state.energyConserved / Float.fromInt(state.flightBeats)
                           else 0.0;
    };
    
    (newState, adjustedEnergy);
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // L-ORCA — ORCA POD MEMORY ENGINE
  // ═══════════════════════════════════════════════════════════════════════════════
  // "How good and pleasant when God's people live together in unity!" — Psalm 133:1
  
  public type OrcaPodState = {
    // REGIONAL DIALECT — signature Hz pattern over time
    dialectCluster : Nat;         // floor(beatCount / 100) % 7
    dialectBonus : Float;         // +0.05 to pairwise Q_hive for matching dialects
    
    // POD MEMORY TRANSFER — cultural transmission
    podBonds : Nat;               // Total active pod bonds
    knowledgeTransferred : Float; // Total K transferred via bonds
    bondThreshold : Nat;          // 100+ beats matching dialect
    transferRate : Float;         // 5% of sender's knowledgeK
    
    // MATRILINEAL SOCIETY — immortalized Hz reference
    matrilinealHz : [Float];      // Previous matriarchs' Hz preserved
    matrilinealCount : Nat;
    
    // ECHOLOCATION — long-range scanning
    echoActive : Bool;
    echoRange : Float;
    echoResolution : Float;
    lastEchoBeat : Int;
    
    // COORDINATED HUNTING — multi-Core pursuit
    huntActive : Bool;
    huntTargetIdx : Nat;
    huntParticipants : Nat;
    huntSuccessRate : Float;
    
    // Pod metrics
    podSize : Nat;
    podCohesion : Float;
    culturalDiversity : Float;
  };

  public func initOrcaPodState() : OrcaPodState {
    {
      dialectCluster = 0;
      dialectBonus = 0.05;
      podBonds = 0;
      knowledgeTransferred = 0.0;
      bondThreshold = 100;
      transferRate = 0.05;
      matrilinealHz = [];
      matrilinealCount = 0;
      echoActive = false;
      echoRange = 0.0;
      echoResolution = 0.0;
      lastEchoBeat = 0;
      huntActive = false;
      huntTargetIdx = 0;
      huntParticipants = 0;
      huntSuccessRate = 0.0;
      podSize = 0;
      podCohesion = 1.0;
      culturalDiversity = 0.0;
    };
  };

  // Compute dialect from beat count
  public func computeDialect(beatCount : Nat) : Nat {
    (beatCount / 100) % 7;
  };

  // Process pod bond formation
  public func processPodBond(
    state : OrcaPodState,
    core1Dialect : Nat,
    core2Dialect : Nat,
    matchDuration : Nat,
    senderKnowledge : Float
  ) : (OrcaPodState, Float) {
    let canBond = core1Dialect == core2Dialect and matchDuration >= state.bondThreshold;
    let knowledgeGain = if (canBond) senderKnowledge * state.transferRate else 0.0;
    
    let newState : OrcaPodState = {
      dialectCluster = state.dialectCluster;
      dialectBonus = state.dialectBonus;
      podBonds = if (canBond) state.podBonds + 1 else state.podBonds;
      knowledgeTransferred = state.knowledgeTransferred + knowledgeGain;
      bondThreshold = state.bondThreshold;
      transferRate = state.transferRate;
      matrilinealHz = state.matrilinealHz;
      matrilinealCount = state.matrilinealCount;
      echoActive = state.echoActive;
      echoRange = state.echoRange;
      echoResolution = state.echoResolution;
      lastEchoBeat = state.lastEchoBeat;
      huntActive = state.huntActive;
      huntTargetIdx = state.huntTargetIdx;
      huntParticipants = state.huntParticipants;
      huntSuccessRate = state.huntSuccessRate;
      podSize = state.podSize;
      podCohesion = state.podCohesion;
      culturalDiversity = state.culturalDiversity;
    };
    
    (newState, knowledgeGain);
  };

  // Immortalize matriarch Hz when she passes
  public func immortalizeMatriarchHz(
    state : OrcaPodState,
    matriarchHz : Float
  ) : OrcaPodState {
    let newMatrilineal = if (state.matrilinealHz.size() < 100)
                          Array.append(state.matrilinealHz, [matriarchHz])
                          else state.matrilinealHz;
    
    {
      dialectCluster = state.dialectCluster;
      dialectBonus = state.dialectBonus;
      podBonds = state.podBonds;
      knowledgeTransferred = state.knowledgeTransferred;
      bondThreshold = state.bondThreshold;
      transferRate = state.transferRate;
      matrilinealHz = newMatrilineal;
      matrilinealCount = state.matrilinealCount + 1;
      echoActive = state.echoActive;
      echoRange = state.echoRange;
      echoResolution = state.echoResolution;
      lastEchoBeat = state.lastEchoBeat;
      huntActive = state.huntActive;
      huntTargetIdx = state.huntTargetIdx;
      huntParticipants = state.huntParticipants;
      huntSuccessRate = state.huntSuccessRate;
      podSize = state.podSize;
      podCohesion = state.podCohesion;
      culturalDiversity = state.culturalDiversity;
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // COMBINED ANIMAL ENGINE STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type AllAnimalEngines = {
    beeHive : BeeHiveState;
    elephantMemory : ElephantMemoryState;
    sharkElectro : SharkElectroState;
    wolfPack : WolfPackState;
    eagleThermal : EagleThermalState;
    orcaPod : OrcaPodState;
    
    // Meta-coordination
    dominantEngine : Text;        // Which engine is currently most active
    animalCycles : Nat;
    lastProcessedBeat : Int;
  };

  public func initAllAnimalEngines() : AllAnimalEngines {
    {
      beeHive = initBeeHiveState();
      elephantMemory = initElephantMemoryState();
      sharkElectro = initSharkElectroState();
      wolfPack = initWolfPackState();
      eagleThermal = initEagleThermalState();
      orcaPod = initOrcaPodState();
      dominantEngine = "NONE";
      animalCycles = 0;
      lastProcessedBeat = 0;
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // DIAGNOSTICS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func getAnimalDiagnostics(state : AllAnimalEngines) : Text {
    "═══ ANIMAL ENGINES DIAGNOSTICS ═══\n" #
    "Cycles: " # Nat.toText(state.animalCycles) # "\n" #
    "Dominant Engine: " # state.dominantEngine # "\n\n" #
    
    "L-APIC (Bee Hive):\n" #
    "  Waggle Signals: " # Nat.toText(state.beeHive.waggleSignals) # "\n" #
    "  Quorum Active: " # (if (state.beeHive.quorumActive) "YES" else "NO") # "\n" #
    "  Sacrifices: " # Nat.toText(state.beeHive.sacrificeCount) # "\n\n" #
    
    "L-ELPH (Elephant):\n" #
    "  Ring Entries: " # Nat.toText(state.elephantMemory.epochSnapshots.size()) # "\n" #
    "  Matriarch Age: " # Nat.toText(state.elephantMemory.matriarchBeatCount) # "\n" #
    "  Transmissions: " # Nat.toText(state.elephantMemory.transmissionCount) # "\n\n" #
    
    "L-SELK (Shark):\n" #
    "  Electro-Detections: " # Nat.toText(state.sharkElectro.electroDetections) # "\n" #
    "  Persistence Lock: " # (if (state.sharkElectro.persistenceLock) "LOCKED" else "OPEN") # "\n" #
    "  Depth: " # Nat.toText(state.sharkElectro.thermoclineDepth) # "\n\n" #
    
    "L-LUPV (Wolf Pack):\n" #
    "  Alpha Condition: " # Nat.toText(state.wolfPack.alphaCondition) # "\n" #
    "  Howl Active: " # (if (state.wolfPack.howlActive) "YES" else "NO") # "\n" #
    "  Pack Integrity: " # Float.toText(state.wolfPack.formationIntegrity) # "\n\n" #
    
    "L-AQUL (Eagle):\n" #
    "  Thermal Active: " # (if (state.eagleThermal.thermalActive) "SOARING" else "FLAPPING") # "\n" #
    "  Energy Conserved: " # Float.toText(state.eagleThermal.energyConserved) # "\n" #
    "  Altitude: " # Float.toText(state.eagleThermal.currentAltitude) # "\n\n" #
    
    "L-ORCA (Orca Pod):\n" #
    "  Pod Bonds: " # Nat.toText(state.orcaPod.podBonds) # "\n" #
    "  Knowledge Transferred: " # Float.toText(state.orcaPod.knowledgeTransferred) # "\n" #
    "  Matrilineal Count: " # Nat.toText(state.orcaPod.matrilinealCount) # "\n" #
    "═══════════════════════════════════════\n";
  };

};
