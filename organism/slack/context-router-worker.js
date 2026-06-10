/**
 * Context Router Worker — Micro-Token Budget Enforcer
 *
 * Per beat, selects the top-K relevant models, injects only those into the cognition layer,
 * enforces the micro-token budget. The organism never loads all 300 models — it pulls
 * the 3-5 most resonant ones per beat.
 *
 * Features:
 * - Cosine similarity ranking against query
 * - Domain filtering
 * - Input type matching
 * - Micro-token budget enforcement
 * - Beat-synchronized model selection
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 */

const PHI = 1.618033988749895;
const DEFAULT_TOP_K = 5; // Default number of models to select
const MICRO_TOKEN_BUDGET = 2000; // Max tokens to inject per beat

// ════════════════════════════════════════════════════════════════
// VECTOR OPERATIONS
// ════════════════════════════════════════════════════════════════

function cosineSimilarity(vec1, vec2) {
  if (!vec1 || !vec2 || vec1.length !== vec2.length) return 0;

  let dotProduct = 0;
  let norm1 = 0;
  let norm2 = 0;

  for (let i = 0; i < vec1.length; i++) {
    dotProduct += vec1[i] * vec2[i];
    norm1 += vec1[i] * vec1[i];
    norm2 += vec2[i] * vec2[i];
  }

  if (norm1 === 0 || norm2 === 0) return 0;
  return dotProduct / (Math.sqrt(norm1) * Math.sqrt(norm2));
}

function generateQueryEmbedding(text, dims = 1024) {
  const hash = text.split('').reduce((acc, char) => {
    return ((acc << 5) - acc) + char.charCodeAt(0);
  }, 0);

  const embedding = [];
  let rng = Math.abs(hash);

  for (let i = 0; i < dims; i++) {
    rng = (rng * 1103515245 + 12345) & 0x7fffffff;
    embedding.push((rng / 0x7fffffff) * 2 - 1);
  }

  return embedding;
}

// ════════════════════════════════════════════════════════════════
// ROUTER STATE
// ════════════════════════════════════════════════════════════════

let routerState = {
  models: [], // Cached model registry
  lastSync: 0,
  totalRoutes: 0,
  routeHistory: [], // Last 89 routes
};

// ════════════════════════════════════════════════════════════════
// CONTEXT ROUTER LOGIC
// ════════════════════════════════════════════════════════════════

/**
 * Select top-K models based on context
 */
function selectModels(context, topK = DEFAULT_TOP_K, filters = {}) {
  const { domain, inputType, minSuccessRate = 0 } = filters;

  // Generate query embedding from context
  const queryEmbedding = generateQueryEmbedding(context.query || '', 1024);

  // Filter models
  let candidates = routerState.models;

  if (domain) {
    candidates = candidates.filter(m => m.domain === domain);
  }

  if (inputType) {
    candidates = candidates.filter(m => m.inputTypes.includes(inputType));
  }

  if (minSuccessRate > 0) {
    candidates = candidates.filter(m => m.successRate >= minSuccessRate);
  }

  // Compute similarities
  const scored = candidates.map(model => {
    const similarity = cosineSimilarity(queryEmbedding, model.embedding);

    // Adjust score based on model performance
    const performanceBoost = model.successRate * 0.2; // Up to +0.2
    const recencyBoost = model.lastAccess > Date.now() - 3600000 ? 0.1 : 0; // +0.1 if used in last hour

    const finalScore = similarity + performanceBoost + recencyBoost;

    return {
      modelId: model.id,
      name: model.name,
      domain: model.domain,
      similarity,
      performanceBoost,
      recencyBoost,
      finalScore,
      successRate: model.successRate,
      averageExecutionTime: model.averageExecutionTime,
    };
  });

  // Sort by final score
  scored.sort((a, b) => b.finalScore - a.finalScore);

  // Take top-K
  const selected = scored.slice(0, topK);

  // Enforce micro-token budget
  const budgetEnforced = enforceMicroTokenBudget(selected, context);

  // Record route
  routerState.totalRoutes++;
  routerState.routeHistory.push({
    timestamp: Date.now(),
    context: context.query || '',
    selectedModels: budgetEnforced.map(s => s.modelId),
    topK,
  });

  // Keep only last 89 routes
  if (routerState.routeHistory.length > 89) {
    routerState.routeHistory = routerState.routeHistory.slice(-89);
  }

  return budgetEnforced;
}

/**
 * Enforce micro-token budget
 * Estimate tokens and truncate if necessary
 */
function enforceMicroTokenBudget(selected, context) {
  // Estimate tokens (rough: 1 token ≈ 4 chars)
  const contextTokens = Math.ceil((context.query || '').length / 4);
  let remainingBudget = MICRO_TOKEN_BUDGET - contextTokens;

  const budgetEnforced = [];

  for (const model of selected) {
    // Estimate model overhead (metadata + execution)
    const modelTokens = 100; // Base overhead per model

    if (remainingBudget >= modelTokens) {
      budgetEnforced.push(model);
      remainingBudget -= modelTokens;
    } else {
      // Budget exhausted
      break;
    }
  }

  return budgetEnforced;
}

/**
 * Sync model registry from model-registry worker
 */
function syncModels(models) {
  routerState.models = models.map(m => ({
    id: m.id,
    name: m.name,
    domain: m.domain,
    embedding: m.embedding || [],
    inputTypes: m.inputTypes || ['text'],
    successRate: m.successRate || 0,
    averageExecutionTime: m.averageExecutionTime || 0,
    lastAccess: m.lastAccess || Date.now(),
  }));

  routerState.lastSync = Date.now();
  console.log(`[CONTEXT ROUTER] Synced ${routerState.models.length} models`);
}

/**
 * Get routing statistics
 */
function getStats() {
  return {
    totalModels: routerState.models.length,
    totalRoutes: routerState.totalRoutes,
    lastSync: routerState.lastSync,
    recentRoutes: routerState.routeHistory.slice(-10).map(r => ({
      timestamp: r.timestamp,
      context: r.context.slice(0, 50),
      selectedModels: r.selectedModels,
      topK: r.topK,
    })),
    modelUsage: getModelUsageStats(),
  };
}

/**
 * Get model usage statistics from route history
 */
function getModelUsageStats() {
  const usage = new Map();

  routerState.routeHistory.forEach(route => {
    route.selectedModels.forEach(modelId => {
      usage.set(modelId, (usage.get(modelId) || 0) + 1);
    });
  });

  return Array.from(usage.entries())
    .map(([modelId, count]) => ({ modelId, count }))
    .sort((a, b) => b.count - a.count)
    .slice(0, 20); // Top 20 most used models
}

/**
 * Get model recommendations (no execution, just selection)
 */
function getRecommendations(context, topK = DEFAULT_TOP_K, filters = {}) {
  return selectModels(context, topK, filters);
}

// ════════════════════════════════════════════════════════════════
// MESSAGE HANDLER
// ════════════════════════════════════════════════════════════════

self.onmessage = function(e) {
  const { type, requestId } = e.data;

  try {
    switch (type) {
      case 'HEARTBEAT':
        self.postMessage({ type: 'HEARTBEAT_ACK', beat: e.data.beat });
        break;

      case 'SYNC_MODELS':
        syncModels(e.data.models);
        self.postMessage({
          type: 'SYNC_COMPLETE',
          requestId,
        });
        break;

      case 'GET_MODELS':
        const recommendations = getRecommendations(
          e.data.context,
          e.data.topK,
          e.data.filters || {}
        );
        self.postMessage({
          type: 'ROUTER_RESPONSE',
          requestId,
          models: recommendations,
        });
        break;

      case 'SELECT':
        const selected = selectModels(
          e.data.context,
          e.data.topK,
          e.data.filters || {}
        );
        self.postMessage({
          type: 'SELECT_RESPONSE',
          requestId,
          models: selected,
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
        console.warn('[CONTEXT ROUTER] Unknown message type:', type);
    }
  } catch (err) {
    console.error('[CONTEXT ROUTER] Error processing message:', err);
    self.postMessage({
      type: 'ERROR',
      requestId,
      error: err.message,
    });
  }
};

console.log('[CONTEXT ROUTER] Worker initialized ✓');
console.log(`[CONTEXT ROUTER] Micro-token budget: ${MICRO_TOKEN_BUDGET} tokens per beat`);
console.log(`[CONTEXT ROUTER] Default top-K: ${DEFAULT_TOP_K} models`);
