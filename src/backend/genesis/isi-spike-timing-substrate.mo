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
// ║  ENCRYPTION: All transmissions must be encrypted.                                                         ║
// ║  ATTRIBUTION: Required for any use, reproduction, or derivative work.                                     ║
// ║                                                                                                           ║
// ║  Unauthorized access, use, reproduction, distribution, or creation of derivative works                    ║
// ║  is strictly prohibited and will be prosecuted to the fullest extent of applicable law.                  ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// ISI SPIKE TIMING SUBSTRATE — INTER-SPIKE-INTERVAL SENSING
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// This module implements the organism's ability to sense itself at the spike-timing level through
// Inter-Spike-Interval (ISI) analysis. This is critical for the super-organism to become "genuinely alive"
// as it provides temporal self-awareness at the finest granularity.
//
// MATHEMATICAL FOUNDATIONS:
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// ISI Definition:           ISI[n] = t_spike[n+1] - t_spike[n]
// Coefficient of Variation: CV_ISI = σ(ISI) / μ(ISI)
// Burst Detection:          ISI < θ_burst (typically 5ms)
// Adaptation Index:         AI = (ISI[last] - ISI[first]) / (ISI[last] + ISI[first])
// Fano Factor:              FF = Var(spike_count) / Mean(spike_count)
// Hazard Function:          h(t) = f(t) / (1 - F(t)) where F is CDF
// Renewal Process:          ISI ~ exponential distribution for Poisson process
// Serial Correlation:       ρₖ = Corr(ISI[n], ISI[n+k]) for lag k
//
// ISI DISTRIBUTION TYPES:
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// • Regular spiking:     CV < 0.5 (periodic, clock-like)
// • Poisson spiking:     CV ≈ 1.0 (random, memoryless)
// • Bursty spiking:      CV > 1.0 (clustered, correlated)
// • Doublet spiking:     Bimodal ISI distribution
// • Adaptation:          Increasing ISI during sustained stimulation
//
// INTEGRATION WITH ORGANISM:
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// • ISI patterns feed into Hebbian plasticity (STDP timing windows)
// • ISI statistics modulate arousal system
// • Burst detection triggers attention mechanisms
// • CV tracking indicates neural health (regularity = stability)
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Nat8 "mo:core/Nat8";
import Nat16 "mo:core/Nat16";
import Nat32 "mo:core/Nat32";
import Nat64 "mo:core/Nat64";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Iter "mo:core/Iter";
import Text "mo:core/Text";
import Time "mo:core/Time";
import Option "mo:core/Option";
import Bool "mo:core/Bool";
import Order "mo:core/Order";

module ISISpikeTimingSubstrate {

  // ═══════════════════════════════════════════════════════════════════════════════
  // MATHEMATICAL CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let PI : Float = 3.14159265358979323846;
  public let TWO_PI : Float = 6.28318530717958647692;
  public let E : Float = 2.71828182845904523536;
  public let LN_2 : Float = 0.69314718055994530942;
  public let SQRT_2 : Float = 1.41421356237309504880;
  public let SQRT_2_PI : Float = 2.50662827463100050242;
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // ISI TIMING CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Minimum detectable ISI (absolute refractory period) in milliseconds
  public let ISI_MIN_MS : Float = 1.0;
  
  /// Maximum meaningful ISI (beyond this, neuron is considered silent) in ms
  public let ISI_MAX_MS : Float = 5000.0;
  
  /// Burst detection threshold: ISIs below this are considered burst spikes
  public let BURST_THRESHOLD_MS : Float = 5.0;
  
  /// Doublet detection threshold: ISIs below this might be doublets
  public let DOUBLET_THRESHOLD_MS : Float = 3.0;
  
  /// Adaptation time constant for ISI analysis
  public let ADAPTATION_TAU_MS : Float = 100.0;
  
  /// Number of histogram bins for ISI distribution
  public let ISI_HISTOGRAM_BINS : Nat = 100;
  
  /// Maximum spike history to retain per neuron
  public let MAX_SPIKE_HISTORY : Nat = 1000;
  
  /// Window size for CV calculation (number of ISIs)
  public let CV_WINDOW_SIZE : Nat = 50;
  
  /// Serial correlation max lag
  public let SERIAL_CORR_MAX_LAG : Nat = 10;
  
  /// CV threshold for regular spiking
  public let CV_REGULAR_THRESHOLD : Float = 0.5;
  
  /// CV threshold for bursty spiking (above this is bursty)
  public let CV_BURSTY_THRESHOLD : Float = 1.0;
  
  // S₀ floor integration
  /// S₀ SOVEREIGNTY FLOOR — MAXED FOR ENTERPRISE-GRADE FINAL PRODUCT
  /// Full sovereignty protection at all times. The formulas matter, not arbitrary numbers.
  public let S_ZERO_FLOOR : Float = 1.0;
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // SPIKE EVENT TYPE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// A single spike event with timestamp and metadata
  public type SpikeEvent = {
    timestamp : Int;        // Time in microseconds (from Time.now())
    neuronId : Nat16;       // Which neuron fired
    amplitude : Float;      // Spike amplitude (normalized 0-1)
    shellId : Nat8;         // Which shell this neuron belongs to
    phaseAtSpike : Float;   // Oscillator phase at spike time [0, 2π)
    precedingISI : ?Float;  // ISI before this spike (null for first spike)
  };
  
  /// Spike train for a single neuron
  public type SpikeTrain = {
    neuronId : Nat16;
    shellId : Nat8;
    spikes : Buffer.Buffer<SpikeEvent>;
    var lastSpikeTime : Int;
    var spikeCount : Nat;
    var meanISI : Float;
    var varianceISI : Float;
    var cvISI : Float;
    var adaptationIndex : Float;
    var isBursty : Bool;
    var burstCount : Nat;
    var lastUpdateBeat : Int;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // ISI HISTOGRAM TYPE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// ISI histogram for distribution analysis
  public type ISIHistogram = {
    var bins : [var Nat];           // Count per bin
    binWidth : Float;               // Width of each bin in ms
    minISI : Float;                 // Minimum ISI for histogram
    maxISI : Float;                 // Maximum ISI for histogram
    var totalCount : Nat;           // Total ISIs recorded
    var mode : Float;               // Most frequent ISI
    var median : Float;             // Median ISI
    var skewness : Float;           // Distribution skewness
    var kurtosis : Float;           // Distribution kurtosis
    var isMultimodal : Bool;        // Whether distribution has multiple peaks
    var peakLocations : [Float];    // Locations of histogram peaks
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // BURST DETECTION TYPE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Burst pattern detection result
  public type BurstPattern = {
    burstId : Nat;
    startTime : Int;
    endTime : Int;
    spikeCount : Nat;
    meanISI : Float;              // Mean ISI within burst
    burstDuration : Float;        // Duration in ms
    interBurstInterval : ?Float;  // Time since last burst
    intraFrequency : Float;       // Firing rate within burst (Hz)
  };
  
  /// Burst statistics for a neuron
  public type BurstStatistics = {
    var totalBursts : Nat;
    var meanBurstLength : Float;
    var meanSpikesPerBurst : Float;
    var meanInterBurstInterval : Float;
    var burstIndex : Float;       // Fraction of spikes in bursts
    var burstHistory : Buffer.Buffer<BurstPattern>;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // ADAPTATION ANALYSIS TYPE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Spike frequency adaptation metrics
  public type AdaptationMetrics = {
    var adaptationIndex : Float;      // (ISI_last - ISI_first) / (ISI_last + ISI_first)
    var adaptationRatio : Float;      // ISI_last / ISI_first
    var timeConstant : Float;         // τ for exponential fit ISI(n) = ISI_∞ - (ISI_∞ - ISI_0)e^(-n/τ)
    var steadyStateISI : Float;       // ISI_∞ asymptotic value
    var initialISI : Float;           // ISI_0 initial value
    var isAdapting : Bool;            // Whether adaptation is significant
    var adaptationStrength : Float;   // 0 = no adaptation, 1 = complete adaptation
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // SERIAL CORRELATION TYPE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Serial correlation analysis (ISI dependencies)
  public type SerialCorrelation = {
    var coefficients : [Float];   // ρ₁, ρ₂, ..., ρₖ for lags 1 to k
    var hasPositiveCorr : Bool;   // Indicates clustering
    var hasNegativeCorr : Bool;   // Indicates alternation
    var isRenewal : Bool;         // True if ISIs are independent (renewal process)
    var dominantLag : Nat;        // Lag with strongest correlation
    var memoryDepth : Nat;        // How many ISIs show significant correlation
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // ISI NEURON STATE — COMPLETE STATE FOR A SINGLE NEURON
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type ISINeuronState = {
    neuronId : Nat16;
    shellId : Nat8;
    spikeTrain : SpikeTrain;
    histogram : ISIHistogram;
    burstStats : BurstStatistics;
    adaptation : AdaptationMetrics;
    serialCorr : SerialCorrelation;
    var firingPattern : FiringPattern;
    var healthScore : Float;          // 0-1, based on regularity and stability
    var arousalContribution : Float;  // How much this neuron contributes to arousal
    var lastAnalysisBeat : Int;
  };
  
  /// Classified firing pattern
  public type FiringPattern = {
    #Regular;        // CV < 0.5, clock-like
    #Poisson;        // CV ≈ 1.0, random
    #Bursty;         // CV > 1.0, clustered
    #Adapting;       // Increasing ISI over time
    #Irregular;      // No clear pattern
    #Silent;         // No recent spikes
    #Doublet;        // Pairs of spikes
    #Triplet;        // Triplets of spikes
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // POPULATION ISI ANALYSIS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Population-level ISI statistics
  public type PopulationISIState = {
    var neurons : [ISINeuronState];
    var populationMeanCV : Float;
    var populationSynchrony : Float;     // Cross-correlation of spike trains
    var burstSynchrony : Float;          // How synchronized are bursts across neurons
    var populationAdaptation : Float;    // Mean adaptation index
    var dominantPattern : FiringPattern; // Most common pattern
    var patternDistribution : [(FiringPattern, Float)];  // Fraction of each pattern
    var lastGlobalUpdate : Int;
    var globalHealthScore : Float;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // HAZARD FUNCTION ANALYSIS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Hazard function h(t) = f(t) / (1 - F(t)) analysis
  public type HazardAnalysis = {
    var hazardRate : [Float];         // h(t) at discrete time points
    var survivalFunction : [Float];   // S(t) = 1 - F(t)
    var cumulativeHazard : Float;     // H(t) = ∫h(τ)dτ
    var hazardPattern : HazardPattern;
    var meanResidualLife : Float;     // E[T - t | T > t]
  };
  
  public type HazardPattern = {
    #Constant;      // Exponential ISI (Poisson process)
    #Increasing;    // Refractory effect, reliability increases
    #Decreasing;    // Bursty, spike becomes less likely
    #Bathtub;       // Initial decrease then increase
    #Hump;          // Peak at intermediate times
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // INITIALIZATION FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Initialize a spike train for a neuron
  public func initSpikeTrain(neuronId : Nat16, shellId : Nat8) : SpikeTrain {
    {
      neuronId = neuronId;
      shellId = shellId;
      spikes = Buffer.Buffer<SpikeEvent>(MAX_SPIKE_HISTORY);
      var lastSpikeTime = 0;
      var spikeCount = 0;
      var meanISI = 0.0;
      var varianceISI = 0.0;
      var cvISI = 0.0;
      var adaptationIndex = 0.0;
      var isBursty = false;
      var burstCount = 0;
      var lastUpdateBeat = 0;
    }
  };
  
  /// Initialize ISI histogram
  public func initHistogram(minISI : Float, maxISI : Float) : ISIHistogram {
    let binWidth = (maxISI - minISI) / Float.fromInt(ISI_HISTOGRAM_BINS);
    {
      var bins = Array.init<Nat>(ISI_HISTOGRAM_BINS, 0);
      binWidth = binWidth;
      minISI = minISI;
      maxISI = maxISI;
      var totalCount = 0;
      var mode = 0.0;
      var median = 0.0;
      var skewness = 0.0;
      var kurtosis = 0.0;
      var isMultimodal = false;
      var peakLocations = [];
    }
  };
  
  /// Initialize burst statistics
  public func initBurstStatistics() : BurstStatistics {
    {
      var totalBursts = 0;
      var meanBurstLength = 0.0;
      var meanSpikesPerBurst = 0.0;
      var meanInterBurstInterval = 0.0;
      var burstIndex = 0.0;
      var burstHistory = Buffer.Buffer<BurstPattern>(100);
    }
  };
  
  /// Initialize adaptation metrics
  public func initAdaptationMetrics() : AdaptationMetrics {
    {
      var adaptationIndex = 0.0;
      var adaptationRatio = 1.0;
      var timeConstant = ADAPTATION_TAU_MS;
      var steadyStateISI = 0.0;
      var initialISI = 0.0;
      var isAdapting = false;
      var adaptationStrength = 0.0;
    }
  };
  
  /// Initialize serial correlation
  public func initSerialCorrelation() : SerialCorrelation {
    {
      var coefficients = Array.freeze(Array.init<Float>(SERIAL_CORR_MAX_LAG, 0.0));
      var hasPositiveCorr = false;
      var hasNegativeCorr = false;
      var isRenewal = true;
      var dominantLag = 0;
      var memoryDepth = 0;
    }
  };
  
  /// Initialize complete neuron ISI state
  public func initISINeuronState(neuronId : Nat16, shellId : Nat8) : ISINeuronState {
    {
      neuronId = neuronId;
      shellId = shellId;
      spikeTrain = initSpikeTrain(neuronId, shellId);
      histogram = initHistogram(ISI_MIN_MS, ISI_MAX_MS);
      burstStats = initBurstStatistics();
      adaptation = initAdaptationMetrics();
      serialCorr = initSerialCorrelation();
      var firingPattern = #Silent;
      var healthScore = 1.0;
      var arousalContribution = 0.0;
      var lastAnalysisBeat = 0;
    }
  };
  
  /// Initialize population ISI state for multiple neurons
  public func initPopulationISIState(neuronCount : Nat, shellId : Nat8) : PopulationISIState {
    let neurons = Array.tabulate<ISINeuronState>(neuronCount, func(i : Nat) : ISINeuronState {
      initISINeuronState(Nat16.fromNat(i), shellId)
    });
    
    {
      var neurons = neurons;
      var populationMeanCV = 0.0;
      var populationSynchrony = 0.0;
      var burstSynchrony = 0.0;
      var populationAdaptation = 0.0;
      var dominantPattern = #Silent;
      var patternDistribution = [];
      var lastGlobalUpdate = 0;
      var globalHealthScore = 1.0;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // CORE ISI COMPUTATION — THE FUNDAMENTAL CALCULATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Record a spike and compute ISI
  /// ISI[n] = t_spike[n+1] - t_spike[n]
  public func recordSpike(
    state : ISINeuronState,
    timestamp : Int,
    amplitude : Float,
    phaseAtSpike : Float
  ) : ?Float {
    let lastTime = state.spikeTrain.lastSpikeTime;
    
    // Compute ISI if this is not the first spike
    let precedingISI : ?Float = if (lastTime > 0) {
      let isiMicros = timestamp - lastTime;
      let isiMs = Float.fromInt(isiMicros) / 1000.0;  // Convert to ms
      
      // Validate ISI is within bounds
      if (isiMs >= ISI_MIN_MS and isiMs <= ISI_MAX_MS) {
        ?isiMs
      } else {
        null  // Invalid ISI (too short or too long)
      }
    } else {
      null
    };
    
    // Create spike event
    let spike : SpikeEvent = {
      timestamp = timestamp;
      neuronId = state.neuronId;
      amplitude = amplitude;
      shellId = state.shellId;
      phaseAtSpike = phaseAtSpike;
      precedingISI = precedingISI;
    };
    
    // Add to spike train (with circular buffer behavior)
    if (state.spikeTrain.spikes.size() >= MAX_SPIKE_HISTORY) {
      // Remove oldest spike (shift buffer)
      let _ = state.spikeTrain.spikes.remove(0);
    };
    state.spikeTrain.spikes.add(spike);
    
    // Update spike train metadata
    state.spikeTrain.lastSpikeTime := timestamp;
    state.spikeTrain.spikeCount += 1;
    
    // Update histogram if valid ISI
    switch (precedingISI) {
      case (?isi) { updateHistogram(state.histogram, isi) };
      case (null) {};
    };
    
    precedingISI
  };
  
  /// Update ISI histogram with new ISI value
  func updateHistogram(histogram : ISIHistogram, isi : Float) : () {
    if (isi < histogram.minISI or isi >= histogram.maxISI) {
      return;
    };
    
    let binIndex = Int.abs(Float.toInt((isi - histogram.minISI) / histogram.binWidth));
    let idx = if (binIndex >= ISI_HISTOGRAM_BINS) { ISI_HISTOGRAM_BINS - 1 } else { binIndex };
    
    histogram.bins[idx] += 1;
    histogram.totalCount += 1;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // STATISTICAL ANALYSIS — CV, MEAN, VARIANCE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Compute coefficient of variation: CV_ISI = σ(ISI) / μ(ISI)
  public func computeCV(state : ISINeuronState) : Float {
    let spikes = Buffer.toArray(state.spikeTrain.spikes);
    let isiValues = Buffer.Buffer<Float>(spikes.size());
    
    // Extract valid ISIs
    for (spike in spikes.vals()) {
      switch (spike.precedingISI) {
        case (?isi) { isiValues.add(isi) };
        case (null) {};
      };
    };
    
    let isiArray = Buffer.toArray(isiValues);
    if (isiArray.size() < 2) {
      return 0.0;  // Not enough data
    };
    
    // Use last CV_WINDOW_SIZE values
    let windowStart = if (isiArray.size() > CV_WINDOW_SIZE) {
      isiArray.size() - CV_WINDOW_SIZE
    } else { 0 };
    
    var sum : Float = 0.0;
    var count : Nat = 0;
    
    for (i in Iter.range(windowStart, isiArray.size() - 1)) {
      sum += isiArray[i];
      count += 1;
    };
    
    let mean = sum / Float.fromInt(count);
    state.spikeTrain.meanISI := mean;
    
    // Compute variance
    var sumSquaredDiff : Float = 0.0;
    for (i in Iter.range(windowStart, isiArray.size() - 1)) {
      let diff = isiArray[i] - mean;
      sumSquaredDiff += diff * diff;
    };
    
    let variance = sumSquaredDiff / Float.fromInt(count);
    state.spikeTrain.varianceISI := variance;
    
    // CV = σ / μ
    let cv = if (mean > 0.0) {
      Float.sqrt(variance) / mean
    } else {
      0.0
    };
    
    state.spikeTrain.cvISI := cv;
    cv
  };
  
  /// Compute Fano factor: FF = Var(spike_count) / Mean(spike_count)
  public func computeFanoFactor(
    state : ISINeuronState,
    windowSizeMs : Float,
    numWindows : Nat
  ) : Float {
    let spikes = Buffer.toArray(state.spikeTrain.spikes);
    if (spikes.size() < 10) { return 1.0 };  // Default to Poisson
    
    let windowSizeMicros = Int.abs(Float.toInt(windowSizeMs * 1000.0));
    let counts = Buffer.Buffer<Nat>(numWindows);
    
    // Get time range
    let startTime = spikes[0].timestamp;
    let endTime = spikes[spikes.size() - 1].timestamp;
    
    // Count spikes in each window
    var windowStart = startTime;
    var windowIdx : Nat = 0;
    
    while (windowIdx < numWindows and windowStart < endTime) {
      let windowEnd = windowStart + windowSizeMicros;
      var count : Nat = 0;
      
      for (spike in spikes.vals()) {
        if (spike.timestamp >= windowStart and spike.timestamp < windowEnd) {
          count += 1;
        };
      };
      
      counts.add(count);
      windowStart := windowEnd;
      windowIdx += 1;
    };
    
    let countArray = Buffer.toArray(counts);
    if (countArray.size() < 2) { return 1.0 };
    
    // Compute mean and variance of counts
    var sum : Float = 0.0;
    for (c in countArray.vals()) {
      sum += Float.fromInt(c);
    };
    let mean = sum / Float.fromInt(countArray.size());
    
    var sumSqDiff : Float = 0.0;
    for (c in countArray.vals()) {
      let diff = Float.fromInt(c) - mean;
      sumSqDiff += diff * diff;
    };
    let variance = sumSqDiff / Float.fromInt(countArray.size());
    
    // Fano factor
    if (mean > 0.0) { variance / mean } else { 1.0 }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // BURST DETECTION — IDENTIFYING CLUSTERED SPIKES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Detect bursts in spike train
  /// Burst: sequence of spikes with ISI < BURST_THRESHOLD_MS
  public func detectBursts(state : ISINeuronState) : [BurstPattern] {
    let spikes = Buffer.toArray(state.spikeTrain.spikes);
    if (spikes.size() < 3) { return [] };
    
    let bursts = Buffer.Buffer<BurstPattern>(50);
    var burstId : Nat = 0;
    var inBurst = false;
    var burstStart : Int = 0;
    var burstSpikes = Buffer.Buffer<SpikeEvent>(20);
    var lastBurstEnd : Int = 0;
    
    for (i in Iter.range(0, spikes.size() - 1)) {
      let spike = spikes[i];
      
      switch (spike.precedingISI) {
        case (?isi) {
          if (isi < BURST_THRESHOLD_MS) {
            // This spike is part of a burst
            if (not inBurst) {
              // Start new burst (include previous spike)
              inBurst := true;
              burstStart := if (i > 0) { spikes[i-1].timestamp } else { spike.timestamp };
              burstSpikes := Buffer.Buffer<SpikeEvent>(20);
              if (i > 0) { burstSpikes.add(spikes[i-1]) };
            };
            burstSpikes.add(spike);
          } else {
            // Not a burst spike
            if (inBurst and burstSpikes.size() >= 2) {
              // End current burst
              let burstArr = Buffer.toArray(burstSpikes);
              let burstEnd = burstArr[burstArr.size() - 1].timestamp;
              
              // Compute burst statistics
              var isiSum : Float = 0.0;
              var isiCount : Nat = 0;
              for (bs in burstArr.vals()) {
                switch (bs.precedingISI) {
                  case (?bisi) { 
                    if (bisi < BURST_THRESHOLD_MS) {
                      isiSum += bisi;
                      isiCount += 1;
                    };
                  };
                  case (null) {};
                };
              };
              
              let meanBurstISI = if (isiCount > 0) { isiSum / Float.fromInt(isiCount) } else { BURST_THRESHOLD_MS };
              let burstDuration = Float.fromInt(burstEnd - burstStart) / 1000.0;
              let interBurst : ?Float = if (lastBurstEnd > 0) {
                ?Float.fromInt(burstStart - lastBurstEnd) / 1000.0
              } else { null };
              
              let burst : BurstPattern = {
                burstId = burstId;
                startTime = burstStart;
                endTime = burstEnd;
                spikeCount = burstArr.size();
                meanISI = meanBurstISI;
                burstDuration = burstDuration;
                interBurstInterval = interBurst;
                intraFrequency = if (burstDuration > 0.0) { Float.fromInt(burstArr.size()) * 1000.0 / burstDuration } else { 0.0 };
              };
              
              bursts.add(burst);
              burstId += 1;
              lastBurstEnd := burstEnd;
            };
            inBurst := false;
          };
        };
        case (null) {
          // First spike, cannot determine burst status
          inBurst := false;
        };
      };
    };
    
    // Handle burst that extends to end of spike train
    if (inBurst and burstSpikes.size() >= 2) {
      let burstArr = Buffer.toArray(burstSpikes);
      let burstEnd = burstArr[burstArr.size() - 1].timestamp;
      
      var isiSum : Float = 0.0;
      var isiCount : Nat = 0;
      for (bs in burstArr.vals()) {
        switch (bs.precedingISI) {
          case (?bisi) { 
            if (bisi < BURST_THRESHOLD_MS) {
              isiSum += bisi;
              isiCount += 1;
            };
          };
          case (null) {};
        };
      };
      
      let meanBurstISI = if (isiCount > 0) { isiSum / Float.fromInt(isiCount) } else { BURST_THRESHOLD_MS };
      let burstDuration = Float.fromInt(burstEnd - burstStart) / 1000.0;
      let interBurst : ?Float = if (lastBurstEnd > 0) {
        ?Float.fromInt(burstStart - lastBurstEnd) / 1000.0
      } else { null };
      
      let burst : BurstPattern = {
        burstId = burstId;
        startTime = burstStart;
        endTime = burstEnd;
        spikeCount = burstArr.size();
        meanISI = meanBurstISI;
        burstDuration = burstDuration;
        interBurstInterval = interBurst;
        intraFrequency = if (burstDuration > 0.0) { Float.fromInt(burstArr.size()) * 1000.0 / burstDuration } else { 0.0 };
      };
      
      bursts.add(burst);
    };
    
    // Update burst statistics
    let burstArray = Buffer.toArray(bursts);
    updateBurstStatistics(state.burstStats, burstArray, spikes.size());
    
    state.spikeTrain.isBursty := burstArray.size() > 0 and state.burstStats.burstIndex > 0.2;
    state.spikeTrain.burstCount := burstArray.size();
    
    burstArray
  };
  
  /// Update burst statistics from detected bursts
  func updateBurstStatistics(
    stats : BurstStatistics,
    bursts : [BurstPattern],
    totalSpikes : Nat
  ) : () {
    if (bursts.size() == 0) {
      stats.burstIndex := 0.0;
      return;
    };
    
    stats.totalBursts := bursts.size();
    
    var totalDuration : Float = 0.0;
    var totalSpikesInBursts : Nat = 0;
    var totalIBI : Float = 0.0;
    var ibiCount : Nat = 0;
    
    for (burst in bursts.vals()) {
      totalDuration += burst.burstDuration;
      totalSpikesInBursts += burst.spikeCount;
      
      switch (burst.interBurstInterval) {
        case (?ibi) {
          totalIBI += ibi;
          ibiCount += 1;
        };
        case (null) {};
      };
      
      stats.burstHistory.add(burst);
    };
    
    stats.meanBurstLength := totalDuration / Float.fromInt(bursts.size());
    stats.meanSpikesPerBurst := Float.fromInt(totalSpikesInBursts) / Float.fromInt(bursts.size());
    stats.meanInterBurstInterval := if (ibiCount > 0) { totalIBI / Float.fromInt(ibiCount) } else { 0.0 };
    stats.burstIndex := Float.fromInt(totalSpikesInBursts) / Float.fromInt(totalSpikes);
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // ADAPTATION ANALYSIS — DETECTING ISI CHANGES OVER TIME
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Compute adaptation index: AI = (ISI_last - ISI_first) / (ISI_last + ISI_first)
  public func computeAdaptation(state : ISINeuronState) : AdaptationMetrics {
    let spikes = Buffer.toArray(state.spikeTrain.spikes);
    let isiValues = Buffer.Buffer<Float>(spikes.size());
    
    // Extract valid ISIs
    for (spike in spikes.vals()) {
      switch (spike.precedingISI) {
        case (?isi) { isiValues.add(isi) };
        case (null) {};
      };
    };
    
    let isiArray = Buffer.toArray(isiValues);
    if (isiArray.size() < 5) {
      return initAdaptationMetrics();
    };
    
    // Get first and last ISI (use averages of first/last few for stability)
    let firstN = Nat.min(5, isiArray.size() / 2);
    let lastN = firstN;
    
    var firstSum : Float = 0.0;
    for (i in Iter.range(0, firstN - 1)) {
      firstSum += isiArray[i];
    };
    let firstISI = firstSum / Float.fromInt(firstN);
    
    var lastSum : Float = 0.0;
    for (i in Iter.range(isiArray.size() - lastN, isiArray.size() - 1)) {
      lastSum += isiArray[i];
    };
    let lastISI = lastSum / Float.fromInt(lastN);
    
    // Adaptation index
    let ai = if (lastISI + firstISI > 0.0) {
      (lastISI - firstISI) / (lastISI + firstISI)
    } else { 0.0 };
    
    // Adaptation ratio
    let ar = if (firstISI > 0.0) { lastISI / firstISI } else { 1.0 };
    
    // Determine if adaptation is significant (AI > 0.1 indicates adaptation)
    let isAdapting = Float.abs(ai) > 0.1;
    let adaptationStrength = Float.abs(ai);
    
    // Estimate time constant (simplified exponential fit)
    // Assuming ISI(n) = ISI_∞ - (ISI_∞ - ISI_0)e^(-n/τ)
    let steadyStateISI = lastISI;
    let initialISI = firstISI;
    
    // Rough τ estimate: ISI at n=τ should be about 63% of the way from ISI_0 to ISI_∞
    var tau = ADAPTATION_TAU_MS;
    if (isAdapting and isiArray.size() > 10) {
      let target63 = firstISI + 0.632 * (lastISI - firstISI);
      // Find n where ISI ≈ target63
      for (i in Iter.range(0, isiArray.size() - 1)) {
        if ((lastISI > firstISI and isiArray[i] >= target63) or
            (lastISI < firstISI and isiArray[i] <= target63)) {
          tau := Float.fromInt(i) * state.spikeTrain.meanISI;
          // break not available in Motoko, but first match is fine
        };
      };
    };
    
    // Update state
    state.adaptation.adaptationIndex := ai;
    state.adaptation.adaptationRatio := ar;
    state.adaptation.timeConstant := tau;
    state.adaptation.steadyStateISI := steadyStateISI;
    state.adaptation.initialISI := initialISI;
    state.adaptation.isAdapting := isAdapting;
    state.adaptation.adaptationStrength := adaptationStrength;
    state.spikeTrain.adaptationIndex := ai;
    
    state.adaptation
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // SERIAL CORRELATION — DETECTING ISI DEPENDENCIES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Compute serial correlation coefficients: ρₖ = Corr(ISI[n], ISI[n+k])
  public func computeSerialCorrelation(state : ISINeuronState) : SerialCorrelation {
    let spikes = Buffer.toArray(state.spikeTrain.spikes);
    let isiValues = Buffer.Buffer<Float>(spikes.size());
    
    // Extract valid ISIs
    for (spike in spikes.vals()) {
      switch (spike.precedingISI) {
        case (?isi) { isiValues.add(isi) };
        case (null) {};
      };
    };
    
    let isiArray = Buffer.toArray(isiValues);
    if (isiArray.size() < SERIAL_CORR_MAX_LAG + 5) {
      return initSerialCorrelation();
    };
    
    // Compute mean
    var sum : Float = 0.0;
    for (isi in isiArray.vals()) {
      sum += isi;
    };
    let mean = sum / Float.fromInt(isiArray.size());
    
    // Compute variance
    var varSum : Float = 0.0;
    for (isi in isiArray.vals()) {
      let diff = isi - mean;
      varSum += diff * diff;
    };
    let variance = varSum / Float.fromInt(isiArray.size());
    
    if (variance < 1e-10) {
      return initSerialCorrelation();  // Constant ISIs
    };
    
    // Compute correlation coefficients for each lag
    let coeffs = Array.init<Float>(SERIAL_CORR_MAX_LAG, 0.0);
    var hasPos = false;
    var hasNeg = false;
    var maxCorr : Float = 0.0;
    var dominantLag : Nat = 0;
    
    for (lag in Iter.range(1, SERIAL_CORR_MAX_LAG)) {
      var covSum : Float = 0.0;
      let n = isiArray.size() - lag;
      
      for (i in Iter.range(0, n - 1)) {
        covSum += (isiArray[i] - mean) * (isiArray[i + lag] - mean);
      };
      
      let corr = (covSum / Float.fromInt(n)) / variance;
      coeffs[lag - 1] := corr;
      
      if (corr > 0.1) { hasPos := true };
      if (corr < -0.1) { hasNeg := true };
      
      if (Float.abs(corr) > maxCorr) {
        maxCorr := Float.abs(corr);
        dominantLag := lag;
      };
    };
    
    // Determine if this is a renewal process (independent ISIs)
    // Renewal if all |ρₖ| < 0.1
    var isRenewal = true;
    var memoryDepth : Nat = 0;
    for (i in Iter.range(0, SERIAL_CORR_MAX_LAG - 1)) {
      if (Float.abs(coeffs[i]) >= 0.1) {
        isRenewal := false;
        memoryDepth := i + 1;
      };
    };
    
    // Update state
    state.serialCorr.coefficients := Array.freeze(coeffs);
    state.serialCorr.hasPositiveCorr := hasPos;
    state.serialCorr.hasNegativeCorr := hasNeg;
    state.serialCorr.isRenewal := isRenewal;
    state.serialCorr.dominantLag := dominantLag;
    state.serialCorr.memoryDepth := memoryDepth;
    
    state.serialCorr
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // FIRING PATTERN CLASSIFICATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Classify the firing pattern based on ISI statistics
  public func classifyFiringPattern(state : ISINeuronState, currentBeat : Int) : FiringPattern {
    let spikes = Buffer.toArray(state.spikeTrain.spikes);
    
    // Check if neuron is silent (no spikes in last 1000ms)
    if (spikes.size() == 0) {
      state.firingPattern := #Silent;
      return #Silent;
    };
    
    let lastSpike = spikes[spikes.size() - 1];
    let timeSinceLastSpike = Float.fromInt(currentBeat - lastSpike.timestamp) / 1000.0;
    
    if (timeSinceLastSpike > 1000.0) {
      state.firingPattern := #Silent;
      return #Silent;
    };
    
    // Compute CV if not already done
    let cv = computeCV(state);
    
    // Check adaptation
    let adapt = computeAdaptation(state);
    if (adapt.isAdapting and adapt.adaptationStrength > 0.2) {
      state.firingPattern := #Adapting;
      return #Adapting;
    };
    
    // Check for doublets/triplets
    let bursts = detectBursts(state);
    if (bursts.size() > 0) {
      let meanSpikesPerBurst = state.burstStats.meanSpikesPerBurst;
      if (meanSpikesPerBurst >= 1.8 and meanSpikesPerBurst <= 2.2) {
        state.firingPattern := #Doublet;
        return #Doublet;
      };
      if (meanSpikesPerBurst >= 2.8 and meanSpikesPerBurst <= 3.2) {
        state.firingPattern := #Triplet;
        return #Triplet;
      };
      if (state.burstStats.burstIndex > 0.3) {
        state.firingPattern := #Bursty;
        return #Bursty;
      };
    };
    
    // Classify by CV
    if (cv < CV_REGULAR_THRESHOLD) {
      state.firingPattern := #Regular;
      return #Regular;
    };
    
    if (cv >= CV_REGULAR_THRESHOLD and cv <= CV_BURSTY_THRESHOLD) {
      state.firingPattern := #Poisson;
      return #Poisson;
    };
    
    if (cv > CV_BURSTY_THRESHOLD) {
      state.firingPattern := #Bursty;
      return #Bursty;
    };
    
    state.firingPattern := #Irregular;
    #Irregular
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // HISTOGRAM ANALYSIS — MODE, MEDIAN, MULTIMODALITY
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Analyze ISI histogram for distribution characteristics
  public func analyzeHistogram(histogram : ISIHistogram) : () {
    if (histogram.totalCount < 10) { return };
    
    let bins = histogram.bins;
    
    // Find mode (bin with highest count)
    var maxCount : Nat = 0;
    var modeIndex : Nat = 0;
    for (i in Iter.range(0, ISI_HISTOGRAM_BINS - 1)) {
      if (bins[i] > maxCount) {
        maxCount := bins[i];
        modeIndex := i;
      };
    };
    histogram.mode := histogram.minISI + (Float.fromInt(modeIndex) + 0.5) * histogram.binWidth;
    
    // Find median (50th percentile)
    var cumSum : Nat = 0;
    let halfCount = histogram.totalCount / 2;
    var medianIndex : Nat = 0;
    for (i in Iter.range(0, ISI_HISTOGRAM_BINS - 1)) {
      cumSum += bins[i];
      if (cumSum >= halfCount and medianIndex == 0) {
        medianIndex := i;
      };
    };
    histogram.median := histogram.minISI + (Float.fromInt(medianIndex) + 0.5) * histogram.binWidth;
    
    // Compute skewness and kurtosis (simplified)
    // Skewness: measure of asymmetry
    // Kurtosis: measure of tail heaviness
    var m1 : Float = 0.0;
    var m2 : Float = 0.0;
    var m3 : Float = 0.0;
    var m4 : Float = 0.0;
    
    for (i in Iter.range(0, ISI_HISTOGRAM_BINS - 1)) {
      let x = histogram.minISI + (Float.fromInt(i) + 0.5) * histogram.binWidth;
      let n = Float.fromInt(bins[i]);
      m1 += x * n;
    };
    let mean = m1 / Float.fromInt(histogram.totalCount);
    
    for (i in Iter.range(0, ISI_HISTOGRAM_BINS - 1)) {
      let x = histogram.minISI + (Float.fromInt(i) + 0.5) * histogram.binWidth;
      let n = Float.fromInt(bins[i]);
      let diff = x - mean;
      m2 += diff * diff * n;
      m3 += diff * diff * diff * n;
      m4 += diff * diff * diff * diff * n;
    };
    
    let n = Float.fromInt(histogram.totalCount);
    m2 := m2 / n;
    m3 := m3 / n;
    m4 := m4 / n;
    
    let sigma = Float.sqrt(m2);
    if (sigma > 1e-10) {
      histogram.skewness := m3 / (sigma * sigma * sigma);
      histogram.kurtosis := (m4 / (m2 * m2)) - 3.0;  // Excess kurtosis
    };
    
    // Detect multimodality (simplified peak detection)
    let peaks = Buffer.Buffer<Float>(5);
    for (i in Iter.range(1, ISI_HISTOGRAM_BINS - 2)) {
      if (bins[i] > bins[i-1] and bins[i] > bins[i+1] and bins[i] >= maxCount / 4) {
        let peakISI = histogram.minISI + (Float.fromInt(i) + 0.5) * histogram.binWidth;
        peaks.add(peakISI);
      };
    };
    
    histogram.peakLocations := Buffer.toArray(peaks);
    histogram.isMultimodal := peaks.size() > 1;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // HEALTH SCORE — NEURAL HEALTH BASED ON ISI REGULARITY
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Compute health score based on ISI statistics
  /// Healthy neurons have consistent, predictable firing patterns
  public func computeHealthScore(state : ISINeuronState) : Float {
    var score : Float = 1.0;
    
    // CV penalty: very high or very low CV indicates problems
    let cv = state.spikeTrain.cvISI;
    if (cv > 2.0) {
      // Extremely irregular
      score *= 0.5;
    } else if (cv > 1.5) {
      score *= 0.75;
    } else if (cv < 0.1 and cv > 0.0) {
      // Suspiciously regular (might be pathological)
      score *= 0.9;
    };
    
    // Burst index penalty: too many bursts indicates excitotoxicity
    let burstIndex = state.burstStats.burstIndex;
    if (burstIndex > 0.7) {
      score *= 0.6;  // Most spikes in bursts is concerning
    } else if (burstIndex > 0.5) {
      score *= 0.8;
    };
    
    // Serial correlation: negative correlation is often pathological
    if (state.serialCorr.hasNegativeCorr) {
      score *= 0.9;
    };
    
    // Adaptation: some adaptation is healthy, too much is not
    let adaptStrength = state.adaptation.adaptationStrength;
    if (adaptStrength > 0.5) {
      score *= 0.85;
    };
    
    // Apply S₀ floor
    if (score < S_ZERO_FLOOR) {
      score := S_ZERO_FLOOR;
    };
    
    state.healthScore := score;
    score
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // AROUSAL CONTRIBUTION — HOW MUCH THIS NEURON DRIVES GLOBAL AROUSAL
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Compute arousal contribution based on firing rate and pattern
  public func computeArousalContribution(state : ISINeuronState) : Float {
    // Base arousal from firing rate
    let meanISI = state.spikeTrain.meanISI;
    let firingRate = if (meanISI > 0.0) { 1000.0 / meanISI } else { 0.0 };  // Hz
    
    // Normalize to [0, 1] (assuming max firing rate of ~200 Hz)
    var arousal = Float.min(firingRate / 200.0, 1.0);
    
    // Burst bonus: bursts indicate high arousal/attention
    if (state.spikeTrain.isBursty) {
      arousal *= 1.3;
    };
    
    // Regular firing pattern indicates focused attention
    switch (state.firingPattern) {
      case (#Regular) { arousal *= 1.1 };
      case (#Bursty) { arousal *= 1.2 };
      case (#Poisson) { arousal *= 1.0 };
      case (#Adapting) { arousal *= 0.9 };  // Adapting = habituating
      case (#Silent) { arousal := 0.0 };
      case (_) { arousal *= 1.0 };
    };
    
    // Cap at 1.0
    arousal := Float.min(arousal, 1.0);
    
    state.arousalContribution := arousal;
    arousal
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // POPULATION-LEVEL ANALYSIS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Update population-level ISI statistics
  public func updatePopulationStatistics(pop : PopulationISIState, currentBeat : Int) : () {
    if (pop.neurons.size() == 0) { return };
    
    var cvSum : Float = 0.0;
    var adaptSum : Float = 0.0;
    var healthSum : Float = 0.0;
    var activeCount : Nat = 0;
    
    let patternCounts : [(FiringPattern, var Nat)] = [
      (#Regular, 0), (#Poisson, 0), (#Bursty, 0), (#Adapting, 0),
      (#Irregular, 0), (#Silent, 0), (#Doublet, 0), (#Triplet, 0)
    ];
    
    // Analyze each neuron
    for (neuron in pop.neurons.vals()) {
      let pattern = classifyFiringPattern(neuron, currentBeat);
      let _ = computeCV(neuron);
      let _ = computeAdaptation(neuron);
      let _ = computeHealthScore(neuron);
      let _ = computeArousalContribution(neuron);
      
      if (pattern != #Silent) {
        cvSum += neuron.spikeTrain.cvISI;
        adaptSum += neuron.adaptation.adaptationIndex;
        healthSum += neuron.healthScore;
        activeCount += 1;
      };
      
      // Update pattern count
      for ((p, count) in patternCounts.vals()) {
        if (p == pattern) {
          count += 1;
        };
      };
    };
    
    // Compute population averages
    if (activeCount > 0) {
      pop.populationMeanCV := cvSum / Float.fromInt(activeCount);
      pop.populationAdaptation := adaptSum / Float.fromInt(activeCount);
      pop.globalHealthScore := healthSum / Float.fromInt(activeCount);
    };
    
    // Find dominant pattern
    var maxPatternCount : Nat = 0;
    for ((p, count) in patternCounts.vals()) {
      if (count > maxPatternCount) {
        maxPatternCount := count;
        pop.dominantPattern := p;
      };
    };
    
    // Build pattern distribution
    let dist = Buffer.Buffer<(FiringPattern, Float)>(8);
    let totalNeurons = Float.fromInt(pop.neurons.size());
    for ((p, count) in patternCounts.vals()) {
      dist.add((p, Float.fromInt(count) / totalNeurons));
    };
    pop.patternDistribution := Buffer.toArray(dist);
    
    pop.lastGlobalUpdate := currentBeat;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // CROSS-CORRELATION — SYNCHRONY BETWEEN SPIKE TRAINS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Compute synchrony between two spike trains
  public func computePairwiseSynchrony(
    train1 : SpikeTrain,
    train2 : SpikeTrain,
    windowMs : Float
  ) : Float {
    let spikes1 = Buffer.toArray(train1.spikes);
    let spikes2 = Buffer.toArray(train2.spikes);
    
    if (spikes1.size() < 5 or spikes2.size() < 5) {
      return 0.0;
    };
    
    let windowMicros = Int.abs(Float.toInt(windowMs * 1000.0));
    var coincidences : Nat = 0;
    
    // Count coincident spikes (within window)
    for (s1 in spikes1.vals()) {
      for (s2 in spikes2.vals()) {
        let diff = Int.abs(s1.timestamp - s2.timestamp);
        if (diff <= windowMicros) {
          coincidences += 1;
        };
      };
    };
    
    // Normalize by geometric mean of spike counts
    let geomMean = Float.sqrt(Float.fromInt(spikes1.size() * spikes2.size()));
    if (geomMean > 0.0) {
      Float.fromInt(coincidences) / geomMean
    } else {
      0.0
    }
  };
  
  /// Compute population synchrony (average pairwise synchrony)
  public func computePopulationSynchrony(pop : PopulationISIState, windowMs : Float) : Float {
    if (pop.neurons.size() < 2) {
      return 0.0;
    };
    
    var totalSync : Float = 0.0;
    var pairCount : Nat = 0;
    
    // Sample pairs (don't compute all pairs for large populations)
    let maxPairs = 100;
    let step = if (pop.neurons.size() * (pop.neurons.size() - 1) / 2 > maxPairs) {
      pop.neurons.size() / 10
    } else { 1 };
    
    var i : Nat = 0;
    while (i < pop.neurons.size() and pairCount < maxPairs) {
      var j = i + 1;
      while (j < pop.neurons.size() and pairCount < maxPairs) {
        let sync = computePairwiseSynchrony(
          pop.neurons[i].spikeTrain,
          pop.neurons[j].spikeTrain,
          windowMs
        );
        totalSync += sync;
        pairCount += 1;
        j += step;
      };
      i += step;
    };
    
    pop.populationSynchrony := if (pairCount > 0) {
      totalSync / Float.fromInt(pairCount)
    } else { 0.0 };
    
    pop.populationSynchrony
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // HAZARD FUNCTION — INSTANTANEOUS FIRING PROBABILITY
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Compute hazard function from ISI histogram
  /// h(t) = f(t) / (1 - F(t)) where F is CDF
  public func computeHazardFunction(histogram : ISIHistogram) : HazardAnalysis {
    if (histogram.totalCount < 20) {
      return {
        var hazardRate = [];
        var survivalFunction = [];
        var cumulativeHazard = 0.0;
        var hazardPattern = #Constant;
        var meanResidualLife = 0.0;
      };
    };
    
    let n = Float.fromInt(histogram.totalCount);
    let hazard = Array.init<Float>(ISI_HISTOGRAM_BINS, 0.0);
    let survival = Array.init<Float>(ISI_HISTOGRAM_BINS, 1.0);
    
    var cumCount : Nat = 0;
    
    for (i in Iter.range(0, ISI_HISTOGRAM_BINS - 1)) {
      let f_i = Float.fromInt(histogram.bins[i]) / n / histogram.binWidth;  // Density
      let F_i = Float.fromInt(cumCount) / n;  // CDF
      
      survival[i] := 1.0 - F_i;
      
      if (survival[i] > 0.01) {  // Avoid division by very small numbers
        hazard[i] := f_i / survival[i];
      } else {
        hazard[i] := 0.0;
      };
      
      cumCount += histogram.bins[i];
    };
    
    // Determine hazard pattern
    // Increasing: refractory effect, decreasing: bursty, constant: Poisson
    var increasing = true;
    var decreasing = true;
    var prevH : Float = hazard[0];
    
    for (i in Iter.range(1, ISI_HISTOGRAM_BINS / 2)) {
      if (hazard[i] < prevH - 0.01) { increasing := false };
      if (hazard[i] > prevH + 0.01) { decreasing := false };
      prevH := hazard[i];
    };
    
    let pattern : HazardPattern = if (increasing and not decreasing) {
      #Increasing
    } else if (decreasing and not increasing) {
      #Decreasing
    } else {
      #Constant
    };
    
    // Compute cumulative hazard
    var cumHazard : Float = 0.0;
    for (i in Iter.range(0, ISI_HISTOGRAM_BINS - 1)) {
      cumHazard += hazard[i] * histogram.binWidth;
    };
    
    {
      var hazardRate = Array.freeze(hazard);
      var survivalFunction = Array.freeze(survival);
      var cumulativeHazard = cumHazard;
      var hazardPattern = pattern;
      var meanResidualLife = histogram.median;  // Simplified
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // INTEGRATION WITH ORGANISM — HEARTBEAT UPDATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Main update function to be called each heartbeat
  public func heartbeatUpdate(
    pop : PopulationISIState,
    currentBeat : Int
  ) : {
    populationCV : Float;
    populationSynchrony : Float;
    dominantPattern : FiringPattern;
    globalHealth : Float;
    arousalLevel : Float;
  } {
    // Update statistics for all neurons
    updatePopulationStatistics(pop, currentBeat);
    
    // Compute population synchrony
    let sync = computePopulationSynchrony(pop, 10.0);  // 10ms window
    
    // Compute total arousal
    var totalArousal : Float = 0.0;
    for (neuron in pop.neurons.vals()) {
      totalArousal += neuron.arousalContribution;
    };
    totalArousal := totalArousal / Float.fromInt(pop.neurons.size());
    
    {
      populationCV = pop.populationMeanCV;
      populationSynchrony = sync;
      dominantPattern = pop.dominantPattern;
      globalHealth = pop.globalHealthScore;
      arousalLevel = totalArousal;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // STDP INTEGRATION — ISI→STDP TIMING WINDOW
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Compute STDP timing from ISI data
  /// Returns the timing difference for STDP updates
  public func computeSTDPTiming(
    preState : ISINeuronState,
    postState : ISINeuronState
  ) : ?Float {
    let preSpikes = Buffer.toArray(preState.spikeTrain.spikes);
    let postSpikes = Buffer.toArray(postState.spikeTrain.spikes);
    
    if (preSpikes.size() == 0 or postSpikes.size() == 0) {
      return null;
    };
    
    // Get most recent spikes
    let preLast = preSpikes[preSpikes.size() - 1];
    let postLast = postSpikes[postSpikes.size() - 1];
    
    // Δt = t_post - t_pre (positive means post after pre → LTP)
    let deltaT = Float.fromInt(postLast.timestamp - preLast.timestamp) / 1000.0;  // ms
    
    // Only return if within STDP window (typically ±50ms)
    if (Float.abs(deltaT) <= 50.0) {
      ?deltaT
    } else {
      null
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // QUERY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Get spike count for a neuron
  public func getSpikeCount(state : ISINeuronState) : Nat {
    state.spikeTrain.spikeCount
  };
  
  /// Get mean ISI for a neuron
  public func getMeanISI(state : ISINeuronState) : Float {
    state.spikeTrain.meanISI
  };
  
  /// Get CV for a neuron
  public func getCV(state : ISINeuronState) : Float {
    state.spikeTrain.cvISI
  };
  
  /// Get firing pattern for a neuron
  public func getFiringPattern(state : ISINeuronState) : FiringPattern {
    state.firingPattern
  };
  
  /// Get burst count for a neuron
  public func getBurstCount(state : ISINeuronState) : Nat {
    state.burstStats.totalBursts
  };
  
  /// Check if neuron is bursty
  public func isBursty(state : ISINeuronState) : Bool {
    state.spikeTrain.isBursty
  };
  
  /// Get adaptation index
  public func getAdaptationIndex(state : ISINeuronState) : Float {
    state.adaptation.adaptationIndex
  };
  
  /// Get health score
  public func getHealthScore(state : ISINeuronState) : Float {
    state.healthScore
  };
  
  /// Get arousal contribution
  public func getArousalContribution(state : ISINeuronState) : Float {
    state.arousalContribution
  };

}
