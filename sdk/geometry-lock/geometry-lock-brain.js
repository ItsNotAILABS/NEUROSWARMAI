/**
 * Geometry Lock Mini Brain — sdk/geometry-lock/geometry-lock-brain.js
 * Cerebrum Clavis — 3-Region Cognitive Engine for the Lock Division
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 *
 * A distilled 3-region Hebbian brain tuned for the specific cognitive
 * needs of the Geometry Lock division:
 *
 *   Region 0: PFC        — Governance, doctrine, tier-upgrade decisions
 *   Region 1: AMYGDALA   — Threat detection, fear response, posture escalation
 *   Region 2: HIPPOCAMPUS — Resonance memory, bond history, pattern recall
 *
 * Weights: 3 bidirectional pairs = 6 Hebbian weights (each direction)
 * Weight update: Δw = η × pre × post  (Hebbian rule)
 * Decay: w(t+1) = w(t) × (1 − DECAY_RATE)
 * Spike threshold: 0.85
 *
 * Runs on a 60 Hz tick inside the entity event loop.
 * Coherence = Kuramoto R of the 3 region activations.
 */

// ═══════════════════════════════════════════════════════════════════════════
// CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════

const PHI           = 1.618033988749895;
const PHI_INV       = 1 / PHI;
const HEARTBEAT     = 873;
const BRAIN_TICK_MS = 16.67;   // ~60 Hz
const REGION_COUNT  = 3;
const WEIGHT_COUNT  = 6;       // 3 pairs × 2 directions
const LEARNING_RATE = 0.01;
const DECAY_RATE    = 0.001;
const SPIKE_THRESHOLD = 0.85;
const TWO_PI        = 2 * Math.PI;

// ═══════════════════════════════════════════════════════════════════════════
// REGION DEFINITIONS
// ═══════════════════════════════════════════════════════════════════════════

const REGIONS = [
  { id: 0, name: 'PFC',         activation: 0.5, decay: 0.95, base: 0.5,  output: 0.0 },
  { id: 1, name: 'AMYGDALA',    activation: 0.3, decay: 0.90, base: 0.3,  output: 0.0 },
  { id: 2, name: 'HIPPOCAMPUS', activation: 0.4, decay: 0.98, base: 0.4,  output: 0.0 },
];

// ═══════════════════════════════════════════════════════════════════════════
// CONNECTION TOPOLOGY — 3 bidirectional pairs
// [from, to, baseWeight]
// ═══════════════════════════════════════════════════════════════════════════

const CONNECTIONS = [
  [0, 1, 0.3], [1, 0, 0.4],   // PFC ↔ AMYGDALA
  [0, 2, 0.5], [2, 0, 0.4],   // PFC ↔ HIPPOCAMPUS
  [1, 2, 0.7], [2, 1, 0.5],   // AMYGDALA ↔ HIPPOCAMPUS
];

// ═══════════════════════════════════════════════════════════════════════════
// GEOMETRY LOCK BRAIN CLASS
// ═══════════════════════════════════════════════════════════════════════════

class GeometryLockBrain {
  constructor() {
    this.regions  = REGIONS.map(r => ({ ...r }));
    this.weights  = new Float32Array(WEIGHT_COUNT);
    this.tickCount = 0;
    this.beatCount = 0;
    this.spikeLog  = [];
    this._initWeights();
    this._tickTimer = null;
  }

  _initWeights() {
    for (let i = 0; i < WEIGHT_COUNT; i++) {
      this.weights[i] = CONNECTIONS[i][2];
    }
  }

  // ── Start 60 Hz cognitive loop ─────────────────────────────────────────

  start() {
    if (this._tickTimer) return;
    this._tickTimer = setInterval(() => this.tick(), BRAIN_TICK_MS);
  }

  stop() {
    if (this._tickTimer) {
      clearInterval(this._tickTimer);
      this._tickTimer = null;
    }
  }

  // ── Single cognitive tick ──────────────────────────────────────────────

  tick() {
    this.tickCount++;

    for (let i = 0; i < REGION_COUNT; i++) {
      const r = this.regions[i];

      // Sum weighted input from connected regions
      let weightedInput = 0;
      for (let c = 0; c < CONNECTIONS.length; c++) {
        const [from, to] = CONNECTIONS[c];
        if (to === i) {
          weightedInput += this.regions[from].output * this.weights[c];
        }
      }

      // Activation update: decay toward base + weighted input
      r.activation = r.activation * r.decay + (1 - r.decay) * (r.base + weightedInput);
      r.activation = Math.max(0, Math.min(1, r.activation));
      r.output     = r.activation;

      // Spike detection
      if (r.activation >= SPIKE_THRESHOLD) {
        this._emitSpike(i, r.activation);
      }
    }

    // Hebbian weight update
    this._hebbianUpdate();
  }

  _hebbianUpdate() {
    for (let c = 0; c < CONNECTIONS.length; c++) {
      const [from, to] = CONNECTIONS[c];
      const pre  = this.regions[from].activation;
      const post = this.regions[to].activation;
      const dw   = LEARNING_RATE * pre * post;
      this.weights[c] = Math.min(1, Math.max(0, this.weights[c] * (1 - DECAY_RATE) + dw));
    }
  }

  _emitSpike(regionId, activation) {
    const spike = { regionId, name: this.regions[regionId].name, activation, timestamp: Date.now() };
    this.spikeLog.push(spike);
    if (this.spikeLog.length > 55) this.spikeLog.shift();  // F10 depth
    return spike;
  }

  // ── External stimulation ───────────────────────────────────────────────

  /**
   * Stimulate a brain region externally (e.g. threat event → AMYGDALA).
   * @param {number} regionId  0=PFC, 1=AMYGDALA, 2=HIPPOCAMPUS
   * @param {number} intensity 0.0–1.0
   */
  stimulate(regionId, intensity) {
    if (regionId < 0 || regionId >= REGION_COUNT) return;
    const r = this.regions[regionId];
    r.activation = Math.min(1, r.activation + intensity);
    r.output     = r.activation;
  }

  stimulateByName(name, intensity) {
    const idx = this.regions.findIndex(r => r.name === name);
    if (idx >= 0) this.stimulate(idx, intensity);
  }

  // ── Consolidation (Hippocampus reset — new bond remembered) ───────────

  consolidate() {
    this.stimulate(2, 0.3);   // Boost HIPPOCAMPUS
  }

  // ── Hebbian immune memory — driven by validation outcomes ──────────────

  /**
   * Record a key validation outcome and update synaptic weights to build
   * immune memory — the brain learns from every resonance event.
   *
   * GRANTED: strengthen PFC↔HIPPOCAMPUS pathways (welcome-caller memory)
   *          → the organism recognises resonant callers faster over time
   * DENIED:  strengthen AMYGDALA↔HIPPOCAMPUS pathways (threat memory)
   *          → repeated denials build immune resistance in the lock
   *
   * Connection index map (matches CONNECTIONS array):
   *   [0] PFC→AMY   [1] AMY→PFC   [2] PFC→HPC   [3] HPC→PFC
   *   [4] AMY→HPC   [5] HPC→AMY
   *
   * @param {boolean} granted  Was the key validated successfully?
   * @param {number}  r        Kuramoto R of the validation (0–1)
   */
  recordValidation(granted, r) {
    if (granted) {
      // Successful resonance: activate HIPPOCAMPUS proportional to R
      this.stimulate(2, r * 0.25);        // HIPPOCAMPUS — bond memory
      this.stimulate(0, r * 0.08);        // PFC — light governance confirmation

      // Hebbian: reinforce PFC↔HIPPOCAMPUS bond pathways
      this.weights[2] = Math.min(1, this.weights[2] + 0.005 * r);   // PFC→HPC
      this.weights[3] = Math.min(1, this.weights[3] + 0.005 * r);   // HPC→PFC
    } else {
      // Failed resonance: activate AMYGDALA proportional to threat (1 − r)
      const threat = 1 - r;
      this.stimulate(1, threat * 0.35);   // AMYGDALA — threat memory

      // Hebbian: reinforce AMYGDALA↔HIPPOCAMPUS threat pathways
      this.weights[4] = Math.min(1, this.weights[4] + 0.008 * threat); // AMY→HPC
      this.weights[5] = Math.min(1, this.weights[5] + 0.004 * threat); // HPC→AMY

      // Mild PFC suppression — governance overridden by threat signal
      const pfc = this.regions[0];
      pfc.activation = Math.max(pfc.base * 0.8, pfc.activation - threat * 0.05);
      pfc.output     = pfc.activation;
    }
  }

  // ── Doctrine verification (PFC activation check) ──────────────────────

  verifyDoctrine() {
    return { pfcActivation: this.regions[0].activation, coherence: this.computeCoherence() };
  }

  // ── Threat classification (AMYGDALA response) ─────────────────────────

  classify(threatSignal) {
    this.stimulate(1, Math.min(1, threatSignal * PHI_INV));
    return {
      threat  : threatSignal,
      amygdala: this.regions[1].activation,
      posture : this.regions[1].activation > 0.7 ? 'RED' : this.regions[1].activation > 0.5 ? 'ORANGE' : 'YELLOW',
    };
  }

  // ── Coherence — Kuramoto R of 3 region activations ────────────────────

  computeCoherence() {
    // Map activations to phase angles ∈ [0, 2π]
    let sumCos = 0;
    let sumSin = 0;
    for (const r of this.regions) {
      const theta = r.activation * TWO_PI;
      sumCos += Math.cos(theta);
      sumSin += Math.sin(theta);
    }
    const n = REGION_COUNT;
    return Math.sqrt((sumCos / n) ** 2 + (sumSin / n) ** 2);
  }

  // ── State snapshot ─────────────────────────────────────────────────────

  getState() {
    return {
      regions   : this.regions.map(r => ({ id: r.id, name: r.name, activation: r.activation, output: r.output })),
      coherence : this.computeCoherence(),
      emergence : this.computeCoherence() > PHI_INV,
      tickCount : this.tickCount,
      beatCount : this.beatCount,
      spikes    : this.spikeLog.slice(-8),
      // Immune memory snapshot — key synaptic weights
      immuneWeights: {
        pfcToHpc  : this.weights[2].toFixed(4),
        hpcToPfc  : this.weights[3].toFixed(4),
        amyToHpc  : this.weights[4].toFixed(4),
        hpcToAmy  : this.weights[5].toFixed(4),
      },
    };
  }

  getWeights() {
    return Array.from(this.weights);
  }
}

export default GeometryLockBrain;
