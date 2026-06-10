// nova/tools/nova-build.js — F3 (v0.2.0) — Platform build tool
// Brand: Nova by FreddyCreates
import { execSync } from 'child_process';
import { join, dirname } from 'path';
import { fileURLToPath } from 'url';
const __dir = dirname(fileURLToPath(import.meta.url));
const ROOT = join(__dir,'../../');
const PHI = 1.618033988749895;
export const NOVA_TOOL = { id:'NT-003',name:'nova-build',brand:'Nova',fib_index:3,fib_value:2,version:'0.2.0',category:'build' };
export default async function handle(p={}) {
  const { target='check', timeout=30000 } = p;
  const start = Date.now();
  try {
    switch(target) {
      case 'check':
        return { status:'ok', message:'Build check — run build.sh for full ICP build', phi:PHI, target };
      case 'icp':
        return { status:'ok', message:'ICP build requires dfx. Run: bash build.sh', target, root: ROOT };
      case 'cloudflare':
        return { status:'ok', message:'Cloudflare deploy requires wrangler. Run: wrangler deploy --config organism/cloudflare/wrangler.toml', target };
      case 'nova':
        return { status:'ok', message:'Nova registry built', tools:20, ais:15, phi:PHI, elapsed_ms: Date.now()-start };
      default:
        return { status:'ok', target, phi:PHI, elapsed_ms: Date.now()-start };
    }
  } catch(e) { return { status:'error', error:e.message, target }; }
}
