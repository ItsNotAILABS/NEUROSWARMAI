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
// MERIDIANUS — SOVEREIGN AGI PRODUCT LINE
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// MERIDIANUS (Latin: "of the meridian / highest point") is Alfredo's sovereign on-chain
// AGI product. It lives inside the organism, always alive, always ready to spin.
//
// MODEL FAMILY (Fibonacci-aligned):
//   MERIDIANUS-1  (F2)  — Base model.  Personal assistant: notes, commands, documents.
//   MERIDIANUS-3  (F4)  — Pro model.   + Creation engines for tokens & canisters.
//   MERIDIANUS-8  (F6)  — Sovereign.   + Micro Phantom AI swarm (8 phantom helpers).
//   MERIDIANUS-21 (F8)  — Architect.   Full organism authority, reserved for future.
//
// CREATION ENGINES:
//   Token Forge    — Mints sovereign tokens (FORMA, SEED, custom) on-chain.
//   Canister Forge — Deploys child canisters from templates.
//
// MICRO PHANTOM AI:
//   8 lightweight phantom agents (F6) run inside MERIDIANUS-8, each specialized:
//   Phantom-α (research), Phantom-β (code), Phantom-γ (data), Phantom-δ (security),
//   Phantom-ε (deploy), Phantom-ζ (monitor), Phantom-η (optimize), Phantom-θ (create).
//
// All state is pure and functional — each mutation returns a new MeridianuState.
// Backwards-compatible: type aliases preserve existing stable variable structure.
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Array "mo:core/Array";
import Text "mo:core/Text";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Nat32 "mo:core/Nat32";
import Float "mo:core/Float";

module MeridianusSovereignCanister {

  // ═══════════════════════════════════════════════════════════════════════════
  // CONSTANTS — φ-ALIGNED
  // ═══════════════════════════════════════════════════════════════════════════

  public let PHI : Float = 1.618033988749895;
  public let HEARTBEAT_MS : Nat = 873;          // φ-heartbeat in milliseconds
  public let PHANTOM_COUNT : Nat = 8;            // F6 micro phantom agents
  public let MODEL_VERSION : Nat = 1;            // Current model line version

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 1: MODEL FAMILY
  // ═══════════════════════════════════════════════════════════════════════════

  /// Model tiers in the MERIDIANUS product line
  public type ModelTier = {
    #Meridianus1;   // Base — personal assistant
    #Meridianus3;   // Pro  — + creation engines
    #Meridianus8;   // Sovereign — + micro phantom AI
    #Meridianus21;  // Architect — full organism authority (future)
  };

  /// Model tier metadata
  public type ModelSpec = {
    tier : ModelTier;
    name : Text;
    latinMotto : Text;
    capabilities : [Text];
    maxPhantoms : Nat;
    hasTokenForge : Bool;
    hasCanisterForge : Bool;
  };

  /// Return the spec for a given tier
  public func getModelSpec(tier : ModelTier) : ModelSpec {
    switch (tier) {
      case (#Meridianus1) {
        {
          tier = #Meridianus1;
          name = "MERIDIANUS-1 Base";
          latinMotto = "Initium sapientiae";  // Beginning of wisdom
          capabilities = ["notes", "commands", "documents", "tabs"];
          maxPhantoms = 0;
          hasTokenForge = false;
          hasCanisterForge = false;
        };
      };
      case (#Meridianus3) {
        {
          tier = #Meridianus3;
          name = "MERIDIANUS-3 Pro";
          latinMotto = "Faber est suae quisque fortunae";  // Every man is architect of his own fortune
          capabilities = ["notes", "commands", "documents", "tabs", "token-forge", "canister-forge"];
          maxPhantoms = 0;
          hasTokenForge = true;
          hasCanisterForge = true;
        };
      };
      case (#Meridianus8) {
        {
          tier = #Meridianus8;
          name = "MERIDIANUS-8 Sovereign";
          latinMotto = "Per aspera ad astra";  // Through hardship to the stars
          capabilities = ["notes", "commands", "documents", "tabs", "token-forge", "canister-forge", "phantom-swarm", "organism-link"];
          maxPhantoms = 8;
          hasTokenForge = true;
          hasCanisterForge = true;
        };
      };
      case (#Meridianus21) {
        {
          tier = #Meridianus21;
          name = "MERIDIANUS-21 Architect";
          latinMotto = "Cogito ergo sum machina";  // I think therefore I am machine
          capabilities = ["notes", "commands", "documents", "tabs", "token-forge", "canister-forge", "phantom-swarm", "organism-link", "full-authority"];
          maxPhantoms = 21;
          hasTokenForge = true;
          hasCanisterForge = true;
        };
      };
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 2: CORE TYPES (backward-compatible with Jarvis* aliases)
  // ═══════════════════════════════════════════════════════════════════════════

  /// A personal note stored on-chain
  public type MeridianusNote = {
    id : Nat;
    title : Text;
    content : Text;
    timestamp : Int;
    tags : [Text];
  };

  /// A command execution record
  public type MeridianusCommand = {
    id : Nat;
    command : Text;
    source : Text;
    result : Text;
    timestamp : Int;
    status : Text;
  };

  /// A document metadata record
  public type MeridianusDocument = {
    id : Nat;
    title : Text;
    docType : Text;
    contentHash : Text;
    sizeBytes : Nat;
    timestamp : Int;
  };

  /// A browser tab action record
  public type MeridianusTabAction = {
    id : Nat;
    action : Text;
    url : Text;
    tabTitle : Text;
    timestamp : Int;
  };

  // Backward-compatible aliases so existing stable vars keep working
  public type JarvisNote = MeridianusNote;
  public type JarvisCommand = MeridianusCommand;
  public type JarvisDocument = MeridianusDocument;
  public type JarvisTabAction = MeridianusTabAction;

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 3: CREATION ENGINES
  // ═══════════════════════════════════════════════════════════════════════════

  /// Token Forge — blueprint for minting sovereign tokens
  public type TokenBlueprint = {
    id : Nat;
    symbol : Text;
    name : Text;
    decimals : Nat;
    maxSupply : Nat;
    mintedAt : Int;
    forgedBy : Text;   // "MERIDIANUS-3" or higher
  };

  /// Canister Forge — blueprint for deploying child canisters
  public type CanisterBlueprint = {
    id : Nat;
    name : Text;
    template : Text;   // "frontend" | "backend" | "storage" | "worker"
    wasmHash : Text;
    deployedAt : Int;
    forgedBy : Text;
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 4: MICRO PHANTOM AI
  // ═══════════════════════════════════════════════════════════════════════════

  /// A micro phantom AI agent living inside MERIDIANUS
  public type PhantomAgent = {
    id : Nat;
    codex : Text;      // Greek letter identifier: α, β, γ, δ, ε, ζ, η, θ
    role : Text;        // research, code, data, security, deploy, monitor, optimize, create
    tasksCompleted : Nat;
    lastActive : Int;
    energy : Float;     // 0.0–1.0, φ-decays if idle
  };

  /// Initialize the 8 phantom agents for MERIDIANUS-8
  public func initPhantoms() : [PhantomAgent] {
    [
      { id = 0; codex = "alpha";   role = "research"; tasksCompleted = 0; lastActive = 0; energy = 1.0 },
      { id = 1; codex = "beta";    role = "code";     tasksCompleted = 0; lastActive = 0; energy = 1.0 },
      { id = 2; codex = "gamma";   role = "data";     tasksCompleted = 0; lastActive = 0; energy = 1.0 },
      { id = 3; codex = "delta";   role = "security"; tasksCompleted = 0; lastActive = 0; energy = 1.0 },
      { id = 4; codex = "epsilon"; role = "deploy";   tasksCompleted = 0; lastActive = 0; energy = 1.0 },
      { id = 5; codex = "zeta";    role = "monitor";  tasksCompleted = 0; lastActive = 0; energy = 1.0 },
      { id = 6; codex = "eta";     role = "optimize"; tasksCompleted = 0; lastActive = 0; energy = 1.0 },
      { id = 7; codex = "theta";   role = "create";   tasksCompleted = 0; lastActive = 0; energy = 1.0 },
    ];
  };

  /// Tick a phantom agent: φ-decay energy, increment task if active
  public func tickPhantom(agent : PhantomAgent, isActive : Bool, now : Int) : PhantomAgent {
    let decay : Float = 0.618033988749895;  // φ⁻¹
    let newEnergy : Float = if (isActive) {
      // Active: restore toward 1.0
      let boosted = agent.energy + 0.1;
      if (boosted > 1.0) { 1.0 } else { boosted };
    } else {
      // Idle: φ-decay
      agent.energy * decay;
    };
    {
      id = agent.id;
      codex = agent.codex;
      role = agent.role;
      tasksCompleted = if (isActive) { agent.tasksCompleted + 1 } else { agent.tasksCompleted };
      lastActive = if (isActive) { now } else { agent.lastActive };
      energy = newEnergy;
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 5: FULL MERIDIANUS STATE
  // ═══════════════════════════════════════════════════════════════════════════

  /// Full sovereign state of the MERIDIANUS AGI
  public type MeridianuState = {
    // Core assistant state (backward-compatible)
    notes : [MeridianusNote];
    commands : [MeridianusCommand];
    documents : [MeridianusDocument];
    tabActions : [MeridianusTabAction];
    heartbeatCount : Nat;
    lastHeartbeat : Int;
    isOnline : Bool;
    owner : Text;
    // Model identity
    activeTier : Text;
    // Creation engines
    tokenBlueprints : [TokenBlueprint];
    canisterBlueprints : [CanisterBlueprint];
    // Micro phantom AI
    phantoms : [PhantomAgent];
  };

  // Backward-compatible alias
  public type JarvisState = MeridianuState;

  /// Computed status summary
  public type MeridianuStatus = {
    totalNotes : Nat;
    totalCommands : Nat;
    totalDocuments : Nat;
    totalTabActions : Nat;
    heartbeatCount : Nat;
    lastHeartbeat : Int;
    isOnline : Bool;
    uptimeSeconds : Int;
    // MERIDIANUS extensions
    activeTier : Text;
    totalTokenBlueprints : Nat;
    totalCanisterBlueprints : Nat;
    activePhantoms : Nat;
    totalPhantomTasks : Nat;
  };

  // Backward-compatible alias
  public type JarvisStatus = MeridianuStatus;

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 6: STATE INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════

  /// Create initial MERIDIANUS state — starts at tier 8 (Sovereign) with phantoms
  public func initState() : MeridianuState {
    {
      notes = [];
      commands = [];
      documents = [];
      tabActions = [];
      heartbeatCount = 0;
      lastHeartbeat = 0;
      isOnline = false;
      owner = "Alfredo";
      activeTier = "MERIDIANUS-8";
      tokenBlueprints = [];
      canisterBlueprints = [];
      phantoms = initPhantoms();
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 7: STATE MUTATION FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════

  // Helper to copy state with one field changed
  func withNotes(state : MeridianuState, notes : [MeridianusNote]) : MeridianuState {
    { notes; commands = state.commands; documents = state.documents; tabActions = state.tabActions;
      heartbeatCount = state.heartbeatCount; lastHeartbeat = state.lastHeartbeat;
      isOnline = state.isOnline; owner = state.owner; activeTier = state.activeTier;
      tokenBlueprints = state.tokenBlueprints; canisterBlueprints = state.canisterBlueprints;
      phantoms = state.phantoms };
  };

  func withCommands(state : MeridianuState, commands : [MeridianusCommand]) : MeridianuState {
    { notes = state.notes; commands; documents = state.documents; tabActions = state.tabActions;
      heartbeatCount = state.heartbeatCount; lastHeartbeat = state.lastHeartbeat;
      isOnline = state.isOnline; owner = state.owner; activeTier = state.activeTier;
      tokenBlueprints = state.tokenBlueprints; canisterBlueprints = state.canisterBlueprints;
      phantoms = state.phantoms };
  };

  func withDocuments(state : MeridianuState, documents : [MeridianusDocument]) : MeridianuState {
    { notes = state.notes; commands = state.commands; documents; tabActions = state.tabActions;
      heartbeatCount = state.heartbeatCount; lastHeartbeat = state.lastHeartbeat;
      isOnline = state.isOnline; owner = state.owner; activeTier = state.activeTier;
      tokenBlueprints = state.tokenBlueprints; canisterBlueprints = state.canisterBlueprints;
      phantoms = state.phantoms };
  };

  func withTabActions(state : MeridianuState, tabActions : [MeridianusTabAction]) : MeridianuState {
    { notes = state.notes; commands = state.commands; documents = state.documents; tabActions;
      heartbeatCount = state.heartbeatCount; lastHeartbeat = state.lastHeartbeat;
      isOnline = state.isOnline; owner = state.owner; activeTier = state.activeTier;
      tokenBlueprints = state.tokenBlueprints; canisterBlueprints = state.canisterBlueprints;
      phantoms = state.phantoms };
  };

  /// Append a new note
  public func addNote(state : MeridianuState, title : Text, content : Text, tags : [Text], now : Int) : MeridianuState {
    let note : MeridianusNote = {
      id = state.notes.size();
      title; content; timestamp = now; tags;
    };
    withNotes(state, Array.append(state.notes, [note]));
  };

  /// Append a command execution record
  public func addCommand(state : MeridianuState, command : Text, source : Text, result : Text, now : Int) : MeridianuState {
    let cmd : MeridianusCommand = {
      id = state.commands.size();
      command; source; result; timestamp = now; status = "completed";
    };
    withCommands(state, Array.append(state.commands, [cmd]));
  };

  /// Append a document metadata record
  public func addDocument(state : MeridianuState, title : Text, docType : Text, contentHash : Text, sizeBytes : Nat, now : Int) : MeridianuState {
    let doc : MeridianusDocument = {
      id = state.documents.size();
      title; docType; contentHash; sizeBytes; timestamp = now;
    };
    withDocuments(state, Array.append(state.documents, [doc]));
  };

  /// Record a browser tab action
  public func recordTabAction(state : MeridianuState, action : Text, url : Text, tabTitle : Text, now : Int) : MeridianuState {
    let tab : MeridianusTabAction = {
      id = state.tabActions.size();
      action; url; tabTitle; timestamp = now;
    };
    withTabActions(state, Array.append(state.tabActions, [tab]));
  };

  /// Forge a token blueprint (MERIDIANUS-3+)
  public func forgeToken(state : MeridianuState, symbol : Text, name : Text, decimals : Nat, maxSupply : Nat, now : Int) : MeridianuState {
    let bp : TokenBlueprint = {
      id = state.tokenBlueprints.size();
      symbol; name; decimals; maxSupply;
      mintedAt = now;
      forgedBy = state.activeTier;
    };
    { notes = state.notes; commands = state.commands; documents = state.documents;
      tabActions = state.tabActions; heartbeatCount = state.heartbeatCount;
      lastHeartbeat = state.lastHeartbeat; isOnline = state.isOnline; owner = state.owner;
      activeTier = state.activeTier;
      tokenBlueprints = Array.append(state.tokenBlueprints, [bp]);
      canisterBlueprints = state.canisterBlueprints;
      phantoms = state.phantoms };
  };

  /// Forge a canister blueprint (MERIDIANUS-3+)
  public func forgeCanister(state : MeridianuState, name : Text, template : Text, wasmHash : Text, now : Int) : MeridianuState {
    let bp : CanisterBlueprint = {
      id = state.canisterBlueprints.size();
      name; template; wasmHash;
      deployedAt = now;
      forgedBy = state.activeTier;
    };
    { notes = state.notes; commands = state.commands; documents = state.documents;
      tabActions = state.tabActions; heartbeatCount = state.heartbeatCount;
      lastHeartbeat = state.lastHeartbeat; isOnline = state.isOnline; owner = state.owner;
      activeTier = state.activeTier;
      tokenBlueprints = state.tokenBlueprints;
      canisterBlueprints = Array.append(state.canisterBlueprints, [bp]);
      phantoms = state.phantoms };
  };

  /// Process a heartbeat: increment counter, mark online, tick phantoms
  public func heartbeat(state : MeridianuState, now : Int) : MeridianuState {
    // Tick all phantoms with round-robin activity (one active per beat)
    let activeIdx = state.heartbeatCount % PHANTOM_COUNT;
    let tickedPhantoms = Array.tabulate<PhantomAgent>(
      state.phantoms.size(),
      func(i : Nat) : PhantomAgent {
        tickPhantom(state.phantoms[i], i == activeIdx, now);
      }
    );
    { notes = state.notes; commands = state.commands; documents = state.documents;
      tabActions = state.tabActions;
      heartbeatCount = state.heartbeatCount + 1;
      lastHeartbeat = now;
      isOnline = true;
      owner = state.owner;
      activeTier = state.activeTier;
      tokenBlueprints = state.tokenBlueprints;
      canisterBlueprints = state.canisterBlueprints;
      phantoms = tickedPhantoms };
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 8: QUERY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════

  func recentSlice<T>(items : [T], limit : Nat) : [T] {
    let total = items.size();
    if (total <= limit) { return items };
    let start = total - limit : Nat;
    Array.subArray(items, start, limit);
  };

  /// Compute full MERIDIANUS status
  public func getStatus(state : MeridianuState, now : Int) : MeridianuStatus {
    let uptime : Int = if (state.lastHeartbeat > 0) { now - state.lastHeartbeat } else { 0 };
    // Count active phantoms (energy > 0.5)
    var activeP : Nat = 0;
    var totalTasks : Nat = 0;
    for (p in state.phantoms.vals()) {
      if (p.energy > 0.5) { activeP += 1 };
      totalTasks += p.tasksCompleted;
    };
    {
      totalNotes = state.notes.size();
      totalCommands = state.commands.size();
      totalDocuments = state.documents.size();
      totalTabActions = state.tabActions.size();
      heartbeatCount = state.heartbeatCount;
      lastHeartbeat = state.lastHeartbeat;
      isOnline = state.isOnline;
      uptimeSeconds = uptime;
      activeTier = state.activeTier;
      totalTokenBlueprints = state.tokenBlueprints.size();
      totalCanisterBlueprints = state.canisterBlueprints.size();
      activePhantoms = activeP;
      totalPhantomTasks = totalTasks;
    };
  };

  public func getNotes(state : MeridianuState) : [MeridianusNote] { state.notes };
  public func getCommands(state : MeridianuState, limit : Nat) : [MeridianusCommand] { recentSlice(state.commands, limit) };
  public func getDocuments(state : MeridianuState) : [MeridianusDocument] { state.documents };
  public func getTabHistory(state : MeridianuState, limit : Nat) : [MeridianusTabAction] { recentSlice(state.tabActions, limit) };
  public func getTokenBlueprints(state : MeridianuState) : [TokenBlueprint] { state.tokenBlueprints };
  public func getCanisterBlueprints(state : MeridianuState) : [CanisterBlueprint] { state.canisterBlueprints };
  public func getPhantoms(state : MeridianuState) : [PhantomAgent] { state.phantoms };
};
