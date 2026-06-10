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
// ║  CONFIDENTIALITY: This code is CONFIDENTIAL and PROPRIETARY.                                             ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// MARKET ORACLE SYSTEM — BACKEND VERSION (MALE)
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// ORACLE MARKET SYSTEM
//
// The Market Oracle provides economic pricing, valuation, and market dynamics
// for the organism's internal economy and external trade.
//
// CORE FUNCTIONS:
// 1. Resource pricing (dynamic based on supply/demand)
// 2. FORMA exchange rates
// 3. Market stability index
// 4. Trade recommendation
// 5. Economic forecasting
//
// PRICE DISCOVERY:
// P = P_base × (1 + scarcity_factor) × (1 + demand_factor) × market_volatility
//
// SCARCITY:
// scarcity = 1 - (current_supply / max_supply)
//
// DEMAND:
// demand = avg_consumption / current_supply
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Nat64 "mo:core/Nat64";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Iter "mo:core/Iter";
import Time "mo:core/Time";
import Option "mo:core/Option";
import Text "mo:core/Text";

module MarketOracleSystem {

  // ═══════════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Number of tradeable resource types
  public let NUM_RESOURCE_TYPES : Nat = 12;
  
  /// Base prices for resources (in FORMA)
  public let BASE_PRICES : [Float] = [
    10.0,   // 0: Food
    15.0,   // 1: Water
    25.0,   // 2: Wood
    30.0,   // 3: Stone
    50.0,   // 4: Iron
    100.0,  // 5: Gold
    75.0,   // 6: Crystal
    40.0,   // 7: Fiber
    60.0,   // 8: Reagent
    200.0,  // 9: Artifact
    35.0,   // 10: Medicine
    20.0,   // 11: Pheromone
  ];
  
  /// Price history depth
  public let PRICE_HISTORY_LENGTH : Nat = 100;
  
  /// Market volatility bounds
  public let MIN_VOLATILITY : Float = 0.8;
  public let MAX_VOLATILITY : Float = 1.5;
  
  /// Price bounds (relative to base)
  public let MIN_PRICE_MULTIPLIER : Float = 0.25;
  public let MAX_PRICE_MULTIPLIER : Float = 4.0;
  
  /// Market update frequency (beats)
  public let MARKET_UPDATE_INTERVAL : Nat = 10;
  
  /// Trade fee percentage
  public let TRADE_FEE_RATE : Float = 0.02;
  
  /// Architect cut of trade fees
  public let ARCHITECT_FEE_SHARE : Float = 0.10;
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // RESOURCE TYPES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type ResourceType = {
    #Food;
    #Water;
    #Wood;
    #Stone;
    #Iron;
    #Gold;
    #Crystal;
    #Fiber;
    #Reagent;
    #Artifact;
    #Medicine;
    #Pheromone;
  };
  
  public func resourceTypeToIndex(rt : ResourceType) : Nat {
    switch (rt) {
      case (#Food) { 0 };
      case (#Water) { 1 };
      case (#Wood) { 2 };
      case (#Stone) { 3 };
      case (#Iron) { 4 };
      case (#Gold) { 5 };
      case (#Crystal) { 6 };
      case (#Fiber) { 7 };
      case (#Reagent) { 8 };
      case (#Artifact) { 9 };
      case (#Medicine) { 10 };
      case (#Pheromone) { 11 };
    }
  };
  
  public func indexToResourceType(n : Nat) : ResourceType {
    switch (n % 12) {
      case (0) { #Food };
      case (1) { #Water };
      case (2) { #Wood };
      case (3) { #Stone };
      case (4) { #Iron };
      case (5) { #Gold };
      case (6) { #Crystal };
      case (7) { #Fiber };
      case (8) { #Reagent };
      case (9) { #Artifact };
      case (10) { #Medicine };
      case (11) { #Pheromone };
      case (_) { #Food };
    }
  };
  
  public func resourceTypeName(rt : ResourceType) : Text {
    switch (rt) {
      case (#Food) { "Food" };
      case (#Water) { "Water" };
      case (#Wood) { "Wood" };
      case (#Stone) { "Stone" };
      case (#Iron) { "Iron" };
      case (#Gold) { "Gold" };
      case (#Crystal) { "Crystal" };
      case (#Fiber) { "Fiber" };
      case (#Reagent) { "Reagent" };
      case (#Artifact) { "Artifact" };
      case (#Medicine) { "Medicine" };
      case (#Pheromone) { "Pheromone" };
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // MARKET DATA
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type ResourceMarketData = {
    resourceType : ResourceType;
    
    // Pricing
    basePrice : Float;
    currentPrice : Float;
    priceHistory : [Float];
    
    // Supply/Demand
    totalSupply : Float;
    maxSupply : Float;
    scarcityFactor : Float;
    
    totalDemand : Float;
    avgConsumption : Float;
    demandFactor : Float;
    
    // Volume
    tradeVolume24h : Float;
    tradeCount24h : Nat;
    
    // Trends
    priceChange1h : Float;
    priceChange24h : Float;
    volatility : Float;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // TRADE RECORD
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type TradeRecord = {
    id : Nat;
    beat : Nat;
    timestamp : Int;
    
    resourceType : ResourceType;
    amount : Float;
    pricePerUnit : Float;
    totalPrice : Float;
    
    buyerId : Nat;
    sellerId : Nat;
    
    fee : Float;
    architectCut : Float;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // MARKET ORACLE STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type MarketOracleState = {
    // Per-resource market data
    var resourceMarkets : [var ResourceMarketData];
    
    // Global market state
    var marketStabilityIndex : Float;
    var globalVolatility : Float;
    var totalTradeVolume : Float;
    
    // Trade history
    var recentTrades : Buffer.Buffer<TradeRecord>;
    var totalTradesLifetime : Nat;
    var totalFeesCollected : Float;
    var totalArchitectCut : Float;
    
    // Price history buffers
    var priceHistoryBuffers : [var Buffer.Buffer<Float>];
    
    // Timing
    var lastUpdateBeat : Nat;
    var lastFullRecalcBeat : Nat;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func initResourceMarketData(index : Nat) : ResourceMarketData {
    let rt = indexToResourceType(index);
    let basePrice = if (index < BASE_PRICES.size()) { BASE_PRICES[index] } else { 10.0 };
    
    {
      resourceType = rt;
      basePrice = basePrice;
      currentPrice = basePrice;
      priceHistory = [];
      totalSupply = 1000.0;
      maxSupply = 10000.0;
      scarcityFactor = 0.0;
      totalDemand = 100.0;
      avgConsumption = 10.0;
      demandFactor = 0.0;
      tradeVolume24h = 0.0;
      tradeCount24h = 0;
      priceChange1h = 0.0;
      priceChange24h = 0.0;
      volatility = 1.0;
    }
  };
  
  public func initMarketOracleState() : MarketOracleState {
    let resourceMarkets = Array.init<ResourceMarketData>(NUM_RESOURCE_TYPES, initResourceMarketData(0));
    for (i in Iter.range(0, NUM_RESOURCE_TYPES - 1)) {
      resourceMarkets[i] := initResourceMarketData(i);
    };
    
    let priceHistoryBuffers = Array.init<Buffer.Buffer<Float>>(NUM_RESOURCE_TYPES, Buffer.Buffer<Float>(PRICE_HISTORY_LENGTH));
    
    {
      var resourceMarkets = resourceMarkets;
      var marketStabilityIndex = 1.0;
      var globalVolatility = 1.0;
      var totalTradeVolume = 0.0;
      var recentTrades = Buffer.Buffer<TradeRecord>(100);
      var totalTradesLifetime = 0;
      var totalFeesCollected = 0.0;
      var totalArchitectCut = 0.0;
      var priceHistoryBuffers = priceHistoryBuffers;
      var lastUpdateBeat = 0;
      var lastFullRecalcBeat = 0;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // PRICE CALCULATION
  // P = P_base × (1 + scarcity) × (1 + demand) × volatility
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Calculate scarcity factor: 1 - (supply / max_supply)
  public func calculateScarcity(supply : Float, maxSupply : Float) : Float {
    if (maxSupply <= 0.0) { return 1.0; };
    Float.max(0.0, 1.0 - (supply / maxSupply))
  };
  
  /// Calculate demand factor: consumption / supply
  public func calculateDemand(consumption : Float, supply : Float) : Float {
    if (supply <= 0.0) { return 2.0; };
    Float.min(2.0, consumption / supply)
  };
  
  /// Calculate current price
  public func calculatePrice(
    basePrice : Float,
    scarcity : Float,
    demand : Float,
    volatility : Float
  ) : Float {
    let rawPrice = basePrice * (1.0 + scarcity) * (1.0 + demand) * volatility;
    
    // Clamp to bounds
    Float.max(
      basePrice * MIN_PRICE_MULTIPLIER,
      Float.min(basePrice * MAX_PRICE_MULTIPLIER, rawPrice)
    )
  };
  
  /// Update prices for all resources
  public func updatePrices(state : MarketOracleState) : () {
    for (i in Iter.range(0, NUM_RESOURCE_TYPES - 1)) {
      let market = state.resourceMarkets[i];
      
      // Calculate factors
      let scarcity = calculateScarcity(market.totalSupply, market.maxSupply);
      let demand = calculateDemand(market.avgConsumption, market.totalSupply);
      
      // Calculate new price
      let newPrice = calculatePrice(market.basePrice, scarcity, demand, market.volatility);
      
      // Update price history
      if (state.priceHistoryBuffers[i].size() >= PRICE_HISTORY_LENGTH) {
        // Remove oldest
        let temp = Buffer.Buffer<Float>(PRICE_HISTORY_LENGTH);
        for (j in Iter.range(1, state.priceHistoryBuffers[i].size() - 1)) {
          temp.add(state.priceHistoryBuffers[i].get(j));
        };
        temp.add(newPrice);
        state.priceHistoryBuffers[i] := temp;
      } else {
        state.priceHistoryBuffers[i].add(newPrice);
      };
      
      // Calculate price changes
      let priceHistory = Buffer.toArray(state.priceHistoryBuffers[i]);
      let priceChange1h = if (priceHistory.size() > 10) {
        (newPrice - priceHistory[priceHistory.size() - 11]) / priceHistory[priceHistory.size() - 11]
      } else { 0.0 };
      
      let priceChange24h = if (priceHistory.size() > 0) {
        (newPrice - priceHistory[0]) / priceHistory[0]
      } else { 0.0 };
      
      // Update market data
      state.resourceMarkets[i] := {
        resourceType = market.resourceType;
        basePrice = market.basePrice;
        currentPrice = newPrice;
        priceHistory = priceHistory;
        totalSupply = market.totalSupply;
        maxSupply = market.maxSupply;
        scarcityFactor = scarcity;
        totalDemand = market.totalDemand;
        avgConsumption = market.avgConsumption;
        demandFactor = demand;
        tradeVolume24h = market.tradeVolume24h;
        tradeCount24h = market.tradeCount24h;
        priceChange1h = priceChange1h;
        priceChange24h = priceChange24h;
        volatility = market.volatility;
      };
    };
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // SUPPLY/DEMAND TRACKING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Update supply for a resource
  public func updateSupply(
    state : MarketOracleState,
    resourceType : ResourceType,
    newSupply : Float
  ) : () {
    let idx = resourceTypeToIndex(resourceType);
    let market = state.resourceMarkets[idx];
    
    state.resourceMarkets[idx] := {
      resourceType = market.resourceType;
      basePrice = market.basePrice;
      currentPrice = market.currentPrice;
      priceHistory = market.priceHistory;
      totalSupply = newSupply;
      maxSupply = market.maxSupply;
      scarcityFactor = calculateScarcity(newSupply, market.maxSupply);
      totalDemand = market.totalDemand;
      avgConsumption = market.avgConsumption;
      demandFactor = market.demandFactor;
      tradeVolume24h = market.tradeVolume24h;
      tradeCount24h = market.tradeCount24h;
      priceChange1h = market.priceChange1h;
      priceChange24h = market.priceChange24h;
      volatility = market.volatility;
    };
  };
  
  /// Record consumption for demand tracking
  public func recordConsumption(
    state : MarketOracleState,
    resourceType : ResourceType,
    amount : Float
  ) : () {
    let idx = resourceTypeToIndex(resourceType);
    let market = state.resourceMarkets[idx];
    
    // Update rolling average consumption
    let newAvg = market.avgConsumption * 0.95 + amount * 0.05;
    
    state.resourceMarkets[idx] := {
      resourceType = market.resourceType;
      basePrice = market.basePrice;
      currentPrice = market.currentPrice;
      priceHistory = market.priceHistory;
      totalSupply = market.totalSupply;
      maxSupply = market.maxSupply;
      scarcityFactor = market.scarcityFactor;
      totalDemand = market.totalDemand + amount;
      avgConsumption = newAvg;
      demandFactor = calculateDemand(newAvg, market.totalSupply);
      tradeVolume24h = market.tradeVolume24h;
      tradeCount24h = market.tradeCount24h;
      priceChange1h = market.priceChange1h;
      priceChange24h = market.priceChange24h;
      volatility = market.volatility;
    };
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // TRADE EXECUTION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Execute a trade
  public func executeTrade(
    state : MarketOracleState,
    resourceType : ResourceType,
    amount : Float,
    buyerId : Nat,
    sellerId : Nat,
    currentBeat : Nat
  ) : ?TradeRecord {
    let idx = resourceTypeToIndex(resourceType);
    let market = state.resourceMarkets[idx];
    
    // Calculate trade price
    let pricePerUnit = market.currentPrice;
    let totalPrice = pricePerUnit * amount;
    let fee = totalPrice * TRADE_FEE_RATE;
    let architectCut = fee * ARCHITECT_FEE_SHARE;
    
    // Create trade record
    let trade : TradeRecord = {
      id = state.totalTradesLifetime;
      beat = currentBeat;
      timestamp = Time.now();
      resourceType = resourceType;
      amount = amount;
      pricePerUnit = pricePerUnit;
      totalPrice = totalPrice;
      buyerId = buyerId;
      sellerId = sellerId;
      fee = fee;
      architectCut = architectCut;
    };
    
    // Update state
    state.recentTrades.add(trade);
    state.totalTradesLifetime += 1;
    state.totalFeesCollected += fee;
    state.totalArchitectCut += architectCut;
    state.totalTradeVolume += totalPrice;
    
    // Update market volume
    state.resourceMarkets[idx] := {
      resourceType = market.resourceType;
      basePrice = market.basePrice;
      currentPrice = market.currentPrice;
      priceHistory = market.priceHistory;
      totalSupply = market.totalSupply;
      maxSupply = market.maxSupply;
      scarcityFactor = market.scarcityFactor;
      totalDemand = market.totalDemand;
      avgConsumption = market.avgConsumption;
      demandFactor = market.demandFactor;
      tradeVolume24h = market.tradeVolume24h + totalPrice;
      tradeCount24h = market.tradeCount24h + 1;
      priceChange1h = market.priceChange1h;
      priceChange24h = market.priceChange24h;
      volatility = market.volatility;
    };
    
    ?trade
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // VOLATILITY CALCULATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Calculate price volatility from history
  public func calculateVolatility(priceHistory : [Float]) : Float {
    if (priceHistory.size() < 2) { return 1.0; };
    
    // Calculate standard deviation of returns
    let returns = Buffer.Buffer<Float>(priceHistory.size() - 1);
    for (i in Iter.range(1, priceHistory.size() - 1)) {
      let ret = (priceHistory[i] - priceHistory[i - 1]) / priceHistory[i - 1];
      returns.add(ret);
    };
    
    // Mean return
    var sum : Float = 0.0;
    for (r in returns.vals()) {
      sum += r;
    };
    let mean = sum / Float.fromInt(returns.size());
    
    // Variance
    var variance : Float = 0.0;
    for (r in returns.vals()) {
      let diff = r - mean;
      variance += diff * diff;
    };
    variance := variance / Float.fromInt(returns.size());
    
    // Standard deviation
    let stdDev = Float.sqrt(variance);
    
    // Convert to volatility multiplier (1.0 = normal)
    let volatility = 1.0 + stdDev * 10.0;
    
    Float.max(MIN_VOLATILITY, Float.min(MAX_VOLATILITY, volatility))
  };
  
  /// Update volatility for all resources
  public func updateVolatility(state : MarketOracleState) : () {
    var totalVol : Float = 0.0;
    
    for (i in Iter.range(0, NUM_RESOURCE_TYPES - 1)) {
      let market = state.resourceMarkets[i];
      let volatility = calculateVolatility(market.priceHistory);
      
      state.resourceMarkets[i] := {
        resourceType = market.resourceType;
        basePrice = market.basePrice;
        currentPrice = market.currentPrice;
        priceHistory = market.priceHistory;
        totalSupply = market.totalSupply;
        maxSupply = market.maxSupply;
        scarcityFactor = market.scarcityFactor;
        totalDemand = market.totalDemand;
        avgConsumption = market.avgConsumption;
        demandFactor = market.demandFactor;
        tradeVolume24h = market.tradeVolume24h;
        tradeCount24h = market.tradeCount24h;
        priceChange1h = market.priceChange1h;
        priceChange24h = market.priceChange24h;
        volatility = volatility;
      };
      
      totalVol += volatility;
    };
    
    state.globalVolatility := totalVol / Float.fromInt(NUM_RESOURCE_TYPES);
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // MARKET STABILITY INDEX
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Calculate market stability index (0 = unstable, 1 = perfectly stable)
  public func calculateMarketStability(state : MarketOracleState) : Float {
    var stabilitySum : Float = 0.0;
    
    for (i in Iter.range(0, NUM_RESOURCE_TYPES - 1)) {
      let market = state.resourceMarkets[i];
      
      // Factors that reduce stability:
      // - High volatility
      // - Large price changes
      // - High scarcity
      let volFactor = 1.0 / market.volatility;
      let changeFactor = 1.0 - Float.abs(market.priceChange24h);
      let scarcityFactor = 1.0 - market.scarcityFactor;
      
      let resourceStability = (volFactor + changeFactor + scarcityFactor) / 3.0;
      stabilitySum += resourceStability;
    };
    
    Float.max(0.0, Float.min(1.0, stabilitySum / Float.fromInt(NUM_RESOURCE_TYPES)))
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // QUERY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Get current price for a resource
  public func getPrice(state : MarketOracleState, resourceType : ResourceType) : Float {
    let idx = resourceTypeToIndex(resourceType);
    state.resourceMarkets[idx].currentPrice
  };
  
  /// Get all market data
  public func getAllMarketData(state : MarketOracleState) : [ResourceMarketData] {
    Array.freeze(state.resourceMarkets)
  };
  
  /// Get market summary
  public func getMarketSummary(state : MarketOracleState) : {
    stabilityIndex : Float;
    globalVolatility : Float;
    totalTradeVolume : Float;
    totalTrades : Nat;
    totalFees : Float;
    architectCut : Float;
  } {
    {
      stabilityIndex = state.marketStabilityIndex;
      globalVolatility = state.globalVolatility;
      totalTradeVolume = state.totalTradeVolume;
      totalTrades = state.totalTradesLifetime;
      totalFees = state.totalFeesCollected;
      architectCut = state.totalArchitectCut;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // HEARTBEAT UPDATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func tick(state : MarketOracleState, currentBeat : Nat) : () {
    // Update prices periodically
    if (currentBeat - state.lastUpdateBeat >= MARKET_UPDATE_INTERVAL) {
      updatePrices(state);
      state.lastUpdateBeat := currentBeat;
    };
    
    // Full recalculation less frequently
    if (currentBeat - state.lastFullRecalcBeat >= 100) {
      updateVolatility(state);
      state.marketStabilityIndex := calculateMarketStability(state);
      state.lastFullRecalcBeat := currentBeat;
      
      // Reset 24h volumes
      for (i in Iter.range(0, NUM_RESOURCE_TYPES - 1)) {
        let market = state.resourceMarkets[i];
        state.resourceMarkets[i] := {
          resourceType = market.resourceType;
          basePrice = market.basePrice;
          currentPrice = market.currentPrice;
          priceHistory = market.priceHistory;
          totalSupply = market.totalSupply;
          maxSupply = market.maxSupply;
          scarcityFactor = market.scarcityFactor;
          totalDemand = 0.0; // Reset
          avgConsumption = market.avgConsumption;
          demandFactor = market.demandFactor;
          tradeVolume24h = market.tradeVolume24h * 0.9; // Decay
          tradeCount24h = 0; // Reset
          priceChange1h = market.priceChange1h;
          priceChange24h = market.priceChange24h;
          volatility = market.volatility;
        };
      };
      
      // Prune old trades
      if (state.recentTrades.size() > 1000) {
        let recent = Buffer.Buffer<TradeRecord>(500);
        for (i in Iter.range(state.recentTrades.size() - 500, state.recentTrades.size() - 1)) {
          recent.add(state.recentTrades.get(i));
        };
        state.recentTrades := recent;
      };
    };
  };

}
