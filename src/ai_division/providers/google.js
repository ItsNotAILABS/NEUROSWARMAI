/**
 * CHIMERIA Provider — Google (Gemini)
 * Models: Gemini 2.5 Pro, Gemini Ultra, Gemini 2.5 Flash
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

import { ProviderAdapter } from './base.js';

export class GoogleProvider extends ProviderAdapter {
  constructor(config = {}) {
    super('google', {
      baseUrl: 'https://generativelanguage.googleapis.com/v1beta',
      requestsPerMinute: 360,
      tokensPerMinute: 4_000_000,
      ...config,
    });

    this.registerModel({
      id: 'gemini-2.5-pro',
      name: 'Gemini 2.5 Pro',
      maxInputTokens: 1_000_000,
      maxOutputTokens: 65_536,
      capabilities: ['reasoning', 'code', 'vision', 'multimodal', 'function_calling'],
      costPerInputToken: 0.00000125,
      costPerOutputToken: 0.000005,
    });

    this.registerModel({
      id: 'gemini-ultra',
      name: 'Gemini Ultra',
      maxInputTokens: 1_000_000,
      maxOutputTokens: 65_536,
      capabilities: ['reasoning', 'scientific', 'multimodal', 'code'],
      costPerInputToken: 0.000007,
      costPerOutputToken: 0.000021,
    });

    this.registerModel({
      id: 'gemini-2.5-flash',
      name: 'Gemini 2.5 Flash',
      maxInputTokens: 1_000_000,
      maxOutputTokens: 65_536,
      capabilities: ['reasoning', 'code', 'fast', 'multimodal'],
      costPerInputToken: 0.00000015,
      costPerOutputToken: 0.0000006,
    });
  }

  getAuthHeaders() {
    // Google uses API key as query param, but also supports header auth
    return { 'x-goog-api-key': this.apiKey };
  }

  async executeRequest(request, model) {
    const contents = this.convertMessages(request.messages);
    const body = {
      contents,
      generationConfig: {
        maxOutputTokens: request.maxTokens || model.maxOutputTokens,
        temperature: request.temperature ?? 0.7,
      },
    };

    const response = await this.fetch(
      `/models/${model.id}:generateContent`,
      { body }
    );
    const data = await response.json();

    const candidate = data.candidates?.[0];
    const text = candidate?.content?.parts?.map(p => p.text).join('') || '';
    const usage = data.usageMetadata || {};

    return {
      id: `gemini-${Date.now()}`,
      model: model.id,
      content: text,
      finishReason: candidate?.finishReason || 'STOP',
      usage: {
        inputTokens: usage.promptTokenCount || 0,
        outputTokens: usage.candidatesTokenCount || 0,
      },
    };
  }

  async *executeStream(request, model) {
    const contents = this.convertMessages(request.messages);
    const body = {
      contents,
      generationConfig: {
        maxOutputTokens: request.maxTokens || model.maxOutputTokens,
        temperature: request.temperature ?? 0.7,
      },
    };

    const response = await this.fetch(
      `/models/${model.id}:streamGenerateContent?alt=sse`,
      { body }
    );
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
          const chunk = JSON.parse(payload);
          const text = chunk.candidates?.[0]?.content?.parts?.map(p => p.text).join('') || '';
          if (text) {
            yield { content: text, done: false };
          }
          if (chunk.candidates?.[0]?.finishReason) {
            yield { content: '', done: true };
            return;
          }
        } catch { /* skip */ }
      }
    }
  }

  /**
   * Convert OpenAI-style messages to Gemini contents format
   */
  convertMessages(messages) {
    const contents = [];
    for (const msg of messages) {
      if (msg.role === 'system') {
        // Gemini treats system as a user message with systemInstruction
        contents.unshift({ role: 'user', parts: [{ text: `[System] ${msg.content}` }] });
      } else {
        contents.push({
          role: msg.role === 'assistant' ? 'model' : 'user',
          parts: [{ text: msg.content }],
        });
      }
    }
    return contents;
  }

  async executeHealthCheck() {
    await this.fetch('/models', { method: 'GET' });
  }
}
