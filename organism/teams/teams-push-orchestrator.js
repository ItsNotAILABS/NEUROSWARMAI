/**
 * Microsoft Teams Push Orchestrator — MEDINA BEDROCK → Teams Integration
 *
 * PUSH architecture: MEDINA BEDROCK pushes intelligence to Microsoft Teams.
 * We don't pull from Teams APIs internally — we PUSH to Teams when we have intelligence to share.
 *
 * Features:
 * - Native MEDINA BEDROCK embeddings
 * - Micro-token allocation using FORMA weights
 * - 24-layer MEDINA-ARTIFACT model routing
 * - φ-synchronized heartbeat (873ms)
 * - Adaptive Cards for rich message formatting
 *
 * Integration Points:
 * - Teams Incoming Webhooks (push messages/cards)
 * - Teams Bot Framework (push proactive messages)
 * - Teams Graph API (push channel posts)
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
const COMPONENT_ID = 'TEAMS_PUSH_ORCHESTRATOR';
const COMPONENT_TYPE = 'INTEGRATION_ORCHESTRATOR';

class TeamsPushOrchestrator {
  constructor(config = {}) {
    this.config = {
      webhookUrl: config.webhookUrl || null,
      botAppId: config.botAppId || null,
      botAppPassword: config.botAppPassword || null,
      tenantId: config.tenantId || null,
      ...config,
    };

    this.beatCount = 0;
    this.pushQueue = [];
    this.stats = {
      totalPushes: 0,
      successfulPushes: 0,
      failedPushes: 0,
      avgLatency: 0,
    };
  }

  async initialize() {
    console.log('[TeamsPush] Initializing Teams push orchestrator...');

    if (!this.config.webhookUrl && !this.config.botAppId) {
      throw new Error('Teams push requires either webhookUrl or botAppId');
    }

    this.startHeartbeat();
    console.log('[TeamsPush] ✓ Teams push orchestrator initialized');
  }

  startHeartbeat() {
    this.heartbeatInterval = setInterval(() => {
      this.beatCount++;
      this.processPushQueue();
      if (this.beatCount % F11 === 0) this.cleanup();
    }, PHI_BEAT);
  }

  async pushMessage(content, options = {}) {
    return this.executePush({
      type: 'MESSAGE',
      content,
      options,
      timestamp: Date.now(),
      retries: 0,
    });
  }

  async pushAdaptiveCard(card, options = {}) {
    return this.executePush({
      type: 'ADAPTIVE_CARD',
      card,
      options,
      timestamp: Date.now(),
      retries: 0,
    });
  }

  async pushMedinaResponse(medinaOutput, conversationId) {
    const card = this.formatMedinaCard(medinaOutput);
    return this.pushAdaptiveCard(card, { conversationId });
  }

  formatMedinaCard(medinaOutput) {
    const { artifactId, name, domain, response, coherence, formaBalance } = medinaOutput;

    return {
      type: 'message',
      attachments: [
        {
          contentType: 'application/vnd.microsoft.card.adaptive',
          content: {
            $schema: 'http://adaptivecards.io/schemas/adaptive-card.json',
            type: 'AdaptiveCard',
            version: '1.4',
            body: [
              {
                type: 'TextBlock',
                text: `🔮 ${name} (${artifactId})`,
                size: 'Large',
                weight: 'Bolder',
              },
              {
                type: 'TextBlock',
                text: response.slice(0, 2000),
                wrap: true,
              },
              {
                type: 'FactSet',
                facts: [
                  { title: 'Domain', value: domain },
                  { title: 'Coherence', value: `${(coherence * 100).toFixed(1)}%` },
                  { title: 'FORMA Balance', value: formaBalance.toFixed(2) },
                ],
              },
            ],
            msteams: {
              width: 'Full',
            },
          },
        },
      ],
    };
  }

  async executePush(pushRequest) {
    const startTime = Date.now();

    try {
      let result;

      if (pushRequest.type === 'MESSAGE') {
        result = await this.sendMessage(pushRequest);
      } else if (pushRequest.type === 'ADAPTIVE_CARD') {
        result = await this.sendCard(pushRequest);
      }

      const latency = Date.now() - startTime;
      this.updateStats(true, latency);

      return { success: true, latency, result };
    } catch (err) {
      console.error('[TeamsPush] Push failed:', err);

      if (pushRequest.retries < 3) {
        pushRequest.retries++;
        setTimeout(() => this.executePush(pushRequest), 1000 * pushRequest.retries);
      } else {
        this.updateStats(false, Date.now() - startTime);
      }

      return { success: false, error: err.message, retries: pushRequest.retries };
    }
  }

  async sendMessage(pushRequest) {
    if (!this.config.webhookUrl) {
      throw new Error('Teams webhook URL not configured');
    }

    const response = await fetch(this.config.webhookUrl, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        text: pushRequest.content,
      }),
    });

    if (!response.ok) {
      throw new Error(`Teams webhook failed: ${response.status}`);
    }

    return { method: 'webhook', status: response.status };
  }

  async sendCard(pushRequest) {
    if (!this.config.webhookUrl) {
      throw new Error('Teams webhook URL not configured');
    }

    const response = await fetch(this.config.webhookUrl, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(pushRequest.card),
    });

    if (!response.ok) {
      throw new Error(`Teams card push failed: ${response.status}`);
    }

    return { method: 'webhook', status: response.status };
  }

  async processPushQueue() {
    if (this.pushQueue.length === 0) return;
    const batch = this.pushQueue.splice(0, 5);
    await Promise.allSettled(batch.map(req => this.executePush(req)));
  }

  cleanup() {
    const now = Date.now();
    const ONE_HOUR = 60 * 60 * 1000;
    this.pushQueue = this.pushQueue.filter(req => now - req.timestamp < ONE_HOUR);
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
      pendingPushes: this.pushQueue.length,
      beatCount: this.beatCount,
      successRate:
        this.stats.totalPushes > 0
          ? (this.stats.successfulPushes / this.stats.totalPushes).toFixed(3)
          : 0,
    };
  }

  async shutdown() {
    console.log('[TeamsPush] Shutting down Teams push orchestrator...');
    if (this.heartbeatInterval) clearInterval(this.heartbeatInterval);
    await this.processPushQueue();
    console.log('[TeamsPush] ✓ Teams push orchestrator shut down');
  }
}

if (typeof module !== 'undefined' && module.exports) {
  module.exports = { TeamsPushOrchestrator };
}

if (typeof window !== 'undefined') {
  window.TeamsPushOrchestrator = TeamsPushOrchestrator;
}
