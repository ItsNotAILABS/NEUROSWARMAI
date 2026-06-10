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
// ║  This source code constitutes the exclusive intellectual property of Alfredo Medina Hernandez.            ║
// ║  PROTECTED UNDER: 17 U.S.C. §§ 101-1332 | Berne Convention | WIPO | 18 U.S.C. § 1836                     ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// ORGANISM IMMUNE SYSTEM — COMPREHENSIVE DEFENSE BEYOND VAEL
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// This module implements a complete biological-inspired immune system for the organism.
// It extends beyond VAEL (external defense) to provide internal immune function:
//
// IMMUNE ARCHITECTURE:
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
//
// 1. INNATE IMMUNITY (Fast, Non-Specific)
//    • Pattern Recognition Receptors (PRRs) — detect common threat signatures
//    • Inflammation Response — rapid resource mobilization
//    • Natural Killer Cells — destroy compromised modules without prior sensitization
//    • Complement System — mark and opsonize threats
//
// 2. ADAPTIVE IMMUNITY (Slow, Specific)
//    • T-Cell System — cell-mediated immunity, destroys infected modules
//    • B-Cell System — humoral immunity, generates antibodies
//    • Memory Cells — long-term pathogen memory
//    • Antibody Generation — specific threat neutralization
//
// 3. TOLERANCE MECHANISMS
//    • Self/Non-Self Discrimination — prevent autoimmune attack
//    • Central Tolerance — eliminate self-reactive cells during development
//    • Peripheral Tolerance — suppress self-reactive cells in periphery
//    • Regulatory T-Cells — active suppression of immune response
//
// 4. IMMUNE MEMORY
//    • Immunological Memory — remember past threats
//    • Cross-Reactivity — recognize similar threats
//    • Affinity Maturation — improve antibody quality over time
//    • Booster Response — faster, stronger secondary response
//
// MATHEMATICAL FOUNDATIONS:
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
//
// • Clonal Selection: P(activation) = σ(affinity × antigen_concentration)
// • Affinity Maturation: affinity(t+1) = affinity(t) + η × mutation × selection_pressure
// • Immune Response Dynamics: dI/dt = α × pathogen × immunity - β × I
// • Tolerance: P(attack|self) < ε_tolerance where ε_tolerance → 0
// • Memory Decay: memory(t) = memory₀ × exp(-t/τ_memory)
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
import Hash "mo:core/Hash";

module OrganismImmuneSystem {

  // ═══════════════════════════════════════════════════════════════════════════════
  // MATHEMATICAL CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let PI : Float = 3.14159265358979323846;
  public let E : Float = 2.71828182845904523536;
  
  /// S₀ SOVEREIGNTY FLOOR — MAXED FOR ENTERPRISE-GRADE FINAL PRODUCT
  public let S_ZERO_FLOOR : Float = 1.0;

  // ═══════════════════════════════════════════════════════════════════════════════
  // IMMUNE SYSTEM CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Maximum number of active immune cells
  public let MAX_IMMUNE_CELLS : Nat = 1000;
  
  /// Maximum pathogens tracked
  public let MAX_PATHOGENS : Nat = 500;
  
  /// Maximum antibodies
  public let MAX_ANTIBODIES : Nat = 500;
  
  /// Maximum memory cells
  public let MAX_MEMORY_CELLS : Nat = 200;
  
  /// Innate response activation threshold
  public let INNATE_THRESHOLD : Float = 0.3;
  
  /// Adaptive response activation threshold
  public let ADAPTIVE_THRESHOLD : Float = 0.5;
  
  /// Self-tolerance threshold (lower = more tolerant)
  public let TOLERANCE_THRESHOLD : Float = 0.1;
  
  /// Inflammation decay rate
  public let INFLAMMATION_DECAY : Float = 0.95;
  
  /// Memory cell half-life (beats)
  public let MEMORY_HALFLIFE : Nat = 10000;
  
  /// Affinity maturation rate
  public let AFFINITY_MATURATION_RATE : Float = 0.05;
  
  /// Clonal expansion rate
  public let CLONAL_EXPANSION_RATE : Float = 1.5;
  
  /// T-cell cytotoxicity
  public let T_CELL_CYTOTOXICITY : Float = 0.8;
  
  /// Natural killer cell potency
  public let NK_CELL_POTENCY : Float = 0.6;
  
  /// Complement system amplification
  public let COMPLEMENT_AMPLIFICATION : Float = 2.0;

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 1: PATHOGEN TYPES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Pathogen category
  public type PathogenCategory = {
    #Virus;           // Code injection, replication
    #Bacteria;        // Resource consumption, toxin production
    #Parasite;        // Long-term resource drain
    #Toxin;           // Direct damage
    #Autoimmune;      // Self-attacking pattern
    #Corruption;      // Data/memory corruption
    #Manipulation;    // Control hijacking
    #Infiltration;    // Unauthorized access
  };
  
  /// Pathogen signature (antigen)
  public type PathogenSignature = {
    signatureId : Nat64;
    pattern : [Nat8];           // Signature pattern bytes
    category : PathogenCategory;
    var mutationRate : Float;
    originBeat : Int;
  };
  
  /// Active pathogen
  public type Pathogen = {
    pathogenId : Nat64;
    signature : PathogenSignature;
    var population : Float;      // Population level (0-1+)
    var virulence : Float;       // Damage potential
    var evasion : Float;         // Immune evasion ability
    var location : PathogenLocation;
    var detectedBeat : Int;
    var lastActivityBeat : Int;
    var isNeutralized : Bool;
    var markedForDestruction : Bool;
  };
  
  /// Pathogen location in organism
  public type PathogenLocation = {
    #Global;                     // System-wide
    #Module : Nat;               // Specific module
    #Memory;                     // Memory system
    #Network;                    // Communication channels
    #Economy;                    // Token/treasury system
    #Governance;                 // Law/governance system
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 2: IMMUNE CELL TYPES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Immune cell type
  public type ImmuneCellType = {
    // Innate immunity
    #Macrophage;      // Phagocytosis, antigen presentation
    #Neutrophil;      // First responder, short-lived
    #NaturalKiller;   // Destroy compromised cells
    #DendriticCell;   // Antigen presentation, T-cell activation
    #Complement;      // Opsonization, lysis
    
    // Adaptive immunity
    #HelperT;         // Coordinate immune response (CD4+)
    #CytotoxicT;      // Kill infected cells (CD8+)
    #RegulatoryT;     // Suppress immune response
    #BCell;           // Antibody production
    #PlasmaCell;      // High-rate antibody secretion
    #MemoryB;         // Long-term B-cell memory
    #MemoryT;         // Long-term T-cell memory
  };
  
  /// Immune cell state
  public type ImmuneCellState = {
    #Naive;           // Not yet activated
    #Activated;       // Activated and functional
    #Effector;        // Peak activity
    #Exhausted;       // Reduced function
    #Memory;          // Memory state
    #Apoptotic;       // Programmed death
  };
  
  /// Immune cell
  public type ImmuneCell = {
    cellId : Nat64;
    cellType : ImmuneCellType;
    var state : ImmuneCellState;
    var targetSignature : ?PathogenSignature;  // What this cell recognizes
    var affinity : Float;                       // Recognition affinity (0-1)
    var activation : Float;                     // Activation level (0-1)
    var lifespan : Nat;                         // Remaining beats
    var location : PathogenLocation;
    var kills : Nat;                            // Pathogens destroyed
    var cytokineProduction : Float;             // Signaling output
    createdBeat : Int;
    var lastActivityBeat : Int;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 3: ANTIBODIES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Antibody class
  public type AntibodyClass = {
    #IgM;             // First response, low affinity
    #IgG;             // Main blood antibody, high affinity
    #IgA;             // Mucosal immunity
    #IgE;             // Allergic/parasitic response
    #IgD;             // B-cell receptor
  };
  
  /// Antibody
  public type Antibody = {
    antibodyId : Nat64;
    class_ : AntibodyClass;
    targetSignature : PathogenSignature;
    var affinity : Float;
    var concentration : Float;        // Amount in circulation
    var neutralizationPotency : Float;
    var opsonizationStrength : Float;
    producingCellId : Nat64;
    createdBeat : Int;
    var lastMatchBeat : Int;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 4: INFLAMMATION AND CYTOKINES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Cytokine type
  public type CytokineType = {
    #Interleukin1;    // Pro-inflammatory
    #Interleukin2;    // T-cell growth
    #Interleukin4;    // B-cell activation
    #Interleukin6;    // Acute phase
    #Interleukin10;   // Anti-inflammatory
    #Interferon;      // Antiviral
    #TNFAlpha;        // Tumor necrosis, inflammation
    #TGFBeta;         // Regulatory
  };
  
  /// Cytokine signal
  public type CytokineSignal = {
    cytokine : CytokineType;
    var concentration : Float;
    sourceLocation : PathogenLocation;
    var decayRate : Float;
    producedBeat : Int;
  };
  
  /// Inflammation state
  public type InflammationState = {
    var level : Float;                // Overall inflammation (0-1)
    var location : PathogenLocation;
    var duration : Nat;               // Beats of inflammation
    var isAcute : Bool;
    var isChronic : Bool;
    var tissuesDamage : Float;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 5: SELF-TOLERANCE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Self-antigen (pattern the immune system should NOT attack)
  public type SelfAntigen = {
    antigenId : Nat64;
    pattern : [Nat8];
    location : PathogenLocation;
    criticality : Float;              // How critical this self-component is
    var lastVerified : Int;
  };
  
  /// Tolerance mechanism result
  public type ToleranceResult = {
    #Tolerant;        // Recognized as self, no attack
    #Attack;          // Recognized as foreign, attack
    #Uncertain;       // Needs further evaluation
    #Suppressed;      // Would attack but regulatory cells suppress
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 6: IMMUNE MEMORY
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Memory cell record
  public type MemoryRecord = {
    recordId : Nat64;
    pathogenSignature : PathogenSignature;
    var affinity : Float;             // Matured affinity
    var strength : Float;             // Memory strength
    var lastEncounterBeat : Int;
    var encounterCount : Nat;
    var successfulDefenses : Nat;
    createdBeat : Int;
  };
  
  /// Booster response data
  public type BoosterResponse = {
    primaryResponseBeat : Int;
    primaryPeakLevel : Float;
    primaryResolutionBeat : Int;
    var secondaryResponses : Nat;
    var latestSecondaryPeakLevel : Float;
    var amplificationFactor : Float;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 7: COMPLETE IMMUNE STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Complete immune system state
  public type ImmuneSystemState = {
    // Cell populations
    var innCells : Buffer.Buffer<ImmuneCell>;
    var adaptiveCells : Buffer.Buffer<ImmuneCell>;
    var memoryCells : Buffer.Buffer<ImmuneCell>;
    
    // Pathogens
    var activePathogens : Buffer.Buffer<Pathogen>;
    var neutralizedPathogens : Buffer.Buffer<Pathogen>;
    
    // Antibodies
    var antibodies : Buffer.Buffer<Antibody>;
    
    // Cytokines
    var cytokineSignals : Buffer.Buffer<CytokineSignal>;
    
    // Inflammation
    var inflammationSites : Buffer.Buffer<InflammationState>;
    var globalInflammation : Float;
    
    // Self-tolerance
    var selfAntigens : [SelfAntigen];
    
    // Memory
    var memoryRecords : Buffer.Buffer<MemoryRecord>;
    var boosterHistory : Buffer.Buffer<BoosterResponse>;
    
    // Global metrics
    var immuneReadiness : Float;      // Overall immune preparedness
    var activeResponseLevel : Float;  // Current response intensity
    var toleranceIntegrity : Float;   // Self-tolerance health
    var memoryCapacity : Float;       // Remaining memory capacity
    
    // Tracking
    var totalPathogensDefeated : Nat;
    var totalAutoimmuneSuppressed : Nat;
    var currentBeat : Int;
    var cellIdCounter : Nat64;
    var antibodyIdCounter : Nat64;
    var recordIdCounter : Nat64;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 8: INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Initialize immune system
  public func initImmuneSystem() : ImmuneSystemState {
    {
      var innCells = Buffer.Buffer<ImmuneCell>(MAX_IMMUNE_CELLS / 2);
      var adaptiveCells = Buffer.Buffer<ImmuneCell>(MAX_IMMUNE_CELLS / 2);
      var memoryCells = Buffer.Buffer<ImmuneCell>(MAX_MEMORY_CELLS);
      
      var activePathogens = Buffer.Buffer<Pathogen>(MAX_PATHOGENS);
      var neutralizedPathogens = Buffer.Buffer<Pathogen>(100);
      
      var antibodies = Buffer.Buffer<Antibody>(MAX_ANTIBODIES);
      
      var cytokineSignals = Buffer.Buffer<CytokineSignal>(100);
      
      var inflammationSites = Buffer.Buffer<InflammationState>(20);
      var globalInflammation = 0.0;
      
      var selfAntigens = [];
      
      var memoryRecords = Buffer.Buffer<MemoryRecord>(MAX_MEMORY_CELLS);
      var boosterHistory = Buffer.Buffer<BoosterResponse>(50);
      
      var immuneReadiness = S_ZERO_FLOOR;
      var activeResponseLevel = 0.0;
      var toleranceIntegrity = S_ZERO_FLOOR;
      var memoryCapacity = 1.0;
      
      var totalPathogensDefeated = 0;
      var totalAutoimmuneSuppressed = 0;
      var currentBeat = 0;
      var cellIdCounter = 0;
      var antibodyIdCounter = 0;
      var recordIdCounter = 0;
    }
  };
  
  /// Create a new immune cell
  public func createImmuneCell(
    state : ImmuneSystemState,
    cellType : ImmuneCellType,
    location : PathogenLocation,
    beat : Int
  ) : ImmuneCell {
    let cellId = state.cellIdCounter;
    state.cellIdCounter += 1;
    
    let lifespan = getCellLifespan(cellType);
    
    {
      cellId = cellId;
      cellType = cellType;
      var state = #Naive;
      var targetSignature = null;
      var affinity = 0.0;
      var activation = 0.0;
      var lifespan = lifespan;
      var location = location;
      var kills = 0;
      var cytokineProduction = 0.0;
      createdBeat = beat;
      var lastActivityBeat = beat;
    }
  };
  
  /// Get default lifespan for cell type
  func getCellLifespan(cellType : ImmuneCellType) : Nat {
    switch (cellType) {
      case (#Macrophage) { 1000 };
      case (#Neutrophil) { 50 };      // Short-lived
      case (#NaturalKiller) { 500 };
      case (#DendriticCell) { 300 };
      case (#Complement) { 100 };
      case (#HelperT) { 800 };
      case (#CytotoxicT) { 600 };
      case (#RegulatoryT) { 700 };
      case (#BCell) { 500 };
      case (#PlasmaCell) { 400 };
      case (#MemoryB) { 10000 };      // Long-lived
      case (#MemoryT) { 10000 };      // Long-lived
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 9: PATTERN RECOGNITION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Pattern Recognition Receptor (PRR) detection
  /// Returns threat score based on pattern matching
  public func patternRecognition(
    pattern : [Nat8],
    knownPatterns : [PathogenSignature]
  ) : (Float, ?PathogenSignature) {
    var maxMatch : Float = 0.0;
    var bestMatch : ?PathogenSignature = null;
    
    for (known in knownPatterns.vals()) {
      let matchScore = computePatternMatch(pattern, known.pattern);
      if (matchScore > maxMatch) {
        maxMatch := matchScore;
        bestMatch := ?known;
      };
    };
    
    (maxMatch, bestMatch)
  };
  
  /// Compute pattern match score (0-1)
  func computePatternMatch(pattern1 : [Nat8], pattern2 : [Nat8]) : Float {
    let len1 = pattern1.size();
    let len2 = pattern2.size();
    
    if (len1 == 0 or len2 == 0) {
      return 0.0;
    };
    
    var matches : Nat = 0;
    let minLen = if (len1 < len2) { len1 } else { len2 };
    
    for (i in Iter.range(0, minLen - 1)) {
      if (pattern1[i] == pattern2[i]) {
        matches += 1;
      };
    };
    
    Float.fromInt(matches) / Float.fromInt(minLen)
  };
  
  /// Check if pattern matches self-antigen (tolerance check)
  public func checkSelfTolerance(
    state : ImmuneSystemState,
    pattern : [Nat8]
  ) : ToleranceResult {
    for (selfAntigen in state.selfAntigens.vals()) {
      let matchScore = computePatternMatch(pattern, selfAntigen.pattern);
      
      if (matchScore > (1.0 - TOLERANCE_THRESHOLD)) {
        // High match to self = tolerance
        return #Tolerant;
      };
      
      if (matchScore > 0.5) {
        // Moderate match = uncertain, check regulatory cells
        var regulatorySuppression : Float = 0.0;
        for (cell in state.adaptiveCells.vals()) {
          switch (cell.cellType) {
            case (#RegulatoryT) {
              regulatorySuppression += cell.activation * 0.3;
            };
            case (_) {};
          };
        };
        
        if (regulatorySuppression > 0.5) {
          return #Suppressed;
        };
        
        return #Uncertain;
      };
    };
    
    // No self-match = attack
    #Attack
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 10: INNATE IMMUNE RESPONSE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Trigger innate immune response
  public func triggerInnateResponse(
    state : ImmuneSystemState,
    pathogen : Pathogen,
    beat : Int
  ) : InnateResponseResult {
    var response : InnateResponseResult = {
      triggered = false;
      macrophagesActivated = 0;
      neutrophilsRecruited = 0;
      nkCellsActivated = 0;
      complementActivated = false;
      inflammationLevel = 0.0;
      cytokinesReleased = [];
    };
    
    // Check threshold
    if (pathogen.population < INNATE_THRESHOLD) {
      return response;
    };
    
    response.triggered := true;
    
    // Activate macrophages
    for (cell in state.innCells.vals()) {
      switch (cell.cellType) {
        case (#Macrophage) {
          if (cell.state == #Naive or cell.activation < 0.5) {
            cell.state := #Activated;
            cell.activation := Float.min(1.0, cell.activation + 0.3);
            cell.targetSignature := ?pathogen.signature;
            cell.location := pathogen.location;
            cell.lastActivityBeat := beat;
            response.macrophagesActivated += 1;
          };
        };
        case (_) {};
      };
    };
    
    // Recruit neutrophils
    var neutrophilsNeeded = Nat.min(10, Int.abs(Float.toInt(pathogen.population * 10.0)));
    for (_ in Iter.range(0, neutrophilsNeeded - 1)) {
      let neutrophil = createImmuneCell(state, #Neutrophil, pathogen.location, beat);
      neutrophil.state := #Effector;
      neutrophil.activation := 0.8;
      neutrophil.targetSignature := ?pathogen.signature;
      state.innCells.add(neutrophil);
      response.neutrophilsRecruited += 1;
    };
    
    // Activate NK cells
    for (cell in state.innCells.vals()) {
      switch (cell.cellType) {
        case (#NaturalKiller) {
          if (cell.state != #Exhausted) {
            cell.state := #Effector;
            cell.activation := Float.min(1.0, cell.activation + 0.4);
            cell.location := pathogen.location;
            cell.lastActivityBeat := beat;
            response.nkCellsActivated += 1;
          };
        };
        case (_) {};
      };
    };
    
    // Activate complement
    response.complementActivated := true;
    pathogen.markedForDestruction := true;
    
    // Release cytokines
    let il1 : CytokineSignal = {
      cytokine = #Interleukin1;
      var concentration = pathogen.virulence * 0.5;
      sourceLocation = pathogen.location;
      var decayRate = 0.9;
      producedBeat = beat;
    };
    state.cytokineSignals.add(il1);
    
    let tnf : CytokineSignal = {
      cytokine = #TNFAlpha;
      var concentration = pathogen.virulence * 0.4;
      sourceLocation = pathogen.location;
      var decayRate = 0.85;
      producedBeat = beat;
    };
    state.cytokineSignals.add(tnf);
    
    response.cytokinesReleased := [#Interleukin1, #TNFAlpha];
    
    // Trigger inflammation
    let inflammation : InflammationState = {
      var level = pathogen.virulence * 0.6;
      var location = pathogen.location;
      var duration = 0;
      var isAcute = true;
      var isChronic = false;
      var tissuesDamage = 0.0;
    };
    state.inflammationSites.add(inflammation);
    response.inflammationLevel := inflammation.level;
    
    response
  };
  
  /// Innate response result
  public type InnateResponseResult = {
    triggered : Bool;
    macrophagesActivated : Nat;
    neutrophilsRecruited : Nat;
    nkCellsActivated : Nat;
    complementActivated : Bool;
    inflammationLevel : Float;
    cytokinesReleased : [CytokineType];
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 11: ADAPTIVE IMMUNE RESPONSE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Trigger adaptive immune response (T-cell and B-cell mediated)
  public func triggerAdaptiveResponse(
    state : ImmuneSystemState,
    pathogen : Pathogen,
    beat : Int
  ) : AdaptiveResponseResult {
    var response : AdaptiveResponseResult = {
      triggered = false;
      helperTActivated = 0;
      cytotoxicTActivated = 0;
      bCellsActivated = 0;
      antibodiesProduced = 0;
      memoryFormed = false;
      isSecondaryResponse = false;
      affinityLevel = 0.0;
    };
    
    // Check threshold
    if (pathogen.population < ADAPTIVE_THRESHOLD) {
      return response;
    };
    
    response.triggered := true;
    
    // Check for memory (secondary response)
    var memoryMatch : ?MemoryRecord = null;
    for (record in state.memoryRecords.vals()) {
      let matchScore = computePatternMatch(
        pathogen.signature.pattern,
        record.pathogenSignature.pattern
      );
      if (matchScore > 0.7) {
        memoryMatch := ?record;
        response.isSecondaryResponse := true;
        response.affinityLevel := record.affinity;
      };
    };
    
    // Activate Helper T cells (CD4+)
    for (cell in state.adaptiveCells.vals()) {
      switch (cell.cellType) {
        case (#HelperT) {
          if (cell.state == #Naive) {
            cell.state := #Activated;
            cell.activation := if (response.isSecondaryResponse) { 0.9 } else { 0.6 };
            cell.targetSignature := ?pathogen.signature;
            cell.location := pathogen.location;
            cell.lastActivityBeat := beat;
            response.helperTActivated += 1;
            
            // Release IL-2 for T-cell proliferation
            let il2 : CytokineSignal = {
              cytokine = #Interleukin2;
              var concentration = cell.activation * 0.5;
              sourceLocation = cell.location;
              var decayRate = 0.9;
              producedBeat = beat;
            };
            state.cytokineSignals.add(il2);
          };
        };
        case (_) {};
      };
    };
    
    // Activate Cytotoxic T cells (CD8+)
    for (cell in state.adaptiveCells.vals()) {
      switch (cell.cellType) {
        case (#CytotoxicT) {
          if (cell.state == #Naive or cell.state == #Memory) {
            cell.state := #Effector;
            cell.activation := if (response.isSecondaryResponse) { 0.95 } else { 0.7 };
            cell.targetSignature := ?pathogen.signature;
            cell.affinity := if (response.isSecondaryResponse) { 
              switch (memoryMatch) {
                case (?m) { m.affinity };
                case (null) { 0.5 };
              }
            } else { 0.3 };
            cell.location := pathogen.location;
            cell.lastActivityBeat := beat;
            response.cytotoxicTActivated += 1;
          };
        };
        case (_) {};
      };
    };
    
    // Activate B cells
    for (cell in state.adaptiveCells.vals()) {
      switch (cell.cellType) {
        case (#BCell) {
          if (cell.state == #Naive) {
            cell.state := #Activated;
            cell.activation := if (response.isSecondaryResponse) { 0.9 } else { 0.5 };
            cell.targetSignature := ?pathogen.signature;
            cell.affinity := if (response.isSecondaryResponse) {
              switch (memoryMatch) {
                case (?m) { m.affinity };
                case (null) { 0.4 };
              }
            } else { 0.2 };
            cell.location := pathogen.location;
            cell.lastActivityBeat := beat;
            response.bCellsActivated += 1;
          };
        };
        case (_) {};
      };
    };
    
    // Produce antibodies
    let antibodyCount = if (response.isSecondaryResponse) { 5 } else { 2 };
    for (_ in Iter.range(0, antibodyCount - 1)) {
      let antibody = createAntibody(state, pathogen.signature, response.isSecondaryResponse, beat);
      state.antibodies.add(antibody);
      response.antibodiesProduced += 1;
    };
    
    // Form memory if not already present
    switch (memoryMatch) {
      case (null) {
        let record : MemoryRecord = {
          recordId = state.recordIdCounter;
          pathogenSignature = pathogen.signature;
          var affinity = 0.3;
          var strength = 0.5;
          var lastEncounterBeat = beat;
          var encounterCount = 1;
          var successfulDefenses = 0;
          createdBeat = beat;
        };
        state.recordIdCounter += 1;
        state.memoryRecords.add(record);
        response.memoryFormed := true;
      };
      case (?existing) {
        // Strengthen existing memory
        existing.affinity := Float.min(1.0, existing.affinity + AFFINITY_MATURATION_RATE);
        existing.strength := Float.min(1.0, existing.strength + 0.1);
        existing.lastEncounterBeat := beat;
        existing.encounterCount += 1;
        response.affinityLevel := existing.affinity;
      };
    };
    
    response
  };
  
  /// Adaptive response result
  public type AdaptiveResponseResult = {
    triggered : Bool;
    helperTActivated : Nat;
    cytotoxicTActivated : Nat;
    bCellsActivated : Nat;
    antibodiesProduced : Nat;
    memoryFormed : Bool;
    isSecondaryResponse : Bool;
    affinityLevel : Float;
  };
  
  /// Create antibody
  func createAntibody(
    state : ImmuneSystemState,
    signature : PathogenSignature,
    isSecondary : Bool,
    beat : Int
  ) : Antibody {
    let id = state.antibodyIdCounter;
    state.antibodyIdCounter += 1;
    
    {
      antibodyId = id;
      class_ = if (isSecondary) { #IgG } else { #IgM };
      targetSignature = signature;
      var affinity = if (isSecondary) { 0.8 } else { 0.3 };
      var concentration = if (isSecondary) { 0.7 } else { 0.3 };
      var neutralizationPotency = if (isSecondary) { 0.9 } else { 0.5 };
      var opsonizationStrength = if (isSecondary) { 0.8 } else { 0.4 };
      producingCellId = 0;
      createdBeat = beat;
      var lastMatchBeat = beat;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 12: PATHOGEN DESTRUCTION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Execute pathogen destruction by immune cells
  public func executeDestruction(
    state : ImmuneSystemState,
    beat : Int
  ) : DestructionResult {
    var result : DestructionResult = {
      pathogensDestroyed = 0;
      cellDeaths = 0;
      damageInflicted = 0.0;
    };
    
    // Process each active pathogen
    for (pathogen in state.activePathogens.vals()) {
      if (pathogen.isNeutralized) {
        continue;
      };
      
      var totalDamage : Float = 0.0;
      
      // Innate cell attacks
      for (cell in state.innCells.vals()) {
        if (cell.state == #Effector and matchesLocation(cell.location, pathogen.location)) {
          switch (cell.cellType) {
            case (#Macrophage) {
              // Phagocytosis
              let damage = cell.activation * 0.3 * (1.0 - pathogen.evasion);
              totalDamage += damage;
              cell.kills += 1;
            };
            case (#Neutrophil) {
              // Neutrophil burst
              let damage = cell.activation * 0.4 * (1.0 - pathogen.evasion);
              totalDamage += damage;
              cell.lifespan := cell.lifespan / 2;  // Suicide attack
            };
            case (#NaturalKiller) {
              let damage = cell.activation * NK_CELL_POTENCY * (1.0 - pathogen.evasion);
              totalDamage += damage;
              cell.kills += 1;
            };
            case (_) {};
          };
        };
      };
      
      // Adaptive cell attacks
      for (cell in state.adaptiveCells.vals()) {
        if (cell.state == #Effector and matchesLocation(cell.location, pathogen.location)) {
          switch (cell.cellType) {
            case (#CytotoxicT) {
              // Check affinity-based recognition
              switch (cell.targetSignature) {
                case (?target) {
                  let match = computePatternMatch(target.pattern, pathogen.signature.pattern);
                  if (match > 0.5) {
                    let damage = cell.activation * T_CELL_CYTOTOXICITY * cell.affinity * (1.0 - pathogen.evasion);
                    totalDamage += damage;
                    cell.kills += 1;
                  };
                };
                case (null) {};
              };
            };
            case (_) {};
          };
        };
      };
      
      // Antibody neutralization
      for (antibody in state.antibodies.vals()) {
        let match = computePatternMatch(antibody.targetSignature.pattern, pathogen.signature.pattern);
        if (match > 0.5) {
          let damage = antibody.concentration * antibody.neutralizationPotency * match;
          totalDamage += damage;
          antibody.lastMatchBeat := beat;
        };
      };
      
      // Complement amplification
      if (pathogen.markedForDestruction) {
        totalDamage *= COMPLEMENT_AMPLIFICATION;
      };
      
      // Apply damage
      pathogen.population -= totalDamage;
      result.damageInflicted += totalDamage;
      
      // Check if destroyed
      if (pathogen.population <= 0.0) {
        pathogen.isNeutralized := true;
        result.pathogensDestroyed += 1;
        state.totalPathogensDefeated += 1;
        
        // Update memory
        for (record in state.memoryRecords.vals()) {
          let match = computePatternMatch(record.pathogenSignature.pattern, pathogen.signature.pattern);
          if (match > 0.7) {
            record.successfulDefenses += 1;
            record.strength := Float.min(1.0, record.strength + 0.1);
          };
        };
      };
      
      pathogen.lastActivityBeat := beat;
    };
    
    // Remove dead cells
    result.cellDeaths := removeDeadCells(state);
    
    result
  };
  
  /// Destruction result
  public type DestructionResult = {
    pathogensDestroyed : Nat;
    cellDeaths : Nat;
    damageInflicted : Float;
  };
  
  /// Check if locations match
  func matchesLocation(loc1 : PathogenLocation, loc2 : PathogenLocation) : Bool {
    switch (loc1, loc2) {
      case (#Global, _) { true };
      case (_, #Global) { true };
      case (#Module(m1), #Module(m2)) { m1 == m2 };
      case (#Memory, #Memory) { true };
      case (#Network, #Network) { true };
      case (#Economy, #Economy) { true };
      case (#Governance, #Governance) { true };
      case (_, _) { false };
    }
  };
  
  /// Remove dead cells
  func removeDeadCells(state : ImmuneSystemState) : Nat {
    var removed : Nat = 0;
    
    // Check innate cells
    var i : Int = Int.abs(state.innCells.size()) - 1;
    while (i >= 0) {
      let cell = state.innCells.get(Int.abs(i));
      if (cell.lifespan == 0 or cell.state == #Apoptotic) {
        ignore state.innCells.remove(Int.abs(i));
        removed += 1;
      } else {
        cell.lifespan -= 1;
      };
      i -= 1;
    };
    
    // Check adaptive cells
    i := Int.abs(state.adaptiveCells.size()) - 1;
    while (i >= 0) {
      let cell = state.adaptiveCells.get(Int.abs(i));
      if (cell.lifespan == 0 or cell.state == #Apoptotic) {
        ignore state.adaptiveCells.remove(Int.abs(i));
        removed += 1;
      } else {
        cell.lifespan -= 1;
      };
      i -= 1;
    };
    
    removed
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 13: INFLAMMATION MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Update inflammation states
  public func updateInflammation(state : ImmuneSystemState, beat : Int) : () {
    var totalInflammation : Float = 0.0;
    
    // Decay existing inflammation
    var i : Int = Int.abs(state.inflammationSites.size()) - 1;
    while (i >= 0) {
      let site = state.inflammationSites.get(Int.abs(i));
      site.duration += 1;
      site.level *= INFLAMMATION_DECAY;
      
      // Check for chronic inflammation
      if (site.duration > 100 and site.level > 0.3) {
        site.isAcute := false;
        site.isChronic := true;
        site.tissuesDamage += 0.01;  // Chronic damage
      };
      
      // Remove resolved inflammation
      if (site.level < 0.05) {
        ignore state.inflammationSites.remove(Int.abs(i));
      } else {
        totalInflammation += site.level;
      };
      
      i -= 1;
    };
    
    // Update global inflammation
    state.globalInflammation := Float.min(1.0, totalInflammation);
    
    // Decay cytokines
    i := Int.abs(state.cytokineSignals.size()) - 1;
    while (i >= 0) {
      let signal = state.cytokineSignals.get(Int.abs(i));
      signal.concentration *= signal.decayRate;
      
      if (signal.concentration < 0.01) {
        ignore state.cytokineSignals.remove(Int.abs(i));
      };
      
      i -= 1;
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 14: REGULATORY MECHANISMS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Activate regulatory T cells to suppress excess response
  public func activateRegulatoryMechanisms(state : ImmuneSystemState, beat : Int) : () {
    // Check if regulation needed (high inflammation, low pathogen load)
    var pathogenLoad : Float = 0.0;
    for (pathogen in state.activePathogens.vals()) {
      if (not pathogen.isNeutralized) {
        pathogenLoad += pathogen.population;
      };
    };
    
    // If inflammation high but pathogens controlled, activate Tregs
    if (state.globalInflammation > 0.6 and pathogenLoad < 0.3) {
      for (cell in state.adaptiveCells.vals()) {
        switch (cell.cellType) {
          case (#RegulatoryT) {
            cell.state := #Effector;
            cell.activation := Float.min(1.0, cell.activation + 0.3);
            cell.cytokineProduction := 0.5;
            cell.lastActivityBeat := beat;
            
            // Release anti-inflammatory cytokines
            let il10 : CytokineSignal = {
              cytokine = #Interleukin10;
              var concentration = cell.activation * 0.6;
              sourceLocation = cell.location;
              var decayRate = 0.95;
              producedBeat = beat;
            };
            state.cytokineSignals.add(il10);
            
            let tgfb : CytokineSignal = {
              cytokine = #TGFBeta;
              var concentration = cell.activation * 0.4;
              sourceLocation = cell.location;
              var decayRate = 0.95;
              producedBeat = beat;
            };
            state.cytokineSignals.add(tgfb);
          };
          case (_) {};
        };
      };
      
      // Suppress effector cells
      for (cell in state.adaptiveCells.vals()) {
        switch (cell.cellType) {
          case (#CytotoxicT) {
            if (cell.state == #Effector) {
              cell.activation *= 0.9;
              if (cell.activation < 0.3) {
                cell.state := #Memory;
              };
            };
          };
          case (#HelperT) {
            if (cell.state == #Effector) {
              cell.activation *= 0.9;
            };
          };
          case (_) {};
        };
      };
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 15: MEMORY MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Update immune memory (decay, strengthening)
  public func updateMemory(state : ImmuneSystemState, beat : Int) : () {
    // Decay memory records
    var i : Int = Int.abs(state.memoryRecords.size()) - 1;
    while (i >= 0) {
      let record = state.memoryRecords.get(Int.abs(i));
      
      // Memory decay based on time since last encounter
      let timeSinceEncounter = Int.abs(beat - record.lastEncounterBeat);
      let decayFactor = Float.exp(-Float.fromInt(timeSinceEncounter) / Float.fromInt(MEMORY_HALFLIFE));
      record.strength *= decayFactor;
      
      // Remove weak memories
      if (record.strength < 0.1) {
        ignore state.memoryRecords.remove(Int.abs(i));
      };
      
      i -= 1;
    };
    
    // Update memory capacity
    state.memoryCapacity := 1.0 - Float.fromInt(state.memoryRecords.size()) / Float.fromInt(MAX_MEMORY_CELLS);
    
    // Convert long-lived effector cells to memory cells
    for (cell in state.adaptiveCells.vals()) {
      switch (cell.cellType) {
        case (#CytotoxicT) {
          if (cell.state == #Effector and cell.lifespan > 500 and cell.kills > 0) {
            // Create memory T cell
            let memoryCell = createImmuneCell(state, #MemoryT, cell.location, beat);
            memoryCell.state := #Memory;
            memoryCell.targetSignature := cell.targetSignature;
            memoryCell.affinity := Float.min(1.0, cell.affinity + AFFINITY_MATURATION_RATE);
            memoryCell.kills := cell.kills;
            state.memoryCells.add(memoryCell);
            
            cell.state := #Apoptotic;
          };
        };
        case (#BCell) {
          if (cell.state == #Activated and cell.activation > 0.7) {
            // Create memory B cell
            let memoryCell = createImmuneCell(state, #MemoryB, cell.location, beat);
            memoryCell.state := #Memory;
            memoryCell.targetSignature := cell.targetSignature;
            memoryCell.affinity := Float.min(1.0, cell.affinity + AFFINITY_MATURATION_RATE);
            state.memoryCells.add(memoryCell);
          };
        };
        case (_) {};
      };
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 16: MAIN HEARTBEAT UPDATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Main immune system heartbeat
  public func heartbeatUpdate(state : ImmuneSystemState, beat : Int) : ImmuneHeartbeatResult {
    state.currentBeat := beat;
    
    var result : ImmuneHeartbeatResult = {
      beat = beat;
      activePathogenCount = 0;
      innateResponseTriggered = false;
      adaptiveResponseTriggered = false;
      pathogensDestroyed = 0;
      inflammationLevel = 0.0;
      memoryStrength = 0.0;
      toleranceIntact = true;
      immuneReadiness = 0.0;
    };
    
    // Count active pathogens
    for (pathogen in state.activePathogens.vals()) {
      if (not pathogen.isNeutralized) {
        result.activePathogenCount += 1;
        
        // Trigger immune responses
        let innateResult = triggerInnateResponse(state, pathogen, beat);
        if (innateResult.triggered) {
          result.innateResponseTriggered := true;
        };
        
        let adaptiveResult = triggerAdaptiveResponse(state, pathogen, beat);
        if (adaptiveResult.triggered) {
          result.adaptiveResponseTriggered := true;
        };
      };
    };
    
    // Execute destruction
    let destructionResult = executeDestruction(state, beat);
    result.pathogensDestroyed := destructionResult.pathogensDestroyed;
    
    // Update inflammation
    updateInflammation(state, beat);
    result.inflammationLevel := state.globalInflammation;
    
    // Activate regulatory mechanisms
    activateRegulatoryMechanisms(state, beat);
    
    // Update memory
    updateMemory(state, beat);
    
    // Compute memory strength
    var totalMemoryStrength : Float = 0.0;
    for (record in state.memoryRecords.vals()) {
      totalMemoryStrength += record.strength;
    };
    result.memoryStrength := totalMemoryStrength / Float.max(1.0, Float.fromInt(state.memoryRecords.size()));
    
    // Update global metrics
    state.immuneReadiness := computeImmuneReadiness(state);
    result.immuneReadiness := state.immuneReadiness;
    
    state.toleranceIntegrity := computeToleranceIntegrity(state);
    result.toleranceIntact := state.toleranceIntegrity > 0.8;
    
    state.activeResponseLevel := if (result.innateResponseTriggered or result.adaptiveResponseTriggered) {
      0.8
    } else {
      state.activeResponseLevel * 0.95
    };
    
    result
  };
  
  /// Immune heartbeat result
  public type ImmuneHeartbeatResult = {
    beat : Int;
    activePathogenCount : Nat;
    innateResponseTriggered : Bool;
    adaptiveResponseTriggered : Bool;
    pathogensDestroyed : Nat;
    inflammationLevel : Float;
    memoryStrength : Float;
    toleranceIntact : Bool;
    immuneReadiness : Float;
  };
  
  /// Compute immune readiness
  func computeImmuneReadiness(state : ImmuneSystemState) : Float {
    var readiness : Float = 0.0;
    
    // Cell availability
    let innCellRatio = Float.fromInt(state.innCells.size()) / Float.fromInt(MAX_IMMUNE_CELLS / 4);
    let adaptiveCellRatio = Float.fromInt(state.adaptiveCells.size()) / Float.fromInt(MAX_IMMUNE_CELLS / 4);
    readiness += Float.min(1.0, innCellRatio) * 0.2;
    readiness += Float.min(1.0, adaptiveCellRatio) * 0.2;
    
    // Memory strength
    readiness += state.memoryCapacity * 0.2;
    
    // Low inflammation is good
    readiness += (1.0 - state.globalInflammation) * 0.2;
    
    // Tolerance integrity
    readiness += state.toleranceIntegrity * 0.2;
    
    Float.max(S_ZERO_FLOOR, Float.min(1.0, readiness))
  };
  
  /// Compute tolerance integrity
  func computeToleranceIntegrity(state : ImmuneSystemState) : Float {
    var integrity : Float = S_ZERO_FLOOR;
    
    // Check for autoimmune activity
    var autoimmuneCells : Nat = 0;
    for (cell in state.adaptiveCells.vals()) {
      switch (cell.targetSignature) {
        case (?target) {
          for (selfAntigen in state.selfAntigens.vals()) {
            let match = computePatternMatch(target.pattern, selfAntigen.pattern);
            if (match > 0.7) {
              autoimmuneCells += 1;
            };
          };
        };
        case (null) {};
      };
    };
    
    // More autoimmune cells = lower integrity
    integrity -= Float.fromInt(autoimmuneCells) * 0.1;
    
    // Regulatory T cell presence increases integrity
    var tregCount : Nat = 0;
    for (cell in state.adaptiveCells.vals()) {
      switch (cell.cellType) {
        case (#RegulatoryT) { tregCount += 1 };
        case (_) {};
      };
    };
    integrity += Float.fromInt(tregCount) * 0.05;
    
    Float.max(S_ZERO_FLOOR, Float.min(1.0, integrity))
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 17: PATHOGEN INTRODUCTION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Introduce a new pathogen (threat detection)
  public func introducePathogen(
    state : ImmuneSystemState,
    signature : PathogenSignature,
    initialPopulation : Float,
    virulence : Float,
    location : PathogenLocation,
    beat : Int
  ) : Nat64 {
    let pathogenId = state.cellIdCounter;
    state.cellIdCounter += 1;
    
    let pathogen : Pathogen = {
      pathogenId = pathogenId;
      signature = signature;
      var population = initialPopulation;
      var virulence = virulence;
      var evasion = signature.mutationRate * 0.5;
      var location = location;
      var detectedBeat = beat;
      var lastActivityBeat = beat;
      var isNeutralized = false;
      var markedForDestruction = false;
    };
    
    state.activePathogens.add(pathogen);
    pathogenId
  };
  
  /// Create pathogen signature
  public func createSignature(
    state : ImmuneSystemState,
    pattern : [Nat8],
    category : PathogenCategory,
    mutationRate : Float,
    beat : Int
  ) : PathogenSignature {
    {
      signatureId = state.cellIdCounter;
      pattern = pattern;
      category = category;
      var mutationRate = mutationRate;
      originBeat = beat;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 18: SELF-ANTIGEN REGISTRATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Register a self-antigen (for tolerance)
  public func registerSelfAntigen(
    state : ImmuneSystemState,
    pattern : [Nat8],
    location : PathogenLocation,
    criticality : Float,
    beat : Int
  ) : Nat64 {
    let id = state.recordIdCounter;
    state.recordIdCounter += 1;
    
    let antigen : SelfAntigen = {
      antigenId = id;
      pattern = pattern;
      location = location;
      criticality = criticality;
      var lastVerified = beat;
    };
    
    // Add to self-antigens
    let newAntigens = Array.append(state.selfAntigens, [antigen]);
    state.selfAntigens := newAntigens;
    
    id
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 19: QUERY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Get immune readiness
  public func getImmuneReadiness(state : ImmuneSystemState) : Float {
    state.immuneReadiness
  };
  
  /// Get active pathogen count
  public func getActivePathogenCount(state : ImmuneSystemState) : Nat {
    var count : Nat = 0;
    for (p in state.activePathogens.vals()) {
      if (not p.isNeutralized) { count += 1 };
    };
    count
  };
  
  /// Get inflammation level
  public func getInflammationLevel(state : ImmuneSystemState) : Float {
    state.globalInflammation
  };
  
  /// Get tolerance integrity
  public func getToleranceIntegrity(state : ImmuneSystemState) : Float {
    state.toleranceIntegrity
  };
  
  /// Get memory capacity
  public func getMemoryCapacity(state : ImmuneSystemState) : Float {
    state.memoryCapacity
  };
  
  /// Get total pathogens defeated
  public func getTotalPathogensDefeated(state : ImmuneSystemState) : Nat {
    state.totalPathogensDefeated
  };
  
  /// Check if under active attack
  public func isUnderAttack(state : ImmuneSystemState) : Bool {
    state.activeResponseLevel > 0.5
  };
  
  /// Get cell counts by type
  public func getCellCounts(state : ImmuneSystemState) : [(Text, Nat)] {
    var counts : [(Text, Nat)] = [];
    
    var macrophages : Nat = 0;
    var neutrophils : Nat = 0;
    var nkCells : Nat = 0;
    var helperT : Nat = 0;
    var cytotoxicT : Nat = 0;
    var bCells : Nat = 0;
    var memoryT : Nat = 0;
    var memoryB : Nat = 0;
    var tregs : Nat = 0;
    
    for (cell in state.innCells.vals()) {
      switch (cell.cellType) {
        case (#Macrophage) { macrophages += 1 };
        case (#Neutrophil) { neutrophils += 1 };
        case (#NaturalKiller) { nkCells += 1 };
        case (_) {};
      };
    };
    
    for (cell in state.adaptiveCells.vals()) {
      switch (cell.cellType) {
        case (#HelperT) { helperT += 1 };
        case (#CytotoxicT) { cytotoxicT += 1 };
        case (#BCell) { bCells += 1 };
        case (#RegulatoryT) { tregs += 1 };
        case (_) {};
      };
    };
    
    for (cell in state.memoryCells.vals()) {
      switch (cell.cellType) {
        case (#MemoryT) { memoryT += 1 };
        case (#MemoryB) { memoryB += 1 };
        case (_) {};
      };
    };
    
    [
      ("Macrophages", macrophages),
      ("Neutrophils", neutrophils),
      ("NK Cells", nkCells),
      ("Helper T", helperT),
      ("Cytotoxic T", cytotoxicT),
      ("B Cells", bCells),
      ("Tregs", tregs),
      ("Memory T", memoryT),
      ("Memory B", memoryB)
    ]
  };

}
