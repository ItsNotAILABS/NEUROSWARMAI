/**
 * Search Worker — SEARCH-001–021: Full-Text & Semantic Search Engine
 */
const PHI = 1.618033988749895;
const PHI_INV = 1 / PHI;
const PHI_BEAT = 873;
const F8=21,F9=34,F10=55,F11=89,F12=144,F13=233,F14=377,F15=610,F16=987,F17=1597,F18=2584,F19=4181;
const INDEX_INTERVAL   = F11; // 89 beats
const OPTIMIZE_INTERVAL= F12; // 144 beats
let beatCount = 0, docCounter = 0, indexVersion = 0;

const TOOL_REGISTRY = [
  { id: 'SEARCH-001', name: 'index',      category: 'write', description: 'Index a document' },
  { id: 'SEARCH-002', name: 'search',     category: 'read',  description: 'Full-text search query' },
  { id: 'SEARCH-003', name: 'suggest',    category: 'read',  description: 'Autocomplete suggestions' },
  { id: 'SEARCH-004', name: 'facet',      category: 'read',  description: 'Faceted search with counts' },
  { id: 'SEARCH-005', name: 'rank',       category: 'read',  description: 'Re-rank results by model' },
  { id: 'SEARCH-006', name: 'reindex',    category: 'admin', description: 'Rebuild inverted index' },
  { id: 'SEARCH-007', name: 'snapshot',   category: 'admin', description: 'Snapshot index state' },
  { id: 'SEARCH-008', name: 'delete',     category: 'write', description: 'Remove document from index' },
  { id: 'SEARCH-009', name: 'bulk',       category: 'write', description: 'Bulk index documents' },
  { id: 'SEARCH-010', name: 'filter',     category: 'read',  description: 'Filter by field predicates' },
  { id: 'SEARCH-011', name: 'highlight',  category: 'read',  description: 'Highlight matching terms' },
  { id: 'SEARCH-012', name: 'explain',    category: 'read',  description: 'Explain relevance score' },
  { id: 'SEARCH-013', name: 'more-like',  category: 'read',  description: 'More-like-this query' },
  { id: 'SEARCH-014', name: 'aggregate',  category: 'read',  description: 'Aggregate field values' },
  { id: 'SEARCH-015', name: 'geo',        category: 'read',  description: 'Geo-bounded search' },
  { id: 'SEARCH-016', name: 'semantic',   category: 'read',  description: 'Semantic vector similarity' },
  { id: 'SEARCH-017', name: 'stats',      category: 'read',  description: 'Index statistics' },
  { id: 'SEARCH-018', name: 'optimize',   category: 'admin', description: 'Optimize index segments' },
  { id: 'SEARCH-019', name: 'export',     category: 'admin', description: 'Export document store' },
  { id: 'SEARCH-020', name: 'import',     category: 'admin', description: 'Import document store' },
  { id: 'SEARCH-021', name: 'health',     category: 'admin', description: 'Search engine health' },
];

// Document store — max F19=4181 docs
const docStore = new Map();
// Inverted index — term → Set<docId>
const invertedIndex = new Map();
// Ranking model — term → PHI-weighted IDF score
const idfScores = new Map();

function tokenize(text) {
  return String(text).toLowerCase().replace(/[^\w\s]/g, ' ').split(/\s+/).filter(t => t.length > 1);
}

function indexDocument(doc) {
  if (docStore.size >= F19 && !docStore.has(doc.id)) {
    const oldest = [...docStore.keys()][0];
    removeDocument(oldest);
  }
  const id = doc.id || `DOC-${++docCounter}`;
  const entry = { ...doc, id, indexedAt: Date.now(), _tokens: [] };
  const tokens = tokenize([doc.title, doc.body, doc.tags].filter(Boolean).join(' '));
  entry._tokens = tokens;
  docStore.set(id, entry);
  for (const term of tokens) {
    if (!invertedIndex.has(term)) invertedIndex.set(term, new Set());
    invertedIndex.get(term).add(id);
  }
  return id;
}

function removeDocument(docId) {
  const doc = docStore.get(docId);
  if (!doc) return false;
  for (const term of doc._tokens || []) {
    const posting = invertedIndex.get(term);
    if (posting) { posting.delete(docId); if (posting.size === 0) invertedIndex.delete(term); }
  }
  docStore.delete(docId);
  return true;
}

function computeIDF() {
  const N = docStore.size || 1;
  for (const [term, docs] of invertedIndex) {
    idfScores.set(term, Math.log(N / docs.size) * PHI);
  }
}

function searchQuery(query, limit = F8) {
  const terms = tokenize(query);
  const scores = new Map();
  for (const term of terms) {
    const posting = invertedIndex.get(term);
    if (!posting) continue;
    const idf = idfScores.get(term) || PHI_INV;
    for (const docId of posting) {
      const doc = docStore.get(docId);
      if (!doc) continue;
      const tf = doc._tokens.filter(t => t === term).length / doc._tokens.length;
      scores.set(docId, (scores.get(docId) || 0) + tf * idf);
    }
  }
  return [...scores.entries()]
    .sort((a, b) => b[1] - a[1])
    .slice(0, limit)
    .map(([docId, score]) => ({ ...docStore.get(docId), _score: score.toFixed(4), _tokens: undefined }));
}

function suggestTerms(prefix, limit = F8) {
  prefix = prefix.toLowerCase();
  return [...invertedIndex.keys()].filter(t => t.startsWith(prefix)).slice(0, limit);
}

function rebuildIndex() {
  invertedIndex.clear();
  for (const doc of docStore.values()) {
    for (const term of doc._tokens || []) {
      if (!invertedIndex.has(term)) invertedIndex.set(term, new Set());
      invertedIndex.get(term).add(doc.id);
    }
  }
  computeIDF();
  indexVersion++;
  self.postMessage({ type: 'search:reindexed', docs: docStore.size, terms: invertedIndex.size, version: indexVersion, beat: beatCount, ts: Date.now() });
}

function optimizeIndex() {
  computeIDF();
  self.postMessage({ type: 'search:optimized', terms: invertedIndex.size, version: indexVersion, beat: beatCount, ts: Date.now() });
}

// Seed a few documents
['workflow-worker','scheduler-worker','career-worker','analytics-worker',
 'billing-worker','audit-worker','compliance-worker','queue-worker',
 'governance-worker'].forEach((name, i) => {
  indexDocument({ id: `SEED-${i}`, title: name, body: `Enterprise web worker for ${name.replace('-worker','')} operations`, tags: 'worker enterprise' });
});
computeIDF();

setInterval(() => {
  beatCount++;
  if (beatCount % INDEX_INTERVAL    === 0) rebuildIndex();
  if (beatCount % OPTIMIZE_INTERVAL === 0) optimizeIndex();
  self.postMessage({ type: 'heartbeat', beat: beatCount, docs: docStore.size, terms: invertedIndex.size, version: indexVersion, ts: Date.now() });
}, PHI_BEAT);

self.onmessage = function(e) {
  const { type, ...payload } = e.data || {};
  switch (type) {
    case 'query:search': {
      const { query, limit } = payload;
      const results = searchQuery(query || '', limit);
      self.postMessage({ type: 'result:search', results, total: results.length, query, ts: Date.now() });
      break;
    }
    case 'query:suggest': {
      const { prefix, limit } = payload;
      self.postMessage({ type: 'result:suggest', suggestions: suggestTerms(prefix || '', limit), ts: Date.now() });
      break;
    }
    case 'query:facets': {
      const { field = 'tags' } = payload;
      const counts = {};
      for (const doc of docStore.values()) {
        const val = doc[field];
        if (val) { const k = String(val); counts[k] = (counts[k] || 0) + 1; }
      }
      self.postMessage({ type: 'result:facets', field, counts, ts: Date.now() });
      break;
    }
    case 'query:index':
      self.postMessage({ type: 'result:index', docs: docStore.size, terms: invertedIndex.size, version: indexVersion, ts: Date.now() });
      break;
    case 'call:index': {
      const docId = indexDocument(payload);
      computeIDF();
      self.postMessage({ type: 'result:index-doc', docId, docs: docStore.size, ts: Date.now() });
      break;
    }
    case 'call:reindex':
      rebuildIndex();
      self.postMessage({ type: 'result:reindex', version: indexVersion, ts: Date.now() });
      break;
    case 'call:delete': {
      const { docId } = payload;
      const removed = removeDocument(docId);
      self.postMessage({ type: 'result:delete', docId, removed, ts: Date.now() });
      break;
    }
    case 'call:snapshot':
      self.postMessage({ type: 'result:snapshot', docs: docStore.size, terms: invertedIndex.size, version: indexVersion, ts: Date.now() });
      break;
    default:
      self.postMessage({ type: 'error', error: 'unknown_type', received: type, ts: Date.now() });
  }
};
