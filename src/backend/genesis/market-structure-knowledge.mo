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
// MARKET STRUCTURE KNOWLEDGE — COMPLETE MICROSTRUCTURE INTELLIGENCE
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// THE ORGANISM KNOWS MARKETS:
// - Order book dynamics (bid/ask spread, depth, imbalance)
// - Liquidity analysis (available liquidity, slippage estimation)
// - MEV (Maximal Extractable Value) detection and avoidance
// - Funding rates and basis trading
// - Spread analysis and arbitrage opportunities
// - Market making dynamics
// - Price impact estimation
// - Order flow toxicity
// - Volatility regimes
//
// This knowledge is ENCODED, not learned. The organism is BORN knowing markets.
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

module MarketStructureKnowledge {

  // ═══════════════════════════════════════════════════════════════════════════════
  // MATHEMATICAL CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let PI : Float = 3.14159265358979323846;
  public let E : Float = 2.71828182845904523536;
  public let PHI : Float = 1.618033988749895;
  public let SQRT2 : Float = 1.41421356237309504880;
  
  // Basis points conversion
  public let BPS : Float = 0.0001;  // 1 basis point = 0.01%

  // ═══════════════════════════════════════════════════════════════════════════════
  // ORDER BOOK TYPES AND STRUCTURES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type OrderSide = {
    #Bid;   // Buy order
    #Ask;   // Sell order
  };
  
  public type OrderType = {
    #Market;     // Execute immediately at best available
    #Limit;      // Execute at specified price or better
    #StopMarket; // Trigger market order at stop price
    #StopLimit;  // Trigger limit order at stop price
    #PostOnly;   // Only add to book, never take
    #IOC;        // Immediate or cancel
    #FOK;        // Fill or kill
    #GTC;        // Good til canceled
  };
  
  public type PriceLevel = {
    price : Float;
    quantity : Float;
    orderCount : Nat;
  };
  
  public type OrderBook = {
    bids : [PriceLevel];   // Sorted descending (best bid first)
    asks : [PriceLevel];   // Sorted ascending (best ask first)
    lastUpdateBeat : Nat64;
    midPrice : Float;
    spread : Float;
    spreadBps : Float;
  };
  
  public type OrderBookMetrics = {
    bidDepth1Pct : Float;      // Bid liquidity within 1% of mid
    askDepth1Pct : Float;      // Ask liquidity within 1% of mid
    bidDepth5Pct : Float;      // Bid liquidity within 5% of mid
    askDepth5Pct : Float;      // Ask liquidity within 5% of mid
    imbalance : Float;         // (bid - ask) / (bid + ask), -1 to 1
    microPrice : Float;        // Liquidity-weighted mid price
    bidAskRatio : Float;       // bid depth / ask depth
    orderBookSkew : Float;     // Asymmetry measure
    depthChangeVelocity : Float; // Rate of depth change
    wallDetected : Bool;       // Large order at specific level
    wallSide : ?OrderSide;     // Which side has the wall
    wallPrice : Float;         // Price level of wall
    wallSize : Float;          // Size of detected wall
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // LIQUIDITY ANALYSIS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type LiquidityMetrics = {
    availableLiquidityBid : Float;  // Total buy-side liquidity
    availableLiquidityAsk : Float;  // Total sell-side liquidity
    slippage1k : Float;             // Slippage for $1k trade
    slippage10k : Float;            // Slippage for $10k trade
    slippage100k : Float;           // Slippage for $100k trade
    slippage1m : Float;             // Slippage for $1M trade
    optimalOrderSize : Float;       // Size with minimal impact
    marketImpactCoeff : Float;      // Square-root impact coefficient
    kyleAlpha : Float;              // Kyle's lambda (price impact)
    amihudIlliquidity : Float;      // Amihud illiquidity ratio
    rollSpread : Float;             // Roll's implied spread
    effectiveSpread : Float;        // Half realized spread
    poissonIntensity : Float;       // Order arrival rate
  };
  
  /// Calculate slippage for a given order size
  public func calculateSlippage(
    book : OrderBook,
    side : OrderSide,
    size : Float
  ) : Float {
    let levels = switch (side) {
      case (#Bid) { book.asks };  // Buying consumes asks
      case (#Ask) { book.bids };  // Selling consumes bids
    };
    
    if (levels.size() == 0) { return 1.0 };  // 100% slippage (no liquidity)
    
    var remainingSize = size;
    var totalCost : Float = 0.0;
    var totalQuantity : Float = 0.0;
    let midPrice = book.midPrice;
    
    for (level in levels.vals()) {
      if (remainingSize <= 0.0) { break () };
      
      let fillQuantity = Float.min(remainingSize, level.quantity);
      totalCost := totalCost + fillQuantity * level.price;
      totalQuantity := totalQuantity + fillQuantity;
      remainingSize := remainingSize - fillQuantity;
    };
    
    if (totalQuantity == 0.0) { return 1.0 };
    
    let avgPrice = totalCost / totalQuantity;
    let slippage = Float.abs(avgPrice - midPrice) / midPrice;
    
    slippage
  };
  
  /// Calculate price impact coefficient using square-root model
  /// Impact = α × sqrt(Q/V) where Q is order size, V is daily volume
  public func calculateMarketImpact(
    orderSize : Float,
    dailyVolume : Float,
    volatility : Float
  ) : Float {
    if (dailyVolume <= 0.0) { return 1.0 };
    
    // Square-root impact model: σ × sqrt(Q/V)
    let participationRate = orderSize / dailyVolume;
    let impact = volatility * Float.sqrt(participationRate);
    
    Float.min(1.0, impact)  // Cap at 100%
  };
  
  /// Estimate Kyle's alpha (price impact per unit flow)
  public func estimateKyleAlpha(
    priceChanges : [Float],
    orderFlows : [Float]
  ) : Float {
    if (priceChanges.size() != orderFlows.size() or priceChanges.size() < 10) {
      return 0.0
    };
    
    // Linear regression: ΔP = α × Q + ε
    var sumXY : Float = 0.0;
    var sumXX : Float = 0.0;
    
    for (i in Iter.range(0, priceChanges.size() - 1)) {
      let x = orderFlows[i];
      let y = priceChanges[i];
      sumXY := sumXY + x * y;
      sumXX := sumXX + x * x;
    };
    
    if (sumXX == 0.0) { return 0.0 };
    
    sumXY / sumXX  // Kyle's lambda
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SPREAD ANALYSIS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type SpreadMetrics = {
    quotedSpread : Float;          // Best ask - best bid
    quotedSpreadBps : Float;       // Quoted spread in basis points
    effectiveSpread : Float;       // 2 × |trade price - midpoint|
    realizedSpread : Float;        // 2 × (trade price - midpoint at T+5)
    priceImprovement : Float;      // Quoted - effective spread
    adverseSelection : Float;      // Effective - realized spread
    inventoryCost : Float;         // Spread component from inventory risk
    orderProcessingCost : Float;   // Fixed cost per trade
    asymmetricInfo : Float;        // Information asymmetry component
    competitionFactor : Float;     // Market maker competition
  };
  
  /// Decompose spread into components (Huang-Stoll decomposition)
  public func decomposeSpread(
    quotedSpread : Float,
    priceChanges : [Float],
    tradeDirections : [Float],  // +1 for buy, -1 for sell
    tradeQuantities : [Float]
  ) : SpreadMetrics {
    let n = priceChanges.size();
    if (n < 20) {
      return {
        quotedSpread = quotedSpread;
        quotedSpreadBps = quotedSpread * 10000.0;
        effectiveSpread = quotedSpread * 0.8;
        realizedSpread = quotedSpread * 0.6;
        priceImprovement = quotedSpread * 0.2;
        adverseSelection = quotedSpread * 0.2;
        inventoryCost = quotedSpread * 0.3;
        orderProcessingCost = quotedSpread * 0.1;
        asymmetricInfo = quotedSpread * 0.4;
        competitionFactor = 0.5;
      }
    };
    
    // Compute effective spread (average)
    var effectiveSum : Float = 0.0;
    for (i in Iter.range(0, n - 1)) {
      effectiveSum := effectiveSum + Float.abs(priceChanges[i]) * 2.0;
    };
    let effectiveSpread = effectiveSum / Float.fromInt(n);
    
    // Compute realized spread (using lagged price change)
    var realizedSum : Float = 0.0;
    let lag = 5;
    for (i in Iter.range(0, n - lag - 1)) {
      let direction = tradeDirections[i];
      let futureChange = priceChanges[i + lag] - priceChanges[i];
      realizedSum := realizedSum + direction * futureChange * 2.0;
    };
    let realizedSpread = if (n > lag) { realizedSum / Float.fromInt(n - lag) } else { 0.0 };
    
    // Decomposition
    let priceImprovement = Float.max(0.0, quotedSpread - effectiveSpread);
    let adverseSelection = Float.max(0.0, effectiveSpread - realizedSpread);
    let inventoryCost = Float.max(0.0, realizedSpread - adverseSelection * 0.3);
    let orderProcessingCost = quotedSpread * 0.05;  // Estimate
    let asymmetricInfo = adverseSelection;
    let competitionFactor = 1.0 - effectiveSpread / quotedSpread;
    
    {
      quotedSpread = quotedSpread;
      quotedSpreadBps = quotedSpread * 10000.0;
      effectiveSpread = effectiveSpread;
      realizedSpread = realizedSpread;
      priceImprovement = priceImprovement;
      adverseSelection = adverseSelection;
      inventoryCost = inventoryCost;
      orderProcessingCost = orderProcessingCost;
      asymmetricInfo = asymmetricInfo;
      competitionFactor = competitionFactor;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // FUNDING RATE ANALYSIS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type FundingMetrics = {
    currentRate : Float;           // Current 8-hour funding rate
    annualizedRate : Float;        // Annualized funding rate
    predictedNextRate : Float;     // Predicted next funding rate
    fundingCost24h : Float;        // Total funding cost over 24h
    fundingDirection : {#Long; #Short; #Neutral};
    extremeLevel : Bool;           // Is funding rate extreme?
    historicalMean : Float;        // Rolling mean
    historicalStd : Float;         // Rolling standard deviation
    zScore : Float;                // (current - mean) / std
    revertProbability : Float;     // P(funding reverts to mean)
  };
  
  /// Analyze funding rate dynamics
  public func analyzeFunding(
    currentRate : Float,
    historicalRates : [Float]
  ) : FundingMetrics {
    let n = historicalRates.size();
    
    // Compute mean and std
    var sum : Float = 0.0;
    for (rate in historicalRates.vals()) {
      sum := sum + rate;
    };
    let mean = if (n > 0) { sum / Float.fromInt(n) } else { 0.0 };
    
    var sumSq : Float = 0.0;
    for (rate in historicalRates.vals()) {
      let diff = rate - mean;
      sumSq := sumSq + diff * diff;
    };
    let std = if (n > 1) { Float.sqrt(sumSq / Float.fromInt(n - 1)) } else { 0.01 };
    
    let zScore = if (std > 0.0) { (currentRate - mean) / std } else { 0.0 };
    let annualized = currentRate * 3.0 * 365.0;  // 3 funding periods per day
    
    // Determine direction
    let direction = if (currentRate > 0.0005) { #Long }  // Longs pay
                    else if (currentRate < -0.0005) { #Short }  // Shorts pay
                    else { #Neutral };
    
    // Extreme if beyond 2 std
    let extreme = Float.abs(zScore) > 2.0;
    
    // Predict next rate using mean reversion
    let alpha = 0.3;  // Mean reversion speed
    let predictedNext = currentRate + alpha * (mean - currentRate);
    
    // Revert probability increases with z-score
    let revertProb = 1.0 - Float.exp(-Float.abs(zScore) * 0.5);
    
    {
      currentRate = currentRate;
      annualizedRate = annualized;
      predictedNextRate = predictedNext;
      fundingCost24h = currentRate * 3.0;  // 3 funding periods
      fundingDirection = direction;
      extremeLevel = extreme;
      historicalMean = mean;
      historicalStd = std;
      zScore = zScore;
      revertProbability = revertProb;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // BASIS AND ARBITRAGE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type BasisMetrics = {
    spotPrice : Float;
    futuresPrice : Float;
    basis : Float;               // Futures - Spot
    basisPercent : Float;        // Basis / Spot
    annualizedBasis : Float;     // Annualized basis yield
    daysToExpiry : Nat;
    carryReturn : Float;         // Return from carry trade
    impliedRate : Float;         // Implied interest rate from basis
    convergenceSpeed : Float;    // Rate of basis convergence
    arbitrageOpportunity : Bool; // Is there an arb opportunity?
    arbExpectedReturn : Float;   // Expected arb return
    arbRiskAdjusted : Float;     // Risk-adjusted arb return
  };
  
  /// Analyze basis between spot and futures
  public func analyzeBasis(
    spotPrice : Float,
    futuresPrice : Float,
    daysToExpiry : Nat,
    riskFreeRate : Float,
    borrowCost : Float
  ) : BasisMetrics {
    let basis = futuresPrice - spotPrice;
    let basisPercent = basis / spotPrice;
    
    // Annualize
    let annualizationFactor = if (daysToExpiry > 0) { 365.0 / Float.fromInt(daysToExpiry) } else { 1.0 };
    let annualizedBasis = basisPercent * annualizationFactor;
    
    // Implied rate from basis
    // F = S × e^(r × T) → r = ln(F/S) / T
    let timeToExpiry = Float.fromInt(daysToExpiry) / 365.0;
    let impliedRate = if (timeToExpiry > 0.0 and spotPrice > 0.0 and futuresPrice > 0.0) {
      Float.log(futuresPrice / spotPrice) / timeToExpiry
    } else { 0.0 };
    
    // Carry return = basis - funding costs
    let carryReturn = annualizedBasis - riskFreeRate;
    
    // Arbitrage check: is basis larger than costs?
    let totalCost = riskFreeRate + borrowCost + 0.001;  // Plus 10 bps transaction
    let isArbOpportunity = Float.abs(annualizedBasis) > totalCost;
    let arbReturn = Float.abs(annualizedBasis) - totalCost;
    
    // Risk-adjusted (Sharpe-like)
    let arbRiskAdjusted = arbReturn / 0.05;  // Assume 5% annual vol
    
    {
      spotPrice = spotPrice;
      futuresPrice = futuresPrice;
      basis = basis;
      basisPercent = basisPercent;
      annualizedBasis = annualizedBasis;
      daysToExpiry = daysToExpiry;
      carryReturn = carryReturn;
      impliedRate = impliedRate;
      convergenceSpeed = if (daysToExpiry > 0) { Float.abs(basisPercent) / Float.fromInt(daysToExpiry) } else { 0.0 };
      arbitrageOpportunity = isArbOpportunity;
      arbExpectedReturn = arbReturn;
      arbRiskAdjusted = arbRiskAdjusted;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // MEV (MAXIMAL EXTRACTABLE VALUE) DETECTION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type MEVType = {
    #Sandwich;        // Front-run + back-run
    #Frontrun;        // Simple front-running
    #Backrun;         // Back-running large trades
    #Arbitrage;       // Cross-venue arb
    #Liquidation;     // Liquidation sniping
    #JITLiquidity;    // Just-in-time liquidity
  };
  
  public type MEVMetrics = {
    mevExposure : Float;         // Estimated MEV exposure
    sandwichRisk : Float;        // Risk of sandwich attack
    frontrunRisk : Float;        // Risk of front-running
    optimalGas : Float;          // Optimal gas for MEV protection
    slippageTolerance : Float;   // Recommended slippage tolerance
    mevProtectedPrice : Float;   // Price accounting for MEV
    flashbotsRecommended : Bool; // Should use private mempool?
    deadlineRecommendation : Nat; // Recommended tx deadline
    splitRecommendation : Nat;   // Number of splits for large order
  };
  
  /// Estimate MEV exposure for a trade
  public func estimateMEVExposure(
    orderSize : Float,
    priceImpact : Float,
    currentSpread : Float,
    poolLiquidity : Float,
    avgBlockMEV : Float
  ) : MEVMetrics {
    // Sandwich risk increases with size and impact
    let sandwichPotentialProfit = orderSize * priceImpact * 2.0;  // Front + back
    let sandwichRisk = Float.min(1.0, sandwichPotentialProfit / (avgBlockMEV + 0.001));
    
    // Front-run risk based on visibility
    let frontrunRisk = Float.min(1.0, orderSize / poolLiquidity);
    
    // Total MEV exposure
    let mevExposure = sandwichRisk * sandwichPotentialProfit * 0.8 + 
                      frontrunRisk * orderSize * priceImpact * 0.5;
    
    // Optimal slippage to avoid sandwich
    let slippageTolerance = Float.max(currentSpread * 2.0, priceImpact * 1.5);
    
    // MEV-protected price
    let mevProtectedPrice = priceImpact * (1.0 + slippageTolerance);
    
    // Should use Flashbots?
    let useFlashbots = mevExposure > 10.0;  // If MEV > $10
    
    // Split recommendation (larger orders should split more)
    let splits = if (orderSize > poolLiquidity * 0.1) { 5 }
                 else if (orderSize > poolLiquidity * 0.05) { 3 }
                 else if (orderSize > poolLiquidity * 0.01) { 2 }
                 else { 1 };
    
    {
      mevExposure = mevExposure;
      sandwichRisk = sandwichRisk;
      frontrunRisk = frontrunRisk;
      optimalGas = 0.0;  // Would need gas price data
      slippageTolerance = slippageTolerance;
      mevProtectedPrice = mevProtectedPrice;
      flashbotsRecommended = useFlashbots;
      deadlineRecommendation = 180;  // 3 minute deadline
      splitRecommendation = splits;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ORDER FLOW TOXICITY (VPIN)
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type OrderFlowMetrics = {
    vpin : Float;                  // Volume-synchronized probability of informed trading
    vpinAlert : Bool;              // VPIN above warning threshold
    buyVolume : Float;             // Total buy volume
    sellVolume : Float;            // Total sell volume
    netFlow : Float;               // Buy - Sell
    flowImbalance : Float;         // (Buy - Sell) / (Buy + Sell)
    aggressorRatio : Float;        // Market orders / total orders
    informedTradingProb : Float;   // Estimated probability of informed trading
    adverseFlowProbability : Float; // P(adverse price move after flow)
    flowPredictability : Float;    // How predictable is order flow
    toxicFlowThreshold : Float;    // Flow level that triggers warning
  };
  
  /// Calculate VPIN (Volume-synchronized Probability of Informed Trading)
  public func calculateVPIN(
    buyVolumes : [Float],
    sellVolumes : [Float],
    bucketSize : Float
  ) : Float {
    let n = Nat.min(buyVolumes.size(), sellVolumes.size());
    if (n < 20) { return 0.5 };  // Default to 50%
    
    // Compute volume buckets
    var vpinSum : Float = 0.0;
    var bucketCount : Nat = 0;
    var currentBuy : Float = 0.0;
    var currentSell : Float = 0.0;
    var currentVolume : Float = 0.0;
    
    for (i in Iter.range(0, n - 1)) {
      currentBuy := currentBuy + buyVolumes[i];
      currentSell := currentSell + sellVolumes[i];
      currentVolume := currentVolume + buyVolumes[i] + sellVolumes[i];
      
      // When bucket is full, compute imbalance
      if (currentVolume >= bucketSize) {
        let totalBucket = currentBuy + currentSell;
        if (totalBucket > 0.0) {
          let imbalance = Float.abs(currentBuy - currentSell) / totalBucket;
          vpinSum := vpinSum + imbalance;
          bucketCount := bucketCount + 1;
        };
        
        // Reset bucket
        currentBuy := 0.0;
        currentSell := 0.0;
        currentVolume := 0.0;
      }
    };
    
    if (bucketCount == 0) { return 0.5 };
    
    vpinSum / Float.fromInt(bucketCount)
  };
  
  /// Analyze order flow toxicity
  public func analyzeOrderFlow(
    buyVolumes : [Float],
    sellVolumes : [Float],
    tradeClassifications : [Float],  // +1 buy, -1 sell
    priceChanges : [Float]
  ) : OrderFlowMetrics {
    let n = buyVolumes.size();
    
    // Compute totals
    var totalBuy : Float = 0.0;
    var totalSell : Float = 0.0;
    for (i in Iter.range(0, n - 1)) {
      totalBuy := totalBuy + buyVolumes[i];
      totalSell := totalSell + sellVolumes[i];
    };
    
    let netFlow = totalBuy - totalSell;
    let totalVolume = totalBuy + totalSell;
    let flowImbalance = if (totalVolume > 0.0) { netFlow / totalVolume } else { 0.0 };
    
    // Calculate VPIN
    let vpin = calculateVPIN(buyVolumes, sellVolumes, totalVolume / 50.0);
    let vpinAlert = vpin > 0.7;  // Alert if VPIN > 70%
    
    // Estimate informed trading probability
    // Higher VPIN and persistent flow direction = more informed
    let informedProb = vpin * 0.7 + Float.abs(flowImbalance) * 0.3;
    
    // Adverse flow probability (flow predicts price against market makers)
    var correctPredictions : Nat = 0;
    let predictions = Nat.min(tradeClassifications.size(), priceChanges.size());
    if (predictions > 1) {
      for (i in Iter.range(0, predictions - 2)) {
        let flowDir = tradeClassifications[i];
        let priceDir = if (priceChanges[i + 1] > 0.0) { 1.0 } else { -1.0 };
        if (flowDir * priceDir > 0.0) {
          correctPredictions := correctPredictions + 1;
        }
      }
    };
    let adverseFlowProb = if (predictions > 1) { 
      Float.fromInt(correctPredictions) / Float.fromInt(predictions - 1) 
    } else { 0.5 };
    
    {
      vpin = vpin;
      vpinAlert = vpinAlert;
      buyVolume = totalBuy;
      sellVolume = totalSell;
      netFlow = netFlow;
      flowImbalance = flowImbalance;
      aggressorRatio = 0.5;  // Would need order type data
      informedTradingProb = informedProb;
      adverseFlowProbability = adverseFlowProb;
      flowPredictability = adverseFlowProb - 0.5;  // Excess over random
      toxicFlowThreshold = 0.7;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // VOLATILITY ANALYSIS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type VolatilityRegime = {
    #Low;           // Vol below 20%
    #Normal;        // Vol 20-40%
    #High;          // Vol 40-80%
    #Extreme;       // Vol above 80%
    #Crisis;        // Vol above 150%
  };
  
  public type VolatilityMetrics = {
    realizedVol : Float;           // Historical realized volatility
    realizedVolAnnualized : Float; // Annualized realized vol
    impliedVol : Float;            // Option-implied vol (if available)
    volOfVol : Float;              // Volatility of volatility
    regime : VolatilityRegime;
    regimeChangeProb : Float;      // P(regime change in next period)
    garchVol : Float;              // GARCH(1,1) estimated vol
    parkinsVol : Float;            // Parkinson high-low estimator
    yangZhangVol : Float;          // Yang-Zhang overnight + intraday
    volCone : {                    // Historical vol percentiles
      pct10 : Float;
      pct25 : Float;
      pct50 : Float;
      pct75 : Float;
      pct90 : Float;
    };
    volTrend : Float;              // Vol increasing or decreasing
    meanRevertTarget : Float;      // Long-term vol mean
  };
  
  /// Calculate realized volatility (close-to-close)
  public func calculateRealizedVol(returns : [Float]) : Float {
    let n = returns.size();
    if (n < 2) { return 0.0 };
    
    // Compute mean
    var sum : Float = 0.0;
    for (r in returns.vals()) { sum := sum + r };
    let mean = sum / Float.fromInt(n);
    
    // Compute variance
    var sumSq : Float = 0.0;
    for (r in returns.vals()) {
      let diff = r - mean;
      sumSq := sumSq + diff * diff;
    };
    
    Float.sqrt(sumSq / Float.fromInt(n - 1))
  };
  
  /// Calculate Parkinson volatility (high-low estimator)
  public func calculateParkinsonVol(highs : [Float], lows : [Float]) : Float {
    let n = Nat.min(highs.size(), lows.size());
    if (n < 2) { return 0.0 };
    
    var sum : Float = 0.0;
    for (i in Iter.range(0, n - 1)) {
      if (highs[i] > 0.0 and lows[i] > 0.0) {
        let logHL = Float.log(highs[i] / lows[i]);
        sum := sum + logHL * logHL;
      }
    };
    
    let factor = 1.0 / (4.0 * Float.log(2.0));
    Float.sqrt(factor * sum / Float.fromInt(n))
  };
  
  /// Determine volatility regime
  public func determineVolRegime(annualizedVol : Float) : VolatilityRegime {
    if (annualizedVol > 1.5) { #Crisis }
    else if (annualizedVol > 0.8) { #Extreme }
    else if (annualizedVol > 0.4) { #High }
    else if (annualizedVol > 0.2) { #Normal }
    else { #Low }
  };
  
  /// Full volatility analysis
  public func analyzeVolatility(
    returns : [Float],
    highs : [Float],
    lows : [Float],
    opens : [Float],
    closes : [Float]
  ) : VolatilityMetrics {
    let realizedVol = calculateRealizedVol(returns);
    let annualized = realizedVol * Float.sqrt(365.0);  // Assuming daily
    let parkinsVol = calculateParkinsonVol(highs, lows) * Float.sqrt(365.0);
    
    let regime = determineVolRegime(annualized);
    
    // Vol of vol (rolling vol of vol changes)
    let volChanges = Buffer.Buffer<Float>(returns.size());
    for (i in Iter.range(1, returns.size() - 1)) {
      let prevVol = Float.abs(returns[i - 1]);
      let currVol = Float.abs(returns[i]);
      if (prevVol > 0.0) {
        volChanges.add((currVol - prevVol) / prevVol);
      }
    };
    let volOfVol = calculateRealizedVol(Buffer.toArray(volChanges));
    
    // Vol trend (recent vs older)
    let midpoint = returns.size() / 2;
    let recentReturns = Array.tabulate<Float>(midpoint, func(i : Nat) : Float {
      returns[returns.size() - 1 - i]
    });
    let olderReturns = Array.tabulate<Float>(midpoint, func(i : Nat) : Float {
      returns[i]
    });
    let recentVol = calculateRealizedVol(recentReturns);
    let olderVol = calculateRealizedVol(olderReturns);
    let volTrend = recentVol - olderVol;
    
    // Estimate regime change probability (simplified)
    let regimeChangeProb = Float.min(1.0, volOfVol * 5.0);
    
    // Long-term mean (use historical average)
    let meanRevertTarget = 0.25;  // 25% annual vol as default target
    
    {
      realizedVol = realizedVol;
      realizedVolAnnualized = annualized;
      impliedVol = annualized * 1.1;  // Rough estimate
      volOfVol = volOfVol;
      regime = regime;
      regimeChangeProb = regimeChangeProb;
      garchVol = annualized;  // Simplified
      parkinsVol = parkinsVol;
      yangZhangVol = (annualized + parkinsVol) / 2.0;  // Average
      volCone = {
        pct10 = annualized * 0.6;
        pct25 = annualized * 0.8;
        pct50 = annualized;
        pct75 = annualized * 1.2;
        pct90 = annualized * 1.5;
      };
      volTrend = volTrend;
      meanRevertTarget = meanRevertTarget;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // MARKET MAKING DYNAMICS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type MarketMakerMetrics = {
    optimalSpread : Float;         // Optimal quote spread
    inventoryRisk : Float;         // Risk from current inventory
    adverseSelectionRisk : Float;  // Risk from informed traders
    optimalSkew : Float;           // How much to skew quotes
    hedgeRatio : Float;            // Optimal hedge ratio
    profitPerTrade : Float;        // Expected profit per round trip
    inventoryHalfLife : Float;     // Time to reduce inventory by half
    positionLimit : Float;         // Maximum inventory position
    quoteAdjustmentSpeed : Float;  // How fast to adjust quotes
    competitorCount : Nat;         // Estimated number of competitors
    marketShare : Float;           // Estimated market share
  };
  
  /// Calculate optimal market making parameters (Avellaneda-Stoikov model)
  public func calculateOptimalQuotes(
    midPrice : Float,
    volatility : Float,
    inventory : Float,
    maxInventory : Float,
    gamma : Float,  // Risk aversion parameter
    timeHorizon : Float
  ) : MarketMakerMetrics {
    // Optimal spread from A-S: spread = γσ²T + 2/γ × ln(1 + γ/κ)
    // Simplified version
    let baseSpread = volatility * volatility * timeHorizon * gamma;
    let optimalSpread = baseSpread + 2.0 * BPS;  // Minimum 2 bps
    
    // Inventory risk
    let inventoryRatio = Float.abs(inventory) / maxInventory;
    let inventoryRisk = inventoryRatio * volatility;
    
    // Optimal quote skew based on inventory
    // Skew = -inventory × risk_aversion × σ²
    let optimalSkew = -inventory / maxInventory * gamma * volatility * volatility;
    
    // Profit per trade (half spread minus adverse selection)
    let adverseSelection = volatility * 0.3;  // Estimate
    let profitPerTrade = optimalSpread / 2.0 - adverseSelection;
    
    // Inventory half-life (how quickly to mean-revert inventory)
    let inventoryHalfLife = if (gamma > 0.0) { 0.693 / gamma } else { 10.0 };
    
    {
      optimalSpread = optimalSpread;
      inventoryRisk = inventoryRisk;
      adverseSelectionRisk = adverseSelection;
      optimalSkew = optimalSkew;
      hedgeRatio = 1.0 - inventoryRatio;  // Hedge excess inventory
      profitPerTrade = profitPerTrade;
      inventoryHalfLife = inventoryHalfLife;
      positionLimit = maxInventory;
      quoteAdjustmentSpeed = gamma;
      competitorCount = 5;  // Estimate
      marketShare = 0.1;    // Estimate
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // COMPLETE MARKET ANALYSIS — ALL METRICS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type CompleteMarketAnalysis = {
    timestamp : Nat64;
    orderBook : OrderBookMetrics;
    liquidity : LiquidityMetrics;
    spread : SpreadMetrics;
    funding : FundingMetrics;
    basis : BasisMetrics;
    mev : MEVMetrics;
    orderFlow : OrderFlowMetrics;
    volatility : VolatilityMetrics;
    marketMaking : MarketMakerMetrics;
    overallMarketScore : Float;     // -1 to 1 (bearish to bullish)
    riskScore : Float;              // 0 to 1 (low to high risk)
    opportunityScore : Float;       // 0 to 1 (low to high opportunity)
    recommendedAction : {
      #AggressiveLong;
      #ModestLong;
      #Neutral;
      #ModestShort;
      #AggressiveShort;
      #ReduceExposure;
      #WaitForClarity;
    };
  };
  
  /// Generate comprehensive market analysis
  public func analyzeMarket(
    book : OrderBook,
    fundingRate : Float,
    historicalFunding : [Float],
    spotPrice : Float,
    futuresPrice : Float,
    daysToExpiry : Nat,
    buyVolumes : [Float],
    sellVolumes : [Float],
    returns : [Float],
    highs : [Float],
    lows : [Float],
    opens : [Float],
    closes : [Float]
  ) : CompleteMarketAnalysis {
    // Calculate all metrics
    let bookMetrics = analyzeOrderBook(book);
    let liquidityMetrics = analyzeLiquidity(book, returns);
    let spreadMetrics = decomposeSpread(book.spread, returns, [], []);
    let fundingMetrics = analyzeFunding(fundingRate, historicalFunding);
    let basisMetrics = analyzeBasis(spotPrice, futuresPrice, daysToExpiry, 0.05, 0.01);
    let mevMetrics = estimateMEVExposure(1000.0, liquidityMetrics.slippage1k, book.spread, 
                                          liquidityMetrics.availableLiquidityBid, 1.0);
    let flowMetrics = analyzeOrderFlow(buyVolumes, sellVolumes, [], returns);
    let volMetrics = analyzeVolatility(returns, highs, lows, opens, closes);
    let mmMetrics = calculateOptimalQuotes(book.midPrice, volMetrics.realizedVol, 0.0, 10000.0, 0.1, 1.0);
    
    // Calculate scores
    let marketScore = calculateMarketScore(bookMetrics, fundingMetrics, flowMetrics, volMetrics);
    let riskScore = calculateRiskScore(volMetrics, flowMetrics, fundingMetrics);
    let opportunityScore = calculateOpportunityScore(basisMetrics, fundingMetrics, volMetrics);
    
    // Determine action
    let action = determineAction(marketScore, riskScore, opportunityScore);
    
    {
      timestamp = Nat64.fromNat(Int.abs(Time.now()));
      orderBook = bookMetrics;
      liquidity = liquidityMetrics;
      spread = spreadMetrics;
      funding = fundingMetrics;
      basis = basisMetrics;
      mev = mevMetrics;
      orderFlow = flowMetrics;
      volatility = volMetrics;
      marketMaking = mmMetrics;
      overallMarketScore = marketScore;
      riskScore = riskScore;
      opportunityScore = opportunityScore;
      recommendedAction = action;
    }
  };
  
  // Helper functions
  func analyzeOrderBook(book : OrderBook) : OrderBookMetrics {
    var bidDepth1Pct : Float = 0.0;
    var askDepth1Pct : Float = 0.0;
    
    for (level in book.bids.vals()) {
      if (Float.abs(level.price - book.midPrice) / book.midPrice <= 0.01) {
        bidDepth1Pct := bidDepth1Pct + level.quantity;
      }
    };
    
    for (level in book.asks.vals()) {
      if (Float.abs(level.price - book.midPrice) / book.midPrice <= 0.01) {
        askDepth1Pct := askDepth1Pct + level.quantity;
      }
    };
    
    let totalDepth = bidDepth1Pct + askDepth1Pct;
    let imbalance = if (totalDepth > 0.0) { (bidDepth1Pct - askDepth1Pct) / totalDepth } else { 0.0 };
    
    {
      bidDepth1Pct = bidDepth1Pct;
      askDepth1Pct = askDepth1Pct;
      bidDepth5Pct = bidDepth1Pct * 3.0;  // Estimate
      askDepth5Pct = askDepth1Pct * 3.0;
      imbalance = imbalance;
      microPrice = book.midPrice * (1.0 + imbalance * 0.01);
      bidAskRatio = if (askDepth1Pct > 0.0) { bidDepth1Pct / askDepth1Pct } else { 1.0 };
      orderBookSkew = imbalance;
      depthChangeVelocity = 0.0;
      wallDetected = false;
      wallSide = null;
      wallPrice = 0.0;
      wallSize = 0.0;
    }
  };
  
  func analyzeLiquidity(book : OrderBook, returns : [Float]) : LiquidityMetrics {
    let slippage1k = calculateSlippage(book, #Bid, 1000.0);
    let slippage10k = calculateSlippage(book, #Bid, 10000.0);
    
    {
      availableLiquidityBid = book.bids.size() > 0 ? book.bids[0].quantity * 10.0 : 0.0;
      availableLiquidityAsk = book.asks.size() > 0 ? book.asks[0].quantity * 10.0 : 0.0;
      slippage1k = slippage1k;
      slippage10k = slippage10k;
      slippage100k = slippage10k * 3.0;
      slippage1m = slippage10k * 10.0;
      optimalOrderSize = 5000.0;
      marketImpactCoeff = 0.1;
      kyleAlpha = 0.001;
      amihudIlliquidity = 0.0001;
      rollSpread = book.spread;
      effectiveSpread = book.spread * 0.9;
      poissonIntensity = 10.0;
    }
  };
  
  func calculateMarketScore(
    book : OrderBookMetrics,
    funding : FundingMetrics,
    flow : OrderFlowMetrics,
    vol : VolatilityMetrics
  ) : Float {
    let bookScore = book.imbalance * 0.3;
    let fundingScore = -funding.zScore * 0.2;  // Contrarian
    let flowScore = flow.flowImbalance * 0.3;
    let volScore = if (vol.volTrend > 0.0) { -0.1 } else { 0.1 };  // Lower vol is better
    
    Float.max(-1.0, Float.min(1.0, bookScore + fundingScore + flowScore + volScore))
  };
  
  func calculateRiskScore(
    vol : VolatilityMetrics,
    flow : OrderFlowMetrics,
    funding : FundingMetrics
  ) : Float {
    let volRisk = Float.min(1.0, vol.realizedVolAnnualized);
    let flowRisk = flow.vpin;
    let fundingRisk = Float.min(1.0, Float.abs(funding.zScore) / 3.0);
    
    (volRisk * 0.4 + flowRisk * 0.3 + fundingRisk * 0.3)
  };
  
  func calculateOpportunityScore(
    basis : BasisMetrics,
    funding : FundingMetrics,
    vol : VolatilityMetrics
  ) : Float {
    let basisOpp = if (basis.arbitrageOpportunity) { basis.arbRiskAdjusted * 0.3 } else { 0.0 };
    let fundingOpp = Float.abs(funding.zScore) * 0.1;  // Extreme funding = opportunity
    let volOpp = if (vol.volTrend < 0.0) { 0.2 } else { 0.0 };  // Declining vol = opportunity
    
    Float.min(1.0, basisOpp + fundingOpp + volOpp)
  };
  
  func determineAction(marketScore : Float, riskScore : Float, opportunityScore : Float) : {
    #AggressiveLong;
    #ModestLong;
    #Neutral;
    #ModestShort;
    #AggressiveShort;
    #ReduceExposure;
    #WaitForClarity;
  } {
    if (riskScore > 0.8) { return #ReduceExposure };
    if (marketScore > 0.5 and riskScore < 0.5 and opportunityScore > 0.3) { return #AggressiveLong };
    if (marketScore > 0.2 and riskScore < 0.6) { return #ModestLong };
    if (marketScore < -0.5 and riskScore < 0.5) { return #AggressiveShort };
    if (marketScore < -0.2 and riskScore < 0.6) { return #ModestShort };
    if (Float.abs(marketScore) < 0.1 and riskScore > 0.5) { return #WaitForClarity };
    #Neutral
  };

}
