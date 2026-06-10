/**
 * IMMUNE BRAIN — Hebbian Cognitive Engine for the Nova Immune System
 * Nova by FreddyCreates
 * 
 * "The brain learns from chaos — every attack makes us stronger."
 * 
 * Based on geometry-lock-brain.js, this is the immune system's cognitive center.
 * It learns from threats, remembers patterns, and adapts defenses over time.
 * 
 * Brain regions:
 * - PFC (Prefrontal Cortex): Decision-making, strategy, meta-cognition
 * - AMYGDALA: Threat detection, fear response, emergency escalation
 * - HIPPOCAMPUS: Pattern memory, attack history, immune memory
 * - CEREBELLUM: Timing, coordination, response calibration
 * - THALAMUS: Signal routing, attention gating
 * 
 * The brain uses Hebbian learning: "Neurons that fire together, wire together"
 * Over time, it builds immune memory that recognizes and responds faster to
 * similar threats.
 * 
 * @version 1.0.0
 * @copyright Nova Protocol by FreddyCreates
 */

import { PHI, PHI_INV, kuramotoR, GREEK } from './greek-mathematics.js';

// ═══════════════════════════════════════════════════════════════════════════
// CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════

const BRAIN_TICK_MS = 16.67;   // ~60 Hz
const REGION_COUNT = 5;
const LEARNING_RATE = GREEK.ETA.value;  // φ-scaled learning
const DECAY_RATE = GREEK.GAMMA.value * 0.001;  // γ-scaled decay
const SPIKE_THRESHOLD = 0.85;
const TWO_PI = 2 * Math.PI;

/** Memory capacity (F12 = 144) */
const MEMORY_CAPACITY = 144;

// ═══════════════════════════════════════════════════════════════════════════
// REGION DEFINITIONS
// ═══════════════════════════════════════════════════════════════════════════

const REGIONS = [
  { id: 0, name: 'PFC',         activation: 0.5, decay: 0.95, base: 0.5, output: 0.0, role: 'STRATEGY' },
  { id: 1, name: 'AMYGDALA',    activation: 0.3, decay: 0.90, base: 0.3, output: 0.0, role: 'THREAT' },
  { id: 2, name: 'HIPPOCAMPUS', activation: 0.4, decay: 0.98, base: 0.4, output: 0.0, role: 'MEMORY' },
  { id: 3, name: 'CEREBELLUM',  activation: 0.4, decay: 0.96, base: 0.4, output: 0.0, role: 'TIMING' },
  { id: 4, name: 'THALAMUS',    activation: 0.5, decay: 0.94, base: 0.5, output: 0.0, role: 'ROUTING' }
];

// ═══════════════════════════════════════════════════════════════════════════
// CONNECTION TOPOLOGY — Full mesh with φ-weighted connections
// [from, to, baseWeight]
// ═══════════════════════════════════════════════════════════════════════════

const CONNECTIONS = [
  // PFC connections (governance)
  [0, 1, 0.3 * PHI_INV],  // PFC → AMYGDALA (executive control over fear)
  [0, 2, 0.5],            // PFC → HIPPOCAMPUS (working memory)
  [0, 3, 0.4],            // PFC → CEREBELLUM (planning)
  [0, 4, 0.6],            // PFC → THALAMUS (attention)
  
  // AMYGDALA connections (threat)
  [1, 0, 0.4 * PHI_INV],  // AMYGDALA → PFC (threat interrupt)
  [1, 2, 0.7],            // AMYGDALA → HIPPOCAMPUS (fear memory)
  [1, 3, 0.5],            // AMYGDALA → CEREBELLUM (startle)
  [1, 4, 0.8],            // AMYGDALA → THALAMUS (attention capture)
  
  // HIPPOCAMPUS connections (memory)
  [2, 0, 0.4],            // HIPPOCAMPUS → PFC (recall)
  [2, 1, 0.5],            // HIPPOCAMPUS → AMYGDALA (contextual fear)
  [2, 3, 0.3],            // HIPPOCAMPUS → CEREBELLUM (sequence memory)
  [2, 4, 0.4],            // HIPPOCAMPUS → THALAMUS (familiar signals)
  
  // CEREBELLUM connections (timing)
  [3, 0, 0.3],            // CEREBELLUM → PFC (timing feedback)
  [3, 1, 0.2],            // CEREBELLUM → AMYGDALA (conditioned response)
  [3, 2, 0.4],            // CEREBELLUM → HIPPOCAMPUS (procedural)
  [3, 4, 0.5],            // CEREBELLUM → THALAMUS (coordination)
  
  // THALAMUS connections (routing)
  [4, 0, 0.6],            // THALAMUS → PFC (filtered signals)
  [4, 1, 0.7],            // THALAMUS → AMYGDALA (threat signals)
  [4, 2, 0.5],            // THALAMUS → HIPPOCAMPUS (encoding signals)
  [4, 3, 0.4]             // THALAMUS → CEREBELLUM (motor signals)
];

// ═══════════════════════════════════════════════════════════════════════════
// IMMUNE BRAIN CLASS
// ═══════════════════════════════════════════════════════════════════════════

/**
 * ImmuneBrain — The learning cognitive engine of the immune system
 */
export class ImmuneBrain {
  constructor(config = {}) {
    // Neural state
    this.regions = REGIONS.map(r => ({ ...r }));
    this.weights = new Float32Array(CONNECTIONS.length);
    this._initWeights();
    
    // Cognitive state
    this.tickCount = 0;
    this.beatCount = 0;
    this._tickTimer = null;
    
    // Spike history
    this.spikeLog = [];
    
    // Immune memory
    this.immuneMemory = new Map();  // patternHash → memory entry
    this.threatPatterns = [];       // Recognized threat signatures
    
    // Meta-cognition
    this.confidence = 0.5;          // Epistemological confidence
    this.creativity = 0;            // Emergent creativity measure
    
    // Learning metrics
    this.metrics = {
      totalTicks: 0,
      spikesEmitted: 0,
      memoriesFormed: 0,
      patternsRecognized: 0,
      creativeMoments: 0
    };
  }
  
  _initWeights() {
    for (let i = 0; i < CONNECTIONS.length; i++) {
      this.weights[i] = CONNECTIONS[i][2];
    }
  }
  
  // ─── Lifecycle ─────────────────────────────────────────────────────────
  
  start() {
    if (this._tickTimer) return this;
    this._tickTimer = setInterval(() => this.tick(), BRAIN_TICK_MS);
    return this;
  }
  
  stop() {
    if (this._tickTimer) {
      clearInterval(this._tickTimer);
      this._tickTimer = null;
    }
    return this;
  }
  
  // ─── Single Cognitive Tick ─────────────────────────────────────────────
  
  tick() {
    this.tickCount++;
    this.metrics.totalTicks++;
    
    // Update each region
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
      r.output = r.activation;
      
      // Spike detection
      if (r.activation >= SPIKE_THRESHOLD) {
        this._emitSpike(i, r.activation);
      }
    }
    
    // Hebbian weight update
    this._hebbianUpdate();
    
    // Update meta-cognition
    this._updateMetaCognition();
  }
  
  _hebbianUpdate() {
    for (let c = 0; c < CONNECTIONS.length; c++) {
      const [from, to] = CONNECTIONS[c];
      const pre = this.regions[from].activation;
      const post = this.regions[to].activation;
      
      // Hebbian: Δw = η × pre × post
      const dw = LEARNING_RATE * pre * post;
      
      // Update with decay
      this.weights[c] = Math.min(1, Math.max(0, 
        this.weights[c] * (1 - DECAY_RATE) + dw
      ));
    }
  }
  
  _emitSpike(regionId, activation) {
    const spike = {
      regionId,
      name: this.regions[regionId].name,
      role: this.regions[regionId].role,
      activation,
      timestamp: Date.now()
    };
    
    this.spikeLog.push(spike);
    if (this.spikeLog.length > 89) this.spikeLog.shift();  // F11 depth
    
    this.metrics.spikesEmitted++;
    
    return spike;
  }
  
  _updateMetaCognition() {
    // Epistemological confidence based on coherence
    const coherence = this.computeCoherence();
    
    // Confidence increases with coherence but also needs variability
    const variance = this._computeVariance();
    
    // Optimal confidence: high coherence, moderate variance
    this.confidence = coherence * (1 - Math.abs(variance - 0.3));
    
    // Creativity emerges at edge of chaos (coherence near φ⁻¹)
    const edgeDistance = Math.abs(coherence - PHI_INV);
    this.creativity = Math.max(0, 1 - edgeDistance * 5);
    
    if (this.creativity > 0.8) {
      this.metrics.creativeMoments++;
    }
  }
  
  _computeVariance() {
    if (this.spikeLog.length < 2) return 0;
    
    const recent = this.spikeLog.slice(-20);
    const mean = recent.reduce((s, sp) => s + sp.activation, 0) / recent.length;
    const variance = recent.reduce((s, sp) => s + Math.pow(sp.activation - mean, 2), 0) / recent.length;
    
    return Math.sqrt(variance);
  }
  
  // ─── External Stimulation ──────────────────────────────────────────────
  
  /**
   * Stimulate a brain region
   * @param {number} regionId - 0=PFC, 1=AMYGDALA, 2=HIPPOCAMPUS, 3=CEREBELLUM, 4=THALAMUS
   * @param {number} intensity - 0.0–1.0
   */
  stimulate(regionId, intensity) {
    if (regionId < 0 || regionId >= REGION_COUNT) return;
    const r = this.regions[regionId];
    r.activation = Math.min(1, r.activation + intensity);
    r.output = r.activation;
  }
  
  stimulateByName(name, intensity) {
    const idx = this.regions.findIndex(r => r.name === name);
    if (idx >= 0) this.stimulate(idx, intensity);
  }
  
  // ─── Threat Processing ─────────────────────────────────────────────────
  
  /**
   * Process a detected threat
   */
  processThreat(threatSignature, severity) {
    // Stimulate AMYGDALA proportional to severity
    this.stimulate(1, severity * 0.5);
    
    // Route through THALAMUS
    this.stimulate(4, severity * 0.3);
    
    // Check if this pattern is recognized
    const recognized = this.recognizePattern(threatSignature);
    
    if (recognized) {
      // Fast path: HIPPOCAMPUS already knows this threat
      this.stimulate(2, 0.4);  // Memory activation
      this.stimulate(0, 0.2);  // PFC for strategic response
    } else {
      // Novel threat: Learn and remember
      this.learnPattern(threatSignature, 'threat', severity);
    }
    
    return {
      recognized,
      amygdalaResponse: this.regions[1].activation,
      pfcResponse: this.regions[0].activation,
      confidence: this.confidence
    };
  }
  
  /**
   * Classify threat level based on brain state
   */
  classifyThreat() {
    const amygdala = this.regions[1].activation;
    const pfc = this.regions[0].activation;
    
    // High amygdala + low PFC = panic response
    // High amygdala + high PFC = controlled response
    // Low amygdala = no threat perceived
    
    if (amygdala < 0.3) {
      return { level: 'NONE', confidence: this.confidence };
    }
    
    if (amygdala > 0.7 && pfc < 0.4) {
      return { level: 'CRITICAL', confidence: this.confidence, warning: 'PANIC_RESPONSE' };
    }
    
    if (amygdala > 0.7) {
      return { level: 'HIGH', confidence: this.confidence };
    }
    
    if (amygdala > 0.5) {
      return { level: 'MEDIUM', confidence: this.confidence };
    }
    
    return { level: 'LOW', confidence: this.confidence };
  }
  
  // ─── Immune Memory ─────────────────────────────────────────────────────
  
  /**
   * Learn a pattern and store in immune memory
   */
  learnPattern(pattern, type, significance) {
    const hash = this._hashPattern(pattern);
    
    const memory = {
      hash,
      pattern,
      type,
      significance,
      encounters: 1,
      firstSeen: Date.now(),
      lastSeen: Date.now(),
      response: this._generateResponse(type, significance)
    };
    
    this.immuneMemory.set(hash, memory);
    
    if (this.immuneMemory.size > MEMORY_CAPACITY) {
      // Evict least significant memory
      this._evictWeakestMemory();
    }
    
    this.metrics.memoriesFormed++;
    
    // Consolidate in HIPPOCAMPUS
    this.stimulate(2, significance * 0.3);
    
    return memory;
  }
  
  /**
   * Recognize a pattern from immune memory
   */
  recognizePattern(pattern) {
    const hash = this._hashPattern(pattern);
    const memory = this.immuneMemory.get(hash);
    
    if (memory) {
      memory.encounters++;
      memory.lastSeen = Date.now();
      
      // Strengthen memory with each encounter
      memory.significance = Math.min(1, memory.significance * 1.1);
      
      this.metrics.patternsRecognized++;
      
      return memory;
    }
    
    return null;
  }
  
  _hashPattern(pattern) {
    // Simple hash for pattern comparison
    const str = JSON.stringify(pattern);
    let hash = 0;
    for (let i = 0; i < str.length; i++) {
      const char = str.charCodeAt(i);
      hash = ((hash << 5) - hash) + char;
      hash = hash & hash;
    }
    return hash.toString(16);
  }
  
  _generateResponse(type, significance) {
    // Generate appropriate immune response based on type and significance
    return {
      type,
      strength: significance * PHI_INV,
      actions: this._determineActions(type, significance)
    };
  }
  
  _determineActions(type, significance) {
    const actions = [];
    
    if (type === 'threat') {
      if (significance > 0.8) {
        actions.push('ISOLATE', 'NEUTRALIZE', 'ALERT');
      } else if (significance > 0.5) {
        actions.push('MONITOR', 'PREPARE');
      } else {
        actions.push('LOG');
      }
    }
    
    return actions;
  }
  
  _evictWeakestMemory() {
    let weakest = null;
    let weakestScore = Infinity;
    
    for (const [hash, memory] of this.immuneMemory) {
      // Score = significance × recency × frequency
      const age = Date.now() - memory.lastSeen;
      const recency = Math.exp(-age / (3600000 * 24));  // Decay over ~1 day
      const score = memory.significance * recency * Math.log(memory.encounters + 1);
      
      if (score < weakestScore) {
        weakestScore = score;
        weakest = hash;
      }
    }
    
    if (weakest) {
      this.immuneMemory.delete(weakest);
    }
  }
  
  // ─── Meta-Learning ─────────────────────────────────────────────────────
  
  /**
   * Meta-learning: Learn from the learning process itself
   */
  metaLearn(outcome) {
    // If our response was effective, strengthen current weights
    // If ineffective, explore new configurations
    
    if (outcome.success) {
      // Reinforce current patterns
      for (let c = 0; c < CONNECTIONS.length; c++) {
        this.weights[c] = Math.min(1, this.weights[c] * 1.01);
      }
      this.confidence = Math.min(1, this.confidence * 1.05);
    } else {
      // Explore: add noise to weights
      for (let c = 0; c < CONNECTIONS.length; c++) {
        const noise = (Math.random() - 0.5) * GREEK.XI.value * 0.1;
        this.weights[c] = Math.max(0, Math.min(1, this.weights[c] + noise));
      }
      this.confidence = Math.max(0.1, this.confidence * 0.95);
    }
    
    return {
      confidence: this.confidence,
      creativity: this.creativity,
      outcome
    };
  }
  
  // ─── Coherence Computation ─────────────────────────────────────────────
  
  computeCoherence() {
    // Map activations to phase angles ∈ [0, 2π]
    const phases = this.regions.map(r => r.activation * TWO_PI);
    return kuramotoR(phases);
  }
  
  hasEmergence() {
    return this.computeCoherence() > PHI_INV;
  }
  
  // ─── State Snapshot ────────────────────────────────────────────────────
  
  getState() {
    return {
      regions: this.regions.map(r => ({
        id: r.id,
        name: r.name,
        role: r.role,
        activation: r.activation,
        output: r.output
      })),
      coherence: this.computeCoherence(),
      emergence: this.hasEmergence(),
      confidence: this.confidence,
      creativity: this.creativity,
      tickCount: this.tickCount,
      memorySize: this.immuneMemory.size,
      spikes: this.spikeLog.slice(-8),
      metrics: { ...this.metrics },
      weights: this._getWeightSummary()
    };
  }
  
  _getWeightSummary() {
    const summary = {};
    for (let c = 0; c < CONNECTIONS.length; c++) {
      const [from, to] = CONNECTIONS[c];
      const key = `${this.regions[from].name}→${this.regions[to].name}`;
      summary[key] = this.weights[c].toFixed(4);
    }
    return summary;
  }
  
  toJSON() {
    return {
      type: 'ImmuneBrain',
      version: '1.0.0',
      ...this.getState()
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// FACTORY
// ═══════════════════════════════════════════════════════════════════════════

export function createImmuneBrain(config = {}) {
  return new ImmuneBrain(config);
}

// ═══════════════════════════════════════════════════════════════════════════
// DEFAULT EXPORT
// ═══════════════════════════════════════════════════════════════════════════

export default {
  ImmuneBrain,
  REGIONS,
  CONNECTIONS,
  MEMORY_CAPACITY,
  createImmuneBrain
};
