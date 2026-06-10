// nova/tools/nova-registry.js — F2 (v0.1.0) — Registry query wrapper
// Brand: Nova by FreddyCreates
import registry from '../registry/index.js';
export const NOVA_TOOL = { id:'NT-002',name:'nova-registry',brand:'Nova',fib_index:2,fib_value:1,version:'0.1.0',category:'registry' };
export default async function handle(p={}) {
  registry.load();
  const { action='status', term, name, filter={}, slot } = p;
  switch(action) {
    case 'list':    return registry.listTools();
    case 'list-ais': return registry.listAIS();
    case 'search':  return registry.search(term||'');
    case 'get':     return registry.get(name);
    case 'query':   return registry.query(filter);
    case 'resolve': return registry.resolve(parseInt(slot)||1);
    case 'pack':    return registry.pack();
    case 'fib':     return { slot, fib: registry.fibForSlot(parseInt(slot)||12), version: registry.versionForSlot(parseInt(slot)||12) };
    default:        return registry.status();
  }
}
