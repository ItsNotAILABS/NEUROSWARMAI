// nova/tools/nova-query.js
// Nova Tool: nova-query — F17 (v15.97.0)
// Aquarium caller: search, resolve, and call any registered tool or AIS by any attribute
// "Call call query everything" — the aquarium
// Brand: Nova by FreddyCreates

import { readFileSync, existsSync } from 'fs';
import { join, dirname } from 'path';
import { fileURLToPath } from 'url';

const __dir = dirname(fileURLToPath(import.meta.url));
const ROOT  = join(__dir, '../../');
const PHI   = 1.618033988749895;
const FIB   = [1,1,2,3,5,8,13,21,34,55,89,144,233,377,610,987,1597,2584,4181,6765];

export const NOVA_TOOL = {
  id: 'NT-017', name: 'nova-query', brand: 'Nova',
  fib_index: 17, fib_value: 1597, version: '15.97.0',
  category: 'registry',
};

function loadAll() {
  const load = p => existsSync(p)
    ? readFileSync(p,'utf-8').split('\n').filter(Boolean).map(l=>JSON.parse(l))
    : [];
  return [
    ...load(join(ROOT,'nova/registry/tools.jsonl')),
    ...load(join(ROOT,'nova/registry/ais.jsonl')),
  ];
}

// φ-weighted fuzzy score — higher weight to name matches
function score(record, term) {
  const t = term.toLowerCase();
  let s = 0;
  if (record.name?.toLowerCase() === t)               s += 100 * PHI;
  if (record.name?.toLowerCase().includes(t))         s += 50;
  if (record.id?.toLowerCase().includes(t))           s += 40;
  if (record.description?.toLowerCase().includes(t))  s += 20;
  if (record.category?.toLowerCase().includes(t))     s += 15;
  if (record.engines?.some(e=>e.toLowerCase().includes(t))) s += 10;
  return s;
}

export default async function handle(payload = {}) {
  const { action = 'query', term, filter = {}, name, call_payload } = payload;
  const all = loadAll();

  switch (action) {
    // ── QUERY: structured filter ──────────────────────────────────────────
    case 'query': {
      const results = all.filter(r => {
        for (const [k, v] of Object.entries(filter)) {
          if (r[k] !== v && !String(r[k]).includes(String(v))) return false;
        }
        return true;
      });
      return {
        action: 'query', filter, count: results.length,
        results: results.map(r => slim(r)),
        phi: PHI,
      };
    }

    // ── SEARCH: φ-weighted fuzzy search ──────────────────────────────────
    case 'search': {
      if (!term) return { error: 'Provide term for search' };
      const scored = all
        .map(r => ({ record: slim(r), score: score(r, term) }))
        .filter(x => x.score > 0)
        .sort((a, b) => b.score - a.score);
      return {
        action: 'search', term, count: scored.length,
        results: scored.map(x => ({ ...x.record, match_score: x.score.toFixed(2) })),
      };
    }

    // ── GET: exact lookup ─────────────────────────────────────────────────
    case 'get': {
      if (!name) return { error: 'Provide name' };
      const found = all.find(r => r.name === name || r.id === name);
      if (!found) return { error: `'${name}' not found`, suggestion: 'Try search action' };
      return { action: 'get', record: found };
    }

    // ── AQUARIUM: fuzzy → call ─────────────────────────────────────────────
    case 'aquarium': {
      if (!term && !name) return { error: 'Provide term or name' };
      const t = name || term;
      const scored = all
        .map(r => ({ r, s: score(r, t) }))
        .filter(x => x.s > 0)
        .sort((a, b) => b.s - a.s);

      if (scored.length === 0) return { error: `No matches for '${t}'` };
      if (scored.length > 1 && scored[0].s < 100 * PHI) {
        // ambiguous — return matches for user to pick
        return {
          action: 'aquarium', ambiguous: true, term: t,
          matches: scored.slice(0, 5).map(x => slim(x.r)),
          hint: 'Use exact name with action:"call" to invoke',
        };
      }
      const target = scored[0].r;
      return { action: 'aquarium', resolved: target.name, record: slim(target),
               note: 'Use action:"call" with this name to invoke' };
    }

    // ── LIST: by category ─────────────────────────────────────────────────
    case 'list': {
      const cats = {};
      for (const r of all) {
        const c = r.category || 'uncategorized';
        if (!cats[c]) cats[c] = [];
        cats[c].push(slim(r));
      }
      return { action: 'list', categories: cats, total: all.length };
    }

    // ── FIB: look up by Fibonacci slot ────────────────────────────────────
    case 'fib': {
      const slot = filter.slot || parseInt(term);
      if (!slot) return { error: 'Provide slot number (1-20)' };
      const found = all.find(r => r.fib_index === slot);
      return found
        ? { action: 'fib', slot, fib_value: FIB[slot-1], record: slim(found) }
        : { error: `No record at Fibonacci slot ${slot}` };
    }

    default:
      return {
        aquarium: 'Nova Registry — Aquarium Query Engine',
        phi: PHI,
        actions: ['query','search','get','aquarium','list','fib'],
        total: all.length,
      };
  }
}

function slim(r) {
  return {
    id: r.id, name: r.name, version: r.version,
    fib_index: r.fib_index, fib_value: r.fib_value,
    category: r.category, description: r.description,
    endpoints: r.endpoints, entry: r.entry,
  };
}

// CLI
if (process.argv[1].endsWith('nova-query.js')) {
  const [,,action,...args] = process.argv;
  const term = args[0];
  const result = await handle({ action: action||'list', term });
  console.log(JSON.stringify(result, null, 2));
}
