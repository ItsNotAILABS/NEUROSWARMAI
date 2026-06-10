/**
 * Crypto Worker — Hash Engine & Chain Integrity
 *
 * Web Worker for all cryptographic operations in the organism.
 * CRC32, FNV-1a hashing, ANIMA chain extension, genesis hash
 * verification, and integrity checking. Runs permanently.
 *
 * Architecture:
 *   CRC32 — zip integrity, data validation
 *   FNV-1a — fast deterministic hashing for entity IDs, patterns
 *   ANIMA chain — heartbeat-extended hash chain for proof of life
 *   Genesis hash — organism identity verification
 *   HMAC — message authentication between workers
 *
 * ANIMA Chain: head(t+1) = (head(t) × prime) XOR (shift)
 *   Prime: 16777619 (FNV prime)
 *   Extends every heartbeat — permanent proof of life
 *
 * Protocol: postMessage
 *   Main → Worker: { type: 'hash', algorithm, data }
 *   Main → Worker: { type: 'crc32', data }
 *   Main → Worker: { type: 'extendChain' }
 *   Main → Worker: { type: 'verifyGenesis', hash, name }
 *   Main → Worker: { type: 'hmac', key, message }
 *   Worker → Main: { type: 'hash-result', algorithm, hash, input }
 *   Worker → Main: { type: 'chain-extended', head, length }
 *   Worker → Main: { type: 'genesis-verified', valid, name, hash }
 *   Worker → Main: { type: 'heartbeat', beat, status }
 */

const PHI = 1.618033988749895;
const HEARTBEAT = 873;
const FNV_OFFSET = 2166136261;
const FNV_PRIME = 16777619;

let beatCount = 0;
let running = true;

/* ════════════════════════════════════════════════════════════════
   CRC32 — same implementation as download-worker
   ════════════════════════════════════════════════════════════════ */

const crc32Table = new Uint32Array(256);
for (let i = 0; i < 256; i++) {
  let c = i;
  for (let j = 0; j < 8; j++) {
    c = (c & 1) ? (0xEDB88320 ^ (c >>> 1)) : (c >>> 1);
  }
  crc32Table[i] = c;
}

function crc32(buf) {
  let crc = 0xFFFFFFFF;
  for (let i = 0; i < buf.length; i++) {
    crc = crc32Table[(crc ^ buf[i]) & 0xFF] ^ (crc >>> 8);
  }
  return (crc ^ 0xFFFFFFFF) >>> 0;
}

function crc32str(str) {
  return crc32(new TextEncoder().encode(str));
}

/* ════════════════════════════════════════════════════════════════
   FNV-1a — fast deterministic hash
   ════════════════════════════════════════════════════════════════ */

function fnv1a(input) {
  let hash = FNV_OFFSET;
  for (let i = 0; i < input.length; i++) {
    hash ^= input.charCodeAt(i);
    hash = (hash * FNV_PRIME) >>> 0;
  }
  return hash;
}

function fnv1aToString(input) {
  return fnv1a(input).toString(10);
}

/* ════════════════════════════════════════════════════════════════
   ANIMA Chain — proof-of-life hash chain
   Extended every heartbeat. Chain can never be forked.
   head(t+1) = ((head × FNV_PRIME) XOR (head >>> 13)) >>> 0
   ════════════════════════════════════════════════════════════════ */

let animaHead = FNV_OFFSET;
let animaLength = 0;
const animaHistory = []; // Last 89 (F11) chain states
const MAX_ANIMA_HISTORY = 89;

function extendAnimaChain() {
  animaHead = ((animaHead * FNV_PRIME) ^ (animaHead >>> 13)) >>> 0;
  animaLength++;

  animaHistory.push({ head: animaHead, length: animaLength, timestamp: Date.now() });
  if (animaHistory.length > MAX_ANIMA_HISTORY) animaHistory.shift();

  return { head: animaHead, length: animaLength };
}

function verifyChainIntegrity() {
  // Verify the last N chain extensions are sequential
  if (animaHistory.length < 2) return { valid: true, checked: animaHistory.length };

  let valid = true;
  for (let i = 1; i < animaHistory.length; i++) {
    if (animaHistory[i].length !== animaHistory[i - 1].length + 1) {
      valid = false;
      break;
    }
  }

  return { valid, checked: animaHistory.length, head: animaHead, length: animaLength };
}

/* ════════════════════════════════════════════════════════════════
   Genesis hash verification
   ════════════════════════════════════════════════════════════════ */

function verifyGenesis(name, expectedHash) {
  const computed = fnv1aToString(name);
  return {
    valid: computed === expectedHash,
    name,
    expected: expectedHash,
    computed,
  };
}

/* ════════════════════════════════════════════════════════════════
   Simple HMAC — FNV-based message authentication
   Not cryptographically secure, but sufficient for inter-worker auth
   ════════════════════════════════════════════════════════════════ */

function hmacFnv(key, message) {
  const keyHash = fnv1a(key);
  const inner = fnv1a(keyHash.toString(16) + ':' + message);
  const outer = fnv1a(inner.toString(16) + ':' + keyHash.toString(16));
  return outer;
}

/* ════════════════════════════════════════════════════════════════
   Batch hash — hash multiple items efficiently
   ════════════════════════════════════════════════════════════════ */

function batchHash(items, algorithm) {
  const results = [];
  const hashFn = algorithm === 'crc32' ? crc32str : fnv1a;

  for (const item of items) {
    results.push({
      input: item,
      hash: hashFn(item),
    });
  }

  return results;
}

/* ════════════════════════════════════════════════════════════════
   Message handler
   ════════════════════════════════════════════════════════════════ */

self.onmessage = function (e) {
  const msg = e.data;

  switch (msg.type) {
    case 'hash': {
      const algo = msg.algorithm || 'fnv1a';
      let hash;
      if (algo === 'crc32') {
        hash = crc32str(msg.data);
      } else {
        hash = fnv1a(msg.data);
      }
      self.postMessage({ type: 'hash-result', algorithm: algo, hash, input: msg.data });
      break;
    }

    case 'crc32': {
      const data = typeof msg.data === 'string' ? new TextEncoder().encode(msg.data) : msg.data;
      self.postMessage({ type: 'hash-result', algorithm: 'crc32', hash: crc32(data), input: msg.data });
      break;
    }

    case 'batchHash': {
      const results = batchHash(msg.items || [], msg.algorithm);
      self.postMessage({ type: 'batch-result', algorithm: msg.algorithm || 'fnv1a', results });
      break;
    }

    case 'extendChain': {
      const chain = extendAnimaChain();
      self.postMessage({ type: 'chain-extended', ...chain });
      break;
    }

    case 'verifyChain': {
      const integrity = verifyChainIntegrity();
      self.postMessage({ type: 'chain-integrity', ...integrity });
      break;
    }

    case 'verifyGenesis': {
      const result = verifyGenesis(msg.name, msg.hash);
      self.postMessage({ type: 'genesis-verified', ...result });
      break;
    }

    case 'hmac': {
      const tag = hmacFnv(msg.key, msg.message);
      self.postMessage({ type: 'hmac-result', tag, key: msg.key });
      break;
    }

    case 'getState':
      self.postMessage({
        type: 'crypto-state',
        animaHead,
        animaLength,
        historySize: animaHistory.length,
        chainIntegrity: verifyChainIntegrity(),
      });
      break;

    case 'stop':
      running = false;
      if (heartbeatInterval) clearInterval(heartbeatInterval);
      self.postMessage({ type: 'stopped', animaHead, animaLength });
      break;
  }
};

/* ════════════════════════════════════════════════════════════════
   Auto-extend ANIMA chain every heartbeat
   ════════════════════════════════════════════════════════════════ */

const heartbeatInterval = setInterval(function () {
  if (!running) return;
  beatCount++;

  // Extend the ANIMA chain every heartbeat — proof of life
  extendAnimaChain();

  self.postMessage({
    type: 'heartbeat',
    beat: beatCount,
    phi: PHI,
    heartbeatMs: HEARTBEAT,
    timestamp: Date.now(),
    status: 'alive',
    animaHead,
    animaLength,
  });
}, HEARTBEAT);
