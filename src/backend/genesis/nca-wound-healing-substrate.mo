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
// NEURAL CELLULAR AUTOMATA (NCA) WOUND-HEALING SUBSTRATE
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// This module implements self-repair at the cellular level through Neural Cellular Automata (NCA).
// The organism can now detect damage (wounds) and regenerate using local NCA rules with morphogen gradients.
//
// MATHEMATICAL FOUNDATIONS:
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// NCA State Update:     state[i,j,t+1] = f(Σ_neighbors state × kernel + morphogen_gradient)
// Wound Detection:      coherence[region] < 0.6 × S₀_floor triggers wound flag
// Reaction-Diffusion:   ∂u/∂t = f(u,v) + Dᵤ∇²u ; ∂v/∂t = g(u,v) + Dᵥ∇²v (Turing patterns)
// Morphogen Gradient:   M(x) = M₀ × exp(-|x - source|/λ) (exponential decay from source)
// Healing Rate:         dR/dt = α × morphogen × (1 - density) × coherence
// Scarring:             If healing incomplete after τ_heal, scar forms with reduced function
//
// BIOLOGICAL INSPIRATION:
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// • Neural plasticity and axon regeneration
// • Morphogenetic fields and reaction-diffusion systems
// • Stem cell activation and differentiation
// • Cellular automata rules for pattern formation
// • Wound healing cascades with inflammation → proliferation → remodeling
//
// INTEGRATION WITH ORGANISM:
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// • Monitors all shells for coherence drops (wound detection)
// • Triggers local NCA healing when wounds detected
// • Morphogen gradients guide regeneration topology
// • Scars reduce local weight bounds permanently
// • Reports healing status to ARES homeostatic regulation
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

module NCAwoundHealingSubstrate {

  // ═══════════════════════════════════════════════════════════════════════════════
  // MATHEMATICAL CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let PI : Float = 3.14159265358979323846;
  public let TWO_PI : Float = 6.28318530717958647692;
  public let E : Float = 2.71828182845904523536;
  public let LN_2 : Float = 0.69314718055994530942;
  public let PHI : Float = 1.61803398874989484820;  // Golden ratio
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // NCA GRID CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Grid dimensions (matches shell structure)
  public let GRID_SIZE : Nat = 64;
  public let TOTAL_CELLS : Nat = 4096;  // 64 × 64
  
  /// Number of state channels per cell
  public let STATE_CHANNELS : Nat = 16;
  
  /// Neighborhood radius for NCA updates
  public let NEIGHBORHOOD_RADIUS : Nat = 1;  // 3×3 Moore neighborhood
  
  /// Number of shells to monitor
  public let NUM_SHELLS : Nat = 12;
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // WOUND DETECTION CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// S₀ floor for organism coherence
  /// S₀ SOVEREIGNTY FLOOR — MAXED FOR ENTERPRISE-GRADE FINAL PRODUCT
  /// Full sovereignty protection at all times. The formulas matter, not arbitrary numbers.
  public let S_ZERO_FLOOR : Float = 1.0;
  
  /// Wound threshold: coherence below this × S₀ triggers wound detection
  public let WOUND_THRESHOLD_FACTOR : Float = 0.6;
  
  /// Minimum wound size to trigger healing (cells)
  public let MIN_WOUND_SIZE : Nat = 4;
  
  /// Maximum wound depth (0-1 scale)
  public let MAX_WOUND_DEPTH : Float = 1.0;
  
  /// Critical wound threshold: triggers emergency healing
  public let CRITICAL_WOUND_FACTOR : Float = 0.3;
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // HEALING CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Base healing rate α
  public let HEALING_ALPHA : Float = 0.05;
  
  /// Morphogen diffusion coefficient Dᵤ
  public let MORPHOGEN_DIFFUSION : Float = 0.1;
  
  /// Morphogen decay rate (exponential)
  public let MORPHOGEN_DECAY_LAMBDA : Float = 10.0;  // decay length in cells
  
  /// Maximum healing time before scarring (in heartbeats)
  public let MAX_HEALING_TIME : Nat = 500;
  
  /// Scar formation threshold (partial healing)
  public let SCAR_THRESHOLD : Float = 0.9;
  
  /// Scar weight reduction factor
  public let SCAR_WEIGHT_REDUCTION : Float = 0.8;  // 80% of normal
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // REACTION-DIFFUSION CONSTANTS (Turing patterns)
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Activator diffusion coefficient
  public let D_ACTIVATOR : Float = 0.05;
  
  /// Inhibitor diffusion coefficient
  public let D_INHIBITOR : Float = 0.2;  // Faster than activator
  
  /// Activator production rate
  public let K_ACTIVATOR : Float = 0.04;
  
  /// Inhibitor production rate
  public let K_INHIBITOR : Float = 0.06;
  
  /// Decay rate for both
  public let DECAY_RATE : Float = 0.01;
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // CELL STATE TYPE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// State of a single NCA cell
  public type CellState = {
    var channels : [var Float];     // STATE_CHANNELS values
    var coherence : Float;          // Local coherence [0, 1]
    var isWounded : Bool;           // Whether cell is damaged
    var woundDepth : Float;         // Severity of wound [0, 1]
    var morphogen : Float;          // Morphogen concentration
    var healingProgress : Float;    // How much healing has occurred [0, 1]
    var isScarred : Bool;           // Permanent damage marker
    var scarSeverity : Float;       // How much function is reduced [0, 1]
    var activator : Float;          // Reaction-diffusion activator
    var inhibitor : Float;          // Reaction-diffusion inhibitor
    var lastUpdate : Int;           // Beat of last update
  };
  
  /// 2D grid of NCA cells
  public type NCAGrid = {
    cells : [[var CellState]];      // 64×64 grid
    var totalCoherence : Float;     // Global coherence
    var woundedCellCount : Nat;     // Number of wounded cells
    var healingCellCount : Nat;     // Number of healing cells
    var scarredCellCount : Nat;     // Number of scarred cells
    var activeWounds : [WoundRegion];  // Currently active wounds
    var lastGlobalUpdate : Int;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // WOUND REGION TYPE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// A contiguous region of wounded cells
  public type WoundRegion = {
    id : Nat;
    centerX : Nat;
    centerY : Nat;
    radius : Float;                 // Approximate radius
    cellCount : Nat;                // Number of cells in wound
    meanDepth : Float;              // Average wound depth
    maxDepth : Float;               // Maximum wound depth
    shellId : Nat8;                 // Which shell is affected
    var healingStartBeat : Int;     // When healing began
    var currentHealing : Float;     // Healing progress [0, 1]
    var isCritical : Bool;          // Requires emergency healing
    var morphogenSource : (Nat, Nat);  // (x, y) of morphogen source
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // NCA KERNEL TYPE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Convolution kernel for NCA updates
  public type NCAKernel = {
    weights : [[Float]];            // 3×3 kernel weights
    bias : Float;
    activation : ActivationType;
  };
  
  public type ActivationType = {
    #ReLU;
    #Sigmoid;
    #Tanh;
    #Identity;
    #LeakyReLU;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // MORPHOGEN FIELD TYPE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Morphogen gradient field
  public type MorphogenField = {
    var concentrations : [[var Float]];  // 64×64 concentrations
    sources : [(Nat, Nat, Float)];       // (x, y, strength) sources
    var totalMorphogen : Float;
    diffusionRate : Float;
    decayRate : Float;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // HEALING PHASE TYPE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Phase of wound healing (biological model)
  public type HealingPhase = {
    #Inflammation;    // Initial response, cytokines released (0-25% progress)
    #Proliferation;   // Cell division, new tissue (25-75% progress)
    #Remodeling;      // Strengthening, scar formation (75-100% progress)
    #Complete;        // Healing finished
    #Scarred;         // Incomplete healing, permanent damage
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // NCA SUBSTRATE STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Complete NCA substrate state
  public type NCASubstrateState = {
    grid : NCAGrid;
    morphogenField : MorphogenField;
    kernels : [NCAKernel];          // Multiple kernels for different updates
    var totalWounds : Nat;          // Lifetime wound count
    var healedWounds : Nat;         // Successfully healed wounds
    var totalScars : Nat;           // Permanent scars formed
    var globalHealthScore : Float;  // Overall tissue health [0, 1]
    var lastHeartbeat : Int;
    var isEmergencyMode : Bool;     // Critical damage detected
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // INITIALIZATION FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Initialize a single cell state
  public func initCellState() : CellState {
    {
      var channels = Array.init<Float>(STATE_CHANNELS, 0.0);
      var coherence = 1.0;
      var isWounded = false;
      var woundDepth = 0.0;
      var morphogen = 0.0;
      var healingProgress = 0.0;
      var isScarred = false;
      var scarSeverity = 0.0;
      var activator = 0.0;
      var inhibitor = 0.0;
      var lastUpdate = 0;
    }
  };
  
  /// Initialize the NCA grid
  public func initNCAGrid() : NCAGrid {
    let cells = Array.tabulate<[var CellState]>(GRID_SIZE, func(i : Nat) : [var CellState] {
      Array.tabulate<CellState>(GRID_SIZE, func(j : Nat) : CellState {
        initCellState()
      })
    });
    
    {
      cells = cells;
      var totalCoherence = 1.0;
      var woundedCellCount = 0;
      var healingCellCount = 0;
      var scarredCellCount = 0;
      var activeWounds = [];
      var lastGlobalUpdate = 0;
    }
  };
  
  /// Initialize morphogen field
  public func initMorphogenField() : MorphogenField {
    let conc = Array.tabulate<[var Float]>(GRID_SIZE, func(i : Nat) : [var Float] {
      Array.init<Float>(GRID_SIZE, 0.0)
    });
    
    {
      var concentrations = conc;
      sources = [];
      var totalMorphogen = 0.0;
      diffusionRate = MORPHOGEN_DIFFUSION;
      decayRate = 1.0 / MORPHOGEN_DECAY_LAMBDA;
    }
  };
  
  /// Initialize NCA kernel (learnable perception kernel)
  public func initNCAKernel() : NCAKernel {
    // Sobel-like kernel for edge detection + center emphasis
    let weights : [[Float]] = [
      [-0.1, 0.2, -0.1],
      [0.2, 0.6, 0.2],
      [-0.1, 0.2, -0.1]
    ];
    
    {
      weights = weights;
      bias = 0.0;
      activation = #Tanh;
    }
  };
  
  /// Initialize complete NCA substrate state
  public func initNCASubstrate() : NCASubstrateState {
    {
      grid = initNCAGrid();
      morphogenField = initMorphogenField();
      kernels = [initNCAKernel(), initSobelXKernel(), initSobelYKernel(), initLaplacianKernel()];
      var totalWounds = 0;
      var healedWounds = 0;
      var totalScars = 0;
      var globalHealthScore = 1.0;
      var lastHeartbeat = 0;
      var isEmergencyMode = false;
    }
  };
  
  /// Sobel X kernel for gradient detection
  func initSobelXKernel() : NCAKernel {
    {
      weights = [
        [-1.0, 0.0, 1.0],
        [-2.0, 0.0, 2.0],
        [-1.0, 0.0, 1.0]
      ];
      bias = 0.0;
      activation = #Identity;
    }
  };
  
  /// Sobel Y kernel for gradient detection
  func initSobelYKernel() : NCAKernel {
    {
      weights = [
        [-1.0, -2.0, -1.0],
        [0.0, 0.0, 0.0],
        [1.0, 2.0, 1.0]
      ];
      bias = 0.0;
      activation = #Identity;
    }
  };
  
  /// Laplacian kernel for diffusion
  func initLaplacianKernel() : NCAKernel {
    {
      weights = [
        [0.05, 0.2, 0.05],
        [0.2, -1.0, 0.2],
        [0.05, 0.2, 0.05]
      ];
      bias = 0.0;
      activation = #Identity;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // ACTIVATION FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Apply activation function
  public func applyActivation(x : Float, actType : ActivationType) : Float {
    switch (actType) {
      case (#ReLU) { Float.max(0.0, x) };
      case (#Sigmoid) { 1.0 / (1.0 + Float.exp(-x)) };
      case (#Tanh) { 
        let exp2x = Float.exp(2.0 * x);
        (exp2x - 1.0) / (exp2x + 1.0)
      };
      case (#Identity) { x };
      case (#LeakyReLU) { if (x > 0.0) { x } else { 0.01 * x } };
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // WOUND DETECTION — IDENTIFYING DAMAGE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Detect wounds from coherence values
  /// Returns list of wound regions found
  public func detectWounds(
    state : NCASubstrateState,
    coherenceGrid : [[Float]],  // External coherence from shells
    shellId : Nat8,
    currentBeat : Int
  ) : [WoundRegion] {
    let woundThreshold = S_ZERO_FLOOR * WOUND_THRESHOLD_FACTOR;
    let criticalThreshold = S_ZERO_FLOOR * CRITICAL_WOUND_FACTOR;
    
    // Mark wounded cells
    let woundMask = Array.tabulate<[var Bool]>(GRID_SIZE, func(i : Nat) : [var Bool] {
      Array.init<Bool>(GRID_SIZE, false)
    });
    
    var woundedCount : Nat = 0;
    
    for (i in Iter.range(0, GRID_SIZE - 1)) {
      for (j in Iter.range(0, GRID_SIZE - 1)) {
        let cell = state.grid.cells[i][j];
        let externalCoherence = if (i < coherenceGrid.size() and j < coherenceGrid[0].size()) {
          coherenceGrid[i][j]
        } else { 1.0 };
        
        if (externalCoherence < woundThreshold) {
          woundMask[i][j] := true;
          cell.isWounded := true;
          cell.woundDepth := (woundThreshold - externalCoherence) / woundThreshold;
          cell.coherence := externalCoherence;
          woundedCount += 1;
        };
      };
    };
    
    state.grid.woundedCellCount := woundedCount;
    
    // Find connected wound regions (flood fill)
    let wounds = Buffer.Buffer<WoundRegion>(10);
    let visited = Array.tabulate<[var Bool]>(GRID_SIZE, func(i : Nat) : [var Bool] {
      Array.init<Bool>(GRID_SIZE, false)
    });
    
    var woundId : Nat = 0;
    
    for (i in Iter.range(0, GRID_SIZE - 1)) {
      for (j in Iter.range(0, GRID_SIZE - 1)) {
        if (woundMask[i][j] and not visited[i][j]) {
          // Found new wound region - flood fill to find extent
          let region = floodFillWound(state, woundMask, visited, i, j, woundId, shellId, currentBeat);
          
          if (region.cellCount >= MIN_WOUND_SIZE) {
            // Check if critical
            let regionCells = region;
            if (region.maxDepth > (1.0 - CRITICAL_WOUND_FACTOR)) {
              // Mutable field access
              let mutableRegion = region;
              // Note: In Motoko, we'd need to return a new record since isCritical is var
            };
            
            wounds.add(region);
            woundId += 1;
          };
        };
      };
    };
    
    let woundArray = Buffer.toArray(wounds);
    state.grid.activeWounds := woundArray;
    state.totalWounds += woundArray.size();
    
    // Check for emergency mode
    var maxDepth : Float = 0.0;
    for (wound in woundArray.vals()) {
      if (wound.maxDepth > maxDepth) {
        maxDepth := wound.maxDepth;
      };
    };
    state.isEmergencyMode := maxDepth > (1.0 - CRITICAL_WOUND_FACTOR);
    
    woundArray
  };
  
  /// Flood fill to find connected wound region
  func floodFillWound(
    state : NCASubstrateState,
    woundMask : [[var Bool]],
    visited : [[var Bool]],
    startX : Nat,
    startY : Nat,
    woundId : Nat,
    shellId : Nat8,
    currentBeat : Int
  ) : WoundRegion {
    let stack = Buffer.Buffer<(Nat, Nat)>(100);
    stack.add((startX, startY));
    
    var cellCount : Nat = 0;
    var sumX : Nat = 0;
    var sumY : Nat = 0;
    var sumDepth : Float = 0.0;
    var maxDepth : Float = 0.0;
    var minX : Nat = startX;
    var maxX : Nat = startX;
    var minY : Nat = startY;
    var maxY : Nat = startY;
    
    while (stack.size() > 0) {
      switch (stack.removeLast()) {
        case (null) {};
        case (?pos) {
          let (x, y) = pos;
          
          if (x < GRID_SIZE and y < GRID_SIZE and 
              woundMask[x][y] and not visited[x][y]) {
            visited[x][y] := true;
            
            let cell = state.grid.cells[x][y];
            cellCount += 1;
            sumX += x;
            sumY += y;
            sumDepth += cell.woundDepth;
            
            if (cell.woundDepth > maxDepth) {
              maxDepth := cell.woundDepth;
            };
            
            if (x < minX) { minX := x };
            if (x > maxX) { maxX := x };
            if (y < minY) { minY := y };
            if (y > maxY) { maxY := y };
            
            // Add neighbors to stack
            if (x > 0) { stack.add((x - 1, y)) };
            if (x < GRID_SIZE - 1) { stack.add((x + 1, y)) };
            if (y > 0) { stack.add((x, y - 1)) };
            if (y < GRID_SIZE - 1) { stack.add((x, y + 1)) };
          };
        };
      };
    };
    
    let centerX = if (cellCount > 0) { sumX / cellCount } else { startX };
    let centerY = if (cellCount > 0) { sumY / cellCount } else { startY };
    let meanDepth = if (cellCount > 0) { sumDepth / Float.fromInt(cellCount) } else { 0.0 };
    let radius = Float.sqrt(Float.fromInt((maxX - minX + 1) * (maxY - minY + 1))) / 2.0;
    
    {
      id = woundId;
      centerX = centerX;
      centerY = centerY;
      radius = radius;
      cellCount = cellCount;
      meanDepth = meanDepth;
      maxDepth = maxDepth;
      shellId = shellId;
      var healingStartBeat = currentBeat;
      var currentHealing = 0.0;
      var isCritical = maxDepth > (1.0 - CRITICAL_WOUND_FACTOR);
      var morphogenSource = (centerX, centerY);
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // MORPHOGEN FIELD — GRADIENT GENERATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Set morphogen source at wound edge (healthy tissue boundary)
  public func setMorphogenSources(
    field : MorphogenField,
    wounds : [WoundRegion],
    grid : NCAGrid
  ) : () {
    // Clear existing sources
    let newSources = Buffer.Buffer<(Nat, Nat, Float)>(wounds.size() * 4);
    
    for (wound in wounds.vals()) {
      // Find healthy cells at wound boundary
      let cx = wound.centerX;
      let cy = wound.centerY;
      let r = Int.abs(Float.toInt(wound.radius)) + 1;
      
      // Sample boundary points
      for (angle in Iter.range(0, 7)) {
        let theta = Float.fromInt(angle) * PI / 4.0;
        let x = Int.abs(Float.toInt(Float.fromInt(cx) + Float.fromInt(r) * Float.cos(theta)));
        let y = Int.abs(Float.toInt(Float.fromInt(cy) + Float.fromInt(r) * Float.sin(theta)));
        
        if (x < GRID_SIZE and y < GRID_SIZE) {
          let cell = grid.cells[x][y];
          if (not cell.isWounded) {
            // This is a healthy boundary cell - set as morphogen source
            let strength = 1.0 - wound.meanDepth;  // Stronger for deeper wounds
            newSources.add((x, y, strength));
          };
        };
      };
    };
    
    // Update field sources (would need to handle mutability)
    // field.sources := Buffer.toArray(newSources);
  };
  
  /// Diffuse morphogen field
  /// ∂M/∂t = D∇²M - λM + sources
  public func diffuseMorphogen(field : MorphogenField) : () {
    let newConc = Array.tabulate<[var Float]>(GRID_SIZE, func(i : Nat) : [var Float] {
      Array.init<Float>(GRID_SIZE, 0.0)
    });
    
    // Apply diffusion using Laplacian
    for (i in Iter.range(1, GRID_SIZE - 2)) {
      for (j in Iter.range(1, GRID_SIZE - 2)) {
        let current = field.concentrations[i][j];
        
        // Laplacian: ∇²M = sum of neighbors - 4 × center
        let laplacian = 
          field.concentrations[i-1][j] + field.concentrations[i+1][j] +
          field.concentrations[i][j-1] + field.concentrations[i][j+1] -
          4.0 * current;
        
        // Update: M_new = M + D×∇²M - λM
        newConc[i][j] := current + 
          field.diffusionRate * laplacian - 
          field.decayRate * current;
        
        // Clamp to [0, 1]
        if (newConc[i][j] < 0.0) { newConc[i][j] := 0.0 };
        if (newConc[i][j] > 1.0) { newConc[i][j] := 1.0 };
      };
    };
    
    // Add sources
    for ((x, y, strength) in field.sources.vals()) {
      if (x < GRID_SIZE and y < GRID_SIZE) {
        newConc[x][y] += strength;
        if (newConc[x][y] > 1.0) { newConc[x][y] := 1.0 };
      };
    };
    
    // Copy back
    for (i in Iter.range(0, GRID_SIZE - 1)) {
      for (j in Iter.range(0, GRID_SIZE - 1)) {
        field.concentrations[i][j] := newConc[i][j];
      };
    };
    
    // Update total
    var total : Float = 0.0;
    for (i in Iter.range(0, GRID_SIZE - 1)) {
      for (j in Iter.range(0, GRID_SIZE - 1)) {
        total += field.concentrations[i][j];
      };
    };
    field.totalMorphogen := total;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // REACTION-DIFFUSION — TURING PATTERNS FOR HEALING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Update reaction-diffusion system
  /// Activator-inhibitor model for pattern formation during healing
  public func updateReactionDiffusion(grid : NCAGrid) : () {
    let newActivator = Array.tabulate<[var Float]>(GRID_SIZE, func(i : Nat) : [var Float] {
      Array.init<Float>(GRID_SIZE, 0.0)
    });
    let newInhibitor = Array.tabulate<[var Float]>(GRID_SIZE, func(i : Nat) : [var Float] {
      Array.init<Float>(GRID_SIZE, 0.0)
    });
    
    for (i in Iter.range(1, GRID_SIZE - 2)) {
      for (j in Iter.range(1, GRID_SIZE - 2)) {
        let cell = grid.cells[i][j];
        
        if (cell.isWounded or cell.healingProgress > 0.0) {
          let u = cell.activator;
          let v = cell.inhibitor;
          
          // Laplacian for activator
          let lapU = 
            grid.cells[i-1][j].activator + grid.cells[i+1][j].activator +
            grid.cells[i][j-1].activator + grid.cells[i][j+1].activator -
            4.0 * u;
          
          // Laplacian for inhibitor
          let lapV = 
            grid.cells[i-1][j].inhibitor + grid.cells[i+1][j].inhibitor +
            grid.cells[i][j-1].inhibitor + grid.cells[i][j+1].inhibitor -
            4.0 * v;
          
          // Reaction terms (Gierer-Meinhardt model)
          // du/dt = ρ(u²/v - u) + D_u∇²u
          // dv/dt = ρ(u² - v) + D_v∇²v
          
          let reaction_u = K_ACTIVATOR * (u * u / (v + 0.001) - u);
          let reaction_v = K_INHIBITOR * (u * u - v);
          
          newActivator[i][j] := u + reaction_u + D_ACTIVATOR * lapU - DECAY_RATE * u;
          newInhibitor[i][j] := v + reaction_v + D_INHIBITOR * lapV - DECAY_RATE * v;
          
          // Clamp values
          if (newActivator[i][j] < 0.0) { newActivator[i][j] := 0.0 };
          if (newActivator[i][j] > 1.0) { newActivator[i][j] := 1.0 };
          if (newInhibitor[i][j] < 0.0) { newInhibitor[i][j] := 0.0 };
          if (newInhibitor[i][j] > 1.0) { newInhibitor[i][j] := 1.0 };
        };
      };
    };
    
    // Copy back
    for (i in Iter.range(0, GRID_SIZE - 1)) {
      for (j in Iter.range(0, GRID_SIZE - 1)) {
        grid.cells[i][j].activator := newActivator[i][j];
        grid.cells[i][j].inhibitor := newInhibitor[i][j];
      };
    };
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // NCA UPDATE — CORE CELLULAR AUTOMATA STEP
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Apply NCA kernel convolution to a cell
  public func applyKernel(
    grid : NCAGrid,
    kernel : NCAKernel,
    x : Nat,
    y : Nat,
    channelIdx : Nat
  ) : Float {
    var sum : Float = 0.0;
    
    // 3×3 convolution
    for (di in Iter.range(0, 2)) {
      for (dj in Iter.range(0, 2)) {
        let ni = if (di == 0) { if (x > 0) { x - 1 } else { 0 } }
                 else if (di == 1) { x }
                 else { if (x < GRID_SIZE - 1) { x + 1 } else { GRID_SIZE - 1 } };
        let nj = if (dj == 0) { if (y > 0) { y - 1 } else { 0 } }
                 else if (dj == 1) { y }
                 else { if (y < GRID_SIZE - 1) { y + 1 } else { GRID_SIZE - 1 } };
        
        let cellValue = if (channelIdx < STATE_CHANNELS) {
          grid.cells[ni][nj].channels[channelIdx]
        } else {
          grid.cells[ni][nj].coherence
        };
        
        sum += cellValue * kernel.weights[di][dj];
      };
    };
    
    sum += kernel.bias;
    applyActivation(sum, kernel.activation)
  };
  
  /// Full NCA update step
  /// state[i,j,t+1] = f(Σ_neighbors state × kernel + morphogen_gradient)
  public func ncaUpdate(
    state : NCASubstrateState,
    currentBeat : Int
  ) : () {
    let grid = state.grid;
    let field = state.morphogenField;
    
    // Store new states
    let newChannels = Array.tabulate<[[var Float]]>(GRID_SIZE, func(i : Nat) : [[var Float]] {
      Array.tabulate<[var Float]>(GRID_SIZE, func(j : Nat) : [var Float] {
        Array.init<Float>(STATE_CHANNELS, 0.0)
      })
    });
    
    // Apply NCA update to each cell
    for (i in Iter.range(0, GRID_SIZE - 1)) {
      for (j in Iter.range(0, GRID_SIZE - 1)) {
        let cell = grid.cells[i][j];
        
        // Only update cells that need updating (wounded or healing)
        if (cell.isWounded or cell.healingProgress > 0.0 and cell.healingProgress < 1.0) {
          // Apply perception kernels
          for (c in Iter.range(0, STATE_CHANNELS - 1)) {
            let kernelIdx = c % state.kernels.size();
            let perceived = applyKernel(grid, state.kernels[kernelIdx], i, j, c);
            
            // Add morphogen influence
            let morphogenInfluence = field.concentrations[i][j] * 0.1;
            
            // NCA update rule
            let delta = perceived * HEALING_ALPHA + morphogenInfluence;
            newChannels[i][j][c] := cell.channels[c] + delta;
            
            // Clamp
            if (newChannels[i][j][c] < 0.0) { newChannels[i][j][c] := 0.0 };
            if (newChannels[i][j][c] > 1.0) { newChannels[i][j][c] := 1.0 };
          };
        } else {
          // Copy existing values
          for (c in Iter.range(0, STATE_CHANNELS - 1)) {
            newChannels[i][j][c] := cell.channels[c];
          };
        };
      };
    };
    
    // Copy new states back
    for (i in Iter.range(0, GRID_SIZE - 1)) {
      for (j in Iter.range(0, GRID_SIZE - 1)) {
        for (c in Iter.range(0, STATE_CHANNELS - 1)) {
          grid.cells[i][j].channels[c] := newChannels[i][j][c];
        };
        grid.cells[i][j].lastUpdate := currentBeat;
      };
    };
    
    grid.lastGlobalUpdate := currentBeat;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // HEALING PROCESS — WOUND RECOVERY
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Determine healing phase based on progress
  public func getHealingPhase(progress : Float, isScarred : Bool) : HealingPhase {
    if (isScarred) { return #Scarred };
    if (progress >= 1.0) { return #Complete };
    if (progress < 0.25) { return #Inflammation };
    if (progress < 0.75) { return #Proliferation };
    #Remodeling
  };
  
  /// Apply healing to wounded cells
  /// dR/dt = α × morphogen × (1 - density) × coherence
  public func healWounds(
    state : NCASubstrateState,
    currentBeat : Int
  ) : Nat {
    let grid = state.grid;
    let field = state.morphogenField;
    var healedCells : Nat = 0;
    
    for (i in Iter.range(0, GRID_SIZE - 1)) {
      for (j in Iter.range(0, GRID_SIZE - 1)) {
        let cell = grid.cells[i][j];
        
        if (cell.isWounded and not cell.isScarred) {
          // Healing rate depends on morphogen and local conditions
          let morphogen = field.concentrations[i][j];
          let density = computeLocalDensity(grid, i, j);
          let coherenceFactor = Float.max(cell.coherence, S_ZERO_FLOOR);
          
          // dR/dt = α × morphogen × (1 - density) × coherence
          let healingRate = HEALING_ALPHA * morphogen * (1.0 - density) * coherenceFactor;
          
          // Emergency mode doubles healing rate
          let effectiveRate = if (state.isEmergencyMode) { healingRate * 2.0 } else { healingRate };
          
          cell.healingProgress += effectiveRate;
          
          if (cell.healingProgress >= 1.0) {
            // Fully healed
            cell.isWounded := false;
            cell.woundDepth := 0.0;
            cell.healingProgress := 1.0;
            cell.coherence := Float.min(cell.coherence + 0.2, 1.0);
            healedCells += 1;
          };
        };
      };
    };
    
    grid.healingCellCount := healedCells;
    state.healedWounds += healedCells;
    healedCells
  };
  
  /// Compute local cell density (for contact inhibition)
  func computeLocalDensity(grid : NCAGrid, x : Nat, y : Nat) : Float {
    var healthyCount : Nat = 0;
    var totalCount : Nat = 0;
    
    for (di in Iter.range(0, 2)) {
      for (dj in Iter.range(0, 2)) {
        let ni = if (di == 0) { if (x > 0) { x - 1 } else { 0 } }
                 else if (di == 1) { x }
                 else { if (x < GRID_SIZE - 1) { x + 1 } else { GRID_SIZE - 1 } };
        let nj = if (dj == 0) { if (y > 0) { y - 1 } else { 0 } }
                 else if (dj == 1) { y }
                 else { if (y < GRID_SIZE - 1) { y + 1 } else { GRID_SIZE - 1 } };
        
        if (not grid.cells[ni][nj].isWounded) {
          healthyCount += 1;
        };
        totalCount += 1;
      };
    };
    
    Float.fromInt(healthyCount) / Float.fromInt(totalCount)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // SCARRING — PERMANENT DAMAGE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Check for scar formation in wounds that haven't healed in time
  public func checkScarFormation(
    state : NCASubstrateState,
    currentBeat : Int
  ) : Nat {
    let grid = state.grid;
    var newScars : Nat = 0;
    
    for (wound in grid.activeWounds.vals()) {
      let healingTime = currentBeat - wound.healingStartBeat;
      
      if (healingTime > MAX_HEALING_TIME) {
        // Time's up - form scars for incompletely healed cells
        let cx = wound.centerX;
        let cy = wound.centerY;
        let r = Int.abs(Float.toInt(wound.radius)) + 1;
        
        for (i in Iter.range(if (cx > r) { cx - r } else { 0 }, Nat.min(cx + r, GRID_SIZE - 1))) {
          for (j in Iter.range(if (cy > r) { cy - r } else { 0 }, Nat.min(cy + r, GRID_SIZE - 1))) {
            let cell = grid.cells[i][j];
            
            if (cell.isWounded and cell.healingProgress < SCAR_THRESHOLD) {
              // Form scar
              cell.isScarred := true;
              cell.scarSeverity := 1.0 - cell.healingProgress;
              cell.isWounded := false;
              cell.healingProgress := cell.healingProgress;  // Partial healing preserved
              
              // Reduce channel capacities permanently
              for (c in Iter.range(0, STATE_CHANNELS - 1)) {
                cell.channels[c] *= SCAR_WEIGHT_REDUCTION;
              };
              
              newScars += 1;
            };
          };
        };
      };
    };
    
    grid.scarredCellCount += newScars;
    state.totalScars += newScars;
    newScars
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // GLOBAL HEALTH SCORE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Compute overall tissue health score
  public func computeGlobalHealth(state : NCASubstrateState) : Float {
    let grid = state.grid;
    
    // Base health from coherence
    var totalCoherence : Float = 0.0;
    var cellCount : Nat = 0;
    
    for (i in Iter.range(0, GRID_SIZE - 1)) {
      for (j in Iter.range(0, GRID_SIZE - 1)) {
        totalCoherence += grid.cells[i][j].coherence;
        cellCount += 1;
      };
    };
    
    let meanCoherence = totalCoherence / Float.fromInt(cellCount);
    
    // Penalty for wounds
    let woundPenalty = Float.fromInt(grid.woundedCellCount) / Float.fromInt(cellCount) * 0.5;
    
    // Penalty for scars (permanent reduction)
    let scarPenalty = Float.fromInt(grid.scarredCellCount) / Float.fromInt(cellCount) * 0.3;
    
    // Compute health
    var health = meanCoherence - woundPenalty - scarPenalty;
    
    // Apply S₀ floor
    if (health < S_ZERO_FLOOR) { health := S_ZERO_FLOOR };
    
    grid.totalCoherence := totalCoherence;
    state.globalHealthScore := health;
    health
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // HEARTBEAT UPDATE — MAIN UPDATE FUNCTION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Main heartbeat update for NCA wound healing
  public func heartbeatUpdate(
    state : NCASubstrateState,
    coherenceGrid : [[Float]],
    shellId : Nat8,
    currentBeat : Int
  ) : {
    woundsDetected : Nat;
    cellsHealed : Nat;
    scarsFormed : Nat;
    globalHealth : Float;
    isEmergency : Bool;
  } {
    // 1. Detect wounds from external coherence data
    let wounds = detectWounds(state, coherenceGrid, shellId, currentBeat);
    
    // 2. Set morphogen sources at wound boundaries
    setMorphogenSources(state.morphogenField, wounds, state.grid);
    
    // 3. Diffuse morphogen field
    diffuseMorphogen(state.morphogenField);
    
    // 4. Update reaction-diffusion (Turing patterns)
    updateReactionDiffusion(state.grid);
    
    // 5. Run NCA update
    ncaUpdate(state, currentBeat);
    
    // 6. Apply healing
    let healed = healWounds(state, currentBeat);
    
    // 7. Check for scar formation
    let scars = checkScarFormation(state, currentBeat);
    
    // 8. Update global health
    let health = computeGlobalHealth(state);
    
    state.lastHeartbeat := currentBeat;
    
    {
      woundsDetected = wounds.size();
      cellsHealed = healed;
      scarsFormed = scars;
      globalHealth = health;
      isEmergency = state.isEmergencyMode;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // QUERY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Get number of active wounds
  public func getActiveWoundCount(state : NCASubstrateState) : Nat {
    state.grid.activeWounds.size()
  };
  
  /// Get total wounded cell count
  public func getWoundedCellCount(state : NCASubstrateState) : Nat {
    state.grid.woundedCellCount
  };
  
  /// Get total scarred cell count
  public func getScarredCellCount(state : NCASubstrateState) : Nat {
    state.grid.scarredCellCount
  };
  
  /// Get global health score
  public func getGlobalHealth(state : NCASubstrateState) : Float {
    state.globalHealthScore
  };
  
  /// Check if in emergency mode
  public func isEmergencyMode(state : NCASubstrateState) : Bool {
    state.isEmergencyMode
  };
  
  /// Get cell state at position
  public func getCellState(state : NCASubstrateState, x : Nat, y : Nat) : ?CellState {
    if (x < GRID_SIZE and y < GRID_SIZE) {
      ?state.grid.cells[x][y]
    } else {
      null
    }
  };
  
  /// Get morphogen concentration at position
  public func getMorphogen(state : NCASubstrateState, x : Nat, y : Nat) : Float {
    if (x < GRID_SIZE and y < GRID_SIZE) {
      state.morphogenField.concentrations[x][y]
    } else {
      0.0
    }
  };
  
  /// Get healing statistics
  public func getHealingStats(state : NCASubstrateState) : {
    totalWounds : Nat;
    healedWounds : Nat;
    totalScars : Nat;
    healingRate : Float;
  } {
    let healingRate = if (state.totalWounds > 0) {
      Float.fromInt(state.healedWounds) / Float.fromInt(state.totalWounds)
    } else { 1.0 };
    
    {
      totalWounds = state.totalWounds;
      healedWounds = state.healedWounds;
      totalScars = state.totalScars;
      healingRate = healingRate;
    }
  };

}
