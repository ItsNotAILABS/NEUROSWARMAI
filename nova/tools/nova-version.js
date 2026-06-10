// nova/tools/nova-version.js
// Nova Tool: nova-version — F12 (v1.44.0)
// Fibonacci version manager: computes, bumps, and manages the Fibonacci version register
// Brand: Nova by FreddyCreates

export const NOVA_TOOL = {
  id: 'NT-012', name: 'nova-version', brand: 'Nova',
  fib_index: 12, fib_value: 144, version: '1.44.0',
  category: 'registry',
};

const PHI = 1.618033988749895;
const FIB = [1,1,2,3,5,8,13,21,34,55,89,144,233,377,610,987,1597,2584,4181,6765];

export function fib(n) {
  if (n <= 0) return 0;
  if (n <= FIB.length) return FIB[n - 1];
  let a = FIB[FIB.length - 2], b = FIB[FIB.length - 1];
  for (let i = FIB.length; i < n; i++) [a, b] = [b, a + b];
  return b;
}

export function fibVersion(slot) {
  const v = fib(slot);
  if (v < 100) return `0.${v}.0`;
  const s = String(v);
  if (s.length === 3) return `${s[0]}.${s.slice(1)}.0`;
  if (s.length === 4) return `${s.slice(0,2)}.${s.slice(2)}.0`;
  return `${s.slice(0,s.length-4)}.${s.slice(-4,-2)}.${s.slice(-2)}`;
}

export function fibSlot(version) {
  // reverse lookup: find slot n where fib(n) matches the version number
  const v = parseInt(version.replace(/\./g,'').replace(/^0+/,'')) ||
            parseInt(version.split('.').filter(x=>x!=='0')[0]);
  return FIB.indexOf(v) + 1;
}

export function phiRatio(n) {
  return fib(n + 1) / fib(n);
}

export default async function handle(payload = {}) {
  const { action = 'next', slot, name } = payload;

  switch (action) {
    case 'next': {
      const s = slot || 12;
      return {
        current_slot:   s,
        current_fib:    fib(s),
        current_version: fibVersion(s),
        next_slot:      s + 1,
        next_fib:       fib(s + 1),
        next_version:   fibVersion(s + 1),
        phi_ratio:      phiRatio(s).toFixed(6),
        phi:            PHI,
      };
    }

    case 'fib': {
      const n = slot || 12;
      return {
        n, fib: fib(n), version: fibVersion(n),
        ratio_to_prev: phiRatio(n - 1).toFixed(6),
        convergence: Math.abs(phiRatio(n - 1) - PHI).toFixed(8),
      };
    }

    case 'sequence': {
      return {
        sequence: FIB.map((v, i) => ({
          slot:    i + 1,
          fib:     v,
          version: fibVersion(i + 1),
          ratio:   i > 0 ? (v / FIB[i-1]).toFixed(6) : 'N/A',
        })),
        phi: PHI,
        convergence: 'All ratios converge to φ = 1.618...',
      };
    }

    case 'lookup': {
      if (!name) return { error: 'Provide name to look up version' };
      // Look up from registry
      const { readFileSync, existsSync } = await import('fs');
      const { join, dirname } = await import('path');
      const { fileURLToPath } = await import('url');
      const __dir = dirname(fileURLToPath(import.meta.url));
      const path = join(__dir, '../registry/tools.jsonl');
      if (!existsSync(path)) return { error: 'Registry not found' };
      const tools = readFileSync(path,'utf-8').split('\n').filter(Boolean).map(l=>JSON.parse(l));
      const tool = tools.find(t => t.name === name);
      if (!tool) return { error: `Tool '${name}' not found` };
      return { name: tool.name, fib_index: tool.fib_index, fib_value: tool.fib_value, version: tool.version };
    }

    default:
      return { sequence: FIB, phi: PHI, law: 'version(n) = F(n). Names emerge from numbers.' };
  }
}

// CLI
import { fileURLToPath } from 'url';
if (process.argv[1] === fileURLToPath(import.meta.url)) {
  const [,,action, ...args] = process.argv;
  const slot = parseInt(args[0]) || 12;
  const result = await handle({ action: action || 'sequence', slot });
  console.log(JSON.stringify(result, null, 2));
}
