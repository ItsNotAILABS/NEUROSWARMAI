/**
 * CHIMERIA Provider — Anthropic
 * Models: Claude Opus, Claude Sonnet, Claude Haiku
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

import { ProviderAdapter } from './base.js';

const ANTHROPIC_VERSION = '2023-06-01';

export class AnthropicProvider extends ProviderAdapter {
  constructor(config = {}) {
    super('anthropic', {
      baseUrl: 'https://api.anthropic.com/v1',
      requestsPerMinute: 50,
      tokensPerMinute: 100_000,
      ...config,
    });

    this.registerModel({
      id: 'claude-opus-4',
      name: 'Claude Opus 4',
      maxInputTokens: 200_000,
      maxOutputTokens: 32_000,
      capabilities: ['reasoning', 'code', 'language', 'scientific', 'vision'],
      costPerInputToken: 0.000015,
      costPerOutputToken: 0.000075,
    });

    this.registerModel({
      id: 'claude-sonnet-4',
      name: 'Claude Sonnet 4',
      maxInputTokens: 200_000,
      maxOutputTokens: 64_000,
      capabilities: ['reasoning', 'code', 'language', 'vision', 'function_calling'],
      costPerInputToken: 0.000003,
      costPerOutputToken: 0.000015,
    });

    this.registerModel({
      id: 'claude-haiku-3.5',
      name: 'Claude Haiku 3.5',
      maxInputTokens: 200_000,
      maxOutputTokens: 8_192,
      capabilities: ['language', 'code', 'fast', 'function_calling'],
      costPerInputToken: 0.0000008,
      costPerOutputToken: 0.000004,
    });
  }

  getAuthHeaders() {
    return {
      'x-api-key': this.apiKey,
      'anthropic-version': ANTHROPIC_VERSION,
    };
  }

  async executeRequest(request, model) {
    const body = {
      model: model.id,
      max_tokens: request.maxTokens || model.maxOutputTokens,
      messages: request.messages.filter(m => m.role !== 'system'),
    };

    // Anthropic uses a separate system parameter
    const systemMsg = request.messages.find(m => m.role === 'system');
    if (systemMsg) {
      body.system = systemMsg.content;
    }

    if (request.temperature !== undefined) {
      body.temperature = request.temperature;
    }

    const response = await this.fetch('/messages', { body });
    const data = await response.json();

    return {
      id: data.id,
      model: data.model,
      content: data.content?.[0]?.text || '',
      finishReason: data.stop_reason || 'end_turn',
      usage: {
        inputTokens: data.usage?.input_tokens || 0,
        outputTokens: data.usage?.output_tokens || 0,
      },
    };
  }

  async *executeStream(request, model) {
    const body = {
      model: model.id,
      max_tokens: request.maxTokens || model.maxOutputTokens,
      messages: request.messages.filter(m => m.role !== 'system'),
      stream: true,
    };

    const systemMsg = request.messages.find(m => m.role === 'system');
    if (systemMsg) {
      body.system = systemMsg.content;
    }

    const response = await this.fetch('/messages', { body });
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

        try {
          const event = JSON.parse(payload);
          if (event.type === 'content_block_delta' && event.delta?.text) {
            yield { content: event.delta.text, done: false };
          } else if (event.type === 'message_stop') {
            yield { content: '', done: true };
            return;
          }
        } catch { /* skip malformed */ }
      }
    }
  }

  async executeHealthCheck() {
    // Anthropic doesn't have a /models endpoint; use a lightweight message
    await this.fetch('/messages', {
      body: {
        model: 'claude-haiku-3.5',
        max_tokens: 1,
        messages: [{ role: 'user', content: 'ping' }],
      },
    });
  }
}
