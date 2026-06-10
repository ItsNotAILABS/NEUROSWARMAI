/**
 * CHIMERIA Provider — DeepSeek
 * Models: DeepSeek-V3, DeepSeek-R1
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

import { ProviderAdapter } from './base.js';

export class DeepSeekProvider extends ProviderAdapter {
  constructor(config = {}) {
    super('deepseek', {
      baseUrl: 'https://api.deepseek.com',
      requestsPerMinute: 60,
      tokensPerMinute: 500_000,
      ...config,
    });

    this.registerModel({
      id: 'deepseek-chat',
      name: 'DeepSeek-V3',
      maxInputTokens: 128_000,
      maxOutputTokens: 8_192,
      capabilities: ['reasoning', 'code', 'language'],
      costPerInputToken: 0.00000027,
      costPerOutputToken: 0.0000011,
    });

    this.registerModel({
      id: 'deepseek-reasoner',
      name: 'DeepSeek-R1',
      maxInputTokens: 128_000,
      maxOutputTokens: 32_768,
      capabilities: ['reasoning', 'scientific', 'math', 'code'],
      costPerInputToken: 0.00000055,
      costPerOutputToken: 0.0000022,
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

    const choice = data.choices?.[0];

    return {
      id: data.id,
      model: data.model,
      content: choice?.message?.content || '',
      reasoningContent: choice?.message?.reasoning_content || null,
      finishReason: choice?.finish_reason || 'stop',
      usage: {
        inputTokens: data.usage?.prompt_tokens || 0,
        outputTokens: data.usage?.completion_tokens || 0,
        reasoningTokens: data.usage?.completion_tokens_details?.reasoning_tokens || 0,
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
