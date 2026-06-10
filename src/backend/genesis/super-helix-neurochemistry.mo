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
// SUPER HELIX NEUROCHEMISTRY ENGINE — BACKEND VERSION (MALE)
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// MEDINA'S MIRROR LAW (Law 9):
// Backend (Male): The organism's mood AT REST — slow, immortal, permanent, accumulating
// Frontend (Female): The organism's mood IN EXPRESSION — fast, mortal, real-time
//
// 21 NEUROCHEMICAL ANALOGS WITH 441 CROSSTALK INTERACTIONS
//
// This is the SOVEREIGN chemical state that persists between sessions.
// When no player is connected: chemicals decay on their own.
// The organism has mood even when alone.
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Nat8 "mo:core/Nat8";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Iter "mo:core/Iter";
import Time "mo:core/Time";
import Option "mo:core/Option";

module SuperHelixNeurochemistry {

  // ═══════════════════════════════════════════════════════════════════════════════
  // MATHEMATICAL CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let PI : Float = 3.14159265358979323846;
  public let TWO_PI : Float = 6.28318530717958647692;
  public let E : Float = 2.71828182845904523536;
  public let PHI : Float = 1.618033988749895;
  
  // Helix constants
  public let HELIX_ANALOG_COUNT : Nat = 21;
  public let HELIX_CROSSTALK_COUNT : Nat = 441; // 21 × 21
  
  // Homeostatic constants
  public let HOMEOSTATIC_TAU : Float = 10.0;   // Time constant for return to baseline
  public let MIN_CONCENTRATION : Float = 0.0;
  public let MAX_CONCENTRATION : Float = 1.0;
  
  // Update constants
  public let DT : Float = 0.5;  // Time step for backend (slower than frontend)
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // THE 21 HELIX ANALOGS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// HelixAnalog enumeration — 21 neurochemical analogs
  public type HelixAnalog = {
    // CATECHOLAMINES — Action and Arousal
    #HELIX_DOPAMINE;         // 0: Reward prediction, motivation, action selection
    #HELIX_NOREPINEPHRINE;   // 1: Alertness, attention, fight-or-flight
    #HELIX_EPINEPHRINE;      // 2: Acute stress, emergency mobilization
    
    // INDOLAMINES — Mood and Rhythm
    #HELIX_SEROTONIN;        // 3: Mood stability, satiety, impulse regulation
    #HELIX_MELATONIN;        // 4: Circadian rhythm, temporal binding
    
    // AMINO ACIDS — Excitation/Inhibition Balance
    #HELIX_GLUTAMATE;        // 5: Primary excitatory neurotransmitter
    #HELIX_GABA;             // 6: Primary inhibitory neurotransmitter
    #HELIX_GLYCINE;          // 7: Co-inhibition, NMDA modulation
    
    // CHOLINERGIC — Learning and Attention
    #HELIX_ACETYLCHOLINE;    // 8: Learning rate, memory consolidation
    
    // NEUROPEPTIDES — Complex Social Behaviors
    #HELIX_OXYTOCIN;         // 9: Trust, bonding, group coherence
    #HELIX_VASOPRESSIN;      // 10: Territoriality, pair bonding, aggression
    #HELIX_ENDORPHIN;        // 11: Endogenous reward, pain suppression
    #HELIX_ENKEPHALIN;       // 12: Pain modulation, stress buffering
    #HELIX_SUBSTANCE_P;      // 13: Pain transmission, inflammation
    #HELIX_CORTISOL;         // 14: Chronic stress, metabolic mobilization
    
    // PURINES — Energy and Sleep
    #HELIX_ADENOSINE;        // 15: Sleep pressure, fatigue accumulation
    #HELIX_ATP;              // 16: Energy currency, metabolic capacity
    
    // ENDOCANNABINOIDS — Homeostasis
    #HELIX_ANANDAMIDE;       // 17: Bliss, retrograde signaling
    
    // GASEOUS — Vascular and Synaptic
    #HELIX_NITRIC_OXIDE;     // 18: Blood flow, synaptic plasticity
    
    // HISTAMINERGIC — Arousal and Immunity
    #HELIX_HISTAMINE;        // 19: Wakefulness, immune response
    
    // OREXINERGIC — Energy Balance
    #HELIX_OREXIN;           // 20: Wakefulness stability, appetite
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // HELIX ANALOG INDEX MAPPING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func analogToIndex(analog : HelixAnalog) : Nat {
    switch (analog) {
      case (#HELIX_DOPAMINE) { 0 };
      case (#HELIX_NOREPINEPHRINE) { 1 };
      case (#HELIX_EPINEPHRINE) { 2 };
      case (#HELIX_SEROTONIN) { 3 };
      case (#HELIX_MELATONIN) { 4 };
      case (#HELIX_GLUTAMATE) { 5 };
      case (#HELIX_GABA) { 6 };
      case (#HELIX_GLYCINE) { 7 };
      case (#HELIX_ACETYLCHOLINE) { 8 };
      case (#HELIX_OXYTOCIN) { 9 };
      case (#HELIX_VASOPRESSIN) { 10 };
      case (#HELIX_ENDORPHIN) { 11 };
      case (#HELIX_ENKEPHALIN) { 12 };
      case (#HELIX_SUBSTANCE_P) { 13 };
      case (#HELIX_CORTISOL) { 14 };
      case (#HELIX_ADENOSINE) { 15 };
      case (#HELIX_ATP) { 16 };
      case (#HELIX_ANANDAMIDE) { 17 };
      case (#HELIX_NITRIC_OXIDE) { 18 };
      case (#HELIX_HISTAMINE) { 19 };
      case (#HELIX_OREXIN) { 20 };
    }
  };
  
  public func indexToAnalog(index : Nat) : ?HelixAnalog {
    switch (index) {
      case (0) { ?#HELIX_DOPAMINE };
      case (1) { ?#HELIX_NOREPINEPHRINE };
      case (2) { ?#HELIX_EPINEPHRINE };
      case (3) { ?#HELIX_SEROTONIN };
      case (4) { ?#HELIX_MELATONIN };
      case (5) { ?#HELIX_GLUTAMATE };
      case (6) { ?#HELIX_GABA };
      case (7) { ?#HELIX_GLYCINE };
      case (8) { ?#HELIX_ACETYLCHOLINE };
      case (9) { ?#HELIX_OXYTOCIN };
      case (10) { ?#HELIX_VASOPRESSIN };
      case (11) { ?#HELIX_ENDORPHIN };
      case (12) { ?#HELIX_ENKEPHALIN };
      case (13) { ?#HELIX_SUBSTANCE_P };
      case (14) { ?#HELIX_CORTISOL };
      case (15) { ?#HELIX_ADENOSINE };
      case (16) { ?#HELIX_ATP };
      case (17) { ?#HELIX_ANANDAMIDE };
      case (18) { ?#HELIX_NITRIC_OXIDE };
      case (19) { ?#HELIX_HISTAMINE };
      case (20) { ?#HELIX_OREXIN };
      case (_) { null };
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // BIOLOGICAL HALF-LIVES (seconds)
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let HELIX_HALF_LIVES : [Float] = [
    0.2,    // DOPAMINE — Very fast (phasic signaling)
    0.3,    // NOREPINEPHRINE — Fast (acute response)
    0.15,   // EPINEPHRINE — Very fast (emergency)
    2.0,    // SEROTONIN — Slow (mood stability)
    30.0,   // MELATONIN — Very slow (circadian)
    0.05,   // GLUTAMATE — Extremely fast (prevent toxicity)
    0.1,    // GABA — Fast (dynamic inhibition)
    0.15,   // GLYCINE — Fast
    0.02,   // ACETYLCHOLINE — Extremely fast (precise timing)
    3.0,    // OXYTOCIN — Slow (lasting bonds)
    3.5,    // VASOPRESSIN — Slow (territorial memory)
    5.0,    // ENDORPHIN — Moderate (sustained relief)
    4.0,    // ENKEPHALIN — Moderate
    1.0,    // SUBSTANCE_P — Moderate (pain signal)
    60.0,   // CORTISOL — Very slow (chronic stress)
    10.0,   // ADENOSINE — Slow (sleep pressure builds)
    1.0,    // ATP — Moderate (energy buffer)
    5.0,    // ANANDAMIDE — Moderate
    0.01,   // NITRIC_OXIDE — Extremely fast (gas diffusion)
    1.5,    // HISTAMINE — Moderate
    5.0,    // OREXIN — Moderate (wake stability)
  ];
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // BASELINE CONCENTRATIONS (normalized 0-1)
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let HELIX_BASELINES : [Float] = [
    0.50,   // DOPAMINE
    0.30,   // NOREPINEPHRINE
    0.10,   // EPINEPHRINE
    0.60,   // SEROTONIN
    0.20,   // MELATONIN
    0.50,   // GLUTAMATE
    0.50,   // GABA
    0.40,   // GLYCINE
    0.50,   // ACETYLCHOLINE
    0.40,   // OXYTOCIN
    0.30,   // VASOPRESSIN
    0.30,   // ENDORPHIN
    0.30,   // ENKEPHALIN
    0.20,   // SUBSTANCE_P
    0.30,   // CORTISOL
    0.20,   // ADENOSINE
    0.80,   // ATP
    0.30,   // ANANDAMIDE
    0.40,   // NITRIC_OXIDE
    0.30,   // HISTAMINE
    0.50,   // OREXIN
  ];
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // THE 441 CROSSTALK MATRIX
  // Matrix[i][j] = effect of chemical i on chemical j
  // Positive = excitatory, Negative = inhibitory
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Get crosstalk value between two chemicals
  public func getCrosstalk(from : Nat, to : Nat) : Float {
    // 21×21 = 441 interactions
    // Stored as a function to save memory
    let matrix : [[Float]] = [
      // Row 0: DOPAMINE affects all 21
      [0.00, 0.30, 0.15, -0.20, -0.10, 0.25, -0.15, 0.00, 0.20, 0.10, 0.15, 0.35, 0.20, -0.05, -0.10, -0.05, 0.15, 0.20, 0.10, 0.05, 0.15],
      // Row 1: NOREPINEPHRINE affects all 21
      [0.25, 0.00, 0.40, -0.15, -0.20, 0.30, -0.20, -0.10, 0.25, -0.10, 0.20, 0.15, 0.10, 0.10, 0.25, -0.10, 0.20, -0.05, 0.15, 0.20, 0.25],
      // Row 2: EPINEPHRINE affects all 21
      [0.20, 0.35, 0.00, -0.25, -0.30, 0.40, -0.25, -0.15, 0.15, -0.20, 0.25, 0.20, 0.15, 0.15, 0.35, -0.15, 0.25, -0.10, 0.20, 0.25, 0.30],
      // Row 3: SEROTONIN affects all 21
      [-0.15, -0.20, -0.25, 0.00, 0.30, -0.15, 0.25, 0.15, 0.10, 0.20, -0.10, 0.15, 0.15, -0.20, -0.15, 0.10, 0.05, 0.15, 0.10, -0.10, -0.05],
      // Row 4: MELATONIN affects all 21
      [-0.20, -0.30, -0.35, 0.20, 0.00, -0.25, 0.30, 0.20, -0.20, 0.10, -0.15, 0.10, 0.10, -0.15, -0.10, 0.35, -0.10, 0.15, 0.05, -0.20, -0.30],
      // Row 5: GLUTAMATE affects all 21
      [0.20, 0.25, 0.20, -0.10, -0.15, 0.00, -0.40, -0.20, 0.30, 0.05, 0.10, 0.10, 0.05, 0.15, 0.10, -0.10, 0.15, 0.05, 0.25, 0.15, 0.20],
      // Row 6: GABA affects all 21
      [-0.20, -0.25, -0.30, 0.15, 0.20, -0.35, 0.00, 0.30, -0.20, 0.10, -0.15, 0.20, 0.20, -0.25, -0.20, 0.20, -0.15, 0.25, -0.10, -0.15, -0.20],
      // Row 7: GLYCINE affects all 21
      [-0.10, -0.15, -0.20, 0.10, 0.15, -0.20, 0.25, 0.00, -0.10, 0.05, -0.10, 0.15, 0.15, -0.20, -0.15, 0.15, -0.10, 0.15, -0.05, -0.10, -0.15],
      // Row 8: ACETYLCHOLINE affects all 21
      [0.25, 0.20, 0.10, 0.10, -0.15, 0.25, -0.15, -0.05, 0.00, 0.15, 0.10, 0.10, 0.05, 0.05, 0.05, -0.10, 0.10, 0.10, 0.15, 0.15, 0.20],
      // Row 9: OXYTOCIN affects all 21
      [0.15, -0.15, -0.20, 0.20, 0.10, 0.05, 0.15, 0.10, 0.15, 0.00, -0.30, 0.30, 0.25, -0.15, -0.25, 0.05, 0.05, 0.20, 0.10, -0.05, 0.05],
      // Row 10: VASOPRESSIN affects all 21
      [0.10, 0.25, 0.20, -0.15, -0.10, 0.15, -0.10, -0.05, 0.10, -0.25, 0.00, 0.10, 0.05, 0.10, 0.20, -0.05, 0.10, -0.05, 0.10, 0.10, 0.15],
      // Row 11: ENDORPHIN affects all 21
      [0.30, -0.10, -0.15, 0.20, 0.10, -0.10, 0.25, 0.20, 0.10, 0.25, -0.05, 0.00, 0.40, -0.35, -0.20, 0.10, 0.05, 0.35, 0.10, -0.05, 0.10],
      // Row 12: ENKEPHALIN affects all 21
      [0.20, -0.05, -0.10, 0.15, 0.10, -0.05, 0.20, 0.15, 0.05, 0.20, 0.00, 0.35, 0.00, -0.30, -0.15, 0.10, 0.05, 0.25, 0.05, -0.05, 0.05],
      // Row 13: SUBSTANCE_P affects all 21
      [0.05, 0.15, 0.20, -0.15, -0.10, 0.20, -0.20, -0.15, 0.10, -0.10, 0.10, -0.25, -0.20, 0.00, 0.25, -0.05, 0.15, -0.15, 0.10, 0.15, 0.10],
      // Row 14: CORTISOL affects all 21
      [-0.10, 0.20, 0.25, -0.20, -0.15, 0.15, -0.15, -0.10, 0.05, -0.20, 0.15, -0.15, -0.10, 0.20, 0.00, 0.05, 0.10, -0.10, 0.05, 0.10, 0.10],
      // Row 15: ADENOSINE affects all 21
      [-0.15, -0.20, -0.25, 0.10, 0.30, -0.20, 0.25, 0.15, -0.15, 0.05, -0.05, 0.10, 0.10, -0.10, 0.05, 0.00, -0.25, 0.15, 0.05, -0.15, -0.30],
      // Row 16: ATP affects all 21
      [0.20, 0.25, 0.30, 0.05, -0.15, 0.20, -0.10, -0.05, 0.15, 0.05, 0.10, 0.10, 0.05, 0.10, -0.05, -0.20, 0.00, 0.05, 0.15, 0.15, 0.25],
      // Row 17: ANANDAMIDE affects all 21
      [0.25, -0.10, -0.15, 0.20, 0.15, -0.05, 0.20, 0.15, 0.10, 0.20, -0.05, 0.30, 0.25, -0.20, -0.15, 0.10, 0.05, 0.00, 0.10, -0.05, 0.10],
      // Row 18: NITRIC_OXIDE affects all 21
      [0.10, 0.15, 0.15, 0.05, 0.00, 0.20, -0.10, -0.05, 0.15, 0.10, 0.10, 0.10, 0.05, 0.05, 0.00, 0.00, 0.10, 0.10, 0.00, 0.05, 0.10],
      // Row 19: HISTAMINE affects all 21
      [0.10, 0.25, 0.20, -0.15, -0.25, 0.20, -0.15, -0.10, 0.20, -0.05, 0.10, -0.05, -0.05, 0.15, 0.10, -0.20, 0.10, -0.05, 0.05, 0.00, 0.20],
      // Row 20: OREXIN affects all 21
      [0.20, 0.30, 0.25, -0.10, -0.35, 0.25, -0.20, -0.10, 0.25, 0.05, 0.15, 0.15, 0.10, 0.10, 0.05, -0.30, 0.20, 0.10, 0.15, 0.20, 0.00],
    ];
    
    if (from < 21 and to < 21) {
      matrix[from][to]
    } else {
      0.0
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // PID HOMEOSTATIC CONTROLLER PARAMETERS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type PIDParams = {
    setpoint : Float;
    Kp : Float;
    Ki : Float;
    Kd : Float;
    integralMax : Float;
  };
  
  public let HELIX_PID_PARAMS : [PIDParams] = [
    { setpoint = 0.50; Kp = 0.10; Ki = 0.010; Kd = 0.020; integralMax = 0.30 }, // DOPAMINE
    { setpoint = 0.30; Kp = 0.12; Ki = 0.015; Kd = 0.025; integralMax = 0.25 }, // NOREPINEPHRINE
    { setpoint = 0.10; Kp = 0.15; Ki = 0.020; Kd = 0.030; integralMax = 0.20 }, // EPINEPHRINE
    { setpoint = 0.60; Kp = 0.08; Ki = 0.008; Kd = 0.015; integralMax = 0.35 }, // SEROTONIN
    { setpoint = 0.20; Kp = 0.05; Ki = 0.005; Kd = 0.010; integralMax = 0.40 }, // MELATONIN
    { setpoint = 0.50; Kp = 0.15; Ki = 0.020; Kd = 0.030; integralMax = 0.20 }, // GLUTAMATE
    { setpoint = 0.50; Kp = 0.12; Ki = 0.015; Kd = 0.025; integralMax = 0.25 }, // GABA
    { setpoint = 0.40; Kp = 0.10; Ki = 0.010; Kd = 0.020; integralMax = 0.30 }, // GLYCINE
    { setpoint = 0.50; Kp = 0.12; Ki = 0.015; Kd = 0.025; integralMax = 0.25 }, // ACETYLCHOLINE
    { setpoint = 0.40; Kp = 0.06; Ki = 0.006; Kd = 0.012; integralMax = 0.35 }, // OXYTOCIN
    { setpoint = 0.30; Kp = 0.08; Ki = 0.008; Kd = 0.015; integralMax = 0.30 }, // VASOPRESSIN
    { setpoint = 0.30; Kp = 0.07; Ki = 0.007; Kd = 0.014; integralMax = 0.35 }, // ENDORPHIN
    { setpoint = 0.30; Kp = 0.07; Ki = 0.007; Kd = 0.014; integralMax = 0.35 }, // ENKEPHALIN
    { setpoint = 0.20; Kp = 0.10; Ki = 0.010; Kd = 0.020; integralMax = 0.30 }, // SUBSTANCE_P
    { setpoint = 0.30; Kp = 0.04; Ki = 0.004; Kd = 0.008; integralMax = 0.40 }, // CORTISOL
    { setpoint = 0.20; Kp = 0.03; Ki = 0.003; Kd = 0.006; integralMax = 0.50 }, // ADENOSINE
    { setpoint = 0.80; Kp = 0.08; Ki = 0.008; Kd = 0.015; integralMax = 0.30 }, // ATP
    { setpoint = 0.30; Kp = 0.06; Ki = 0.006; Kd = 0.012; integralMax = 0.35 }, // ANANDAMIDE
    { setpoint = 0.40; Kp = 0.20; Ki = 0.025; Kd = 0.040; integralMax = 0.15 }, // NITRIC_OXIDE
    { setpoint = 0.30; Kp = 0.10; Ki = 0.010; Kd = 0.020; integralMax = 0.30 }, // HISTAMINE
    { setpoint = 0.50; Kp = 0.08; Ki = 0.008; Kd = 0.015; integralMax = 0.35 }, // OREXIN
  ];
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // CIRCADIAN MODULATION PARAMETERS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type CircadianParams = {
    amplitude : Float;
    peakPhase : Float;
    acrophase : Float;
  };
  
  public let HELIX_CIRCADIAN : [CircadianParams] = [
    { amplitude = 0.20; peakPhase = 0.40; acrophase = 9.6 },   // DOPAMINE
    { amplitude = 0.30; peakPhase = 0.35; acrophase = 8.4 },   // NOREPINEPHRINE
    { amplitude = 0.25; peakPhase = 0.40; acrophase = 9.6 },   // EPINEPHRINE
    { amplitude = 0.25; peakPhase = 0.50; acrophase = 12.0 },  // SEROTONIN
    { amplitude = 0.80; peakPhase = 0.00; acrophase = 0.0 },   // MELATONIN
    { amplitude = 0.15; peakPhase = 0.45; acrophase = 10.8 },  // GLUTAMATE
    { amplitude = 0.15; peakPhase = 0.90; acrophase = 21.6 },  // GABA
    { amplitude = 0.10; peakPhase = 0.95; acrophase = 22.8 },  // GLYCINE
    { amplitude = 0.30; peakPhase = 0.40; acrophase = 9.6 },   // ACETYLCHOLINE
    { amplitude = 0.15; peakPhase = 0.60; acrophase = 14.4 },  // OXYTOCIN
    { amplitude = 0.20; peakPhase = 0.30; acrophase = 7.2 },   // VASOPRESSIN
    { amplitude = 0.20; peakPhase = 0.50; acrophase = 12.0 },  // ENDORPHIN
    { amplitude = 0.15; peakPhase = 0.50; acrophase = 12.0 },  // ENKEPHALIN
    { amplitude = 0.10; peakPhase = 0.40; acrophase = 9.6 },   // SUBSTANCE_P
    { amplitude = 0.50; peakPhase = 0.30; acrophase = 7.2 },   // CORTISOL
    { amplitude = 0.40; peakPhase = 0.85; acrophase = 20.4 },  // ADENOSINE
    { amplitude = 0.20; peakPhase = 0.45; acrophase = 10.8 },  // ATP
    { amplitude = 0.15; peakPhase = 0.60; acrophase = 14.4 },  // ANANDAMIDE
    { amplitude = 0.10; peakPhase = 0.50; acrophase = 12.0 },  // NITRIC_OXIDE
    { amplitude = 0.35; peakPhase = 0.40; acrophase = 9.6 },   // HISTAMINE
    { amplitude = 0.40; peakPhase = 0.40; acrophase = 9.6 },   // OREXIN
  ];
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // HELIX STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type HelixState = {
    concentrations : [var Float];       // Current concentrations (21)
    velocities : [var Float];           // Rate of change (21)
    integrals : [var Float];            // PID integral terms (21)
    previousErrors : [var Float];       // PID previous errors (21)
    dominantChemical : Nat;             // Most active chemical
    arousal : Float;                    // Overall arousal level
    valence : Float;                    // Overall valence (-1 to 1)
    circadianPhase : Float;             // Current circadian phase (0-1)
    lastUpdateTime : Int;               // Last update timestamp
    totalUpdates : Nat;                 // Total heartbeat updates
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func initHelixState() : HelixState {
    let concentrations = Array.init<Float>(HELIX_ANALOG_COUNT, 0.0);
    let velocities = Array.init<Float>(HELIX_ANALOG_COUNT, 0.0);
    let integrals = Array.init<Float>(HELIX_ANALOG_COUNT, 0.0);
    let previousErrors = Array.init<Float>(HELIX_ANALOG_COUNT, 0.0);
    
    // Initialize to baselines
    for (i in Iter.range(0, HELIX_ANALOG_COUNT - 1)) {
      concentrations[i] := HELIX_BASELINES[i];
    };
    
    {
      concentrations = concentrations;
      velocities = velocities;
      integrals = integrals;
      previousErrors = previousErrors;
      dominantChemical = 0;
      arousal = 0.5;
      valence = 0.0;
      circadianPhase = 0.0;
      lastUpdateTime = Time.now();
      totalUpdates = 0;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // CORE CHEMISTRY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Calculate decay based on half-life
  public func calculateDecay(concentration : Float, halfLife : Float, dt : Float) : Float {
    let decayRate = Float.log(2.0) / halfLife;
    concentration * Float.exp(-decayRate * dt)
  };
  
  /// Apply crosstalk from all chemicals to one chemical
  public func applyCrosstalk(state : HelixState, targetIndex : Nat) : Float {
    var totalEffect : Float = 0.0;
    
    for (i in Iter.range(0, HELIX_ANALOG_COUNT - 1)) {
      if (i != targetIndex) {
        let crosstalkStrength = getCrosstalk(i, targetIndex);
        let sourceConcentration = state.concentrations[i];
        totalEffect += crosstalkStrength * sourceConcentration;
      };
    };
    
    totalEffect
  };
  
  /// Calculate PID control output
  public func calculatePIDOutput(
    currentValue : Float,
    params : PIDParams,
    integral : Float,
    previousError : Float,
    dt : Float
  ) : (Float, Float, Float) {
    let error = params.setpoint - currentValue;
    
    // Proportional term
    let P = params.Kp * error;
    
    // Integral term (with anti-windup)
    var newIntegral = integral + error * dt;
    if (newIntegral > params.integralMax) {
      newIntegral := params.integralMax;
    } else if (newIntegral < -params.integralMax) {
      newIntegral := -params.integralMax;
    };
    let I = params.Ki * newIntegral;
    
    // Derivative term
    let D = params.Kd * (error - previousError) / dt;
    
    let output = P + I + D;
    (output, newIntegral, error)
  };
  
  /// Get circadian modulation at current phase
  public func getCircadianModulation(phase : Float, params : CircadianParams) : Float {
    let phaseDistance = Float.abs(phase - params.peakPhase);
    let normalizedDistance = if (phaseDistance > 0.5) { 1.0 - phaseDistance } else { phaseDistance };
    params.amplitude * Float.cos(TWO_PI * normalizedDistance)
  };
  
  /// Calculate arousal from chemical state
  public func calculateArousal(state : HelixState) : Float {
    // Arousal increases with catecholamines, decreases with GABA and melatonin
    let dopamine = state.concentrations[0];
    let norepinephrine = state.concentrations[1];
    let epinephrine = state.concentrations[2];
    let gaba = state.concentrations[6];
    let melatonin = state.concentrations[4];
    let orexin = state.concentrations[20];
    
    let excitatory = (dopamine + norepinephrine + epinephrine + orexin) / 4.0;
    let inhibitory = (gaba + melatonin) / 2.0;
    
    Float.max(0.0, Float.min(1.0, 0.5 + excitatory - inhibitory))
  };
  
  /// Calculate valence from chemical state
  public func calculateValence(state : HelixState) : Float {
    // Positive: dopamine, serotonin, endorphin, oxytocin, anandamide
    // Negative: cortisol, substance_p, norepinephrine (high)
    let positive = (
      state.concentrations[0] +  // dopamine
      state.concentrations[3] +  // serotonin
      state.concentrations[11] + // endorphin
      state.concentrations[9] +  // oxytocin
      state.concentrations[17]   // anandamide
    ) / 5.0;
    
    let negative = (
      state.concentrations[14] + // cortisol
      state.concentrations[13] + // substance_p
      Float.max(0.0, state.concentrations[1] - 0.5)  // norepinephrine when high
    ) / 3.0;
    
    positive - negative
  };
  
  /// Find dominant chemical
  public func findDominantChemical(state : HelixState) : Nat {
    var maxDiff : Float = 0.0;
    var dominant : Nat = 0;
    
    for (i in Iter.range(0, HELIX_ANALOG_COUNT - 1)) {
      let diff = Float.abs(state.concentrations[i] - HELIX_BASELINES[i]);
      if (diff > maxDiff) {
        maxDiff := diff;
        dominant := i;
      };
    };
    
    dominant
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // HEARTBEAT UPDATE — FIRES EVERY BEAT
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Update chemistry state for one heartbeat
  public func tick(state : HelixState, circadianPhase : Float) : () {
    // Update each chemical
    for (i in Iter.range(0, HELIX_ANALOG_COUNT - 1)) {
      // 1. Calculate natural decay
      let decayed = calculateDecay(
        state.concentrations[i],
        HELIX_HALF_LIVES[i],
        DT
      );
      
      // 2. Apply crosstalk from other chemicals
      let crosstalkEffect = applyCrosstalk(state, i);
      
      // 3. Calculate PID homeostatic correction
      let (pidOutput, newIntegral, newError) = calculatePIDOutput(
        decayed,
        HELIX_PID_PARAMS[i],
        state.integrals[i],
        state.previousErrors[i],
        DT
      );
      
      // Update PID state
      state.integrals[i] := newIntegral;
      state.previousErrors[i] := newError;
      
      // 4. Get circadian modulation
      let circadianMod = getCircadianModulation(circadianPhase, HELIX_CIRCADIAN[i]);
      
      // 5. Combine all effects
      let newConcentration = decayed + crosstalkEffect * DT + pidOutput * DT + circadianMod * 0.01;
      
      // 6. Calculate velocity (rate of change)
      state.velocities[i] := (newConcentration - state.concentrations[i]) / DT;
      
      // 7. Clamp to valid range
      state.concentrations[i] := Float.max(MIN_CONCENTRATION, Float.min(MAX_CONCENTRATION, newConcentration));
    };
    
    // Update aggregate metrics
    state.circadianPhase := circadianPhase;
    state.arousal := calculateArousal(state);
    state.valence := calculateValence(state);
    state.dominantChemical := findDominantChemical(state);
    state.lastUpdateTime := Time.now();
    state.totalUpdates += 1;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // STIMULUS FUNCTIONS — External events affect chemistry
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Apply stimulus to a specific chemical
  public func applyStimulus(state : HelixState, chemical : Nat, magnitude : Float) : () {
    if (chemical < HELIX_ANALOG_COUNT) {
      let newValue = state.concentrations[chemical] + magnitude;
      state.concentrations[chemical] := Float.max(MIN_CONCENTRATION, Float.min(MAX_CONCENTRATION, newValue));
    };
  };
  
  /// Sacrifice event — spikes cortisol, substance_p, drops oxytocin
  public func onSacrifice(state : HelixState) : () {
    applyStimulus(state, 14, 0.4);  // CORTISOL spike
    applyStimulus(state, 13, 0.3);  // SUBSTANCE_P spike
    applyStimulus(state, 9, -0.2);  // OXYTOCIN drop
    applyStimulus(state, 1, 0.3);   // NOREPINEPHRINE spike
  };
  
  /// OMNIS event — spikes dopamine, endorphin, serotonin
  public func onOMNIS(state : HelixState) : () {
    applyStimulus(state, 0, 0.5);   // DOPAMINE spike
    applyStimulus(state, 11, 0.4);  // ENDORPHIN spike
    applyStimulus(state, 3, 0.3);   // SEROTONIN spike
    applyStimulus(state, 9, 0.2);   // OXYTOCIN spike
  };
  
  /// Territory gain — dopamine, vasopressin spike
  public func onTerritoryGain(state : HelixState) : () {
    applyStimulus(state, 0, 0.3);   // DOPAMINE
    applyStimulus(state, 10, 0.25); // VASOPRESSIN
  };
  
  /// Territory loss — cortisol spike, dopamine drop
  public func onTerritoryLoss(state : HelixState) : () {
    applyStimulus(state, 14, 0.25); // CORTISOL
    applyStimulus(state, 0, -0.2);  // DOPAMINE drop
  };
  
  /// Combat — norepinephrine, epinephrine spike
  public func onCombat(state : HelixState) : () {
    applyStimulus(state, 1, 0.35);  // NOREPINEPHRINE
    applyStimulus(state, 2, 0.4);   // EPINEPHRINE
    applyStimulus(state, 16, -0.1); // ATP consumption
  };
  
  /// Rest — adenosine drops, ATP rises
  public func onRest(state : HelixState) : () {
    applyStimulus(state, 15, -0.2);  // ADENOSINE drop
    applyStimulus(state, 16, 0.15);  // ATP recovery
    applyStimulus(state, 4, 0.1);    // MELATONIN rise
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // QUERY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Get E/I balance (Glutamate/GABA ratio)
  public func getEIBalance(state : HelixState) : Float {
    let glutamate = state.concentrations[5];
    let gaba = state.concentrations[6];
    if (gaba > 0.01) {
      glutamate / gaba
    } else {
      glutamate / 0.01
    }
  };
  
  /// Check if E/I balance is in healthy range
  public func isEIBalanced(state : HelixState) : Bool {
    let ratio = getEIBalance(state);
    ratio >= 0.8 and ratio <= 1.2
  };
  
  /// Get stress level (cortisol + substance_p - endorphin)
  public func getStressLevel(state : HelixState) : Float {
    let stress = state.concentrations[14] + state.concentrations[13] - state.concentrations[11];
    Float.max(0.0, Float.min(1.0, stress))
  };
  
  /// Get energy level (ATP - adenosine)
  public func getEnergyLevel(state : HelixState) : Float {
    let energy = state.concentrations[16] - state.concentrations[15];
    Float.max(0.0, Float.min(1.0, 0.5 + energy))
  };

}
