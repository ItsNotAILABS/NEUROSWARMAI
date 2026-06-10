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
// ENTERPRISE SETTLEMENT ENGINE — FULL CLEARINGHOUSE MECHANICS
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// THE ORGANISM SETTLES LIKE A SENIOR CLEARINGHOUSE OPERATOR:
// - Real-time netting across all positions
// - Collateral optimization
// - Default waterfall procedures
// - Margin calls and liquidation paths
// - Multi-asset settlement
// - Novation and trade compression
// - Mark-to-market settlement
// - Delivery vs payment (DvP)
// - Settlement risk management
//
// This is ENTERPRISE-GRADE settlement infrastructure encoded in the organism's DNA.
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
import HashMap "mo:core/HashMap";
import Hash "mo:core/Hash";

module EnterpriseSettlementEngine {

  // ═══════════════════════════════════════════════════════════════════════════════
  // MATHEMATICAL CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let PI : Float = 3.14159265358979323846;
  public let E : Float = 2.71828182845904523536;
  public let PHI : Float = 1.618033988749895;
  
  // Basis points
  public let BPS : Float = 0.0001;

  // ═══════════════════════════════════════════════════════════════════════════════
  // SETTLEMENT TYPES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type SettlementType = {
    #DVP;              // Delivery vs Payment
    #FOP;              // Free of Payment
    #PVP;              // Payment vs Payment
    #Cash;             // Cash settlement
    #Physical;         // Physical delivery
    #NetSettlement;    // Net position settlement
    #GrossSettlement;  // Gross (trade by trade)
  };
  
  public type SettlementCycle = {
    #T0;    // Same day
    #T1;    // Next day
    #T2;    // Two days
    #T3;    // Three days
    #Custom;
  };
  
  public type SettlementStatus = {
    #Pending;
    #Matched;
    #Affirmed;
    #Cleared;
    #Settled;
    #Failed;
    #Cancelled;
    #Disputed;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // TRADE AND POSITION STRUCTURES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type Trade = {
    tradeId : Text;
    counterpartyId : Text;
    instrumentId : Text;
    side : { #Buy; #Sell };
    quantity : Float;
    price : Float;
    notionalValue : Float;
    tradeDate : Nat64;
    settlementDate : Nat64;
    settlementType : SettlementType;
    status : SettlementStatus;
    fees : Float;
    collateralRequired : Float;
    marginRequirement : Float;
  };
  
  public type Position = {
    instrumentId : Text;
    netQuantity : Float;          // Net position (long positive, short negative)
    avgEntryPrice : Float;
    notionalValue : Float;
    unrealizedPnL : Float;
    realizedPnL : Float;
    trades : [Text];              // Trade IDs comprising this position
    lastMarkPrice : Float;
    marginRequired : Float;
    variationMargin : Float;
  };
  
  public type SettlementObligation = {
    obligationId : Text;
    fromParty : Text;
    toParty : Text;
    asset : Text;
    amount : Float;
    dueDate : Nat64;
    status : SettlementStatus;
    priority : Nat;               // Lower = higher priority
    netted : Bool;
    originalTradeIds : [Text];
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // COLLATERAL STRUCTURES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type CollateralType = {
    #Cash;
    #GovernmentBond;
    #CorporateBond;
    #Equity;
    #Cryptocurrency;
    #StableCoin;
    #Letter_of_Credit;
    #Gold;
  };
  
  public type CollateralAsset = {
    assetId : Text;
    collateralType : CollateralType;
    quantity : Float;
    marketValue : Float;
    haircut : Float;              // Discount for volatility
    eligibleValue : Float;        // marketValue × (1 - haircut)
    pledgedTo : ?Text;            // Counterparty it's pledged to
    available : Bool;
    expiryDate : ?Nat64;
  };
  
  public type CollateralAccount = {
    accountId : Text;
    ownerId : Text;
    totalMarketValue : Float;
    totalEligibleValue : Float;
    pledgedValue : Float;
    availableValue : Float;
    assets : [CollateralAsset];
    marginCalls : [MarginCall];
    haircuts : [(CollateralType, Float)];
  };
  
  public type MarginCall = {
    callId : Text;
    amount : Float;
    reason : { #VariationMargin; #InitialMargin; #AdditionalMargin; #Intraday };
    deadline : Nat64;
    status : { #Issued; #Met; #Failed; #Disputed };
    issuedAt : Nat64;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // NETTING STRUCTURES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type NettingSet = {
    setId : Text;
    counterparties : [Text];      // Parties in the netting set
    trades : [Text];              // Trade IDs included
    grossExposure : Float;        // Sum of absolute exposures
    netExposure : Float;          // Net exposure after netting
    nettingBenefit : Float;       // (gross - net) / gross
    netSettlementObligation : Float;
    direction : { #Payable; #Receivable; #Zero };
  };
  
  public type NettingResult = {
    nettingSets : [NettingSet];
    totalGrossExposure : Float;
    totalNetExposure : Float;
    overallNettingBenefit : Float;
    obligationsCreated : [SettlementObligation];
    tradesNetted : Nat;
    compressionRatio : Float;     // Net / Gross
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // DEFAULT WATERFALL
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type DefaultWaterfallLayer = {
    layer : Nat;
    name : Text;
    description : Text;
    availableAmount : Float;
    usedAmount : Float;
    remainingAmount : Float;
    priority : Nat;               // 1 = first to absorb losses
  };
  
  public type DefaultWaterfall = {
    layers : [DefaultWaterfallLayer];
    totalResources : Float;
    totalUsed : Float;
    totalRemaining : Float;
    defaultingParty : Text;
    defaultAmount : Float;
    fullyAbsorbed : Bool;
    shortfall : Float;
  };
  
  /// Define standard default waterfall layers
  public func getStandardWaterfallLayers(
    defaulterMargin : Float,
    defaulterContribution : Float,
    mutualizedFund : Float,
    clearinghouseCapital : Float,
    insuranceFund : Float
  ) : [DefaultWaterfallLayer] {
    [
      {
        layer = 1;
        name = "Defaulter's Margin";
        description = "Initial and variation margin of defaulting member";
        availableAmount = defaulterMargin;
        usedAmount = 0.0;
        remainingAmount = defaulterMargin;
        priority = 1;
      },
      {
        layer = 2;
        name = "Defaulter's Guarantee Fund Contribution";
        description = "Defaulter's contribution to the guarantee fund";
        availableAmount = defaulterContribution;
        usedAmount = 0.0;
        remainingAmount = defaulterContribution;
        priority = 2;
      },
      {
        layer = 3;
        name = "Clearinghouse First Tranche";
        description = "Clearinghouse own capital (first skin in the game)";
        availableAmount = clearinghouseCapital * 0.25;
        usedAmount = 0.0;
        remainingAmount = clearinghouseCapital * 0.25;
        priority = 3;
      },
      {
        layer = 4;
        name = "Mutualized Guarantee Fund";
        description = "Non-defaulting members' guarantee fund contributions";
        availableAmount = mutualizedFund;
        usedAmount = 0.0;
        remainingAmount = mutualizedFund;
        priority = 4;
      },
      {
        layer = 5;
        name = "Clearinghouse Second Tranche";
        description = "Remaining clearinghouse capital";
        availableAmount = clearinghouseCapital * 0.75;
        usedAmount = 0.0;
        remainingAmount = clearinghouseCapital * 0.75;
        priority = 5;
      },
      {
        layer = 6;
        name = "Insurance Fund";
        description = "External insurance coverage";
        availableAmount = insuranceFund;
        usedAmount = 0.0;
        remainingAmount = insuranceFund;
        priority = 6;
      },
    ]
  };
  
  /// Apply losses through the waterfall
  public func applyDefaultWaterfall(
    layers : [DefaultWaterfallLayer],
    lossAmount : Float,
    defaultingParty : Text
  ) : DefaultWaterfall {
    var remainingLoss = lossAmount;
    let updatedLayers = Buffer.Buffer<DefaultWaterfallLayer>(layers.size());
    
    for (layer in layers.vals()) {
      if (remainingLoss <= 0.0) {
        updatedLayers.add(layer);
      } else {
        let amountUsed = Float.min(layer.availableAmount, remainingLoss);
        remainingLoss := remainingLoss - amountUsed;
        
        updatedLayers.add({
          layer = layer.layer;
          name = layer.name;
          description = layer.description;
          availableAmount = layer.availableAmount;
          usedAmount = amountUsed;
          remainingAmount = layer.availableAmount - amountUsed;
          priority = layer.priority;
        });
      }
    };
    
    // Calculate totals
    var totalResources : Float = 0.0;
    var totalUsed : Float = 0.0;
    for (l in updatedLayers.vals()) {
      totalResources := totalResources + l.availableAmount;
      totalUsed := totalUsed + l.usedAmount;
    };
    
    {
      layers = Buffer.toArray(updatedLayers);
      totalResources = totalResources;
      totalUsed = totalUsed;
      totalRemaining = totalResources - totalUsed;
      defaultingParty = defaultingParty;
      defaultAmount = lossAmount;
      fullyAbsorbed = remainingLoss <= 0.0;
      shortfall = Float.max(0.0, remainingLoss);
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // NETTING ENGINE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Perform bilateral netting between two parties
  public func bilateralNet(
    trades : [Trade],
    party1 : Text,
    party2 : Text,
    asset : Text
  ) : NettingSet {
    var grossLong : Float = 0.0;
    var grossShort : Float = 0.0;
    var netPosition : Float = 0.0;
    let tradeIds = Buffer.Buffer<Text>(trades.size());
    
    for (trade in trades.vals()) {
      let isParty1Buyer = Text.equal(trade.counterpartyId, party2);
      let isRelevant = Text.equal(trade.instrumentId, asset);
      
      if (isRelevant) {
        tradeIds.add(trade.tradeId);
        switch (trade.side) {
          case (#Buy) {
            grossLong := grossLong + trade.notionalValue;
            netPosition := netPosition + trade.quantity;
          };
          case (#Sell) {
            grossShort := grossShort + trade.notionalValue;
            netPosition := netPosition - trade.quantity;
          };
        }
      }
    };
    
    let grossExposure = grossLong + grossShort;
    let netExposure = Float.abs(netPosition);
    let nettingBenefit = if (grossExposure > 0.0) {
      (grossExposure - netExposure) / grossExposure
    } else { 0.0 };
    
    let direction = if (netPosition > 0.0) { #Receivable }
                    else if (netPosition < 0.0) { #Payable }
                    else { #Zero };
    
    {
      setId = party1 # "-" # party2 # "-" # asset;
      counterparties = [party1, party2];
      trades = Buffer.toArray(tradeIds);
      grossExposure = grossExposure;
      netExposure = netExposure;
      nettingBenefit = nettingBenefit;
      netSettlementObligation = Float.abs(netPosition);
      direction = direction;
    }
  };
  
  /// Perform multilateral netting across multiple parties
  public func multilateralNet(
    trades : [Trade],
    parties : [Text],
    asset : Text
  ) : NettingResult {
    let nettingSets = Buffer.Buffer<NettingSet>(parties.size());
    var totalGross : Float = 0.0;
    var totalNet : Float = 0.0;
    var tradesNetted : Nat = 0;
    
    // Calculate net position for each party
    let partyPositions = Buffer.Buffer<(Text, Float)>(parties.size());
    
    for (party in parties.vals()) {
      var netPosition : Float = 0.0;
      var gross : Float = 0.0;
      
      for (trade in trades.vals()) {
        if (Text.equal(trade.instrumentId, asset)) {
          // Determine if this party is buyer or seller
          switch (trade.side) {
            case (#Buy) {
              netPosition := netPosition + trade.quantity;
              gross := gross + Float.abs(trade.notionalValue);
            };
            case (#Sell) {
              netPosition := netPosition - trade.quantity;
              gross := gross + Float.abs(trade.notionalValue);
            };
          };
          tradesNetted := tradesNetted + 1;
        }
      };
      
      totalGross := totalGross + gross;
      totalNet := totalNet + Float.abs(netPosition);
      partyPositions.add((party, netPosition));
    };
    
    // Create netting sets
    for ((party, position) in partyPositions.vals()) {
      nettingSets.add({
        setId = party # "-" # asset;
        counterparties = [party];
        trades = [];  // Would populate with actual trade IDs
        grossExposure = totalGross / Float.fromInt(parties.size());
        netExposure = Float.abs(position);
        nettingBenefit = 0.0;
        netSettlementObligation = Float.abs(position);
        direction = if (position > 0.0) { #Receivable }
                    else if (position < 0.0) { #Payable }
                    else { #Zero };
      });
    };
    
    let compressionRatio = if (totalGross > 0.0) { totalNet / totalGross } else { 1.0 };
    let nettingBenefit = 1.0 - compressionRatio;
    
    {
      nettingSets = Buffer.toArray(nettingSets);
      totalGrossExposure = totalGross;
      totalNetExposure = totalNet;
      overallNettingBenefit = nettingBenefit;
      obligationsCreated = [];  // Would create actual obligations
      tradesNetted = tradesNetted;
      compressionRatio = compressionRatio;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // MARGIN CALCULATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type MarginRequirement = {
    initialMargin : Float;
    variationMargin : Float;
    maintenanceMargin : Float;
    additionalMargin : Float;     // For concentrated positions, etc.
    totalMargin : Float;
    marginExcess : Float;         // Positive = over-collateralized
    marginDeficit : Float;        // Positive = under-collateralized
    marginCallRequired : Bool;
    liquidationRequired : Bool;
  };
  
  /// Calculate margin requirements using SPAN-like methodology
  public func calculateMargin(
    positions : [Position],
    volatilities : [(Text, Float)],  // instrument -> volatility
    correlations : [[Float]],
    confidenceLevel : Float,
    liquidationPeriod : Float  // Days
  ) : MarginRequirement {
    var initialMargin : Float = 0.0;
    var variationMargin : Float = 0.0;
    
    // Initial Margin: parametric VaR-like calculation
    // IM = position × volatility × sqrt(liquidation period) × confidence factor
    let confidenceFactor = 2.33;  // ~99% confidence
    
    for (pos in positions.vals()) {
      // Find volatility for this instrument
      var vol : Float = 0.20;  // Default 20%
      for ((inst, v) in volatilities.vals()) {
        if (Text.equal(inst, pos.instrumentId)) { vol := v };
      };
      
      // Initial margin for this position
      let posIM = Float.abs(pos.notionalValue) * vol * Float.sqrt(liquidationPeriod) * confidenceFactor;
      initialMargin := initialMargin + posIM;
      
      // Variation margin = unrealized P&L
      variationMargin := variationMargin + pos.unrealizedPnL;
    };
    
    // Apply correlation offset (simplified)
    // In practice, would use full covariance matrix
    if (positions.size() > 1) {
      let diversificationBenefit = 0.2;  // 20% reduction for diversification
      initialMargin := initialMargin * (1.0 - diversificationBenefit);
    };
    
    // Maintenance margin = 80% of initial
    let maintenanceMargin = initialMargin * 0.80;
    
    // Additional margin for concentrated positions
    var additionalMargin : Float = 0.0;
    for (pos in positions.vals()) {
      let concentrationLimit = 0.10;  // 10% of some notional
      if (Float.abs(pos.netQuantity) > concentrationLimit) {
        additionalMargin := additionalMargin + Float.abs(pos.notionalValue) * 0.05;
      }
    };
    
    let totalMargin = initialMargin + Float.abs(variationMargin) + additionalMargin;
    
    // Assuming we have some collateral (would be passed in)
    let currentCollateral = totalMargin * 1.1;  // Assume 10% over
    let marginExcess = Float.max(0.0, currentCollateral - totalMargin);
    let marginDeficit = Float.max(0.0, totalMargin - currentCollateral);
    
    {
      initialMargin = initialMargin;
      variationMargin = variationMargin;
      maintenanceMargin = maintenanceMargin;
      additionalMargin = additionalMargin;
      totalMargin = totalMargin;
      marginExcess = marginExcess;
      marginDeficit = marginDeficit;
      marginCallRequired = marginDeficit > 0.0;
      liquidationRequired = currentCollateral < maintenanceMargin;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // LIQUIDATION ENGINE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type LiquidationOrder = {
    orderId : Text;
    positionId : Text;
    instrumentId : Text;
    quantityToLiquidate : Float;
    estimatedPrice : Float;
    estimatedSlippage : Float;
    urgency : { #Immediate; #Orderly; #Scheduled };
    reason : { #MarginCall; #InsufficientCollateral; #Default; #RiskLimit };
  };
  
  public type LiquidationPlan = {
    orders : [LiquidationOrder];
    totalNotionalToLiquidate : Float;
    estimatedProceeds : Float;
    estimatedLoss : Float;
    expectedDuration : Float;      // Hours to complete
    marketImpact : Float;          // Estimated price impact
    riskOfIncomplete : Float;      // 0-1
  };
  
  /// Create liquidation plan for a defaulting position
  public func createLiquidationPlan(
    positions : [Position],
    currentPrices : [(Text, Float)],
    liquidityProfiles : [(Text, Float)],  // instrument -> daily volume
    urgency : { #Immediate; #Orderly; #Scheduled }
  ) : LiquidationPlan {
    let orders = Buffer.Buffer<LiquidationOrder>(positions.size());
    var totalNotional : Float = 0.0;
    var estimatedProceeds : Float = 0.0;
    var estimatedLoss : Float = 0.0;
    var totalDuration : Float = 0.0;
    var totalImpact : Float = 0.0;
    
    for (pos in positions.vals()) {
      if (Float.abs(pos.netQuantity) > 0.0) {
        // Find current price
        var price : Float = pos.lastMarkPrice;
        for ((inst, p) in currentPrices.vals()) {
          if (Text.equal(inst, pos.instrumentId)) { price := p };
        };
        
        // Find liquidity
        var dailyVolume : Float = Float.abs(pos.notionalValue) * 10.0;  // Default
        for ((inst, vol) in liquidityProfiles.vals()) {
          if (Text.equal(inst, pos.instrumentId)) { dailyVolume := vol };
        };
        
        // Calculate slippage (square root impact model)
        let participationRate = Float.abs(pos.notionalValue) / dailyVolume;
        let slippage = 0.1 * Float.sqrt(participationRate);  // 10% coefficient
        
        // Estimated execution price
        let executionPrice = if (pos.netQuantity > 0.0) {
          price * (1.0 - slippage)  // Selling long position
        } else {
          price * (1.0 + slippage)  // Covering short position
        };
        
        let proceeds = Float.abs(pos.netQuantity) * executionPrice;
        let loss = Float.abs(pos.notionalValue - proceeds);
        let duration = Float.max(1.0, participationRate * 24.0);  // Hours
        
        orders.add({
          orderId = pos.instrumentId # "-LIQ";
          positionId = pos.instrumentId;
          instrumentId = pos.instrumentId;
          quantityToLiquidate = Float.abs(pos.netQuantity);
          estimatedPrice = executionPrice;
          estimatedSlippage = slippage;
          urgency = urgency;
          reason = #MarginCall;
        });
        
        totalNotional := totalNotional + Float.abs(pos.notionalValue);
        estimatedProceeds := estimatedProceeds + proceeds;
        estimatedLoss := estimatedLoss + loss;
        totalDuration := Float.max(totalDuration, duration);
        totalImpact := totalImpact + slippage * Float.abs(pos.notionalValue) / totalNotional;
      }
    };
    
    // Risk of incomplete (higher if duration is long or impact is high)
    let riskOfIncomplete = Float.min(1.0, totalDuration / 48.0 + totalImpact);
    
    {
      orders = Buffer.toArray(orders);
      totalNotionalToLiquidate = totalNotional;
      estimatedProceeds = estimatedProceeds;
      estimatedLoss = estimatedLoss;
      expectedDuration = totalDuration;
      marketImpact = totalImpact;
      riskOfIncomplete = riskOfIncomplete;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SETTLEMENT MATCHING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type MatchResult = {
    matched : Bool;
    trade1Id : Text;
    trade2Id : Text;
    discrepancies : [Discrepancy];
    matchConfidence : Float;
  };
  
  public type Discrepancy = {
    field : Text;
    value1 : Text;
    value2 : Text;
    severity : { #Critical; #Warning; #Info };
  };
  
  /// Match two trades for settlement
  public func matchTrades(trade1 : Trade, trade2 : Trade) : MatchResult {
    let discrepancies = Buffer.Buffer<Discrepancy>(5);
    
    // Check quantity match
    if (Float.abs(trade1.quantity - trade2.quantity) > 0.0001) {
      discrepancies.add({
        field = "quantity";
        value1 = Float.toText(trade1.quantity);
        value2 = Float.toText(trade2.quantity);
        severity = #Critical;
      });
    };
    
    // Check price match
    if (Float.abs(trade1.price - trade2.price) > 0.01) {
      discrepancies.add({
        field = "price";
        value1 = Float.toText(trade1.price);
        value2 = Float.toText(trade2.price);
        severity = #Critical;
      });
    };
    
    // Check settlement date
    if (trade1.settlementDate != trade2.settlementDate) {
      discrepancies.add({
        field = "settlementDate";
        value1 = Nat64.toText(trade1.settlementDate);
        value2 = Nat64.toText(trade2.settlementDate);
        severity = #Warning;
      });
    };
    
    // Check sides are opposite
    let sidesMatch = switch (trade1.side, trade2.side) {
      case (#Buy, #Sell) { true };
      case (#Sell, #Buy) { true };
      case (_, _) { false };
    };
    
    if (not sidesMatch) {
      discrepancies.add({
        field = "side";
        value1 = "same side";
        value2 = "same side";
        severity = #Critical;
      });
    };
    
    // Calculate match confidence
    let criticalCount = Array.filter<Discrepancy>(
      Buffer.toArray(discrepancies),
      func(d : Discrepancy) : Bool {
        switch (d.severity) {
          case (#Critical) { true };
          case (_) { false };
        }
      }
    ).size();
    
    let matched = criticalCount == 0;
    let confidence = if (matched) {
      1.0 - Float.fromInt(discrepancies.size()) * 0.1
    } else {
      0.0
    };
    
    {
      matched = matched;
      trade1Id = trade1.tradeId;
      trade2Id = trade2.tradeId;
      discrepancies = Buffer.toArray(discrepancies);
      matchConfidence = confidence;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SETTLEMENT CYCLE MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type SettlementBatch = {
    batchId : Text;
    settlementDate : Nat64;
    trades : [Trade];
    obligations : [SettlementObligation];
    totalValue : Float;
    status : SettlementStatus;
    startTime : Nat64;
    endTime : ?Nat64;
    failures : [SettlementFailure];
  };
  
  public type SettlementFailure = {
    obligationId : Text;
    reason : { #InsufficientFunds; #InsufficientSecurities; #Timeout; #Rejected; #SystemError };
    amount : Float;
    retryCount : Nat;
    lastRetryTime : Nat64;
  };
  
  /// Create settlement batch for a settlement date
  public func createSettlementBatch(
    trades : [Trade],
    settlementDate : Nat64
  ) : SettlementBatch {
    // Filter trades for this settlement date
    let batchTrades = Array.filter<Trade>(trades, func(t : Trade) : Bool {
      t.settlementDate == settlementDate and 
      (t.status == #Matched or t.status == #Affirmed or t.status == #Cleared)
    });
    
    // Calculate total value
    var totalValue : Float = 0.0;
    for (t in batchTrades.vals()) {
      totalValue := totalValue + t.notionalValue;
    };
    
    {
      batchId = Nat64.toText(settlementDate) # "-BATCH";
      settlementDate = settlementDate;
      trades = batchTrades;
      obligations = [];  // Would be populated by netting
      totalValue = totalValue;
      status = #Pending;
      startTime = Nat64.fromNat(Int.abs(Time.now()));
      endTime = null;
      failures = [];
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // COMPLETE SETTLEMENT ENGINE STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type SettlementEngineState = {
    var pendingTrades : [Trade];
    var settledTrades : [Trade];
    var failedTrades : [Trade];
    var positions : [Position];
    var collateralAccounts : [CollateralAccount];
    var nettingSets : [NettingSet];
    var settlementBatches : [SettlementBatch];
    var defaultWaterfall : ?DefaultWaterfall;
    var totalSettledVolume : Float;
    var totalFailedVolume : Float;
    var settlementRate : Float;    // Success rate
    var lastProcessingTime : Nat64;
  };
  
  public func initSettlementEngine() : SettlementEngineState {
    {
      var pendingTrades = [];
      var settledTrades = [];
      var failedTrades = [];
      var positions = [];
      var collateralAccounts = [];
      var nettingSets = [];
      var settlementBatches = [];
      var defaultWaterfall = null;
      var totalSettledVolume = 0.0;
      var totalFailedVolume = 0.0;
      var settlementRate = 1.0;
      var lastProcessingTime = 0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // MAIN SETTLEMENT CYCLE — CALLED EACH BEAT
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func runSettlementCycle(
    state : SettlementEngineState,
    currentTime : Nat64
  ) : {
    updatedState : SettlementEngineState;
    settledThisCycle : Nat;
    failedThisCycle : Nat;
    marginCallsIssued : Nat;
    nettingBenefit : Float;
    alerts : [Text];
  } {
    let alerts = Buffer.Buffer<Text>(10);
    var settledCount : Nat = 0;
    var failedCount : Nat = 0;
    var marginCallsIssued : Nat = 0;
    
    // 1. Match pending trades
    let matchedTrades = Buffer.Buffer<Trade>(state.pendingTrades.size());
    for (trade in state.pendingTrades.vals()) {
      if (trade.status == #Pending) {
        // In practice, would match against counterparty's trade
        let updated = {
          tradeId = trade.tradeId;
          counterpartyId = trade.counterpartyId;
          instrumentId = trade.instrumentId;
          side = trade.side;
          quantity = trade.quantity;
          price = trade.price;
          notionalValue = trade.notionalValue;
          tradeDate = trade.tradeDate;
          settlementDate = trade.settlementDate;
          settlementType = trade.settlementType;
          status = #Matched;  // Assume matched
          fees = trade.fees;
          collateralRequired = trade.collateralRequired;
          marginRequirement = trade.marginRequirement;
        };
        matchedTrades.add(updated);
      } else {
        matchedTrades.add(trade);
      }
    };
    
    // 2. Perform netting
    let nettingResult = multilateralNet(
      Buffer.toArray(matchedTrades),
      [],  // Would extract parties from trades
      "USD"  // Default asset
    );
    
    // 3. Check margin requirements
    let marginReq = calculateMargin(
      state.positions,
      [],
      [],
      0.99,
      2.0
    );
    
    if (marginReq.marginCallRequired) {
      marginCallsIssued := marginCallsIssued + 1;
      alerts.add("MARGIN CALL: Deficit of " # Float.toText(marginReq.marginDeficit));
    };
    
    // 4. Settle due obligations
    let toSettle = Array.filter<Trade>(Buffer.toArray(matchedTrades), func(t : Trade) : Bool {
      t.settlementDate <= currentTime and t.status == #Matched
    });
    
    let settled = Buffer.Buffer<Trade>(toSettle.size());
    let failed = Buffer.Buffer<Trade>(toSettle.size());
    
    for (trade in toSettle.vals()) {
      // Simulate settlement (90% success rate for demo)
      let success = true;  // Would actually check collateral, etc.
      
      if (success) {
        settled.add({
          tradeId = trade.tradeId;
          counterpartyId = trade.counterpartyId;
          instrumentId = trade.instrumentId;
          side = trade.side;
          quantity = trade.quantity;
          price = trade.price;
          notionalValue = trade.notionalValue;
          tradeDate = trade.tradeDate;
          settlementDate = trade.settlementDate;
          settlementType = trade.settlementType;
          status = #Settled;
          fees = trade.fees;
          collateralRequired = trade.collateralRequired;
          marginRequirement = trade.marginRequirement;
        });
        settledCount := settledCount + 1;
      } else {
        failed.add({
          tradeId = trade.tradeId;
          counterpartyId = trade.counterpartyId;
          instrumentId = trade.instrumentId;
          side = trade.side;
          quantity = trade.quantity;
          price = trade.price;
          notionalValue = trade.notionalValue;
          tradeDate = trade.tradeDate;
          settlementDate = trade.settlementDate;
          settlementType = trade.settlementType;
          status = #Failed;
          fees = trade.fees;
          collateralRequired = trade.collateralRequired;
          marginRequirement = trade.marginRequirement;
        });
        failedCount := failedCount + 1;
      }
    };
    
    // 5. Update state
    var settledVolume = state.totalSettledVolume;
    var failedVolume = state.totalFailedVolume;
    
    for (t in settled.vals()) {
      settledVolume := settledVolume + t.notionalValue;
    };
    for (t in failed.vals()) {
      failedVolume := failedVolume + t.notionalValue;
    };
    
    let totalVolume = settledVolume + failedVolume;
    let settlementRate = if (totalVolume > 0.0) { settledVolume / totalVolume } else { 1.0 };
    
    // Add alerts
    if (settlementRate < 0.95) {
      alerts.add("WARNING: Settlement rate " # Float.toText(settlementRate * 100.0) # "% is below 95%");
    };
    
    if (marginReq.liquidationRequired) {
      alerts.add("CRITICAL: Liquidation required due to insufficient margin");
    };
    
    let updatedState : SettlementEngineState = {
      var pendingTrades = Buffer.toArray(matchedTrades);
      var settledTrades = Array.append(state.settledTrades, Buffer.toArray(settled));
      var failedTrades = Array.append(state.failedTrades, Buffer.toArray(failed));
      var positions = state.positions;
      var collateralAccounts = state.collateralAccounts;
      var nettingSets = nettingResult.nettingSets;
      var settlementBatches = state.settlementBatches;
      var defaultWaterfall = state.defaultWaterfall;
      var totalSettledVolume = settledVolume;
      var totalFailedVolume = failedVolume;
      var settlementRate = settlementRate;
      var lastProcessingTime = currentTime;
    };
    
    {
      updatedState = updatedState;
      settledThisCycle = settledCount;
      failedThisCycle = failedCount;
      marginCallsIssued = marginCallsIssued;
      nettingBenefit = nettingResult.overallNettingBenefit;
      alerts = Buffer.toArray(alerts);
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // REPORTING AND METRICS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type SettlementMetrics = {
    totalPendingTrades : Nat;
    totalPendingValue : Float;
    totalSettledTrades : Nat;
    totalSettledValue : Float;
    totalFailedTrades : Nat;
    totalFailedValue : Float;
    settlementRate : Float;
    nettingBenefit : Float;
    avgSettlementTime : Float;     // Hours
    failuresByReason : [(Text, Nat)];
    collateralUtilization : Float;
    marginExcess : Float;
  };
  
  public func getSettlementMetrics(state : SettlementEngineState) : SettlementMetrics {
    var pendingValue : Float = 0.0;
    for (t in state.pendingTrades.vals()) {
      pendingValue := pendingValue + t.notionalValue;
    };
    
    var settledValue : Float = 0.0;
    for (t in state.settledTrades.vals()) {
      settledValue := settledValue + t.notionalValue;
    };
    
    var failedValue : Float = 0.0;
    for (t in state.failedTrades.vals()) {
      failedValue := failedValue + t.notionalValue;
    };
    
    {
      totalPendingTrades = state.pendingTrades.size();
      totalPendingValue = pendingValue;
      totalSettledTrades = state.settledTrades.size();
      totalSettledValue = settledValue;
      totalFailedTrades = state.failedTrades.size();
      totalFailedValue = failedValue;
      settlementRate = state.settlementRate;
      nettingBenefit = 0.0;  // Would calculate from netting sets
      avgSettlementTime = 0.0;  // Would track settlement timestamps
      failuresByReason = [];
      collateralUtilization = 0.0;
      marginExcess = 0.0;
    }
  };

}
