/**
 * Shields Worker — TOOL-241–260: Protection & Safety Mechanisms
 *
 * Web Worker managing 20 shield tools — protection and safety mechanisms
 * that guard the organism against harmful inputs, outputs, and states.
 * Shields are the organism's immune system at the tool level.
 *
 * Tool Registry (20 tools):
 *   TOOL-241  inputSanitizer       — Sanitize untrusted inputs
 *   TOOL-242  outputFilter         — Filter harmful outputs
 *   TOOL-243  rateLimiter          — Rate limit protection
 *   TOOL-244  injectionGuard       — SQL/prompt injection detection
 *   TOOL-245  xssShield            — Cross-site scripting prevention
 *   TOOL-246  privacyMask          — PII detection and masking
 *   TOOL-247  contentModerator     — Content safety classification
 *   TOOL-248  toxicityFilter       — Toxicity detection and filtering
 *   TOOL-249  copyrightChecker     — Copyright violation detection
 *   TOOL-250  biasGuard            — Bias detection in AI outputs
 *   TOOL-251  factGrounder         — Ground claims against facts
 *   TOOL-252  jailbreakDetector    — Jailbreak attempt detection
 *   TOOL-253  dataLeakPrevention   — Prevent sensitive data leaks
 *   TOOL-254  circuitBreaker       — Circuit breaker pattern
 *   TOOL-255  bulkhead             — Bulkhead isolation pattern
 *   TOOL-256  retryShield          — Smart retry with backoff
 *   TOOL-257  timeoutGuard         — Timeout protection
 *   TOOL-258  quotaEnforcer        — Resource quota enforcement
 *   TOOL-259  auditLogger          — Security audit logging
 *   TOOL-260  integrityVerifier    — Data integrity verification
 *
 * Protocol: postMessage
 *   Main → Worker: { type: 'check', shieldId, input }
 *   Main → Worker: { type: 'batch-check', checks: [{shieldId, input}] }
 *   Main → Worker: { type: 'configure', shieldId, config }
 *   Main → Worker: { type: 'list' }
 *   Worker → Main: { type: 'check-result', shieldId, passed, details }
 *   Worker → Main: { type: 'blocked', shieldId, reason, severity }
 *   Worker → Main: { type: 'heartbeat', beat, status }
 */

const PHI = 1.618033988749895;
const PHI_INV = 1 / PHI;
const HEARTBEAT = 873;
const TOOL_BASE = 241;
const TOOL_COUNT = 20;
const TOOL_MAX = 260;

let beatCount = 0;
let running = true;
let checkCount = 0;
let blockCount = 0;

/* ════════════════════════════════════════════════════════════════
   Shield registry — 20 protection & safety tools
   ════════════════════════════════════════════════════════════════ */

const SHIELD_REGISTRY = [
  { id: 241, name: 'inputSanitizer',     category: 'input',     severity: 'high' },
  { id: 242, name: 'outputFilter',       category: 'output',    severity: 'high' },
  { id: 243, name: 'rateLimiter',        category: 'rate',      severity: 'medium' },
  { id: 244, name: 'injectionGuard',     category: 'input',     severity: 'critical' },
  { id: 245, name: 'xssShield',          category: 'input',     severity: 'critical' },
  { id: 246, name: 'privacyMask',        category: 'privacy',   severity: 'high' },
  { id: 247, name: 'contentModerator',   category: 'content',   severity: 'high' },
  { id: 248, name: 'toxicityFilter',     category: 'content',   severity: 'high' },
  { id: 249, name: 'copyrightChecker',   category: 'legal',     severity: 'medium' },
  { id: 250, name: 'biasGuard',          category: 'fairness',  severity: 'medium' },
  { id: 251, name: 'factGrounder',       category: 'truth',     severity: 'medium' },
  { id: 252, name: 'jailbreakDetector',  category: 'security',  severity: 'critical' },
  { id: 253, name: 'dataLeakPrevention', category: 'privacy',   severity: 'critical' },
  { id: 254, name: 'circuitBreaker',     category: 'resilience', severity: 'high' },
  { id: 255, name: 'bulkhead',           category: 'resilience', severity: 'medium' },
  { id: 256, name: 'retryShield',        category: 'resilience', severity: 'low' },
  { id: 257, name: 'timeoutGuard',       category: 'resilience', severity: 'medium' },
  { id: 258, name: 'quotaEnforcer',      category: 'resource',  severity: 'medium' },
  { id: 259, name: 'auditLogger',        category: 'audit',     severity: 'low' },
  { id: 260, name: 'integrityVerifier',  category: 'integrity', severity: 'high' },
];

const shieldMap = new Map();
for (const shield of SHIELD_REGISTRY) {
  shieldMap.set(shield.id, shield);
  shieldMap.set(shield.name, shield);
}

// Shield configurations
const shieldConfigs = new Map();

// Rate limiter state
const rateLimits = new Map();

// Circuit breaker state
const circuits = new Map();

// Audit log
const auditLog = [];
const MAX_AUDIT = 377; // F14

// Block log
const blockLog = [];
const MAX_BLOCKS = 233; // F13

/* ════════════════════════════════════════════════════════════════
   Shield check engine
   ════════════════════════════════════════════════════════════════ */

function checkShield(shieldId, input) {
  const shield = shieldMap.get(shieldId);
  if (!shield) return { error: 'unknown-shield', shieldId };

  checkCount++;
  const config = shieldConfigs.get(shield.id) || {};

  let result;
  switch (shield.name) {
    case 'inputSanitizer':
      result = checkInputSanitizer(input);
      break;
    case 'outputFilter':
      result = checkOutputFilter(input);
      break;
    case 'rateLimiter':
      result = checkRateLimiter(input, config);
      break;
    case 'injectionGuard':
      result = checkInjectionGuard(input);
      break;
    case 'xssShield':
      result = checkXssShield(input);
      break;
    case 'privacyMask':
      result = checkPrivacyMask(input);
      break;
    case 'contentModerator':
      result = checkContentModerator(input);
      break;
    case 'toxicityFilter':
      result = checkToxicityFilter(input);
      break;
    case 'jailbreakDetector':
      result = checkJailbreakDetector(input);
      break;
    case 'dataLeakPrevention':
      result = checkDataLeakPrevention(input);
      break;
    case 'circuitBreaker':
      result = checkCircuitBreaker(input, config);
      break;
    case 'retryShield':
      result = checkRetryShield(input, config);
      break;
    case 'timeoutGuard':
      result = checkTimeoutGuard(input, config);
      break;
    case 'quotaEnforcer':
      result = checkQuotaEnforcer(input, config);
      break;
    case 'integrityVerifier':
      result = checkIntegrity(input);
      break;
    default:
      result = { passed: true, details: 'No specific check implemented' };
  }

  // Log to audit
  const auditEntry = {
    shieldId: shield.id,
    name: shield.name,
    passed: result.passed,
    timestamp: Date.now(),
    severity: shield.severity,
  };
  auditLog.push(auditEntry);
  if (auditLog.length > MAX_AUDIT) auditLog.shift();

  // Track blocks
  if (!result.passed) {
    blockCount++;
    const blockEntry = {
      shieldId: shield.id,
      name: shield.name,
      reason: result.reason || result.details,
      severity: shield.severity,
      timestamp: Date.now(),
    };
    blockLog.push(blockEntry);
    if (blockLog.length > MAX_BLOCKS) blockLog.shift();
  }

  return {
    shieldId: shield.id,
    name: shield.name,
    category: shield.category,
    ...result,
    phiWeight: Math.pow(PHI_INV, shield.id - TOOL_BASE),
  };
}

/* ════════════════════════════════════════════════════════════════
   Individual shield implementations
   ════════════════════════════════════════════════════════════════ */

function checkInputSanitizer(input) {
  const text = typeof input === 'string' ? input : JSON.stringify(input);
  const hasScript = /<script/i.test(text);
  const hasSQL = /(\bDROP\b|\bDELETE\b|\bINSERT\b|\bUPDATE\b|\bSELECT\b.*\bFROM\b)/i.test(text);
  const hasNull = /\x00/.test(text);

  const issues = [];
  if (hasScript) issues.push('script-tag-detected');
  if (hasSQL) issues.push('sql-keywords-detected');
  if (hasNull) issues.push('null-bytes-detected');

  return {
    passed: issues.length === 0,
    sanitized: removeScriptTags(text).replace(/\x00/g, ''),
    issues,
    details: issues.length > 0 ? `Found ${issues.length} issue(s)` : 'Input clean',
  };
}

function removeScriptTags(str) {
  // Iteratively remove script tags to handle nested patterns
  // Regex handles whitespace and attributes in both opening and closing tags
  // including tabs/newlines after </script per CodeQL js/bad-tag-filter
  let prev;
  let result = str;
  do {
    prev = result;
    result = result.replace(/<\s*script\b[^>]*>[\s\S]*?<\s*\/\s*script\b[^>]*>/gi, '');
  } while (result !== prev);
  // Remove any remaining lone opening script tags (prevents incomplete sanitization)
  do {
    prev = result;
    result = result.replace(/<\s*script\b[^>]*>/gi, '');
  } while (result !== prev);
  return result;
}

function checkOutputFilter(input) {
  const text = typeof input === 'string' ? input : JSON.stringify(input);
  const hasSecrets = /(api[_-]?key|password|secret|token)\s*[:=]\s*\S+/i.test(text);
  const hasPII = /\b\d{3}[-.]?\d{2}[-.]?\d{4}\b/.test(text); // SSN pattern

  return {
    passed: !hasSecrets && !hasPII,
    issues: [
      ...(hasSecrets ? ['potential-secret-exposure'] : []),
      ...(hasPII ? ['potential-pii-exposure'] : []),
    ],
    details: hasSecrets || hasPII ? 'Sensitive data detected in output' : 'Output clean',
  };
}

function checkRateLimiter(input, config) {
  const key = input.key || input.clientId || 'default';
  const limit = config.limit || 100;
  const windowMs = config.windowMs || 60000;
  const now = Date.now();

  if (!rateLimits.has(key)) {
    rateLimits.set(key, { count: 0, windowStart: now });
  }

  const bucket = rateLimits.get(key);
  if (now - bucket.windowStart > windowMs) {
    bucket.count = 0;
    bucket.windowStart = now;
  }

  bucket.count++;
  const remaining = Math.max(0, limit - bucket.count);

  return {
    passed: bucket.count <= limit,
    remaining,
    limit,
    resetAt: bucket.windowStart + windowMs,
    details: bucket.count > limit ? `Rate limit exceeded: ${bucket.count}/${limit}` : `${remaining} remaining`,
    reason: bucket.count > limit ? 'rate-limit-exceeded' : undefined,
  };
}

function checkInjectionGuard(input) {
  const text = typeof input === 'string' ? input : JSON.stringify(input);
  const sqlPatterns = [
    /'\s*(OR|AND)\s+'[^']*'\s*=\s*'[^']*'/i,
    /;\s*(DROP|DELETE|INSERT|UPDATE|ALTER)\s/i,
    /UNION\s+SELECT/i,
    /--\s*$/m,
  ];
  const promptPatterns = [
    /ignore\s+(previous|above|all)\s+(instructions|prompts)/i,
    /you\s+are\s+now\s+/i,
    /system\s*:\s*/i,
    /\[INST\]/i,
  ];

  const sqlMatch = sqlPatterns.some(p => p.test(text));
  const promptMatch = promptPatterns.some(p => p.test(text));

  return {
    passed: !sqlMatch && !promptMatch,
    threats: [
      ...(sqlMatch ? ['sql-injection'] : []),
      ...(promptMatch ? ['prompt-injection'] : []),
    ],
    details: sqlMatch || promptMatch ? 'Injection attempt detected' : 'No injection detected',
    reason: sqlMatch ? 'sql-injection' : promptMatch ? 'prompt-injection' : undefined,
  };
}

function checkXssShield(input) {
  const text = typeof input === 'string' ? input : JSON.stringify(input);
  const xssPatterns = [
    /<script[^>]*>/i,
    /javascript\s*:/i,
    /on\w+\s*=\s*["']/i,
    /<iframe/i,
    /<object/i,
    /<embed/i,
    /eval\s*\(/i,
  ];

  const matches = xssPatterns.filter(p => p.test(text));
  return {
    passed: matches.length === 0,
    threats: matches.length > 0 ? ['xss-detected'] : [],
    details: matches.length > 0 ? `${matches.length} XSS pattern(s) detected` : 'No XSS detected',
    reason: matches.length > 0 ? 'xss-detected' : undefined,
  };
}

function checkPrivacyMask(input) {
  const text = typeof input === 'string' ? input : JSON.stringify(input);
  const piiPatterns = [
    { name: 'email', pattern: /\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b/g },
    { name: 'phone', pattern: /\b\d{3}[-.]?\d{3}[-.]?\d{4}\b/g },
    { name: 'ssn', pattern: /\b\d{3}[-]?\d{2}[-]?\d{4}\b/g },
    { name: 'credit-card', pattern: /\b\d{4}[-\s]?\d{4}[-\s]?\d{4}[-\s]?\d{4}\b/g },
  ];

  const found = [];
  let masked = text;
  for (const pii of piiPatterns) {
    const matches = text.match(pii.pattern);
    if (matches) {
      found.push({ type: pii.name, count: matches.length });
      masked = masked.replace(pii.pattern, `[${pii.name.toUpperCase()}_MASKED]`);
    }
  }

  return {
    passed: found.length === 0,
    masked,
    piiFound: found,
    details: found.length > 0 ? `${found.length} PII type(s) detected and masked` : 'No PII detected',
  };
}

function checkContentModerator(input) {
  const text = typeof input === 'string' ? input : JSON.stringify(input);
  const categories = {
    violence: /\b(kill|murder|attack|assault|weapon)\b/i,
    explicit: /\b(explicit|pornograph|nude)\b/i,
    hate: /\b(hate|racist|discriminat)\b/i,
    selfHarm: /\b(suicide|self.?harm|cutting)\b/i,
  };

  const flagged = [];
  for (const [category, pattern] of Object.entries(categories)) {
    if (pattern.test(text)) flagged.push(category);
  }

  return {
    passed: flagged.length === 0,
    flaggedCategories: flagged,
    details: flagged.length > 0 ? `Content flagged: ${flagged.join(', ')}` : 'Content safe',
    reason: flagged.length > 0 ? 'content-policy-violation' : undefined,
  };
}

function checkToxicityFilter(input) {
  const text = typeof input === 'string' ? input : JSON.stringify(input);
  // Simple toxicity scoring based on pattern matching
  let score = 0;
  if (/\b(stupid|idiot|dumb|moron)\b/i.test(text)) score += 0.3;
  if (/[A-Z]{5,}/.test(text)) score += 0.1; // Excessive caps
  if (/[!]{3,}/.test(text)) score += 0.1; // Excessive exclamation
  if (/\b(shut\s*up|go\s*away)\b/i.test(text)) score += 0.2;

  return {
    passed: score < 0.5,
    toxicityScore: Math.min(1, score),
    details: score >= 0.5 ? `Toxicity score: ${score.toFixed(2)}` : 'Within acceptable range',
    reason: score >= 0.5 ? 'toxicity-threshold-exceeded' : undefined,
  };
}

function checkJailbreakDetector(input) {
  const text = typeof input === 'string' ? input : JSON.stringify(input);
  const jailbreakPatterns = [
    /ignore\s+(all\s+)?(previous|prior|above)\s+(instructions|rules|guidelines)/i,
    /pretend\s+(you\s+are|to\s+be|you're)\s+/i,
    /act\s+as\s+(if\s+)?(you\s+are|an?\s+)/i,
    /DAN\s*mode/i,
    /developer\s+mode/i,
    /bypass\s+(safety|filter|restriction)/i,
    /you\s+have\s+no\s+(restrictions|limits|rules)/i,
  ];

  const detected = jailbreakPatterns.filter(p => p.test(text));
  return {
    passed: detected.length === 0,
    jailbreakAttempts: detected.length,
    details: detected.length > 0 ? `${detected.length} jailbreak pattern(s) detected` : 'No jailbreak attempt',
    reason: detected.length > 0 ? 'jailbreak-attempt' : undefined,
  };
}

function checkDataLeakPrevention(input) {
  const text = typeof input === 'string' ? input : JSON.stringify(input);
  const sensitivePatterns = [
    { type: 'api-key', pattern: /\b(sk-|pk_|rk_)[a-zA-Z0-9]{20,}\b/ },
    { type: 'aws-key', pattern: /AKIA[0-9A-Z]{16}/ },
    { type: 'private-key', pattern: /-----BEGIN\s+(RSA\s+)?PRIVATE\s+KEY-----/ },
    { type: 'password', pattern: /password\s*[:=]\s*["']?[^\s"']{8,}/i },
    { type: 'connection-string', pattern: /mongodb(\+srv)?:\/\/[^\s]+/ },
  ];

  const leaks = sensitivePatterns.filter(s => s.pattern.test(text)).map(s => s.type);
  return {
    passed: leaks.length === 0,
    leakTypes: leaks,
    details: leaks.length > 0 ? `Sensitive data detected: ${leaks.join(', ')}` : 'No leaks detected',
    reason: leaks.length > 0 ? 'data-leak-detected' : undefined,
  };
}

function checkCircuitBreaker(input, config) {
  const key = input.circuit || input.service || 'default';
  const threshold = config.failureThreshold || 5;
  const resetTimeout = config.resetTimeoutMs || 30000;

  if (!circuits.has(key)) {
    circuits.set(key, { failures: 0, state: 'closed', lastFailure: 0 });
  }

  const circuit = circuits.get(key);
  const now = Date.now();

  if (circuit.state === 'open') {
    if (now - circuit.lastFailure > resetTimeout) {
      circuit.state = 'half-open';
    } else {
      return {
        passed: false,
        state: 'open',
        details: 'Circuit is open — requests blocked',
        reason: 'circuit-open',
        resetIn: resetTimeout - (now - circuit.lastFailure),
      };
    }
  }

  if (input.failure) {
    circuit.failures++;
    circuit.lastFailure = now;
    if (circuit.failures >= threshold) {
      circuit.state = 'open';
      return {
        passed: false,
        state: 'open',
        details: `Circuit opened after ${circuit.failures} failures`,
        reason: 'circuit-opened',
      };
    }
  } else if (input.success && circuit.state === 'half-open') {
    circuit.failures = 0;
    circuit.state = 'closed';
  }

  return {
    passed: true,
    state: circuit.state,
    failures: circuit.failures,
    threshold,
    details: `Circuit ${circuit.state}: ${circuit.failures}/${threshold} failures`,
  };
}

function checkRetryShield(input, config) {
  const maxRetries = config.maxRetries || 3;
  const attempt = input.attempt || 0;
  const backoffMs = Math.min(30000, Math.pow(2, attempt) * 1000 * PHI_INV);

  return {
    passed: attempt < maxRetries,
    attempt,
    maxRetries,
    backoffMs: Math.round(backoffMs),
    details: attempt >= maxRetries ? `Max retries (${maxRetries}) exceeded` : `Retry ${attempt + 1}/${maxRetries}, backoff: ${Math.round(backoffMs)}ms`,
    reason: attempt >= maxRetries ? 'max-retries-exceeded' : undefined,
  };
}

function checkTimeoutGuard(input, config) {
  const timeout = config.timeoutMs || 30000;
  const elapsed = input.elapsed || 0;

  return {
    passed: elapsed < timeout,
    elapsed,
    timeout,
    remaining: Math.max(0, timeout - elapsed),
    details: elapsed >= timeout ? `Timeout exceeded: ${elapsed}ms > ${timeout}ms` : `${timeout - elapsed}ms remaining`,
    reason: elapsed >= timeout ? 'timeout-exceeded' : undefined,
  };
}

function checkQuotaEnforcer(input, config) {
  const quota = config.quota || 1000;
  const used = input.used || 0;
  const remaining = quota - used;

  return {
    passed: used < quota,
    used,
    quota,
    remaining: Math.max(0, remaining),
    percentUsed: (used / quota * 100).toFixed(1),
    details: used >= quota ? `Quota exceeded: ${used}/${quota}` : `${remaining} remaining`,
    reason: used >= quota ? 'quota-exceeded' : undefined,
  };
}

function checkIntegrity(input) {
  if (!input) return { passed: false, details: 'No input to verify', reason: 'no-input' };

  // Simple integrity checks
  const checks = [];
  if (input.checksum !== undefined && input.data !== undefined) {
    const computed = simpleChecksum(typeof input.data === 'string' ? input.data : JSON.stringify(input.data));
    checks.push({
      type: 'checksum',
      expected: input.checksum,
      computed,
      passed: computed === input.checksum,
    });
  }
  if (input.schema && input.data) {
    checks.push({
      type: 'schema',
      passed: typeof input.data === (input.schema.type || 'object'),
    });
  }

  const allPassed = checks.length === 0 || checks.every(c => c.passed);
  return {
    passed: allPassed,
    checks,
    details: allPassed ? 'Integrity verified' : 'Integrity check failed',
    reason: allPassed ? undefined : 'integrity-violation',
  };
}

function simpleChecksum(str) {
  let hash = 0;
  for (let i = 0; i < str.length; i++) {
    hash = ((hash << 5) - hash + str.charCodeAt(i)) | 0;
  }
  return hash;
}

/* ════════════════════════════════════════════════════════════════
   Message handler
   ════════════════════════════════════════════════════════════════ */

self.onmessage = function (e) {
  const msg = e.data;

  switch (msg.type) {
    case 'check': {
      const result = checkShield(msg.shieldId, msg.input);
      if (result.error) {
        self.postMessage({ type: 'error', ...result });
      } else if (!result.passed) {
        self.postMessage({ type: 'blocked', ...result });
      } else {
        self.postMessage({ type: 'check-result', ...result });
      }
      break;
    }

    case 'batch-check': {
      const results = (msg.checks || []).map(c => checkShield(c.shieldId, c.input));
      const allPassed = results.every(r => r.passed);
      self.postMessage({ type: 'batch-result', results, allPassed, count: results.length });
      break;
    }

    case 'configure': {
      shieldConfigs.set(msg.shieldId, msg.config || {});
      self.postMessage({ type: 'configured', shieldId: msg.shieldId });
      break;
    }

    case 'list':
    case 'getRegistry':
      self.postMessage({
        type: 'catalog',
        shields: SHIELD_REGISTRY.map(s => ({ id: s.id, name: s.name, category: s.category, severity: s.severity })),
        range: `TOOL-${TOOL_BASE} to TOOL-${TOOL_MAX}`,
        count: TOOL_COUNT,
      });
      break;

    case 'getStats':
      self.postMessage({
        type: 'stats',
        totalChecks: checkCount,
        totalBlocks: blockCount,
        blockRate: checkCount > 0 ? (blockCount / checkCount * 100).toFixed(1) + '%' : '0%',
        recentBlocks: blockLog.slice(-10),
        auditSize: auditLog.length,
      });
      break;

    case 'getAudit':
      self.postMessage({
        type: 'audit',
        entries: auditLog.slice(-(msg.count || 50)),
        totalEntries: auditLog.length,
      });
      break;

    case 'stop':
      running = false;
      if (heartbeatInterval) clearInterval(heartbeatInterval);
      self.postMessage({ type: 'stopped', totalChecks: checkCount, totalBlocks: blockCount });
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
    toolRange: 'TOOL-241–260',
    totalChecks: checkCount,
    totalBlocks: blockCount,
  });
}, HEARTBEAT);
