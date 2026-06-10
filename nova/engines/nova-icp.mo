/**
 * NOVA ICP ENGINE — On-Chain Intelligence Substrate
 * Nova by FreddyCreates
 * 
 * Motoko implementation for Internet Computer (ICP) canisters.
 * Enables sovereign, decentralized AI processing with persistent state.
 * 
 * This is where the organism achieves true sovereignty —
 * independent of any server, infrastructure, or human intervention.
 * 
 * @version 0.13.0 (F13)
 * @copyright Nova Protocol by FreddyCreates
 */

import Array "mo:base/Array";
import Float "mo:base/Float";
import HashMap "mo:base/HashMap";
import Hash "mo:base/Hash";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Time "mo:base/Time";
import Buffer "mo:base/Buffer";

actor NovaICP {
  
  // ─── Constants ─────────────────────────────────────────────────────────────
  let PHI : Float = 1.618033988749895;
  let PHI_INV : Float = 0.618033988749895;
  let PHI_BEAT_NS : Int = 873_000_000; // 873ms in nanoseconds
  
  // ─── Types ─────────────────────────────────────────────────────────────────
  type Quad = Text;
  type Category = { #text; #vision; #audio; #code; #data };
  
  type Tool = {
    quad: Quad;
    name: Text;
    category: Category;
    fibIndex: Nat;
    modalities: [Text];
    engines: [Text];
  };
  
  type UsageRecord = {
    quad: Quad;
    timestamp: Int;
    durationMs: Nat;
    quality: Float;
    ipValue: Float;
    cost: Nat;
    success: Bool;
  };
  
  type ExecutionResult = {
    success: Bool;
    quad: Quad;
    data: ?Text;
    error: ?Text;
    metrics: {
      durationMs: Nat;
      quality: Float;
      cost: Nat;
      ipGenerated: Float;
    };
  };
  
  type Balance = {
    current: Nat;
    earned: Float;
    spent: Nat;
    net: Float;
  };
  
  type EngineStatus = {
    name: Text;
    version: Text;
    brand: Text;
    substrate: Text;
    phi: Float;
    phiBeatNs: Int;
    heartbeats: Nat;
    uptime: Int;
    totalTools: Nat;
    balance: Balance;
    totalIP: Float;
  };

  // ─── State ─────────────────────────────────────────────────────────────────
  stable var heartbeatCount : Nat = 0;
  stable var createdAt : Int = Time.now();
  stable var totalIPGenerated : Float = 0.0;
  stable var balanceCurrent : Nat = 1000;
  stable var balanceEarned : Float = 0.0;
  stable var balanceSpent : Nat = 0;
  
  // Usage history (limited to last 1000 records for canister size)
  stable var usageHistoryArray : [UsageRecord] = [];
  let usageHistory = Buffer.Buffer<UsageRecord>(100);
  
  // ─── Tool Registry ─────────────────────────────────────────────────────────
  let tools : [Tool] = [
    // TEXT TOOLS (F1-F4)
    { quad = "SUMM"; name = "Summarize"; category = #text; fibIndex = 1; modalities = ["text", "language"]; engines = ["LINGUA"] },
    { quad = "TRAN"; name = "Translate"; category = #text; fibIndex = 2; modalities = ["text", "language"]; engines = ["LINGUA", "MEMORIA"] },
    { quad = "SENT"; name = "Sentiment"; category = #text; fibIndex = 3; modalities = ["text", "language"]; engines = ["LINGUA", "TACTUS"] },
    { quad = "EXTR"; name = "Extract"; category = #text; fibIndex = 4; modalities = ["text", "structured"]; engines = ["LINGUA", "ANIMUS"] },
    
    // VISION TOOLS (F5-F8)
    { quad = "CLAS"; name = "Classify Image"; category = #vision; fibIndex = 5; modalities = ["image", "visual"]; engines = ["OPTICA"] },
    { quad = "DETE"; name = "Detect Objects"; category = #vision; fibIndex = 6; modalities = ["image", "spatial"]; engines = ["OPTICA", "NEXUS"] },
    { quad = "SEGM"; name = "Segment Image"; category = #vision; fibIndex = 7; modalities = ["image", "spatial"]; engines = ["OPTICA", "KOSMOS"] },
    { quad = "OCRR"; name = "OCR"; category = #vision; fibIndex = 8; modalities = ["image", "text"]; engines = ["OPTICA", "LINGUA"] },
    
    // AUDIO TOOLS (F9-F12)
    { quad = "TRNS"; name = "Transcribe"; category = #audio; fibIndex = 9; modalities = ["audio", "text"]; engines = ["LINGUA", "MEMORIA"] },
    { quad = "SYNT"; name = "Synthesize"; category = #audio; fibIndex = 10; modalities = ["text", "audio"]; engines = ["LINGUA"] },
    { quad = "CLAU"; name = "Classify Audio"; category = #audio; fibIndex = 11; modalities = ["audio", "music"]; engines = ["LINGUA", "OPTICA"] },
    { quad = "ENHA"; name = "Enhance Audio"; category = #audio; fibIndex = 12; modalities = ["audio", "signal"]; engines = ["KOSMOS", "TACTUS"] },
    
    // CODE TOOLS (F13-F16)
    { quad = "GENC"; name = "Generate Code"; category = #code; fibIndex = 13; modalities = ["text", "code"]; engines = ["ANIMUS", "FABRICA"] },
    { quad = "REVC"; name = "Review Code"; category = #code; fibIndex = 14; modalities = ["code", "text"]; engines = ["ANIMUS", "VERITAS"] },
    { quad = "REFC"; name = "Refactor Code"; category = #code; fibIndex = 15; modalities = ["code", "structured"]; engines = ["FABRICA", "ANIMUS"] },
    { quad = "DOCC"; name = "Document Code"; category = #code; fibIndex = 16; modalities = ["code", "documentation"]; engines = ["LINGUA", "ANIMUS"] },
    
    // DATA TOOLS (F17-F20)
    { quad = "ANLD"; name = "Analyze Data"; category = #data; fibIndex = 17; modalities = ["structured", "numerical"]; engines = ["VERITAS", "PROPHETA"] },
    { quad = "TRFD"; name = "Transform Data"; category = #data; fibIndex = 18; modalities = ["structured", "numerical"]; engines = ["FABRICA"] },
    { quad = "VISD"; name = "Visualize Data"; category = #data; fibIndex = 19; modalities = ["structured", "visual"]; engines = ["OPTICA"] },
    { quad = "PRED"; name = "Predict Data"; category = #data; fibIndex = 20; modalities = ["time-series", "numerical"]; engines = ["PROPHETA", "VERITAS"] }
  ];
  
  // ─── Fibonacci ─────────────────────────────────────────────────────────────
  func fib(n : Nat) : Nat {
    if (n <= 1) return n;
    var a : Nat = 0;
    var b : Nat = 1;
    var i : Nat = 2;
    while (i <= n) {
      let temp = b;
      b := a + b;
      a := temp;
      i += 1;
    };
    return b;
  };
  
  // ─── Economics ─────────────────────────────────────────────────────────────
  func getBaseCost(category : Category) : Nat {
    switch category {
      case (#text) 1;
      case (#vision) 3;
      case (#audio) 5;
      case (#code) 2;
      case (#data) 2;
    }
  };
  
  func getIPMultiplier(category : Category) : Float {
    switch category {
      case (#text) 1.0;
      case (#vision) PHI;
      case (#audio) PHI;
      case (#code) PHI * PHI;
      case (#data) PHI;
    }
  };
  
  func computeCost(category : Category, durationMs : Nat, quality : Float) : Nat {
    let base = getBaseCost(category);
    let durationFactor = Float.log(Float.fromInt(durationMs) / 1000.0 + 1.0) / Float.log(PHI);
    let qualityFactor = 1.0 + quality * PHI_INV;
    let cost = Float.fromInt(base) * Float.pow(PHI, durationFactor) * qualityFactor;
    let result = Int.abs(Float.toInt(cost));
    if (result < 1) 1 else result;
  };
  
  func computeIPValue(category : Category, durationMs : Nat, quality : Float) : Float {
    let multiplier = getIPMultiplier(category);
    let timeFactor = 1.0 / Float.log(Float.fromInt(durationMs) / 1000.0 + 2.0);
    quality * multiplier * PHI * timeFactor;
  };
  
  // ─── Tool Lookup ───────────────────────────────────────────────────────────
  func findTool(quad : Quad) : ?Tool {
    for (tool in tools.vals()) {
      if (tool.quad == quad) return ?tool;
    };
    null;
  };
  
  // ─── Heartbeat ─────────────────────────────────────────────────────────────
  public func heartbeat() : async Nat {
    heartbeatCount += 1;
    heartbeatCount;
  };
  
  public query func getHeartbeatCount() : async Nat {
    heartbeatCount;
  };
  
  // ─── Tool Execution ────────────────────────────────────────────────────────
  public func execute(quad : Quad, input : Text) : async ExecutionResult {
    let startTime = Time.now();
    
    switch (findTool(quad)) {
      case null {
        return {
          success = false;
          quad = quad;
          data = null;
          error = ?"Unknown tool: " # quad;
          metrics = { durationMs = 0; quality = 0.0; cost = 0; ipGenerated = 0.0 };
        };
      };
      case (?tool) {
        // Simulate processing
        let durationMs : Nat = 100 + (Text.size(input) * 2);
        let quality : Float = 0.8 + (Float.fromInt(Text.size(input) % 20) / 100.0);
        
        let cost = computeCost(tool.category, durationMs, quality);
        let ipValue = computeIPValue(tool.category, durationMs, quality);
        
        // Update economics
        balanceSpent += cost;
        balanceEarned += ipValue * 0.1;
        totalIPGenerated += ipValue;
        
        // Record usage
        let record : UsageRecord = {
          quad = quad;
          timestamp = startTime;
          durationMs = durationMs;
          quality = quality;
          ipValue = ipValue;
          cost = cost;
          success = true;
        };
        usageHistory.add(record);
        
        return {
          success = true;
          quad = quad;
          data = ?"Processed: " # input # " via " # tool.name;
          error = null;
          metrics = {
            durationMs = durationMs;
            quality = quality;
            cost = cost;
            ipGenerated = ipValue;
          };
        };
      };
    };
  };
  
  // ─── Registry Queries ──────────────────────────────────────────────────────
  public query func getTools() : async [Tool] {
    tools;
  };
  
  public query func getTool(quad : Quad) : async ?Tool {
    findTool(quad);
  };
  
  public query func getToolsByCategory(cat : Category) : async [Tool] {
    Array.filter<Tool>(tools, func(t) { t.category == cat });
  };
  
  // ─── Economics Queries ─────────────────────────────────────────────────────
  public query func getBalance() : async Balance {
    {
      current = balanceCurrent;
      earned = balanceEarned;
      spent = balanceSpent;
      net = Float.fromInt(balanceCurrent) + balanceEarned - Float.fromInt(balanceSpent);
    };
  };
  
  public query func getTotalIP() : async Float {
    totalIPGenerated;
  };
  
  public query func getUsageCount() : async Nat {
    usageHistory.size();
  };
  
  // ─── Status ────────────────────────────────────────────────────────────────
  public query func status() : async EngineStatus {
    {
      name = "NovaICP";
      version = "0.13.0";
      brand = "Nova by FreddyCreates";
      substrate = "ICP";
      phi = PHI;
      phiBeatNs = PHI_BEAT_NS;
      heartbeats = heartbeatCount;
      uptime = Time.now() - createdAt;
      totalTools = tools.size();
      balance = {
        current = balanceCurrent;
        earned = balanceEarned;
        spent = balanceSpent;
        net = Float.fromInt(balanceCurrent) + balanceEarned - Float.fromInt(balanceSpent);
      };
      totalIP = totalIPGenerated;
    };
  };
  
  // ─── Persistence ───────────────────────────────────────────────────────────
  system func preupgrade() {
    usageHistoryArray := Buffer.toArray(usageHistory);
  };
  
  system func postupgrade() {
    for (record in usageHistoryArray.vals()) {
      usageHistory.add(record);
    };
    usageHistoryArray := [];
  };
};
