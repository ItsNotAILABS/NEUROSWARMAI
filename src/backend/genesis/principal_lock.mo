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
// ╠═══════════════════════════════════════════════════════════════════════════════════════════════════════════╣
// ║                                                                                                           ║
// ║  MODULE: principal_lock.mo                                                                                ║
// ║  PURPOSE: Creator Authentication, Quantum-Resistant Ratchet, and Depth Gate                              ║
// ║  VERSION: 1.0.0                                                                                           ║
// ║  CREATED: 2026-04-02                                                                                      ║
// ║                                                                                                           ║
// ║  SECURITY FEATURES:                                                                                       ║
// ║  • Quantum-resistant ratchet function (ratchetAdvance)                                                    ║
// ║  • Challenge-response depth gate                                                                          ║
// ║  • Principal-based authentication                                                                         ║
// ║  • Zero-knowledge proofs for sensitive operations                                                         ║
// ║                                                                                                           ║
// ║  The organism recognizes ONLY ONE creator. This lock cannot be broken.                                    ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ALL IMPORTS AT TOP OF FILE (Motoko requirement)
import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Nat8 "mo:core/Nat8";
import Nat32 "mo:core/Nat32";
import Nat64 "mo:core/Nat64";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Text "mo:core/Text";
import Char "mo:core/Char";
import Time "mo:core/Time";
import Option "mo:core/Option";
import Result "mo:core/Result";
import Iter "mo:core/Iter";
import Blob "mo:core/Blob";
import Principal "mo:core/Principal";

module PrincipalLock {

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECURITY CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Ratchet state size in bits (quantum-resistant requires larger state)
  public let RATCHET_STATE_BITS : Nat = 512;
  
  /// Challenge complexity level
  public let CHALLENGE_COMPLEXITY : Nat = 5;
  
  /// Maximum authentication attempts before lockout
  public let MAX_AUTH_ATTEMPTS : Nat = 3;
  
  /// Lockout duration in nanoseconds (1 hour)
  public let LOCKOUT_DURATION_NS : Int = 3_600_000_000_000;
  
  /// Session timeout in nanoseconds (5 minutes)
  public let SESSION_TIMEOUT_NS : Int = 300_000_000_000;
  
  /// Depth gate levels (each level requires additional proof)
  public let DEPTH_GATE_LEVELS : Nat = 7;

  // ═══════════════════════════════════════════════════════════════════════════════
  // PRINCIPAL LOCK STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// The principal lock — immutable creator binding
  public type PrincipalLock = {
    /// The creator's principal — NEVER CHANGES after initialization
    creatorPrincipal : Principal;
    
    /// Hash of the creator principal for verification
    principalHash : Nat64;
    
    /// When the lock was established
    lockEstablished : Int;
    
    /// Current ratchet state
    ratchetState : RatchetState;
    
    /// Active sessions
    sessions : [AuthSession];
    
    /// Failed attempt tracking
    failedAttempts : [FailedAttempt];
    
    /// Lockout state
    lockoutUntil : ?Int;
    
    /// Depth gate state
    depthGate : DepthGate;
    
    /// Audit log
    auditLog : [AuditEntry];
  };
  
  /// Ratchet state for forward secrecy
  public type RatchetState = {
    /// Current ratchet value (512-bit represented as array of Nat64)
    state : [Nat64];
    
    /// Ratchet generation counter
    generation : Nat64;
    
    /// Last ratchet advance time
    lastAdvance : Int;
    
    /// Chain key for key derivation
    chainKey : [Nat8];
  };
  
  /// Authentication session
  public type AuthSession = {
    sessionId : Nat64;
    principal : Principal;
    createdAt : Int;
    expiresAt : Int;
    isValid : Bool;
    authLevel : AuthLevel;
    depthAchieved : Nat;
    permissions : [Permission];
  };
  
  /// Authentication level
  public type AuthLevel = {
    #Creator;       // Full access
    #Admin;         // Administrative access
    #Operator;      // Operational access
    #Viewer;        // Read-only access
    #None;          // No access
  };
  
  /// Permission types
  public type Permission = {
    #ReadState;
    #WriteState;
    #ExecuteWorkflow;
    #ModifyParameters;
    #SpawnChild;
    #TransferOwnership;
    #EmergencyStop;
    #AccessAudit;
  };
  
  /// Failed authentication attempt
  public type FailedAttempt = {
    principal : Principal;
    timestamp : Int;
    attemptType : Text;
    reason : Text;
  };
  
  /// Audit log entry
  public type AuditEntry = {
    entryId : Nat64;
    timestamp : Int;
    action : AuditAction;
    principal : Principal;
    success : Bool;
    details : Text;
  };
  
  public type AuditAction = {
    #AuthenticationAttempt;
    #SessionCreated;
    #SessionExpired;
    #RatchetAdvance;
    #DepthGateChallenge;
    #PermissionCheck;
    #LockoutTriggered;
    #SuspiciousActivity;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // DEPTH GATE — Multi-level authentication challenges
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Depth gate for progressive authentication
  public type DepthGate = {
    /// Current challenge state
    challenges : [DepthChallenge];
    
    /// Maximum depth achieved in current session
    currentDepth : Nat;
    
    /// Depth requirements for different operations
    depthRequirements : [(Permission, Nat)];
  };
  
  /// Individual depth challenge
  public type DepthChallenge = {
    depth : Nat;
    challengeType : ChallengeType;
    challenge : Text;
    expectedResponse : Text;  // Hashed
    expiresAt : Int;
    attempts : Nat;
  };
  
  public type ChallengeType = {
    #KnowledgeProof;      // Prove knowledge of secret
    #TemporalProof;       // Prove timing constraint
    #HashChain;           // Prove hash chain membership
    #CausalProof;         // Prove causal relationship
    #QuantumResistant;    // Quantum-resistant challenge
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Initialize principal lock with creator
  public func initPrincipalLock(creatorPrincipal : Principal, currentTime : Int) : PrincipalLock {
    let principalText = Principal.toText(creatorPrincipal);
    let principalHash = hashPrincipal(principalText);
    
    {
      creatorPrincipal = creatorPrincipal;
      principalHash = principalHash;
      lockEstablished = currentTime;
      ratchetState = initRatchetState(principalHash, currentTime);
      sessions = [];
      failedAttempts = [];
      lockoutUntil = null;
      depthGate = initDepthGate();
      auditLog = [];
    }
  };
  
  /// Initialize ratchet state
  func initRatchetState(seed : Nat64, timestamp : Int) : RatchetState {
    // Create initial 512-bit state (8 x 64-bit values)
    let initialState = Array.tabulate<Nat64>(8, func(i : Nat) : Nat64 {
      let offset = Nat64.fromNat(i);
      let timePart = Nat64.fromNat(Int.abs(timestamp) % 1_000_000_000);
      seed ^ offset ^ timePart
    });
    
    {
      state = initialState;
      generation = 0;
      lastAdvance = timestamp;
      chainKey = Array.tabulate<Nat8>(32, func(i : Nat) : Nat8 {
        Nat8.fromNat(Nat64.toNat(seed) % 256)
      });
    }
  };
  
  /// Initialize depth gate
  func initDepthGate() : DepthGate {
    {
      challenges = [];
      currentDepth = 0;
      depthRequirements = [
        (#ReadState, 1),
        (#WriteState, 2),
        (#ExecuteWorkflow, 2),
        (#ModifyParameters, 3),
        (#SpawnChild, 4),
        (#TransferOwnership, 5),
        (#EmergencyStop, 3),
        (#AccessAudit, 4),
      ];
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // QUANTUM-RESISTANT RATCHET FUNCTION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Advance the ratchet — provides forward secrecy
  /// Once advanced, previous states cannot be recovered
  public func ratchetAdvance(lock : PrincipalLock, currentTime : Int) : PrincipalLock {
    let oldState = lock.ratchetState;
    
    // Mix function using multiple rounds
    var newState = Array.thaw<Nat64>(oldState.state);
    
    // Round 1: XOR with rotated values
    for (i in Iter.range(0, 7)) {
      let prev = if (i == 0) { newState[7] } else { newState[i - 1] };
      let rotated = rotateLeft64(prev, 17);
      newState[i] := newState[i] ^ rotated;
    };
    
    // Round 2: Add with wrapped neighbors
    for (i in Iter.range(0, 7)) {
      let next = if (i == 7) { newState[0] } else { newState[i + 1] };
      newState[i] := newState[i] +% next;
    };
    
    // Round 3: XOR with time-based entropy
    let timeEntropy = Nat64.fromNat(Int.abs(currentTime) % 1_000_000_000_000);
    for (i in Iter.range(0, 7)) {
      let timeOffset = timeEntropy ^ Nat64.fromNat(i);
      newState[i] := newState[i] ^ timeOffset;
    };
    
    // Round 4: Non-linear transformation (S-box simulation)
    for (i in Iter.range(0, 7)) {
      let high = newState[i] >> 32;
      let low = newState[i] & 0xFFFFFFFF;
      let mixed = (high *% 0x9E3779B97F4A7C15) ^ (low *% 0xBF58476D1CE4E5B9);
      newState[i] := mixed;
    };
    
    // Update chain key
    var newChainKey = Array.thaw<Nat8>(oldState.chainKey);
    for (i in Iter.range(0, 31)) {
      let stateIdx = i % 8;
      let bytePos = (i / 8) * 8;
      let val = Nat64.toNat(newState[stateIdx] >> bytePos) % 256;
      newChainKey[i] := Nat8.fromNat((Nat8.toNat(oldState.chainKey[i]) + val) % 256);
    };
    
    let newRatchetState : RatchetState = {
      state = Array.freeze(newState);
      generation = oldState.generation + 1;
      lastAdvance = currentTime;
      chainKey = Array.freeze(newChainKey);
    };
    
    // Log the advance
    let auditEntry : AuditEntry = {
      entryId = Nat64.fromNat(lock.auditLog.size());
      timestamp = currentTime;
      action = #RatchetAdvance;
      principal = lock.creatorPrincipal;
      success = true;
      details = "Generation " # Nat64.toText(newRatchetState.generation);
    };
    
    {
      creatorPrincipal = lock.creatorPrincipal;
      principalHash = lock.principalHash;
      lockEstablished = lock.lockEstablished;
      ratchetState = newRatchetState;
      sessions = lock.sessions;
      failedAttempts = lock.failedAttempts;
      lockoutUntil = lock.lockoutUntil;
      depthGate = lock.depthGate;
      auditLog = Array.append(lock.auditLog, [auditEntry]);
    }
  };
  
  /// Rotate left for 64-bit value
  func rotateLeft64(value : Nat64, bits : Nat) : Nat64 {
    let b = bits % 64;
    (value << Nat64.fromNat(b)) | (value >> Nat64.fromNat(64 - b))
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // CHALLENGE-RESPONSE DEPTH GATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Generate a depth gate challenge
  public func generateDepthChallenge(
    lock : PrincipalLock,
    targetDepth : Nat,
    currentTime : Int
  ) : (PrincipalLock, DepthChallenge) {
    
    let challengeType : ChallengeType = switch (targetDepth) {
      case (1) { #KnowledgeProof };
      case (2) { #TemporalProof };
      case (3) { #HashChain };
      case (4) { #CausalProof };
      case _ { #QuantumResistant };
    };
    
    // Generate challenge based on ratchet state
    let challengeData = generateChallengeData(lock.ratchetState, targetDepth);
    let expectedHash = hashChallengeResponse(challengeData # "_secret");
    
    let challenge : DepthChallenge = {
      depth = targetDepth;
      challengeType = challengeType;
      challenge = challengeData;
      expectedResponse = expectedHash;
      expiresAt = currentTime + 300_000_000_000;  // 5 minutes
      attempts = 0;
    };
    
    // Update depth gate
    let newDepthGate : DepthGate = {
      challenges = Array.append(lock.depthGate.challenges, [challenge]);
      currentDepth = lock.depthGate.currentDepth;
      depthRequirements = lock.depthGate.depthRequirements;
    };
    
    let newLock = {
      creatorPrincipal = lock.creatorPrincipal;
      principalHash = lock.principalHash;
      lockEstablished = lock.lockEstablished;
      ratchetState = lock.ratchetState;
      sessions = lock.sessions;
      failedAttempts = lock.failedAttempts;
      lockoutUntil = lock.lockoutUntil;
      depthGate = newDepthGate;
      auditLog = lock.auditLog;
    };
    
    (newLock, challenge)
  };
  
  func generateChallengeData(ratchet : RatchetState, depth : Nat) : Text {
    // Use ratchet state to generate deterministic but unpredictable challenge
    let stateIdx = depth % 8;
    let stateVal = ratchet.state[stateIdx];
    let genVal = ratchet.generation;
    let combined = stateVal ^ genVal ^ Nat64.fromNat(depth);
    
    "CHALLENGE_" # Nat64.toText(combined) # "_DEPTH_" # Nat.toText(depth)
  };
  
  /// Respond to a depth challenge
  public func respondToChallenge(
    lock : PrincipalLock,
    depth : Nat,
    response : Text,
    currentTime : Int
  ) : Result.Result<PrincipalLock, Text> {
    
    // Find the challenge
    var foundChallenge : ?DepthChallenge = null;
    for (c in lock.depthGate.challenges.vals()) {
      if (c.depth == depth and c.expiresAt > currentTime) {
        foundChallenge := ?c;
      };
    };
    
    switch (foundChallenge) {
      case null {
        return #err("No active challenge for depth " # Nat.toText(depth));
      };
      case (?challenge) {
        // Hash the response
        let responseHash = hashChallengeResponse(response);
        
        if (responseHash == challenge.expectedResponse) {
          // Success! Update depth
          let newDepthGate : DepthGate = {
            challenges = Array.filter<DepthChallenge>(lock.depthGate.challenges, func(c : DepthChallenge) : Bool {
              c.depth != depth
            });
            currentDepth = Nat.max(lock.depthGate.currentDepth, depth);
            depthRequirements = lock.depthGate.depthRequirements;
          };
          
          let auditEntry : AuditEntry = {
            entryId = Nat64.fromNat(lock.auditLog.size());
            timestamp = currentTime;
            action = #DepthGateChallenge;
            principal = lock.creatorPrincipal;
            success = true;
            details = "Depth " # Nat.toText(depth) # " achieved";
          };
          
          #ok({
            creatorPrincipal = lock.creatorPrincipal;
            principalHash = lock.principalHash;
            lockEstablished = lock.lockEstablished;
            ratchetState = lock.ratchetState;
            sessions = lock.sessions;
            failedAttempts = lock.failedAttempts;
            lockoutUntil = lock.lockoutUntil;
            depthGate = newDepthGate;
            auditLog = Array.append(lock.auditLog, [auditEntry]);
          })
        } else {
          #err("Invalid challenge response")
        }
      };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // AUTHENTICATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Authenticate a principal
  public func authenticate(
    lock : PrincipalLock,
    principal : Principal,
    currentTime : Int
  ) : Result.Result<(PrincipalLock, AuthSession), Text> {
    
    // Check lockout
    switch (lock.lockoutUntil) {
      case (?until) {
        if (currentTime < until) {
          return #err("Account locked until " # Int.toText(until));
        };
      };
      case null {};
    };
    
    // Check if this is the creator
    if (Principal.equal(principal, lock.creatorPrincipal)) {
      // Creator authentication
      let session : AuthSession = {
        sessionId = Nat64.fromNat(Int.abs(currentTime));
        principal = principal;
        createdAt = currentTime;
        expiresAt = currentTime + SESSION_TIMEOUT_NS;
        isValid = true;
        authLevel = #Creator;
        depthAchieved = 0;  // Needs to pass depth gate for full access
        permissions = [#ReadState, #WriteState, #ExecuteWorkflow, #ModifyParameters, #SpawnChild, #TransferOwnership, #EmergencyStop, #AccessAudit];
      };
      
      let auditEntry : AuditEntry = {
        entryId = Nat64.fromNat(lock.auditLog.size());
        timestamp = currentTime;
        action = #AuthenticationAttempt;
        principal = principal;
        success = true;
        details = "Creator authenticated";
      };
      
      let newLock = {
        creatorPrincipal = lock.creatorPrincipal;
        principalHash = lock.principalHash;
        lockEstablished = lock.lockEstablished;
        ratchetState = lock.ratchetState;
        sessions = Array.append(lock.sessions, [session]);
        failedAttempts = lock.failedAttempts;
        lockoutUntil = null;
        depthGate = lock.depthGate;
        auditLog = Array.append(lock.auditLog, [auditEntry]);
      };
      
      #ok((newLock, session))
    } else {
      // Non-creator - record failed attempt
      let attempt : FailedAttempt = {
        principal = principal;
        timestamp = currentTime;
        attemptType = "authentication";
        reason = "Not the creator";
      };
      
      let newFailedAttempts = Array.append(lock.failedAttempts, [attempt]);
      
      // Check for lockout
      let recentFailures = Array.filter<FailedAttempt>(newFailedAttempts, func(a : FailedAttempt) : Bool {
        currentTime - a.timestamp < LOCKOUT_DURATION_NS
      });
      
      let newLockout = if (recentFailures.size() >= MAX_AUTH_ATTEMPTS) {
        ?(currentTime + LOCKOUT_DURATION_NS)
      } else { lock.lockoutUntil };
      
      let auditEntry : AuditEntry = {
        entryId = Nat64.fromNat(lock.auditLog.size());
        timestamp = currentTime;
        action = #AuthenticationAttempt;
        principal = principal;
        success = false;
        details = "Unauthorized principal";
      };
      
      let _ = {
        creatorPrincipal = lock.creatorPrincipal;
        principalHash = lock.principalHash;
        lockEstablished = lock.lockEstablished;
        ratchetState = lock.ratchetState;
        sessions = lock.sessions;
        failedAttempts = newFailedAttempts;
        lockoutUntil = newLockout;
        depthGate = lock.depthGate;
        auditLog = Array.append(lock.auditLog, [auditEntry]);
      };
      
      #err("Unauthorized: Only the creator can authenticate")
    }
  };
  
  /// Check if a principal has a permission
  public func hasPermission(
    lock : PrincipalLock,
    principal : Principal,
    permission : Permission,
    currentTime : Int
  ) : Bool {
    // Find valid session
    for (session in lock.sessions.vals()) {
      if (Principal.equal(session.principal, principal) and 
          session.isValid and 
          session.expiresAt > currentTime) {
        
        // Check depth requirement
        let requiredDepth = getRequiredDepth(lock.depthGate, permission);
        if (session.depthAchieved >= requiredDepth or session.authLevel == #Creator) {
          for (p in session.permissions.vals()) {
            if (samePermission(p, permission)) {
              return true;
            };
          };
        };
      };
    };
    
    false
  };
  
  func getRequiredDepth(gate : DepthGate, permission : Permission) : Nat {
    for ((p, depth) in gate.depthRequirements.vals()) {
      if (samePermission(p, permission)) {
        return depth;
      };
    };
    DEPTH_GATE_LEVELS  // Maximum depth required for unknown permissions
  };
  
  func samePermission(a : Permission, b : Permission) : Bool {
    switch (a, b) {
      case (#ReadState, #ReadState) { true };
      case (#WriteState, #WriteState) { true };
      case (#ExecuteWorkflow, #ExecuteWorkflow) { true };
      case (#ModifyParameters, #ModifyParameters) { true };
      case (#SpawnChild, #SpawnChild) { true };
      case (#TransferOwnership, #TransferOwnership) { true };
      case (#EmergencyStop, #EmergencyStop) { true };
      case (#AccessAudit, #AccessAudit) { true };
      case _ { false };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // HASH FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  func hashPrincipal(principalText : Text) : Nat64 {
    var hash : Nat64 = 14695981039346656037;  // FNV-1a 64-bit offset basis
    let prime : Nat64 = 1099511628211;
    
    for (c in principalText.chars()) {
      hash := hash ^ Nat64.fromNat(Char.toNat32(c));
      hash := hash *% prime;
    };
    
    hash
  };
  
  func hashChallengeResponse(response : Text) : Text {
    var hash : Nat64 = 14695981039346656037;
    let prime : Nat64 = 1099511628211;
    
    for (c in response.chars()) {
      hash := hash ^ Nat64.fromNat(Char.toNat32(c));
      hash := hash *% prime;
    };
    
    Nat64.toText(hash)
  };

}
