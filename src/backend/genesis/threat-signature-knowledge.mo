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
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// THREAT SIGNATURE KNOWLEDGE — ATTACK PATTERNS & EXPLOIT DETECTION
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// THE ORGANISM KNOWS THREATS LIKE A SENIOR SECURITY ANALYST:
// - Rugpull signatures and patterns
// - Smart contract exploit patterns
// - Oracle manipulation attacks
// - Flash loan attack signatures
// - Governance attack patterns
// - Social engineering indicators
// - Bridge exploit signatures
// - Economic attack vectors
// - MEV attack patterns
// - Protocol-specific vulnerabilities
//
// This knowledge is ENCODED, not learned. The organism is BORN knowing threats.
// When a threat signature matches, the organism KNOWS it's under attack.
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Nat64 "mo:core/Nat64";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Iter "mo:core/Iter";
import Option "mo:core/Option";
import Time "mo:core/Time";
import Text "mo:core/Text";

module ThreatSignatureKnowledge {

  // ═══════════════════════════════════════════════════════════════════════════════
  // MATHEMATICAL CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let PI : Float = 3.14159265358979323846;
  public let E : Float = 2.71828182845904523536;
  public let PHI : Float = 1.618033988749895;

  // ═══════════════════════════════════════════════════════════════════════════════
  // THREAT CATEGORIES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type ThreatCategory = {
    #Rugpull;           // Exit scam
    #SmartContractExploit;
    #OracleManipulation;
    #FlashLoanAttack;
    #GovernanceAttack;
    #BridgeExploit;
    #MEVAttack;
    #EconomicAttack;
    #SocialEngineering;
    #Phishing;
    #KeyCompromise;
    #InsiderThreat;
    #DDoS;
    #ReentrancyAttack;
    #OverflowUnderflow;
    #AccessControl;
    #FrontRunning;
    #SandwichAttack;
    #LiquidityCrisis;
    #ProtocolFailure;
  };
  
  public type ThreatSeverity = {
    #Critical;   // Immediate, existential threat
    #High;       // Significant damage likely
    #Medium;     // Moderate risk
    #Low;        // Minor concern
    #Info;       // Informational only
  };
  
  public func severityToScore(severity : ThreatSeverity) : Float {
    switch (severity) {
      case (#Critical) { 1.0 };
      case (#High) { 0.8 };
      case (#Medium) { 0.5 };
      case (#Low) { 0.3 };
      case (#Info) { 0.1 };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // THREAT SIGNATURES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type ThreatSignature = {
    id : Text;
    name : Text;
    category : ThreatCategory;
    severity : ThreatSeverity;
    description : Text;
    indicators : [ThreatIndicator];
    mitigations : [Text];
    historicalExamples : [Text];
    detectionConfidence : Float;  // 0-1
    falsePositiveRate : Float;    // 0-1
    responseUrgency : Float;      // 0-1 (how fast to respond)
  };
  
  public type ThreatIndicator = {
    indicatorType : IndicatorType;
    threshold : Float;
    weight : Float;        // Contribution to detection
    description : Text;
  };
  
  public type IndicatorType = {
    // On-chain indicators
    #LargeTransfer;              // Unusually large transfer
    #MultipleWithdrawals;        // Many withdrawals in short time
    #ContractSelfDestruct;       // Contract self-destructing
    #UnusualGasUsage;            // Abnormal gas consumption
    #FlashLoanSignature;         // Flash loan pattern detected
    #ReentrancyPattern;          // Reentrancy call pattern
    #DelegateCallAbuse;          // Suspicious delegatecall
    #ProxyUpgrade;               // Unexpected proxy upgrade
    #AdminKeyChange;             // Admin key modification
    #MintingSpike;               // Abnormal token minting
    #BurnSpike;                  // Abnormal token burning
    
    // Price indicators
    #RapidPriceMove;             // Price moves > X% in short time
    #OraclePriceDeviation;       // Oracle vs spot divergence
    #LiquidityDrain;             // Liquidity being removed
    #AbnormalVolume;             // Volume spike
    #SpreadWidening;             // Bid-ask spread widening
    
    // Protocol indicators
    #TVLDrop;                    // Total value locked dropping
    #GovernanceProposal;         // Suspicious governance proposal
    #TimelockBypass;             // Timelock being bypassed
    #MultiSigChange;             // Multi-sig configuration change
    #OracleSourceChange;         // Oracle data source change
    
    // Social indicators
    #TeamAnonymous;              // Anonymous team
    #SocialMediaSilence;         // Team goes silent
    #NegativeSentiment;          // Negative social sentiment spike
    #FakeAudit;                  // Fake or compromised audit
    #InfluencerPump;             // Coordinated influencer promotion
    
    // Technical indicators
    #UnverifiedContract;         // Contract not verified
    #SuspiciousCode;             // Known malicious code pattern
    #HoneypotPattern;            // Can buy but not sell
    #HiddenOwner;                // Hidden owner functions
    #DisabledTransfers;          // Transfer functions disabled
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // PRE-DEFINED THREAT SIGNATURES — RUGPULL PATTERNS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func getRugpullSignatures() : [ThreatSignature] {
    [
      {
        id = "RUG-001";
        name = "Liquidity Pool Drain";
        category = #Rugpull;
        severity = #Critical;
        description = "Owner removing all liquidity from trading pool";
        indicators = [
          { indicatorType = #LiquidityDrain; threshold = 0.5; weight = 0.4; description = "LP tokens being burned/removed" },
          { indicatorType = #LargeTransfer; threshold = 0.3; weight = 0.3; description = "Large token transfer to new wallet" },
          { indicatorType = #AdminKeyChange; threshold = 0.0; weight = 0.2; description = "Admin permissions changed" },
          { indicatorType = #SocialMediaSilence; threshold = 0.7; weight = 0.1; description = "Team communication stopped" },
        ];
        mitigations = ["Exit position immediately", "Alert community", "Document evidence"];
        historicalExamples = ["Squid Game Token", "AnubisDAO"];
        detectionConfidence = 0.95;
        falsePositiveRate = 0.05;
        responseUrgency = 1.0;
      },
      {
        id = "RUG-002";
        name = "Honeypot Token";
        category = #Rugpull;
        severity = #Critical;
        description = "Token allows buying but prevents selling";
        indicators = [
          { indicatorType = #HoneypotPattern; threshold = 0.0; weight = 0.5; description = "Sell transactions failing" },
          { indicatorType = #SuspiciousCode; threshold = 0.0; weight = 0.3; description = "Transfer restrictions in code" },
          { indicatorType = #UnverifiedContract; threshold = 0.0; weight = 0.1; description = "Contract source not verified" },
          { indicatorType = #TeamAnonymous; threshold = 0.0; weight = 0.1; description = "Anonymous developers" },
        ];
        mitigations = ["Never buy unverified tokens", "Test small sell before large buy", "Check contract code"];
        historicalExamples = ["Various meme tokens"];
        detectionConfidence = 0.90;
        falsePositiveRate = 0.10;
        responseUrgency = 0.9;
      },
      {
        id = "RUG-003";
        name = "Mint Function Abuse";
        category = #Rugpull;
        severity = #Critical;
        description = "Owner minting excessive tokens and dumping";
        indicators = [
          { indicatorType = #MintingSpike; threshold = 0.2; weight = 0.4; description = "Large token mint event" },
          { indicatorType = #LargeTransfer; threshold = 0.3; weight = 0.3; description = "Minted tokens being sold" },
          { indicatorType = #RapidPriceMove; threshold = -0.3; weight = 0.2; description = "Price dumping" },
          { indicatorType = #AbnormalVolume; threshold = 5.0; weight = 0.1; description = "Volume spike" },
        ];
        mitigations = ["Check for mint functions", "Verify total supply caps", "Monitor token events"];
        historicalExamples = ["Various DeFi exploits"];
        detectionConfidence = 0.85;
        falsePositiveRate = 0.15;
        responseUrgency = 0.95;
      },
    ]
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // PRE-DEFINED THREAT SIGNATURES — SMART CONTRACT EXPLOITS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func getSmartContractExploitSignatures() : [ThreatSignature] {
    [
      {
        id = "SCE-001";
        name = "Reentrancy Attack";
        category = #ReentrancyAttack;
        severity = #Critical;
        description = "Recursive call exploiting state update timing";
        indicators = [
          { indicatorType = #ReentrancyPattern; threshold = 0.0; weight = 0.5; description = "Recursive external calls detected" },
          { indicatorType = #UnusualGasUsage; threshold = 3.0; weight = 0.3; description = "Abnormal gas consumption" },
          { indicatorType = #MultipleWithdrawals; threshold = 5.0; weight = 0.2; description = "Multiple withdrawals in one tx" },
        ];
        mitigations = ["Use checks-effects-interactions", "Implement reentrancy guards", "Limit gas forwarded"];
        historicalExamples = ["The DAO Hack", "Cream Finance"];
        detectionConfidence = 0.92;
        falsePositiveRate = 0.08;
        responseUrgency = 1.0;
      },
      {
        id = "SCE-002";
        name = "Flash Loan Attack";
        category = #FlashLoanAttack;
        severity = #Critical;
        description = "Using flash loans to manipulate protocol state";
        indicators = [
          { indicatorType = #FlashLoanSignature; threshold = 0.0; weight = 0.4; description = "Flash loan detected in tx" },
          { indicatorType = #OraclePriceDeviation; threshold = 0.1; weight = 0.3; description = "Oracle price divergence" },
          { indicatorType = #AbnormalVolume; threshold = 10.0; weight = 0.2; description = "Massive volume spike" },
          { indicatorType = #RapidPriceMove; threshold = 0.2; weight = 0.1; description = "Rapid price movement" },
        ];
        mitigations = ["Use TWAP oracles", "Add flash loan resistance", "Implement cooldown periods"];
        historicalExamples = ["bZx", "Harvest Finance", "Pancake Bunny"];
        detectionConfidence = 0.88;
        falsePositiveRate = 0.12;
        responseUrgency = 1.0;
      },
      {
        id = "SCE-003";
        name = "Integer Overflow/Underflow";
        category = #OverflowUnderflow;
        severity = #High;
        description = "Arithmetic overflow or underflow in calculations";
        indicators = [
          { indicatorType = #SuspiciousCode; threshold = 0.0; weight = 0.5; description = "Unchecked arithmetic" },
          { indicatorType = #MintingSpike; threshold = 10.0; weight = 0.3; description = "Massive unexpected minting" },
          { indicatorType = #UnusualGasUsage; threshold = 2.0; weight = 0.2; description = "Unusual gas pattern" },
        ];
        mitigations = ["Use SafeMath or Solidity 0.8+", "Add bounds checking", "Validate inputs"];
        historicalExamples = ["Beauty Chain", "Various older contracts"];
        detectionConfidence = 0.85;
        falsePositiveRate = 0.15;
        responseUrgency = 0.9;
      },
      {
        id = "SCE-004";
        name = "Access Control Vulnerability";
        category = #AccessControl;
        severity = #Critical;
        description = "Unauthorized access to privileged functions";
        indicators = [
          { indicatorType = #HiddenOwner; threshold = 0.0; weight = 0.4; description = "Hidden admin functions" },
          { indicatorType = #AdminKeyChange; threshold = 0.0; weight = 0.3; description = "Ownership transfer" },
          { indicatorType = #ProxyUpgrade; threshold = 0.0; weight = 0.3; description = "Unauthorized upgrade" },
        ];
        mitigations = ["Implement proper access control", "Use OpenZeppelin AccessControl", "Audit permissions"];
        historicalExamples = ["Parity Wallet", "Various DeFi hacks"];
        detectionConfidence = 0.90;
        falsePositiveRate = 0.10;
        responseUrgency = 0.95;
      },
    ]
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // PRE-DEFINED THREAT SIGNATURES — ORACLE MANIPULATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func getOracleManipulationSignatures() : [ThreatSignature] {
    [
      {
        id = "ORC-001";
        name = "Spot Price Manipulation";
        category = #OracleManipulation;
        severity = #Critical;
        description = "Manipulating spot price used by oracle";
        indicators = [
          { indicatorType = #OraclePriceDeviation; threshold = 0.05; weight = 0.4; description = "Oracle vs real price divergence" },
          { indicatorType = #FlashLoanSignature; threshold = 0.0; weight = 0.3; description = "Flash loan in same block" },
          { indicatorType = #AbnormalVolume; threshold = 5.0; weight = 0.2; description = "Volume spike on manipulation venue" },
          { indicatorType = #RapidPriceMove; threshold = 0.1; weight = 0.1; description = "Rapid price movement" },
        ];
        mitigations = ["Use TWAP oracles", "Multiple oracle sources", "Circuit breakers"];
        historicalExamples = ["Mango Markets", "Various DeFi exploits"];
        detectionConfidence = 0.85;
        falsePositiveRate = 0.15;
        responseUrgency = 1.0;
      },
      {
        id = "ORC-002";
        name = "Oracle Source Compromise";
        category = #OracleManipulation;
        severity = #Critical;
        description = "Oracle data source itself compromised";
        indicators = [
          { indicatorType = #OracleSourceChange; threshold = 0.0; weight = 0.5; description = "Oracle source changed" },
          { indicatorType = #OraclePriceDeviation; threshold = 0.1; weight = 0.3; description = "Persistent price deviation" },
          { indicatorType = #AdminKeyChange; threshold = 0.0; weight = 0.2; description = "Oracle admin key change" },
        ];
        mitigations = ["Multi-source oracles", "Decentralized oracle networks", "Price deviation checks"];
        historicalExamples = ["Synthetix KRW oracle"];
        detectionConfidence = 0.80;
        falsePositiveRate = 0.20;
        responseUrgency = 0.95;
      },
    ]
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // PRE-DEFINED THREAT SIGNATURES — GOVERNANCE ATTACKS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func getGovernanceAttackSignatures() : [ThreatSignature] {
    [
      {
        id = "GOV-001";
        name = "Flash Loan Governance Attack";
        category = #GovernanceAttack;
        severity = #Critical;
        description = "Using flash-borrowed tokens for governance votes";
        indicators = [
          { indicatorType = #FlashLoanSignature; threshold = 0.0; weight = 0.4; description = "Flash loan used for voting" },
          { indicatorType = #GovernanceProposal; threshold = 0.0; weight = 0.3; description = "Suspicious proposal" },
          { indicatorType = #AbnormalVolume; threshold = 3.0; weight = 0.2; description = "Token volume spike before vote" },
          { indicatorType = #TimelockBypass; threshold = 0.0; weight = 0.1; description = "Timelock bypass attempt" },
        ];
        mitigations = ["Snapshot voting", "Time-weighted voting", "Vote escrow"];
        historicalExamples = ["Beanstalk", "Various DAO attacks"];
        detectionConfidence = 0.85;
        falsePositiveRate = 0.15;
        responseUrgency = 0.9;
      },
      {
        id = "GOV-002";
        name = "Malicious Proposal";
        category = #GovernanceAttack;
        severity = #High;
        description = "Proposal designed to drain treasury or change critical parameters";
        indicators = [
          { indicatorType = #GovernanceProposal; threshold = 0.0; weight = 0.5; description = "Proposal with suspicious code" },
          { indicatorType = #LargeTransfer; threshold = 0.5; weight = 0.3; description = "Large treasury transfer in proposal" },
          { indicatorType = #MultiSigChange; threshold = 0.0; weight = 0.2; description = "Multi-sig configuration change" },
        ];
        mitigations = ["Proposal review period", "Security council veto", "Executable simulation"];
        historicalExamples = ["Various DAO exploits"];
        detectionConfidence = 0.75;
        falsePositiveRate = 0.25;
        responseUrgency = 0.8;
      },
    ]
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // PRE-DEFINED THREAT SIGNATURES — MEV ATTACKS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func getMEVAttackSignatures() : [ThreatSignature] {
    [
      {
        id = "MEV-001";
        name = "Sandwich Attack";
        category = #SandwichAttack;
        severity = #Medium;
        description = "Front-run and back-run victim transaction";
        indicators = [
          { indicatorType = #FrontRunning; threshold = 0.0; weight = 0.4; description = "Front-run transaction detected" },
          { indicatorType = #SpreadWidening; threshold = 0.02; weight = 0.3; description = "Spread temporarily widened" },
          { indicatorType = #UnusualGasUsage; threshold = 2.0; weight = 0.2; description = "High gas priority fee" },
          { indicatorType = #AbnormalVolume; threshold = 2.0; weight = 0.1; description = "Volume burst around tx" },
        ];
        mitigations = ["Private mempool", "Slippage limits", "Flashbots Protect"];
        historicalExamples = ["Common on Uniswap"];
        detectionConfidence = 0.90;
        falsePositiveRate = 0.10;
        responseUrgency = 0.6;
      },
      {
        id = "MEV-002";
        name = "JIT Liquidity Attack";
        category = #MEVAttack;
        severity = #Low;
        description = "Just-in-time liquidity to capture fees";
        indicators = [
          { indicatorType = #FrontRunning; threshold = 0.0; weight = 0.5; description = "Liquidity added just before swap" },
          { indicatorType = #LiquidityDrain; threshold = 0.0; weight = 0.3; description = "Liquidity removed after swap" },
          { indicatorType = #UnusualGasUsage; threshold = 1.5; weight = 0.2; description = "Priority gas" },
        ];
        mitigations = ["Concentrated liquidity protection", "Fee timing"];
        historicalExamples = ["Uniswap V3 JIT"];
        detectionConfidence = 0.85;
        falsePositiveRate = 0.15;
        responseUrgency = 0.4;
      },
    ]
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // PRE-DEFINED THREAT SIGNATURES — BRIDGE EXPLOITS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func getBridgeExploitSignatures() : [ThreatSignature] {
    [
      {
        id = "BRG-001";
        name = "Bridge Validator Compromise";
        category = #BridgeExploit;
        severity = #Critical;
        description = "Bridge validators or keys compromised";
        indicators = [
          { indicatorType = #AdminKeyChange; threshold = 0.0; weight = 0.4; description = "Validator key rotation" },
          { indicatorType = #LargeTransfer; threshold = 0.5; weight = 0.3; description = "Large outbound transfer" },
          { indicatorType = #MultiSigChange; threshold = 0.0; weight = 0.2; description = "Multi-sig config change" },
          { indicatorType = #SocialMediaSilence; threshold = 0.5; weight = 0.1; description = "Team communication issues" },
        ];
        mitigations = ["Multi-sig with high threshold", "Hardware security modules", "Validator rotation"];
        historicalExamples = ["Ronin Bridge", "Harmony Horizon"];
        detectionConfidence = 0.80;
        falsePositiveRate = 0.20;
        responseUrgency = 1.0;
      },
      {
        id = "BRG-002";
        name = "Bridge Smart Contract Exploit";
        category = #BridgeExploit;
        severity = #Critical;
        description = "Vulnerability in bridge smart contract";
        indicators = [
          { indicatorType = #SuspiciousCode; threshold = 0.0; weight = 0.4; description = "Contract vulnerability" },
          { indicatorType = #MintingSpike; threshold = 5.0; weight = 0.3; description = "Excess minting on destination" },
          { indicatorType = #FlashLoanSignature; threshold = 0.0; weight = 0.2; description = "Flash loan in bridge tx" },
          { indicatorType = #UnusualGasUsage; threshold = 3.0; weight = 0.1; description = "Abnormal gas usage" },
        ];
        mitigations = ["Formal verification", "Multiple audits", "Bug bounty program"];
        historicalExamples = ["Wormhole", "Nomad"];
        detectionConfidence = 0.85;
        falsePositiveRate = 0.15;
        responseUrgency = 1.0;
      },
    ]
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // THREAT DETECTION ENGINE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type ThreatDetectionResult = {
    signature : ThreatSignature;
    matchScore : Float;           // 0-1 (how well pattern matches)
    matchedIndicators : [IndicatorMatch];
    confidence : Float;           // Adjusted confidence
    recommendedAction : ThreatAction;
    urgencyScore : Float;
    timestamp : Nat64;
  };
  
  public type IndicatorMatch = {
    indicator : ThreatIndicator;
    observedValue : Float;
    matched : Bool;
    contribution : Float;
  };
  
  public type ThreatAction = {
    #ImmediateExit;          // Exit all positions now
    #ReduceExposure;         // Reduce position size
    #HaltOperations;         // Stop new operations
    #IncreasedMonitoring;    // Watch closely
    #AlertGovernance;        // Notify governance
    #NoAction;               // False positive likely
  };
  
  /// Match observed values against a threat signature
  public func matchSignature(
    signature : ThreatSignature,
    observations : [(IndicatorType, Float)]
  ) : ThreatDetectionResult {
    let matches = Buffer.Buffer<IndicatorMatch>(signature.indicators.size());
    var totalWeight : Float = 0.0;
    var matchedWeight : Float = 0.0;
    
    for (indicator in signature.indicators.vals()) {
      var observedValue : Float = 0.0;
      var found = false;
      
      // Find matching observation
      for ((obsType, obsValue) in observations.vals()) {
        if (indicatorTypesMatch(indicator.indicatorType, obsType)) {
          observedValue := obsValue;
          found := true;
        }
      };
      
      // Check if threshold exceeded
      let matched = found and observedValue >= indicator.threshold;
      let contribution = if (matched) { indicator.weight } else { 0.0 };
      
      matches.add({
        indicator = indicator;
        observedValue = observedValue;
        matched = matched;
        contribution = contribution;
      });
      
      totalWeight := totalWeight + indicator.weight;
      if (matched) {
        matchedWeight := matchedWeight + indicator.weight;
      }
    };
    
    let matchScore = if (totalWeight > 0.0) { matchedWeight / totalWeight } else { 0.0 };
    let confidence = matchScore * signature.detectionConfidence * (1.0 - signature.falsePositiveRate);
    
    // Determine action based on severity and confidence
    let action = determineAction(signature.severity, confidence, signature.responseUrgency);
    
    {
      signature = signature;
      matchScore = matchScore;
      matchedIndicators = Buffer.toArray(matches);
      confidence = confidence;
      recommendedAction = action;
      urgencyScore = signature.responseUrgency * matchScore;
      timestamp = Nat64.fromNat(Int.abs(Time.now()));
    }
  };
  
  // Helper: Check if indicator types match
  func indicatorTypesMatch(a : IndicatorType, b : IndicatorType) : Bool {
    // This is a simplified comparison - in practice would use variant comparison
    switch (a, b) {
      case (#LargeTransfer, #LargeTransfer) { true };
      case (#MultipleWithdrawals, #MultipleWithdrawals) { true };
      case (#ContractSelfDestruct, #ContractSelfDestruct) { true };
      case (#UnusualGasUsage, #UnusualGasUsage) { true };
      case (#FlashLoanSignature, #FlashLoanSignature) { true };
      case (#ReentrancyPattern, #ReentrancyPattern) { true };
      case (#DelegateCallAbuse, #DelegateCallAbuse) { true };
      case (#ProxyUpgrade, #ProxyUpgrade) { true };
      case (#AdminKeyChange, #AdminKeyChange) { true };
      case (#MintingSpike, #MintingSpike) { true };
      case (#BurnSpike, #BurnSpike) { true };
      case (#RapidPriceMove, #RapidPriceMove) { true };
      case (#OraclePriceDeviation, #OraclePriceDeviation) { true };
      case (#LiquidityDrain, #LiquidityDrain) { true };
      case (#AbnormalVolume, #AbnormalVolume) { true };
      case (#SpreadWidening, #SpreadWidening) { true };
      case (#TVLDrop, #TVLDrop) { true };
      case (#GovernanceProposal, #GovernanceProposal) { true };
      case (#TimelockBypass, #TimelockBypass) { true };
      case (#MultiSigChange, #MultiSigChange) { true };
      case (#OracleSourceChange, #OracleSourceChange) { true };
      case (#TeamAnonymous, #TeamAnonymous) { true };
      case (#SocialMediaSilence, #SocialMediaSilence) { true };
      case (#NegativeSentiment, #NegativeSentiment) { true };
      case (#FakeAudit, #FakeAudit) { true };
      case (#InfluencerPump, #InfluencerPump) { true };
      case (#UnverifiedContract, #UnverifiedContract) { true };
      case (#SuspiciousCode, #SuspiciousCode) { true };
      case (#HoneypotPattern, #HoneypotPattern) { true };
      case (#HiddenOwner, #HiddenOwner) { true };
      case (#DisabledTransfers, #DisabledTransfers) { true };
      case (#FrontRunning, #FrontRunning) { true };
      case (_, _) { false };
    }
  };
  
  // Helper: Determine action based on severity and confidence
  func determineAction(severity : ThreatSeverity, confidence : Float, urgency : Float) : ThreatAction {
    let combinedScore = severityToScore(severity) * confidence * urgency;
    
    if (combinedScore > 0.8) { #ImmediateExit }
    else if (combinedScore > 0.6) { #ReduceExposure }
    else if (combinedScore > 0.4) { #HaltOperations }
    else if (combinedScore > 0.2) { #IncreasedMonitoring }
    else if (combinedScore > 0.1) { #AlertGovernance }
    else { #NoAction }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // COMPLETE THREAT SCAN
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Get all pre-defined threat signatures
  public func getAllSignatures() : [ThreatSignature] {
    let all = Buffer.Buffer<ThreatSignature>(50);
    
    for (sig in getRugpullSignatures().vals()) { all.add(sig) };
    for (sig in getSmartContractExploitSignatures().vals()) { all.add(sig) };
    for (sig in getOracleManipulationSignatures().vals()) { all.add(sig) };
    for (sig in getGovernanceAttackSignatures().vals()) { all.add(sig) };
    for (sig in getMEVAttackSignatures().vals()) { all.add(sig) };
    for (sig in getBridgeExploitSignatures().vals()) { all.add(sig) };
    
    Buffer.toArray(all)
  };
  
  /// Scan all signatures against current observations
  public func scanAllThreats(
    observations : [(IndicatorType, Float)]
  ) : [ThreatDetectionResult] {
    let signatures = getAllSignatures();
    let results = Buffer.Buffer<ThreatDetectionResult>(signatures.size());
    
    for (sig in signatures.vals()) {
      let result = matchSignature(sig, observations);
      // Only include if confidence > 0.1
      if (result.confidence > 0.1) {
        results.add(result);
      }
    };
    
    // Sort by urgency
    let arr = Buffer.toArray(results);
    Array.sort<ThreatDetectionResult>(arr, func(a : ThreatDetectionResult, b : ThreatDetectionResult) : {#less; #equal; #greater} {
      if (a.urgencyScore > b.urgencyScore) { #less }
      else if (a.urgencyScore < b.urgencyScore) { #greater }
      else { #equal }
    })
  };
  
  /// Get threat assessment summary
  public func getThreatAssessment(
    observations : [(IndicatorType, Float)]
  ) : {
    overallThreatLevel : ThreatSeverity;
    highestRisk : ?ThreatDetectionResult;
    activeThreats : Nat;
    recommendedAction : ThreatAction;
    threatScore : Float;  // 0-1
    detailedResults : [ThreatDetectionResult];
  } {
    let results = scanAllThreats(observations);
    
    // Find highest risk
    var highestRisk : ?ThreatDetectionResult = null;
    var maxUrgency : Float = 0.0;
    var totalThreatScore : Float = 0.0;
    var activeCount : Nat = 0;
    
    for (result in results.vals()) {
      if (result.matchScore > 0.3) {
        activeCount := activeCount + 1;
        totalThreatScore := totalThreatScore + result.urgencyScore;
        
        if (result.urgencyScore > maxUrgency) {
          maxUrgency := result.urgencyScore;
          highestRisk := ?result;
        }
      }
    };
    
    // Determine overall threat level
    let avgThreatScore = if (activeCount > 0) { totalThreatScore / Float.fromInt(activeCount) } else { 0.0 };
    let overallLevel = if (avgThreatScore > 0.8) { #Critical }
                       else if (avgThreatScore > 0.6) { #High }
                       else if (avgThreatScore > 0.4) { #Medium }
                       else if (avgThreatScore > 0.2) { #Low }
                       else { #Info };
    
    // Determine overall recommended action
    let action = switch (highestRisk) {
      case (?hr) { hr.recommendedAction };
      case (null) { #NoAction };
    };
    
    {
      overallThreatLevel = overallLevel;
      highestRisk = highestRisk;
      activeThreats = activeCount;
      recommendedAction = action;
      threatScore = avgThreatScore;
      detailedResults = results;
    }
  };

}
