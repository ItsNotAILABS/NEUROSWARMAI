// nova/tools/nova-lint.js — F6 (v0.8.0) — Code quality linter
// Brand: Nova by FreddyCreates
import { execSync } from 'child_process';
import { join, dirname } from 'path';
import { fileURLToPath } from 'url';
const __dir = dirname(fileURLToPath(import.meta.url));
const ROOT = join(__dir,'../../');
const PHI = 1.618033988749895;
export const NOVA_TOOL = { id:'NT-006',name:'nova-lint',brand:'Nova',fib_index:6,fib_value:8,version:'0.8.0',category:'quality' };
export default async function handle(p={}) {
  const { path=ROOT, fix=false, rules=['phi-coherence','import-order','no-unused'] } = p;
  const checks = rules.map(r => ({
    rule: r,
    status: r==='phi-coherence' ? 'custom-nova-rule' : 'biome-compatible',
    phi_weighted: true,
  }));
  return {
    linter: 'nova-lint v0.8.0',
    path, fix, rules_checked: checks,
    command: fix ? 'biome check --write .' : 'biome check .',
    phi_rules: ['coherence-score>0.618','fib-version-format','nova-brand-namespace'],
    phi: PHI,
    note: 'Run: node nova/runtime/nova-runtime.js for full lint integration',
  };
}
