/**
 * MONTE CARLO SIMULATION ENGINE — Probabilistic Reality Testing
 * Nova by FreddyCreates
 * 
 * "Test a thousand futures to prepare for one reality."
 * 
 * This engine runs Monte Carlo simulations to:
 * - Simulate virtual user interactions with UI
 * - Test token economics and market behavior
 * - Explore possible system states
 * - Find edge cases through random exploration
 * - Validate system behavior under uncertainty
 * 
 * Monte Carlo Method:
 * - Generate random samples from probability distributions
 * - Run many simulations to estimate outcomes
 * - Analyze statistical properties of results
 * - Identify tail risks and edge cases
 * 
 * @version 1.0.0
 * @copyright Nova Protocol by FreddyCreates
 */

import { PHI, PHI_INV, GREEK, shannonEntropy, approximateEntropy } from '../engines/greek-mathematics.js';

// ═══════════════════════════════════════════════════════════════════════════
// CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════

/** Default simulation count */
const DEFAULT_SIMULATIONS = 1000;

/** Confidence levels */
const CONFIDENCE_LEVELS = {
  LOW: 0.90,
  STANDARD: 0.95,
  HIGH: 0.99
};

/** Distribution types */
const DISTRIBUTION = {
  UNIFORM: 'uniform',
  NORMAL: 'normal',
  EXPONENTIAL: 'exponential',
  POISSON: 'poisson',
  PARETO: 'pareto',
  BETA: 'beta',
  PHI_WEIGHTED: 'phi_weighted'  // Custom: Golden ratio weighted
};

// ═══════════════════════════════════════════════════════════════════════════
// RANDOM GENERATORS
// ═══════════════════════════════════════════════════════════════════════════

/**
 * Box-Muller transform for normal distribution
 */
function boxMuller() {
  let u = 0, v = 0;
  while (u === 0) u = Math.random();
  while (v === 0) v = Math.random();
  return Math.sqrt(-2.0 * Math.log(u)) * Math.cos(2.0 * Math.PI * v);
}

/**
 * Generate random number from distribution
 */
function randomFromDistribution(distribution, params = {}) {
  switch (distribution) {
    case DISTRIBUTION.UNIFORM:
      const { min = 0, max = 1 } = params;
      return min + Math.random() * (max - min);
    
    case DISTRIBUTION.NORMAL:
      const { mean = 0, stddev = 1 } = params;
      return mean + boxMuller() * stddev;
    
    case DISTRIBUTION.EXPONENTIAL:
      const { lambda = 1 } = params;
      return -Math.log(1 - Math.random()) / lambda;
    
    case DISTRIBUTION.POISSON:
      const { rate = 1 } = params;
      let L = Math.exp(-rate);
      let k = 0;
      let p = 1;
      do {
        k++;
        p *= Math.random();
      } while (p > L);
      return k - 1;
    
    case DISTRIBUTION.PARETO:
      const { alpha = 1, xm = 1 } = params;
      return xm / Math.pow(Math.random(), 1 / alpha);
    
    case DISTRIBUTION.BETA:
      const { a = 2, b = 2 } = params;
      // Simplified beta using ratio of gammas
      const gammaA = randomFromDistribution(DISTRIBUTION.EXPONENTIAL, { lambda: 1 / a });
      const gammaB = randomFromDistribution(DISTRIBUTION.EXPONENTIAL, { lambda: 1 / b });
      return gammaA / (gammaA + gammaB);
    
    case DISTRIBUTION.PHI_WEIGHTED:
      // Custom: Sample weighted by golden ratio
      const base = Math.random();
      return base < PHI_INV ? base * PHI : base / PHI;
    
    default:
      return Math.random();
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// STATISTICS HELPERS
// ═══════════════════════════════════════════════════════════════════════════

function mean(arr) {
  return arr.reduce((a, b) => a + b, 0) / arr.length;
}

function variance(arr) {
  const m = mean(arr);
  return arr.reduce((sum, x) => sum + Math.pow(x - m, 2), 0) / arr.length;
}

function stddev(arr) {
  return Math.sqrt(variance(arr));
}

function percentile(arr, p) {
  const sorted = [...arr].sort((a, b) => a - b);
  const idx = Math.ceil((p / 100) * sorted.length) - 1;
  return sorted[Math.max(0, idx)];
}

function median(arr) {
  return percentile(arr, 50);
}

function confidenceInterval(arr, level = 0.95) {
  const m = mean(arr);
  const s = stddev(arr);
  const n = arr.length;
  const z = level === 0.99 ? 2.576 : level === 0.90 ? 1.645 : 1.96;
  const margin = z * (s / Math.sqrt(n));
  
  return {
    mean: m,
    lower: m - margin,
    upper: m + margin,
    margin,
    level
  };
}

// ═══════════════════════════════════════════════════════════════════════════
// MONTE CARLO SIMULATION CLASS
// ═══════════════════════════════════════════════════════════════════════════

/**
 * MonteCarloSimulation — Run probabilistic simulations
 */
export class MonteCarloSimulation {
  constructor(config = {}) {
    this.simulationCount = config.simulations || DEFAULT_SIMULATIONS;
    this.seed = config.seed || Date.now();
    
    // Results storage
    this.results = [];
    this.statistics = null;
    
    // Progress tracking
    this.progress = 0;
    this.running = false;
    
    // Metrics
    this.metrics = {
      totalSimulations: 0,
      totalTime: 0,
      averageTime: 0,
      edgeCasesFound: 0
    };
  }
  
  /**
   * Run simulation with a simulator function
   * @param {Function} simulator - Function that returns a simulation result
   * @param {Object} options - Simulation options
   */
  async run(simulator, options = {}) {
    const count = options.simulations || this.simulationCount;
    const progressCallback = options.onProgress;
    
    this.results = [];
    this.running = true;
    this.progress = 0;
    
    const startTime = Date.now();
    
    for (let i = 0; i < count; i++) {
      try {
        const result = simulator(i, count);
        this.results.push(result);
      } catch (error) {
        // Edge case found!
        this.results.push({
          error: true,
          message: error.message,
          iteration: i
        });
        this.metrics.edgeCasesFound++;
      }
      
      this.progress = (i + 1) / count;
      
      if (progressCallback && i % Math.ceil(count / 100) === 0) {
        progressCallback(this.progress, i, count);
      }
      
      // Yield to event loop periodically
      if (i % 100 === 0) {
        await new Promise(resolve => setImmediate ? setImmediate(resolve) : setTimeout(resolve, 0));
      }
    }
    
    const endTime = Date.now();
    this.metrics.totalSimulations += count;
    this.metrics.totalTime += (endTime - startTime);
    this.metrics.averageTime = this.metrics.totalTime / this.metrics.totalSimulations;
    
    this.running = false;
    
    // Compute statistics
    this.statistics = this._computeStatistics();
    
    return {
      results: this.results,
      statistics: this.statistics,
      metrics: { ...this.metrics },
      duration: endTime - startTime
    };
  }
  
  _computeStatistics() {
    // Extract numeric results
    const numericResults = this.results
      .filter(r => typeof r === 'number')
      .map(r => r);
    
    if (numericResults.length === 0) {
      // Handle non-numeric results
      return this._computeNonNumericStatistics();
    }
    
    return {
      count: numericResults.length,
      min: Math.min(...numericResults),
      max: Math.max(...numericResults),
      mean: mean(numericResults),
      median: median(numericResults),
      stddev: stddev(numericResults),
      variance: variance(numericResults),
      ci90: confidenceInterval(numericResults, 0.90),
      ci95: confidenceInterval(numericResults, 0.95),
      ci99: confidenceInterval(numericResults, 0.99),
      percentiles: {
        p1: percentile(numericResults, 1),
        p5: percentile(numericResults, 5),
        p10: percentile(numericResults, 10),
        p25: percentile(numericResults, 25),
        p75: percentile(numericResults, 75),
        p90: percentile(numericResults, 90),
        p95: percentile(numericResults, 95),
        p99: percentile(numericResults, 99)
      },
      errors: this.results.filter(r => r && r.error).length
    };
  }
  
  _computeNonNumericStatistics() {
    // Count occurrences of each result type
    const counts = new Map();
    
    for (const result of this.results) {
      const key = JSON.stringify(result);
      counts.set(key, (counts.get(key) || 0) + 1);
    }
    
    const entries = [...counts.entries()]
      .map(([key, count]) => ({
        value: JSON.parse(key),
        count,
        probability: count / this.results.length
      }))
      .sort((a, b) => b.count - a.count);
    
    return {
      count: this.results.length,
      uniqueOutcomes: counts.size,
      distribution: entries.slice(0, 20),  // Top 20
      entropy: shannonEntropy(entries.map(e => e.probability)),
      errors: this.results.filter(r => r && r.error).length
    };
  }
  
  /**
   * Analyze results for specific conditions
   */
  analyze(condition) {
    const matching = this.results.filter(condition);
    const probability = matching.length / this.results.length;
    
    return {
      matches: matching.length,
      total: this.results.length,
      probability,
      percentile: probability * 100,
      confidence: confidenceInterval(
        this.results.map(r => condition(r) ? 1 : 0),
        0.95
      )
    };
  }
  
  /**
   * Find edge cases (extreme values)
   */
  findEdgeCases(threshold = 0.05) {
    if (this.statistics && this.statistics.percentiles) {
      const lower = this.statistics.percentiles.p5;
      const upper = this.statistics.percentiles.p95;
      
      return this.results.filter(r => {
        if (typeof r === 'number') {
          return r < lower || r > upper;
        }
        return r && r.error;
      });
    }
    
    return this.results.filter(r => r && r.error);
  }
  
  toJSON() {
    return {
      type: 'MonteCarloSimulation',
      version: '1.0.0',
      simulationCount: this.simulationCount,
      progress: this.progress,
      running: this.running,
      statistics: this.statistics,
      metrics: { ...this.metrics }
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// VIRTUAL USER SIMULATOR
// ═══════════════════════════════════════════════════════════════════════════

/**
 * VirtualUser — Simulates user interactions with UI
 */
export class VirtualUser {
  constructor(config = {}) {
    this.userId = config.userId || `USER-${Date.now().toString(36)}`;
    this.behavior = config.behavior || 'random';
    
    // User characteristics
    this.patience = config.patience || randomFromDistribution(DISTRIBUTION.NORMAL, { mean: 0.5, stddev: 0.2 });
    this.expertise = config.expertise || randomFromDistribution(DISTRIBUTION.BETA, { a: 2, b: 5 });
    this.clickRate = config.clickRate || randomFromDistribution(DISTRIBUTION.NORMAL, { mean: 1, stddev: 0.3 });
    
    // Session state
    this.sessionStart = Date.now();
    this.actions = [];
    this.errors = [];
    this.abandonmentRisk = 0;
  }
  
  /**
   * Simulate interacting with a UI element
   */
  interact(element) {
    const action = {
      userId: this.userId,
      element: element.id || element.name,
      type: element.type,
      timestamp: Date.now(),
      success: true,
      latency: 0
    };
    
    // Simulate latency (exponential with patience factor)
    action.latency = randomFromDistribution(DISTRIBUTION.EXPONENTIAL, { 
      lambda: this.clickRate / this.patience 
    }) * 1000;
    
    // Check for errors based on expertise and element complexity
    const errorChance = (element.complexity || 0.1) * (1 - this.expertise);
    if (Math.random() < errorChance) {
      action.success = false;
      action.error = 'user_error';
      this.errors.push(action);
      this.abandonmentRisk += 0.1;
    }
    
    // Check for UI errors (element bugs)
    if (element.bugProbability && Math.random() < element.bugProbability) {
      action.success = false;
      action.error = 'ui_bug';
      action.bugType = element.potentialBugs?.[0] || 'unknown';
      this.errors.push(action);
      this.abandonmentRisk += 0.2;
    }
    
    // Patience decay
    if (!action.success) {
      this.patience *= 0.9;
    }
    
    this.actions.push(action);
    
    return action;
  }
  
  /**
   * Decide whether to abandon session
   */
  shouldAbandon() {
    const baseRisk = this.abandonmentRisk;
    const patienceRisk = 1 - this.patience;
    const totalRisk = (baseRisk + patienceRisk) / 2;
    
    return Math.random() < totalRisk;
  }
  
  /**
   * Get session summary
   */
  getSessionSummary() {
    return {
      userId: this.userId,
      sessionDuration: Date.now() - this.sessionStart,
      totalActions: this.actions.length,
      successfulActions: this.actions.filter(a => a.success).length,
      errors: this.errors.length,
      averageLatency: this.actions.length > 0 
        ? this.actions.reduce((sum, a) => sum + a.latency, 0) / this.actions.length 
        : 0,
      abandonmentRisk: this.abandonmentRisk,
      patience: this.patience,
      expertise: this.expertise
    };
  }
}

/**
 * VirtualUIEnvironment — A simulated UI for testing
 */
export class VirtualUIEnvironment {
  constructor(config = {}) {
    this.envId = config.envId || `ENV-${Date.now().toString(36)}`;
    this.elements = new Map();
    this.interactions = [];
    
    // Initialize with config or defaults
    this._initializeElements(config.elements || this._defaultElements());
  }
  
  _defaultElements() {
    return [
      { id: 'btn-primary', name: 'Primary Button', type: 'button', complexity: 0.1, bugProbability: 0.01 },
      { id: 'btn-secondary', name: 'Secondary Button', type: 'button', complexity: 0.1, bugProbability: 0.02 },
      { id: 'input-text', name: 'Text Input', type: 'input', complexity: 0.2, bugProbability: 0.03 },
      { id: 'input-email', name: 'Email Input', type: 'input', complexity: 0.3, bugProbability: 0.05 },
      { id: 'select-dropdown', name: 'Dropdown', type: 'select', complexity: 0.25, bugProbability: 0.04 },
      { id: 'checkbox-terms', name: 'Terms Checkbox', type: 'checkbox', complexity: 0.15, bugProbability: 0.02 },
      { id: 'form-submit', name: 'Submit Form', type: 'submit', complexity: 0.4, bugProbability: 0.08, potentialBugs: ['validation_error', 'timeout', 'server_error'] },
      { id: 'nav-home', name: 'Home Navigation', type: 'link', complexity: 0.05, bugProbability: 0.01 },
      { id: 'nav-settings', name: 'Settings Navigation', type: 'link', complexity: 0.1, bugProbability: 0.02 },
      { id: 'modal-close', name: 'Close Modal', type: 'button', complexity: 0.15, bugProbability: 0.03 }
    ];
  }
  
  _initializeElements(elements) {
    for (const el of elements) {
      this.elements.set(el.id, el);
    }
  }
  
  getElement(id) {
    return this.elements.get(id);
  }
  
  getRandomElement() {
    const keys = [...this.elements.keys()];
    const randomKey = keys[Math.floor(Math.random() * keys.length)];
    return this.elements.get(randomKey);
  }
  
  recordInteraction(action) {
    this.interactions.push(action);
  }
  
  getMetrics() {
    const successCount = this.interactions.filter(i => i.success).length;
    
    return {
      totalInteractions: this.interactions.length,
      successRate: this.interactions.length > 0 
        ? successCount / this.interactions.length 
        : 1,
      errorRate: this.interactions.length > 0 
        ? (this.interactions.length - successCount) / this.interactions.length 
        : 0,
      uniqueElements: new Set(this.interactions.map(i => i.element)).size,
      averageLatency: this.interactions.length > 0 
        ? this.interactions.reduce((sum, i) => sum + (i.latency || 0), 0) / this.interactions.length 
        : 0
    };
  }
}

/**
 * UIChaosTester — Monte Carlo testing of virtual UI
 */
export class UIChaosTester {
  constructor(config = {}) {
    this.testerId = config.testerId || `UITEST-${Date.now().toString(36)}`;
    this.environment = new VirtualUIEnvironment(config.environment);
    this.simulation = new MonteCarloSimulation({ simulations: config.simulations || 1000 });
    
    // Results
    this.testResults = [];
  }
  
  /**
   * Run a UI chaos test with simulated users
   */
  async runTest(options = {}) {
    const userCount = options.users || 100;
    const actionsPerUser = options.actionsPerUser || 10;
    
    const simulator = (iteration) => {
      // Create virtual user
      const user = new VirtualUser({ userId: `user-${iteration}` });
      
      // Simulate user journey
      for (let i = 0; i < actionsPerUser; i++) {
        if (user.shouldAbandon()) {
          return {
            userId: user.userId,
            abandoned: true,
            actionsCompleted: i,
            summary: user.getSessionSummary()
          };
        }
        
        const element = this.environment.getRandomElement();
        const action = user.interact(element);
        this.environment.recordInteraction(action);
      }
      
      return {
        userId: user.userId,
        abandoned: false,
        actionsCompleted: actionsPerUser,
        summary: user.getSessionSummary()
      };
    };
    
    const results = await this.simulation.run(simulator, { simulations: userCount });
    
    // Analyze results
    const abandonmentRate = this.simulation.analyze(r => r.abandoned).probability;
    const avgActionsCompleted = mean(results.results.map(r => r.actionsCompleted));
    
    this.testResults.push({
      timestamp: Date.now(),
      userCount,
      actionsPerUser,
      abandonmentRate,
      avgActionsCompleted,
      envMetrics: this.environment.getMetrics(),
      statistics: results.statistics
    });
    
    return {
      testerId: this.testerId,
      abandonmentRate,
      avgActionsCompleted,
      envMetrics: this.environment.getMetrics(),
      edgeCases: this.simulation.findEdgeCases(),
      fullResults: results
    };
  }
  
  toJSON() {
    return {
      type: 'UIChaosTester',
      version: '1.0.0',
      testerId: this.testerId,
      testCount: this.testResults.length,
      lastTest: this.testResults[this.testResults.length - 1]
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// EXPORTS
// ═══════════════════════════════════════════════════════════════════════════

export {
  DISTRIBUTION,
  CONFIDENCE_LEVELS,
  randomFromDistribution,
  mean,
  variance,
  stddev,
  percentile,
  median,
  confidenceInterval
};

export function createSimulation(config = {}) {
  return new MonteCarloSimulation(config);
}

export function createUITester(config = {}) {
  return new UIChaosTester(config);
}

export default {
  DISTRIBUTION,
  CONFIDENCE_LEVELS,
  MonteCarloSimulation,
  VirtualUser,
  VirtualUIEnvironment,
  UIChaosTester,
  createSimulation,
  createUITester,
  // Statistical helpers
  randomFromDistribution,
  mean,
  variance,
  stddev,
  percentile,
  median,
  confidenceInterval
};
