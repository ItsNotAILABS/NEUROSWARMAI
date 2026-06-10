/**
 * CHIMERIA Provider — OpenAI
 * Models: GPT-4o, GPT-4.1, o1, o3, o4-mini
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

import { ProviderAdapter } from './base.js';

export class OpenAIProvider extends ProviderAdapter {
  constructor(config = {}) {
    super('openai', {
      baseUrl: 'https://api.openai.com/v1',
      requestsPerMinute: 500,
      tokensPerMinute: 800_000,
      ...config,
    });

    this.registerModel({
      id: 'gpt-4o',
      name: 'GPT-4o',
      maxInputTokens: 128_000,
      maxOutputTokens: 16_384,
      capabilities: ['reasoning', 'code', 'vision', 'multimodal', 'function_calling'],
      costPerInputToken: 0.0000025,
      costPerOutputToken: 0.00001,
    });

    this.registerModel({
      id: 'gpt-4.1',
      name: 'GPT-4.1',
      maxInputTokens: 1_000_000,
      maxOutputTokens: 32_768,
      capabilities: ['reasoning', 'code', 'language', 'function_calling'],
      costPerInputToken: 0.000002,
      costPerOutputToken: 0.000008,
    });

    this.registerModel({
      id: 'o1',
      name: 'o1',
      maxInputTokens: 200_000,
      maxOutputTokens: 100_000,
      capabilities: ['reasoning', 'scientific', 'math'],
      costPerInputToken: 0.000015,
      costPerOutputToken: 0.00006,
    });

    this.registerModel({
      id: 'o3',
      name: 'o3',
      maxInputTokens: 200_000,
      maxOutputTokens: 100_000,
      capabilities: ['reasoning', 'scientific', 'code', 'math'],
      costPerInputToken: 0.00001,
      costPerOutputToken: 0.00004,
    });

    this.registerModel({
      id: 'o4-mini',
      name: 'o4-mini',
      maxInputTokens: 200_000,
      maxOutputTokens: 100_000,
      capabilities: ['reasoning', 'code', 'fast'],
      costPerInputToken: 0.0000011,
      costPerOutputToken: 0.0000044,
    });
  }

  getAuthHeaders() {
    return { 'Authorization': 'Bearer ' + this.apiKey };
  }

  async executeRequest(request, model) {
    const isReasoningModel = model.id.startsWith('o');

    const body = {
      model: model.id,
      messages: request.messages,
      ...(isReasoningModel
        ? { max_completion_tokens: request.maxTokens || model.maxOutputTokens }
        : {
            max_tokens: request.maxTokens || model.maxOutputTokens,
            temperature: request.temperature ?? 0.7,
          }),
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
    const isReasoningModel = model.id.startsWith('o');

    const body = {
      model: model.id,
      messages: request.messages,
      stream: true,
      ...(isReasoningModel
        ? { max_completion_tokens: request.maxTokens || model.maxOutputTokens }
        : {
            max_tokens: request.maxTokens || model.maxOutputTokens,
            temperature: request.temperature ?? 0.7,
          }),
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
          if (content) {
            yield { content, done: false };
          }
        } catch { /* skip malformed chunks */ }
      }
    }
  }

  async executeHealthCheck() {
    await this.fetch('/models', { method: 'GET' });
  }
}
