// nova/tools/nova-doc.js — F7 (v0.13.0) — Documentation generator
// Brand: Nova by FreddyCreates
import { readdirSync, readFileSync, existsSync } from 'fs';
import { join, dirname } from 'path';
import { fileURLToPath } from 'url';
const __dir = dirname(fileURLToPath(import.meta.url));
const ROOT = join(__dir,'../../');
const PHI = 1.618033988749895;
export const NOVA_TOOL = { id:'NT-007',name:'nova-doc',brand:'Nova',fib_index:7,fib_value:13,version:'0.13.0',category:'docs' };
export default async function handle(p={}) {
  const { source='nova', type='api' } = p;
  const papers = existsSync(join(ROOT,'docs/research')) ? readdirSync(join(ROOT,'docs/research')).filter(f=>f.endsWith('.md')) : [];
  const tools = existsSync(join(ROOT,'nova/tools')) ? readdirSync(join(ROOT,'nova/tools')) : [];
  return {
    action:'doc-generate', source, type,
    research_papers: papers.length,
    nova_tools: tools.length,
    outputs: ['docs/api/nova-tools.md','docs/api/nova-ais.md','docs/api/nova-registry.md'],
    phi: PHI,
    note: 'Full doc generation runs via organism-bot-scriptor workflow',
  };
}
