// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  CHIMERIA Python Substrate Canister                                                                       ║
// ║  ICP ↔ Python Bridge for Pythonista Intelligence Engines                                                  ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Int "mo:base/Int";
import Time "mo:base/Time";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import HashMap "mo:base/HashMap";
import Iter "mo:base/Iter";
import Result "mo:base/Result";

actor PythonSubstrate {

  // ═══════════════════════════════════════════════════════════════
  // TYPES - Python Engine Bridge
  // ═══════════════════════════════════════════════════════════════

  public type EngineId = Text;

  public type PythonEngine = {
    id : EngineId;
    name : Text;
    category : { #Reasoning; #Language; #Vision; #Somatic; #Mesh };
    tools : [Text];
    status : { #Running; #Stopped; #Error : Text };
    lastHeartbeat : Int;
  };

  public type ToolInvocation = {
    engineId : EngineId;
    toolName : Text;
    input : Text;
    timestamp : Int;
    requestId : Text;
  };

  public type ToolResult = {
    requestId : Text;
    output : Text;
    success : Bool;
    executionTimeMs : Nat;
    timestamp : Int;
  };

  public type BridgeConfig = {
    pythonHost : Text;
    pythonPort : Nat;
    healthCheckInterval : Nat;
    maxRetries : Nat;
    timeoutMs : Nat;
  };

  // ═══════════════════════════════════════════════════════════════
  // STATE
  // ═══════════════════════════════════════════════════════════════

  stable var engineEntries : [(EngineId, PythonEngine)] = [];
  stable var resultEntries : [(Text, ToolResult)] = [];
  stable var bridgeConfig : BridgeConfig = {
    pythonHost = "127.0.0.1";
    pythonPort = 8100;
    healthCheckInterval = 30;
    maxRetries = 3;
    timeoutMs = 5000;
  };

  let engines = HashMap.HashMap<EngineId, PythonEngine>(8, Text.equal, Text.hash);
  let results = HashMap.HashMap<Text, ToolResult>(64, Text.equal, Text.hash);
  let pendingInvocations = Buffer.Buffer<ToolInvocation>(32);

  // Initialize the 5 Pythonista engines
  private func initEngines() {
    let now = Time.now();

    let animusEngine : PythonEngine = {
      id = "animus";
      name = "AnimusEngine";
      category = #Reasoning;
      tools = ["reason", "kuramoto_sync", "hebbian_learn", "phi_loss"];
      status = #Stopped;
      lastHeartbeat = now;
    };

    let linguaEngine : PythonEngine = {
      id = "lingua";
      name = "LinguaEngine";
      category = #Language;
      tools = ["summarize", "translate", "sentiment", "extract"];
      status = #Stopped;
      lastHeartbeat = now;
    };

    let opticaEngine : PythonEngine = {
      id = "optica";
      name = "OpticaEngine";
      category = #Vision;
      tools = ["classify_image", "detect_objects", "segment_image", "ocr"];
      status = #Stopped;
      lastHeartbeat = now;
    };

    let tactusEngine : PythonEngine = {
      id = "tactus";
      name = "TactusEngine";
      category = #Somatic;
      tools = ["sense", "pid_control", "morphogenesis", "interoception"];
      status = #Stopped;
      lastHeartbeat = now;
    };

    let nexusEngine : PythonEngine = {
      id = "nexus";
      name = "NexusEngine";
      category = #Mesh;
      tools = ["route", "bayesian_update", "small_world_connect", "consensus"];
      status = #Stopped;
      lastHeartbeat = now;
    };

    engines.put("animus", animusEngine);
    engines.put("lingua", linguaEngine);
    engines.put("optica", opticaEngine);
    engines.put("tactus", tactusEngine);
    engines.put("nexus", nexusEngine);
  };

  initEngines();

  // ═══════════════════════════════════════════════════════════════
  // PUBLIC API
  // ═══════════════════════════════════════════════════════════════

  /// Get bridge configuration
  public query func getBridgeConfig() : async BridgeConfig {
    bridgeConfig
  };

  /// Update bridge configuration
  public shared(msg) func setBridgeConfig(config : BridgeConfig) : async () {
    bridgeConfig := config;
  };

  /// List all Python engines
  public query func listEngines() : async [PythonEngine] {
    Iter.toArray(engines.vals())
  };

  /// Get a specific engine
  public query func getEngine(id : EngineId) : async ?PythonEngine {
    engines.get(id)
  };

  /// Record engine heartbeat (called by Python bridge)
  public shared(msg) func heartbeat(engineId : EngineId) : async Result.Result<(), Text> {
    switch (engines.get(engineId)) {
      case (?engine) {
        let updated : PythonEngine = {
          id = engine.id;
          name = engine.name;
          category = engine.category;
          tools = engine.tools;
          status = #Running;
          lastHeartbeat = Time.now();
        };
        engines.put(engineId, updated);
        #ok(())
      };
      case null { #err("Engine not found: " # engineId) };
    };
  };

  /// Invoke a Python tool (queued for bridge pickup)
  public shared(msg) func invokeTool(invocation : ToolInvocation) : async Result.Result<Text, Text> {
    switch (engines.get(invocation.engineId)) {
      case (?engine) {
        switch (engine.status) {
          case (#Running) {
            pendingInvocations.add(invocation);
            #ok(invocation.requestId)
          };
          case (#Stopped) { #err("Engine is stopped: " # invocation.engineId) };
          case (#Error(e)) { #err("Engine error: " # e) };
        };
      };
      case null { #err("Engine not found: " # invocation.engineId) };
    };
  };

  /// Get pending invocations (called by Python bridge to pick up work)
  public shared(msg) func getPendingInvocations() : async [ToolInvocation] {
    let pending = Buffer.toArray(pendingInvocations);
    pendingInvocations.clear();
    pending
  };

  /// Submit tool result (called by Python bridge after execution)
  public shared(msg) func submitResult(result : ToolResult) : async () {
    results.put(result.requestId, result);
  };

  /// Get tool result
  public query func getResult(requestId : Text) : async ?ToolResult {
    results.get(requestId)
  };

  /// Start all engines (signals Python bridge to initialize)
  public shared(msg) func startAll() : async Result.Result<Nat, Text> {
    var started : Nat = 0;
    for ((id, engine) in engines.entries()) {
      let updated : PythonEngine = {
        id = engine.id;
        name = engine.name;
        category = engine.category;
        tools = engine.tools;
        status = #Running;
        lastHeartbeat = Time.now();
      };
      engines.put(id, updated);
      started += 1;
    };
    #ok(started)
  };

  /// Stop all engines
  public shared(msg) func stopAll() : async Result.Result<Nat, Text> {
    var stopped : Nat = 0;
    for ((id, engine) in engines.entries()) {
      let updated : PythonEngine = {
        id = engine.id;
        name = engine.name;
        category = engine.category;
        tools = engine.tools;
        status = #Stopped;
        lastHeartbeat = engine.lastHeartbeat;
      };
      engines.put(id, updated);
      stopped += 1;
    };
    #ok(stopped)
  };

  /// Get substrate health
  public query func health() : async {
    totalEngines : Nat;
    runningEngines : Nat;
    pendingTasks : Nat;
    completedTasks : Nat;
    bridgeHost : Text;
    bridgePort : Nat;
  } {
    var running : Nat = 0;
    for ((_, engine) in engines.entries()) {
      switch (engine.status) {
        case (#Running) { running += 1 };
        case _ {};
      };
    };

    {
      totalEngines = engines.size();
      runningEngines = running;
      pendingTasks = pendingInvocations.size();
      completedTasks = results.size();
      bridgeHost = bridgeConfig.pythonHost;
      bridgePort = bridgeConfig.pythonPort;
    }
  };

  // ═══════════════════════════════════════════════════════════════
  // SYSTEM HOOKS
  // ═══════════════════════════════════════════════════════════════

  system func preupgrade() {
    engineEntries := Iter.toArray(engines.entries());
    resultEntries := Iter.toArray(results.entries());
  };

  system func postupgrade() {
    for ((id, engine) in engineEntries.vals()) {
      engines.put(id, engine);
    };
    for ((id, result) in resultEntries.vals()) {
      results.put(id, result);
    };
    engineEntries := [];
    resultEntries := [];
  };
};
