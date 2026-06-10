/**
 * CHAOS SPINNERS — Edge-Exploring Autonomous Agents
 * Nova by FreddyCreates
 * 
 * "Spin into chaos, find the edges, bring back truth."
 * 
 * Chaos Spinners are autonomous agents that:
 * - Deploy into the system/environment
 * - Explore edges and boundaries
 * - Find fractures and weak points
 * - Return with information
 * - Learn from each spin
 * 
 * The name comes from the golden spiral (φ) — they spin outward following
 * the golden ratio, exploring exponentially larger spaces, then spiral
 * back to report their findings.
 * 
 * Types of Spinners:
 * - EDGE_SPINNER: Finds boundary conditions
 * - FRACTURE_SPINNER: Discovers weak points
 * - DEPTH_SPINNER: Explores nested structures
 * - BREADTH_SPINNER: Maps surface area
 * - CHAOS_SPINNER: Random walk exploration
 * 
 * @version 1.0.0
 * @copyright Nova Protocol by FreddyCreates
 */

import { PHI, PHI_INV, goldenSpiralPoint, FIBONACCI_SEQUENCE, GREEK } from '../engines/greek-mathematics.js';

// ═══════════════════════════════════════════════════════════════════════════
// CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════

/** Spin states */
const SPIN_STATE = {
  IDLE: 'IDLE',
  DEPLOYING: 'DEPLOYING',
  SPINNING: 'SPINNING',
  EXPLORING: 'EXPLORING',
  RETURNING: 'RETURNING',
  REPORTING: 'REPORTING',
  RECOVERED: 'RECOVERED',
  LOST: 'LOST'
};

/** Spinner types */
const SPINNER_TYPE = {
  EDGE: {
    code: 'EDGE',
    name: 'Edge Spinner',
    description: 'Finds boundary conditions and edge cases',
    maxDepth: 13,        // F7
    spinRate: PHI,       // Golden ratio spin
    returnThreshold: 0.8
  },
  FRACTURE: {
    code: 'FRAC',
    name: 'Fracture Spinner',
    description: 'Discovers weak points and vulnerabilities',
    maxDepth: 21,        // F8
    spinRate: PHI * 1.5,
    returnThreshold: 0.9
  },
  DEPTH: {
    code: 'DEEP',
    name: 'Depth Spinner',
    description: 'Explores nested structures recursively',
    maxDepth: 34,        // F9
    spinRate: PHI_INV,   // Slower, deeper
    returnThreshold: 0.7
  },
  BREADTH: {
    code: 'WIDE',
    name: 'Breadth Spinner',
    description: 'Maps surface area quickly',
    maxDepth: 8,         // F6
    spinRate: PHI * 2,   // Fast, wide
    returnThreshold: 0.6
  },
  CHAOS: {
    code: 'KAOS',
    name: 'Chaos Spinner',
    description: 'Random walk exploration for edge discovery',
    maxDepth: 55,        // F10
    spinRate: 1 + Math.random() * PHI,
    returnThreshold: 0.5
  }
};

/** Max findings per spinner */
const MAX_FINDINGS = 89;  // F11

// ═══════════════════════════════════════════════════════════════════════════
// FINDING CLASS
// ═══════════════════════════════════════════════════════════════════════════

/**
 * ChaosFindings — What a spinner discovers
 */
export class ChaosFindings {
  constructor() {
    this.edges = [];
    this.fractures = [];
    this.anomalies = [];
    this.patterns = [];
    this.dataPoints = [];
  }
  
  addEdge(location, type, severity) {
    this.edges.push({
      location,
      type,
      severity,
      foundAt: Date.now()
    });
    this._trim();
  }
  
  addFracture(location, weakness, exploitable) {
    this.fractures.push({
      location,
      weakness,
      exploitable,
      foundAt: Date.now()
    });
    this._trim();
  }
  
  addAnomaly(description, data, significance) {
    this.anomalies.push({
      description,
      data,
      significance,
      foundAt: Date.now()
    });
    this._trim();
  }
  
  addPattern(pattern, frequency, confidence) {
    this.patterns.push({
      pattern,
      frequency,
      confidence,
      foundAt: Date.now()
    });
    this._trim();
  }
  
  addDataPoint(key, value, context) {
    this.dataPoints.push({
      key,
      value,
      context,
      foundAt: Date.now()
    });
    this._trim();
  }
  
  _trim() {
    // Keep collections within bounds
    if (this.edges.length > MAX_FINDINGS) this.edges.shift();
    if (this.fractures.length > MAX_FINDINGS) this.fractures.shift();
    if (this.anomalies.length > MAX_FINDINGS) this.anomalies.shift();
    if (this.patterns.length > MAX_FINDINGS) this.patterns.shift();
    if (this.dataPoints.length > MAX_FINDINGS) this.dataPoints.shift();
  }
  
  getSummary() {
    return {
      edgeCount: this.edges.length,
      fractureCount: this.fractures.length,
      anomalyCount: this.anomalies.length,
      patternCount: this.patterns.length,
      dataPointCount: this.dataPoints.length,
      totalFindings: this.edges.length + this.fractures.length + 
                     this.anomalies.length + this.patterns.length + 
                     this.dataPoints.length
    };
  }
  
  getMostSignificant() {
    // Find the most significant finding
    const all = [
      ...this.edges.map(e => ({ type: 'edge', item: e, score: e.severity })),
      ...this.fractures.map(f => ({ type: 'fracture', item: f, score: f.exploitable ? 1 : 0.5 })),
      ...this.anomalies.map(a => ({ type: 'anomaly', item: a, score: a.significance })),
      ...this.patterns.map(p => ({ type: 'pattern', item: p, score: p.confidence }))
    ];
    
    all.sort((a, b) => b.score - a.score);
    
    return all[0] || null;
  }
  
  export() {
    return {
      edges: [...this.edges],
      fractures: [...this.fractures],
      anomalies: [...this.anomalies],
      patterns: [...this.patterns],
      dataPoints: [...this.dataPoints],
      summary: this.getSummary()
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// CHAOS SPINNER CLASS
// ═══════════════════════════════════════════════════════════════════════════

/**
 * ChaosSpinner — An autonomous exploration agent
 */
export class ChaosSpinner {
  constructor(type = SPINNER_TYPE.EDGE, config = {}) {
    this.id = config.id || `SPIN-${Date.now().toString(36)}`;
    this.type = type;
    this.config = config;
    
    // State
    this.state = SPIN_STATE.IDLE;
    this.position = { x: 0, y: 0, depth: 0 };
    this.theta = 0;  // Current angle on golden spiral
    this.spinCount = 0;
    
    // Findings
    this.findings = new ChaosFindings();
    
    // Journey tracking
    this.path = [];
    this.startTime = null;
    this.returnTime = null;
    
    // Energy (determines how long it can spin)
    this.energy = 1.0;
    this.energyDecay = config.energyDecay || 0.01;
    
    // Exploration target
    this.target = null;
    this.targetExplorer = null;  // Function to explore target
    
    // Callbacks
    this.onFinding = config.onFinding || null;
    this.onReturn = config.onReturn || null;
    this.onLost = config.onLost || null;
    
    // Metrics
    this.metrics = {
      totalSpins: 0,
      totalDistance: 0,
      findingsReported: 0,
      timeSpinning: 0,
      explorations: 0
    };
  }
  
  // ─── Deployment ────────────────────────────────────────────────────────
  
  /**
   * Deploy the spinner to explore a target
   * @param {any} target - The system/component to explore
   * @param {Function} explorer - Function(position, target) that returns findings
   */
  deploy(target, explorer) {
    if (this.state !== SPIN_STATE.IDLE && this.state !== SPIN_STATE.RECOVERED) {
      return { success: false, error: 'Spinner not available' };
    }
    
    this.target = target;
    this.targetExplorer = explorer;
    this.state = SPIN_STATE.DEPLOYING;
    this.startTime = Date.now();
    this.energy = 1.0;
    this.theta = 0;
    this.spinCount = 0;
    this.position = { x: 0, y: 0, depth: 0 };
    this.path = [{ ...this.position, timestamp: Date.now() }];
    
    // Begin spinning
    this.state = SPIN_STATE.SPINNING;
    
    return {
      success: true,
      spinnerId: this.id,
      type: this.type.code,
      startTime: this.startTime
    };
  }
  
  /**
   * Execute one spin cycle
   */
  spin() {
    if (this.state !== SPIN_STATE.SPINNING && this.state !== SPIN_STATE.EXPLORING) {
      return null;
    }
    
    this.spinCount++;
    this.metrics.totalSpins++;
    
    // Move along golden spiral
    this.theta += Math.PI / (this.type.spinRate * 4);
    const spiralPoint = goldenSpiralPoint(this.theta);
    
    // Update position
    const prevPos = { ...this.position };
    this.position = {
      x: spiralPoint.x,
      y: spiralPoint.y,
      depth: Math.floor(this.theta / (Math.PI / 2))  // Depth increases with each quarter turn
    };
    
    // Calculate distance traveled
    const dx = this.position.x - prevPos.x;
    const dy = this.position.y - prevPos.y;
    const distance = Math.sqrt(dx * dx + dy * dy);
    this.metrics.totalDistance += distance;
    
    // Record path
    this.path.push({ ...this.position, timestamp: Date.now() });
    
    // Decay energy
    this.energy -= this.energyDecay;
    
    // Explore at this position
    this.state = SPIN_STATE.EXPLORING;
    const explorationResult = this._explore();
    this.state = SPIN_STATE.SPINNING;
    
    // Check return conditions
    if (this._shouldReturn()) {
      return this.initiateReturn();
    }
    
    // Check if lost
    if (this.energy <= 0 || this.position.depth > this.type.maxDepth) {
      return this._handleLost();
    }
    
    return {
      spinnerId: this.id,
      spin: this.spinCount,
      position: { ...this.position },
      energy: this.energy,
      findings: explorationResult
    };
  }
  
  /**
   * Explore at current position
   */
  _explore() {
    this.metrics.explorations++;
    
    if (!this.targetExplorer) {
      return null;
    }
    
    try {
      const result = this.targetExplorer(this.position, this.target);
      
      if (result) {
        this._processFinding(result);
      }
      
      return result;
    } catch (error) {
      // Found an edge case! The explorer threw an error
      this.findings.addEdge(
        { ...this.position },
        'error',
        0.9
      );
      
      this.findings.addFracture(
        { ...this.position },
        error.message,
        true
      );
      
      return { type: 'error', error: error.message };
    }
  }
  
  _processFinding(result) {
    // Process different types of findings
    if (result.edge) {
      this.findings.addEdge(
        { ...this.position },
        result.edge.type,
        result.edge.severity || 0.5
      );
    }
    
    if (result.fracture) {
      this.findings.addFracture(
        { ...this.position },
        result.fracture.weakness,
        result.fracture.exploitable || false
      );
    }
    
    if (result.anomaly) {
      this.findings.addAnomaly(
        result.anomaly.description,
        result.anomaly.data,
        result.anomaly.significance || 0.5
      );
    }
    
    if (result.pattern) {
      this.findings.addPattern(
        result.pattern.pattern,
        result.pattern.frequency || 1,
        result.pattern.confidence || 0.5
      );
    }
    
    if (result.data) {
      this.findings.addDataPoint(
        result.data.key,
        result.data.value,
        result.data.context
      );
    }
    
    // Callback
    if (this.onFinding && typeof this.onFinding === 'function') {
      this.onFinding(result, this);
    }
    
    this.metrics.findingsReported++;
  }
  
  _shouldReturn() {
    // Return if we've found enough
    const summary = this.findings.getSummary();
    const findingScore = summary.totalFindings / MAX_FINDINGS;
    
    // Return if:
    // 1. Found enough significant findings
    // 2. Energy is low
    // 3. Hit return threshold based on position
    
    if (findingScore >= this.type.returnThreshold) {
      return true;
    }
    
    if (this.energy < 0.2) {
      return true;
    }
    
    // Random return based on position (further out = more likely to return)
    const returnProbability = (this.position.depth / this.type.maxDepth) * PHI_INV;
    if (Math.random() < returnProbability) {
      return true;
    }
    
    return false;
  }
  
  // ─── Return Journey ────────────────────────────────────────────────────
  
  /**
   * Begin return journey
   */
  initiateReturn() {
    this.state = SPIN_STATE.RETURNING;
    this.returnTime = Date.now();
    
    return this._return();
  }
  
  _return() {
    this.state = SPIN_STATE.REPORTING;
    
    const report = {
      spinnerId: this.id,
      type: this.type.code,
      state: this.state,
      
      // Journey stats
      journey: {
        startTime: this.startTime,
        returnTime: this.returnTime,
        duration: this.returnTime - this.startTime,
        spinCount: this.spinCount,
        maxDepth: Math.max(...this.path.map(p => p.depth)),
        totalDistance: this.metrics.totalDistance,
        pathLength: this.path.length
      },
      
      // Findings
      findings: this.findings.export(),
      
      // Most significant finding
      highlight: this.findings.getMostSignificant(),
      
      // Energy remaining
      energyRemaining: this.energy,
      
      // Metrics
      metrics: { ...this.metrics }
    };
    
    // Update time spinning
    this.metrics.timeSpinning += report.journey.duration;
    
    // Callback
    if (this.onReturn && typeof this.onReturn === 'function') {
      this.onReturn(report, this);
    }
    
    // Reset state
    this.state = SPIN_STATE.RECOVERED;
    
    return report;
  }
  
  _handleLost() {
    this.state = SPIN_STATE.LOST;
    
    const lostReport = {
      spinnerId: this.id,
      type: this.type.code,
      state: this.state,
      lastPosition: { ...this.position },
      partialFindings: this.findings.getSummary(),
      energyAtLoss: this.energy,
      spinCount: this.spinCount
    };
    
    if (this.onLost && typeof this.onLost === 'function') {
      this.onLost(lostReport, this);
    }
    
    return lostReport;
  }
  
  // ─── Status ────────────────────────────────────────────────────────────
  
  getStatus() {
    return {
      id: this.id,
      type: this.type.code,
      state: this.state,
      position: { ...this.position },
      theta: this.theta,
      spinCount: this.spinCount,
      energy: this.energy,
      findings: this.findings.getSummary(),
      metrics: { ...this.metrics }
    };
  }
  
  isAvailable() {
    return this.state === SPIN_STATE.IDLE || this.state === SPIN_STATE.RECOVERED;
  }
  
  toJSON() {
    return {
      type: 'ChaosSpinner',
      version: '1.0.0',
      ...this.getStatus()
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SPINNER FLEET — Manages multiple spinners
// ═══════════════════════════════════════════════════════════════════════════

/**
 * SpinnerFleet — Coordinates multiple chaos spinners
 */
export class SpinnerFleet {
  constructor(config = {}) {
    this.fleetId = config.fleetId || `FLEET-${Date.now().toString(36)}`;
    this.spinners = new Map();
    this.config = config;
    
    // Initialize spinners
    this._initializeFleet(config.spinnerTypes || ['EDGE', 'FRACTURE', 'DEPTH', 'BREADTH', 'CHAOS']);
    
    // Results aggregation
    this.allFindings = new ChaosFindings();
    this.missionHistory = [];
    
    // Metrics
    this.metrics = {
      missionsCompleted: 0,
      spinnersDeployed: 0,
      spinnersLost: 0,
      totalFindings: 0
    };
  }
  
  _initializeFleet(types) {
    for (const typeName of types) {
      const type = SPINNER_TYPE[typeName];
      if (type) {
        const spinner = new ChaosSpinner(type, {
          id: `${this.fleetId}-${type.code}`,
          onFinding: (result, spinner) => this._handleFinding(result, spinner),
          onReturn: (report, spinner) => this._handleReturn(report, spinner),
          onLost: (report, spinner) => this._handleLost(report, spinner)
        });
        this.spinners.set(type.code, spinner);
      }
    }
  }
  
  _handleFinding(result, spinner) {
    // Aggregate findings
    if (result.edge) {
      this.allFindings.addEdge(result.edge.location, result.edge.type, result.edge.severity);
    }
    if (result.fracture) {
      this.allFindings.addFracture(result.fracture.location, result.fracture.weakness, result.fracture.exploitable);
    }
    if (result.anomaly) {
      this.allFindings.addAnomaly(result.anomaly.description, result.anomaly.data, result.anomaly.significance);
    }
    if (result.pattern) {
      this.allFindings.addPattern(result.pattern.pattern, result.pattern.frequency, result.pattern.confidence);
    }
    if (result.data) {
      this.allFindings.addDataPoint(result.data.key, result.data.value, result.data.context);
    }
    
    this.metrics.totalFindings++;
  }
  
  _handleReturn(report, spinner) {
    this.missionHistory.push({
      spinnerId: spinner.id,
      type: spinner.type.code,
      report,
      timestamp: Date.now()
    });
    
    this.metrics.missionsCompleted++;
  }
  
  _handleLost(report, spinner) {
    this.metrics.spinnersLost++;
    
    // Create replacement spinner
    const newSpinner = new ChaosSpinner(spinner.type, {
      id: `${this.fleetId}-${spinner.type.code}-R${this.metrics.spinnersLost}`,
      onFinding: (result, s) => this._handleFinding(result, s),
      onReturn: (r, s) => this._handleReturn(r, s),
      onLost: (r, s) => this._handleLost(r, s)
    });
    
    this.spinners.set(spinner.type.code, newSpinner);
  }
  
  /**
   * Deploy all available spinners
   */
  deployAll(target, explorer) {
    const deployments = [];
    
    for (const [code, spinner] of this.spinners) {
      if (spinner.isAvailable()) {
        const result = spinner.deploy(target, explorer);
        if (result.success) {
          this.metrics.spinnersDeployed++;
          deployments.push(result);
        }
      }
    }
    
    return {
      fleetId: this.fleetId,
      deployed: deployments.length,
      deployments
    };
  }
  
  /**
   * Deploy a specific spinner type
   */
  deploySpinner(typeCode, target, explorer) {
    const spinner = this.spinners.get(typeCode);
    if (!spinner) {
      return { success: false, error: `Unknown spinner type: ${typeCode}` };
    }
    
    if (!spinner.isAvailable()) {
      return { success: false, error: `Spinner ${typeCode} not available` };
    }
    
    this.metrics.spinnersDeployed++;
    return spinner.deploy(target, explorer);
  }
  
  /**
   * Execute spin cycle on all active spinners
   */
  spinAll() {
    const results = [];
    
    for (const [code, spinner] of this.spinners) {
      if (spinner.state === SPIN_STATE.SPINNING || spinner.state === SPIN_STATE.EXPLORING) {
        const result = spinner.spin();
        results.push({ spinnerCode: code, result });
      }
    }
    
    return results;
  }
  
  /**
   * Run a complete chaos exploration mission
   */
  async runMission(target, explorer, options = {}) {
    const maxSpins = options.maxSpins || 100;
    const spinDelay = options.spinDelay || 10;
    
    // Deploy all spinners
    const deployment = this.deployAll(target, explorer);
    
    // Spin until all return or max spins reached
    let spinCount = 0;
    while (spinCount < maxSpins) {
      const activeSpinners = [...this.spinners.values()].filter(
        s => s.state === SPIN_STATE.SPINNING || s.state === SPIN_STATE.EXPLORING
      );
      
      if (activeSpinners.length === 0) break;
      
      this.spinAll();
      spinCount++;
      
      // Small delay between spins
      if (spinDelay > 0) {
        await new Promise(resolve => setTimeout(resolve, spinDelay));
      }
    }
    
    // Collect final results
    return {
      fleetId: this.fleetId,
      missionComplete: true,
      totalSpins: spinCount,
      findings: this.allFindings.export(),
      highlight: this.allFindings.getMostSignificant(),
      metrics: { ...this.metrics },
      spinnerStates: [...this.spinners.values()].map(s => s.getStatus())
    };
  }
  
  getStatus() {
    return {
      fleetId: this.fleetId,
      spinnerCount: this.spinners.size,
      spinners: [...this.spinners.values()].map(s => s.getStatus()),
      findings: this.allFindings.getSummary(),
      metrics: { ...this.metrics }
    };
  }
  
  toJSON() {
    return {
      type: 'SpinnerFleet',
      version: '1.0.0',
      ...this.getStatus()
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// EXPORTS
// ═══════════════════════════════════════════════════════════════════════════

export {
  SPIN_STATE,
  SPINNER_TYPE
};

export function createSpinner(type = 'EDGE', config = {}) {
  const spinnerType = SPINNER_TYPE[type] || SPINNER_TYPE.EDGE;
  return new ChaosSpinner(spinnerType, config);
}

export function createFleet(config = {}) {
  return new SpinnerFleet(config);
}

export default {
  SPIN_STATE,
  SPINNER_TYPE,
  ChaosFindings,
  ChaosSpinner,
  SpinnerFleet,
  createSpinner,
  createFleet
};
