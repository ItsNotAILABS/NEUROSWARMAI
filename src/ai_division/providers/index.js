/**
 * CHIMERIA Provider Registry & Router
 *
 * Central registry for all AI providers. Handles:
 * - Provider initialization from environment config
 * - Intelligent routing (cost, latency, capability matching)
 * - Fallback chains across providers
 * - Aggregate health monitoring
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

import { OpenAIProvider } from './openai.js';
import { AnthropicProvider } from './anthropic.js';
import { GoogleProvider } from './google.js';
import { MetaProvider } from './meta.js';
import { MistralProvider } from './mistral.js';
import { DeepSeekProvider } from './deepseek.js';

export { ProviderAdapter } from './base.js';
export { OpenAIProvider } from './openai.js';
export { AnthropicProvider } from './anthropic.js';
export { GoogleProvider } from './google.js';
export { MetaProvider } from './meta.js';
export { MistralProvider } from './mistral.js';
export { DeepSeekProvider } from './deepseek.js';

/**
 * Provider Router — intelligent multi-provider routing
 */
export class ProviderRouter {
  constructor() {
    /** @type {Map<string, import('./base.js').ProviderAdapter>} */
    this.providers = new Map();
    /** @type {Map<string, {providerId: string, modelId: string}>} */
    this.modelIndex = new Map();
  }

  /**
   * Initialize all providers from config
   * @param {Object} config - Keys per provider: { openai: { apiKey }, anthropic: { apiKey }, ... }
   */
  initialize(config = {}) {
    const providerClasses = {
      openai: OpenAIProvider,
      anthropic: AnthropicProvider,
      google: GoogleProvider,
      meta: MetaProvider,
      mistral: MistralProvider,
      deepseek: DeepSeekProvider,
    };

    for (const [id, ProviderClass] of Object.entries(providerClasses)) {
      if (config[id]?.apiKey || config[id]?.enabled) {
        const provider = new ProviderClass(config[id]);
        this.providers.set(id, provider);

        // Index all models for fast lookup
        for (const model of provider.listModels()) {
          this.modelIndex.set(model.id, { providerId: id, modelId: model.id });
        }
      }
    }

    return this;
  }

  /**
   * Route a request to a specific model
   */
  async infer(request) {
    const entry = this.modelIndex.get(request.model);
    if (!entry) {
      throw new Error(`[Router] Unknown model: ${request.model}`);
    }

    const provider = this.providers.get(entry.providerId);
    if (!provider) {
      throw new Error(`[Router] Provider ${entry.providerId} not initialized`);
    }

    return provider.infer(request);
  }

  /**
   * Stream a request to a specific model
   */
  async *stream(request) {
    const entry = this.modelIndex.get(request.model);
    if (!entry) {
      throw new Error(`[Router] Unknown model: ${request.model}`);
    }

    const provider = this.providers.get(entry.providerId);
    if (!provider) {
      throw new Error(`[Router] Provider ${entry.providerId} not initialized`);
    }

    yield* provider.stream(request);
  }

  /**
   * Route by capability — find best model matching requirements
   * @param {string[]} requiredCapabilities
   * @param {'cost'|'latency'|'quality'} optimize
   */
  async inferByCapability(request, requiredCapabilities, optimize = 'cost') {
    const candidates = this.findModels(requiredCapabilities);
    if (candidates.length === 0) {
      throw new Error(`[Router] No model matches capabilities: ${requiredCapabilities.join(', ')}`);
    }

    // Sort by optimization target
    candidates.sort((a, b) => {
      switch (optimize) {
        case 'cost':
          return (a.model.costPerInputToken + a.model.costPerOutputToken) -
                 (b.model.costPerInputToken + b.model.costPerOutputToken);
        case 'quality':
          return (b.model.costPerInputToken + b.model.costPerOutputToken) -
                 (a.model.costPerInputToken + a.model.costPerOutputToken);
        default:
          return 0;
      }
    });

    // Try candidates in order (fallback chain)
    for (const candidate of candidates) {
      const provider = this.providers.get(candidate.providerId);
      if (!provider || !provider.healthy) continue;

      try {
        return await provider.infer({ ...request, model: candidate.model.id });
      } catch (err) {
        // Try next candidate
        continue;
      }
    }

    throw new Error(`[Router] All providers failed for capabilities: ${requiredCapabilities.join(', ')}`);
  }

  /**
   * Find all models matching required capabilities
   */
  findModels(requiredCapabilities) {
    const results = [];

    for (const [providerId, provider] of this.providers) {
      for (const model of provider.listModels()) {
        const hasAll = requiredCapabilities.every(cap => model.capabilities.includes(cap));
        if (hasAll) {
          results.push({ providerId, model });
        }
      }
    }

    return results;
  }

  /**
   * List all available models across all providers
   */
  listAllModels() {
    const models = [];
    for (const [providerId, provider] of this.providers) {
      for (const model of provider.listModels()) {
        models.push({ ...model, providerId });
      }
    }
    return models;
  }

  /**
   * Get aggregate health status
   */
  getStatus() {
    const statuses = {};
    for (const [id, provider] of this.providers) {
      statuses[id] = provider.getStatus();
    }
    return {
      totalProviders: this.providers.size,
      totalModels: this.modelIndex.size,
      providers: statuses,
    };
  }
}
