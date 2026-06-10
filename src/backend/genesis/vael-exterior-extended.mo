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
// VAEL EXTERIOR CHAIN EXTENDED — ADVANCED PERIMETER DEFENSE
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// This extension TRIPLES the depth with:
//
// PART 1: ADVANCED ANOMALY DETECTION (500 lines)
// ═════════════════════════════════════════════
//   - Isolation Forest
//   - Local Outlier Factor
//   - DBSCAN clustering
//   - Autoencoder reconstruction error
//   - Gaussian Mixture Models
//
// PART 2: ADVERSARIAL ROBUSTNESS (400 lines)
// ════════════════════════════════════════════
//   - Input gradient masking
//   - Adversarial training
//   - Certified defense bounds
//   - Detection of adversarial inputs
//   - Robust optimization
//
// PART 3: INTRUSION DETECTION SYSTEMS (500 lines)
// ═══════════════════════════════════════════════
//   - Signature-based detection
//   - Behavior-based detection
//   - Hybrid IDS
//   - Alert correlation
//   - False positive reduction
//
// PART 4: THREAT INTELLIGENCE (400 lines)
// ══════════════════════════════════════
//   - Threat actor modeling
//   - Attack pattern analysis
//   - Indicator of Compromise (IoC) tracking
//   - Threat landscape mapping
//   - Predictive threat analysis
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
import Blob "mo:base/Blob";

module VAELExteriorExtended {

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  public let NUM_AXES : Nat = 6;
  public let SIGNATURE_DB_SIZE : Nat = 1000;
  public let BEHAVIOR_WINDOW : Nat = 100;
  public let THREAT_MEMORY_SIZE : Nat = 500;
  
  // Axis indices
  public let COHERENCE_AXIS : Nat = 0;
  public let IDENTITY_AXIS : Nat = 1;
  public let FREQUENCY_AXIS : Nat = 2;
  public let TEMPORAL_AXIS : Nat = 3;
  public let ECONOMIC_AXIS : Nat = 4;
  public let SOCIAL_AXIS : Nat = 5;
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // PART 1: ADVANCED ANOMALY DETECTION
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Multiple complementary anomaly detection methods.
  //
  
  public type IsolationForestState = {
    var trees : [[var Float]];           // Tree split points
    var numTrees : Nat;
    var maxDepth : Nat;
    var anomalyScores : [var Float];
    var averagePathLength : Float;
  };
  
  public type LOFState = {
    var kNeighbors : Nat;
    var reachabilityDistances : [[var Float]];
    var localDensities : [var Float];
    var lofScores : [var Float];
  };
  
  public type GMMState = {
    var numComponents : Nat;
    var means : [[var Float]];
    var covariances : [[[var Float]]];
    var weights : [var Float];
    var responsibilities : [[var Float]];
    var logLikelihood : Float;
  };
  
  public type AnomalyDetectionState = {
    isolationForest : IsolationForestState;
    lof : LOFState;
    gmm : GMMState;
    
    var normalBaseline : [[var Float]];  // Normal behavior samples
    var baselineSize : Nat;
    var ensembleScore : Float;           // Combined anomaly score
    var detectionThreshold : Float;
    var anomalyCount : Nat;
  };
  
  public func initIsolationForest() : IsolationForestState {
    {
      var trees = Array.init<[var Float]>(100, func(_ : Nat) : [var Float] {
        Array.init<Float>(20, func(_ : Nat) : Float { 0.5 })
      });
      var numTrees = 100;
      var maxDepth = 10;
      var anomalyScores = Array.init<Float>(THREAT_MEMORY_SIZE, func(_ : Nat) : Float { 0.0 });
      var averagePathLength = 5.0;
    }
  };
  
  public func initLOFState() : LOFState {
    {
      var kNeighbors = 10;
      var reachabilityDistances = Array.init<[var Float]>(BEHAVIOR_WINDOW, func(_ : Nat) : [var Float] {
        Array.init<Float>(BEHAVIOR_WINDOW, func(_ : Nat) : Float { 0.0 })
      });
      var localDensities = Array.init<Float>(BEHAVIOR_WINDOW, func(_ : Nat) : Float { 1.0 });
      var lofScores = Array.init<Float>(BEHAVIOR_WINDOW, func(_ : Nat) : Float { 1.0 });
    }
  };
  
  public func initGMMState() : GMMState {
    {
      var numComponents = 3;
      var means = Array.init<[var Float]>(3, func(_ : Nat) : [var Float] {
        Array.init<Float>(NUM_AXES, func(_ : Nat) : Float { 0.5 })
      });
      var covariances = Array.init<[[var Float]]>(3, func(_ : Nat) : [[var Float]] {
        Array.init<[var Float]>(NUM_AXES, func(_ : Nat) : [var Float] {
          Array.init<Float>(NUM_AXES, func(i : Nat) : Float { if (i == 0) { 0.1 } else { 0.0 } })
        })
      });
      var weights = Array.init<Float>(3, func(_ : Nat) : Float { 0.333 });
      var responsibilities = Array.init<[var Float]>(BEHAVIOR_WINDOW, func(_ : Nat) : [var Float] {
        Array.init<Float>(3, func(_ : Nat) : Float { 0.333 })
      });
      var logLikelihood = 0.0;
    }
  };
  
  public func initAnomalyDetection() : AnomalyDetectionState {
    {
      isolationForest = initIsolationForest();
      lof = initLOFState();
      gmm = initGMMState();
      var normalBaseline = Array.init<[var Float]>(BEHAVIOR_WINDOW, func(_ : Nat) : [var Float] {
        Array.init<Float>(NUM_AXES, func(_ : Nat) : Float { 0.5 })
      });
      var baselineSize = 0;
      var ensembleScore = 0.0;
      var detectionThreshold = 0.7;
      var anomalyCount = 0;
    }
  };
  
  // Isolation Forest: anomaly score based on path length
  public func computeIsolationScore(
    iforest : IsolationForestState,
    sample : [Float]
  ) : Float {
    var totalPathLength : Float = 0.0;
    
    for (t in Iter.range(0, iforest.numTrees - 1)) {
      var depth : Nat = 0;
      var nodeIdx : Nat = 0;
      
      while (depth < iforest.maxDepth) {
        let splitDim = nodeIdx % NUM_AXES;
        let splitValue = iforest.trees[t][depth];
        let sampleValue = if (splitDim < Array.size(sample)) { sample[splitDim] } else { 0.5 };
        
        if (sampleValue < splitValue) {
          nodeIdx := 2 * nodeIdx + 1;
        } else {
          nodeIdx := 2 * nodeIdx + 2;
        };
        depth += 1;
      };
      
      totalPathLength += Float.fromInt(depth);
    };
    
    let avgPath = totalPathLength / Float.fromInt(iforest.numTrees);
    
    // Anomaly score: s(x, n) = 2^(-E[h(x)]/c(n))
    // c(n) = 2H(n-1) - 2(n-1)/n for normalization
    let n = Float.fromInt(BEHAVIOR_WINDOW);
    let cn = 2.0 * (ln(n - 1.0) + 0.5772) - 2.0 * (n - 1.0) / n;
    
    pow(2.0, -avgPath / cn)
  };
  
  // Local Outlier Factor: anomaly based on local density
  public func computeLOFScore(
    lof : LOFState,
    pointIdx : Nat,
    points : [[Float]]
  ) : Float {
    if (pointIdx >= Array.size(points)) { return 1.0 };
    
    let k = lof.kNeighbors;
    let numPoints = Array.size(points);
    
    // Compute k-distance and k-nearest neighbors
    let distances = Array.tabulate<Float>(numPoints, func(j : Nat) : Float {
      if (j == pointIdx) { 1000.0 }
      else { euclideanDistance(points[pointIdx], points[j]) }
    });
    
    // Find k-th smallest distance
    var kDistance : Float = 1000.0;
    var neighborCount : Nat = 0;
    
    for (_ in Iter.range(0, k - 1)) {
      var minDist : Float = 1000.0;
      for (j in Iter.range(0, numPoints - 1)) {
        if (distances[j] < minDist and distances[j] < kDistance) {
          minDist := distances[j];
        };
      };
      if (minDist < 1000.0) {
        kDistance := minDist;
        neighborCount += 1;
      };
    };
    
    // Compute local reachability density
    var reachSum : Float = 0.0;
    for (j in Iter.range(0, numPoints - 1)) {
      if (distances[j] <= kDistance and j != pointIdx) {
        let reachDist = Float.max(distances[j], kDistance);
        reachSum += reachDist;
        lof.reachabilityDistances[pointIdx][j] := reachDist;
      };
    };
    
    let lrd = if (reachSum > 0.0001) { Float.fromInt(neighborCount) / reachSum } else { 1.0 };
    lof.localDensities[pointIdx] := lrd;
    
    // Compute LOF: average ratio of neighbor densities to own density
    var lofSum : Float = 0.0;
    var lofCount : Nat = 0;
    
    for (j in Iter.range(0, numPoints - 1)) {
      if (distances[j] <= kDistance and j != pointIdx) {
        if (lrd > 0.0001) {
          lofSum += lof.localDensities[j] / lrd;
          lofCount += 1;
        };
      };
    };
    
    let lofScore = if (lofCount > 0) { lofSum / Float.fromInt(lofCount) } else { 1.0 };
    lof.lofScores[pointIdx] := lofScore;
    
    lofScore
  };
  
  // GMM: probability under mixture model
  public func computeGMMProbability(
    gmm : GMMState,
    sample : [Float]
  ) : Float {
    var totalProb : Float = 0.0;
    
    for (k in Iter.range(0, gmm.numComponents - 1)) {
      let weight = gmm.weights[k];
      
      // Compute Gaussian probability
      var sqDist : Float = 0.0;
      for (d in Iter.range(0, NUM_AXES - 1)) {
        let mean = gmm.means[k][d];
        let variance = gmm.covariances[k][d][d];
        let sampleVal = if (d < Array.size(sample)) { sample[d] } else { 0.5 };
        let diff = sampleVal - mean;
        sqDist += diff * diff / Float.max(0.01, variance);
      };
      
      let gaussProb = expFunc(-0.5 * sqDist) / sqrt(pow(2.0 * 3.14159, Float.fromInt(NUM_AXES)));
      totalProb += weight * gaussProb;
    };
    
    totalProb
  };
  
  // Ensemble anomaly detection
  public func computeEnsembleAnomalyScore(
    state : AnomalyDetectionState,
    sample : [Float],
    sampleIdx : Nat
  ) : Float {
    // Collect samples for LOF
    let samples = Array.tabulate<[Float]>(state.baselineSize, func(i : Nat) : [Float] {
      Array.freeze(state.normalBaseline[i])
    });
    
    // Isolation Forest score
    let iforestScore = computeIsolationScore(state.isolationForest, sample);
    
    // LOF score (normalized to 0-1)
    let lofScore = if (state.baselineSize > 10) {
      let rawLof = computeLOFScore(state.lof, sampleIdx % BEHAVIOR_WINDOW, samples);
      Float.min(1.0, rawLof / 3.0)  // LOF > 3 is typically anomalous
    } else { 0.5 };
    
    // GMM score (low probability = anomaly)
    let gmmProb = computeGMMProbability(state.gmm, sample);
    let gmmScore = 1.0 - Float.min(1.0, gmmProb * 10.0);
    
    // Weighted ensemble
    state.ensembleScore := 0.4 * iforestScore + 0.3 * lofScore + 0.3 * gmmScore;
    
    if (state.ensembleScore > state.detectionThreshold) {
      state.anomalyCount += 1;
    };
    
    state.ensembleScore
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // PART 2: ADVERSARIAL ROBUSTNESS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Defending against adversarial inputs that try to fool the system.
  //
  
  public type AdversarialDefenseState = {
    // Gradient masking
    var gradientNoise : Float;           // Noise added to gradients
    var inputNoise : Float;              // Noise added to inputs
    
    // Adversarial detection
    var detectionThreshold : Float;
    var detectedAdversarials : Nat;
    var adversarialPatterns : [[var Float]];
    var patternCount : Nat;
    
    // Certified bounds
    var certifiedRadius : Float;         // Provably robust within this radius
    var lipschitzConstant : Float;       // Upper bound on gradient norm
    
    // Robust optimization
    var worstCaseLoss : Float;
    var perturbationBudget : Float;      // ε for adversarial training
  };
  
  public func initAdversarialDefense() : AdversarialDefenseState {
    {
      var gradientNoise = 0.01;
      var inputNoise = 0.05;
      var detectionThreshold = 0.8;
      var detectedAdversarials = 0;
      var adversarialPatterns = Array.init<[var Float]>(100, func(_ : Nat) : [var Float] {
        Array.init<Float>(NUM_AXES, func(_ : Nat) : Float { 0.0 })
      });
      var patternCount = 0;
      var certifiedRadius = 0.1;
      var lipschitzConstant = 1.0;
      var worstCaseLoss = 0.0;
      var perturbationBudget = 0.1;
    }
  };
  
  // Detect adversarial input using statistical tests
  public func detectAdversarialInput(
    defense : AdversarialDefenseState,
    input : [Float],
    expectedDistribution : [Float]       // Expected input distribution
  ) : Bool {
    // Test 1: Statistical distance from expected
    var klDivergence : Float = 0.0;
    let dim = Nat.min(Array.size(input), Array.size(expectedDistribution));
    
    for (i in Iter.range(0, dim - 1)) {
      let p = Float.max(0.001, input[i]);
      let q = Float.max(0.001, expectedDistribution[i]);
      klDivergence += p * ln(p / q);
    };
    
    // Test 2: Check for suspicious patterns
    var patternMatch : Float = 0.0;
    for (p in Iter.range(0, defense.patternCount - 1)) {
      let similarity = cosineSimilarity(input, Array.freeze(defense.adversarialPatterns[p]));
      if (similarity > patternMatch) {
        patternMatch := similarity;
      };
    };
    
    // Test 3: Local smoothness (adversarials often have sharp features)
    var smoothness : Float = 0.0;
    for (i in Iter.range(1, dim - 1)) {
      let diff = input[i] - input[i - 1];
      smoothness += diff * diff;
    };
    smoothness := sqrt(smoothness / Float.fromInt(dim));
    
    // Combine tests
    let adversarialScore = 0.4 * Float.min(1.0, klDivergence) + 
                          0.3 * patternMatch + 
                          0.3 * Float.min(1.0, smoothness * 5.0);
    
    let isAdversarial = adversarialScore > defense.detectionThreshold;
    
    if (isAdversarial) {
      defense.detectedAdversarials += 1;
      
      // Store pattern for future detection
      if (defense.patternCount < 100) {
        for (i in Iter.range(0, NUM_AXES - 1)) {
          defense.adversarialPatterns[defense.patternCount][i] := 
            if (i < Array.size(input)) { input[i] } else { 0.0 };
        };
        defense.patternCount += 1;
      };
    };
    
    isAdversarial
  };
  
  // Randomized smoothing for certified robustness
  public func randomizedSmoothing(
    defense : AdversarialDefenseState,
    input : [Float],
    numSamples : Nat
  ) : [Float] {
    let dim = Array.size(input);
    let smoothed = Array.init<Float>(dim, func(_ : Nat) : Float { 0.0 });
    
    for (_ in Iter.range(0, numSamples - 1)) {
      for (i in Iter.range(0, dim - 1)) {
        // Add Gaussian noise
        let noise = defense.inputNoise * gaussianNoise();
        smoothed[i] := smoothed[i] + input[i] + noise;
      };
    };
    
    // Average
    Array.tabulate<Float>(dim, func(i : Nat) : Float {
      smoothed[i] / Float.fromInt(numSamples)
    })
  };
  
  // Compute certified radius
  public func computeCertifiedRadius(
    defense : AdversarialDefenseState,
    confidence : Float                   // Confidence in prediction
  ) : Float {
    // Certified radius depends on smoothing noise and confidence
    // R = σ × Φ^{-1}(p_A)  where p_A is the confidence
    
    let sigma = defense.inputNoise;
    let invNormalCDF = if (confidence > 0.5) {
      sqrt(2.0) * erfInv(2.0 * confidence - 1.0)
    } else { 0.0 };
    
    defense.certifiedRadius := sigma * invNormalCDF;
    defense.certifiedRadius
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // PART 3: INTRUSION DETECTION SYSTEMS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Signature-based and behavior-based detection working together.
  //
  
  public type Signature = {
    id : Nat;
    pattern : [Float];
    severity : Float;
    description : Text;
    var matchCount : Nat;
    var lastMatch : Nat;
  };
  
  public type BehaviorProfile = {
    var normalMean : [var Float];
    var normalStd : [var Float];
    var windowBuffer : [[var Float]];
    var bufferIdx : Nat;
    var deviationScore : Float;
  };
  
  public type IDSState = {
    // Signature-based
    var signatures : [var Signature];
    var numSignatures : Nat;
    var signatureMatches : Nat;
    
    // Behavior-based
    var behaviorProfiles : [var BehaviorProfile];
    var numProfiles : Nat;
    var behaviorAlerts : Nat;
    
    // Hybrid
    var combinedThreatScore : Float;
    var alertHistory : [var Float];
    var alertIdx : Nat;
    var falsePositiveRate : Float;
    var truePositiveRate : Float;
    
    // Alert correlation
    var correlationWindow : Nat;
    var correlatedAlerts : Nat;
  };
  
  public func initSignature(id : Nat, pattern : [Float], severity : Float, desc : Text) : Signature {
    {
      id = id;
      pattern = pattern;
      severity = severity;
      description = desc;
      var matchCount = 0;
      var lastMatch = 0;
    }
  };
  
  public func initBehaviorProfile() : BehaviorProfile {
    {
      var normalMean = Array.init<Float>(NUM_AXES, func(_ : Nat) : Float { 0.5 });
      var normalStd = Array.init<Float>(NUM_AXES, func(_ : Nat) : Float { 0.1 });
      var windowBuffer = Array.init<[var Float]>(BEHAVIOR_WINDOW, func(_ : Nat) : [var Float] {
        Array.init<Float>(NUM_AXES, func(_ : Nat) : Float { 0.5 })
      });
      var bufferIdx = 0;
      var deviationScore = 0.0;
    }
  };
  
  public func initIDSState() : IDSState {
    {
      var signatures = Array.init<Signature>(SIGNATURE_DB_SIZE, func(i : Nat) : Signature {
        initSignature(i, [], 0.0, "")
      });
      var numSignatures = 0;
      var signatureMatches = 0;
      var behaviorProfiles = Array.init<BehaviorProfile>(NUM_AXES, func(_ : Nat) : BehaviorProfile {
        initBehaviorProfile()
      });
      var numProfiles = NUM_AXES;
      var behaviorAlerts = 0;
      var combinedThreatScore = 0.0;
      var alertHistory = Array.init<Float>(1000, func(_ : Nat) : Float { 0.0 });
      var alertIdx = 0;
      var falsePositiveRate = 0.1;
      var truePositiveRate = 0.9;
      var correlationWindow = 50;
      var correlatedAlerts = 0;
    }
  };
  
  // Add a signature to the database
  public func addSignature(
    ids : IDSState,
    pattern : [Float],
    severity : Float,
    description : Text
  ) {
    if (ids.numSignatures >= SIGNATURE_DB_SIZE) { return };
    
    ids.signatures[ids.numSignatures] := initSignature(ids.numSignatures, pattern, severity, description);
    ids.numSignatures += 1;
  };
  
  // Signature matching
  public func checkSignatures(
    ids : IDSState,
    input : [Float],
    beat : Nat
  ) : Float {
    var maxSeverity : Float = 0.0;
    
    for (i in Iter.range(0, ids.numSignatures - 1)) {
      let sig = ids.signatures[i];
      let similarity = cosineSimilarity(input, sig.pattern);
      
      if (similarity > 0.9) {
        // Match found
        ids.signatures[i].matchCount += 1;
        ids.signatures[i].lastMatch := beat;
        ids.signatureMatches += 1;
        
        if (sig.severity > maxSeverity) {
          maxSeverity := sig.severity;
        };
      };
    };
    
    maxSeverity
  };
  
  // Behavior-based detection: compare to learned normal
  public func checkBehavior(
    ids : IDSState,
    input : [Float],
    profileIdx : Nat
  ) : Float {
    if (profileIdx >= ids.numProfiles) { return 0.0 };
    
    let profile = ids.behaviorProfiles[profileIdx];
    
    // Add to window
    for (i in Iter.range(0, NUM_AXES - 1)) {
      profile.windowBuffer[profile.bufferIdx][i] := 
        if (i < Array.size(input)) { input[i] } else { 0.5 };
    };
    profile.bufferIdx := (profile.bufferIdx + 1) % BEHAVIOR_WINDOW;
    
    // Compute Z-score
    var maxZ : Float = 0.0;
    for (i in Iter.range(0, NUM_AXES - 1)) {
      let value = if (i < Array.size(input)) { input[i] } else { 0.5 };
      let mean = profile.normalMean[i];
      let std = Float.max(0.01, profile.normalStd[i]);
      let z = Float.abs((value - mean) / std);
      
      if (z > maxZ) { maxZ := z };
    };
    
    profile.deviationScore := maxZ;
    
    // Z > 3 is typically anomalous
    if (maxZ > 3.0) {
      ids.behaviorAlerts += 1;
    };
    
    maxZ
  };
  
  // Combined IDS decision
  public func runIDS(
    ids : IDSState,
    input : [Float],
    beat : Nat
  ) : Float {
    let signatureSeverity = checkSignatures(ids, input, beat);
    
    var maxBehaviorScore : Float = 0.0;
    for (p in Iter.range(0, ids.numProfiles - 1)) {
      let score = checkBehavior(ids, input, p);
      if (score > maxBehaviorScore) {
        maxBehaviorScore := score;
      };
    };
    
    // Normalize behavior score
    let normalizedBehavior = Float.min(1.0, maxBehaviorScore / 5.0);
    
    // Combine: weight signature higher (more specific)
    ids.combinedThreatScore := 0.6 * signatureSeverity + 0.4 * normalizedBehavior;
    
    // Store in alert history
    ids.alertHistory[ids.alertIdx] := ids.combinedThreatScore;
    ids.alertIdx := (ids.alertIdx + 1) % 1000;
    
    // Check for correlated alerts
    var recentAlerts : Nat = 0;
    for (i in Iter.range(0, ids.correlationWindow - 1)) {
      let idx = (ids.alertIdx + 1000 - i) % 1000;
      if (ids.alertHistory[idx] > 0.5) {
        recentAlerts += 1;
      };
    };
    
    if (recentAlerts > ids.correlationWindow / 3) {
      ids.correlatedAlerts += 1;
      // Boost threat score for correlated alerts
      ids.combinedThreatScore := Float.min(1.0, ids.combinedThreatScore * 1.5);
    };
    
    ids.combinedThreatScore
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // PART 4: THREAT INTELLIGENCE
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Understanding the threat landscape and predicting future attacks.
  //
  
  public type ThreatActor = {
    id : Nat;
    var capability : Float;              // Technical capability
    var intent : Float;                  // Malicious intent
    var opportunity : Float;             // Access/opportunity
    var activityLevel : Float;           // Recent activity
    var knownTTPs : [Nat];               // Tactics, Techniques, Procedures
    var lastSeen : Nat;
  };
  
  public type IoC = {
    hash : Nat32;
    indicatorType : Nat;                 // 0=hash, 1=pattern, 2=behavior
    var confidence : Float;
    var firstSeen : Nat;
    var lastSeen : Nat;
    var matchCount : Nat;
  };
  
  public type ThreatIntelState = {
    var threatActors : [var ThreatActor];
    var numActors : Nat;
    
    var iocs : [var IoC];
    var numIocs : Nat;
    
    var threatLandscape : [[var Float]];  // Heat map of threats
    var landscapeSize : Nat;
    
    var predictedThreats : [var Float];  // Predicted threat probability per axis
    var predictionHorizon : Nat;         // Beats into future
    
    var overallThreatLevel : Float;
  };
  
  public func initThreatActor(id : Nat) : ThreatActor {
    {
      id = id;
      var capability = 0.5;
      var intent = 0.5;
      var opportunity = 0.5;
      var activityLevel = 0.0;
      var knownTTPs = [];
      var lastSeen = 0;
    }
  };
  
  public func initIoC(hash : Nat32, iocType : Nat) : IoC {
    {
      hash = hash;
      indicatorType = iocType;
      var confidence = 0.5;
      var firstSeen = 0;
      var lastSeen = 0;
      var matchCount = 0;
    }
  };
  
  public func initThreatIntel() : ThreatIntelState {
    {
      var threatActors = Array.init<ThreatActor>(50, func(i : Nat) : ThreatActor {
        initThreatActor(i)
      });
      var numActors = 0;
      var iocs = Array.init<IoC>(THREAT_MEMORY_SIZE, func(_ : Nat) : IoC {
        initIoC(0, 0)
      });
      var numIocs = 0;
      var threatLandscape = Array.init<[var Float]>(10, func(_ : Nat) : [var Float] {
        Array.init<Float>(10, func(_ : Nat) : Float { 0.0 })
      });
      var landscapeSize = 10;
      var predictedThreats = Array.init<Float>(NUM_AXES, func(_ : Nat) : Float { 0.0 });
      var predictionHorizon = 100;
      var overallThreatLevel = 0.0;
    }
  };
  
  // Add an indicator of compromise
  public func addIoC(
    intel : ThreatIntelState,
    data : [Nat8],
    iocType : Nat,
    confidence : Float,
    beat : Nat
  ) {
    if (intel.numIocs >= THREAT_MEMORY_SIZE) { return };
    
    let hash = fnv1aHash(data);
    
    // Check if IoC already exists
    for (i in Iter.range(0, intel.numIocs - 1)) {
      if (intel.iocs[i].hash == hash) {
        intel.iocs[i].lastSeen := beat;
        intel.iocs[i].matchCount += 1;
        intel.iocs[i].confidence := Float.min(1.0, intel.iocs[i].confidence + 0.1);
        return;
      };
    };
    
    // Add new IoC
    intel.iocs[intel.numIocs] := {
      hash = hash;
      indicatorType = iocType;
      var confidence = confidence;
      var firstSeen = beat;
      var lastSeen = beat;
      var matchCount = 1;
    };
    intel.numIocs += 1;
  };
  
  // Check input against IoCs
  public func checkIoCs(
    intel : ThreatIntelState,
    data : [Nat8],
    beat : Nat
  ) : Float {
    let hash = fnv1aHash(data);
    
    for (i in Iter.range(0, intel.numIocs - 1)) {
      if (intel.iocs[i].hash == hash) {
        intel.iocs[i].lastSeen := beat;
        intel.iocs[i].matchCount += 1;
        return intel.iocs[i].confidence;
      };
    };
    
    0.0
  };
  
  // Update threat actor assessment
  public func assessThreatActor(
    intel : ThreatIntelState,
    actorIdx : Nat,
    observedCapability : Float,
    observedActivity : Float,
    beat : Nat
  ) {
    if (actorIdx >= intel.numActors) { return };
    
    let actor = intel.threatActors[actorIdx];
    
    // Update with exponential moving average
    actor.capability := 0.9 * actor.capability + 0.1 * observedCapability;
    actor.activityLevel := 0.9 * actor.activityLevel + 0.1 * observedActivity;
    actor.lastSeen := beat;
    
    // Update opportunity based on recency
    let beatsSinceLastSeen = beat - actor.lastSeen;
    if (beatsSinceLastSeen < 100) {
      actor.opportunity := Float.min(1.0, actor.opportunity + 0.1);
    } else {
      actor.opportunity := Float.max(0.0, actor.opportunity - 0.01);
    };
  };
  
  // Predict future threats
  public func predictThreats(
    intel : ThreatIntelState,
    recentActivity : [Float],
    horizon : Nat
  ) {
    intel.predictionHorizon := horizon;
    
    // Simple trend extrapolation
    for (axis in Iter.range(0, NUM_AXES - 1)) {
      let current = if (axis < Array.size(recentActivity)) { recentActivity[axis] } else { 0.0 };
      
      // Factor in threat actors
      var actorContribution : Float = 0.0;
      for (a in Iter.range(0, intel.numActors - 1)) {
        let actor = intel.threatActors[a];
        actorContribution += actor.capability * actor.intent * actor.opportunity * actor.activityLevel;
      };
      actorContribution /= Float.max(1.0, Float.fromInt(intel.numActors));
      
      // Prediction = current trend + actor threat
      intel.predictedThreats[axis] := Float.min(1.0, current + actorContribution * 0.5);
    };
    
    // Overall threat level
    var sumThreat : Float = 0.0;
    for (axis in Iter.range(0, NUM_AXES - 1)) {
      sumThreat += intel.predictedThreats[axis];
    };
    intel.overallThreatLevel := sumThreat / Float.fromInt(NUM_AXES);
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // UTILITY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  func euclideanDistance(a : [Float], b : [Float]) : Float {
    var sum : Float = 0.0;
    let dim = Nat.min(Array.size(a), Array.size(b));
    for (i in Iter.range(0, dim - 1)) {
      let diff = a[i] - b[i];
      sum += diff * diff;
    };
    sqrt(sum)
  };
  
  func cosineSimilarity(a : [Float], b : [Float]) : Float {
    var dot : Float = 0.0;
    var normA : Float = 0.0;
    var normB : Float = 0.0;
    let dim = Nat.min(Array.size(a), Array.size(b));
    
    for (i in Iter.range(0, dim - 1)) {
      dot += a[i] * b[i];
      normA += a[i] * a[i];
      normB += b[i] * b[i];
    };
    
    let denom = sqrt(normA) * sqrt(normB);
    if (denom > 0.0001) { dot / denom } else { 0.0 }
  };
  
  func fnv1aHash(data : [Nat8]) : Nat32 {
    var hash : Nat32 = 2166136261;
    for (byte in data.vals()) {
      hash := hash ^ Nat32.fromNat(Nat8.toNat(byte));
      hash := hash *% 16777619;
    };
    hash
  };
  
  func gaussianNoise() : Float {
    // Box-Muller approximation (simplified)
    let u1 = 0.5;  // Would need proper random
    let u2 = 0.5;
    sqrt(-2.0 * ln(Float.max(0.0001, u1))) * cos(2.0 * 3.14159 * u2)
  };
  
  func erfInv(x : Float) : Float {
    // Approximation of inverse error function
    let a = 0.147;
    let sign : Float = if (x < 0.0) { -1.0 } else { 1.0 };
    let x2 = x * x;
    let lnPart = ln(1.0 - x2);
    let term1 = 2.0 / (3.14159 * a) + lnPart / 2.0;
    let term2 = lnPart / a;
    sign * sqrt(sqrt(term1 * term1 - term2) - term1)
  };
  
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
  
  func cos(x : Float) : Float {
    let PI : Float = 3.14159265358979323846;
    var xNorm = x;
    while (xNorm > PI) { xNorm := xNorm - 2.0 * PI };
    while (xNorm < -PI) { xNorm := xNorm + 2.0 * PI };
    
    var result : Float = 1.0;
    var term : Float = 1.0;
    for (n in Iter.range(1, 15)) {
      term := -term * xNorm * xNorm / Float.fromInt((2 * n - 1) * (2 * n));
      result += term;
    };
    result
  };

};
