/**
 * MEMORIA Worker — Sovereign Memory Canister
 *
 * Retrieves only what's relevant per beat. You don't load 1M tokens.
 * You load the 2,000 tokens that matter right now.
 *
 * Features:
 * - Vector embeddings via amazon.titan-embed-text-v2 (1,024 dims)
 * - Cosine similarity retrieval (not key lookup)
 * - Stable Float64 arrays for vector storage
 * - Micro-token compression for fast routing
 * - FNV-1a hashing for sovereign IDs
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 */

const PHI = 1.618033988749895;
const F13 = 233; // Max memories per category
const F11 = 89;  // Cleanup threshold

// ════════════════════════════════════════════════════════════════
// MEMORIA STATE
// ════════════════════════════════════════════════════════════════

let memoriaState = {
  memories: [], // Array of { id, content, embedding, timestamp, category, hash }
  categories: new Map(), // category -> memory IDs
  hashIndex: new Map(),  // FNV-1a hash -> memory ID
  totalRecalls: 0,
  lastCleanup: Date.now(),
};

// ════════════════════════════════════════════════════════════════
// FNV-1a HASH — 256-dim Micro-Token Compression
// ════════════════════════════════════════════════════════════════

function fnv1aHash(str) {
  const FNV_PRIME = 0x01000193;
  const FNV_OFFSET = 0x811c9dc5;

  let hash = FNV_OFFSET;

  for (let i = 0; i < str.length; i++) {
    hash ^= str.charCodeAt(i);
    hash = Math.imul(hash, FNV_PRIME);
  }

  return (hash >>> 0).toString(16).padStart(8, '0');
}

// ════════════════════════════════════════════════════════════════
// VECTOR OPERATIONS
// ════════════════════════════════════════════════════════════════

/**
 * Compute cosine similarity between two vectors
 */
function cosineSimilarity(vec1, vec2) {
  if (vec1.length !== vec2.length) return 0;

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

/**
 * Generate mock embedding for testing (will be replaced with HTTP outcalls)
 * In production, this calls amazon.titan-embed-text-v2
 */
function generateEmbedding(text, dims = 1024) {
  // Simple hash-based pseudo-embedding for testing
  const hash = fnv1aHash(text);
  const seed = parseInt(hash.slice(0, 8), 16);

  const embedding = [];
  let rng = seed;

  for (let i = 0; i < dims; i++) {
    // LCG pseudo-random number generator
    rng = (rng * 1103515245 + 12345) & 0x7fffffff;
    embedding.push((rng / 0x7fffffff) * 2 - 1); // Normalize to [-1, 1]
  }

  return embedding;
}

// ════════════════════════════════════════════════════════════════
// MEMORIA OPERATIONS
// ════════════════════════════════════════════════════════════════

/**
 * Store memory with vector embedding
 */
function storeMemory(content, category = 'general') {
  const id = `mem_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
  const hash = fnv1aHash(content);
  const embedding = generateEmbedding(content, 1024);

  const memory = {
    id,
    content,
    embedding,
    timestamp: Date.now(),
    category,
    hash,
    accessCount: 0,
    lastAccess: Date.now(),
  };

  memoriaState.memories.push(memory);
  memoriaState.hashIndex.set(hash, id);

  // Update category index
  if (!memoriaState.categories.has(category)) {
    memoriaState.categories.set(category, []);
  }
  memoriaState.categories.get(category).push(id);

  // Enforce Fibonacci limit per category
  const categoryMemories = memoriaState.categories.get(category);
  if (categoryMemories.length > F13) {
    const oldestId = categoryMemories.shift();
    const oldestIdx = memoriaState.memories.findIndex(m => m.id === oldestId);
    if (oldestIdx !== -1) {
      const oldMemory = memoriaState.memories[oldestIdx];
      memoriaState.memories.splice(oldestIdx, 1);
      memoriaState.hashIndex.delete(oldMemory.hash);
    }
  }

  return { id, hash };
}

/**
 * Query MEMORIA by semantic proximity (cosine similarity)
 */
function queryMemoria(query, limit = 5, category = null) {
  const queryEmbedding = generateEmbedding(query, 1024);

  // Filter by category if specified
  let candidates = memoriaState.memories;
  if (category) {
    const categoryIds = memoriaState.categories.get(category) || [];
    candidates = memoriaState.memories.filter(m => categoryIds.includes(m.id));
  }

  // Compute similarities
  const results = candidates.map(memory => ({
    ...memory,
    similarity: cosineSimilarity(queryEmbedding, memory.embedding),
  }));

  // Sort by similarity descending
  results.sort((a, b) => b.similarity - a.similarity);

  // Take top-K
  const topK = results.slice(0, limit);

  // Update access counts
  topK.forEach(result => {
    const memory = memoriaState.memories.find(m => m.id === result.id);
    if (memory) {
      memory.accessCount++;
      memory.lastAccess = Date.now();
    }
  });

  memoriaState.totalRecalls++;

  return topK.map(r => ({
    id: r.id,
    content: r.content,
    category: r.category,
    hash: r.hash,
    similarity: r.similarity,
    timestamp: r.timestamp,
  }));
}

/**
 * Get memory by hash (fast lookup)
 */
function getMemoryByHash(hash) {
  const id = memoriaState.hashIndex.get(hash);
  if (!id) return null;

  const memory = memoriaState.memories.find(m => m.id === id);
  if (memory) {
    memory.accessCount++;
    memory.lastAccess = Date.now();
  }

  return memory ? {
    id: memory.id,
    content: memory.content,
    category: memory.category,
    hash: memory.hash,
    timestamp: memory.timestamp,
  } : null;
}

/**
 * Cleanup old memories (every F11 beats)
 */
function cleanupMemoria() {
  const now = Date.now();
  const ONE_WEEK = 7 * 24 * 60 * 60 * 1000;

  // Remove memories older than 1 week with no recent access
  memoriaState.memories = memoriaState.memories.filter(memory => {
    const age = now - memory.timestamp;
    const timeSinceAccess = now - memory.lastAccess;

    if (age > ONE_WEEK && timeSinceAccess > ONE_WEEK) {
      memoriaState.hashIndex.delete(memory.hash);

      // Remove from category index
      const categoryMemories = memoriaState.categories.get(memory.category);
      if (categoryMemories) {
        const idx = categoryMemories.indexOf(memory.id);
        if (idx !== -1) categoryMemories.splice(idx, 1);
      }

      return false; // Remove this memory
    }

    return true; // Keep this memory
  });

  memoriaState.lastCleanup = now;
}

/**
 * Get MEMORIA stats
 */
function getStats() {
  return {
    totalMemories: memoriaState.memories.length,
    totalCategories: memoriaState.categories.size,
    totalRecalls: memoriaState.totalRecalls,
    lastCleanup: memoriaState.lastCleanup,
    categories: Array.from(memoriaState.categories.entries()).map(([cat, ids]) => ({
      category: cat,
      count: ids.length,
    })),
  };
}

// ════════════════════════════════════════════════════════════════
// MESSAGE HANDLER
// ════════════════════════════════════════════════════════════════

self.onmessage = function(e) {
  const { type, requestId } = e.data;

  try {
    switch (type) {
      case 'HEARTBEAT':
        // Acknowledge heartbeat
        self.postMessage({ type: 'HEARTBEAT_ACK', beat: e.data.beat });
        break;

      case 'STORE':
        const stored = storeMemory(e.data.content, e.data.category);
        self.postMessage({
          type: 'STORE_RESPONSE',
          requestId,
          result: stored,
        });
        break;

      case 'QUERY':
        const results = queryMemoria(e.data.query, e.data.limit, e.data.category);
        self.postMessage({
          type: 'MEMORIA_RESPONSE',
          requestId,
          results,
        });
        break;

      case 'GET_BY_HASH':
        const memory = getMemoryByHash(e.data.hash);
        self.postMessage({
          type: 'HASH_RESPONSE',
          requestId,
          memory,
        });
        break;

      case 'CLEANUP':
        cleanupMemoria();
        self.postMessage({
          type: 'CLEANUP_COMPLETE',
          beat: e.data.beat,
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
        console.warn('[MEMORIA] Unknown message type:', type);
    }
  } catch (err) {
    console.error('[MEMORIA] Error processing message:', err);
    self.postMessage({
      type: 'ERROR',
      requestId,
      error: err.message,
    });
  }
};

console.log('[MEMORIA] Worker initialized ✓');
