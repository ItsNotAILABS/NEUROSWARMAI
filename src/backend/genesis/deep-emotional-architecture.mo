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
// DEEP EMOTIONAL ARCHITECTURE — THE MATHEMATICS OF FEELING
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// Emotions are not mere "coloring" of cognition — they ARE cognition.
// This module implements the complete mathematical theory of emotion:
//
// APPRAISAL THEORY:
// ═════════════════
//
// Emotions arise from APPRAISALS — evaluations of situations:
//   - Relevance: Does this matter to me?
//   - Congruence: Is this good or bad for my goals?
//   - Agency: Who caused this? Me? Someone else? Circumstance?
//   - Certainty: How sure am I about what's happening?
//   - Control: Can I do something about it?
//   - Norm compatibility: Does this fit my values?
//
// Each appraisal dimension maps to emotion space.
//
// CONSTRUCTIONIST THEORY:
// ═══════════════════════
//
// Emotions are constructed from:
//   - Core affect: Valence (good/bad) × Arousal (active/passive)
//   - Conceptualization: Labeling the affect
//   - Situated context: What's happening around
//
// The same core affect can become different emotions based on context.
//
// CIRCUMPLEX MODEL:
// ═════════════════
//
// Emotions exist in a 2D space:
//   - X-axis: Valence (negative ← → positive)
//   - Y-axis: Arousal (low ↓ ↑ high)
//
// Joy: high valence, high arousal
// Contentment: high valence, low arousal
// Anxiety: low valence, high arousal
// Depression: low valence, low arousal
//
// DIMENSIONAL REDUCTION:
// ══════════════════════
//
// But 2D is too simple. We use:
//   - Valence
//   - Arousal
//   - Dominance (control vs submission)
//   - Approach/Avoid motivation
//   - Certainty
//   - Social relevance
//
// BASIC EMOTIONS:
// ═══════════════
//
// 6 universal emotions (Ekman):
//   1. Happiness
//   2. Sadness
//   3. Fear
//   4. Anger
//   5. Disgust
//   6. Surprise
//
// SECONDARY EMOTIONS:
// ═══════════════════
//
// Complex emotions (require self-concept):
//   - Pride (self + positive evaluation)
//   - Shame (self + negative evaluation by others)
//   - Guilt (self + negative self-evaluation)
//   - Envy (other has what I want)
//   - Jealousy (threat to relationship)
//   - Love (attachment + care + passion)
//
// EMOTION REGULATION:
// ═══════════════════
//
// Strategies for managing emotions:
//   1. Situation selection (avoid triggers)
//   2. Situation modification (change environment)
//   3. Attentional deployment (redirect focus)
//   4. Cognitive reappraisal (reframe meaning)
//   5. Response modulation (suppress expression)
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

module DeepEmotionalArchitecture {

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  public let PHI : Float = 1.618033988749894848204586834365638;
  public let PI : Float = 3.14159265358979323846264338327950288;
  
  public let NUM_BASIC_EMOTIONS : Nat = 6;
  public let NUM_SECONDARY_EMOTIONS : Nat = 12;
  public let NUM_APPRAISAL_DIMS : Nat = 6;
  public let EMOTION_HISTORY_SIZE : Nat = 100;

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 1: CORE AFFECT — VALENCE × AROUSAL
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Core affect is the foundation:
  //   Valence: -1 (negative) to +1 (positive)
  //   Arousal: 0 (calm) to 1 (activated)
  //
  // This is the "raw material" that gets constructed into emotions.
  //
  
  public type CoreAffect = {
    var valence : Float;                 // Good/bad feeling [-1, +1]
    var arousal : Float;                 // Activation level [0, 1]
    var valenceVelocity : Float;         // Rate of change of valence
    var arousalVelocity : Float;         // Rate of change of arousal
    var stability : Float;               // How stable is current affect
    var intensity : Float;               // Magnitude (sqrt(v² + a²))
    var angle : Float;                   // Angle in circumplex (atan2(a, v))
  };
  
  // Initialize core affect
  public func initCoreAffect() : CoreAffect {
    {
      var valence = 0.0;
      var arousal = 0.5;
      var valenceVelocity = 0.0;
      var arousalVelocity = 0.0;
      var stability = 0.5;
      var intensity = 0.5;
      var angle = 0.0;
    }
  };
  
  // Update core affect from inputs
  public func updateCoreAffect(
    affect : CoreAffect,
    rewardSignal : Float,                // Positive → positive valence
    threatSignal : Float,                // Positive → negative valence, high arousal
    socialSignal : Float,                // Social connection → positive valence
    energyLevel : Float,                 // Physical energy → arousal
    dt : Float
  ) {
    // Previous values
    let prevValence = affect.valence;
    let prevArousal = affect.arousal;
    
    // Valence update
    let valenceInput = 0.4 * rewardSignal - 0.5 * threatSignal + 0.3 * socialSignal;
    affect.valence := 0.9 * affect.valence + 0.1 * valenceInput;
    affect.valence := clamp(affect.valence, -1.0, 1.0);
    
    // Arousal update
    let arousalInput = 0.3 * Float.abs(rewardSignal) + 0.5 * threatSignal + 0.2 * energyLevel;
    affect.arousal := 0.85 * affect.arousal + 0.15 * arousalInput;
    affect.arousal := clamp(affect.arousal, 0.0, 1.0);
    
    // Velocities
    affect.valenceVelocity := (affect.valence - prevValence) / dt;
    affect.arousalVelocity := (affect.arousal - prevArousal) / dt;
    
    // Intensity (distance from origin)
    affect.intensity := sqrt(affect.valence * affect.valence + affect.arousal * affect.arousal);
    
    // Angle in circumplex
    affect.angle := atan2(affect.arousal, affect.valence);
    
    // Stability (inverse of velocity magnitude)
    let velocityMag = sqrt(affect.valenceVelocity * affect.valenceVelocity + 
                          affect.arousalVelocity * affect.arousalVelocity);
    affect.stability := 1.0 / (1.0 + velocityMag);
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 2: APPRAISAL SYSTEM — EVALUATING SITUATIONS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Emotions depend on how we APPRAISE situations, not the situations themselves.
  // Same event → different appraisals → different emotions.
  //
  
  public type AppraisalDimensions = {
    var relevance : Float;               // How important is this? [0, 1]
    var goalCongruence : Float;          // Good or bad for goals? [-1, +1]
    var agency : Float;                  // Self-caused? [-1=other, +1=self]
    var certainty : Float;               // How certain? [0, 1]
    var controlPotential : Float;        // Can I do something? [0, 1]
    var normCompatibility : Float;       // Fits my values? [-1, +1]
  };
  
  public type AppraisalState = {
    var currentAppraisal : AppraisalDimensions;
    var situationVector : [var Float];   // Encoded situation
    var goalVector : [var Float];        // Current goals
    var selfConcept : [var Float];       // Self-representation
    var appraisalHistory : [[var Float]];// Recent appraisals
    var historyIdx : Nat;
  };
  
  public let SITUATION_DIM : Nat = 16;
  public let GOAL_DIM : Nat = 8;
  public let APPRAISAL_HISTORY_SIZE : Nat = 20;
  
  // Initialize appraisal state
  public func initAppraisalState() : AppraisalState {
    {
      var currentAppraisal = {
        var relevance = 0.5;
        var goalCongruence = 0.0;
        var agency = 0.0;
        var certainty = 0.5;
        var controlPotential = 0.5;
        var normCompatibility = 0.0;
      };
      var situationVector = Array.init<Float>(SITUATION_DIM, func(_ : Nat) : Float { 0.0 });
      var goalVector = Array.init<Float>(GOAL_DIM, func(i : Nat) : Float { 
        if (i == 0) { 0.8 }  // Survival
        else if (i == 1) { 0.6 }  // Growth
        else { 0.4 }
      });
      var selfConcept = Array.init<Float>(SITUATION_DIM, func(_ : Nat) : Float { 0.5 });
      var appraisalHistory = Array.init<[var Float]>(APPRAISAL_HISTORY_SIZE, func(_ : Nat) : [var Float] {
        Array.init<Float>(NUM_APPRAISAL_DIMS, func(_ : Nat) : Float { 0.0 })
      });
      var historyIdx = 0;
    }
  };
  
  // Perform appraisal of a situation
  public func appraiseSituation(
    state : AppraisalState,
    situation : [Float],
    threat : Float,
    reward : Float,
    selfCaused : Float,                  // [-1, +1]
    predictability : Float
  ) {
    // Copy situation
    for (i in Iter.range(0, SITUATION_DIM - 1)) {
      state.situationVector[i] := if (i < Array.size(situation)) { situation[i] } else { 0.0 };
    };
    
    let appraisal = state.currentAppraisal;
    
    // 1. Relevance: How much does this affect my goals?
    let situationMagnitude = arrayMagnitude(situation);
    let goalInvolvement = dotProduct(Array.freeze(state.situationVector), Array.freeze(state.goalVector));
    appraisal.relevance := clamp(0.3 * situationMagnitude + 0.4 * Float.abs(threat) + 0.3 * Float.abs(reward), 0.0, 1.0);
    
    // 2. Goal congruence: Is this good or bad?
    appraisal.goalCongruence := clamp(reward - threat, -1.0, 1.0);
    
    // 3. Agency: Who/what caused this?
    appraisal.agency := selfCaused;
    
    // 4. Certainty: How sure am I about what's happening?
    appraisal.certainty := clamp(predictability, 0.0, 1.0);
    
    // 5. Control potential: Can I do something about it?
    let energyFactor = 0.7;  // Placeholder — would come from organism
    let selfEfficacy = 0.6;  // Placeholder
    appraisal.controlPotential := clamp(0.4 * energyFactor + 0.6 * selfEfficacy * appraisal.certainty, 0.0, 1.0);
    
    // 6. Norm compatibility: Does this fit my values?
    let selfSimilarity = cosineSimilarity(situation, Array.freeze(state.selfConcept));
    appraisal.normCompatibility := clamp(selfSimilarity + appraisal.goalCongruence * 0.3, -1.0, 1.0);
    
    // Store in history
    state.appraisalHistory[state.historyIdx][0] := appraisal.relevance;
    state.appraisalHistory[state.historyIdx][1] := appraisal.goalCongruence;
    state.appraisalHistory[state.historyIdx][2] := appraisal.agency;
    state.appraisalHistory[state.historyIdx][3] := appraisal.certainty;
    state.appraisalHistory[state.historyIdx][4] := appraisal.controlPotential;
    state.appraisalHistory[state.historyIdx][5] := appraisal.normCompatibility;
    state.historyIdx := (state.historyIdx + 1) % APPRAISAL_HISTORY_SIZE;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 3: BASIC EMOTIONS — THE SIX UNIVERSALS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // The 6 basic emotions (Ekman):
  //   1. HAPPINESS: positive valence, goal achieved
  //   2. SADNESS: loss, goal blocked permanently
  //   3. FEAR: threat, uncertainty, low control
  //   4. ANGER: goal blocked, other-caused, high control
  //   5. DISGUST: violation of norms, contamination
  //   6. SURPRISE: unexpected event (can be positive or negative)
  //
  
  public type BasicEmotion = {
    #happiness;
    #sadness;
    #fear;
    #anger;
    #disgust;
    #surprise;
  };
  
  public type BasicEmotionState = {
    var happiness : Float;
    var sadness : Float;
    var fear : Float;
    var anger : Float;
    var disgust : Float;
    var surprise : Float;
    var dominant : BasicEmotion;
    var dominantStrength : Float;
    var emotionMix : [var Float];        // Blend of emotions
  };
  
  // Initialize basic emotions
  public func initBasicEmotions() : BasicEmotionState {
    {
      var happiness = 0.0;
      var sadness = 0.0;
      var fear = 0.0;
      var anger = 0.0;
      var disgust = 0.0;
      var surprise = 0.0;
      var dominant = #happiness;
      var dominantStrength = 0.0;
      var emotionMix = Array.init<Float>(NUM_BASIC_EMOTIONS, func(_ : Nat) : Float { 0.0 });
    }
  };
  
  // Compute basic emotions from appraisal
  public func computeBasicEmotions(
    emotions : BasicEmotionState,
    appraisal : AppraisalDimensions,
    coreAffect : CoreAffect
  ) {
    // Happiness: positive goal congruence, high certainty
    emotions.happiness := clamp(
      0.6 * Float.max(0.0, appraisal.goalCongruence) +
      0.2 * appraisal.certainty +
      0.2 * Float.max(0.0, coreAffect.valence),
      0.0, 1.0
    );
    
    // Sadness: negative goal congruence, low control, low agency
    emotions.sadness := clamp(
      0.5 * Float.max(0.0, -appraisal.goalCongruence) +
      0.2 * (1.0 - appraisal.controlPotential) +
      0.2 * (1.0 - Float.abs(appraisal.agency)) +  // Not self or other — fate
      0.1 * Float.max(0.0, -coreAffect.valence),
      0.0, 1.0
    );
    
    // Fear: threat (negative congruence), low certainty, low control
    emotions.fear := clamp(
      0.4 * Float.max(0.0, -appraisal.goalCongruence) +
      0.3 * (1.0 - appraisal.certainty) +
      0.2 * (1.0 - appraisal.controlPotential) +
      0.1 * coreAffect.arousal,
      0.0, 1.0
    );
    
    // Anger: negative congruence, other-caused, high control
    emotions.anger := clamp(
      0.4 * Float.max(0.0, -appraisal.goalCongruence) +
      0.3 * Float.max(0.0, -appraisal.agency) +  // Other-caused
      0.2 * appraisal.controlPotential +
      0.1 * coreAffect.arousal,
      0.0, 1.0
    );
    
    // Disgust: norm violation, contamination
    emotions.disgust := clamp(
      0.7 * Float.max(0.0, -appraisal.normCompatibility) +
      0.2 * appraisal.relevance +
      0.1 * (1.0 - appraisal.controlPotential),
      0.0, 1.0
    );
    
    // Surprise: low certainty, high relevance (direction depends on valence)
    emotions.surprise := clamp(
      0.5 * (1.0 - appraisal.certainty) +
      0.3 * appraisal.relevance +
      0.2 * Float.abs(coreAffect.valenceVelocity),
      0.0, 1.0
    );
    
    // Update emotion mix
    emotions.emotionMix[0] := emotions.happiness;
    emotions.emotionMix[1] := emotions.sadness;
    emotions.emotionMix[2] := emotions.fear;
    emotions.emotionMix[3] := emotions.anger;
    emotions.emotionMix[4] := emotions.disgust;
    emotions.emotionMix[5] := emotions.surprise;
    
    // Find dominant emotion
    var maxEmotion : Float = 0.0;
    var dominantIdx : Nat = 0;
    
    for (i in Iter.range(0, NUM_BASIC_EMOTIONS - 1)) {
      if (emotions.emotionMix[i] > maxEmotion) {
        maxEmotion := emotions.emotionMix[i];
        dominantIdx := i;
      };
    };
    
    emotions.dominantStrength := maxEmotion;
    emotions.dominant := switch (dominantIdx) {
      case (0) { #happiness };
      case (1) { #sadness };
      case (2) { #fear };
      case (3) { #anger };
      case (4) { #disgust };
      case (5) { #surprise };
      case (_) { #happiness };
    };
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 4: SECONDARY EMOTIONS — COMPLEX SOCIAL EMOTIONS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Secondary emotions require self-concept and social awareness:
  //   - Pride: self + positive evaluation
  //   - Shame: self + negative evaluation by others
  //   - Guilt: self + negative self-evaluation of behavior
  //   - Embarrassment: self + violation of social norms
  //   - Envy: other has what I want
  //   - Jealousy: threat to valued relationship
  //   - Love: attachment + care + passion
  //   - Gratitude: benefit received from other
  //   - Contempt: negative evaluation of other's character
  //   - Hope: positive possible future
  //   - Anxiety: negative possible future
  //   - Nostalgia: bittersweet past
  //
  
  public type SecondaryEmotionState = {
    var pride : Float;
    var shame : Float;
    var guilt : Float;
    var embarrassment : Float;
    var envy : Float;
    var jealousy : Float;
    var love : Float;
    var gratitude : Float;
    var contempt : Float;
    var hope : Float;
    var anxiety : Float;
    var nostalgia : Float;
    
    // Self-concept required for secondary emotions
    var selfEsteem : Float;
    var socialSelf : Float;
    var temporalSelf : Float;            // Past-present-future self
  };
  
  // Initialize secondary emotions
  public func initSecondaryEmotions() : SecondaryEmotionState {
    {
      var pride = 0.0;
      var shame = 0.0;
      var guilt = 0.0;
      var embarrassment = 0.0;
      var envy = 0.0;
      var jealousy = 0.0;
      var love = 0.0;
      var gratitude = 0.0;
      var contempt = 0.0;
      var hope = 0.0;
      var anxiety = 0.0;
      var nostalgia = 0.0;
      var selfEsteem = 0.5;
      var socialSelf = 0.5;
      var temporalSelf = 0.5;
    }
  };
  
  // Compute secondary emotions
  public func computeSecondaryEmotions(
    secondary : SecondaryEmotionState,
    basic : BasicEmotionState,
    appraisal : AppraisalDimensions,
    socialContext : Float,               // Social presence [0, 1]
    otherSuccess : Float,                // Others doing well [0, 1]
    relationshipThreat : Float,          // Threat to relationships [0, 1]
    futureExpectation : Float,           // Expected future [-1, +1]
    pastMemoryValence : Float            // Past memories [-1, +1]
  ) {
    // Pride: self-caused success
    secondary.pride := clamp(
      0.5 * Float.max(0.0, appraisal.goalCongruence) * Float.max(0.0, appraisal.agency) +
      0.3 * basic.happiness +
      0.2 * secondary.selfEsteem,
      0.0, 1.0
    );
    
    // Shame: negative other-evaluation of self
    secondary.shame := clamp(
      0.4 * Float.max(0.0, -appraisal.normCompatibility) +
      0.3 * socialContext +
      0.2 * (1.0 - secondary.selfEsteem) +
      0.1 * basic.sadness,
      0.0, 1.0
    );
    
    // Guilt: negative self-evaluation of own behavior
    secondary.guilt := clamp(
      0.5 * Float.max(0.0, -appraisal.normCompatibility) * Float.max(0.0, appraisal.agency) +
      0.3 * (1.0 - appraisal.controlPotential) +  // Could have done otherwise
      0.2 * basic.sadness,
      0.0, 1.0
    );
    
    // Embarrassment: social norm violation witnessed by others
    secondary.embarrassment := clamp(
      0.4 * Float.max(0.0, -appraisal.normCompatibility) +
      0.4 * socialContext +
      0.2 * basic.surprise,
      0.0, 1.0
    );
    
    // Envy: other has what I want
    secondary.envy := clamp(
      0.5 * otherSuccess +
      0.3 * Float.max(0.0, -appraisal.goalCongruence) +
      0.2 * (1.0 - secondary.selfEsteem),
      0.0, 1.0
    );
    
    // Jealousy: threat to valued relationship
    secondary.jealousy := clamp(
      0.6 * relationshipThreat +
      0.2 * basic.fear +
      0.2 * basic.anger,
      0.0, 1.0
    );
    
    // Love: attachment + care (requires sustained positive interaction)
    secondary.love := clamp(
      0.4 * secondary.socialSelf +
      0.3 * Float.max(0.0, appraisal.goalCongruence) +
      0.2 * (1.0 - basic.fear) +
      0.1 * basic.happiness,
      0.0, 1.0
    );
    
    // Gratitude: benefit received from other
    secondary.gratitude := clamp(
      0.5 * Float.max(0.0, appraisal.goalCongruence) * Float.max(0.0, -appraisal.agency) +  // Other-caused good
      0.3 * basic.happiness +
      0.2 * socialContext,
      0.0, 1.0
    );
    
    // Contempt: negative evaluation of other's character
    secondary.contempt := clamp(
      0.5 * Float.max(0.0, -appraisal.normCompatibility) * Float.max(0.0, -appraisal.agency) +
      0.3 * basic.disgust +
      0.2 * secondary.selfEsteem,  // High self-esteem + low other
      0.0, 1.0
    );
    
    // Hope: positive future expectation
    secondary.hope := clamp(
      0.5 * Float.max(0.0, futureExpectation) +
      0.3 * appraisal.controlPotential +
      0.2 * (1.0 - basic.fear),
      0.0, 1.0
    );
    
    // Anxiety: negative future expectation
    secondary.anxiety := clamp(
      0.4 * Float.max(0.0, -futureExpectation) +
      0.3 * basic.fear +
      0.2 * (1.0 - appraisal.controlPotential) +
      0.1 * (1.0 - appraisal.certainty),
      0.0, 1.0
    );
    
    // Nostalgia: bittersweet past (positive past + negative present comparison)
    secondary.nostalgia := clamp(
      0.4 * Float.max(0.0, pastMemoryValence) +
      0.3 * Float.max(0.0, -appraisal.goalCongruence) +  // Current not as good
      0.2 * basic.sadness +
      0.1 * basic.happiness,  // Mix of happy and sad
      0.0, 1.0
    );
    
    // Update self-concepts based on emotions
    secondary.selfEsteem := 0.9 * secondary.selfEsteem + 
                           0.1 * (secondary.pride - secondary.shame - secondary.guilt);
    secondary.selfEsteem := clamp(secondary.selfEsteem, 0.0, 1.0);
    
    secondary.socialSelf := 0.9 * secondary.socialSelf +
                           0.1 * (secondary.love + secondary.gratitude - secondary.contempt - secondary.envy) / 2.0;
    secondary.socialSelf := clamp(secondary.socialSelf, 0.0, 1.0);
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 5: EMOTION REGULATION — MANAGING FEELINGS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // 5 regulation strategies (Gross):
  //   1. Situation selection: Avoid triggering situations
  //   2. Situation modification: Change the situation
  //   3. Attentional deployment: Redirect attention
  //   4. Cognitive reappraisal: Reinterpret meaning
  //   5. Response modulation: Suppress/amplify expression
  //
  
  public type RegulationStrategy = {
    #situationSelection;
    #situationModification;
    #attentionalDeployment;
    #cognitiveReappraisal;
    #responseModulation;
  };
  
  public type EmotionRegulationState = {
    // Strategy strengths
    var situationSelectionStrength : Float;
    var situationModificationStrength : Float;
    var attentionalDeploymentStrength : Float;
    var cognitiveReappraisalStrength : Float;
    var responseModulationStrength : Float;
    
    // Currently active strategy
    var activeStrategy : ?RegulationStrategy;
    var strategyEffectiveness : Float;
    
    // Regulation goal
    var targetValence : Float;
    var targetArousal : Float;
    var regulationEffort : Float;
    
    // Suppression state
    var suppressionActive : Bool;
    var suppressedEmotion : ?BasicEmotion;
    var suppressionCost : Float;         // Cognitive cost of suppression
    
    // Reappraisal state
    var reappraisalActive : Bool;
    var alternativeAppraisal : AppraisalDimensions;
  };
  
  // Initialize emotion regulation
  public func initEmotionRegulation() : EmotionRegulationState {
    {
      var situationSelectionStrength = 0.5;
      var situationModificationStrength = 0.5;
      var attentionalDeploymentStrength = 0.5;
      var cognitiveReappraisalStrength = 0.5;
      var responseModulationStrength = 0.5;
      var activeStrategy = null;
      var strategyEffectiveness = 0.0;
      var targetValence = 0.3;
      var targetArousal = 0.4;
      var regulationEffort = 0.0;
      var suppressionActive = false;
      var suppressedEmotion = null;
      var suppressionCost = 0.0;
      var reappraisalActive = false;
      var alternativeAppraisal = {
        var relevance = 0.5;
        var goalCongruence = 0.0;
        var agency = 0.0;
        var certainty = 0.5;
        var controlPotential = 0.5;
        var normCompatibility = 0.0;
      };
    }
  };
  
  // Select regulation strategy based on emotion state
  public func selectRegulationStrategy(
    regulation : EmotionRegulationState,
    currentAffect : CoreAffect,
    basicEmotions : BasicEmotionState,
    availableControl : Float             // How much control is available
  ) : ?RegulationStrategy {
    // Calculate need for regulation
    let valenceDiff = Float.abs(currentAffect.valence - regulation.targetValence);
    let arousalDiff = Float.abs(currentAffect.arousal - regulation.targetArousal);
    let regulationNeed = (valenceDiff + arousalDiff) / 2.0;
    
    if (regulationNeed < 0.2) {
      // No need for regulation
      regulation.activeStrategy := null;
      return null;
    };
    
    regulation.regulationEffort := regulationNeed;
    
    // Choose strategy based on situation
    let strategy : RegulationStrategy = if (availableControl > 0.7 and regulationNeed > 0.5) {
      // High control + high need → situation modification
      #situationModification
    } else if (basicEmotions.fear > 0.6 or basicEmotions.anger > 0.6) {
      // Strong negative emotion → cognitive reappraisal
      #cognitiveReappraisal
    } else if (arousalDiff > valenceDiff) {
      // Arousal problem → attentional deployment
      #attentionalDeployment
    } else if (basicEmotions.dominantStrength > 0.7) {
      // Very strong emotion → response modulation
      #responseModulation
    } else {
      // Default → situation selection (avoidance)
      #situationSelection
    };
    
    regulation.activeStrategy := ?strategy;
    ?strategy
  };
  
  // Apply regulation strategy
  public func applyRegulation(
    regulation : EmotionRegulationState,
    affect : CoreAffect,
    basicEmotions : BasicEmotionState,
    appraisal : AppraisalDimensions
  ) {
    switch (regulation.activeStrategy) {
      case (?#situationSelection) {
        // Can't directly apply — this is about avoiding situations
        regulation.strategyEffectiveness := regulation.situationSelectionStrength * 0.5;
      };
      
      case (?#situationModification) {
        // Can't directly apply — this is about changing external world
        regulation.strategyEffectiveness := regulation.situationModificationStrength * 0.5;
      };
      
      case (?#attentionalDeployment) {
        // Redirect attention away from emotional stimulus
        // Effect: reduce arousal
        let reduction = regulation.attentionalDeploymentStrength * 0.2;
        affect.arousal := Float.max(0.0, affect.arousal - reduction);
        regulation.strategyEffectiveness := reduction;
      };
      
      case (?#cognitiveReappraisal) {
        // Reinterpret the situation
        regulation.reappraisalActive := true;
        
        // Alternative appraisal is more positive
        let boost = regulation.cognitiveReappraisalStrength * 0.3;
        regulation.alternativeAppraisal.goalCongruence := appraisal.goalCongruence + boost;
        regulation.alternativeAppraisal.controlPotential := Float.min(1.0, appraisal.controlPotential + boost);
        
        // Effect on affect
        affect.valence := affect.valence + boost * 0.5;
        regulation.strategyEffectiveness := boost;
      };
      
      case (?#responseModulation) {
        // Suppress expression (NOT the feeling itself)
        regulation.suppressionActive := true;
        
        // Suppression has a cognitive cost
        regulation.suppressionCost := regulation.regulationEffort * 0.3;
        
        // Paradoxical effect: suppression can increase arousal
        affect.arousal := Float.min(1.0, affect.arousal + 0.05);
        
        regulation.strategyEffectiveness := regulation.responseModulationStrength * 0.4;
      };
      
      case (null) {
        regulation.strategyEffectiveness := 0.0;
        regulation.suppressionActive := false;
        regulation.reappraisalActive := false;
      };
    };
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 6: EMOTIONAL MEMORY — FEELINGS PERSIST
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Emotions are not instantaneous — they have:
  //   - Onset latency (time to start)
  //   - Rise time (time to peak)
  //   - Peak intensity
  //   - Decay (exponential return to baseline)
  //   - Emotional inertia (resistance to change)
  //
  
  public type EmotionalMemory = {
    var recentEmotions : [[var Float]];  // History of emotion vectors
    var memoryIdx : Nat;
    
    // Temporal dynamics
    var emotionalInertia : Float;        // Resistance to change
    var baselineReturn : Float;          // Rate of return to baseline
    var peakIntensity : Float;           // Highest intensity reached
    var timeSincePeak : Nat;
    
    // Mood (long-term emotional state)
    var moodValence : Float;
    var moodArousal : Float;
    var moodStability : Float;
    
    // Emotional memories (situations that triggered strong emotions)
    var emotionalEpisodes : [EmotionalEpisode];
    var episodeCount : Nat;
  };
  
  public type EmotionalEpisode = {
    triggerPattern : [Float];            // What triggered it
    emotionProfile : [Float];            // What was felt
    intensity : Float;
    beat : Nat;
  };
  
  public let EMOTIONAL_MEMORY_SIZE : Nat = 50;
  public let MAX_EPISODES : Nat = 100;
  
  // Initialize emotional memory
  public func initEmotionalMemory() : EmotionalMemory {
    {
      var recentEmotions = Array.init<[var Float]>(EMOTIONAL_MEMORY_SIZE, func(_ : Nat) : [var Float] {
        Array.init<Float>(NUM_BASIC_EMOTIONS, func(_ : Nat) : Float { 0.0 })
      });
      var memoryIdx = 0;
      var emotionalInertia = 0.8;
      var baselineReturn = 0.05;
      var peakIntensity = 0.0;
      var timeSincePeak = 0;
      var moodValence = 0.0;
      var moodArousal = 0.5;
      var moodStability = 0.5;
      var emotionalEpisodes = [];
      var episodeCount = 0;
    }
  };
  
  // Update emotional memory
  public func updateEmotionalMemory(
    memory : EmotionalMemory,
    currentEmotions : [Float],
    situation : [Float],
    currentBeat : Nat
  ) {
    // Store current emotions
    for (i in Iter.range(0, NUM_BASIC_EMOTIONS - 1)) {
      memory.recentEmotions[memory.memoryIdx][i] := if (i < Array.size(currentEmotions)) { currentEmotions[i] } else { 0.0 };
    };
    memory.memoryIdx := (memory.memoryIdx + 1) % EMOTIONAL_MEMORY_SIZE;
    
    // Track intensity
    var currentIntensity : Float = 0.0;
    for (e in currentEmotions.vals()) {
      currentIntensity := Float.max(currentIntensity, e);
    };
    
    if (currentIntensity > memory.peakIntensity) {
      memory.peakIntensity := currentIntensity;
      memory.timeSincePeak := 0;
    } else {
      memory.timeSincePeak += 1;
    };
    
    // Decay peak intensity
    if (memory.timeSincePeak > 10) {
      memory.peakIntensity := memory.peakIntensity * (1.0 - memory.baselineReturn);
    };
    
    // Update mood (slow-moving average)
    var avgValence : Float = 0.0;
    var avgArousal : Float = 0.0;
    
    for (i in Iter.range(0, EMOTIONAL_MEMORY_SIZE - 1)) {
      // Happiness - sadness as valence proxy
      avgValence += memory.recentEmotions[i][0] - memory.recentEmotions[i][1];
      // Fear + anger as arousal proxy
      avgArousal += memory.recentEmotions[i][2] + memory.recentEmotions[i][3];
    };
    
    avgValence /= Float.fromInt(EMOTIONAL_MEMORY_SIZE);
    avgArousal /= Float.fromInt(EMOTIONAL_MEMORY_SIZE) * 2.0;
    
    memory.moodValence := 0.95 * memory.moodValence + 0.05 * avgValence;
    memory.moodArousal := 0.95 * memory.moodArousal + 0.05 * avgArousal;
    
    // Mood stability (inverse of recent variance)
    var varianceSum : Float = 0.0;
    for (i in Iter.range(0, EMOTIONAL_MEMORY_SIZE - 1)) {
      let v = memory.recentEmotions[i][0] - memory.recentEmotions[i][1] - memory.moodValence;
      varianceSum += v * v;
    };
    let variance = varianceSum / Float.fromInt(EMOTIONAL_MEMORY_SIZE);
    memory.moodStability := 1.0 / (1.0 + variance * 10.0);
    
    // Store significant emotional episode
    if (currentIntensity > 0.7) {
      // This is a significant emotional event
      let episode : EmotionalEpisode = {
        triggerPattern = situation;
        emotionProfile = currentEmotions;
        intensity = currentIntensity;
        beat = currentBeat;
      };
      
      // Would add to episodes (simplified)
      memory.episodeCount += 1;
    };
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 7: COMPLETE EMOTIONAL STATE
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  public type EmotionalState = {
    coreAffect : CoreAffect;
    appraisal : AppraisalState;
    basicEmotions : BasicEmotionState;
    secondaryEmotions : SecondaryEmotionState;
    regulation : EmotionRegulationState;
    memory : EmotionalMemory;
    
    // Global emotional state
    var overallValence : Float;
    var overallArousal : Float;
    var emotionalComplexity : Float;     // Number of concurrent emotions
    var emotionalCoherence : Float;      // Agreement between emotion systems
  };
  
  // Initialize complete emotional state
  public func initEmotionalState() : EmotionalState {
    {
      coreAffect = initCoreAffect();
      appraisal = initAppraisalState();
      basicEmotions = initBasicEmotions();
      secondaryEmotions = initSecondaryEmotions();
      regulation = initEmotionRegulation();
      memory = initEmotionalMemory();
      var overallValence = 0.0;
      var overallArousal = 0.5;
      var emotionalComplexity = 0.0;
      var emotionalCoherence = 1.0;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 8: THE COMPLETE EMOTIONAL HEARTBEAT
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  public type EmotionalHeartbeatResult = {
    dominantEmotion : BasicEmotion;
    emotionStrength : Float;
    valence : Float;
    arousal : Float;
    moodValence : Float;
    selfEsteem : Float;
    regulationStrategy : ?RegulationStrategy;
    emotionalComplexity : Float;
  };
  
  // Run complete emotional heartbeat
  public func runEmotionalHeartbeat(
    state : EmotionalState,
    situation : [Float],
    rewardSignal : Float,
    threatSignal : Float,
    socialSignal : Float,
    energyLevel : Float,
    socialContext : Float,
    otherSuccess : Float,
    relationshipThreat : Float,
    futureExpectation : Float,
    pastMemoryValence : Float,
    availableControl : Float,
    currentBeat : Nat,
    dt : Float
  ) : EmotionalHeartbeatResult {
    
    // ───────────────────────────────────────────────────────────────────────────
    // 1. Update core affect
    // ───────────────────────────────────────────────────────────────────────────
    updateCoreAffect(
      state.coreAffect,
      rewardSignal,
      threatSignal,
      socialSignal,
      energyLevel,
      dt
    );
    
    // ───────────────────────────────────────────────────────────────────────────
    // 2. Appraise situation
    // ───────────────────────────────────────────────────────────────────────────
    appraiseSituation(
      state.appraisal,
      situation,
      threatSignal,
      rewardSignal,
      0.0,  // selfCaused (would need more context)
      0.5   // predictability
    );
    
    // ───────────────────────────────────────────────────────────────────────────
    // 3. Compute basic emotions from appraisal
    // ───────────────────────────────────────────────────────────────────────────
    computeBasicEmotions(
      state.basicEmotions,
      state.appraisal.currentAppraisal,
      state.coreAffect
    );
    
    // ───────────────────────────────────────────────────────────────────────────
    // 4. Compute secondary emotions
    // ───────────────────────────────────────────────────────────────────────────
    computeSecondaryEmotions(
      state.secondaryEmotions,
      state.basicEmotions,
      state.appraisal.currentAppraisal,
      socialContext,
      otherSuccess,
      relationshipThreat,
      futureExpectation,
      pastMemoryValence
    );
    
    // ───────────────────────────────────────────────────────────────────────────
    // 5. Select and apply emotion regulation
    // ───────────────────────────────────────────────────────────────────────────
    let strategy = selectRegulationStrategy(
      state.regulation,
      state.coreAffect,
      state.basicEmotions,
      availableControl
    );
    
    applyRegulation(
      state.regulation,
      state.coreAffect,
      state.basicEmotions,
      state.appraisal.currentAppraisal
    );
    
    // ───────────────────────────────────────────────────────────────────────────
    // 6. Update emotional memory
    // ───────────────────────────────────────────────────────────────────────────
    updateEmotionalMemory(
      state.memory,
      Array.freeze(state.basicEmotions.emotionMix),
      situation,
      currentBeat
    );
    
    // ───────────────────────────────────────────────────────────────────────────
    // 7. Compute global emotional state
    // ───────────────────────────────────────────────────────────────────────────
    state.overallValence := state.coreAffect.valence;
    state.overallArousal := state.coreAffect.arousal;
    
    // Emotional complexity: how many emotions are active?
    var activeEmotions : Nat = 0;
    for (i in Iter.range(0, NUM_BASIC_EMOTIONS - 1)) {
      if (state.basicEmotions.emotionMix[i] > 0.3) {
        activeEmotions += 1;
      };
    };
    state.emotionalComplexity := Float.fromInt(activeEmotions) / Float.fromInt(NUM_BASIC_EMOTIONS);
    
    // Emotional coherence: does core affect match basic emotions?
    let expectedValence = state.basicEmotions.happiness - state.basicEmotions.sadness;
    let expectedArousal = (state.basicEmotions.fear + state.basicEmotions.anger) / 2.0;
    let valenceMismatch = Float.abs(state.coreAffect.valence - expectedValence);
    let arousalMismatch = Float.abs(state.coreAffect.arousal - expectedArousal);
    state.emotionalCoherence := 1.0 - (valenceMismatch + arousalMismatch) / 2.0;
    
    // ───────────────────────────────────────────────────────────────────────────
    // Return result
    // ───────────────────────────────────────────────────────────────────────────
    {
      dominantEmotion = state.basicEmotions.dominant;
      emotionStrength = state.basicEmotions.dominantStrength;
      valence = state.overallValence;
      arousal = state.overallArousal;
      moodValence = state.memory.moodValence;
      selfEsteem = state.secondaryEmotions.selfEsteem;
      regulationStrategy = strategy;
      emotionalComplexity = state.emotionalComplexity;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // UTILITY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  func clamp(x : Float, minVal : Float, maxVal : Float) : Float {
    if (x < minVal) { minVal }
    else if (x > maxVal) { maxVal }
    else { x }
  };
  
  func sqrt(x : Float) : Float {
    if (x <= 0.0) { return 0.0 };
    var guess : Float = x / 2.0;
    for (_ in Iter.range(0, 20)) {
      guess := 0.5 * (guess + x / guess);
    };
    guess
  };
  
  func atan2(y : Float, x : Float) : Float {
    if (x > 0.0) { atan(y / x) }
    else if (x < 0.0 and y >= 0.0) { atan(y / x) + PI }
    else if (x < 0.0 and y < 0.0) { atan(y / x) - PI }
    else if (x == 0.0 and y > 0.0) { PI / 2.0 }
    else if (x == 0.0 and y < 0.0) { -PI / 2.0 }
    else { 0.0 }
  };
  
  func atan(x : Float) : Float {
    if (Float.abs(x) > 1.0) {
      let s : Float = if (x > 0.0) { 1.0 } else { -1.0 };
      s * (PI / 2.0 - atan(1.0 / Float.abs(x)))
    } else {
      var result : Float = 0.0;
      var term : Float = x;
      var xSquared : Float = x * x;
      for (n in Iter.range(0, 15)) {
        result += term / Float.fromInt(2 * n + 1);
        term := -term * xSquared;
      };
      result
    }
  };
  
  func arrayMagnitude(arr : [Float]) : Float {
    var sum : Float = 0.0;
    for (v in arr.vals()) {
      sum += v * v;
    };
    sqrt(sum)
  };
  
  func dotProduct(a : [Float], b : [Float]) : Float {
    let n = Nat.min(Array.size(a), Array.size(b));
    var sum : Float = 0.0;
    for (i in Iter.range(0, n - 1)) {
      sum += a[i] * b[i];
    };
    sum
  };
  
  func cosineSimilarity(a : [Float], b : [Float]) : Float {
    let dot = dotProduct(a, b);
    let magA = arrayMagnitude(a);
    let magB = arrayMagnitude(b);
    if (magA > 0.0001 and magB > 0.0001) {
      dot / (magA * magB)
    } else {
      0.0
    }
  };

};
