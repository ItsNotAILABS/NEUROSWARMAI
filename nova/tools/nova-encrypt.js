// nova/tools/nova-encrypt.js — F10 (v0.55.0) — HMAC-SHA256 + AES-GCM encryption
// Brand: Nova by FreddyCreates
import { createHmac, randomBytes, createCipheriv, createDecipheriv } from 'crypto';
const PHI = 1.618033988749895;
export const NOVA_TOOL = { id:'NT-010',name:'nova-encrypt',brand:'Nova',fib_index:10,fib_value:55,version:'0.55.0',category:'security' };
const ALGO = 'aes-256-gcm';
export default async function handle(p={}) {
  const { action='hmac', data, key=randomBytes(32).toString('hex'), secret } = p;
  switch(action) {
    case 'hmac': {
      if(!data) return { error:'Provide data' };
      const k = secret || key;
      const sig = createHmac('sha256', k).update(typeof data==='string'?data:JSON.stringify(data)).digest('hex');
      return { action:'hmac', algorithm:'HMAC-SHA256', signature:sig, phi_prefix: sig.slice(0,6), phi:PHI };
    }
    case 'encrypt': {
      if(!data) return { error:'Provide data' };
      const keyBuf = Buffer.from(key,'hex').slice(0,32);
      const iv = randomBytes(12);
      const cipher = createCipheriv(ALGO, keyBuf, iv);
      const enc = Buffer.concat([cipher.update(JSON.stringify(data),'utf8'), cipher.final()]);
      const tag = cipher.getAuthTag();
      return { action:'encrypt', algo:ALGO, iv:iv.toString('hex'), tag:tag.toString('hex'), ciphertext:enc.toString('hex'), phi:PHI };
    }
    case 'verify': {
      if(!data||!secret) return { error:'Provide data and secret' };
      const expected = createHmac('sha256',secret).update(typeof data==='string'?data:JSON.stringify(data)).digest('hex');
      return { action:'verify', valid: expected===p.signature, phi:PHI };
    }
    default: return { actions:['hmac','encrypt','verify'], phi:PHI };
  }
}
