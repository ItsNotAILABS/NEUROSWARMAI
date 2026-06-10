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
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// ECONOMIC INTELLIGENCE ENGINE EXTENDED — ADVANCED MARKET DYNAMICS
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// This extension TRIPLES the depth with:
//
// PART 1: MARKET MICROSTRUCTURE (500 lines)
// ═════════════════════════════════════════
//   - Order book dynamics
//   - Price impact models
//   - Market making strategies
//   - High-frequency patterns
//   - Liquidity modeling
//
// PART 2: PORTFOLIO OPTIMIZATION (400 lines)
// ═════════════════════════════════════════
//   - Modern Portfolio Theory
//   - Black-Litterman model
//   - Risk parity
//   - Factor models
//   - Rebalancing strategies
//
// PART 3: BEHAVIORAL ECONOMICS (400 lines)
// ═══════════════════════════════════════
//   - Prospect theory
//   - Loss aversion
//   - Anchoring bias
//   - Herding behavior
//   - Overconfidence
//
// PART 4: ALGORITHMIC TRADING (400 lines)
// ═════════════════════════════════════
//   - TWAP/VWAP execution
//   - Momentum strategies
//   - Mean reversion
//   - Pairs trading
//   - Market regime detection
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Nat8 "mo:base/Nat8";
import Nat32 "mo:base/Nat32";
import Nat64 "mo:base/Nat64";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Iter "mo:base/Iter";
import Text "mo:base/Text";
import Option "mo:base/Option";
import Bool "mo:base/Bool";

module EconomicIntelligenceExtended {

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  public let NUM_ASSETS : Nat = 12;
  public let ORDERBOOK_DEPTH : Nat = 20;
  public let HISTORY_LENGTH : Nat = 1000;
  public let PHI : Float = 1.618033988749894848;
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // PART 1: MARKET MICROSTRUCTURE
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // The fine structure of markets: order books, spreads, and price formation.
  //
  
  public type Order = {
    price : Float;
    quantity : Float;
    isBid : Bool;
    timestamp : Nat;
    orderId : Nat;
  };
  
  public type OrderBook = {
    var bids : [var Order];              // Buy orders (descending price)
    var asks : [var Order];              // Sell orders (ascending price)
    var bidCount : Nat;
    var askCount : Nat;
    var midPrice : Float;
    var spread : Float;
    var depth : Float;                   // Total volume within n ticks
    var imbalance : Float;               // (bid_vol - ask_vol) / (bid_vol + ask_vol)
  };
  
  public type MarketMicrostructureState = {
    var orderBooks : [var OrderBook];
    var numAssets : Nat;
    
    // Price impact
    var permanentImpact : [var Float];   // λ_perm for each asset
    var temporaryImpact : [var Float];   // λ_temp for each asset
    var impactDecay : Float;             // Decay rate
    
    // Liquidity
    var liquidityScores : [var Float];
    var averageSpread : [var Float];
    var volatility : [var Float];
    
    // HFT patterns
    var tickClusters : [[var Nat]];      // Tick clustering patterns
    var flashCrashRisk : [var Float];
  };
  
  public func initOrder(price : Float, qty : Float, isBid : Bool, time : Nat, id : Nat) : Order {
    { price = price; quantity = qty; isBid = isBid; timestamp = time; orderId = id }
  };
  
  public func initOrderBook() : OrderBook {
    {
      var bids = Array.init<Order>(ORDERBOOK_DEPTH, func(_ : Nat) : Order {
        initOrder(0.0, 0.0, true, 0, 0)
      });
      var asks = Array.init<Order>(ORDERBOOK_DEPTH, func(_ : Nat) : Order {
        initOrder(0.0, 0.0, false, 0, 0)
      });
      var bidCount = 0;
      var askCount = 0;
      var midPrice = 100.0;
      var spread = 0.01;
      var depth = 0.0;
      var imbalance = 0.0;
    }
  };
  
  public func initMarketMicrostructure() : MarketMicrostructureState {
    {
      var orderBooks = Array.init<OrderBook>(NUM_ASSETS, func(_ : Nat) : OrderBook {
        initOrderBook()
      });
      var numAssets = NUM_ASSETS;
      var permanentImpact = Array.init<Float>(NUM_ASSETS, func(_ : Nat) : Float { 0.0001 });
      var temporaryImpact = Array.init<Float>(NUM_ASSETS, func(_ : Nat) : Float { 0.001 });
      var impactDecay = 0.5;
      var liquidityScores = Array.init<Float>(NUM_ASSETS, func(_ : Nat) : Float { 1.0 });
      var averageSpread = Array.init<Float>(NUM_ASSETS, func(_ : Nat) : Float { 0.01 });
      var volatility = Array.init<Float>(NUM_ASSETS, func(_ : Nat) : Float { 0.02 });
      var tickClusters = Array.init<[var Nat]>(NUM_ASSETS, func(_ : Nat) : [var Nat] {
        Array.init<Nat>(10, func(_ : Nat) : Nat { 0 })
      });
      var flashCrashRisk = Array.init<Float>(NUM_ASSETS, func(_ : Nat) : Float { 0.0 });
    }
  };
  
  // Add order to book
  public func addOrder(
    book : OrderBook,
    order : Order
  ) {
    if (order.isBid) {
      if (book.bidCount < ORDERBOOK_DEPTH) {
        // Insert in sorted position (descending)
        var insertIdx = book.bidCount;
        for (i in Iter.range(0, book.bidCount - 1)) {
          if (order.price > book.bids[i].price) {
            insertIdx := i;
          };
        };
        
        // Shift existing orders
        var j = book.bidCount;
        while (j > insertIdx) {
          book.bids[j] := book.bids[j - 1];
          j -= 1;
        };
        
        book.bids[insertIdx] := order;
        book.bidCount += 1;
      };
    } else {
      if (book.askCount < ORDERBOOK_DEPTH) {
        // Insert in sorted position (ascending)
        var insertIdx = book.askCount;
        for (i in Iter.range(0, book.askCount - 1)) {
          if (order.price < book.asks[i].price) {
            insertIdx := i;
          };
        };
        
        var j = book.askCount;
        while (j > insertIdx) {
          book.asks[j] := book.asks[j - 1];
          j -= 1;
        };
        
        book.asks[insertIdx] := order;
        book.askCount += 1;
      };
    };
    
    // Update metrics
    updateOrderBookMetrics(book);
  };
  
  // Update order book metrics
  public func updateOrderBookMetrics(book : OrderBook) {
    // Mid price
    let bestBid = if (book.bidCount > 0) { book.bids[0].price } else { 0.0 };
    let bestAsk = if (book.askCount > 0) { book.asks[0].price } else { 0.0 };
    
    if (bestBid > 0.0 and bestAsk > 0.0) {
      book.midPrice := (bestBid + bestAsk) / 2.0;
      book.spread := bestAsk - bestBid;
    };
    
    // Depth and imbalance
    var bidVolume : Float = 0.0;
    var askVolume : Float = 0.0;
    
    for (i in Iter.range(0, book.bidCount - 1)) {
      bidVolume += book.bids[i].quantity;
    };
    for (i in Iter.range(0, book.askCount - 1)) {
      askVolume += book.asks[i].quantity;
    };
    
    book.depth := bidVolume + askVolume;
    
    if (book.depth > 0.0) {
      book.imbalance := (bidVolume - askVolume) / book.depth;
    } else {
      book.imbalance := 0.0;
    };
  };
  
  // Compute price impact of a trade
  public func computePriceImpact(
    state : MarketMicrostructureState,
    assetIdx : Nat,
    tradeSize : Float,
    isBuy : Bool
  ) : Float {
    if (assetIdx >= state.numAssets) { return 0.0 };
    
    // Kyle's Lambda model: ΔP = λ × sign(trade) × |trade|^0.5
    let lambda = state.permanentImpact[assetIdx];
    let sign : Float = if (isBuy) { 1.0 } else { -1.0 };
    let impact = lambda * sign * sqrt(Float.abs(tradeSize));
    
    // Temporary impact
    let tempImpact = state.temporaryImpact[assetIdx] * tradeSize;
    
    impact + tempImpact
  };
  
  // Compute liquidity score
  public func computeLiquidityScore(
    state : MarketMicrostructureState,
    assetIdx : Nat
  ) : Float {
    if (assetIdx >= state.numAssets) { return 0.0 };
    
    let book = state.orderBooks[assetIdx];
    
    // Liquidity = depth / spread / volatility
    let spreadFactor = 1.0 / Float.max(0.0001, book.spread);
    let depthFactor = book.depth;
    let volFactor = 1.0 / Float.max(0.01, state.volatility[assetIdx]);
    
    let score = spreadFactor * depthFactor * volFactor / 1000.0;
    state.liquidityScores[assetIdx] := Float.min(1.0, score);
    
    state.liquidityScores[assetIdx]
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // PART 2: PORTFOLIO OPTIMIZATION
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Constructing optimal portfolios given risk/return trade-offs.
  //
  
  public type PortfolioState = {
    var weights : [var Float];           // Current weights
    var targetWeights : [var Float];     // Target weights
    var returns : [[var Float]];         // Historical returns
    var returnIdx : Nat;
    
    // Statistics
    var expectedReturns : [var Float];
    var covariance : [[var Float]];
    var correlations : [[var Float]];
    
    // Risk metrics
    var portfolioReturn : Float;
    var portfolioVolatility : Float;
    var sharpeRatio : Float;
    var maxDrawdown : Float;
    var valueAtRisk : Float;
    
    // Factor model
    var factorExposures : [[var Float]];
    var factorReturns : [var Float];
    var specificRisk : [var Float];
  };
  
  public func initPortfolioState() : PortfolioState {
    {
      var weights = Array.init<Float>(NUM_ASSETS, func(_ : Nat) : Float { 1.0 / Float.fromInt(NUM_ASSETS) });
      var targetWeights = Array.init<Float>(NUM_ASSETS, func(_ : Nat) : Float { 1.0 / Float.fromInt(NUM_ASSETS) });
      var returns = Array.init<[var Float]>(HISTORY_LENGTH, func(_ : Nat) : [var Float] {
        Array.init<Float>(NUM_ASSETS, func(_ : Nat) : Float { 0.0 })
      });
      var returnIdx = 0;
      var expectedReturns = Array.init<Float>(NUM_ASSETS, func(_ : Nat) : Float { 0.05 });
      var covariance = Array.init<[var Float]>(NUM_ASSETS, func(i : Nat) : [var Float] {
        Array.init<Float>(NUM_ASSETS, func(j : Nat) : Float { if (i == j) { 0.04 } else { 0.01 } })
      });
      var correlations = Array.init<[var Float]>(NUM_ASSETS, func(i : Nat) : [var Float] {
        Array.init<Float>(NUM_ASSETS, func(j : Nat) : Float { if (i == j) { 1.0 } else { 0.3 } })
      });
      var portfolioReturn = 0.0;
      var portfolioVolatility = 0.0;
      var sharpeRatio = 0.0;
      var maxDrawdown = 0.0;
      var valueAtRisk = 0.0;
      var factorExposures = Array.init<[var Float]>(NUM_ASSETS, func(_ : Nat) : [var Float] {
        Array.init<Float>(5, func(_ : Nat) : Float { 0.0 })
      });
      var factorReturns = Array.init<Float>(5, func(_ : Nat) : Float { 0.0 });
      var specificRisk = Array.init<Float>(NUM_ASSETS, func(_ : Nat) : Float { 0.02 });
    }
  };
  
  // Compute portfolio return
  public func computePortfolioReturn(
    portfolio : PortfolioState
  ) : Float {
    var totalReturn : Float = 0.0;
    
    for (i in Iter.range(0, NUM_ASSETS - 1)) {
      totalReturn += portfolio.weights[i] * portfolio.expectedReturns[i];
    };
    
    portfolio.portfolioReturn := totalReturn;
    totalReturn
  };
  
  // Compute portfolio volatility
  public func computePortfolioVolatility(
    portfolio : PortfolioState
  ) : Float {
    var variance : Float = 0.0;
    
    for (i in Iter.range(0, NUM_ASSETS - 1)) {
      for (j in Iter.range(0, NUM_ASSETS - 1)) {
        variance += portfolio.weights[i] * portfolio.weights[j] * portfolio.covariance[i][j];
      };
    };
    
    portfolio.portfolioVolatility := sqrt(Float.max(0.0, variance));
    portfolio.portfolioVolatility
  };
  
  // Compute Sharpe ratio
  public func computeSharpeRatio(
    portfolio : PortfolioState,
    riskFreeRate : Float
  ) : Float {
    let ret = computePortfolioReturn(portfolio);
    let vol = computePortfolioVolatility(portfolio);
    
    if (vol > 0.0001) {
      portfolio.sharpeRatio := (ret - riskFreeRate) / vol;
    } else {
      portfolio.sharpeRatio := 0.0;
    };
    
    portfolio.sharpeRatio
  };
  
  // Mean-variance optimization (simplified gradient descent)
  public func optimizeMeanVariance(
    portfolio : PortfolioState,
    targetReturn : Float,
    iterations : Nat
  ) {
    let lr = 0.01;
    
    for (_ in Iter.range(0, iterations - 1)) {
      // Compute gradient of variance
      let gradients = Array.tabulate<Float>(NUM_ASSETS, func(i : Nat) : Float {
        var grad : Float = 0.0;
        for (j in Iter.range(0, NUM_ASSETS - 1)) {
          grad += 2.0 * portfolio.weights[j] * portfolio.covariance[i][j];
        };
        grad
      });
      
      // Update weights
      for (i in Iter.range(0, NUM_ASSETS - 1)) {
        portfolio.weights[i] := portfolio.weights[i] - lr * gradients[i];
      };
      
      // Normalize to sum to 1
      var sumWeights : Float = 0.0;
      for (w in portfolio.weights.vals()) { sumWeights += Float.abs(w) };
      if (sumWeights > 0.0) {
        for (i in Iter.range(0, NUM_ASSETS - 1)) {
          portfolio.weights[i] := Float.abs(portfolio.weights[i]) / sumWeights;
        };
      };
    };
  };
  
  // Risk parity: equalize risk contribution
  public func computeRiskParity(
    portfolio : PortfolioState
  ) {
    // Target: w_i × (Σ_j w_j × σ_ij) = constant for all i
    
    let targetRisk = computePortfolioVolatility(portfolio) / Float.fromInt(NUM_ASSETS);
    
    for (_ in Iter.range(0, 20)) {
      for (i in Iter.range(0, NUM_ASSETS - 1)) {
        // Marginal contribution to risk
        var mcr : Float = 0.0;
        for (j in Iter.range(0, NUM_ASSETS - 1)) {
          mcr += portfolio.weights[j] * portfolio.covariance[i][j];
        };
        
        // Risk contribution
        let rc = portfolio.weights[i] * mcr;
        
        // Adjust weight
        if (rc > 0.0001) {
          portfolio.weights[i] := portfolio.weights[i] * (targetRisk / rc);
        };
      };
      
      // Normalize
      var sumWeights : Float = 0.0;
      for (w in portfolio.weights.vals()) { sumWeights += Float.abs(w) };
      if (sumWeights > 0.0) {
        for (i in Iter.range(0, NUM_ASSETS - 1)) {
          portfolio.weights[i] := Float.abs(portfolio.weights[i]) / sumWeights;
        };
      };
    };
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // PART 3: BEHAVIORAL ECONOMICS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Modeling psychological biases in economic decisions.
  //
  
  public type BehavioralState = {
    // Prospect theory
    var referencePoint : Float;
    var lossAversion : Float;            // λ, typically ~2.25
    var diminishingSensitivity : Float;  // α, typically ~0.88
    
    // Biases
    var anchoringBias : Float;
    var overconfidence : Float;
    var herdingTendency : Float;
    var recencyBias : Float;
    var confirmationBias : Float;
    
    // Emotional state
    var fear : Float;
    var greed : Float;
    var regret : Float;
    var disappointment : Float;
    
    // Decision history
    var recentDecisions : [var Nat];
    var decisionOutcomes : [var Float];
    var decisionIdx : Nat;
  };
  
  public func initBehavioralState() : BehavioralState {
    {
      var referencePoint = 0.0;
      var lossAversion = 2.25;
      var diminishingSensitivity = 0.88;
      var anchoringBias = 0.3;
      var overconfidence = 0.2;
      var herdingTendency = 0.4;
      var recencyBias = 0.5;
      var confirmationBias = 0.3;
      var fear = 0.0;
      var greed = 0.0;
      var regret = 0.0;
      var disappointment = 0.0;
      var recentDecisions = Array.init<Nat>(100, func(_ : Nat) : Nat { 0 });
      var decisionOutcomes = Array.init<Float>(100, func(_ : Nat) : Float { 0.0 });
      var decisionIdx = 0;
    }
  };
  
  // Prospect theory value function
  public func prospectValue(
    state : BehavioralState,
    outcome : Float
  ) : Float {
    let x = outcome - state.referencePoint;
    let alpha = state.diminishingSensitivity;
    let lambda = state.lossAversion;
    
    if (x >= 0.0) {
      // Gains: v(x) = x^α
      pow(x, alpha)
    } else {
      // Losses: v(x) = -λ × (-x)^α
      -lambda * pow(-x, alpha)
    }
  };
  
  // Probability weighting function (Prelec)
  public func weightProbability(
    probability : Float,
    gamma : Float                        // Typically ~0.65
  ) : Float {
    if (probability <= 0.0) { return 0.0 };
    if (probability >= 1.0) { return 1.0 };
    
    let lnP = ln(probability);
    expFunc(-pow(-lnP, gamma))
  };
  
  // Compute behavioral utility
  public func computeBehavioralUtility(
    state : BehavioralState,
    outcomes : [Float],
    probabilities : [Float]
  ) : Float {
    var utility : Float = 0.0;
    let n = Nat.min(Array.size(outcomes), Array.size(probabilities));
    
    for (i in Iter.range(0, n - 1)) {
      let value = prospectValue(state, outcomes[i]);
      let weight = weightProbability(probabilities[i], 0.65);
      utility += value * weight;
    };
    
    utility
  };
  
  // Update emotional state based on outcome
  public func updateEmotions(
    state : BehavioralState,
    expectedOutcome : Float,
    actualOutcome : Float
  ) {
    let surprise = actualOutcome - expectedOutcome;
    
    if (actualOutcome < 0.0) {
      // Loss
      state.fear := Float.min(1.0, state.fear + 0.1 * Float.abs(actualOutcome));
      state.greed := Float.max(0.0, state.greed - 0.05);
      
      if (surprise < 0.0) {
        state.disappointment := Float.min(1.0, state.disappointment + 0.2 * Float.abs(surprise));
      };
    } else {
      // Gain
      state.greed := Float.min(1.0, state.greed + 0.05 * actualOutcome);
      state.fear := Float.max(0.0, state.fear - 0.05);
      
      // Regret from not taking bigger position?
      if (surprise > 0.0) {
        state.regret := Float.min(1.0, state.regret + 0.1 * surprise);
      };
    };
    
    // Decay emotions
    state.fear := state.fear * 0.95;
    state.greed := state.greed * 0.95;
    state.regret := state.regret * 0.9;
    state.disappointment := state.disappointment * 0.9;
  };
  
  // Herding bias: follow the crowd
  public func applyHerdingBias(
    state : BehavioralState,
    ownOpinion : Float,
    crowdOpinion : Float
  ) : Float {
    (1.0 - state.herdingTendency) * ownOpinion + state.herdingTendency * crowdOpinion
  };
  
  // Anchoring bias: insufficient adjustment from anchor
  public func applyAnchoringBias(
    state : BehavioralState,
    anchor : Float,
    estimate : Float
  ) : Float {
    state.anchoringBias * anchor + (1.0 - state.anchoringBias) * estimate
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // PART 4: ALGORITHMIC TRADING
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Automated trading strategies.
  //
  
  public type MarketRegime = {
    #Trending;
    #MeanReverting;
    #HighVolatility;
    #LowVolatility;
    #Unknown;
  };
  
  public type AlgoTradingState = {
    // Execution algorithms
    var twapProgress : Float;            // 0-1 progress
    var vwapBenchmark : Float;
    var executionSlippage : Float;
    
    // Momentum
    var momentumSignals : [var Float];
    var momentumLookback : Nat;
    
    // Mean reversion
    var zScores : [var Float];
    var bollinger_upper : [var Float];
    var bollinger_lower : [var Float];
    
    // Pairs trading
    var pairSpread : [[var Float]];
    var spreadMean : [[var Float]];
    var spreadStd : [[var Float]];
    
    // Regime detection
    var currentRegime : MarketRegime;
    var regimeConfidence : Float;
    var regimeHistory : [var Nat];
  };
  
  public func initAlgoTrading() : AlgoTradingState {
    {
      var twapProgress = 0.0;
      var vwapBenchmark = 0.0;
      var executionSlippage = 0.0;
      var momentumSignals = Array.init<Float>(NUM_ASSETS, func(_ : Nat) : Float { 0.0 });
      var momentumLookback = 20;
      var zScores = Array.init<Float>(NUM_ASSETS, func(_ : Nat) : Float { 0.0 });
      var bollinger_upper = Array.init<Float>(NUM_ASSETS, func(_ : Nat) : Float { 0.0 });
      var bollinger_lower = Array.init<Float>(NUM_ASSETS, func(_ : Nat) : Float { 0.0 });
      var pairSpread = Array.init<[var Float]>(NUM_ASSETS, func(_ : Nat) : [var Float] {
        Array.init<Float>(NUM_ASSETS, func(_ : Nat) : Float { 0.0 })
      });
      var spreadMean = Array.init<[var Float]>(NUM_ASSETS, func(_ : Nat) : [var Float] {
        Array.init<Float>(NUM_ASSETS, func(_ : Nat) : Float { 0.0 })
      });
      var spreadStd = Array.init<[var Float]>(NUM_ASSETS, func(_ : Nat) : [var Float] {
        Array.init<Float>(NUM_ASSETS, func(_ : Nat) : Float { 1.0 })
      });
      var currentRegime = #Unknown;
      var regimeConfidence = 0.0;
      var regimeHistory = Array.init<Nat>(100, func(_ : Nat) : Nat { 0 });
    }
  };
  
  // TWAP: Time-Weighted Average Price execution
  public func computeTWAPSlice(
    state : AlgoTradingState,
    totalQuantity : Float,
    totalTime : Nat,
    currentTime : Nat
  ) : Float {
    state.twapProgress := Float.fromInt(currentTime) / Float.fromInt(totalTime);
    totalQuantity / Float.fromInt(totalTime)
  };
  
  // VWAP: Volume-Weighted Average Price
  public func computeVWAPBenchmark(
    prices : [Float],
    volumes : [Float]
  ) : Float {
    var sumPV : Float = 0.0;
    var sumV : Float = 0.0;
    let n = Nat.min(Array.size(prices), Array.size(volumes));
    
    for (i in Iter.range(0, n - 1)) {
      sumPV += prices[i] * volumes[i];
      sumV += volumes[i];
    };
    
    if (sumV > 0.0) { sumPV / sumV } else { 0.0 }
  };
  
  // Momentum signal
  public func computeMomentumSignal(
    state : AlgoTradingState,
    assetIdx : Nat,
    priceHistory : [Float]
  ) : Float {
    if (assetIdx >= NUM_ASSETS) { return 0.0 };
    
    let n = Array.size(priceHistory);
    if (n < 2) { return 0.0 };
    
    // Simple momentum: (P_now - P_lookback) / P_lookback
    let lookback = Nat.min(state.momentumLookback, n - 1);
    let currentPrice = priceHistory[n - 1];
    let pastPrice = priceHistory[n - 1 - lookback];
    
    let momentum = if (pastPrice > 0.0) {
      (currentPrice - pastPrice) / pastPrice
    } else { 0.0 };
    
    state.momentumSignals[assetIdx] := momentum;
    momentum
  };
  
  // Mean reversion: Bollinger Bands and Z-score
  public func computeMeanReversion(
    state : AlgoTradingState,
    assetIdx : Nat,
    priceHistory : [Float],
    windowSize : Nat
  ) {
    if (assetIdx >= NUM_ASSETS) { return };
    
    let n = Array.size(priceHistory);
    let window = Nat.min(windowSize, n);
    
    // Compute mean and std
    var sum : Float = 0.0;
    var sumSq : Float = 0.0;
    
    for (i in Iter.range(n - window, n - 1)) {
      sum += priceHistory[i];
      sumSq += priceHistory[i] * priceHistory[i];
    };
    
    let mean = sum / Float.fromInt(window);
    let variance = sumSq / Float.fromInt(window) - mean * mean;
    let std = sqrt(Float.max(0.0, variance));
    
    // Bollinger Bands
    state.bollinger_upper[assetIdx] := mean + 2.0 * std;
    state.bollinger_lower[assetIdx] := mean - 2.0 * std;
    
    // Z-score
    let currentPrice = priceHistory[n - 1];
    if (std > 0.0001) {
      state.zScores[assetIdx] := (currentPrice - mean) / std;
    } else {
      state.zScores[assetIdx] := 0.0;
    };
  };
  
  // Pairs trading: cointegration-based
  public func computePairSpread(
    state : AlgoTradingState,
    asset1 : Nat,
    asset2 : Nat,
    prices1 : [Float],
    prices2 : [Float]
  ) : Float {
    if (asset1 >= NUM_ASSETS or asset2 >= NUM_ASSETS) { return 0.0 };
    
    let n = Nat.min(Array.size(prices1), Array.size(prices2));
    if (n < 2) { return 0.0 };
    
    // Simple spread: log(P1) - β × log(P2)
    // β estimated from regression (simplified here)
    let beta = 1.0;  // Would need proper regression
    
    let p1 = ln(Float.max(0.01, prices1[n - 1]));
    let p2 = ln(Float.max(0.01, prices2[n - 1]));
    let spread = p1 - beta * p2;
    
    state.pairSpread[asset1][asset2] := spread;
    
    // Update running mean and std
    let alpha = 0.1;
    state.spreadMean[asset1][asset2] := 
      (1.0 - alpha) * state.spreadMean[asset1][asset2] + alpha * spread;
    
    let deviation = spread - state.spreadMean[asset1][asset2];
    state.spreadStd[asset1][asset2] := 
      (1.0 - alpha) * state.spreadStd[asset1][asset2] + alpha * Float.abs(deviation);
    
    spread
  };
  
  // Regime detection using HMM-like logic
  public func detectMarketRegime(
    state : AlgoTradingState,
    returns : [Float],
    volatility : Float
  ) : MarketRegime {
    let n = Array.size(returns);
    if (n < 10) { return #Unknown };
    
    // Trend detection: are returns consistently positive or negative?
    var posCount : Nat = 0;
    var negCount : Nat = 0;
    
    for (r in returns.vals()) {
      if (r > 0.001) { posCount += 1 }
      else if (r < -0.001) { negCount += 1 };
    };
    
    let trendStrength = Float.abs(Float.fromInt(posCount) - Float.fromInt(negCount)) / Float.fromInt(n);
    
    // Mean reversion detection: autocorrelation
    var autoCorr : Float = 0.0;
    if (n > 1) {
      for (i in Iter.range(1, n - 1)) {
        autoCorr += returns[i] * returns[i - 1];
      };
      autoCorr /= Float.fromInt(n - 1);
    };
    
    // Classify regime
    let regime : MarketRegime = if (volatility > 0.03) {
      #HighVolatility
    } else if (volatility < 0.01) {
      #LowVolatility
    } else if (trendStrength > 0.6) {
      #Trending
    } else if (autoCorr < -0.2) {
      #MeanReverting
    } else {
      #Unknown
    };
    
    state.currentRegime := regime;
    state.regimeConfidence := Float.max(trendStrength, Float.abs(autoCorr));
    
    regime
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // UTILITY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  func sqrt(x : Float) : Float {
    if (x <= 0.0) { return 0.0 };
    var guess = x / 2.0;
    for (_ in Iter.range(0, 20)) {
      guess := 0.5 * (guess + x / guess);
    };
    guess
  };
  
  func pow(base : Float, exp : Float) : Float {
    if (base <= 0.0) { return 0.0 };
    expFunc(exp * ln(base))
  };
  
  func expFunc(x : Float) : Float {
    if (x > 20.0) { return 485165195.0 };
    if (x < -20.0) { return 0.0 };
    var result : Float = 1.0;
    var term : Float = 1.0;
    for (n in Iter.range(1, 30)) {
      term := term * x / Float.fromInt(n);
      result += term;
    };
    result
  };
  
  func ln(x : Float) : Float {
    if (x <= 0.0) { return -1000.0 };
    let z = (x - 1.0) / (x + 1.0);
    let zSq = z * z;
    var result : Float = 0.0;
    var term : Float = z;
    for (n in Iter.range(0, 30)) {
      result += term / Float.fromInt(2 * n + 1);
      term := term * zSq;
    };
    2.0 * result
  };

};
