// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  SOVEREIGN AI — TENSOR MATHEMATICS LIBRARY                                                                ║
// ║  Zero Third-Party Dependencies — ITAR/EAR Compliant — Air-Gap Ready                                      ║
// ║                                                                                                           ║
// ║  EXPORT CONTROL: This module may be subject to ITAR (22 CFR §120-130) / EAR (15 CFR §730-774)           ║
// ║  DO NOT EXPORT without proper BIS/DDTC authorization.                                                     ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

import Float "mo:core/Float";
import Array "mo:core/Array";
import Iter "mo:core/Iter";
import Int "mo:core/Int";
import Nat "mo:core/Nat";

module SovereignTensor {

  // ═══════════════════════════════════════════════════════════════════════════════
  // TYPE DEFINITIONS — SOVEREIGN TENSOR TYPES
  // ═══════════════════════════════════════════════════════════════════════════════

  /// 1D Tensor (Vector)
  public type Vector = [Float];

  /// 2D Tensor (Matrix) — row-major storage
  public type Matrix = {
    rows : Nat;
    cols : Nat;
    data : [var Float];
  };

  /// 3D Tensor — for batch operations
  public type Tensor3D = {
    depth : Nat;
    rows : Nat;
    cols : Nat;
    data : [var Float];
  };

  /// Tensor shape descriptor
  public type Shape = {
    dims : [Nat];
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════

  public let EPSILON : Float = 1.0e-8;
  public let PHI : Float = 1.6180339887498948482;
  public let PHI_INV : Float = 0.6180339887498949;

  // ═══════════════════════════════════════════════════════════════════════════════
  // MATRIX CREATION
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Create zero matrix
  public func zeros(rows : Nat, cols : Nat) : Matrix {
    { rows; cols; data = Array.init<Float>(rows * cols, 0.0) }
  };

  /// Create identity matrix
  public func identity(n : Nat) : Matrix {
    let mat = zeros(n, n);
    for (i in Iter.range(0, n - 1)) {
      mat.data[i * n + i] := 1.0;
    };
    mat
  };

  /// Create matrix filled with a value
  public func fill(rows : Nat, cols : Nat, value : Float) : Matrix {
    { rows; cols; data = Array.init<Float>(rows * cols, value) }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // MATRIX ELEMENT ACCESS
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Get element at (row, col)
  public func get(m : Matrix, row : Nat, col : Nat) : Float {
    m.data[row * m.cols + col]
  };

  /// Set element at (row, col)
  public func set(m : Matrix, row : Nat, col : Nat, value : Float) : () {
    m.data[row * m.cols + col] := value;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // MATRIX ARITHMETIC — ALL FROM FIRST PRINCIPLES
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Matrix addition: C = A + B
  public func add(a : Matrix, b : Matrix) : Matrix {
    assert(a.rows == b.rows and a.cols == b.cols);
    let c = zeros(a.rows, a.cols);
    let size = a.rows * a.cols;
    for (i in Iter.range(0, size - 1)) {
      c.data[i] := a.data[i] + b.data[i];
    };
    c
  };

  /// Matrix subtraction: C = A - B
  public func sub(a : Matrix, b : Matrix) : Matrix {
    assert(a.rows == b.rows and a.cols == b.cols);
    let c = zeros(a.rows, a.cols);
    let size = a.rows * a.cols;
    for (i in Iter.range(0, size - 1)) {
      c.data[i] := a.data[i] - b.data[i];
    };
    c
  };

  /// Scalar multiplication: C = α × A
  public func scale(a : Matrix, scalar : Float) : Matrix {
    let c = zeros(a.rows, a.cols);
    let size = a.rows * a.cols;
    for (i in Iter.range(0, size - 1)) {
      c.data[i] := a.data[i] * scalar;
    };
    c
  };

  /// Matrix multiplication: C = A × B (O(n³) naive — sovereign, no BLAS)
  public func matmul(a : Matrix, b : Matrix) : Matrix {
    assert(a.cols == b.rows);
    let c = zeros(a.rows, b.cols);
    for (i in Iter.range(0, a.rows - 1)) {
      for (j in Iter.range(0, b.cols - 1)) {
        var sum : Float = 0.0;
        for (k in Iter.range(0, a.cols - 1)) {
          sum += a.data[i * a.cols + k] * b.data[k * b.cols + j];
        };
        c.data[i * b.cols + j] := sum;
      };
    };
    c
  };

  /// Element-wise multiplication (Hadamard product): C = A ⊙ B
  public func hadamard(a : Matrix, b : Matrix) : Matrix {
    assert(a.rows == b.rows and a.cols == b.cols);
    let c = zeros(a.rows, a.cols);
    let size = a.rows * a.cols;
    for (i in Iter.range(0, size - 1)) {
      c.data[i] := a.data[i] * b.data[i];
    };
    c
  };

  /// Matrix transpose: B = Aᵀ
  public func transpose(a : Matrix) : Matrix {
    let b = zeros(a.cols, a.rows);
    for (i in Iter.range(0, a.rows - 1)) {
      for (j in Iter.range(0, a.cols - 1)) {
        b.data[j * a.rows + i] := a.data[i * a.cols + j];
      };
    };
    b
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // VECTOR OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Dot product: a · b
  public func dot(a : Vector, b : Vector) : Float {
    assert(a.size() == b.size());
    var sum : Float = 0.0;
    for (i in Iter.range(0, a.size() - 1)) {
      sum += a[i] * b[i];
    };
    sum
  };

  /// Vector L2 norm: ||v||₂
  public func norm(v : Vector) : Float {
    var sum : Float = 0.0;
    for (x in v.vals()) {
      sum += x * x;
    };
    Float.sqrt(sum)
  };

  /// Normalize vector to unit length
  public func normalize(v : Vector) : Vector {
    let n = norm(v);
    if (n < EPSILON) return v;
    Array.tabulate<Float>(v.size(), func(i : Nat) : Float { v[i] / n })
  };

  /// Cosine similarity: cos(θ) = (a·b)/(||a||×||b||)
  public func cosineSimilarity(a : Vector, b : Vector) : Float {
    let d = dot(a, b);
    let na = norm(a);
    let nb = norm(b);
    if (na < EPSILON or nb < EPSILON) return 0.0;
    d / (na * nb)
  };

  /// Outer product: C = a ⊗ b (vector × vector → matrix)
  public func outer(a : Vector, b : Vector) : Matrix {
    let c = zeros(a.size(), b.size());
    for (i in Iter.range(0, a.size() - 1)) {
      for (j in Iter.range(0, b.size() - 1)) {
        c.data[i * b.size() + j] := a[i] * b[j];
      };
    };
    c
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ACTIVATION FUNCTIONS — ALL FROM FIRST PRINCIPLES
  // ═══════════════════════════════════════════════════════════════════════════════

  /// ReLU: max(0, x)
  public func relu(x : Float) : Float {
    if (x > 0.0) x else 0.0
  };

  /// ReLU derivative
  public func reluGrad(x : Float) : Float {
    if (x > 0.0) 1.0 else 0.0
  };

  /// Leaky ReLU: max(αx, x) where α = 0.01
  public func leakyRelu(x : Float, alpha : Float) : Float {
    if (x > 0.0) x else alpha * x
  };

  /// Sigmoid: σ(x) = 1 / (1 + e^(-x))
  public func sigmoid(x : Float) : Float {
    1.0 / (1.0 + Float.exp(-x))
  };

  /// Sigmoid derivative: σ'(x) = σ(x)(1 - σ(x))
  public func sigmoidGrad(x : Float) : Float {
    let s = sigmoid(x);
    s * (1.0 - s)
  };

  /// Tanh: (e^x - e^(-x)) / (e^x + e^(-x))
  public func tanh_(x : Float) : Float {
    let ep = Float.exp(x);
    let em = Float.exp(-x);
    (ep - em) / (ep + em)
  };

  /// Tanh derivative: 1 - tanh²(x)
  public func tanhGrad(x : Float) : Float {
    let t = tanh_(x);
    1.0 - t * t
  };

  /// GELU: x × Φ(x) ≈ 0.5x(1 + tanh(√(2/π)(x + 0.044715x³)))
  public func gelu(x : Float) : Float {
    let sqrt2OverPi : Float = 0.7978845608028654;
    let inner = sqrt2OverPi * (x + 0.044715 * x * x * x);
    0.5 * x * (1.0 + tanh_(inner))
  };

  /// Softmax: exp(xᵢ) / Σⱼ exp(xⱼ) with numerical stability
  public func softmax(v : Vector) : Vector {
    // Find max for numerical stability
    var maxVal : Float = v[0];
    for (x in v.vals()) {
      if (x > maxVal) maxVal := x;
    };
    // Compute exp(x - max)
    var sumExp : Float = 0.0;
    let exps = Array.tabulate<Float>(v.size(), func(i : Nat) : Float {
      let e = Float.exp(v[i] - maxVal);
      sumExp += e;
      e
    });
    // Normalize
    Array.tabulate<Float>(v.size(), func(i : Nat) : Float {
      exps[i] / sumExp
    })
  };

  /// Swish: x × σ(βx) — self-gated activation
  public func swish(x : Float, beta : Float) : Float {
    x * sigmoid(beta * x)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // LOSS FUNCTIONS — ALL FROM FIRST PRINCIPLES
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Mean Squared Error: (1/n) Σᵢ (yᵢ - ŷᵢ)²
  public func mseLoss(predicted : Vector, target : Vector) : Float {
    assert(predicted.size() == target.size());
    var sum : Float = 0.0;
    for (i in Iter.range(0, predicted.size() - 1)) {
      let diff = predicted[i] - target[i];
      sum += diff * diff;
    };
    sum / Float.fromInt(predicted.size())
  };

  /// Cross-entropy loss: -Σᵢ tᵢ × log(pᵢ)
  public func crossEntropyLoss(predicted : Vector, target : Vector) : Float {
    assert(predicted.size() == target.size());
    var sum : Float = 0.0;
    for (i in Iter.range(0, predicted.size() - 1)) {
      let p = Float.max(predicted[i], EPSILON); // Clamp for log stability
      sum -= target[i] * Float.log(p);
    };
    sum
  };

  /// KL Divergence: Σᵢ p(i) × log(p(i)/q(i))
  public func klDivergence(p : Vector, q : Vector) : Float {
    assert(p.size() == q.size());
    var sum : Float = 0.0;
    for (i in Iter.range(0, p.size() - 1)) {
      if (p[i] > EPSILON) {
        let qi = Float.max(q[i], EPSILON);
        sum += p[i] * Float.log(p[i] / qi);
      };
    };
    sum
  };

  /// Huber loss (smooth L1): robust to outliers
  public func huberLoss(predicted : Vector, target : Vector, delta : Float) : Float {
    assert(predicted.size() == target.size());
    var sum : Float = 0.0;
    for (i in Iter.range(0, predicted.size() - 1)) {
      let diff = Float.abs(predicted[i] - target[i]);
      if (diff <= delta) {
        sum += 0.5 * diff * diff;
      } else {
        sum += delta * (diff - 0.5 * delta);
      };
    };
    sum / Float.fromInt(predicted.size())
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // MATRIX DECOMPOSITION — SOVEREIGN IMPLEMENTATIONS
  // ═══════════════════════════════════════════════════════════════════════════════

  /// LU Decomposition (Doolittle algorithm) — no LAPACK dependency
  /// Returns (L, U) such that A = L × U
  public func luDecomposition(a : Matrix) : (Matrix, Matrix) {
    assert(a.rows == a.cols);
    let n = a.rows;
    let l = identity(n);
    let u = zeros(n, n);

    for (i in Iter.range(0, n - 1)) {
      // Upper triangular
      for (j in Iter.range(i, n - 1)) {
        var sum : Float = 0.0;
        for (k in Iter.range(0, i - 1)) {
          sum += get(l, i, k) * get(u, k, j);
        };
        set(u, i, j, get(a, i, j) - sum);
      };
      // Lower triangular
      for (j in Iter.range(i + 1, n - 1)) {
        var sum : Float = 0.0;
        for (k in Iter.range(0, i - 1)) {
          sum += get(l, j, k) * get(u, k, i);
        };
        let uii = get(u, i, i);
        if (Float.abs(uii) > EPSILON) {
          set(l, j, i, (get(a, j, i) - sum) / uii);
        };
      };
    };
    (l, u)
  };

  /// Matrix determinant via LU decomposition
  public func determinant(a : Matrix) : Float {
    assert(a.rows == a.cols);
    let (_, u) = luDecomposition(a);
    var det : Float = 1.0;
    for (i in Iter.range(0, a.rows - 1)) {
      det *= get(u, i, i);
    };
    det
  };

  /// Frobenius norm: ||A||_F = √(Σᵢⱼ aᵢⱼ²)
  public func frobeniusNorm(a : Matrix) : Float {
    var sum : Float = 0.0;
    let size = a.rows * a.cols;
    for (i in Iter.range(0, size - 1)) {
      sum += a.data[i] * a.data[i];
    };
    Float.sqrt(sum)
  };

  /// Trace: tr(A) = Σᵢ aᵢᵢ
  public func trace(a : Matrix) : Float {
    assert(a.rows == a.cols);
    var sum : Float = 0.0;
    for (i in Iter.range(0, a.rows - 1)) {
      sum += get(a, i, i);
    };
    sum
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SIGNAL PROCESSING — FFT FROM FIRST PRINCIPLES (NO FFTW)
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Discrete Fourier Transform (DFT) — O(N²) reference implementation
  /// X[k] = Σₙ x[n] × e^(-j2πkn/N)
  /// Returns (real parts, imaginary parts)
  public func dft(signal : Vector) : (Vector, Vector) {
    let n = signal.size();
    let realPart = Array.init<Float>(n, 0.0);
    let imagPart = Array.init<Float>(n, 0.0);
    let twoPiOverN = 6.2831853071795864769 / Float.fromInt(n);

    for (k in Iter.range(0, n - 1)) {
      for (t in Iter.range(0, n - 1)) {
        let angle = twoPiOverN * Float.fromInt(k) * Float.fromInt(t);
        realPart[k] += signal[t] * Float.cos(angle);
        imagPart[k] -= signal[t] * Float.sin(angle);
      };
    };
    (Array.freeze(realPart), Array.freeze(imagPart))
  };

  /// Power spectral density: |X[k]|²
  public func powerSpectrum(signal : Vector) : Vector {
    let (re, im) = dft(signal);
    Array.tabulate<Float>(re.size(), func(k : Nat) : Float {
      re[k] * re[k] + im[k] * im[k]
    })
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // RANDOM NUMBER GENERATION — SOVEREIGN (NO /dev/urandom in air-gapped)
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Xoshiro256** — fast, high-quality PRNG (public domain algorithm)
  /// State is internal — no external entropy source required
  public type PRNGState = {
    var s0 : Nat;
    var s1 : Nat;
    var s2 : Nat;
    var s3 : Nat;
  };

  /// Initialize PRNG with seed (deterministic — required for defense reproducibility)
  public func prngInit(seed : Nat) : PRNGState {
    {
      var s0 = seed;
      var s1 = seed *% 6364136223846793005 +% 1442695040888963407;
      var s2 = (seed *% 6364136223846793005 +% 1442695040888963407) *% 6364136223846793005 +% 1442695040888963407;
      var s3 = seed ^ 0xDEADBEEFCAFEBABE;
    }
  };

  /// Generate next random Float in [0, 1)
  public func prngNext(state : PRNGState) : Float {
    let result = state.s1 *% 5;
    let t = state.s1 << 17;

    state.s2 := state.s2 ^ state.s0;
    state.s3 := state.s3 ^ state.s1;
    state.s1 := state.s1 ^ state.s2;
    state.s0 := state.s0 ^ state.s3;
    state.s2 := state.s2 ^ t;
    state.s3 := state.s3 << 45; // Rotate left 45

    // Convert to [0, 1) float
    Float.fromInt(result % 1000000) / 1000000.0
  };

  /// Xavier/Glorot initialization: N(0, √(2/(fan_in + fan_out)))
  public func xavierInit(state : PRNGState, fanIn : Nat, fanOut : Nat, size : Nat) : Vector {
    let stddev = Float.sqrt(2.0 / Float.fromInt(fanIn + fanOut));
    Array.tabulate<Float>(size, func(_ : Nat) : Float {
      (prngNext(state) - 0.5) * 2.0 * stddev
    })
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ADVANCED DECOMPOSITIONS — SOVEREIGN IMPLEMENTATIONS
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Cholesky decomposition: A = LLᵀ (A must be symmetric positive-definite)
  /// Returns lower triangular L such that A = L × Lᵀ
  public func choleskyDecomposition(a : Matrix) : ?Matrix {
    assert(a.rows == a.cols);
    let n = a.rows;
    let l = zeros(n, n);

    for (i in Iter.range(0, n - 1)) {
      for (j in Iter.range(0, i)) {
        var sum : Float = 0.0;
        for (k in Iter.range(0, j - 1)) {
          sum += get(l, i, k) * get(l, j, k);
        };
        if (j == i) {
          let diag = get(a, i, i) - sum;
          if (diag <= 0.0) return null; // Not positive-definite
          set(l, i, j, Float.sqrt(diag));
        } else {
          let ljj = get(l, j, j);
          if (Float.abs(ljj) < EPSILON) return null;
          set(l, i, j, (get(a, i, j) - sum) / ljj);
        };
      };
      // Handle diagonal when j == i (loop above may skip)
      if (true) {
        var sum : Float = 0.0;
        for (k in Iter.range(0, i - 1)) {
          sum += get(l, i, k) * get(l, i, k);
        };
        let diag = get(a, i, i) - sum;
        if (diag <= 0.0) return null;
        set(l, i, i, Float.sqrt(diag));
      };
    };
    ?l
  };

  /// QR decomposition via modified Gram-Schmidt orthogonalization
  /// Returns (Q, R) such that A = Q × R, Q orthogonal, R upper triangular
  public func qrDecomposition(a : Matrix) : (Matrix, Matrix) {
    let m = a.rows;
    let n = a.cols;
    let q = zeros(m, n);
    let r = zeros(n, n);

    // Copy columns of A
    let cols = Array.init<[var Float]>(n, Array.init<Float>(m, 0.0));
    for (j in Iter.range(0, n - 1)) {
      cols[j] := Array.init<Float>(m, 0.0);
      for (i in Iter.range(0, m - 1)) {
        cols[j][i] := get(a, i, j);
      };
    };

    for (j in Iter.range(0, n - 1)) {
      // Orthogonalize against previous columns
      for (i in Iter.range(0, j - 1)) {
        // r[i][j] = q_i · a_j
        var dotProd : Float = 0.0;
        for (k in Iter.range(0, m - 1)) {
          dotProd += get(q, k, i) * cols[j][k];
        };
        set(r, i, j, dotProd);
        // a_j = a_j - r[i][j] * q_i
        for (k in Iter.range(0, m - 1)) {
          cols[j][k] -= dotProd * get(q, k, i);
        };
      };
      // r[j][j] = ||a_j||
      var colNorm : Float = 0.0;
      for (k in Iter.range(0, m - 1)) {
        colNorm += cols[j][k] * cols[j][k];
      };
      colNorm := Float.sqrt(colNorm);
      set(r, j, j, colNorm);
      // q_j = a_j / r[j][j]
      if (colNorm > EPSILON) {
        for (k in Iter.range(0, m - 1)) {
          set(q, k, j, cols[j][k] / colNorm);
        };
      };
    };
    (q, r)
  };

  /// Power iteration for dominant eigenvalue/eigenvector
  /// Returns (eigenvalue, eigenvector) after maxIter iterations
  public func powerIteration(a : Matrix, maxIter : Nat, seed : Nat) : (Float, Vector) {
    assert(a.rows == a.cols);
    let n = a.rows;
    let prng = prngInit(seed);

    // Random initial vector
    var v = Array.tabulate<Float>(n, func(_ : Nat) : Float {
      prngNext(prng) - 0.5
    });
    v := normalize(v);

    var eigenvalue : Float = 0.0;

    for (_ in Iter.range(0, maxIter - 1)) {
      // w = A × v
      let w = Array.tabulate<Float>(n, func(i : Nat) : Float {
        var sum : Float = 0.0;
        for (j in Iter.range(0, n - 1)) {
          sum += get(a, i, j) * v[j];
        };
        sum
      });
      // eigenvalue = v · w (Rayleigh quotient)
      eigenvalue := dot(v, w);
      // Normalize w
      v := normalize(w);
    };
    (eigenvalue, v)
  };

  /// Singular Value Decomposition (truncated) via power iteration
  /// Returns top-k singular values for dimensionality reduction
  public func svdTopK(a : Matrix, k : Nat, maxIter : Nat, seed : Nat) : [Float] {
    let m = a.rows;
    let n = a.cols;
    // Compute A^T × A
    let at = transpose(a);
    let ata = matmul(at, a);

    // Extract top-k eigenvalues of A^T A (singular values = sqrt of these)
    var result : [Float] = [];
    let deflated = zeros(ata.rows, ata.cols);
    let size = ata.rows * ata.cols;
    for (i in Iter.range(0, size - 1)) {
      deflated.data[i] := ata.data[i];
    };

    for (ki in Iter.range(0, k - 1)) {
      let (eigenval, eigenvec) = powerIteration(deflated, maxIter, seed + ki);
      let singularVal = Float.sqrt(Float.abs(eigenval));
      result := Array.append(result, [singularVal]);

      // Deflate: A = A - λ × v × vᵀ
      for (i in Iter.range(0, deflated.rows - 1)) {
        for (j in Iter.range(0, deflated.cols - 1)) {
          let current = get(deflated, i, j);
          set(deflated, i, j, current - eigenval * eigenvec[i] * eigenvec[j]);
        };
      };
    };
    result
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // CONVOLUTION — 1D AND 2D FROM FIRST PRINCIPLES
  // ═══════════════════════════════════════════════════════════════════════════════

  /// 1D convolution: (f * g)[n] = Σₖ f[k] × g[n-k]
  public func convolve1D(signal : Vector, kernel : Vector) : Vector {
    let sigLen = signal.size();
    let kerLen = kernel.size();
    let outLen = sigLen + kerLen - 1;
    Array.tabulate<Float>(outLen, func(n : Nat) : Float {
      var sum : Float = 0.0;
      for (k in Iter.range(0, kerLen - 1)) {
        if (n >= k and (n - k) < sigLen) {
          sum += kernel[k] * signal[n - k];
        };
      };
      sum
    })
  };

  /// 2D convolution for image/feature map processing
  public func convolve2D(input : Matrix, kernel : Matrix) : Matrix {
    let outRows = input.rows - kernel.rows + 1;
    let outCols = input.cols - kernel.cols + 1;
    let output = zeros(outRows, outCols);

    for (i in Iter.range(0, outRows - 1)) {
      for (j in Iter.range(0, outCols - 1)) {
        var sum : Float = 0.0;
        for (ki in Iter.range(0, kernel.rows - 1)) {
          for (kj in Iter.range(0, kernel.cols - 1)) {
            sum += get(input, i + ki, j + kj) * get(kernel, ki, kj);
          };
        };
        set(output, i, j, sum);
      };
    };
    output
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // BATCH OPERATIONS — EFFICIENT MULTI-SAMPLE PROCESSING
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Batch matrix multiply: compute A[i] × B for each matrix in batch
  public func batchMatmul(batch : [Matrix], b : Matrix) : [Matrix] {
    Array.tabulate<Matrix>(batch.size(), func(i : Nat) : Matrix {
      matmul(batch[i], b)
    })
  };

  /// Batch vector-matrix multiply
  public func batchVecMul(vectors : [Vector], m : Matrix) : [Vector] {
    Array.tabulate<Vector>(vectors.size(), func(i : Nat) : Vector {
      let v = vectors[i];
      Array.tabulate<Float>(m.cols, func(j : Nat) : Float {
        var sum : Float = 0.0;
        for (k in Iter.range(0, v.size() - 1)) {
          sum += v[k] * get(m, k, j);
        };
        sum
      })
    })
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ADVANCED ACTIVATION FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════

  /// ELU: α(eˣ - 1) for x < 0, x for x ≥ 0
  public func elu(x : Float, alpha : Float) : Float {
    if (x >= 0.0) x else alpha * (Float.exp(x) - 1.0)
  };

  /// ELU derivative
  public func eluGrad(x : Float, alpha : Float) : Float {
    if (x >= 0.0) 1.0 else alpha * Float.exp(x)
  };

  /// Mish: x × tanh(softplus(x)) = x × tanh(ln(1 + eˣ))
  public func mish(x : Float) : Float {
    let softplus = Float.log(1.0 + Float.exp(x));
    x * tanh_(softplus)
  };

  /// SELU: λ × (ELU(x, α)) with self-normalizing constants
  public func selu(x : Float) : Float {
    let lambda : Float = 1.0507009873554804934;
    let alpha : Float = 1.6732632423543772848;
    if (x >= 0.0) { lambda * x } else { lambda * alpha * (Float.exp(x) - 1.0) }
  };

  /// Hard sigmoid: clip(x × 0.2 + 0.5, 0, 1) — efficient on tactical hardware
  public func hardSigmoid(x : Float) : Float {
    Float.max(0.0, Float.min(1.0, x * 0.2 + 0.5))
  };

  /// Hard swish: x × hardSigmoid(x) — MobileNet V3 activation
  public func hardSwish(x : Float) : Float {
    x * hardSigmoid(x)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ADVANCED LOSS FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Focal loss: -α(1-p)^γ × log(p) — handles class imbalance
  public func focalLoss(predicted : Vector, target : Vector, alpha : Float, gamma : Float) : Float {
    assert(predicted.size() == target.size());
    var sum : Float = 0.0;
    for (i in Iter.range(0, predicted.size() - 1)) {
      let p = Float.max(predicted[i], EPSILON);
      let pt = if (target[i] > 0.5) p else (1.0 - p);
      let modulating = Float.exp(gamma * Float.log(1.0 - pt)); // (1-pt)^γ
      sum -= alpha * modulating * Float.log(pt);
    };
    sum / Float.fromInt(predicted.size())
  };

  /// Cosine embedding loss: for contrastive learning
  public func cosineEmbeddingLoss(x : Vector, y : Vector, label : Float, margin : Float) : Float {
    let sim = cosineSimilarity(x, y);
    if (label > 0.0) {
      1.0 - sim
    } else {
      Float.max(0.0, sim - margin)
    }
  };

  /// Triplet loss: max(0, d(a,p) - d(a,n) + margin)
  public func tripletLoss(anchor : Vector, positive : Vector, negative : Vector, margin : Float) : Float {
    let positiveDist = euclideanDistance(anchor, positive);
    let negativeDist = euclideanDistance(anchor, negative);
    Float.max(0.0, positiveDist - negativeDist + margin)
  };

  /// Euclidean distance between vectors
  public func euclideanDistance(a : Vector, b : Vector) : Float {
    assert(a.size() == b.size());
    var sum : Float = 0.0;
    for (i in Iter.range(0, a.size() - 1)) {
      let diff = a[i] - b[i];
      sum += diff * diff;
    };
    Float.sqrt(sum)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // MATRIX UTILITIES — PROFESSIONAL GRADE
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Solve linear system Ax = b using forward/back substitution with LU
  public func solve(a : Matrix, b : Vector) : Vector {
    assert(a.rows == a.cols and a.rows == b.size());
    let n = a.rows;
    let (l, u) = luDecomposition(a);

    // Forward substitution: Ly = b
    let y = Array.init<Float>(n, 0.0);
    for (i in Iter.range(0, n - 1)) {
      var sum : Float = 0.0;
      for (j in Iter.range(0, i - 1)) {
        sum += get(l, i, j) * y[j];
      };
      y[i] := b[i] - sum;
    };

    // Back substitution: Ux = y
    let x = Array.init<Float>(n, 0.0);
    var i : Int = n - 1;
    while (i >= 0) {
      var sum : Float = 0.0;
      for (j in Iter.range(Int.abs(i) + 1, n - 1)) {
        sum += get(u, Int.abs(i), j) * x[j];
      };
      let uii = get(u, Int.abs(i), Int.abs(i));
      if (Float.abs(uii) > EPSILON) {
        x[Int.abs(i)] := (y[Int.abs(i)] - sum) / uii;
      };
      i -= 1;
    };
    Array.freeze(x)
  };

  /// Matrix inverse via LU decomposition: A⁻¹
  public func inverse(a : Matrix) : ?Matrix {
    assert(a.rows == a.cols);
    let n = a.rows;
    let det_ = determinant(a);
    if (Float.abs(det_) < EPSILON) return null; // Singular

    let inv = zeros(n, n);
    for (col in Iter.range(0, n - 1)) {
      // Solve A × x = e_col
      let e = Array.tabulate<Float>(n, func(i : Nat) : Float {
        if (i == col) 1.0 else 0.0
      });
      let x = solve(a, e);
      for (row in Iter.range(0, n - 1)) {
        set(inv, row, col, x[row]);
      };
    };
    ?inv
  };

  /// Matrix condition number estimate: ||A|| × ||A⁻¹|| (Frobenius)
  public func conditionNumber(a : Matrix) : Float {
    let normA = frobeniusNorm(a);
    switch (inverse(a)) {
      case (?invA) { normA * frobeniusNorm(invA) };
      case null { 1.0 / 0.0 }; // Infinity — singular
    }
  };

  /// Kronecker product: A ⊗ B
  public func kronecker(a : Matrix, b : Matrix) : Matrix {
    let outRows = a.rows * b.rows;
    let outCols = a.cols * b.cols;
    let result = zeros(outRows, outCols);

    for (i in Iter.range(0, a.rows - 1)) {
      for (j in Iter.range(0, a.cols - 1)) {
        let aij = get(a, i, j);
        for (k in Iter.range(0, b.rows - 1)) {
          for (l in Iter.range(0, b.cols - 1)) {
            set(result, i * b.rows + k, j * b.cols + l, aij * get(b, k, l));
          };
        };
      };
    };
    result
  };

  /// Row echelon form via Gaussian elimination (for rank computation)
  public func rowEchelonForm(a : Matrix) : (Matrix, Nat) {
    let m = a.rows;
    let n = a.cols;
    let result = zeros(m, n);
    let size = m * n;
    for (idx in Iter.range(0, size - 1)) {
      result.data[idx] := a.data[idx];
    };

    var rank : Nat = 0;
    var col : Nat = 0;

    while (rank < m and col < n) {
      // Find pivot
      var maxRow = rank;
      var maxVal = Float.abs(get(result, rank, col));
      for (i in Iter.range(rank + 1, m - 1)) {
        let val = Float.abs(get(result, i, col));
        if (val > maxVal) {
          maxVal := val;
          maxRow := i;
        };
      };

      if (maxVal < EPSILON) {
        col += 1;
      } else {
        // Swap rows
        if (maxRow != rank) {
          for (j in Iter.range(0, n - 1)) {
            let tmp = get(result, rank, j);
            set(result, rank, j, get(result, maxRow, j));
            set(result, maxRow, j, tmp);
          };
        };
        // Eliminate below
        for (i in Iter.range(rank + 1, m - 1)) {
          let factor = get(result, i, col) / get(result, rank, col);
          for (j in Iter.range(col, n - 1)) {
            set(result, i, j, get(result, i, j) - factor * get(result, rank, j));
          };
        };
        rank += 1;
        col += 1;
      };
    };
    (result, rank)
  };

  /// Matrix rank via row echelon form
  public func rank(a : Matrix) : Nat {
    let (_, r) = rowEchelonForm(a);
    r
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // WINDOWING FUNCTIONS — FOR SIGNAL PROCESSING PRE-FFT
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Hamming window: 0.54 - 0.46 × cos(2πn/(N-1))
  public func hammingWindow(n : Nat) : Vector {
    Array.tabulate<Float>(n, func(i : Nat) : Float {
      0.54 - 0.46 * Float.cos(6.2831853071795864769 * Float.fromInt(i) / Float.fromInt(n - 1))
    })
  };

  /// Hanning window: 0.5 × (1 - cos(2πn/(N-1)))
  public func hanningWindow(n : Nat) : Vector {
    Array.tabulate<Float>(n, func(i : Nat) : Float {
      0.5 * (1.0 - Float.cos(6.2831853071795864769 * Float.fromInt(i) / Float.fromInt(n - 1)))
    })
  };

  /// Blackman window: 0.42 - 0.5cos(2πn/(N-1)) + 0.08cos(4πn/(N-1))
  public func blackmanWindow(n : Nat) : Vector {
    Array.tabulate<Float>(n, func(i : Nat) : Float {
      let twoPi = 6.2831853071795864769;
      let nf = Float.fromInt(i);
      let nm1 = Float.fromInt(n - 1);
      0.42 - 0.5 * Float.cos(twoPi * nf / nm1) + 0.08 * Float.cos(2.0 * twoPi * nf / nm1)
    })
  };

  /// Apply window to signal (element-wise multiply)
  public func applyWindow(signal : Vector, window : Vector) : Vector {
    assert(signal.size() == window.size());
    Array.tabulate<Float>(signal.size(), func(i : Nat) : Float {
      signal[i] * window[i]
    })
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // STATISTICS — FOR DATA PREPROCESSING
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Compute mean of vector
  public func mean(v : Vector) : Float {
    var sum : Float = 0.0;
    for (x in v.vals()) { sum += x };
    sum / Float.fromInt(v.size())
  };

  /// Compute variance of vector
  public func variance(v : Vector) : Float {
    let m = mean(v);
    var sum : Float = 0.0;
    for (x in v.vals()) {
      let diff = x - m;
      sum += diff * diff;
    };
    sum / Float.fromInt(v.size())
  };

  /// Compute standard deviation
  public func stddev(v : Vector) : Float {
    Float.sqrt(variance(v))
  };

  /// Z-score normalization: (x - μ) / σ
  public func zScoreNormalize(v : Vector) : Vector {
    let m = mean(v);
    let s = stddev(v);
    if (s < EPSILON) return v;
    Array.tabulate<Float>(v.size(), func(i : Nat) : Float {
      (v[i] - m) / s
    })
  };

  /// Min-max normalization to [0, 1]
  public func minMaxNormalize(v : Vector) : Vector {
    var minVal : Float = v[0];
    var maxVal : Float = v[0];
    for (x in v.vals()) {
      if (x < minVal) minVal := x;
      if (x > maxVal) maxVal := x;
    };
    let range = maxVal - minVal;
    if (range < EPSILON) return v;
    Array.tabulate<Float>(v.size(), func(i : Nat) : Float {
      (v[i] - minVal) / range
    })
  };

  /// Exponential moving average
  public func exponentialMovingAverage(v : Vector, alpha : Float) : Vector {
    if (v.size() == 0) return v;
    let result = Array.init<Float>(v.size(), v[0]);
    for (i in Iter.range(1, v.size() - 1)) {
      result[i] := alpha * v[i] + (1.0 - alpha) * result[i - 1];
    };
    Array.freeze(result)
  };
}
