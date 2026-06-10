/**
 * IMMUNE HEART — φ-Heartbeat Engine for the Nova Immune System
 * Nova by FreddyCreates
 * 
 * "The heart is the rhythm of chaos — controlled, infinite, alive."
 * 
 * Based on geometry-lock-heart.js, this is the immune system's heartbeat.
 * It fires every 873ms (the φ-heartbeat), coordinates all immune responses,
 * and keeps the entire defense system synchronized.
 * 
 * The heart:
 * - Maintains the φ-beat timer (873ms)
 * - Coordinates all immune cells (spinners, crawlers, agents)
 * - Broadcasts threat levels to all defensive systems
 * - Adapts heartbeat rate based on system stress
 * - Never stops — the immune system is always running
 * 
 * @version 1.0.0
 * @copyright Nova Protocol by FreddyCreates
 */

import { PHI, PHI_INV, PHI_BEAT, kuramotoR, GREEK } from './greek-mathematics.js';

// ═══════════════════════════════════════════════════════════════════════════
// CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════

/** Default heartbeat interval */
const DEFAULT_HEARTBEAT = PHI_BEAT;  // 873ms

/** Stressed heartbeat (faster under threat) */
const STRESSED_HEARTBEAT = Math.floor(PHI_BEAT / PHI);  // ~540ms

/** Relaxed heartbeat (slower when healthy) */
const RELAXED_HEARTBEAT = Math.floor(PHI_BEAT * PHI);  // ~1412ms

/** Max immune cells tracked */
const MAX_IMMUNE_CELLS = 233;  // F13 Fibonacci

/** Posture levels */
const POSTURE = {
  GREEN: 'GREEN',     // Healthy, normal operation
  YELLOW: 'YELLOW',   // Elevated awareness
  ORANGE: 'ORANGE',   // Active defense
  RED: 'RED'          // Emergency lockdown
};

// ═══════════════════════════════════════════════════════════════════════════
// IMMUNE HEART CLASS
// ═══════════════════════════════════════════════════════════════════════════

/**
 * ImmuneHeart — The always-running heartbeat of the immune system
 */
export class ImmuneHeart {
  constructor(config = {}) {
    // Core state
    this.beatCount = 0;
    this.running = false;
    this.posture = POSTURE.GREEN;
    this.heartbeatInterval = config.interval || DEFAULT_HEARTBEAT;
    
    // Immune cells registry
    this.cells = new Map();  // cellId → cell metadata
    this.spinners = new Map();  // spinnerId → spinner state
    this.crawlers = new Map();  // crawlerId → crawler state
    
    // Listeners
    this._listeners = [];
    this._timer = null;
    this._startedAt = null;
    
    // Metrics
    this.metrics = {
      totalBeats: 0,
      threatsDetected: 0,
      responsesTriggered: 0,
      cellsActivated: 0,
      postureChanges: 0,
      averageCoherence: 0
    };
    
    // Coherence tracking
    this._coherenceHistory = [];
  }
  
  // ─── Lifecycle ─────────────────────────────────────────────────────────
  
  /**
   * Start the heartbeat — this runs forever
   */
  start() {
    if (this.running) return this;
    
    this.running = true;
    this._startedAt = Date.now();
    this._timer = setInterval(() => this._beat(), this.heartbeatInterval);
    
    this._emit({
      type: 'heart-started',
      beat: this.beatCount,
      interval: this.heartbeatInterval,
      posture: this.posture,
      timestamp: Date.now()
    });
    
    return this;
  }
  
  /**
   * Stop the heartbeat (only for shutdown)
   */
  stop() {
    if (this._timer) {
      clearInterval(this._timer);
      this._timer = null;
    }
    this.running = false;
    
    this._emit({
      type: 'heart-stopped',
      beat: this.beatCount,
      uptime: this.getUptime(),
      timestamp: Date.now()
    });
    
    return this;
  }
  
  /**
   * Adapt heartbeat rate based on posture
   */
  adaptRate(posture) {
    let newInterval;
    
    switch (posture) {
      case POSTURE.RED:
        newInterval = STRESSED_HEARTBEAT;  // Fast pulse under threat
        break;
      case POSTURE.ORANGE:
        newInterval = Math.floor(PHI_BEAT * 0.8);  // Elevated
        break;
      case POSTURE.YELLOW:
        newInterval = DEFAULT_HEARTBEAT;  // Normal
        break;
      case POSTURE.GREEN:
      default:
        newInterval = RELAXED_HEARTBEAT;  // Relaxed when healthy
        break;
    }
    
    if (newInterval !== this.heartbeatInterval) {
      this.heartbeatInterval = newInterval;
      
      // Restart timer with new interval
      if (this.running) {
        clearInterval(this._timer);
        this._timer = setInterval(() => this._beat(), this.heartbeatInterval);
      }
      
      this._emit({
        type: 'rate-adapted',
        posture,
        interval: newInterval,
        beat: this.beatCount,
        timestamp: Date.now()
      });
    }
    
    return newInterval;
  }
  
  // ─── Posture Management ────────────────────────────────────────────────
  
  /**
   * Set defensive posture
   */
  setPosture(posture) {
    if (!Object.values(POSTURE).includes(posture)) {
      posture = POSTURE.GREEN;
    }
    
    const previousPosture = this.posture;
    this.posture = posture;
    this.metrics.postureChanges++;
    
    // Adapt heart rate to posture
    this.adaptRate(posture);
    
    this._emit({
      type: 'posture-change',
      from: previousPosture,
      to: posture,
      beat: this.beatCount,
      timestamp: Date.now()
    });
    
    // Broadcast to all cells
    this._broadcastPosture(posture);
    
    return { previous: previousPosture, current: posture };
  }
  
  /**
   * Escalate posture (GREEN → YELLOW → ORANGE → RED)
   */
  escalate() {
    const levels = [POSTURE.GREEN, POSTURE.YELLOW, POSTURE.ORANGE, POSTURE.RED];
    const currentIdx = levels.indexOf(this.posture);
    
    if (currentIdx < levels.length - 1) {
      return this.setPosture(levels[currentIdx + 1]);
    }
    
    return { previous: this.posture, current: this.posture };
  }
  
  /**
   * De-escalate posture (RED → ORANGE → YELLOW → GREEN)
   */
  deescalate() {
    const levels = [POSTURE.GREEN, POSTURE.YELLOW, POSTURE.ORANGE, POSTURE.RED];
    const currentIdx = levels.indexOf(this.posture);
    
    if (currentIdx > 0) {
      return this.setPosture(levels[currentIdx - 1]);
    }
    
    return { previous: this.posture, current: this.posture };
  }
  
  _broadcastPosture(posture) {
    for (const [, cell] of this.cells) {
      if (typeof cell.onPostureChange === 'function') {
        try {
          cell.onPostureChange(posture);
        } catch (e) { /* isolate cell errors */ }
      }
    }
  }
  
  // ─── Cell Management ───────────────────────────────────────────────────
  
  /**
   * Register an immune cell
   */
  registerCell(cellId, metadata = {}) {
    if (this.cells.size >= MAX_IMMUNE_CELLS) {
      // Evict oldest cell
      const oldest = [...this.cells.entries()]
        .sort((a, b) => a[1].registeredAt - b[1].registeredAt)[0];
      if (oldest) this.cells.delete(oldest[0]);
    }
    
    this.cells.set(cellId, {
      cellId,
      type: metadata.type || 'generic',
      registeredAt: Date.now(),
      lastPulse: null,
      healthy: true,
      ...metadata
    });
    
    this.metrics.cellsActivated++;
    
    this._emit({
      type: 'cell-registered',
      cellId,
      cellType: metadata.type,
      beat: this.beatCount,
      timestamp: Date.now()
    });
    
    return this.cells.get(cellId);
  }
  
  /**
   * Unregister an immune cell
   */
  unregisterCell(cellId) {
    const cell = this.cells.get(cellId);
    this.cells.delete(cellId);
    
    if (cell) {
      this._emit({
        type: 'cell-unregistered',
        cellId,
        beat: this.beatCount,
        timestamp: Date.now()
      });
    }
    
    return cell;
  }
  
  /**
   * Register a chaos spinner
   */
  registerSpinner(spinnerId, spinner) {
    this.spinners.set(spinnerId, {
      spinner,
      registeredAt: Date.now(),
      spins: 0,
      lastReturn: null
    });
    
    return this.registerCell(spinnerId, { type: 'spinner', spinner });
  }
  
  /**
   * Register a crawler
   */
  registerCrawler(crawlerId, crawler) {
    this.crawlers.set(crawlerId, {
      crawler,
      registeredAt: Date.now(),
      explorations: 0,
      lastReturn: null
    });
    
    return this.registerCell(crawlerId, { type: 'crawler', crawler });
  }
  
  // ─── Threat Detection ──────────────────────────────────────────────────
  
  /**
   * Report a threat detection
   */
  reportThreat(source, severity, details = {}) {
    this.metrics.threatsDetected++;
    
    const threat = {
      type: 'threat-detected',
      source,
      severity,  // 0-1
      details,
      beat: this.beatCount,
      timestamp: Date.now()
    };
    
    this._emit(threat);
    
    // Auto-escalate based on severity
    if (severity > 0.8) {
      this.setPosture(POSTURE.RED);
    } else if (severity > 0.5) {
      this.setPosture(POSTURE.ORANGE);
    } else if (severity > 0.2) {
      this.setPosture(POSTURE.YELLOW);
    }
    
    return threat;
  }
  
  /**
   * Trigger immune response
   */
  triggerResponse(responseType, target, strength = 1) {
    this.metrics.responsesTriggered++;
    
    const response = {
      type: 'immune-response',
      responseType,
      target,
      strength,
      beat: this.beatCount,
      timestamp: Date.now()
    };
    
    this._emit(response);
    
    return response;
  }
  
  // ─── Internal Beat ─────────────────────────────────────────────────────
  
  _beat() {
    this.beatCount++;
    this.metrics.totalBeats++;
    
    // Calculate coherence from cell phases
    const phases = [...this.cells.values()]
      .filter(c => c.phase !== undefined)
      .map(c => c.phase);
    
    const coherence = phases.length > 0 ? kuramotoR(phases) : 1;
    this._coherenceHistory.push(coherence);
    if (this._coherenceHistory.length > 100) this._coherenceHistory.shift();
    
    this.metrics.averageCoherence = this._coherenceHistory.reduce((a, b) => a + b, 0) / 
      this._coherenceHistory.length;
    
    // Update all cells
    const ts = Date.now();
    for (const [, cell] of this.cells) {
      cell.lastPulse = ts;
    }
    
    // Emit pulse
    const pulse = {
      type: 'pulse',
      beat: this.beatCount,
      posture: this.posture,
      coherence,
      cellCount: this.cells.size,
      spinnerCount: this.spinners.size,
      crawlerCount: this.crawlers.size,
      phi: PHI,
      phiInv: PHI_INV,
      interval: this.heartbeatInterval,
      uptime: this.getUptime(),
      timestamp: ts
    };
    
    this._emit(pulse);
    
    // Check for emergence
    if (coherence > PHI_INV) {
      this._emit({
        type: 'emergence',
        coherence,
        beat: this.beatCount,
        timestamp: ts
      });
    }
  }
  
  // ─── Event System ──────────────────────────────────────────────────────
  
  on(listener) {
    if (typeof listener === 'function') {
      this._listeners.push(listener);
    }
    return () => {
      this._listeners = this._listeners.filter(l => l !== listener);
    };
  }
  
  _emit(event) {
    for (const fn of this._listeners) {
      try { fn(event); } catch (_) { /* isolate listener errors */ }
    }
  }
  
  // ─── Status ────────────────────────────────────────────────────────────
  
  getUptime() {
    return this._startedAt ? Date.now() - this._startedAt : 0;
  }
  
  getVitals() {
    return {
      running: this.running,
      posture: this.posture,
      beatCount: this.beatCount,
      heartbeatInterval: this.heartbeatInterval,
      cells: this.cells.size,
      spinners: this.spinners.size,
      crawlers: this.crawlers.size,
      coherence: this.metrics.averageCoherence,
      uptime: this.getUptime(),
      metrics: { ...this.metrics },
      phi: PHI,
      timestamp: Date.now()
    };
  }
  
  heartbeat() {
    return {
      alive: this.running,
      beat: this.beatCount,
      posture: this.posture,
      cells: this.cells.size,
      coherence: this.metrics.averageCoherence,
      timestamp: Date.now()
    };
  }
  
  toJSON() {
    return {
      type: 'ImmuneHeart',
      version: '1.0.0',
      ...this.getVitals()
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// POSTURE EXPORT
// ═══════════════════════════════════════════════════════════════════════════

export { POSTURE };

// ═══════════════════════════════════════════════════════════════════════════
// FACTORY
// ═══════════════════════════════════════════════════════════════════════════

export function createImmuneHeart(config = {}) {
  return new ImmuneHeart(config);
}

// ═══════════════════════════════════════════════════════════════════════════
// DEFAULT EXPORT
// ═══════════════════════════════════════════════════════════════════════════

export default {
  ImmuneHeart,
  POSTURE,
  DEFAULT_HEARTBEAT,
  STRESSED_HEARTBEAT,
  RELAXED_HEARTBEAT,
  createImmuneHeart
};
