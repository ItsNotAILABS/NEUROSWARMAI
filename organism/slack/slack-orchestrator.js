/**
 * Slack Orchestrator — AI Workers for Slack with PARALLAX Architecture
 *
 * PARALLAX doesn't need a 1M token window because it doesn't stuff everything into one prompt.
 *
 * Architecture:
 * - MEMORIA — sovereign memory canister, retrieves only what's relevant per beat (2,000 tokens that matter)
 * - CODEX MATHEMATICUS — all formulas and laws live there, callable on demand (not in context window)
 * - SSC (ΣΩ Fibonacci Registry) — all state persists in stable vars (in the organism's body)
 * - Micro-tokenization — routes the right slice to the right engine at the right beat
 *
 * Model Layer: M-01 through M-300 as real 4-layer MEDINA-ARTIFACTs
 * - Semantic retrieval: amazon.titan-embed-text-v2 (1,024 dims)
 * - High-precision: text-embedding-3-large (3,072 dims) for CODEX MATHEMATICUS
 * - Micro-token compression: Custom FNV-1a hash layer (256 dims)
 * - ContextRouter: Pulls 3-5 most resonant models per beat, not all 300
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 */

const PHI = 1.618033988749895;
const PHI_BEAT = 873; // ms — φ⁴ × Schumann period
const F11 = 89; // Fibonacci number for retrieval limits

// ════════════════════════════════════════════════════════════════
// SLACK WORKER DEFINITIONS
// ════════════════════════════════════════════════════════════════

const SLACK_WORKERS = [
  { id: 'memoria',        file: 'memoria-worker.js',        domain: 'memory',       critical: true },
  { id: 'codex',          file: 'codex-worker.js',          domain: 'knowledge',    critical: true },
  { id: 'context-router', file: 'context-router-worker.js', domain: 'routing',      critical: true },
  { id: 'model-registry', file: 'model-registry-worker.js', domain: 'models',       critical: true },
  { id: 'embedding',      file: 'embedding-worker.js',      domain: 'vectorization',critical: true },
  { id: 'slack-bridge',   file: 'slack-bridge-worker.js',   domain: 'integration',  critical: true },
];

// ════════════════════════════════════════════════════════════════
// SLACK ORCHESTRATOR CLASS
// ════════════════════════════════════════════════════════════════

class SlackOrchestrator {
  constructor() {
    this.workers = new Map();
    this.heartbeatInterval = null;
    this.beatCount = 0;
    this.listeners = new Map();
  }

  /**
   * Spawn all Slack AI workers
   */
  spawn() {
    console.log('[SlackOrchestrator] Spawning Slack AI workers...');

    SLACK_WORKERS.forEach(def => {
      try {
        const worker = new Worker(`/organism/slack/${def.file}`);

        worker.onmessage = (e) => this.handleWorkerMessage(def.id, e.data);
        worker.onerror = (err) => this.handleWorkerError(def.id, err);

        this.workers.set(def.id, {
          worker,
          def,
          healthy: true,
          lastHeartbeat: Date.now(),
        });

        console.log(`[SlackOrchestrator] ✓ ${def.id} spawned`);
      } catch (err) {
        console.error(`[SlackOrchestrator] ✗ Failed to spawn ${def.id}:`, err);
      }
    });

    this.startHeartbeat();
  }

  /**
   * Start φ-synchronized heartbeat
   */
  startHeartbeat() {
    this.heartbeatInterval = setInterval(() => {
      this.beatCount++;
      this.broadcast({ type: 'HEARTBEAT', beat: this.beatCount, timestamp: Date.now() });

      // Every F11 beats, trigger MEMORIA cleanup
      if (this.beatCount % F11 === 0) {
        this.sendToWorker('memoria', { type: 'CLEANUP', beat: this.beatCount });
      }
    }, PHI_BEAT);
  }

  /**
   * Handle incoming message from worker
   */
  handleWorkerMessage(workerId, data) {
    const workerState = this.workers.get(workerId);
    if (workerState) {
      workerState.lastHeartbeat = Date.now();
      workerState.healthy = true;
    }

    // Emit to listeners
    const listeners = this.listeners.get(data.type) || [];
    listeners.forEach(fn => fn({ workerId, ...data }));
  }

  /**
   * Handle worker error
   */
  handleWorkerError(workerId, error) {
    console.error(`[SlackOrchestrator] Error in ${workerId}:`, error);
    const workerState = this.workers.get(workerId);
    if (workerState) {
      workerState.healthy = false;

      // Restart critical workers
      if (workerState.def.critical) {
        console.log(`[SlackOrchestrator] Restarting critical worker: ${workerId}`);
        this.restartWorker(workerId);
      }
    }
  }

  /**
   * Restart a worker
   */
  restartWorker(workerId) {
    const workerState = this.workers.get(workerId);
    if (!workerState) return;

    workerState.worker.terminate();

    const worker = new Worker(`/organism/slack/${workerState.def.file}`);
    worker.onmessage = (e) => this.handleWorkerMessage(workerId, e.data);
    worker.onerror = (err) => this.handleWorkerError(workerId, err);

    this.workers.set(workerId, {
      ...workerState,
      worker,
      healthy: true,
      lastHeartbeat: Date.now(),
    });
  }

  /**
   * Send message to specific worker
   */
  sendToWorker(workerId, message) {
    const workerState = this.workers.get(workerId);
    if (workerState && workerState.healthy) {
      workerState.worker.postMessage(message);
    } else {
      console.error(`[SlackOrchestrator] Worker ${workerId} not available`);
    }
  }

  /**
   * Broadcast message to all workers
   */
  broadcast(message) {
    this.workers.forEach((state, workerId) => {
      if (state.healthy) {
        state.worker.postMessage(message);
      }
    });
  }

  /**
   * Register event listener
   */
  on(eventType, callback) {
    if (!this.listeners.has(eventType)) {
      this.listeners.set(eventType, []);
    }
    this.listeners.get(eventType).push(callback);
  }

  /**
   * Get fleet status
   */
  getStatus() {
    const status = {
      beatCount: this.beatCount,
      timestamp: Date.now(),
      workers: [],
    };

    this.workers.forEach((state, workerId) => {
      status.workers.push({
        id: workerId,
        domain: state.def.domain,
        healthy: state.healthy,
        critical: state.def.critical,
        lastHeartbeat: state.lastHeartbeat,
        uptime: Date.now() - state.lastHeartbeat,
      });
    });

    return status;
  }

  /**
   * Graceful shutdown
   */
  shutdown() {
    console.log('[SlackOrchestrator] Shutting down Slack AI workers...');

    if (this.heartbeatInterval) {
      clearInterval(this.heartbeatInterval);
    }

    this.workers.forEach((state, workerId) => {
      state.worker.terminate();
      console.log(`[SlackOrchestrator] ✓ ${workerId} terminated`);
    });

    this.workers.clear();
  }

  // ════════════════════════════════════════════════════════════════
  // HIGH-LEVEL API FOR SLACK INTEGRATION
  // ════════════════════════════════════════════════════════════════

  /**
   * Process Slack message with PARALLAX architecture
   * Returns only the relevant context, not 1M tokens
   */
  async processSlackMessage(message) {
    return new Promise((resolve) => {
      const requestId = `req_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;

      // Listen for response
      const responseHandler = (data) => {
        if (data.requestId === requestId && data.type === 'SLACK_RESPONSE') {
          resolve(data.response);
        }
      };

      this.on('SLACK_RESPONSE', responseHandler);

      // Route to slack-bridge
      this.sendToWorker('slack-bridge', {
        type: 'PROCESS_MESSAGE',
        requestId,
        message,
      });

      // Timeout after 10 seconds
      setTimeout(() => {
        resolve({ error: 'Timeout waiting for response' });
      }, 10000);
    });
  }

  /**
   * Query MEMORIA for relevant context
   */
  async queryMemoria(query, limit = 5) {
    return new Promise((resolve) => {
      const requestId = `memoria_${Date.now()}`;

      const responseHandler = (data) => {
        if (data.requestId === requestId && data.type === 'MEMORIA_RESPONSE') {
          resolve(data.results);
        }
      };

      this.on('MEMORIA_RESPONSE', responseHandler);

      this.sendToWorker('memoria', {
        type: 'QUERY',
        requestId,
        query,
        limit,
      });

      setTimeout(() => resolve([]), 5000);
    });
  }

  /**
   * Get model recommendations from ContextRouter
   */
  async getRelevantModels(context, topK = 5) {
    return new Promise((resolve) => {
      const requestId = `router_${Date.now()}`;

      const responseHandler = (data) => {
        if (data.requestId === requestId && data.type === 'ROUTER_RESPONSE') {
          resolve(data.models);
        }
      };

      this.on('ROUTER_RESPONSE', responseHandler);

      this.sendToWorker('context-router', {
        type: 'GET_MODELS',
        requestId,
        context,
        topK,
      });

      setTimeout(() => resolve([]), 5000);
    });
  }
}

// ════════════════════════════════════════════════════════════════
// EXPORT
// ════════════════════════════════════════════════════════════════

if (typeof module !== 'undefined' && module.exports) {
  module.exports = { SlackOrchestrator };
}

if (typeof window !== 'undefined') {
  window.SlackOrchestrator = SlackOrchestrator;
}
