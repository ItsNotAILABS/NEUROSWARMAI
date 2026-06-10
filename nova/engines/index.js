/**
 * NOVA ENGINES — Index
 * Nova by FreddyCreates
 * 
 * Multi-substrate Nova Engine exports.
 * Same organism, six bodies.
 * 
 * @version 0.13.0 (F13)
 * @copyright Nova Protocol by FreddyCreates
 */

// Core Engine
export { NovaEngine, TOOLS, PHI, PHI_INV, PHI_BEAT, fib } from './nova-engine.js';

// Substrate-specific exports
// Note: Import directly for substrate-specific usage:
// - nova-icp.mo → For ICP canister deployment (Motoko)
// - nova-edge.js → For Cloudflare Workers deployment
// - nova-worker.js → For Web Worker deployment

// ─── Substrate Registry ──────────────────────────────────────────────────────
export const SUBSTRATES = {
  node: {
    name: 'Node.js',
    description: 'Server-side JavaScript runtime',
    engine: 'nova-engine.js',
    environments: ['server', 'desktop', 'serverless']
  },
  icp: {
    name: 'Internet Computer',
    description: 'On-chain sovereign execution',
    engine: 'nova-icp.mo',
    environments: ['blockchain', 'canister']
  },
  edge: {
    name: 'Cloudflare Workers',
    description: 'Global edge deployment',
    engine: 'nova-edge.js',
    environments: ['edge', 'serverless', 'global']
  },
  worker: {
    name: 'Web Workers',
    description: 'Browser parallel execution',
    engine: 'nova-worker.js',
    environments: ['browser', 'client']
  },
  browser: {
    name: 'Browser (Main Thread)',
    description: 'Direct browser execution',
    engine: 'nova-engine.js',
    environments: ['browser', 'client']
  },
  python: {
    name: 'Pythonista',
    description: 'Python/iOS execution',
    engine: '../pythonista/',
    environments: ['mobile', 'server', 'notebook']
  }
};

// ─── Factory ─────────────────────────────────────────────────────────────────
import { NovaEngine } from './nova-engine.js';

export function createEngine(substrate = 'node', config = {}) {
  return new NovaEngine({ substrate, ...config });
}

// ─── Default Export ──────────────────────────────────────────────────────────
export default {
  NovaEngine,
  SUBSTRATES,
  createEngine
};
