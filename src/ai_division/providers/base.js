/**
 * CHIMERIA Provider Adapter — Base Class
 *
 * Production-grade base for all AI model provider adapters.
 * Handles: HTTP transport, retries with exponential backoff,
 * streaming, health checks, rate limiting, and token accounting.
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI = 1.618033988749895;
const PHI_INV = 1 / PHI;

/**
 * @typedef {Object} ProviderModel
 * @property {string} id
 * @property {string} name
 * @property {number} maxInputTokens
 * @property {number} maxOutputTokens
 * @property {string[]} capabilities
 * @property {number} costPerInputToken
 * @property {number} costPerOutputToken
 */

/**
 * @typedef {Object} InferenceRequest
 * @property {string} model
 * @property {Array<{role: string, content: string}>} messages
 * @property {number} [maxTokens]
 * @property {number} [temperature]
 * @property {boolean} [stream]
 * @property {Object} [metadata]
 */

/**
 * @typedef {Object} InferenceResponse
 * @property {string} id
 * @property {string} model
 * @property {string} content
 * @property {Object} usage
 * @property {number} usage.inputTokens
 * @property {number} usage.outputTokens
 * @property {string} finishReason
 * @property {number} latencyMs
 */

export class ProviderAdapter {
  /** @type {string} */
  providerId;
  /** @type {string} */
  baseUrl;
  /** @type {Map<string, ProviderModel>} */
  models;
  /** @type {boolean} */
  healthy;

  constructor(providerId, config = {}) {
    this.providerId = providerId;
    this.baseUrl = config.baseUrl || '';
    this.apiKey = config.apiKey || null;
    this.models = new Map();
    this.healthy = true;
    this.lastHealthCheck = 0;
    this.healthCheckIntervalMs = 30_000;

    // Metrics
    this.metrics = {
      totalRequests: 0,
      successfulRequests: 0,
      failedRequests: 0,
      totalInputTokens: 0,
      totalOutputTokens: 0,
      totalLatencyMs: 0,
      totalCost: 0,
    };

    // Rate limiting
    this.rateLimiter = {
      requestsPerMinute: config.requestsPerMinute || 60,
      tokensPerMinute: config.tokensPerMinute || 100_000,
      windowRequests: [],
      windowTokens: [],
    };

    // Retry config
    this.retryConfig = {
      maxRetries: config.maxRetries ?? 3,
      baseDelayMs: config.baseDelayMs ?? 1000,
      maxDelayMs: config.maxDelayMs ?? 30_000,
      retryableStatuses: new Set([429, 500, 502, 503, 504]),
    };
  }

  /**
   * Register a model supported by this provider
   */
  registerModel(model) {
    this.models.set(model.id, model);
  }

  /**
   * List all registered models
   */
  listModels() {
    return [...this.models.values()];
  }

  /**
   * Get a specific model by ID
   */
  getModel(modelId) {
    return this.models.get(modelId) || null;
  }

  /**
   * Send an inference request with retries and rate limiting
   * @param {InferenceRequest} request
   * @returns {Promise<InferenceResponse>}
   */
  async infer(request) {
    if (!this.healthy) {
      await this.healthCheck();
      if (!this.healthy) {
        throw new Error(`[${this.providerId}] Provider unhealthy — cannot serve inference`);
      }
    }

    this.enforceRateLimit();
    this.metrics.totalRequests++;

    const model = this.models.get(request.model);
    if (!model) {
      throw new Error(`[${this.providerId}] Unknown model: ${request.model}`);
    }

    const startMs = Date.now();
    let lastError = null;

    for (let attempt = 0; attempt <= this.retryConfig.maxRetries; attempt++) {
      try {
        if (attempt > 0) {
          const delay = this.computeBackoff(attempt);
          await this.sleep(delay);
        }

        const response = await this.executeRequest(request, model);
        const latencyMs = Date.now() - startMs;

        // Track metrics
        this.metrics.successfulRequests++;
        this.metrics.totalLatencyMs += latencyMs;
        if (response.usage) {
          this.metrics.totalInputTokens += response.usage.inputTokens || 0;
          this.metrics.totalOutputTokens += response.usage.outputTokens || 0;
          this.metrics.totalCost +=
            (response.usage.inputTokens || 0) * (model.costPerInputToken || 0) +
            (response.usage.outputTokens || 0) * (model.costPerOutputToken || 0);
        }

        this.recordRateWindow(response.usage);
        return { ...response, latencyMs };
      } catch (err) {
        lastError = err;
        const status = err.status || err.statusCode || 0;

        if (!this.retryConfig.retryableStatuses.has(status) && status !== 0) {
          break; // Non-retryable error
        }
      }
    }

    this.metrics.failedRequests++;
    throw lastError || new Error(`[${this.providerId}] Inference failed after retries`);
  }

  /**
   * Stream inference (yields chunks)
   * @param {InferenceRequest} request
   * @returns {AsyncGenerator<{content: string, done: boolean}>}
   */
  async *stream(request) {
    if (!this.healthy) {
      throw new Error(`[${this.providerId}] Provider unhealthy`);
    }

    this.enforceRateLimit();
    this.metrics.totalRequests++;

    const model = this.models.get(request.model);
    if (!model) {
      throw new Error(`[${this.providerId}] Unknown model: ${request.model}`);
    }

    yield* this.executeStream(request, model);
  }

  /**
   * Provider-specific request execution (override in subclass)
   * @abstract
   */
  async executeRequest(request, model) {
    throw new Error(`[${this.providerId}] executeRequest() not implemented`);
  }

  /**
   * Provider-specific streaming (override in subclass)
   * @abstract
   */
  async *executeStream(request, model) {
    throw new Error(`[${this.providerId}] executeStream() not implemented`);
  }

  /**
   * HTTP fetch with headers
   */
  async fetch(path, options = {}) {
    const url = `${this.baseUrl}${path}`;
    const headers = {
      'Content-Type': 'application/json',
      ...this.getAuthHeaders(),
      ...options.headers,
    };

    const response = await globalThis.fetch(url, {
      method: options.method || 'POST',
      headers,
      body: options.body ? JSON.stringify(options.body) : undefined,
      signal: options.signal,
    });

    if (!response.ok) {
      const error = new Error(`[${this.providerId}] HTTP ${response.status}: ${response.statusText}`);
      error.status = response.status;
      try { error.body = await response.json(); } catch { /* ignore */ }
      throw error;
    }

    return response;
  }

  /**
   * Get auth headers (override per provider)
   */
  getAuthHeaders() {
    if (this.apiKey) {
      return { 'Authorization': 'Bearer ' + this.apiKey };
    }
    return {};
  }

  /**
   * Health check — ping provider
   */
  async healthCheck() {
    const now = Date.now();
    if (now - this.lastHealthCheck < this.healthCheckIntervalMs) return;
    this.lastHealthCheck = now;

    try {
      await this.executeHealthCheck();
      this.healthy = true;
    } catch {
      this.healthy = false;
    }
  }

  /**
   * Override for provider-specific health check
   */
  async executeHealthCheck() {
    await this.fetch('/models', { method: 'GET' });
  }

  /**
   * Rate limit enforcement
   */
  enforceRateLimit() {
    const now = Date.now();
    const oneMinuteAgo = now - 60_000;

    this.rateLimiter.windowRequests = this.rateLimiter.windowRequests.filter(t => t > oneMinuteAgo);

    if (this.rateLimiter.windowRequests.length >= this.rateLimiter.requestsPerMinute) {
      throw new Error(`[${this.providerId}] Rate limit exceeded: ${this.rateLimiter.requestsPerMinute} req/min`);
    }

    this.rateLimiter.windowRequests.push(now);
  }

  recordRateWindow(usage) {
    if (usage) {
      this.rateLimiter.windowTokens.push({
        ts: Date.now(),
        tokens: (usage.inputTokens || 0) + (usage.outputTokens || 0),
      });
    }
  }

  /**
   * Exponential backoff with φ-jitter
   */
  computeBackoff(attempt) {
    const base = this.retryConfig.baseDelayMs * Math.pow(2, attempt);
    const jitter = base * PHI_INV * Math.random();
    return Math.min(base + jitter, this.retryConfig.maxDelayMs);
  }

  sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
  }

  /**
   * Get provider status
   */
  getStatus() {
    const avgLatency = this.metrics.successfulRequests > 0
      ? this.metrics.totalLatencyMs / this.metrics.successfulRequests : 0;
    const errorRate = this.metrics.totalRequests > 0
      ? this.metrics.failedRequests / this.metrics.totalRequests : 0;

    return {
      providerId: this.providerId,
      healthy: this.healthy,
      models: this.listModels().map(m => m.id),
      metrics: { ...this.metrics, avgLatencyMs: Math.round(avgLatency), errorRate },
    };
  }
}
