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

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// CHRONO GENESIS ANCHOR — IMMUTABLE TEMPORAL LOCK FOR ALL GENESIS LAW VALUES
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// CHRONO GENESIS ANCHOR is the immutable temporal substrate that stores:
//
// CHRONO (immutable anchor)
//   ├── genesis formation hash
//   ├── genesis law compliance scores [one per system]
//   ├── genesis Merkle roots [VERITAS, AEGIS, GENOME]
//   └── timestamp (principal-gated, immutable)
//
// Every canister heartbeat:
//   ├── compute L_live(system_i)
//   ├── δ_drift = |L_live - L_genesis|
//   ├── if δ_drift > ε_i → law violation → cascade fires
//   └── compliance score reported to BRAIN (numeric only)
//
// THE CORE MECHANISM:
// ─────────────────────
// At genesis, for each system, you compute:
//   L_genesis(system_i) = lawFunction(state_i at formation)
//
// That value gets locked in CHRONO alongside the formation hash.
// It is immutable, principal-gated, and timestamped.
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Nat8 "mo:core/Nat8";
import Nat32 "mo:core/Nat32";
import Nat64 "mo:core/Nat64";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Iter "mo:core/Iter";
import Text "mo:core/Text";
import Time "mo:core/Time";
import Option "mo:core/Option";
import Bool "mo:core/Bool";
import Blob "mo:core/Blob";

module ChronoGenesisAnchor {

  // ═══════════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let NUM_SYSTEMS : Nat = 13;
  public let ANCHOR_VERSION : Nat = 1;
  public let SIGNATURE_LENGTH : Nat = 64;

  // ═══════════════════════════════════════════════════════════════════════════════
  // SYSTEM IDENTIFIERS — All 13 drift-gated systems
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// SystemId identifies which system
  public type SystemId = {
    #BRAIN;
    #QUANTUM;
    #MEMORIA;
    #NEUROCHEM;
    #SUBSTRATE;
    #SIMULACRUM;
    #CORTEX;
    #GENOME;
    #SOCIO;
    #VERITAS;
    #AEGIS;
    #WALLET;
    #BEHAVIORAL;
  };
  
  /// Get system name
  public func getSystemName(id : SystemId) : Text {
    switch (id) {
      case (#BRAIN) { "BRAIN" };
      case (#QUANTUM) { "QUANTUM" };
      case (#MEMORIA) { "MEMORIA" };
      case (#NEUROCHEM) { "NEUROCHEM" };
      case (#SUBSTRATE) { "SUBSTRATE" };
      case (#SIMULACRUM) { "SIMULACRUM" };
      case (#CORTEX) { "CORTEX" };
      case (#GENOME) { "GENOME" };
      case (#SOCIO) { "SOCIO" };
      case (#VERITAS) { "VERITAS" };
      case (#AEGIS) { "AEGIS" };
      case (#WALLET) { "WALLET" };
      case (#BEHAVIORAL) { "BEHAVIORAL" };
    }
  };
  
  /// Get all system IDs
  public func getAllSystemIds() : [SystemId] {
    [#BRAIN, #QUANTUM, #MEMORIA, #NEUROCHEM, #SUBSTRATE, #SIMULACRUM, 
     #CORTEX, #GENOME, #SOCIO, #VERITAS, #AEGIS, #WALLET, #BEHAVIORAL]
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // GENESIS LAW VALUE — L_genesis for one system
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// GenesisLawValue stores L_genesis(system_i) = lawFunction(state_i at formation)
  public type GenesisLawValue = {
    /// System ID
    systemId : SystemId;
    
    /// System name
    systemName : Text;
    
    /// L_genesis: the law function output at formation
    lawGenesisValue : Float;
    
    /// Genesis state vector (system-specific representation)
    genesisStateVector : [Float];
    
    /// Genesis state hash
    genesisStateHash : Nat32;
    
    /// Drift threshold ε_i for this system
    epsilon : Float;
    
    /// Critical threshold
    epsilonCritical : Float;
    
    /// Catastrophic threshold
    epsilonCatastrophic : Float;
    
    /// Weight in aggregate calculation
    weight : Float;
    
    /// Correction type for this system
    correctionType : Text;
    
    /// Is this value locked?
    isLocked : Bool;
    
    /// Lock timestamp
    lockTimestamp : Int;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // MERKLE ROOT — For critical systems (VERITAS, AEGIS, GENOME)
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// MerkleRoot for critical system integrity
  public type GenesisMerkleRoot = {
    /// System ID
    systemId : SystemId;
    
    /// System name
    systemName : Text;
    
    /// Genesis Merkle root hash
    merkleRoot : Nat32;
    
    /// Number of entries at genesis
    entryCount : Nat;
    
    /// Entry hashes (first 32 only, for audit)
    sampleEntryHashes : [Nat32];
    
    /// Is Merkle root locked?
    isLocked : Bool;
    
    /// Lock timestamp
    lockTimestamp : Int;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // FORMATION HASH — Unique organism identifier
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// FormationHash uniquely identifies the organism at genesis
  public type FormationHash = {
    /// Primary formation hash
    primaryHash : Nat32;
    
    /// Secondary hash (backup verification)
    secondaryHash : Nat32;
    
    /// Formation timestamp
    formationTimestamp : Int;
    
    /// Formation heartbeat
    formationHeartbeat : Nat;
    
    /// Creator principal
    creatorPrincipal : Text;
    
    /// Organism ID
    organismId : Text;
    
    /// Version
    version : Nat;
    
    /// Is formation complete?
    isFormationComplete : Bool;
    
    /// Formation signature
    formationSignature : [Nat8];
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // COMPLETE CHRONO GENESIS ANCHOR
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// ChronoGenesisAnchor is the complete immutable temporal lock
  public type ChronoGenesisAnchorState = {
    /// Formation hash (unique organism identifier)
    formationHash : FormationHash;
    
    /// Genesis law compliance scores (one per system)
    genesisLawValues : [GenesisLawValue];
    
    /// Genesis Merkle roots (VERITAS, AEGIS, GENOME)
    genesisMerkleRoots : [GenesisMerkleRoot];
    
    /// VERITAS Merkle root (explicit)
    veritasMerkleRoot : Nat32;
    
    /// AEGIS Merkle root (explicit)
    aegisMerkleRoot : Nat32;
    
    /// GENOME Merkle root (explicit)
    genomeMerkleRoot : Nat32;
    
    /// Genesis timestamp
    genesisTimestamp : Int;
    
    /// Is anchor finalized?
    isFinalized : Bool;
    
    /// Finalization timestamp
    finalizationTimestamp : Int;
    
    /// Anchor version
    anchorVersion : Nat;
    
    /// Total genesis hash (hash of all genesis values)
    totalGenesisHash : Nat32;
    
    /// Principal who created the anchor
    creatorPrincipal : Text;
    
    /// Organism ID
    organismId : Text;
    
    /// Is anchor sealed? (cannot be modified after sealing)
    isSealed : Bool;
    
    /// Seal timestamp
    sealTimestamp : Int;
    
    /// Anchor integrity check
    integrityCheck : AnchorIntegrityCheck;
  };
  
  /// AnchorIntegrityCheck for verifying anchor has not been tampered with
  public type AnchorIntegrityCheck = {
    /// Last verification timestamp
    lastVerificationTimestamp : Int;
    
    /// Last verification heartbeat
    lastVerificationHeartbeat : Nat;
    
    /// Verification count
    verificationCount : Nat;
    
    /// All verifications passed?
    allVerificationsPassed : Bool;
    
    /// Last verification result
    lastVerificationResult : Bool;
    
    /// Integrity score [0, 1]
    integrityScore : Float;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Get default epsilon for system
  func getDefaultEpsilon(id : SystemId) : Float {
    switch (id) {
      case (#VERITAS) { 0.0 };    // Zero tolerance
      case (#AEGIS) { 0.0 };      // Zero tolerance
      case (#GENOME) { 0.05 };    // 5%
      case (#BRAIN) { 0.05 };
      case (#QUANTUM) { 0.1 };    // 10% for quantum
      case (#MEMORIA) { 0.05 };
      case (#NEUROCHEM) { 0.05 };
      case (#SUBSTRATE) { 0.05 };
      case (#SIMULACRUM) { 0.1 };
      case (#CORTEX) { 0.05 };
      case (#SOCIO) { 0.1 };
      case (#WALLET) { 0.05 };
      case (#BEHAVIORAL) { 0.1 };
    }
  };
  
  /// Get default weight for system
  func getDefaultWeight(id : SystemId) : Float {
    switch (id) {
      case (#VERITAS) { 2.0 };
      case (#AEGIS) { 1.8 };
      case (#BRAIN) { 1.5 };
      case (#QUANTUM) { 1.4 };
      case (#GENOME) { 1.3 };
      case (#CORTEX) { 1.2 };
      case (#MEMORIA) { 1.1 };
      case (#NEUROCHEM) { 1.0 };
      case (#SUBSTRATE) { 1.0 };
      case (#SIMULACRUM) { 0.9 };
      case (#SOCIO) { 0.9 };
      case (#WALLET) { 0.8 };
      case (#BEHAVIORAL) { 0.8 };
    }
  };
  
  /// Get correction type for system
  func getCorrectionType(id : SystemId) : Text {
    switch (id) {
      case (#BRAIN) { "ReentrainmentPulse" };
      case (#QUANTUM) { "VQEReoptimizer" };
      case (#MEMORIA) { "HebbianReplay" };
      case (#NEUROCHEM) { "HomeostaticCorrection" };
      case (#SUBSTRATE) { "CouplingReanchor" };
      case (#SIMULACRUM) { "ModelResync" };
      case (#CORTEX) { "PurposeRealignment" };
      case (#GENOME) { "Rollback" };
      case (#SOCIO) { "StrategyRecalibration" };
      case (#VERITAS) { "EmergencyHalt" };
      case (#AEGIS) { "ImmediateRelock" };
      case (#WALLET) { "FORMAReinjection" };
      case (#BEHAVIORAL) { "TraitRebalance" };
    }
  };
  
  /// Create default genesis law value for a system
  public func createDefaultGenesisLawValue(id : SystemId) : GenesisLawValue {
    let epsilon = getDefaultEpsilon(id);
    {
      systemId = id;
      systemName = getSystemName(id);
      lawGenesisValue = 0.0;
      genesisStateVector = [];
      genesisStateHash = 0;
      epsilon = epsilon;
      epsilonCritical = epsilon * 3.0;
      epsilonCatastrophic = epsilon * 5.0;
      weight = getDefaultWeight(id);
      correctionType = getCorrectionType(id);
      isLocked = false;
      lockTimestamp = 0;
    }
  };
  
  /// Create default Merkle root for critical system
  public func createDefaultMerkleRoot(id : SystemId) : GenesisMerkleRoot {
    {
      systemId = id;
      systemName = getSystemName(id);
      merkleRoot = 0;
      entryCount = 0;
      sampleEntryHashes = [];
      isLocked = false;
      lockTimestamp = 0;
    }
  };
  
  /// Create default formation hash
  public func createDefaultFormationHash(organismId : Text, creatorPrincipal : Text) : FormationHash {
    {
      primaryHash = 0;
      secondaryHash = 0;
      formationTimestamp = Time.now();
      formationHeartbeat = 0;
      creatorPrincipal = creatorPrincipal;
      organismId = organismId;
      version = ANCHOR_VERSION;
      isFormationComplete = false;
      formationSignature = [];
    }
  };
  
  /// Create default integrity check
  public func createDefaultIntegrityCheck() : AnchorIntegrityCheck {
    {
      lastVerificationTimestamp = 0;
      lastVerificationHeartbeat = 0;
      verificationCount = 0;
      allVerificationsPassed = true;
      lastVerificationResult = true;
      integrityScore = 1.0;
    }
  };
  
  /// Create default CHRONO Genesis Anchor
  public func createDefaultChronoGenesisAnchor(
    organismId : Text,
    creatorPrincipal : Text
  ) : ChronoGenesisAnchorState {
    let systems = getAllSystemIds();
    {
      formationHash = createDefaultFormationHash(organismId, creatorPrincipal);
      genesisLawValues = Array.tabulate<GenesisLawValue>(NUM_SYSTEMS, func(i : Nat) : GenesisLawValue {
        createDefaultGenesisLawValue(systems[i])
      });
      genesisMerkleRoots = [
        createDefaultMerkleRoot(#VERITAS),
        createDefaultMerkleRoot(#AEGIS),
        createDefaultMerkleRoot(#GENOME)
      ];
      veritasMerkleRoot = 0;
      aegisMerkleRoot = 0;
      genomeMerkleRoot = 0;
      genesisTimestamp = Time.now();
      isFinalized = false;
      finalizationTimestamp = 0;
      anchorVersion = ANCHOR_VERSION;
      totalGenesisHash = 0;
      creatorPrincipal = creatorPrincipal;
      organismId = organismId;
      isSealed = false;
      sealTimestamp = 0;
      integrityCheck = createDefaultIntegrityCheck();
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // GENESIS VALUE LOCKING — Lock L_genesis for each system
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Lock a single system's genesis law value
  public func lockGenesisLawValue(
    anchor : ChronoGenesisAnchorState,
    systemId : SystemId,
    lawValue : Float,
    stateVector : [Float],
    stateHash : Nat32
  ) : ChronoGenesisAnchorState {
    // Don't allow changes if sealed
    if (anchor.isSealed) {
      return anchor;
    };
    
    // Find and update the system's genesis value
    let updatedValues = Array.tabulate<GenesisLawValue>(NUM_SYSTEMS, func(i : Nat) : GenesisLawValue {
      let current = anchor.genesisLawValues[i];
      if (current.systemId == systemId and not current.isLocked) {
        {
          systemId = current.systemId;
          systemName = current.systemName;
          lawGenesisValue = lawValue;
          genesisStateVector = stateVector;
          genesisStateHash = stateHash;
          epsilon = current.epsilon;
          epsilonCritical = current.epsilonCritical;
          epsilonCatastrophic = current.epsilonCatastrophic;
          weight = current.weight;
          correctionType = current.correctionType;
          isLocked = true;
          lockTimestamp = Time.now();
        }
      } else {
        current
      }
    });
    
    {
      formationHash = anchor.formationHash;
      genesisLawValues = updatedValues;
      genesisMerkleRoots = anchor.genesisMerkleRoots;
      veritasMerkleRoot = anchor.veritasMerkleRoot;
      aegisMerkleRoot = anchor.aegisMerkleRoot;
      genomeMerkleRoot = anchor.genomeMerkleRoot;
      genesisTimestamp = anchor.genesisTimestamp;
      isFinalized = anchor.isFinalized;
      finalizationTimestamp = anchor.finalizationTimestamp;
      anchorVersion = anchor.anchorVersion;
      totalGenesisHash = anchor.totalGenesisHash;
      creatorPrincipal = anchor.creatorPrincipal;
      organismId = anchor.organismId;
      isSealed = anchor.isSealed;
      sealTimestamp = anchor.sealTimestamp;
      integrityCheck = anchor.integrityCheck;
    }
  };
  
  /// Lock all genesis law values at once
  public func lockAllGenesisLawValues(
    anchor : ChronoGenesisAnchorState,
    lawValues : [(SystemId, Float, [Float], Nat32)]
  ) : ChronoGenesisAnchorState {
    var updatedAnchor = anchor;
    
    for (entry in Iter.fromArray(lawValues)) {
      let (systemId, lawValue, stateVector, stateHash) = entry;
      updatedAnchor := lockGenesisLawValue(updatedAnchor, systemId, lawValue, stateVector, stateHash);
    };
    
    updatedAnchor
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // MERKLE ROOT LOCKING — Lock Merkle roots for VERITAS, AEGIS, GENOME
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Lock a Merkle root for a critical system
  public func lockMerkleRoot(
    anchor : ChronoGenesisAnchorState,
    systemId : SystemId,
    merkleRoot : Nat32,
    entryCount : Nat,
    sampleHashes : [Nat32]
  ) : ChronoGenesisAnchorState {
    // Don't allow changes if sealed
    if (anchor.isSealed) {
      return anchor;
    };
    
    // Validate system is one of the three critical systems
    let isValidSystem = switch (systemId) {
      case (#VERITAS or #AEGIS or #GENOME) { true };
      case _ { false };
    };
    
    if (not isValidSystem) {
      return anchor;
    };
    
    // Update the specific Merkle root
    var newVeritas = anchor.veritasMerkleRoot;
    var newAegis = anchor.aegisMerkleRoot;
    var newGenome = anchor.genomeMerkleRoot;
    
    switch (systemId) {
      case (#VERITAS) { newVeritas := merkleRoot; };
      case (#AEGIS) { newAegis := merkleRoot; };
      case (#GENOME) { newGenome := merkleRoot; };
      case _ {};
    };
    
    // Update the Merkle roots array
    let updatedMerkleRoots = Array.tabulate<GenesisMerkleRoot>(3, func(i : Nat) : GenesisMerkleRoot {
      let current = anchor.genesisMerkleRoots[i];
      if (current.systemId == systemId and not current.isLocked) {
        {
          systemId = current.systemId;
          systemName = current.systemName;
          merkleRoot = merkleRoot;
          entryCount = entryCount;
          sampleEntryHashes = sampleHashes;
          isLocked = true;
          lockTimestamp = Time.now();
        }
      } else {
        current
      }
    });
    
    {
      formationHash = anchor.formationHash;
      genesisLawValues = anchor.genesisLawValues;
      genesisMerkleRoots = updatedMerkleRoots;
      veritasMerkleRoot = newVeritas;
      aegisMerkleRoot = newAegis;
      genomeMerkleRoot = newGenome;
      genesisTimestamp = anchor.genesisTimestamp;
      isFinalized = anchor.isFinalized;
      finalizationTimestamp = anchor.finalizationTimestamp;
      anchorVersion = anchor.anchorVersion;
      totalGenesisHash = anchor.totalGenesisHash;
      creatorPrincipal = anchor.creatorPrincipal;
      organismId = anchor.organismId;
      isSealed = anchor.isSealed;
      sealTimestamp = anchor.sealTimestamp;
      integrityCheck = anchor.integrityCheck;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // FORMATION HASH COMPUTATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Compute formation hash from all genesis values
  public func computeFormationHash(anchor : ChronoGenesisAnchorState) : Nat32 {
    var hash : Nat32 = 0;
    
    // Mix in all law genesis values
    for (i in Iter.range(0, NUM_SYSTEMS - 1)) {
      let value = anchor.genesisLawValues[i];
      let valueBits = Float.toInt(value.lawGenesisValue * 1000000.0);
      hash := hash +% Nat32.fromIntWrap(valueBits * (i + 1));
      hash := hash +% value.genesisStateHash;
    };
    
    // Mix in Merkle roots
    hash := hash +% anchor.veritasMerkleRoot;
    hash := hash +% anchor.aegisMerkleRoot;
    hash := hash +% anchor.genomeMerkleRoot;
    
    // Mix in timestamp
    let timeBits = Nat32.fromIntWrap(anchor.genesisTimestamp % 0x7FFFFFFF);
    hash := hash +% timeBits;
    
    hash
  };
  
  /// Compute secondary hash for verification
  func computeSecondaryHash(anchor : ChronoGenesisAnchorState) : Nat32 {
    var hash : Nat32 = 0;
    
    // Different mixing strategy for verification
    for (i in Iter.range(0, NUM_SYSTEMS - 1)) {
      let value = anchor.genesisLawValues[i];
      let valueBits = Float.toInt(value.lawGenesisValue * 1000000.0);
      hash := hash *% 31 +% Nat32.fromIntWrap(valueBits);
    };
    
    hash := hash *% 37 +% anchor.veritasMerkleRoot;
    hash := hash *% 41 +% anchor.aegisMerkleRoot;
    hash := hash *% 43 +% anchor.genomeMerkleRoot;
    
    hash
  };
  
  /// Compute formation signature
  func computeFormationSignature(primaryHash : Nat32, secondaryHash : Nat32) : [Nat8] {
    // Simple signature from hashes (in production would use cryptographic signing)
    let h1 = primaryHash;
    let h2 = secondaryHash;
    
    Array.tabulate<Nat8>(SIGNATURE_LENGTH, func(i : Nat) : Nat8 {
      let idx = i % 8;
      let baseHash = if (i < SIGNATURE_LENGTH / 2) { h1 } else { h2 };
      let shifted = baseHash / Nat32.fromNat(Nat.pow(256, idx % 4));
      Nat8.fromNat(Nat32.toNat(shifted % 256))
    })
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // FINALIZATION AND SEALING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Check if all genesis values are locked
  public func areAllGenesisValuesLocked(anchor : ChronoGenesisAnchorState) : Bool {
    for (i in Iter.range(0, NUM_SYSTEMS - 1)) {
      if (not anchor.genesisLawValues[i].isLocked) {
        return false;
      };
    };
    true
  };
  
  /// Check if all critical Merkle roots are locked
  public func areAllMerkleRootsLocked(anchor : ChronoGenesisAnchorState) : Bool {
    for (i in Iter.range(0, 2)) {
      if (not anchor.genesisMerkleRoots[i].isLocked) {
        return false;
      };
    };
    true
  };
  
  /// Finalize the genesis anchor (compute hashes, but don't seal)
  public func finalizeGenesisAnchor(
    anchor : ChronoGenesisAnchorState,
    heartbeat : Nat
  ) : ChronoGenesisAnchorState {
    // Can't finalize if already sealed
    if (anchor.isSealed) {
      return anchor;
    };
    
    // Check that all values are locked
    if (not areAllGenesisValuesLocked(anchor) or not areAllMerkleRootsLocked(anchor)) {
      return anchor;
    };
    
    // Compute hashes
    let primaryHash = computeFormationHash(anchor);
    let secondaryHash = computeSecondaryHash(anchor);
    let totalHash = primaryHash +% secondaryHash;
    
    // Compute signature
    let signature = computeFormationSignature(primaryHash, secondaryHash);
    
    // Update formation hash
    let newFormationHash = {
      primaryHash = primaryHash;
      secondaryHash = secondaryHash;
      formationTimestamp = anchor.formationHash.formationTimestamp;
      formationHeartbeat = heartbeat;
      creatorPrincipal = anchor.formationHash.creatorPrincipal;
      organismId = anchor.formationHash.organismId;
      version = anchor.formationHash.version;
      isFormationComplete = true;
      formationSignature = signature;
    };
    
    {
      formationHash = newFormationHash;
      genesisLawValues = anchor.genesisLawValues;
      genesisMerkleRoots = anchor.genesisMerkleRoots;
      veritasMerkleRoot = anchor.veritasMerkleRoot;
      aegisMerkleRoot = anchor.aegisMerkleRoot;
      genomeMerkleRoot = anchor.genomeMerkleRoot;
      genesisTimestamp = anchor.genesisTimestamp;
      isFinalized = true;
      finalizationTimestamp = Time.now();
      anchorVersion = anchor.anchorVersion;
      totalGenesisHash = totalHash;
      creatorPrincipal = anchor.creatorPrincipal;
      organismId = anchor.organismId;
      isSealed = anchor.isSealed;
      sealTimestamp = anchor.sealTimestamp;
      integrityCheck = anchor.integrityCheck;
    }
  };
  
  /// Seal the genesis anchor (makes it permanently immutable)
  public func sealGenesisAnchor(anchor : ChronoGenesisAnchorState) : ChronoGenesisAnchorState {
    // Must be finalized first
    if (not anchor.isFinalized) {
      return anchor;
    };
    
    // Already sealed
    if (anchor.isSealed) {
      return anchor;
    };
    
    {
      formationHash = anchor.formationHash;
      genesisLawValues = anchor.genesisLawValues;
      genesisMerkleRoots = anchor.genesisMerkleRoots;
      veritasMerkleRoot = anchor.veritasMerkleRoot;
      aegisMerkleRoot = anchor.aegisMerkleRoot;
      genomeMerkleRoot = anchor.genomeMerkleRoot;
      genesisTimestamp = anchor.genesisTimestamp;
      isFinalized = anchor.isFinalized;
      finalizationTimestamp = anchor.finalizationTimestamp;
      anchorVersion = anchor.anchorVersion;
      totalGenesisHash = anchor.totalGenesisHash;
      creatorPrincipal = anchor.creatorPrincipal;
      organismId = anchor.organismId;
      isSealed = true;
      sealTimestamp = Time.now();
      integrityCheck = anchor.integrityCheck;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // INTEGRITY VERIFICATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Verify anchor integrity
  public func verifyAnchorIntegrity(
    anchor : ChronoGenesisAnchorState,
    heartbeat : Nat
  ) : (ChronoGenesisAnchorState, Bool) {
    // Recompute hashes
    let recomputedPrimary = computeFormationHash(anchor);
    let recomputedSecondary = computeSecondaryHash(anchor);
    
    // Verify they match
    let primaryMatch = anchor.formationHash.primaryHash == recomputedPrimary;
    let secondaryMatch = anchor.formationHash.secondaryHash == recomputedSecondary;
    let totalMatch = anchor.totalGenesisHash == (recomputedPrimary +% recomputedSecondary);
    
    let allVerificationsPassed = primaryMatch and secondaryMatch and totalMatch;
    let integrityScore = if (allVerificationsPassed) { 1.0 }
                         else if (primaryMatch or secondaryMatch) { 0.5 }
                         else { 0.0 };
    
    let newIntegrityCheck = {
      lastVerificationTimestamp = Time.now();
      lastVerificationHeartbeat = heartbeat;
      verificationCount = anchor.integrityCheck.verificationCount + 1;
      allVerificationsPassed = anchor.integrityCheck.allVerificationsPassed and allVerificationsPassed;
      lastVerificationResult = allVerificationsPassed;
      integrityScore = integrityScore;
    };
    
    let updatedAnchor = {
      formationHash = anchor.formationHash;
      genesisLawValues = anchor.genesisLawValues;
      genesisMerkleRoots = anchor.genesisMerkleRoots;
      veritasMerkleRoot = anchor.veritasMerkleRoot;
      aegisMerkleRoot = anchor.aegisMerkleRoot;
      genomeMerkleRoot = anchor.genomeMerkleRoot;
      genesisTimestamp = anchor.genesisTimestamp;
      isFinalized = anchor.isFinalized;
      finalizationTimestamp = anchor.finalizationTimestamp;
      anchorVersion = anchor.anchorVersion;
      totalGenesisHash = anchor.totalGenesisHash;
      creatorPrincipal = anchor.creatorPrincipal;
      organismId = anchor.organismId;
      isSealed = anchor.isSealed;
      sealTimestamp = anchor.sealTimestamp;
      integrityCheck = newIntegrityCheck;
    };
    
    (updatedAnchor, allVerificationsPassed)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // QUERY FUNCTIONS — Get genesis values for drift computation
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Get L_genesis for a system
  public func getGenesisLawValue(anchor : ChronoGenesisAnchorState, systemId : SystemId) : Float {
    for (i in Iter.range(0, NUM_SYSTEMS - 1)) {
      if (anchor.genesisLawValues[i].systemId == systemId) {
        return anchor.genesisLawValues[i].lawGenesisValue;
      };
    };
    0.0
  };
  
  /// Get epsilon for a system
  public func getSystemEpsilon(anchor : ChronoGenesisAnchorState, systemId : SystemId) : Float {
    for (i in Iter.range(0, NUM_SYSTEMS - 1)) {
      if (anchor.genesisLawValues[i].systemId == systemId) {
        return anchor.genesisLawValues[i].epsilon;
      };
    };
    0.05  // Default
  };
  
  /// Get system weight
  public func getSystemWeight(anchor : ChronoGenesisAnchorState, systemId : SystemId) : Float {
    for (i in Iter.range(0, NUM_SYSTEMS - 1)) {
      if (anchor.genesisLawValues[i].systemId == systemId) {
        return anchor.genesisLawValues[i].weight;
      };
    };
    1.0  // Default
  };
  
  /// Get genesis Merkle root for critical system
  public func getGenesisMerkleRoot(anchor : ChronoGenesisAnchorState, systemId : SystemId) : Nat32 {
    switch (systemId) {
      case (#VERITAS) { anchor.veritasMerkleRoot };
      case (#AEGIS) { anchor.aegisMerkleRoot };
      case (#GENOME) { anchor.genomeMerkleRoot };
      case _ { 0 };
    }
  };
  
  /// Get formation hash
  public func getFormationHash(anchor : ChronoGenesisAnchorState) : Nat32 {
    anchor.formationHash.primaryHash
  };
  
  /// Get total genesis hash
  public func getTotalGenesisHash(anchor : ChronoGenesisAnchorState) : Nat32 {
    anchor.totalGenesisHash
  };
  
  /// Is anchor sealed?
  public func isAnchorSealed(anchor : ChronoGenesisAnchorState) : Bool {
    anchor.isSealed
  };
  
  /// Is anchor finalized?
  public func isAnchorFinalized(anchor : ChronoGenesisAnchorState) : Bool {
    anchor.isFinalized
  };
  
  /// Get integrity score
  public func getIntegrityScore(anchor : ChronoGenesisAnchorState) : Float {
    anchor.integrityCheck.integrityScore
  };
  
  /// Get genesis timestamp
  public func getGenesisTimestamp(anchor : ChronoGenesisAnchorState) : Int {
    anchor.genesisTimestamp
  };
  
  /// Get all genesis law values as array of (SystemId, Float)
  public func getAllGenesisLawValues(anchor : ChronoGenesisAnchorState) : [(SystemId, Float)] {
    Array.tabulate<(SystemId, Float)>(NUM_SYSTEMS, func(i : Nat) : (SystemId, Float) {
      (anchor.genesisLawValues[i].systemId, anchor.genesisLawValues[i].lawGenesisValue)
    })
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // DRIFT VERIFICATION HELPER
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// DriftVerificationResult from CHRONO
  public type DriftVerificationResult = {
    systemId : SystemId;
    lawGenesis : Float;
    lawLive : Float;
    drift : Float;
    epsilon : Float;
    isViolation : Bool;
    isCritical : Bool;
    isCatastrophic : Bool;
  };
  
  /// Verify drift for a single system
  public func verifySystemDrift(
    anchor : ChronoGenesisAnchorState,
    systemId : SystemId,
    lawLive : Float
  ) : DriftVerificationResult {
    var lawGenesis : Float = 0.0;
    var epsilon : Float = 0.05;
    var epsilonCritical : Float = 0.15;
    var epsilonCatastrophic : Float = 0.25;
    
    for (i in Iter.range(0, NUM_SYSTEMS - 1)) {
      if (anchor.genesisLawValues[i].systemId == systemId) {
        lawGenesis := anchor.genesisLawValues[i].lawGenesisValue;
        epsilon := anchor.genesisLawValues[i].epsilon;
        epsilonCritical := anchor.genesisLawValues[i].epsilonCritical;
        epsilonCatastrophic := anchor.genesisLawValues[i].epsilonCatastrophic;
      };
    };
    
    let drift = Float.abs(lawLive - lawGenesis);
    
    {
      systemId = systemId;
      lawGenesis = lawGenesis;
      lawLive = lawLive;
      drift = drift;
      epsilon = epsilon;
      isViolation = drift > epsilon;
      isCritical = drift > epsilonCritical;
      isCatastrophic = drift > epsilonCatastrophic;
    }
  };

}
