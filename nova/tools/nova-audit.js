// nova/tools/nova-audit.js — F14 (v3.77.0) — Immutable audit trail
// Brand: Nova by FreddyCreates
import { createHash } from 'crypto';
import { appendFileSync, existsSync, readFileSync, mkdirSync } from 'fs';
import { join, dirname } from 'path';
import { fileURLToPath } from 'url';
const __dir = dirname(fileURLToPath(import.meta.url));
const ROOT = join(__dir,'../../');
const AUDIT_PATH = join(ROOT,'nova/audit.jsonl');
const PHI = 1.618033988749895;
export const NOVA_TOOL = { id:'NT-014',name:'nova-audit',brand:'Nova',fib_index:14,fib_value:377,version:'3.77.0',category:'audit' };
function phiHash(data,prev='genesis') {
  return createHash('sha256').update(JSON.stringify(data)+prev).digest('hex').slice(0,16);
}
export default async function handle(p={}) {
  const { action='log', event, query } = p;
  switch(action) {
    case 'log': {
      if(!event) return { error:'Provide event object' };
      const prev = getLastHash();
      const entry = { ts:new Date().toISOString(), event, prev_hash:prev, hash:phiHash(event,prev), phi:PHI };
      mkdirSync(join(ROOT,'nova'),{recursive:true});
      appendFileSync(AUDIT_PATH, JSON.stringify(entry)+'\n');
      return { logged:true, hash:entry.hash, phi:PHI };
    }
    case 'query': {
      if(!existsSync(AUDIT_PATH)) return { entries:[], count:0 };
      const lines = readFileSync(AUDIT_PATH,'utf-8').split('\n').filter(Boolean).map(l=>JSON.parse(l));
      return { entries:lines, count:lines.length, phi:PHI };
    }
    case 'verify': {
      if(!existsSync(AUDIT_PATH)) return { valid:true, note:'Empty audit log — no entries to verify' };
      const lines = readFileSync(AUDIT_PATH,'utf-8').split('\n').filter(Boolean).map(l=>JSON.parse(l));
      let valid=true, prev='genesis';
      for(const e of lines) {
        const expected = phiHash(e.event,prev);
        if(e.hash!==expected) { valid=false; break; }
        prev = e.hash;
      }
      return { valid, entries:lines.length, phi:PHI };
    }
    default: return { actions:['log','query','verify'], phi:PHI };
  }
}
function getLastHash() {
  if(!existsSync(AUDIT_PATH)) return 'genesis';
  const lines = readFileSync(AUDIT_PATH,'utf-8').split('\n').filter(Boolean);
  if(!lines.length) return 'genesis';
  return JSON.parse(lines[lines.length-1]).hash || 'genesis';
}
