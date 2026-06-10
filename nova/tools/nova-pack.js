// nova/tools/nova-pack.js
// Nova Tool: nova-pack — F1 (v0.1.0)
// Self-packing tool: builds and bundles the Nova registry into a distributable artifact
// Brand: Nova by FreddyCreates

import { readFileSync, writeFileSync, mkdirSync, existsSync, readdirSync, statSync } from 'fs';
import { join, dirname } from 'path';
import { fileURLToPath } from 'url';
import { createGzip } from 'zlib';
import { createReadStream, createWriteStream } from 'fs';
import { pipeline } from 'stream/promises';

const __dir = dirname(fileURLToPath(import.meta.url));
const ROOT  = join(__dir, '../../');
const PHI   = 1.618033988749895;

// Self-register in the registry on import
export const NOVA_TOOL = {
  id: 'NT-001', name: 'nova-pack', brand: 'Nova',
  fib_index: 1, fib_value: 1, version: '0.1.0',
  category: 'build', self_pack: true,
};

export default async function handle(payload = {}, record = NOVA_TOOL) {
  const { target = 'registry', outDir = join(ROOT, 'dist') } = payload;
  mkdirSync(outDir, { recursive: true });

  switch (target) {
    case 'registry': return packRegistry(outDir);
    case 'release':  return packRelease(outDir);
    case 'tools':    return packTools(outDir);
    default:         return packRegistry(outDir);
  }
}

async function packRegistry(outDir) {
  const toolsRaw = readJsonl(join(ROOT, 'nova/registry/tools.jsonl'));
  const aisRaw   = readJsonl(join(ROOT, 'nova/registry/ais.jsonl'));

  const bundle = {
    brand:      'Nova',
    platform:   'command-platform',
    phi:        PHI,
    fib_seq:    [1,1,2,3,5,8,13,21,34,55,89,144,233,377,610,987,1597,2584,4181,6765],
    tools:      toolsRaw,
    ais:        aisRaw,
    total:      toolsRaw.length + aisRaw.length,
    packed_at:  new Date().toISOString(),
    packer:     'nova-pack@0.1.0',
    manifest:   'nova.toml',
  };

  const outPath = join(outDir, 'nova-registry.bundle.json');
  writeFileSync(outPath, JSON.stringify(bundle, null, 2));

  // gzip it
  const gzPath = outPath + '.gz';
  await gzip(outPath, gzPath);

  const bytes    = statSync(outPath).size;
  const gzBytes  = statSync(gzPath).size;
  const ratio    = bytes / gzBytes;

  return {
    bundle: outPath,
    compressed: gzPath,
    tools: toolsRaw.length,
    ais: aisRaw.length,
    size_bytes: bytes,
    compressed_bytes: gzBytes,
    compression_ratio: ratio.toFixed(3),
    phi_ratio: (ratio / PHI).toFixed(3),
  };
}

async function packRelease(outDir) {
  const nova = readdirSafe(join(ROOT, 'nova'));
  const files = nova.flatMap(f => {
    const full = join(ROOT, 'nova', f);
    if (statSync(full).isDirectory()) {
      return readdirSync(full).map(cf => `nova/${f}/${cf}`);
    }
    return [`nova/${f}`];
  });

  const manifest = {
    brand: 'Nova', files, packed_at: new Date().toISOString(),
    root: 'nova.toml',
  };
  const mPath = join(outDir, 'nova-release-manifest.json');
  writeFileSync(mPath, JSON.stringify(manifest, null, 2));
  return { manifest: mPath, file_count: files.length };
}

async function packTools(outDir) {
  const toolFiles = readdirSafe(join(ROOT, 'nova/tools'));
  const out = { brand: 'Nova', tools: toolFiles, packed_at: new Date().toISOString() };
  const outPath = join(outDir, 'nova-tools.json');
  writeFileSync(outPath, JSON.stringify(out, null, 2));
  return { output: outPath, count: toolFiles.length };
}

function readJsonl(path) {
  if (!existsSync(path)) return [];
  return readFileSync(path, 'utf-8').split('\n').filter(Boolean).map(l => JSON.parse(l));
}

function readdirSafe(dir) {
  try { return readdirSync(dir); } catch { return []; }
}

async function gzip(src, dest) {
  await pipeline(
    createReadStream(src),
    createGzip({ level: 9 }),
    createWriteStream(dest)
  );
}
