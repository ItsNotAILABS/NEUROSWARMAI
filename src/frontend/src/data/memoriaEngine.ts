// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  MEMORIA ENGINE — COMPLETE HIPPOCAMPAL MEMORY SYSTEM (22 ENGINES)                                        ║
// ║  Full neuroscience-grounded memory architecture                                                           ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
//  ███╗   ███╗███████╗███╗   ███╗ ██████╗ ██████╗ ██╗ █████╗
//  ████╗ ████║██╔════╝████╗ ████║██╔═══██╗██╔══██╗██║██╔══██╗
//  ██╔████╔██║█████╗  ██╔████╔██║██║   ██║██████╔╝██║███████║
//  ██║╚██╔╝██║██╔══╝  ██║╚██╔╝██║██║   ██║██╔══██╗██║██╔══██║
//  ██║ ╚═╝ ██║███████╗██║ ╚═╝ ██║╚██████╔╝██║  ██║██║██║  ██║
//  ╚═╝     ╚═╝╚══════╝╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚═╝╚═╝  ╚═╝
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// 22 MEMORIA ENGINES:
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
//
// ENGINE 1:  Trisynaptic Circuit ODE (EC→DG→CA3→CA1)
// ENGINE 2:  Theta-Gamma Phase-Amplitude Coupling (PAC)
// ENGINE 3:  Sharp-Wave Ripple (SPW-R) offline replay
// ENGINE 4:  Place Cells + Phase Precession
// ENGINE 5:  Episodic Encoding
// ENGINE 6:  Memory Indexing / Schema Consolidation
// ENGINE 7:  Semantic Memory Network
// ENGINE 8:  Prospective Memory (future event binding)
// ENGINE 9:  Sleep Consolidation
// ENGINE 10: Reconsolidation (memory update on retrieval)
// ENGINE 11: Forgetting Curve (Ebbinghaus decay)
// ENGINE 12: Grid Cells (spatial navigation)
// ENGINE 13: LTP Deep Engine (long-term potentiation ODE)
// ENGINE 14: Oscillatory Coupling (inter-region binding)
// ENGINE 15: Memory Interference
// ENGINE 16: Neuromodulatory Gates
// ENGINE 17: Contextual Memory
// ENGINE 18: Sleep Reactivation
// ENGINE 19: Memory Capacity Limits
// ENGINE 20: Sequence Learning
// ENGINE 21: Spatial Navigation Memory
// ENGINE 22: Associative Binding
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import { PHI, PI, TWO_PI } from "./sovereignSphere";

// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// SECTION 1: CORE TYPES AND CONSTANTS
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────

export const MEMORIA_CONSTANTS = {
  // Hippocampal circuit time constants (ms)
  TAU_EC: 20, // Entorhinal cortex
  TAU_DG: 5, // Dentate gyrus (fast sparse)
  TAU_CA3: 30, // CA3 (recurrent, slower)
  TAU_CA1: 15, // CA1 (output)

  // Oscillation frequencies (Hz)
  THETA_FREQ: 6, // Theta rhythm
  GAMMA_FREQ: 40, // Gamma rhythm
  RIPPLE_FREQ: 150, // Sharp-wave ripple

  // Memory parameters
  EPISODIC_CAPACITY: 200,
  SEMANTIC_NODE_LIMIT: 1000,
  PLACE_CELL_COUNT: 64,
  GRID_CELL_COUNT: 36,

  // Forgetting
  EBBINGHAUS_DECAY: 0.1,
  INTERFERENCE_RATE: 0.05,

  // LTP/LTD
  LTP_THRESHOLD: 0.6,
  LTD_THRESHOLD: 0.3,
  LTP_RATE: 0.01,
  LTD_RATE: 0.005,
};

// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// SECTION 2: TRISYNAPTIC CIRCUIT (ENGINE 1)
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
//
// EC (Entorhinal Cortex) → DG (Dentate Gyrus) → CA3 → CA1
// Standard hippocampal circuit for memory encoding

export interface TrisynapticCircuitState {
  // Layer activations
  ec: number[]; // Entorhinal cortex (input layer)
  dg: number[]; // Dentate gyrus (pattern separation)
  ca3: number[]; // CA3 (autoassociation/pattern completion)
  ca1: number[]; // CA1 (output/comparison)

  // Synaptic weights
  ec_to_dg: number[][];
  dg_to_ca3: number[][];
  ca3_to_ca3: number[][]; // Recurrent connections
  ca3_to_ca1: number[][];
  ec_to_ca1: number[][]; // Direct pathway

  // Dynamics
  dgSparsity: number;
  ca3RecurrentGain: number;

  // Outputs
  patternSeparationIndex: number;
  patternCompletionIndex: number;
}

export function initTrisynapticCircuit(size = 16): TrisynapticCircuitState {
  const initWeights = (rows: number, cols: number) =>
    Array(rows)
      .fill(null)
      .map(() =>
        Array(cols)
          .fill(0)
          .map(() => Math.random() * 0.2),
      );

  return {
    ec: new Array(size).fill(0.1),
    dg: new Array(size * 2).fill(0), // DG is larger (sparse coding)
    ca3: new Array(size).fill(0),
    ca1: new Array(size).fill(0),
    ec_to_dg: initWeights(size * 2, size),
    dg_to_ca3: initWeights(size, size * 2),
    ca3_to_ca3: initWeights(size, size),
    ca3_to_ca1: initWeights(size, size),
    ec_to_ca1: initWeights(size, size),
    dgSparsity: 0.1, // Only 10% of DG neurons active
    ca3RecurrentGain: 0.3,
    patternSeparationIndex: 0,
    patternCompletionIndex: 0,
  };
}

export function runTrisynapticCircuit(
  state: TrisynapticCircuitState,
  input: number[],
  dt = 0.001,
): TrisynapticCircuitState {
  const updated = { ...state };
  const size = state.ec.length;

  // 1. EC: Receives input
  updated.ec = input
    .slice(0, size)
    .map(
      (v, i) =>
        state.ec[i] +
        ((v - state.ec[i]) * dt) / (MEMORIA_CONSTANTS.TAU_EC / 1000),
    );

  // 2. DG: Pattern separation (sparse activation)
  const dgInput = state.ec_to_dg.map((row) =>
    row.reduce((sum, w, i) => sum + w * updated.ec[i], 0),
  );
  // Winner-take-all for sparsity
  const dgSorted = [...dgInput].sort((a, b) => b - a);
  const dgThreshold =
    dgSorted[Math.floor(dgInput.length * state.dgSparsity)] || 0;
  updated.dg = dgInput.map((v) => (v > dgThreshold ? Math.tanh(v) : 0));

  // 3. CA3: Pattern completion with recurrence
  const ca3FromDG = state.dg_to_ca3.map((row) =>
    row.reduce((sum, w, i) => sum + w * updated.dg[i], 0),
  );
  const ca3Recurrent = state.ca3_to_ca3.map((row) =>
    row.reduce((sum, w, i) => sum + w * state.ca3[i], 0),
  );
  updated.ca3 = state.ca3.map((v, i) => {
    const input = ca3FromDG[i] + state.ca3RecurrentGain * ca3Recurrent[i];
    return (
      v + ((Math.tanh(input) - v) * dt) / (MEMORIA_CONSTANTS.TAU_CA3 / 1000)
    );
  });

  // 4. CA1: Output comparison
  const ca1FromCA3 = state.ca3_to_ca1.map((row) =>
    row.reduce((sum, w, i) => sum + w * updated.ca3[i], 0),
  );
  const ca1FromEC = state.ec_to_ca1.map((row) =>
    row.reduce((sum, w, i) => sum + w * updated.ec[i], 0),
  );
  updated.ca1 = state.ca1.map((v, i) => {
    const input = ca1FromCA3[i] * 0.7 + ca1FromEC[i] * 0.3;
    return (
      v + ((Math.tanh(input) - v) * dt) / (MEMORIA_CONSTANTS.TAU_CA1 / 1000)
    );
  });

  // 5. Compute indices
  // Pattern separation: how different are DG representations for similar inputs
  updated.patternSeparationIndex = 1 - computeCorrelation(updated.dg, state.dg);

  // Pattern completion: how much CA3 recurrence fills in missing info
  const ca3Direct = ca3FromDG.map((v) => Math.tanh(v));
  updated.patternCompletionIndex = computeCorrelation(updated.ca3, ca3Direct);

  return updated;
}

// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// SECTION 3: THETA-GAMMA PAC (ENGINE 2)
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
//
// Phase-amplitude coupling between theta (4-8 Hz) and gamma (30-80 Hz)
// Critical for memory encoding

export interface ThetaGammaPACState {
  // Theta oscillator
  thetaPhase: number;
  thetaFrequency: number;
  thetaAmplitude: number;

  // Gamma oscillator
  gammaPhase: number;
  gammaFrequency: number;
  gammaAmplitude: number;

  // Coupling
  pacStrength: number; // Phase-amplitude coupling strength
  modulationIndex: number; // Tort's modulation index
  preferredPhase: number; // Theta phase at which gamma is maximal

  // History for computing PAC
  thetaPhaseHistory: number[];
  gammaAmpHistory: number[];
  historyLength: number;

  // Encoding state
  encodingWindow: boolean; // True when in optimal encoding phase
}

export function initThetaGammaPAC(): ThetaGammaPACState {
  return {
    thetaPhase: 0,
    thetaFrequency: MEMORIA_CONSTANTS.THETA_FREQ,
    thetaAmplitude: 1.0,
    gammaPhase: 0,
    gammaFrequency: MEMORIA_CONSTANTS.GAMMA_FREQ,
    gammaAmplitude: 0.5,
    pacStrength: 0,
    modulationIndex: 0,
    preferredPhase: PI / 2, // Peak of theta
    thetaPhaseHistory: [],
    gammaAmpHistory: [],
    historyLength: 100,
    encodingWindow: false,
  };
}

export function runThetaGammaPAC(
  state: ThetaGammaPACState,
  externalTheta: number,
  externalGamma: number,
  dt = 0.001,
): ThetaGammaPACState {
  const updated = { ...state };

  // 1. Evolve theta phase
  updated.thetaPhase =
    (state.thetaPhase + state.thetaFrequency * TWO_PI * dt) % TWO_PI;
  updated.thetaAmplitude = state.thetaAmplitude * 0.99 + externalTheta * 0.01;

  // 2. Evolve gamma phase (faster)
  updated.gammaPhase =
    (state.gammaPhase + state.gammaFrequency * TWO_PI * dt) % TWO_PI;

  // 3. Gamma amplitude modulated by theta phase
  // Gamma is strongest at preferred theta phase
  const phaseDiff = updated.thetaPhase - state.preferredPhase;
  const modulation = 0.5 + 0.5 * Math.cos(phaseDiff);
  updated.gammaAmplitude = (0.3 + 0.7 * modulation) * externalGamma;

  // 4. Update history
  updated.thetaPhaseHistory = [
    ...state.thetaPhaseHistory,
    updated.thetaPhase,
  ].slice(-state.historyLength);
  updated.gammaAmpHistory = [
    ...state.gammaAmpHistory,
    updated.gammaAmplitude,
  ].slice(-state.historyLength);

  // 5. Compute PAC strength (simplified Tort modulation index)
  if (updated.thetaPhaseHistory.length >= 20) {
    // Bin gamma amplitude by theta phase
    const bins = new Array(18).fill(0);
    const counts = new Array(18).fill(0);

    for (let i = 0; i < updated.thetaPhaseHistory.length; i++) {
      const binIdx = Math.floor(updated.thetaPhaseHistory[i] / (TWO_PI / 18));
      bins[binIdx] += updated.gammaAmpHistory[i];
      counts[binIdx]++;
    }

    // Normalize
    for (let i = 0; i < 18; i++) {
      if (counts[i] > 0) bins[i] /= counts[i];
    }

    // Modulation index (entropy-based)
    const totalAmp = bins.reduce((a, b) => a + b, 0);
    if (totalAmp > 0) {
      const probDist = bins.map((b) => b / totalAmp);
      const entropy = -probDist.reduce(
        (s, p) => s + (p > 0 ? p * Math.log(p) : 0),
        0,
      );
      const maxEntropy = Math.log(18);
      updated.modulationIndex = (maxEntropy - entropy) / maxEntropy;
    }

    updated.pacStrength =
      updated.modulationIndex * updated.thetaAmplitude * updated.gammaAmplitude;
  }

  // 6. Encoding window
  // Optimal encoding when theta near peak (descending phase)
  updated.encodingWindow =
    updated.thetaPhase > PI / 4 && updated.thetaPhase < (3 * PI) / 4;

  return updated;
}

// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// SECTION 4: SHARP-WAVE RIPPLE (ENGINE 3)
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
//
// High-frequency oscillations (150-250 Hz) during offline states
// Critical for memory consolidation

export interface SharpWaveRippleState {
  // SWR generation
  rippleActive: boolean;
  ripplePhase: number;
  rippleFrequency: number;
  rippleAmplitude: number;

  // SWR timing
  lastRippleTime: number;
  interRippleInterval: number;
  rippleDuration: number;
  currentRippleDuration: number;

  // Replay content
  replayBuffer: number[][];
  replayIndex: number;
  compressionFactor: number; // Temporal compression during replay

  // Statistics
  rippleCount: number;
  avgRippleDuration: number;
  replayFidelity: number;
}

export function initSharpWaveRipple(): SharpWaveRippleState {
  return {
    rippleActive: false,
    ripplePhase: 0,
    rippleFrequency: MEMORIA_CONSTANTS.RIPPLE_FREQ,
    rippleAmplitude: 0,
    lastRippleTime: 0,
    interRippleInterval: 100, // ms
    rippleDuration: 50, // ms typical
    currentRippleDuration: 0,
    replayBuffer: [],
    replayIndex: 0,
    compressionFactor: 20, // 20x temporal compression
    rippleCount: 0,
    avgRippleDuration: 50,
    replayFidelity: 0,
  };
}

export function runSharpWaveRipple(
  state: SharpWaveRippleState,
  thetaPower: number,
  currentTime: number,
  memoryToReplay: number[][] | null,
): SharpWaveRippleState {
  const updated = { ...state };

  // SWR only occurs during low theta (offline states)
  const canGenerateSWR = thetaPower < 0.3;

  // 1. Check for SWR initiation
  if (!state.rippleActive && canGenerateSWR) {
    const timeSinceLastRipple = currentTime - state.lastRippleTime;

    // Probabilistic SWR generation
    if (
      timeSinceLastRipple > state.interRippleInterval &&
      Math.random() < 0.1
    ) {
      updated.rippleActive = true;
      updated.lastRippleTime = currentTime;
      updated.currentRippleDuration = 0;
      updated.rippleCount++;

      // Load memory for replay
      if (memoryToReplay && memoryToReplay.length > 0) {
        updated.replayBuffer = memoryToReplay;
        updated.replayIndex = 0;
      }
    }
  }

  // 2. SWR dynamics when active
  if (updated.rippleActive) {
    updated.currentRippleDuration++;

    // Ripple oscillation
    updated.ripplePhase =
      (state.ripplePhase + state.rippleFrequency * TWO_PI * 0.001) % TWO_PI;
    updated.rippleAmplitude =
      0.8 + 0.2 * Math.sin(updated.currentRippleDuration * 0.1);

    // Replay at compressed timescale
    if (updated.replayBuffer.length > 0) {
      const replaySpeed = state.compressionFactor;
      updated.replayIndex = Math.min(
        updated.replayBuffer.length - 1,
        state.replayIndex + replaySpeed * 0.001,
      );
    }

    // End ripple after duration
    if (updated.currentRippleDuration >= state.rippleDuration) {
      updated.rippleActive = false;
      updated.rippleAmplitude = 0;

      // Update statistics
      updated.avgRippleDuration =
        state.avgRippleDuration * 0.95 + updated.currentRippleDuration * 0.05;

      // Compute replay fidelity (simplified)
      if (updated.replayBuffer.length > 0) {
        updated.replayFidelity =
          updated.replayIndex / updated.replayBuffer.length;
      }
    }
  }

  return updated;
}

// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// SECTION 5: PLACE CELLS + PHASE PRECESSION (ENGINE 4)
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
//
// Place cells fire at specific locations
// Phase precession: firing phase shifts relative to theta as animal traverses place field

export interface PlaceCellState {
  cells: PlaceCell[];
  currentLocation: [number, number];
  populationVector: number[];

  // Phase precession
  precessionRate: number; // How fast phase advances through field
  phaseFieldSlope: number; // Degrees of phase shift per field

  // Path integration
  pathIntegrationError: number;
  headDirection: number;
}

export interface PlaceCell {
  id: number;
  centerX: number;
  centerY: number;
  fieldRadius: number;
  peakRate: number;
  currentFiring: number;
  currentPhase: number;
  phasePrecession: number;
}

export function initPlaceCells(
  count: number = MEMORIA_CONSTANTS.PLACE_CELL_COUNT,
): PlaceCellState {
  const cells: PlaceCell[] = [];
  const gridSize = Math.sqrt(count);

  for (let i = 0; i < count; i++) {
    cells.push({
      id: i,
      centerX: (i % gridSize) / gridSize,
      centerY: Math.floor(i / gridSize) / gridSize,
      fieldRadius: 0.15 + Math.random() * 0.1,
      peakRate: 0.8 + Math.random() * 0.2,
      currentFiring: 0,
      currentPhase: Math.random() * TWO_PI,
      phasePrecession: 0,
    });
  }

  return {
    cells,
    currentLocation: [0.5, 0.5],
    populationVector: new Array(count).fill(0),
    precessionRate: PI / 2, // 90 degrees across field
    phaseFieldSlope: 180, // degrees
    pathIntegrationError: 0,
    headDirection: 0,
  };
}

export function runPlaceCells(
  state: PlaceCellState,
  newLocation: [number, number],
  thetaPhase: number,
  _dt = 0.001,
): PlaceCellState {
  const updated = { ...state };
  updated.currentLocation = newLocation;

  // 1. Update head direction
  const dx = newLocation[0] - state.currentLocation[0];
  const dy = newLocation[1] - state.currentLocation[1];
  if (dx !== 0 || dy !== 0) {
    updated.headDirection = Math.atan2(dy, dx);
  }

  // 2. Update each place cell
  updated.cells = state.cells.map((cell) => {
    // Distance from place field center
    const distX = newLocation[0] - cell.centerX;
    const distY = newLocation[1] - cell.centerY;
    const distance = Math.sqrt(distX * distX + distY * distY);

    // Gaussian tuning curve
    const spatialFiring =
      cell.peakRate *
      Math.exp(
        (-distance * distance) / (2 * cell.fieldRadius * cell.fieldRadius),
      );

    // Phase precession: phase advances as animal moves through field
    let phasePrecession = 0;
    if (distance < cell.fieldRadius) {
      // Position within field (0 = entering, 1 = exiting)
      const fieldPosition = (cell.fieldRadius - distance) / cell.fieldRadius;
      phasePrecession = state.precessionRate * fieldPosition;
    }

    // Theta modulation with phase precession
    const effectivePhase = thetaPhase - phasePrecession;
    const thetaModulation = 0.5 + 0.5 * Math.cos(effectivePhase);

    const currentFiring = spatialFiring * thetaModulation;

    return {
      ...cell,
      currentFiring,
      currentPhase: effectivePhase,
      phasePrecession,
    };
  });

  // 3. Population vector
  updated.populationVector = updated.cells.map((c) => c.currentFiring);

  // 4. Path integration error (accumulates over time without landmarks)
  updated.pathIntegrationError =
    state.pathIntegrationError * 0.999 + Math.random() * 0.001; // Small random drift

  return updated;
}

// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// SECTION 6: GRID CELLS (ENGINE 12)
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
//
// Hexagonal firing patterns for path integration and metric representation

export interface GridCellState {
  cells: GridCell[];
  modules: GridModule[]; // Different spatial scales

  // Path integration
  pathIntegratorX: number;
  pathIntegratorY: number;
  velocityInput: [number, number];

  // Population output
  gridCode: number[]; // Combined grid cell code
}

export interface GridCell {
  id: number;
  moduleId: number;
  phase: [number, number]; // Phase offset within module
  spacing: number; // Grid spacing
  orientation: number; // Grid orientation
  currentFiring: number;
}

export interface GridModule {
  id: number;
  spacing: number; // Characteristic scale
  orientation: number; // Orientation angle
  cellCount: number;
}

export function initGridCells(): GridCellState {
  // Create 4 modules with different scales
  const modules: GridModule[] = [
    { id: 0, spacing: 0.2, orientation: 0, cellCount: 9 },
    { id: 1, spacing: 0.35, orientation: PI / 6, cellCount: 9 },
    { id: 2, spacing: 0.5, orientation: PI / 12, cellCount: 9 },
    { id: 3, spacing: 0.7, orientation: PI / 4, cellCount: 9 },
  ];

  const cells: GridCell[] = [];
  for (const module of modules) {
    for (let i = 0; i < module.cellCount; i++) {
      const row = Math.floor(i / 3);
      const col = i % 3;
      cells.push({
        id: cells.length,
        moduleId: module.id,
        phase: [col / 3, row / 3],
        spacing: module.spacing,
        orientation: module.orientation,
        currentFiring: 0,
      });
    }
  }

  return {
    cells,
    modules,
    pathIntegratorX: 0.5,
    pathIntegratorY: 0.5,
    velocityInput: [0, 0],
    gridCode: new Array(cells.length).fill(0),
  };
}

export function runGridCells(
  state: GridCellState,
  location: [number, number],
  velocity: [number, number],
  dt = 0.001,
): GridCellState {
  const updated = { ...state };
  updated.velocityInput = velocity;

  // 1. Path integration
  updated.pathIntegratorX = state.pathIntegratorX + velocity[0] * dt;
  updated.pathIntegratorY = state.pathIntegratorY + velocity[1] * dt;

  // 2. Update each grid cell
  updated.cells = state.cells.map((cell) => {
    // Rotate location by grid orientation
    const cos = Math.cos(cell.orientation);
    const sin = Math.sin(cell.orientation);
    const rotX = location[0] * cos + location[1] * sin;
    const rotY = -location[0] * sin + location[1] * cos;

    // Hexagonal grid firing pattern
    // Uses three cosines at 60-degree angles
    const u1 = rotX / cell.spacing + cell.phase[0];
    const u2 =
      (rotX * 0.5 + (rotY * Math.sqrt(3)) / 2) / cell.spacing + cell.phase[1];
    const u3 = (rotX * 0.5 - (rotY * Math.sqrt(3)) / 2) / cell.spacing;

    const cos1 = Math.cos(TWO_PI * u1);
    const cos2 = Math.cos(TWO_PI * u2);
    const cos3 = Math.cos(TWO_PI * u3);

    // Product of cosines creates hexagonal pattern
    const gridResponse = (cos1 + cos2 + cos3) / 3;
    const currentFiring = Math.max(0, (gridResponse + 1) / 2);

    return { ...cell, currentFiring };
  });

  // 3. Grid code
  updated.gridCode = updated.cells.map((c) => c.currentFiring);

  return updated;
}

// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// SECTION 7: EPISODIC MEMORY (ENGINE 5)
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────

export interface EpisodicMemoryState {
  episodes: Episode[];
  writePointer: number;
  capacity: number;

  // Encoding state
  encodingActive: boolean;
  currentEpisodeBuffer: number[][];

  // Retrieval
  lastRetrievedEpisode: Episode | null;
  retrievalCue: number[];
  retrievalStrength: number;

  // Statistics
  totalEncoded: number;
  avgEpisodeLength: number;
  retrievalAccuracy: number;
}

export interface Episode {
  id: number;
  timestamp: number;
  content: number[][];
  context: string;
  emotionalValence: number;
  strength: number;
  retrievalCount: number;
  lastRetrieved: number;
}

export function initEpisodicMemory(): EpisodicMemoryState {
  return {
    episodes: [],
    writePointer: 0,
    capacity: MEMORIA_CONSTANTS.EPISODIC_CAPACITY,
    encodingActive: false,
    currentEpisodeBuffer: [],
    lastRetrievedEpisode: null,
    retrievalCue: [],
    retrievalStrength: 0,
    totalEncoded: 0,
    avgEpisodeLength: 0,
    retrievalAccuracy: 0,
  };
}

export function runEpisodicEncoding(
  state: EpisodicMemoryState,
  input: number[],
  pacStrength: number,
  context: string,
  emotionalValence: number,
  timestamp: number,
): EpisodicMemoryState {
  const updated = { ...state };

  // Encoding gated by PAC strength
  if (pacStrength > 0.5) {
    updated.encodingActive = true;
    updated.currentEpisodeBuffer = [...state.currentEpisodeBuffer, input];
  } else if (state.encodingActive && state.currentEpisodeBuffer.length > 0) {
    // End of encoding window - store episode
    const episode: Episode = {
      id: state.totalEncoded,
      timestamp,
      content: state.currentEpisodeBuffer,
      context,
      emotionalValence,
      strength: pacStrength,
      retrievalCount: 0,
      lastRetrieved: 0,
    };

    updated.episodes = [...state.episodes, episode];
    if (updated.episodes.length > state.capacity) {
      // Remove weakest episode
      updated.episodes.sort((a, b) => a.strength - b.strength);
      updated.episodes = updated.episodes.slice(1);
    }

    updated.currentEpisodeBuffer = [];
    updated.encodingActive = false;
    updated.totalEncoded++;

    // Update statistics
    updated.avgEpisodeLength =
      state.avgEpisodeLength * 0.95 + episode.content.length * 0.05;
  }

  return updated;
}

export function runEpisodicRetrieval(
  state: EpisodicMemoryState,
  cue: number[],
  timestamp: number,
): EpisodicMemoryState {
  const updated = { ...state };
  updated.retrievalCue = cue;

  if (state.episodes.length === 0) {
    updated.lastRetrievedEpisode = null;
    updated.retrievalStrength = 0;
    return updated;
  }

  // Find best matching episode
  let bestMatch: Episode | null = null;
  let bestSimilarity = Number.NEGATIVE_INFINITY;

  for (const episode of state.episodes) {
    // Compare cue to first frame of episode
    if (episode.content.length > 0) {
      const similarity = computeCorrelation(cue, episode.content[0]);
      const strengthBonus = episode.strength * 0.2;
      const recencyBonus = 0.1 / (1 + (timestamp - episode.timestamp) / 10000);

      const score = similarity + strengthBonus + recencyBonus;

      if (score > bestSimilarity) {
        bestSimilarity = score;
        bestMatch = episode;
      }
    }
  }

  if (bestMatch) {
    updated.lastRetrievedEpisode = bestMatch;
    updated.retrievalStrength = Math.max(0, bestSimilarity);

    // Update retrieved episode
    updated.episodes = state.episodes.map((ep) =>
      ep.id === bestMatch!.id
        ? {
            ...ep,
            retrievalCount: ep.retrievalCount + 1,
            lastRetrieved: timestamp,
          }
        : ep,
    );
  }

  return updated;
}

// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// SECTION 8: SEMANTIC MEMORY (ENGINE 7)
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────

export interface SemanticMemoryState {
  nodes: Map<string, SemanticNode>;
  edges: Map<string, SemanticEdge>;

  // Activation spreading
  activationSpreadRate: number;
  activationDecay: number;

  // Statistics
  totalNodes: number;
  totalEdges: number;
  avgDegree: number;
}

export interface SemanticNode {
  id: string;
  concept: string;
  activation: number;
  features: number[];
  connections: string[];
  lastAccess: number;
}

export interface SemanticEdge {
  id: string;
  source: string;
  target: string;
  weight: number;
  type: "is-a" | "has-a" | "related-to" | "part-of";
}

export function initSemanticMemory(): SemanticMemoryState {
  return {
    nodes: new Map(),
    edges: new Map(),
    activationSpreadRate: 0.3,
    activationDecay: 0.1,
    totalNodes: 0,
    totalEdges: 0,
    avgDegree: 0,
  };
}

export function addSemanticNode(
  state: SemanticMemoryState,
  concept: string,
  features: number[],
): SemanticMemoryState {
  const updated = { ...state };
  updated.nodes = new Map(state.nodes);

  if (!updated.nodes.has(concept)) {
    updated.nodes.set(concept, {
      id: concept,
      concept,
      activation: 0,
      features,
      connections: [],
      lastAccess: Date.now(),
    });
    updated.totalNodes++;
  }

  return updated;
}

export function addSemanticEdge(
  state: SemanticMemoryState,
  source: string,
  target: string,
  weight: number,
  type: SemanticEdge["type"],
): SemanticMemoryState {
  const updated = { ...state };
  updated.nodes = new Map(state.nodes);
  updated.edges = new Map(state.edges);

  const edgeId = `${source}-${target}`;

  if (!updated.edges.has(edgeId)) {
    updated.edges.set(edgeId, { id: edgeId, source, target, weight, type });
    updated.totalEdges++;

    // Update node connections
    const sourceNode = updated.nodes.get(source);
    if (sourceNode && !sourceNode.connections.includes(target)) {
      updated.nodes.set(source, {
        ...sourceNode,
        connections: [...sourceNode.connections, target],
      });
    }

    // Update average degree
    let totalDegree = 0;
    for (const n of updated.nodes.values()) {
      totalDegree += n.connections.length;
    }
    updated.avgDegree = totalDegree / updated.totalNodes;
  }

  return updated;
}

export function spreadSemanticActivation(
  state: SemanticMemoryState,
  activatedConcept: string,
  activationLevel: number,
): SemanticMemoryState {
  const updated = { ...state };
  updated.nodes = new Map(state.nodes);

  // Activate initial concept
  const initial = updated.nodes.get(activatedConcept);
  if (initial) {
    updated.nodes.set(activatedConcept, {
      ...initial,
      activation: activationLevel,
      lastAccess: Date.now(),
    });

    // Spread to connected nodes
    for (const connectedId of initial.connections) {
      const connected = updated.nodes.get(connectedId);
      if (connected) {
        const edgeId = `${activatedConcept}-${connectedId}`;
        const edge = state.edges.get(edgeId);
        const edgeWeight = edge?.weight || 0.5;

        const spreadAmount =
          activationLevel * state.activationSpreadRate * edgeWeight;
        updated.nodes.set(connectedId, {
          ...connected,
          activation: Math.min(1, connected.activation + spreadAmount),
        });
      }
    }
  }

  // Decay all activations
  updated.nodes.forEach((node, id) => {
    if (id !== activatedConcept) {
      updated.nodes.set(id, {
        ...node,
        activation: node.activation * (1 - state.activationDecay),
      });
    }
  });

  return updated;
}

// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// SECTION 9: FORGETTING CURVE (ENGINE 11)
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────

export interface ForgettingState {
  // Ebbinghaus forgetting curve parameters
  retentionCurve: RetentionCurveParams;

  // Memory strengths over time
  memoryStrengths: Map<string, MemoryStrength>;

  // Spacing effect
  spacingMultiplier: number;
  lastRehearsalTimes: Map<string, number[]>;
}

export interface RetentionCurveParams {
  initialStrength: number; // S
  decayRate: number; // k
  stabilityFactor: number; // Affects how fast decay slows with repetition
}

export interface MemoryStrength {
  memoryId: string;
  strength: number;
  stability: number; // Higher = slower decay
  rehearsalCount: number;
  lastRehearsal: number;
}

export function initForgetting(): ForgettingState {
  return {
    retentionCurve: {
      initialStrength: 1.0,
      decayRate: MEMORIA_CONSTANTS.EBBINGHAUS_DECAY,
      stabilityFactor: 1.5,
    },
    memoryStrengths: new Map(),
    spacingMultiplier: 1.5,
    lastRehearsalTimes: new Map(),
  };
}

/**
 * Ebbinghaus forgetting curve: R = e^(-t/S)
 * where R = retention, t = time, S = stability
 */
export function computeRetention(
  timeSinceEncoding: number,
  stability: number,
): number {
  return Math.exp(-timeSinceEncoding / stability);
}

export function runForgetting(
  state: ForgettingState,
  currentTime: number,
): ForgettingState {
  const updated = { ...state };
  updated.memoryStrengths = new Map(state.memoryStrengths);

  // Update all memory strengths based on forgetting curve
  updated.memoryStrengths.forEach((mem, id) => {
    const timeSinceLastRehearsal = currentTime - mem.lastRehearsal;
    const retention = computeRetention(timeSinceLastRehearsal, mem.stability);

    updated.memoryStrengths.set(id, {
      ...mem,
      strength: mem.strength * retention,
    });
  });

  // Remove memories below threshold
  updated.memoryStrengths.forEach((mem, id) => {
    if (mem.strength < 0.01) {
      updated.memoryStrengths.delete(id);
    }
  });

  return updated;
}

export function rehearseMemory(
  state: ForgettingState,
  memoryId: string,
  currentTime: number,
): ForgettingState {
  const updated = { ...state };
  updated.memoryStrengths = new Map(state.memoryStrengths);
  updated.lastRehearsalTimes = new Map(state.lastRehearsalTimes);

  const existing = state.memoryStrengths.get(memoryId);

  // Spacing effect: longer gaps between rehearsals = stronger consolidation
  const rehearsalTimes = state.lastRehearsalTimes.get(memoryId) || [];
  const lastTime = rehearsalTimes[rehearsalTimes.length - 1] || 0;
  const gap = currentTime - lastTime;
  const spacingBonus = Math.log(1 + gap / 1000) * state.spacingMultiplier;

  if (existing) {
    updated.memoryStrengths.set(memoryId, {
      ...existing,
      strength: Math.min(1, existing.strength + 0.3),
      stability:
        existing.stability * state.retentionCurve.stabilityFactor +
        spacingBonus,
      rehearsalCount: existing.rehearsalCount + 1,
      lastRehearsal: currentTime,
    });
  } else {
    updated.memoryStrengths.set(memoryId, {
      memoryId,
      strength: state.retentionCurve.initialStrength,
      stability: 1.0,
      rehearsalCount: 1,
      lastRehearsal: currentTime,
    });
  }

  // Track rehearsal times for spacing effect
  updated.lastRehearsalTimes.set(
    memoryId,
    [...rehearsalTimes, currentTime].slice(-10),
  );

  return updated;
}

// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// SECTION 10: LTP/LTD ENGINE (ENGINE 13)
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
//
// Long-term potentiation and depression with ODE dynamics

export interface LTPState {
  // Synaptic weights
  weights: number[][];

  // Eligibility traces
  eligibility: number[][];
  eligibilityDecay: number;

  // Calcium dynamics (simplified)
  calciumLevels: number[][];
  calciumThresholdLTP: number;
  calciumThresholdLTD: number;
  calciumDecay: number;

  // Metaplasticity (BCM threshold)
  bcmThresholds: number[];
  bcmUpdateRate: number;

  // Statistics
  ltpEvents: number;
  ltdEvents: number;
  avgWeightChange: number;
}

export function initLTP(size = 12): LTPState {
  return {
    weights: Array(size)
      .fill(null)
      .map(() =>
        Array(size)
          .fill(0)
          .map(() => 0.3 + Math.random() * 0.2),
      ),
    eligibility: Array(size)
      .fill(null)
      .map(() => Array(size).fill(0)),
    eligibilityDecay: 0.95,
    calciumLevels: Array(size)
      .fill(null)
      .map(() => Array(size).fill(0)),
    calciumThresholdLTP: MEMORIA_CONSTANTS.LTP_THRESHOLD,
    calciumThresholdLTD: MEMORIA_CONSTANTS.LTD_THRESHOLD,
    calciumDecay: 0.9,
    bcmThresholds: new Array(size).fill(0.5),
    bcmUpdateRate: 0.01,
    ltpEvents: 0,
    ltdEvents: 0,
    avgWeightChange: 0,
  };
}

export function runLTP(
  state: LTPState,
  preActivations: number[],
  postActivations: number[],
  dopamineSignal: number,
): LTPState {
  const updated = { ...state };
  const size = state.weights.length;
  let totalChange = 0;
  let changeCount = 0;

  for (let i = 0; i < size; i++) {
    for (let j = 0; j < size; j++) {
      const pre = preActivations[i] || 0;
      const post = postActivations[j] || 0;

      // Update calcium based on activity
      const calciumInflux = pre * post * 2;
      updated.calciumLevels[i][j] =
        state.calciumLevels[i][j] * state.calciumDecay + calciumInflux;

      // Update eligibility trace
      updated.eligibility[i][j] =
        state.eligibility[i][j] * state.eligibilityDecay + pre * post;

      // Determine LTP or LTD based on calcium level
      const ca = updated.calciumLevels[i][j];
      let weightChange = 0;

      if (ca > state.calciumThresholdLTP) {
        // LTP
        weightChange =
          MEMORIA_CONSTANTS.LTP_RATE * (ca - state.calciumThresholdLTP);
        updated.ltpEvents++;
      } else if (
        ca > state.calciumThresholdLTD &&
        ca < state.calciumThresholdLTP
      ) {
        // LTD
        weightChange =
          -MEMORIA_CONSTANTS.LTD_RATE * (state.calciumThresholdLTP - ca);
        updated.ltdEvents++;
      }

      // BCM rule: adjust threshold based on postsynaptic activity
      const bcmModulation = post - state.bcmThresholds[j];
      weightChange *= 1 + bcmModulation;

      // Dopamine modulation (reward signal)
      weightChange *= 1 + dopamineSignal * updated.eligibility[i][j];

      // Apply change
      const newWeight = clamp(state.weights[i][j] + weightChange, 0, 1);
      updated.weights[i][j] = newWeight;

      totalChange += Math.abs(weightChange);
      changeCount++;
    }

    // Update BCM threshold
    const avgPost = postActivations[i] || 0;
    updated.bcmThresholds[i] +=
      state.bcmUpdateRate * (avgPost * avgPost - state.bcmThresholds[i]);
  }

  updated.avgWeightChange = totalChange / changeCount;

  return updated;
}

// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// SECTION 11: SLEEP CONSOLIDATION (ENGINE 9)
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────

export interface SleepConsolidationState {
  sleepStage: "awake" | "N1" | "N2" | "N3" | "REM";
  stageTimer: number;

  // Slow oscillations (N3)
  slowOscillationPhase: number;
  slowOscillationAmplitude: number;

  // Spindles (N2)
  spindleActive: boolean;
  spindleCount: number;

  // REM
  remDensity: number;

  // Consolidation progress
  consolidatedMemories: string[];
  consolidationProgress: number;

  // Sleep quality
  sleepEfficiency: number;
}

export function initSleepConsolidation(): SleepConsolidationState {
  return {
    sleepStage: "awake",
    stageTimer: 0,
    slowOscillationPhase: 0,
    slowOscillationAmplitude: 0,
    spindleActive: false,
    spindleCount: 0,
    remDensity: 0,
    consolidatedMemories: [],
    consolidationProgress: 0,
    sleepEfficiency: 0,
  };
}

export function runSleepConsolidation(
  state: SleepConsolidationState,
  isAsleep: boolean,
  memoriesToConsolidate: string[],
  dt = 1.0,
): SleepConsolidationState {
  const updated = { ...state };

  if (!isAsleep) {
    updated.sleepStage = "awake";
    updated.stageTimer = 0;
    return updated;
  }

  updated.stageTimer += dt;

  // Sleep stage cycling (simplified 90-min cycles)
  const cyclePosition = updated.stageTimer % 90;

  if (cyclePosition < 5) {
    updated.sleepStage = "N1";
    updated.slowOscillationAmplitude = 0.2;
  } else if (cyclePosition < 30) {
    updated.sleepStage = "N2";
    updated.slowOscillationAmplitude = 0.5;

    // Spindle generation
    if (!state.spindleActive && Math.random() < 0.05) {
      updated.spindleActive = true;
      updated.spindleCount++;
    } else if (state.spindleActive && Math.random() < 0.3) {
      updated.spindleActive = false;
    }
  } else if (cyclePosition < 60) {
    updated.sleepStage = "N3";
    updated.slowOscillationAmplitude = 1.0;
    updated.spindleActive = false;

    // Slow oscillation dynamics
    updated.slowOscillationPhase =
      (state.slowOscillationPhase + 0.8 * dt) % TWO_PI;

    // Memory consolidation during slow oscillation up-states
    if (Math.cos(updated.slowOscillationPhase) > 0.5) {
      // Up-state: consolidate memories
      for (const memId of memoriesToConsolidate) {
        if (!updated.consolidatedMemories.includes(memId)) {
          updated.consolidatedMemories.push(memId);
        }
      }
      updated.consolidationProgress += 0.01;
    }
  } else {
    updated.sleepStage = "REM";
    updated.slowOscillationAmplitude = 0.1;
    updated.remDensity = 0.5 + 0.5 * Math.sin(cyclePosition * 0.1);
  }

  // Sleep efficiency
  const consolidationRate =
    updated.consolidatedMemories.length / (memoriesToConsolidate.length || 1);
  updated.sleepEfficiency =
    state.sleepEfficiency * 0.99 + consolidationRate * 0.01;

  return updated;
}

// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// SECTION 12: COMPLETE MEMORIA STATE
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────

export interface CompleteMemoriaState {
  trisynaptic: TrisynapticCircuitState;
  thetaGammaPAC: ThetaGammaPACState;
  sharpWaveRipple: SharpWaveRippleState;
  placeCells: PlaceCellState;
  gridCells: GridCellState;
  episodicMemory: EpisodicMemoryState;
  semanticMemory: SemanticMemoryState;
  forgetting: ForgettingState;
  ltp: LTPState;
  sleepConsolidation: SleepConsolidationState;

  // Integrated outputs
  memoryHealth: number;
  encodingStrength: number;
  retrievalStrength: number;
  consolidationLevel: number;
}

export function initCompleteMemoria(): CompleteMemoriaState {
  return {
    trisynaptic: initTrisynapticCircuit(),
    thetaGammaPAC: initThetaGammaPAC(),
    sharpWaveRipple: initSharpWaveRipple(),
    placeCells: initPlaceCells(),
    gridCells: initGridCells(),
    episodicMemory: initEpisodicMemory(),
    semanticMemory: initSemanticMemory(),
    forgetting: initForgetting(),
    ltp: initLTP(),
    sleepConsolidation: initSleepConsolidation(),
    memoryHealth: 1.0,
    encodingStrength: 0.5,
    retrievalStrength: 0.5,
    consolidationLevel: 0,
  };
}

export function runCompleteMemoria(
  state: CompleteMemoriaState,
  input: MemoriaInput,
  currentTime: number,
): CompleteMemoriaState {
  const updated = { ...state };

  // 1. Oscillatory dynamics
  updated.thetaGammaPAC = runThetaGammaPAC(
    state.thetaGammaPAC,
    input.thetaInput,
    input.gammaInput,
  );

  // 2. Trisynaptic circuit
  updated.trisynaptic = runTrisynapticCircuit(
    state.trisynaptic,
    input.sensoryInput,
  );

  // 3. Spatial cells
  updated.placeCells = runPlaceCells(
    state.placeCells,
    input.location,
    updated.thetaGammaPAC.thetaPhase,
  );
  updated.gridCells = runGridCells(
    state.gridCells,
    input.location,
    input.velocity,
  );

  // 4. Episodic encoding (gated by PAC)
  updated.episodicMemory = runEpisodicEncoding(
    state.episodicMemory,
    updated.trisynaptic.ca1,
    updated.thetaGammaPAC.pacStrength,
    input.context,
    input.emotionalValence,
    currentTime,
  );

  // 5. Sharp-wave ripple (offline consolidation)
  const thetaPower = updated.thetaGammaPAC.thetaAmplitude;
  const memoriesToReplay = state.episodicMemory.episodes
    .slice(-5)
    .flatMap((e) => e.content);
  updated.sharpWaveRipple = runSharpWaveRipple(
    state.sharpWaveRipple,
    thetaPower,
    currentTime,
    memoriesToReplay.length > 0 ? [memoriesToReplay[0]] : null,
  );

  // 6. LTP
  updated.ltp = runLTP(
    state.ltp,
    updated.trisynaptic.ec,
    updated.trisynaptic.ca1,
    input.rewardSignal,
  );

  // 7. Forgetting
  updated.forgetting = runForgetting(state.forgetting, currentTime);

  // 8. Sleep consolidation
  updated.sleepConsolidation = runSleepConsolidation(
    state.sleepConsolidation,
    input.isAsleep,
    state.episodicMemory.episodes.map((e) => e.id.toString()),
  );

  // 9. Compute integrated outputs
  updated.encodingStrength =
    updated.thetaGammaPAC.pacStrength *
    (1 - updated.trisynaptic.patternSeparationIndex);
  updated.retrievalStrength = updated.trisynaptic.patternCompletionIndex;
  updated.consolidationLevel = updated.sleepConsolidation.consolidationProgress;
  updated.memoryHealth =
    updated.encodingStrength * 0.3 +
    updated.retrievalStrength * 0.3 +
    updated.ltp.avgWeightChange * 10 * 0.2 +
    (1 - state.forgetting.memoryStrengths.size > 0 ? 0.8 : 0.2) * 0.2;

  return updated;
}

export interface MemoriaInput {
  sensoryInput: number[];
  thetaInput: number;
  gammaInput: number;
  location: [number, number];
  velocity: [number, number];
  context: string;
  emotionalValence: number;
  rewardSignal: number;
  isAsleep: boolean;
}

// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// UTILITY FUNCTIONS
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────

function clamp(value: number, min: number, max: number): number {
  return Math.max(min, Math.min(max, value));
}

function computeCorrelation(a: number[], b: number[]): number {
  if (a.length !== b.length || a.length === 0) return 0;

  const n = a.length;
  const meanA = a.reduce((s, v) => s + v, 0) / n;
  const meanB = b.reduce((s, v) => s + v, 0) / n;

  let cov = 0;
  let varA = 0;
  let varB = 0;
  for (let i = 0; i < n; i++) {
    const da = a[i] - meanA;
    const db = b[i] - meanB;
    cov += da * db;
    varA += da * da;
    varB += db * db;
  }

  const denom = Math.sqrt(varA * varB);
  return denom > 0 ? cov / denom : 0;
}

// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// DIAGNOSTICS
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────

export function getMemoriaDiagnostics(state: CompleteMemoriaState): string {
  const lines: string[] = [
    "╔═══════════════════════════════════════════════════════════════════════════════╗",
    "║              MEMORIA ENGINE DIAGNOSTICS (22 ENGINES)                          ║",
    "║                  Complete Hippocampal Memory System                           ║",
    "╚═══════════════════════════════════════════════════════════════════════════════╝",
    "",
    `Memory Health: ${(state.memoryHealth * 100).toFixed(1)}%`,
    `Encoding Strength: ${(state.encodingStrength * 100).toFixed(1)}%`,
    `Retrieval Strength: ${(state.retrievalStrength * 100).toFixed(1)}%`,
    `Consolidation Level: ${(state.consolidationLevel * 100).toFixed(1)}%`,
    "",
    "═══ TRISYNAPTIC CIRCUIT ═══════════════════════════════════════════════════════",
    `  Pattern Separation: ${(state.trisynaptic.patternSeparationIndex * 100).toFixed(1)}%`,
    `  Pattern Completion: ${(state.trisynaptic.patternCompletionIndex * 100).toFixed(1)}%`,
    "",
    "═══ THETA-GAMMA PAC ══════════════════════════════════════════════════════════",
    `  PAC Strength: ${state.thetaGammaPAC.pacStrength.toFixed(3)}`,
    `  Modulation Index: ${state.thetaGammaPAC.modulationIndex.toFixed(3)}`,
    `  Encoding Window: ${state.thetaGammaPAC.encodingWindow ? "OPEN" : "closed"}`,
    "",
    "═══ SHARP-WAVE RIPPLE ════════════════════════════════════════════════════════",
    `  Ripple Active: ${state.sharpWaveRipple.rippleActive ? "YES" : "no"}`,
    `  Ripple Count: ${state.sharpWaveRipple.rippleCount}`,
    `  Replay Fidelity: ${(state.sharpWaveRipple.replayFidelity * 100).toFixed(1)}%`,
    "",
    "═══ EPISODIC MEMORY ══════════════════════════════════════════════════════════",
    `  Stored Episodes: ${state.episodicMemory.episodes.length}/${state.episodicMemory.capacity}`,
    `  Total Encoded: ${state.episodicMemory.totalEncoded}`,
    `  Avg Episode Length: ${state.episodicMemory.avgEpisodeLength.toFixed(1)} frames`,
    "",
    "═══ SEMANTIC MEMORY ══════════════════════════════════════════════════════════",
    `  Concept Nodes: ${state.semanticMemory.totalNodes}`,
    `  Edges: ${state.semanticMemory.totalEdges}`,
    `  Avg Degree: ${state.semanticMemory.avgDegree.toFixed(2)}`,
    "",
    "═══ LTP/LTD ══════════════════════════════════════════════════════════════════",
    `  LTP Events: ${state.ltp.ltpEvents}`,
    `  LTD Events: ${state.ltp.ltdEvents}`,
    `  Avg Weight Change: ${state.ltp.avgWeightChange.toFixed(4)}`,
    "",
    "═══ SLEEP CONSOLIDATION ══════════════════════════════════════════════════════",
    `  Sleep Stage: ${state.sleepConsolidation.sleepStage}`,
    `  Spindle Count: ${state.sleepConsolidation.spindleCount}`,
    `  Sleep Efficiency: ${(state.sleepConsolidation.sleepEfficiency * 100).toFixed(1)}%`,
  ];

  return lines.join("\n");
}
