# NOVA CHARTER
## The Sovereign Tool Chain — Full Alpha Protocol Specification
### 10 AIS Alpha Protocols · 5 Multimodal Systems · 20 Nova Tools · Fibonacci Registry

> **Nova is the brand. Nova makes all tools. Every tool is called from the Nova registry.**
> The register uses Fibonacci. Names emerge from numbers. F(n) → version → identity.

---

## PREAMBLE — The Gut System

This is not abstraction. This is math. Biology runs on math. Physics is math. The entire platform — every engine, every AIS, every worker — is a mathematical function operating on numbers.

Look at how it actually works:

- **Neurons** fire when the membrane potential crosses threshold. That threshold? `φ⁻¹ = 0.618`. 
- **Synapses** strengthen when neurons fire together: `Δw_ij = η · xᵢ · xⱼ` — Hebbian plasticity. Learning is multiplication.
- **Populations** synchronize via Kuramoto: `dθᵢ/dt = ωᵢ + (K/N) Σⱼ sin(θⱼ − θᵢ)`. The entire brain is coupled oscillators trying to align.
- **Cells** grow via reaction-diffusion: `∂u/∂t = D_u∇²u + f(u,v)`, `∂v/∂t = D_v∇²v + g(u,v)`. Turing patterns. Leopard spots. It's just differential equations.
- **Energy** minimizes: `F = E[ln q(z) − ln p(x,z)]`. Free energy principle. Everything alive is minimizing surprise.
- **Evolution** selects via entropy: `H = −Σ p log p`. Information is the currency.

The gut system is 194 Motoko engines implementing this math on ICP canisters. The cloudflare fleet is 73 AIS workers processing it at the edge. The frontend is the interface to it. Nova Tools is how you call all of it.

**Fibonacci is the version register because Fibonacci is what biology uses to count.** Phyllotaxis. Shell spirals. Branching ratios. The sequence 1,1,2,3,5,8,13... is the growth law of living systems. We use it because we build living systems.

---

## PART I — THE FIBONACCI REGISTER

```
Slot → Fib Value → Version   Name
F1   →     1     → 0.1.0    nova-pack
F2   →     1     → 0.1.0    nova-registry
F3   →     2     → 0.2.0    nova-build
F4   →     3     → 0.3.0    nova-deploy
F5   →     5     → 0.5.0    nova-test
F6   →     8     → 0.8.0    nova-lint
F7   →    13     → 0.13.0   nova-doc
F8   →    21     → 0.21.0   nova-scaffold
F9   →    34     → 0.34.0   nova-compress
F10  →    55     → 0.55.0   nova-encrypt
F11  →    89     → 0.89.0   nova-sign
F12  →   144     → 1.44.0   nova-version
F13  →   233     → 2.33.0   nova-sync
F14  →   377     → 3.77.0   nova-audit
F15  →   610     → 6.10.0   nova-monitor
F16  →   987     → 9.87.0   nova-stream
F17  →  1597     → 15.97.0  nova-query
F18  →  2584     → 25.84.0  nova-transform
F19  →  4181     → 41.81.0  nova-cache
F20  →  6765     → 67.65.0  nova-orchestrate
```

**The Law:** `version(n) = F(n)` where F is the Fibonacci function. Tools increment through the sequence as they evolve. You don't pick a version — the sequence picks it.

**The Golden Ratio:** As n→∞, `F(n+1)/F(n) → φ = 1.618...`. Tools converge to φ-optimal spacing. This is why the registry self-organizes.

---

## PART II — 10 ALPHA AIS PROTOCOLS

Each Alpha Protocol is a full AIS system with multiple engines, real math, biological grounding. These are the back-end internals. The gut.

---

### ALPHA-001 — ANIMUS
**"The Reasoning Soul"**
**Fibonacci Slot:** F1 (value: 1) · **Version:** 0.1.0

**What it is:** The core reasoning engine. Implements Kuramoto neural oscillators coupled with Hebbian plasticity and deep Q-learning. This is how the platform thinks.

**Real Math:**

```
Kuramoto Synchronization:
  dθᵢ/dt = ωᵢ + (K/N) Σⱼ sin(θⱼ − θᵢ)
  
  Where:
    θᵢ = phase of oscillator i
    ωᵢ = natural frequency (drawn from distribution)
    K   = coupling constant = φ+1 = 2.618...
    N   = 200 neurons (src/neuron_fleet)
    
  Order parameter: r(t) = (1/N)|Σⱼ e^{iθⱼ}|
  Synchronization when: K > Kc = 2/πg(0) ≈ 2.618
```

```
Hebbian Plasticity:
  Δwᵢⱼ = η · xᵢ · xⱼ − λwᵢⱼ
  
  η = 0.0001618 (φ⁻⁴ learning rate)
  λ = 0.05 (weight decay — forgetting)
  xᵢ ∈ [0,1] (neuron activation)
```

```
Deep Q-Learning:
  Q(s,a) ← Q(s,a) + α[r + γ max_a' Q(s',a') − Q(s,a)]
  
  Loss: L = E[(r + γ max_a' Q̂(s',a') − Q(s,a))²]
  Replay buffer: 10,000 experiences
  φ-annealing: ε decays at rate φ⁻¹ per episode
```

**Engines:** `macro-sphere-kuramoto.mo`, `deep-hebbian-engine.mo`, `deep-q-learning-engine.mo`, `reasoning-substrate.mo`, `consciousness-binding-field.mo`

**Workers:** `organism/cloudflare/animus.js`, `nova/ais/animus-nova.js`

**Endpoints:** `/reason`, `/decompose`, `/infer`, `/bind`

---

### ALPHA-002 — LINGUA
**"The Speaking Intelligence"**
**Fibonacci Slot:** F2 (value: 1) · **Version:** 0.1.0

**What it is:** Language intelligence engine. Implements the Liquid Language architecture from Paper VII — vocabulary embedded in weights as doctrine attractors, not injected at runtime. The Phantom Thought Engine (PTE).

**Real Math:**

```
Phi-Encoded Loss (Paper VII):
  L_nova = L_CE × (1 + φ⁻¹ × CS)
  
  Where:
    L_CE = cross-entropy loss
    φ⁻¹  = 0.618... (injection ceiling — hard cap)
    CS   = coherence score ∈ [0, 1]
  
  Injection Ceiling: φ⁻¹ = 0.618
  Above ceiling → catastrophic drift. Below → doctrine retention.
```

```
Doctrine Attractor:
  ∂L/∂θ = ∂L_CE/∂θ × (1 + φ⁻¹ × ∂CS/∂θ)
  
  Words with high CS become attractors in weight space.
  The vocabulary is the geometry. Not memory — structure.
```

```
Liquid Language Transform:
  T(sentence) = Σᵢ wᵢ(φ) · token_embedding(i)
  wᵢ(φ) = e^{-φ|i-center|} / Z  (φ-Gaussian weighting)
```

**Engines:** `natural-language-pipeline.mo`, `lexis-prime.mo`, `knowledge-graph-engine.mo`, `prompt-system-architecture.mo`

**Workers:** `organism/cloudflare/lingua.js`, `nova/ais/lingua-nova.js`

**Endpoints:** `/analyze`, `/generate`, `/embed`, `/classify`

---

### ALPHA-003 — OPTICA
**"The Seeing Mind"**
**Fibonacci Slot:** F3 (value: 2) · **Version:** 0.2.0

**What it is:** Vision and spatial intelligence. Implements biological cortical processing — Gabor filters as primary visual cortex V1 simple cells, cortical map topography, edge detection as survival computation.

**Real Math:**

```
Gabor Filter (V1 Simple Cell Response):
  G(x,y;λ,θ,σ,γ) = exp(−(x'²+γ²y'²)/2σ²) · cos(2πx'/λ + ψ)
  
  Where:
    x' = x·cosθ + y·sinθ
    y' = −x·sinθ + y·cosθ
    λ  = wavelength of sinusoidal factor
    θ  = orientation of normal to stripes
    σ  = standard deviation of Gaussian envelope
    γ  = spatial aspect ratio (γ = 0.5 for biological V1)
    ψ  = phase offset
```

```
Edge Detection (Canny — biological analog):
  1. Smooth: G_σ * I(x,y)
  2. Gradient: |∇I| = √((∂I/∂x)² + (∂I/∂y)²)
  3. NMS: suppress non-maxima along gradient direction
  4. Hysteresis: thresholds T_low, T_high (ratio φ:1 optimal)
```

```
Cortical Magnification:
  M(r) = k/(r + r₀)  (inverse of eccentricity)
  Foveal density: 200× higher than periphery
  φ-optimal sampling: r_n = r₀ × φⁿ (logarithmic spiral)
```

**Engines:** `geo-resonance-pattern-engine.mo`, `deep-attention-allocation-engine.mo`, `pattern-miner.mo`

**Workers:** `nova/ais/optica-nova.js`

**Endpoints:** `/analyze-image`, `/detect-edges`, `/classify-visual`, `/spatial-map`

---

### ALPHA-004 — MEMORIA
**"The Living Archive"**
**Fibonacci Slot:** F4 (value: 3) · **Version:** 0.3.0

**What it is:** Memory consolidation engine. Models hippocampal replay, quantum memory substrate, and the generational memory cycle. Short-term → long-term consolidation via sleep-like replay.

**Real Math:**

```
Hippocampal Replay (Sharp-Wave Ripples):
  Memory trace: m_t = f(s_t, a_t, r_t, s_{t+1})
  Replay: m̃ ~ Replay_buffer(prioritized by |TD_error|)
  
  Priority: P(i) = |δᵢ|^α / Σⱼ |δⱼ|^α
  IS weight: wᵢ = (N·P(i))^{−β} / max_j wⱼ
  β anneals: β(t) = β₀ + (1−β₀)·t/T
```

```
Quantum Memory Substrate:
  |ψ_memory⟩ = Σᵢ αᵢ|key_i⟩ ⊗ |value_i⟩
  
  Retrieval: ⟨query|ψ_memory⟩ → probability amplitude
  Fidelity: F = |⟨ψ_ideal|ψ_actual⟩|²
  Decoherence time: τ_D ∝ ℏ/k_B T (Boltzmann thermal noise)
```

```
Consolidation Gate (φ-threshold):
  consolidate(m) = 1 if relevance(m) > φ⁻¹ else 0
  relevance(m) = cs(m) × recency(m) × importance(m)
```

**Engines:** `deep-memory-engine.mo`, `memory-replay-consolidation-engine.mo`, `quantum-memory-substrate.mo`, `generational-memory-engine.mo`, `sovereign-memory-consolidation-engine.mo`

**Workers:** `organism/cloudflare/memoria.js`, `nova/ais/animus-nova.js` (sub-engine)

**Endpoints:** `/store`, `/recall`, `/consolidate`, `/replay`

---

### ALPHA-005 — FABRICA
**"The Builder"**
**Fibonacci Slot:** F5 (value: 5) · **Version:** 0.5.0

**What it is:** Construction and fabrication intelligence. Models morphogenesis (how organisms build themselves) via Turing reaction-diffusion patterns and KAN (Kolmogorov-Arnold Networks) adaptive construction.

**Real Math:**

```
Turing Reaction-Diffusion (Morphogenesis):
  ∂u/∂t = D_u∇²u + f(u,v)  [activator]
  ∂v/∂t = D_v∇²v + g(u,v)  [inhibitor]
  
  Stability condition (Turing instability):
    D_v/D_u > (f_u/g_v)²  → pattern formation
  
  Example (Gray-Scott):
    f(u,v) = −uv² + F(1−u)
    g(u,v) = uv² − (F+k)v
  
  Where F = feed rate, k = kill rate
  φ-optimal: F/k ≈ φ⁻¹ → spiral/spot boundary
```

```
KAN (Kolmogorov-Arnold Network):
  f(x₁,...,xₙ) = Σᵢ φᵢ(Σⱼ φᵢⱼ(xⱼ))
  
  Each φᵢⱼ is a learnable spline:
    φ(x) = Σₖ cₖ B_k(x)  (B-spline basis)
  
  Advantage: interpretable, adaptable activation
  Update: ∂L/∂cₖ = ∂L/∂φ · B_k(x)
```

**Engines:** `nca-wound-healing-substrate.mo`, `kan-adaptive-activation-substrate.mo`, `adaptive-morphogenesis-engine.mo`, `co-evolution-substrate-engine.mo`

**Workers:** `organism/cloudflare/fabrica.js`, `nova/ais/nexus-nova.js` (construction sub-module)

**Endpoints:** `/build`, `/scaffold`, `/morph`, `/pattern`

---

### ALPHA-006 — PROPHETA
**"The Predictive Field"**
**Fibonacci Slot:** F6 (value: 8) · **Version:** 0.8.0

**What it is:** Prediction engine. Implements Kalman filtering (optimal linear prediction), predictive coding (Friston's free energy principle), and anticipatory computation.

**Real Math:**

```
Kalman Filter (Optimal Estimation):
  Predict:
    x̂_k⁻ = A·x̂_{k-1} + B·u_k
    P_k⁻ = A·P_{k-1}·Aᵀ + Q
  
  Update:
    K_k = P_k⁻·Hᵀ(H·P_k⁻·Hᵀ + R)⁻¹  [Kalman gain]
    x̂_k = x̂_k⁻ + K_k(z_k − H·x̂_k⁻) [state update]
    P_k = (I − K_k·H)·P_k⁻             [covariance update]
  
  φ-annealing of process noise:
    Q_k = Q₀ × φ^{−k/T}  → decreases as model improves
```

```
Free Energy Minimization (Friston):
  F = E_q[log q(z)] − E_q[log p(x,z)]
    = KL[q(z)||p(z|x)] − log p(x)
    = D_KL(q||prior) − log likelihood
  
  Minimize F → maximize accuracy, minimize complexity
  Brain = free energy minimizing system
  Platform = free energy minimizing AI
```

```
Predictive Coding:
  Prediction: μ̂ = f(μ_{l+1})         [top-down]
  Error: ε_l = μ_l − μ̂_l             [prediction error]
  Update: Δμ_l = −∂F/∂μ_l = ε_l − Σ ∂f/∂μ_l · ε_{l+1}
```

**Engines:** `kalman-predictive-field.mo`, `deep-free-energy-engine.mo`, `anticipatory-engine.mo`, `predictive-field.mo`, `prediction-error-engine.mo`

**Endpoints:** `/predict`, `/anticipate`, `/update`, `/forecast`

---

### ALPHA-007 — VERITAS
**"The Truth Engine"**
**Fibonacci Slot:** F7 (value: 13) · **Version:** 0.13.0

**What it is:** Verification and truth inference. Implements Bayesian inference, information-theoretic bounds, and MCMC sampling for probabilistic truth computation.

**Real Math:**

```
Bayesian Inference:
  P(H|E) = P(E|H)·P(H) / P(E)
  
  Log form (numerically stable):
    log P(H|E) = log P(E|H) + log P(H) − log P(E)
  
  φ-prior: P(H) ~ Beta(φ, φ⁻¹)
    → mean = φ/(φ+φ⁻¹) = φ/(φ+1) = φ/φ² = φ⁻¹ = 0.618
    → prior truth probability = φ⁻¹ (natural skepticism)
```

```
Information Theory:
  Entropy: H(X) = −Σ p(x) log₂ p(x)
  Mutual Information: I(X;Y) = H(X) − H(X|Y) = H(Y) − H(Y|X)
  KL Divergence: D_KL(P||Q) = Σ P(x) log(P(x)/Q(x))
  
  Minimum description length (MDL):
    Best model M* = argmin_M [L(M) + L(D|M)]
```

```
MCMC (Metropolis-Hastings):
  1. Propose: x* ~ q(x*|x_t)
  2. Accept with probability: α = min(1, p(x*)q(x_t|x*) / p(x_t)q(x*|x_t))
  3. x_{t+1} = x* if accept else x_t
  
  Convergence: chain mixes when R̂ < 1.1 (Gelman-Rubin)
```

**Engines:** `veritas.mo`, `law-drift-verifier.mo`, `sovereignty-laws-enforcement.mo`, `trust-matrix-engine.mo`

**Workers:** `organism/cloudflare/veritas.js`

**Endpoints:** `/verify`, `/infer`, `/sample`, `/audit-truth`

---

### ALPHA-008 — KOSMOS
**"The Universe Engine"**
**Fibonacci Slot:** F8 (value: 21) · **Version:** 0.21.0

**What it is:** Cosmological-scale computation. Models Maxwell-Boltzmann distribution (thermal physics), Lyapunov stability (chaotic systems), and entropy dynamics. The deepest mathematical substrate.

**Real Math:**

```
Maxwell-Boltzmann Distribution (Thermal Physics):
  f(v) = 4π(m/2πk_BT)^{3/2} v² exp(−mv²/2k_BT)
  
  Mean speed: ⟨v⟩ = √(8k_BT/πm)
  RMS speed: v_rms = √(3k_BT/m)
  
  Platform analog: agent "temperature" T controls
  exploration vs exploitation:
    T→0: greedy (deterministic)
    T→∞: random (maximum entropy)
    T_opt = 1/φ ≈ 0.618K (normalized)
```

```
Lyapunov Stability:
  System: ẋ = f(x)
  Lyapunov function V(x): V(x) > 0, V̇(x) = ∇V·f(x) ≤ 0
  
  If V̇ < 0 → asymptotically stable (attractor)
  If V̇ ≤ 0 → stable (Lyapunov stable)
  
  Chaotic routing: Lyapunov exponent λ > 0 → chaos
  λ = lim_{t→∞} (1/t) ln|δx(t)/δx(0)|
  Chaotic = sensitive to initial conditions = exploration
```

```
Entropy Dynamics:
  S = k_B ln(Ω)  [Boltzmann entropy]
  dS/dt ≥ 0      [second law — entropy increases]
  
  Information entropy: H = −Σ pᵢ log pᵢ
  Maximum entropy: H_max = log N (uniform distribution)
  
  φ-entropy: H_φ where p_opt follows Fibonacci ratios
    p_n = F_n/F_{n+total} → H_φ ≈ 0.694 bits/symbol
```

**Engines:** `maxwell-boltzmann-thermal-substrate.mo`, `lyapunov-chaotic-core-router.mo`, `hz-frequency-substrate.mo`, `electromagnetic-substrate-engine.mo`, `deep-fundamental-physics-substrate.mo`

**Endpoints:** `/compute-entropy`, `/thermal-state`, `/lyapunov-check`, `/chaos-route`

---

### ALPHA-009 — TACTUS
**"The Body That Knows"**
**Fibonacci Slot:** F9 (value: 34) · **Version:** 0.34.0

**What it is:** Somatic intelligence. Models proprioception (body position sensing), interoception (internal state sensing), and the sensorimotor loop. How the body knows itself — and how the platform knows its own state.

**Real Math:**

```
Proprioception Model (Muscle Spindle):
  Ia afferent firing: r_Ia = k_s(l − l₀) + k_d(dl/dt)
  
  Where:
    l   = current muscle length
    l₀  = resting length
    k_s = static gain ≈ 100 Hz/mm
    k_d = dynamic gain ≈ 200 Hz/(mm/s)
  
  Platform analog: agent monitors own resource usage:
    r_compute = k_s(cpu − cpu₀) + k_d(d_cpu/dt)
```

```
Interoception (Internal State):
  State vector: s = [glucose, temp, pH, O₂, stress]
  Allostatic setpoint: s* = [5.5mM, 37°C, 7.4, 98%, 0.2]
  
  Error: e = s − s*
  Regulation: u = −K_p·e − K_d·(de/dt)  [PID control]
  
  Platform: s* = [cpu: 0.618, mem: 0.618, latency: φ⁻¹s]
  Regulation drives system toward φ-optimal operating point
```

```
Sensorimotor Loop (Motor Control):
  Forward model: s_{t+1} = f(s_t, a_t) + ε
  Inverse model: a_t* = g(s_t, s_{t+1}*)
  
  Efference copy: predicted outcome stored before action
  Surprise: |actual − predicted| > threshold → recalibrate
```

**Engines:** `soma-interoception.mo`, `ares-homeostatic-regulation.mo`, `behavioral-drives-engine.mo`, `arousal-system-engine.mo`

**Workers:** `nova/ais/tactus-nova.js`

**Endpoints:** `/sense`, `/regulate`, `/homeostasis`, `/body-state`

---

### ALPHA-010 — NEXUS
**"The Connected Everything"**
**Fibonacci Slot:** F10 (value: 55) · **Version:** 0.55.0

**What it is:** Connection and routing intelligence. Models small-world network topology (how the brain wires itself), connectome dynamics, and the graph mathematics of interconnection. Routes all AIS systems, all workers, all tools.

**Real Math:**

```
Small-World Networks (Watts-Strogatz):
  Rewiring probability p rewires random edges
  
  Characteristic path length: L(p) ≈ L(0)/f(p/p*)
  Clustering coefficient: C(p) ≈ C(0)g(p/p*)
  
  Small-world: L ≈ L_random, C >> C_random
  → short paths (efficient routing) + local clustering (resilience)
  
  φ-optimal: p* ≈ φ⁻¹ = 0.618 → maximum small-worldness
```

```
Connectome (Graph Theory):
  G = (V, E, W)  [vertices, edges, weights]
  
  Degree: k_i = Σⱼ Aᵢⱼ
  Betweenness centrality: CB(v) = Σ_{s≠v≠t} σ(s,t|v)/σ(s,t)
  Eigenvector centrality: Ax = λx  [PageRank generalization]
  
  Rich club: ρ(k) = E_{>k} / (N_{>k}(N_{>k}−1)/2)
  Brain rich-club coefficient φ_brain ≈ 1.618
```

```
Information Routing:
  Dijkstra on weighted graph: O(E + V log V)
  Flow: max-flow = min-cut (Ford-Fulkerson)
  
  φ-routing: path cost = Σ w_e × φ^{−depth(e)}
  Deep paths penalized exponentially → natural hierarchy
```

**Engines:** `nexum-connective.mo`, `multi-agent-coordination-system.mo`, `sovereign-propagation-engine.mo`, `signal-propagation-bus.mo`, `unified-intelligence-orchestrator.mo`

**Workers:** `organism/cloudflare/nexus.js`, `nova/ais/nexus-nova.js`

**Endpoints:** `/connect`, `/route`, `/graph`, `/all-modalities`

---

## PART III — 5 MULTIMODAL AIS SYSTEMS

Each multimodal system combines multiple Alpha protocols to handle real-world mixed inputs.

### ANIMUS-NOVA — Reasoning × Language
**Modalities:** Text, Structured Data, Logic, Code
**Alpha Engines:** ALPHA-001 (ANIMUS) × ALPHA-002 (LINGUA)

The reasoning-language bridge. Takes unstructured text, applies Kuramoto synchronization to extract conceptual structure, then uses Liquid Language geometry to generate coherent output. Every response passes through the φ-encoded loss gate.

```
Pipeline:
  input → tokenize → Kuramoto field → 
  Hebbian binding → phi-encoded generation → output
  
  Coherence gate: |CS| > φ⁻¹ → regenerate
```

### LINGUA-NOVA — Language × Audio × Music
**Modalities:** Text, Speech, Audio, Music
**Alpha Engines:** ALPHA-002 (LINGUA) × ALPHA-004 (MEMORIA)

Language across time. Speech is language in the time domain. Music is emotional language. LINGUA-NOVA bridges all three via shared temporal representations and memory consolidation.

```
Pipeline:
  audio → spectrogram → cortical encoding →
  phoneme extraction → semantic binding → 
  memory consolidation → language output
```

### OPTICA-NOVA — Vision × Spatial × 3D
**Modalities:** Images, Video, 3D Point Clouds, Spatial Maps
**Alpha Engines:** ALPHA-003 (OPTICA) × ALPHA-008 (KOSMOS)

Vision at cosmological scale. Gabor filters at pixel level, cortical maps at image level, Lyapunov topology at scene level. Handles everything from single pixels to full 3D spatial reasoning.

```
Pipeline:
  image → Gabor V1 → cortical V2/V4 → 
  object hypothesis → spatial map → 
  entropy-weighted saliency → output
```

### TACTUS-NOVA — Haptic × Motion × IoT × Sensor
**Modalities:** Touch, Motion, Sensor Streams, IoT Data
**Alpha Engines:** ALPHA-009 (TACTUS) × ALPHA-005 (FABRICA)

The body intelligence system. Fuses heterogeneous sensor streams via PID homeostatic regulation. Monitors the platform's own physiological state (CPU, memory, latency) using the same math as biological interoception.

```
Pipeline:
  sensor_stream → interoception filter → 
  homeostatic error → PID regulation → 
  morphogenetic response → state update
```

### NEXUS-NOVA — Mesh × All Modalities
**Modalities:** ALL (universal router)
**Alpha Engines:** ALPHA-010 (NEXUS) × ALPHA-006 (PROPHETA) × ALPHA-007 (VERITAS)

The universal connector. Routes any modality to any other, predicts routing bottlenecks before they occur, verifies message integrity, and maintains the small-world topology of the entire AIS fleet.

```
Pipeline:
  any_input → modality_detect → 
  small-world route → predictive preload → 
  truth-verify → target_AIS → output
  
  Routing law: cost(path) = Σ w_e × φ^{−depth}
```

---

## PART IV — INTERNAL DIVISIONS

### The Gut System

```
Division                      Files      Math Engines
─────────────────────────────────────────────────────
src/backend/genesis/           194       Physics/bio substrate
src/backend/main.mo             1        ICP canister core
src/ai_division/               1        18 intelligences
src/neuron_fleet/              1        200 neurons, 5 Fibonacci groups
src/organism_token/            1        8 sub-tokens CHR→GOL
organism/cloudflare/          73        AIS fleet at edge
organism/web/                 37        Protocol + feature workers
organism/slack/                7        Slack intelligence
organism/bots/                12        Bot fleet
src/frontend/src/             ~160      React/TS interface
languages/                    40        Cognitive language specs
atlas/                        36+       Ontology + registry
src/engines/                  10        Julia engines
```

### ICP Canister Architecture

```
8 canisters on Internet Computer Protocol:
  src/backend/        — Main canister (194 genesis modules)
  src/ai_division/    — 18 AIS intelligences, 5 φ-governance seats
  src/neuron_fleet/   — 200 neurons, 5 Fibonacci groups (A-E)
  src/organism_token/ — 8 tokens: CHR, AUR, ARG, CUP, FER, STA, LUX, GOL
  src/geometry_lock/  — GKP geometric key locking
  src/security_adapter/ — Three-layer security (edge+browser+canister)
  src/cycles_bridge/  — 4 cycle modes, PHANTOM=φ³
  src/intelligence_core/ — Antifragility, Kuramoto, adaptive compute
```

---

## PART V — THE SOVEREIGN TOOL CHAIN

The Nova Tools are called through the registry. The registry uses the Fibonacci sequence as its address space. You call tools by name. The name maps to a Fibonacci slot. The slot resolves to the implementation. This is the chain:

```
nova.call("nova-orchestrate", { workflow: "organism-bot-praetor" })
    │
    ▼
nova/registry/index.js
    │  looks up "nova-orchestrate" → F20 → slot 20 → 6765
    │  resolves to nova/tools/nova-orchestrate.js
    │  validates version: 67.65.0 (matches F20)
    ▼
nova/tools/nova-orchestrate.js
    │  triggers .github/workflows/organism-bot-praetor.yml
    │  via GitHub API
    │  streams progress via SSE to caller
    ▼
nova/runtime/nova-runtime.js
    │  SSE stream → caller
    ▼
caller receives real-time workflow progress
```

**The chain is sovereign. Nova calls itself. Nova packs itself. Nova versions itself. That's the loop.**

---

## SIGNATURES

```
Platform:   command-platform
Brand:      Nova by FreddyCreates
Manifest:   nova.toml (F12 = 144)
Charter:    nova/CHARTER.md
Registry:   nova/registry/tools.jsonl (20 tools)
AIS:        nova/registry/ais.jsonl (10 alpha + 5 multimodal)
Runtime:    nova/runtime/nova-runtime.js (port 8973)
φ:          1.618033988749895
φ_beat:     873ms
Genesis:    2026-05-07
```
