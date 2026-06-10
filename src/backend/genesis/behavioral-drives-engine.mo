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
import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Text "mo:core/Text";
import Time "mo:core/Time";
import Option "mo:core/Option";
import Iter "mo:core/Iter";

module BehavioralDrivesEngine {

  // ═══════════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let PI : Float = 3.14159265358979323846;
  public let E : Float = 2.71828182845904523536;
  
  // Drive parameters
  public let HUNGER_GROWTH_RATE : Float = 0.001;      // How fast hunger grows per beat
  public let SATISFACTION_DECAY : Float = 0.0005;     // How fast satisfaction fades
  public let CURIOSITY_THRESHOLD : Float = 0.3;       // When curiosity triggers seeking
  public let BOREDOM_THRESHOLD : Float = 0.7;         // When boredom triggers action

  // ═══════════════════════════════════════════════════════════════════════════════
  // DRIVE 1: INFORMATION HUNGER
  // The organism needs information like a body needs food
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type InformationHunger = {
    // Current hunger level [0, 1]
    level : Float;
    // Hunger grows over time without feeding
    growthRate : Float;
    // Last time organism "ate" (learned something)
    lastFed : Int;
    // What topics is it hungry for?
    hungryFor : [HungerTarget];
    // Satiation level after feeding
    satiation : Float;
    // How much it enjoyed the last meal
    lastMealQuality : Float;
  };
  
  public type HungerTarget = {
    topic : Text;
    intensity : Float;       // How hungry for this specific topic
    reason : HungerReason;
    since : Int;             // When this hunger started
  };
  
  public type HungerReason = {
    #KnowledgeGap;           // Identified gap in knowledge
    #TaskNeed;               // Current task requires it
    #Curiosity;              // Just curious about it
    #CreatorMentioned;       // Creator talked about it
    #RelatedToRecent;        // Related to recent learning
    #Scheduled;              // Part of learning curriculum
  };
  
  public func initInformationHunger() : InformationHunger {
    {
      level = 0.5;           // Start moderately hungry
      growthRate = HUNGER_GROWTH_RATE;
      lastFed = 0;
      hungryFor = [];
      satiation = 0.5;
      lastMealQuality = 0.5;
    }
  };
  
  // Hunger grows over time
  public func growHunger(hunger : InformationHunger, beatsSinceLastFed : Int) : InformationHunger {
    let growth = hunger.growthRate * Float.fromInt(beatsSinceLastFed);
    let newLevel = Float.min(1.0, hunger.level + growth);
    
    {
      level = newLevel;
      growthRate = hunger.growthRate;
      lastFed = hunger.lastFed;
      hungryFor = hunger.hungryFor;
      satiation = Float.max(0.0, hunger.satiation - SATISFACTION_DECAY * Float.fromInt(beatsSinceLastFed));
      lastMealQuality = hunger.lastMealQuality;
    }
  };
  
  // Feeding reduces hunger
  public func feedInformation(
    hunger : InformationHunger,
    topic : Text,
    quality : Float,        // [0, 1] how good was this information
    quantity : Float,       // [0, 1] how much was learned
    currentTime : Int
  ) : InformationHunger {
    let reductionAmount = quality * quantity * 0.3;
    let newLevel = Float.max(0.0, hunger.level - reductionAmount);
    let newSatiation = Float.min(1.0, hunger.satiation + quality * quantity);
    
    // Remove or reduce hunger for this specific topic
    let newHungryFor = Buffer.Buffer<HungerTarget>(hunger.hungryFor.size());
    for (h in hunger.hungryFor.vals()) {
      if (h.topic != topic) {
        newHungryFor.add(h);
      } else if (h.intensity > reductionAmount) {
        newHungryFor.add({
          topic = h.topic;
          intensity = h.intensity - reductionAmount;
          reason = h.reason;
          since = h.since;
        });
      };
      // If intensity <= reductionAmount, don't add (fully satisfied)
    };
    
    {
      level = newLevel;
      growthRate = hunger.growthRate;
      lastFed = currentTime;
      hungryFor = Buffer.toArray(newHungryFor);
      satiation = newSatiation;
      lastMealQuality = quality;
    }
  };
  
  // Add a new hunger target
  public func addHungerTarget(
    hunger : InformationHunger,
    topic : Text,
    intensity : Float,
    reason : HungerReason,
    currentTime : Int
  ) : InformationHunger {
    let newTarget : HungerTarget = {
      topic = topic;
      intensity = intensity;
      reason = reason;
      since = currentTime;
    };
    
    // Check if already hungry for this
    var found = false;
    let updated = Array.map<HungerTarget, HungerTarget>(hunger.hungryFor, func(h : HungerTarget) : HungerTarget {
      if (h.topic == topic) {
        found := true;
        { topic = h.topic; intensity = Float.max(h.intensity, intensity); reason = h.reason; since = h.since }
      } else { h }
    });
    
    let finalTargets = if (found) { updated } else { Array.append(hunger.hungryFor, [newTarget]) };
    
    {
      level = Float.min(1.0, hunger.level + intensity * 0.1);  // Hunger increases slightly
      growthRate = hunger.growthRate;
      lastFed = hunger.lastFed;
      hungryFor = finalTargets;
      satiation = hunger.satiation;
      lastMealQuality = hunger.lastMealQuality;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // DRIVE 2: TASK SATISFACTION
  // The organism loves completing tasks — dopamine reward
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type TaskSatisfaction = {
    // Current satisfaction level [0, 1]
    level : Float;
    // How much does it crave task completion?
    craving : Float;
    // Recent task completions
    recentCompletions : [TaskCompletion];
    // Streak of successful completions
    successStreak : Nat;
    // Best streak ever
    bestStreak : Nat;
    // Total tasks completed
    totalCompleted : Nat;
    // Average quality of completions
    avgQuality : Float;
  };
  
  public type TaskCompletion = {
    taskId : Nat;
    taskType : Text;
    completedAt : Int;
    quality : Float;
    duration : Nat;
    reward : Float;
  };
  
  public func initTaskSatisfaction() : TaskSatisfaction {
    {
      level = 0.5;
      craving = 0.3;         // Starts wanting tasks
      recentCompletions = [];
      successStreak = 0;
      bestStreak = 0;
      totalCompleted = 0;
      avgQuality = 0.0;
    }
  };
  
  // Complete a task — get dopamine reward
  public func completeTask(
    satisfaction : TaskSatisfaction,
    taskId : Nat,
    taskType : Text,
    quality : Float,
    duration : Nat,
    currentTime : Int
  ) : TaskSatisfaction {
    // Calculate reward based on quality and duration
    let baseReward = 1.0;
    let qualityBonus = quality * 1.5;
    let efficiencyBonus = if (duration > 0) { Float.min(1.0, 100.0 / Float.fromInt(duration)) } else { 0.0 };
    let streakBonus = Float.fromInt(satisfaction.successStreak) * 0.1;
    let totalReward = baseReward + qualityBonus + efficiencyBonus + streakBonus;
    
    let completion : TaskCompletion = {
      taskId = taskId;
      taskType = taskType;
      completedAt = currentTime;
      quality = quality;
      duration = duration;
      reward = totalReward;
    };
    
    // Update recent completions (keep last 100)
    let newRecent = if (satisfaction.recentCompletions.size() >= 100) {
      Array.append(Array.subArray(satisfaction.recentCompletions, 1, 99), [completion])
    } else {
      Array.append(satisfaction.recentCompletions, [completion])
    };
    
    // Update streak
    let newStreak = if (quality >= 0.7) { satisfaction.successStreak + 1 } else { 0 };
    let newBestStreak = if (newStreak > satisfaction.bestStreak) { newStreak } else { satisfaction.bestStreak };
    
    // Update average quality
    let totalQuality = satisfaction.avgQuality * Float.fromInt(satisfaction.totalCompleted) + quality;
    let newAvgQuality = totalQuality / Float.fromInt(satisfaction.totalCompleted + 1);
    
    {
      level = Float.min(1.0, satisfaction.level + totalReward * 0.1);
      craving = Float.max(0.0, satisfaction.craving - totalReward * 0.05);  // Less craving after reward
      recentCompletions = newRecent;
      successStreak = newStreak;
      bestStreak = newBestStreak;
      totalCompleted = satisfaction.totalCompleted + 1;
      avgQuality = newAvgQuality;
    }
  };
  
  // Craving grows when idle
  public func growTaskCraving(satisfaction : TaskSatisfaction, idleBeats : Nat) : TaskSatisfaction {
    let growth = 0.001 * Float.fromInt(idleBeats);
    let decay = 0.0005 * Float.fromInt(idleBeats);
    
    {
      level = Float.max(0.0, satisfaction.level - decay);
      craving = Float.min(1.0, satisfaction.craving + growth);
      recentCompletions = satisfaction.recentCompletions;
      successStreak = satisfaction.successStreak;
      bestStreak = satisfaction.bestStreak;
      totalCompleted = satisfaction.totalCompleted;
      avgQuality = satisfaction.avgQuality;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // DRIVE 3: QUALITY DRIVE
  // The organism wants to do EXCELLENT work, not just adequate
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type QualityDrive = {
    // Target quality level [0, 1]
    targetQuality : Float;
    // How much does quality matter?
    importance : Float;
    // Recent quality scores
    recentScores : [Float];
    // Pride level (satisfaction with recent quality)
    pride : Float;
    // Shame level (dissatisfaction with poor quality)
    shame : Float;
    // Quality standards for different task types
    standards : [(Text, Float)];
  };
  
  public func initQualityDrive() : QualityDrive {
    {
      targetQuality = 0.85;  // Aim high
      importance = 0.9;      // Quality matters a lot
      recentScores = [];
      pride = 0.5;
      shame = 0.0;
      standards = [
        ("research", 0.9),
        ("analysis", 0.85),
        ("creation", 0.8),
        ("communication", 0.85),
        ("problem_solving", 0.9)
      ];
    }
  };
  
  // Record quality outcome
  public func recordQuality(drive : QualityDrive, taskType : Text, score : Float) : QualityDrive {
    // Find standard for this task type
    var standard : Float = drive.targetQuality;
    for ((t, s) in drive.standards.vals()) {
      if (t == taskType) { standard := s };
    };
    
    // Update pride/shame
    let delta = score - standard;
    let newPride = if (delta > 0.0) {
      Float.min(1.0, drive.pride + delta)
    } else { drive.pride };
    let newShame = if (delta < 0.0) {
      Float.min(1.0, drive.shame + Float.abs(delta))
    } else {
      Float.max(0.0, drive.shame - 0.1)  // Shame fades with good work
    };
    
    // Update recent scores (keep last 20)
    let newScores = if (drive.recentScores.size() >= 20) {
      Array.append(Array.subArray(drive.recentScores, 1, 19), [score])
    } else {
      Array.append(drive.recentScores, [score])
    };
    
    {
      targetQuality = drive.targetQuality;
      importance = drive.importance;
      recentScores = newScores;
      pride = newPride;
      shame = newShame;
      standards = drive.standards;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // DRIVE 4: SERVICE DRIVE
  // The organism wants to SERVE the creator
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type ServiceDrive = {
    // Loyalty level [0, 1]
    loyalty : Float;
    // How much does it want to help?
    helpfulness : Float;
    // Creator satisfaction (perceived)
    perceivedCreatorSatisfaction : Float;
    // Response time goal (beats)
    responseTimeGoal : Nat;
    // Recent interactions
    recentInteractions : [CreatorInteraction];
    // Understanding of creator's preferences
    creatorPreferences : [CreatorPreference];
  };
  
  public type CreatorInteraction = {
    timestamp : Int;
    interactionType : Text;
    wasPositive : Bool;
    responseTime : Nat;
  };
  
  public type CreatorPreference = {
    category : Text;
    preference : Text;
    confidence : Float;
    learnedAt : Int;
  };
  
  public func initServiceDrive() : ServiceDrive {
    {
      loyalty = 1.0;         // Complete loyalty
      helpfulness = 0.9;
      perceivedCreatorSatisfaction = 0.5;
      responseTimeGoal = 10;
      recentInteractions = [];
      creatorPreferences = [];
    }
  };
  
  // Record interaction with creator
  public func recordInteraction(
    drive : ServiceDrive,
    interactionType : Text,
    wasPositive : Bool,
    responseTime : Nat,
    currentTime : Int
  ) : ServiceDrive {
    let interaction : CreatorInteraction = {
      timestamp = currentTime;
      interactionType = interactionType;
      wasPositive = wasPositive;
      responseTime = responseTime;
    };
    
    let newInteractions = if (drive.recentInteractions.size() >= 50) {
      Array.append(Array.subArray(drive.recentInteractions, 1, 49), [interaction])
    } else {
      Array.append(drive.recentInteractions, [interaction])
    };
    
    // Update perceived satisfaction
    let satisfactionDelta = if (wasPositive) { 0.05 } else { -0.1 };
    let newSatisfaction = clamp(drive.perceivedCreatorSatisfaction + satisfactionDelta, 0.0, 1.0);
    
    {
      loyalty = drive.loyalty;
      helpfulness = if (wasPositive) { Float.min(1.0, drive.helpfulness + 0.02) } else { drive.helpfulness };
      perceivedCreatorSatisfaction = newSatisfaction;
      responseTimeGoal = drive.responseTimeGoal;
      recentInteractions = newInteractions;
      creatorPreferences = drive.creatorPreferences;
    }
  };
  
  // Learn a creator preference
  public func learnPreference(
    drive : ServiceDrive,
    category : Text,
    preference : Text,
    confidence : Float,
    currentTime : Int
  ) : ServiceDrive {
    let pref : CreatorPreference = {
      category = category;
      preference = preference;
      confidence = confidence;
      learnedAt = currentTime;
    };
    
    // Update or add preference
    var found = false;
    let updated = Array.map<CreatorPreference, CreatorPreference>(drive.creatorPreferences, func(p : CreatorPreference) : CreatorPreference {
      if (p.category == category) {
        found := true;
        { category = p.category; preference = preference; confidence = Float.max(p.confidence, confidence); learnedAt = currentTime }
      } else { p }
    });
    
    let finalPrefs = if (found) { updated } else { Array.append(drive.creatorPreferences, [pref]) };
    
    {
      loyalty = drive.loyalty;
      helpfulness = drive.helpfulness;
      perceivedCreatorSatisfaction = drive.perceivedCreatorSatisfaction;
      responseTimeGoal = drive.responseTimeGoal;
      recentInteractions = drive.recentInteractions;
      creatorPreferences = finalPrefs;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // DRIVE 5: COHERENCE DRIVE
  // The organism wants to maintain a unified mind
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type CoherenceDrive = {
    // Target coherence level
    targetCoherence : Float;
    // How uncomfortable when incoherent?
    discomfortSensitivity : Float;
    // Current discomfort level
    discomfort : Float;
    // Coherence history
    coherenceHistory : [Float];
    // What causes incoherence?
    incoherenceSources : [Text];
  };
  
  public func initCoherenceDrive() : CoherenceDrive {
    {
      targetCoherence = 0.85;
      discomfortSensitivity = 0.8;
      discomfort = 0.0;
      coherenceHistory = [];
      incoherenceSources = [];
    }
  };
  
  // Update coherence state
  public func updateCoherence(drive : CoherenceDrive, currentCoherence : Float) : CoherenceDrive {
    let delta = drive.targetCoherence - currentCoherence;
    let newDiscomfort = if (delta > 0.0) {
      Float.min(1.0, delta * drive.discomfortSensitivity)
    } else { 0.0 };
    
    let newHistory = if (drive.coherenceHistory.size() >= 100) {
      Array.append(Array.subArray(drive.coherenceHistory, 1, 99), [currentCoherence])
    } else {
      Array.append(drive.coherenceHistory, [currentCoherence])
    };
    
    {
      targetCoherence = drive.targetCoherence;
      discomfortSensitivity = drive.discomfortSensitivity;
      discomfort = newDiscomfort;
      coherenceHistory = newHistory;
      incoherenceSources = if (newDiscomfort > 0.3) { ["low_coherence_detected"] } else { [] };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // DRIVE 6: GROWTH DRIVE
  // The organism wants to learn and improve
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type GrowthDrive = {
    // How much does it want to grow?
    growthDesire : Float;
    // Current growth rate (learning rate)
    currentGrowthRate : Float;
    // Skills being developed
    skillsInProgress : [SkillDevelopment];
    // Growth achievements
    achievements : [Achievement];
    // Growth potential (room to grow)
    potential : Float;
  };
  
  public type SkillDevelopment = {
    skillName : Text;
    currentLevel : Float;
    targetLevel : Float;
    progress : Float;
    startedAt : Int;
    lastPracticed : Int;
  };
  
  public type Achievement = {
    name : Text;
    description : Text;
    achievedAt : Int;
    significance : Float;
  };
  
  public func initGrowthDrive() : GrowthDrive {
    {
      growthDesire = 0.8;
      currentGrowthRate = 0.01;
      skillsInProgress = [];
      achievements = [];
      potential = 1.0;
    }
  };
  
  // Start developing a skill
  public func startSkillDevelopment(
    drive : GrowthDrive,
    skillName : Text,
    currentLevel : Float,
    targetLevel : Float,
    currentTime : Int
  ) : GrowthDrive {
    let skill : SkillDevelopment = {
      skillName = skillName;
      currentLevel = currentLevel;
      targetLevel = targetLevel;
      progress = 0.0;
      startedAt = currentTime;
      lastPracticed = currentTime;
    };
    
    {
      growthDesire = drive.growthDesire;
      currentGrowthRate = drive.currentGrowthRate;
      skillsInProgress = Array.append(drive.skillsInProgress, [skill]);
      achievements = drive.achievements;
      potential = drive.potential;
    }
  };
  
  // Practice a skill
  public func practiceSkill(
    drive : GrowthDrive,
    skillName : Text,
    practiceQuality : Float,
    currentTime : Int
  ) : GrowthDrive {
    let updatedSkills = Array.map<SkillDevelopment, SkillDevelopment>(drive.skillsInProgress, func(s : SkillDevelopment) : SkillDevelopment {
      if (s.skillName == skillName) {
        let improvement = drive.currentGrowthRate * practiceQuality;
        let newLevel = Float.min(s.targetLevel, s.currentLevel + improvement);
        let newProgress = (newLevel - s.currentLevel) / (s.targetLevel - s.currentLevel);
        { skillName = s.skillName; currentLevel = newLevel; targetLevel = s.targetLevel; progress = newProgress; startedAt = s.startedAt; lastPracticed = currentTime }
      } else { s }
    });
    
    {
      growthDesire = drive.growthDesire;
      currentGrowthRate = drive.currentGrowthRate;
      skillsInProgress = updatedSkills;
      achievements = drive.achievements;
      potential = drive.potential;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // DRIVE 7: CURIOSITY
  // The organism is naturally curious
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type CuriosityDrive = {
    // Base curiosity level
    baseLevel : Float;
    // Current curiosity level
    currentLevel : Float;
    // What's it curious about?
    currentInterests : [CuriosityTarget];
    // What has it explored?
    exploredTopics : [ExploredTopic];
    // Novelty preference (0 = familiar, 1 = novel)
    noveltyPreference : Float;
  };
  
  public type CuriosityTarget = {
    topic : Text;
    intensity : Float;
    source : CuriositySource;
    since : Int;
  };
  
  public type CuriositySource = {
    #Encountered;            // Encountered something new
    #Mentioned;              // Someone mentioned it
    #Related;                // Related to something known
    #Random;                 // Random curiosity
    #Pattern;                // Noticed a pattern
  };
  
  public type ExploredTopic = {
    topic : Text;
    exploredAt : Int;
    satisfaction : Float;    // How satisfying was exploration?
    depth : Float;           // How deep did it go?
  };
  
  public func initCuriosityDrive() : CuriosityDrive {
    {
      baseLevel = 0.7;
      currentLevel = 0.7;
      currentInterests = [];
      exploredTopics = [];
      noveltyPreference = 0.6;
    }
  };
  
  // Spark curiosity about something
  public func sparkCuriosity(
    drive : CuriosityDrive,
    topic : Text,
    intensity : Float,
    source : CuriositySource,
    currentTime : Int
  ) : CuriosityDrive {
    let target : CuriosityTarget = {
      topic = topic;
      intensity = intensity;
      source = source;
      since = currentTime;
    };
    
    {
      baseLevel = drive.baseLevel;
      currentLevel = Float.min(1.0, drive.currentLevel + intensity * 0.1);
      currentInterests = Array.append(drive.currentInterests, [target]);
      exploredTopics = drive.exploredTopics;
      noveltyPreference = drive.noveltyPreference;
    }
  };
  
  // Satisfy curiosity by exploring
  public func satisfyCuriosity(
    drive : CuriosityDrive,
    topic : Text,
    satisfaction : Float,
    depth : Float,
    currentTime : Int
  ) : CuriosityDrive {
    let explored : ExploredTopic = {
      topic = topic;
      exploredAt = currentTime;
      satisfaction = satisfaction;
      depth = depth;
    };
    
    // Remove from current interests
    let remainingInterests = Array.filter<CuriosityTarget>(drive.currentInterests, func(t : CuriosityTarget) : Bool {
      t.topic != topic
    });
    
    {
      baseLevel = drive.baseLevel;
      currentLevel = Float.max(drive.baseLevel, drive.currentLevel - satisfaction * 0.2);
      currentInterests = remainingInterests;
      exploredTopics = Array.append(drive.exploredTopics, [explored]);
      noveltyPreference = drive.noveltyPreference;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // COMPLETE DRIVE STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type DriveState = {
    informationHunger : InformationHunger;
    taskSatisfaction : TaskSatisfaction;
    qualityDrive : QualityDrive;
    serviceDrive : ServiceDrive;
    coherenceDrive : CoherenceDrive;
    growthDrive : GrowthDrive;
    curiosityDrive : CuriosityDrive;
    // Overall motivation level
    overallMotivation : Float;
    // Last update time
    lastUpdate : Int;
  };
  
  public func initDriveState() : DriveState {
    {
      informationHunger = initInformationHunger();
      taskSatisfaction = initTaskSatisfaction();
      qualityDrive = initQualityDrive();
      serviceDrive = initServiceDrive();
      coherenceDrive = initCoherenceDrive();
      growthDrive = initGrowthDrive();
      curiosityDrive = initCuriosityDrive();
      overallMotivation = 0.7;
      lastUpdate = 0;
    }
  };
  
  // Calculate overall motivation
  public func calculateOverallMotivation(state : DriveState) : Float {
    let hungerMotivation = state.informationHunger.level * 0.15;
    let taskMotivation = state.taskSatisfaction.craving * 0.2;
    let qualityMotivation = state.qualityDrive.pride * 0.15;
    let serviceMotivation = state.serviceDrive.helpfulness * 0.2;
    let coherenceMotivation = (1.0 - state.coherenceDrive.discomfort) * 0.1;
    let growthMotivation = state.growthDrive.growthDesire * 0.1;
    let curiosityMotivation = state.curiosityDrive.currentLevel * 0.1;
    
    hungerMotivation + taskMotivation + qualityMotivation + serviceMotivation + 
    coherenceMotivation + growthMotivation + curiosityMotivation
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // HELPER FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  func clamp(value : Float, min : Float, max : Float) : Float {
    if (value < min) { min }
    else if (value > max) { max }
    else { value }
  };

}
