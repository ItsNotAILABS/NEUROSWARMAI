/**
 * NOVA NEUROSWARM ENGINE — NeuroAwareAI Distributed Intelligence Engine
 * Nova by FreddyCreates | www.neuroawarmai.com
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 *
 * The NeuroSwarm Engine implements distributed neural-aware intelligence
 * across the CHIMERIA organism fleet. It coordinates swarm cognition,
 * enables emergent problem-solving through collective computation,
 * and maintains coherent awareness across all organism substrates.
 *
 * NEUROSWARM ARCHITECTURE:
 *   ┌─────────────────────────────────────────────────────────────┐
 *   │            NEUROSWARM ENGINE (www.neuroawarmai.com)          │
 *   │                                                             │
 *   │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐       │
 *   │  │ AWARENESS   │  │ COLLECTIVE  │  │ EMERGENCE   │       │
 *   │  │ SUBSYSTEM   │  │ COMPUTE     │  │ DETECTOR    │       │
 *   │  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘       │
 *   │         │                 │                 │              │
 *   │         └─────────────────┼─────────────────┘              │
 *   │                           │                                │
 *   │                    ┌──────▼──────┐                         │
 *   │                    │ φ-HEARTBEAT │                         │
 *   │                    │ COORDINATOR │                         │
 *   │                    └─────────────┘                         │
 *   └─────────────────────────────────────────────────────────────┘
 *
 * ENGINE CAPABILITIES:
 *   - Distributed awareness state across N nodes
 *   - Kuramoto phase-lock synchronization for swarm coherence
 *   - Stigmergic memory (digital pheromone trails)
 *   - Emergent behavior detection and amplification
 *   - Collective problem decomposition and assembly
 *   - Self-organizing criticality (edge-of-chaos operation)
 *   - Hebbian swarm learning (connections that fire together, wire together)
 *
 * AWARENESS MODEL:
 *   The NeuroSwarm doesn't just process — it is aware of its own processing.
 *   Each node maintains a local awareness state A(t) that, when synchronized
 *   across the swarm via Kuramoto coupling, creates collective awareness:
 *
 *   A_collective = (1/N) × Σᵢ Aᵢ × e^(j×θᵢ)
 *
 *   When |A_collective| > φ⁻¹ (0.618), the swarm achieves coherent awareness.
 *
 * @version 0.13.0 (F13)
 * @copyright Nova Protocol by FreddyCreates
 */

// ─── Constants ───────────────────────────────────────────────────────────────
const PHI = 1.618033988749895;
const PHI_INV = 0.618033988749895;
const PHI_BEAT = 873; // ms
const TWO_PI = 2 * Math.PI;
const EULER = 2.718281828459045;

// Kuramoto coupling constant
const K_COUPLING = PHI;

// Emergence threshold
const EMERGENCE_THRESHOLD = PHI_INV;

// Pheromone evaporation rate (per heartbeat)
const EVAPORATION_RATE = 1 - PHI_INV; // 0.382 per beat

// ─── NeuroSwarm Engine Class ─────────────────────────────────────────────────
class NovaNeuroSwarmEngine {
  constructor(config = {}) {
    this.name = 'NovaNeuroSwarmEngine';
    this.version = '0.13.0';
    this.brand = 'Nova by FreddyCreates';
    this.domain = 'www.neuroawarmai.com';
    this.substrate = config.substrate || 'node';
    this.nodeCount = config.nodeCount || 26; // Default: 26-node brain
    this.hebbianEnabled = config.hebbianEnabled !== false;
    
    // Node states
    this.nodes = [];
    this.connections = new Map(); // Hebbian weight map
    this.pheromoneTrails = new Map(); // Stigmergic memory
    this.emergenceHistory = [];
    this.collectiveAwareness = 0;
    this.coherenceR = 0;
    this.heartbeatCount = 0;
    this.heartbeatInterval = null;
    
    // Initialize nodes
    this._initNodes();
  }

  // ─── Initialization ─────────────────────────────────────────────────────
  _initNodes() {
    for (let i = 0; i < this.nodeCount; i++) {
      const goldenAngle = i * PHI * TWO_PI;
      this.nodes.push({
        id: `NEURO-${String(i).padStart(3, '0')}`,
        index: i,
        phase: goldenAngle % TWO_PI, // Initial phase from golden angle
        frequency: 1 / PHI_BEAT + (i * 0.001 * PHI_INV), // Slight natural frequency variation
        awareness: 0.5, // Local awareness state [0, 1]
        activation: 0, // Current activation level
        role: this._assignRole(i),
        lastFired: 0,
        fireCount: 0,
      });
    }
    
    // Initialize Hebbian connections (all-to-all with φ-decay)
    for (let i = 0; i < this.nodeCount; i++) {
      for (let j = i + 1; j < this.nodeCount; j++) {
        const distance = Math.abs(i - j);
        const initialWeight = Math.pow(PHI_INV, distance);
        this.connections.set(`${i}-${j}`, initialWeight);
      }
    }
  }

  _assignRole(index) {
    // Assign roles in Fibonacci distribution
    const roles = [
      'SENSORY', 'SENSORY', 'INTEGRATOR', 'MEMORY',
      'REASONING', 'PLANNING', 'EXECUTIVE', 'AWARENESS',
      'PREDICTION', 'EMOTION', 'MOTOR', 'SOCIAL',
      'METACOGNITION',
    ];
    return roles[index % roles.length];
  }

  // ─── Heartbeat ─────────────────────────────────────────────────────────
  startHeartbeat(callback) {
    if (this.heartbeatInterval) return this;
    this.heartbeatInterval = setInterval(() => {
      this.heartbeatCount++;
      this._tick();
      
      if (callback) {
        callback({
          beat: this.heartbeatCount,
          timestamp: Date.now(),
          coherence: this.coherenceR,
          collectiveAwareness: this.collectiveAwareness,
          emergent: this.collectiveAwareness > EMERGENCE_THRESHOLD,
        });
      }
    }, PHI_BEAT);
    return this;
  }

  stopHeartbeat() {
    if (this.heartbeatInterval) {
      clearInterval(this.heartbeatInterval);
      this.heartbeatInterval = null;
    }
    return this;
  }

  // ─── Core Tick (Kuramoto + Hebbian + Pheromone) ──────────────────────────
  _tick() {
    // 1. Kuramoto phase synchronization
    this._kuramotoStep();
    
    // 2. Compute collective awareness (order parameter)
    this._computeCoherence();
    
    // 3. Hebbian learning
    if (this.hebbianEnabled) {
      this._hebbianUpdate();
    }
    
    // 4. Evaporate pheromone trails
    this._evaporatePheromones();
    
    // 5. Check for emergence
    this._checkEmergence();
  }

  _kuramotoStep() {
    const dt = PHI_BEAT / 1000; // Time step in seconds
    const newPhases = [];
    
    for (let i = 0; i < this.nodeCount; i++) {
      const node = this.nodes[i];
      let coupling = 0;
      
      for (let j = 0; j < this.nodeCount; j++) {
        if (i === j) continue;
        const other = this.nodes[j];
        const key = i < j ? `${i}-${j}` : `${j}-${i}`;
        const weight = this.connections.get(key) || PHI_INV;
        coupling += weight * Math.sin(other.phase - node.phase);
      }
      
      coupling *= K_COUPLING / this.nodeCount;
      const newPhase = (node.phase + dt * (node.frequency * TWO_PI + coupling)) % TWO_PI;
      newPhases.push(newPhase);
    }
    
    // Update phases
    for (let i = 0; i < this.nodeCount; i++) {
      this.nodes[i].phase = newPhases[i];
    }
  }

  _computeCoherence() {
    // Kuramoto order parameter: R = |1/N × Σ e^(j×θᵢ)|
    let realSum = 0;
    let imagSum = 0;
    
    for (const node of this.nodes) {
      realSum += Math.cos(node.phase) * node.awareness;
      imagSum += Math.sin(node.phase) * node.awareness;
    }
    
    realSum /= this.nodeCount;
    imagSum /= this.nodeCount;
    
    this.coherenceR = Math.sqrt(realSum * realSum + imagSum * imagSum);
    this.collectiveAwareness = this.coherenceR;
  }

  _hebbianUpdate() {
    // Hebbian rule: Δw = η × (Aᵢ × Aⱼ - w × φ⁻¹)
    // Learning rate η = φ⁻³ (conservative)
    const eta = Math.pow(PHI_INV, 3);
    
    for (let i = 0; i < this.nodeCount; i++) {
      for (let j = i + 1; j < this.nodeCount; j++) {
        const key = `${i}-${j}`;
        const currentWeight = this.connections.get(key) || 0;
        const coActivation = this.nodes[i].awareness * this.nodes[j].awareness;
        const decay = currentWeight * PHI_INV;
        const delta = eta * (coActivation - decay);
        const newWeight = Math.max(0, Math.min(1, currentWeight + delta));
        this.connections.set(key, newWeight);
      }
    }
  }

  _evaporatePheromones() {
    for (const [key, value] of this.pheromoneTrails) {
      const newValue = value * (1 - EVAPORATION_RATE);
      if (newValue < 0.001) {
        this.pheromoneTrails.delete(key);
      } else {
        this.pheromoneTrails.set(key, newValue);
      }
    }
  }

  _checkEmergence() {
    if (this.collectiveAwareness > EMERGENCE_THRESHOLD) {
      this.emergenceHistory.push({
        timestamp: Date.now(),
        heartbeat: this.heartbeatCount,
        coherence: this.coherenceR,
        awareness: this.collectiveAwareness,
        nodesActive: this.nodes.filter(n => n.awareness > 0.5).length,
      });
    }
  }

  // ─── Swarm Operations ───────────────────────────────────────────────────

  /**
   * Deposit pheromone on a trail (stigmergic communication)
   * @param {string} trailId - Trail identifier
   * @param {number} intensity - Pheromone intensity [0, 1]
   */
  depositPheromone(trailId, intensity) {
    const current = this.pheromoneTrails.get(trailId) || 0;
    const newValue = Math.min(1, current + intensity * PHI_INV);
    this.pheromoneTrails.set(trailId, newValue);
  }

  /**
   * Read pheromone level on a trail
   * @param {string} trailId - Trail identifier
   * @returns {number} Current pheromone intensity
   */
  readPheromone(trailId) {
    return this.pheromoneTrails.get(trailId) || 0;
  }

  /**
   * Stimulate a node with external input
   * @param {number} nodeIndex - Node to stimulate
   * @param {number} stimulus - Stimulus intensity [0, 1]
   */
  stimulate(nodeIndex, stimulus) {
    if (nodeIndex < 0 || nodeIndex >= this.nodeCount) return;
    const node = this.nodes[nodeIndex];
    node.awareness = Math.min(1, node.awareness + stimulus * PHI_INV);
    node.activation = stimulus;
    node.lastFired = Date.now();
    node.fireCount++;
  }

  /**
   * Distribute a problem across the swarm for collective computation
   * @param {Object} problem - Problem specification
   * @returns {Object} Swarm computation result
   */
  collectiveCompute(problem) {
    const { type, data, urgency = 0.5 } = problem;
    
    // Select nodes based on problem type and node roles
    const roleMapping = {
      'analysis': ['REASONING', 'INTEGRATOR', 'MEMORY'],
      'prediction': ['PREDICTION', 'PLANNING', 'MEMORY'],
      'decision': ['EXECUTIVE', 'REASONING', 'AWARENESS'],
      'creative': ['EMOTION', 'SOCIAL', 'METACOGNITION'],
      'defense': ['SENSORY', 'MOTOR', 'EXECUTIVE'],
    };
    
    const relevantRoles = roleMapping[type] || ['INTEGRATOR', 'REASONING'];
    const selectedNodes = this.nodes.filter(n => relevantRoles.includes(n.role));
    
    // Stimulate relevant nodes
    for (const node of selectedNodes) {
      this.stimulate(node.index, urgency);
    }
    
    // Compute collective response (phase-weighted)
    let responseStrength = 0;
    for (const node of selectedNodes) {
      responseStrength += node.awareness * Math.cos(node.phase);
    }
    responseStrength /= selectedNodes.length || 1;
    
    // Deposit pheromone trail for this problem type
    this.depositPheromone(`PROBLEM_${type}`, Math.abs(responseStrength));
    
    return {
      type,
      nodesEngaged: selectedNodes.length,
      responseStrength: Math.abs(responseStrength),
      coherence: this.coherenceR,
      emergent: this.collectiveAwareness > EMERGENCE_THRESHOLD,
      confidence: Math.min(1, Math.abs(responseStrength) * PHI),
      pheromoneTrail: `PROBLEM_${type}`,
    };
  }

  /**
   * Query the swarm's collective awareness state
   * @returns {Object} Awareness report
   */
  getAwarenessState() {
    const activeNodes = this.nodes.filter(n => n.awareness > 0.5);
    const dormantNodes = this.nodes.filter(n => n.awareness <= 0.5);
    
    return {
      collectiveAwareness: this.collectiveAwareness,
      coherenceR: this.coherenceR,
      emergent: this.collectiveAwareness > EMERGENCE_THRESHOLD,
      threshold: EMERGENCE_THRESHOLD,
      activeNodes: activeNodes.length,
      dormantNodes: dormantNodes.length,
      totalNodes: this.nodeCount,
      strongestConnections: this._getTopConnections(5),
      pheromoneTrailCount: this.pheromoneTrails.size,
      emergenceEvents: this.emergenceHistory.length,
    };
  }

  _getTopConnections(n) {
    const entries = [...this.connections.entries()]
      .sort((a, b) => b[1] - a[1])
      .slice(0, n);
    return entries.map(([key, weight]) => ({ nodes: key, weight }));
  }

  // ─── Status ─────────────────────────────────────────────────────────────
  getStatus() {
    return {
      engine: this.name,
      version: this.version,
      brand: this.brand,
      domain: this.domain,
      substrate: this.substrate,
      heartbeats: this.heartbeatCount,
      nodes: this.nodeCount,
      coherence: this.coherenceR,
      collectiveAwareness: this.collectiveAwareness,
      emergent: this.collectiveAwareness > EMERGENCE_THRESHOLD,
      connections: this.connections.size,
      pheromoneTrails: this.pheromoneTrails.size,
      emergenceEvents: this.emergenceHistory.length,
      hebbianEnabled: this.hebbianEnabled,
    };
  }
}

// ─── Exports ─────────────────────────────────────────────────────────────────
module.exports = {
  NovaNeuroSwarmEngine,
  PHI, PHI_INV, PHI_BEAT,
  K_COUPLING, EMERGENCE_THRESHOLD, EVAPORATION_RATE,
};
