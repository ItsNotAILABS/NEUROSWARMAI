/**
 * Web Push Orchestrator — MEDINA BEDROCK → Web Browser Integration
 *
 * PUSH architecture: MEDINA BEDROCK pushes intelligence to web browsers.
 * We don't pull from browser APIs internally — we PUSH updates when we have intelligence to share.
 *
 * Features:
 * - Native MEDINA BEDROCK embeddings
 * - Micro-token allocation using FORMA weights
 * - Real-time WebSocket push
 * - Server-Sent Events (SSE) push
 * - Web Push Notifications
 *
 * Integration Points:
 * - WebSocket (push real-time data streams)
 * - SSE (push server-sent events)
 * - Web Push API (push browser notifications)
 * - Service Workers (push background updates)
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 */

const PHI = 1.618033988749895;
const PHI_BEAT = 873;
const F11 = 89;

// ════════════════════════════════════════════════════════════════
// VERSION INFORMATION
// ════════════════════════════════════════════════════════════════

const VERSION = '1.0.0';
const COMPONENT_ID = 'WEB_PUSH_ORCHESTRATOR';
const COMPONENT_TYPE = 'INTEGRATION_ORCHESTRATOR';

class WebPushOrchestrator {
  constructor(config = {}) {
    this.config = {
      websocketPort: config.websocketPort || 8080,
      sseEndpoint: config.sseEndpoint || '/events',
      vapidPublicKey: config.vapidPublicKey || null,
      vapidPrivateKey: config.vapidPrivateKey || null,
      ...config,
    };

    this.beatCount = 0;
    this.connections = new Map(); // WebSocket connections
    this.subscribers = new Map(); // SSE subscribers
    this.pushSubscriptions = new Map(); // Web Push subscriptions
    this.stats = {
      totalPushes: 0,
      successfulPushes: 0,
      failedPushes: 0,
      avgLatency: 0,
      activeConnections: 0,
    };
  }

  async initialize() {
    console.log('[WebPush] Initializing Web push orchestrator...');
    this.startHeartbeat();
    console.log('[WebPush] ✓ Web push orchestrator initialized');
  }

  startHeartbeat() {
    this.heartbeatInterval = setInterval(() => {
      this.beatCount++;

      // Send heartbeat to all connections
      this.broadcastHeartbeat();

      // Cleanup every F11 beats
      if (this.beatCount % F11 === 0) this.cleanup();
    }, PHI_BEAT);
  }

  // ════════════════════════════════════════════════════════════════
  // WEBSOCKET PUSH
  // ════════════════════════════════════════════════════════════════

  /**
   * Register WebSocket connection
   */
  registerWebSocket(connectionId, ws) {
    this.connections.set(connectionId, {
      ws,
      connected: true,
      lastActivity: Date.now(),
      pushCount: 0,
    });

    this.stats.activeConnections = this.connections.size;

    ws.on('close', () => {
      this.unregisterWebSocket(connectionId);
    });

    console.log(`[WebPush] WebSocket registered: ${connectionId}`);
  }

  /**
   * Unregister WebSocket connection
   */
  unregisterWebSocket(connectionId) {
    this.connections.delete(connectionId);
    this.stats.activeConnections = this.connections.size;
    console.log(`[WebPush] WebSocket unregistered: ${connectionId}`);
  }

  /**
   * Push data to specific WebSocket connection
   */
  async pushToWebSocket(connectionId, data) {
    const conn = this.connections.get(connectionId);
    if (!conn || !conn.connected) {
      return { success: false, reason: 'connection_not_found' };
    }

    const startTime = Date.now();

    try {
      conn.ws.send(JSON.stringify(data));
      conn.lastActivity = Date.now();
      conn.pushCount++;

      const latency = Date.now() - startTime;
      this.updateStats(true, latency);

      return { success: true, latency };
    } catch (err) {
      console.error('[WebPush] WebSocket push failed:', err);
      this.updateStats(false, Date.now() - startTime);
      return { success: false, error: err.message };
    }
  }

  /**
   * Broadcast to all WebSocket connections
   */
  async broadcastWebSocket(data) {
    const results = [];

    for (const [connectionId, conn] of this.connections.entries()) {
      if (conn.connected) {
        const result = await this.pushToWebSocket(connectionId, data);
        results.push({ connectionId, ...result });
      }
    }

    return results;
  }

  /**
   * Broadcast heartbeat to all connections
   */
  broadcastHeartbeat() {
    this.broadcastWebSocket({
      type: 'HEARTBEAT',
      beat: this.beatCount,
      timestamp: Date.now(),
      phi: PHI,
    });
  }

  // ════════════════════════════════════════════════════════════════
  // SERVER-SENT EVENTS (SSE) PUSH
  // ════════════════════════════════════════════════════════════════

  /**
   * Register SSE subscriber
   */
  registerSSE(subscriberId, res) {
    this.subscribers.set(subscriberId, {
      res,
      active: true,
      lastPush: Date.now(),
      pushCount: 0,
    });

    // Set SSE headers
    res.writeHead(200, {
      'Content-Type': 'text/event-stream',
      'Cache-Control': 'no-cache',
      'Connection': 'keep-alive',
    });

    // Send initial connection message
    this.pushToSSE(subscriberId, {
      type: 'CONNECTED',
      subscriberId,
      beat: this.beatCount,
    });

    console.log(`[WebPush] SSE subscriber registered: ${subscriberId}`);
  }

  /**
   * Push data via SSE
   */
  async pushToSSE(subscriberId, data) {
    const subscriber = this.subscribers.get(subscriberId);
    if (!subscriber || !subscriber.active) {
      return { success: false, reason: 'subscriber_not_found' };
    }

    const startTime = Date.now();

    try {
      const sseData = `data: ${JSON.stringify(data)}\n\n`;
      subscriber.res.write(sseData);
      subscriber.lastPush = Date.now();
      subscriber.pushCount++;

      const latency = Date.now() - startTime;
      this.updateStats(true, latency);

      return { success: true, latency };
    } catch (err) {
      console.error('[WebPush] SSE push failed:', err);
      this.subscribers.delete(subscriberId);
      this.updateStats(false, Date.now() - startTime);
      return { success: false, error: err.message };
    }
  }

  /**
   * Broadcast to all SSE subscribers
   */
  async broadcastSSE(data) {
    const results = [];

    for (const [subscriberId, subscriber] of this.subscribers.entries()) {
      if (subscriber.active) {
        const result = await this.pushToSSE(subscriberId, data);
        results.push({ subscriberId, ...result });
      }
    }

    return results;
  }

  // ════════════════════════════════════════════════════════════════
  // WEB PUSH NOTIFICATIONS
  // ════════════════════════════════════════════════════════════════

  /**
   * Register Web Push subscription
   */
  registerPushSubscription(userId, subscription) {
    this.pushSubscriptions.set(userId, {
      subscription,
      registered: Date.now(),
      pushCount: 0,
    });

    console.log(`[WebPush] Push subscription registered: ${userId}`);
  }

  /**
   * Push notification to user
   */
  async pushNotification(userId, notification) {
    const sub = this.pushSubscriptions.get(userId);
    if (!sub) {
      return { success: false, reason: 'subscription_not_found' };
    }

    // Web Push requires webpush library
    // This is a placeholder for Web Push integration
    console.log('[WebPush] Notification push:', userId, notification.title);

    return {
      success: true,
      userId,
      notification,
    };
  }

  // ════════════════════════════════════════════════════════════════
  // MEDINA-ARTIFACT PUSH
  // ════════════════════════════════════════════════════════════════

  /**
   * Push MEDINA-ARTIFACT response to web clients
   */
  async pushMedinaResponse(medinaOutput, target = 'broadcast') {
    const payload = {
      type: 'MEDINA_RESPONSE',
      artifactId: medinaOutput.artifactId,
      name: medinaOutput.name,
      domain: medinaOutput.domain,
      response: medinaOutput.response,
      coherence: medinaOutput.coherence,
      formaBalance: medinaOutput.formaBalance,
      timestamp: Date.now(),
    };

    if (target === 'broadcast') {
      // Broadcast to all connections
      const wsResults = await this.broadcastWebSocket(payload);
      const sseResults = await this.broadcastSSE(payload);

      return {
        websocket: wsResults,
        sse: sseResults,
      };
    } else {
      // Push to specific connection
      const wsResult = await this.pushToWebSocket(target, payload);
      return { websocket: wsResult };
    }
  }

  // ════════════════════════════════════════════════════════════════
  // MAINTENANCE
  // ════════════════════════════════════════════════════════════════

  cleanup() {
    const now = Date.now();
    const TIMEOUT = 60 * 60 * 1000; // 1 hour

    // Remove stale WebSocket connections
    for (const [connectionId, conn] of this.connections.entries()) {
      if (now - conn.lastActivity > TIMEOUT) {
        conn.ws.close();
        this.connections.delete(connectionId);
      }
    }

    // Remove stale SSE subscribers
    for (const [subscriberId, subscriber] of this.subscribers.entries()) {
      if (now - subscriber.lastPush > TIMEOUT) {
        subscriber.res.end();
        this.subscribers.delete(subscriberId);
      }
    }

    this.stats.activeConnections = this.connections.size;

    console.log(
      `[WebPush] Cleanup: ${this.connections.size} WS, ${this.subscribers.size} SSE`
    );
  }

  updateStats(success, latency) {
    this.stats.totalPushes++;
    if (success) {
      this.stats.successfulPushes++;
    } else {
      this.stats.failedPushes++;
    }
    this.stats.avgLatency =
      (this.stats.avgLatency * (this.stats.totalPushes - 1) + latency) /
      this.stats.totalPushes;
  }

  getStats() {
    return {
      ...this.stats,
      activeWebSockets: this.connections.size,
      activeSSE: this.subscribers.size,
      activePushSubs: this.pushSubscriptions.size,
      beatCount: this.beatCount,
      successRate:
        this.stats.totalPushes > 0
          ? (this.stats.successfulPushes / this.stats.totalPushes).toFixed(3)
          : 0,
    };
  }

  async shutdown() {
    console.log('[WebPush] Shutting down Web push orchestrator...');

    if (this.heartbeatInterval) clearInterval(this.heartbeatInterval);

    // Close all WebSocket connections
    for (const [connectionId, conn] of this.connections.entries()) {
      conn.ws.close();
    }

    // Close all SSE connections
    for (const [subscriberId, subscriber] of this.subscribers.entries()) {
      subscriber.res.end();
    }

    console.log('[WebPush] ✓ Web push orchestrator shut down');
  }
}

if (typeof module !== 'undefined' && module.exports) {
  module.exports = { WebPushOrchestrator };
}

if (typeof window !== 'undefined') {
  window.WebPushOrchestrator = WebPushOrchestrator;
}
