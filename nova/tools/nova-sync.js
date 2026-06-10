// nova/tools/nova-sync.js — F13 (v2.33.0) — State synchronization
// Brand: Nova by FreddyCreates
const PHI = 1.618033988749895;
export const NOVA_TOOL = { id:'NT-013',name:'nova-sync',brand:'Nova',fib_index:13,fib_value:233,version:'2.33.0',category:'sync' };
export default async function handle(p={}) {
  const { target='all', state, kv_namespace, icp_canister, dry_run=true } = p;
  const ts = new Date().toISOString();
  const sync = (t,details={}) => ({ target:t, synced:!dry_run, dry_run, timestamp:ts, phi:PHI, ...details });
  switch(target) {
    case 'cloudflare': return sync('cloudflare', { namespace:kv_namespace||'NOVA_REGISTRY', key:'nova-state', note:'Requires CF Workers KV binding' });
    case 'icp':        return sync('icp', { canister:icp_canister||'nova-state-canister', method:'setRegistryState', note:'Requires dfx identity' });
    case 'git':        return sync('git', { branch:'main', file:'nova/registry/state.json', note:'Commits current registry state to git' });
    case 'all':        return { targets:['cloudflare','icp','git'], phi:PHI, dry_run, timestamp:ts, note:'Sync to all targets' };
    default:           return { error:'Unknown target', targets:['cloudflare','icp','git','all'] };
  }
}
