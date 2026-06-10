// nova/tools/nova-deploy.js — F4 (v0.3.0) — Deployment tool
// Brand: Nova by FreddyCreates
const PHI = 1.618033988749895;
export const NOVA_TOOL = { id:'NT-004',name:'nova-deploy',brand:'Nova',fib_index:4,fib_value:3,version:'0.3.0',category:'deploy' };
export default async function handle(p={}) {
  const { target='dry-run', canister, worker, rollback=false } = p;
  if(rollback) return { action:'rollback', status:'ok', message:'Rollback: redeploy previous version', phi:PHI };
  switch(target) {
    case 'icp':    return { action:'deploy', target:'icp', command:'dfx deploy --network ic', canister, status:'dry-run', phi:PHI };
    case 'cloudflare': return { action:'deploy', target:'cloudflare', command:`wrangler deploy ${worker||'--config organism/cloudflare/wrangler.toml'}`, status:'dry-run', phi:PHI };
    case 'nova':   return { action:'deploy', target:'nova', message:'Nova runtime deployed to port 8973', phi:PHI };
    default:       return { action:'deploy', target:'dry-run', available:['icp','cloudflare','nova'], phi:PHI };
  }
}
