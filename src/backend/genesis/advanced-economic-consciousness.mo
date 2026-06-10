// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  ADVANCED ECONOMIC CONSCIOUSNESS MODULE                                                                   ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║  Framework: Medina Doctrine                                                                               ║
// ║                                                                                                           ║
// ║  This module implements economic cognition integrating:                                                   ║
// ║  • Value representation and computation                                                                   ║
// ║  • Prospect theory and loss aversion                                                                      ║
// ║  • Temporal discounting and intertemporal choice                                                         ║
// ║  • Risk perception and uncertainty processing                                                             ║
// ║  • Social value computation (fairness, reciprocity)                                                      ║
// ║  • Market sentiment and collective intelligence                                                          ║
// ║  • Token consciousness - awareness of economic state                                                      ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Nat64 "mo:core/Nat64";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Text "mo:core/Text";
import Time "mo:core/Time";
import Iter "mo:core/Iter";

module {
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  let PI : Float = 3.14159265358979323846;
  let E : Float = 2.71828182845904523536;
  let PHI : Float = 1.61803398874989484820;
  let SOVEREIGN_FLOOR : Float = 0.75;
  
  // Prospect theory parameters (Kahneman & Tversky)
  let ALPHA_GAINS : Float = 0.88;     // Diminishing sensitivity for gains
  let ALPHA_LOSSES : Float = 0.88;    // Diminishing sensitivity for losses
  let LAMBDA_LOSS : Float = 2.25;     // Loss aversion coefficient
  let GAMMA_PROB : Float = 0.61;      // Probability weighting parameter
  let DELTA_PROB : Float = 0.69;
  
  // Temporal discounting
  let DISCOUNT_K : Float = 0.025;     // Hyperbolic discounting constant
  let BETA_PRESENT : Float = 0.7;     // Present bias (beta-delta)
  let DELTA_FUTURE : Float = 0.99;    // Long-run discount factor
  
  // Token identifiers
  let NUM_TOKENS : Nat = 12;
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // TYPE DEFINITIONS - VALUE REPRESENTATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Value neuron - encodes economic value
  public type ValueNeuron = {
    neuronId : Nat;
    valueType : ValueType;
    currentValue : Float;
    baselineValue : Float;           // Reference point
    firingRate : Float;
    sensitivity : Float;             // Response to value changes
    adaptationRate : Float;          // How fast baseline adjusts
    lastUpdateTime : Int;
  };
  
  public type ValueType = {
    #Absolute;                        // Raw monetary value
    #Relative;                        // Relative to reference
    #Social;                          // Social/fairness value
    #Temporal;                        // Time-dependent value
    #Uncertainty;                     // Value under uncertainty
  };
  
  /// Value representation in multiple currencies
  public type MultiTokenValue = {
    tokenValues : [TokenValue];
    aggregateValue : Float;          // Combined value
    confidence : Float;
    lastComputeTime : Int;
  };
  
  public type TokenValue = {
    tokenId : Nat;
    tokenName : Text;
    amount : Float;
    unitValue : Float;               // Value per unit
    totalValue : Float;              // amount * unitValue
    volatility : Float;
    trend : Float;                   // Recent price trend
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // TYPE DEFINITIONS - PROSPECT THEORY
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Prospect - A gamble/choice with outcomes and probabilities
  public type Prospect = {
    prospectId : Nat;
    outcomes : [Outcome];
    expectedValue : Float;
    prospectValue : Float;           // PT-weighted value
    certaintyEquivalent : Float;
    riskPremium : Float;
  };
  
  public type Outcome = {
    value : Float;                   // Monetary outcome
    probability : Float;             // Objective probability
    weightedProb : Float;            // Subjective (weighted) probability
    isGain : Bool;
    utilityValue : Float;            // Value function transformed
  };
  
  /// Reference point tracking
  public type ReferencePoint = {
    var currentPoint : Float;
    var pointHistory : Buffer.Buffer<ReferenceSnapshot>;
    var adaptationSpeed : Float;
    var contextualShifts : Float;
    var aspirationLevel : Float;
    var statusQuo : Float;
  };
  
  public type ReferenceSnapshot = {
    timestamp : Int;
    value : Float;
    context : Text;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // TYPE DEFINITIONS - TEMPORAL DISCOUNTING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Intertemporal choice
  public type IntertemporalChoice = {
    immediateOption : Float;
    delayedOption : Float;
    delay : Int;                      // Delay in nanoseconds
    discountedValue : Float;         // Present value of delayed option
    preferenceStrength : Float;      // How strong the preference
    impulsivityFactor : Float;
  };
  
  /// Discount function state
  public type DiscountState = {
    var hyperbolicK : Float;         // Hyperbolic discount rate
    var exponentialDelta : Float;    // Exponential discount factor
    var presentBiasBeta : Float;     // Present bias
    var impulsivity : Float;         // Individual impulsivity
    var patience : Float;            // Opposite of impulsivity
    var futureOrientation : Float;   // How much future matters
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // TYPE DEFINITIONS - RISK PROCESSING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Risk perception
  public type RiskPerception = {
    objectiveRisk : Float;           // Statistical risk
    perceivedRisk : Float;           // Subjective risk
    riskTolerance : Float;           // Individual tolerance
    ambiguityAversion : Float;       // Aversion to unknown probs
    dreadFactor : Float;             // Fear-inducing aspects
    controllability : Float;         // Perceived control
    familiarityBias : Float;
  };
  
  /// Uncertainty quantification
  public type UncertaintyState = {
    var aleatoric : Float;           // Inherent randomness
    var epistemic : Float;           // Knowledge uncertainty
    var totalUncertainty : Float;
    var confidenceInterval : [Float];
    var worstCase : Float;
    var bestCase : Float;
    var mostLikely : Float;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // TYPE DEFINITIONS - SOCIAL VALUE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Social preference model
  public type SocialPreferences = {
    var altruism : Float;            // Concern for others' welfare
    var fairness : Float;            // Inequity aversion
    var reciprocity : Float;         // Respond to kindness/unkindness
    var trustLevel : Float;          // Trust in others
    var envy : Float;                // Negative response to others' gains
    var spite : Float;               // Willingness to hurt others
    var guilt : Float;               // Response to unequal outcomes
    var warmGlow : Float;            // Joy from giving
  };
  
  /// Fairness computation
  public type FairnessAssessment = {
    distributiveJustice : Float;     // Fair distribution
    proceduralJustice : Float;       // Fair process
    interactionalJustice : Float;    // Respectful treatment
    overallFairness : Float;
    selfOtherRatio : Float;          // What I get vs others
    deviationFromEqual : Float;
  };
  
  /// Ultimatum game state (canonical fairness test)
  public type UltimatumState = {
    proposerOffer : Float;
    totalPie : Float;
    acceptanceThreshold : Float;     // Minimum acceptable offer
    rejectionLikelihood : Float;
    emotionalResponse : Float;       // Anger from unfair offers
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // TYPE DEFINITIONS - MARKET CONSCIOUSNESS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Market state awareness
  public type MarketConsciousness = {
    var currentSentiment : Float;    // -1 (fear) to +1 (greed)
    var volatilityPerception : Float;
    var trendAwareness : Float;
    var liquidityPerception : Float;
    var crowdBehavior : CrowdState;
    var narrativeStrength : Float;   // Power of current narrative
    var regimeState : MarketRegime;
  };
  
  public type CrowdState = {
    herding : Float;                 // Following the crowd
    contrarian : Float;              // Going against crowd
    momentum : Float;                // Following trends
    meanReversion : Float;           // Expecting reversion
    consensusLevel : Float;
  };
  
  public type MarketRegime = {
    #Bull;
    #Bear;
    #Sideways;
    #HighVolatility;
    #LowVolatility;
    #Crisis;
    #Recovery;
  };
  
  /// Token consciousness - awareness of each token's state
  public type TokenConsciousness = {
    tokenId : Nat;
    name : Text;
    awarenessLevel : Float;          // How much attention to this token
    valuePercept : Float;            // Perceived value
    trendPercept : Float;            // Perceived trend
    riskPercept : Float;             // Perceived risk
    utilityWeight : Float;           // How useful for organism
    emotionalValence : Float;        // Feelings about token
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // TYPE DEFINITIONS - COLLECTIVE INTELLIGENCE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Wisdom of crowds state
  public type CollectiveIntelligence = {
    var aggregatePrediction : Float;
    var predictionDiversity : Float;
    var informationCascade : Bool;
    var polarization : Float;
    var collectiveAccuracy : Float;
    var participantCount : Nat;
    var weightedConsensus : Float;
  };
  
  /// Agent prediction
  public type AgentPrediction = {
    agentId : Nat;
    prediction : Float;
    confidence : Float;
    trackRecord : Float;             // Historical accuracy
    weight : Float;
    timestamp : Int;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // MAIN STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type EconomicConsciousnessState = {
    // Value neurons
    var valueNeurons : [var ValueNeuron];
    var numValueNeurons : Nat;
    
    // Multi-token value
    var multiTokenValue : MultiTokenValue;
    var tokenConsciousness : [var TokenConsciousness];
    
    // Prospect theory
    var referencePoint : ReferencePoint;
    var recentProspects : Buffer.Buffer<Prospect>;
    var lossAversion : Float;
    
    // Temporal discounting
    var discountState : DiscountState;
    var pendingChoices : Buffer.Buffer<IntertemporalChoice>;
    
    // Risk processing
    var riskPerception : RiskPerception;
    var uncertaintyState : UncertaintyState;
    
    // Social value
    var socialPreferences : SocialPreferences;
    var fairnessHistory : Buffer.Buffer<FairnessAssessment>;
    
    // Market consciousness
    var marketConsciousness : MarketConsciousness;
    var collectiveIntelligence : CollectiveIntelligence;
    var agentPredictions : Buffer.Buffer<AgentPrediction>;
    
    // Integration
    var overallEconomicState : Float;
    var decisionQuality : Float;
    var wealthPerception : Float;
    
    // Temporal
    var tickCount : Nat;
    var lastTickTime : Int;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Initialize economic consciousness
  public func initEconomicConsciousness() : EconomicConsciousnessState {
    let now = Time.now();
    
    {
      var valueNeurons = initValueNeurons(64);
      var numValueNeurons = 64;
      var multiTokenValue = initMultiTokenValue();
      var tokenConsciousness = initTokenConsciousness();
      var referencePoint = initReferencePoint();
      var recentProspects = Buffer.Buffer<Prospect>(64);
      var lossAversion = LAMBDA_LOSS;
      var discountState = initDiscountState();
      var pendingChoices = Buffer.Buffer<IntertemporalChoice>(32);
      var riskPerception = initRiskPerception();
      var uncertaintyState = initUncertaintyState();
      var socialPreferences = initSocialPreferences();
      var fairnessHistory = Buffer.Buffer<FairnessAssessment>(256);
      var marketConsciousness = initMarketConsciousness();
      var collectiveIntelligence = initCollectiveIntelligence();
      var agentPredictions = Buffer.Buffer<AgentPrediction>(1024);
      var overallEconomicState = SOVEREIGN_FLOOR;
      var decisionQuality = SOVEREIGN_FLOOR;
      var wealthPerception = 0.5;
      var tickCount = 0;
      var lastTickTime = now;
    }
  };
  
  func initValueNeurons(n : Nat) : [var ValueNeuron] {
    let types : [ValueType] = [#Absolute, #Relative, #Social, #Temporal, #Uncertainty];
    
    Array.init<ValueNeuron>(n, func(i) {
      {
        neuronId = i;
        valueType = types[i % types.size()];
        currentValue = 0.0;
        baselineValue = 0.0;
        firingRate = 10.0;
        sensitivity = 1.0;
        adaptationRate = 0.01;
        lastUpdateTime = Time.now();
      }
    })
  };
  
  func initMultiTokenValue() : MultiTokenValue {
    let tokenNames = ["FORMA", "SEED", "GTK", "CVT", "VCT", "KNT", "SBT", "HBT", "DRT", "OMT", "MTH", "MRC"];
    
    {
      tokenValues = Array.tabulate<TokenValue>(NUM_TOKENS, func(i) {
        {
          tokenId = i;
          tokenName = tokenNames[i];
          amount = 0.0;
          unitValue = 1.0;
          totalValue = 0.0;
          volatility = 0.1;
          trend = 0.0;
        }
      });
      aggregateValue = 0.0;
      confidence = 0.5;
      lastComputeTime = Time.now();
    }
  };
  
  func initTokenConsciousness() : [var TokenConsciousness] {
    let tokenNames = ["FORMA", "SEED", "GTK", "CVT", "VCT", "KNT", "SBT", "HBT", "DRT", "OMT", "MTH", "MRC"];
    
    Array.init<TokenConsciousness>(NUM_TOKENS, func(i) {
      {
        tokenId = i;
        name = tokenNames[i];
        awarenessLevel = if (i == 0) { 0.9 } else { 0.5 }; // FORMA highest
        valuePercept = 1.0;
        trendPercept = 0.0;
        riskPercept = 0.2;
        utilityWeight = 1.0 / Float.fromInt(i + 1);
        emotionalValence = 0.5;
      }
    })
  };
  
  func initReferencePoint() : ReferencePoint {
    {
      var currentPoint = 0.0;
      var pointHistory = Buffer.Buffer<ReferenceSnapshot>(1024);
      var adaptationSpeed = 0.1;
      var contextualShifts = 0.0;
      var aspirationLevel = 0.0;
      var statusQuo = 0.0;
    }
  };
  
  func initDiscountState() : DiscountState {
    {
      var hyperbolicK = DISCOUNT_K;
      var exponentialDelta = DELTA_FUTURE;
      var presentBiasBeta = BETA_PRESENT;
      var impulsivity = 0.3;
      var patience = 0.7;
      var futureOrientation = 0.6;
    }
  };
  
  func initRiskPerception() : RiskPerception {
    {
      objectiveRisk = 0.0;
      perceivedRisk = 0.0;
      riskTolerance = 0.5;
      ambiguityAversion = 0.5;
      dreadFactor = 0.0;
      controllability = 0.5;
      familiarityBias = 0.5;
    }
  };
  
  func initUncertaintyState() : UncertaintyState {
    {
      var aleatoric = 0.1;
      var epistemic = 0.3;
      var totalUncertainty = 0.4;
      var confidenceInterval = [-0.2, 0.2];
      var worstCase = -1.0;
      var bestCase = 1.0;
      var mostLikely = 0.0;
    }
  };
  
  func initSocialPreferences() : SocialPreferences {
    {
      var altruism = 0.3;
      var fairness = 0.6;
      var reciprocity = 0.7;
      var trustLevel = 0.5;
      var envy = 0.2;
      var spite = 0.1;
      var guilt = 0.4;
      var warmGlow = 0.3;
    }
  };
  
  func initMarketConsciousness() : MarketConsciousness {
    {
      var currentSentiment = 0.0;
      var volatilityPerception = 0.2;
      var trendAwareness = 0.0;
      var liquidityPerception = 0.8;
      var crowdBehavior = {
        herding = 0.3;
        contrarian = 0.2;
        momentum = 0.3;
        meanReversion = 0.2;
        consensusLevel = 0.5;
      };
      var narrativeStrength = 0.5;
      var regimeState = #Sideways;
    }
  };
  
  func initCollectiveIntelligence() : CollectiveIntelligence {
    {
      var aggregatePrediction = 0.0;
      var predictionDiversity = 0.5;
      var informationCascade = false;
      var polarization = 0.0;
      var collectiveAccuracy = 0.5;
      var participantCount = 0;
      var weightedConsensus = 0.0;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // VALUE FUNCTION (Prospect Theory)
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Apply prospect theory value function to outcome
  public func valueFunction(state : EconomicConsciousnessState, outcome : Float) : Float {
    let reference = state.referencePoint.currentPoint;
    let deviation = outcome - reference;
    
    if (deviation >= 0.0) {
      // Gains: v(x) = x^α
      Float.pow(deviation, ALPHA_GAINS)
    } else {
      // Losses: v(x) = -λ|x|^α
      -state.lossAversion * Float.pow(Float.abs(deviation), ALPHA_LOSSES)
    }
  };
  
  /// Apply probability weighting function
  public func weightProbability(p : Float, isGain : Bool) : Float {
    if (p <= 0.0) return 0.0;
    if (p >= 1.0) return 1.0;
    
    let gamma = if (isGain) { GAMMA_PROB } else { DELTA_PROB };
    
    // Prelec function: w(p) = exp(-(-ln(p))^γ)
    let negLogP = -Float.log(p);
    Float.exp(-Float.pow(negLogP, gamma))
  };
  
  /// Evaluate a prospect (gamble)
  public func evaluateProspect(state : EconomicConsciousnessState, outcomes : [(Float, Float)]) : Prospect {
    let processedOutcomes = Buffer.Buffer<Outcome>(outcomes.size());
    var prospectValue : Float = 0.0;
    var expectedValue : Float = 0.0;
    
    for ((value, prob) in outcomes.vals()) {
      let isGain = value >= state.referencePoint.currentPoint;
      let utilityVal = valueFunction(state, value);
      let weightedP = weightProbability(prob, isGain);
      
      prospectValue += weightedP * utilityVal;
      expectedValue += prob * value;
      
      processedOutcomes.add({
        value = value;
        probability = prob;
        weightedProb = weightedP;
        isGain = isGain;
        utilityValue = utilityVal;
      });
    };
    
    // Compute certainty equivalent (inverse of value function)
    let certaintyEquiv = if (prospectValue >= 0.0) {
      Float.pow(prospectValue, 1.0 / ALPHA_GAINS) + state.referencePoint.currentPoint
    } else {
      state.referencePoint.currentPoint - Float.pow(Float.abs(prospectValue) / state.lossAversion, 1.0 / ALPHA_LOSSES)
    };
    
    let prospect : Prospect = {
      prospectId = state.recentProspects.size();
      outcomes = Buffer.toArray(processedOutcomes);
      expectedValue = expectedValue;
      prospectValue = prospectValue;
      certaintyEquivalent = certaintyEquiv;
      riskPremium = expectedValue - certaintyEquiv;
    };
    
    state.recentProspects.add(prospect);
    prospect
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // TEMPORAL DISCOUNTING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Hyperbolic discount function: V = A / (1 + kD)
  public func hyperbolicDiscount(amount : Float, delayDays : Float, k : Float) : Float {
    amount / (1.0 + k * delayDays)
  };
  
  /// Quasi-hyperbolic (beta-delta) discount: V = βδ^t × A
  public func quasiHyperbolicDiscount(state : EconomicConsciousnessState, amount : Float, periods : Nat) : Float {
    let ds = state.discountState;
    
    if (periods == 0) {
      amount
    } else {
      ds.presentBiasBeta * Float.pow(ds.exponentialDelta, Float.fromInt(periods)) * amount
    }
  };
  
  /// Evaluate intertemporal choice
  public func evaluateIntertemporalChoice(
    state : EconomicConsciousnessState,
    immediate : Float,
    delayed : Float,
    delayNs : Int
  ) : IntertemporalChoice {
    let ds = state.discountState;
    let delayDays = Float.fromInt(delayNs) / Float.fromInt(86_400_000_000_000);
    
    // Compute discounted value using hyperbolic
    let discounted = hyperbolicDiscount(delayed, delayDays, ds.hyperbolicK);
    
    // Preference strength (how much better one option is)
    let prefStrength = Float.abs(immediate - discounted) / Float.max(immediate, discounted);
    
    // Impulsivity factor based on delay magnitude
    let impulsivity = ds.impulsivity * Float.exp(-delayDays / 30.0);
    
    {
      immediateOption = immediate;
      delayedOption = delayed;
      delay = delayNs;
      discountedValue = discounted;
      preferenceStrength = prefStrength;
      impulsivityFactor = impulsivity;
    }
  };
  
  /// Update discount parameters based on experience
  public func updateDiscountParameters(state : EconomicConsciousnessState, choseDelayed : Bool, delayDays : Float) {
    let ds = state.discountState;
    
    if (choseDelayed) {
      // Increase patience
      ds.patience := Float.min(1.0, ds.patience + 0.01);
      ds.impulsivity := Float.max(0.0, ds.impulsivity - 0.01);
      ds.futureOrientation := Float.min(1.0, ds.futureOrientation + 0.005);
      
      // Lower discount rate (more patient)
      ds.hyperbolicK := Float.max(0.001, ds.hyperbolicK * 0.99);
    } else {
      // Increase impulsivity
      ds.impulsivity := Float.min(1.0, ds.impulsivity + 0.01);
      ds.patience := Float.max(0.0, ds.patience - 0.01);
      
      // Higher discount rate (less patient)
      ds.hyperbolicK := Float.min(0.5, ds.hyperbolicK * 1.01);
    };
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // RISK PROCESSING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Update risk perception
  public func updateRiskPerception(state : EconomicConsciousnessState, newObservation : Float) {
    let risk = state.riskPerception;
    
    // Update perceived risk with psychophysical transformation
    let rawRisk = Float.abs(newObservation);
    
    // Risk perception is nonlinear (overweight small, underweight large)
    let perceivedRisk = 1.0 - Float.exp(-rawRisk * 3.0);
    
    // Apply dread factor
    let dreadAdjusted = perceivedRisk * (1.0 + risk.dreadFactor);
    
    // Apply controllability discount
    let controlAdjusted = dreadAdjusted * (1.0 - risk.controllability * 0.3);
    
    // Apply familiarity discount
    let familiarAdjusted = controlAdjusted * (1.0 - risk.familiarityBias * 0.2);
    
    // Blend with current perception
    state.riskPerception := {
      risk with
      objectiveRisk = rawRisk;
      perceivedRisk = risk.perceivedRisk * 0.8 + familiarAdjusted * 0.2;
    };
  };
  
  /// Compute risk-adjusted value
  public func riskAdjustedValue(state : EconomicConsciousnessState, expectedValue : Float, variance : Float) : Float {
    let risk = state.riskPerception;
    
    // Mean-variance utility: U = E[V] - (1/2)λσ²
    let riskCoeff = (1.0 - risk.riskTolerance) * 2.0;
    expectedValue - 0.5 * riskCoeff * variance
  };
  
  /// Update uncertainty quantification
  public func updateUncertainty(state : EconomicConsciousnessState, observations : [Float]) {
    let unc = state.uncertaintyState;
    
    if (observations.size() == 0) return;
    
    // Compute statistics
    var sum : Float = 0.0;
    var sumSq : Float = 0.0;
    var minVal : Float = observations[0];
    var maxVal : Float = observations[0];
    
    for (obs in observations.vals()) {
      sum += obs;
      sumSq += obs * obs;
      if (obs < minVal) { minVal := obs };
      if (obs > maxVal) { maxVal := obs };
    };
    
    let n = Float.fromInt(observations.size());
    let mean = sum / n;
    let variance = sumSq / n - mean * mean;
    let stdDev = Float.sqrt(Float.max(0.0, variance));
    
    // Aleatoric = irreducible randomness (estimated from variance)
    let aleatoric = Float.min(1.0, stdDev);
    
    // Epistemic = knowledge uncertainty (decreases with sample size)
    let epistemic = 1.0 / Float.sqrt(n);
    
    unc.aleatoric := aleatoric;
    unc.epistemic := epistemic;
    unc.totalUncertainty := Float.sqrt(aleatoric * aleatoric + epistemic * epistemic);
    unc.confidenceInterval := [mean - 1.96 * stdDev, mean + 1.96 * stdDev];
    unc.worstCase := minVal;
    unc.bestCase := maxVal;
    unc.mostLikely := mean;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // SOCIAL VALUE COMPUTATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Compute Fehr-Schmidt inequity aversion utility
  public func inequityAversionUtility(
    state : EconomicConsciousnessState,
    selfPayoff : Float,
    otherPayoff : Float
  ) : Float {
    let prefs = state.socialPreferences;
    
    let diff = selfPayoff - otherPayoff;
    
    if (diff >= 0.0) {
      // Ahead: guilt from advantageous inequity
      selfPayoff - prefs.guilt * diff
    } else {
      // Behind: envy from disadvantageous inequity
      selfPayoff - prefs.envy * Float.abs(diff)
    }
  };
  
  /// Compute fairness assessment
  public func assessFairness(
    state : EconomicConsciousnessState,
    selfShare : Float,
    totalPool : Float,
    numParticipants : Nat
  ) : FairnessAssessment {
    let equalShare = totalPool / Float.fromInt(numParticipants);
    let selfOtherRatio = if (totalPool - selfShare > 0.0001) {
      selfShare / ((totalPool - selfShare) / Float.fromInt(numParticipants - 1))
    } else { 1.0 };
    
    let deviationFromEqual = (selfShare - equalShare) / Float.max(equalShare, 0.0001);
    
    // Distributive justice: how close to equal split
    let distributive = 1.0 - Float.abs(deviationFromEqual);
    
    // Procedural justice: assume fair process for now
    let procedural = 0.8;
    
    // Interactional justice: base level
    let interactional = 0.7;
    
    let overall = (distributive + procedural + interactional) / 3.0;
    
    let assessment : FairnessAssessment = {
      distributiveJustice = distributive;
      proceduralJustice = procedural;
      interactionalJustice = interactional;
      overallFairness = overall;
      selfOtherRatio = selfOtherRatio;
      deviationFromEqual = deviationFromEqual;
    };
    
    state.fairnessHistory.add(assessment);
    assessment
  };
  
  /// Ultimatum game response
  public func ultimatumResponse(state : EconomicConsciousnessState, offer : Float, total : Float) : UltimatumState {
    let prefs = state.socialPreferences;
    
    let shareOffered = offer / total;
    
    // Minimum acceptable offer (influenced by fairness and spite)
    let minAcceptable = 0.1 + prefs.fairness * 0.3 - prefs.spite * 0.1;
    
    // Rejection likelihood based on offer vs threshold
    let rejectionLikelihood = if (shareOffered >= minAcceptable) {
      Float.max(0.0, (minAcceptable - shareOffered) * 2.0)
    } else {
      Float.min(1.0, (minAcceptable - shareOffered) * 3.0)
    };
    
    // Emotional response (anger from unfair offers)
    let emotionalResponse = if (shareOffered < 0.5) {
      (0.5 - shareOffered) * prefs.fairness * 2.0
    } else { 0.0 };
    
    {
      proposerOffer = offer;
      totalPie = total;
      acceptanceThreshold = minAcceptable;
      rejectionLikelihood = rejectionLikelihood;
      emotionalResponse = emotionalResponse;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // MARKET CONSCIOUSNESS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Update market sentiment
  public func updateMarketSentiment(state : EconomicConsciousnessState, priceChange : Float, volume : Float) {
    let mc = state.marketConsciousness;
    
    // Sentiment moves with price but mean-reverts
    let sentimentChange = priceChange * 0.3;
    let newSentiment = mc.currentSentiment * 0.9 + sentimentChange * 0.1;
    mc.currentSentiment := Float.max(-1.0, Float.min(1.0, newSentiment));
    
    // Volatility perception
    let volChange = Float.abs(priceChange);
    mc.volatilityPerception := mc.volatilityPerception * 0.95 + volChange * 0.05;
    
    // Trend awareness
    mc.trendAwareness := mc.trendAwareness * 0.8 + priceChange * 0.2;
    
    // Liquidity perception based on volume
    mc.liquidityPerception := mc.liquidityPerception * 0.9 + volume * 0.1;
    
    // Update regime state
    mc.regimeState := determineRegime(mc.currentSentiment, mc.volatilityPerception, mc.trendAwareness);
  };
  
  func determineRegime(sentiment : Float, volatility : Float, trend : Float) : MarketRegime {
    if (volatility > 0.5) {
      if (sentiment < -0.3) { #Crisis }
      else { #HighVolatility }
    } else if (trend > 0.2) {
      #Bull
    } else if (trend < -0.2) {
      #Bear
    } else if (sentiment > 0.3 and volatility < 0.2) {
      #Recovery
    } else if (volatility < 0.1) {
      #LowVolatility
    } else {
      #Sideways
    }
  };
  
  /// Update token consciousness
  public func updateTokenConsciousness(state : EconomicConsciousnessState, tokenId : Nat, price : Float, volume : Float) {
    if (tokenId >= NUM_TOKENS) return;
    
    let tc = state.tokenConsciousness[tokenId];
    
    // Value percept tracks price
    let newValuePercept = tc.valuePercept * 0.9 + price * 0.1;
    
    // Trend percept from recent price change
    let newTrendPercept = tc.trendPercept * 0.8 + (price - tc.valuePercept) * 0.2;
    
    // Risk percept from volatility
    let priceChange = Float.abs(price - tc.valuePercept);
    let newRiskPercept = tc.riskPercept * 0.9 + priceChange * 0.1;
    
    // Awareness increases with activity
    let activityBoost = Float.min(0.1, volume * 0.01);
    let newAwareness = Float.min(1.0, tc.awarenessLevel + activityBoost);
    
    // Emotional valence from trend and risk
    let newValence = 0.5 + newTrendPercept * 0.3 - newRiskPercept * 0.2;
    
    state.tokenConsciousness[tokenId] := {
      tc with
      valuePercept = newValuePercept;
      trendPercept = newTrendPercept;
      riskPercept = newRiskPercept;
      awarenessLevel = newAwareness;
      emotionalValence = Float.max(0.0, Float.min(1.0, newValence));
    };
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // COLLECTIVE INTELLIGENCE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Add agent prediction
  public func addAgentPrediction(state : EconomicConsciousnessState, agentId : Nat, prediction : Float, confidence : Float) {
    let pred : AgentPrediction = {
      agentId = agentId;
      prediction = prediction;
      confidence = confidence;
      trackRecord = 0.5; // Default track record
      weight = confidence;
      timestamp = Time.now();
    };
    
    state.agentPredictions.add(pred);
  };
  
  /// Compute aggregate prediction using wisdom of crowds
  public func computeAggregatePrediction(state : EconomicConsciousnessState) : Float {
    let ci = state.collectiveIntelligence;
    
    if (state.agentPredictions.size() == 0) return 0.0;
    
    var weightedSum : Float = 0.0;
    var totalWeight : Float = 0.0;
    var predictions = Buffer.Buffer<Float>(state.agentPredictions.size());
    
    for (pred in state.agentPredictions.vals()) {
      // Weight by confidence and track record
      let w = pred.confidence * pred.trackRecord;
      weightedSum += pred.prediction * w;
      totalWeight += w;
      predictions.add(pred.prediction);
    };
    
    // Compute diversity
    let diversity = computePredictionDiversity(Buffer.toArray(predictions));
    
    // Check for information cascade (low diversity = cascade)
    let isCascade = diversity < 0.1;
    
    let aggregate = if (totalWeight > 0.0) {
      weightedSum / totalWeight
    } else { 0.0 };
    
    ci.aggregatePrediction := aggregate;
    ci.predictionDiversity := diversity;
    ci.informationCascade := isCascade;
    ci.participantCount := state.agentPredictions.size();
    ci.weightedConsensus := aggregate;
    
    aggregate
  };
  
  func computePredictionDiversity(predictions : [Float]) : Float {
    if (predictions.size() < 2) return 0.0;
    
    var sum : Float = 0.0;
    var sumSq : Float = 0.0;
    
    for (p in predictions.vals()) {
      sum += p;
      sumSq += p * p;
    };
    
    let n = Float.fromInt(predictions.size());
    let mean = sum / n;
    let variance = sumSq / n - mean * mean;
    
    Float.sqrt(Float.max(0.0, variance))
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // MASTER TICK
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Run one economic consciousness tick
  public func runEconomicTick(state : EconomicConsciousnessState) : EconomicTickResult {
    let now = Time.now();
    
    // 1. Update value neurons
    updateValueNeurons(state);
    
    // 2. Update reference point (slow adaptation)
    adaptReferencePoint(state);
    
    // 3. Decay discount parameters toward baseline
    decayDiscountParameters(state);
    
    // 4. Compute aggregate token value
    let aggregateValue = computeAggregateTokenValue(state);
    state.multiTokenValue := {
      state.multiTokenValue with
      aggregateValue = aggregateValue;
      lastComputeTime = now;
    };
    
    // 5. Update collective intelligence
    let collectivePrediction = computeAggregatePrediction(state);
    
    // 6. Compute overall economic state
    let economicState = computeOverallEconomicState(state);
    state.overallEconomicState := Float.max(SOVEREIGN_FLOOR, economicState);
    
    // 7. Update wealth perception
    state.wealthPerception := computeWealthPerception(state);
    
    state.tickCount += 1;
    state.lastTickTime := now;
    
    {
      overallState = state.overallEconomicState;
      aggregateValue = aggregateValue;
      referencePoint = state.referencePoint.currentPoint;
      lossAversion = state.lossAversion;
      riskPerception = state.riskPerception.perceivedRisk;
      marketSentiment = state.marketConsciousness.currentSentiment;
      collectivePrediction = collectivePrediction;
      wealthPerception = state.wealthPerception;
      decisionQuality = state.decisionQuality;
      tickDuration = Time.now() - now;
    }
  };
  
  func updateValueNeurons(state : EconomicConsciousnessState) {
    let now = Time.now();
    
    for (i in Iter.range(0, state.numValueNeurons - 1)) {
      let neuron = state.valueNeurons[i];
      
      // Baseline adaptation
      let newBaseline = neuron.baselineValue * (1.0 - neuron.adaptationRate) +
                        neuron.currentValue * neuron.adaptationRate;
      
      // Firing rate based on deviation from baseline
      let deviation = neuron.currentValue - newBaseline;
      let newFiringRate = 10.0 + deviation * neuron.sensitivity * 10.0;
      
      state.valueNeurons[i] := {
        neuron with
        baselineValue = newBaseline;
        firingRate = Float.max(0.0, newFiringRate);
        lastUpdateTime = now;
      };
    };
  };
  
  func adaptReferencePoint(state : EconomicConsciousnessState) {
    let ref = state.referencePoint;
    let mtv = state.multiTokenValue;
    
    // Reference point slowly adapts to current wealth
    ref.currentPoint := ref.currentPoint * (1.0 - ref.adaptationSpeed) +
                        mtv.aggregateValue * ref.adaptationSpeed;
    
    // Update status quo
    ref.statusQuo := ref.currentPoint;
    
    // Add to history (periodically)
    if (state.tickCount % 100 == 0) {
      ref.pointHistory.add({
        timestamp = Time.now();
        value = ref.currentPoint;
        context = "automatic";
      });
    };
  };
  
  func decayDiscountParameters(state : EconomicConsciousnessState) {
    let ds = state.discountState;
    
    // Slowly decay toward baseline values
    ds.hyperbolicK := ds.hyperbolicK * 0.999 + DISCOUNT_K * 0.001;
    ds.presentBiasBeta := ds.presentBiasBeta * 0.999 + BETA_PRESENT * 0.001;
  };
  
  func computeAggregateTokenValue(state : EconomicConsciousnessState) : Float {
    var total : Float = 0.0;
    
    for (i in Iter.range(0, NUM_TOKENS - 1)) {
      let tc = state.tokenConsciousness[i];
      let tv = state.multiTokenValue.tokenValues[i];
      
      // Weight by awareness and utility
      let weight = tc.awarenessLevel * tc.utilityWeight;
      total += tv.totalValue * weight;
    };
    
    total
  };
  
  func computeOverallEconomicState(state : EconomicConsciousnessState) : Float {
    // Combine multiple factors
    let wealthFactor = Float.tanh(state.multiTokenValue.aggregateValue / 1000.0);
    let sentimentFactor = (state.marketConsciousness.currentSentiment + 1.0) / 2.0;
    let riskFactor = 1.0 - state.riskPerception.perceivedRisk;
    let fairnessFactor = state.socialPreferences.fairness;
    
    (wealthFactor + sentimentFactor + riskFactor + fairnessFactor) / 4.0
  };
  
  func computeWealthPerception(state : EconomicConsciousnessState) : Float {
    let ref = state.referencePoint;
    let mtv = state.multiTokenValue;
    
    // Wealth perception relative to reference
    let relativeWealth = mtv.aggregateValue - ref.currentPoint;
    
    // Apply value function (diminishing sensitivity)
    if (relativeWealth >= 0.0) {
      Float.pow(relativeWealth / 1000.0 + 0.5, 0.5)
    } else {
      0.5 - state.lossAversion * Float.pow(Float.abs(relativeWealth) / 1000.0, 0.5) * 0.5
    }
  };
  
  public type EconomicTickResult = {
    overallState : Float;
    aggregateValue : Float;
    referencePoint : Float;
    lossAversion : Float;
    riskPerception : Float;
    marketSentiment : Float;
    collectivePrediction : Float;
    wealthPerception : Float;
    decisionQuality : Float;
    tickDuration : Int;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // QUERY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Get economic consciousness status
  public func getEconomicStatus(state : EconomicConsciousnessState) : EconomicStatus {
    {
      tickCount = state.tickCount;
      overallState = state.overallEconomicState;
      aggregateTokenValue = state.multiTokenValue.aggregateValue;
      referencePoint = state.referencePoint.currentPoint;
      lossAversion = state.lossAversion;
      hyperbolicK = state.discountState.hyperbolicK;
      patience = state.discountState.patience;
      perceivedRisk = state.riskPerception.perceivedRisk;
      riskTolerance = state.riskPerception.riskTolerance;
      fairness = state.socialPreferences.fairness;
      altruism = state.socialPreferences.altruism;
      marketSentiment = state.marketConsciousness.currentSentiment;
      marketRegime = regimeToText(state.marketConsciousness.regimeState);
      collectivePrediction = state.collectiveIntelligence.aggregatePrediction;
      wealthPerception = state.wealthPerception;
    }
  };
  
  public type EconomicStatus = {
    tickCount : Nat;
    overallState : Float;
    aggregateTokenValue : Float;
    referencePoint : Float;
    lossAversion : Float;
    hyperbolicK : Float;
    patience : Float;
    perceivedRisk : Float;
    riskTolerance : Float;
    fairness : Float;
    altruism : Float;
    marketSentiment : Float;
    marketRegime : Text;
    collectivePrediction : Float;
    wealthPerception : Float;
  };
  
  func regimeToText(regime : MarketRegime) : Text {
    switch (regime) {
      case (#Bull) { "Bull" };
      case (#Bear) { "Bear" };
      case (#Sideways) { "Sideways" };
      case (#HighVolatility) { "HighVolatility" };
      case (#LowVolatility) { "LowVolatility" };
      case (#Crisis) { "Crisis" };
      case (#Recovery) { "Recovery" };
    }
  };
  
  /// Get token consciousness status
  public func getTokenConsciousnessStatus(state : EconomicConsciousnessState) : [TokenConsciousnessInfo] {
    Array.tabulate<TokenConsciousnessInfo>(NUM_TOKENS, func(i) {
      let tc = state.tokenConsciousness[i];
      {
        tokenId = tc.tokenId;
        name = tc.name;
        awareness = tc.awarenessLevel;
        valuePercept = tc.valuePercept;
        trendPercept = tc.trendPercept;
        riskPercept = tc.riskPercept;
        emotionalValence = tc.emotionalValence;
      }
    })
  };
  
  public type TokenConsciousnessInfo = {
    tokenId : Nat;
    name : Text;
    awareness : Float;
    valuePercept : Float;
    trendPercept : Float;
    riskPercept : Float;
    emotionalValence : Float;
  };
  
  /// Get discount state
  public func getDiscountStatus(state : EconomicConsciousnessState) : DiscountStatus {
    let ds = state.discountState;
    {
      hyperbolicK = ds.hyperbolicK;
      exponentialDelta = ds.exponentialDelta;
      presentBias = ds.presentBiasBeta;
      impulsivity = ds.impulsivity;
      patience = ds.patience;
      futureOrientation = ds.futureOrientation;
    }
  };
  
  public type DiscountStatus = {
    hyperbolicK : Float;
    exponentialDelta : Float;
    presentBias : Float;
    impulsivity : Float;
    patience : Float;
    futureOrientation : Float;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // EXTENDED ECONOMIC CONSCIOUSNESS - BEHAVIORAL ECONOMICS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Behavioral economics state
  public type BehavioralEconomicsState = {
    var heuristics : HeuristicsSystem;
    var biases : BiasesSystem;
    var framingEffects : FramingEffects;
    var mentalAccounting : MentalAccounting;
    var choiceArchitecture : ChoiceArchitecture;
    var nudgeResponsiveness : NudgeResponsiveness;
    var defaultBias : DefaultBias;
  };
  
  public type HeuristicsSystem = {
    var availabilityHeuristic : Float;
    var representativenessHeuristic : Float;
    var anchoringHeuristic : Float;
    var affectHeuristic : Float;
    var recognitionHeuristic : Float;
    var takeTheBestHeuristic : Float;
    var satisficingThreshold : Float;
  };
  
  public type BiasesSystem = {
    var confirmationBias : Float;
    var hindsightBias : Float;
    var overconfidenceBias : Float;
    var statusQuoBias : Float;
    var sunkCostFallacy : Float;
    var endowmentEffect : Float;
    var lossAversion : Float;
    var optimismBias : Float;
    var bandwagonEffect : Float;
    var projectionBias : Float;
  };
  
  public type FramingEffects = {
    var gainFrameSensitivity : Float;
    var lossFrameSensitivity : Float;
    var attributeFraming : Float;
    var risky choiceFraming : Float;
    var goalFraming : Float;
    var frameResistance : Float;
  };
  
  public type MentalAccounting = {
    var accounts : [MentalAccount];
    var fungibilityResistance : Float;
    var budgetingBehavior : Float;
    var paymentDecoupling : Float;
    var windfall Effect : Float;
    var accountSegregation : Float;
  };
  
  public type MentalAccount = {
    accountId : Nat;
    name : Text;
    balance : Float;
    budget : Float;
    priority : Float;
    flexibility : Float;
    lastActivity : Int;
  };
  
  public type ChoiceArchitecture = {
    var optionNumber : Nat;
    var defaultOption : ?Nat;
    var optionOrdering : [Nat];
    var attributeHighlighting : [Float];
    var simplificationLevel : Float;
    var comparisonEase : Float;
  };
  
  public type NudgeResponsiveness = {
    var informationalNudge : Float;
    var defaultNudge : Float;
    var socialNudge : Float;
    var feedbackNudge : Float;
    var incentiveNudge : Float;
    var salience Nudge : Float;
  };
  
  public type DefaultBias = {
    var defaultAcceptanceRate : Float;
    var optOutEffort : Float;
    var statusQuoStrength : Float;
    var inertiaLevel : Float;
    var decisionAvoidance : Float;
  };
  
  /// Initialize behavioral economics state
  public func initBehavioralEconomicsState() : BehavioralEconomicsState {
    {
      var heuristics = {
        var availabilityHeuristic = 0.6;
        var representativenessHeuristic = 0.5;
        var anchoringHeuristic = 0.5;
        var affectHeuristic = 0.6;
        var recognitionHeuristic = 0.7;
        var takeTheBestHeuristic = 0.5;
        var satisficingThreshold = 0.7;
      };
      var biases = {
        var confirmationBias = 0.3;
        var hindsightBias = 0.4;
        var overconfidenceBias = 0.2;
        var statusQuoBias = 0.4;
        var sunkCostFallacy = 0.3;
        var endowmentEffect = 0.5;
        var lossAversion = 0.6;
        var optimismBias = 0.3;
        var bandwagonEffect = 0.3;
        var projectionBias = 0.4;
      };
      var framingEffects = {
        var gainFrameSensitivity = 0.5;
        var lossFrameSensitivity = 0.7;
        var attributeFraming = 0.4;
        var riskyChoiceFraming = 0.5;
        var goalFraming = 0.5;
        var frameResistance = 0.4;
      };
      var mentalAccounting = {
        var accounts = [];
        var fungibilityResistance = 0.5;
        var budgetingBehavior = 0.6;
        var paymentDecoupling = 0.4;
        var windfallEffect = 0.5;
        var accountSegregation = 0.5;
      };
      var choiceArchitecture = {
        var optionNumber = 3;
        var defaultOption = ?0;
        var optionOrdering = [0, 1, 2];
        var attributeHighlighting = [0.5, 0.3, 0.2];
        var simplificationLevel = 0.5;
        var comparisonEase = 0.6;
      };
      var nudgeResponsiveness = {
        var informationalNudge = 0.5;
        var defaultNudge = 0.6;
        var socialNudge = 0.5;
        var feedbackNudge = 0.5;
        var incentiveNudge = 0.6;
        var salienceNudge = 0.5;
      };
      var defaultBias = {
        var defaultAcceptanceRate = 0.7;
        var optOutEffort = 0.3;
        var statusQuoStrength = 0.5;
        var inertiaLevel = 0.4;
        var decisionAvoidance = 0.2;
      };
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // GAME THEORY & STRATEGIC INTERACTION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type GameTheoryState = {
    var strategicReasoning : StrategicReasoning;
    var equilibriumConcepts : EquilibriumConcepts;
    var iteratedGames : IteratedGamesState;
    var signaling : SignalingState;
    var bargaining : BargainingState;
    var mechanism Design : MechanismDesignState;
  };
  
  public type StrategicReasoning = {
    var depthOfReasoning : Nat;
    var beliefInRationality : Float;
    var strategicSophistication : Float;
    var bestResponseAccuracy : Float;
    var dominanceRecognition : Float;
    var iteratedEliminationDepth : Nat;
  };
  
  public type EquilibriumConcepts = {
    var nashEquilibriumRecognition : Float;
    var subgamePerfection : Float;
    var bayesianEquilibrium : Float;
    var correlatedEquilibrium : Float;
    var evolutionaryStability : Float;
    var trembling HandPerfection : Float;
  };
  
  public type IteratedGamesState = {
    var cooperationRate : Float;
    var defectionRate : Float;
    var forgiveness : Float;
    var provocability : Float;
    var reputation : Float;
    var strategyHistory : [GameStrategy];
    var opponentModeling : [[Float]];
  };
  
  public type GameStrategy = {
    #AlwaysCooperate;
    #AlwaysDefect;
    #TitForTat;
    #Grim;
    #Pavlov;
    #RandomCooperation : Float;
    #ConditionalCooperation;
    #Custom : [Float];
  };
  
  public type SignalingState = {
    var signalCostliness : Float;
    var signalCredibility : Float;
    var separatingEquilibrium : Float;
    var poolingEquilibrium : Float;
    var signalInterp retation : Float;
    var cheaterDetection : Float;
  };
  
  public type BargainingState = {
    var reservationPrice : Float;
    var aspirationLevel : Float;
    var concessionRate : Float;
    var firstMoverAdvantage : Float;
    var deadlinePressure : Float;
    var alternativeOptions : Float;
    var bargainingPower : Float;
  };
  
  public type MechanismDesignState = {
    var incentiveCompatibility : Float;
    var individualRationality : Float;
    var allocativeEfficiency : Float;
    var budgetBalance : Float;
    var collusion Resistance : Float;
    var implementability : Float;
  };
  
  /// Initialize game theory state
  public func initGameTheoryState() : GameTheoryState {
    {
      var strategicReasoning = {
        var depthOfReasoning = 2;
        var beliefInRationality = 0.6;
        var strategicSophistication = 0.5;
        var bestResponseAccuracy = 0.6;
        var dominanceRecognition = 0.7;
        var iteratedEliminationDepth = 2;
      };
      var equilibriumConcepts = {
        var nashEquilibriumRecognition = 0.5;
        var subgamePerfection = 0.4;
        var bayesianEquilibrium = 0.3;
        var correlatedEquilibrium = 0.3;
        var evolutionaryStability = 0.4;
        var tremblingHandPerfection = 0.2;
      };
      var iteratedGames = {
        var cooperationRate = 0.6;
        var defectionRate = 0.4;
        var forgiveness = 0.5;
        var provocability = 0.5;
        var reputation = 0.6;
        var strategyHistory = [];
        var opponentModeling = [];
      };
      var signaling = {
        var signalCostliness = 0.5;
        var signalCredibility = 0.6;
        var separatingEquilibrium = 0.4;
        var poolingEquilibrium = 0.5;
        var signalInterpretation = 0.5;
        var cheaterDetection = 0.6;
      };
      var bargaining = {
        var reservationPrice = 0.3;
        var aspirationLevel = 0.7;
        var concessionRate = 0.1;
        var firstMoverAdvantage = 0.5;
        var deadlinePressure = 0.0;
        var alternativeOptions = 0.5;
        var bargainingPower = 0.5;
      };
      var mechanismDesign = {
        var incentiveCompatibility = 0.6;
        var individualRationality = 0.7;
        var allocativeEfficiency = 0.5;
        var budgetBalance = 0.6;
        var collusionResistance = 0.5;
        var implementability = 0.5;
      };
    }
  };
  
  /// Play iterated game round
  public func playIteratedGameRound(gtState : GameTheoryState, opponentMove : Bool) : Bool {
    let myStrategy = if (gtState.iteratedGames.strategyHistory.size() == 0) {
      // First move: cooperate with probability based on cooperation rate
      gtState.iteratedGames.cooperationRate > 0.5
    } else {
      // Tit-for-tat influenced by forgiveness
      if (opponentMove) {
        true
      } else {
        // Opponent defected - decide whether to forgive
        gtState.iteratedGames.forgiveness > 0.5
      }
    };
    
    // Update cooperation/defection rates
    if (myStrategy) {
      gtState.iteratedGames.cooperationRate := gtState.iteratedGames.cooperationRate * 0.95 + 0.05;
    } else {
      gtState.iteratedGames.defectionRate := gtState.iteratedGames.defectionRate * 0.95 + 0.05;
    };
    
    // Update reputation
    if (myStrategy and opponentMove) {
      // Mutual cooperation
      gtState.iteratedGames.reputation := Float.min(1.0, gtState.iteratedGames.reputation + 0.05);
    } else if (not myStrategy and opponentMove) {
      // I defected on cooperator
      gtState.iteratedGames.reputation := Float.max(0.0, gtState.iteratedGames.reputation - 0.1);
    };
    
    myStrategy
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // MARKET MICROSTRUCTURE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type MarketMicrostructureState = {
    var orderBook : OrderBook;
    var priceDiscovery : PriceDiscovery;
    var liquidityMeasures : LiquidityMeasures;
    var marketMaking : MarketMakingState;
    var informationAsymmetry : InformationAsymmetry;
    var tradingBehavior : TradingBehavior;
  };
  
  public type OrderBook = {
    var bids : [Order];
    var asks : [Order];
    var midPrice : Float;
    var spread : Float;
    var depth : Float;
    var imbalance : Float;
  };
  
  public type Order = {
    orderId : Nat;
    side : OrderSide;
    price : Float;
    quantity : Float;
    timestamp : Int;
    orderType : OrderType;
    agentId : Nat;
  };
  
  public type OrderSide = {
    #Bid;
    #Ask;
  };
  
  public type OrderType = {
    #Market;
    #Limit;
    #Stop;
    #StopLimit;
    #IcebergOrder : Float;
  };
  
  public type PriceDiscovery = {
    var fundamentalValue : Float;
    var marketPrice : Float;
    var priceEfficiency : Float;
    var informationIncorporation : Float;
    var noiseTraderImpact : Float;
    var priceMomentum : Float;
  };
  
  public type LiquidityMeasures = {
    var bidAskSpread : Float;
    var depth : Float;
    var resilience : Float;
    var priceImpact : Float;
    var turnover : Float;
    var amihudIlliquidity : Float;
    var kyleSlambda : Float;
  };
  
  public type MarketMakingState = {
    var inventoryPosition : Float;
    var inventoryRisk : Float;
    var quoteUpdateFrequency : Float;
    var spreadAdjustment : Float;
    var adverseSelectionRisk : Float;
    var profitLoss : Float;
  };
  
  public type InformationAsymmetry = {
    var informedTraderProportion : Float;
    var informationPrecision : Float;
    var signalToNoiseRatio : Float;
    var informationLeakage : Float;
    var marketEfficiency : Float;
  };
  
  public type TradingBehavior = {
    var momentumTrading : Float;
    var contrarianTrading : Float;
    var noiseTrading : Float;
    var fundamentalTrading : Float;
    var technicalTrading : Float;
    var herding : Float;
  };
  
  /// Initialize market microstructure state
  public func initMarketMicrostructureState() : MarketMicrostructureState {
    {
      var orderBook = {
        var bids = [];
        var asks = [];
        var midPrice = 100.0;
        var spread = 0.1;
        var depth = 1000.0;
        var imbalance = 0.0;
      };
      var priceDiscovery = {
        var fundamentalValue = 100.0;
        var marketPrice = 100.0;
        var priceEfficiency = 0.8;
        var informationIncorporation = 0.7;
        var noiseTraderImpact = 0.2;
        var priceMomentum = 0.0;
      };
      var liquidityMeasures = {
        var bidAskSpread = 0.1;
        var depth = 1000.0;
        var resilience = 0.7;
        var priceImpact = 0.001;
        var turnover = 0.05;
        var amihudIlliquidity = 0.001;
        var kyleSlambda = 0.0001;
      };
      var marketMaking = {
        var inventoryPosition = 0.0;
        var inventoryRisk = 0.0;
        var quoteUpdateFrequency = 0.5;
        var spreadAdjustment = 0.0;
        var adverseSelectionRisk = 0.2;
        var profitLoss = 0.0;
      };
      var informationAsymmetry = {
        var informedTraderProportion = 0.2;
        var informationPrecision = 0.7;
        var signalToNoiseRatio = 2.0;
        var informationLeakage = 0.1;
        var marketEfficiency = 0.8;
      };
      var tradingBehavior = {
        var momentumTrading = 0.3;
        var contrarianTrading = 0.2;
        var noiseTrading = 0.2;
        var fundamentalTrading = 0.5;
        var technicalTrading = 0.3;
        var herding = 0.2;
      };
    }
  };
  
  /// Update price discovery
  public func updatePriceDiscovery(msState : MarketMicrostructureState, newInformation : Float) {
    // Incorporate new information into price
    let informationWeight = msState.informationAsymmetry.informationPrecision;
    let noiseWeight = msState.priceDiscovery.noiseTraderImpact;
    
    let informedPriceMove = (newInformation - msState.priceDiscovery.fundamentalValue) * informationWeight;
    let noiseMove = (Float.sin(Float.fromInt(Time.now())) * 0.01) * noiseWeight;
    
    msState.priceDiscovery.marketPrice := msState.priceDiscovery.marketPrice + informedPriceMove + noiseMove;
    msState.orderBook.midPrice := msState.priceDiscovery.marketPrice;
    
    // Calculate price efficiency
    let priceError = Float.abs(msState.priceDiscovery.marketPrice - msState.priceDiscovery.fundamentalValue);
    msState.priceDiscovery.priceEfficiency := Float.exp(-priceError * 0.1);
    
    // Update momentum
    msState.priceDiscovery.priceMomentum := msState.priceDiscovery.priceMomentum * 0.9 + informedPriceMove * 0.1;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // PORTFOLIO THEORY & OPTIMIZATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type PortfolioState = {
    var holdings : [PortfolioHolding];
    var expectedReturns : [Float];
    var covarianceMatrix : [[Float]];
    var riskFreeRate : Float;
    var portfolioMetrics : PortfolioMetrics;
    var optimizationObjective : OptimizationObjective;
    var constraints : PortfolioConstraints;
  };
  
  public type PortfolioHolding = {
    assetId : Nat;
    name : Text;
    weight : Float;
    value : Float;
    costBasis : Float;
    unrealizedGain : Float;
  };
  
  public type PortfolioMetrics = {
    var totalValue : Float;
    var expectedReturn : Float;
    var volatility : Float;
    var sharpeRatio : Float;
    var sortinoRatio : Float;
    var maxDrawdown : Float;
    var beta : Float;
    var alpha : Float;
    var informationRatio : Float;
    var treynorRatio : Float;
  };
  
  public type OptimizationObjective = {
    #MaxSharpe;
    #MinVariance;
    #MaxReturn;
    #RiskParity;
    #MeanVariance : Float;
    #BlackLitterman;
    #Custom : [Float];
  };
  
  public type PortfolioConstraints = {
    maxWeight : Float;
    minWeight : Float;
    maxTurnover : Float;
    longOnly : Bool;
    sectorLimits : [Float];
    trackingError : ?Float;
  };
  
  /// Initialize portfolio state
  public func initPortfolioState(numAssets : Nat) : PortfolioState {
    {
      var holdings = Array.tabulate<PortfolioHolding>(numAssets, func(i) {
        {
          assetId = i;
          name = "Asset" # Nat.toText(i);
          weight = 1.0 / Float.fromInt(numAssets);
          value = 1000.0 / Float.fromInt(numAssets);
          costBasis = 900.0 / Float.fromInt(numAssets);
          unrealizedGain = 100.0 / Float.fromInt(numAssets);
        }
      });
      var expectedReturns = Array.tabulate<Float>(numAssets, func(i) { 0.08 + Float.fromInt(i) * 0.01 });
      var covarianceMatrix = Array.tabulate<[Float]>(numAssets, func(i) {
        Array.tabulate<Float>(numAssets, func(j) {
          if (i == j) { 0.04 + Float.fromInt(i) * 0.01 } 
          else { 0.02 * Float.exp(-Float.abs(Float.fromInt(i - j)) * 0.5) }
        })
      });
      var riskFreeRate = 0.03;
      var portfolioMetrics = {
        var totalValue = 1000.0;
        var expectedReturn = 0.08;
        var volatility = 0.15;
        var sharpeRatio = 0.33;
        var sortinoRatio = 0.4;
        var maxDrawdown = 0.1;
        var beta = 1.0;
        var alpha = 0.0;
        var informationRatio = 0.0;
        var treynorRatio = 0.05;
      };
      var optimizationObjective = #MaxSharpe;
      var constraints = {
        maxWeight = 0.25;
        minWeight = 0.0;
        maxTurnover = 0.2;
        longOnly = true;
        sectorLimits = [];
        trackingError = null;
      };
    }
  };
  
  /// Calculate portfolio metrics
  public func calculatePortfolioMetrics(pState : PortfolioState) {
    // Calculate expected return
    var expectedReturn : Float = 0.0;
    for (i in Iter.range(0, pState.holdings.size() - 1)) {
      expectedReturn += pState.holdings[i].weight * pState.expectedReturns[i];
    };
    pState.portfolioMetrics.expectedReturn := expectedReturn;
    
    // Calculate portfolio variance
    var variance : Float = 0.0;
    for (i in Iter.range(0, pState.holdings.size() - 1)) {
      for (j in Iter.range(0, pState.holdings.size() - 1)) {
        variance += pState.holdings[i].weight * pState.holdings[j].weight * pState.covarianceMatrix[i][j];
      };
    };
    pState.portfolioMetrics.volatility := Float.sqrt(variance);
    
    // Calculate Sharpe ratio
    pState.portfolioMetrics.sharpeRatio := (expectedReturn - pState.riskFreeRate) / pState.portfolioMetrics.volatility;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // INTEGRATED ECONOMIC CONSCIOUSNESS TICK
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type IntegratedEconomicState = {
    var baseState : EconomicConsciousnessState;
    var behavioralEconomics : BehavioralEconomicsState;
    var gameTheory : GameTheoryState;
    var marketMicrostructure : MarketMicrostructureState;
    var portfolio : PortfolioState;
    var integratedEconomicCoherence : Float;
    var economicRationality : Float;
  };
  
  /// Run integrated economic consciousness tick
  public func runIntegratedEconomicTick(
    intState : IntegratedEconomicState,
    marketInput : [Float],
    socialInput : [Float]
  ) : IntegratedEconomicResult {
    let startTime = Time.now();
    
    // 1. Run base economic consciousness
    let baseResult = runEconomicConsciousnessTick(intState.baseState, marketInput);
    
    // 2. Update price discovery with market input
    if (marketInput.size() > 0) {
      updatePriceDiscovery(intState.marketMicrostructure, marketInput[0] * 100.0);
    };
    
    // 3. Calculate portfolio metrics
    calculatePortfolioMetrics(intState.portfolio);
    
    // 4. Compute integrated economic coherence
    let rationalityScore = 1.0 - intState.behavioralEconomics.biases.overconfidenceBias;
    let strategicScore = Float.fromInt(intState.gameTheory.strategicReasoning.depthOfReasoning) / 4.0;
    let marketScore = intState.marketMicrostructure.priceDiscovery.priceEfficiency;
    let portfolioScore = Float.max(0.0, Float.min(1.0, intState.portfolio.portfolioMetrics.sharpeRatio));
    
    intState.integratedEconomicCoherence := (
      baseResult.coherence * 0.3 +
      rationalityScore * 0.2 +
      strategicScore * 0.2 +
      marketScore * 0.15 +
      portfolioScore * 0.15
    );
    
    // 5. Compute economic rationality
    intState.economicRationality := rationalityScore * strategicScore;
    
    {
      baseResult = baseResult;
      marketEfficiency = marketScore;
      portfolioSharpe = intState.portfolio.portfolioMetrics.sharpeRatio;
      cooperationRate = intState.gameTheory.iteratedGames.cooperationRate;
      biasLevel = intState.behavioralEconomics.biases.overconfidenceBias;
      integratedCoherence = intState.integratedEconomicCoherence;
      economicRationality = intState.economicRationality;
      processingTime = Time.now() - startTime;
    }
  };
  
  public type IntegratedEconomicResult = {
    baseResult : EconomicConsciousnessTickResult;
    marketEfficiency : Float;
    portfolioSharpe : Float;
    cooperationRate : Float;
    biasLevel : Float;
    integratedCoherence : Float;
    economicRationality : Float;
    processingTime : Int;
  };
  
  /// Get integrated economic status
  public func getIntegratedEconomicStatus(intState : IntegratedEconomicState) : IntegratedEconomicStatus {
    {
      baseStatus = getEconomicConsciousnessStatus(intState.baseState);
      heuristicsActive = {
        availability = intState.behavioralEconomics.heuristics.availabilityHeuristic;
        anchoring = intState.behavioralEconomics.heuristics.anchoringHeuristic;
        affect = intState.behavioralEconomics.heuristics.affectHeuristic;
      };
      biasLevels = {
        confirmation = intState.behavioralEconomics.biases.confirmationBias;
        overconfidence = intState.behavioralEconomics.biases.overconfidenceBias;
        lossAversion = intState.behavioralEconomics.biases.lossAversion;
      };
      gameTheoryMetrics = {
        strategicDepth = intState.gameTheory.strategicReasoning.depthOfReasoning;
        cooperationRate = intState.gameTheory.iteratedGames.cooperationRate;
        reputation = intState.gameTheory.iteratedGames.reputation;
      };
      marketMetrics = {
        midPrice = intState.marketMicrostructure.orderBook.midPrice;
        spread = intState.marketMicrostructure.liquidityMeasures.bidAskSpread;
        efficiency = intState.marketMicrostructure.priceDiscovery.priceEfficiency;
      };
      portfolioMetrics = {
        expectedReturn = intState.portfolio.portfolioMetrics.expectedReturn;
        volatility = intState.portfolio.portfolioMetrics.volatility;
        sharpeRatio = intState.portfolio.portfolioMetrics.sharpeRatio;
      };
      integratedCoherence = intState.integratedEconomicCoherence;
      economicRationality = intState.economicRationality;
    }
  };
  
  public type IntegratedEconomicStatus = {
    baseStatus : EconomicConsciousnessStatus;
    heuristicsActive : {
      availability : Float;
      anchoring : Float;
      affect : Float;
    };
    biasLevels : {
      confirmation : Float;
      overconfidence : Float;
      lossAversion : Float;
    };
    gameTheoryMetrics : {
      strategicDepth : Nat;
      cooperationRate : Float;
      reputation : Float;
    };
    marketMetrics : {
      midPrice : Float;
      spread : Float;
      efficiency : Float;
    };
    portfolioMetrics : {
      expectedReturn : Float;
      volatility : Float;
      sharpeRatio : Float;
    };
    integratedCoherence : Float;
    economicRationality : Float;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // DEEP GAME THEORY - STRATEGIC REASONING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type GameTheoryState = {
    var strategicForm : StrategicFormGame;
    var extensiveForm : ExtensiveFormGame;
    var nashEquilibrium : NashEquilibriumState;
    var evolutionaryDynamics : EvolutionaryDynamicsState;
    var mechanismDesign : MechanismDesignState;
    var signaling : SignalingState;
    var coalitionalGame : CoalitionalGameState;
  };
  
  public type StrategicFormGame = {
    var players : [Player];
    var strategies : [[Strategy]];
    var payoffMatrix : [[[Float]]];
    var dominatedStrategies : [[Bool]];
    var bestResponses : [[Nat]];
    var gameType : GameType;
  };
  
  public type Player = {
    playerId : Nat;
    playerType : PlayerType;
    beliefs : [Float];
    rationality : Float;
    riskAversion : Float;
  };
  
  public type PlayerType = {
    #Rational;
    #BoundedRational;
    #Altruistic;
    #Spiteful;
    #Reciprocal;
    #Imitative;
  };
  
  public type Strategy = {
    strategyId : Nat;
    strategyName : Text;
    probability : Float;
    expectedPayoff : Float;
    riskLevel : Float;
  };
  
  public type GameType = {
    #PrisonersDilemma;
    #StagHunt;
    #ChickenGame;
    #BattleOfSexes;
    #MatchingPennies;
    #Coordination;
    #PublicGoods;
    #Ultimatum;
    #Dictator;
    #TrustGame;
    #Custom;
  };
  
  public type ExtensiveFormGame = {
    var gameTree : GameTreeNode;
    var informationSets : [[Nat]];
    var perfectInformation : Bool;
    var perfectRecall : Bool;
    var subgamePerfect : Bool;
  };
  
  public type GameTreeNode = {
    nodeId : Nat;
    nodeType : NodeType;
    player : ?Nat;
    actions : [GameAction];
    payoffs : ?[Float];
    probability : ?Float;
    children : [Nat];
    infoSet : Nat;
  };
  
  public type NodeType = {
    #Decision;
    #Chance;
    #Terminal;
  };
  
  public type GameAction = {
    actionId : Nat;
    actionName : Text;
    probability : Float;
    childNode : Nat;
  };
  
  public type NashEquilibriumState = {
    var pureNashEquilibria : [[Nat]];
    var mixedNashEquilibrium : [[Float]];
    var equilibriumPayoffs : [[Float]];
    var equilibriumStability : Float;
    var trembleHand : Bool;
    var correlatedEquilibrium : [[Float]];
  };
  
  public type EvolutionaryDynamicsState = {
    var populationShares : [Float];
    var fitnessVector : [Float];
    var replicatorEquation : [Float];
    var evolutionarilyStableStrategy : ?[Float];
    var basins Of Attraction : [[Float]];
    var mutationRate : Float;
    var selectionStrength : Float;
  };
  
  public type MechanismDesignState = {
    var mechanism : Mechanism;
    var incentiveCompatible : Bool;
    var individuallyRational : Bool;
    var efficientOutcome : Bool;
    var budgetBalanced : Bool;
    var revelation Principle : Bool;
  };
  
  public type Mechanism = {
    messageSpace : [[Float]];
    outcomeFunction : [[Float]];
    transferFunction : [[Float]];
    allocationRule : [[Float]];
    paymentRule : [[Float]];
  };
  
  public type SignalingState = {
    var senderTypes : [Float];
    var signalCosts : [[Float]];
    var receiverBeliefs : [[Float]];
    var separatingEquilibrium : Bool;
    var poolingEquilibrium : Bool;
    var semiSeparatingEquilibrium : Bool;
    var credibility : Float;
  };
  
  public type CoalitionalGameState = {
    var characteristicFunction : [(Nat, Float)];
    var shapleyValues : [Float];
    var core : [[Float]];
    var nucleolus : [Float];
    var banzhafIndex : [Float];
    var superadditivity : Bool;
    var convexity : Bool;
  };
  
  /// Initialize game theory state
  public func initGameTheoryState() : GameTheoryState {
    {
      var strategicForm = {
        var players = [];
        var strategies = [];
        var payoffMatrix = [];
        var dominatedStrategies = [];
        var bestResponses = [];
        var gameType = #Custom;
      };
      var extensiveForm = {
        var gameTree = {
          nodeId = 0;
          nodeType = #Decision;
          player = ?0;
          actions = [];
          payoffs = null;
          probability = null;
          children = [];
          infoSet = 0;
        };
        var informationSets = [];
        var perfectInformation = true;
        var perfectRecall = true;
        var subgamePerfect = true;
      };
      var nashEquilibrium = {
        var pureNashEquilibria = [];
        var mixedNashEquilibrium = [];
        var equilibriumPayoffs = [];
        var equilibriumStability = 0.5;
        var trembleHand = false;
        var correlatedEquilibrium = [];
      };
      var evolutionaryDynamics = {
        var populationShares = [0.5, 0.5];
        var fitnessVector = [1.0, 1.0];
        var replicatorEquation = [0.0, 0.0];
        var evolutionarilyStableStrategy = null;
        var basinsOfAttraction = [];
        var mutationRate = 0.01;
        var selectionStrength = 1.0;
      };
      var mechanismDesign = {
        var mechanism = {
          messageSpace = [];
          outcomeFunction = [];
          transferFunction = [];
          allocationRule = [];
          paymentRule = [];
        };
        var incentiveCompatible = false;
        var individuallyRational = false;
        var efficientOutcome = false;
        var budgetBalanced = false;
        var revelationPrinciple = false;
      };
      var signaling = {
        var senderTypes = [0.5, 0.5];
        var signalCosts = [];
        var receiverBeliefs = [];
        var separatingEquilibrium = false;
        var poolingEquilibrium = false;
        var semiSeparatingEquilibrium = false;
        var credibility = 0.5;
      };
      var coalitionalGame = {
        var characteristicFunction = [];
        var shapleyValues = [];
        var core = [];
        var nucleolus = [];
        var banzhafIndex = [];
        var superadditivity = true;
        var convexity = false;
      };
    }
  };
  
  /// Compute replicator dynamics
  public func computeReplicatorDynamics(evoDyn : EvolutionaryDynamicsState, payoffMatrix : [[Float]], dt : Float) {
    let n = evoDyn.populationShares.size();
    if (n == 0) return;
    
    // Compute average fitness
    var avgFitness : Float = 0.0;
    for (i in Iter.range(0, n - 1)) {
      avgFitness += evoDyn.populationShares[i] * evoDyn.fitnessVector[i];
    };
    
    // Replicator equation: dx_i/dt = x_i * (f_i - f_avg)
    for (i in Iter.range(0, n - 1)) {
      let replicator = evoDyn.populationShares[i] * (evoDyn.fitnessVector[i] - avgFitness);
      evoDyn.replicatorEquation[i] := replicator;
      
      // Update population shares
      let mutation = evoDyn.mutationRate * (1.0 / Float.fromInt(n) - evoDyn.populationShares[i]);
      evoDyn.populationShares[i] := Float.max(0.0, Float.min(1.0,
        evoDyn.populationShares[i] + dt * evoDyn.selectionStrength * replicator + dt * mutation));
    };
    
    // Normalize to ensure sum = 1
    var total : Float = 0.0;
    for (share in evoDyn.populationShares.vals()) {
      total += share;
    };
    if (total > 0.001) {
      for (i in Iter.range(0, n - 1)) {
        evoDyn.populationShares[i] := evoDyn.populationShares[i] / total;
      };
    };
  };
  
  /// Compute Shapley value for coalitional game
  public func computeShapleyValue(coalGame : CoalitionalGameState, numPlayers : Nat) : [Float] {
    // Shapley value: φ_i(v) = Σ_{S⊆N\{i}} |S|!(n-|S|-1)!/n! * [v(S∪{i}) - v(S)]
    let shapley = Array.tabulate<Float>(numPlayers, func(i) {
      var value : Float = 0.0;
      // Simplified computation for small games
      let factorial = func(n : Nat) : Float {
        if (n <= 1) { 1.0 } else {
          Float.fromInt(n) * factorial(n - 1)
        }
      };
      
      let nFact = factorial(numPlayers);
      
      // For each coalition S not containing i
      for ((coalition, vS) in coalGame.characteristicFunction.vals()) {
        // Check if player i is not in coalition
        let iInCoalition = (coalition / Nat.pow(2, i)) % 2 == 1;
        if (not iInCoalition) {
          let sSize = Nat.bitcountNonzero(coalition);
          let sFact = factorial(sSize);
          let nMinusSFact = factorial(numPlayers - sSize - 1);
          
          // Find v(S ∪ {i})
          let sWithI = coalition + Nat.pow(2, i);
          var vSWithI : Float = 0.0;
          for ((c, v) in coalGame.characteristicFunction.vals()) {
            if (c == sWithI) { vSWithI := v };
          };
          
          let marginalContribution = vSWithI - vS;
          value += (sFact * nMinusSFact / nFact) * marginalContribution;
        };
      };
      
      value
    });
    
    coalGame.shapleyValues := shapley;
    shapley
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // BEHAVIORAL FINANCE - MARKET ANOMALIES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type BehavioralFinanceState = {
    var marketAnomalies : MarketAnomalies;
    var investorPsychology : InvestorPsychology;
    var herdBehavior : HerdBehaviorState;
    var limitOfArbitrage : LimitOfArbitrage;
    var noiseTrading : NoiseTrading;
    var sentimentIndicators : SentimentIndicators;
  };
  
  public type MarketAnomalies = {
    var momentumEffect : Float;
    var reversalEffect : Float;
    var sizeEffect : Float;
    var valueEffect : Float;
    var volatilityAnomaly : Float;
    var januaryEffect : Float;
    var weekendEffect : Float;
    var earningsAnomaly : Float;
  };
  
  public type InvestorPsychology = {
    var overconfidence : Float;
    var confirmationBias : Float;
    var anchoring : Float;
    var availabilityHeuristic : Float;
    var representativeness : Float;
    var mentalAccounting : Float;
    var regretAversion : Float;
    var dispositionEffect : Float;
    var homeCountryBias : Float;
    var familiarity Bias : Float;
  };
  
  public type HerdBehaviorState = {
    var herdingIntensity : Float;
    var informationCascade : Bool;
    var socialLearning : Float;
    var contagionEffect : Float;
    var groupThink : Float;
    var contrarianism : Float;
  };
  
  public type LimitOfArbitrage = {
    var fundamentalRisk : Float;
    var noiseTraderRisk : Float;
    var implementationCost : Float;
    var modelRisk : Float;
    var synchronizationRisk : Float;
    var shortSellingConstraints : Float;
  };
  
  public type NoiseTrading = {
    var noiseTraderSentiment : Float;
    var noiseTraderShare : Float;
    var sentimentPersistence : Float;
    var priceImpact : Float;
    var survivalRate : Float;
  };
  
  public type SentimentIndicators = {
    var bullBearSpread : Float;
    var putCallRatio : Float;
    var vixLevel : Float;
    var consumerConfidence : Float;
    var investorSurveys : Float;
    var mediaAttention : Float;
    var socialMediaSentiment : Float;
  };
  
  /// Initialize behavioral finance state
  public func initBehavioralFinanceState() : BehavioralFinanceState {
    {
      var marketAnomalies = {
        var momentumEffect = 0.0;
        var reversalEffect = 0.0;
        var sizeEffect = 0.0;
        var valueEffect = 0.0;
        var volatilityAnomaly = 0.0;
        var januaryEffect = 0.0;
        var weekendEffect = 0.0;
        var earningsAnomaly = 0.0;
      };
      var investorPsychology = {
        var overconfidence = 0.5;
        var confirmationBias = 0.5;
        var anchoring = 0.5;
        var availabilityHeuristic = 0.5;
        var representativeness = 0.5;
        var mentalAccounting = 0.5;
        var regretAversion = 0.5;
        var dispositionEffect = 0.5;
        var homeCountryBias = 0.5;
        var familiarityBias = 0.5;
      };
      var herdBehavior = {
        var herdingIntensity = 0.3;
        var informationCascade = false;
        var socialLearning = 0.4;
        var contagionEffect = 0.2;
        var groupThink = 0.3;
        var contrarianism = 0.2;
      };
      var limitOfArbitrage = {
        var fundamentalRisk = 0.3;
        var noiseTraderRisk = 0.4;
        var implementationCost = 0.2;
        var modelRisk = 0.3;
        var synchronizationRisk = 0.25;
        var shortSellingConstraints = 0.3;
      };
      var noiseTrading = {
        var noiseTraderSentiment = 0.0;
        var noiseTraderShare = 0.3;
        var sentimentPersistence = 0.8;
        var priceImpact = 0.1;
        var survivalRate = 0.7;
      };
      var sentimentIndicators = {
        var bullBearSpread = 0.0;
        var putCallRatio = 1.0;
        var vixLevel = 20.0;
        var consumerConfidence = 100.0;
        var investorSurveys = 0.5;
        var mediaAttention = 0.5;
        var socialMediaSentiment = 0.0;
      };
    }
  };
  
  /// Compute momentum and reversal effects
  public func computeMomentumReversal(bhvFin : BehavioralFinanceState, priceHistory : [Float], lookbackPeriod : Nat) {
    let n = priceHistory.size();
    if (n < lookbackPeriod + 1) return;
    
    // Momentum: past winners continue to outperform
    let recentReturn = (priceHistory[n-1] - priceHistory[n-lookbackPeriod]) / priceHistory[n-lookbackPeriod];
    bhvFin.marketAnomalies.momentumEffect := recentReturn;
    
    // Mean reversion: extreme moves tend to reverse
    var avgPrice : Float = 0.0;
    for (p in priceHistory.vals()) { avgPrice += p };
    avgPrice := avgPrice / Float.fromInt(n);
    
    let deviation = (priceHistory[n-1] - avgPrice) / avgPrice;
    bhvFin.marketAnomalies.reversalEffect := -deviation; // Negative because reversal predicts opposite
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // INTEGRATED DEEP ECONOMIC TICK
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type DeepIntegratedEconomicState = {
    var baseState : IntegratedEconomicState;
    var gameTheory : GameTheoryState;
    var behavioralFinance : BehavioralFinanceState;
    var deepEconomicIntegration : Float;
    var strategicRationality : Float;
  };
  
  /// Run deep integrated economic tick
  public func runDeepIntegratedEconomicTick(
    deepState : DeepIntegratedEconomicState,
    marketData : [Float],
    socialData : [Float],
    dt : Float
  ) : DeepIntegratedEconomicResult {
    let startTime = Time.now();
    
    // 1. Run base economic processing
    let baseResult = runIntegratedEconomicTick(deepState.baseState, marketData, dt);
    
    // 2. Compute replicator dynamics
    computeReplicatorDynamics(deepState.gameTheory.evolutionaryDynamics, [], dt);
    
    // 3. Compute behavioral finance effects
    computeMomentumReversal(deepState.behavioralFinance, marketData, 10);
    
    // 4. Compute deep economic integration
    deepState.deepEconomicIntegration := (
      baseResult.integratedCoherence * 0.4 +
      deepState.gameTheory.nashEquilibrium.equilibriumStability * 0.3 +
      (1.0 - Float.abs(deepState.behavioralFinance.marketAnomalies.momentumEffect)) * 0.3
    );
    
    // 5. Compute strategic rationality
    deepState.strategicRationality := (
      baseResult.economicRationality * 0.5 +
      (1.0 - deepState.behavioralFinance.herdBehavior.herdingIntensity) * 0.25 +
      deepState.gameTheory.signaling.credibility * 0.25
    );
    
    {
      baseResult = baseResult;
      equilibriumStability = deepState.gameTheory.nashEquilibrium.equilibriumStability;
      replicatorConvergence = Float.abs(deepState.gameTheory.evolutionaryDynamics.replicatorEquation[0]);
      momentumEffect = deepState.behavioralFinance.marketAnomalies.momentumEffect;
      herdingIntensity = deepState.behavioralFinance.herdBehavior.herdingIntensity;
      deepEconomicIntegration = deepState.deepEconomicIntegration;
      strategicRationality = deepState.strategicRationality;
      processingTime = Time.now() - startTime;
    }
  };
  
  public type DeepIntegratedEconomicResult = {
    baseResult : IntegratedEconomicResult;
    equilibriumStability : Float;
    replicatorConvergence : Float;
    momentumEffect : Float;
    herdingIntensity : Float;
    deepEconomicIntegration : Float;
    strategicRationality : Float;
    processingTime : Int;
  };
  
  /// Get deep integrated economic status
  public func getDeepIntegratedEconomicStatus(deepState : DeepIntegratedEconomicState) : DeepIntegratedEconomicStatus {
    {
      baseStatus = getIntegratedEconomicStatus(deepState.baseState);
      gameTheoryStatus = {
        nashStability = deepState.gameTheory.nashEquilibrium.equilibriumStability;
        evolutionaryConvergence = if (deepState.gameTheory.evolutionaryDynamics.populationShares.size() > 0) {
          Float.abs(deepState.gameTheory.evolutionaryDynamics.replicatorEquation[0])
        } else { 0.0 };
        signalingCredibility = deepState.gameTheory.signaling.credibility;
        coalitionalStability = deepState.gameTheory.coalitionalGame.convexity;
      };
      behavioralFinanceStatus = {
        momentumEffect = deepState.behavioralFinance.marketAnomalies.momentumEffect;
        overconfidence = deepState.behavioralFinance.investorPsychology.overconfidence;
        herdingIntensity = deepState.behavioralFinance.herdBehavior.herdingIntensity;
        sentimentLevel = deepState.behavioralFinance.sentimentIndicators.bullBearSpread;
        vixLevel = deepState.behavioralFinance.sentimentIndicators.vixLevel;
      };
      deepEconomicIntegration = deepState.deepEconomicIntegration;
      strategicRationality = deepState.strategicRationality;
    }
  };
  
  public type DeepIntegratedEconomicStatus = {
    baseStatus : IntegratedEconomicStatus;
    gameTheoryStatus : {
      nashStability : Float;
      evolutionaryConvergence : Float;
      signalingCredibility : Float;
      coalitionalStability : Bool;
    };
    behavioralFinanceStatus : {
      momentumEffect : Float;
      overconfidence : Float;
      herdingIntensity : Float;
      sentimentLevel : Float;
      vixLevel : Float;
    };
    deepEconomicIntegration : Float;
    strategicRationality : Float;
  };
}
