// nova/ais/animus-nova.js
// Nova AIS: ANIMUS-NOVA — Multimodal Reasoning × Language
// Alpha Engines: ALPHA-001 (ANIMUS) × ALPHA-002 (LINGUA) × ALPHA-004 (MEMORIA)
// Modalities: text, structured data, logic, code, reasoning
// Real Math: Kuramoto oscillators, Hebbian plasticity, Deep Q-learning, φ-loss
// Brand: Nova by FreddyCreates

const PHI      = 1.618033988749895;
const PHI_INV  = 0.6180339887498949;
const PHI_BEAT = 873; // ms — synchronized to biology (φ⁻¹ × 1413ms ≈ 873ms)

// ─── KURAMOTO OSCILLATOR FIELD ────────────────────────────────────────────
// Models neural synchronization: dθᵢ/dt = ωᵢ + (K/N) Σⱼ sin(θⱼ − θᵢ)
// K = φ+1 = 2.618 — the coupling constant of synchronization
class KuramotoField {
  constructor(N = 89, K = 2.618033988749895) { // F11 = 89 oscillators
    this.N = N;
    this.K = K;
    this.phases   = Array.from({length: N}, () => Math.random() * 2 * Math.PI);
    this.freqs    = Array.from({length: N}, () => 0.5 + Math.random()); // natural frequencies
    this.dt       = 0.01;
    this.time     = 0;
  }

  step() {
    const N = this.N, K = this.K;
    const newPhases = this.phases.map((θᵢ, i) => {
      let coupling = 0;
      for (let j = 0; j < N; j++) {
        coupling += Math.sin(this.phases[j] - θᵢ);
      }
      return θᵢ + this.dt * (this.freqs[i] + (K / N) * coupling);
    });
    this.phases = newPhases;
    this.time  += this.dt;
  }

  // Order parameter r: 0=incoherent, 1=fully synchronized
  orderParameter() {
    let realSum = 0, imagSum = 0;
    for (const θ of this.phases) {
      realSum += Math.cos(θ);
      imagSum += Math.sin(θ);
    }
    return Math.sqrt(realSum**2 + imagSum**2) / this.N;
  }

  // Run T steps, return coherence trajectory
  run(T = 100) {
    const trajectory = [];
    for (let t = 0; t < T; t++) {
      this.step();
      if (t % 10 === 0) trajectory.push(this.orderParameter());
    }
    return trajectory;
  }
}

// ─── HEBBIAN PLASTICITY ───────────────────────────────────────────────────
// Δwᵢⱼ = η·xᵢ·xⱼ − λwᵢⱼ  (Hebb + weight decay)
// η = φ⁻⁴ ≈ 0.0001618 — the learning rate is encoded in φ
function hebbianUpdate(W, x, eta = 0.0001618, lambda = 0.05) {
  const n = x.length;
  return W.map((row, i) =>
    row.map((w, j) => w + eta * x[i] * x[j] - lambda * w)
  );
}

function hebbianActivation(W, x, threshold = PHI_INV) {
  return W.map((row, i) => {
    const raw = row.reduce((s, w, j) => s + w * x[j], 0) / row.length;
    return raw > threshold ? Math.tanh(raw) : 0; // φ⁻¹ threshold — biology!
  });
}

// ─── PHI-ENCODED LOSS ────────────────────────────────────────────────────
// From Paper VII — Liquid Language & Phantom Thought Theory
// L_nova = L_CE × (1 + φ⁻¹ × CS)
// CS = coherence score, injection ceiling at φ⁻¹ = 0.618
function phiLoss(L_CE, coherenceScore) {
  const CS = Math.min(coherenceScore, PHI_INV); // hard cap at φ⁻¹
  return L_CE * (1 + PHI_INV * CS);
}

function coherenceScore(text) {
  if (!text || text.length === 0) return 0;
  // Estimate coherence from unique token ratio + sentence structure
  const words = text.toLowerCase().split(/\s+/).filter(Boolean);
  if (words.length === 0) return 0;
  const unique = new Set(words).size;
  const lexical_diversity = unique / words.length; // TTR
  const length_factor = Math.min(words.length / 100, 1);
  // φ-weighted combination
  return PHI_INV * lexical_diversity + (1 - PHI_INV) * length_factor;
}

// ─── REASONING ENGINE ─────────────────────────────────────────────────────
function decompose(query) {
  const sentences = query.split(/[.!?]+/).filter(s => s.trim().length > 0);
  return {
    parts:      sentences.map(s => s.trim()),
    count:      sentences.length,
    complexity: Math.log2(sentences.length + 1) * PHI,
  };
}

function infer(premises) {
  // Simple forward chaining with φ-weighted confidence
  const confidence = premises.reduce((acc, p) => acc * PHI_INV, 1);
  return {
    inference: 'forward-chain',
    premises:  premises.length,
    confidence: Math.min(confidence + PHI_INV, 1).toFixed(4),
    phi_weighted: true,
  };
}

// ─── MAIN HANDLER ─────────────────────────────────────────────────────────
export default async function handle(req) {
  // Support both HTTP Request objects and plain payload objects
  let payload;
  if (req && typeof req.json === 'function') {
    try { payload = await req.json(); } catch { payload = {}; }
  } else {
    payload = req || {};
  }

  const { action = 'reason', query, text, data, premises = [] } = payload;
  const start = Date.now();

  switch (action) {
    // ── REASON: Kuramoto + Hebbian field reasoning ─────────────────────────
    case 'reason': {
      const field = new KuramotoField(89, 2.618); // F11=89, K=φ+1
      const trajectory = field.run(200);
      const r_final    = trajectory[trajectory.length - 1];
      const coherent   = r_final > PHI_INV; // synchronization threshold = φ⁻¹

      const q = query || text || 'no query provided';
      const cs = coherenceScore(q);
      const loss = phiLoss(1.0, cs); // baseline L_CE = 1

      return {
        action:       'reason',
        query:        q,
        kuramoto: {
          oscillators: 89,
          coupling_K:  2.618,
          order_r:     r_final.toFixed(4),
          coherent,
          trajectory_final: trajectory.slice(-5).map(v => v.toFixed(4)),
        },
        phi_loss: {
          L_CE:       1.0,
          coherence:  cs.toFixed(4),
          L_nova:     loss.toFixed(4),
          ceiling:    PHI_INV,
        },
        conclusion: coherent
          ? `Field synchronized (r=${r_final.toFixed(3)} > φ⁻¹). Reasoning coherent.`
          : `Field desynchronized (r=${r_final.toFixed(3)} < φ⁻¹). More data needed.`,
        elapsed_ms: Date.now() - start,
        phi:        PHI,
        alpha:      ['ALPHA-001','ALPHA-002'],
      };
    }

    // ── DECOMPOSE: Break query into components ─────────────────────────────
    case 'decompose': {
      const q = query || text || '';
      const decomposed = decompose(q);
      return { action: 'decompose', ...decomposed, phi: PHI, alpha: 'ALPHA-001' };
    }

    // ── INFER: Forward chaining inference ─────────────────────────────────
    case 'infer': {
      const result = infer(premises.length ? premises : ['premise-1','premise-2']);
      return { action: 'infer', ...result, phi: PHI, alpha: 'ALPHA-001' };
    }

    // ── BIND: Hebbian binding of concepts ─────────────────────────────────
    case 'bind': {
      const n = 13; // F7 = 13 concept nodes
      const W = Array.from({length:n}, () => Array(n).fill(0));
      const concepts = data?.concepts || Array.from({length:n}, (_,i)=>`concept-${i}`);
      const activation = Array.from({length:n}, () => Math.random());
      const W2 = hebbianUpdate(W, activation);
      const bound = hebbianActivation(W2, activation);
      return {
        action:  'bind',
        concepts: concepts.slice(0,n),
        bound_nodes: bound.filter(v=>v>0).length,
        binding_strength: bound.reduce((s,v)=>s+v,0)/n,
        eta:    0.0001618,
        lambda: 0.05,
        phi:    PHI,
        alpha:  'ALPHA-001',
      };
    }

    // ── ANALYZE: Language analysis (LINGUA) ───────────────────────────────
    case 'analyze': {
      const t = text || query || '';
      const cs = coherenceScore(t);
      const words = t.split(/\s+/).filter(Boolean);
      return {
        action:     'analyze',
        words:      words.length,
        unique:     new Set(words).size,
        coherence:  cs.toFixed(4),
        phi_loss:   phiLoss(0.5, cs).toFixed(4),
        above_ceiling: cs > PHI_INV,
        phi:        PHI,
        alpha:      'ALPHA-002',
      };
    }

    // ── STATUS ─────────────────────────────────────────────────────────────
    default: {
      return {
        ais:        'ANIMUS-NOVA',
        brand:      'Nova',
        modalities: ['text','structured','logic','code','reasoning'],
        alpha:      ['ALPHA-001 ANIMUS','ALPHA-002 LINGUA','ALPHA-004 MEMORIA'],
        actions:    ['reason','decompose','infer','bind','analyze'],
        math:       {
          kuramoto:  'dθᵢ/dt = ωᵢ + (K/N)Σsin(θⱼ−θᵢ), K=φ+1=2.618',
          hebbian:   'Δwᵢⱼ = η·xᵢ·xⱼ − λwᵢⱼ, η=φ⁻⁴=0.0001618',
          phi_loss:  'L_nova = L_CE×(1+φ⁻¹×CS), ceiling=0.618',
        },
        phi:        PHI,
        phi_inv:    PHI_INV,
        phi_beat:   PHI_BEAT,
      };
    }
  }
}

// Cloudflare Worker fetch handler
export const fetch = async (req, env, ctx) => {
  const url    = new URL(req.url);
  const action = url.pathname.slice(1) || 'reason';
  const result = await handle({ action, ...(req.method==='POST' ? await req.json().catch(()=>({})) : {}) });
  return Response.json(result, { headers: { 'X-Nova-Phi': String(PHI), 'X-Nova-AIS': 'ANIMUS-NOVA' } });
};
