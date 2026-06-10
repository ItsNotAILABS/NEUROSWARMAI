# Slack AI Workers — PARALLAX Architecture

## Overview

AI workers for Slack built with PARALLAX architecture. **PARALLAX doesn't need a 1M token window** because it doesn't stuff everything into one prompt. Instead, it uses micro-tokenization to route only the relevant context.

## Architecture Components

### 1. MEMORIA — Sovereign Memory Canister
**File**: `memoria-worker.js`

- Retrieves only what's relevant per beat (2,000 tokens that matter, not 1M)
- Vector embeddings via amazon.titan-embed-text-v2 (1,024 dims)
- Cosine similarity retrieval (not key lookup)
- FNV-1a hashing for fast sovereign ID lookup
- Fibonacci limits: F13 (233) memories per category

### 2. CODEX MATHEMATICUS — Formula Registry
**File**: `codex-worker.js`

- All formulas and laws live here, callable on demand
- Not in context window. In the canister.
- High-precision embeddings via text-embedding-3-large (3,072 dims)
- Seeded with φ-geometry, Kuramoto, Hebbian, ACO, physics formulas
- LaTeX rendering support

### 3. Model Registry — M-01 through M-300
**File**: `model-registry-worker.js`

- 300 models as real 4-layer MEDINA-ARTIFACTs
- Each model has:
  - **Semantic Layer**: Description, keywords
  - **Contextual Layer**: Input types, output format
  - **Execution Layer**: Callable function, timeout
  - **Result Layer**: Success rate, average execution time
- Vector embedding at formation (1,024 dims)
- FNV-1a hash per artifact (256-dim sovereign ID)
- Multimodal input registry (text, image, PDF)

### 4. ContextRouter — Micro-Token Budget Enforcer
**File**: `context-router-worker.js`

- **The organism never loads all 300 models**
- Pulls 3-5 most resonant models per beat
- Cosine similarity ranking
- Performance-based scoring (success rate + recency)
- Enforces 2,000 token budget per beat
- Domain and input type filtering

### 5. Embedding Worker — Vector Embedding Layer
**File**: `embedding-worker.js`

- HTTP outcalls for vector embeddings (production)
- amazon.titan-embed-text-v2 (1,024 dims) for semantic retrieval
- text-embedding-3-large (3,072 dims) for CODEX MATHEMATICUS
- Embedding cache for performance
- Batch embedding support

### 6. Slack Bridge — Integration Layer
**File**: `slack-bridge-worker.js`

- Orchestrates the full PARALLAX flow:
  1. Receive Slack message
  2. Query MEMORIA for relevant context
  3. Query CODEX for applicable formulas
  4. Get top-K models from ContextRouter
  5. Execute selected models
  6. Store results in MEMORIA
  7. Return response to Slack

## SSC (ΣΩ Fibonacci Registry)

**File**: `src/backend/genesis/sovereign-db.mo`

All state persists in stable vars. Not in memory. In the organism's body.

- `MedinaArtifact`: 4-layer model structure
- `MemoriaEntry`: Memory with vector embedding
- `CodexFormula`: Formula with LaTeX and embedding
- Cosine similarity functions
- FNV-1a hash for sovereign IDs
- Semantic retrieval for all registries

## Usage

### Initialize Slack Orchestrator

```javascript
import { SlackOrchestrator } from '/organism/slack/slack-orchestrator.js';

const slack = new SlackOrchestrator();
slack.spawn(); // Spawn all 6 workers

// Process Slack message
const result = await slack.processSlackMessage({
  text: 'Explain Kuramoto synchronization',
  user: 'U12345',
  channel: 'C67890',
});

console.log(result.response);
// Only 2,000 relevant tokens loaded, not 1M
```

### Query MEMORIA Directly

```javascript
const memories = await slack.queryMemoria('synchronization', 5);
// Returns top-5 most relevant memories by cosine similarity
```

### Get Model Recommendations

```javascript
const models = await slack.getRelevantModels({
  query: 'analyze network topology',
}, 5);
// Returns 3-5 most resonant models, not all 300
```

## Micro-Tokenization Flow

```
Slack Message
    ↓
MEMORIA Query → Top-5 relevant memories (cosine similarity)
    ↓
CODEX Query → Top-3 applicable formulas
    ↓
ContextRouter → Top-5 models (3-5 most resonant, not all 300)
    ↓
Execute Models → Parallel execution
    ↓
Synthesize Response
    ↓
Store in MEMORIA
    ↓
Return to Slack
```

**Total context loaded**: ~2,000 tokens (relevant slice)
**Traditional approach**: 1M tokens (everything)

**Result**: Architecturally superior. Faster. Cheaper. More precise.

## φ-Beat Synchronization

All workers synchronize on PHI_BEAT = 873ms (φ⁴ × Schumann period).

- Every beat: Heartbeat broadcast
- Every F11 (89) beats: MEMORIA cleanup
- Beat-synchronized model selection

## Worker Fleet

| Worker ID | File | Domain | Purpose |
|-----------|------|--------|---------|
| `memoria` | `memoria-worker.js` | memory | Sovereign memory with vector retrieval |
| `codex` | `codex-worker.js` | knowledge | Formula and law registry |
| `context-router` | `context-router-worker.js` | routing | Top-K model selection, micro-token budget |
| `model-registry` | `model-registry-worker.js` | models | M-01 through M-300 MEDINA-ARTIFACTs |
| `embedding` | `embedding-worker.js` | vectorization | Vector embedding HTTP outcalls |
| `slack-bridge` | `slack-bridge-worker.js` | integration | Slack integration orchestrator |

## Model Distribution (M-01 through M-300)

Models are distributed across 34 domains:
- reasoning, logic, memory, comprehension, decision
- surveillance, networking, will, inquiry, prediction
- temporal, causality, quantum, emergence, collective
- wisdom, sovereignty, economics, protocol, governance
- career, infrastructure, swarm, evolution, transcendence
- intelligence, perception, synthesis, optimization, creativity
- analysis, computation, communication, coordination
- (and more...)

## Production Deployment

### Vector Embeddings

Replace mock embeddings with HTTP outcalls:

```motoko
// In embedding-worker.js, replace mockGenerateEmbedding with:
const response = await fetch('https://api.aws.amazon.com/bedrock/...', {
  method: 'POST',
  headers: { 'Authorization': '...' },
  body: JSON.stringify({ text, model: 'amazon.titan-embed-text-v2' }),
});
```

### ICP Integration

Wire to main.mo canister:

```motoko
import SovereignDB "genesis/sovereign-db";

let sovereignDB = SovereignDB.initState();

public shared func registerModel(...): async Text {
  SovereignDB.registerModel(sovereignDB, ...);
};

public query func queryModels(embedding: [Float], topK: Nat): async [SovereignDB.MedinaArtifact] {
  SovereignDB.queryModels(sovereignDB, embedding, topK);
};
```

## Key Advantages

1. **No 1M Token Window Needed**: Micro-tokenization loads only 2,000 relevant tokens
2. **Fast Retrieval**: Vector similarity, not sequential scan
3. **Scalable**: 300 models, but only 3-5 loaded per beat
4. **Persistent State**: All in stable vars (SSC Fibonacci Registry)
5. **φ-Synchronized**: 873ms heartbeat across all workers

## COPYRIGHT

© 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.

MEDINA DOCTRINE | DALLAS, TX | 2026
