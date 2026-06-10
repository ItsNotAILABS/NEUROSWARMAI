/**
 * NOVA WEB WORKER — Browser Intelligence Substrate
 * Nova by FreddyCreates
 * 
 * Web Worker implementation for browser-based execution.
 * Runs in parallel thread without blocking the main UI.
 * 
 * @version 0.13.0 (F13)
 * @copyright Nova Protocol by FreddyCreates
 */

// ─── Constants ───────────────────────────────────────────────────────────────
const PHI = 1.618033988749895;
const PHI_INV = 0.618033988749895;
const PHI_BEAT = 873;

function fib(n) {
  if (n <= 1) return n;
  let a = 0, b = 1;
  for (let i = 2; i <= n; i++) {
    [a, b] = [b, a + b];
  }
  return b;
}

// ─── Tool Registry ───────────────────────────────────────────────────────────
const TOOLS = {
  SUMM: { name: 'Summarize', category: 'text', fib: 1 },
  TRAN: { name: 'Translate', category: 'text', fib: 2 },
  SENT: { name: 'Sentiment', category: 'text', fib: 3 },
  EXTR: { name: 'Extract', category: 'text', fib: 4 },
  CLAS: { name: 'Classify Image', category: 'vision', fib: 5 },
  DETE: { name: 'Detect Objects', category: 'vision', fib: 6 },
  SEGM: { name: 'Segment Image', category: 'vision', fib: 7 },
  OCRR: { name: 'OCR', category: 'vision', fib: 8 },
  TRNS: { name: 'Transcribe', category: 'audio', fib: 9 },
  SYNT: { name: 'Synthesize', category: 'audio', fib: 10 },
  CLAU: { name: 'Classify Audio', category: 'audio', fib: 11 },
  ENHA: { name: 'Enhance Audio', category: 'audio', fib: 12 },
  GENC: { name: 'Generate Code', category: 'code', fib: 13 },
  REVC: { name: 'Review Code', category: 'code', fib: 14 },
  REFC: { name: 'Refactor Code', category: 'code', fib: 15 },
  DOCC: { name: 'Document Code', category: 'code', fib: 16 },
  ANLD: { name: 'Analyze Data', category: 'data', fib: 17 },
  TRFD: { name: 'Transform Data', category: 'data', fib: 18 },
  VISD: { name: 'Visualize Data', category: 'data', fib: 19 },
  PRED: { name: 'Predict Data', category: 'data', fib: 20 }
};

// ─── Worker State ────────────────────────────────────────────────────────────
let state = {
  heartbeatCount: 0,
  heartbeatInterval: null,
  usageHistory: [],
  totalIPGenerated: 0,
  balance: { current: 1000, earned: 0, spent: 0 },
  createdAt: Date.now()
};

// ─── Economics ───────────────────────────────────────────────────────────────
const BASE_COSTS = { text: 1, vision: 3, audio: 5, code: 2, data: 2 };
const IP_MULTIPLIERS = { text: 1.0, vision: PHI, audio: PHI, code: PHI * PHI, data: PHI };

function computeCost(category, durationMs, quality) {
  const base = BASE_COSTS[category] || 1;
  const durationFactor = Math.log(durationMs / 1000 + 1) / Math.log(PHI);
  const qualityFactor = 1 + quality * PHI_INV;
  return Math.max(1, Math.round(base * Math.pow(PHI, durationFactor) * qualityFactor));
}

function computeIPValue(category, durationMs, quality) {
  const multiplier = IP_MULTIPLIERS[category] || 1.0;
  const timeFactor = 1 / Math.log(durationMs / 1000 + 2);
  return quality * multiplier * PHI * timeFactor;
}

// ─── Tool Execution ──────────────────────────────────────────────────────────
async function execute(quad, input, options = {}) {
  const tool = TOOLS[quad];
  if (!tool) throw new Error(`Unknown tool: ${quad}`);
  
  const startTime = performance.now();
  
  // Simulated execution (would call actual implementations)
  await new Promise(resolve => setTimeout(resolve, 50 + Math.random() * 100));
  
  const durationMs = Math.round(performance.now() - startTime);
  const quality = 0.75 + Math.random() * 0.2;
  
  const cost = computeCost(tool.category, durationMs, quality);
  const ipValue = computeIPValue(tool.category, durationMs, quality);
  
  state.balance.spent += cost;
  state.balance.earned += ipValue * 0.1;
  state.totalIPGenerated += ipValue;
  
  state.usageHistory.push({
    quad,
    timestamp: Date.now(),
    durationMs,
    quality,
    ipValue,
    cost,
    success: true
  });
  
  return {
    success: true,
    quad,
    tool: tool.name,
    result: { processed: true, inputLength: typeof input === 'string' ? input.length : 0 },
    metrics: {
      durationMs,
      quality: Math.round(quality * 1000) / 1000,
      cost,
      ipGenerated: Math.round(ipValue * 10000) / 10000
    }
  };
}

// ─── Heartbeat ───────────────────────────────────────────────────────────────
function startHeartbeat() {
  if (state.heartbeatInterval) return;
  state.heartbeatInterval = setInterval(() => {
    state.heartbeatCount++;
    self.postMessage({
      type: 'heartbeat',
      beat: state.heartbeatCount,
      timestamp: Date.now()
    });
  }, PHI_BEAT);
}

function stopHeartbeat() {
  if (state.heartbeatInterval) {
    clearInterval(state.heartbeatInterval);
    state.heartbeatInterval = null;
  }
}

// ─── Status ──────────────────────────────────────────────────────────────────
function getStatus() {
  return {
    name: 'NovaWebWorker',
    version: '0.13.0',
    brand: 'Nova by FreddyCreates',
    substrate: 'web-worker',
    phi: PHI,
    phiBeat: PHI_BEAT,
    heartbeats: state.heartbeatCount,
    uptime: Date.now() - state.createdAt,
    tools: Object.keys(TOOLS).length,
    balance: {
      current: state.balance.current,
      earned: Math.round(state.balance.earned * 100) / 100,
      spent: state.balance.spent,
      net: Math.round((state.balance.current + state.balance.earned - state.balance.spent) * 100) / 100
    },
    totalIPGenerated: Math.round(state.totalIPGenerated * 10000) / 10000
  };
}

// ─── Message Handler ─────────────────────────────────────────────────────────
self.onmessage = async function(event) {
  const { type, id, payload } = event.data;
  
  try {
    let result;
    
    switch (type) {
      case 'status':
        result = getStatus();
        break;
        
      case 'tools':
        result = { tools: Object.entries(TOOLS).map(([quad, t]) => ({ quad, ...t, fibValue: fib(t.fib) })) };
        break;
        
      case 'execute':
        result = await execute(payload.quad, payload.input, payload.options);
        break;
        
      case 'startHeartbeat':
        startHeartbeat();
        result = { started: true };
        break;
        
      case 'stopHeartbeat':
        stopHeartbeat();
        result = { stopped: true };
        break;
        
      case 'balance':
        result = {
          current: state.balance.current,
          earned: Math.round(state.balance.earned * 100) / 100,
          spent: state.balance.spent,
          net: Math.round((state.balance.current + state.balance.earned - state.balance.spent) * 100) / 100
        };
        break;
        
      case 'history':
        result = { history: state.usageHistory.slice(-100) };
        break;
        
      default:
        throw new Error(`Unknown message type: ${type}`);
    }
    
    self.postMessage({ type: 'response', id, success: true, result });
    
  } catch (error) {
    self.postMessage({ type: 'response', id, success: false, error: error.message });
  }
};

// ─── Initialize ──────────────────────────────────────────────────────────────
self.postMessage({ type: 'ready', status: getStatus() });
