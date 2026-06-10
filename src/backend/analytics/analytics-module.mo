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
// =====================================================================
// Analytics Module — Historical Tracking, Performance Metrics, Snapshots
// Part of the Organism Command Platform Cognitive Architecture
// =====================================================================

import Time "mo:core/Time";
import Array "mo:core/Array";
import Float "mo:core/Float";
import Nat "mo:core/Nat";
import Int "mo:core/Int";
import Text "mo:core/Text";
import Principal "mo:core/Principal";

module AnalyticsModule {

  // ===================== Time Window Types =====================

  public type TimeWindow = {
    #Hour;
    #Day;
    #Week;
    #Month;
    #Quarter;
    #Year;
    #AllTime;
  };

  public type TimeRange = {
    startTime : Int;
    endTime : Int;
    window : TimeWindow;
  };

  // ===================== Metric Types =====================

  public type MetricType = {
    #Coherence;
    #FormaBalance;
    #ActivationCount;
    #GovernanceScore;
    #CompoundIndex;
    #HzMean;
    #NeuroChemMean;
    #MintRate;
    #StreakBonus;
    #DriveTransitions;
  };

  public type AggregationType = {
    #Mean;
    #Median;
    #Min;
    #Max;
    #Sum;
    #Count;
    #StdDev;
    #Variance;
    #Percentile95;
    #Percentile99;
  };

  // ===================== Snapshot Types =====================

  public type ShellSnapshot = {
    organismId : Text;
    timestamp : Int;
    coherence : Float;
    formaBalance : Float;
    activationCount : Nat;
    governanceScore : Float;
    compoundIndex : Float;
    hzMean : Float;
    hzMin : Float;
    hzMax : Float;
    hzStdDev : Float;
    neuroChemMean : Float;
    neuroChemMin : Float;
    neuroChemMax : Float;
    neuroChemStdDev : Float;
    driveMode : Text;
    mintRate : Float;
    streakBonus : Float;
  };

  public type OrganismSnapshot = {
    organismId : Text;
    organismName : Text;
    owner : Principal;
    class_ : Text;
    specializations : [Text];
    genesisHash : Text;
    shellSnapshot : ShellSnapshot;
    transferCount : Nat;
    createdAt : Int;
    snapshotAt : Int;
  };

  // ===================== Performance Metrics =====================

  public type PerformanceMetric = {
    organismId : Text;
    metricType : MetricType;
    value : Float;
    previousValue : Float;
    changePercent : Float;
    changeAbsolute : Float;
    trend : Text; // "up", "down", "stable"
    timestamp : Int;
    window : TimeWindow;
  };

  public type AggregatedMetric = {
    organismId : Text;
    metricType : MetricType;
    aggregationType : AggregationType;
    value : Float;
    sampleCount : Nat;
    timeRange : TimeRange;
  };

  // ===================== Trend Analysis =====================

  public type TrendPoint = {
    timestamp : Int;
    value : Float;
  };

  public type TrendLine = {
    organismId : Text;
    metricType : MetricType;
    points : [TrendPoint];
    slope : Float;
    intercept : Float;
    r2 : Float; // R-squared correlation coefficient
    prediction : Float; // Next predicted value
    confidence : Float; // Prediction confidence 0-1
  };

  public type TrendAnalysis = {
    organismId : Text;
    coherenceTrend : TrendLine;
    formaTrend : TrendLine;
    governanceTrend : TrendLine;
    compoundTrend : TrendLine;
    overallHealth : Text; // "excellent", "good", "fair", "needs_attention"
    recommendations : [Text];
    analysisTimestamp : Int;
  };

  // ===================== Comparative Analytics =====================

  public type OrganismRanking = {
    organismId : Text;
    organismName : Text;
    rank : Nat;
    percentile : Float;
    metricValue : Float;
    metricType : MetricType;
  };

  public type LeaderboardEntry = {
    rank : Nat;
    organismId : Text;
    organismName : Text;
    owner : Principal;
    class_ : Text;
    score : Float;
    change24h : Float;
    streak : Nat;
  };

  public type Leaderboard = {
    entries : [LeaderboardEntry];
    metricType : MetricType;
    timeWindow : TimeWindow;
    totalOrganisms : Nat;
    updatedAt : Int;
  };

  // ===================== Activity Tracking =====================

  public type ActivityType = {
    #Tick;
    #Chat;
    #Transfer;
    #ListForSale;
    #WithdrawFromSale;
    #Purchase;
    #ArtifactCreated;
    #DriveChange;
    #MilestoneReached;
  };

  public type ActivityEvent = {
    id : Text;
    organismId : Text;
    activityType : ActivityType;
    details : Text;
    timestamp : Int;
    metadata : [(Text, Text)];
  };

  public type ActivitySummary = {
    organismId : Text;
    totalEvents : Nat;
    eventsByType : [(ActivityType, Nat)];
    mostActiveHour : Nat;
    mostActiveDay : Text;
    averageEventsPerDay : Float;
    timeRange : TimeRange;
  };

  // ===================== Health Metrics =====================

  public type HealthIndicator = {
    name : Text;
    value : Float;
    status : Text; // "healthy", "warning", "critical"
    threshold : Float;
    recommendation : ?Text;
  };

  public type OrganismHealth = {
    organismId : Text;
    overallScore : Float;
    status : Text;
    indicators : [HealthIndicator];
    lastChecked : Int;
    nextCheckRecommended : Int;
  };

  // ===================== State Management =====================

  public type AnalyticsState = {
    var snapshots : [OrganismSnapshot];
    var performanceMetrics : [PerformanceMetric];
    var aggregatedMetrics : [AggregatedMetric];
    var trendAnalyses : [TrendAnalysis];
    var activityEvents : [ActivityEvent];
    var leaderboards : [Leaderboard];
    var healthReports : [OrganismHealth];
    var lastSnapshotTime : Int;
    var snapshotInterval : Int;
  };

  public func initState() : AnalyticsState {
    {
      var snapshots = [];
      var performanceMetrics = [];
      var aggregatedMetrics = [];
      var trendAnalyses = [];
      var activityEvents = [];
      var leaderboards = [];
      var healthReports = [];
      var lastSnapshotTime = 0;
      var snapshotInterval = 3600_000_000_000; // 1 hour in nanoseconds
    };
  };

  // ===================== Array Utilities =====================

  func arrayAppend<T>(a : [T], b : [T]) : [T] {
    let sa = a.size();
    let sb = b.size();
    if (sa == 0) return b;
    if (sb == 0) return a;
    Array.tabulate(sa + sb, func(i : Nat) : T {
      if (i < sa) a[i] else b[i - sa];
    });
  };

  func arrayFilter<T>(arr : [T], pred : T -> Bool) : [T] {
    var result : [T] = [];
    for (item in arr.vals()) {
      if (pred(item)) {
        result := arrayAppend(result, [item]);
      };
    };
    result;
  };

  func arrayMap<T, U>(arr : [T], f : T -> U) : [U] {
    Array.tabulate(arr.size(), func(i : Nat) : U { f(arr[i]) });
  };

  // ===================== Math Utilities =====================

  public func mean(values : [Float]) : Float {
    if (values.size() == 0) return 0.0;
    var sum : Float = 0.0;
    for (v in values.vals()) {
      sum := sum + v;
    };
    sum / values.size().toFloat();
  };

  public func variance(values : [Float]) : Float {
    if (values.size() < 2) return 0.0;
    let m = mean(values);
    var sumSquares : Float = 0.0;
    for (v in values.vals()) {
      let diff = v - m;
      sumSquares := sumSquares + (diff * diff);
    };
    sumSquares / (values.size() - 1).toFloat();
  };

  public func stdDev(values : [Float]) : Float {
    Float.sqrt(variance(values));
  };

  public func min(values : [Float]) : Float {
    if (values.size() == 0) return 0.0;
    var minVal = values[0];
    for (v in values.vals()) {
      if (v < minVal) minVal := v;
    };
    minVal;
  };

  public func max(values : [Float]) : Float {
    if (values.size() == 0) return 0.0;
    var maxVal = values[0];
    for (v in values.vals()) {
      if (v > maxVal) maxVal := v;
    };
    maxVal;
  };

  public func percentile(values : [Float], p : Float) : Float {
    if (values.size() == 0) return 0.0;
    // Simple percentile calculation (would need sorting for accuracy)
    let idx = Float.toInt(p * values.size().toFloat() / 100.0);
    let safeIdx = if (idx < 0) 0 else if (idx >= values.size().toInt()) values.size() - 1 else Int.abs(idx);
    values[safeIdx];
  };

  // ===================== Linear Regression =====================

  public func linearRegression(points : [TrendPoint]) : (Float, Float, Float) {
    // Returns (slope, intercept, r2)
    if (points.size() < 2) return (0.0, 0.0, 0.0);
    
    let n = points.size().toFloat();
    var sumX : Float = 0.0;
    var sumY : Float = 0.0;
    var sumXY : Float = 0.0;
    var sumXX : Float = 0.0;
    var sumYY : Float = 0.0;
    
    for (p in points.vals()) {
      let x = p.timestamp.toFloat();
      let y = p.value;
      sumX := sumX + x;
      sumY := sumY + y;
      sumXY := sumXY + (x * y);
      sumXX := sumXX + (x * x);
      sumYY := sumYY + (y * y);
    };
    
    let denominator = n * sumXX - sumX * sumX;
    if (denominator == 0.0) return (0.0, sumY / n, 0.0);
    
    let slope = (n * sumXY - sumX * sumY) / denominator;
    let intercept = (sumY - slope * sumX) / n;
    
    // Calculate R-squared
    let ssRes = sumYY - slope * sumXY - intercept * sumY;
    let ssTot = sumYY - (sumY * sumY) / n;
    let r2 = if (ssTot == 0.0) 1.0 else 1.0 - (ssRes / ssTot);
    
    (slope, intercept, Float.max(0.0, Float.min(1.0, r2)));
  };

  // ===================== Snapshot Functions =====================

  public func createShellSnapshot(
    organismId : Text,
    coherence : Float,
    formaBalance : Float,
    activationCount : Nat,
    governanceScore : Float,
    compoundIndex : Float,
    hz : [Float],
    neuroChem : [Float],
    driveMode : Text,
  ) : ShellSnapshot {
    let hzMean = mean(hz);
    let hzStd = stdDev(hz);
    let neuroMean = mean(neuroChem);
    let neuroStd = stdDev(neuroChem);
    
    // Calculate mint rate: coherence * 2.0 * streakBonus * compoundIndex
    let streakBonus = Float.min(2.0, 1.0 + activationCount.toFloat() * 0.001);
    let mintRate = coherence * 2.0 * streakBonus * compoundIndex;
    
    {
      organismId;
      timestamp = Time.now();
      coherence;
      formaBalance;
      activationCount;
      governanceScore;
      compoundIndex;
      hzMean;
      hzMin = min(hz);
      hzMax = max(hz);
      hzStdDev = hzStd;
      neuroChemMean = neuroMean;
      neuroChemMin = min(neuroChem);
      neuroChemMax = max(neuroChem);
      neuroChemStdDev = neuroStd;
      driveMode;
      mintRate;
      streakBonus;
    };
  };

  public func addSnapshot(state : AnalyticsState, snapshot : OrganismSnapshot) {
    state.snapshots := arrayAppend(state.snapshots, [snapshot]);
    state.lastSnapshotTime := Time.now();
  };

  public func getSnapshotsForOrganism(
    state : AnalyticsState,
    organismId : Text,
    limit : Nat,
  ) : [OrganismSnapshot] {
    var result : [OrganismSnapshot] = [];
    var count : Nat = 0;
    
    // Iterate in reverse to get most recent first
    let size = state.snapshots.size();
    var i = size;
    while (i > 0 and count < limit) {
      i -= 1;
      if (state.snapshots[i].organismId == organismId) {
        result := arrayAppend(result, [state.snapshots[i]]);
        count += 1;
      };
    };
    result;
  };

  public func getSnapshotsInTimeRange(
    state : AnalyticsState,
    organismId : Text,
    startTime : Int,
    endTime : Int,
  ) : [OrganismSnapshot] {
    arrayFilter(state.snapshots, func(s : OrganismSnapshot) : Bool {
      s.organismId == organismId and s.snapshotAt >= startTime and s.snapshotAt <= endTime
    });
  };

  // ===================== Performance Metric Functions =====================

  public func calculatePerformanceMetric(
    organismId : Text,
    metricType : MetricType,
    currentValue : Float,
    previousValue : Float,
    window : TimeWindow,
  ) : PerformanceMetric {
    let changeAbsolute = currentValue - previousValue;
    let changePercent = if (previousValue == 0.0) 0.0 else (changeAbsolute / previousValue) * 100.0;
    let trend = if (changeAbsolute > 0.01) "up" 
                else if (changeAbsolute < -0.01) "down" 
                else "stable";
    
    {
      organismId;
      metricType;
      value = currentValue;
      previousValue;
      changePercent;
      changeAbsolute;
      trend;
      timestamp = Time.now();
      window;
    };
  };

  public func addPerformanceMetric(state : AnalyticsState, metric : PerformanceMetric) {
    state.performanceMetrics := arrayAppend(state.performanceMetrics, [metric]);
  };

  public func getPerformanceMetrics(
    state : AnalyticsState,
    organismId : Text,
    metricType : ?MetricType,
  ) : [PerformanceMetric] {
    arrayFilter(state.performanceMetrics, func(m : PerformanceMetric) : Bool {
      m.organismId == organismId and (
        switch metricType {
          case null true;
          case (?mt) m.metricType == mt;
        }
      )
    });
  };

  // ===================== Aggregation Functions =====================

  public func aggregateMetric(
    organismId : Text,
    metricType : MetricType,
    aggregationType : AggregationType,
    values : [Float],
    timeRange : TimeRange,
  ) : AggregatedMetric {
    let aggregatedValue = switch aggregationType {
      case (#Mean) mean(values);
      case (#Min) min(values);
      case (#Max) max(values);
      case (#Sum) {
        var s : Float = 0.0;
        for (v in values.vals()) s := s + v;
        s;
      };
      case (#Count) values.size().toFloat();
      case (#StdDev) stdDev(values);
      case (#Variance) variance(values);
      case (#Percentile95) percentile(values, 95.0);
      case (#Percentile99) percentile(values, 99.0);
      case (#Median) percentile(values, 50.0);
    };
    
    {
      organismId;
      metricType;
      aggregationType;
      value = aggregatedValue;
      sampleCount = values.size();
      timeRange;
    };
  };

  public func addAggregatedMetric(state : AnalyticsState, metric : AggregatedMetric) {
    state.aggregatedMetrics := arrayAppend(state.aggregatedMetrics, [metric]);
  };

  // ===================== Trend Analysis Functions =====================

  public func analyzeTrend(
    organismId : Text,
    metricType : MetricType,
    points : [TrendPoint],
  ) : TrendLine {
    let (slope, intercept, r2) = linearRegression(points);
    
    // Predict next value
    let lastTimestamp = if (points.size() > 0) points[points.size() - 1].timestamp else Time.now();
    let nextTimestamp = lastTimestamp + 3600_000_000_000; // 1 hour ahead
    let prediction = slope * nextTimestamp.toFloat() + intercept;
    
    // Confidence based on R-squared and sample size
    let sampleConfidence = Float.min(1.0, points.size().toFloat() / 24.0);
    let confidence = (r2 + sampleConfidence) / 2.0;
    
    {
      organismId;
      metricType;
      points;
      slope;
      intercept;
      r2;
      prediction;
      confidence;
    };
  };

  public func createTrendAnalysis(
    organismId : Text,
    coherencePoints : [TrendPoint],
    formaPoints : [TrendPoint],
    governancePoints : [TrendPoint],
    compoundPoints : [TrendPoint],
  ) : TrendAnalysis {
    let coherenceTrend = analyzeTrend(organismId, #Coherence, coherencePoints);
    let formaTrend = analyzeTrend(organismId, #FormaBalance, formaPoints);
    let governanceTrend = analyzeTrend(organismId, #GovernanceScore, governancePoints);
    let compoundTrend = analyzeTrend(organismId, #CompoundIndex, compoundPoints);
    
    // Calculate overall health
    let avgR2 = (coherenceTrend.r2 + formaTrend.r2 + governanceTrend.r2 + compoundTrend.r2) / 4.0;
    let avgSlope = (coherenceTrend.slope + governanceTrend.slope + compoundTrend.slope) / 3.0;
    
    let overallHealth = if (avgR2 > 0.8 and avgSlope > 0) "excellent"
                        else if (avgR2 > 0.6 and avgSlope >= 0) "good"
                        else if (avgR2 > 0.4) "fair"
                        else "needs_attention";
    
    // Generate recommendations
    var recommendations : [Text] = [];
    
    if (coherenceTrend.slope < 0) {
      recommendations := arrayAppend(recommendations, ["Coherence declining - consider increasing tick frequency"]);
    };
    if (formaTrend.slope < 0) {
      recommendations := arrayAppend(recommendations, ["FORMA balance declining - review mint rate optimization"]);
    };
    if (governanceTrend.slope < -0.001) {
      recommendations := arrayAppend(recommendations, ["Governance score unstable - recommend stability maintenance"]);
    };
    if (compoundTrend.r2 < 0.5) {
      recommendations := arrayAppend(recommendations, ["Compound index volatility high - consider longer tick intervals"]);
    };
    
    if (recommendations.size() == 0) {
      recommendations := ["All metrics performing optimally"];
    };
    
    {
      organismId;
      coherenceTrend;
      formaTrend;
      governanceTrend;
      compoundTrend;
      overallHealth;
      recommendations;
      analysisTimestamp = Time.now();
    };
  };

  public func addTrendAnalysis(state : AnalyticsState, analysis : TrendAnalysis) {
    // Remove old analysis for same organism
    state.trendAnalyses := arrayFilter(state.trendAnalyses, func(a : TrendAnalysis) : Bool {
      a.organismId != analysis.organismId
    });
    state.trendAnalyses := arrayAppend(state.trendAnalyses, [analysis]);
  };

  public func getTrendAnalysis(state : AnalyticsState, organismId : Text) : ?TrendAnalysis {
    for (a in state.trendAnalyses.vals()) {
      if (a.organismId == organismId) return ?a;
    };
    null;
  };

  // ===================== Activity Tracking Functions =====================

  public func logActivity(
    state : AnalyticsState,
    organismId : Text,
    activityType : ActivityType,
    details : Text,
    metadata : [(Text, Text)],
  ) : ActivityEvent {
    let event : ActivityEvent = {
      id = "event-" # Time.now().toText();
      organismId;
      activityType;
      details;
      timestamp = Time.now();
      metadata;
    };
    state.activityEvents := arrayAppend(state.activityEvents, [event]);
    event;
  };

  public func getActivityEvents(
    state : AnalyticsState,
    organismId : Text,
    limit : Nat,
  ) : [ActivityEvent] {
    var result : [ActivityEvent] = [];
    var count : Nat = 0;
    
    let size = state.activityEvents.size();
    var i = size;
    while (i > 0 and count < limit) {
      i -= 1;
      if (state.activityEvents[i].organismId == organismId) {
        result := arrayAppend(result, [state.activityEvents[i]]);
        count += 1;
      };
    };
    result;
  };

  public func getActivitySummary(
    state : AnalyticsState,
    organismId : Text,
    timeRange : TimeRange,
  ) : ActivitySummary {
    let events = arrayFilter(state.activityEvents, func(e : ActivityEvent) : Bool {
      e.organismId == organismId and e.timestamp >= timeRange.startTime and e.timestamp <= timeRange.endTime
    });
    
    // Count by type
    var tickCount : Nat = 0;
    var chatCount : Nat = 0;
    var transferCount : Nat = 0;
    var saleCount : Nat = 0;
    var artifactCount : Nat = 0;
    var driveCount : Nat = 0;
    var milestoneCount : Nat = 0;
    
    for (e in events.vals()) {
      switch e.activityType {
        case (#Tick) tickCount += 1;
        case (#Chat) chatCount += 1;
        case (#Transfer) transferCount += 1;
        case (#ListForSale) saleCount += 1;
        case (#WithdrawFromSale) saleCount += 1;
        case (#Purchase) saleCount += 1;
        case (#ArtifactCreated) artifactCount += 1;
        case (#DriveChange) driveCount += 1;
        case (#MilestoneReached) milestoneCount += 1;
      };
    };
    
    let eventsByType : [(ActivityType, Nat)] = [
      (#Tick, tickCount),
      (#Chat, chatCount),
      (#Transfer, transferCount),
      (#ListForSale, saleCount),
      (#ArtifactCreated, artifactCount),
      (#DriveChange, driveCount),
      (#MilestoneReached, milestoneCount),
    ];
    
    // Calculate average events per day
    let durationNanos = timeRange.endTime - timeRange.startTime;
    let durationDays = durationNanos.toFloat() / (86400_000_000_000.0);
    let avgPerDay = if (durationDays > 0) events.size().toFloat() / durationDays else 0.0;
    
    {
      organismId;
      totalEvents = events.size();
      eventsByType;
      mostActiveHour = 12; // Simplified - would need proper hour calculation
      mostActiveDay = "Monday"; // Simplified
      averageEventsPerDay = avgPerDay;
      timeRange;
    };
  };

  // ===================== Health Assessment Functions =====================

  public func assessOrganismHealth(
    organismId : Text,
    coherence : Float,
    governanceScore : Float,
    compoundIndex : Float,
    activationCount : Nat,
    formaBalance : Float,
  ) : OrganismHealth {
    var indicators : [HealthIndicator] = [];
    var totalScore : Float = 0.0;
    var criticalCount : Nat = 0;
    var warningCount : Nat = 0;
    
    // Coherence indicator
    let coherenceStatus = if (coherence >= 0.9) "healthy" else if (coherence >= 0.8) "warning" else "critical";
    if (coherenceStatus == "critical") criticalCount += 1;
    if (coherenceStatus == "warning") warningCount += 1;
    indicators := arrayAppend(indicators, [{
      name = "Coherence";
      value = coherence;
      status = coherenceStatus;
      threshold = 0.85;
      recommendation = if (coherenceStatus != "healthy") ?"Increase tick frequency to improve coherence" else null;
    }]);
    totalScore += coherence;
    
    // Governance indicator
    let govStatus = if (governanceScore >= 0.85) "healthy" else if (governanceScore >= 0.78) "warning" else "critical";
    if (govStatus == "critical") criticalCount += 1;
    if (govStatus == "warning") warningCount += 1;
    indicators := arrayAppend(indicators, [{
      name = "Governance Score";
      value = governanceScore;
      status = govStatus;
      threshold = 0.8;
      recommendation = if (govStatus != "healthy") ?"Governance below optimal - ensure regular activations" else null;
    }]);
    totalScore += governanceScore;
    
    // Compound Index indicator
    let compoundStatus = if (compoundIndex >= 0.85) "healthy" else if (compoundIndex >= 0.78) "warning" else "critical";
    if (compoundStatus == "critical") criticalCount += 1;
    if (compoundStatus == "warning") warningCount += 1;
    indicators := arrayAppend(indicators, [{
      name = "Compound Index";
      value = compoundIndex;
      status = compoundStatus;
      threshold = 0.8;
      recommendation = if (compoundStatus != "healthy") ?"Compound index suboptimal - coherence and governance need attention" else null;
    }]);
    totalScore += compoundIndex;
    
    // Activation indicator
    let activationThreshold : Nat = 100;
    let activationScore = Float.min(1.0, activationCount.toFloat() / activationThreshold.toFloat());
    let activationStatus = if (activationCount >= activationThreshold) "healthy" else if (activationCount >= 50) "warning" else "critical";
    if (activationStatus == "critical") criticalCount += 1;
    if (activationStatus == "warning") warningCount += 1;
    indicators := arrayAppend(indicators, [{
      name = "Activation Maturity";
      value = activationScore;
      status = activationStatus;
      threshold = 1.0;
      recommendation = if (activationStatus != "healthy") ?"Continue activating organism to build streak bonus" else null;
    }]);
    totalScore += activationScore;
    
    // FORMA indicator
    let formaThreshold : Float = 500.0;
    let formaScore = Float.min(1.0, formaBalance / formaThreshold);
    let formaStatus = if (formaBalance >= formaThreshold) "healthy" else if (formaBalance >= 200.0) "warning" else "critical";
    if (formaStatus == "critical") criticalCount += 1;
    if (formaStatus == "warning") warningCount += 1;
    indicators := arrayAppend(indicators, [{
      name = "FORMA Balance";
      value = formaScore;
      status = formaStatus;
      threshold = 1.0;
      recommendation = if (formaStatus != "healthy") ?"FORMA balance low - maintain regular activations" else null;
    }]);
    totalScore += formaScore;
    
    // Calculate overall score (0-100)
    let overallScore = (totalScore / 5.0) * 100.0;
    
    let status = if (criticalCount > 0) "critical" 
                 else if (warningCount > 1) "warning"
                 else if (warningCount > 0) "fair"
                 else "healthy";
    
    {
      organismId;
      overallScore;
      status;
      indicators;
      lastChecked = Time.now();
      nextCheckRecommended = Time.now() + 3600_000_000_000; // 1 hour
    };
  };

  public func addHealthReport(state : AnalyticsState, report : OrganismHealth) {
    // Remove old report for same organism
    state.healthReports := arrayFilter(state.healthReports, func(h : OrganismHealth) : Bool {
      h.organismId != report.organismId
    });
    state.healthReports := arrayAppend(state.healthReports, [report]);
  };

  public func getHealthReport(state : AnalyticsState, organismId : Text) : ?OrganismHealth {
    for (h in state.healthReports.vals()) {
      if (h.organismId == organismId) return ?h;
    };
    null;
  };

  // ===================== Leaderboard Functions =====================

  public func createLeaderboard(
    entries : [LeaderboardEntry],
    metricType : MetricType,
    timeWindow : TimeWindow,
    totalOrganisms : Nat,
  ) : Leaderboard {
    {
      entries;
      metricType;
      timeWindow;
      totalOrganisms;
      updatedAt = Time.now();
    };
  };

  public func updateLeaderboard(state : AnalyticsState, leaderboard : Leaderboard) {
    // Remove old leaderboard for same metric/window
    state.leaderboards := arrayFilter(state.leaderboards, func(l : Leaderboard) : Bool {
      not (l.metricType == leaderboard.metricType and l.timeWindow == leaderboard.timeWindow)
    });
    state.leaderboards := arrayAppend(state.leaderboards, [leaderboard]);
  };

  public func getLeaderboard(
    state : AnalyticsState, 
    metricType : MetricType, 
    timeWindow : TimeWindow
  ) : ?Leaderboard {
    for (l in state.leaderboards.vals()) {
      if (l.metricType == metricType and l.timeWindow == timeWindow) return ?l;
    };
    null;
  };

  // ===================== Cleanup Functions =====================

  public func pruneOldSnapshots(state : AnalyticsState, maxAge : Int) {
    let cutoff = Time.now() - maxAge;
    state.snapshots := arrayFilter(state.snapshots, func(s : OrganismSnapshot) : Bool {
      s.snapshotAt >= cutoff
    });
  };

  public func pruneOldEvents(state : AnalyticsState, maxAge : Int) {
    let cutoff = Time.now() - maxAge;
    state.activityEvents := arrayFilter(state.activityEvents, func(e : ActivityEvent) : Bool {
      e.timestamp >= cutoff
    });
  };

  public func pruneOldMetrics(state : AnalyticsState, maxAge : Int) {
    let cutoff = Time.now() - maxAge;
    state.performanceMetrics := arrayFilter(state.performanceMetrics, func(m : PerformanceMetric) : Bool {
      m.timestamp >= cutoff
    });
  };

};
