/**
 * ╔═══════════════════════════════════════════════════════════════════════════════╗
 * ║  ALPHA MIND SDK — Embeddable Warfare Intelligence Module                     ║
 * ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.       ║
 * ╠═══════════════════════════════════════════════════════════════════════════════╣
 * ║                                                                               ║
 * ║  Five minds. One brain. Infinite hosts.                                       ║
 * ║                                                                               ║
 * ║  This SDK embeds the Alpha Mind into ANY digital entity:                      ║
 * ║    • Digital Avatars          • Autonomous Drones                             ║
 * ║    • Antivirus Engines        • Cyber Defense Platforms                       ║
 * ║    • Swarm Nodes              • Infrastructure Guardians                      ║
 * ║    • Orbital Assets           • Any Digital Entity                            ║
 * ║                                                                               ║
 * ║  COGNITIVE DOMAINS:                                                           ║
 * ║    1. HACKER MIND     — Exploit intuition, zero-day discovery                 ║
 * ║    2. GENERAL MIND    — Theater command, force projection                     ║
 * ║    3. STRATEGIST MIND — Game theory, deception, long planning                 ║
 * ║    4. PILOT MIND      — Spatial awareness, reaction speed                     ║
 * ║    5. AI INTELLIGENCE — Pattern recognition, prediction, swarm sync           ║
 * ║                                                                               ║
 * ╚═══════════════════════════════════════════════════════════════════════════════╝
 */

// ═══════════════════════════════════════════════════════════════════════════════
// CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

const PHI = 1.618033988749895;
const PHI_INV = 0.618033988749895;
const TWO_PI = 6.28318530717958647692;

const DOMAIN_WEIGHTS = Object.freeze({
  hacker: 0.236,
  general: 0.236,
  strategist: 0.191,
  pilot: 0.146,
  aiIntel: 0.191,
});

const DEPLOYMENT_TARGETS = Object.freeze([
  'digital-avatar',
  'autonomous-drone',
  'antivirus-engine',
  'cyber-defense',
  'swarm-node',
  'infra-guardian',
  'orbital-asset',
  'universal-entity',
]);

const THREAT_CLASSES = Object.freeze([
  'zero-day',
  'apt',
  'kinetic-strike',
  'electronic-warfare',
  'ai-adversary',
  'insider',
  'supply-chain',
  'swarm',
]);

// ═══════════════════════════════════════════════════════════════════════════════
// ALPHA MIND CLASS — THE EMBEDDABLE BRAIN
// ═══════════════════════════════════════════════════════════════════════════════

class AlphaMind {
  /**
   * Create a new Alpha Mind instance for embedding.
   *
   * @param {object} config
   * @param {string} config.mindId          Unique identifier for this mind
   * @param {string} config.targetType      Deployment target (see DEPLOYMENT_TARGETS)
   * @param {number} config.personalitySeed Deterministic personality seed
   * @param {number} config.aggression      Offense bias (0.0=defense, 1.0=offense)
   * @param {number} config.autonomy        Autonomy level (0.0=human-in-loop, 1.0=full auto)
   * @param {boolean} config.swarmEnabled   Whether this mind can join a collective
   * @param {string} config.loyaltyAnchor   Operator/principal this mind serves
   * @param {number} config.memoryDepth     How many events to remember
   */
  constructor(config = {}) {
    if (!config.mindId) throw new Error('AlphaMind: mindId is required');
    if (!config.targetType) throw new Error('AlphaMind: targetType is required');

    this.config = {
      mindId: config.mindId,
      targetType: config.targetType,
      personalitySeed: config.personalitySeed || Date.now(),
      aggression: config.aggression ?? 0.5,
      autonomy: config.autonomy ?? 0.7,
      swarmEnabled: config.swarmEnabled ?? true,
      loyaltyAnchor: config.loyaltyAnchor || 'sovereign',
      memoryDepth: config.memoryDepth || 1000,
    };

    // Internal state
    this.state = {
      alertLevel: 0.1,
      cognitiveLoad: 0.0,
      dominantDomain: 'aiIntel',
      activations: { hacker: 0.2, general: 0.2, strategist: 0.2, pilot: 0.2, aiIntel: 0.8 },
      phase: 0.0,
      coherence: 0.0,
      heartbeatMs: Math.round(539 * PHI), // ≈ 872ms golden heartbeat
      decisionsPerSecond: 0,
      threatQueue: [],
      strategies: [],
      personality: {
        aggressionBias: this.config.aggression,
        patienceHorizon: 1.0 - this.config.aggression,
        deceptionAffinity: 0.5,
        loyaltyStrength: 1.0,
      },
    };

    this.bootTime = Date.now();
    this.tickCount = 0;
    this.threatsNeutralized = 0;
    this._interval = null;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // LIFECYCLE
  // ═══════════════════════════════════════════════════════════════════════════

  /** Start the Alpha Mind heartbeat loop */
  start() {
    if (this._interval) return this;
    this._interval = setInterval(() => this._tick(), this.state.heartbeatMs);
    return this;
  }

  /** Stop the Alpha Mind */
  stop() {
    if (this._interval) {
      clearInterval(this._interval);
      this._interval = null;
    }
    return this;
  }

  /** Check if running */
  get isRunning() {
    return this._interval !== null;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // CORE COGNITIVE FUSION
  // ═══════════════════════════════════════════════════════════════════════════

  /**
   * Fuse all five cognitive domains into a single decision value.
   * This is the HEART of the Alpha Mind.
   */
  fuseCognition(signals) {
    const { hacker = 0, general = 0, strategist = 0, pilot = 0, aiIntel = 0 } = signals;
    const urgency = this.state.alertLevel ** 2;

    // Dynamic weights: urgency shifts power to fast-reaction domains
    const w = {
      hacker: DOMAIN_WEIGHTS.hacker + urgency * 0.1,
      general: DOMAIN_WEIGHTS.general - urgency * 0.05,
      strategist: DOMAIN_WEIGHTS.strategist - urgency * 0.05,
      pilot: DOMAIN_WEIGHTS.pilot + urgency * 0.1,
      aiIntel: DOMAIN_WEIGHTS.aiIntel,
    };

    const fused = hacker * w.hacker + general * w.general +
                  strategist * w.strategist + pilot * w.pilot + aiIntel * w.aiIntel;

    return Math.max(0, Math.min(1, fused));
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // INDIVIDUAL COGNITIVE DOMAINS
  // ═══════════════════════════════════════════════════════════════════════════

  /** Hacker Mind: Evaluate attack surface */
  hackerAnalyze({ surfaceComplexity = 0, knownVulns = 0, patchAgeDays = 0, segmentation = 0.5 } = {}) {
    const complexityScore = surfaceComplexity * PHI_INV;
    const vulnScore = knownVulns * 0.1;
    const ageScore = patchAgeDays / 365;
    const segScore = (1 - segmentation) * 0.8;
    return Math.max(0, Math.min(1, (complexityScore + vulnScore + ageScore + segScore) / 4));
  }

  /** General Mind: Assess force balance */
  generalAssess({ friendly = 1, enemy = 1, supply = 0.8, morale = 0.8, terrain = 0.5 } = {}) {
    const friendlyPower = friendly * friendly * morale * terrain;
    const enemyPower = enemy * enemy;
    const sustained = friendlyPower * supply;
    const ratio = enemyPower > 0 ? sustained / enemyPower : 10;
    if (ratio >= 3) return 0.95;
    if (ratio >= 2) return 0.75;
    if (ratio >= 1) return 0.50;
    if (ratio >= 0.5) return 0.25;
    return 0.10;
  }

  /** Strategist Mind: Game theory decision */
  strategistPlan({ payoffs = [], deceptionCost = 0.5, horizonMoves = 3 } = {}) {
    const bestMin = payoffs.length > 0 ? Math.max(...payoffs) : 0.5;
    const deceptionBonus = deceptionCost < 0.5 ? (1 - deceptionCost) * 0.2 * horizonMoves : 0;
    return Math.max(0, Math.min(1, bestMin + deceptionBonus));
  }

  /** Pilot Mind: Reaction and evasion priority */
  pilotReact({ bearing = 0, range = 1, closure = 0.5, mobility = 0.7, threats = 1 } = {}) {
    const tti = closure > 0 ? range / closure : 1000;
    const geometry = (Math.cos(bearing) + 1) / 2;
    const difficulty = 1 - (mobility / (1 + threats));
    const priority = (1 / (tti + 0.01)) * 0.4 + geometry * 0.3 + difficulty * 0.3;
    return Math.max(0, Math.min(1, priority));
  }

  /** AI Intelligence: Pattern prediction */
  aiPredict({ history = [], noveltyThreshold = 0.3, peers = 1, decay = 0.1 } = {}) {
    if (history.length === 0) return 0.5;
    let weightedSum = 0, weightTotal = 0;
    for (let i = 0; i < history.length; i++) {
      const age = history.length - i - 1;
      const weight = Math.exp(-age * decay);
      weightedSum += history[i] * weight;
      weightTotal += weight;
    }
    const predicted = weightTotal > 0 ? weightedSum / weightTotal : 0.5;
    const swarmBonus = Math.log(peers + 1) * 0.05;
    return Math.max(0, Math.min(1, predicted + swarmBonus));
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DEPLOYMENT-SPECIFIC INTERFACES
  // ═══════════════════════════════════════════════════════════════════════════

  /** Antivirus: Scan for malicious intent */
  antivirusScan({ entropy = 0, apiAnomalies = 0, networkDeviation = 0, signatureMatch = 0, drift = 0 } = {}) {
    const hackerSignal = this.hackerAnalyze({ surfaceComplexity: entropy, knownVulns: apiAnomalies, segmentation: 1 - networkDeviation });
    const aiSignal = this.aiPredict({ history: [signatureMatch, drift, entropy], decay: 0.1 });
    const generalSignal = (apiAnomalies > 10 && networkDeviation > 0.7) ? 0.9 : 0.3;
    return this.fuseCognition({ hacker: hackerSignal, general: generalSignal, strategist: 0.5, pilot: 0.3, aiIntel: aiSignal });
  }

  /** Drone: Autonomous engagement decision */
  droneDecision({ targetConfidence = 0, friendlyDist = 1, weaponState = 1, missionPriority = 0.5, roe = 0.5 } = {}) {
    const pilot = this.pilotReact({ range: friendlyDist, closure: 0.5, mobility: weaponState });
    const general = this.generalAssess({ friendly: weaponState, enemy: 1 - targetConfidence, morale: missionPriority, terrain: friendlyDist });
    const strategist = this.strategistPlan({ payoffs: [targetConfidence, missionPriority], deceptionCost: 0.3, horizonMoves: 3 });
    const ai = this.aiPredict({ history: [targetConfidence, weaponState, missionPriority], peers: 5, decay: 0.05 });
    const hacker = this.hackerAnalyze({ surfaceComplexity: 1 - targetConfidence, segmentation: friendlyDist });
    return this.fuseCognition({ hacker, general, strategist, pilot, aiIntel: ai });
  }

  /** Avatar: Social interaction response */
  avatarRespond({ interaction = 0.5, trust = 0.5, infoValue = 0.5, deception = 0, consensus = 0.5 } = {}) {
    const strategist = this.strategistPlan({ payoffs: [trust, infoValue], deceptionCost: deception, horizonMoves: 5 });
    const ai = this.aiPredict({ history: [interaction, trust, deception], peers: 3, decay: 0.2 });
    const general = this.generalAssess({ friendly: trust, enemy: deception, supply: 0.9, morale: 0.8, terrain: consensus });
    const hacker = this.hackerAnalyze({ surfaceComplexity: 1 - trust, segmentation: interaction });
    return this.fuseCognition({ hacker, general, strategist, pilot: 0.3, aiIntel: ai });
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SWARM SYNCHRONIZATION
  // ═══════════════════════════════════════════════════════════════════════════

  /** Synchronize phase with peer Alpha Minds */
  syncWithPeers(peerPhases = []) {
    if (!this.config.swarmEnabled || peerPhases.length === 0) return this.state.phase;
    let delta = 0;
    for (const peer of peerPhases) {
      delta += Math.sin(peer - this.state.phase);
    }
    const meanDelta = delta / peerPhases.length;
    this.state.phase += PHI_INV * meanDelta;
    this.state.phase = ((this.state.phase % TWO_PI) + TWO_PI) % TWO_PI;
    this.state.coherence = this._calcCoherence([this.state.phase, ...peerPhases]);
    return this.state.phase;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // THREAT PROCESSING
  // ═══════════════════════════════════════════════════════════════════════════

  /** Submit a threat for the Alpha Mind to assess */
  assessThreat(threat = {}) {
    const { classification = 'zero-day', severity = 0.5, timeToImpact = 5000 } = threat;

    // Determine who leads
    const dominant = this._determineDominant(classification, severity, timeToImpact);

    // Update alert level
    this.state.alertLevel = Math.min(1, this.state.alertLevel * 0.7 + severity * 0.3);
    this.state.dominantDomain = dominant;

    // Generate fused assessment
    const fusedScore = this.fuseCognition({
      hacker: this.hackerAnalyze({ surfaceComplexity: severity }),
      general: this.generalAssess({ enemy: severity }),
      strategist: this.strategistPlan({ payoffs: [1 - severity], horizonMoves: 5 }),
      pilot: this.pilotReact({ range: timeToImpact / 10000, closure: severity }),
      aiIntel: this.aiPredict({ history: [severity], peers: 3 }),
    });

    const assessment = { ...threat, dominant, fusedScore, timestamp: Date.now() };
    this.state.threatQueue.push(assessment);
    if (this.state.threatQueue.length > this.config.memoryDepth) {
      this.state.threatQueue.shift();
    }

    return assessment;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // INTERNAL METHODS
  // ═══════════════════════════════════════════════════════════════════════════

  _tick() {
    this.tickCount++;
    // Decay alert level naturally
    this.state.alertLevel *= 0.98;
    // Update decisions/sec
    const elapsed = Date.now() - this.bootTime;
    this.state.decisionsPerSecond = elapsed > 0 ? (this.tickCount * 1000) / elapsed : 0;
  }

  _determineDominant(classification, severity, timeToImpact) {
    if (timeToImpact < 500) return 'pilot';
    if (timeToImpact < 5000) {
      if (classification === 'zero-day') return 'hacker';
      if (classification === 'electronic-warfare') return 'pilot';
      if (classification === 'ai-adversary') return 'aiIntel';
      return 'general';
    }
    const map = {
      'zero-day': 'hacker', 'apt': 'strategist', 'kinetic-strike': 'general',
      'electronic-warfare': 'pilot', 'ai-adversary': 'aiIntel', 'insider': 'strategist',
      'supply-chain': 'hacker', 'swarm': 'aiIntel',
    };
    return map[classification] || 'aiIntel';
  }

  _calcCoherence(phases) {
    if (phases.length === 0) return 0;
    let sumCos = 0, sumSin = 0;
    for (const theta of phases) {
      sumCos += Math.cos(theta);
      sumSin += Math.sin(theta);
    }
    const mc = sumCos / phases.length;
    const ms = sumSin / phases.length;
    return Math.sqrt(mc * mc + ms * ms);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SDK METADATA
  // ═══════════════════════════════════════════════════════════════════════════

  static get VERSION() { return '1.0.0'; }
  static get NAME() { return 'ALPHA-MIND-WARFARE-SDK'; }
  static get CODENAME() { return 'ARCHON'; }
  static get DOCTRINE() { return 'Five Minds, One Brain, Infinite Hosts'; }
  static get DEPLOYMENT_TARGETS() { return DEPLOYMENT_TARGETS; }
  static get THREAT_CLASSES() { return THREAT_CLASSES; }

  getManifest() {
    return {
      version: AlphaMind.VERSION,
      name: AlphaMind.NAME,
      codename: AlphaMind.CODENAME,
      doctrine: AlphaMind.DOCTRINE,
      cognitiveDomains: 5,
      deploymentTargets: 8,
      threatClasses: 8,
      embeddingProtocol: 'KURAMOTO-PHI-LOCK',
      mindId: this.config.mindId,
      targetType: this.config.targetType,
      uptime: Date.now() - this.bootTime,
      tickCount: this.tickCount,
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// FACTORY FUNCTIONS — Quick deployment presets
// ═══════════════════════════════════════════════════════════════════════════════

/** Create an Alpha Mind optimized for drone deployment */
AlphaMind.forDrone = (id, opts = {}) => new AlphaMind({
  mindId: id, targetType: 'autonomous-drone', aggression: 0.7,
  autonomy: 0.9, swarmEnabled: true, ...opts,
});

/** Create an Alpha Mind optimized for antivirus deployment */
AlphaMind.forAntivirus = (id, opts = {}) => new AlphaMind({
  mindId: id, targetType: 'antivirus-engine', aggression: 0.4,
  autonomy: 1.0, swarmEnabled: true, ...opts,
});

/** Create an Alpha Mind optimized for digital avatar */
AlphaMind.forAvatar = (id, opts = {}) => new AlphaMind({
  mindId: id, targetType: 'digital-avatar', aggression: 0.3,
  autonomy: 0.6, swarmEnabled: false, ...opts,
});

/** Create an Alpha Mind optimized for cyber defense */
AlphaMind.forCyberDefense = (id, opts = {}) => new AlphaMind({
  mindId: id, targetType: 'cyber-defense', aggression: 0.5,
  autonomy: 0.8, swarmEnabled: true, ...opts,
});

/** Create an Alpha Mind optimized for swarm node */
AlphaMind.forSwarm = (id, opts = {}) => new AlphaMind({
  mindId: id, targetType: 'swarm-node', aggression: 0.6,
  autonomy: 0.95, swarmEnabled: true, ...opts,
});

export default AlphaMind;
export { AlphaMind, DEPLOYMENT_TARGETS, THREAT_CLASSES, DOMAIN_WEIGHTS };
