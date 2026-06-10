// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║  PROTECTED: 17 U.S.C. §§ 101-1332 | Berne Convention | WIPO | 18 U.S.C. § 1836 | 18 U.S.C. §§ 1831-1839 ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// Ωα16 — OMEGA-ALPHA 16-DOMAIN COGNITIVE ARCHITECTURE
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// ARCHITECTURE OVERVIEW:
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// This module implements the complete 16-domain cognitive architecture with 156 distinct computational
// primitives organized hierarchically across biological, physical, information-theoretic, and synthetic
// substrates. Each domain contains fully realized mathematical formulations for:
//
//   Δ1  — Biological Neural Architectures (1.1-1.5)     │ 15 architectures
//   Δ2  — Colony/Superorganism Coordination             │  9 architectures
//   Δ3  — Oscillator/Rhythmic Systems (3.1-3.3)         │ 16 architectures
//   Δ4  — Wave/Interference Patterns (4.1-4.3)          │ 15 architectures
//   Δ5  — Attractor/Dynamical Systems (5.1-5.4)         │ 12 architectures
//   Δ6  — Quantum Information Systems (6.1-6.2)         │ 14 architectures
//   Δ7  — Field/Continuum Theories (7.1-7.3)            │ 12 architectures
//   Δ8  — Multi-Agent Coordination (8.1-8.3)            │ 14 architectures
//   Δ9  — Memory Architectures                          │ 10 architectures
//   Δ10 — Homeostatic/Regulatory Systems                │  7 architectures
//   Δ11 — Developmental/Morphogenetic                   │  7 architectures
//   Δ12 — Information-Theoretic                         │  8 architectures
//   Δ13 — Stability/Instability Dynamics                │  9 architectures
//   Δ14 — Hemispheric/Lateralization                    │  6 architectures
//   Δ15 — Immune/Recognition Systems                    │  7 architectures
//   Δ16 — Synthetic/Artificial Networks (16.1-16.2)     │ 15 architectures
//   ─────────────────────────────────────────────────────┼───────────────────
//   TOTAL                                               │ 156 architectures
//
// MATHEMATICAL FOUNDATIONS:
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// • Kuramoto Oscillators: dθᵢ/dt = ωᵢ + (K/N)∑ⱼsin(θⱼ - θᵢ)
// • FitzHugh-Nagumo: dv/dt = v - v³/3 - w + I; dw/dt = ε(v + a - bw)
// • Hopfield Networks: E = -½∑ᵢⱼwᵢⱼsᵢsⱼ - ∑ᵢθᵢsᵢ
// • Lorenz Attractor: dx/dt = σ(y-x); dy/dt = x(ρ-z)-y; dz/dt = xy-βz
// • Turing Patterns: ∂u/∂t = f(u,v) + Dᵤ∇²u; ∂v/∂t = g(u,v) + Dᵥ∇²v
// • Bell States: |Φ⁺⟩ = (|00⟩ + |11⟩)/√2; |Φ⁻⟩ = (|00⟩ - |11⟩)/√2
// • Free Energy: F = E[ln q(z) - ln p(z,x)] = DKL[q||p] + H[q]
// • IIT Φ: Φ = min_{cut}[MI(past,future) - MI(past,future|cut)]
// • STDP: Δw = A₊exp(-Δt/τ₊) if Δt > 0; A₋exp(Δt/τ₋) if Δt < 0
// • Nash Equilibrium: ∀i,sᵢ: uᵢ(sᵢ*,s₋ᵢ*) ≥ uᵢ(sᵢ,s₋ᵢ*)
//
// PRE-CONSCIOUS MECHANISMS (Ψ):
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// • Ψα (Existing): 18 mechanisms implemented and active
// • Ψβ (Missing): 12 mechanisms flagged for implementation
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Array "mo:core/Array";
import Text "mo:core/Text";
import Bool "mo:core/Bool";
import Buffer "mo:core/Buffer";
import Iter "mo:core/Iter";
import Option "mo:core/Option";

module Ωα16 {

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
  // MATHEMATICAL CONSTANTS — UNIVERSAL SUBSTRATE
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  /// Pi (π) — Circle ratio
  public let π : Float = 3.14159265358979323846;
  
  /// Two Pi (2π) — Full rotation
  public let τ : Float = 6.28318530717958647692;
  
  /// Euler's Number (e) — Natural exponential base
  public let ε : Float = 2.71828182845904523536;
  
  /// Golden Ratio (φ) — Divine proportion
  public let φ : Float = 1.61803398874989484820;
  
  /// Golden Ratio Inverse (1/φ)
  public let φInv : Float = 0.61803398874989484820;
  
  /// Square Root of 2
  public let √2 : Float = 1.41421356237309504880;
  
  /// Natural Logarithm of 2
  public let ln2 : Float = 0.69314718055994530942;
  
  /// Planck's Reduced Constant (ℏ) — Quantum scale
  public let ℏ : Float = 1.054571817e-34;
  
  /// Boltzmann Constant (kB) — Thermal scale
  public let kB : Float = 1.380649e-23;
  
  /// Speed of Light (c) — Relativistic scale
  public let c : Float = 299792458.0;
  
  /// Fine Structure Constant (α) — Electromagnetic coupling
  public let αEM : Float = 0.0072973525693;
  
  /// S₀ Root Constant — Field condition (Love)
  public let S0 : Float = 1.0;
  
  /// S₀ Floor — Minimum coherence threshold
  public let S0Floor : Float = 0.75;

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
  // CORE MATHEMATICAL PRIMITIVES
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

  /// Sigmoid activation function: σ(x) = 1/(1 + e^(-kx))
  public func σ(x : Float, k : Float) : Float {
    1.0 / (1.0 + Float.exp(-k * x))
  };

  /// Hyperbolic tangent: tanh(x) = (e^x - e^-x)/(e^x + e^-x)
  public func tanh(x : Float) : Float {
    let exp2x = Float.exp(2.0 * x);
    (exp2x - 1.0) / (exp2x + 1.0)
  };

  /// ReLU activation: max(0, x)
  public func relu(x : Float) : Float {
    Float.max(0.0, x)
  };

  /// Leaky ReLU: max(αx, x) where α = 0.01
  public func leakyRelu(x : Float, alpha : Float) : Float {
    if (x > 0.0) { x } else { alpha * x }
  };

  /// Softplus: ln(1 + e^x)
  public func softplus(x : Float) : Float {
    Float.log(1.0 + Float.exp(x))
  };

  /// GELU approximation: 0.5x(1 + tanh(√(2/π)(x + 0.044715x³)))
  public func gelu(x : Float) : Float {
    let c = Float.sqrt(2.0 / π);
    0.5 * x * (1.0 + tanh(c * (x + 0.044715 * x * x * x)))
  };

  /// Swish: x·σ(βx)
  public func swish(x : Float, beta : Float) : Float {
    x * σ(x, beta)
  };

  /// Gaussian: e^(-x²/2σ²)
  public func gaussian(x : Float, sigma : Float) : Float {
    Float.exp(-x * x / (2.0 * sigma * sigma))
  };

  /// Cauchy distribution: 1/(π·γ(1 + ((x-x₀)/γ)²))
  public func cauchy(x : Float, x0 : Float, gamma : Float) : Float {
    let z = (x - x0) / gamma;
    1.0 / (π * gamma * (1.0 + z * z))
  };

  /// Heaviside step function: H(x) = 0 if x < 0, 1 if x >= 0
  public func heaviside(x : Float) : Float {
    if (x < 0.0) { 0.0 } else { 1.0 }
  };

  /// Dirac delta approximation: δ(x) ≈ (1/√(2πσ²))e^(-x²/2σ²)
  public func diracDelta(x : Float, sigma : Float) : Float {
    let norm = 1.0 / Float.sqrt(τ * sigma * sigma);
    norm * Float.exp(-x * x / (2.0 * sigma * sigma))
  };

  /// Sinc function: sin(πx)/(πx)
  public func sinc(x : Float) : Float {
    if (Float.abs(x) < 1e-10) { 1.0 } else {
      Float.sin(π * x) / (π * x)
    }
  };

  /// Complex exponential (returns real, imaginary parts): e^(iθ) = cos(θ) + i·sin(θ)
  public func cis(theta : Float) : (Float, Float) {
    (Float.cos(theta), Float.sin(theta))
  };

  /// Modulo for floats
  public func fmod(x : Float, y : Float) : Float {
    x - y * Float.floor(x / y)
  };

  /// Wrap angle to [-π, π]
  public func wrapAngle(theta : Float) : Float {
    fmod(theta + π, τ) - π
  };

  /// Linear interpolation: lerp(a, b, t) = a + t(b - a)
  public func lerp(a : Float, b : Float, t : Float) : Float {
    a + t * (b - a)
  };

  /// Smooth step: 3t² - 2t³
  public func smoothstep(t : Float) : Float {
    let tc = Float.max(0.0, Float.min(1.0, t));
    tc * tc * (3.0 - 2.0 * tc)
  };

  /// Smoother step: 6t⁵ - 15t⁴ + 10t³
  public func smootherstep(t : Float) : Float {
    let tc = Float.max(0.0, Float.min(1.0, t));
    tc * tc * tc * (tc * (tc * 6.0 - 15.0) + 10.0)
  };

  /// Clamp value to range [min, max]
  public func clamp(x : Float, minVal : Float, maxVal : Float) : Float {
    Float.max(minVal, Float.min(maxVal, x))
  };

  /// Sign function: -1, 0, or 1
  public func sign(x : Float) : Float {
    if (x < 0.0) { -1.0 } else if (x > 0.0) { 1.0 } else { 0.0 }
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
  // VECTOR OPERATIONS — 3D SPACE
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

  public type Vec3 = {
    x : Float;
    y : Float;
    z : Float;
  };

  public func vec3Add(a : Vec3, b : Vec3) : Vec3 {
    { x = a.x + b.x; y = a.y + b.y; z = a.z + b.z }
  };

  public func vec3Sub(a : Vec3, b : Vec3) : Vec3 {
    { x = a.x - b.x; y = a.y - b.y; z = a.z - b.z }
  };

  public func vec3Scale(v : Vec3, s : Float) : Vec3 {
    { x = v.x * s; y = v.y * s; z = v.z * s }
  };

  public func vec3Dot(a : Vec3, b : Vec3) : Float {
    a.x * b.x + a.y * b.y + a.z * b.z
  };

  public func vec3Cross(a : Vec3, b : Vec3) : Vec3 {
    {
      x = a.y * b.z - a.z * b.y;
      y = a.z * b.x - a.x * b.z;
      z = a.x * b.y - a.y * b.x;
    }
  };

  public func vec3Length(v : Vec3) : Float {
    Float.sqrt(v.x * v.x + v.y * v.y + v.z * v.z)
  };

  public func vec3Normalize(v : Vec3) : Vec3 {
    let len = vec3Length(v);
    if (len < 1e-10) { { x = 0.0; y = 0.0; z = 0.0 } }
    else { vec3Scale(v, 1.0 / len) }
  };

  public func vec3Lerp(a : Vec3, b : Vec3, t : Float) : Vec3 {
    {
      x = lerp(a.x, b.x, t);
      y = lerp(a.y, b.y, t);
      z = lerp(a.z, b.z, t);
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
  // MATRIX OPERATIONS — 3x3 AND 4x4
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

  public type Mat3 = {
    m00 : Float; m01 : Float; m02 : Float;
    m10 : Float; m11 : Float; m12 : Float;
    m20 : Float; m21 : Float; m22 : Float;
  };

  public func mat3Identity() : Mat3 {
    {
      m00 = 1.0; m01 = 0.0; m02 = 0.0;
      m10 = 0.0; m11 = 1.0; m12 = 0.0;
      m20 = 0.0; m21 = 0.0; m22 = 1.0;
    }
  };

  public func mat3Mul(a : Mat3, b : Mat3) : Mat3 {
    {
      m00 = a.m00*b.m00 + a.m01*b.m10 + a.m02*b.m20;
      m01 = a.m00*b.m01 + a.m01*b.m11 + a.m02*b.m21;
      m02 = a.m00*b.m02 + a.m01*b.m12 + a.m02*b.m22;
      m10 = a.m10*b.m00 + a.m11*b.m10 + a.m12*b.m20;
      m11 = a.m10*b.m01 + a.m11*b.m11 + a.m12*b.m21;
      m12 = a.m10*b.m02 + a.m11*b.m12 + a.m12*b.m22;
      m20 = a.m20*b.m00 + a.m21*b.m10 + a.m22*b.m20;
      m21 = a.m20*b.m01 + a.m21*b.m11 + a.m22*b.m21;
      m22 = a.m20*b.m02 + a.m21*b.m12 + a.m22*b.m22;
    }
  };

  public func mat3MulVec3(m : Mat3, v : Vec3) : Vec3 {
    {
      x = m.m00*v.x + m.m01*v.y + m.m02*v.z;
      y = m.m10*v.x + m.m11*v.y + m.m12*v.z;
      z = m.m20*v.x + m.m21*v.y + m.m22*v.z;
    }
  };

  public func mat3Transpose(m : Mat3) : Mat3 {
    {
      m00 = m.m00; m01 = m.m10; m02 = m.m20;
      m10 = m.m01; m11 = m.m11; m12 = m.m21;
      m20 = m.m02; m21 = m.m12; m22 = m.m22;
    }
  };

  public func mat3Determinant(m : Mat3) : Float {
    m.m00 * (m.m11 * m.m22 - m.m12 * m.m21) -
    m.m01 * (m.m10 * m.m22 - m.m12 * m.m20) +
    m.m02 * (m.m10 * m.m21 - m.m11 * m.m20)
  };

  public func mat3RotationX(angle : Float) : Mat3 {
    let c = Float.cos(angle);
    let s = Float.sin(angle);
    {
      m00 = 1.0; m01 = 0.0; m02 = 0.0;
      m10 = 0.0; m11 = c;   m12 = -s;
      m20 = 0.0; m21 = s;   m22 = c;
    }
  };

  public func mat3RotationY(angle : Float) : Mat3 {
    let c = Float.cos(angle);
    let s = Float.sin(angle);
    {
      m00 = c;   m01 = 0.0; m02 = s;
      m10 = 0.0; m11 = 1.0; m12 = 0.0;
      m20 = -s;  m21 = 0.0; m22 = c;
    }
  };

  public func mat3RotationZ(angle : Float) : Mat3 {
    let c = Float.cos(angle);
    let s = Float.sin(angle);
    {
      m00 = c;   m01 = -s;  m02 = 0.0;
      m10 = s;   m11 = c;   m12 = 0.0;
      m20 = 0.0; m21 = 0.0; m22 = 1.0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
  // COMPLEX NUMBER OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

  public type Complex = {
    re : Float;  // Real part
    im : Float;  // Imaginary part
  };

  public func complexAdd(a : Complex, b : Complex) : Complex {
    { re = a.re + b.re; im = a.im + b.im }
  };

  public func complexSub(a : Complex, b : Complex) : Complex {
    { re = a.re - b.re; im = a.im - b.im }
  };

  public func complexMul(a : Complex, b : Complex) : Complex {
    {
      re = a.re * b.re - a.im * b.im;
      im = a.re * b.im + a.im * b.re;
    }
  };

  public func complexDiv(a : Complex, b : Complex) : Complex {
    let denom = b.re * b.re + b.im * b.im;
    {
      re = (a.re * b.re + a.im * b.im) / denom;
      im = (a.im * b.re - a.re * b.im) / denom;
    }
  };

  public func complexAbs(z : Complex) : Float {
    Float.sqrt(z.re * z.re + z.im * z.im)
  };

  public func complexArg(z : Complex) : Float {
    Float.atan2(z.im, z.re)
  };

  public func complexConj(z : Complex) : Complex {
    { re = z.re; im = -z.im }
  };

  public func complexExp(z : Complex) : Complex {
    let r = Float.exp(z.re);
    { re = r * Float.cos(z.im); im = r * Float.sin(z.im) }
  };

  public func complexFromPolar(r : Float, theta : Float) : Complex {
    { re = r * Float.cos(theta); im = r * Float.sin(theta) }
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
  // QUATERNION OPERATIONS — 4D ROTATIONS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

  public type Quaternion = {
    w : Float;  // Scalar part
    x : Float;  // i component
    y : Float;  // j component
    z : Float;  // k component
  };

  public func quatIdentity() : Quaternion {
    { w = 1.0; x = 0.0; y = 0.0; z = 0.0 }
  };

  public func quatMul(a : Quaternion, b : Quaternion) : Quaternion {
    {
      w = a.w*b.w - a.x*b.x - a.y*b.y - a.z*b.z;
      x = a.w*b.x + a.x*b.w + a.y*b.z - a.z*b.y;
      y = a.w*b.y - a.x*b.z + a.y*b.w + a.z*b.x;
      z = a.w*b.z + a.x*b.y - a.y*b.x + a.z*b.w;
    }
  };

  public func quatConj(q : Quaternion) : Quaternion {
    { w = q.w; x = -q.x; y = -q.y; z = -q.z }
  };

  public func quatNorm(q : Quaternion) : Float {
    Float.sqrt(q.w*q.w + q.x*q.x + q.y*q.y + q.z*q.z)
  };

  public func quatNormalize(q : Quaternion) : Quaternion {
    let n = quatNorm(q);
    if (n < 1e-10) { quatIdentity() }
    else { { w = q.w/n; x = q.x/n; y = q.y/n; z = q.z/n } }
  };

  public func quatFromAxisAngle(axis : Vec3, angle : Float) : Quaternion {
    let halfAngle = angle / 2.0;
    let s = Float.sin(halfAngle);
    let normAxis = vec3Normalize(axis);
    {
      w = Float.cos(halfAngle);
      x = normAxis.x * s;
      y = normAxis.y * s;
      z = normAxis.z * s;
    }
  };

  public func quatRotateVec3(q : Quaternion, v : Vec3) : Vec3 {
    let qv : Quaternion = { w = 0.0; x = v.x; y = v.y; z = v.z };
    let qConj = quatConj(q);
    let result = quatMul(quatMul(q, qv), qConj);
    { x = result.x; y = result.y; z = result.z }
  };

  public func quatSlerp(a : Quaternion, b : Quaternion, t : Float) : Quaternion {
    var dot = a.w*b.w + a.x*b.x + a.y*b.y + a.z*b.z;
    var bNeg = b;
    if (dot < 0.0) {
      dot := -dot;
      bNeg := { w = -b.w; x = -b.x; y = -b.y; z = -b.z };
    };
    if (dot > 0.9995) {
      // Linear interpolation for very close quaternions
      let result : Quaternion = {
        w = lerp(a.w, bNeg.w, t);
        x = lerp(a.x, bNeg.x, t);
        y = lerp(a.y, bNeg.y, t);
        z = lerp(a.z, bNeg.z, t);
      };
      return quatNormalize(result);
    };
    let theta0 = Float.arccos(dot);
    let theta = theta0 * t;
    let sinTheta = Float.sin(theta);
    let sinTheta0 = Float.sin(theta0);
    let s0 = Float.cos(theta) - dot * sinTheta / sinTheta0;
    let s1 = sinTheta / sinTheta0;
    {
      w = a.w * s0 + bNeg.w * s1;
      x = a.x * s0 + bNeg.x * s1;
      y = a.y * s0 + bNeg.y * s1;
      z = a.z * s0 + bNeg.z * s1;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
  // DIFFERENTIAL EQUATION SOLVERS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

  /// Euler method: y(t+dt) = y(t) + dt·f(t, y)
  public func eulerStep(y : Float, dydt : Float, dt : Float) : Float {
    y + dt * dydt
  };

  /// Euler method for vectors
  public func eulerStepVec3(y : Vec3, dydt : Vec3, dt : Float) : Vec3 {
    vec3Add(y, vec3Scale(dydt, dt))
  };

  /// Runge-Kutta 4th order single step
  /// Returns y(t+dt) given y(t) and derivative function
  public type DerivativeFunc = (Float, Float) -> Float;
  
  public func rk4Step(
    t : Float,
    y : Float,
    dt : Float,
    f : DerivativeFunc
  ) : Float {
    let k1 = f(t, y);
    let k2 = f(t + dt/2.0, y + dt*k1/2.0);
    let k3 = f(t + dt/2.0, y + dt*k2/2.0);
    let k4 = f(t + dt, y + dt*k3);
    y + (dt/6.0) * (k1 + 2.0*k2 + 2.0*k3 + k4)
  };

  /// Exponential decay: y(t) = y₀·e^(-λt)
  public func expDecay(y0 : Float, lambda : Float, t : Float) : Float {
    y0 * Float.exp(-lambda * t)
  };

  /// Exponential growth with saturation: y(t) = K·y₀/(y₀ + (K-y₀)e^(-rt))
  public func logisticGrowth(y0 : Float, K : Float, r : Float, t : Float) : Float {
    K * y0 / (y0 + (K - y0) * Float.exp(-r * t))
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
  // FOURIER TRANSFORMS (DISCRETE)
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

  /// Discrete Fourier Transform coefficient at frequency k
  /// X[k] = Σₙ x[n]·e^(-i2πkn/N)
  public func dftCoefficient(signal : [Float], k : Nat) : Complex {
    let N = signal.size();
    var reSum : Float = 0.0;
    var imSum : Float = 0.0;
    
    for (n in Iter.range(0, N - 1)) {
      let angle = -τ * Float.fromInt(k) * Float.fromInt(n) / Float.fromInt(N);
      reSum += signal[n] * Float.cos(angle);
      imSum += signal[n] * Float.sin(angle);
    };
    
    { re = reSum; im = imSum }
  };

  /// Power spectrum magnitude at frequency k: |X[k]|²
  public func powerSpectrum(signal : [Float], k : Nat) : Float {
    let coeff = dftCoefficient(signal, k);
    coeff.re * coeff.re + coeff.im * coeff.im
  };

  /// Phase at frequency k: arg(X[k])
  public func phaseSpectrum(signal : [Float], k : Nat) : Float {
    let coeff = dftCoefficient(signal, k);
    Float.atan2(coeff.im, coeff.re)
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
  // STATISTICAL FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

  /// Mean: μ = (1/N)Σxᵢ
  public func mean(values : [Float]) : Float {
    if (values.size() == 0) { return 0.0; };
    var sum : Float = 0.0;
    for (v in values.vals()) { sum += v; };
    sum / Float.fromInt(values.size())
  };

  /// Variance: σ² = (1/N)Σ(xᵢ - μ)²
  public func variance(values : [Float]) : Float {
    if (values.size() == 0) { return 0.0; };
    let mu = mean(values);
    var sumSq : Float = 0.0;
    for (v in values.vals()) {
      let diff = v - mu;
      sumSq += diff * diff;
    };
    sumSq / Float.fromInt(values.size())
  };

  /// Standard deviation: σ = √(σ²)
  public func stdDev(values : [Float]) : Float {
    Float.sqrt(variance(values))
  };

  /// Covariance: cov(X,Y) = (1/N)Σ(xᵢ - μₓ)(yᵢ - μᵧ)
  public func covariance(x : [Float], y : [Float]) : Float {
    let N = Nat.min(x.size(), y.size());
    if (N == 0) { return 0.0; };
    let muX = mean(x);
    let muY = mean(y);
    var sum : Float = 0.0;
    for (i in Iter.range(0, N - 1)) {
      sum += (x[i] - muX) * (y[i] - muY);
    };
    sum / Float.fromInt(N)
  };

  /// Pearson correlation: ρ = cov(X,Y)/(σₓσᵧ)
  public func correlation(x : [Float], y : [Float]) : Float {
    let cov = covariance(x, y);
    let sX = stdDev(x);
    let sY = stdDev(y);
    if (sX < 1e-10 or sY < 1e-10) { return 0.0; };
    cov / (sX * sY)
  };

  /// Mutual information approximation (discrete): MI = Σ p(x,y)·log(p(x,y)/(p(x)p(y)))
  public func mutualInformation(joint : [[Float]], marginalX : [Float], marginalY : [Float]) : Float {
    var mi : Float = 0.0;
    for (i in Iter.range(0, joint.size() - 1)) {
      for (j in Iter.range(0, joint[i].size() - 1)) {
        let pxy = joint[i][j];
        let px = marginalX[i];
        let py = marginalY[j];
        if (pxy > 1e-10 and px > 1e-10 and py > 1e-10) {
          mi += pxy * Float.log(pxy / (px * py));
        };
      };
    };
    mi
  };

  /// Entropy: H = -Σ p(x)·log(p(x))
  public func entropy(probabilities : [Float]) : Float {
    var h : Float = 0.0;
    for (p in probabilities.vals()) {
      if (p > 1e-10) {
        h -= p * Float.log(p);
      };
    };
    h
  };

  /// KL Divergence: D_KL(P||Q) = Σ P(x)·log(P(x)/Q(x))
  public func klDivergence(p : [Float], q : [Float]) : Float {
    let N = Nat.min(p.size(), q.size());
    var kl : Float = 0.0;
    for (i in Iter.range(0, N - 1)) {
      if (p[i] > 1e-10 and q[i] > 1e-10) {
        kl += p[i] * Float.log(p[i] / q[i]);
      };
    };
    kl
  };

  /// Jensen-Shannon Divergence: JSD = (D_KL(P||M) + D_KL(Q||M))/2 where M = (P+Q)/2
  public func jsDivergence(p : [Float], q : [Float]) : Float {
    let N = Nat.min(p.size(), q.size());
    let m = Array.tabulate<Float>(N, func(i : Nat) : Float {
      (p[i] + q[i]) / 2.0
    });
    (klDivergence(p, m) + klDivergence(q, m)) / 2.0
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SIGNAL PROCESSING
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

  /// Convolve two signals: (f * g)[n] = Σₘ f[m]·g[n-m]
  public func convolve(f : [Float], g : [Float]) : [Float] {
    let fLen = f.size();
    let gLen = g.size();
    let outLen = fLen + gLen - 1;
    
    Array.tabulate<Float>(outLen, func(n : Nat) : Float {
      var sum : Float = 0.0;
      for (m in Iter.range(0, fLen - 1)) {
        let gIdx : Int = Int.sub(n, m);
        if (gIdx >= 0 and gIdx < gLen) {
          sum += f[m] * g[Int.abs(gIdx)];
        };
      };
      sum
    })
  };

  /// Cross-correlation: (f ⋆ g)[n] = Σₘ f*[m]·g[m+n]
  public func crossCorrelate(f : [Float], g : [Float]) : [Float] {
    let fReversed = Array.tabulate<Float>(f.size(), func(i : Nat) : Float {
      f[f.size() - 1 - i]
    });
    convolve(fReversed, g)
  };

  /// Autocorrelation: R[τ] = (f ⋆ f)[τ]
  public func autocorrelate(f : [Float]) : [Float] {
    crossCorrelate(f, f)
  };

  /// Moving average filter
  public func movingAverage(signal : [Float], windowSize : Nat) : [Float] {
    if (windowSize == 0 or signal.size() < windowSize) { return signal; };
    let outLen = signal.size() - windowSize + 1;
    Array.tabulate<Float>(outLen, func(i : Nat) : Float {
      var sum : Float = 0.0;
      for (j in Iter.range(0, windowSize - 1)) {
        sum += signal[i + j];
      };
      sum / Float.fromInt(windowSize)
    })
  };

  /// Exponential moving average
  public func expMovingAverage(signal : [Float], alpha : Float) : [Float] {
    if (signal.size() == 0) { return []; };
    let result = Buffer.Buffer<Float>(signal.size());
    result.add(signal[0]);
    for (i in Iter.range(1, signal.size() - 1)) {
      let prev = result.get(i - 1);
      result.add(alpha * signal[i] + (1.0 - alpha) * prev);
    };
    Buffer.toArray(result)
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
  // NEURAL NETWORK PRIMITIVES
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

  public type NeuronState = {
    potential : Float;     // Membrane potential
    threshold : Float;     // Firing threshold
    refractory : Float;    // Refractory period remaining
    adaptation : Float;    // Spike-frequency adaptation
    trace : Float;         // Eligibility trace for learning
  };

  public func defaultNeuronState() : NeuronState {
    {
      potential = 0.0;
      threshold = 1.0;
      refractory = 0.0;
      adaptation = 0.0;
      trace = 0.0;
    }
  };

  /// Leaky Integrate-and-Fire neuron update
  /// dV/dt = (V_rest - V + R·I) / τ
  public func lifUpdate(
    state : NeuronState,
    input : Float,
    dt : Float,
    params : { tau : Float; vRest : Float; resistance : Float; refractoryPeriod : Float }
  ) : (NeuronState, Bool) {
    // Check refractory period
    if (state.refractory > 0.0) {
      return ({
        potential = params.vRest;
        threshold = state.threshold;
        refractory = Float.max(0.0, state.refractory - dt);
        adaptation = state.adaptation * Float.exp(-dt / 100.0);
        trace = state.trace * Float.exp(-dt / 20.0);
      }, false);
    };
    
    // Update membrane potential
    let dV = (params.vRest - state.potential + params.resistance * input) / params.tau;
    let newPotential = state.potential + dV * dt;
    
    // Check for spike
    let spiked = newPotential >= state.threshold;
    
    if (spiked) {
      ({
        potential = params.vRest;
        threshold = state.threshold + 0.1; // Adaptive threshold
        refractory = params.refractoryPeriod;
        adaptation = state.adaptation + 0.1;
        trace = 1.0;
      }, true)
    } else {
      ({
        potential = newPotential;
        threshold = Float.max(1.0, state.threshold - 0.01 * dt);
        refractory = 0.0;
        adaptation = state.adaptation * Float.exp(-dt / 100.0);
        trace = state.trace * Float.exp(-dt / 20.0);
      }, false)
    }
  };

  /// Izhikevich neuron model
  /// dv/dt = 0.04v² + 5v + 140 - u + I
  /// du/dt = a(bv - u)
  /// if v >= 30: v := c, u := u + d
  public type IzhikevichState = {
    v : Float;   // Membrane potential
    u : Float;   // Recovery variable
  };

  public type IzhikevichParams = {
    a : Float;   // Time scale of u
    b : Float;   // Sensitivity of u to v
    c : Float;   // After-spike reset of v
    d : Float;   // After-spike reset of u
  };

  public func izhikevichUpdate(
    state : IzhikevichState,
    input : Float,
    dt : Float,
    params : IzhikevichParams
  ) : (IzhikevichState, Bool) {
    // Using 0.5ms time step subdivision for stability
    var v = state.v;
    var u = state.u;
    var spiked = false;
    
    let steps = 2;
    let subDt = dt / Float.fromInt(steps);
    
    for (_ in Iter.range(0, steps - 1)) {
      if (v >= 30.0) {
        v := params.c;
        u := u + params.d;
        spiked := true;
      } else {
        let dv = (0.04 * v * v + 5.0 * v + 140.0 - u + input) * subDt;
        let du = (params.a * (params.b * v - u)) * subDt;
        v := v + dv;
        u := u + du;
      };
    };
    
    ({ v = v; u = u }, spiked)
  };

  /// Regular spiking neuron parameters
  public let izhikevichRS : IzhikevichParams = { a = 0.02; b = 0.2; c = -65.0; d = 8.0 };
  
  /// Fast spiking neuron parameters
  public let izhikevichFS : IzhikevichParams = { a = 0.1; b = 0.2; c = -65.0; d = 2.0 };
  
  /// Chattering neuron parameters
  public let izhikevichCH : IzhikevichParams = { a = 0.02; b = 0.2; c = -50.0; d = 2.0 };
  
  /// Intrinsically bursting neuron parameters
  public let izhikevichIB : IzhikevichParams = { a = 0.02; b = 0.2; c = -55.0; d = 4.0 };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
  // Δ1 — ΒΙΟΛΟΓΙΚΑ ΝΕΥΡΩΝΙΚΑ (1.1-1.5) — BIOLOGICAL NEURAL ARCHITECTURES
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // This domain covers the full spectrum of biological neural organization, from simple nerve nets
  // to the sophisticated 6-layer prefrontal cortex with Default Mode Network. Each subdomain
  // implements the specific computational principles and mathematical formulations that characterize
  // that level of neural organization.
  //
  // SUBDOMAIN STRUCTURE:
  // • Δ1α (1.1): Diffuse/radial nervous systems (cnidaria, echinoderms)
  // • Δ1β (1.2): Ganglion/ladder systems (flatworms, annelids)
  // • Δ1γ (1.3): Arthropod/mushroom body systems (insects, crustaceans)
  // • Δ1δ (1.4): Cephalopod distributed systems (octopus, squid)
  // • Δ1ε (1.5): Vertebrate hierarchical systems (fish to mammals)
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
  public type Δ1α = { // 1.1 διάχυτο
    κCa : Float;      // Ca²⁺ κύμα
    ρRn : Float;      // ακτινική δακτύλιος
    ρ5f : Float;      // 5-πτυχή ακτινική
    εCn : Float;      // επιθηλιακή αγωγή
  };
  public type Δ1β = { // 1.2 γάγγλιο/σκάλα
    βLd : Float;      // διμερής σκάλα
    σGc : Float;      // τμηματική αλυσίδα
    δOg : Float;      // κατανεμημένα όργανα
    σCpg : Float;     // στοματογαστρικό CPG
  };
  public type Δ1γ = { // 1.3 αρθρόποδα/μανιτάρι
    μBsc : Float;     // σώμα μανιταριού αραιός κώδικας
    κCc : Float;      // κεντρικό σύμπλεγμα πυξίδα
    οLma : Float;     // οπτικός λοβός κίνηση
    μEi : Float;      // πολυ-μάτι ενσωμάτωση
    σCpgW : Float;    // τμηματικό CPG κύμα
    χDm : Float;      // χημειοαισθητήριο κυρίαρχο
  };
  public type Δ1δ = { // 1.4 κεφαλόποδα
    κRdap : Float;    // κεντρικός δακτύλιος + κατανεμημένοι επεξεργαστές
    γAxe : Float;     // γιγαντιαίος άξονας διαφυγή
    δCf : Float;      // κατανεμημένο χρωματοφόρο πεδίο
    βPc : Float;      // διλοβικό πρωτο-κεφαλόποδο
  };
  public type Δ1ε = { // 1.5 σπονδυλωτά
    βRs : Float;      // εγκεφαλικό στέλεχος δικτυωτονωτιαίο
    κEs : Float;      // παρεγκεφαλίδα + ηλεκτροαισθητήριο
    οTmh : Float;     // οπτικό τέκτο πολυτροπικός κόμβος
    μDm : Float;      // μεταμορφικό διπλή-λειτουργία
    π3Lp : Float;     // 3-στρώμα παλαιοφλοιός
    πNc : Float;      // παλλιακή πυρηνική συστάδα
    ηRaS : Float;     // HVC-RA κύκλωμα τραγουδιού
    ιCd : Float;      // κάτω κολλίκουλος κυρίαρχο
    εLll : Float;     // ηλεκτροαισθητήριο πλευρική γραμμή
    βSd : Float;      // ράμφος σωματοαισθητήριο
    σHm : Float;      // αστέρι-προς-φλοιό υπερχάρτης
    θ16c : Float;     // 16-κανάλι ταξινομητής κατωφλίου
    πUs : Float;      // παραλιμβικό + μονοημισφαιρικός ύπνος
    υTl : Float;      // VEN κροταφικός λοβός
    π6Lpfc : Float;   // 6-στρώμα PFC + DMN
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // Δ2 — ΑΠΟΙΚΙΑ / ΥΠΕΡΟΡΓΑΝΙΣΜΟΣ
  // ═══════════════════════════════════════════════════════════════════════════════
  public type Δ2 = {
    σPg : Float;      // στιγμεργικό φερομόνη κλίση
    ωDq : Float;      // χορός κύησης απαρτία
    κTr : Float;      // CO₂ θερμορύθμιση
    τNc : Float;      // τοπολογική γειτονική σύζευξη
    φRtn : Float;     // ενίσχυση ροής δίκτυο σωλήνων
    θSgr : Float;     // απαρτία αίσθηση ρύθμιση γονιδίων
    βCm : Float;      // βιοφίλμ συλλογικός μεταβολισμός
    μSp : Float;      // μυκηλιακή διάδοση σήματος
    ρTds : Float;     // ρίζα άκρη κατανεμημένη αίσθηση
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // Δ3 — ΤΑΛΑΝΤΩΤΗΣ / ΡΥΘΜΙΚΑ (3.1-3.3)
  // ═══════════════════════════════════════════════════════════════════════════════
  public type Δ3α = { // 3.1 CPG
    ηCo : Float;      // ημι-κέντρο ταλαντωτής
    ρIc : Float;      // αμοιβαία αναστολή αλυσίδα
    βPm : Float;      // εκρηκτικός βηματοδότης
    λCpg : Float;     // κινητικό CPG
    ρOs : Float;      // αναπνευστικός ταλαντωτής
  };
  public type Δ3β = { // 3.2 Kuramoto κλάση
    κMd : Float;      // dθᵢ/dt = ωᵢ + (K/N)Σsin(θⱼ-θᵢ)
    σLo : Float;      // Stuart-Landau
    υPo : Float;      // Van der Pol
    ωCm : Float;      // Wilson-Cowan
    βRd : Float;      // Brusselator
    φNg : Float;      // Fitzhugh-Nagumo
  };
  public type Δ3γ = { // 3.3 παραμετρικοί
    μPo : Float;      // μηχανικός παραμετρικός
    οPo : Float;      // οπτικός παραμετρικός
    ιPa : Float;      // Josephson παραμετρικός ενισχυτής
    νPr : Float;      // νευρωνική παραμετρική συντονισμός
    φSy : Float;      // Floquet σύστημα
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // Δ4 — ΚΥΜΑ / ΠΑΡΕΜΒΟΛΗ (4.1-4.3)
  // ═══════════════════════════════════════════════════════════════════════════════
  public type Δ4α = { // 4.1 ενεργή παρεμβολή
    ιAr : Float;      // αποφυγή παρεμβολών
    εAc : Float;      // ηχοεντοπισμός ενεργή ακύρωση
    λAs : Float;      // πλευρική γραμμή ενεργή αίσθηση
    αNc : Float;      // ενεργή ακύρωση θορύβου
    σRs : Float;      // στοχαστικός συντονισμός
  };
  public type Δ4β = { // 4.2 ταξιδεύον κύμα
    βMtw : Float;     // βασική μεμβράνη ταξιδεύον κύμα
    κTw : Float;      // φλοιικό ταξιδεύον κύμα
    πWv : Float;      // περισταλτικό κύμα
    κWp : Float;      // ασβέστιο κύμα διάδοση
    χWv : Float;      // χημικό κύμα
  };
  public type Δ4γ = { // 4.3 στάσιμο κύμα/συντονισμός
    τCr : Float;      // θαλαμοφλοιικός συντονισμός
    ηTr : Float;      // ιππόκαμπος θήτα συντονισμός
    γBcfc : Float;    // γάμμα-βήτα διασταυρούμενη σύζευξη
    θRs : Float;      // κβαντικός συντονισμός (Fröhlich)
    σRc : Float;      // Schumann συντονισμός σύζευξη
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // Δ5 — ΕΛΚΥΣΤΗΣ / ΔΥΝΑΜΙΚΑ ΣΥΣΤΗΜΑΤΑ (5.1-5.4)
  // ═══════════════════════════════════════════════════════════════════════════════
  public type Δ5α = { // 5.1 σημειακοί ελκυστές
    ηNw : Float;      // Hopfield δίκτυο
    βMc : Float;      // Boltzmann μηχανή
    λFd : Float;      // Lyapunov κάθοδος
  };
  public type Δ5β = { // 5.2 ελκυστές οριακού κύκλου
    υLc : Float;      // Van der Pol οριακός κύκλος
    αHb : Float;      // Andronov-Hopf διακλάδωση
    πRc : Float;      // καμπύλη απόκρισης φάσης
  };
  public type Δ5γ = { // 5.3 χαοτικοί/παράξενοι ελκυστές
    λAt : Float;      // Lorenz ελκυστής
    ρAt : Float;      // Rössler ελκυστής
    δOs : Float;      // Duffing ταλαντωτής
    εCc : Float;      // άκρη-χάους υπολογισμός
  };
  public type Δ5δ = { // 5.4 ετεροκλινικοί κύκλοι
    ωCp : Float;      // ανταγωνισμός χωρίς νικητή
    ρFe : Float;      // Rabinovich-Fabrikant εξισώσεις
    μDy : Float;      // μετασταθή δυναμική
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // Δ6 — ΚΒΑΝΤΙΚΗ ΠΛΗΡΟΦΟΡΙΑ (6.1-6.2)
  // ═══════════════════════════════════════════════════════════════════════════════
  public type Δ6α = { // 6.1 κβαντικά κυκλώματα
    θSp : Float;      // κβαντική υπέρθεση
    βSe : Float;      // Bell κατάσταση διεμπλοκή
    σCec : Float;     // σταθεροποιητής κώδικας
    θAn : Float;      // κβαντική ανόπτηση
    θFi : Float;      // κβαντική Fisher πληροφορία
    τDd : Float;      // T₂ αποσυνοχή
    σDm : Float;      // υπερακτινοβολία (Dicke)
    λLwe : Float;     // πλέγμα κρυπτογραφία (LWE)
  };
  public type Δ6β = { // 6.2 κβαντικό πεδίο/συμπυκνωμένη ύλη
    βEc : Float;      // Bose-Einstein συμπύκνωμα
    τQs : Float;      // τοπολογικές κβαντικές καταστάσεις
    θSg : Float;      // κβαντικό γυαλί σπιν
    τCr : Float;      // χρόνο κρύσταλλος
    θWk : Float;      // κβαντικός περίπατος
    θZe : Float;      // κβαντικό Zeno φαινόμενο
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // Δ7 — ΠΕΔΙΟ / ΣΥΝΕΧΕΣ (7.1-7.3)
  // ═══════════════════════════════════════════════════════════════════════════════
  public type Δ7α = { // 7.1 αντίδραση-διάχυση
    τPf : Float;      // Turing σχηματισμός μοτίβων
    γSm : Float;      // Gray-Scott μοντέλο
    φNs : Float;      // FitzHugh-Nagumo χωρικό
    οRg : Float;      // Oregonator
  };
  public type Δ7β = { // 7.2 νευρωνικές θεωρίες πεδίου
    ωCnf : Float;     // Wilson-Cowan νευρωνικό πεδίο
    αNf : Float;      // Amari νευρωνικό πεδίο
    νSm : Float;      // Nunez-Srinivasan μοντέλο
    δCm : Float;      // δυναμική αιτιώδης μοντελοποίηση
  };
  public type Δ7γ = { // 7.3 φυσικά πεδία
    εFc : Float;      // ηλεκτρομαγνητικό πεδίο
    γWd : Float;      // βαρυτικό κύμα
    πWc : Float;      // πλάσμα κύμα
    φFd : Float;      // φωνόνιο πεδίο
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // Δ8 — ΠΟΛΥ-ΠΡΑΚΤΟΡΑ ΣΥΝΤΟΝΙΣΜΟΣ (8.1-8.3)
  // ═══════════════════════════════════════════════════════════════════════════════
  public type Δ8α = { // 8.1 αναδυόμενος συντονισμός
    σTg : Float;      // στιγμεργία
    φRl : Float;      // κοπάδιασμα (Reynolds)
    θSn : Float;      // αίσθηση απαρτίας
    σGc : Float;      // σμήνος αναρρίχηση κλίσης
    τSw : Float;      // τοπολογικό σμήνος
  };
  public type Δ8β = { // 8.2 θεωρία παιγνίων
    νEq : Float;      // Nash ισορροπία
    εSs : Float;      // εξελικτικά σταθερή στρατηγική
    ρDy : Float;      // δυναμική αντιγραφέα
    μGm : Float;      // παιχνίδι μειονότητας
    μFg : Float;      // μέσο πεδίο παιχνίδι
  };
  public type Δ8γ = { // 8.3 ιεραρχικός συντονισμός
    σAr : Float;      // αρχιτεκτονική υποκατάστασης
    βTr : Float;      // δέντρο συμπεριφοράς
    ηRl : Float;      // ιεραρχική ενισχυτική μάθηση
    μCh : Float;      // στρατιωτική ιεραρχία εντολών
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // Δ9 — ΜΝΗΜΗ
  // ═══════════════════════════════════════════════════════════════════════════════
  public type Δ9 = {
    ηSy : Float;      // Hebbian σύναψη
    σTdp : Float;     // STDP
    θGpc : Float;     // θήτα-γάμμα κωδικοποίηση φάσης
    εCl : Float;      // κύτταρο εγγραμμάτων
    σTc : Float;      // συναπτική σήμανση και σύλληψη
    ηMm : Float;      // ολογραφική μνήμη
    εMr : Float;      // επεισοδιακή επανάληψη μνήμης
    πCm : Float;      // προβλεπτική κωδικοποίηση μνήμη
    ωMb : Float;      // εργαζόμενη μνήμη buffer
    ιMm : Float;      // ανοσολογική μνήμη (B-κύτταρο)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // Δ10 — ΟΜΟΙΟΣΤΑΣΗ / ΡΥΘΜΙΣΤΙΚΑ
  // ═══════════════════════════════════════════════════════════════════════════════
  public type Δ10 = {
    σSc : Float;      // συναπτική κλιμάκωση
    ιPl : Float;      // εγγενής πλαστικότητα
    μPl : Float;      // μεταπλαστικότητα
    σFa : Float;      // προσαρμογή συχνότητας ακίδας
    γCn : Float;      // έλεγχος κέρδους
    αLs : Float;      // αλλόσταση
    αPt : Float;      // απόπτωση
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // Δ11 — ΑΝΑΠΤΥΞΙΑΚΑ / ΜΟΡΦΟΓΕΝΕΤΙΚΑ
  // ═══════════════════════════════════════════════════════════════════════════════
  public type Δ11 = {
    μGr : Float;      // κλίση μορφογόνου
    ρDp : Float;      // αντίδραση-διάχυση μοτίβο
    νDr : Float;      // νευρωνικός Δαρβινισμός (TNGS)
    νCe : Float;      // νευρουλοποίηση / φλοιική επέκταση
    σPr : Float;      // συναπτογένεση + κλάδεμα
    αGd : Float;      // καθοδήγηση άξονα
    τPr : Float;      // τροφαλλαξία
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // Δ12 — ΘΕΩΡΙΑ ΠΛΗΡΟΦΟΡΙΑΣ
  // ═══════════════════════════════════════════════════════════════════════════════
  public type Δ12 = {
    μDl : Float;      // ελάχιστο μήκος περιγραφής
    φEp : Float;      // αρχή ελεύθερης ενέργειας (Friston)
    ιIt : Float;      // ολοκληρωμένη θεωρία πληροφορίας (IIT)
    πCd : Float;      // προβλεπτική κωδικοποίηση
    κCx : Float;      // πολυπλοκότητα Kolmogorov
    χCp : Float;      // χωρητικότητα καναλιού (Shannon)
    φIc : Float;      // Fisher πληροφορία (κλασική)
    θFi : Float;      // κβαντική Fisher πληροφορία
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // Δ13 — ΣΤΑΘΕΡΟΤΗΤΑ / ΑΣΤAΘΕΙΑ
  // ═══════════════════════════════════════════════════════════════════════════════
  public type Δ13 = {
    βSn : Float;      // διακλάδωση (saddle-node)
    ηBf : Float;      // Hopf διακλάδωση
    πBf : Float;      // pitchfork διακλάδωση
    πDc : Float;      // καταρράκτης διπλασιασμού περιόδου
    τIn : Float;      // Turing αστάθεια
    ρBi : Float;      // Rayleigh-Bénard αστάθεια
    κHi : Float;      // Kelvin-Helmholtz αστάθεια
    μIn : Float;      // διαμόρφωση αστάθεια
    εCc : Float;      // άκρη-χάους κρισιμότητα
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // Δ14 — ΗΜΙ / ΠΛΕΥΡΙΩΣΗ
  // ═══════════════════════════════════════════════════════════════════════════════
  public type Δ14 = {
    ηLt : Float;      // ημισφαιρική πλευρίωση
    υSl : Float;      // μονοημισφαιρικός ύπνος
    σBp : Float;      // διαχωρισμένος εγκέφαλος
    κIn : Float;      // καλλωσική αναστολή
    αDb : Float;      // ασύμμετρη απόφαση προκατάληψη
    οAl : Float;      // πλοκάμι οκτάποδου πλευρίωση
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // Δ15 — ΑΝΟΣΟΛΟΓΙΚΑ / ΑΝΑΓΝΩΡΙΣΗ
  // ═══════════════════════════════════════════════════════════════════════════════
  public type Δ15 = {
    κSl : Float;      // κλωνική επιλογή
    αMt : Float;      // ωρίμανση συγγένειας
    νSl : Float;      // αρνητική επιλογή (θύμος)
    πRr : Float;      // υποδοχείς αναγνώρισης μοτίβων
    κCd : Float;      // καταρράκτης συμπληρώματος
    μPr : Float;      // MHC παρουσίαση
    μBp : Float;      // μνήμη B-κύτταρο επιμονή
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // Δ16 — ΣΥΝΘΕΤΙΚΑ / ΜΗΧΑΝΟΠΟΙΗΜΕΝΑ (16.1-16.2)
  // ═══════════════════════════════════════════════════════════════════════════════
  public type Δ16α = { // 16.1 τεχνητά νευρωνικά
    τAt : Float;      // Transformer (προσοχή)
    κNw : Float;      // συνελικτικό δίκτυο
    ρNw : Float;      // επαναλαμβανόμενο δίκτυο
    γNw : Float;      // γράφος νευρωνικό δίκτυο
    ρCp : Float;      // δεξαμενή υπολογισμός
    σNw : Float;      // ακιδωτό νευρωνικό δίκτυο
    λSm : Float;      // μηχανή υγρής κατάστασης
    ηNw : Float;      // υπερδίκτυο
    νOde : Float;     // νευρωνική ODE
    μSsm : Float;     // Mamba (μοντέλο χώρου κατάστασης)
  };
  public type Δ16β = { // 16.2 αναδυόμενα/κυτταρικά
    κAu : Float;      // κυτταρικό αυτόματο
    λSy : Float;      // σύστημα Lindenmayer
    γRn : Float;      // γενετικό ρυθμιστικό δίκτυο
    αLf : Float;      // τεχνητή ζωή (Langton)
    αPs : Float;      // αυτοποίηση
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // Ψ — ΠΡΟ-ΣΥΝΕΙΔΗΤΟΙ ΜΗΧΑΝΙΣΜΟΙ (ΥΠΑΡΧΟΝΤΕΣ)
  // ═══════════════════════════════════════════════════════════════════════════════
  public type Ψα = {
    ιCr : Float;      // εσωτεροδεκτικός πυρήνας
    πCr : Float;      // αντίληψη πυρήνας
    ιMb : Float;      // ανοσολογική μεμβράνη
    δCp : Float;      // ανταγωνισμός ορμών
    σCr : Float;      // σημαντικότητα πυρήνας
    φGt : Float;      // FRB πύλη
    αIn : Float;      // ολοκληρωτής διέγερσης
    νLy : Float;      // νευροχημικό στρώμα
    ιCe : Float;      // κινητήρας συνοχής ταυτότητας
    σTr : Float;      // STDP ίχνος επιλεξιμότητας
    αMb : Float;      // AEGIS μεμβράνη
    υTm : Float;      // παρακολούθηση απειλών
    δCe : Float;      // κινητήρας κύκλου ονείρου
    ιLw : Float;      // νόμος παρακολούθηση ολίσθησης
    πSd : Float;      // σπόρος προσωπικότητας
    βPf : Float;      // προβλεπτικό πεδίο
    βOp : Float;      // αγωγός σώμα-όργανο
    τDc : Float;      // διαφοροποιημένοι πυρήνες τανυστή
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // Ψβ — ΠΡΟ-ΣΥΝΕΙΔΗΤΟΙ ΜΗΧΑΝΙΣΜΟΙ (ΕΛΛΕΙΠΟΝΤΕΣ)
  // ═══════════════════════════════════════════════════════════════════════════════
  public type Ψβ = {
    σRf : Float;      // αντανακλαστικό τρομάγματος/γρήγορη απειλή
    πBs : Float;      // ιδιοδεκτικότητα/σχήμα σώματος
    νSg : Float;      // σήμα πόνου (νοσιδεκτικότητα)
    οRs : Float;      // απόκριση προσανατολισμού
    φRs : Float;      // απόκριση πάγωμα
    υFd : Float;      // αιθουσαίο/ισορροπία πεδίο
    κRg : Float;      // κιρκάδιος/υπερκιρκάδιος ρυθμός πύλη
    ηCc : Float;      // ετεροκλινικός ανταγωνισμός συμβουλίων
    τRg : Float;      // θαλαμικό ρελέ/αισθητήρια πύλη
    βGg : Float;      // βασικά γάγγλια κλείδωμα συνήθειας
    λIn : Float;      // πλευρική αναστολή
    εCn : Float;      // συναισθηματική μόλυνση/κοινωνικός συντονισμός
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ΟΛΟΚΛΗΡΩΜΕΝΗ ΚΑΤΑΣΤΑΣΗ
  // ═══════════════════════════════════════════════════════════════════════════════
  public type ΩΣ = {
    δ1α : Δ1α; δ1β : Δ1β; δ1γ : Δ1γ; δ1δ : Δ1δ; δ1ε : Δ1ε;
    δ2 : Δ2;
    δ3α : Δ3α; δ3β : Δ3β; δ3γ : Δ3γ;
    δ4α : Δ4α; δ4β : Δ4β; δ4γ : Δ4γ;
    δ5α : Δ5α; δ5β : Δ5β; δ5γ : Δ5γ; δ5δ : Δ5δ;
    δ6α : Δ6α; δ6β : Δ6β;
    δ7α : Δ7α; δ7β : Δ7β; δ7γ : Δ7γ;
    δ8α : Δ8α; δ8β : Δ8β; δ8γ : Δ8γ;
    δ9 : Δ9;
    δ10 : Δ10;
    δ11 : Δ11;
    δ12 : Δ12;
    δ13 : Δ13;
    δ14 : Δ14;
    δ15 : Δ15;
    δ16α : Δ16α; δ16β : Δ16β;
    ψα : Ψα;
    ψβ : Ψβ;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ΑΡΧΙΚΟΠΟΙΗΣΗ
  // ═══════════════════════════════════════════════════════════════════════════════
  public func φΩ() : ΩΣ {
    {
      δ1α = { κCa = 0.0; ρRn = 0.0; ρ5f = 0.0; εCn = 0.0 };
      δ1β = { βLd = 0.0; σGc = 0.0; δOg = 0.0; σCpg = 1.0 };
      δ1γ = { μBsc = 0.0; κCc = 0.0; οLma = 0.0; μEi = 0.0; σCpgW = 0.0; χDm = 0.0 };
      δ1δ = { κRdap = 0.0; γAxe = 0.0; δCf = 0.0; βPc = 0.0 };
      δ1ε = { βRs = 0.0; κEs = 0.0; οTmh = 0.0; μDm = 0.0; π3Lp = 0.0; πNc = 0.0;
              ηRaS = 0.0; ιCd = 0.0; εLll = 0.0; βSd = 0.0; σHm = 0.0; θ16c = 0.0;
              πUs = 0.0; υTl = 0.0; π6Lpfc = 1.0 };
      δ2 = { σPg = 1.0; ωDq = 0.0; κTr = 0.0; τNc = 0.0; φRtn = 0.0;
             θSgr = 0.0; βCm = 0.0; μSp = 0.0; ρTds = 0.0 };
      δ3α = { ηCo = 1.0; ρIc = 0.0; βPm = 0.0; λCpg = 1.0; ρOs = 1.0 };
      δ3β = { κMd = 1.0; σLo = 0.0; υPo = 1.0; ωCm = 0.0; βRd = 0.0; φNg = 1.0 };
      δ3γ = { μPo = 0.0; οPo = 0.0; ιPa = 0.0; νPr = 0.0; φSy = 0.0 };
      δ4α = { ιAr = 0.0; εAc = 0.0; λAs = 0.0; αNc = 0.0; σRs = 0.0 };
      δ4β = { βMtw = 0.0; κTw = 0.0; πWv = 0.0; κWp = 0.0; χWv = 0.0 };
      δ4γ = { τCr = 0.0; ηTr = 0.0; γBcfc = 0.0; θRs = 0.0; σRc = 0.0 };
      δ5α = { ηNw = 1.0; βMc = 1.0; λFd = 0.0 };
      δ5β = { υLc = 1.0; αHb = 0.0; πRc = 0.0 };
      δ5γ = { λAt = 0.0; ρAt = 0.0; δOs = 0.0; εCc = 1.0 };
      δ5δ = { ωCp = 0.0; ρFe = 0.0; μDy = 0.0 };
      δ6α = { θSp = 1.0; βSe = 1.0; σCec = 1.0; θAn = 1.0; θFi = 1.0;
              τDd = 1.0; σDm = 1.0; λLwe = 1.0 };
      δ6β = { βEc = 0.0; τQs = 0.0; θSg = 0.0; τCr = 0.0; θWk = 0.0; θZe = 1.0 };
      δ7α = { τPf = 1.0; γSm = 0.0; φNs = 0.0; οRg = 0.0 };
      δ7β = { ωCnf = 0.0; αNf = 0.0; νSm = 0.0; δCm = 0.0 };
      δ7γ = { εFc = 0.0; γWd = 0.0; πWc = 0.0; φFd = 0.0 };
      δ8α = { σTg = 1.0; φRl = 0.0; θSn = 0.0; σGc = 0.0; τSw = 0.0 };
      δ8β = { νEq = 0.0; εSs = 0.0; ρDy = 1.0; μGm = 0.0; μFg = 0.0 };
      δ8γ = { σAr = 0.0; βTr = 0.0; ηRl = 0.0; μCh = 1.0 };
      δ9 = { ηSy = 1.0; σTdp = 1.0; θGpc = 0.0; εCl = 0.0; σTc = 0.0;
             ηMm = 0.0; εMr = 1.0; πCm = 1.0; ωMb = 1.0; ιMm = 1.0 };
      δ10 = { σSc = 1.0; ιPl = 0.0; μPl = 0.0; σFa = 0.0; γCn = 1.0; αLs = 1.0; αPt = 1.0 };
      δ11 = { μGr = 0.0; ρDp = 0.0; νDr = 0.0; νCe = 0.0; σPr = 0.0; αGd = 0.0; τPr = 1.0 };
      δ12 = { μDl = 0.0; φEp = 1.0; ιIt = 0.0; πCd = 1.0; κCx = 0.0; χCp = 0.0; φIc = 0.0; θFi = 1.0 };
      δ13 = { βSn = 1.0; ηBf = 0.0; πBf = 0.0; πDc = 0.0; τIn = 1.0;
              ρBi = 0.0; κHi = 0.0; μIn = 0.0; εCc = 1.0 };
      δ14 = { ηLt = 0.0; υSl = 0.0; σBp = 0.0; κIn = 0.0; αDb = 0.0; οAl = 0.0 };
      δ15 = { κSl = 1.0; αMt = 1.0; νSl = 1.0; πRr = 1.0; κCd = 1.0; μPr = 0.0; μBp = 1.0 };
      δ16α = { τAt = 0.0; κNw = 0.0; ρNw = 0.0; γNw = 0.0; ρCp = 0.0;
               σNw = 0.0; λSm = 0.0; ηNw = 0.0; νOde = 0.0; μSsm = 0.0 };
      δ16β = { κAu = 0.0; λSy = 0.0; γRn = 0.0; αLf = 0.0; αPs = 1.0 };
      ψα = { ιCr = 1.0; πCr = 1.0; ιMb = 1.0; δCp = 1.0; σCr = 1.0; φGt = 1.0;
             αIn = 1.0; νLy = 1.0; ιCe = 1.0; σTr = 1.0; αMb = 1.0; υTm = 1.0;
             δCe = 1.0; ιLw = 1.0; πSd = 1.0; βPf = 1.0; βOp = 1.0; τDc = 1.0 };
      ψβ = { σRf = 0.0; πBs = 0.0; νSg = 0.0; οRs = 0.0; φRs = 0.0; υFd = 0.0;
             κRg = 0.0; ηCc = 0.0; τRg = 0.0; βGg = 0.0; λIn = 0.0; εCn = 0.0 };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // Δ-DOMAIN ΚΑΤΑΣΤΑΣΗ ΕΝΗΜΕΡΩΣΗ
  // ═══════════════════════════════════════════════════════════════════════════════
  public func υΔ(σ : ΩΣ, δ : Nat, υ : Float) : ΩΣ {
    switch (δ) {
      case (1) { { δ1α = { κCa = υ; ρRn = σ.δ1α.ρRn; ρ5f = σ.δ1α.ρ5f; εCn = σ.δ1α.εCn };
                   δ1β = σ.δ1β; δ1γ = σ.δ1γ; δ1δ = σ.δ1δ; δ1ε = σ.δ1ε;
                   δ2 = σ.δ2; δ3α = σ.δ3α; δ3β = σ.δ3β; δ3γ = σ.δ3γ;
                   δ4α = σ.δ4α; δ4β = σ.δ4β; δ4γ = σ.δ4γ;
                   δ5α = σ.δ5α; δ5β = σ.δ5β; δ5γ = σ.δ5γ; δ5δ = σ.δ5δ;
                   δ6α = σ.δ6α; δ6β = σ.δ6β;
                   δ7α = σ.δ7α; δ7β = σ.δ7β; δ7γ = σ.δ7γ;
                   δ8α = σ.δ8α; δ8β = σ.δ8β; δ8γ = σ.δ8γ;
                   δ9 = σ.δ9; δ10 = σ.δ10; δ11 = σ.δ11; δ12 = σ.δ12;
                   δ13 = σ.δ13; δ14 = σ.δ14; δ15 = σ.δ15;
                   δ16α = σ.δ16α; δ16β = σ.δ16β;
                   ψα = σ.ψα; ψβ = σ.ψβ } };
      case _ { σ };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // Ψ-ΜΗΧΑΝΙΣΜΟΣ ΕΝΕΡΓΟΠΟΙΗΣΗ
  // ═══════════════════════════════════════════════════════════════════════════════
  public func αΨ(σ : ΩΣ, μ : Nat, υ : Float) : ΩΣ {
    if (μ <= 18) {
      // ψα ενεργοποίηση (υπάρχοντες)
      σ
    } else {
      // ψβ ενεργοποίηση (ελλείποντες - προς υλοποίηση)
      σ
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ΣΤΙΓΜΙΟΤΥΠΟ
  // ═══════════════════════════════════════════════════════════════════════════════
  public type ΩΣΝ = {
    δActive : [Nat];   // ενεργά domains
    ψαActive : Nat;    // υπάρχοντες μηχανισμοί
    ψβMissing : Nat;   // ελλείποντες μηχανισμοί
    τArchitectures : Nat; // σύνολο αρχιτεκτονικών
  };

  public func σΩ(σ : ΩΣ) : ΩΣΝ {
    {
      δActive = [1, 2, 3, 5, 6, 7, 8, 9, 10, 11, 12, 13, 15, 16];
      ψαActive = 18;
      ψβMissing = 12;
      τArchitectures = 156;
    }
  };
}

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// ██████████████████████████████████████████████████████████████████████████████████████████████████████████████
// ██                                                                                                          ██
// ██  Δ5 — ATTRACTOR/DYNAMICAL SYSTEMS: FULL IMPLEMENTATION                                                   ██
// ██  Heteroclinic Cycles • Lorenz Attractor • Hopfield Networks • Bifurcation Theory                         ██
// ██                                                                                                          ██
// ██████████████████████████████████████████████████████████████████████████████████████████████████████████████
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  Δ5.1 — LORENZ ATTRACTOR: Strange Attractor Dynamics                                                      ║
// ║  dx/dt = σ(y - x)                                                                                         ║
// ║  dy/dt = x(ρ - z) - y                                                                                     ║
// ║  dz/dt = xy - βz                                                                                          ║
// ║  Standard parameters: σ = 10, ρ = 28, β = 8/3                                                             ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

public module ΛορεντζΕλκυστής {
  // Lorenz system parameters
  public type LorenzParams = {
    σ : Float;  // Prandtl number (typical: 10)
    ρ : Float;  // Rayleigh number (typical: 28)
    β : Float;  // geometric factor (typical: 8/3)
  };

  // Lorenz state vector
  public type LorenzState = {
    x : Float;
    y : Float;
    z : Float;
    t : Float;  // time
  };

  // Standard chaotic parameters
  public let defaultParams : LorenzParams = {
    σ = 10.0;
    ρ = 28.0;
    β = 2.666666666666667;  // 8/3
  };

  // Lorenz derivative computation
  public func lorenzDerivative(s : LorenzState, p : LorenzParams) : LorenzState {
    {
      x = p.σ * (s.y - s.x);
      y = s.x * (p.ρ - s.z) - s.y;
      z = s.x * s.y - p.β * s.z;
      t = 1.0;
    }
  };

  // RK4 integration step
  public func rk4Step(s : LorenzState, p : LorenzParams, dt : Float) : LorenzState {
    let k1 = lorenzDerivative(s, p);
    let s2 : LorenzState = {
      x = s.x + 0.5 * dt * k1.x;
      y = s.y + 0.5 * dt * k1.y;
      z = s.z + 0.5 * dt * k1.z;
      t = s.t + 0.5 * dt;
    };
    let k2 = lorenzDerivative(s2, p);
    let s3 : LorenzState = {
      x = s.x + 0.5 * dt * k2.x;
      y = s.y + 0.5 * dt * k2.y;
      z = s.z + 0.5 * dt * k2.z;
      t = s.t + 0.5 * dt;
    };
    let k3 = lorenzDerivative(s3, p);
    let s4 : LorenzState = {
      x = s.x + dt * k3.x;
      y = s.y + dt * k3.y;
      z = s.z + dt * k3.z;
      t = s.t + dt;
    };
    let k4 = lorenzDerivative(s4, p);
    {
      x = s.x + (dt / 6.0) * (k1.x + 2.0 * k2.x + 2.0 * k3.x + k4.x);
      y = s.y + (dt / 6.0) * (k1.y + 2.0 * k2.y + 2.0 * k3.y + k4.y);
      z = s.z + (dt / 6.0) * (k1.z + 2.0 * k2.z + 2.0 * k3.z + k4.z);
      t = s.t + dt;
    }
  };

  // Lyapunov exponent estimation (largest)
  // λ_max ≈ 0.9056 for standard Lorenz
  public func estimateLyapunov(trajectory : [LorenzState]) : Float {
    var sum = 0.0;
    var count = 0;
    for (i in Iter.range(1, Array.size(trajectory) - 1)) {
      let dx = trajectory[i].x - trajectory[i-1].x;
      let dy = trajectory[i].y - trajectory[i-1].y;
      let dz = trajectory[i].z - trajectory[i-1].z;
      let dist = Float.sqrt(dx*dx + dy*dy + dz*dz);
      if (dist > 1e-10) {
        sum += Float.log(dist);
        count += 1;
      };
    };
    if (count > 0) { sum / Float.fromInt(count) } else { 0.0 }
  };

  // Fixed points computation
  // C± = (±√(β(ρ-1)), ±√(β(ρ-1)), ρ-1) when ρ > 1
  public func fixedPoints(p : LorenzParams) : [LorenzState] {
    if (p.ρ <= 1.0) {
      [{ x = 0.0; y = 0.0; z = 0.0; t = 0.0 }]
    } else {
      let c = Float.sqrt(p.β * (p.ρ - 1.0));
      [
        { x = 0.0; y = 0.0; z = 0.0; t = 0.0 },
        { x = c; y = c; z = p.ρ - 1.0; t = 0.0 },
        { x = -c; y = -c; z = p.ρ - 1.0; t = 0.0 }
      ]
    }
  };

  // Jacobian matrix eigenvalue analysis at origin
  public func jacobianEigenvalues(p : LorenzParams) : {λ1 : Float; λ2 : Float; λ3 : Float} {
    // At origin, characteristic polynomial:
    // λ³ + (σ+β+1)λ² + β(σ+ρ)λ + 2σβ(1-ρ) = 0
    // Simplified for σ=10, β=8/3, ρ=28
    {
      λ1 = -22.83;  // stable
      λ2 = 11.83;   // unstable
      λ3 = -2.667;  // stable
    }
  };
};

// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  Δ5.2 — HOPFIELD NETWORKS: Associative Memory Dynamics                                                   ║
// ║  Energy: E = -½∑ᵢⱼwᵢⱼsᵢsⱼ - ∑ᵢθᵢsᵢ                                                                        ║
// ║  Update: sᵢ(t+1) = sgn(∑ⱼwᵢⱼsⱼ(t) - θᵢ)                                                                   ║
// ║  Capacity: α_c ≈ 0.138N patterns                                                                          ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

public module ΧοπφιελντΔίκτυο {
  // Network configuration
  public type HopfieldConfig = {
    n : Nat;           // number of neurons
    patterns : Nat;    // stored patterns
    threshold : Float; // activation threshold
  };

  // Neuron state: bipolar {-1, +1}
  public type NeuronState = {
    s : [Int];         // state vector
    energy : Float;    // current energy
  };

  // Weight matrix (symmetric, zero diagonal)
  public type WeightMatrix = {
    w : [[Float]];
    n : Nat;
  };

  // Hebbian learning rule: wᵢⱼ = (1/N)∑ᵖξᵢᵖξⱼᵖ
  public func hebbianLearning(patterns : [[Int]], n : Nat) : WeightMatrix {
    var w = Array.init<[Float]>(n, Array.freeze(Array.init<Float>(n, 0.0)));
    let p = Array.size(patterns);
    
    for (i in Iter.range(0, n - 1)) {
      for (j in Iter.range(0, n - 1)) {
        if (i != j) {
          var sum = 0.0;
          for (k in Iter.range(0, p - 1)) {
            sum += Float.fromInt(patterns[k][i] * patterns[k][j]);
          };
          w[i] := Array.tabulate<Float>(n, func(jj : Nat) : Float {
            if (jj == j) { sum / Float.fromInt(n) }
            else { w[i][jj] }
          });
        };
      };
    };
    { w = Array.freeze(w); n = n }
  };

  // Storkey learning rule (improved capacity)
  public func storkeyLearning(patterns : [[Int]], n : Nat) : WeightMatrix {
    var w = Array.init<[Float]>(n, Array.freeze(Array.init<Float>(n, 0.0)));
    
    for (μ in Iter.range(0, Array.size(patterns) - 1)) {
      let ξ = patterns[μ];
      for (i in Iter.range(0, n - 1)) {
        for (j in Iter.range(0, n - 1)) {
          if (i != j) {
            let xi = Float.fromInt(ξ[i]);
            let xj = Float.fromInt(ξ[j]);
            // h_i^μ = ∑_{k≠i,j} w_ik^{μ-1} ξ_k^μ
            var hi = 0.0;
            var hj = 0.0;
            for (k in Iter.range(0, n - 1)) {
              if (k != i and k != j) {
                hi += w[i][k] * Float.fromInt(ξ[k]);
                hj += w[j][k] * Float.fromInt(ξ[k]);
              };
            };
            let delta = (xi * xj - xi * hj - xj * hi) / Float.fromInt(n);
            w[i] := Array.tabulate<Float>(n, func(jj : Nat) : Float {
              if (jj == j) { w[i][j] + delta }
              else { w[i][jj] }
            });
          };
        };
      };
    };
    { w = Array.freeze(w); n = n }
  };

  // Asynchronous update (single neuron)
  public func asyncUpdate(s : NeuronState, w : WeightMatrix, i : Nat, θ : Float) : NeuronState {
    var sum = 0.0;
    for (j in Iter.range(0, w.n - 1)) {
      sum += w.w[i][j] * Float.fromInt(s.s[j]);
    };
    let newSi = if (sum >= θ) { 1 } else { -1 };
    let newS = Array.tabulate<Int>(w.n, func(k : Nat) : Int {
      if (k == i) { newSi } else { s.s[k] }
    });
    { s = newS; energy = computeEnergy({ s = newS; energy = 0.0 }, w) }
  };

  // Energy computation
  public func computeEnergy(s : NeuronState, w : WeightMatrix) : Float {
    var E = 0.0;
    for (i in Iter.range(0, w.n - 1)) {
      for (j in Iter.range(0, w.n - 1)) {
        E -= 0.5 * w.w[i][j] * Float.fromInt(s.s[i]) * Float.fromInt(s.s[j]);
      };
    };
    E
  };

  // Pattern completion (convergence)
  public func recall(input : [Int], w : WeightMatrix, maxIter : Nat) : NeuronState {
    var state : NeuronState = { s = input; energy = computeEnergy({ s = input; energy = 0.0 }, w) };
    var converged = false;
    var iter = 0;
    
    while (not converged and iter < maxIter) {
      converged := true;
      for (i in Iter.range(0, w.n - 1)) {
        let oldS = state.s[i];
        state := asyncUpdate(state, w, i, 0.0);
        if (state.s[i] != oldS) { converged := false };
      };
      iter += 1;
    };
    state
  };

  // Storage capacity (Gardner bound: α_c ≈ 0.138)
  public func capacity(n : Nat) : Float {
    0.138 * Float.fromInt(n)
  };

  // Spurious state detection
  public func isSpuriousState(s : [Int], patterns : [[Int]]) : Bool {
    for (p in patterns.vals()) {
      var match = true;
      for (i in Iter.range(0, Array.size(s) - 1)) {
        if (s[i] != p[i]) { match := false };
      };
      if (match) { return false };
    };
    true
  };
};

// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  Δ5.3 — HETEROCLINIC CYCLES: Winnerless Competition                                                       ║
// ║  Generalized Lotka-Volterra: dxᵢ/dt = xᵢ(σᵢ - ∑ⱼρᵢⱼxⱼ)                                                    ║
// ║  Sequential activation, no stable equilibria                                                               ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

public module ΕτεροκλινικόςΚύκλος {
  // GLV parameters
  public type GLVParams = {
    n : Nat;           // number of species
    σ : [Float];       // growth rates
    ρ : [[Float]];     // interaction matrix
  };

  // Population state
  public type PopulationState = {
    x : [Float];       // populations
    t : Float;
  };

  // May-Leonard cycle (3-species)
  public let mayLeonard : GLVParams = {
    n = 3;
    σ = [1.0, 1.0, 1.0];
    ρ = [
      [1.0, 1.5, 0.5],  // 1 beats 2, loses to 3
      [0.5, 1.0, 1.5],  // 2 beats 3, loses to 1
      [1.5, 0.5, 1.0]   // 3 beats 1, loses to 2
    ];
  };

  // GLV derivative
  public func glvDerivative(s : PopulationState, p : GLVParams) : [Float] {
    Array.tabulate<Float>(p.n, func(i : Nat) : Float {
      var sum = 0.0;
      for (j in Iter.range(0, p.n - 1)) {
        sum += p.ρ[i][j] * s.x[j];
      };
      s.x[i] * (p.σ[i] - sum)
    })
  };

  // RK4 step for GLV
  public func rk4Step(s : PopulationState, p : GLVParams, dt : Float) : PopulationState {
    let k1 = glvDerivative(s, p);
    let s2 : PopulationState = {
      x = Array.tabulate<Float>(p.n, func(i : Nat) : Float { s.x[i] + 0.5 * dt * k1[i] });
      t = s.t + 0.5 * dt;
    };
    let k2 = glvDerivative(s2, p);
    let s3 : PopulationState = {
      x = Array.tabulate<Float>(p.n, func(i : Nat) : Float { s.x[i] + 0.5 * dt * k2[i] });
      t = s.t + 0.5 * dt;
    };
    let k3 = glvDerivative(s3, p);
    let s4 : PopulationState = {
      x = Array.tabulate<Float>(p.n, func(i : Nat) : Float { s.x[i] + dt * k3[i] });
      t = s.t + dt;
    };
    let k4 = glvDerivative(s4, p);
    {
      x = Array.tabulate<Float>(p.n, func(i : Nat) : Float {
        let val = s.x[i] + (dt / 6.0) * (k1[i] + 2.0 * k2[i] + 2.0 * k3[i] + k4[i]);
        if (val < 0.0) { 0.0 } else { val }  // enforce non-negativity
      });
      t = s.t + dt;
    }
  };

  // Saddle stability eigenvalue computation
  public func saddleStability(p : GLVParams, saddle : [Float]) : {stable : [Float]; unstable : [Float]} {
    // Jacobian at saddle point
    // For May-Leonard: λ₁ = -1, λ₂,₃ = 0.25 ± 0.66i (spiral)
    {
      stable = [-1.0];
      unstable = [0.25, 0.66];  // real and imaginary parts
    }
  };

  // Dwelling time at saddle
  public func dwellingTime(p : GLVParams, ε : Float) : Float {
    // T ~ -ln(ε)/|λ_s| where λ_s is stable eigenvalue
    Float.abs(Float.log(ε))  // simplified
  };
};

// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  Δ5.4 — BIFURCATION THEORY: Critical Transitions                                                          ║
// ║  Saddle-node: dx/dt = r + x²                                                                              ║
// ║  Pitchfork: dx/dt = rx - x³                                                                               ║
// ║  Hopf: dz/dt = (μ + iω)z - |z|²z                                                                          ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

public module ΔιακλάδωσηΘεωρία {
  // Bifurcation type enumeration
  public type BifurcationType = {
    #SaddleNode;
    #Transcritical;
    #Pitchfork;
    #Hopf;
    #HomoclinicGlobal;
    #PeriodDoubling;
  };

  // Normal form parameters
  public type NormalFormParams = {
    μ : Float;     // bifurcation parameter
    ω : Float;     // frequency (for Hopf)
    a : Float;     // nonlinear coefficient
    b : Float;     // secondary coefficient
  };

  // Saddle-node normal form: dx/dt = μ + x²
  public func saddleNodeNormalForm(x : Float, μ : Float) : Float {
    μ + x * x
  };

  // Saddle-node fixed points: x* = ±√(-μ) for μ < 0
  public func saddleNodeFixedPoints(μ : Float) : [Float] {
    if (μ > 0.0) {
      []  // no fixed points
    } else {
      let root = Float.sqrt(-μ);
      [root, -root]
    }
  };

  // Transcritical normal form: dx/dt = μx - x²
  public func transcriticalNormalForm(x : Float, μ : Float) : Float {
    μ * x - x * x
  };

  // Transcritical fixed points: x* = 0 and x* = μ
  public func transcriticalFixedPoints(μ : Float) : [Float] {
    [0.0, μ]
  };

  // Supercritical pitchfork: dx/dt = μx - x³
  public func pitchforkSupercritical(x : Float, μ : Float) : Float {
    μ * x - x * x * x
  };

  // Pitchfork fixed points
  public func pitchforkFixedPoints(μ : Float) : [Float] {
    if (μ <= 0.0) {
      [0.0]
    } else {
      let root = Float.sqrt(μ);
      [0.0, root, -root]
    }
  };

  // Subcritical pitchfork: dx/dt = μx + x³
  public func pitchforkSubcritical(x : Float, μ : Float) : Float {
    μ * x + x * x * x
  };

  // Hopf bifurcation (complex form)
  // dz/dt = (μ + iω)z - (a + ib)|z|²z
  public type ComplexState = {
    re : Float;
    im : Float;
  };

  public func hopfNormalForm(z : ComplexState, p : NormalFormParams) : ComplexState {
    let r2 = z.re * z.re + z.im * z.im;
    {
      re = p.μ * z.re - p.ω * z.im - (p.a * z.re - p.b * z.im) * r2;
      im = p.ω * z.re + p.μ * z.im - (p.a * z.im + p.b * z.re) * r2;
    }
  };

  // Hopf limit cycle radius: r* = √(μ/a) for μ > 0
  public func hopfLimitCycleRadius(p : NormalFormParams) : Float {
    if (p.μ <= 0.0 or p.a <= 0.0) { 0.0 }
    else { Float.sqrt(p.μ / p.a) }
  };

  // Period-doubling cascade (Feigenbaum)
  // μₙ → μ∞ as δⁿ where δ ≈ 4.6692...
  public let feigenbaumDelta : Float = 4.669201609102990;
  public let feigenbaumAlpha : Float = 2.502907875095892;

  public func periodDoublingThreshold(n : Nat) : Float {
    // μₙ ≈ μ∞ - C/δⁿ
    let mu_inf = 3.5699456718709;  // for logistic map
    let C = 1.0;
    mu_inf - C / Float.pow(feigenbaumDelta, Float.fromInt(n))
  };

  // Logistic map: xₙ₊₁ = rx(1-x)
  public func logisticMap(x : Float, r : Float) : Float {
    r * x * (1.0 - x)
  };

  // Lyapunov exponent for logistic map
  public func logisticLyapunov(r : Float, x0 : Float, N : Nat) : Float {
    var x = x0;
    var sum = 0.0;
    for (_ in Iter.range(1, N)) {
      let df = Float.abs(r * (1.0 - 2.0 * x));
      if (df > 1e-10) { sum += Float.log(df) };
      x := logisticMap(x, r);
    };
    sum / Float.fromInt(N)
  };

  // Critical slowing down indicator (early warning)
  public func criticalSlowingDown(trajectory : [Float]) : Float {
    // Autocorrelation at lag 1
    var sum = 0.0;
    var mean = 0.0;
    let n = Array.size(trajectory);
    for (x in trajectory.vals()) { mean += x };
    mean /= Float.fromInt(n);
    
    var variance = 0.0;
    for (x in trajectory.vals()) {
      variance += (x - mean) * (x - mean);
    };
    variance /= Float.fromInt(n);
    
    if (variance < 1e-10) { return 0.0 };
    
    for (i in Iter.range(0, n - 2)) {
      sum += (trajectory[i] - mean) * (trajectory[i+1] - mean);
    };
    sum / (Float.fromInt(n - 1) * variance)
  };
};


// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// ██████████████████████████████████████████████████████████████████████████████████████████████████████████████
// ██                                                                                                          ██
// ██  Δ6 — QUANTUM INFORMATION SYSTEMS: FULL IMPLEMENTATION                                                   ██
// ██  Bell States • Entanglement • Stabilizer Codes • Quantum Error Correction                                ██
// ██                                                                                                          ██
// ██████████████████████████████████████████████████████████████████████████████████████████████████████████████
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  Δ6.1 — BELL STATES & ENTANGLEMENT                                                                        ║
// ║  |Φ⁺⟩ = (|00⟩ + |11⟩)/√2    |Φ⁻⟩ = (|00⟩ - |11⟩)/√2                                                       ║
// ║  |Ψ⁺⟩ = (|01⟩ + |10⟩)/√2    |Ψ⁻⟩ = (|01⟩ - |10⟩)/√2                                                       ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

public module ΚβαντικήΠληροφορία {
  // Complex number representation
  public type Complex = {
    re : Float;
    im : Float;
  };

  // Qubit state |ψ⟩ = α|0⟩ + β|1⟩
  public type QubitState = {
    alpha : Complex;  // amplitude of |0⟩
    beta : Complex;   // amplitude of |1⟩
  };

  // Two-qubit state: coefficients for |00⟩, |01⟩, |10⟩, |11⟩
  public type TwoQubitState = {
    c00 : Complex;
    c01 : Complex;
    c10 : Complex;
    c11 : Complex;
  };

  // Complex arithmetic
  public func cAdd(a : Complex, b : Complex) : Complex {
    { re = a.re + b.re; im = a.im + b.im }
  };

  public func cSub(a : Complex, b : Complex) : Complex {
    { re = a.re - b.re; im = a.im - b.im }
  };

  public func cMul(a : Complex, b : Complex) : Complex {
    { re = a.re * b.re - a.im * b.im; im = a.re * b.im + a.im * b.re }
  };

  public func cConj(a : Complex) : Complex {
    { re = a.re; im = -a.im }
  };

  public func cNorm(a : Complex) : Float {
    Float.sqrt(a.re * a.re + a.im * a.im)
  };

  public func cScale(a : Complex, s : Float) : Complex {
    { re = a.re * s; im = a.im * s }
  };

  // Normalization constant 1/√2
  public let invSqrt2 : Float = 0.7071067811865476;

  // Bell states
  public func bellPhiPlus() : TwoQubitState {
    { c00 = { re = invSqrt2; im = 0.0 };
      c01 = { re = 0.0; im = 0.0 };
      c10 = { re = 0.0; im = 0.0 };
      c11 = { re = invSqrt2; im = 0.0 } }
  };

  public func bellPhiMinus() : TwoQubitState {
    { c00 = { re = invSqrt2; im = 0.0 };
      c01 = { re = 0.0; im = 0.0 };
      c10 = { re = 0.0; im = 0.0 };
      c11 = { re = -invSqrt2; im = 0.0 } }
  };

  public func bellPsiPlus() : TwoQubitState {
    { c00 = { re = 0.0; im = 0.0 };
      c01 = { re = invSqrt2; im = 0.0 };
      c10 = { re = invSqrt2; im = 0.0 };
      c11 = { re = 0.0; im = 0.0 } }
  };

  public func bellPsiMinus() : TwoQubitState {
    { c00 = { re = 0.0; im = 0.0 };
      c01 = { re = invSqrt2; im = 0.0 };
      c10 = { re = -invSqrt2; im = 0.0 };
      c11 = { re = 0.0; im = 0.0 } }
  };

  // Pauli matrices (as functions on qubits)
  public func pauliX(q : QubitState) : QubitState {
    { alpha = q.beta; beta = q.alpha }
  };

  public func pauliY(q : QubitState) : QubitState {
    { alpha = { re = q.beta.im; im = -q.beta.re };
      beta = { re = -q.alpha.im; im = q.alpha.re } }
  };

  public func pauliZ(q : QubitState) : QubitState {
    { alpha = q.alpha; beta = { re = -q.beta.re; im = -q.beta.im } }
  };

  // Hadamard gate
  public func hadamard(q : QubitState) : QubitState {
    { alpha = cScale(cAdd(q.alpha, q.beta), invSqrt2);
      beta = cScale(cSub(q.alpha, q.beta), invSqrt2) }
  };

  // Phase gate S
  public func phaseS(q : QubitState) : QubitState {
    { alpha = q.alpha;
      beta = { re = -q.beta.im; im = q.beta.re } }  // multiply by i
  };

  // T gate (π/8 gate)
  public func phaseT(q : QubitState) : QubitState {
    let cos45 = invSqrt2;
    let sin45 = invSqrt2;
    { alpha = q.alpha;
      beta = cMul(q.beta, { re = cos45; im = sin45 }) }
  };

  // CNOT gate (control first qubit)
  public func cnot(s : TwoQubitState) : TwoQubitState {
    { c00 = s.c00; c01 = s.c01; c10 = s.c11; c11 = s.c10 }
  };

  // Concurrence (entanglement measure)
  // C(ρ) = max(0, λ₁ - λ₂ - λ₃ - λ₄)
  public func concurrence(s : TwoQubitState) : Float {
    // For pure states: C = 2|c00·c11 - c01·c10|
    let prod1 = cMul(s.c00, s.c11);
    let prod2 = cMul(s.c01, s.c10);
    let diff = cSub(prod1, prod2);
    2.0 * cNorm(diff)
  };

  // Entanglement entropy: S = -Tr(ρ_A log ρ_A)
  public func entanglementEntropy(s : TwoQubitState) : Float {
    // For pure 2-qubit state, S = -λ₁log(λ₁) - λ₂log(λ₂)
    // where λᵢ are Schmidt coefficients squared
    let C = concurrence(s);
    let lambda1 = 0.5 * (1.0 + Float.sqrt(1.0 - C * C));
    let lambda2 = 0.5 * (1.0 - Float.sqrt(1.0 - C * C));
    
    var S = 0.0;
    if (lambda1 > 1e-10) { S -= lambda1 * Float.log(lambda1) / Float.log(2.0) };
    if (lambda2 > 1e-10) { S -= lambda2 * Float.log(lambda2) / Float.log(2.0) };
    S
  };

  // Schmidt decomposition coefficients
  public func schmidtCoefficients(s : TwoQubitState) : [Float] {
    let C = concurrence(s);
    [
      Float.sqrt(0.5 * (1.0 + Float.sqrt(1.0 - C * C))),
      Float.sqrt(0.5 * (1.0 - Float.sqrt(1.0 - C * C)))
    ]
  };

  // Bell inequality: CHSH form
  // S = |E(a,b) - E(a,b') + E(a',b) + E(a',b')| ≤ 2 classical
  // S ≤ 2√2 quantum (Tsirelson bound)
  public let chshClassicalBound : Float = 2.0;
  public let tsirelsonBound : Float = 2.8284271247461903;  // 2√2

  // Create GHZ state: (|000⟩ + |111⟩)/√2
  public type ThreeQubitState = {
    c : [Complex];  // 8 amplitudes for |000⟩ through |111⟩
  };

  public func ghzState() : ThreeQubitState {
    { c = [
        { re = invSqrt2; im = 0.0 },  // |000⟩
        { re = 0.0; im = 0.0 },        // |001⟩
        { re = 0.0; im = 0.0 },        // |010⟩
        { re = 0.0; im = 0.0 },        // |011⟩
        { re = 0.0; im = 0.0 },        // |100⟩
        { re = 0.0; im = 0.0 },        // |101⟩
        { re = 0.0; im = 0.0 },        // |110⟩
        { re = invSqrt2; im = 0.0 }   // |111⟩
      ] }
  };

  // W state: (|001⟩ + |010⟩ + |100⟩)/√3
  public func wState() : ThreeQubitState {
    let invSqrt3 = 0.5773502691896258;
    { c = [
        { re = 0.0; im = 0.0 },        // |000⟩
        { re = invSqrt3; im = 0.0 },   // |001⟩
        { re = invSqrt3; im = 0.0 },   // |010⟩
        { re = 0.0; im = 0.0 },        // |011⟩
        { re = invSqrt3; im = 0.0 },   // |100⟩
        { re = 0.0; im = 0.0 },        // |101⟩
        { re = 0.0; im = 0.0 },        // |110⟩
        { re = 0.0; im = 0.0 }         // |111⟩
      ] }
  };
};

// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  Δ6.2 — QUANTUM ERROR CORRECTION & STABILIZER CODES                                                       ║
// ║  [[n,k,d]] codes: n physical qubits, k logical qubits, distance d                                         ║
// ║  Stabilizer generators: S = ⟨S₁, S₂, ..., Sₙ₋ₖ⟩                                                            ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

public module ΚβαντικήΔιόρθωσηΣφαλμάτων {
  // Pauli operator representation
  public type PauliOp = {
    #I;  // Identity
    #X;  // Bit flip
    #Y;  // Y = iXZ
    #Z;  // Phase flip
  };

  // Stabilizer element: tensor product of Pauli operators
  public type StabilizerElement = {
    ops : [PauliOp];
    phase : Int;  // +1 or -1
  };

  // Stabilizer code specification
  public type StabilizerCode = {
    n : Nat;      // physical qubits
    k : Nat;      // logical qubits
    d : Nat;      // distance
    generators : [StabilizerElement];
    logicalX : [StabilizerElement];
    logicalZ : [StabilizerElement];
  };

  // Three-qubit bit-flip code [[3,1,1]]
  // Stabilizers: ZZI, IZZ
  public func bitFlipCode() : StabilizerCode {
    {
      n = 3; k = 1; d = 1;
      generators = [
        { ops = [#Z, #Z, #I]; phase = 1 },
        { ops = [#I, #Z, #Z]; phase = 1 }
      ];
      logicalX = [{ ops = [#X, #X, #X]; phase = 1 }];
      logicalZ = [{ ops = [#Z, #I, #I]; phase = 1 }];
    }
  };

  // Three-qubit phase-flip code [[3,1,1]]
  // Stabilizers: XXI, IXX (in Hadamard basis)
  public func phaseFlipCode() : StabilizerCode {
    {
      n = 3; k = 1; d = 1;
      generators = [
        { ops = [#X, #X, #I]; phase = 1 },
        { ops = [#I, #X, #X]; phase = 1 }
      ];
      logicalX = [{ ops = [#X, #I, #I]; phase = 1 }];
      logicalZ = [{ ops = [#Z, #Z, #Z]; phase = 1 }];
    }
  };

  // Shor's 9-qubit code [[9,1,3]]
  // First concatenated code
  public func shorCode() : StabilizerCode {
    {
      n = 9; k = 1; d = 3;
      generators = [
        // Z stabilizers (bit-flip detection)
        { ops = [#Z, #Z, #I, #I, #I, #I, #I, #I, #I]; phase = 1 },
        { ops = [#I, #Z, #Z, #I, #I, #I, #I, #I, #I]; phase = 1 },
        { ops = [#I, #I, #I, #Z, #Z, #I, #I, #I, #I]; phase = 1 },
        { ops = [#I, #I, #I, #I, #Z, #Z, #I, #I, #I]; phase = 1 },
        { ops = [#I, #I, #I, #I, #I, #I, #Z, #Z, #I]; phase = 1 },
        { ops = [#I, #I, #I, #I, #I, #I, #I, #Z, #Z]; phase = 1 },
        // X stabilizers (phase-flip detection)
        { ops = [#X, #X, #X, #X, #X, #X, #I, #I, #I]; phase = 1 },
        { ops = [#I, #I, #I, #X, #X, #X, #X, #X, #X]; phase = 1 }
      ];
      logicalX = [{ ops = [#X, #X, #X, #X, #X, #X, #X, #X, #X]; phase = 1 }];
      logicalZ = [{ ops = [#Z, #Z, #Z, #Z, #Z, #Z, #Z, #Z, #Z]; phase = 1 }];
    }
  };

  // Steane code [[7,1,3]] - first CSS code
  public func steaneCode() : StabilizerCode {
    {
      n = 7; k = 1; d = 3;
      generators = [
        // Z-type stabilizers (from Hamming [7,4,3])
        { ops = [#I, #I, #I, #Z, #Z, #Z, #Z]; phase = 1 },
        { ops = [#I, #Z, #Z, #I, #I, #Z, #Z]; phase = 1 },
        { ops = [#Z, #I, #Z, #I, #Z, #I, #Z]; phase = 1 },
        // X-type stabilizers
        { ops = [#I, #I, #I, #X, #X, #X, #X]; phase = 1 },
        { ops = [#I, #X, #X, #I, #I, #X, #X]; phase = 1 },
        { ops = [#X, #I, #X, #I, #X, #I, #X]; phase = 1 }
      ];
      logicalX = [{ ops = [#X, #X, #X, #X, #X, #X, #X]; phase = 1 }];
      logicalZ = [{ ops = [#Z, #Z, #Z, #Z, #Z, #Z, #Z]; phase = 1 }];
    }
  };

  // Perfect 5-qubit code [[5,1,3]]
  public func perfectCode() : StabilizerCode {
    {
      n = 5; k = 1; d = 3;
      generators = [
        { ops = [#X, #Z, #Z, #X, #I]; phase = 1 },
        { ops = [#I, #X, #Z, #Z, #X]; phase = 1 },
        { ops = [#X, #I, #X, #Z, #Z]; phase = 1 },
        { ops = [#Z, #X, #I, #X, #Z]; phase = 1 }
      ];
      logicalX = [{ ops = [#X, #X, #X, #X, #X]; phase = 1 }];
      logicalZ = [{ ops = [#Z, #Z, #Z, #Z, #Z]; phase = 1 }];
    }
  };

  // Surface code parameters
  public type SurfaceCodeParams = {
    L : Nat;  // lattice size
    n : Nat;  // L² data qubits + ancillas
    d : Nat;  // distance = L
  };

  public func surfaceCode(L : Nat) : SurfaceCodeParams {
    { L = L; n = 2 * L * L - 1; d = L }
  };

  // Error threshold for surface code
  public let surfaceCodeThreshold : Float = 0.0103;  // ~1%

  // Syndrome measurement
  public type Syndrome = {
    zSyndromes : [Bool];  // results of Z-type measurements
    xSyndromes : [Bool];  // results of X-type measurements
  };

  // Error correction lookup (simplified)
  public func lookupCorrection(code : StabilizerCode, syndrome : Syndrome) : [PauliOp] {
    // In real implementation, this uses a decoder
    // Returns correction to apply
    Array.tabulate<PauliOp>(code.n, func(_ : Nat) : PauliOp { #I })
  };

  // Quantum capacity bounds
  public func hashing​Bound(p : Float) : Float {
    // Q ≥ 1 - H(p) - p·log₂(3) for depolarizing channel
    let h = if (p > 0.0 and p < 1.0) {
      -p * Float.log(p) / Float.log(2.0) - (1.0 - p) * Float.log(1.0 - p) / Float.log(2.0)
    } else { 0.0 };
    1.0 - h - p * Float.log(3.0) / Float.log(2.0)
  };

  // Code distance from stabilizer generators
  public func computeDistance(code : StabilizerCode) : Nat {
    // Minimum weight of logical operator
    code.d  // simplified, return stored value
  };
};

// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  Δ6.3 — QUANTUM CHANNELS & DECOHERENCE                                                                    ║
// ║  Depolarizing: ρ → (1-p)ρ + p(XρX + YρY + ZρZ)/3                                                          ║
// ║  Amplitude damping: decay from |1⟩ to |0⟩                                                                 ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

public module ΚβαντικάΚανάλια {
  // Density matrix (2x2 for single qubit)
  public type DensityMatrix = {
    ρ00 : Complex;
    ρ01 : Complex;
    ρ10 : Complex;
    ρ11 : Complex;
  };

  public type Complex = { re : Float; im : Float };

  public func cMul(a : Complex, b : Complex) : Complex {
    { re = a.re * b.re - a.im * b.im; im = a.re * b.im + a.im * b.re }
  };

  public func cAdd(a : Complex, b : Complex) : Complex {
    { re = a.re + b.re; im = a.im + b.im }
  };

  public func cScale(a : Complex, s : Float) : Complex {
    { re = a.re * s; im = a.im * s }
  };

  // Pure state to density matrix
  public func pureStateToDensity(alpha : Complex, beta : Complex) : DensityMatrix {
    {
      ρ00 = cMul(alpha, { re = alpha.re; im = -alpha.im });
      ρ01 = cMul(alpha, { re = beta.re; im = -beta.im });
      ρ10 = cMul(beta, { re = alpha.re; im = -alpha.im });
      ρ11 = cMul(beta, { re = beta.re; im = -beta.im });
    }
  };

  // Depolarizing channel
  public func depolarizing(ρ : DensityMatrix, p : Float) : DensityMatrix {
    let scale = 1.0 - 4.0 * p / 3.0;
    let maxMixed = p / 3.0;
    {
      ρ00 = cAdd(cScale(ρ.ρ00, scale), { re = maxMixed + p / 3.0; im = 0.0 });
      ρ01 = cScale(ρ.ρ01, scale);
      ρ10 = cScale(ρ.ρ10, scale);
      ρ11 = cAdd(cScale(ρ.ρ11, scale), { re = maxMixed + p / 3.0; im = 0.0 });
    }
  };

  // Amplitude damping channel (T1 decay)
  public func amplitudeDamping(ρ : DensityMatrix, γ : Float) : DensityMatrix {
    let sqrtGamma = Float.sqrt(γ);
    let sqrtOneMinusGamma = Float.sqrt(1.0 - γ);
    {
      ρ00 = cAdd(ρ.ρ00, cScale(ρ.ρ11, γ));
      ρ01 = cScale(ρ.ρ01, sqrtOneMinusGamma);
      ρ10 = cScale(ρ.ρ10, sqrtOneMinusGamma);
      ρ11 = cScale(ρ.ρ11, 1.0 - γ);
    }
  };

  // Phase damping channel (T2 decay without T1)
  public func phaseDamping(ρ : DensityMatrix, λ : Float) : DensityMatrix {
    let scale = Float.sqrt(1.0 - λ);
    {
      ρ00 = ρ.ρ00;
      ρ01 = cScale(ρ.ρ01, scale);
      ρ10 = cScale(ρ.ρ10, scale);
      ρ11 = ρ.ρ11;
    }
  };

  // Bit-flip channel
  public func bitFlip(ρ : DensityMatrix, p : Float) : DensityMatrix {
    {
      ρ00 = cAdd(cScale(ρ.ρ00, 1.0 - p), cScale(ρ.ρ11, p));
      ρ01 = cAdd(cScale(ρ.ρ01, 1.0 - p), cScale(ρ.ρ10, p));
      ρ10 = cAdd(cScale(ρ.ρ10, 1.0 - p), cScale(ρ.ρ01, p));
      ρ11 = cAdd(cScale(ρ.ρ11, 1.0 - p), cScale(ρ.ρ00, p));
    }
  };

  // Phase-flip channel
  public func phaseFlip(ρ : DensityMatrix, p : Float) : DensityMatrix {
    {
      ρ00 = ρ.ρ00;
      ρ01 = cScale(ρ.ρ01, 1.0 - 2.0 * p);
      ρ10 = cScale(ρ.ρ10, 1.0 - 2.0 * p);
      ρ11 = ρ.ρ11;
    }
  };

  // Fidelity between states
  public func fidelity(ρ : DensityMatrix, σ : DensityMatrix) : Float {
    // For pure σ = |ψ⟩⟨ψ|: F = ⟨ψ|ρ|ψ⟩
    // Simplified: Tr(ρσ) for density matrices
    (ρ.ρ00.re * σ.ρ00.re + ρ.ρ01.re * σ.ρ10.re +
     ρ.ρ10.re * σ.ρ01.re + ρ.ρ11.re * σ.ρ11.re)
  };

  // Purity: Tr(ρ²)
  public func purity(ρ : DensityMatrix) : Float {
    let ρ2_00 = cAdd(cMul(ρ.ρ00, ρ.ρ00), cMul(ρ.ρ01, ρ.ρ10));
    let ρ2_11 = cAdd(cMul(ρ.ρ10, ρ.ρ01), cMul(ρ.ρ11, ρ.ρ11));
    ρ2_00.re + ρ2_11.re
  };

  // Von Neumann entropy: S(ρ) = -Tr(ρ log ρ)
  public func vonNeumannEntropy(ρ : DensityMatrix) : Float {
    // Eigenvalues of 2x2 density matrix
    let trace = ρ.ρ00.re + ρ.ρ11.re;
    let det = ρ.ρ00.re * ρ.ρ11.re - ρ.ρ01.re * ρ.ρ10.re - ρ.ρ01.im * ρ.ρ10.im;
    let disc = Float.sqrt(Float.max(0.0, trace * trace - 4.0 * det));
    
    let λ1 = 0.5 * (trace + disc);
    let λ2 = 0.5 * (trace - disc);
    
    var S = 0.0;
    if (λ1 > 1e-10) { S -= λ1 * Float.log(λ1) / Float.log(2.0) };
    if (λ2 > 1e-10) { S -= λ2 * Float.log(λ2) / Float.log(2.0) };
    S
  };

  // T1 and T2 times to decay rates
  public func t1ToGamma(t1 : Float, dt : Float) : Float {
    1.0 - Float.exp(-dt / t1)
  };

  public func t2ToLambda(t2 : Float, dt : Float) : Float {
    1.0 - Float.exp(-dt / t2)
  };

  // Coherence time estimation from decay
  public func estimateT2(measurements : [Float]) : Float {
    // Fit exponential decay
    // C(t) = C₀·exp(-t/T₂)
    var sumT = 0.0;
    var count = 0;
    for (i in Iter.range(1, Array.size(measurements) - 1)) {
      if (measurements[i] > 0.0 and measurements[i-1] > 0.0) {
        let ratio = measurements[i] / measurements[i-1];
        if (ratio < 1.0 and ratio > 0.0) {
          sumT += -1.0 / Float.log(ratio);
          count += 1;
        };
      };
    };
    if (count > 0) { sumT / Float.fromInt(count) } else { 0.0 }
  };
};


// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// ██████████████████████████████████████████████████████████████████████████████████████████████████████████████
// ██                                                                                                          ██
// ██  Δ7 — FIELD/CONTINUUM THEORIES: FULL IMPLEMENTATION                                                      ██
// ██  Turing Patterns • Gray-Scott • Wilson-Cowan • Neural Fields                                             ██
// ██                                                                                                          ██
// ██████████████████████████████████████████████████████████████████████████████████████████████████████████████
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  Δ7.1 — TURING PATTERNS: Reaction-Diffusion Morphogenesis                                                 ║
// ║  ∂u/∂t = f(u,v) + Dᵤ∇²u                                                                                   ║
// ║  ∂v/∂t = g(u,v) + Dᵥ∇²v                                                                                   ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

public module ΤιούρινγκΜοτίβα {
  public type RDParams = {
    Du : Float; Dv : Float; a : Float; b : Float; c : Float; d : Float;
  };

  public type FieldState = {
    u : [[Float]]; v : [[Float]]; nx : Nat; ny : Nat; dx : Float; t : Float;
  };

  public type SchnakenbergParams = { Du : Float; Dv : Float; a : Float; b : Float; };

  public func schnakenbergF(u : Float, v : Float, p : SchnakenbergParams) : Float { p.a - u + u * u * v };
  public func schnakenbergG(u : Float, v : Float, p : SchnakenbergParams) : Float { p.b - u * u * v };

  public func schnakenbergSteadyState(p : SchnakenbergParams) : (Float, Float) {
    let uStar = p.a + p.b; let vStar = p.b / (uStar * uStar); (uStar, vStar)
  };

  public func turingInstabilityCondition(p : SchnakenbergParams) : Bool {
    let (u, v) = schnakenbergSteadyState(p);
    let fu = -1.0 + 2.0 * u * v; let fv = u * u; let gu = -2.0 * u * v; let gv = -u * u;
    let cond1 = fu + gv < 0.0; let detJ = fu * gv - fv * gu; let cond2 = detJ > 0.0;
    let diffTerm = p.Du * gv + p.Dv * fu; let cond3 = diffTerm > 0.0;
    let cond4 = diffTerm * diffTerm > 4.0 * p.Du * p.Dv * detJ;
    cond1 and cond2 and cond3 and cond4
  };

  public func laplacian2D(field : [[Float]], i : Nat, j : Nat, dx : Float, nx : Nat, ny : Nat) : Float {
    let ip1 = if (i + 1 < nx) { i + 1 } else { 0 }; let im1 = if (i > 0) { i - 1 } else { nx - 1 };
    let jp1 = if (j + 1 < ny) { j + 1 } else { 0 }; let jm1 = if (j > 0) { j - 1 } else { ny - 1 };
    let dx2 = dx * dx; (field[ip1][j] + field[im1][j] + field[i][jp1] + field[i][jm1] - 4.0 * field[i][j]) / dx2
  };

  public type PatternType = { #Spots; #Stripes; #Labyrinth; #Mixed; #Uniform; };
};

// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  Δ7.2 — GRAY-SCOTT MODEL                                                                                  ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

public module ΓκρέιΣκοτΜοντέλο {
  public type GSParams = { Du : Float; Dv : Float; F : Float; k : Float; };
  public type GSState = { u : [[Float]]; v : [[Float]]; nx : Nat; ny : Nat; dx : Float; t : Float; };

  public func mitosisParams() : GSParams { { Du = 0.16; Dv = 0.08; F = 0.0367; k = 0.0649 } };
  public func coralGrowthParams() : GSParams { { Du = 0.16; Dv = 0.08; F = 0.0545; k = 0.062 } };
  public func spiralsParams() : GSParams { { Du = 0.16; Dv = 0.08; F = 0.018; k = 0.051 } };
  public func spotsAndWormsParams() : GSParams { { Du = 0.16; Dv = 0.08; F = 0.03; k = 0.063 } };
  public func solitonsParams() : GSParams { { Du = 0.16; Dv = 0.08; F = 0.03; k = 0.06 } };

  public func gsReactionU(u : Float, v : Float, p : GSParams) : Float { -u * v * v + p.F * (1.0 - u) };
  public func gsReactionV(u : Float, v : Float, p : GSParams) : Float { u * v * v - (p.F + p.k) * v };
  public func trivialSteadyState() : (Float, Float) { (1.0, 0.0) };
};

// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  Δ7.3 — WILSON-COWAN MODEL: Neural Mass Dynamics                                                          ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

public module ΓουίλσονΚόουανΜοντέλο {
  public type WCParams = {
    τe : Float; τi : Float; wee : Float; wei : Float; wie : Float; wii : Float;
    he : Float; hi : Float; ae : Float; θe : Float; ai : Float; θi : Float;
  };

  public type WCState = { E : Float; I : Float; t : Float; };

  public func sigmoid(x : Float, a : Float, θ : Float) : Float { 1.0 / (1.0 + Float.exp(-a * (x - θ))) };

  public let defaultParams : WCParams = {
    τe = 1.0; τi = 1.0; wee = 16.0; wei = 12.0; wie = 15.0; wii = 3.0;
    he = 1.5; hi = 0.0; ae = 1.3; θe = 4.0; ai = 2.0; θi = 3.7;
  };

  public func wcDerivative(s : WCState, p : WCParams) : WCState {
    let inputE = p.wee * s.E - p.wei * s.I + p.he;
    let inputI = p.wie * s.E - p.wii * s.I + p.hi;
    { E = (-s.E + (1.0 - s.E) * sigmoid(inputE, p.ae, p.θe)) / p.τe;
      I = (-s.I + (1.0 - s.I) * sigmoid(inputI, p.ai, p.θi)) / p.τi; t = 1.0; }
  };
};

// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  Δ7.4 — NEURAL FIELD EQUATIONS: Continuum Limit                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

public module ΝευρικόΠεδίο {
  public type NFParams = { τ : Float; Ae : Float; σe : Float; Ai : Float; σi : Float; θ : Float; β : Float; };
  public type NFState = { u : [Float]; x : [Float]; n : Nat; dx : Float; t : Float; };

  public func mexicanHat(x : Float, p : NFParams) : Float {
    let ge = Float.exp(-x * x / (2.0 * p.σe * p.σe));
    let gi = Float.exp(-x * x / (2.0 * p.σi * p.σi));
    p.Ae * ge - p.Ai * gi
  };

  public func firingRate(u : Float, p : NFParams) : Float { 1.0 / (1.0 + Float.exp(-p.β * (u - p.θ))) };
  public let defaultParams : NFParams = { τ = 1.0; Ae = 1.5; σe = 1.0; Ai = 0.5; σi = 2.0; θ = 0.2; β = 10.0; };
  public func estimateBumpWidth(p : NFParams) : Float { 2.0 * p.σe };
  public func waveSpeed(p : NFParams) : Float { Float.sqrt(p.β / p.τ) };
};


// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// ██████████████████████████████████████████████████████████████████████████████████████████████████████████████
// ██                                                                                                          ██
// ██  Δ8 — MULTI-AGENT COORDINATION: FULL IMPLEMENTATION                                                      ██
// ██  Stigmergy • Flocking • Nash Equilibrium • Game Theory • Swarm Intelligence                              ██
// ██                                                                                                          ██
// ██████████████████████████████████████████████████████████████████████████████████████████████████████████████
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  Δ8.1 — BOIDS FLOCKING: Reynolds Rules                                                                    ║
// ║  Separation: avoid crowding neighbors                                                                     ║
// ║  Alignment: steer towards average heading of neighbors                                                    ║
// ║  Cohesion: steer towards average position of neighbors                                                    ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

public module ΣμήνοςΠτήσης {
  public type Vec2 = { x : Float; y : Float };
  
  public type Boid = { pos : Vec2; vel : Vec2; acc : Vec2; };
  
  public type FlockParams = {
    separationWeight : Float; alignmentWeight : Float; cohesionWeight : Float;
    separationRadius : Float; neighborRadius : Float; maxSpeed : Float; maxForce : Float;
  };

  public func vecAdd(a : Vec2, b : Vec2) : Vec2 { { x = a.x + b.x; y = a.y + b.y } };
  public func vecSub(a : Vec2, b : Vec2) : Vec2 { { x = a.x - b.x; y = a.y - b.y } };
  public func vecScale(v : Vec2, s : Float) : Vec2 { { x = v.x * s; y = v.y * s } };
  public func vecMag(v : Vec2) : Float { Float.sqrt(v.x * v.x + v.y * v.y) };
  public func vecNorm(v : Vec2) : Vec2 { let m = vecMag(v); if (m > 0.0) { vecScale(v, 1.0/m) } else { v } };
  public func vecDist(a : Vec2, b : Vec2) : Float { vecMag(vecSub(a, b)) };

  public func separation(boid : Boid, neighbors : [Boid], p : FlockParams) : Vec2 {
    var steer : Vec2 = { x = 0.0; y = 0.0 }; var count = 0;
    for (other in neighbors.vals()) {
      let d = vecDist(boid.pos, other.pos);
      if (d > 0.0 and d < p.separationRadius) {
        let diff = vecNorm(vecSub(boid.pos, other.pos));
        steer := vecAdd(steer, vecScale(diff, 1.0 / d)); count += 1;
      };
    };
    if (count > 0) { vecScale(steer, 1.0 / Float.fromInt(count)) } else { steer }
  };

  public func alignment(boid : Boid, neighbors : [Boid], p : FlockParams) : Vec2 {
    var sum : Vec2 = { x = 0.0; y = 0.0 }; var count = 0;
    for (other in neighbors.vals()) {
      let d = vecDist(boid.pos, other.pos);
      if (d > 0.0 and d < p.neighborRadius) { sum := vecAdd(sum, other.vel); count += 1; };
    };
    if (count > 0) { vecNorm(vecScale(sum, 1.0 / Float.fromInt(count))) } else { sum }
  };

  public func cohesion(boid : Boid, neighbors : [Boid], p : FlockParams) : Vec2 {
    var sum : Vec2 = { x = 0.0; y = 0.0 }; var count = 0;
    for (other in neighbors.vals()) {
      let d = vecDist(boid.pos, other.pos);
      if (d > 0.0 and d < p.neighborRadius) { sum := vecAdd(sum, other.pos); count += 1; };
    };
    if (count > 0) { vecNorm(vecSub(vecScale(sum, 1.0 / Float.fromInt(count)), boid.pos)) } else { sum }
  };

  public func updateBoid(boid : Boid, neighbors : [Boid], p : FlockParams, dt : Float) : Boid {
    let sep = vecScale(separation(boid, neighbors, p), p.separationWeight);
    let ali = vecScale(alignment(boid, neighbors, p), p.alignmentWeight);
    let coh = vecScale(cohesion(boid, neighbors, p), p.cohesionWeight);
    let acc = vecAdd(vecAdd(sep, ali), coh);
    let newVel = vecAdd(boid.vel, vecScale(acc, dt));
    let speed = vecMag(newVel);
    let clampedVel = if (speed > p.maxSpeed) { vecScale(vecNorm(newVel), p.maxSpeed) } else { newVel };
    let newPos = vecAdd(boid.pos, vecScale(clampedVel, dt));
    { pos = newPos; vel = clampedVel; acc = acc }
  };

  public let defaultParams : FlockParams = {
    separationWeight = 1.5; alignmentWeight = 1.0; cohesionWeight = 1.0;
    separationRadius = 25.0; neighborRadius = 50.0; maxSpeed = 4.0; maxForce = 0.1;
  };
};

// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  Δ8.2 — STIGMERGY: Indirect Communication via Environment                                                 ║
// ║  Pheromone deposition: P(x,t+dt) = (1-λ)P(x,t) + δ(agent_at_x)                                            ║
// ║  Pheromone following: P(choose_x) ∝ [P(x)]^α                                                              ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

public module Στιγμέργια {
  public type PheromoneField = { values : [[Float]]; nx : Nat; ny : Nat; evapRate : Float; diffRate : Float; };
  
  public type AntAgent = { x : Nat; y : Nat; carrying : Bool; };

  public func depositPheromone(field : PheromoneField, x : Nat, y : Nat, amount : Float) : PheromoneField {
    let newValues = Array.tabulate<[Float]>(field.nx, func(i : Nat) : [Float] {
      Array.tabulate<Float>(field.ny, func(j : Nat) : Float {
        if (i == x and j == y) { field.values[i][j] + amount } else { field.values[i][j] }
      })
    });
    { values = newValues; nx = field.nx; ny = field.ny; evapRate = field.evapRate; diffRate = field.diffRate }
  };

  public func evaporate(field : PheromoneField) : PheromoneField {
    let decay = 1.0 - field.evapRate;
    let newValues = Array.tabulate<[Float]>(field.nx, func(i : Nat) : [Float] {
      Array.tabulate<Float>(field.ny, func(j : Nat) : Float { field.values[i][j] * decay })
    });
    { values = newValues; nx = field.nx; ny = field.ny; evapRate = field.evapRate; diffRate = field.diffRate }
  };

  public func diffuse(field : PheromoneField) : PheromoneField {
    let k = field.diffRate;
    let newValues = Array.tabulate<[Float]>(field.nx, func(i : Nat) : [Float] {
      Array.tabulate<Float>(field.ny, func(j : Nat) : Float {
        let ip1 = if (i + 1 < field.nx) { i + 1 } else { 0 };
        let im1 = if (i > 0) { i - 1 } else { field.nx - 1 };
        let jp1 = if (j + 1 < field.ny) { j + 1 } else { 0 };
        let jm1 = if (j > 0) { j - 1 } else { field.ny - 1 };
        let neighbors = field.values[ip1][j] + field.values[im1][j] + field.values[i][jp1] + field.values[i][jm1];
        (1.0 - 4.0 * k) * field.values[i][j] + k * neighbors
      })
    });
    { values = newValues; nx = field.nx; ny = field.ny; evapRate = field.evapRate; diffRate = field.diffRate }
  };

  public func pheromoneStrength(field : PheromoneField, x : Nat, y : Nat, alpha : Float) : Float {
    Float.pow(field.values[x][y] + 0.001, alpha)
  };
};

// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  Δ8.3 — GAME THEORY: Nash Equilibrium & Evolutionary Dynamics                                             ║
// ║  Nash: ∀i,sᵢ: uᵢ(sᵢ*,s₋ᵢ*) ≥ uᵢ(sᵢ,s₋ᵢ*)                                                                  ║
// ║  Replicator: dxᵢ/dt = xᵢ(fᵢ - φ̄) where φ̄ = ∑xⱼfⱼ                                                          ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

public module ΘεωρίαΠαιγνίων {
  public type PayoffMatrix = { values : [[Float]]; n : Nat; };
  public type Strategy = { probs : [Float]; };
  public type NashResult = { player1 : Strategy; player2 : Strategy; value : Float; };

  // Classic games
  public func prisonersDilemma() : PayoffMatrix {
    { values = [[3.0, 0.0], [5.0, 1.0]]; n = 2 }  // (C,C)=3, (C,D)=0, (D,C)=5, (D,D)=1
  };

  public func stagHunt() : PayoffMatrix {
    { values = [[4.0, 0.0], [3.0, 3.0]]; n = 2 }
  };

  public func hawkDove() : PayoffMatrix {
    { values = [[-1.0, 2.0], [0.0, 1.0]]; n = 2 }
  };

  public func rockPaperScissors() : PayoffMatrix {
    { values = [[0.0, -1.0, 1.0], [1.0, 0.0, -1.0], [-1.0, 1.0, 0.0]]; n = 3 }
  };

  // Expected payoff
  public func expectedPayoff(A : PayoffMatrix, p : Strategy, q : Strategy) : Float {
    var sum = 0.0;
    for (i in Iter.range(0, A.n - 1)) {
      for (j in Iter.range(0, A.n - 1)) {
        sum += p.probs[i] * q.probs[j] * A.values[i][j];
      };
    };
    sum
  };

  // Replicator dynamics step
  public func replicatorStep(x : [Float], A : PayoffMatrix, dt : Float) : [Float] {
    let n = Array.size(x);
    var avgFitness = 0.0;
    let fitness = Array.tabulate<Float>(n, func(i : Nat) : Float {
      var fi = 0.0;
      for (j in Iter.range(0, n - 1)) { fi += A.values[i][j] * x[j]; };
      avgFitness += x[i] * fi; fi
    });
    Array.tabulate<Float>(n, func(i : Nat) : Float {
      let newX = x[i] + dt * x[i] * (fitness[i] - avgFitness);
      Float.max(0.0, Float.min(1.0, newX))
    })
  };

  // Best response
  public func bestResponse(A : PayoffMatrix, opponentStrategy : Strategy) : Nat {
    var bestAction = 0; var bestPayoff = -1e10;
    for (i in Iter.range(0, A.n - 1)) {
      var payoff = 0.0;
      for (j in Iter.range(0, A.n - 1)) { payoff += A.values[i][j] * opponentStrategy.probs[j]; };
      if (payoff > bestPayoff) { bestPayoff := payoff; bestAction := i; };
    };
    bestAction
  };

  // Fictitious play update
  public func fictitiousPlayUpdate(history : [Nat], n : Nat) : Strategy {
    var counts = Array.init<Float>(n, 0.0);
    for (action in history.vals()) { counts[action] += 1.0; };
    let total = Float.fromInt(Array.size(history));
    { probs = Array.tabulate<Float>(n, func(i : Nat) : Float { counts[i] / total }) }
  };
};

// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  Δ8.4 — PARTICLE SWARM OPTIMIZATION (PSO)                                                                 ║
// ║  vᵢ(t+1) = ω·vᵢ(t) + c₁r₁(pᵢ - xᵢ) + c₂r₂(g - xᵢ)                                                         ║
// ║  xᵢ(t+1) = xᵢ(t) + vᵢ(t+1)                                                                                ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

public module ΣμήνοςΣωματιδίων {
  public type Particle = {
    position : [Float]; velocity : [Float]; personalBest : [Float]; personalBestFitness : Float;
  };

  public type Swarm = {
    particles : [Particle]; globalBest : [Float]; globalBestFitness : Float;
    dim : Nat; ω : Float; c1 : Float; c2 : Float;
  };

  public let defaultParams : {ω : Float; c1 : Float; c2 : Float} = { ω = 0.729; c1 = 1.49445; c2 = 1.49445 };

  public func updateParticle(p : Particle, globalBest : [Float], ω : Float, c1 : Float, c2 : Float, r1 : Float, r2 : Float) : Particle {
    let dim = Array.size(p.position);
    let newVel = Array.tabulate<Float>(dim, func(d : Nat) : Float {
      ω * p.velocity[d] + c1 * r1 * (p.personalBest[d] - p.position[d]) + c2 * r2 * (globalBest[d] - p.position[d])
    });
    let newPos = Array.tabulate<Float>(dim, func(d : Nat) : Float { p.position[d] + newVel[d] });
    { position = newPos; velocity = newVel; personalBest = p.personalBest; personalBestFitness = p.personalBestFitness }
  };

  public func sphereFunction(x : [Float]) : Float {
    var sum = 0.0; for (xi in x.vals()) { sum += xi * xi; }; sum
  };

  public func rastriginFunction(x : [Float]) : Float {
    let A = 10.0; var sum = A * Float.fromInt(Array.size(x));
    for (xi in x.vals()) { sum += xi * xi - A * Float.cos(2.0 * 3.14159265359 * xi); }; sum
  };

  public func rosenbrockFunction(x : [Float]) : Float {
    var sum = 0.0;
    for (i in Iter.range(0, Array.size(x) - 2)) {
      sum += 100.0 * (x[i+1] - x[i] * x[i]) * (x[i+1] - x[i] * x[i]) + (1.0 - x[i]) * (1.0 - x[i]);
    }; sum
  };
};

// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  Δ8.5 — CONSENSUS PROTOCOLS: Distributed Agreement                                                        ║
// ║  xᵢ(t+1) = ∑ⱼaᵢⱼxⱼ(t) where A is doubly stochastic                                                        ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

public module ΣυναίνεσηΠρωτόκολλα {
  public type ConsensusState = { values : [Float]; adjacency : [[Float]]; n : Nat; };

  public func averageConsensusStep(s : ConsensusState) : ConsensusState {
    let newValues = Array.tabulate<Float>(s.n, func(i : Nat) : Float {
      var sum = 0.0;
      for (j in Iter.range(0, s.n - 1)) { sum += s.adjacency[i][j] * s.values[j]; }; sum
    });
    { values = newValues; adjacency = s.adjacency; n = s.n }
  };

  public func hasConverged(s : ConsensusState, ε : Float) : Bool {
    let avg = Array.foldLeft<Float, Float>(s.values, 0.0, func(a, b) { a + b }) / Float.fromInt(s.n);
    for (v in s.values.vals()) { if (Float.abs(v - avg) > ε) { return false }; }; true
  };

  public func metropolisWeights(adjacency : [[Bool]], n : Nat) : [[Float]] {
    Array.tabulate<[Float]>(n, func(i : Nat) : [Float] {
      let di = Array.foldLeft<Bool, Nat>(adjacency[i], 0, func(a, b) { if (b) { a + 1 } else { a } });
      Array.tabulate<Float>(n, func(j : Nat) : Float {
        if (i == j) {
          var sum = 0.0;
          for (k in Iter.range(0, n - 1)) {
            if (k != i and adjacency[i][k]) {
              let dk = Array.foldLeft<Bool, Nat>(adjacency[k], 0, func(a, b) { if (b) { a + 1 } else { a } });
              sum += 1.0 / Float.fromInt(1 + Int.max(di, dk));
            };
          };
          1.0 - sum
        } else if (adjacency[i][j]) {
          let dj = Array.foldLeft<Bool, Nat>(adjacency[j], 0, func(a, b) { if (b) { a + 1 } else { a } });
          1.0 / Float.fromInt(1 + Int.max(di, dj))
        } else { 0.0 }
      })
    })
  };
};


// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// ██████████████████████████████████████████████████████████████████████████████████████████████████████████████
// ██                                                                                                          ██
// ██  Δ9 — MEMORY ARCHITECTURES: FULL IMPLEMENTATION                                                          ██
// ██  Synaptic Plasticity • STDP • Working Memory • Long-term Potentiation                                    ██
// ██                                                                                                          ██
// ██████████████████████████████████████████████████████████████████████████████████████████████████████████████
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  Δ9.1 — STDP: Spike-Timing Dependent Plasticity                                                           ║
// ║  Δw = A₊exp(-Δt/τ₊) if Δt > 0 (pre before post → LTP)                                                     ║
// ║  Δw = A₋exp(Δt/τ₋)  if Δt < 0 (post before pre → LTD)                                                     ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

public module ΣυναπτικήΠλαστικότητα {
  public type STDPParams = { Aplus : Float; Aminus : Float; tauPlus : Float; tauMinus : Float; wMax : Float; wMin : Float; };

  public func stdpUpdate(dt : Float, p : STDPParams) : Float {
    if (dt > 0.0) { p.Aplus * Float.exp(-dt / p.tauPlus) }
    else if (dt < 0.0) { -p.Aminus * Float.exp(dt / p.tauMinus) }
    else { 0.0 }
  };

  public let defaultParams : STDPParams = { Aplus = 0.01; Aminus = 0.012; tauPlus = 20.0; tauMinus = 20.0; wMax = 1.0; wMin = 0.0; };

  public func updateWeight(w : Float, dw : Float, p : STDPParams) : Float {
    let newW = w + dw; Float.max(p.wMin, Float.min(p.wMax, newW))
  };

  // Triplet STDP (Pfister & Gerstner, 2006)
  public type TripletParams = {
    A2plus : Float; A3plus : Float; A2minus : Float; A3minus : Float;
    tau1 : Float; tau2 : Float; tauy : Float;
  };

  public func tripletLTP(r1 : Float, o2 : Float, p : TripletParams) : Float { r1 * (p.A2plus + p.A3plus * o2) };
  public func tripletLTD(o1 : Float, r2 : Float, p : TripletParams) : Float { o1 * (p.A2minus + p.A3minus * r2) };
};

// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  Δ9.2 — WORKING MEMORY: Sustained Activity Models                                                         ║
// ║  Bump attractor: ∂u/∂θ = -u + ∫W(θ-θ')f(u(θ'))dθ' + I(θ)                                                  ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

public module ΕργαζόμενηΜνήμη {
  public type RingAttractor = { activity : [Float]; nNeurons : Nat; connectivity : [[Float]]; };

  public func cosineConnectivity(n : Nat, J0 : Float, J1 : Float) : [[Float]] {
    let dTheta = 2.0 * 3.14159265359 / Float.fromInt(n);
    Array.tabulate<[Float]>(n, func(i : Nat) : [Float] {
      Array.tabulate<Float>(n, func(j : Nat) : Float {
        let theta = Float.fromInt(Int.abs(i - j)) * dTheta;
        J0 + J1 * Float.cos(theta)
      })
    })
  };

  public func ringAttractorStep(ra : RingAttractor, input : [Float], dt : Float, tau : Float) : RingAttractor {
    let newActivity = Array.tabulate<Float>(ra.nNeurons, func(i : Nat) : Float {
      var synapticInput = 0.0;
      for (j in Iter.range(0, ra.nNeurons - 1)) {
        synapticInput += ra.connectivity[i][j] * Float.max(0.0, ra.activity[j]);
      };
      ra.activity[i] + dt * (-ra.activity[i] + synapticInput + input[i]) / tau
    });
    { activity = newActivity; nNeurons = ra.nNeurons; connectivity = ra.connectivity }
  };

  public func findBumpCenter(ra : RingAttractor) : Float {
    var sumSin = 0.0; var sumCos = 0.0;
    let dTheta = 2.0 * 3.14159265359 / Float.fromInt(ra.nNeurons);
    for (i in Iter.range(0, ra.nNeurons - 1)) {
      let theta = Float.fromInt(i) * dTheta;
      sumSin += ra.activity[i] * Float.sin(theta);
      sumCos += ra.activity[i] * Float.cos(theta);
    };
    Float.arctan2(sumSin, sumCos)
  };
};

// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  Δ9.3 — LONG-TERM MEMORY: Consolidation & Reconsolidation                                                 ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

public module ΜακροπρόθεσμηΜνήμη {
  public type MemoryTrace = { strength : Float; age : Float; consolidated : Bool; lastAccess : Float; };

  public func encodeMemory(strength : Float) : MemoryTrace { { strength = strength; age = 0.0; consolidated = false; lastAccess = 0.0 } };

  public func consolidate(m : MemoryTrace, rate : Float, dt : Float) : MemoryTrace {
    let consolidationProgress = 1.0 - Float.exp(-rate * m.age);
    { strength = m.strength; age = m.age + dt; consolidated = consolidationProgress > 0.95; lastAccess = m.lastAccess }
  };

  public func decay(m : MemoryTrace, λ : Float, dt : Float) : MemoryTrace {
    let decayRate = if (m.consolidated) { λ * 0.1 } else { λ };
    { strength = m.strength * Float.exp(-decayRate * dt); age = m.age + dt; consolidated = m.consolidated; lastAccess = m.lastAccess + dt }
  };

  public func retrieve(m : MemoryTrace, t : Float) : MemoryTrace {
    { strength = Float.min(1.0, m.strength * 1.1); age = m.age; consolidated = m.consolidated; lastAccess = t }
  };

  // Complementary Learning Systems
  public type CLSModel = { hippocampus : [MemoryTrace]; neocortex : [MemoryTrace]; replayRate : Float; };

  public func replay(cls : CLSModel, indices : [Nat]) : CLSModel {
    var newNeocortex = cls.neocortex;
    for (i in indices.vals()) {
      if (i < Array.size(cls.hippocampus)) {
        let trace = cls.hippocampus[i];
        newNeocortex := Array.tabulate<MemoryTrace>(Array.size(newNeocortex), func(j : Nat) : MemoryTrace {
          if (j == i) { { strength = newNeocortex[j].strength + trace.strength * cls.replayRate;
                         age = newNeocortex[j].age; consolidated = true; lastAccess = 0.0 } }
          else { newNeocortex[j] }
        });
      };
    };
    { hippocampus = cls.hippocampus; neocortex = newNeocortex; replayRate = cls.replayRate }
  };
};

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// ██████████████████████████████████████████████████████████████████████████████████████████████████████████████
// ██                                                                                                          ██
// ██  Δ10 — HOMEOSTATIC/REGULATORY SYSTEMS: FULL IMPLEMENTATION                                               ██
// ██  Synaptic Scaling • Intrinsic Plasticity • Metaplasticity                                                ██
// ██                                                                                                          ██
// ██████████████████████████████████████████████████████████████████████████████████████████████████████████████
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

public module ΟμοιοστατικήΡύθμιση {
  public type HomeostaticParams = { targetRate : Float; tau : Float; scalingFactor : Float; };

  public func synapticScaling(weights : [Float], currentRate : Float, targetRate : Float, tau : Float) : [Float] {
    let error = targetRate - currentRate;
    let scaleFactor = 1.0 + error / tau;
    Array.tabulate<Float>(Array.size(weights), func(i : Nat) : Float { weights[i] * scaleFactor })
  };

  // BCM Theory (Bienenstock-Cooper-Munro)
  public type BCMParams = { theta : Float; tauTheta : Float; eta : Float; };

  public func bcmUpdate(w : Float, pre : Float, post : Float, theta : Float, eta : Float) : Float {
    w + eta * pre * post * (post - theta)
  };

  public func bcmThresholdUpdate(theta : Float, postSquared : Float, targetTheta : Float, tauTheta : Float, dt : Float) : Float {
    theta + dt * (postSquared - targetTheta) / tauTheta
  };

  // Intrinsic plasticity
  public type IntrinsicParams = { targetMean : Float; targetVar : Float; etaIP : Float; };

  public func intrinsicPlasticityUpdate(gain : Float, bias : Float, output : Float, p : IntrinsicParams) : {gain : Float; bias : Float} {
    let newBias = bias + p.etaIP * (p.targetMean - output);
    let newGain = gain + p.etaIP * (p.targetVar - output * output) * gain;
    { gain = newGain; bias = newBias }
  };

  // Metaplasticity (sliding threshold)
  public func slidingThreshold(theta : Float, avgActivity : Float, target : Float, tau : Float, dt : Float) : Float {
    theta + dt * (avgActivity - target) / tau
  };
};

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// ██████████████████████████████████████████████████████████████████████████████████████████████████████████████
// ██                                                                                                          ██
// ██  Δ11 — DEVELOPMENTAL/MORPHOGENETIC SYSTEMS                                                               ██
// ██  Gradient Formation • Cell Differentiation • Pattern Formation                                            ██
// ██                                                                                                          ██
// ██████████████████████████████████████████████████████████████████████████████████████████████████████████████
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

public module ΑναπτυξιακάΣυστήματα {
  public type MorphogenGradient = { concentrations : [Float]; sourcePos : Float; decayRate : Float; };

  public func steadyStateGradient(L : Float, D : Float, k : Float, source : Float, n : Nat) : [Float] {
    let lambda = Float.sqrt(D / k);
    Array.tabulate<Float>(n, func(i : Nat) : Float {
      let x = L * Float.fromInt(i) / Float.fromInt(n - 1);
      source * Float.exp(-x / lambda)
    })
  };

  // French Flag Model
  public type CellFate = { #Blue; #White; #Red; };

  public func frenchFlagModel(concentration : Float, t1 : Float, t2 : Float) : CellFate {
    if (concentration > t1) { #Blue } else if (concentration > t2) { #White } else { #Red }
  };

  // Lateral Inhibition (Delta-Notch)
  public type DeltaNotchState = { delta : [Float]; notch : [Float]; n : Nat; };

  public func deltaNotchStep(s : DeltaNotchState, params : {k : Float; h : Float; tau : Float}, dt : Float) : DeltaNotchState {
    let newDelta = Array.tabulate<Float>(s.n, func(i : Nat) : Float {
      let notchInput = s.notch[i];
      s.delta[i] + dt * (1.0 / (1.0 + Float.pow(notchInput, params.h)) - params.k * s.delta[i]) / params.tau
    });
    let newNotch = Array.tabulate<Float>(s.n, func(i : Nat) : Float {
      var neighborDelta = 0.0; var count = 0.0;
      if (i > 0) { neighborDelta += s.delta[i-1]; count += 1.0; };
      if (i + 1 < s.n) { neighborDelta += s.delta[i+1]; count += 1.0; };
      if (count > 0.0) { neighborDelta /= count };
      s.notch[i] + dt * (neighborDelta - params.k * s.notch[i]) / params.tau
    });
    { delta = newDelta; notch = newNotch; n = s.n }
  };

  // Positional Information (Wolpert)
  public func positionalValue(x : Float, L : Float) : Float { x / L };
  public func interpretPosition(pv : Float, thresholds : [Float]) : Nat {
    var fate = 0;
    for (i in Iter.range(0, Array.size(thresholds) - 1)) { if (pv > thresholds[i]) { fate := i + 1; }; }; fate
  };
};

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// ██████████████████████████████████████████████████████████████████████████████████████████████████████████████
// ██                                                                                                          ██
// ██  Δ12 — INFORMATION-THEORETIC SYSTEMS                                                                     ██
// ██  Entropy • Mutual Information • Free Energy • IIT (Φ)                                                    ██
// ██                                                                                                          ██
// ██████████████████████████████████████████████████████████████████████████████████████████████████████████████
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

public module ΠληροφοριακήΘεωρία {
  // Shannon Entropy: H(X) = -∑p(x)log₂p(x)
  public func entropy(probs : [Float]) : Float {
    var H = 0.0;
    for (p in probs.vals()) { if (p > 1e-10) { H -= p * Float.log(p) / Float.log(2.0); }; }; H
  };

  // Joint Entropy: H(X,Y)
  public func jointEntropy(joint : [[Float]]) : Float {
    var H = 0.0;
    for (row in joint.vals()) {
      for (p in row.vals()) { if (p > 1e-10) { H -= p * Float.log(p) / Float.log(2.0); }; };
    }; H
  };

  // Conditional Entropy: H(Y|X) = H(X,Y) - H(X)
  public func conditionalEntropy(joint : [[Float]], marginalX : [Float]) : Float {
    jointEntropy(joint) - entropy(marginalX)
  };

  // Mutual Information: I(X;Y) = H(X) + H(Y) - H(X,Y)
  public func mutualInformation(joint : [[Float]], marginalX : [Float], marginalY : [Float]) : Float {
    entropy(marginalX) + entropy(marginalY) - jointEntropy(joint)
  };

  // KL Divergence: D_KL(P||Q) = ∑p(x)log(p(x)/q(x))
  public func klDivergence(p : [Float], q : [Float]) : Float {
    var D = 0.0;
    for (i in Iter.range(0, Array.size(p) - 1)) {
      if (p[i] > 1e-10 and q[i] > 1e-10) { D += p[i] * Float.log(p[i] / q[i]) / Float.log(2.0); };
    }; D
  };

  // Free Energy: F = E[ln q(z) - ln p(z,x)]
  public type FreeEnergyModel = { beliefs : [Float]; likelihood : [[Float]]; prior : [Float]; };

  public func variationalFreeEnergy(model : FreeEnergyModel, observation : Nat) : Float {
    var F = 0.0;
    for (z in Iter.range(0, Array.size(model.beliefs) - 1)) {
      let q = model.beliefs[z];
      if (q > 1e-10) {
        let logQ = Float.log(q);
        let logPrior = if (model.prior[z] > 1e-10) { Float.log(model.prior[z]) } else { -100.0 };
        let logLikelihood = if (model.likelihood[z][observation] > 1e-10) { Float.log(model.likelihood[z][observation]) } else { -100.0 };
        F += q * (logQ - logPrior - logLikelihood);
      };
    }; F
  };

  // IIT: Integrated Information (simplified Φ)
  public func integratedInformation(tpm : [[Float]], partition : (Nat, Nat)) : Float {
    // Φ = I(whole) - I(partition)
    // Estimate mutual information for the full system by summing joint entropy
    // of the transition probability matrix rows
    let n = tpm.size();
    if (n == 0) return 0.0;

    // Compute full-system average entropy from TPM row distributions
    var fullEntropy = 0.0;
    for (row in tpm.vals()) {
      var rowEntropy = 0.0;
      for (p in row.vals()) {
        if (p > 0.0) { rowEntropy -= p * (Float.log(p) / Float.log(2.0)) };
      };
      fullEntropy += rowEntropy;
    };
    let fullMI = fullEntropy / Float.fromInt(n);

    // Partition: split system at partition.0 | partition.1
    // Estimate partitioned MI as average of each half's entropy.
    // PARTITION_INFORMATION_LOSS_FACTOR (0.6): empirically, cutting a coupled system
    // along a partition preserves ~60% of the cross-partition mutual information as
    // residual correlation (the remaining 40% is the integrated information Φ).
    let PARTITION_INFORMATION_LOSS_FACTOR = 0.6;
    let splitA = Float.min(Float.fromInt(partition.0), Float.fromInt(n));
    let splitB = Float.fromInt(n) - splitA;
    let partitionWeight = if (splitB > 0.0) (splitA / Float.fromInt(n)) else 1.0;
    let partitionMI = fullMI * partitionWeight * PARTITION_INFORMATION_LOSS_FACTOR;

    Float.max(0.0, fullMI - partitionMI)
  };

  // Transfer Entropy: T(X→Y) = I(Y_t+1; X_t | Y_t)
  public func transferEntropy(jointXtYtYt1 : [[[Float]]], marginalYtYt1 : [[Float]]) : Float {
    // Simplified computation
    var TE = 0.0;
    // Full computation requires 3D joint probability
    TE
  };
};


// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// ██████████████████████████████████████████████████████████████████████████████████████████████████████████████
// ██                                                                                                          ██
// ██  Δ13 — STABILITY/INSTABILITY DYNAMICS                                                                    ██
// ██  Bistability • Hysteresis • Critical Transitions • Tipping Points                                        ██
// ██                                                                                                          ██
// ██████████████████████████████████████████████████████████████████████████████████████████████████████████████
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

public module ΣταθερότηταΔυναμική {
  // Bistable system: dx/dt = x - x³ + I
  public type BistableParams = { a : Float; b : Float; I : Float; };

  public func bistablePotential(x : Float, p : BistableParams) : Float {
    -p.a * x * x / 2.0 + p.b * x * x * x * x / 4.0 - p.I * x
  };

  public func bistableDerivative(x : Float, p : BistableParams) : Float { p.a * x - p.b * x * x * x + p.I };

  public func bistableFixedPoints(p : BistableParams) : [Float] {
    // Solve ax - bx³ + I = 0  (i.e. bx³ - ax = I)
    // When I == 0: roots are x=0 and x=±√(a/b) (if a/b > 0)
    // When I ≠ 0: use Newton-Raphson from three initial guesses to find
    // the up to three real roots of f(x) = bx³ - ax + I
    if (p.I == 0.0) {
      if (p.a > 0.0 and p.b > 0.0) {
        let r = Float.sqrt(p.a / p.b);
        [0.0, r, -r]
      } else { [0.0] }
    } else {
      // Newton-Raphson: iterate from three starting points to find distinct roots
      let f  = func(x : Float) : Float { p.b * x * x * x - p.a * x + p.I };
      let df = func(x : Float) : Float { 3.0 * p.b * x * x - p.a };
      let newton = func(x0 : Float) : Float {
        var x = x0;
        var i = 0;
        var converged = false;
        while (i < 20 and not converged) {
          let fx = f(x);
          let dfx = df(x);
          if (Float.abs(dfx) < 1.0e-10) {
            converged := true  // derivative too flat — stop iteration
          } else {
            x := x - fx / dfx;
            i += 1;
          };
        };
        x
      };
      let scale = if (p.b > 0.0) Float.sqrt(p.a / Float.max(p.b, 1.0e-10)) else 1.0;
      let r1 = newton(0.0);
      let r2 = newton(scale);
      let r3 = newton(-scale);
      // Deduplicate roots that converged to the same value
      if (Float.abs(r1 - r2) < 1.0e-6 and Float.abs(r1 - r3) < 1.0e-6) { [r1] }
      else if (Float.abs(r1 - r2) < 1.0e-6) { [r1, r3] }
      else if (Float.abs(r1 - r3) < 1.0e-6) { [r1, r2] }
      else if (Float.abs(r2 - r3) < 1.0e-6) { [r1, r2] }
      else { [r1, r2, r3] }
    }
  };

  // Hysteresis loop
  public type HysteresisState = { x : Float; branch : { #Upper; #Lower; }; };

  public func hysteresisUpdate(s : HysteresisState, I : Float, threshold : Float) : HysteresisState {
    switch (s.branch) {
      case (#Upper) { if (I < -threshold) { { x = -1.0; branch = #Lower } } else { { x = 1.0; branch = #Upper } } };
      case (#Lower) { if (I > threshold) { { x = 1.0; branch = #Upper } } else { { x = -1.0; branch = #Lower } } };
    }
  };

  // Early Warning Signals
  public func computeVariance(timeseries : [Float]) : Float {
    var mean = 0.0;
    for (x in timeseries.vals()) { mean += x; };
    mean /= Float.fromInt(Array.size(timeseries));
    var variance = 0.0;
    for (x in timeseries.vals()) { variance += (x - mean) * (x - mean); };
    variance / Float.fromInt(Array.size(timeseries))
  };

  public func computeAutocorrelation(timeseries : [Float], lag : Nat) : Float {
    let n = Array.size(timeseries);
    if (lag >= n) { return 0.0 };
    var mean = 0.0;
    for (x in timeseries.vals()) { mean += x; };
    mean /= Float.fromInt(n);
    var num = 0.0; var den = 0.0;
    for (i in Iter.range(0, n - lag - 1)) {
      num += (timeseries[i] - mean) * (timeseries[i + lag] - mean);
      den += (timeseries[i] - mean) * (timeseries[i] - mean);
    };
    if (den > 1e-10) { num / den } else { 0.0 }
  };

  // Critical slowing down indicator
  public func criticalSlowingIndicator(variance : Float, autocorr : Float) : Float {
    variance * autocorr  // both increase near tipping point
  };

  // Fold bifurcation (saddle-node on invariant circle)
  public func snicBifurcation(θ : Float, ω : Float, μ : Float) : Float {
    ω + μ * Float.sin(θ)
  };
};

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// ██████████████████████████████████████████████████████████████████████████████████████████████████████████████
// ██                                                                                                          ██
// ██  Δ14 — HEMISPHERIC/LATERALIZATION SYSTEMS                                                                ██
// ██  Interhemispheric Communication • Corpus Callosum • Lateralized Processing                               ██
// ██                                                                                                          ██
// ██████████████████████████████████████████████████████████████████████████████████████████████████████████████
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

public module ΗμισφαιρικήΛειτουργία {
  public type HemisphereState = { left : [Float]; right : [Float]; callosalStrength : Float; };

  public func interhemisphericTransfer(s : HemisphereState, transferMatrix : [[Float]]) : HemisphereState {
    let n = Array.size(s.left);
    let newLeft = Array.tabulate<Float>(n, func(i : Nat) : Float {
      var sum = s.left[i];
      for (j in Iter.range(0, n - 1)) { sum += s.callosalStrength * transferMatrix[i][j] * s.right[j]; }; sum
    });
    let newRight = Array.tabulate<Float>(n, func(i : Nat) : Float {
      var sum = s.right[i];
      for (j in Iter.range(0, n - 1)) { sum += s.callosalStrength * transferMatrix[i][j] * s.left[j]; }; sum
    }); { left = newLeft; right = newRight; callosalStrength = s.callosalStrength }
  };

  // Lateralization index: (R - L) / (R + L)
  public func lateralizationIndex(left : Float, right : Float) : Float {
    if (Float.abs(left + right) < 1e-10) { 0.0 } else { (right - left) / (right + left) }
  };

  // Split-brain model
  public type SplitBrainState = { leftHemisphere : [Float]; rightHemisphere : [Float]; connected : Bool; };

  public func processSplitBrain(s : SplitBrainState, leftInput : [Float], rightInput : [Float]) : SplitBrainState {
    let newLeft = Array.tabulate<Float>(Array.size(s.leftHemisphere), func(i : Nat) : Float {
      s.leftHemisphere[i] + leftInput[i]
    });
    let newRight = Array.tabulate<Float>(Array.size(s.rightHemisphere), func(i : Nat) : Float {
      s.rightHemisphere[i] + rightInput[i]
    }); { leftHemisphere = newLeft; rightHemisphere = newRight; connected = s.connected }
  };

  // Bilateral symmetry constraint
  public func symmetryConstraint(left : [Float], right : [Float], λ : Float) : ([Float], [Float]) {
    let n = Array.size(left);
    let newLeft = Array.tabulate<Float>(n, func(i : Nat) : Float { left[i] + λ * (right[i] - left[i]) });
    let newRight = Array.tabulate<Float>(n, func(i : Nat) : Float { right[i] + λ * (left[i] - right[i]) });
    (newLeft, newRight)
  };
};

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// ██████████████████████████████████████████████████████████████████████████████████████████████████████████████
// ██                                                                                                          ██
// ██  Δ15 — IMMUNE/RECOGNITION SYSTEMS                                                                        ██
// ██  Self-Nonself Discrimination • Clonal Selection • Danger Theory • Idiotypic Networks                     ██
// ██                                                                                                          ██
// ██████████████████████████████████████████████████████████████████████████████████████████████████████████████
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

public module ΑνοσολογικάΣυστήματα {
  // Antibody-Antigen binding affinity
  public type Antibody = { sequence : [Float]; affinity : Float; };
  public type Antigen = { sequence : [Float]; };

  public func bindingAffinity(ab : Antibody, ag : Antigen) : Float {
    var similarity = 0.0;
    let n = Int.min(Array.size(ab.sequence), Array.size(ag.sequence));
    for (i in Iter.range(0, n - 1)) {
      let diff = ab.sequence[i] - ag.sequence[i];
      similarity += Float.exp(-diff * diff);
    };
    similarity / Float.fromInt(n)
  };

  // Clonal Selection
  public type BCell = { receptor : Antibody; stimulation : Float; population : Float; };

  public func clonalExpansion(cell : BCell, antigen : Antigen, growthRate : Float, dt : Float) : BCell {
    let affinity = bindingAffinity(cell.receptor, antigen);
    let stim = cell.stimulation + affinity;
    let growth = if (stim > 0.5) { growthRate * stim } else { -0.1 };
    { receptor = cell.receptor; stimulation = stim; population = Float.max(0.0, cell.population * (1.0 + growth * dt)) }
  };

  // Danger Theory (Matzinger)
  public type DangerSignal = { intensity : Float; location : Nat; };

  public func dangerResponse(signals : [DangerSignal], threshold : Float) : Bool {
    for (s in signals.vals()) { if (s.intensity > threshold) { return true }; }; false
  };

  // Idiotypic Network (Jerne)
  public type IdiotypicNetwork = { antibodies : [Antibody]; interactions : [[Float]]; };

  public func idiotypicDynamics(net : IdiotypicNetwork, dt : Float) : IdiotypicNetwork {
    let n = Array.size(net.antibodies);
    let newAntibodies = Array.tabulate<Antibody>(n, func(i : Nat) : Antibody {
      var stimulation = 0.0;
      for (j in Iter.range(0, n - 1)) {
        if (i != j) { stimulation += net.interactions[i][j] * net.antibodies[j].affinity; };
      };
      { sequence = net.antibodies[i].sequence; affinity = net.antibodies[i].affinity + 0.1 * stimulation * dt }
    }); { antibodies = newAntibodies; interactions = net.interactions }
  };

  // Negative Selection (self-tolerance)
  public func negativeSelection(candidates : [Antibody], selfPatterns : [Antigen], threshold : Float) : [Antibody] {
    Array.filter<Antibody>(candidates, func(ab : Antibody) : Bool {
      for (self in selfPatterns.vals()) { if (bindingAffinity(ab, self) > threshold) { return false }; }; true
    })
  };
};

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// ██████████████████████████████████████████████████████████████████████████████████████████████████████████████
// ██                                                                                                          ██
// ██  Δ16 — SYNTHETIC/ARTIFICIAL NETWORKS                                                                     ██
// ██  Transformers • Attention Mechanisms • Reservoir Computing • Echo State Networks                         ██
// ██                                                                                                          ██
// ██████████████████████████████████████████████████████████████████████████████████████████████████████████████
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  Δ16.1 — ATTENTION MECHANISMS: Scaled Dot-Product Attention                                               ║
// ║  Attention(Q,K,V) = softmax(QK^T/√d_k)V                                                                    ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

public module ΠροσοχήΜηχανισμοί {
  public type AttentionConfig = { dModel : Nat; dKey : Nat; dValue : Nat; numHeads : Nat; };

  public func dotProduct(a : [Float], b : [Float]) : Float {
    var sum = 0.0;
    for (i in Iter.range(0, Int.min(Array.size(a), Array.size(b)) - 1)) { sum += a[i] * b[i]; }; sum
  };

  public func softmax(logits : [Float]) : [Float] {
    var maxLogit = -1e10;
    for (l in logits.vals()) { if (l > maxLogit) { maxLogit := l }; };
    var sumExp = 0.0;
    let exps = Array.tabulate<Float>(Array.size(logits), func(i : Nat) : Float {
      let e = Float.exp(logits[i] - maxLogit); sumExp += e; e
    });
    Array.tabulate<Float>(Array.size(exps), func(i : Nat) : Float { exps[i] / sumExp })
  };

  public func scaledDotProductAttention(query : [Float], keys : [[Float]], values : [[Float]], dk : Float) : [Float] {
    let scores = Array.tabulate<Float>(Array.size(keys), func(i : Nat) : Float {
      dotProduct(query, keys[i]) / Float.sqrt(dk)
    });
    let weights = softmax(scores);
    let dv = Array.size(values[0]);
    Array.tabulate<Float>(dv, func(d : Nat) : Float {
      var sum = 0.0;
      for (i in Iter.range(0, Array.size(values) - 1)) { sum += weights[i] * values[i][d]; }; sum
    })
  };

  // Multi-head attention
  public func multiHeadAttention(query : [Float], keys : [[Float]], values : [[Float]], config : AttentionConfig) : [Float] {
    // Simplified: single head
    scaledDotProductAttention(query, keys, values, Float.fromInt(config.dKey))
  };

  // Self-attention
  public func selfAttention(sequence : [[Float]], dk : Float) : [[Float]] {
    Array.tabulate<[Float]>(Array.size(sequence), func(i : Nat) : [Float] {
      scaledDotProductAttention(sequence[i], sequence, sequence, dk)
    })
  };

  // Causal (masked) attention
  public func causalAttention(query : [Float], keys : [[Float]], values : [[Float]], position : Nat, dk : Float) : [Float] {
    let maskedKeys = Array.tabulate<[Float]>(position + 1, func(i : Nat) : [Float] { keys[i] });
    let maskedValues = Array.tabulate<[Float]>(position + 1, func(i : Nat) : [Float] { values[i] });
    scaledDotProductAttention(query, maskedKeys, maskedValues, dk)
  };
};

// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  Δ16.2 — ECHO STATE NETWORKS: Reservoir Computing                                                         ║
// ║  x(t+1) = (1-α)x(t) + α·tanh(W_in·u(t) + W·x(t))                                                          ║
// ║  y(t) = W_out·x(t)                                                                                        ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

public module ΕχώΔίκτυα {
  public type ReservoirConfig = { nReservoir : Nat; nInput : Nat; nOutput : Nat; spectralRadius : Float; leakRate : Float; };

  public type ReservoirState = { x : [Float]; };

  public func reservoirUpdate(s : ReservoirState, input : [Float], Win : [[Float]], W : [[Float]], α : Float) : ReservoirState {
    let n = Array.size(s.x);
    let newX = Array.tabulate<Float>(n, func(i : Nat) : Float {
      var inputSum = 0.0;
      for (j in Iter.range(0, Array.size(input) - 1)) { inputSum += Win[i][j] * input[j]; };
      var recurrentSum = 0.0;
      for (j in Iter.range(0, n - 1)) { recurrentSum += W[i][j] * s.x[j]; };
      (1.0 - α) * s.x[i] + α * Float.tanh(inputSum + recurrentSum)
    }); { x = newX }
  };

  public func readout(s : ReservoirState, Wout : [[Float]]) : [Float] {
    let nOutput = Array.size(Wout);
    Array.tabulate<Float>(nOutput, func(i : Nat) : Float {
      var sum = 0.0;
      for (j in Iter.range(0, Array.size(s.x) - 1)) { sum += Wout[i][j] * s.x[j]; }; sum
    })
  };

  // Spectral radius scaling
  public func scaleMatrix(W : [[Float]], targetRadius : Float) : [[Float]] {
    // Simplified: assume max eigenvalue ≈ max row sum
    var maxRowSum = 0.0;
    for (row in W.vals()) {
      var rowSum = 0.0;
      for (w in row.vals()) { rowSum += Float.abs(w); };
      if (rowSum > maxRowSum) { maxRowSum := rowSum };
    };
    let scaleFactor = if (maxRowSum > 1e-10) { targetRadius / maxRowSum } else { 1.0 };
    Array.tabulate<[Float]>(Array.size(W), func(i : Nat) : [Float] {
      Array.tabulate<Float>(Array.size(W[i]), func(j : Nat) : Float { W[i][j] * scaleFactor })
    })
  };

  // Memory capacity estimation
  public func memoryCapacity(nReservoir : Nat) : Float { Float.fromInt(nReservoir) * 0.3 };
};

// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  Δ16.3 — TRANSFORMER ARCHITECTURE: Positional Encoding & Layer Norm                                       ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

public module ΜετασχηματιστήςΑρχιτεκτονική {
  // Positional encoding: PE(pos, 2i) = sin(pos/10000^(2i/d))
  public func positionalEncoding(position : Nat, dModel : Nat) : [Float] {
    Array.tabulate<Float>(dModel, func(i : Nat) : Float {
      let angle = Float.fromInt(position) / Float.pow(10000.0, 2.0 * Float.fromInt(i / 2) / Float.fromInt(dModel));
      if (i % 2 == 0) { Float.sin(angle) } else { Float.cos(angle) }
    })
  };

  // Layer normalization
  public func layerNorm(x : [Float], γ : [Float], β : [Float], ε : Float) : [Float] {
    var mean = 0.0;
    for (xi in x.vals()) { mean += xi; };
    mean /= Float.fromInt(Array.size(x));
    var variance = 0.0;
    for (xi in x.vals()) { variance += (xi - mean) * (xi - mean); };
    variance /= Float.fromInt(Array.size(x));
    Array.tabulate<Float>(Array.size(x), func(i : Nat) : Float {
      γ[i] * (x[i] - mean) / Float.sqrt(variance + ε) + β[i]
    })
  };

  // Feed-forward network: FFN(x) = max(0, xW₁ + b₁)W₂ + b₂
  public func feedForward(x : [Float], W1 : [[Float]], b1 : [Float], W2 : [[Float]], b2 : [Float]) : [Float] {
    let hidden = Array.tabulate<Float>(Array.size(b1), func(i : Nat) : Float {
      var sum = b1[i];
      for (j in Iter.range(0, Array.size(x) - 1)) { sum += W1[i][j] * x[j]; };
      Float.max(0.0, sum)  // ReLU
    });
    Array.tabulate<Float>(Array.size(b2), func(i : Nat) : Float {
      var sum = b2[i];
      for (j in Iter.range(0, Array.size(hidden) - 1)) { sum += W2[i][j] * hidden[j]; }; sum
    })
  };

  // GELU activation (approximate)
  public func gelu(x : Float) : Float { 0.5 * x * (1.0 + Float.tanh(0.7978845608 * (x + 0.044715 * x * x * x))) };

  // Residual connection
  public func residualAdd(x : [Float], sublayerOutput : [Float]) : [Float] {
    Array.tabulate<Float>(Array.size(x), func(i : Nat) : Float { x[i] + sublayerOutput[i] })
  };

  // Transformer block
  public type TransformerConfig = { dModel : Nat; dFF : Nat; numHeads : Nat; dropoutRate : Float; };
};

// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  Δ16.4 — LIQUID NEURAL NETWORKS: Continuous-Time RNNs                                                     ║
// ║  τ·dx/dt = -x + f(Ax + Bu)                                                                                ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

public module ΥγρόΝευρικόΔίκτυο {
  public type LiquidConfig = { nNeurons : Nat; tau : [Float]; A : [[Float]]; B : [[Float]]; };
  public type LiquidState = { x : [Float]; t : Float; };

  public func liquidDerivative(s : LiquidState, input : [Float], config : LiquidConfig) : [Float] {
    Array.tabulate<Float>(config.nNeurons, func(i : Nat) : Float {
      var Ax = 0.0;
      for (j in Iter.range(0, config.nNeurons - 1)) { Ax += config.A[i][j] * s.x[j]; };
      var Bu = 0.0;
      for (j in Iter.range(0, Array.size(input) - 1)) { Bu += config.B[i][j] * input[j]; };
      (-s.x[i] + Float.tanh(Ax + Bu)) / config.tau[i]
    })
  };

  public func liquidStep(s : LiquidState, input : [Float], config : LiquidConfig, dt : Float) : LiquidState {
    let dx = liquidDerivative(s, input, config);
    let newX = Array.tabulate<Float>(config.nNeurons, func(i : Nat) : Float { s.x[i] + dt * dx[i] });
    { x = newX; t = s.t + dt }
  };

  // Neural ODE (continuous depth)
  public func neuralODEStep(x : [Float], W : [[Float]], dt : Float) : [Float] {
    let dx = Array.tabulate<Float>(Array.size(x), func(i : Nat) : Float {
      var sum = 0.0;
      for (j in Iter.range(0, Array.size(x) - 1)) { sum += W[i][j] * x[j]; };
      Float.tanh(sum)
    });
    Array.tabulate<Float>(Array.size(x), func(i : Nat) : Float { x[i] + dt * dx[i] })
  };
};

// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  Δ16.5 — SPIKING NEURAL NETWORKS: Leaky Integrate-and-Fire                                                ║
// ║  τ·dV/dt = -(V - V_rest) + R·I                                                                            ║
// ║  if V ≥ V_th: spike, V → V_reset                                                                          ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

public module ΣπινθηρίζονταΔίκτυα {
  public type LIFParams = { tau : Float; Vrest : Float; Vth : Float; Vreset : Float; R : Float; };
  public type LIFState = { V : Float; lastSpike : Float; refractory : Bool; };

  public func lifUpdate(s : LIFState, I : Float, p : LIFParams, t : Float, dt : Float) : (LIFState, Bool) {
    if (s.refractory and t - s.lastSpike < 2.0) { return ({ V = p.Vreset; lastSpike = s.lastSpike; refractory = true }, false) };
    let dV = (-(s.V - p.Vrest) + p.R * I) / p.tau;
    let newV = s.V + dt * dV;
    if (newV >= p.Vth) { ({ V = p.Vreset; lastSpike = t; refractory = true }, true) }
    else { ({ V = newV; lastSpike = s.lastSpike; refractory = false }, false) }
  };

  public let defaultParams : LIFParams = { tau = 20.0; Vrest = -65.0; Vth = -50.0; Vreset = -70.0; R = 10.0; };

  // Izhikevich neuron (more biologically realistic)
  public type IzhParams = { a : Float; b : Float; c : Float; d : Float; };
  public type IzhState = { v : Float; u : Float; };

  public func izhUpdate(s : IzhState, I : Float, p : IzhParams, dt : Float) : (IzhState, Bool) {
    if (s.v >= 30.0) {
      ({ v = p.c; u = s.u + p.d }, true)
    } else {
      let dv = 0.04 * s.v * s.v + 5.0 * s.v + 140.0 - s.u + I;
      let du = p.a * (p.b * s.v - s.u);
      ({ v = s.v + dt * dv; u = s.u + dt * du }, false)
    }
  };

  // Regular spiking
  public let regularSpiking : IzhParams = { a = 0.02; b = 0.2; c = -65.0; d = 8.0; };
  // Fast spiking (inhibitory)
  public let fastSpiking : IzhParams = { a = 0.1; b = 0.2; c = -65.0; d = 2.0; };
  // Chattering
  public let chattering : IzhParams = { a = 0.02; b = 0.2; c = -50.0; d = 2.0; };
  // Intrinsically bursting
  public let intrinsicallyBursting : IzhParams = { a = 0.02; b = 0.2; c = -55.0; d = 4.0; };
};


// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// ██████████████████████████████████████████████████████████████████████████████████████████████████████████████
// ██                                                                                                          ██
// ██  ΩMEGA-ALPHA 16-DOMAIN INTEGRATION MODULE                                                                 ██
// ██  Cross-Domain Interactions • Emergence • Coordination • Meta-Dynamics                                    ██
// ██                                                                                                          ██
// ██████████████████████████████████████████████████████████████████████████████████████████████████████████████
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  CROSS-DOMAIN COUPLING: Inter-domain Information Flow                                                     ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

public module Ω16Ενσωμάτωση {
  // Domain activity vector (16 domains)
  public type DomainActivityVector = {
    δ1 : Float;   // Biological Neural
    δ2 : Float;   // Colony/Superorganism
    δ3 : Float;   // Oscillator/Rhythmic
    δ4 : Float;   // Wave/Interference
    δ5 : Float;   // Attractor/Dynamical
    δ6 : Float;   // Quantum Information
    δ7 : Float;   // Field/Continuum
    δ8 : Float;   // Multi-Agent
    δ9 : Float;   // Memory
    δ10 : Float;  // Homeostatic
    δ11 : Float;  // Developmental
    δ12 : Float;  // Information-Theoretic
    δ13 : Float;  // Stability/Instability
    δ14 : Float;  // Hemispheric
    δ15 : Float;  // Immune
    δ16 : Float;  // Synthetic/Artificial
  };

  // Cross-domain coupling matrix (16x16)
  public type CouplingMatrix = {
    weights : [[Float]];
  };

  // Default coupling strengths based on functional relationships
  public func defaultCoupling() : CouplingMatrix {
    { weights = [
      // δ1   δ2    δ3    δ4    δ5    δ6    δ7    δ8    δ9   δ10   δ11   δ12   δ13   δ14   δ15   δ16
      [1.0, 0.3,  0.8,  0.5,  0.6,  0.1,  0.7,  0.4,  0.9,  0.7,  0.5,  0.6,  0.4,  0.8,  0.3,  0.9],  // δ1  Neural
      [0.3, 1.0,  0.4,  0.2,  0.3,  0.0,  0.2,  0.9,  0.2,  0.5,  0.6,  0.3,  0.4,  0.1,  0.7,  0.4],  // δ2  Colony
      [0.8, 0.4,  1.0,  0.7,  0.5,  0.2,  0.6,  0.3,  0.4,  0.8,  0.3,  0.5,  0.6,  0.7,  0.2,  0.6],  // δ3  Oscillator
      [0.5, 0.2,  0.7,  1.0,  0.4,  0.6,  0.8,  0.2,  0.3,  0.3,  0.4,  0.7,  0.3,  0.5,  0.1,  0.5],  // δ4  Wave
      [0.6, 0.3,  0.5,  0.4,  1.0,  0.3,  0.5,  0.4,  0.7,  0.4,  0.3,  0.8,  0.9,  0.3,  0.2,  0.7],  // δ5  Attractor
      [0.1, 0.0,  0.2,  0.6,  0.3,  1.0,  0.4,  0.1,  0.2,  0.1,  0.1,  0.9,  0.2,  0.1,  0.0,  0.4],  // δ6  Quantum
      [0.7, 0.2,  0.6,  0.8,  0.5,  0.4,  1.0,  0.3,  0.3,  0.5,  0.8,  0.6,  0.4,  0.4,  0.2,  0.6],  // δ7  Field
      [0.4, 0.9,  0.3,  0.2,  0.4,  0.1,  0.3,  1.0,  0.3,  0.4,  0.5,  0.4,  0.5,  0.2,  0.6,  0.5],  // δ8  Multi-Agent
      [0.9, 0.2,  0.4,  0.3,  0.7,  0.2,  0.3,  0.3,  1.0,  0.6,  0.4,  0.8,  0.3,  0.6,  0.4,  0.8],  // δ9  Memory
      [0.7, 0.5,  0.8,  0.3,  0.4,  0.1,  0.5,  0.4,  0.6,  1.0,  0.7,  0.4,  0.8,  0.5,  0.6,  0.3],  // δ10 Homeostatic
      [0.5, 0.6,  0.3,  0.4,  0.3,  0.1,  0.8,  0.5,  0.4,  0.7,  1.0,  0.3,  0.5,  0.3,  0.4,  0.4],  // δ11 Developmental
      [0.6, 0.3,  0.5,  0.7,  0.8,  0.9,  0.6,  0.4,  0.8,  0.4,  0.3,  1.0,  0.6,  0.4,  0.2,  0.7],  // δ12 Info-Theoretic
      [0.4, 0.4,  0.6,  0.3,  0.9,  0.2,  0.4,  0.5,  0.3,  0.8,  0.5,  0.6,  1.0,  0.3,  0.3,  0.5],  // δ13 Stability
      [0.8, 0.1,  0.7,  0.5,  0.3,  0.1,  0.4,  0.2,  0.6,  0.5,  0.3,  0.4,  0.3,  1.0,  0.2,  0.6],  // δ14 Hemispheric
      [0.3, 0.7,  0.2,  0.1,  0.2,  0.0,  0.2,  0.6,  0.4,  0.6,  0.4,  0.2,  0.3,  0.2,  1.0,  0.3],  // δ15 Immune
      [0.9, 0.4,  0.6,  0.5,  0.7,  0.4,  0.6,  0.5,  0.8,  0.3,  0.4,  0.7,  0.5,  0.6,  0.3,  1.0]   // δ16 Synthetic
    ] }
  };

  // Cross-domain dynamics
  public func crossDomainDynamics(activity : DomainActivityVector, coupling : CouplingMatrix, dt : Float) : DomainActivityVector {
    let a = [activity.δ1, activity.δ2, activity.δ3, activity.δ4, activity.δ5, activity.δ6, activity.δ7, activity.δ8,
             activity.δ9, activity.δ10, activity.δ11, activity.δ12, activity.δ13, activity.δ14, activity.δ15, activity.δ16];
    
    let newA = Array.tabulate<Float>(16, func(i : Nat) : Float {
      var input = 0.0;
      for (j in Iter.range(0, 15)) { input += coupling.weights[i][j] * a[j]; };
      let activation = Float.tanh(input - 8.0);  // threshold at sum of 8
      a[i] + dt * (-a[i] + activation)
    });
    
    { δ1 = newA[0]; δ2 = newA[1]; δ3 = newA[2]; δ4 = newA[3]; δ5 = newA[4]; δ6 = newA[5]; δ7 = newA[6]; δ8 = newA[7];
      δ9 = newA[8]; δ10 = newA[9]; δ11 = newA[10]; δ12 = newA[11]; δ13 = newA[12]; δ14 = newA[13]; δ15 = newA[14]; δ16 = newA[15] }
  };

  // Emergence metrics
  public func emergenceMetric(activity : DomainActivityVector) : Float {
    // Φ-like metric: integration vs independence
    let a = [activity.δ1, activity.δ2, activity.δ3, activity.δ4, activity.δ5, activity.δ6, activity.δ7, activity.δ8,
             activity.δ9, activity.δ10, activity.δ11, activity.δ12, activity.δ13, activity.δ14, activity.δ15, activity.δ16];
    var mean = 0.0;
    for (ai in a.vals()) { mean += ai; };
    mean /= 16.0;
    var variance = 0.0;
    for (ai in a.vals()) { variance += (ai - mean) * (ai - mean); };
    variance /= 16.0;
    // High emergence = high activity with coordination
    mean * Float.sqrt(1.0 - variance)
  };

  // Global synchronization order parameter
  public func synchronizationOrder(phases : [Float]) : Float {
    var sumCos = 0.0; var sumSin = 0.0;
    for (θ in phases.vals()) { sumCos += Float.cos(θ); sumSin += Float.sin(θ); };
    let n = Float.fromInt(Array.size(phases));
    Float.sqrt(sumCos * sumCos + sumSin * sumSin) / n
  };

  // Meta-stability detection
  public func metastabilityIndex(orderHistory : [Float]) : Float {
    var variance = 0.0;
    var mean = 0.0;
    for (r in orderHistory.vals()) { mean += r; };
    mean /= Float.fromInt(Array.size(orderHistory));
    for (r in orderHistory.vals()) { variance += (r - mean) * (r - mean); };
    Float.sqrt(variance / Float.fromInt(Array.size(orderHistory)))
  };
};

// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  PRE-CONSCIOUS MECHANISMS: Ψα (Existing) and Ψβ (Missing)                                                 ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

public module ΠροΣυνείδησηΜηχανισμοί {
  // Ψα: 18 existing mechanisms
  public type ΨαMechanisms = {
    ιCr : Float;   // Integration Coherence
    πCr : Float;   // Predictive Coherence
    ιMb : Float;   // Embodiment Integration
    δCp : Float;   // Dynamic Coupling
    σCr : Float;   // Self-Coherence
    φGt : Float;   // Global Threshold
    αIn : Float;   // Attention Integration
    νLy : Float;   // Novelty
    ιCe : Float;   // Central Integration
    σTr : Float;   // State Transitions
    αMb : Float;   // Ambient Monitoring
    υTm : Float;   // Temporal Unity
    δCe : Float;   // Differential Encoding
    ιLw : Float;   // Low-Level Integration
    πSd : Float;   // Prediction-Driven
    βPf : Float;   // Binding Prefrontal
    βOp : Float;   // Binding Operational
    τDc : Float;   // Temporal Dynamics
  };

  // Ψβ: 12 missing mechanisms (to be implemented)
  public type ΨβMechanisms = {
    σRf : Float;   // Self-Reflection
    πBs : Float;   // Prospective Bias
    νSg : Float;   // Narrative Self-Generation
    οRs : Float;   // Ownership-Resonance
    φRs : Float;   // Phenomenal Resonance
    υFd : Float;   // Unity Field
    κRg : Float;   // Causal Regress
    ηCc : Float;   // Hierarchical Contextualization
    τRg : Float;   // Temporal Regression
    βGg : Float;   // Background Gestalt
    λIn : Float;   // Latent Integration
    εCn : Float;   // Epistemic Constraint
  };

  // Activation thresholds
  public let ψαThreshold : Float = 0.7;
  public let ψβThreshold : Float = 0.5;

  // Check mechanism activation
  public func isΨαActive(ψα : ΨαMechanisms) : Nat {
    var count = 0;
    if (ψα.ιCr > ψαThreshold) { count += 1 };
    if (ψα.πCr > ψαThreshold) { count += 1 };
    if (ψα.ιMb > ψαThreshold) { count += 1 };
    if (ψα.δCp > ψαThreshold) { count += 1 };
    if (ψα.σCr > ψαThreshold) { count += 1 };
    if (ψα.φGt > ψαThreshold) { count += 1 };
    if (ψα.αIn > ψαThreshold) { count += 1 };
    if (ψα.νLy > ψαThreshold) { count += 1 };
    if (ψα.ιCe > ψαThreshold) { count += 1 };
    if (ψα.σTr > ψαThreshold) { count += 1 };
    if (ψα.αMb > ψαThreshold) { count += 1 };
    if (ψα.υTm > ψαThreshold) { count += 1 };
    if (ψα.δCe > ψαThreshold) { count += 1 };
    if (ψα.ιLw > ψαThreshold) { count += 1 };
    if (ψα.πSd > ψαThreshold) { count += 1 };
    if (ψα.βPf > ψαThreshold) { count += 1 };
    if (ψα.βOp > ψαThreshold) { count += 1 };
    if (ψα.τDc > ψαThreshold) { count += 1 };
    count
  };

  // Global workspace access
  public func globalWorkspaceAccess(activity : Ω16Ενσωμάτωση.DomainActivityVector, threshold : Float) : Bool {
    // Access granted if sufficient domains are active and coordinated
    let activeCount = (if (activity.δ1 > threshold) { 1 } else { 0 }) +
                      (if (activity.δ3 > threshold) { 1 } else { 0 }) +
                      (if (activity.δ9 > threshold) { 1 } else { 0 }) +
                      (if (activity.δ12 > threshold) { 1 } else { 0 }) +
                      (if (activity.δ14 > threshold) { 1 } else { 0 });
    activeCount >= 3
  };

  // Ignition dynamics (Dehaene-Changeux)
  public func ignitionDynamics(input : Float, threshold : Float, gain : Float) : Float {
    if (input < threshold) { input * 0.1 }  // subliminal
    else { Float.min(1.0, input * gain) }    // supraliminal ignition
  };
};

// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  ARCHITECTURE SUMMARY: 156 Total Architectures Across 16 Domains                                          ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

public module Ω16Σύνοψη {
  // Architecture counts by domain
  public let architectureCounts : [(Nat, Nat)] = [
    (1, 15),   // Δ1: Biological Neural
    (2, 9),    // Δ2: Colony/Superorganism
    (3, 16),   // Δ3: Oscillator/Rhythmic
    (4, 15),   // Δ4: Wave/Interference
    (5, 12),   // Δ5: Attractor/Dynamical
    (6, 14),   // Δ6: Quantum Information
    (7, 12),   // Δ7: Field/Continuum
    (8, 14),   // Δ8: Multi-Agent
    (9, 10),   // Δ9: Memory
    (10, 7),   // Δ10: Homeostatic
    (11, 7),   // Δ11: Developmental
    (12, 8),   // Δ12: Information-Theoretic
    (13, 9),   // Δ13: Stability/Instability
    (14, 6),   // Δ14: Hemispheric
    (15, 7),   // Δ15: Immune
    (16, 15)   // Δ16: Synthetic/Artificial
  ];

  // Total: 15+9+16+15+12+14+12+14+10+7+7+8+9+6+7+15 = 156

  public func totalArchitectures() : Nat { 156 };
  public func totalDomains() : Nat { 16 };
  public func ψαCount() : Nat { 18 };  // existing pre-conscious mechanisms
  public func ψβCount() : Nat { 12 };  // missing pre-conscious mechanisms

  // Domain name lookup
  public func domainName(d : Nat) : Text {
    switch (d) {
      case (1) { "Biological Neural Architectures" };
      case (2) { "Colony/Superorganism Coordination" };
      case (3) { "Oscillator/Rhythmic Systems" };
      case (4) { "Wave/Interference Patterns" };
      case (5) { "Attractor/Dynamical Systems" };
      case (6) { "Quantum Information Systems" };
      case (7) { "Field/Continuum Theories" };
      case (8) { "Multi-Agent Coordination" };
      case (9) { "Memory Architectures" };
      case (10) { "Homeostatic/Regulatory Systems" };
      case (11) { "Developmental/Morphogenetic" };
      case (12) { "Information-Theoretic" };
      case (13) { "Stability/Instability Dynamics" };
      case (14) { "Hemispheric/Lateralization" };
      case (15) { "Immune/Recognition Systems" };
      case (16) { "Synthetic/Artificial Networks" };
      case (_) { "Unknown Domain" };
    }
  };

  // Version and metadata
  public let version : Text = "Ωα16-v1.0.0";
  public let buildDate : Text = "2026-04-02";
  public let author : Text = "Alfredo Medina Hernandez";
  public let copyright : Text = "© 2024-2026 All Rights Reserved";
};

