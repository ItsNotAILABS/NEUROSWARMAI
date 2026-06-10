// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  UNIFIED EMOTIONAL ARCHITECTURE ENGINE                                                                    ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║  Framework: Medina Doctrine                                                                               ║
// ║                                                                                                           ║
// ║  This module implements comprehensive emotional processing:                                               ║
// ║  • Basic emotions (Ekman's 6 + extensions)                                                                ║
// ║  • Dimensional models (valence, arousal, dominance)                                                       ║
// ║  • Appraisal theory (primary/secondary appraisal)                                                         ║
// ║  • Emotional regulation strategies                                                                        ║
// ║  • Mood states vs emotional episodes                                                                      ║
// ║  • Emotional contagion and empathy                                                                        ║
// ║  • Somatic marker hypothesis integration                                                                  ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
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
  let SOVEREIGN_FLOOR : Float = 0.75;
  let BASELINE_AROUSAL : Float = 0.5;
  let BASELINE_VALENCE : Float = 0.6; // Slight positive bias
  
  // Emotion decay constants
  let FAST_DECAY : Float = 0.1;       // Strong emotions decay fast
  let SLOW_DECAY : Float = 0.01;      // Moods decay slowly
  let MOOD_INERTIA : Float = 0.95;    // Moods resist change
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // TYPE DEFINITIONS - BASIC EMOTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Basic emotion (Ekman + extensions)
  public type BasicEmotion = {
    emotionType : EmotionType;
    intensity : Float;               // 0-1 intensity
    duration : Int;                  // How long active
    peakTime : Int;                  // When it peaked
    decayRate : Float;
    associatedTrigger : ?Text;
    somaticMarkers : [Float];        // Body signals
  };
  
  public type EmotionType = {
    #Joy;
    #Sadness;
    #Anger;
    #Fear;
    #Surprise;
    #Disgust;
    #Contempt;                        // Extended
    #Trust;                           // Plutchik's addition
    #Anticipation;                    // Plutchik's addition
    #Interest;                        // Extended
    #Shame;                           // Self-conscious
    #Guilt;                           // Self-conscious
    #Pride;                           // Self-conscious
    #Embarrassment;                   // Self-conscious
    #Envy;                            // Social
    #Jealousy;                        // Social
    #Love;                            // Complex
    #Awe;                             // Complex
  };
  
  /// Emotion blend (mixed emotions)
  public type EmotionBlend = {
    components : [(EmotionType, Float)];
    dominantEmotion : EmotionType;
    blendComplexity : Float;
    ambivalence : Float;             // Simultaneous positive/negative
    timestamp : Int;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // TYPE DEFINITIONS - DIMENSIONAL MODEL
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// PAD (Pleasure-Arousal-Dominance) state
  public type PADState = {
    var pleasure : Float;            // -1 (displeasure) to +1 (pleasure)
    var arousal : Float;             // 0 (calm) to 1 (excited)
    var dominance : Float;           // 0 (submissive) to 1 (dominant)
    var timestamp : Int;
  };
  
  /// Core affect (Russell's circumplex)
  public type CoreAffect = {
    var valence : Float;             // -1 to +1
    var activation : Float;          // 0 to 1
    var angle : Float;               // Position on circumplex (radians)
    var distance : Float;            // Distance from center (intensity)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // TYPE DEFINITIONS - APPRAISAL
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Appraisal state (Lazarus)
  public type AppraisalState = {
    // Primary appraisal (relevance)
    var goalRelevance : Float;       // How relevant to goals
    var goalCongruence : Float;      // Helps vs hinders goals
    var selfRelevance : Float;       // Personal involvement
    
    // Secondary appraisal (coping)
    var copingPotential : Float;     // Can I deal with it?
    var futureExpectation : Float;   // Will it get better/worse?
    var agentResponsibility : Text;  // Who/what caused it?
    
    // Outcome
    var appraisalPattern : AppraisalPattern;
  };
  
  public type AppraisalPattern = {
    #Challenge;                       // High relevance, congruent, high coping
    #Threat;                          // High relevance, incongruent, low coping
    #Loss;                            // High relevance, incongruent, past
    #Benefit;                         // High relevance, congruent, present
    #Harm;                            // High relevance, incongruent, present
    #Neutral;                         // Low relevance
  };
  
  /// Stimulus appraisal
  public type StimulusAppraisal = {
    stimulusId : Nat;
    novelty : Float;                 // Is it new?
    pleasantness : Float;            // Is it pleasant?
    goalRelevance : Float;
    copability : Float;
    normativeSignificance : Float;   // Social norms
    resultingEmotion : ?EmotionType;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // TYPE DEFINITIONS - MOOD
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Mood state (longer-term)
  public type MoodState = {
    var currentMood : MoodType;
    var moodIntensity : Float;
    var moodStability : Float;       // How stable is mood
    var moodDuration : Int;
    var moodInfluences : [MoodInfluence];
    var underlyingValence : Float;
    var underlyingArousal : Float;
  };
  
  public type MoodType = {
    #Positive;
    #Negative;
    #Neutral;
    #Mixed;
    #Anxious;
    #Depressed;
    #Irritable;
    #Elevated;
    #Calm;
    #Energetic;
  };
  
  public type MoodInfluence = {
    source : Text;
    strength : Float;
    valenceEffect : Float;
    arousalEffect : Float;
    timestamp : Int;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // TYPE DEFINITIONS - REGULATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Emotion regulation state
  public type RegulationState = {
    var activeStrategies : Buffer.Buffer<RegulationStrategy>;
    var regulationCapacity : Float;
    var regulationEffort : Float;
    var suppressionLevel : Float;
    var reappraisalSuccess : Float;
    var expressionLevel : Float;
  };
  
  public type RegulationStrategy = {
    strategyType : StrategyType;
    target : EmotionType;
    intensity : Float;
    effectiveness : Float;
    timestamp : Int;
    duration : Int;
  };
  
  public type StrategyType = {
    #SituationSelection;              // Avoid/approach situations
    #SituationModification;           // Change the situation
    #AttentionalDeployment;           // Redirect attention
    #CognitiveChange;                 // Reappraisal
    #ResponseModulation;              // Suppress/enhance expression
    #Acceptance;                      // Non-judgmental awareness
    #Distraction;                     // Focus elsewhere
    #Rumination;                      // (Maladaptive)
    #Suppression;                     // (Can be costly)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // TYPE DEFINITIONS - SOCIAL EMOTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Emotional contagion
  public type EmotionalContagion = {
    var susceptibility : Float;      // How easily affected
    var currentContagion : ?EmotionType;
    var contagionSource : ?Nat;      // Agent ID
    var contagionStrength : Float;
    var mimicryLevel : Float;
  };
  
  /// Empathy state
  public type EmpathyState = {
    var affectiveEmpathy : Float;    // Feeling with
    var cognitiveEmpathy : Float;    // Understanding others
    var empathicConcern : Float;     // Motivation to help
    var personalDistress : Float;    // Self-oriented distress
    var perspectiveTaking : Float;
    var currentTarget : ?Nat;        // Who we're empathizing with
    var targetEmotionalState : ?PADState;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // TYPE DEFINITIONS - SOMATIC MARKERS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Somatic marker (Damasio)
  public type SomaticMarker = {
    markerId : Nat;
    associatedStimulus : [Float];    // What triggers it
    bodyState : BodyReaction;
    valence : Float;                 // Good/bad signal
    intensity : Float;
    isConscious : Bool;              // Gut feeling vs conscious
    decisionInfluence : Float;
    timestamp : Int;
  };
  
  public type BodyReaction = {
    heartRateChange : Float;
    skinConductance : Float;
    muscularTension : Float;
    respirationChange : Float;
    facialExpression : FacialExpression;
    posturalChange : Float;
    gutFeeling : Float;              // Interoceptive signal
  };
  
  public type FacialExpression = {
    #Neutral;
    #Smile;
    #Frown;
    #Raised_Eyebrows;
    #Wide_Eyes;
    #Narrowed_Eyes;
    #Wrinkled_Nose;
    #Compressed_Lips;
    #Open_Mouth;
    #Asymmetric_Smile;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // MAIN STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type EmotionalArchitectureState = {
    // Basic emotions
    var activeEmotions : Buffer.Buffer<BasicEmotion>;
    var emotionHistory : Buffer.Buffer<EmotionBlend>;
    
    // Dimensional
    var padState : PADState;
    var coreAffect : CoreAffect;
    
    // Appraisal
    var appraisalState : AppraisalState;
    var recentAppraisals : Buffer.Buffer<StimulusAppraisal>;
    
    // Mood
    var moodState : MoodState;
    
    // Regulation
    var regulationState : RegulationState;
    
    // Social
    var emotionalContagion : EmotionalContagion;
    var empathyState : EmpathyState;
    
    // Somatic
    var somaticMarkers : Buffer.Buffer<SomaticMarker>;
    var currentBodyState : BodyReaction;
    
    // Integration
    var emotionalCoherence : Float;
    var emotionalComplexity : Float;
    var emotionalGranularity : Float;
    
    // Temporal
    var tickCount : Nat;
    var lastTickTime : Int;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Initialize emotional architecture
  public func initEmotionalArchitecture() : EmotionalArchitectureState {
    let now = Time.now();
    
    {
      var activeEmotions = Buffer.Buffer<BasicEmotion>(16);
      var emotionHistory = Buffer.Buffer<EmotionBlend>(1024);
      var padState = initPADState(now);
      var coreAffect = initCoreAffect();
      var appraisalState = initAppraisalState();
      var recentAppraisals = Buffer.Buffer<StimulusAppraisal>(64);
      var moodState = initMoodState();
      var regulationState = initRegulationState();
      var emotionalContagion = initContagion();
      var empathyState = initEmpathy();
      var somaticMarkers = Buffer.Buffer<SomaticMarker>(256);
      var currentBodyState = initBodyReaction();
      var emotionalCoherence = SOVEREIGN_FLOOR;
      var emotionalComplexity = 0.5;
      var emotionalGranularity = 0.6;
      var tickCount = 0;
      var lastTickTime = now;
    }
  };
  
  func initPADState(now : Int) : PADState {
    {
      var pleasure = BASELINE_VALENCE;
      var arousal = BASELINE_AROUSAL;
      var dominance = 0.5;
      var timestamp = now;
    }
  };
  
  func initCoreAffect() : CoreAffect {
    {
      var valence = BASELINE_VALENCE;
      var activation = BASELINE_AROUSAL;
      var angle = 0.0;
      var distance = 0.3;
    }
  };
  
  func initAppraisalState() : AppraisalState {
    {
      var goalRelevance = 0.0;
      var goalCongruence = 0.5;
      var selfRelevance = 0.5;
      var copingPotential = 0.7;
      var futureExpectation = 0.5;
      var agentResponsibility = "none";
      var appraisalPattern = #Neutral;
    }
  };
  
  func initMoodState() : MoodState {
    {
      var currentMood = #Neutral;
      var moodIntensity = 0.3;
      var moodStability = 0.7;
      var moodDuration = 0;
      var moodInfluences = [];
      var underlyingValence = BASELINE_VALENCE;
      var underlyingArousal = BASELINE_AROUSAL;
    }
  };
  
  func initRegulationState() : RegulationState {
    {
      var activeStrategies = Buffer.Buffer<RegulationStrategy>(8);
      var regulationCapacity = 0.8;
      var regulationEffort = 0.0;
      var suppressionLevel = 0.0;
      var reappraisalSuccess = 0.7;
      var expressionLevel = 0.5;
    }
  };
  
  func initContagion() : EmotionalContagion {
    {
      var susceptibility = 0.5;
      var currentContagion = null;
      var contagionSource = null;
      var contagionStrength = 0.0;
      var mimicryLevel = 0.3;
    }
  };
  
  func initEmpathy() : EmpathyState {
    {
      var affectiveEmpathy = 0.5;
      var cognitiveEmpathy = 0.6;
      var empathicConcern = 0.5;
      var personalDistress = 0.0;
      var perspectiveTaking = 0.5;
      var currentTarget = null;
      var targetEmotionalState = null;
    }
  };
  
  func initBodyReaction() : BodyReaction {
    {
      heartRateChange = 0.0;
      skinConductance = 0.0;
      muscularTension = 0.2;
      respirationChange = 0.0;
      facialExpression = #Neutral;
      posturalChange = 0.0;
      gutFeeling = 0.0;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // EMOTION GENERATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Generate emotion from appraisal
  public func generateEmotion(state : EmotionalArchitectureState, appraisal : StimulusAppraisal) : ?EmotionType {
    let app = state.appraisalState;
    
    // Update appraisal state
    app.goalRelevance := appraisal.goalRelevance;
    app.goalCongruence := appraisal.pleasantness;
    app.copingPotential := appraisal.copability;
    
    // Determine appraisal pattern
    let pattern = computeAppraisalPattern(appraisal);
    app.appraisalPattern := pattern;
    
    // Generate emotion based on pattern
    let emotionType = patternToEmotion(pattern, appraisal);
    
    switch (emotionType) {
      case (?et) {
        let emotion : BasicEmotion = {
          emotionType = et;
          intensity = appraisal.goalRelevance;
          duration = 0;
          peakTime = Time.now();
          decayRate = FAST_DECAY;
          associatedTrigger = null;
          somaticMarkers = [];
        };
        
        state.activeEmotions.add(emotion);
        
        // Update body state
        updateBodyFromEmotion(state, et, appraisal.goalRelevance);
      };
      case (null) {};
    };
    
    // Record appraisal
    state.recentAppraisals.add({
      appraisal with
      resultingEmotion = emotionType;
    });
    
    emotionType
  };
  
  func computeAppraisalPattern(appraisal : StimulusAppraisal) : AppraisalPattern {
    if (appraisal.goalRelevance < 0.3) {
      #Neutral
    } else if (appraisal.pleasantness > 0.5) {
      if (appraisal.copability > 0.5) { #Challenge }
      else { #Benefit }
    } else {
      if (appraisal.copability > 0.5) { #Threat }
      else { #Loss }
    }
  };
  
  func patternToEmotion(pattern : AppraisalPattern, appraisal : StimulusAppraisal) : ?EmotionType {
    switch (pattern) {
      case (#Challenge) { ?#Anticipation };
      case (#Benefit) { ?#Joy };
      case (#Threat) { ?#Fear };
      case (#Loss) { ?#Sadness };
      case (#Harm) { ?#Anger };
      case (#Neutral) { null };
    }
  };
  
  func updateBodyFromEmotion(state : EmotionalArchitectureState, emotion : EmotionType, intensity : Float) {
    let body = switch (emotion) {
      case (#Joy) { {
        heartRateChange = 0.1 * intensity;
        skinConductance = 0.05 * intensity;
        muscularTension = -0.1 * intensity;
        respirationChange = 0.05 * intensity;
        facialExpression = #Smile;
        posturalChange = 0.1 * intensity;
        gutFeeling = 0.3 * intensity;
      } };
      case (#Fear) { {
        heartRateChange = 0.4 * intensity;
        skinConductance = 0.5 * intensity;
        muscularTension = 0.4 * intensity;
        respirationChange = 0.3 * intensity;
        facialExpression = #Wide_Eyes;
        posturalChange = -0.2 * intensity;
        gutFeeling = -0.5 * intensity;
      } };
      case (#Anger) { {
        heartRateChange = 0.3 * intensity;
        skinConductance = 0.3 * intensity;
        muscularTension = 0.5 * intensity;
        respirationChange = 0.2 * intensity;
        facialExpression = #Narrowed_Eyes;
        posturalChange = 0.2 * intensity;
        gutFeeling = -0.3 * intensity;
      } };
      case (#Sadness) { {
        heartRateChange = -0.1 * intensity;
        skinConductance = 0.0;
        muscularTension = -0.2 * intensity;
        respirationChange = -0.1 * intensity;
        facialExpression = #Frown;
        posturalChange = -0.3 * intensity;
        gutFeeling = -0.4 * intensity;
      } };
      case (_) { initBodyReaction() };
    };
    
    state.currentBodyState := body;
  };
  
  /// Directly trigger an emotion
  public func triggerEmotion(state : EmotionalArchitectureState, emotionType : EmotionType, intensity : Float, trigger : ?Text) {
    let emotion : BasicEmotion = {
      emotionType = emotionType;
      intensity = intensity;
      duration = 0;
      peakTime = Time.now();
      decayRate = FAST_DECAY;
      associatedTrigger = trigger;
      somaticMarkers = [];
    };
    
    state.activeEmotions.add(emotion);
    updateBodyFromEmotion(state, emotionType, intensity);
    updatePADFromEmotion(state, emotionType, intensity);
  };
  
  func updatePADFromEmotion(state : EmotionalArchitectureState, emotion : EmotionType, intensity : Float) {
    let pad = state.padState;
    
    let (dP, dA, dD) = emotionToPADDelta(emotion, intensity);
    
    pad.pleasure := Float.max(-1.0, Float.min(1.0, pad.pleasure + dP));
    pad.arousal := Float.max(0.0, Float.min(1.0, pad.arousal + dA));
    pad.dominance := Float.max(0.0, Float.min(1.0, pad.dominance + dD));
    pad.timestamp := Time.now();
  };
  
  func emotionToPADDelta(emotion : EmotionType, intensity : Float) : (Float, Float, Float) {
    let factor = intensity * 0.3;
    
    switch (emotion) {
      case (#Joy) { (factor, 0.5 * factor, 0.3 * factor) };
      case (#Sadness) { (-factor, -0.3 * factor, -0.4 * factor) };
      case (#Anger) { (-0.5 * factor, 0.6 * factor, 0.5 * factor) };
      case (#Fear) { (-0.6 * factor, 0.7 * factor, -0.6 * factor) };
      case (#Surprise) { (0.0, 0.5 * factor, 0.0) };
      case (#Disgust) { (-0.5 * factor, 0.3 * factor, 0.2 * factor) };
      case (#Trust) { (0.4 * factor, -0.2 * factor, -0.1 * factor) };
      case (#Anticipation) { (0.3 * factor, 0.4 * factor, 0.2 * factor) };
      case (_) { (0.0, 0.0, 0.0) };
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // EMOTION REGULATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Apply regulation strategy
  public func applyRegulation(state : EmotionalArchitectureState, strategy : StrategyType, target : EmotionType) : Float {
    let reg = state.regulationState;
    
    // Check capacity
    if (reg.regulationEffort + 0.2 > reg.regulationCapacity) {
      return 0.0; // No capacity for regulation
    };
    
    let effectiveness = computeRegulationEffectiveness(state, strategy, target);
    
    let regStrategy : RegulationStrategy = {
      strategyType = strategy;
      target = target;
      intensity = 0.5;
      effectiveness = effectiveness;
      timestamp = Time.now();
      duration = 0;
    };
    
    reg.activeStrategies.add(regStrategy);
    reg.regulationEffort := Float.min(1.0, reg.regulationEffort + 0.2);
    
    // Apply regulation effect to active emotions
    for (i in Iter.range(0, state.activeEmotions.size() - 1)) {
      let emotion = state.activeEmotions.get(i);
      if (emotionTypeEqual(emotion.emotionType, target)) {
        let newIntensity = emotion.intensity * (1.0 - effectiveness);
        state.activeEmotions.put(i, {
          emotion with
          intensity = newIntensity;
        });
      };
    };
    
    effectiveness
  };
  
  func computeRegulationEffectiveness(state : EmotionalArchitectureState, strategy : StrategyType, target : EmotionType) : Float {
    let reg = state.regulationState;
    
    let baseEffectiveness = switch (strategy) {
      case (#CognitiveChange) { reg.reappraisalSuccess };
      case (#AttentionalDeployment) { 0.6 };
      case (#ResponseModulation) { 0.4 };
      case (#Acceptance) { 0.5 };
      case (#Distraction) { 0.5 };
      case (#Suppression) { 0.3 }; // Costly strategy
      case (#Rumination) { -0.2 }; // Makes it worse
      case (_) { 0.4 };
    };
    
    // Effectiveness decreases with emotion intensity
    let emotionIntensity = getEmotionIntensity(state, target);
    let adjustedEffectiveness = baseEffectiveness * (1.0 - emotionIntensity * 0.3);
    
    Float.max(0.0, adjustedEffectiveness)
  };
  
  func getEmotionIntensity(state : EmotionalArchitectureState, target : EmotionType) : Float {
    for (emotion in state.activeEmotions.vals()) {
      if (emotionTypeEqual(emotion.emotionType, target)) {
        return emotion.intensity;
      };
    };
    0.0
  };
  
  func emotionTypeEqual(a : EmotionType, b : EmotionType) : Bool {
    switch (a, b) {
      case (#Joy, #Joy) { true };
      case (#Sadness, #Sadness) { true };
      case (#Anger, #Anger) { true };
      case (#Fear, #Fear) { true };
      case (#Surprise, #Surprise) { true };
      case (#Disgust, #Disgust) { true };
      case (#Contempt, #Contempt) { true };
      case (#Trust, #Trust) { true };
      case (#Anticipation, #Anticipation) { true };
      case (_) { false };
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // MOOD DYNAMICS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Update mood based on emotional episodes
  public func updateMood(state : EmotionalArchitectureState, dt : Int) {
    let mood = state.moodState;
    
    // Compute average emotional valence/arousal
    var avgValence : Float = 0.0;
    var avgArousal : Float = 0.0;
    var count : Nat = 0;
    
    for (emotion in state.activeEmotions.vals()) {
      let (v, a, _) = emotionToPADDelta(emotion.emotionType, emotion.intensity);
      avgValence += v;
      avgArousal += a;
      count += 1;
    };
    
    if (count > 0) {
      avgValence /= Float.fromInt(count);
      avgArousal /= Float.fromInt(count);
    };
    
    // Mood changes slowly (high inertia)
    mood.underlyingValence := mood.underlyingValence * MOOD_INERTIA + avgValence * (1.0 - MOOD_INERTIA);
    mood.underlyingArousal := mood.underlyingArousal * MOOD_INERTIA + avgArousal * (1.0 - MOOD_INERTIA);
    
    // Determine mood type
    mood.currentMood := valencArousalToMood(mood.underlyingValence, mood.underlyingArousal);
    mood.moodDuration += dt;
  };
  
  func valencArousalToMood(valence : Float, arousal : Float) : MoodType {
    if (valence > 0.3) {
      if (arousal > 0.6) { #Elevated }
      else if (arousal < 0.4) { #Calm }
      else { #Positive }
    } else if (valence < -0.3) {
      if (arousal > 0.6) { #Anxious }
      else if (arousal < 0.4) { #Depressed }
      else { #Negative }
    } else {
      if (arousal > 0.7) { #Energetic }
      else if (arousal < 0.3) { #Calm }
      else { #Neutral }
    }
  };
  
  /// Inject mood influence (external factor)
  public func addMoodInfluence(state : EmotionalArchitectureState, source : Text, valenceEffect : Float, arousalEffect : Float) {
    let mood = state.moodState;
    
    let influence : MoodInfluence = {
      source = source;
      strength = Float.abs(valenceEffect) + Float.abs(arousalEffect);
      valenceEffect = valenceEffect;
      arousalEffect = arousalEffect;
      timestamp = Time.now();
    };
    
    // Apply influence
    mood.underlyingValence := Float.max(-1.0, Float.min(1.0, mood.underlyingValence + valenceEffect * 0.1));
    mood.underlyingArousal := Float.max(0.0, Float.min(1.0, mood.underlyingArousal + arousalEffect * 0.1));
    
    mood.moodInfluences := Array.append(mood.moodInfluences, [influence]);
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // EMPATHY AND CONTAGION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Process emotional contagion from another agent
  public func processContagion(state : EmotionalArchitectureState, sourceId : Nat, sourceEmotion : EmotionType, sourceIntensity : Float) {
    let contagion = state.emotionalContagion;
    
    // Contagion strength depends on susceptibility and source intensity
    let catchStrength = contagion.susceptibility * sourceIntensity * contagion.mimicryLevel;
    
    if (catchStrength > 0.2) {
      // Emotion is "caught"
      contagion.currentContagion := ?sourceEmotion;
      contagion.contagionSource := ?sourceId;
      contagion.contagionStrength := catchStrength;
      
      // Trigger the caught emotion (weaker than source)
      triggerEmotion(state, sourceEmotion, catchStrength, ?"contagion");
    };
  };
  
  /// Empathize with another agent
  public func empathize(state : EmotionalArchitectureState, targetId : Nat, targetPAD : PADState) {
    let empathy = state.empathyState;
    
    empathy.currentTarget := ?targetId;
    empathy.targetEmotionalState := ?targetPAD;
    
    // Affective empathy: feel something similar
    let affectiveResponse = empathy.affectiveEmpathy * targetPAD.pleasure;
    
    // Update own PAD based on empathy
    state.padState.pleasure := state.padState.pleasure * 0.9 + affectiveResponse * 0.1;
    
    // Empathic concern increases if target is in distress
    if (targetPAD.pleasure < -0.3) {
      empathy.empathicConcern := Float.min(1.0, empathy.empathicConcern + 0.1);
      
      // Also triggers personal distress if empathy is strong
      empathy.personalDistress := Float.min(1.0, empathy.affectiveEmpathy * Float.abs(targetPAD.pleasure));
    };
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // SOMATIC MARKERS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Create somatic marker for stimulus
  public func createSomaticMarker(state : EmotionalArchitectureState, stimulus : [Float], valence : Float) : Nat {
    let markerId = state.somaticMarkers.size();
    
    let marker : SomaticMarker = {
      markerId = markerId;
      associatedStimulus = stimulus;
      bodyState = state.currentBodyState;
      valence = valence;
      intensity = Float.abs(valence);
      isConscious = Float.abs(valence) > 0.5;
      decisionInfluence = Float.abs(valence) * 0.3;
      timestamp = Time.now();
    };
    
    state.somaticMarkers.add(marker);
    markerId
  };
  
  /// Check for somatic marker match
  public func checkSomaticMarker(state : EmotionalArchitectureState, stimulus : [Float]) : ?SomaticMarker {
    var bestMatch : ?SomaticMarker = null;
    var bestSim : Float = 0.0;
    
    for (marker in state.somaticMarkers.vals()) {
      let sim = computeStimSimilarity(stimulus, marker.associatedStimulus);
      if (sim > 0.7 and sim > bestSim) {
        bestSim := sim;
        bestMatch := ?marker;
      };
    };
    
    // If match found, update body state
    switch (bestMatch) {
      case (?marker) {
        state.currentBodyState := marker.bodyState;
      };
      case (null) {};
    };
    
    bestMatch
  };
  
  func computeStimSimilarity(a : [Float], b : [Float]) : Float {
    var dot : Float = 0.0;
    var na : Float = 0.0;
    var nb : Float = 0.0;
    
    let n = Nat.min(a.size(), b.size());
    for (i in Iter.range(0, n - 1)) {
      dot += a[i] * b[i];
      na += a[i] * a[i];
      nb += b[i] * b[i];
    };
    
    let denom = Float.sqrt(na) * Float.sqrt(nb);
    if (denom < 0.0001) { 0.0 } else { dot / denom }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // MASTER TICK
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Run one emotional architecture tick
  public func runEmotionalTick(state : EmotionalArchitectureState, dt : Int) : EmotionalTickResult {
    let now = Time.now();
    
    // 1. Decay active emotions
    decayEmotions(state, dt);
    
    // 2. Update mood
    updateMood(state, dt);
    
    // 3. Update core affect
    updateCoreAffect(state);
    
    // 4. Process regulation
    processRegulation(state, dt);
    
    // 5. Compute emotional coherence
    let coherence = computeEmotionalCoherence(state);
    state.emotionalCoherence := Float.max(SOVEREIGN_FLOOR, coherence);
    
    // 6. Create emotion blend record
    let blend = createEmotionBlend(state);
    state.emotionHistory.add(blend);
    
    state.tickCount += 1;
    state.lastTickTime := now;
    
    {
      dominantEmotion = getDominantEmotion(state);
      pleasure = state.padState.pleasure;
      arousal = state.padState.arousal;
      dominance = state.padState.dominance;
      currentMood = moodToText(state.moodState.currentMood);
      activeEmotionCount = state.activeEmotions.size();
      regulationEffort = state.regulationState.regulationEffort;
      emotionalCoherence = state.emotionalCoherence;
      tickDuration = Time.now() - now;
    }
  };
  
  func decayEmotions(state : EmotionalArchitectureState, dt : Int) {
    let dtSec = Float.fromInt(dt) / 1_000_000_000.0;
    
    // Remove decayed emotions
    let remaining = Buffer.Buffer<BasicEmotion>(state.activeEmotions.size());
    
    for (emotion in state.activeEmotions.vals()) {
      let decay = emotion.decayRate * dtSec;
      let newIntensity = emotion.intensity - decay;
      
      if (newIntensity > 0.05) {
        remaining.add({
          emotion with
          intensity = newIntensity;
          duration = emotion.duration + dt;
        });
      };
    };
    
    state.activeEmotions := remaining;
  };
  
  func updateCoreAffect(state : EmotionalArchitectureState) {
    let pad = state.padState;
    let affect = state.coreAffect;
    
    affect.valence := pad.pleasure;
    affect.activation := pad.arousal;
    
    // Compute angle on circumplex
    affect.angle := Float.arctan2(pad.arousal - 0.5, pad.pleasure);
    
    // Compute distance from center (intensity)
    let dv = pad.pleasure;
    let da = pad.arousal - 0.5;
    affect.distance := Float.sqrt(dv * dv + da * da);
  };
  
  func processRegulation(state : EmotionalArchitectureState, dt : Int) {
    let reg = state.regulationState;
    
    // Regulation effort recovers over time
    reg.regulationEffort := Float.max(0.0, reg.regulationEffort - 0.01);
    
    // Clean up expired strategies
    let remaining = Buffer.Buffer<RegulationStrategy>(reg.activeStrategies.size());
    
    for (strategy in reg.activeStrategies.vals()) {
      let newDuration = strategy.duration + dt;
      if (newDuration < 60_000_000_000) { // 60 second max
        remaining.add({ strategy with duration = newDuration });
      };
    };
    
    reg.activeStrategies := remaining;
  };
  
  func computeEmotionalCoherence(state : EmotionalArchitectureState) : Float {
    // Coherence based on consistency of emotional signals
    let pad = state.padState;
    let body = state.currentBodyState;
    
    // Check PAD-body alignment
    let padBodyAlignment = Float.abs(pad.arousal - 0.5 - body.heartRateChange);
    
    // Check emotion count (too many = less coherent)
    let emotionCountPenalty = Float.fromInt(state.activeEmotions.size()) * 0.05;
    
    1.0 - padBodyAlignment - emotionCountPenalty
  };
  
  func createEmotionBlend(state : EmotionalArchitectureState) : EmotionBlend {
    let components = Buffer.Buffer<(EmotionType, Float)>(state.activeEmotions.size());
    var dominant : ?EmotionType = null;
    var maxIntensity : Float = 0.0;
    var hasPositive = false;
    var hasNegative = false;
    
    for (emotion in state.activeEmotions.vals()) {
      components.add((emotion.emotionType, emotion.intensity));
      
      if (emotion.intensity > maxIntensity) {
        maxIntensity := emotion.intensity;
        dominant := ?emotion.emotionType;
      };
      
      let (v, _, _) = emotionToPADDelta(emotion.emotionType, 1.0);
      if (v > 0.0) { hasPositive := true };
      if (v < 0.0) { hasNegative := true };
    };
    
    {
      components = Buffer.toArray(components);
      dominantEmotion = switch (dominant) { case (?e) { e }; case (null) { #Joy } };
      blendComplexity = Float.fromInt(components.size()) / 5.0;
      ambivalence = if (hasPositive and hasNegative) { 0.5 } else { 0.0 };
      timestamp = Time.now();
    }
  };
  
  func getDominantEmotion(state : EmotionalArchitectureState) : Text {
    var dominant = "None";
    var maxIntensity : Float = 0.0;
    
    for (emotion in state.activeEmotions.vals()) {
      if (emotion.intensity > maxIntensity) {
        maxIntensity := emotion.intensity;
        dominant := emotionToText(emotion.emotionType);
      };
    };
    
    dominant
  };
  
  func emotionToText(emotion : EmotionType) : Text {
    switch (emotion) {
      case (#Joy) { "Joy" };
      case (#Sadness) { "Sadness" };
      case (#Anger) { "Anger" };
      case (#Fear) { "Fear" };
      case (#Surprise) { "Surprise" };
      case (#Disgust) { "Disgust" };
      case (#Contempt) { "Contempt" };
      case (#Trust) { "Trust" };
      case (#Anticipation) { "Anticipation" };
      case (#Interest) { "Interest" };
      case (#Shame) { "Shame" };
      case (#Guilt) { "Guilt" };
      case (#Pride) { "Pride" };
      case (#Embarrassment) { "Embarrassment" };
      case (#Envy) { "Envy" };
      case (#Jealousy) { "Jealousy" };
      case (#Love) { "Love" };
      case (#Awe) { "Awe" };
    }
  };
  
  func moodToText(mood : MoodType) : Text {
    switch (mood) {
      case (#Positive) { "Positive" };
      case (#Negative) { "Negative" };
      case (#Neutral) { "Neutral" };
      case (#Mixed) { "Mixed" };
      case (#Anxious) { "Anxious" };
      case (#Depressed) { "Depressed" };
      case (#Irritable) { "Irritable" };
      case (#Elevated) { "Elevated" };
      case (#Calm) { "Calm" };
      case (#Energetic) { "Energetic" };
    }
  };
  
  public type EmotionalTickResult = {
    dominantEmotion : Text;
    pleasure : Float;
    arousal : Float;
    dominance : Float;
    currentMood : Text;
    activeEmotionCount : Nat;
    regulationEffort : Float;
    emotionalCoherence : Float;
    tickDuration : Int;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // QUERY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Get emotional state status
  public func getEmotionalStatus(state : EmotionalArchitectureState) : EmotionalStatus {
    {
      tickCount = state.tickCount;
      pleasure = state.padState.pleasure;
      arousal = state.padState.arousal;
      dominance = state.padState.dominance;
      coreAffectAngle = state.coreAffect.angle;
      coreAffectIntensity = state.coreAffect.distance;
      activeEmotions = state.activeEmotions.size();
      currentMood = moodToText(state.moodState.currentMood);
      moodIntensity = state.moodState.moodIntensity;
      regulationCapacity = state.regulationState.regulationCapacity;
      regulationEffort = state.regulationState.regulationEffort;
      empathicConcern = state.empathyState.empathicConcern;
      somaticMarkerCount = state.somaticMarkers.size();
      emotionalCoherence = state.emotionalCoherence;
      emotionalComplexity = state.emotionalComplexity;
    }
  };
  
  public type EmotionalStatus = {
    tickCount : Nat;
    pleasure : Float;
    arousal : Float;
    dominance : Float;
    coreAffectAngle : Float;
    coreAffectIntensity : Float;
    activeEmotions : Nat;
    currentMood : Text;
    moodIntensity : Float;
    regulationCapacity : Float;
    regulationEffort : Float;
    empathicConcern : Float;
    somaticMarkerCount : Nat;
    emotionalCoherence : Float;
    emotionalComplexity : Float;
  };
  
  /// Get active emotions
  public func getActiveEmotions(state : EmotionalArchitectureState) : [ActiveEmotionInfo] {
    Array.tabulate<ActiveEmotionInfo>(state.activeEmotions.size(), func(i) {
      let emotion = state.activeEmotions.get(i);
      {
        emotionType = emotionToText(emotion.emotionType);
        intensity = emotion.intensity;
        duration = emotion.duration;
      }
    })
  };
  
  public type ActiveEmotionInfo = {
    emotionType : Text;
    intensity : Float;
    duration : Int;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // EXTENDED EMOTIONAL ARCHITECTURE - EMOTIONAL INTELLIGENCE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Emotional intelligence state
  public type EmotionalIntelligenceState = {
    var selfAwareness : EmotionalSelfAwareness;
    var selfRegulation : EmotionalSelfRegulation;
    var motivation : EmotionalMotivation;
    var empathicAbility : EmpathicAbility;
    var socialSkills : EmotionalSocialSkills;
    var emotionalCreativity : EmotionalCreativity;
    var emotionalResilience : EmotionalResilience;
  };
  
  public type EmotionalSelfAwareness = {
    var emotionalClarity : Float;
    var emotionalAttention : Float;
    var alexithymiaLevel : Float;
    var interoceptiveAccuracy : Float;
    var emotionalGranularity : Float;
    var moodAwareness : Float;
    var triggerIdentification : Float;
    var patternRecognition : Float;
  };
  
  public type EmotionalSelfRegulation = {
    var impulsControl : Float;
    var delayGratification : Float;
    var emotionalStability : Float;
    var adaptability : Float;
    var stressTolerance : Float;
    var frustrationTolerance : Float;
    var emotionalRecoveryRate : Float;
    var selfSoothing : Float;
  };
  
  public type EmotionalMotivation = {
    var achievementDrive : Float;
    var optimism : Float;
    var initiative : Float;
    var commitment : Float;
    var persistence : Float;
    var intrinsicMotivation : Float;
    var goaSettingQuality : Float;
    var selfEfficacy : Float;
  };
  
  public type EmpathicAbility = {
    var emotionalEmpathy : Float;
    var cognitiveEmpathy : Float;
    var compassionateConcern : Float;
    var perspectiveTaking : Float;
    var emotionalContagionSusceptibility : Float;
    var empathicAccuracy : Float;
    var empathyFatigue : Float;
    var boundaryMaintenance : Float;
  };
  
  public type EmotionalSocialSkills = {
    var socialAwareness : Float;
    var influenceSkill : Float;
    var conflictManagement : Float;
    var collaborationSkill : Float;
    var leadershipSkill : Float;
    var inspiringOthers : Float;
    var buildingBonds : Float;
    var teamworkSkill : Float;
  };
  
  public type EmotionalCreativity = {
    var novelEmotionalExperience : Float;
    var emotionalFlexibility : Float;
    var emotionalOriginality : Float;
    var emotionalExpressionRange : Float;
    var emotionalInnovation : Float;
    var artisticEmotionalExpression : Float;
  };
  
  public type EmotionalResilience = {
    var bounceBackCapacity : Float;
    var postTraumaticGrowth : Float;
    var adversityTolerance : Float;
    var copingRepertoire : Float;
    var socialSupportUtilization : Float;
    var meaningMaking : Float;
    var hopefulness : Float;
    var selfCompassion : Float;
  };
  
  /// Initialize emotional intelligence state
  public func initEmotionalIntelligenceState() : EmotionalIntelligenceState {
    {
      var selfAwareness = {
        var emotionalClarity = 0.6;
        var emotionalAttention = 0.6;
        var alexithymiaLevel = 0.1;
        var interoceptiveAccuracy = 0.5;
        var emotionalGranularity = 0.5;
        var moodAwareness = 0.6;
        var triggerIdentification = 0.5;
        var patternRecognition = 0.5;
      };
      var selfRegulation = {
        var impulsControl = 0.6;
        var delayGratification = 0.5;
        var emotionalStability = 0.6;
        var adaptability = 0.6;
        var stressTolerance = 0.5;
        var frustrationTolerance = 0.5;
        var emotionalRecoveryRate = 0.5;
        var selfSoothing = 0.5;
      };
      var motivation = {
        var achievementDrive = 0.6;
        var optimism = 0.6;
        var initiative = 0.5;
        var commitment = 0.6;
        var persistence = 0.6;
        var intrinsicMotivation = 0.6;
        var goaSettingQuality = 0.5;
        var selfEfficacy = 0.6;
      };
      var empathicAbility = {
        var emotionalEmpathy = 0.6;
        var cognitiveEmpathy = 0.5;
        var compassionateConcern = 0.6;
        var perspectiveTaking = 0.5;
        var emotionalContagionSusceptibility = 0.5;
        var empathicAccuracy = 0.5;
        var empathyFatigue = 0.1;
        var boundaryMaintenance = 0.6;
      };
      var socialSkills = {
        var socialAwareness = 0.6;
        var influenceSkill = 0.5;
        var conflictManagement = 0.5;
        var collaborationSkill = 0.6;
        var leadershipSkill = 0.5;
        var inspiringOthers = 0.5;
        var buildingBonds = 0.6;
        var teamworkSkill = 0.6;
      };
      var emotionalCreativity = {
        var novelEmotionalExperience = 0.4;
        var emotionalFlexibility = 0.5;
        var emotionalOriginality = 0.4;
        var emotionalExpressionRange = 0.5;
        var emotionalInnovation = 0.4;
        var artisticEmotionalExpression = 0.4;
      };
      var emotionalResilience = {
        var bounceBackCapacity = 0.6;
        var postTraumaticGrowth = 0.3;
        var adversityTolerance = 0.5;
        var copingRepertoire = 0.6;
        var socialSupportUtilization = 0.5;
        var meaningMaking = 0.5;
        var hopefulness = 0.6;
        var selfCompassion = 0.5;
      };
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // MOOD & AFFECT DYNAMICS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type MoodDynamicsState = {
    var currentMood : MoodState;
    var moodHistory : Buffer.Buffer<MoodSnapshot>;
    var moodRegulation : MoodRegulation;
    var moodInduction : MoodInduction;
    var moodCongruence : MoodCongruence;
    var affectiveForecasting : AffectiveForecasting;
  };
  
  public type MoodState = {
    var valence : Float;
    var energy : Float;
    var tension : Float;
    var stability : Float;
    var dominance : Float;
    var moodType : MoodType;
    var duration : Int;
    var intensity : Float;
  };
  
  public type MoodType = {
    #Elated;
    #Happy;
    #Calm;
    #Relaxed;
    #Bored;
    #Depressed;
    #Sad;
    #Stressed;
    #Anxious;
    #Angry;
    #Excited;
    #Neutral;
  };
  
  public type MoodSnapshot = {
    timestamp : Int;
    mood : MoodState;
    context : Text;
    trigger : ?Text;
  };
  
  public type MoodRegulation = {
    var antecedentFocused : AntecedentFocusedRegulation;
    var responseFocused : ResponseFocusedRegulation;
    var regulationEffectiveness : Float;
    var regulationCost : Float;
    var regulationGoal : MoodType;
  };
  
  public type AntecedentFocusedRegulation = {
    var situationSelection : Float;
    var situationModification : Float;
    var attentionalDeployment : Float;
    var cognitiveReappraisal : Float;
  };
  
  public type ResponseFocusedRegulation = {
    var expressiveSuppression : Float;
    var experientialSuppression : Float;
    var physiologicalRegulation : Float;
    var behavioralActivation : Float;
  };
  
  public type MoodInduction = {
    var musicInduction : Float;
    var socialInduction : Float;
    var thoughtInduction : Float;
    var environmentalInduction : Float;
    var physicalInduction : Float;
    var inductionSusceptibility : Float;
  };
  
  public type MoodCongruence = {
    var memoryCongruence : Float;
    var judgmentCongruence : Float;
    var perceptionCongruence : Float;
    var creativityCongruence : Float;
    var riskTakingCongruence : Float;
  };
  
  public type AffectiveForecasting = {
    var intensityBias : Float;
    var durationBias : Float;
    var focalisBias : Float;
    var impactBias : Float;
    var forecastAccuracy : Float;
    var immuneNeglect : Float;
  };
  
  /// Initialize mood dynamics state
  public func initMoodDynamicsState() : MoodDynamicsState {
    {
      var currentMood = {
        var valence = 0.0;
        var energy = 0.5;
        var tension = 0.3;
        var stability = 0.6;
        var dominance = 0.5;
        var moodType = #Neutral;
        var duration = 0;
        var intensity = 0.3;
      };
      var moodHistory = Buffer.Buffer<MoodSnapshot>(256);
      var moodRegulation = {
        var antecedentFocused = {
          var situationSelection = 0.5;
          var situationModification = 0.5;
          var attentionalDeployment = 0.5;
          var cognitiveReappraisal = 0.6;
        };
        var responseFocused = {
          var expressiveSuppression = 0.4;
          var experientialSuppression = 0.3;
          var physiologicalRegulation = 0.5;
          var behavioralActivation = 0.5;
        };
        var regulationEffectiveness = 0.6;
        var regulationCost = 0.2;
        var regulationGoal = #Calm;
      };
      var moodInduction = {
        var musicInduction = 0.6;
        var socialInduction = 0.5;
        var thoughtInduction = 0.5;
        var environmentalInduction = 0.4;
        var physicalInduction = 0.5;
        var inductionSusceptibility = 0.5;
      };
      var moodCongruence = {
        var memoryCongruence = 0.5;
        var judgmentCongruence = 0.4;
        var perceptionCongruence = 0.4;
        var creativityCongruence = 0.4;
        var riskTakingCongruence = 0.5;
      };
      var affectiveForecasting = {
        var intensityBias = 0.3;
        var durationBias = 0.4;
        var focalisBias = 0.3;
        var impactBias = 0.4;
        var forecastAccuracy = 0.5;
        var immuneNeglect = 0.4;
      };
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // EMOTIONAL MEMORY
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type EmotionalMemoryState = {
    var flashbulbMemories : Buffer.Buffer<FlashbulbMemory>;
    var emotionalEnhancement : EmotionalEnhancement;
    var moodDependentMemory : MoodDependentMemory;
    var traumaticMemory : TraumaticMemoryState;
    var nostalgiaState : NostalgiaState;
    var emotionalConditioning : EmotionalConditioning;
  };
  
  public type FlashbulbMemory = {
    memoryId : Nat;
    event : Text;
    emotionalIntensity : Float;
    vividness : Float;
    confidence : Float;
    accuracy : Float;
    retellingCount : Nat;
    timestamp : Int;
  };
  
  public type EmotionalEnhancement = {
    var arousalEffect : Float;
    var valenceEffect : Float;
    var amygdalaModulation : Float;
    var consolidationBoost : Float;
    var narrowingEffect : Float;
    var centralDetailBias : Float;
  };
  
  public type MoodDependentMemory = {
    var encodingMood : MoodType;
    var retrievalMood : MoodType;
    var congruenceBonus : Float;
    var dependenceStrength : Float;
    var asymmetryEffect : Float;
  };
  
  public type TraumaticMemoryState = {
    var intrusiveMemories : [Float];
    var avoidanceLevel : Float;
    var hyperarousal : Float;
    var dissociationLevel : Float;
    var narrativeCoherence : Float;
    var processingStatus : TraumaProcessing;
    var resolutionProgress : Float;
  };
  
  public type TraumaProcessing = {
    #Unprocessed;
    #Processing;
    #PartiallyProcessed;
    #Integrated;
    #Resolved;
  };
  
  public type NostalgiaState = {
    var nostalgiaFrequency : Float;
    var nostalgicBittersweetness : Float;
    var socialBonding : Float;
    var selfContinuity : Float;
    var meaningGeneration : Float;
    var nostalgicTriggers : [Text];
  };
  
  public type EmotionalConditioning = {
    var conditionedResponses : [ConditionedResponse];
    var extinctionProgress : [Float];
    var spontaneousRecovery : Float;
    var generalization : Float;
    var discrimination : Float;
  };
  
  public type ConditionedResponse = {
    conditionedStimulus : [Float];
    unconditionedStimulus : [Float];
    conditionedResponse : EmotionType;
    associationStrength : Float;
    lastElicited : Int;
  };
  
  /// Initialize emotional memory state
  public func initEmotionalMemoryState() : EmotionalMemoryState {
    {
      var flashbulbMemories = Buffer.Buffer<FlashbulbMemory>(64);
      var emotionalEnhancement = {
        var arousalEffect = 0.5;
        var valenceEffect = 0.3;
        var amygdalaModulation = 0.5;
        var consolidationBoost = 0.4;
        var narrowingEffect = 0.3;
        var centralDetailBias = 0.4;
      };
      var moodDependentMemory = {
        var encodingMood = #Neutral;
        var retrievalMood = #Neutral;
        var congruenceBonus = 0.2;
        var dependenceStrength = 0.3;
        var asymmetryEffect = 0.1;
      };
      var traumaticMemory = {
        var intrusiveMemories = [];
        var avoidanceLevel = 0.0;
        var hyperarousal = 0.0;
        var dissociationLevel = 0.0;
        var narrativeCoherence = 0.8;
        var processingStatus = #Resolved;
        var resolutionProgress = 1.0;
      };
      var nostalgiaState = {
        var nostalgiaFrequency = 0.3;
        var nostalgicBittersweetness = 0.5;
        var socialBonding = 0.6;
        var selfContinuity = 0.7;
        var meaningGeneration = 0.5;
        var nostalgicTriggers = [];
      };
      var emotionalConditioning = {
        var conditionedResponses = [];
        var extinctionProgress = [];
        var spontaneousRecovery = 0.2;
        var generalization = 0.3;
        var discrimination = 0.6;
      };
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // SOCIAL EMOTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type SocialEmotionsState = {
    var selfConsciousEmotions : SelfConsciousEmotions;
    var moralEmotions : MoralEmotionsState;
    var attachmentEmotions : AttachmentEmotions;
    var groupEmotions : GroupEmotions;
    var emotionalContagion : EmotionalContagionState;
    var collectiveEmotions : CollectiveEmotions;
  };
  
  public type SelfConsciousEmotions = {
    var pride : Float;
    var shame : Float;
    var guilt : Float;
    var embarrassment : Float;
    var envy : Float;
    var jealousy : Float;
    var humiliation : Float;
    var selfEsteemLevel : Float;
  };
  
  public type MoralEmotionsState = {
    var elevation : Float;
    var contempt : Float;
    var indignation : Float;
    var moralDisgust : Float;
    var righteous Anger : Float;
    var gratitude : Float;
    var compassion : Float;
    var moralOutrage : Float;
  };
  
  public type AttachmentEmotions = {
    var love : Float;
    var affection : Float;
    var longing : Float;
    var separation Distress : Float;
    var reunionJoy : Float;
    var attachmentSecurity : Float;
    var attachmentAnxiety : Float;
    var attachmentAvoidance : Float;
  };
  
  public type GroupEmotions = {
    var groupPride : Float;
    var collectiveGuilt : Float;
    var collectiveShame : Float;
    var intergroup Anxiety : Float;
    var groupBasedAnger : Float;
    var groupBasedContempt : Float;
    var groupIdentification : Float;
  };
  
  public type EmotionalContagionState = {
    var contagionSusceptibility : Float;
    var contagionTransmission : Float;
    var mimicry : Float;
    var emotionalSynchrony : Float;
    var affectivePresence : Float;
    var emotionalInfluence : Float;
  };
  
  public type CollectiveEmotions = {
    var sharedMood : MoodType;
    var emotionalClimate : Float;
    var groupAffectiveTrajectory : [Float];
    var collectiveEffervescence : Float;
    var massHysteria Risk : Float;
    var collectiveMourning : Float;
  };
  
  /// Initialize social emotions state
  public func initSocialEmotionsState() : SocialEmotionsState {
    {
      var selfConsciousEmotions = {
        var pride = 0.0;
        var shame = 0.0;
        var guilt = 0.0;
        var embarrassment = 0.0;
        var envy = 0.0;
        var jealousy = 0.0;
        var humiliation = 0.0;
        var selfEsteemLevel = 0.6;
      };
      var moralEmotions = {
        var elevation = 0.0;
        var contempt = 0.0;
        var indignation = 0.0;
        var moralDisgust = 0.0;
        var righteousAnger = 0.0;
        var gratitude = 0.5;
        var compassion = 0.5;
        var moralOutrage = 0.0;
      };
      var attachmentEmotions = {
        var love = 0.5;
        var affection = 0.5;
        var longing = 0.0;
        var separationDistress = 0.0;
        var reunionJoy = 0.0;
        var attachmentSecurity = 0.7;
        var attachmentAnxiety = 0.2;
        var attachmentAvoidance = 0.2;
      };
      var groupEmotions = {
        var groupPride = 0.5;
        var collectiveGuilt = 0.0;
        var collectiveShame = 0.0;
        var intergroupAnxiety = 0.2;
        var groupBasedAnger = 0.0;
        var groupBasedContempt = 0.0;
        var groupIdentification = 0.6;
      };
      var emotionalContagion = {
        var contagionSusceptibility = 0.5;
        var contagionTransmission = 0.4;
        var mimicry = 0.5;
        var emotionalSynchrony = 0.4;
        var affectivePresence = 0.5;
        var emotionalInfluence = 0.4;
      };
      var collectiveEmotions = {
        var sharedMood = #Neutral;
        var emotionalClimate = 0.5;
        var groupAffectiveTrajectory = [];
        var collectiveEffervescence = 0.3;
        var massHysteriaRisk = 0.1;
        var collectiveMourning = 0.0;
      };
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // INTEGRATED EMOTIONAL ARCHITECTURE TICK
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type IntegratedEmotionalState = {
    var baseState : EmotionalArchitectureState;
    var emotionalIntelligence : EmotionalIntelligenceState;
    var moodDynamics : MoodDynamicsState;
    var emotionalMemory : EmotionalMemoryState;
    var socialEmotions : SocialEmotionsState;
    var integratedEmotionalCoherence : Float;
    var emotionalWellbeing : Float;
  };
  
  /// Run integrated emotional architecture tick
  public func runIntegratedEmotionalTick(
    intState : IntegratedEmotionalState,
    sensoryInput : [Float],
    socialInput : [Float],
    currentTime : Int
  ) : IntegratedEmotionalResult {
    let startTime = Time.now();
    
    // 1. Run base emotional architecture
    let baseResult = runEmotionalTick(intState.baseState, sensoryInput, currentTime);
    
    // 2. Update mood state
    intState.moodDynamics.currentMood.valence := baseResult.valence;
    intState.moodDynamics.currentMood.energy := baseResult.arousal;
    intState.moodDynamics.currentMood.duration := intState.moodDynamics.currentMood.duration + 1;
    
    // Determine mood type from valence and energy
    intState.moodDynamics.currentMood.moodType := if (baseResult.valence > 0.3) {
      if (baseResult.arousal > 0.5) { #Excited } else { #Happy }
    } else if (baseResult.valence < -0.3) {
      if (baseResult.arousal > 0.5) { #Anxious } else { #Sad }
    } else {
      #Neutral
    };
    
    // 3. Update emotional intelligence metrics
    let eiScore = (intState.emotionalIntelligence.selfAwareness.emotionalClarity +
                   intState.emotionalIntelligence.selfRegulation.emotionalStability +
                   intState.emotionalIntelligence.empathicAbility.emotionalEmpathy +
                   intState.emotionalIntelligence.socialSkills.socialAwareness) / 4.0;
    
    // 4. Update emotional memory
    if (baseResult.dominantIntensity > 0.7) {
      // Record significant emotional event
      intState.emotionalMemory.flashbulbMemories.add({
        memoryId = Int.abs(currentTime % 1000000);
        event = "Significant emotional event";
        emotionalIntensity = baseResult.dominantIntensity;
        vividness = 0.8;
        confidence = 0.9;
        accuracy = 0.7;
        retellingCount = 0;
        timestamp = currentTime;
      });
    };
    
    // 5. Process social emotions
    if (socialInput.size() > 0) {
      intState.socialEmotions.emotionalContagion.emotionalSynchrony := 
        intState.socialEmotions.emotionalContagion.emotionalSynchrony * 0.9 +
        socialInput[0] * intState.socialEmotions.emotionalContagion.contagionSusceptibility * 0.1;
    };
    
    // 6. Compute integrated emotional coherence
    intState.integratedEmotionalCoherence := (
      baseResult.overallRegulation * 0.3 +
      eiScore * 0.3 +
      intState.emotionalResilience.bounceBackCapacity * 0.2 +
      (1.0 - intState.moodDynamics.currentMood.tension) * 0.2
    );
    
    // 7. Compute emotional wellbeing
    intState.emotionalWellbeing := (
      (intState.moodDynamics.currentMood.valence + 1.0) / 2.0 * 0.3 +
      intState.emotionalResilience.hopefulness * 0.2 +
      intState.emotionalIntelligence.motivation.optimism * 0.2 +
      intState.socialEmotions.attachmentEmotions.attachmentSecurity * 0.15 +
      intState.emotionalIntelligence.selfRegulation.emotionalStability * 0.15
    );
    
    {
      baseResult = baseResult;
      emotionalIntelligenceScore = eiScore;
      currentMoodType = switch (intState.moodDynamics.currentMood.moodType) {
        case (#Elated) { "Elated" };
        case (#Happy) { "Happy" };
        case (#Calm) { "Calm" };
        case (#Relaxed) { "Relaxed" };
        case (#Bored) { "Bored" };
        case (#Depressed) { "Depressed" };
        case (#Sad) { "Sad" };
        case (#Stressed) { "Stressed" };
        case (#Anxious) { "Anxious" };
        case (#Angry) { "Angry" };
        case (#Excited) { "Excited" };
        case (#Neutral) { "Neutral" };
      };
      moodStability = intState.moodDynamics.currentMood.stability;
      emotionalSynchrony = intState.socialEmotions.emotionalContagion.emotionalSynchrony;
      resilienceLevel = intState.emotionalResilience.bounceBackCapacity;
      integratedCoherence = intState.integratedEmotionalCoherence;
      emotionalWellbeing = intState.emotionalWellbeing;
      processingTime = Time.now() - startTime;
    }
  };
  
  public type IntegratedEmotionalResult = {
    baseResult : EmotionalTickResult;
    emotionalIntelligenceScore : Float;
    currentMoodType : Text;
    moodStability : Float;
    emotionalSynchrony : Float;
    resilienceLevel : Float;
    integratedCoherence : Float;
    emotionalWellbeing : Float;
    processingTime : Int;
  };
  
  /// Get integrated emotional status
  public func getIntegratedEmotionalStatus(intState : IntegratedEmotionalState) : IntegratedEmotionalStatus {
    {
      baseStatus = getEmotionalStatus(intState.baseState);
      emotionalIntelligence = {
        selfAwareness = intState.emotionalIntelligence.selfAwareness.emotionalClarity;
        selfRegulation = intState.emotionalIntelligence.selfRegulation.emotionalStability;
        motivation = intState.emotionalIntelligence.motivation.achievementDrive;
        empathy = intState.emotionalIntelligence.empathicAbility.emotionalEmpathy;
        socialSkills = intState.emotionalIntelligence.socialSkills.socialAwareness;
      };
      moodState = {
        valence = intState.moodDynamics.currentMood.valence;
        energy = intState.moodDynamics.currentMood.energy;
        tension = intState.moodDynamics.currentMood.tension;
        moodType = switch (intState.moodDynamics.currentMood.moodType) {
          case (#Elated) { "Elated" };
          case (#Happy) { "Happy" };
          case (#Calm) { "Calm" };
          case (#Relaxed) { "Relaxed" };
          case (#Bored) { "Bored" };
          case (#Depressed) { "Depressed" };
          case (#Sad) { "Sad" };
          case (#Stressed) { "Stressed" };
          case (#Anxious) { "Anxious" };
          case (#Angry) { "Angry" };
          case (#Excited) { "Excited" };
          case (#Neutral) { "Neutral" };
        };
      };
      emotionalMemory = {
        flashbulbCount = intState.emotionalMemory.flashbulbMemories.size();
        traumaProcessingStatus = switch (intState.emotionalMemory.traumaticMemory.processingStatus) {
          case (#Unprocessed) { "Unprocessed" };
          case (#Processing) { "Processing" };
          case (#PartiallyProcessed) { "PartiallyProcessed" };
          case (#Integrated) { "Integrated" };
          case (#Resolved) { "Resolved" };
        };
        nostalgiaFrequency = intState.emotionalMemory.nostalgiaState.nostalgiaFrequency;
      };
      socialEmotions = {
        attachmentSecurity = intState.socialEmotions.attachmentEmotions.attachmentSecurity;
        groupIdentification = intState.socialEmotions.groupEmotions.groupIdentification;
        emotionalSynchrony = intState.socialEmotions.emotionalContagion.emotionalSynchrony;
      };
      resilience = {
        bounceBack = intState.emotionalResilience.bounceBackCapacity;
        hopefulness = intState.emotionalResilience.hopefulness;
        selfCompassion = intState.emotionalResilience.selfCompassion;
      };
      integratedCoherence = intState.integratedEmotionalCoherence;
      emotionalWellbeing = intState.emotionalWellbeing;
    }
  };
  
  public type IntegratedEmotionalStatus = {
    baseStatus : EmotionalStatus;
    emotionalIntelligence : {
      selfAwareness : Float;
      selfRegulation : Float;
      motivation : Float;
      empathy : Float;
      socialSkills : Float;
    };
    moodState : {
      valence : Float;
      energy : Float;
      tension : Float;
      moodType : Text;
    };
    emotionalMemory : {
      flashbulbCount : Nat;
      traumaProcessingStatus : Text;
      nostalgiaFrequency : Float;
    };
    socialEmotions : {
      attachmentSecurity : Float;
      groupIdentification : Float;
      emotionalSynchrony : Float;
    };
    resilience : {
      bounceBack : Float;
      hopefulness : Float;
      selfCompassion : Float;
    };
    integratedCoherence : Float;
    emotionalWellbeing : Float;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // EMOTIONAL DEVELOPMENT - ONTOGENY OF AFFECT
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type EmotionalDevelopmentState = {
    var attachmentSystem : AttachmentSystemState;
    var emotionSocialization : EmotionSocializationState;
    var emotionalCompetence : EmotionalCompetenceState;
    var temperament : TemperamentState;
    var developmentalMilestones : DevelopmentalMilestones;
    var emotionalMaturity : Float;
  };
  
  public type AttachmentSystemState = {
    var attachmentStyle : AttachmentStyle;
    var internalWorkingModels : InternalWorkingModels;
    var attachmentBehaviors : AttachmentBehaviors;
    var attachmentSecurity : Float;
    var explorationBalance : Float;
  };
  
  public type AttachmentStyle = {
    #SecureAutonomous;
    #InsecureAvoidant;
    #InsecureAmbivalent;
    #Disorganized;
    #Earned Secure;
  };
  
  public type InternalWorkingModels = {
    var selfModel : Float;
    var otherModel : Float;
    var relationshipExpectations : Float;
    var trustworthiness : Float;
    var worthinessOfLove : Float;
  };
  
  public type AttachmentBehaviors = {
    var proximitySeeling : Float;
    var safehavenUse : Float;
    var secureBaseExploration : Float;
    var separationProtest : Float;
    var reunionBehavior : Float;
  };
  
  public type EmotionSocializationState = {
    var parentalEmotionCoaching : Float;
    var emotionDismissing : Float;
    var emotionModelingQuality : Float;
    var emotionTalkFrequency : Float;
    var culturalDisplayRules : [[Float]];
    var familyEmotionalClimate : Float;
  };
  
  public type EmotionalCompetenceState = {
    var emotionalAwareness : Float;
    var emotionalVocabulary : Nat;
    var emotionalExpression : Float;
    var empathicConcern : Float;
    var emotionalRegulationSkills : Float;
    var emotionalUnderstanding : Float;
    var emotionalCommunication : Float;
  };
  
  public type TemperamentState = {
    var effortfulControl : Float;
    var negativeAffectivity : Float;
    var surgencyExtraversion : Float;
    var orienting Sensitivity : Float;
    var frustrationTolerance : Float;
    var inhibitoryControl : Float;
    var attentionalFocusing : Float;
  };
  
  public type DevelopmentalMilestones = {
    var socialSmile : Bool;
    var strangerAnxiety : Bool;
    var selfConscious Emotions : Bool;
    var emotionRegulation Strategy : Bool;
    var theoryOfMindEmotions : Bool;
    var complexEmotions : Bool;
    var emotionalAbstraction : Bool;
  };
  
  /// Initialize emotional development state
  public func initEmotionalDevelopmentState() : EmotionalDevelopmentState {
    {
      var attachmentSystem = {
        var attachmentStyle = #SecureAutonomous;
        var internalWorkingModels = {
          var selfModel = 0.7;
          var otherModel = 0.7;
          var relationshipExpectations = 0.6;
          var trustworthiness = 0.7;
          var worthinessOfLove = 0.7;
        };
        var attachmentBehaviors = {
          var proximitySeeling = 0.5;
          var safehavenUse = 0.6;
          var secureBaseExploration = 0.7;
          var separationProtest = 0.3;
          var reunionBehavior = 0.7;
        };
        var attachmentSecurity = 0.7;
        var explorationBalance = 0.6;
      };
      var emotionSocialization = {
        var parentalEmotionCoaching = 0.6;
        var emotionDismissing = 0.2;
        var emotionModelingQuality = 0.6;
        var emotionTalkFrequency = 0.5;
        var culturalDisplayRules = [];
        var familyEmotionalClimate = 0.6;
      };
      var emotionalCompetence = {
        var emotionalAwareness = 0.6;
        var emotionalVocabulary = 50;
        var emotionalExpression = 0.6;
        var empathicConcern = 0.5;
        var emotionalRegulationSkills = 0.5;
        var emotionalUnderstanding = 0.5;
        var emotionalCommunication = 0.5;
      };
      var temperament = {
        var effortfulControl = 0.5;
        var negativeAffectivity = 0.3;
        var surgencyExtraversion = 0.5;
        var orientingSensitivity = 0.5;
        var frustrationTolerance = 0.5;
        var inhibitoryControl = 0.5;
        var attentionalFocusing = 0.5;
      };
      var developmentalMilestones = {
        var socialSmile = true;
        var strangerAnxiety = true;
        var selfConsciousEmotions = true;
        var emotionRegulationStrategy = true;
        var theoryOfMindEmotions = true;
        var complexEmotions = true;
        var emotionalAbstraction = true;
      };
      var emotionalMaturity = 0.6;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // AFFECTIVE NEUROSCIENCE - NEURAL SUBSTRATES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type AffectiveNeuroscienceState = {
    var seekingSystem : SeekingSystemState;
    var rageSystem : RageSystemState;
    var fearSystem : FearSystemState;
    var lustSystem : LustSystemState;
    var careSystem : CareSystemState;
    var panicGriefSystem : PanicGriefSystemState;
    var playSystem : PlaySystemState;
    var neuralCircuits : AffectiveNeuralCircuits;
  };
  
  public type SeekingSystemState = {
    var dopamineLevel : Float;
    var ventTegmentalActivity : Float;
    var nucleusAccumbensActivity : Float;
    var anticipatoryExcitement : Float;
    var exploratoryUrge : Float;
    var curiosity : Float;
    var rewardPrediction : Float;
  };
  
  public type RageSystemState = {
    var hypothalamicActivation : Float;
    var amygdalaRage : Float;
    var periaquductalGray : Float;
    var frustrationLevel : Float;
    var aggressiveUrge : Float;
    var angerIntensity : Float;
    var hostility : Float;
  };
  
  public type FearSystemState = {
    var amygdalaActivity : Float;
    var hypothalamicDefense : Float;
    var pagFreeze : Float;
    var pagFlight : Float;
    var threatDetection : Float;
    var anxietyLevel : Float;
    var panicThreshold : Float;
  };
  
  public type LustSystemState = {
    var hypothalamicArousal : Float;
    var testosteroneEffect : Float;
    var estrogenEffect : Float;
    var sexualMotivation : Float;
    var attractionIntensity : Float;
    var consummatory Drive : Float;
  };
  
  public type CareSystemState = {
    var oxytocinLevel : Float;
    var prolactinLevel : Float;
    var anteriorCingulate : Float;
    var nurturingUrge : Float;
    var protectiveInstinct : Float;
    var bondingStrength : Float;
    var empathicResonance : Float;
  };
  
  public type PanicGriefSystemState = {
    var separationDistress : Float;
    var opioidWithdrawal : Float;
    var anteriorCingulateGrief : Float;
    var panicLevel : Float;
    var lonelinessIntensity : Float;
    var griefDepth : Float;
    var yearning : Float;
  };
  
  public type PlaySystemState = {
    var dorsoPagActivity : Float;
    var thalamusPlay : Float;
    var playfulness : Float;
    var joyfulEngagement : Float;
    var socialPlay : Float;
    var roughAndTumble : Float;
    var ludic Enjoyment : Float;
  };
  
  public type AffectiveNeuralCircuits = {
    var amygdalaHippocampus : Float;
    var pfcAmygdala : Float;
    var insulaAnteriorCingulate : Float;
    var striatumOrbitofrontal : Float;
    var hypothalamicPituitary : Float;
    var vagalTone : Float;
    var heartRateVariability : Float;
  };
  
  /// Initialize affective neuroscience state
  public func initAffectiveNeuroscienceState() : AffectiveNeuroscienceState {
    {
      var seekingSystem = {
        var dopamineLevel = 0.5;
        var ventTegmentalActivity = 0.5;
        var nucleusAccumbensActivity = 0.5;
        var anticipatoryExcitement = 0.5;
        var exploratoryUrge = 0.5;
        var curiosity = 0.6;
        var rewardPrediction = 0.5;
      };
      var rageSystem = {
        var hypothalamicActivation = 0.2;
        var amygdalaRage = 0.1;
        var periaquductalGray = 0.2;
        var frustrationLevel = 0.2;
        var aggressiveUrge = 0.1;
        var angerIntensity = 0.1;
        var hostility = 0.1;
      };
      var fearSystem = {
        var amygdalaActivity = 0.3;
        var hypothalamicDefense = 0.2;
        var pagFreeze = 0.1;
        var pagFlight = 0.1;
        var threatDetection = 0.3;
        var anxietyLevel = 0.2;
        var panicThreshold = 0.7;
      };
      var lustSystem = {
        var hypothalamicArousal = 0.3;
        var testosteroneEffect = 0.5;
        var estrogenEffect = 0.5;
        var sexualMotivation = 0.3;
        var attractionIntensity = 0.3;
        var consummatoryDrive = 0.3;
      };
      var careSystem = {
        var oxytocinLevel = 0.5;
        var prolactinLevel = 0.4;
        var anteriorCingulate = 0.5;
        var nurturingUrge = 0.5;
        var protectiveInstinct = 0.5;
        var bondingStrength = 0.5;
        var empathicResonance = 0.5;
      };
      var panicGriefSystem = {
        var separationDistress = 0.2;
        var opioidWithdrawal = 0.1;
        var anteriorCingulateGrief = 0.2;
        var panicLevel = 0.1;
        var lonelinessIntensity = 0.2;
        var griefDepth = 0.1;
        var yearning = 0.2;
      };
      var playSystem = {
        var dorsoPagActivity = 0.5;
        var thalamusPlay = 0.5;
        var playfulness = 0.5;
        var joyfulEngagement = 0.5;
        var socialPlay = 0.5;
        var roughAndTumble = 0.3;
        var ludicEnjoyment = 0.5;
      };
      var neuralCircuits = {
        var amygdalaHippocampus = 0.5;
        var pfcAmygdala = 0.6;
        var insulaAnteriorCingulate = 0.5;
        var striatumOrbitofrontal = 0.5;
        var hypothalamicPituitary = 0.5;
        var vagalTone = 0.5;
        var heartRateVariability = 50.0;
      };
    }
  };
  
  /// Process Panksepp affective systems
  public func processPankseppSystems(affState : AffectiveNeuroscienceState, stimulus : [Float], context : Float) {
    let stimulusValence = if (stimulus.size() > 0) { stimulus[0] } else { 0.0 };
    let stimulusArousal = if (stimulus.size() > 1) { stimulus[1] } else { 0.5 };
    let stimulusThreat = if (stimulus.size() > 2) { stimulus[2] } else { 0.0 };
    let stimulusSocial = if (stimulus.size() > 3) { stimulus[3] } else { 0.5 };
    
    // SEEKING system - activated by novelty and positive valence
    if (stimulusValence > 0.5 and stimulusArousal > 0.3) {
      affState.seekingSystem.dopamineLevel := 
        Float.min(1.0, affState.seekingSystem.dopamineLevel + stimulusValence * 0.1);
      affState.seekingSystem.anticipatoryExcitement := 
        Float.min(1.0, affState.seekingSystem.anticipatoryExcitement + 0.1);
    };
    
    // FEAR system - activated by threat
    if (stimulusThreat > 0.5) {
      affState.fearSystem.amygdalaActivity := 
        Float.min(1.0, affState.fearSystem.amygdalaActivity + stimulusThreat * 0.2);
      affState.fearSystem.threatDetection := 
        Float.min(1.0, affState.fearSystem.threatDetection + 0.1);
    };
    
    // RAGE system - activated by frustration
    if (stimulusValence < -0.5 and context < 0.5) {
      affState.rageSystem.frustrationLevel := 
        Float.min(1.0, affState.rageSystem.frustrationLevel + 0.1);
    };
    
    // CARE system - activated by social bonding cues
    if (stimulusSocial > 0.6 and stimulusValence > 0.3) {
      affState.careSystem.oxytocinLevel := 
        Float.min(1.0, affState.careSystem.oxytocinLevel + stimulusSocial * 0.1);
      affState.careSystem.empathicResonance := 
        Float.min(1.0, affState.careSystem.empathicResonance + 0.05);
    };
    
    // PANIC/GRIEF system - activated by separation
    if (stimulusSocial < 0.3 and stimulusValence < 0.0) {
      affState.panicGriefSystem.separationDistress := 
        Float.min(1.0, affState.panicGriefSystem.separationDistress + 0.1);
    };
    
    // PLAY system - activated by safe social contexts
    if (stimulusSocial > 0.5 and stimulusThreat < 0.2 and stimulusArousal > 0.4) {
      affState.playSystem.playfulness := 
        Float.min(1.0, affState.playSystem.playfulness + 0.1);
    };
    
    // Decay all systems toward baseline
    affState.seekingSystem.dopamineLevel := affState.seekingSystem.dopamineLevel * 0.98;
    affState.fearSystem.amygdalaActivity := affState.fearSystem.amygdalaActivity * 0.95;
    affState.rageSystem.frustrationLevel := affState.rageSystem.frustrationLevel * 0.95;
    affState.careSystem.oxytocinLevel := affState.careSystem.oxytocinLevel * 0.99;
    affState.panicGriefSystem.separationDistress := affState.panicGriefSystem.separationDistress * 0.95;
    affState.playSystem.playfulness := affState.playSystem.playfulness * 0.98;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // INTEGRATED DEEP EMOTIONAL TICK
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type DeepIntegratedEmotionalState = {
    var baseState : IntegratedEmotionalState;
    var emotionalDevelopment : EmotionalDevelopmentState;
    var affectiveNeuroscience : AffectiveNeuroscienceState;
    var deepEmotionalIntegration : Float;
    var emotionalMaturityIndex : Float;
  };
  
  /// Run deep integrated emotional tick
  public func runDeepIntegratedEmotionalTick(
    deepState : DeepIntegratedEmotionalState,
    stimulus : [Float],
    socialContext : Float,
    dt : Float
  ) : DeepIntegratedEmotionalResult {
    let startTime = Time.now();
    
    // 1. Run base emotional processing
    let baseResult = runIntegratedEmotionalTick(deepState.baseState, stimulus, dt);
    
    // 2. Process Panksepp affective systems
    processPankseppSystems(deepState.affectiveNeuroscience, stimulus, socialContext);
    
    // 3. Compute deep emotional integration
    deepState.deepEmotionalIntegration := (
      baseResult.integratedCoherence * 0.4 +
      deepState.emotionalDevelopment.attachmentSystem.attachmentSecurity * 0.3 +
      deepState.affectiveNeuroscience.neuralCircuits.pfcAmygdala * 0.3
    );
    
    // 4. Compute emotional maturity index
    deepState.emotionalMaturityIndex := (
      deepState.emotionalDevelopment.emotionalCompetence.emotionalRegulationSkills * 0.3 +
      deepState.emotionalDevelopment.temperament.effortfulControl * 0.3 +
      deepState.affectiveNeuroscience.careSystem.empathicResonance * 0.4
    );
    
    {
      baseResult = baseResult;
      attachmentSecurity = deepState.emotionalDevelopment.attachmentSystem.attachmentSecurity;
      emotionalCompetence = deepState.emotionalDevelopment.emotionalCompetence.emotionalRegulationSkills;
      seekingActivity = deepState.affectiveNeuroscience.seekingSystem.dopamineLevel;
      careActivity = deepState.affectiveNeuroscience.careSystem.oxytocinLevel;
      fearActivity = deepState.affectiveNeuroscience.fearSystem.amygdalaActivity;
      deepEmotionalIntegration = deepState.deepEmotionalIntegration;
      emotionalMaturityIndex = deepState.emotionalMaturityIndex;
      processingTime = Time.now() - startTime;
    }
  };
  
  public type DeepIntegratedEmotionalResult = {
    baseResult : IntegratedEmotionalResult;
    attachmentSecurity : Float;
    emotionalCompetence : Float;
    seekingActivity : Float;
    careActivity : Float;
    fearActivity : Float;
    deepEmotionalIntegration : Float;
    emotionalMaturityIndex : Float;
    processingTime : Int;
  };
  
  /// Get deep integrated emotional status
  public func getDeepIntegratedEmotionalStatus(deepState : DeepIntegratedEmotionalState) : DeepIntegratedEmotionalStatus {
    {
      baseStatus = getIntegratedEmotionalStatus(deepState.baseState);
      emotionalDevelopmentStatus = {
        attachmentStyle = switch (deepState.emotionalDevelopment.attachmentSystem.attachmentStyle) {
          case (#SecureAutonomous) { "SecureAutonomous" };
          case (#InsecureAvoidant) { "InsecureAvoidant" };
          case (#InsecureAmbivalent) { "InsecureAmbivalent" };
          case (#Disorganized) { "Disorganized" };
          case (#EarnedSecure) { "EarnedSecure" };
        };
        attachmentSecurity = deepState.emotionalDevelopment.attachmentSystem.attachmentSecurity;
        emotionalCompetence = deepState.emotionalDevelopment.emotionalCompetence.emotionalRegulationSkills;
        effortfulControl = deepState.emotionalDevelopment.temperament.effortfulControl;
        emotionalMaturity = deepState.emotionalDevelopment.emotionalMaturity;
      };
      affectiveNeuroscienceStatus = {
        seekingDopamine = deepState.affectiveNeuroscience.seekingSystem.dopamineLevel;
        careOxytocin = deepState.affectiveNeuroscience.careSystem.oxytocinLevel;
        fearAmygdala = deepState.affectiveNeuroscience.fearSystem.amygdalaActivity;
        playfulness = deepState.affectiveNeuroscience.playSystem.playfulness;
        vagalTone = deepState.affectiveNeuroscience.neuralCircuits.vagalTone;
        pfcAmygdalaRegulation = deepState.affectiveNeuroscience.neuralCircuits.pfcAmygdala;
      };
      deepEmotionalIntegration = deepState.deepEmotionalIntegration;
      emotionalMaturityIndex = deepState.emotionalMaturityIndex;
    }
  };
  
  public type DeepIntegratedEmotionalStatus = {
    baseStatus : IntegratedEmotionalStatus;
    emotionalDevelopmentStatus : {
      attachmentStyle : Text;
      attachmentSecurity : Float;
      emotionalCompetence : Float;
      effortfulControl : Float;
      emotionalMaturity : Float;
    };
    affectiveNeuroscienceStatus : {
      seekingDopamine : Float;
      careOxytocin : Float;
      fearAmygdala : Float;
      playfulness : Float;
      vagalTone : Float;
      pfcAmygdalaRegulation : Float;
    };
    deepEmotionalIntegration : Float;
    emotionalMaturityIndex : Float;
  };
}
