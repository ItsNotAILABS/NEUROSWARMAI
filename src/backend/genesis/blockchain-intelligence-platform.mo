// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  BLOCKCHAIN INTELLIGENCE PLATFORM — PRODUCTION GRADE                                                      ║
// ║  Alpha Framework №3: Cryptocurrency + Smart Contracts + DeFi + NFT Analytics                             ║
// ║  Commercial Deployment System for Blockchain Intelligence                                                 ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Nat64 "mo:core/Nat64";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Iter "mo:core/Iter";
import Text "mo:core/Text";
import Time "mo:core/Time";
import Principal "mo:core/Principal";
import HashMap "mo:core/HashMap";
import Hash "mo:core/Hash";

import NovaIntelligence "nova-intelligence-engine";
import NovaComputing "../../intelligence_core/computing/core";
import NovaEmergence "../../intelligence_core/emergence/kuramoto";
import FiveAlphas "five-alphas-unified-substrate";

module BlockchainIntelligencePlatform {

  // ═══════════════════════════════════════════════════════════════════════════════
  // TYPES — COMMERCIAL PRODUCTION SYSTEM
  // ═══════════════════════════════════════════════════════════════════════════════

  public type SwarmId = Text;
  public type AgentId = Nat;
  public type Timestamp = Nat64;
  public type BlockchainAddress = Text;
  public type TransactionHash = Text;

  public type BlockchainNetwork = {
    #Bitcoin;
    #Ethereum;
    #ICP;
    #Solana;
    #Polygon;
    #Avalanche;
    #BSC;
    #Arbitrum;
  };

  public type AnalysisType = {
    #WalletAnalysis;           // Track wallet behavior, identify whales
    #SmartContractAudit;       // Vulnerability detection in contracts
    #DeFiProtocolMonitoring;   // TVL, APY, risk metrics for DeFi protocols
    #NFTMarketAnalysis;        // Floor price, volume, rarity analytics
    #TransactionTracing;       // Follow money flows, identify patterns
    #TokenomicsAnalysis;       // Supply, distribution, holder analysis
  };

  public type BlockchainAgent = {
    id : AgentId;
    network : BlockchainNetwork;
    phase : Float;                    // Kuramoto phase [0, 2π)
    frequency : Float;                // Natural frequency
    activation : Float;               // [0, 1] operational status
    addressesMonitored : [BlockchainAddress];
    transactionsAnalyzed : Nat;
    anomaliesDetected : Nat;
    lastUpdate : Timestamp;
  };

  public type WalletInsight = {
    address : BlockchainAddress;
    balance : Float;
    transactionCount : Nat;
    category : Text;                  // "whale" | "exchange" | "contract" | "retail"
    riskScore : Float;                // [0, 1]
    confidence : Float;               // [0, 1]
  };

  public type SmartContractVulnerability = {
    contractAddress : BlockchainAddress;
    vulnerabilityType : Text;         // "reentrancy" | "overflow" | "access-control" | etc
    severity : Text;                  // "critical" | "high" | "medium" | "low"
    description : Text;
    remediation : Text;
  };

  public type DeFiProtocolMetrics = {
    protocolName : Text;
    tvl : Float;                      // Total Value Locked (USD)
    apy : Float;                      // Annual Percentage Yield
    riskScore : Float;                // [0, 1] computed risk
    userCount : Nat;
    smartContracts : [BlockchainAddress];
  };

  public type NFTCollection = {
    collectionAddress : BlockchainAddress;
    name : Text;
    floorPrice : Float;               // ETH or native token
    volume24h : Float;
    holderCount : Nat;
    rarityDistribution : [Float];     // Rarity scores
  };

  public type BlockchainMission = {
    id : SwarmId;
    analysisType : AnalysisType;
    networks : [BlockchainNetwork];
    agentCount : Nat;
    startTime : Timestamp;
    duration : Nat64;
    status : SwarmStatus;
    agents : [var BlockchainAgent];
    coherence : Float;                // Kuramoto R [0, 1]
    walletInsights : Buffer.Buffer<WalletInsight>;
    vulnerabilities : Buffer.Buffer<SmartContractVulnerability>;
    defiMetrics : Buffer.Buffer<DeFiProtocolMetrics>;
    nftCollections : Buffer.Buffer<NFTCollection>;
    client : Principal;
  };

  public type SwarmStatus = {
    #Initializing;
    #Scanning;
    #Analyzing;
    #Completed;
    #Aborted;
  };

  public type DeployRequest = {
    analysisType : AnalysisType;
    networks : [BlockchainNetwork];
    agentCount : Nat;
    duration : Nat64;
  };

  public type DeployResponse = {
    swarmId : SwarmId;
    status : Text;
    networksActive : Nat;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // STATE MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════════

  public class BlockchainSystem() {
    let swarms = HashMap.HashMap<SwarmId, BlockchainMission>(10, Text.equal, Text.hash);
    var nextSwarmId : Nat = 1;

    // ═══════════════════════════════════════════════════════════════════════════
    // COMMERCIAL API — DEPLOY BLOCKCHAIN SWARM
    // ═══════════════════════════════════════════════════════════════════════════

    public func deploySwarm(request : DeployRequest, client : Principal) : DeployResponse {
      let swarmId = "BLOCKCHAIN-" # Nat.toText(nextSwarmId);
      nextSwarmId += 1;

      // Initialize agents
      let agents = Array.init<BlockchainAgent>(request.agentCount, {
        id = 0;
        network = #Ethereum;
        phase = 0.0;
        frequency = 1.0;
        activation = 1.0;
        addressesMonitored = [];
        transactionsAnalyzed = 0;
        anomaliesDetected = 0;
        lastUpdate = Nat64.fromNat(Int.abs(Time.now()));
      });

      // Distribute agents across networks
      for (i in Iter.range(0, request.agentCount - 1)) {
        let networkIndex = i % request.networks.size();
        let network = request.networks[networkIndex];
        let phase = Float.fromInt(i) * NovaComputing.GOLDEN_ANGLE_RAD;
        let freq = 1.0 + 0.1 * Float.sin(phase);

        agents[i] := {
          id = i;
          network = network;
          phase = phase;
          frequency = freq;
          activation = 1.0;
          addressesMonitored = [];
          transactionsAnalyzed = 0;
          anomaliesDetected = 0;
          lastUpdate = Nat64.fromNat(Int.abs(Time.now()));
        };
      };

      let mission : BlockchainMission = {
        id = swarmId;
        analysisType = request.analysisType;
        networks = request.networks;
        agentCount = request.agentCount;
        startTime = Nat64.fromNat(Int.abs(Time.now()));
        duration = request.duration;
        status = #Initializing;
        agents = agents;
        coherence = 0.0;
        walletInsights = Buffer.Buffer<WalletInsight>(100);
        vulnerabilities = Buffer.Buffer<SmartContractVulnerability>(50);
        defiMetrics = Buffer.Buffer<DeFiProtocolMetrics>(20);
        nftCollections = Buffer.Buffer<NFTCollection>(50);
        client = client;
      };

      swarms.put(swarmId, mission);

      {
        swarmId = swarmId;
        status = "Initializing";
        networksActive = request.networks.size();
      }
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // COMMERCIAL API — GET BLOCKCHAIN INSIGHTS
    // ═══════════════════════════════════════════════════════════════════════════

    public func getBlockchainInsights(swarmId : SwarmId) : ?{
      walletInsights : [WalletInsight];
      vulnerabilities : [SmartContractVulnerability];
      defiMetrics : [DeFiProtocolMetrics];
      nftCollections : [NFTCollection];
      coherence : Float;
      totalTransactionsAnalyzed : Nat;
    } {
      switch (swarms.get(swarmId)) {
        case null { null };
        case (?mission) {
          var totalTx : Nat = 0;
          for (agent in Array.freeze(mission.agents).vals()) {
            totalTx += agent.transactionsAnalyzed;
          };

          ?{
            walletInsights = Buffer.toArray(mission.walletInsights);
            vulnerabilities = Buffer.toArray(mission.vulnerabilities);
            defiMetrics = Buffer.toArray(mission.defiMetrics);
            nftCollections = Buffer.toArray(mission.nftCollections);
            coherence = mission.coherence;
            totalTransactionsAnalyzed = totalTx;
          }
        };
      };
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // COMMERCIAL API — WALLET ANALYSIS
    // ═══════════════════════════════════════════════════════════════════════════

    public func analyzeWallet(address : BlockchainAddress, network : BlockchainNetwork) : WalletInsight {
      // Simplified wallet analysis (real implementation would query blockchain)
      {
        address = address;
        balance = 100.0 + Float.sin(Float.fromInt(Text.hash(address))) * 50.0;
        transactionCount = 150;
        category = if (Float.sin(Float.fromInt(Text.hash(address))) > 0.5) "whale" else "retail";
        riskScore = 0.3;
        confidence = 0.85;
      }
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // HEARTBEAT TICK — KURAMOTO SYNCHRONIZATION
    // ═══════════════════════════════════════════════════════════════════════════

    public func tickSwarm(swarmId : SwarmId, dt : Float) : () {
      switch (swarms.get(swarmId)) {
        case null { () };
        case (?mission) {
          let n = mission.agents.size();
          let phases = Array.init<Float>(n, 0.0);
          let frequencies = Array.init<Float>(n, 0.0);

          for (i in Iter.range(0, n - 1)) {
            phases[i] := mission.agents[i].phase;
            frequencies[i] := mission.agents[i].frequency;
          };

          let coupling = 0.3 + mission.coherence * 0.4;
          NovaEmergence.kuramotoStep(phases, Array.freeze(frequencies), coupling, dt);

          for (i in Iter.range(0, n - 1)) {
            let agent = mission.agents[i];
            mission.agents[i] := {
              agent with
              phase = phases[i];
              activation = 0.5 + 0.5 * Float.sin(phases[i]);
            };
          };

          let (r, _) = NovaEmergence.kuramotoOrderParameter(Array.freeze(phases));

          let updatedMission = {
            mission with
            coherence = r;
            status = if (r > 0.85) #Scanning else mission.status;
          };

          swarms.put(swarmId, updatedMission);
        };
      };
    };

    public func getAllSwarms() : [(SwarmId, Text)] {
      Iter.toArray(Iter.map<(SwarmId, BlockchainMission), (SwarmId, Text)>(
        swarms.entries(),
        func((id, mission)) {
          let status = switch (mission.status) {
            case (#Initializing) { "Initializing" };
            case (#Scanning) { "Scanning" };
            case (#Analyzing) { "Analyzing" };
            case (#Completed) { "Completed" };
            case (#Aborted) { "Aborted" };
          };
          (id, status)
        }
      ))
    };

  };

}
