/**
 * CHIMERIA Provider — Meta (Llama)
 * Models: Llama 3.3 70B, Llama 4 Scout, Llama 4 Maverick
 *
 * Uses OpenAI-compatible API (via together.ai, fireworks, or self-hosted vLLM).
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

import { ProviderAdapter } from './base.js';

export class MetaProvider extends ProviderAdapter {
  constructor(config = {}) {
    super('meta', {
      baseUrl: config.baseUrl || 'https://api.together.xyz/v1',
      requestsPerMinute: 600,
      tokensPerMinute: 1_000_000,
      ...config,
    });

    this.registerModel({
      id: 'llama-3.3-70b',
      name: 'Llama 3.3 70B Instruct',
      maxInputTokens: 128_000,
      maxOutputTokens: 16_384,
      capabilities: ['reasoning', 'code', 'language', 'function_calling'],
      costPerInputToken: 0.0000009,
      costPerOutputToken: 0.0000009,
    });

    this.registerModel({
      id: 'llama-4-scout',
      name: 'Llama 4 Scout',
      maxInputTokens: 512_000,
      maxOutputTokens: 32_768,
      capabilities: ['reasoning', 'code', 'vision', 'multimodal'],
      costPerInputToken: 0.00000015,
      costPerOutputToken: 0.0000006,
    });

    this.registerModel({
      id: 'llama-4-maverick',
      name: 'Llama 4 Maverick',
      maxInputTokens: 1_000_000,
      maxOutputTokens: 65_536,
      capabilities: ['reasoning', 'code', 'vision', 'multimodal', 'scientific'],
      costPerInputToken: 0.0000003,
      costPerOutputToken: 0.0000009,
    });
  }

  getAuthHeaders() {
    return { 'Authorization': 'Bearer ' + this.apiKey };
  }

  /**
   * Map our model IDs to provider-specific model names
   */
  resolveModelName(modelId) {
    const map = {
      'llama-3.3-70b': 'meta-llama/Llama-3.3-70B-Instruct-Turbo',
      'llama-4-scout': 'meta-llama/Llama-4-Scout-17B-16E-Instruct',
      'llama-4-maverick': 'meta-llama/Llama-4-Maverick-17B-128E-Instruct',
    };
    return map[modelId] || modelId;
  }

  async executeRequest(request, model) {
    const body = {
      model: this.resolveModelName(model.id),
      messages: request.messages,
      max_tokens: request.maxTokens || model.maxOutputTokens,
      temperature: request.temperature ?? 0.7,
    };

    const response = await this.fetch('/chat/completions', { body });
    const data = await response.json();

    return {
      id: data.id,
      model: data.model,
      content: data.choices?.[0]?.message?.content || '',
      finishReason: data.choices?.[0]?.finish_reason || 'stop',
      usage: {
        inputTokens: data.usage?.prompt_tokens || 0,
        outputTokens: data.usage?.completion_tokens || 0,
      },
    };
  }

  async *executeStream(request, model) {
    const body = {
      model: this.resolveModelName(model.id),
      messages: request.messages,
      max_tokens: request.maxTokens || model.maxOutputTokens,
      temperature: request.temperature ?? 0.7,
      stream: true,
    };

    const response = await this.fetch('/chat/completions', { body });
    const reader = response.body.getReader();
    const decoder = new TextDecoder();
    let buffer = '';

    while (true) {
      const { done, value } = await reader.read();
      if (done) break;

      buffer += decoder.decode(value, { stream: true });
      const lines = buffer.split('\n');
      buffer = lines.pop() || '';

      for (const line of lines) {
        if (!line.startsWith('data: ')) continue;
        const payload = line.slice(6).trim();
        if (payload === '[DONE]') {
          yield { content: '', done: true };
          return;
        }

        try {
          const chunk = JSON.parse(payload);
          const content = chunk.choices?.[0]?.delta?.content || '';
          if (content) yield { content, done: false };
        } catch { /* skip */ }
      }
    }
  }

  async executeHealthCheck() {
    await this.fetch('/models', { method: 'GET' });
  }
}
