/**
 * Adapters Worker — TOOL-201–221: Cross-System Connectors
 *
 * Web Worker managing adapter tools — connectors for AI providers,
 * infrastructure services, and security. Each adapter normalizes
 * external protocols into the organism's internal signal format.
 *
 * Tool Registry:
 *   TOOL-201  openaiAdapter       — OpenAI native provider (GPT-4o, 4.1, o1, o3, o4-mini)
 *   TOOL-202  anthropicAdapter    — Anthropic native provider (Opus, Sonnet, Haiku)
 *   TOOL-203  googleAdapter       — Google Gemini native provider (Pro, Ultra, Flash)
 *   TOOL-204  metaAdapter         — Meta Llama native provider (3.3, 4 Scout, 4 Maverick)
 *   TOOL-205  mistralAdapter      — Mistral native provider (Large, Codestral, Mixtral)
 *   TOOL-206  deepseekAdapter     — DeepSeek native provider (V3, R1)
 *   TOOL-207  chimeriaVoice       — CHIMERIA native voice synthesis engine (formant-based)
 *   TOOL-210  pineconeAdapter     — Pinecone vector DB connector
 *   TOOL-211  weaviateAdapter     — Weaviate vector DB connector
 *   TOOL-212  supabaseAdapter     — Supabase backend connector
 *   TOOL-213  stripeAdapter       — Stripe payments connector
 *   TOOL-214  twilioAdapter       — Twilio communications connector
 *   TOOL-215  sendgridAdapter     — SendGrid email connector
 *   TOOL-216  githubAdapter       — GitHub API connector
 *   TOOL-217  slackAdapter        — Slack messaging connector
 *   TOOL-218  webhookAdapter      — Generic webhook connector
 *   TOOL-219  graphqlAdapter      — Generic GraphQL connector
 *   TOOL-220  restAdapter         — Generic REST API connector
 *   TOOL-221  securityAdapter     — Meridianus Security Adapter (φ-doctrine ICP gate)
 *
 * Protocol: postMessage
 *   Main → Worker: { type: 'connect', adapterId, config }
 *   Main → Worker: { type: 'request', adapterId, method, params }
 *   Main → Worker: { type: 'disconnect', adapterId }
 *   Main → Worker: { type: 'list' }
 *   Worker → Main: { type: 'response', adapterId, data, latency }
 *   Worker → Main: { type: 'adapter-error', adapterId, error }
 *   Worker → Main: { type: 'heartbeat', beat, status }
 */

const PHI = 1.618033988749895;
const PHI_INV = 1 / PHI;
const HEARTBEAT = 873;
const TOOL_BASE = 201;
const TOOL_COUNT = 19;  // 6 AI providers + 1 native voice + 11 infrastructure + 1 security
const TOOL_MAX = 221;

let beatCount = 0;
let running = true;
let requestCount = 0;

/* ════════════════════════════════════════════════════════════════
   Adapter registry — 6 native AI providers + 1 native voice + 11 infrastructure + 1 security
   TOOL-221: Meridianus Security Adapter (φ-doctrine ICP gate)
   ════════════════════════════════════════════════════════════════ */

const ADAPTER_REGISTRY = [
  // Native AI Provider Adapters (real HTTP, production-ready)
  { id: 201, name: 'openaiAdapter',      provider: 'OpenAI',         protocol: 'rest',     category: 'ai-provider',  module: 'src/ai_division/providers/openai.js',    models: ['gpt-4o', 'gpt-4.1', 'o1', 'o3', 'o4-mini'] },
  { id: 202, name: 'anthropicAdapter',   provider: 'Anthropic',      protocol: 'rest',     category: 'ai-provider',  module: 'src/ai_division/providers/anthropic.js',  models: ['claude-opus-4', 'claude-sonnet-4', 'claude-haiku-3.5'] },
  { id: 203, name: 'googleAdapter',      provider: 'Google',         protocol: 'rest',     category: 'ai-provider',  module: 'src/ai_division/providers/google.js',     models: ['gemini-2.5-pro', 'gemini-ultra', 'gemini-2.5-flash'] },
  { id: 204, name: 'metaAdapter',        provider: 'Meta',           protocol: 'rest',     category: 'ai-provider',  module: 'src/ai_division/providers/meta.js',       models: ['llama-3.3-70b', 'llama-4-scout', 'llama-4-maverick'] },
  { id: 205, name: 'mistralAdapter',     provider: 'Mistral',        protocol: 'rest',     category: 'ai-provider',  module: 'src/ai_division/providers/mistral.js',    models: ['mistral-large', 'codestral', 'mixtral-8x22b'] },
  { id: 206, name: 'deepseekAdapter',    provider: 'DeepSeek',       protocol: 'rest',     category: 'ai-provider',  module: 'src/ai_division/providers/deepseek.js',   models: ['deepseek-chat', 'deepseek-reasoner'] },
  // Native Voice Engine (no external TTS — built in-house)
  { id: 207, name: 'chimeriaVoice',      provider: 'CHIMERIA',       protocol: 'native',   category: 'voice',        module: 'src/ai_division/voice/index.js',          presets: ['chimeria-default', 'chimeria-warm', 'chimeria-sharp', 'chimeria-deep'] },
  // Infrastructure connectors
  { id: 210, name: 'pineconeAdapter',    provider: 'Pinecone',       protocol: 'rest',     category: 'vector-db' },
  { id: 211, name: 'weaviateAdapter',    provider: 'Weaviate',       protocol: 'graphql',  category: 'vector-db' },
  { id: 212, name: 'supabaseAdapter',    provider: 'Supabase',       protocol: 'rest',     category: 'backend' },
  { id: 213, name: 'stripeAdapter',      provider: 'Stripe',         protocol: 'rest',     category: 'payments' },
  { id: 214, name: 'twilioAdapter',      provider: 'Twilio',         protocol: 'rest',     category: 'comms' },
  { id: 215, name: 'sendgridAdapter',    provider: 'SendGrid',       protocol: 'rest',     category: 'email' },
  { id: 216, name: 'githubAdapter',      provider: 'GitHub',         protocol: 'rest',     category: 'devops' },
  { id: 217, name: 'slackAdapter',       provider: 'Slack',          protocol: 'rest',     category: 'messaging' },
  { id: 218, name: 'webhookAdapter',     provider: 'Generic',        protocol: 'webhook',  category: 'integration' },
  { id: 219, name: 'graphqlAdapter',     provider: 'Generic',        protocol: 'graphql',  category: 'integration' },
  { id: 220, name: 'restAdapter',        provider: 'Generic',        protocol: 'rest',     category: 'integration' },
  // TOOL-221: Meridianus Security Adapter — φ-bot protection for any ICP canister or web app
  {
    id: 221, name: 'securityAdapter', provider: 'Meridianus/ICP', protocol: 'icp+rest', category: 'security',
    description: 'Medina phi-doctrine security gate. Rate: F11=89/60s. Threshold: phi-inv=0.618. Blacklist: F8=21 flags.',
    methods: ['checkCaller', 'rateCheck', 'reportBot', 'isBlocked', 'getStatus', 'getThresholds'],
    httpEndpoints: ['/security/check', '/security/status', '/security/thresholds', '/security/report'],
    icpCanisterId: null,  // set after: dfx deploy security_adapter && dfx canister id security_adapter
    docs: 'src/security_adapter/README.md',
    layers: 3,
  },
];

const adapterMap = new Map();
for (const adapter of ADAPTER_REGISTRY) {
  adapterMap.set(adapter.id, adapter);
  adapterMap.set(adapter.name, adapter);
}

// Connected adapters with their configurations
const connections = new Map();

// Request history
const requestLog = [];
const MAX_REQUEST_LOG = 233; // F13

/* ════════════════════════════════════════════════════════════════
   Adapter connection & request handling
   ════════════════════════════════════════════════════════════════ */

function connectAdapter(adapterId, config) {
  const adapter = adapterMap.get(adapterId);
  if (!adapter) return { error: 'unknown-adapter', adapterId };

  const connection = {
    adapterId: adapter.id,
    name: adapter.name,
    provider: adapter.provider,
    protocol: adapter.protocol,
    config: config || {},
    status: 'connected',
    connectedAt: Date.now(),
    requestCount: 0,
    errorCount: 0,
    totalLatency: 0,
  };

  connections.set(adapter.id, connection);
  return { adapterId: adapter.id, name: adapter.name, status: 'connected' };
}

function handleRequest(adapterId, method, params) {
  const adapter = adapterMap.get(adapterId);
  if (!adapter) return { error: 'unknown-adapter', adapterId };

  const connection = connections.get(adapter.id);
  if (!connection) return { error: 'not-connected', adapterId: adapter.id, name: adapter.name };

  const start = performance.now();
  requestCount++;
  connection.requestCount++;

  // Build normalized request
  const request = {
    adapterId: adapter.id,
    provider: adapter.provider,
    protocol: adapter.protocol,
    method: method || 'default',
    params: params || {},
    timestamp: Date.now(),
  };

  // Simulate adapter response (in real system, would make actual API calls)
  const response = simulateAdapterResponse(adapter, method, params);
  const latency = performance.now() - start;
  connection.totalLatency += latency;

  // Log request
  requestLog.push({
    adapterId: adapter.id,
    method,
    latency,
    timestamp: Date.now(),
    success: !response.error,
  });
  if (requestLog.length > MAX_REQUEST_LOG) requestLog.shift();

  return {
    adapterId: adapter.id,
    name: adapter.name,
    provider: adapter.provider,
    method,
    data: response,
    latency,
    phiWeight: Math.pow(PHI_INV, adapter.id - TOOL_BASE),
  };
}

function simulateAdapterResponse(adapter, method, params) {
  // Security adapter (TOOL-221): φ-deviation scoring in the browser
  if (adapter.category === 'security') {
    return handleSecurityAdapterRequest(method, params);
  }
  // Base response shape per adapter category
  switch (adapter.category) {
    case 'ai-provider':
      // Native provider adapters — delegates to src/ai_division/providers/*
      return {
        status: 'ready',
        provider: adapter.provider,
        models: adapter.models || [],
        module: adapter.module,
        note: 'Use ProviderRouter.infer() for actual inference — this worker registers availability',
      };
    case 'voice':
      // CHIMERIA native voice engine — formant synthesis
      return {
        status: 'ready',
        provider: adapter.provider,
        engine: 'formant-synthesis',
        presets: adapter.presets || [],
        module: adapter.module,
        note: 'Use VoiceEngine.synthesize() for audio generation — zero external TTS dependencies',
      };
    case 'vector-db':
      return {
        matches: [],
        namespace: params ? params.namespace : 'default',
        queryVector: 'embedded',
      };
    case 'backend':
      return { data: [], count: 0, status: 'ok' };
    case 'payments':
      return { status: 'simulated', amount: 0, currency: 'usd' };
    case 'integration':
      return { status: 'ok', method, provider: adapter.provider };
    default:
      return { status: 'ok', provider: adapter.provider };
  }
}

/* ════════════════════════════════════════════════════════════════
   Security Adapter (TOOL-221) — φ-doctrine engine
   Browser-local L2 implementation. Mirrors canister logic.
   ════════════════════════════════════════════════════════════════ */

const secRateTable   = new Map(); // callerId → { count, windowStart, flags }
const secBlacklist   = new Map(); // callerId → { reason, until }
const SEC_WINDOW_MS  = 60_000;
const SEC_BAN_MS     = 600_000;
const SEC_MAX_RATE   = 89;        // Fibonacci F11
const SEC_FLAG_LIMIT = 21;        // Fibonacci F8
let   secEmaBaseline = 5.0;
let   secChecked = 0, secAllowed = 0, secRejected = 0;

function secIsBlocked(who, now) {
  const e = secBlacklist.get(who);
  return e ? e.until > now : false;
}

function secPhiScore(rate) {
  return Math.min(Math.abs(rate - secEmaBaseline) / (secEmaBaseline + 1), 1.0);
}

function secEvaluate(who, now) {
  if (secIsBlocked(who, now)) return { allowed: false, score: 1.0, reason: 'blacklisted', callerRate: SEC_MAX_RATE + 1 };
  let entry = secRateTable.get(who);
  if (!entry || (now - entry.windowStart) > SEC_WINDOW_MS) entry = { count: 0, windowStart: now, flags: entry ? entry.flags : 0 };
  const count = entry.count + 1;
  if (count > SEC_MAX_RATE) { secRateTable.set(who, { ...entry, count }); return { allowed: false, score: 1.0, reason: 'rate_exceeded', callerRate: count }; }
  const score = secPhiScore(count);
  secEmaBaseline = (2 / (PHI * 13 + 1)) * count + (1 - 2 / (PHI * 13 + 1)) * secEmaBaseline;
  const flags = score > PHI_INV ? entry.flags + 1 : entry.flags;
  secRateTable.set(who, { ...entry, count, flags });
  if (flags >= SEC_FLAG_LIMIT) { secBlacklist.set(who, { reason: `phi_flags_${flags}`, until: now + SEC_BAN_MS }); return { allowed: false, score, reason: 'phi_blacklisted', callerRate: count }; }
  return { allowed: true, score, reason: score > PHI_INV ? 'phi_elevated' : 'clean', callerRate: count };
}

function handleSecurityAdapterRequest(method, params) {
  const now = Date.now();
  const who = (params && (params.callerId || params.principalId)) || 'browser-worker';
  switch (method) {
    case 'checkCaller': {
      secChecked++;
      const result = secEvaluate(who, now);
      if (result.allowed) secAllowed++; else secRejected++;
      return { ...result, layer: 'L2_BROWSER_WORKER', phi: PHI, phiInv: PHI_INV };
    }
    case 'rateCheck': {
      const e = secRateTable.get(who);
      const count = (e && (now - e.windowStart) <= SEC_WINDOW_MS ? e.count : 0) + 1;
      return { allowed: count <= SEC_MAX_RATE && !secIsBlocked(who, now), count, maxAllowed: SEC_MAX_RATE };
    }
    case 'reportBot': {
      const suspect = (params && params.suspect) || who;
      const e = secRateTable.get(suspect) || { count: 0, windowStart: now, flags: 0 };
      const flags = e.flags + 1;
      secRateTable.set(suspect, { ...e, flags });
      if (flags >= SEC_FLAG_LIMIT) secBlacklist.set(suspect, { reason: `reported_${(params && params.evidence) || 'unknown'}`, until: now + SEC_BAN_MS });
      return { accepted: true, flags, blacklisted: flags >= SEC_FLAG_LIMIT };
    }
    case 'isBlocked':
      return { blocked: secIsBlocked((params && params.who) || who, now) };
    case 'getStatus': {
      let activeBlacklist = 0;
      for (const e of secBlacklist.values()) { if (e.until > now) activeBlacklist++; }
      return {
        totalChecked: secChecked, totalAllowed: secAllowed, totalRejected: secRejected,
        blacklistSize: activeBlacklist, activeCallers: secRateTable.size,
        coherence: secChecked > 0 ? secAllowed / secChecked : 1.0,
        gateOpen: true, phiInv: PHI_INV,
        layer: 'L2_BROWSER_WORKER',
        doctrine: 'Medina phi-doctrine | L2 browser worker mirror',
      };
    }
    case 'getThresholds':
      return { maxRate: SEC_MAX_RATE, windowSeconds: 60, phiInv: PHI_INV, botFlagThreshold: SEC_FLAG_LIMIT, blacklistDurationMins: 10 };
    default:
      return { error: 'unknown-method', available: ['checkCaller', 'rateCheck', 'reportBot', 'isBlocked', 'getStatus', 'getThresholds'] };
  }
}

function disconnectAdapter(adapterId) {
  const adapter = adapterMap.get(adapterId);
  if (!adapter) return { error: 'unknown-adapter', adapterId };

  const connection = connections.get(adapter.id);
  if (connection) {
    connection.status = 'disconnected';
    connections.delete(adapter.id);
  }

  return { adapterId: adapter.id, name: adapter.name, disconnected: !!connection };
}

/* ════════════════════════════════════════════════════════════════
   Message handler
   ════════════════════════════════════════════════════════════════ */

self.onmessage = function (e) {
  const msg = e.data;

  switch (msg.type) {
    case 'connect': {
      const result = connectAdapter(msg.adapterId, msg.config);
      if (result.error) {
        self.postMessage({ type: 'adapter-error', ...result });
      } else {
        self.postMessage({ type: 'adapter-connected', ...result });
      }
      break;
    }

    case 'request': {
      const result = handleRequest(msg.adapterId, msg.method, msg.params);
      if (result.error) {
        self.postMessage({ type: 'adapter-error', ...result });
      } else {
        self.postMessage({ type: 'response', ...result });
      }
      break;
    }

    case 'disconnect': {
      const result = disconnectAdapter(msg.adapterId);
      self.postMessage({ type: 'adapter-disconnected', ...result });
      break;
    }

    case 'list':
    case 'getRegistry':
      self.postMessage({
        type: 'catalog',
        adapters: ADAPTER_REGISTRY.map(a => ({
          id: a.id, name: a.name, provider: a.provider,
          protocol: a.protocol, category: a.category,
          connected: connections.has(a.id),
        })),
        range: `TOOL-${TOOL_BASE} to TOOL-${TOOL_MAX}`,
        count: TOOL_COUNT,
        connectedCount: connections.size,
      });
      break;

    case 'getStats':
      self.postMessage({
        type: 'stats',
        totalRequests: requestCount,
        connectedAdapters: connections.size,
        adapters: [...connections.values()].map(c => ({
          id: c.adapterId, name: c.name,
          requests: c.requestCount, errors: c.errorCount,
          avgLatency: c.requestCount > 0 ? c.totalLatency / c.requestCount : 0,
        })),
      });
      break;

    case 'stop':
      running = false;
      if (heartbeatInterval) clearInterval(heartbeatInterval);
      self.postMessage({ type: 'stopped', totalRequests: requestCount });
      break;
  }
};

/* ════════════════════════════════════════════════════════════════
   Heartbeat — 873ms φ-scaled
   ════════════════════════════════════════════════════════════════ */

const heartbeatInterval = setInterval(function () {
  if (!running) return;
  beatCount++;
  self.postMessage({
    type: 'heartbeat',
    beat: beatCount,
    phi: PHI,
    heartbeatMs: HEARTBEAT,
    timestamp: Date.now(),
    status: 'alive',
    toolRange: 'TOOL-201–221',
    totalRequests: requestCount,
    connectedAdapters: connections.size,
  });
}, HEARTBEAT);
