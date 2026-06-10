/**
 * CHIMERIA Provider — Mistral
 * Models: Mistral Large, Codestral, Mixtral
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

import { ProviderAdapter } from './base.js';

export class MistralProvider extends ProviderAdapter {
  constructor(config = {}) {
    super('mistral', {
      baseUrl: 'https://api.mistral.ai/v1',
      requestsPerMinute: 120,
      tokensPerMinute: 500_000,
      ...config,
    });

    this.registerModel({
      id: 'mistral-large',
      name: 'Mistral Large',
      maxInputTokens: 128_000,
      maxOutputTokens: 32_768,
      capabilities: ['reasoning', 'code', 'language', 'function_calling'],
      costPerInputToken: 0.000002,
      costPerOutputToken: 0.000006,
    });

    this.registerModel({
      id: 'codestral',
      name: 'Codestral',
      maxInputTokens: 256_000,
      maxOutputTokens: 32_768,
      capabilities: ['code', 'reasoning', 'fast'],
      costPerInputToken: 0.0000003,
      costPerOutputToken: 0.0000009,
    });

    this.registerModel({
      id: 'mixtral-8x22b',
      name: 'Mixtral 8x22B',
      maxInputTokens: 65_536,
      maxOutputTokens: 16_384,
      capabilities: ['reasoning', 'language', 'code'],
      costPerInputToken: 0.000002,
      costPerOutputToken: 0.000006,
    });
  }

  getAuthHeaders() {
    return { 'Authorization': 'Bearer ' + this.apiKey };
  }

  async executeRequest(request, model) {
    const body = {
      model: model.id,
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
      model: model.id,
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
