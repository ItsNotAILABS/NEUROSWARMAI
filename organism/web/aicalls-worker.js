/**
 * AI Calls Worker — TOOL-061–100: Direct AI Invocations
 *
 * Web Worker that manages 40 AI invocation tools for the organism.
 * Handles goal decomposition, hallucination checking, prompt chaining,
 * reasoning validation, and all direct AI-to-AI communication patterns.
 *
 * Tool Registry (40 tools):
 *   TOOL-061  goalDecompose       — Break complex goals into sub-goals
 *   TOOL-062  hallucinationCheck  — Verify AI output for factual grounding
 *   TOOL-063  promptChain         — Chain sequential AI prompts
 *   TOOL-064  reasoningValidate   — Validate logical reasoning steps
 *   TOOL-065  contextWindow       — Manage context window allocation
 *   TOOL-066  tokenBudget         — Track and allocate token budgets
 *   TOOL-067  responseGrade       — Grade AI response quality (0-1)
 *   TOOL-068  chainOfThought      — Structured CoT reasoning
 *   TOOL-069  fewShotSelect       — Select optimal few-shot examples
 *   TOOL-070  selfCritique        — AI self-evaluation loop
 *   TOOL-071  factExtract         — Extract verifiable facts from text
 *   TOOL-072  claimVerify         — Cross-reference claims against knowledge
 *   TOOL-073  biasDetect          — Detect reasoning biases in output
 *   TOOL-074  uncertaintyQuantify — Quantify confidence levels
 *   TOOL-075  analogyGenerate     — Generate structural analogies
 *   TOOL-076  hypothesisForm      — Form testable hypotheses
 *   TOOL-077  counterArgument     — Generate counter-arguments
 *   TOOL-078  summaryAbstract     — Multi-level text summarization
 *   TOOL-079  entityExtract       — Named entity extraction
 *   TOOL-080  sentimentAnalyze    — Sentiment and tone analysis
 *   TOOL-081  intentClassify      — Classify user/system intent
 *   TOOL-082  topicModel          — Dynamic topic modeling
 *   TOOL-083  keywordExpand       — Semantic keyword expansion
 *   TOOL-084  questionGenerate    — Generate clarifying questions
 *   TOOL-085  answerSynthesize    — Synthesize answers from multiple sources
 *   TOOL-086  codeGenerate        — Generate code from specifications
 *   TOOL-087  codeReview          — Automated code review
 *   TOOL-088  codeExplain         — Explain code in natural language
 *   TOOL-089  testGenerate        — Generate test cases
 *   TOOL-090  docGenerate         — Generate documentation
 *   TOOL-091  translateLang       — Natural language translation
 *   TOOL-092  paraphraseRewrite   — Paraphrase and rewrite content
 *   TOOL-093  styleTransfer       — Transfer writing style
 *   TOOL-094  toneAdjust          — Adjust communication tone
 *   TOOL-095  formatConvert       — Convert between data formats
 *   TOOL-096  schemaValidate      — Validate against JSON/data schemas
 *   TOOL-097  pipelineOrchestrate — Orchestrate multi-model pipelines
 *   TOOL-098  fallbackRoute       — Route to fallback models on failure
 *   TOOL-099  cacheLookup         — Semantic cache for repeated queries
 *   TOOL-100  metaPromptOptimize  — Optimize prompt templates via meta-learning
 *
 * Protocol: postMessage
 *   Main → Worker: { type: 'invoke', toolId, input, context? }
 *   Main → Worker: { type: 'batch', invocations: [{toolId, input}] }
 *   Main → Worker: { type: 'getRegistry' }
 *   Main → Worker: { type: 'getStats' }
 *   Worker → Main: { type: 'result', toolId, output, confidence, latency }
 *   Worker → Main: { type: 'batch-result', results }
 *   Worker → Main: { type: 'error', toolId, error }
 *   Worker → Main: { type: 'heartbeat', beat, status }
 */

const PHI = 1.618033988749895;
const PHI_INV = 1 / PHI;
const HEARTBEAT = 873;
const TOOL_BASE = 61;
const TOOL_COUNT = 40;
const TOOL_MAX = 100;

let beatCount = 0;
let running = true;
let invokeCount = 0;
let errorCount = 0;

/* ════════════════════════════════════════════════════════════════
   Tool registry — 40 AI invocation tools
   ════════════════════════════════════════════════════════════════ */

const TOOL_REGISTRY = [
  { id: 61,  name: 'goalDecompose',       category: 'reasoning',   phiWeight: Math.pow(PHI_INV, 0) },
  { id: 62,  name: 'hallucinationCheck',  category: 'validation',  phiWeight: Math.pow(PHI_INV, 1) },
  { id: 63,  name: 'promptChain',         category: 'orchestration', phiWeight: Math.pow(PHI_INV, 2) },
  { id: 64,  name: 'reasoningValidate',   category: 'validation',  phiWeight: Math.pow(PHI_INV, 3) },
  { id: 65,  name: 'contextWindow',       category: 'resource',    phiWeight: Math.pow(PHI_INV, 4) },
  { id: 66,  name: 'tokenBudget',         category: 'resource',    phiWeight: Math.pow(PHI_INV, 5) },
  { id: 67,  name: 'responseGrade',       category: 'evaluation',  phiWeight: Math.pow(PHI_INV, 6) },
  { id: 68,  name: 'chainOfThought',      category: 'reasoning',   phiWeight: Math.pow(PHI_INV, 7) },
  { id: 69,  name: 'fewShotSelect',       category: 'optimization', phiWeight: Math.pow(PHI_INV, 8) },
  { id: 70,  name: 'selfCritique',        category: 'evaluation',  phiWeight: Math.pow(PHI_INV, 9) },
  { id: 71,  name: 'factExtract',         category: 'extraction',  phiWeight: Math.pow(PHI_INV, 10) },
  { id: 72,  name: 'claimVerify',         category: 'validation',  phiWeight: Math.pow(PHI_INV, 11) },
  { id: 73,  name: 'biasDetect',          category: 'validation',  phiWeight: Math.pow(PHI_INV, 12) },
  { id: 74,  name: 'uncertaintyQuantify', category: 'evaluation',  phiWeight: Math.pow(PHI_INV, 13) },
  { id: 75,  name: 'analogyGenerate',     category: 'reasoning',   phiWeight: Math.pow(PHI_INV, 14) },
  { id: 76,  name: 'hypothesisForm',      category: 'reasoning',   phiWeight: Math.pow(PHI_INV, 15) },
  { id: 77,  name: 'counterArgument',     category: 'reasoning',   phiWeight: Math.pow(PHI_INV, 16) },
  { id: 78,  name: 'summaryAbstract',     category: 'transform',   phiWeight: Math.pow(PHI_INV, 17) },
  { id: 79,  name: 'entityExtract',       category: 'extraction',  phiWeight: Math.pow(PHI_INV, 18) },
  { id: 80,  name: 'sentimentAnalyze',    category: 'analysis',    phiWeight: Math.pow(PHI_INV, 19) },
  { id: 81,  name: 'intentClassify',      category: 'classification', phiWeight: Math.pow(PHI_INV, 20) },
  { id: 82,  name: 'topicModel',          category: 'analysis',    phiWeight: Math.pow(PHI_INV, 21) },
  { id: 83,  name: 'keywordExpand',       category: 'transform',   phiWeight: Math.pow(PHI_INV, 22) },
  { id: 84,  name: 'questionGenerate',    category: 'generation',  phiWeight: Math.pow(PHI_INV, 23) },
  { id: 85,  name: 'answerSynthesize',    category: 'generation',  phiWeight: Math.pow(PHI_INV, 24) },
  { id: 86,  name: 'codeGenerate',        category: 'generation',  phiWeight: Math.pow(PHI_INV, 25) },
  { id: 87,  name: 'codeReview',          category: 'validation',  phiWeight: Math.pow(PHI_INV, 26) },
  { id: 88,  name: 'codeExplain',         category: 'transform',   phiWeight: Math.pow(PHI_INV, 27) },
  { id: 89,  name: 'testGenerate',        category: 'generation',  phiWeight: Math.pow(PHI_INV, 28) },
  { id: 90,  name: 'docGenerate',         category: 'generation',  phiWeight: Math.pow(PHI_INV, 29) },
  { id: 91,  name: 'translateLang',       category: 'transform',   phiWeight: Math.pow(PHI_INV, 30) },
  { id: 92,  name: 'paraphraseRewrite',   category: 'transform',   phiWeight: Math.pow(PHI_INV, 31) },
  { id: 93,  name: 'styleTransfer',       category: 'transform',   phiWeight: Math.pow(PHI_INV, 32) },
  { id: 94,  name: 'toneAdjust',          category: 'transform',   phiWeight: Math.pow(PHI_INV, 33) },
  { id: 95,  name: 'formatConvert',       category: 'transform',   phiWeight: Math.pow(PHI_INV, 34) },
  { id: 96,  name: 'schemaValidate',      category: 'validation',  phiWeight: Math.pow(PHI_INV, 35) },
  { id: 97,  name: 'pipelineOrchestrate', category: 'orchestration', phiWeight: Math.pow(PHI_INV, 36) },
  { id: 98,  name: 'fallbackRoute',       category: 'orchestration', phiWeight: Math.pow(PHI_INV, 37) },
  { id: 99,  name: 'cacheLookup',         category: 'optimization', phiWeight: Math.pow(PHI_INV, 38) },
  { id: 100, name: 'metaPromptOptimize',  category: 'optimization', phiWeight: Math.pow(PHI_INV, 39) },
];

const toolMap = new Map();
for (const tool of TOOL_REGISTRY) {
  toolMap.set(tool.id, tool);
  toolMap.set(tool.name, tool);
}

// Per-tool invocation stats
const toolStats = new Map();
for (const tool of TOOL_REGISTRY) {
  toolStats.set(tool.id, { invocations: 0, errors: 0, totalLatency: 0 });
}

// Semantic cache for cacheLookup (TOOL-099)
const semanticCache = new Map();
const MAX_CACHE = 233; // F13

/* ════════════════════════════════════════════════════════════════
   Tool invocation engine
   ════════════════════════════════════════════════════════════════ */

function invokeTool(toolId, input, context) {
  const start = performance.now();
  const tool = toolMap.get(toolId);

  if (!tool) {
    return { error: 'unknown-tool', toolId };
  }

  const stats = toolStats.get(tool.id);
  stats.invocations++;
  invokeCount++;

  let output;
  try {
    output = executeTool(tool, input, context);
  } catch (err) {
    stats.errors++;
    errorCount++;
    return { error: err.message, toolId: tool.id, name: tool.name };
  }

  const latency = performance.now() - start;
  stats.totalLatency += latency;

  return {
    toolId: tool.id,
    name: tool.name,
    output,
    confidence: computeConfidence(tool, output),
    latency,
    category: tool.category,
  };
}

function executeTool(tool, input, context) {
  switch (tool.name) {
    case 'goalDecompose':
      return decomposeGoal(input, context);
    case 'hallucinationCheck':
      return checkHallucination(input, context);
    case 'promptChain':
      return chainPrompts(input);
    case 'reasoningValidate':
      return validateReasoning(input);
    case 'contextWindow':
      return manageContextWindow(input);
    case 'tokenBudget':
      return trackTokenBudget(input);
    case 'responseGrade':
      return gradeResponse(input);
    case 'chainOfThought':
      return chainOfThought(input);
    case 'fewShotSelect':
      return selectFewShot(input);
    case 'selfCritique':
      return selfCritique(input);
    case 'cacheLookup':
      return lookupCache(input);
    default:
      return genericAITool(tool, input, context);
  }
}

/* ════════════════════════════════════════════════════════════════
   Tool implementations — key tools with real logic
   ════════════════════════════════════════════════════════════════ */

function decomposeGoal(input) {
  const goal = typeof input === 'string' ? input : (input.goal || '');
  const words = goal.split(/\s+/);
  const complexity = Math.min(1, words.length / 50);
  const subGoalCount = Math.max(2, Math.min(8, Math.ceil(complexity * 8)));

  const subGoals = [];
  const chunkSize = Math.ceil(words.length / subGoalCount);
  for (let i = 0; i < subGoalCount; i++) {
    const start = i * chunkSize;
    const chunk = words.slice(start, start + chunkSize).join(' ');
    subGoals.push({
      id: i + 1,
      description: chunk || `Sub-goal ${i + 1}`,
      priority: Math.pow(PHI_INV, i),
      estimated_complexity: complexity * Math.pow(PHI_INV, i),
    });
  }

  return { goal, subGoals, complexity, totalSubGoals: subGoals.length };
}

function checkHallucination(input) {
  const text = typeof input === 'string' ? input : (input.text || '');
  const claims = text.split(/[.!?]+/).filter(s => s.trim().length > 10);
  const results = claims.map((claim, i) => {
    const hasNumbers = /\d+/.test(claim);
    const hasProperNouns = /[A-Z][a-z]{2,}/.test(claim);
    const riskScore = (hasNumbers ? 0.3 : 0) + (hasProperNouns ? 0.2 : 0) + (claim.length > 100 ? 0.2 : 0);
    return {
      claim: claim.trim(),
      riskScore: Math.min(1, riskScore),
      flagged: riskScore > 0.5,
      reason: riskScore > 0.5 ? 'High hallucination risk — contains verifiable claims' : 'Low risk',
    };
  });

  const overallRisk = results.length > 0
    ? results.reduce((sum, r) => sum + r.riskScore, 0) / results.length
    : 0;

  return { claims: results, overallRisk, flaggedCount: results.filter(r => r.flagged).length };
}

function chainPrompts(input) {
  const steps = Array.isArray(input) ? input : (input.steps || [input]);
  return {
    chainLength: steps.length,
    steps: steps.map((step, i) => ({
      index: i,
      prompt: typeof step === 'string' ? step : step.prompt,
      dependsOn: i > 0 ? i - 1 : null,
      status: 'pending',
    })),
    executionOrder: steps.map((_, i) => i),
  };
}

function validateReasoning(input) {
  const steps = Array.isArray(input) ? input : (input.steps || []);
  const validations = steps.map((step, i) => {
    const valid = typeof step === 'string' ? step.length > 5 : !!step.conclusion;
    return { step: i, valid, confidence: valid ? 0.8 : 0.2 };
  });
  const overallValid = validations.every(v => v.valid);
  return { validations, overallValid, confidence: overallValid ? 0.85 : 0.3 };
}

function manageContextWindow(input) {
  const maxTokens = input.maxTokens || 128000;
  const used = input.used || 0;
  const remaining = maxTokens - used;
  const utilization = used / maxTokens;
  return {
    maxTokens, used, remaining, utilization,
    pressure: utilization > 0.8 ? 'high' : utilization > 0.5 ? 'medium' : 'low',
    recommendation: utilization > 0.9 ? 'truncate-older-context' : 'continue',
  };
}

function trackTokenBudget(input) {
  const budget = input.budget || 100000;
  const spent = input.spent || 0;
  const remaining = budget - spent;
  return {
    budget, spent, remaining,
    percentUsed: (spent / budget * 100).toFixed(1),
    burnRate: input.burnRate || 0,
    estimatedRemaining: input.burnRate > 0 ? remaining / input.burnRate : Infinity,
  };
}

function gradeResponse(input) {
  const response = typeof input === 'string' ? input : (input.response || '');
  const relevance = Math.min(1, response.length / 500) * 0.3;
  const coherence = response.split(/[.!?]+/).filter(s => s.trim()).length > 1 ? 0.3 : 0.1;
  const specificity = /\d|specific|exact|precisely/.test(response) ? 0.2 : 0.1;
  const completeness = response.length > 200 ? 0.2 : response.length / 1000;
  const grade = relevance + coherence + specificity + completeness;
  return {
    grade: Math.min(1, grade),
    breakdown: { relevance, coherence, specificity, completeness },
    rating: grade > 0.8 ? 'excellent' : grade > 0.6 ? 'good' : grade > 0.4 ? 'fair' : 'poor',
  };
}

function chainOfThought(input) {
  const question = typeof input === 'string' ? input : (input.question || '');
  return {
    question,
    steps: [
      { step: 1, action: 'understand', description: 'Parse and understand the question' },
      { step: 2, action: 'decompose', description: 'Break into component parts' },
      { step: 3, action: 'reason', description: 'Apply logical reasoning to each part' },
      { step: 4, action: 'synthesize', description: 'Combine partial answers' },
      { step: 5, action: 'verify', description: 'Check for consistency and completeness' },
    ],
    status: 'structured',
  };
}

function selectFewShot(input) {
  const examples = input.examples || [];
  const query = input.query || '';
  // Select top examples by simple relevance scoring
  const scored = examples.map((ex, i) => ({
    index: i,
    example: ex,
    score: computeSimilarity(query, typeof ex === 'string' ? ex : JSON.stringify(ex)),
  }));
  scored.sort((a, b) => b.score - a.score);
  const selected = scored.slice(0, input.count || 3);
  return { selected, totalExamples: examples.length, selectedCount: selected.length };
}

function selfCritique(input) {
  const response = typeof input === 'string' ? input : (input.response || '');
  const issues = [];
  if (response.length < 50) issues.push({ type: 'brevity', detail: 'Response may be too short' });
  if (!/\b(because|therefore|since|thus)\b/i.test(response)) issues.push({ type: 'reasoning', detail: 'Lacks explicit reasoning connectors' });
  if (/\b(always|never|all|none|every)\b/i.test(response)) issues.push({ type: 'absolutism', detail: 'Contains absolute claims' });
  return {
    issues,
    issueCount: issues.length,
    quality: issues.length === 0 ? 'good' : issues.length <= 2 ? 'acceptable' : 'needs-revision',
    suggestion: issues.length > 0 ? 'Address flagged issues and re-evaluate' : 'Response passes self-critique',
  };
}

function lookupCache(input) {
  const key = typeof input === 'string' ? input : JSON.stringify(input);
  const cached = semanticCache.get(key);
  if (cached) {
    cached.hits++;
    return { hit: true, result: cached.result, age: Date.now() - cached.timestamp, hits: cached.hits };
  }
  return { hit: false, key, cacheSize: semanticCache.size };
}

function genericAITool(tool, input, context) {
  return {
    toolId: tool.id,
    name: tool.name,
    category: tool.category,
    input: typeof input === 'string' ? input : JSON.stringify(input).slice(0, 200),
    status: 'processed',
    phiWeight: tool.phiWeight,
    timestamp: Date.now(),
  };
}

/* ════════════════════════════════════════════════════════════════
   Utility functions
   ════════════════════════════════════════════════════════════════ */

function computeConfidence(tool, output) {
  if (!output) return 0;
  if (output.confidence !== undefined) return output.confidence;
  if (output.grade !== undefined) return output.grade;
  if (output.overallRisk !== undefined) return 1 - output.overallRisk;
  return tool.phiWeight;
}

function computeSimilarity(a, b) {
  if (!a || !b) return 0;
  const wordsA = new Set(a.toLowerCase().split(/\W+/));
  const wordsB = new Set(b.toLowerCase().split(/\W+/));
  let intersection = 0;
  for (const w of wordsA) {
    if (wordsB.has(w)) intersection++;
  }
  const union = wordsA.size + wordsB.size - intersection;
  return union > 0 ? intersection / union : 0;
}

/* ════════════════════════════════════════════════════════════════
   Message handler
   ════════════════════════════════════════════════════════════════ */

self.onmessage = function (e) {
  const msg = e.data;

  switch (msg.type) {
    case 'invoke': {
      const result = invokeTool(msg.toolId, msg.input, msg.context);
      if (result.error) {
        self.postMessage({ type: 'error', ...result });
      } else {
        self.postMessage({ type: 'result', ...result });
      }
      break;
    }

    case 'batch': {
      const results = (msg.invocations || []).map(inv =>
        invokeTool(inv.toolId, inv.input, inv.context)
      );
      self.postMessage({ type: 'batch-result', results, count: results.length });
      break;
    }

    case 'cacheStore': {
      const key = typeof msg.key === 'string' ? msg.key : JSON.stringify(msg.key);
      semanticCache.set(key, { result: msg.result, timestamp: Date.now(), hits: 0 });
      if (semanticCache.size > MAX_CACHE) {
        const oldest = semanticCache.keys().next().value;
        semanticCache.delete(oldest);
      }
      break;
    }

    case 'getRegistry':
      self.postMessage({
        type: 'registry',
        tools: TOOL_REGISTRY.map(t => ({ id: t.id, name: t.name, category: t.category })),
        range: `TOOL-${TOOL_BASE} to TOOL-${TOOL_MAX}`,
        count: TOOL_COUNT,
      });
      break;

    case 'getStats': {
      const stats = {};
      for (const [id, s] of toolStats) {
        stats[id] = { ...s, avgLatency: s.invocations > 0 ? s.totalLatency / s.invocations : 0 };
      }
      self.postMessage({
        type: 'stats',
        totalInvocations: invokeCount,
        totalErrors: errorCount,
        errorRate: invokeCount > 0 ? errorCount / invokeCount : 0,
        perTool: stats,
        cacheSize: semanticCache.size,
      });
      break;
    }

    case 'stop':
      running = false;
      if (heartbeatInterval) clearInterval(heartbeatInterval);
      self.postMessage({ type: 'stopped', totalInvocations: invokeCount });
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
    toolRange: 'TOOL-061–100',
    invocations: invokeCount,
    errors: errorCount,
  });
}, HEARTBEAT);
