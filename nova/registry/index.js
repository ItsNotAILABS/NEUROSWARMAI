// nova/registry/index.js
// Nova Registry — Aquarium Query Engine
// "Call everything from here. Call it aquarium. Call query everything, pack them."
// Brand: Nova by FreddyCreates
// Versioning: Fibonacci sequence F1–F20
// Usage:
//   import registry from './nova/registry/index.js'
//   registry.call('nova-orchestrate', { workflow: 'organism-bot-praetor' })
//   registry.query({ category: 'build' })

import { readFileSync, existsSync } from 'fs';
import { createReadStream } from 'fs';
import { createInterface } from 'readline';
import { join, dirname } from 'path';
import { fileURLToPath } from 'url';

const __dir = dirname(fileURLToPath(import.meta.url));
const ROOT  = join(__dir, '../../');

// ─── FIBONACCI ENGINE ──────────────────────────────────────────────────────
// The register. Names emerge from numbers.
const FIB = [1,1,2,3,5,8,13,21,34,55,89,144,233,377,610,987,1597,2584,4181,6765];
const PHI = 1.618033988749895;
const PHI_INV = 0.6180339887498949;

function fib(n) {
  if (n <= 0) return 0;
  if (n <= FIB.length) return FIB[n - 1];
  let a = FIB[FIB.length - 2], b = FIB[FIB.length - 1];
  for (let i = FIB.length; i < n; i++) { [a, b] = [b, a + b]; }
  return b;
}

function fibVersion(slot) {
  const v = fib(slot);
  if (v < 100) return `0.${v}.0`;
  const s = String(v);
  if (s.length === 3) return `${s[0]}.${s.slice(1)}.0`;
  if (s.length === 4) return `${s.slice(0,2)}.${s.slice(2)}.0`;
  return `${s.slice(0,s.length-4)}.${s.slice(-4,-2)}.${s.slice(-2)}`;
}

// ─── JSONL LOADER ─────────────────────────────────────────────────────────
function loadJsonl(path) {
  if (!existsSync(path)) return [];
  return readFileSync(path, 'utf-8')
    .split('\n')
    .filter(Boolean)
    .map(line => JSON.parse(line));
}

// ─── REGISTRY CORE ────────────────────────────────────────────────────────
class NovaRegistry {
  constructor() {
    this.tools   = [];
    this.ais     = [];
    this._index  = new Map();     // name → record
    this._cats   = new Map();     // category → [records]
    this._fibs   = new Map();     // fib_index → record
    this._loaded = false;
    this._phi_beat = 873;         // ms — φ-synchronized heartbeat
  }

  load() {
    if (this._loaded) return this;

    this.tools = loadJsonl(join(ROOT, 'nova/registry/tools.jsonl'));
    this.ais   = loadJsonl(join(ROOT, 'nova/registry/ais.jsonl'));

    const all  = [...this.tools, ...this.ais];
    for (const r of all) {
      this._index.set(r.name, r);
      if (r.id) this._index.set(r.id, r);

      const cat = r.category || r.modalities?.[0] || 'uncategorized';
      if (!this._cats.has(cat)) this._cats.set(cat, []);
      this._cats.get(cat).push(r);

      if (r.fib_index) this._fibs.set(r.fib_index, r);
    }

    this._loaded = true;
    return this;
  }

  // ─── QUERY ─────────────────────────────────────────────────────────────
  // The aquarium. Search by anything.
  query(opts = {}) {
    this.load();
    const all = [...this.tools, ...this.ais];

    return all.filter(r => {
      if (opts.name     && !r.name.includes(opts.name))          return false;
      if (opts.id       && r.id !== opts.id)                     return false;
      if (opts.category && r.category !== opts.category)         return false;
      if (opts.fib_index !== undefined && r.fib_index !== opts.fib_index) return false;
      if (opts.fib_value !== undefined && r.fib_value !== opts.fib_value) return false;
      if (opts.version  && r.version !== opts.version)           return false;
      if (opts.multimodal !== undefined && r.multimodal !== opts.multimodal) return false;
      if (opts.alpha_protocol !== undefined && r.alpha_protocol !== opts.alpha_protocol) return false;
      if (opts.brand    && r.brand !== opts.brand)               return false;
      return true;
    });
  }

  // fuzzy search across name + description
  search(term) {
    this.load();
    const t = term.toLowerCase();
    return [...this.tools, ...this.ais].filter(r =>
      r.name.toLowerCase().includes(t) ||
      r.description?.toLowerCase().includes(t) ||
      r.category?.toLowerCase().includes(t) ||
      r.id?.toLowerCase().includes(t)
    );
  }

  // get by exact name or id
  get(name) {
    this.load();
    return this._index.get(name) || null;
  }

  // resolve by Fibonacci slot
  resolve(fibSlot) {
    this.load();
    return this._fibs.get(fibSlot) || null;
  }

  // list all tools
  listTools() {
    this.load();
    return this.tools;
  }

  // list all AIS
  listAIS() {
    this.load();
    return this.ais;
  }

  // list by category
  byCategory(cat) {
    this.load();
    return this._cats.get(cat) || [];
  }

  // ─── CALL ──────────────────────────────────────────────────────────────
  // "Call everything from the registry"
  // Dynamically imports and runs the tool entry point
  async call(name, payload = {}) {
    this.load();
    const record = this.get(name);
    if (!record) {
      throw new Error(`Nova: tool '${name}' not found in registry. Run nova.search('${name}') to find it.`);
    }

    const entryPath = join(ROOT, record.entry);
    if (!existsSync(entryPath)) {
      throw new Error(`Nova: entry '${record.entry}' not found on disk. Register with nova-scaffold first.`);
    }

    const mod = await import(entryPath);
    const handler = mod.default || mod.handle || mod.run;
    if (typeof handler !== 'function') {
      throw new Error(`Nova: '${name}' entry must export a default function.`);
    }

    const result = await handler(payload, record);
    return { tool: record, result, phi: PHI, fib: fib(record.fib_index) };
  }

  // ─── AQUARIUM ──────────────────────────────────────────────────────────
  // The aquarium caller — call any tool by regex match or partial name
  async aquarium(query, payload = {}) {
    this.load();
    const matches = this.search(query);
    if (matches.length === 0) {
      throw new Error(`Nova aquarium: no tools match '${query}'`);
    }
    if (matches.length > 1) {
      return { matches: matches.map(m => ({ id: m.id, name: m.name, version: m.version })) };
    }
    return this.call(matches[0].name, payload);
  }

  // ─── PACK ──────────────────────────────────────────────────────────────
  // Serialize the full registry to JSON (for nova-pack)
  pack() {
    this.load();
    return {
      brand:     'Nova',
      platform:  'command-platform',
      phi:       PHI,
      phi_inv:   PHI_INV,
      phi_beat:  this._phi_beat,
      fibonacci: FIB,
      tools:     this.tools,
      ais:       this.ais,
      total:     this.tools.length + this.ais.length,
      packed_at: new Date().toISOString(),
      manifest:  'nova.toml',
    };
  }

  // ─── VERSION ───────────────────────────────────────────────────────────
  nextFib(slot) { return fib(slot + 1); }
  fibForSlot(slot) { return fib(slot); }
  versionForSlot(slot) { return fibVersion(slot); }

  // ─── STATUS ────────────────────────────────────────────────────────────
  status() {
    this.load();
    return {
      tools:       this.tools.length,
      ais:         this.ais.length,
      alpha:       this.ais.filter(a => a.alpha_protocol).length,
      multimodal:  this.ais.filter(a => a.multimodal).length,
      categories:  [...this._cats.keys()],
      phi:         PHI,
      phi_inv:     PHI_INV,
      fib_current: FIB[11],   // F12 = 144 (current platform index)
      fib_next:    FIB[12],   // F13 = 233 (next)
      phi_beat_ms: this._phi_beat,
    };
  }
}

// ─── SINGLETON EXPORT ─────────────────────────────────────────────────────
const registry = new NovaRegistry();
export default registry;
export { registry, fib, fibVersion, FIB, PHI, PHI_INV };

// ─── CLI ENTRY ────────────────────────────────────────────────────────────
if (process.argv[1] === fileURLToPath(import.meta.url)) {
  const [,, cmd, ...args] = process.argv;
  registry.load();

  switch (cmd) {
    case 'list':
      console.log(JSON.stringify(registry.listTools().map(t => ({
        name: t.name, version: t.version, fib: t.fib_value, category: t.category
      })), null, 2));
      break;

    case 'list-ais':
      console.log(JSON.stringify(registry.listAIS().map(a => ({
        id: a.id, name: a.name, version: a.version, multimodal: a.multimodal
      })), null, 2));
      break;

    case 'query':
      const opts = {};
      for (let i = 0; i < args.length; i += 2) {
        const key = args[i].replace('--','');
        opts[key] = args[i+1];
      }
      console.log(JSON.stringify(registry.query(opts), null, 2));
      break;

    case 'search':
      console.log(JSON.stringify(registry.search(args[0]), null, 2));
      break;

    case 'get':
      console.log(JSON.stringify(registry.get(args[0]), null, 2));
      break;

    case 'call':
      (async () => {
        const payload = args[1] ? JSON.parse(args[1]) : {};
        const result = await registry.call(args[0], payload);
        console.log(JSON.stringify(result, null, 2));
      })().catch(console.error);
      break;

    case 'status':
      console.log(JSON.stringify(registry.status(), null, 2));
      break;

    case 'pack':
      console.log(JSON.stringify(registry.pack(), null, 2));
      break;

    case 'fib':
      const n = parseInt(args[0]) || 12;
      console.log(`F(${n}) = ${fib(n)}, version = ${fibVersion(n)}`);
      break;

    default:
      console.log(`
Nova Registry — Aquarium Query Engine
Brand: Nova by FreddyCreates
φ = ${PHI}

Commands:
  list              List all 20 Nova tools
  list-ais          List all 15 AIS (10 alpha + 5 multimodal)
  query --name x    Query by attribute
  search <term>     Fuzzy search
  get <name>        Get tool by exact name
  call <name> [{}]  Call tool with optional JSON payload
  status            Registry status
  pack              Serialize full registry
  fib <n>           Compute Fibonacci number F(n) and version

Examples:
  node nova/registry/index.js list
  node nova/registry/index.js search build
  node nova/registry/index.js get nova-orchestrate
  node nova/registry/index.js call nova-version
  node nova/registry/index.js fib 20
`);
  }
}
