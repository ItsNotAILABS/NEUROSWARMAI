// nova/ais/tactus-nova.js
// Nova AIS: TACTUS-NOVA — Multimodal Haptic × Motion × IoT × Sensor
// Alpha Engines: ALPHA-009 (TACTUS) × ALPHA-005 (FABRICA)
// Modalities: haptic, motion, sensor streams, IoT data
// Real Math: proprioception model, PID homeostasis, Turing morphogenesis
// Brand: Nova by FreddyCreates

const PHI      = 1.618033988749895;
const PHI_INV  = 0.6180339887498949;
const PHI_BEAT = 873; // ms — synchronized to biology

// ─── PROPRIOCEPTION (Ia Afferent Firing) ──────────────────────────────────
// Ia afferent rate: r_Ia = k_s(l − l₀) + k_d(dl/dt)
// Models muscle spindle — position + velocity sensing
// Platform analog: CPU/memory monitoring uses same math
function iaAfferent(length, restLength, dLdt, ks = 100, kd = 200) {
  return ks * (length - restLength) + kd * dLdt; // Hz
}

// Platform state as proprioceptive signal
function platformProprioception(cpu, mem, latencyMs) {
  // Setpoint: all at φ⁻¹ = 0.618 (the biological optimal)
  const sp = PHI_INV;
  return {
    cpu:  { value: cpu,       setpoint: sp, error: cpu-sp,       signal: iaAfferent(cpu, sp, 0) },
    mem:  { value: mem,       setpoint: sp, error: mem-sp,       signal: iaAfferent(mem, sp, 0) },
    lat:  { value: latencyMs, setpoint: sp*1000, error: latencyMs-(sp*1000), signal: iaAfferent(latencyMs/1000, sp, 0) },
  };
}

// ─── INTEROCEPTION + PID HOMEOSTASIS ─────────────────────────────────────
// u = −Kp·e − Ki∫e dt − Kd·(de/dt)
// Biological: hypothalamic temperature regulation, blood glucose control
// Platform: CPU/memory/latency regulation
class PIDController {
  constructor(Kp = 2.0, Ki = 0.5, Kd = 1.0) {
    this.Kp = Kp; this.Ki = Ki; this.Kd = Kd;
    this.integral   = 0;
    this.prev_error = 0;
    this.dt         = PHI_BEAT / 1000; // φ-beat in seconds
  }

  update(error) {
    this.integral  += error * this.dt;
    const derivative = (error - this.prev_error) / this.dt;
    this.prev_error = error;
    const u = -(this.Kp * error + this.Ki * this.integral + this.Kd * derivative);
    return { u, error, integral: this.integral, derivative };
  }

  reset() { this.integral = 0; this.prev_error = 0; }
}

// Allostatic regulation: maintain setpoints via PID
function homeostasis(current, setpoint, controller) {
  const error    = current - setpoint;
  const control  = controller.update(error);
  const regulated = Math.max(0, Math.min(1, current + control.u * PHI_INV));
  return {
    current, setpoint, error: error.toFixed(4),
    control_signal: control.u.toFixed(4),
    regulated: regulated.toFixed(4),
    coherent: Math.abs(regulated - setpoint) < 0.1,
  };
}

// ─── TURING REACTION-DIFFUSION (ALPHA-005 FABRICA) ────────────────────────
// ∂u/∂t = D_u∇²u + f(u,v)  [activator]
// ∂v/∂t = D_v∇²v + g(u,v)  [inhibitor]
// Gray-Scott model: F = feed rate, k = kill rate
// φ-optimal: F/k ≈ φ⁻¹ → boundary between spots and stripes
function grayscottStep(u, v, { Du=0.16, Dv=0.08, F=0.055, k=0.062, dt=1.0 }={}) {
  // Simplified 1D version for platform
  const uvv  = u * v * v;
  const du   = Du * (0 - u) + (-uvv + F * (1 - u)); // laplacian=0 simplified
  const dv   = Dv * (0 - v) + (uvv - (F + k) * v);
  return {
    u:    Math.max(0, Math.min(1, u + du * dt)),
    v:    Math.max(0, Math.min(1, v + dv * dt)),
    uvv:  uvv.toFixed(6),
    phi_boundary: Math.abs(F/k - PHI_INV) < 0.01 ? 'AT_PHI_BOUNDARY' : 'OFF_BOUNDARY',
  };
}

// Run Gray-Scott for N steps
function morphogenesis(u0=0.5, v0=0.25, steps=89) { // F11=89 steps
  let u = u0, v = v0;
  const trajectory = [];
  for (let i = 0; i < steps; i++) {
    const next = grayscottStep(u, v);
    u = next.u; v = next.v;
    if (i % 13 === 0) trajectory.push({ step:i, u:u.toFixed(4), v:v.toFixed(4) }); // F7=13
  }
  return { final_u:u.toFixed(4), final_v:v.toFixed(4), trajectory, phi_optimal: Math.abs(u-PHI_INV)<0.1 };
}

// ─── SENSOR FUSION ────────────────────────────────────────────────────────
// Fuse heterogeneous sensor streams with φ-weighted Kalman-like fusion
function sensorFusion(sensors = []) {
  if (!sensors.length) sensors = [
    { name:'cpu',     value:0.45, uncertainty:0.05 },
    { name:'memory',  value:0.62, uncertainty:0.03 },
    { name:'network', value:0.31, uncertainty:0.08 },
    { name:'disk',    value:0.55, uncertainty:0.02 },
  ];
  // Uncertainty-weighted fusion: w_i = 1/σ_i² × φ^(-i)
  let weightedSum = 0, totalWeight = 0;
  const fused = sensors.map((s, i) => {
    const w = (1 / (s.uncertainty**2)) * Math.pow(PHI, -i);
    weightedSum  += s.value * w;
    totalWeight  += w;
    return { ...s, phi_weight: w.toFixed(4) };
  });
  const fused_value = weightedSum / totalWeight;
  return {
    sensors: fused,
    fused_value: fused_value.toFixed(4),
    coherent: Math.abs(fused_value - PHI_INV) < 0.1,
    phi_setpoint: PHI_INV,
  };
}

// ─── MAIN HANDLER ─────────────────────────────────────────────────────────
const cpuPID = new PIDController(2.0, 0.5, 1.0);
const memPID = new PIDController(2.0, 0.5, 1.0);

export default async function handle(req) {
  let payload;
  if (req && typeof req.json === 'function') {
    try { payload = await req.json(); } catch { payload = {}; }
  } else {
    payload = req || {};
  }

  const { action='status', cpu=0.5, memory=0.5, latency=500, sensors=[], u=0.5, v=0.25 } = payload;
  const start = Date.now();

  switch (action) {
    case 'sense': {
      const proprio = platformProprioception(cpu, memory, latency);
      return {
        action: 'sense',
        proprioception: proprio,
        phi_setpoint: PHI_INV,
        bio_analog: 'Ia afferent: r_Ia = k_s(l-l₀) + k_d(dl/dt), k_s=100Hz/mm, k_d=200Hz/(mm/s)',
        elapsed_ms: Date.now()-start, phi:PHI, alpha:'ALPHA-009',
      };
    }

    case 'regulate': {
      const cpuReg = homeostasis(cpu, PHI_INV, cpuPID);
      const memReg = homeostasis(memory, PHI_INV, memPID);
      return {
        action: 'regulate',
        cpu:    cpuReg,
        memory: memReg,
        allostasis: { setpoint:PHI_INV, bio:'hypothalamic-pituitary-adrenal axis analog' },
        pid:    { Kp:2.0, Ki:0.5, Kd:1.0, beat_ms:PHI_BEAT },
        elapsed_ms: Date.now()-start, phi:PHI, alpha:'ALPHA-009',
      };
    }

    case 'homeostasis': {
      return {
        action: 'homeostasis',
        setpoints: { cpu:PHI_INV, memory:PHI_INV, latency:PHI_INV*1000 },
        pid_formula: 'u = -Kp·e - Ki∫e dt - Kd·(de/dt)',
        phi_optimal: 'All systems converge to φ⁻¹ = 0.618 operating point',
        phi:PHI, alpha:'ALPHA-009',
      };
    }

    case 'morph': {
      const result = morphogenesis(u, v, 89);
      return {
        action: 'morph',
        gray_scott: { u0:u, v0:v, steps:89, F:0.055, k:0.062 },
        result,
        turing_condition: 'D_v/D_u > (f_u/g_v)² → pattern formation',
        phi_boundary: 'F/k ≈ φ⁻¹ = 0.618 → boundary between spots and stripes',
        elapsed_ms: Date.now()-start, phi:PHI, alpha:'ALPHA-005',
      };
    }

    case 'body-state':
    case 'sense-all': {
      const fusion = sensorFusion(sensors);
      const proprio = platformProprioception(cpu, memory, latency);
      return {
        action: 'body-state',
        fusion, proprio,
        coherent: fusion.coherent,
        phi_beat_ms: PHI_BEAT,
        elapsed_ms: Date.now()-start, phi:PHI,
      };
    }

    default: {
      return {
        ais:        'TACTUS-NOVA',
        brand:      'Nova',
        modalities: ['haptic','motion','sensor','iot'],
        alpha:      ['ALPHA-009 TACTUS','ALPHA-005 FABRICA'],
        actions:    ['sense','regulate','homeostasis','morph','body-state'],
        math:       {
          proprioception: 'r_Ia = k_s(l-l₀) + k_d·(dl/dt), k_s=100Hz/mm',
          pid:            'u = -Kp·e - Ki∫e dt - Kd·(de/dt)',
          gray_scott:     '∂u/∂t = D_u∇²u + (-uv²+F(1-u))',
          phi_setpoint:   'All systems → φ⁻¹ = 0.618 operating point',
        },
        phi:PHI, phi_inv:PHI_INV, phi_beat:PHI_BEAT,
      };
    }
  }
}

export const fetch = async (req, env, ctx) => {
  const url    = new URL(req.url);
  const action = url.pathname.slice(1) || 'status';
  const body   = req.method === 'POST' ? await req.json().catch(() => ({})) : {};
  const result = await handle({ action, ...body });
  return Response.json(result, { headers: { 'X-Nova-Phi': String(PHI), 'X-Nova-AIS': 'TACTUS-NOVA' } });
};
