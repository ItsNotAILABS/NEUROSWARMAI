# Nova Python SDK for Pythonista iOS

**Nova by FreddyCreates** — The complete multimodal AI intelligence system, now on your iPhone.

This SDK brings the entire Nova/MAQUE intelligence system to Pythonista on iOS. Run real AI with real math — Kuramoto oscillators, Hebbian plasticity, Gabor cortical filters, small-world networks, Bayesian verification — all on your phone.

## Quick Start

1. Copy the `pythonista/` folder to your Pythonista app
2. Run `nova_app.py` to launch the UI
3. Or import directly in your scripts:

```python
from nova_app import Nova

nova = Nova()

# Reason with Kuramoto oscillators
result = nova.reason("What is the golden ratio?")
print(f"Coherent: {result['kuramoto']['coherent']}")

# Analyze text with Liquid Language
analysis = nova.analyze("The organism thinks with synchronized fields.")
print(f"Coherence: {analysis['coherence']}")

# Sense body state (uses real iOS sensors!)
sense = nova.sense()
print(f"Accelerometer: {sense['accelerometer']}")

# Connect AIS through mesh
connection = nova.connect("ANIM", "LING")
print(f"Path: {connection['path']}")
```

## Engines

### ANIMUS — Reasoning Engine
Alpha: ALPHA-001 × ALPHA-002

```python
from animus import AnimusEngine

engine = AnimusEngine()
result = engine.reason("Your query here")
# Returns: kuramoto sync, hebbian binding, phi-loss
```

**Math:**
- Kuramoto oscillators: `dθᵢ/dt = ωᵢ + (K/N) Σⱼ sin(θⱼ − θᵢ)`, K=φ+1=2.618
- Hebbian plasticity: `Δwᵢⱼ = η·xᵢ·xⱼ − λwᵢⱼ`, η=φ⁻⁴=0.0001618
- φ-loss: `L_nova = L_CE × (1 + φ⁻¹ × CS)`, ceiling=0.618

### LINGUA — Language Engine
Alpha: ALPHA-002 × ALPHA-004

```python
from lingua import LinguaEngine

engine = LinguaEngine()
analysis = engine.analyze("Your text here")
engine.store("Memory content", priority=0.9)
memories = engine.recall(5)
```

**Features:**
- Liquid Language geometry (vocabulary as weight-space attractors)
- Hippocampal replay memory
- Coherence scoring with φ⁻¹ injection ceiling

### OPTICA — Vision Engine
Alpha: ALPHA-003 × ALPHA-008

```python
from optica import OpticaEngine, capture_and_analyze

engine = OpticaEngine()
# With iOS camera (in Pythonista):
result = capture_and_analyze()

# Or analyze synthetic image:
result = engine.analyze_image(image_array)
```

**Math:**
- Gabor V1 filters: `G(x,y) = exp(-(x'²+γ²y'²)/(2σ²)) × cos(2π·x'/λ + ψ)`
- Cortical magnification: `M(r) = k/(r + r₀)`
- Entropy saliency: `S = -Σ p(i)log₂(p(i))`
- Maxwell-Boltzmann physics: `f(v) = 4π(m/2πkT)^(3/2) × v² × exp(-mv²/2kT)`

### TACTUS — Somatic Engine
Alpha: ALPHA-009 × ALPHA-005

```python
from tactus import TactusEngine

engine = TactusEngine()
sense = engine.sense()  # Uses real iOS sensors!
regulation = engine.regulate()
pattern = engine.morph(steps=50)  # Turing morphogenesis
```

**Math:**
- Proprioception: `Ia = k_s(l-l₀) + k_d(dl/dt)`
- PID homeostasis: `u = -Kp·e - Ki·∫e·dt - Kd·(de/dt)`, setpoint=φ⁻¹
- Turing morphogenesis: Gray-Scott reaction-diffusion

### NEXUS — Mesh Router
Alpha: ALPHA-010 × ALPHA-006 × ALPHA-007

```python
from nexus import NexusEngine

engine = NexusEngine()
conn = engine.connect("ANIM", "LING")
pred = engine.predict("key", value=0.5)
verif = engine.verify(claim=0.618, evidence=[0.61, 0.62])
```

**Math:**
- Small-world topology: Watts-Strogatz, rewire_prob=φ⁻¹
- φ-routing: `cost = Σ w_e × φ^(-depth)`
- Kalman filter: `K = P/(P+R)`
- Bayesian verification: `posterior ∝ likelihood × prior`, φ-prior=Beta(φ, φ⁻¹+1)

## MAQUE Protocol

The internal communication protocol for Nova:

```python
from maque import spawn_vivi, message, apex, QUADS, FLOS

# Spawn a VIVI processing thread
vivi = spawn_vivi("ANIM")

# Create a MAQUE message
msg = message(
    from_quad="ANIM",
    to_quad="LING",
    verb="query",
    via="THINK",
    vivi=vivi,
    body={"input": "Hello Nova"}
)

# Create an APEX artifact
artifact = apex(
    type_="result",
    from_quad="LING",
    flos_path="THINK",
    vivi_id=vivi.id,
    payload={"output": "Hello human"}
)
```

## φ Constants

```python
from phi import PHI, PHI_INV, PHI_BEAT, fib, phi_loss

PHI = 1.6180339887498949       # The golden ratio
PHI_INV = 0.6180339887498949   # φ⁻¹ — threshold, setpoint, learning rate
PHI_BEAT = 873                  # ms — organism heartbeat

# Fibonacci sequence
fib(10)  # → 55

# φ-encoded loss
phi_loss(L_CE=1.0, coherence_score=0.5)
```

## Files

| File | Description |
|------|-------------|
| `phi.py` | φ constants, Fibonacci utilities, φ-loss function |
| `maque.py` | MAQUE protocol — QUAD codes, VIVI, APEX, FLOS pathways |
| `animus.py` | Reasoning engine — Kuramoto, Hebbian, φ-loss |
| `lingua.py` | Language engine — Liquid Language, memory |
| `optica.py` | Vision engine — Gabor, entropy saliency |
| `tactus.py` | Somatic engine — sensors, PID, morphogenesis |
| `nexus.py` | Mesh router — small-world, Kalman, Bayesian |
| `nova_app.py` | Main app — unified interface, UI |

## iOS Features

When running on Pythonista, Nova can access:

- **Accelerometer** — real device motion via `motion` module
- **Gyroscope** — device orientation
- **Camera** — capture and analyze images via `photos` module
- **UI** — native iOS interface via `ui` module

If modules aren't available (e.g., testing on desktop), Nova falls back to synthetic data.

## QUAD Codes

All components have 4-letter QUAD codes:

| Code | Name | Description |
|------|------|-------------|
| ANIM | ANIMUS | Reasoning engine |
| LING | LINGUA | Language engine |
| OPTI | OPTICA | Vision engine |
| MEMO | MEMORIA | Memory engine |
| TACT | TACTUS | Somatic engine |
| NEXU | NEXUS | Mesh engine |
| PROP | PROPHETA | Prediction engine |
| VERI | VERITAS | Truth engine |
| KOSM | KOSMOS | Physics engine |
| FABR | FABRICA | Build engine |

## FLOS Pathways

Pre-defined processing pathways:

| Pathway | Route | Purpose |
|---------|-------|---------|
| THINK | ANIM → LING → MEMO | Reasoning + language + memory |
| BUILD | FABR → AEDI → NEXU | Construction |
| SEE | OPTI → KOSM → NEXU | Vision |
| FEEL | TACT → FABR → MEMO | Embodiment |
| TRUTH | VERI → PROP → ANIM | Verification |
| FULL | All 10 alphas | Complete processing |

## Philosophy

Nova is built on three principles:

1. **φ everywhere** — The golden ratio governs thresholds, learning rates, timing, topology
2. **Real math** — Every engine uses real neuroscience/physics equations
3. **No external models** — All intelligence is internal to the organism

This is not a wrapper around GPT. This is native intelligence.

## Author

**FreddyCreates** — Building the civilization.

Repository: [command-platform](https://github.com/FreddyCreates/command-platform)

---

*"The organism thinks with synchronized oscillators, speaks with liquid language, sees with cortical filters, feels with homeostatic regulation, and connects through small-world topology. All governed by φ."*
