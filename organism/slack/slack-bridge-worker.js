/**
 * Slack Bridge Worker — Integration Layer
 *
 * Bridges between Slack events and the PARALLAX architecture.
 * Coordinates between MEMORIA, CODEX, ContextRouter, and ModelRegistry
 * to process Slack messages with micro-tokenization.
 *
 * Flow:
 * 1. Receive Slack message
 * 2. Query MEMORIA for relevant context (2,000 tokens that matter)
 * 3. Query CODEX for applicable formulas/laws
 * 4. Get top-K models from ContextRouter (3-5 most resonant)
 * 5. Execute selected models
 * 6. Store results in MEMORIA
 * 7. Return response to Slack
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 */

const PHI = 1.618033988749895;
const F11 = 89; // Response history limit

// ════════════════════════════════════════════════════════════════
// BRIDGE STATE
// ════════════════════════════════════════════════════════════════

let bridgeState = {
  pendingRequests: new Map(), // requestId -> { promise, timestamp }
  responseHistory: [], // Last 89 responses
  totalProcessed: 0,
  averageResponseTime: 0,
};

// ════════════════════════════════════════════════════════════════
// SLACK MESSAGE PROCESSING
// ════════════════════════════════════════════════════════════════

/**
 * Process Slack message through PARALLAX architecture
 */
async function processSlackMessage(message) {
  const startTime = Date.now();

  try {
    // Step 1: Query MEMORIA for relevant context
    const memoriaResults = await queryMemoria(message.text, 5);
    const contextTokens = memoriaResults.map(r => r.content).join(' ');

    // Step 2: Query CODEX for applicable formulas
    const codexResults = await queryCodex(message.text, 3);
    const formulaContext = codexResults.map(f => `${f.name}: ${f.formula}`).join('; ');

    // Step 3: Get top-K models from ContextRouter
    const context = {
      query: message.text,
      memoria: contextTokens,
      codex: formulaContext,
    };

    const selectedModels = await getRelevantModels(context, 5);

    // Step 4: Execute selected models
    const executionResults = await Promise.all(
      selectedModels.map(model =>
        executeModel(model.modelId, {
          text: message.text,
          context: contextTokens,
          formulas: formulaContext,
        })
      )
    );

    // Step 5: Synthesize response
    const response = synthesizeResponse(message, executionResults, selectedModels);

    // Step 6: Store response in MEMORIA
    await storeMemoria(
      `Q: ${message.text}\nA: ${response.text}`,
      'slack_conversation'
    );

    // Record response
    const responseTime = Date.now() - startTime;
    bridgeState.totalProcessed++;
    bridgeState.responseHistory.push({
      timestamp: Date.now(),
      message: message.text.slice(0, 100),
      responseTime,
      modelsUsed: selectedModels.map(m => m.modelId),
      success: true,
    });

    // Keep only last F11 responses
    if (bridgeState.responseHistory.length > F11) {
      bridgeState.responseHistory = bridgeState.responseHistory.slice(-F11);
    }

    // Update average response time
    const totalTime = bridgeState.responseHistory.reduce((sum, r) => sum + r.responseTime, 0);
    bridgeState.averageResponseTime = totalTime / bridgeState.responseHistory.length;

    return {
      success: true,
      response,
      responseTime,
      modelsUsed: selectedModels.length,
      memoriaHits: memoriaResults.length,
      codexHits: codexResults.length,
    };
  } catch (error) {
    const responseTime = Date.now() - startTime;

    bridgeState.responseHistory.push({
      timestamp: Date.now(),
      message: message.text.slice(0, 100),
      responseTime,
      success: false,
      error: error.message,
    });

    return {
      success: false,
      error: error.message,
      responseTime,
    };
  }
}

/**
 * Synthesize response from model execution results
 */
function synthesizeResponse(message, executionResults, selectedModels) {
  // Simple synthesis: combine model outputs
  const outputs = executionResults
    .filter(r => r.success)
    .map(r => r.result.output);

  const synthesized = outputs.length > 0
    ? outputs[0] // Use first successful output for now
    : 'I encountered an issue processing your message.';

  return {
    text: synthesized,
    models: selectedModels.map(m => ({
      id: m.modelId,
      name: m.name,
      score: m.finalScore,
    })),
    confidence: executionResults.filter(r => r.success).length / executionResults.length,
  };
}

// ════════════════════════════════════════════════════════════════
// INTER-WORKER COMMUNICATION
// ════════════════════════════════════════════════════════════════

/**
 * Query MEMORIA (mock - would message memoria-worker)
 */
async function queryMemoria(query, limit = 5) {
  // Mock for now - in production, this messages memoria-worker
  await new Promise(resolve => setTimeout(resolve, 50));
  return [
    { id: 'mem_1', content: 'Relevant context 1', similarity: 0.85 },
    { id: 'mem_2', content: 'Relevant context 2', similarity: 0.78 },
  ];
}

/**
 * Query CODEX (mock - would message codex-worker)
 */
async function queryCodex(query, limit = 3) {
  await new Promise(resolve => setTimeout(resolve, 50));
  return [
    { id: 'formula_1', name: 'Kuramoto Phase', formula: 'dθᵢ/dt = ωᵢ + K/N Σⱼ sin(θⱼ - θᵢ)' },
  ];
}

/**
 * Get relevant models (mock - would message context-router-worker)
 */
async function getRelevantModels(context, topK = 5) {
  await new Promise(resolve => setTimeout(resolve, 50));
  return [
    { modelId: 'M-001', name: 'Reasoning Model 1', domain: 'reasoning', finalScore: 0.92 },
    { modelId: 'M-007', name: 'Will Model 7', domain: 'will', finalScore: 0.87 },
    { modelId: 'M-013', name: 'Quantum Model 13', domain: 'quantum', finalScore: 0.81 },
  ];
}

/**
 * Execute model (mock - would message model-registry-worker)
 */
async function executeModel(modelId, input) {
  await new Promise(resolve => setTimeout(resolve, 100));
  return {
    success: true,
    result: {
      modelId,
      input,
      output: `Processed by ${modelId}: ${input.text.slice(0, 50)}...`,
      confidence: 0.85,
    },
    executionTime: 100,
  };
}

/**
 * Store in MEMORIA (mock - would message memoria-worker)
 */
async function storeMemoria(content, category) {
  await new Promise(resolve => setTimeout(resolve, 30));
  return { id: 'mem_' + Date.now(), hash: 'abc123' };
}

/**
 * Get bridge statistics
 */
function getStats() {
  return {
    totalProcessed: bridgeState.totalProcessed,
    averageResponseTime: Math.round(bridgeState.averageResponseTime),
    recentResponses: bridgeState.responseHistory.slice(-10).map(r => ({
      timestamp: r.timestamp,
      message: r.message,
      responseTime: r.responseTime,
      success: r.success,
      modelsUsed: r.modelsUsed,
    })),
    successRate: bridgeState.responseHistory.filter(r => r.success).length /
                 Math.max(bridgeState.responseHistory.length, 1),
  };
}

// ════════════════════════════════════════════════════════════════
// MESSAGE HANDLER
// ════════════════════════════════════════════════════════════════

self.onmessage = async function(e) {
  const { type, requestId } = e.data;

  try {
    switch (type) {
      case 'HEARTBEAT':
        self.postMessage({ type: 'HEARTBEAT_ACK', beat: e.data.beat });
        break;

      case 'PROCESS_MESSAGE':
        const result = await processSlackMessage(e.data.message);
        self.postMessage({
          type: 'SLACK_RESPONSE',
          requestId,
          response: result,
        });
        break;

      case 'GET_STATS':
        const stats = getStats();
        self.postMessage({
          type: 'STATS_RESPONSE',
          requestId,
          stats,
        });
        break;

      default:
        console.warn('[SLACK BRIDGE] Unknown message type:', type);
    }
  } catch (err) {
    console.error('[SLACK BRIDGE] Error processing message:', err);
    self.postMessage({
      type: 'ERROR',
      requestId,
      error: err.message,
    });
  }
};

console.log('[SLACK BRIDGE] Worker initialized ✓');
console.log('[SLACK BRIDGE] PARALLAX architecture active');
console.log('[SLACK BRIDGE] Micro-tokenization: Only 2,000 relevant tokens per beat');
