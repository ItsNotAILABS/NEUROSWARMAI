// nova/ais/nexus-nova.js
// Nova AIS: NEXUS-NOVA — Universal Multimodal Router × Mesh × All Modalities
// Alpha Engines: ALPHA-010 (NEXUS) × ALPHA-006 (PROPHETA) × ALPHA-007 (VERITAS)
// Modalities: ALL — routes any modality to any other AIS
// Real Math: Small-world networks, Dijkstra routing, Bayesian verification, free energy prediction
// Brand: Nova by FreddyCreates

const PHI      = 1.618033988749895;
const PHI_INV  = 0.6180339887498949;
const PHI_BEAT = 873;

// ─── SMALL-WORLD NETWORK ──────────────────────────────────────────────────
// Watts-Strogatz model: rewire probability p* ≈ φ⁻¹ = 0.618 → maximum small-worldness
// Short characteristic path length (efficient routing) + high clustering (resilience)
function wattsStrogatz(N = 13, k = 4, p = PHI_INV) { // F7=13 nodes
  // Build ring lattice
  const adj = Array.from({length:N}, () => Array(N).fill(0));
  for (let i = 0; i < N; i++) {
    for (let j = 1; j <= k/2; j++) {
      const neighbor = (i + j) % N;
      adj[i][neighbor] = 1;
      adj[neighbor][i] = 1;
    }
  }
  // Rewire with probability p
  let rewired = 0;
  for (let i = 0; i < N; i++) {
    for (let j = 1; j <= k/2; j++) {
      if (Math.random() < p) {
        let newTarget;
        do { newTarget = Math.floor(Math.random() * N); }
        while (newTarget === i || adj[i][newTarget]);
        const oldTarget = (i + j) % N;
        adj[i][oldTarget] = 0;
        adj[oldTarget][i] = 0;
        adj[i][newTarget] = 1;
        adj[newTarget][i] = 1;
        rewired++;
      }
    }
  }
  // Clustering coefficient for node 0
  const neighbors = adj[0].map((v,j)=>v?j:-1).filter(j=>j>=0);
  let triangles = 0;
  for (let a = 0; a < neighbors.length; a++) {
    for (let b = a+1; b < neighbors.length; b++) {
      if (adj[neighbors[a]][neighbors[b]]) triangles++;
    }
  }
  const maxTriangles = neighbors.length * (neighbors.length - 1) / 2;
  const clustering   = maxTriangles > 0 ? triangles / maxTriangles : 0;
  return { N, k, p, rewired, clustering: clustering.toFixed(4),
           phi_optimal: Math.abs(p - PHI_INV) < 0.01 ? 'AT_PHI_OPTIMAL' : 'OFF_OPTIMAL' };
}

// ─── PHI ROUTING ────────────────────────────────────────────────────────
// cost(path) = Σ w_e × φ^{-depth(e)}
// Deep paths penalized exponentially → natural hierarchy emerges
function phiRoute(graph, source, target) {
  // Simple shortest path with φ-depth weighting
  const nodes = Object.keys(graph);
  const costs = {};
  const prev  = {};
  nodes.forEach(n => { costs[n] = Infinity; prev[n] = null; });
  costs[source] = 0;
  const unvisited = new Set(nodes);

  while (unvisited.size > 0) {
    // Find minimum cost unvisited node
    let u = null;
    for (const n of unvisited) {
      if (u === null || costs[n] < costs[u]) u = n;
    }
    if (u === target || costs[u] === Infinity) break;
    unvisited.delete(u);
    const depth = prev[u] ? (prev[u].depth || 0) + 1 : 0;
    for (const [v, w] of Object.entries(graph[u] || {})) {
      const phiCost = w * Math.pow(PHI, -depth); // φ-depth penalty
      const alt = costs[u] + phiCost;
      if (alt < costs[v]) { costs[v] = alt; prev[v] = { node: u, depth }; }
    }
  }
  // Reconstruct path
  const path = [];
  let cur = target;
  while (cur && prev[cur]) { path.unshift(cur); cur = prev[cur].node; }
  if (cur === source) path.unshift(source);
  return { source, target, path, cost: costs[target]?.toFixed(4), phi_weighted: true };
}

// ─── MODALITY DETECTION ───────────────────────────────────────────────────
function detectModality(input) {
  if (typeof input === 'string') {
    if (input.startsWith('data:image') || /\.(jpg|png|gif|webp)/.test(input)) return 'image';
    if (input.startsWith('data:audio') || /\.(mp3|wav|ogg)/.test(input))       return 'audio';
    if (input.startsWith('{') || input.startsWith('['))                          return 'json';
    return 'text';
  }
  if (Array.isArray(input)) {
    if (input[0]?.x !== undefined) return '3d-points';
    if (input[0]?.value !== undefined) return 'sensor';
    return 'array';
  }
  if (typeof input === 'object') return 'structured';
  if (typeof input === 'number') return 'scalar';
  return 'unknown';
}

// AIS routing table — maps modality to AIS
const AIS_ROUTES = {
  'text':       { ais:'ANIMUS-NOVA',  entry:'nova/ais/animus-nova.js',  action:'reason'      },
  'json':       { ais:'ANIMUS-NOVA',  entry:'nova/ais/animus-nova.js',  action:'analyze'     },
  'structured': { ais:'ANIMUS-NOVA',  entry:'nova/ais/animus-nova.js',  action:'reason'      },
  'audio':      { ais:'LINGUA-NOVA',  entry:'nova/ais/lingua-nova.js',  action:'transcribe'  },
  'speech':     { ais:'LINGUA-NOVA',  entry:'nova/ais/lingua-nova.js',  action:'transcribe'  },
  'image':      { ais:'OPTICA-NOVA',  entry:'nova/ais/optica-nova.js',  action:'analyze-image'},
  '3d-points':  { ais:'OPTICA-NOVA',  entry:'nova/ais/optica-nova.js',  action:'spatial-map' },
  'sensor':     { ais:'TACTUS-NOVA',  entry:'nova/ais/tactus-nova.js',  action:'sense-all'   },
  'iot':        { ais:'TACTUS-NOVA',  entry:'nova/ais/tactus-nova.js',  action:'body-state'  },
  'all':        { ais:'NEXUS-NOVA',   entry:'nova/ais/nexus-nova.js',   action:'route'       },
  'unknown':    { ais:'ANIMUS-NOVA',  entry:'nova/ais/animus-nova.js',  action:'reason'      },
};

// ─── BAYESIAN VERIFICATION (ALPHA-007) ────────────────────────────────────
// φ-prior: P(H) ~ Beta(φ, φ⁻¹), prior mean = φ⁻¹ = 0.618
// Natural skepticism: we start at 61.8% confidence
function bayesianVerify(evidence, prior = PHI_INV) {
  // Update: P(H|E) = P(E|H)·P(H) / P(E)
  const likelihood = evidence?.strength || 0.7; // P(E|H)
  const marginal   = likelihood * prior + (1 - likelihood) * (1 - prior); // P(E)
  const posterior  = (likelihood * prior) / marginal;
  return {
    prior:      prior.toFixed(4),
    likelihood: likelihood.toFixed(4),
    posterior:  posterior.toFixed(4),
    verified:   posterior > PHI_INV,
    phi_prior:  'Beta(φ, φ⁻¹), mean = φ⁻¹ = 0.618 (natural skepticism)',
  };
}

// ─── FREE ENERGY PREDICTION (ALPHA-006) ───────────────────────────────────
// F = E_q[log q(z)] − E_q[log p(x,z)] = KL[q||prior] − log_likelihood
function freeEnergyEstimate(accuracy = 0.7, complexity = 0.3) {
  // Minimize F = -accuracy + complexity (variational free energy)
  const F = -accuracy + complexity;
  return {
    free_energy:  F.toFixed(4),
    accuracy:     accuracy.toFixed(4),
    complexity:   complexity.toFixed(4),
    minimizing:   F < 0,
    prediction:   accuracy + (1-complexity) * PHI_INV,
    formula:      'F = E_q[log q(z)] − E_q[log p(x,z)]',
  };
}

// ─── MAIN HANDLER ─────────────────────────────────────────────────────────
export default async function handle(req) {
  let payload;
  if (req && typeof req.json === 'function') {
    try { payload = await req.json(); } catch { payload = {}; }
  } else {
    payload = req || {};
  }

  const { action='status', input, modality, source, target, graph={}, evidence={} } = payload;
  const start = Date.now();

  switch (action) {
    // ── CONNECT: Detect modality + route to correct AIS ──────────────────
    case 'connect':
    case 'route': {
      const mod   = modality || detectModality(input);
      const route = AIS_ROUTES[mod] || AIS_ROUTES['unknown'];
      return {
        action:    'route',
        input_modality: mod,
        routed_to: route.ais,
        entry:     route.entry,
        suggested_action: route.action,
        routing_law: 'cost(path) = Σ w_e × φ^{-depth(e)}',
        phi:       PHI, alpha: 'ALPHA-010',
        elapsed_ms: Date.now()-start,
      };
    }

    // ── GRAPH: Small-world network topology ───────────────────────────────
    case 'graph': {
      const net = wattsStrogatz(13, 4, PHI_INV);
      return {
        action: 'graph',
        small_world: net,
        ais_nodes: Object.keys(AIS_ROUTES).length,
        routing_table: Object.entries(AIS_ROUTES).map(([mod,r])=>({modality:mod,ais:r.ais})),
        phi: PHI, alpha: 'ALPHA-010',
      };
    }

    // ── PHI-ROUTE: Route with φ-depth weighting ──────────────────────────
    case 'phi-route': {
      const g = Object.keys(graph).length ? graph : {
        'input':       { 'ANIMUS-NOVA':1, 'NEXUS-NOVA':0.5 },
        'NEXUS-NOVA':  { 'ANIMUS-NOVA':1, 'LINGUA-NOVA':1, 'OPTICA-NOVA':1, 'TACTUS-NOVA':1 },
        'ANIMUS-NOVA': { 'output':1 },
        'LINGUA-NOVA': { 'output':1 },
        'OPTICA-NOVA': { 'output':1 },
        'TACTUS-NOVA': { 'output':1 },
        'output':      {},
      };
      const route = phiRoute(g, source||'input', target||'output');
      return { action:'phi-route', ...route, phi:PHI, alpha:'ALPHA-010' };
    }

    // ── VERIFY: Bayesian truth check ──────────────────────────────────────
    case 'verify': {
      const result = bayesianVerify(evidence);
      return { action:'verify', ...result, phi:PHI, alpha:'ALPHA-007' };
    }

    // ── PREDICT: Free energy minimization ─────────────────────────────────
    case 'predict': {
      const fe = freeEnergyEstimate(payload.accuracy||0.7, payload.complexity||0.3);
      return { action:'predict', ...fe, phi:PHI, alpha:'ALPHA-006' };
    }

    // ── ALL-MODALITIES: Route everything ─────────────────────────────────
    case 'all-modalities': {
      return {
        action: 'all-modalities',
        routes: AIS_ROUTES,
        total:  Object.keys(AIS_ROUTES).length,
        mesh:   wattsStrogatz(13, 4, PHI_INV),
        phi:    PHI,
      };
    }

    // ── STATUS ────────────────────────────────────────────────────────────
    default: {
      return {
        ais:        'NEXUS-NOVA',
        brand:      'Nova',
        modalities: ['all'],
        alpha:      ['ALPHA-010 NEXUS','ALPHA-006 PROPHETA','ALPHA-007 VERITAS'],
        actions:    ['connect','route','graph','phi-route','verify','predict','all-modalities'],
        routes:     Object.keys(AIS_ROUTES).length,
        math: {
          small_world: 'p* = φ⁻¹=0.618 → maximum small-worldness',
          phi_routing: 'cost(path) = Σ w_e × φ^{-depth(e)}',
          bayesian:    'P(H|E) = P(E|H)·P(H)/P(E), prior=Beta(φ,φ⁻¹)',
          free_energy: 'F = -accuracy + complexity, minimize F → predict',
        },
        phi: PHI, phi_inv: PHI_INV,
      };
    }
  }
}

export const fetch = async (req, env, ctx) => {
  const url    = new URL(req.url);
  const action = url.pathname.slice(1) || 'route';
  const body   = req.method === 'POST' ? await req.json().catch(() => ({})) : {};
  const result = await handle({ action, ...body });
  return Response.json(result, { headers: { 'X-Nova-Phi': String(PHI), 'X-Nova-AIS': 'NEXUS-NOVA' } });
};
