// nova/tools/nova-sign.js — F11 (v0.89.0) — GKP Geometric signing
// Brand: Nova by FreddyCreates
import { createHmac, createHash, randomBytes } from 'crypto';
const PHI = 1.618033988749895;
const PHI_INV = 0.6180339887498949;
const GOLDEN_ANGLE = 137.5077640500378;
export const NOVA_TOOL = { id:'NT-011',name:'nova-sign',brand:'Nova',fib_index:11,fib_value:89,version:'0.89.0',category:'security' };
export default async function handle(p={}) {
  const { action='sign', data, key=randomBytes(32).toString('hex') } = p;
  // GKP: geometric key — encodes data using golden angle + phi rotation
  const payload = typeof data==='string'?data:JSON.stringify(data||{});
  const hash    = createHash('sha256').update(payload).digest('hex');
  // Geometric signature: rotate hash bytes by golden angle
  const geoSig  = Array.from(Buffer.from(hash,'hex')).map((b,i) =>
    ((b + Math.round(GOLDEN_ANGLE * i)) % 256).toString(16).padStart(2,'0')
  ).join('');
  const hmac = createHmac('sha256', key).update(hash).digest('hex');
  switch(action) {
    case 'sign':   return { action:'sign', hash, geo_signature:geoSig, hmac, phi:PHI, golden_angle:GOLDEN_ANGLE };
    case 'verify': return { action:'verify', hash, expected_geo:geoSig, match: p.geo_signature===geoSig, phi:PHI };
    case 'chain':  return { action:'chain', hash, sig:geoSig, prev_hash:p.prev_hash||'genesis', chained: createHash('sha256').update(geoSig+(p.prev_hash||'genesis')).digest('hex'), phi:PHI };
    default: return { actions:['sign','verify','chain'], phi:PHI };
  }
}
