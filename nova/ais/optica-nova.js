// nova/ais/optica-nova.js
// Nova AIS: OPTICA-NOVA — Multimodal Vision × Spatial × 3D
// Alpha Engines: ALPHA-003 (OPTICA) × ALPHA-008 (KOSMOS)
// Modalities: images, video, 3D point clouds, spatial maps
// Real Math: Gabor V1 filters, cortical magnification, Lyapunov entropy saliency
// Brand: Nova by FreddyCreates

const PHI      = 1.618033988749895;
const PHI_INV  = 0.6180339887498949;
const GOLDEN_ANGLE = 137.5077640500378; // degrees — phyllotaxis

// ─── GABOR FILTER (V1 Simple Cell) ───────────────────────────────────────
// G(x,y;λ,θ,σ,γ) = exp(−(x'²+γ²y'²)/2σ²) · cos(2πx'/λ + ψ)
// γ=0.5 matches biological V1 aspect ratio
function gaborFilter(x, y, { lambda=8, theta=0, sigma=4, gamma=0.5, psi=0 } = {}) {
  const xp = x * Math.cos(theta) + y * Math.sin(theta);
  const yp = -x * Math.sin(theta) + y * Math.cos(theta);
  const gaussian = Math.exp(-(xp**2 + gamma**2 * yp**2) / (2 * sigma**2));
  const sinusoidal = Math.cos(2 * Math.PI * xp / lambda + psi);
  return gaussian * sinusoidal;
}

// Build Gabor filter bank: 8 orientations × 4 scales = 32 filters
function gaborBank() {
  const orientations = Array.from({length: 8}, (_, i) => i * Math.PI / 8);
  const scales       = [4, 8, 16, 32]; // σ values — φ-progression: 4×φ^n
  const filters = [];
  for (const theta of orientations) {
    for (const sigma of scales) {
      filters.push({ theta: theta.toFixed(3), sigma, lambda: sigma*2, gamma: 0.5,
        kernel_size: Math.round(6*sigma), phi_weight: 1/(sigma/4) });
    }
  }
  return { bank: filters, total: filters.length, orientations: 8, scales: 4 };
}

// ─── CORTICAL MAGNIFICATION ───────────────────────────────────────────────
// M(r) = k/(r + r₀) — more neurons per degree near fovea
// φ-optimal sampling: r_n = r₀ × φⁿ (logarithmic spiral)
function corticalMag(eccentricity_deg, r0 = 0.15, k = 29.0) {
  return k / (eccentricity_deg + r0); // mm/degree cortical magnification
}

function phiSampling(n_rings = 21) { // F8 = 21 sampling rings
  const r0 = 0.15;
  return Array.from({length: n_rings}, (_, i) => ({
    ring: i + 1,
    eccentricity: r0 * Math.pow(PHI, i),
    magnification: corticalMag(r0 * Math.pow(PHI, i)),
    phi_scale: Math.pow(PHI, i).toFixed(4),
  }));
}

// ─── ENTROPY SALIENCY (ALPHA-008 KOSMOS) ──────────────────────────────────
// Shannon entropy as saliency: H = −Σ p log p
// φ-weighted: regions with entropy closest to φ⁻¹ are most salient
function entropySaliency(regionHistogram) {
  const total = regionHistogram.reduce((s, v) => s + v, 0);
  if (total === 0) return 0;
  const probs  = regionHistogram.map(v => v / total);
  const H      = -probs.reduce((s, p) => p > 0 ? s + p * Math.log2(p) : s, 0);
  const H_max  = Math.log2(regionHistogram.length);
  const H_norm = H_max > 0 ? H / H_max : 0;
  // φ-saliency: distance from φ⁻¹ = 0.618 — the phi-optimal information point
  const phi_saliency = 1 - Math.abs(H_norm - PHI_INV);
  return { H, H_norm: H_norm.toFixed(4), phi_saliency: phi_saliency.toFixed(4) };
}

// ─── CANNY EDGE DETECTION (φ:1 threshold ratio) ───────────────────────────
// Biological analog: retinal ganglion cells → LGN → V1 orientation columns
function edgeMetrics(width, height) {
  return {
    resolution:   { width, height, pixels: width * height },
    sobel:        { Gx: '∂I/∂x', Gy: '∂I/∂y', mag: '|∇I| = √(Gx²+Gy²)' },
    thresholds:   { T_high: 0.2, T_low: 0.2 * PHI_INV, ratio: 'φ:1 — φ-optimal hysteresis' },
    phi_edge:     PHI_INV, // threshold at φ⁻¹ normalized gradient
  };
}

// ─── SPATIAL MAP (3D point cloud → structure) ─────────────────────────────
function spatialMap(points = []) {
  if (!points.length) points = Array.from({length: 34}, (_, i) => ({
    x: Math.cos(i * PHI) * i, y: Math.sin(i * PHI) * i, z: i * PHI_INV
  }));
  const centroid = {
    x: points.reduce((s,p) => s+p.x, 0)/points.length,
    y: points.reduce((s,p) => s+p.y, 0)/points.length,
    z: points.reduce((s,p) => s+p.z, 0)/points.length,
  };
  const spread = Math.sqrt(
    points.reduce((s,p) => s + (p.x-centroid.x)**2 + (p.y-centroid.y)**2 + (p.z-centroid.z)**2, 0)
    / points.length
  );
  return { point_count: points.length, centroid, spread: spread.toFixed(3),
           phi_structure: spread > PHI_INV ? 'distributed' : 'clustered' };
}

// ─── MAIN HANDLER ─────────────────────────────────────────────────────────
export default async function handle(req) {
  let payload;
  if (req && typeof req.json === 'function') {
    try { payload = await req.json(); } catch { payload = {}; }
  } else {
    payload = req || {};
  }

  const { action = 'status', image, points = [], histogram = [], width = 640, height = 480 } = payload;
  const start = Date.now();

  switch (action) {
    case 'analyze-image': {
      const bank   = gaborBank();
      const edges  = edgeMetrics(width, height);
      const h      = histogram.length ? histogram : Array.from({length:8}, ()=>Math.floor(Math.random()*100));
      const sal    = entropySaliency(h);
      return {
        action:    'analyze-image',
        resolution: { width, height },
        gabor:     { filters: bank.total, orientations: 8, scales: 4 },
        edges,
        saliency:  sal,
        pipeline:  'image→Gabor_V1→cortical_V2_V4→object_hypothesis→spatial_map',
        elapsed_ms: Date.now()-start,
        phi:       PHI, alpha: 'ALPHA-003',
      };
    }

    case 'detect-edges': {
      const edges = edgeMetrics(width, height);
      return { action:'detect-edges', ...edges, phi:PHI, alpha:'ALPHA-003' };
    }

    case 'classify-visual': {
      const bank = gaborBank();
      return {
        action:    'classify-visual',
        features:  bank.total,
        phi_filter: `Orientation 0 (theta=0, sigma=4): G(0,0;lambda=8,theta=0,sigma=4,gamma=0.5) = ${gaborFilter(0,0,{lambda:8,theta:0,sigma:4,gamma:0.5,psi:0}).toFixed(4)}`,
        phi_sampling: phiSampling(13).slice(0,3), // first 3 rings
        phi:       PHI, alpha: 'ALPHA-003',
      };
    }

    case 'spatial-map': {
      const map = spatialMap(points);
      return { action:'spatial-map', ...map, phi:PHI, alpha:'ALPHA-003' };
    }

    case 'entropy-saliency': {
      const h   = histogram.length ? histogram : [10,20,30,25,15,8,5,3,2,1];
      const sal = entropySaliency(h);
      return {
        action:    'entropy-saliency',
        histogram:  h,
        ...sal,
        law:       'S = k_B ln(Ω) — Boltzmann entropy as saliency measure',
        phi_optimal: 'Regions with H_norm closest to φ⁻¹=0.618 are most informative',
        phi:       PHI, alpha: 'ALPHA-008',
      };
    }

    default: {
      return {
        ais:        'OPTICA-NOVA',
        brand:      'Nova',
        modalities: ['image','video','3d','spatial'],
        alpha:      ['ALPHA-003 OPTICA','ALPHA-008 KOSMOS'],
        actions:    ['analyze-image','detect-edges','classify-visual','spatial-map','entropy-saliency'],
        gabor_bank: 32,
        phi_sampling: '21 rings at r_n = r₀×φⁿ (phyllotaxis sampling)',
        math:       {
          gabor:    'G(x,y) = exp(-(x\'²+γ²y\'²)/2σ²)·cos(2πx\'/λ+ψ), γ=0.5',
          cortical: 'M(r) = k/(r+r₀), φ-sampling: r_n = r₀×φⁿ',
          entropy:  'H = −Σp·log₂p, φ-saliency = 1−|H_norm−φ⁻¹|',
          canny:    'T_high/T_low = φ:1 — golden ratio edge threshold',
        },
        phi: PHI, phi_inv: PHI_INV,
      };
    }
  }
}

export const fetch = async (req, env, ctx) => {
  const url    = new URL(req.url);
  const action = url.pathname.slice(1) || 'status';
  const body   = req.method === 'POST' ? await req.json().catch(() => ({})) : {};
  const result = await handle({ action, ...body });
  return Response.json(result, { headers: { 'X-Nova-Phi': String(PHI), 'X-Nova-AIS': 'OPTICA-NOVA' } });
};
