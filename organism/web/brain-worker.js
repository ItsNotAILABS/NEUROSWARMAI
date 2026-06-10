/**
 * Brain Worker — 7-Region Hebbian Cognitive Engine
 *
 * Web Worker that runs the organism's 7-region brain architecture at 60 Hz.
 * Each region has activation dynamics, decay, and inter-region Hebbian
 * weight updates. This is the fast mortal brain — it runs in the browser,
 * learns in real-time, and syncs learned weights back to the immortal backend.
 *
 * Architecture (from organism constants):
 *   Region 0: PFC        — Governance, doctrine, decision gating
 *   Region 1: AMYGDALA   — Threat detection, fear response
 *   Region 2: HIPPOCAMPUS — Memory encoding, pattern consolidation
 *   Region 3: CEREBELLUM — Timing, rhythm, motor reflex
 *   Region 4: BRAINSTEM  — Heartbeat floor, arousal baseline
 *   Region 5: THALAMUS   — Sensor fusion, input routing
 *   Region 6: BASAL_GANGLIA — Drive competition, action selection
 *
 * 21 bidirectional connection pairs = 42 Hebbian weights
 * Weight update: Δw = η × pre × post (Hebbian rule)
 * Decay: w(t+1) = w(t) × (1 - decay_rate)
 *
 * Protocol: postMessage
 *   Main → Worker: { type: 'init', weights?: Float32Array }
 *   Main → Worker: { type: 'stimulate', region, intensity }
 *   Main → Worker: { type: 'tick' }
 *   Main → Worker: { type: 'getState' }
 *   Main → Worker: { type: 'getWeights' }
 *   Worker → Main: { type: 'state', regions, coherence, emergence }
 *   Worker → Main: { type: 'weights', weights: Float32Array }
 *   Worker → Main: { type: 'spike', region, activation }
 *   Worker → Main: { type: 'heartbeat', beat, status }
 */

const PHI = 1.618033988749895;
const HEARTBEAT = 873;
const BRAIN_TICK_MS = 16.67; // ~60 Hz
const REGION_COUNT = 7;
const WEIGHT_COUNT = 42; // 21 pairs × 2 directions
const LEARNING_RATE = 0.01;
const DECAY_RATE = 0.001;
const SPIKE_THRESHOLD = 0.85;

let beatCount = 0;
let running = true;
let tickCount = 0;

/* ════════════════════════════════════════════════════════════════
   Brain region state
   ════════════════════════════════════════════════════════════════ */

const regions = [
  { id: 0, name: 'PFC',           activation: 0.5, decay: 0.95,  base: 0.5,  output: 0.0 },
  { id: 1, name: 'AMYGDALA',      activation: 0.3, decay: 0.90,  base: 0.3,  output: 0.0 },
  { id: 2, name: 'HIPPOCAMPUS',   activation: 0.4, decay: 0.98,  base: 0.4,  output: 0.0 },
  { id: 3, name: 'CEREBELLUM',    activation: 0.6, decay: 0.92,  base: 0.6,  output: 0.0 },
  { id: 4, name: 'BRAINSTEM',     activation: 0.7, decay: 0.99,  base: 0.7,  output: 0.0 },
  { id: 5, name: 'THALAMUS',      activation: 0.5, decay: 0.94,  base: 0.5,  output: 0.0 },
  { id: 6, name: 'BASAL_GANGLIA', activation: 0.4, decay: 0.93,  base: 0.4,  output: 0.0 },
];

/* ════════════════════════════════════════════════════════════════
   Connection topology — 21 bidirectional pairs
   [from, to, baseWeight]
   ════════════════════════════════════════════════════════════════ */

const CONNECTIONS = [
  // PFC connections (6 pairs)
  [0, 1, 0.3], [1, 0, 0.4],  // PFC ↔ AMY
  [0, 2, 0.5], [2, 0, 0.4],  // PFC ↔ HPC
  [0, 3, 0.2], [3, 0, 0.2],  // PFC ↔ CER
  [0, 4, 0.1], [4, 0, 0.3],  // PFC ↔ BST
  [0, 5, 0.4], [5, 0, 0.5],  // PFC ↔ THL
  [0, 6, 0.6], [6, 0, 0.4],  // PFC ↔ BGL
  // AMYGDALA connections (5 pairs)
  [1, 2, 0.7], [2, 1, 0.5],  // AMY ↔ HPC
  [1, 3, 0.3], [3, 1, 0.2],  // AMY ↔ CER
  [1, 4, 0.8], [4, 1, 0.6],  // AMY ↔ BST
  [1, 5, 0.5], [5, 1, 0.6],  // AMY ↔ THL
  [1, 6, 0.4], [6, 1, 0.3],  // AMY ↔ BGL
  // HIPPOCAMPUS connections (4 pairs)
  [2, 3, 0.2], [3, 2, 0.3],  // HPC ↔ CER
  [2, 4, 0.1], [4, 2, 0.2],  // HPC ↔ BST
  [2, 5, 0.4], [5, 2, 0.5],  // HPC ↔ THL
  [2, 6, 0.3], [6, 2, 0.3],  // HPC ↔ BGL
  // CEREBELLUM connections (3 pairs)
  [3, 4, 0.4], [4, 3, 0.3],  // CER ↔ BST
  [3, 5, 0.3], [5, 3, 0.4],  // CER ↔ THL
  [3, 6, 0.5], [6, 3, 0.4],  // CER ↔ BGL
  // BRAINSTEM connections (2 pairs)
  [4, 5, 0.3], [5, 4, 0.4],  // BST ↔ THL
  [4, 6, 0.2], [6, 4, 0.3],  // BST ↔ BGL
  // THALAMUS connections (1 pair)
  [5, 6, 0.5], [6, 5, 0.4],  // THL ↔ BGL
];

// Hebbian weight matrix — mutable, learned over session
const weights = new Float32Array(WEIGHT_COUNT);

function initWeights(initial) {
  if (initial && initial.length === WEIGHT_COUNT) {
    weights.set(initial);
  } else {
    for (let i = 0; i < WEIGHT_COUNT; i++) {
      weights[i] = CONNECTIONS[i][2];
    }
  }
}

initWeights();

/* ════════════════════════════════════════════════════════════════
   Brain tick — propagate activations, update weights
   ════════════════════════════════════════════════════════════════ */

function tick() {
  tickCount++;

  // Compute weighted input for each region
  const inputs = new Float32Array(REGION_COUNT);

  for (let c = 0; c < WEIGHT_COUNT; c++) {
    const from = CONNECTIONS[c][0];
    const to = CONNECTIONS[c][1];
    inputs[to] += regions[from].activation * weights[c];
  }

  // Update activations with decay
  for (let r = 0; r < REGION_COUNT; r++) {
    const region = regions[r];
    const prevActivation = region.activation;

    // Activation = decay × previous + input (normalized)
    region.activation = region.decay * prevActivation + inputs[r] * 0.1;

    // Clamp to [0, 1]
    region.activation = Math.max(0, Math.min(1, region.activation));

    // Mean reversion toward base
    region.activation += (region.base - region.activation) * 0.002;

    // Output = tanh(activation) for smooth signaling
    region.output = Math.tanh(region.activation * 2 - 1);

    // Spike detection
    if (region.activation >= SPIKE_THRESHOLD) {
      self.postMessage({ type: 'spike', region: r, name: region.name, activation: region.activation, tick: tickCount });
    }
  }

  // Hebbian weight update: Δw = η × pre × post
  for (let c = 0; c < WEIGHT_COUNT; c++) {
    const from = CONNECTIONS[c][0];
    const to = CONNECTIONS[c][1];
    const pre = regions[from].activation;
    const post = regions[to].activation;

    // Hebbian update
    weights[c] += LEARNING_RATE * pre * post;

    // Decay toward zero
    weights[c] *= (1 - DECAY_RATE);

    // Clamp weights
    weights[c] = Math.max(-1, Math.min(1, weights[c]));
  }

  return computeState();
}

function computeState() {
  // Coherence = mean pairwise correlation of activations
  let sum = 0;
  for (let r = 0; r < REGION_COUNT; r++) sum += regions[r].activation;
  const mean = sum / REGION_COUNT;

  let variance = 0;
  for (let r = 0; r < REGION_COUNT; r++) {
    const diff = regions[r].activation - mean;
    variance += diff * diff;
  }
  const coherence = 1 - Math.sqrt(variance / REGION_COUNT);

  // Drift = instability measure
  const drift = Math.abs(coherence - 0.5) * 0.4 + (1 - coherence) * 0.25;

  // Emergence = coherence × (1 - drift)
  const emergence = coherence * (1 - drift);

  return {
    regions: regions.map(r => ({ id: r.id, name: r.name, activation: r.activation, output: r.output })),
    coherence,
    drift,
    emergence,
    tick: tickCount,
  };
}

/* ════════════════════════════════════════════════════════════════
   Message handler
   ════════════════════════════════════════════════════════════════ */

self.onmessage = function (e) {
  const msg = e.data;

  switch (msg.type) {
    case 'init':
      initWeights(msg.weights);
      self.postMessage({ type: 'initialized', regionCount: REGION_COUNT, weightCount: WEIGHT_COUNT });
      break;

    case 'stimulate': {
      const r = typeof msg.region === 'number' ? Math.floor(msg.region) : -1;
      if (r >= 0 && r < REGION_COUNT) {
        regions[r].activation = Math.min(1, regions[r].activation + (msg.intensity || 0.3));
      }
      break;
    }

    case 'tick': {
      const state = tick();
      self.postMessage({ type: 'state', ...state });
      break;
    }

    case 'getState':
      self.postMessage({ type: 'state', ...computeState() });
      break;

    case 'getWeights':
      self.postMessage({ type: 'weights', weights: new Float32Array(weights) });
      break;

    case 'setWeights':
      if (msg.weights) initWeights(msg.weights);
      break;

    case 'stop':
      running = false;
      if (heartbeatInterval) clearInterval(heartbeatInterval);
      if (tickInterval) clearInterval(tickInterval);
      self.postMessage({ type: 'stopped', finalWeights: new Float32Array(weights) });
      break;
  }
};

/* ════════════════════════════════════════════════════════════════
   Auto-tick at 60 Hz
   ════════════════════════════════════════════════════════════════ */

const tickInterval = setInterval(function () {
  if (!running) return;
  tick();
}, BRAIN_TICK_MS);

/* ════════════════════════════════════════════════════════════════
   Heartbeat — runs permanently at 873ms
   ════════════════════════════════════════════════════════════════ */

const heartbeatInterval = setInterval(function () {
  if (!running) return;
  beatCount++;
  const state = computeState();
  self.postMessage({
    type: 'heartbeat',
    beat: beatCount,
    phi: PHI,
    heartbeatMs: HEARTBEAT,
    timestamp: Date.now(),
    status: 'alive',
    coherence: state.coherence,
    emergence: state.emergence,
    tick: tickCount,
  });
}, HEARTBEAT);
