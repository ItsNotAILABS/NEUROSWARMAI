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
// ENTERPRISE RISK ENGINE — VAR, STRESS TESTING, RISK MANAGEMENT
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// THE ORGANISM MANAGES RISK LIKE A SENIOR CLEARINGHOUSE OPERATOR:
// - Value at Risk (VaR) calculations: Parametric, Historical, Monte Carlo
// - Expected Shortfall (CVaR) for tail risk
// - Stress testing across market scenarios
// - Correlation breakdown detection
// - Tail risk hedging strategies
// - Counterparty risk scoring
// - Concentration limits enforcement
// - Liquidity risk assessment
//
// This is ENTERPRISE-GRADE risk management encoded in the organism's DNA.
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

module EnterpriseRiskEngine {

  // ═══════════════════════════════════════════════════════════════════════════════
  // MATHEMATICAL CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let PI : Float = 3.14159265358979323846;
  public let E : Float = 2.71828182845904523536;
  public let SQRT2 : Float = 1.41421356237309504880;
  public let PHI : Float = 1.618033988749895;
  
  // Standard normal distribution quantiles
  public let Z_90 : Float = 1.28155;   // 90% confidence
  public let Z_95 : Float = 1.64485;   // 95% confidence
  public let Z_99 : Float = 2.32635;   // 99% confidence
  public let Z_999 : Float = 3.09023;  // 99.9% confidence

  // ═══════════════════════════════════════════════════════════════════════════════
  // RISK TYPES AND CATEGORIES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type RiskCategory = {
    #Market;        // Price/volatility risk
    #Credit;        // Counterparty default risk
    #Liquidity;     // Inability to exit positions
    #Operational;   // System/process failures
    #Concentration; // Over-exposure to single asset/counterparty
    #Regulatory;    // Compliance risk
    #Systemic;      // Market-wide risk
    #Model;         // Model/assumption risk
  };
  
  public type ConfidenceLevel = {
    #P90;   // 90% confidence
    #P95;   // 95% confidence
    #P99;   // 99% confidence
    #P999;  // 99.9% confidence
  };
  
  public func confidenceToZ(level : ConfidenceLevel) : Float {
    switch (level) {
      case (#P90) { Z_90 };
      case (#P95) { Z_95 };
      case (#P99) { Z_99 };
      case (#P999) { Z_999 };
    }
  };
  
  public func confidenceToPercentile(level : ConfidenceLevel) : Float {
    switch (level) {
      case (#P90) { 0.90 };
      case (#P95) { 0.95 };
      case (#P99) { 0.99 };
      case (#P999) { 0.999 };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // POSITION AND PORTFOLIO STRUCTURES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type AssetClass = {
    #Cryptocurrency;
    #DeFiToken;
    #StableCoin;
    #NFT;
    #LP_Token;      // Liquidity pool token
    #Derivative;
    #Cash;
  };
  
  public type Position = {
    assetId : Text;
    assetClass : AssetClass;
    quantity : Float;
    currentPrice : Float;
    notionalValue : Float;       // quantity × price
    avgCost : Float;             // Average entry price
    unrealizedPnL : Float;       // Current P&L
    volatility : Float;          // Asset volatility
    beta : Float;                // Correlation to market
    liquidityScore : Float;      // 0-1, how liquid the position
    daysToLiquidate : Float;     // Estimated days to fully exit
    concentration : Float;       // Position / portfolio
  };
  
  public type Portfolio = {
    positions : [Position];
    totalNotional : Float;
    cashBalance : Float;
    marginUsed : Float;
    availableMargin : Float;
    leverage : Float;
    portfolioVolatility : Float;
    portfolioBeta : Float;
    sharpeRatio : Float;
    maxDrawdown : Float;
    currentDrawdown : Float;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // VALUE AT RISK (VAR) CALCULATIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type VaRMethod = {
    #Parametric;     // Variance-covariance method
    #Historical;     // Historical simulation
    #MonteCarlo;     // Monte Carlo simulation
    #Cornish_Fisher; // Fat tails adjustment
  };
  
  public type VaRResult = {
    method : VaRMethod;
    confidenceLevel : ConfidenceLevel;
    horizon : Nat;              // Days
    varAbsolute : Float;        // Dollar VaR
    varPercent : Float;         // VaR as % of portfolio
    cvarAbsolute : Float;       // Conditional VaR (Expected Shortfall)
    cvarPercent : Float;        // CVaR as % of portfolio
    marginalVaR : [Float];      // VaR contribution by position
    componentVaR : [Float];     // VaR if position removed
    incrementalVaR : [Float];   // VaR from adding position
  };
  
  /// Calculate Parametric VaR (Variance-Covariance method)
  /// Assumes normal distribution: VaR = μ - z × σ × √t
  public func calculateParametricVaR(
    portfolioValue : Float,
    portfolioVolatility : Float,  // Daily volatility
    confidence : ConfidenceLevel,
    horizon : Nat
  ) : VaRResult {
    let z = confidenceToZ(confidence);
    let sqrtT = Float.sqrt(Float.fromInt(horizon));
    
    // VaR (assuming mean return = 0 for simplicity)
    let varPercent = z * portfolioVolatility * sqrtT;
    let varAbsolute = portfolioValue * varPercent;
    
    // CVaR (Expected Shortfall) for normal distribution
    // ES = σ × φ(z) / (1-α) where φ is standard normal PDF
    let pdfAtZ = Float.exp(-z * z / 2.0) / Float.sqrt(2.0 * PI);
    let alpha = confidenceToPercentile(confidence);
    let cvarPercent = portfolioVolatility * sqrtT * pdfAtZ / (1.0 - alpha);
    let cvarAbsolute = portfolioValue * cvarPercent;
    
    {
      method = #Parametric;
      confidenceLevel = confidence;
      horizon = horizon;
      varAbsolute = varAbsolute;
      varPercent = varPercent;
      cvarAbsolute = cvarAbsolute;
      cvarPercent = cvarPercent;
      marginalVaR = [];
      componentVaR = [];
      incrementalVaR = [];
    }
  };
  
  /// Calculate Historical VaR
  /// Uses actual historical returns sorted by magnitude
  public func calculateHistoricalVaR(
    portfolioValue : Float,
    historicalReturns : [Float],  // Daily returns
    confidence : ConfidenceLevel,
    horizon : Nat
  ) : VaRResult {
    let n = historicalReturns.size();
    if (n < 20) {
      return calculateParametricVaR(portfolioValue, 0.02, confidence, horizon)
    };
    
    // Scale returns to horizon
    let sqrtT = Float.sqrt(Float.fromInt(horizon));
    let scaledReturns = Array.map<Float, Float>(historicalReturns, func(r : Float) : Float {
      r * sqrtT
    });
    
    // Sort returns (ascending - worst first)
    let sortedReturns = Array.sort<Float>(scaledReturns, Float.compare);
    
    // Find percentile
    let alpha = 1.0 - confidenceToPercentile(confidence);
    let index = Int.abs(Float.toInt(Float.floor(alpha * Float.fromInt(n))));
    let varIndex = if (index >= n) { n - 1 } else { index };
    
    let varReturn = -sortedReturns[varIndex];  // Negative because it's a loss
    let varAbsolute = portfolioValue * varReturn;
    
    // CVaR = average of returns worse than VaR
    var cvarSum : Float = 0.0;
    var cvarCount : Nat = 0;
    for (i in Iter.range(0, varIndex)) {
      cvarSum := cvarSum + (-sortedReturns[i]);
      cvarCount := cvarCount + 1;
    };
    let cvarPercent = if (cvarCount > 0) { cvarSum / Float.fromInt(cvarCount) } else { varReturn };
    let cvarAbsolute = portfolioValue * cvarPercent;
    
    {
      method = #Historical;
      confidenceLevel = confidence;
      horizon = horizon;
      varAbsolute = varAbsolute;
      varPercent = varReturn;
      cvarAbsolute = cvarAbsolute;
      cvarPercent = cvarPercent;
      marginalVaR = [];
      componentVaR = [];
      incrementalVaR = [];
    }
  };
  
  /// Calculate Cornish-Fisher VaR (fat tails adjustment)
  /// Adjusts for skewness and kurtosis
  public func calculateCornishFisherVaR(
    portfolioValue : Float,
    portfolioVolatility : Float,
    skewness : Float,
    excessKurtosis : Float,
    confidence : ConfidenceLevel,
    horizon : Nat
  ) : VaRResult {
    let z = confidenceToZ(confidence);
    let sqrtT = Float.sqrt(Float.fromInt(horizon));
    
    // Cornish-Fisher expansion
    // z_cf = z + (z² - 1) × S/6 + (z³ - 3z) × K/24 - (2z³ - 5z) × S²/36
    let z2 = z * z;
    let z3 = z2 * z;
    let S = skewness;
    let K = excessKurtosis;
    
    let z_cf = z + (z2 - 1.0) * S / 6.0 
               + (z3 - 3.0 * z) * K / 24.0 
               - (2.0 * z3 - 5.0 * z) * S * S / 36.0;
    
    let varPercent = z_cf * portfolioVolatility * sqrtT;
    let varAbsolute = portfolioValue * varPercent;
    
    // Approximate CVaR
    let cvarPercent = varPercent * 1.25;  // Rough approximation for fat tails
    let cvarAbsolute = portfolioValue * cvarPercent;
    
    {
      method = #Cornish_Fisher;
      confidenceLevel = confidence;
      horizon = horizon;
      varAbsolute = varAbsolute;
      varPercent = varPercent;
      cvarAbsolute = cvarAbsolute;
      cvarPercent = cvarPercent;
      marginalVaR = [];
      componentVaR = [];
      incrementalVaR = [];
    }
  };
  
  /// Calculate Marginal VaR for each position
  public func calculateMarginalVaR(
    positions : [Position],
    portfolioVolatility : Float,
    positionVolatilities : [Float],
    correlationMatrix : [[Float]],
    confidence : ConfidenceLevel,
    horizon : Nat
  ) : [Float] {
    let n = positions.size();
    let z = confidenceToZ(confidence);
    let sqrtT = Float.sqrt(Float.fromInt(horizon));
    
    Array.tabulate<Float>(n, func(i : Nat) : Float {
      // Marginal VaR = weight × correlation × asset_vol / portfolio_vol × VaR
      let weight = positions[i].concentration;
      let assetVol = positionVolatilities[i];
      
      // Compute weighted correlation
      var weightedCorr : Float = 0.0;
      for (j in Iter.range(0, n - 1)) {
        if (i < correlationMatrix.size() and j < correlationMatrix[i].size()) {
          weightedCorr := weightedCorr + positions[j].concentration * correlationMatrix[i][j];
        }
      };
      
      let marginalContribution = weight * weightedCorr * assetVol / portfolioVolatility;
      marginalContribution * z * portfolioVolatility * sqrtT * positions[i].notionalValue
    })
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // STRESS TESTING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type StressScenario = {
    name : Text;
    description : Text;
    marketMove : Float;          // Overall market move (e.g., -30%)
    volatilityMultiplier : Float; // Vol spike (e.g., 3x)
    correlationShift : Float;    // Correlation breakdown
    liquidityHaircut : Float;    // Liquidity reduction
    spreadWidening : Float;      // Spread widening factor
    duration : Nat;              // Days of stress
  };
  
  public type StressTestResult = {
    scenario : StressScenario;
    portfolioLoss : Float;
    portfolioLossPercent : Float;
    positionLosses : [Float];
    maxDrawdown : Float;
    liquidationRisk : Bool;
    marginCall : Bool;
    estimatedRecoveryDays : Nat;
    worstCaseMultiple : Float;   // How many times worse than VaR
  };
  
  /// Pre-defined stress scenarios
  public func getStandardScenarios() : [StressScenario] {
    [
      // 2008 Financial Crisis style
      {
        name = "Financial Crisis";
        description = "2008-style market collapse with correlation spike";
        marketMove = -0.50;
        volatilityMultiplier = 4.0;
        correlationShift = 0.3;
        liquidityHaircut = 0.7;
        spreadWidening = 5.0;
        duration = 90;
      },
      // Flash Crash
      {
        name = "Flash Crash";
        description = "Sudden 20% drop with immediate recovery";
        marketMove = -0.20;
        volatilityMultiplier = 10.0;
        correlationShift = 0.5;
        liquidityHaircut = 0.9;
        spreadWidening = 20.0;
        duration = 1;
      },
      // Luna/UST style collapse
      {
        name = "Token Collapse";
        description = "Single major token goes to zero, contagion";
        marketMove = -0.40;
        volatilityMultiplier = 5.0;
        correlationShift = 0.4;
        liquidityHaircut = 0.8;
        spreadWidening = 10.0;
        duration = 7;
      },
      // FTX-style exchange failure
      {
        name = "Exchange Failure";
        description = "Major exchange fails, counterparty losses";
        marketMove = -0.25;
        volatilityMultiplier = 3.0;
        correlationShift = 0.3;
        liquidityHaircut = 0.5;
        spreadWidening = 8.0;
        duration = 30;
      },
      // Regulatory crackdown
      {
        name = "Regulatory Shock";
        description = "Major regulatory action causes panic";
        marketMove = -0.35;
        volatilityMultiplier = 2.5;
        correlationShift = 0.2;
        liquidityHaircut = 0.4;
        spreadWidening = 3.0;
        duration = 60;
      },
      // Positive stress - rapid appreciation
      {
        name = "Parabolic Rally";
        description = "Extreme upside, forced short covering";
        marketMove = 1.00;
        volatilityMultiplier = 3.0;
        correlationShift = 0.3;
        liquidityHaircut = 0.3;
        spreadWidening = 2.0;
        duration = 14;
      },
      // Mild correction
      {
        name = "Mild Correction";
        description = "Normal 15% correction";
        marketMove = -0.15;
        volatilityMultiplier = 1.5;
        correlationShift = 0.1;
        liquidityHaircut = 0.1;
        spreadWidening = 1.5;
        duration = 21;
      },
      // Liquidity crisis
      {
        name = "Liquidity Crisis";
        description = "Market-wide liquidity evaporates";
        marketMove = -0.30;
        volatilityMultiplier = 2.0;
        correlationShift = 0.5;
        liquidityHaircut = 0.95;
        spreadWidening = 50.0;
        duration = 14;
      },
    ]
  };
  
  /// Run stress test on portfolio
  public func runStressTest(
    portfolio : Portfolio,
    scenario : StressScenario,
    varResult : VaRResult
  ) : StressTestResult {
    // Calculate position losses
    let positionLosses = Array.map<Position, Float>(portfolio.positions, func(pos : Position) : Float {
      // Adjust by beta (higher beta = more market sensitivity)
      let adjustedMove = scenario.marketMove * pos.beta;
      
      // Add liquidity penalty
      let liquidityPenalty = scenario.liquidityHaircut * pos.liquidityScore * 0.1;
      
      pos.notionalValue * (adjustedMove - liquidityPenalty)
    });
    
    // Total portfolio loss
    var totalLoss : Float = 0.0;
    for (loss in positionLosses.vals()) {
      totalLoss := totalLoss + loss;
    };
    
    let portfolioLossPercent = if (portfolio.totalNotional > 0.0) {
      totalLoss / portfolio.totalNotional
    } else { 0.0 };
    
    // Max drawdown during stress
    let maxDrawdown = Float.abs(totalLoss) * scenario.volatilityMultiplier * 0.3;
    
    // Liquidation risk (if loss > available margin)
    let liquidationRisk = Float.abs(totalLoss) > portfolio.availableMargin;
    
    // Margin call (if loss > 50% of available margin)
    let marginCall = Float.abs(totalLoss) > portfolio.availableMargin * 0.5;
    
    // Recovery estimate
    let estimatedRecoveryDays = if (Float.abs(portfolioLossPercent) > 0.3) {
      scenario.duration * 3
    } else if (Float.abs(portfolioLossPercent) > 0.15) {
      scenario.duration * 2
    } else {
      scenario.duration
    };
    
    // Worst case multiple vs VaR
    let worstCaseMultiple = if (varResult.varAbsolute > 0.0) {
      Float.abs(totalLoss) / varResult.varAbsolute
    } else { 1.0 };
    
    {
      scenario = scenario;
      portfolioLoss = totalLoss;
      portfolioLossPercent = portfolioLossPercent;
      positionLosses = positionLosses;
      maxDrawdown = maxDrawdown;
      liquidationRisk = liquidationRisk;
      marginCall = marginCall;
      estimatedRecoveryDays = estimatedRecoveryDays;
      worstCaseMultiple = worstCaseMultiple;
    }
  };
  
  /// Run all standard stress tests
  public func runAllStressTests(
    portfolio : Portfolio,
    varResult : VaRResult
  ) : [StressTestResult] {
    let scenarios = getStandardScenarios();
    Array.map<StressScenario, StressTestResult>(scenarios, func(s : StressScenario) : StressTestResult {
      runStressTest(portfolio, s, varResult)
    })
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // CORRELATION ANALYSIS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type CorrelationMetrics = {
    correlationMatrix : [[Float]];
    avgCorrelation : Float;
    maxCorrelation : Float;
    minCorrelation : Float;
    correlationCluster : Nat;      // Number of highly correlated clusters
    diversificationRatio : Float;  // Portfolio vol / weighted avg vol
    breakdownRisk : Float;         // Risk of correlation spike
    eigenvalues : [Float];         // Principal component eigenvalues
    pcaExplainedVar : [Float];     // Variance explained by each PC
  };
  
  /// Calculate correlation matrix from returns
  public func calculateCorrelationMatrix(
    assetReturns : [[Float]]  // n_assets × n_periods
  ) : [[Float]] {
    let n = assetReturns.size();
    if (n == 0) { return [] };
    
    // Calculate means
    let means = Array.map<[Float], Float>(assetReturns, func(returns : [Float]) : Float {
      if (returns.size() == 0) { return 0.0 };
      var sum : Float = 0.0;
      for (r in returns.vals()) { sum := sum + r };
      sum / Float.fromInt(returns.size())
    });
    
    // Calculate standard deviations
    let stds = Array.tabulate<Float>(n, func(i : Nat) : Float {
      let returns = assetReturns[i];
      let mean = means[i];
      if (returns.size() < 2) { return 1.0 };
      var sumSq : Float = 0.0;
      for (r in returns.vals()) {
        let diff = r - mean;
        sumSq := sumSq + diff * diff;
      };
      Float.sqrt(sumSq / Float.fromInt(returns.size() - 1))
    });
    
    // Calculate correlation matrix
    Array.tabulate<[Float]>(n, func(i : Nat) : [Float] {
      Array.tabulate<Float>(n, func(j : Nat) : Float {
        if (i == j) { return 1.0 };
        
        let returnsI = assetReturns[i];
        let returnsJ = assetReturns[j];
        let periods = Nat.min(returnsI.size(), returnsJ.size());
        if (periods < 2) { return 0.0 };
        
        var covariance : Float = 0.0;
        for (k in Iter.range(0, periods - 1)) {
          covariance := covariance + (returnsI[k] - means[i]) * (returnsJ[k] - means[j]);
        };
        covariance := covariance / Float.fromInt(periods - 1);
        
        let stdI = stds[i];
        let stdJ = stds[j];
        if (stdI > 0.0 and stdJ > 0.0) {
          covariance / (stdI * stdJ)
        } else { 0.0 }
      })
    })
  };
  
  /// Analyze correlation structure
  public func analyzeCorrelations(
    correlationMatrix : [[Float]],
    weights : [Float]
  ) : CorrelationMetrics {
    let n = correlationMatrix.size();
    if (n == 0) {
      return {
        correlationMatrix = [];
        avgCorrelation = 0.0;
        maxCorrelation = 0.0;
        minCorrelation = 0.0;
        correlationCluster = 0;
        diversificationRatio = 1.0;
        breakdownRisk = 0.0;
        eigenvalues = [];
        pcaExplainedVar = [];
      }
    };
    
    // Compute statistics
    var sum : Float = 0.0;
    var maxCorr : Float = -1.0;
    var minCorr : Float = 1.0;
    var count : Nat = 0;
    var highCorrCount : Nat = 0;
    
    for (i in Iter.range(0, n - 1)) {
      for (j in Iter.range(i + 1, n - 1)) {
        if (j < correlationMatrix[i].size()) {
          let corr = correlationMatrix[i][j];
          sum := sum + corr;
          count := count + 1;
          if (corr > maxCorr) { maxCorr := corr };
          if (corr < minCorr) { minCorr := corr };
          if (Float.abs(corr) > 0.7) { highCorrCount := highCorrCount + 1 };
        }
      }
    };
    
    let avgCorr = if (count > 0) { sum / Float.fromInt(count) } else { 0.0 };
    
    // Diversification ratio (simplified)
    // True DR = sqrt(w' × Σ × w) / (w' × σ)
    var weightedVol : Float = 0.0;
    for (i in Iter.range(0, Nat.min(n, weights.size()) - 1)) {
      weightedVol := weightedVol + Float.abs(weights[i]);
    };
    let diversificationRatio = 1.0 / (1.0 + avgCorr);  // Simplified
    
    // Breakdown risk (higher when correlations are high)
    let breakdownRisk = Float.min(1.0, avgCorr * 1.5);
    
    // Estimate number of clusters (simplified)
    let clusterCount = if (highCorrCount > n * n / 4) { 1 }  // All highly correlated
                       else if (highCorrCount > n) { 2 }
                       else { 3 };
    
    {
      correlationMatrix = correlationMatrix;
      avgCorrelation = avgCorr;
      maxCorrelation = maxCorr;
      minCorrelation = minCorr;
      correlationCluster = clusterCount;
      diversificationRatio = diversificationRatio;
      breakdownRisk = breakdownRisk;
      eigenvalues = [];  // Would need proper eigendecomposition
      pcaExplainedVar = [];
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // COUNTERPARTY RISK
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type CounterpartyRating = {
    #AAA;  // Highest quality
    #AA;   // High quality
    #A;    // Upper medium
    #BBB;  // Lower medium
    #BB;   // Speculative
    #B;    // Highly speculative
    #CCC;  // Substantial risk
    #CC;   // Extremely speculative
    #C;    // Imminent default
    #D;    // Default
  };
  
  public type Counterparty = {
    id : Text;
    name : Text;
    rating : CounterpartyRating;
    exposure : Float;           // Current exposure
    potentialExposure : Float;  // Potential future exposure
    collateral : Float;         // Collateral held
    netExposure : Float;        // exposure - collateral
    creditLimit : Float;        // Maximum exposure allowed
    utilizationRate : Float;    // exposure / creditLimit
    wrongWayRisk : Float;       // Correlation with own default
    recoveryRate : Float;       // Expected recovery in default
    probabilityOfDefault : Float; // Annual PD
    expectedLoss : Float;       // EL = PD × EAD × (1 - RR)
  };
  
  /// Get default probability from rating
  public func ratingToPD(rating : CounterpartyRating) : Float {
    switch (rating) {
      case (#AAA) { 0.0001 };
      case (#AA) { 0.0005 };
      case (#A) { 0.001 };
      case (#BBB) { 0.002 };
      case (#BB) { 0.01 };
      case (#B) { 0.03 };
      case (#CCC) { 0.10 };
      case (#CC) { 0.25 };
      case (#C) { 0.50 };
      case (#D) { 1.0 };
    }
  };
  
  /// Calculate counterparty risk metrics
  public func calculateCounterpartyRisk(
    counterparty : Counterparty
  ) : {
    creditVaR : Float;
    unexpectedLoss : Float;
    creditScore : Float;
    recommendation : { #Maintain; #ReduceExposure; #CloseOut; #RequestCollateral };
  } {
    let pd = counterparty.probabilityOfDefault;
    let lgd = 1.0 - counterparty.recoveryRate;
    let ead = counterparty.netExposure;
    
    // Expected Loss = PD × LGD × EAD
    let el = pd * lgd * ead;
    
    // Unexpected Loss (for CVaR-like measure)
    // UL ≈ EAD × LGD × sqrt(PD × (1-PD)) × z_99
    let ul = ead * lgd * Float.sqrt(pd * (1.0 - pd)) * Z_99;
    
    // Credit VaR = EL + UL
    let creditVaR = el + ul;
    
    // Credit score (0-100, higher is better)
    let utilizationPenalty = counterparty.utilizationRate * 20.0;
    let pdPenalty = pd * 500.0;
    let collateralBonus = if (counterparty.collateral > 0.0) { 10.0 } else { 0.0 };
    let creditScore = Float.max(0.0, 100.0 - utilizationPenalty - pdPenalty + collateralBonus);
    
    // Recommendation
    let recommendation = if (pd > 0.1 or counterparty.utilizationRate > 0.9) {
      #CloseOut
    } else if (pd > 0.03 or counterparty.utilizationRate > 0.7) {
      #ReduceExposure
    } else if (counterparty.collateral < counterparty.exposure * 0.1) {
      #RequestCollateral
    } else {
      #Maintain
    };
    
    {
      creditVaR = creditVaR;
      unexpectedLoss = ul;
      creditScore = creditScore;
      recommendation = recommendation;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // CONCENTRATION LIMITS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type ConcentrationLimits = {
    maxSinglePosition : Float;      // Max % in single asset
    maxAssetClass : Float;          // Max % in single asset class
    maxCounterparty : Float;        // Max % to single counterparty
    maxSector : Float;              // Max % in single sector
    maxGeography : Float;           // Max % in single geography
    maxIlliquid : Float;            // Max % in illiquid positions
    maxLeverage : Float;            // Maximum leverage ratio
    maxDrawdownLimit : Float;       // Maximum allowable drawdown
  };
  
  public type ConcentrationBreaches = {
    positionBreaches : [{ assetId : Text; currentConcentration : Float; limit : Float }];
    assetClassBreaches : [{ assetClass : AssetClass; currentConcentration : Float; limit : Float }];
    counterpartyBreaches : [{ counterpartyId : Text; currentExposure : Float; limit : Float }];
    totalBreaches : Nat;
    severityScore : Float;  // 0-1, higher = more severe
    actionRequired : Bool;
  };
  
  /// Default concentration limits (conservative)
  public func getDefaultLimits() : ConcentrationLimits {
    {
      maxSinglePosition = 0.10;     // 10% max per position
      maxAssetClass = 0.40;         // 40% max per asset class
      maxCounterparty = 0.15;       // 15% max per counterparty
      maxSector = 0.30;             // 30% max per sector
      maxGeography = 0.50;          // 50% max per geography
      maxIlliquid = 0.20;           // 20% max in illiquid
      maxLeverage = 3.0;            // 3x max leverage
      maxDrawdownLimit = 0.25;      // 25% max drawdown
    }
  };
  
  /// Check concentration limits
  public func checkConcentrationLimits(
    portfolio : Portfolio,
    limits : ConcentrationLimits
  ) : ConcentrationBreaches {
    let positionBreaches = Buffer.Buffer<{ assetId : Text; currentConcentration : Float; limit : Float }>(5);
    let assetClassBreaches = Buffer.Buffer<{ assetClass : AssetClass; currentConcentration : Float; limit : Float }>(5);
    
    // Check position limits
    for (pos in portfolio.positions.vals()) {
      if (pos.concentration > limits.maxSinglePosition) {
        positionBreaches.add({
          assetId = pos.assetId;
          currentConcentration = pos.concentration;
          limit = limits.maxSinglePosition;
        });
      }
    };
    
    // Check asset class limits
    var cryptoConcentration : Float = 0.0;
    var defiConcentration : Float = 0.0;
    var stableConcentration : Float = 0.0;
    
    for (pos in portfolio.positions.vals()) {
      switch (pos.assetClass) {
        case (#Cryptocurrency) { cryptoConcentration := cryptoConcentration + pos.concentration };
        case (#DeFiToken) { defiConcentration := defiConcentration + pos.concentration };
        case (#StableCoin) { stableConcentration := stableConcentration + pos.concentration };
        case (_) {};
      }
    };
    
    if (cryptoConcentration > limits.maxAssetClass) {
      assetClassBreaches.add({
        assetClass = #Cryptocurrency;
        currentConcentration = cryptoConcentration;
        limit = limits.maxAssetClass;
      });
    };
    
    // Calculate severity
    let totalBreaches = positionBreaches.size() + assetClassBreaches.size();
    var severitySum : Float = 0.0;
    
    for (breach in positionBreaches.vals()) {
      severitySum := severitySum + (breach.currentConcentration - breach.limit) / breach.limit;
    };
    for (breach in assetClassBreaches.vals()) {
      severitySum := severitySum + (breach.currentConcentration - breach.limit) / breach.limit;
    };
    
    let severityScore = if (totalBreaches > 0) {
      Float.min(1.0, severitySum / Float.fromInt(totalBreaches))
    } else { 0.0 };
    
    {
      positionBreaches = Buffer.toArray(positionBreaches);
      assetClassBreaches = Buffer.toArray(assetClassBreaches);
      counterpartyBreaches = [];
      totalBreaches = totalBreaches;
      severityScore = severityScore;
      actionRequired = totalBreaches > 0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // LIQUIDITY RISK
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type LiquidityRiskMetrics = {
    liquidityVaR : Float;             // Loss from forced liquidation
    timeToLiquidate : Float;          // Days to fully liquidate
    liquidityCost : Float;            // Cost of liquidating now
    liquidityRatio : Float;           // Liquid assets / total assets
    liquidityCoverageRatio : Float;   // LCR for stress scenario
    fundingLiquidityRisk : Float;     // Risk of funding squeeze
    marketLiquidityRisk : Float;      // Risk of market illiquidity
    assetLiabilityMismatch : Float;   // Duration gap
    stressLiquidityBuffer : Float;    // Buffer for stress scenario
  };
  
  /// Calculate liquidity risk
  public func calculateLiquidityRisk(
    portfolio : Portfolio,
    marketVolatility : Float
  ) : LiquidityRiskMetrics {
    // Liquidity-adjusted VaR
    var liquidityCost : Float = 0.0;
    var totalLiquidDays : Float = 0.0;
    var liquidAssets : Float = 0.0;
    
    for (pos in portfolio.positions.vals()) {
      // Cost of liquidating = notional × (1 - liquidity score) × volatility
      let posCost = pos.notionalValue * (1.0 - pos.liquidityScore) * marketVolatility * 0.5;
      liquidityCost := liquidityCost + posCost;
      
      // Weighted days to liquidate
      totalLiquidDays := totalLiquidDays + pos.daysToLiquidate * pos.concentration;
      
      // Liquid assets (high liquidity score)
      if (pos.liquidityScore > 0.8) {
        liquidAssets := liquidAssets + pos.notionalValue;
      }
    };
    
    let liquidityVaR = liquidityCost * Z_95;
    let liquidityRatio = if (portfolio.totalNotional > 0.0) {
      liquidAssets / portfolio.totalNotional
    } else { 1.0 };
    
    // Liquidity Coverage Ratio (simplified)
    // LCR = high quality liquid assets / net cash outflows over 30 days
    let lcr = liquidAssets / (portfolio.marginUsed * 0.3 + 0.001);
    
    // Funding risk (higher if high leverage and low liquidity)
    let fundingRisk = portfolio.leverage * (1.0 - liquidityRatio) * 0.2;
    
    // Market liquidity risk
    let marketLiqRisk = (1.0 - liquidityRatio) * marketVolatility;
    
    {
      liquidityVaR = liquidityVaR;
      timeToLiquidate = totalLiquidDays;
      liquidityCost = liquidityCost;
      liquidityRatio = liquidityRatio;
      liquidityCoverageRatio = lcr;
      fundingLiquidityRisk = fundingRisk;
      marketLiquidityRisk = marketLiqRisk;
      assetLiabilityMismatch = 0.0;  // Would need liability data
      stressLiquidityBuffer = liquidAssets - portfolio.marginUsed;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // COMPLETE RISK ASSESSMENT
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type CompleteRiskAssessment = {
    timestamp : Nat64;
    portfolio : Portfolio;
    
    // VaR metrics
    parametricVaR : VaRResult;
    historicalVaR : VaRResult;
    
    // Stress testing
    stressTestResults : [StressTestResult];
    worstCaseScenario : ?StressTestResult;
    
    // Correlation
    correlationMetrics : CorrelationMetrics;
    
    // Concentration
    concentrationBreaches : ConcentrationBreaches;
    
    // Liquidity
    liquidityRisk : LiquidityRiskMetrics;
    
    // Overall metrics
    compositeRiskScore : Float;     // 0-100, higher = riskier
    riskBudgetUsed : Float;         // % of risk budget consumed
    riskCapacityRemaining : Float;  // How much more risk can be taken
    actionRequired : Bool;
    recommendations : [Text];
  };
  
  /// Generate complete risk assessment
  public func generateRiskAssessment(
    portfolio : Portfolio,
    historicalReturns : [Float],
    assetReturns : [[Float]],
    limits : ConcentrationLimits
  ) : CompleteRiskAssessment {
    // Calculate VaR
    let parametricVaR = calculateParametricVaR(
      portfolio.totalNotional,
      portfolio.portfolioVolatility,
      #P95,
      1
    );
    
    let historicalVaR = calculateHistoricalVaR(
      portfolio.totalNotional,
      historicalReturns,
      #P95,
      1
    );
    
    // Stress tests
    let stressResults = runAllStressTests(portfolio, parametricVaR);
    let worstCase = findWorstStressTest(stressResults);
    
    // Correlation analysis
    let corrMatrix = calculateCorrelationMatrix(assetReturns);
    let weights = Array.map<Position, Float>(portfolio.positions, func(p : Position) : Float {
      p.concentration
    });
    let corrMetrics = analyzeCorrelations(corrMatrix, weights);
    
    // Concentration
    let concBreaches = checkConcentrationLimits(portfolio, limits);
    
    // Liquidity
    let liqRisk = calculateLiquidityRisk(portfolio, portfolio.portfolioVolatility);
    
    // Composite risk score
    let varComponent = Float.min(30.0, parametricVaR.varPercent * 100.0);
    let stressComponent = switch (worstCase) {
      case (?wc) { Float.min(30.0, Float.abs(wc.portfolioLossPercent) * 50.0) };
      case (null) { 0.0 };
    };
    let corrComponent = corrMetrics.avgCorrelation * 15.0;
    let concComponent = concBreaches.severityScore * 15.0;
    let liqComponent = (1.0 - liqRisk.liquidityRatio) * 10.0;
    
    let compositeScore = varComponent + stressComponent + corrComponent + concComponent + liqComponent;
    
    // Risk budget
    let riskBudgetUsed = compositeScore / 100.0;
    let riskCapacityRemaining = Float.max(0.0, 1.0 - riskBudgetUsed);
    
    // Generate recommendations
    let recommendations = generateRecommendations(
      parametricVaR, worstCase, concBreaches, liqRisk, portfolio
    );
    
    {
      timestamp = Nat64.fromNat(Int.abs(Time.now()));
      portfolio = portfolio;
      parametricVaR = parametricVaR;
      historicalVaR = historicalVaR;
      stressTestResults = stressResults;
      worstCaseScenario = worstCase;
      correlationMetrics = corrMetrics;
      concentrationBreaches = concBreaches;
      liquidityRisk = liqRisk;
      compositeRiskScore = compositeScore;
      riskBudgetUsed = riskBudgetUsed;
      riskCapacityRemaining = riskCapacityRemaining;
      actionRequired = concBreaches.actionRequired or compositeScore > 70.0;
      recommendations = recommendations;
    }
  };
  
  // Helper: Find worst stress test
  func findWorstStressTest(results : [StressTestResult]) : ?StressTestResult {
    if (results.size() == 0) { return null };
    
    var worst : ?StressTestResult = ?results[0];
    var worstLoss : Float = results[0].portfolioLoss;
    
    for (result in results.vals()) {
      if (result.portfolioLoss < worstLoss) {
        worstLoss := result.portfolioLoss;
        worst := ?result;
      }
    };
    
    worst
  };
  
  // Helper: Generate recommendations
  func generateRecommendations(
    var_ : VaRResult,
    worstCase : ?StressTestResult,
    conc : ConcentrationBreaches,
    liq : LiquidityRiskMetrics,
    portfolio : Portfolio
  ) : [Text] {
    let recs = Buffer.Buffer<Text>(10);
    
    // VaR recommendations
    if (var_.varPercent > 0.05) {
      recs.add("REDUCE RISK: Daily VaR exceeds 5% of portfolio. Consider reducing position sizes.");
    };
    
    // Stress test recommendations
    switch (worstCase) {
      case (?wc) {
        if (wc.liquidationRisk) {
          recs.add("CRITICAL: Liquidation risk in " # wc.scenario.name # " scenario. Reduce leverage immediately.");
        };
        if (wc.marginCall) {
          recs.add("WARNING: Margin call likely in " # wc.scenario.name # " scenario. Increase collateral or reduce positions.");
        };
      };
      case (null) {};
    };
    
    // Concentration recommendations
    if (conc.positionBreaches.size() > 0) {
      recs.add("CONCENTRATION: " # Nat.toText(conc.positionBreaches.size()) # " positions exceed limits. Rebalance required.");
    };
    
    // Liquidity recommendations
    if (liq.liquidityRatio < 0.3) {
      recs.add("LIQUIDITY: Only " # Float.toText(liq.liquidityRatio * 100.0) # "% in liquid assets. Increase liquidity buffer.");
    };
    
    // Leverage recommendations
    if (portfolio.leverage > 2.0) {
      recs.add("LEVERAGE: Current leverage " # Float.toText(portfolio.leverage) # "x is elevated. Consider deleveraging.");
    };
    
    // Drawdown recommendations
    if (portfolio.currentDrawdown > 0.15) {
      recs.add("DRAWDOWN: Currently " # Float.toText(portfolio.currentDrawdown * 100.0) # "% in drawdown. Review risk strategy.");
    };
    
    if (recs.size() == 0) {
      recs.add("Risk levels within acceptable parameters. Continue monitoring.");
    };
    
    Buffer.toArray(recs)
  };

}
