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
// ENTERPRISE TREASURY ENGINE — CASH MANAGEMENT & YIELD OPTIMIZATION
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// THE ORGANISM MANAGES TREASURY LIKE A SENIOR CFO:
// - Cash management with yield optimization
// - Duration matching for liabilities
// - Multi-protocol yield farming strategy
// - Risk-adjusted return optimization
// - Liquidity ladder management
// - Stress testing scenarios
// - Capital allocation optimization
// - Working capital management
// - Reserve management
//
// This is ENTERPRISE-GRADE treasury management encoded in the organism's DNA.
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

module EnterpriseTreasuryEngine {

  // ═══════════════════════════════════════════════════════════════════════════════
  // MATHEMATICAL CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let PI : Float = 3.14159265358979323846;
  public let E : Float = 2.71828182845904523536;
  public let PHI : Float = 1.618033988749895;
  
  // Basis points
  public let BPS : Float = 0.0001;
  
  // Time constants
  public let DAYS_PER_YEAR : Float = 365.0;
  public let BEATS_PER_DAY : Nat = 288;  // 5-minute beats

  // ═══════════════════════════════════════════════════════════════════════════════
  // ASSET TYPES FOR TREASURY
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type TreasuryAssetType = {
    #Cash;              // Immediate liquidity (stablecoins)
    #ShortTermDeposit;  // < 30 days
    #MediumTermDeposit; // 30-90 days
    #LongTermDeposit;   // > 90 days
    #LendingPool;       // DeFi lending
    #LiquidityPool;     // AMM LP positions
    #YieldFarm;         // Yield farming positions
    #Staking;           // Staked tokens
    #Bond;              // Fixed income
    #Reserve;           // Strategic reserve
  };
  
  public type TreasuryAsset = {
    id : Text;
    assetType : TreasuryAssetType;
    protocol : Text;              // Protocol name (Aave, Compound, etc.)
    underlyingAsset : Text;       // USDC, DAI, ETH, etc.
    principal : Float;            // Initial investment
    currentValue : Float;         // Current market value
    accruedYield : Float;         // Yield earned
    apy : Float;                  // Current APY
    duration : Float;             // Duration in days
    maturityDate : ?Nat64;        // Maturity timestamp (if applicable)
    lockupPeriod : Float;         // Lockup in days
    liquidityScore : Float;       // 0-1 (instant to locked)
    riskScore : Float;            // 0-1 (safe to risky)
    protocolRisk : Float;         // Smart contract risk
    impermanentLossRisk : Float;  // For LP positions
    collateralRatio : Float;      // For leveraged positions
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // YIELD CURVE AND INTEREST RATES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type YieldCurvePoint = {
    maturity : Float;    // Days to maturity
    rate : Float;        // Annualized rate
  };
  
  public type YieldCurve = {
    points : [YieldCurvePoint];
    shape : { #Normal; #Inverted; #Flat; #Humped };
    slope : Float;       // Slope of curve
    curvature : Float;   // Second derivative
    lastUpdate : Nat64;
  };
  
  /// Interpolate yield curve to get rate at any maturity
  public func interpolateYieldCurve(curve : YieldCurve, maturity : Float) : Float {
    let points = curve.points;
    let n = points.size();
    if (n == 0) { return 0.05 };  // Default 5%
    if (n == 1) { return points[0].rate };
    
    // Find surrounding points
    var lower : ?YieldCurvePoint = null;
    var upper : ?YieldCurvePoint = null;
    
    for (p in points.vals()) {
      if (p.maturity <= maturity) {
        switch (lower) {
          case (?l) { if (p.maturity > l.maturity) { lower := ?p } };
          case (null) { lower := ?p };
        }
      };
      if (p.maturity >= maturity) {
        switch (upper) {
          case (?u) { if (p.maturity < u.maturity) { upper := ?p } };
          case (null) { upper := ?p };
        }
      }
    };
    
    // Linear interpolation
    switch (lower, upper) {
      case (?l, ?u) {
        if (l.maturity == u.maturity) { l.rate }
        else {
          let t = (maturity - l.maturity) / (u.maturity - l.maturity);
          l.rate + t * (u.rate - l.rate)
        }
      };
      case (?l, null) { l.rate };
      case (null, ?u) { u.rate };
      case (null, null) { 0.05 };
    }
  };
  
  /// Determine yield curve shape
  public func determineYieldCurveShape(curve : YieldCurve) : { #Normal; #Inverted; #Flat; #Humped } {
    let points = curve.points;
    if (points.size() < 3) { return #Flat };
    
    let shortRate = points[0].rate;
    let midRate = points[points.size() / 2].rate;
    let longRate = points[points.size() - 1].rate;
    
    let shortLongDiff = longRate - shortRate;
    let midBump = midRate - (shortRate + longRate) / 2.0;
    
    if (Float.abs(shortLongDiff) < 0.005) {
      if (Float.abs(midBump) > 0.005) { #Humped } else { #Flat }
    } else if (shortLongDiff > 0.0) {
      if (midBump > 0.01) { #Humped } else { #Normal }
    } else {
      #Inverted
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // DURATION AND CONVEXITY
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type DurationMetrics = {
    macaulayDuration : Float;    // Weighted average time to cash flows
    modifiedDuration : Float;    // Price sensitivity to rate changes
    effectiveDuration : Float;   // For complex instruments
    dollarDuration : Float;      // DV01 - dollar value of 1bp
    convexity : Float;           // Second-order price sensitivity
    keyRateDurations : [Float];  // Duration at each key rate
  };
  
  /// Calculate duration metrics for a bond/position
  public func calculateDuration(
    principal : Float,
    couponRate : Float,
    yieldToMaturity : Float,
    maturityDays : Float,
    couponFrequency : Nat  // Per year
  ) : DurationMetrics {
    let maturityYears = maturityDays / DAYS_PER_YEAR;
    let periods = Int.abs(Float.toInt(maturityYears * Float.fromInt(couponFrequency)));
    let periodRate = yieldToMaturity / Float.fromInt(couponFrequency);
    let couponPayment = principal * couponRate / Float.fromInt(couponFrequency);
    
    var presentValue : Float = 0.0;
    var weightedTime : Float = 0.0;
    var weightedTimeSq : Float = 0.0;
    
    for (t in Iter.range(1, periods)) {
      let tf = Float.fromInt(t);
      let discountFactor = Float.pow(1.0 + periodRate, -tf);
      let cashFlow = if (t == periods) { couponPayment + principal } else { couponPayment };
      let pv = cashFlow * discountFactor;
      
      presentValue := presentValue + pv;
      weightedTime := weightedTime + tf * pv;
      weightedTimeSq := weightedTimeSq + tf * (tf + 1.0) * pv;
    };
    
    let macaulayDuration = if (presentValue > 0.0) {
      weightedTime / presentValue / Float.fromInt(couponFrequency)
    } else { maturityYears };
    
    let modifiedDuration = macaulayDuration / (1.0 + periodRate);
    let dollarDuration = modifiedDuration * presentValue * BPS;
    
    let convexity = if (presentValue > 0.0) {
      weightedTimeSq / (presentValue * Float.pow(1.0 + periodRate, 2.0)) / 
      Float.pow(Float.fromInt(couponFrequency), 2.0)
    } else { 0.0 };
    
    {
      macaulayDuration = macaulayDuration;
      modifiedDuration = modifiedDuration;
      effectiveDuration = modifiedDuration;
      dollarDuration = dollarDuration;
      convexity = convexity;
      keyRateDurations = [modifiedDuration];  // Simplified
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // LIQUIDITY LADDER
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type LiquidityBucket = {
    horizon : Text;              // "Immediate", "1 Day", "1 Week", "1 Month", "3 Months", "1 Year"
    horizonDays : Float;
    availableLiquidity : Float;  // Cash available in this bucket
    expectedInflows : Float;     // Expected cash inflows
    expectedOutflows : Float;    // Expected cash outflows
    netPosition : Float;         // Net liquidity position
    cumulativeNet : Float;       // Cumulative net from start
    bufferRequired : Float;      // Minimum buffer required
    shortfall : Float;           // Shortfall if negative
  };
  
  public type LiquidityLadder = {
    buckets : [LiquidityBucket];
    totalLiquidity : Float;
    liquidityCoverageRatio : Float;  // LCR
    netStableFundingRatio : Float;   // NSFR
    survivalHorizon : Float;         // Days of stress survival
    liquidityBuffer : Float;         // Excess liquidity
    stressBufferRequired : Float;    // Buffer for stress scenario
  };
  
  /// Build liquidity ladder from treasury assets
  public func buildLiquidityLadder(
    assets : [TreasuryAsset],
    expectedOutflows : [{ horizon : Float; amount : Float }],
    stressMultiplier : Float  // Multiply outflows for stress
  ) : LiquidityLadder {
    // Define buckets
    let horizons : [(Text, Float)] = [
      ("Immediate", 0.0),
      ("1 Day", 1.0),
      ("1 Week", 7.0),
      ("1 Month", 30.0),
      ("3 Months", 90.0),
      ("6 Months", 180.0),
      ("1 Year", 365.0)
    ];
    
    // Calculate available liquidity in each bucket
    let buckets = Buffer.Buffer<LiquidityBucket>(horizons.size());
    var cumulativeNet : Float = 0.0;
    
    for ((name, days) in horizons.vals()) {
      // Available liquidity (assets that mature by this horizon)
      var available : Float = 0.0;
      for (asset in assets.vals()) {
        let effectiveDays = asset.lockupPeriod + asset.duration * (1.0 - asset.liquidityScore);
        if (effectiveDays <= days) {
          available := available + asset.currentValue;
        }
      };
      
      // Expected inflows (yield accrual, etc.)
      var inflows : Float = 0.0;
      for (asset in assets.vals()) {
        let dailyYield = asset.currentValue * asset.apy / DAYS_PER_YEAR;
        inflows := inflows + dailyYield * days;
      };
      
      // Expected outflows
      var outflows : Float = 0.0;
      for (outflow in expectedOutflows.vals()) {
        if (outflow.horizon <= days) {
          outflows := outflows + outflow.amount;
        }
      };
      
      let netPosition = available + inflows - outflows;
      cumulativeNet := cumulativeNet + netPosition;
      
      // Buffer required (higher for shorter horizons)
      let bufferRequired = outflows * (if (days < 7.0) { 0.3 } else if (days < 30.0) { 0.2 } else { 0.1 });
      
      let shortfall = if (cumulativeNet < bufferRequired) {
        bufferRequired - cumulativeNet
      } else { 0.0 };
      
      buckets.add({
        horizon = name;
        horizonDays = days;
        availableLiquidity = available;
        expectedInflows = inflows;
        expectedOutflows = outflows;
        netPosition = netPosition;
        cumulativeNet = cumulativeNet;
        bufferRequired = bufferRequired;
        shortfall = shortfall;
      });
    };
    
    let bucketArray = Buffer.toArray(buckets);
    
    // Calculate overall metrics
    var totalLiquidity : Float = 0.0;
    for (asset in assets.vals()) {
      totalLiquidity := totalLiquidity + asset.currentValue;
    };
    
    // LCR = High Quality Liquid Assets / 30-day Net Outflows
    let hqla = bucketArray[0].availableLiquidity + bucketArray[1].availableLiquidity;
    let thirtyDayOutflows = if (bucketArray.size() > 3) { bucketArray[3].expectedOutflows } else { 1.0 };
    let lcr = hqla / (thirtyDayOutflows + 0.001);
    
    // Survival horizon (how many days until shortfall)
    var survivalHorizon : Float = 365.0;
    for (bucket in bucketArray.vals()) {
      if (bucket.shortfall > 0.0 and bucket.horizonDays < survivalHorizon) {
        survivalHorizon := bucket.horizonDays;
      }
    };
    
    {
      buckets = bucketArray;
      totalLiquidity = totalLiquidity;
      liquidityCoverageRatio = lcr;
      netStableFundingRatio = 1.0;  // Simplified
      survivalHorizon = survivalHorizon;
      liquidityBuffer = totalLiquidity - bucketArray[bucketArray.size() - 1].expectedOutflows;
      stressBufferRequired = thirtyDayOutflows * stressMultiplier * 0.3;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // YIELD OPTIMIZATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type YieldOpportunity = {
    protocol : Text;
    asset : Text;
    strategyType : TreasuryAssetType;
    apy : Float;
    tvl : Float;                 // Total value locked
    riskScore : Float;           // 0-1
    liquidityScore : Float;      // 0-1
    smartContractRisk : Float;   // 0-1
    impermanentLossRisk : Float; // 0-1 (for LP)
    minDeposit : Float;
    maxDeposit : Float;
    lockupDays : Float;
    sharpeRatio : Float;         // Risk-adjusted return
    recommendedAllocation : Float;
  };
  
  public type YieldStrategy = {
    opportunities : [YieldOpportunity];
    totalAllocated : Float;
    weightedApy : Float;
    weightedRisk : Float;
    diversificationScore : Float;
    expectedAnnualYield : Float;
    riskAdjustedReturn : Float;
  };
  
  /// Optimize yield allocation across opportunities
  public func optimizeYieldAllocation(
    availableCapital : Float,
    opportunities : [YieldOpportunity],
    riskBudget : Float,         // Max acceptable risk (0-1)
    minLiquidity : Float,       // Min liquidity requirement
    maxSingleAllocation : Float  // Max % in single opportunity
  ) : YieldStrategy {
    // Filter by risk and liquidity constraints
    let eligible = Array.filter<YieldOpportunity>(opportunities, func(o : YieldOpportunity) : Bool {
      o.riskScore <= riskBudget and o.liquidityScore >= minLiquidity
    });
    
    if (eligible.size() == 0) {
      return {
        opportunities = [];
        totalAllocated = 0.0;
        weightedApy = 0.0;
        weightedRisk = 0.0;
        diversificationScore = 0.0;
        expectedAnnualYield = 0.0;
        riskAdjustedReturn = 0.0;
      }
    };
    
    // Rank by Sharpe ratio
    let sorted = Array.sort<YieldOpportunity>(eligible, func(a : YieldOpportunity, b : YieldOpportunity) : {#less; #equal; #greater} {
      if (a.sharpeRatio > b.sharpeRatio) { #less }
      else if (a.sharpeRatio < b.sharpeRatio) { #greater }
      else { #equal }
    });
    
    // Allocate capital
    let allocatedOpps = Buffer.Buffer<YieldOpportunity>(sorted.size());
    var remainingCapital = availableCapital;
    var totalAllocated : Float = 0.0;
    
    for (opp in sorted.vals()) {
      if (remainingCapital <= 0.0) { break () };
      
      let maxAllocation = Float.min(
        Float.min(remainingCapital, opp.maxDeposit),
        availableCapital * maxSingleAllocation
      );
      
      let allocation = Float.max(opp.minDeposit, maxAllocation);
      
      if (allocation >= opp.minDeposit) {
        let allocatedOpp = {
          protocol = opp.protocol;
          asset = opp.asset;
          strategyType = opp.strategyType;
          apy = opp.apy;
          tvl = opp.tvl;
          riskScore = opp.riskScore;
          liquidityScore = opp.liquidityScore;
          smartContractRisk = opp.smartContractRisk;
          impermanentLossRisk = opp.impermanentLossRisk;
          minDeposit = opp.minDeposit;
          maxDeposit = opp.maxDeposit;
          lockupDays = opp.lockupDays;
          sharpeRatio = opp.sharpeRatio;
          recommendedAllocation = allocation;
        };
        
        allocatedOpps.add(allocatedOpp);
        remainingCapital := remainingCapital - allocation;
        totalAllocated := totalAllocated + allocation;
      }
    };
    
    let allocated = Buffer.toArray(allocatedOpps);
    
    // Calculate metrics
    var weightedApy : Float = 0.0;
    var weightedRisk : Float = 0.0;
    
    for (opp in allocated.vals()) {
      let weight = opp.recommendedAllocation / (totalAllocated + 0.001);
      weightedApy := weightedApy + opp.apy * weight;
      weightedRisk := weightedRisk + opp.riskScore * weight;
    };
    
    let expectedYield = totalAllocated * weightedApy;
    let diversification = Float.fromInt(allocated.size()) / Float.fromInt(Nat.max(1, opportunities.size()));
    let riskAdjusted = if (weightedRisk > 0.0) { weightedApy / weightedRisk } else { weightedApy };
    
    {
      opportunities = allocated;
      totalAllocated = totalAllocated;
      weightedApy = weightedApy;
      weightedRisk = weightedRisk;
      diversificationScore = diversification;
      expectedAnnualYield = expectedYield;
      riskAdjustedReturn = riskAdjusted;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // CAPITAL ALLOCATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type CapitalBucket = {
    name : Text;
    purpose : Text;
    targetAllocation : Float;    // Target % of total capital
    currentAllocation : Float;   // Current % allocated
    absoluteAmount : Float;      // Dollar amount
    minAllocation : Float;       // Minimum required
    maxAllocation : Float;       // Maximum allowed
    priority : Nat;              // 1 = highest priority
    returnTarget : Float;        // Expected return
    riskLimit : Float;           // Max risk for this bucket
  };
  
  public type CapitalAllocationPlan = {
    buckets : [CapitalBucket];
    totalCapital : Float;
    unallocated : Float;
    overallReturnTarget : Float;
    overallRiskBudget : Float;
    rebalanceRequired : Bool;
    rebalanceActions : [{ from : Text; to : Text; amount : Float }];
  };
  
  /// Define optimal capital allocation buckets
  public func getOptimalAllocationBuckets(totalCapital : Float) : [CapitalBucket] {
    [
      {
        name = "Operating Cash";
        purpose = "Day-to-day operations, immediate liquidity";
        targetAllocation = 0.15;
        currentAllocation = 0.0;
        absoluteAmount = totalCapital * 0.15;
        minAllocation = 0.10;
        maxAllocation = 0.25;
        priority = 1;
        returnTarget = 0.02;  // 2% (money market rates)
        riskLimit = 0.01;
      },
      {
        name = "Reserve Fund";
        purpose = "Emergency reserve, 6 months runway";
        targetAllocation = 0.20;
        currentAllocation = 0.0;
        absoluteAmount = totalCapital * 0.20;
        minAllocation = 0.15;
        maxAllocation = 0.30;
        priority = 2;
        returnTarget = 0.04;
        riskLimit = 0.05;
      },
      {
        name = "Short-Term Yield";
        purpose = "< 30 day yield farming";
        targetAllocation = 0.25;
        currentAllocation = 0.0;
        absoluteAmount = totalCapital * 0.25;
        minAllocation = 0.15;
        maxAllocation = 0.35;
        priority = 3;
        returnTarget = 0.08;
        riskLimit = 0.15;
      },
      {
        name = "Medium-Term Yield";
        purpose = "30-90 day strategies";
        targetAllocation = 0.20;
        currentAllocation = 0.0;
        absoluteAmount = totalCapital * 0.20;
        minAllocation = 0.10;
        maxAllocation = 0.30;
        priority = 4;
        returnTarget = 0.12;
        riskLimit = 0.25;
      },
      {
        name = "Strategic Growth";
        purpose = "Long-term growth investments";
        targetAllocation = 0.15;
        currentAllocation = 0.0;
        absoluteAmount = totalCapital * 0.15;
        minAllocation = 0.05;
        maxAllocation = 0.25;
        priority = 5;
        returnTarget = 0.20;
        riskLimit = 0.40;
      },
      {
        name = "Risk Buffer";
        purpose = "Buffer for unexpected risks";
        targetAllocation = 0.05;
        currentAllocation = 0.0;
        absoluteAmount = totalCapital * 0.05;
        minAllocation = 0.03;
        maxAllocation = 0.10;
        priority = 1;
        returnTarget = 0.02;
        riskLimit = 0.02;
      },
    ]
  };
  
  /// Calculate rebalancing actions
  public func calculateRebalanceActions(
    current : [CapitalBucket],
    target : [CapitalBucket]
  ) : [{ from : Text; to : Text; amount : Float }] {
    let actions = Buffer.Buffer<{ from : Text; to : Text; amount : Float }>(10);
    
    // Find over-allocated buckets
    let overAllocated = Buffer.Buffer<{ name : Text; excess : Float }>(5);
    let underAllocated = Buffer.Buffer<{ name : Text; deficit : Float; priority : Nat }>(5);
    
    for (i in Iter.range(0, Nat.min(current.size(), target.size()) - 1)) {
      let c = current[i];
      let t = target[i];
      let diff = c.currentAllocation - t.targetAllocation;
      
      if (diff > 0.01) {  // Over-allocated by > 1%
        overAllocated.add({ name = c.name; excess = diff * c.absoluteAmount / c.currentAllocation });
      } else if (diff < -0.01) {  // Under-allocated by > 1%
        underAllocated.add({ name = c.name; deficit = -diff * t.absoluteAmount / t.targetAllocation; priority = c.priority });
      }
    };
    
    // Match over to under by priority
    let underArr = Array.sort<{ name : Text; deficit : Float; priority : Nat }>(
      Buffer.toArray(underAllocated),
      func(a : { name : Text; deficit : Float; priority : Nat }, b : { name : Text; deficit : Float; priority : Nat }) : {#less; #equal; #greater} {
        if (a.priority < b.priority) { #less }
        else if (a.priority > b.priority) { #greater }
        else { #equal }
      }
    );
    
    for (over in overAllocated.vals()) {
      var remaining = over.excess;
      for (under in underArr.vals()) {
        if (remaining > 0.0 and under.deficit > 0.0) {
          let transferAmount = Float.min(remaining, under.deficit);
          actions.add({
            from = over.name;
            to = under.name;
            amount = transferAmount;
          });
          remaining := remaining - transferAmount;
        }
      }
    };
    
    Buffer.toArray(actions)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // TREASURY METRICS AND HEALTH
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type TreasuryHealth = {
    totalAssets : Float;
    totalLiabilities : Float;
    netWorth : Float;
    liquidityRatio : Float;           // Liquid assets / total assets
    currentRatio : Float;             // Current assets / current liabilities
    quickRatio : Float;               // (Current assets - inventory) / current liabilities
    runwayDays : Float;               // Days until capital exhaustion
    burnRate : Float;                 // Daily cash burn
    yieldOnAssets : Float;            // Average yield
    riskAdjustedYield : Float;        // Yield / risk
    concentrationRisk : Float;        // Herfindahl index
    protocolDiversification : Float;  // Number of protocols
    healthScore : Float;              // 0-100
    alerts : [Text];
  };
  
  /// Calculate treasury health metrics
  public func calculateTreasuryHealth(
    assets : [TreasuryAsset],
    dailyExpenses : Float,
    liabilities : Float
  ) : TreasuryHealth {
    // Total assets
    var totalAssets : Float = 0.0;
    var liquidAssets : Float = 0.0;
    var weightedYield : Float = 0.0;
    var weightedRisk : Float = 0.0;
    var protocolCount : Nat = 0;
    var sumSqConcentration : Float = 0.0;
    
    let protocols = Buffer.Buffer<Text>(10);
    
    for (asset in assets.vals()) {
      totalAssets := totalAssets + asset.currentValue;
      
      if (asset.liquidityScore > 0.7) {
        liquidAssets := liquidAssets + asset.currentValue;
      };
      
      weightedYield := weightedYield + asset.apy * asset.currentValue;
      weightedRisk := weightedRisk + asset.riskScore * asset.currentValue;
      
      // Track protocols
      var found = false;
      for (p in protocols.vals()) {
        if (Text.equal(p, asset.protocol)) { found := true };
      };
      if (not found) {
        protocols.add(asset.protocol);
        protocolCount := protocolCount + 1;
      };
    };
    
    // Concentration (Herfindahl)
    for (asset in assets.vals()) {
      let share = asset.currentValue / (totalAssets + 0.001);
      sumSqConcentration := sumSqConcentration + share * share;
    };
    
    let avgYield = weightedYield / (totalAssets + 0.001);
    let avgRisk = weightedRisk / (totalAssets + 0.001);
    let riskAdjustedYield = if (avgRisk > 0.0) { avgYield / avgRisk } else { avgYield };
    
    let netWorth = totalAssets - liabilities;
    let liquidityRatio = liquidAssets / (totalAssets + 0.001);
    let currentRatio = totalAssets / (liabilities + 0.001);
    let runwayDays = if (dailyExpenses > 0.0) { liquidAssets / dailyExpenses } else { 999.0 };
    
    // Health score
    let liquidityScore = Float.min(25.0, liquidityRatio * 25.0);
    let runwayScore = Float.min(25.0, Float.min(runwayDays, 180.0) / 180.0 * 25.0);
    let yieldScore = Float.min(25.0, avgYield * 100.0);
    let diversificationScore = Float.min(25.0, (1.0 - sumSqConcentration) * 25.0);
    let healthScore = liquidityScore + runwayScore + yieldScore + diversificationScore;
    
    // Generate alerts
    let alerts = Buffer.Buffer<Text>(5);
    if (runwayDays < 30.0) { alerts.add("CRITICAL: Runway below 30 days") };
    if (liquidityRatio < 0.2) { alerts.add("WARNING: Liquidity ratio below 20%") };
    if (sumSqConcentration > 0.5) { alerts.add("WARNING: High concentration risk") };
    if (protocolCount < 3) { alerts.add("WARNING: Low protocol diversification") };
    if (avgRisk > 0.3) { alerts.add("WARNING: High average portfolio risk") };
    
    {
      totalAssets = totalAssets;
      totalLiabilities = liabilities;
      netWorth = netWorth;
      liquidityRatio = liquidityRatio;
      currentRatio = currentRatio;
      quickRatio = liquidityRatio * currentRatio;
      runwayDays = runwayDays;
      burnRate = dailyExpenses;
      yieldOnAssets = avgYield;
      riskAdjustedYield = riskAdjustedYield;
      concentrationRisk = sumSqConcentration;
      protocolDiversification = Float.fromInt(protocolCount);
      healthScore = healthScore;
      alerts = Buffer.toArray(alerts);
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // COMPLETE TREASURY ASSESSMENT
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type CompleteTreasuryAssessment = {
    timestamp : Nat64;
    health : TreasuryHealth;
    liquidityLadder : LiquidityLadder;
    yieldStrategy : YieldStrategy;
    allocationPlan : CapitalAllocationPlan;
    durationMetrics : DurationMetrics;
    yieldCurve : YieldCurve;
    recommendations : [Text];
  };
  
  /// Generate complete treasury assessment
  public func generateTreasuryAssessment(
    assets : [TreasuryAsset],
    dailyExpenses : Float,
    liabilities : Float,
    yieldOpportunities : [YieldOpportunity],
    riskBudget : Float
  ) : CompleteTreasuryAssessment {
    // Health metrics
    let health = calculateTreasuryHealth(assets, dailyExpenses, liabilities);
    
    // Liquidity ladder
    let expectedOutflows = [
      { horizon = 1.0; amount = dailyExpenses },
      { horizon = 7.0; amount = dailyExpenses * 7.0 },
      { horizon = 30.0; amount = dailyExpenses * 30.0 },
      { horizon = 90.0; amount = dailyExpenses * 90.0 },
    ];
    let liquidityLadder = buildLiquidityLadder(assets, expectedOutflows, 1.5);
    
    // Yield optimization
    let availableForYield = health.totalAssets * 0.6;  // 60% for yield
    let yieldStrategy = optimizeYieldAllocation(
      availableForYield,
      yieldOpportunities,
      riskBudget,
      0.3,  // Min 30% liquidity
      0.25  // Max 25% in single opportunity
    );
    
    // Capital allocation
    let targetBuckets = getOptimalAllocationBuckets(health.totalAssets);
    let currentBuckets = targetBuckets;  // Simplified - would need current state
    let rebalanceActions = calculateRebalanceActions(currentBuckets, targetBuckets);
    let allocationPlan = {
      buckets = targetBuckets;
      totalCapital = health.totalAssets;
      unallocated = 0.0;
      overallReturnTarget = 0.08;
      overallRiskBudget = riskBudget;
      rebalanceRequired = rebalanceActions.size() > 0;
      rebalanceActions = rebalanceActions;
    };
    
    // Duration (simplified)
    let durationMetrics = calculateDuration(health.totalAssets, 0.05, 0.06, 365.0, 2);
    
    // Yield curve (placeholder)
    let yieldCurve = {
      points = [
        { maturity = 1.0; rate = 0.03 },
        { maturity = 30.0; rate = 0.04 },
        { maturity = 90.0; rate = 0.05 },
        { maturity = 365.0; rate = 0.06 },
      ];
      shape = #Normal;
      slope = 0.03;
      curvature = 0.0;
      lastUpdate = Nat64.fromNat(Int.abs(Time.now()));
    };
    
    // Generate recommendations
    let recommendations = generateTreasuryRecommendations(health, liquidityLadder, yieldStrategy);
    
    {
      timestamp = Nat64.fromNat(Int.abs(Time.now()));
      health = health;
      liquidityLadder = liquidityLadder;
      yieldStrategy = yieldStrategy;
      allocationPlan = allocationPlan;
      durationMetrics = durationMetrics;
      yieldCurve = yieldCurve;
      recommendations = recommendations;
    }
  };
  
  // Helper: Generate recommendations
  func generateTreasuryRecommendations(
    health : TreasuryHealth,
    ladder : LiquidityLadder,
    yield : YieldStrategy
  ) : [Text] {
    let recs = Buffer.Buffer<Text>(10);
    
    // Liquidity recommendations
    if (health.runwayDays < 90.0) {
      recs.add("PRIORITY: Extend runway to at least 90 days by increasing liquid reserves.");
    };
    
    if (ladder.liquidityCoverageRatio < 1.0) {
      recs.add("CRITICAL: LCR below 100%. Increase high-quality liquid assets.");
    };
    
    // Yield recommendations
    if (health.yieldOnAssets < 0.05) {
      recs.add("OPPORTUNITY: Portfolio yield below 5%. Consider reallocating to higher-yield strategies.");
    };
    
    if (yield.diversificationScore < 0.3) {
      recs.add("RISK: Low yield diversification. Spread allocation across more protocols.");
    };
    
    // Concentration recommendations
    if (health.concentrationRisk > 0.4) {
      recs.add("RISK: High concentration in single assets. Rebalance to reduce HHI index.");
    };
    
    // General health
    if (health.healthScore < 60.0) {
      recs.add("WARNING: Treasury health score below 60. Review allocation strategy.");
    };
    
    if (recs.size() == 0) {
      recs.add("Treasury health within optimal parameters. Continue monitoring.");
    };
    
    Buffer.toArray(recs)
  };

}
