// nova/tools/nova-compress.js — F9 (v0.34.0) — Artifact compression
// Brand: Nova by FreddyCreates
import { createGzip, createGunzip } from 'zlib';
import { createReadStream, createWriteStream, statSync, existsSync } from 'fs';
import { pipeline } from 'stream/promises';
const PHI = 1.618033988749895;
const PHI_INV = 0.618;
export const NOVA_TOOL = { id:'NT-009',name:'nova-compress',brand:'Nova',fib_index:9,fib_value:34,version:'0.34.0',category:'artifact' };
export default async function handle(p={}) {
  const { src, dest, action='compress', level=9 } = p;
  if(!src) return { error:'Provide src path', phi:PHI, phi_level: Math.round(9*PHI_INV) };
  if(!existsSync(src)) return { error:`File not found: ${src}` };
  const outPath = dest || src+'.gz';
  if(action==='compress') {
    await pipeline(createReadStream(src), createGzip({level}), createWriteStream(outPath));
    const origSize = statSync(src).size;
    const gzSize   = statSync(outPath).size;
    const ratio    = origSize/gzSize;
    return { action:'compress', src, dest:outPath, orig_bytes:origSize, gz_bytes:gzSize,
             ratio:ratio.toFixed(3), phi_ratio:(ratio/PHI).toFixed(3), phi:PHI };
  }
  if(action==='decompress') {
    const out = dest||src.replace('.gz','');
    await pipeline(createReadStream(src), createGunzip(), createWriteStream(out));
    return { action:'decompress', src, dest:out, phi:PHI };
  }
  return { error:'Unknown action', actions:['compress','decompress'] };
}
