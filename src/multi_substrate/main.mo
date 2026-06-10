// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  CHIMERIA Multi-Substrate Canister                                                                        ║
// ║  Motoko + Python Unified Deployment Substrate                                                             ║
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
import Principal "mo:base/Principal";
import Result "mo:base/Result";

actor MultiSubstrate {

  // ═══════════════════════════════════════════════════════════════
  // TYPES
  // ═══════════════════════════════════════════════════════════════

  public type SubstrateId = Text;
  public type SubstrateKind = { #Motoko; #Python; #Hybrid };

  public type SubstrateStatus = {
    #Active;
    #Idle;
    #Deploying;
    #Error : Text;
  };

  public type SubstrateConfig = {
    id : SubstrateId;
    kind : SubstrateKind;
    name : Text;
    version : Text;
    endpoints : [Text];
    createdAt : Int;
    updatedAt : Int;
    status : SubstrateStatus;
  };

  public type SubstrateMessage = {
    sourceId : SubstrateId;
    targetId : SubstrateId;
    payload : Text;
    timestamp : Int;
    messageType : { #Command; #Event; #Query; #Response };
  };

  public type DeploymentManifest = {
    substrates : [SubstrateConfig];
    routes : [(SubstrateId, SubstrateId)];
    pythonBridge : ?PythonBridgeConfig;
  };

  public type PythonBridgeConfig = {
    host : Text;
    port : Nat;
    engines : [Text];
    healthEndpoint : Text;
  };

  // ═══════════════════════════════════════════════════════════════
  // STATE
  // ═══════════════════════════════════════════════════════════════

  stable var substrates : [(SubstrateId, SubstrateConfig)] = [];
  stable var messageLog : [SubstrateMessage] = [];
  stable var deploymentVersion : Nat = 0;

  let substrateMap = HashMap.HashMap<SubstrateId, SubstrateConfig>(16, Text.equal, Text.hash);
  let messageBuffer = Buffer.Buffer<SubstrateMessage>(256);

  // Initialize default substrates
  private func initDefaults() {
    let now = Time.now();

    let mokokoSubstrate : SubstrateConfig = {
      id = "motoko-genesis";
      kind = #Motoko;
      name = "Genesis Motoko Substrate";
      version = "1.0.0";
      endpoints = ["/api/motoko/genesis", "/api/motoko/laws", "/api/motoko/organisms"];
      createdAt = now;
      updatedAt = now;
      status = #Active;
    };

    let pythonSubstrate : SubstrateConfig = {
      id = "python-pythonista";
      kind = #Python;
      name = "Pythonista Intelligence Substrate";
      version = "0.2.0";
      endpoints = ["/api/python/animus", "/api/python/lingua", "/api/python/nexus"];
      createdAt = now;
      updatedAt = now;
      status = #Active;
    };

    let hybridSubstrate : SubstrateConfig = {
      id = "hybrid-chimeria";
      kind = #Hybrid;
      name = "CHIMERIA Hybrid Orchestrator";
      version = "1.0.0";
      endpoints = ["/api/hybrid/orchestrate", "/api/hybrid/deploy", "/api/hybrid/status"];
      createdAt = now;
      updatedAt = now;
      status = #Active;
    };

    substrateMap.put("motoko-genesis", mokokoSubstrate);
    substrateMap.put("python-pythonista", pythonSubstrate);
    substrateMap.put("hybrid-chimeria", hybridSubstrate);
  };

  // Run initialization
  initDefaults();

  // ═══════════════════════════════════════════════════════════════
  // PUBLIC API
  // ═══════════════════════════════════════════════════════════════

  /// Register a new substrate
  public shared(msg) func registerSubstrate(config : SubstrateConfig) : async Result.Result<SubstrateId, Text> {
    switch (substrateMap.get(config.id)) {
      case (?_existing) { #err("Substrate already registered: " # config.id) };
      case null {
        substrateMap.put(config.id, config);
        #ok(config.id)
      };
    };
  };

  /// Get substrate configuration
  public query func getSubstrate(id : SubstrateId) : async ?SubstrateConfig {
    substrateMap.get(id)
  };

  /// List all registered substrates
  public query func listSubstrates() : async [SubstrateConfig] {
    Iter.toArray(substrateMap.vals())
  };

  /// Update substrate status
  public shared(msg) func updateStatus(id : SubstrateId, status : SubstrateStatus) : async Result.Result<(), Text> {
    switch (substrateMap.get(id)) {
      case (?existing) {
        let updated : SubstrateConfig = {
          id = existing.id;
          kind = existing.kind;
          name = existing.name;
          version = existing.version;
          endpoints = existing.endpoints;
          createdAt = existing.createdAt;
          updatedAt = Time.now();
          status = status;
        };
        substrateMap.put(id, updated);
        #ok(())
      };
      case null { #err("Substrate not found: " # id) };
    };
  };

  /// Send a message between substrates
  public shared(msg) func sendMessage(message : SubstrateMessage) : async Result.Result<(), Text> {
    switch (substrateMap.get(message.sourceId), substrateMap.get(message.targetId)) {
      case (?_source, ?_target) {
        messageBuffer.add(message);
        #ok(())
      };
      case (null, _) { #err("Source substrate not found: " # message.sourceId) };
      case (_, null) { #err("Target substrate not found: " # message.targetId) };
    };
  };

  /// Get deployment manifest for all substrates
  public query func getDeploymentManifest() : async DeploymentManifest {
    let allSubstrates = Iter.toArray(substrateMap.vals());
    let routes : [(SubstrateId, SubstrateId)] = [
      ("motoko-genesis", "hybrid-chimeria"),
      ("python-pythonista", "hybrid-chimeria"),
      ("hybrid-chimeria", "motoko-genesis"),
      ("hybrid-chimeria", "python-pythonista"),
    ];

    {
      substrates = allSubstrates;
      routes = routes;
      pythonBridge = ?{
        host = "127.0.0.1";
        port = 8100;
        engines = ["AnimusEngine", "LinguaEngine", "OpticaEngine", "TactusEngine", "NexusEngine"];
        healthEndpoint = "/health";
      };
    }
  };

  /// Deploy all substrates (triggers deployment pipeline)
  public shared(msg) func deploy() : async Result.Result<Nat, Text> {
    deploymentVersion += 1;

    // Update all substrates to deploying status
    for ((id, config) in substrateMap.entries()) {
      let updated : SubstrateConfig = {
        id = config.id;
        kind = config.kind;
        name = config.name;
        version = config.version;
        endpoints = config.endpoints;
        createdAt = config.createdAt;
        updatedAt = Time.now();
        status = #Deploying;
      };
      substrateMap.put(id, updated);
    };

    // After deployment pipeline completes, set active
    for ((id, config) in substrateMap.entries()) {
      let updated : SubstrateConfig = {
        id = config.id;
        kind = config.kind;
        name = config.name;
        version = config.version;
        endpoints = config.endpoints;
        createdAt = config.createdAt;
        updatedAt = Time.now();
        status = #Active;
      };
      substrateMap.put(id, updated);
    };

    #ok(deploymentVersion)
  };

  /// Get health status
  public query func health() : async {
    version : Nat;
    substrateCount : Nat;
    messageCount : Nat;
    status : Text;
  } {
    {
      version = deploymentVersion;
      substrateCount = substrateMap.size();
      messageCount = messageBuffer.size();
      status = "operational";
    }
  };

  // ═══════════════════════════════════════════════════════════════
  // SYSTEM HOOKS
  // ═══════════════════════════════════════════════════════════════

  system func preupgrade() {
    substrates := Iter.toArray(substrateMap.entries());
    messageLog := Buffer.toArray(messageBuffer);
  };

  system func postupgrade() {
    for ((id, config) in substrates.vals()) {
      substrateMap.put(id, config);
    };
    for (msg in messageLog.vals()) {
      messageBuffer.add(msg);
    };
    substrates := [];
    messageLog := [];
  };
};
