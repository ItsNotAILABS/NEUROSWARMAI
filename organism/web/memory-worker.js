/**
 * Memory Worker — 144-Node Golden Spiral Resonance Memory
 *
 * Web Worker implementing the organism's resonance memory engine.
 * 144 nodes arranged in a golden spiral at 137.5° angular separation.
 * Memory is NOT storage — it IS resonance. Patterns encode through
 * activation and decode through resonance matching.
 *
 * Architecture:
 *   144 nodes (Fibonacci F12) in golden spiral
 *   Angular separation: 137.5077640500378° (golden angle)
 *   Signal flow: Input → Pattern encode → Resonance match → Recall
 *   Coupling residue: φ⁻² × 0.1 = 0.0382 per connection
 *   Containment: pathways below φ⁻⁶ (0.0557) dissolve
 *   Max active patterns: 89 (Fibonacci F11)
 *
 * Protocol: postMessage
 *   Main → Worker: { type: 'encode', pattern, strength }
 *   Main → Worker: { type: 'recall', query }
 *   Main → Worker: { type: 'tick' }
 *   Main → Worker: { type: 'getState' }
 *   Worker → Main: { type: 'encoded', id, nodes }
 *   Worker → Main: { type: 'recalled', matches, resonanceStrength }
 *   Worker → Main: { type: 'decay', dissolved, remaining }
 *   Worker → Main: { type: 'heartbeat', beat, status }
 */

const PHI = 1.618033988749895;
const PHI_INV = 1 / PHI;                     // 0.618033988749895
const PHI_NEG2 = PHI_INV * PHI_INV;          // 0.381966...
const PHI_NEG6 = Math.pow(PHI_INV, 6);       // 0.055728...
const GOLDEN_ANGLE_DEG = 137.5077640500378;
const GOLDEN_ANGLE_RAD = GOLDEN_ANGLE_DEG * Math.PI / 180;
const HEARTBEAT = 873;
const NODE_COUNT = 144;                        // F12
const MAX_PATTERNS = 89;                       // F11
const COUPLING_RESIDUE_RATE = PHI_NEG2 * 0.1; // 0.0382
const CONTAINMENT_THRESHOLD = PHI_NEG6;       // 0.055728 — below this, pathways dissolve

let beatCount = 0;
let running = true;
let tickCount = 0;
let patternIdCounter = 0;

/* ════════════════════════════════════════════════════════════════
   Node initialization — golden spiral placement
   ════════════════════════════════════════════════════════════════ */

const nodes = [];
for (let i = 0; i < NODE_COUNT; i++) {
  const angle = i * GOLDEN_ANGLE_RAD;
  const radius = Math.sqrt(i + 1) * 10;
  nodes.push({
    id: i,
    angle,
    radius,
    x: Math.cos(angle) * radius,
    y: Math.sin(angle) * radius,
    activation: 0,
    couplingResidue: 0,
    lastActive: 0,
  });
}

/* ════════════════════════════════════════════════════════════════
   Pattern storage — encoded memories as node activation patterns
   ════════════════════════════════════════════════════════════════ */

const patterns = [];

function fnv1a(input) {
  let hash = 2166136261;
  for (let i = 0; i < input.length; i++) {
    hash ^= input.charCodeAt(i);
    hash = (hash * 16777619) >>> 0;
  }
  return hash;
}

function patternToNodes(pattern) {
  // Map pattern string to a set of node activations using hash distribution
  const hash = fnv1a(pattern);
  const nodeActivations = new Float32Array(NODE_COUNT);
  const activeCount = 8 + (hash % 13); // 8-20 nodes per pattern (Fibonacci-adjacent)

  for (let i = 0; i < activeCount; i++) {
    const nodeIdx = ((hash * (i + 1) * 2654435761) >>> 0) % NODE_COUNT;
    const strength = 0.5 + ((((hash >> i) & 0xFF) / 255) * 0.5);
    nodeActivations[nodeIdx] = Math.max(nodeActivations[nodeIdx], strength);
  }

  return nodeActivations;
}

function encodePattern(pattern, strength) {
  if (patterns.length >= MAX_PATTERNS) {
    // Dissolve weakest pattern to make room
    let weakest = 0;
    let weakestStrength = Infinity;
    for (let i = 0; i < patterns.length; i++) {
      if (patterns[i].strength < weakestStrength) {
        weakestStrength = patterns[i].strength;
        weakest = i;
      }
    }
    patterns.splice(weakest, 1);
  }

  const id = ++patternIdCounter;
  const nodeActivations = patternToNodes(pattern);

  // Apply activations to nodes with coupling residue
  for (let i = 0; i < NODE_COUNT; i++) {
    if (nodeActivations[i] > 0) {
      nodes[i].activation = Math.max(nodes[i].activation, nodeActivations[i] * (strength || 1));
      nodes[i].couplingResidue += COUPLING_RESIDUE_RATE;
      nodes[i].lastActive = tickCount;
    }
  }

  const patternRecord = {
    id,
    pattern,
    strength: strength || 1,
    nodeActivations,
    encodedAt: tickCount,
    lastRecalled: tickCount,
    recallCount: 0,
  };

  patterns.push(patternRecord);
  return patternRecord;
}

function recallPattern(query) {
  const queryNodes = patternToNodes(query);
  const matches = [];

  for (const stored of patterns) {
    // Compute resonance = dot product of query and stored pattern
    let dotProduct = 0;
    let queryNorm = 0;
    let storedNorm = 0;

    for (let i = 0; i < NODE_COUNT; i++) {
      dotProduct += queryNodes[i] * stored.nodeActivations[i];
      queryNorm += queryNodes[i] * queryNodes[i];
      storedNorm += stored.nodeActivations[i] * stored.nodeActivations[i];
    }

    const norm = Math.sqrt(queryNorm) * Math.sqrt(storedNorm);
    const resonance = norm > 0 ? dotProduct / norm : 0;

    if (resonance > 0.1) {
      stored.lastRecalled = tickCount;
      stored.recallCount++;
      // Strengthen on recall (reconsolidation)
      stored.strength = Math.min(2.0, stored.strength + 0.05);
      matches.push({ id: stored.id, pattern: stored.pattern, resonance, strength: stored.strength });
    }
  }

  // Sort by resonance descending
  matches.sort((a, b) => b.resonance - a.resonance);
  return matches;
}

/* ════════════════════════════════════════════════════════════════
   Decay and containment — the dissolution layer
   ════════════════════════════════════════════════════════════════ */

function processDecay() {
  let dissolved = 0;

  // Decay node activations
  for (let i = 0; i < NODE_COUNT; i++) {
    nodes[i].activation *= 0.995;
    nodes[i].couplingResidue *= 0.998;

    // Containment: dissolve pathways below threshold
    if (nodes[i].couplingResidue > 0 && nodes[i].couplingResidue < CONTAINMENT_THRESHOLD) {
      nodes[i].couplingResidue = 0;
      nodes[i].activation *= 0.5; // Rapid decay when decoupled
    }
  }

  // Decay pattern strengths
  for (let i = patterns.length - 1; i >= 0; i--) {
    patterns[i].strength *= 0.999;

    // Dissolve patterns below containment threshold
    if (patterns[i].strength < CONTAINMENT_THRESHOLD) {
      patterns.splice(i, 1);
      dissolved++;
    }
  }

  return { dissolved, remaining: patterns.length };
}

/* ════════════════════════════════════════════════════════════════
   Tick — advance memory state
   ════════════════════════════════════════════════════════════════ */

function tick() {
  tickCount++;
  const decay = processDecay();

  if (decay.dissolved > 0) {
    self.postMessage({ type: 'decay', ...decay, tick: tickCount });
  }

  return getState();
}

function getState() {
  let totalActivation = 0;
  let totalResidue = 0;
  let activeNodes = 0;

  for (let i = 0; i < NODE_COUNT; i++) {
    totalActivation += nodes[i].activation;
    totalResidue += nodes[i].couplingResidue;
    if (nodes[i].activation > 0.1) activeNodes++;
  }

  return {
    nodeCount: NODE_COUNT,
    activeNodes,
    patternCount: patterns.length,
    maxPatterns: MAX_PATTERNS,
    meanActivation: totalActivation / NODE_COUNT,
    totalResidue,
    tick: tickCount,
  };
}

/* ════════════════════════════════════════════════════════════════
   Message handler
   ════════════════════════════════════════════════════════════════ */

self.onmessage = function (e) {
  const msg = e.data;

  switch (msg.type) {
    case 'encode': {
      const record = encodePattern(msg.pattern, msg.strength);
      const activeNodes = [];
      for (let i = 0; i < NODE_COUNT; i++) {
        if (record.nodeActivations[i] > 0) {
          activeNodes.push({ node: i, activation: record.nodeActivations[i] });
        }
      }
      self.postMessage({ type: 'encoded', id: record.id, pattern: msg.pattern, nodes: activeNodes });
      break;
    }

    case 'recall': {
      const matches = recallPattern(msg.query);
      self.postMessage({ type: 'recalled', query: msg.query, matches, resonanceStrength: matches.length > 0 ? matches[0].resonance : 0 });
      break;
    }

    case 'tick': {
      const state = tick();
      self.postMessage({ type: 'state', ...state });
      break;
    }

    case 'getState':
      self.postMessage({ type: 'state', ...getState() });
      break;

    case 'getPatterns':
      self.postMessage({
        type: 'patterns',
        patterns: patterns.map(p => ({
          id: p.id,
          pattern: p.pattern,
          strength: p.strength,
          encodedAt: p.encodedAt,
          recallCount: p.recallCount,
        })),
      });
      break;

    case 'stop':
      running = false;
      if (heartbeatInterval) clearInterval(heartbeatInterval);
      if (tickInterval) clearInterval(tickInterval);
      self.postMessage({
        type: 'stopped',
        patterns: patterns.map(p => ({ id: p.id, pattern: p.pattern, strength: p.strength })),
      });
      break;
  }
};

/* ════════════════════════════════════════════════════════════════
   Auto-tick — memory decay runs every 100ms
   ════════════════════════════════════════════════════════════════ */

const tickInterval = setInterval(function () {
  if (!running) return;
  tick();
}, 100);

/* ════════════════════════════════════════════════════════════════
   Heartbeat — runs permanently at 873ms
   ════════════════════════════════════════════════════════════════ */

const heartbeatInterval = setInterval(function () {
  if (!running) return;
  beatCount++;
  const state = getState();
  self.postMessage({
    type: 'heartbeat',
    beat: beatCount,
    phi: PHI,
    heartbeatMs: HEARTBEAT,
    timestamp: Date.now(),
    status: 'alive',
    ...state,
  });
}, HEARTBEAT);
