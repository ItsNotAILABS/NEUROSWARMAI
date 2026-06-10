/**
 * FRACTAL ARCHITECTURE CORE
 *
 * MEDINA'S FRACTAL PRINCIPLE:
 * Not linear. Not parallel. SPHERICAL.
 *
 * The fractal expands:
 * - INWARD: To infinite detail
 * - OUTWARD: To infinite scale
 * - In ALL directions simultaneously
 *
 * Every part contains the whole.
 * The whole is reflected in every part.
 *
 * PROPRIETARY INTELLECTUAL PROPERTY
 * Alfredo Medina Hernandez | Dallas TX | 2026
 */

// ============================================================================
// FRACTAL DIMENSIONS
// The organism exists in multiple simultaneous dimensions
// ============================================================================

export const FRACTAL_DIMENSIONS = {
  /** Temporal dimension - time scales */
  TEMPORAL: {
    GAMMA: {
      hz: 60,
      scale: "milliseconds",
      description: "Real-time cognition",
    },
    BETA: { hz: 20, scale: "deciseconds", description: "Action planning" },
    ALPHA: { hz: 10, scale: "seconds", description: "Resting awareness" },
    THETA: { hz: 6, scale: "multiseconds", description: "Memory binding" },
    DELTA: { hz: 2, scale: "beats", description: "Sovereign heartbeat" },
    ULTRA_SLOW: { hz: 0.1, scale: "minutes", description: "Circadian rhythm" },
  },

  /** Spatial dimension - scale levels */
  SPATIAL: {
    SYNAPSE: { units: "nm", count: 1e15, description: "Synaptic weights" },
    NEURON: { units: "μm", count: 1e11, description: "Neural activations" },
    COLUMN: { units: "mm", count: 1e8, description: "Cortical columns" },
    REGION: { units: "cm", count: 64, description: "Brain regions" },
    HEMISPHERE: { units: "dm", count: 2, description: "Left/Right" },
    WHOLE_BRAIN: { units: "m", count: 1, description: "Unified organism" },
  },

  /** Organizational dimension - hierarchy levels */
  ORGANIZATIONAL: {
    INDIVIDUAL: { description: "Single entity" },
    SQUAD: { description: "4-8 entities" },
    PLATOON: { description: "16-32 entities" },
    COMPANY: { description: "64-128 entities" },
    BATTALION: { description: "256-512 entities" },
    SWARM: { description: "1000+ entities" },
  },
} as const;

// ============================================================================
// FRACTAL SELF-SIMILARITY
// The same patterns repeat at every scale
// ============================================================================

export interface FractalPattern {
  /** Pattern identifier */
  id: string;

  /** Scale at which this pattern exists */
  scale: number;

  /** The pattern itself */
  structure: {
    nodes: number;
    connections: number;
    symmetry: "radial" | "bilateral" | "rotational" | "translational";
    dimensionality: number;
  };

  /** Self-similar instances at other scales */
  instances: Array<{
    scale: number;
    fidelity: number; // How similar (0-1)
    transformation: "scaling" | "rotation" | "translation" | "reflection";
  }>;

  /** Fractal dimension (Hausdorff dimension) */
  fractalDimension: number;

  /** Is this pattern scale-invariant? */
  isScaleInvariant: boolean;
}

// ============================================================================
// SPHERICAL COORDINATES
// The organism as a sphere, not a tree
// ============================================================================

export interface SphericalPosition {
  /** Radial distance from center (0 = core, 1 = surface) */
  r: number;

  /** Polar angle (0 to π, 0 = top, π = bottom) */
  theta: number;

  /** Azimuthal angle (0 to 2π) */
  phi: number;

  /** Layer (which memory/processing layer) */
  layer: "gamma" | "theta" | "delta";

  /** Region index within layer */
  region: number;
}

/**
 * Convert spherical to Cartesian coordinates
 */
export function sphericalToCartesian(pos: SphericalPosition): {
  x: number;
  y: number;
  z: number;
} {
  return {
    x: pos.r * Math.sin(pos.theta) * Math.cos(pos.phi),
    y: pos.r * Math.sin(pos.theta) * Math.sin(pos.phi),
    z: pos.r * Math.cos(pos.theta),
  };
}

/**
 * Convert Cartesian to spherical coordinates
 */
export function cartesianToSpherical(
  x: number,
  y: number,
  z: number,
): Omit<SphericalPosition, "layer" | "region"> {
  const r = Math.sqrt(x * x + y * y + z * z);
  return {
    r,
    theta: r > 0 ? Math.acos(z / r) : 0,
    phi: Math.atan2(y, x),
  };
}

// ============================================================================
// FRACTAL INFORMATION FLOW
// Information flows in ALL directions simultaneously
// ============================================================================

export const FRACTAL_FLOW_DIRECTIONS = {
  /** Centripetal: Surface → Core */
  CENTRIPETAL: {
    direction: "inward",
    description: "Sensory input flows to deep processing",
    speedProfile: "accelerating", // Gets faster as it concentrates
  },

  /** Centrifugal: Core → Surface */
  CENTRIFUGAL: {
    direction: "outward",
    description: "Decisions flow to motor output",
    speedProfile: "decelerating", // Spreads out, slows down
  },

  /** Tangential: Around the sphere */
  TANGENTIAL: {
    direction: "lateral",
    description: "Cross-regional integration",
    speedProfile: "constant",
  },

  /** Radial Oscillation: In ↔ Out */
  RADIAL_OSCILLATION: {
    direction: "bidirectional",
    description: "Breathing rhythm of cognition",
    speedProfile: "sinusoidal",
  },

  /** Helical: Spiral path through layers */
  HELICAL: {
    direction: "spiral",
    description: "Learning integration across time",
    speedProfile: "phi-ratio", // Golden ratio spiral
  },
} as const;

// ============================================================================
// FRACTAL RECURSION
// Each part contains the whole
// ============================================================================

export interface FractalNode {
  id: string;
  depth: number;

  /** This node's state */
  state: {
    activation: number;
    phase: number;
    energy: number;
  };

  /** Children (smaller scale versions) */
  children: FractalNode[];

  /** Parent (larger scale version) */
  parent: FractalNode | null;

  /** Sibling connections (same scale) */
  siblings: string[];

  /** Does this node mirror the whole? */
  containsWhole: boolean;

  /** Recursion depth limit */
  maxDepth: number;
}

/**
 * Generate fractal tree to specified depth
 */
export function generateFractalTree(
  rootId: string,
  branchingFactor: number,
  maxDepth: number,
  currentDepth = 0,
): FractalNode {
  const node: FractalNode = {
    id: `${rootId}_d${currentDepth}`,
    depth: currentDepth,
    state: {
      activation: 0.5,
      phase: (currentDepth / maxDepth) * Math.PI * 2,
      energy: 1 / (currentDepth + 1),
    },
    children: [],
    parent: null,
    siblings: [],
    containsWhole: true, // Every part contains the whole
    maxDepth,
  };

  if (currentDepth < maxDepth) {
    for (let i = 0; i < branchingFactor; i++) {
      const child = generateFractalTree(
        `${rootId}_${i}`,
        branchingFactor,
        maxDepth,
        currentDepth + 1,
      );
      child.parent = node;
      node.children.push(child);
    }

    // Connect siblings
    for (let i = 0; i < node.children.length; i++) {
      node.children[i].siblings = node.children
        .filter((_, j) => j !== i)
        .map((c) => c.id);
    }
  }

  return node;
}

// ============================================================================
// GOLDEN RATIO (φ) RELATIONSHIPS
// Nature's fractal constant
// ============================================================================

export const PHI = 1.618033988749895;
export const PHI_INVERSE = 0.618033988749895;
export const PHI_SQUARED = 2.618033988749895;

export const GOLDEN_RELATIONSHIPS = {
  /** Scale relationships follow φ */
  SCALE_RATIO: PHI,

  /** Time relationships follow φ */
  TIME_RATIO: PHI,

  /** Fibonacci sequence (integer approximation of φ) */
  FIBONACCI: [
    1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597,
  ],

  /** Golden angle (radians) for optimal packing */
  GOLDEN_ANGLE: Math.PI * (3 - Math.sqrt(5)), // ~137.5°

  /** Phyllotaxis spiral constant */
  PHYLLOTAXIS_C: Math.sqrt(5) + 1,
};

/**
 * Generate Fibonacci spiral positions
 */
export function fibonacciSpiralPositions(
  count: number,
): Array<{ x: number; y: number }> {
  const positions: Array<{ x: number; y: number }> = [];
  const goldenAngle = GOLDEN_RELATIONSHIPS.GOLDEN_ANGLE;

  for (let i = 0; i < count; i++) {
    const r = Math.sqrt(i);
    const theta = i * goldenAngle;
    positions.push({
      x: r * Math.cos(theta),
      y: r * Math.sin(theta),
    });
  }

  return positions;
}

// ============================================================================
// FRACTAL COHERENCE
// Synchronization across scales
// ============================================================================

export interface FractalCoherence {
  /** Coherence at each scale */
  scaleCoherence: Map<number, number>;

  /** Cross-scale coherence (how aligned are different scales) */
  crossScaleCoherence: number;

  /** Phase alignment across scales */
  phaseAlignment: number;

  /** Is the fractal in resonance? */
  inResonance: boolean;

  /** Dominant frequency at each scale */
  dominantFrequencies: Map<number, number>;

  /** Global fractal coherence (all scales integrated) */
  globalCoherence: number;
}

/**
 * Calculate fractal coherence across scales
 */
export function calculateFractalCoherence(
  activations: Map<number, number[]>,
): FractalCoherence {
  const scaleCoherence = new Map<number, number>();
  const dominantFrequencies = new Map<number, number>();

  // Calculate coherence at each scale
  for (const [scale, values] of activations) {
    const mean = values.reduce((a, b) => a + b, 0) / values.length;
    const variance =
      values.reduce((a, b) => a + (b - mean) ** 2, 0) / values.length;
    scaleCoherence.set(scale, 1 - Math.sqrt(variance)); // Higher coherence = lower variance
  }

  // Calculate cross-scale coherence
  const scales = Array.from(scaleCoherence.keys()).sort((a, b) => a - b);
  let crossScaleSum = 0;
  let crossScaleCount = 0;

  for (let i = 0; i < scales.length - 1; i++) {
    const c1 = scaleCoherence.get(scales[i])!;
    const c2 = scaleCoherence.get(scales[i + 1])!;
    crossScaleSum += Math.abs(c1 - c2);
    crossScaleCount++;
  }

  const crossScaleCoherence =
    crossScaleCount > 0 ? 1 - crossScaleSum / crossScaleCount : 1;

  // Global coherence is geometric mean of all scale coherences
  const coherenceValues = Array.from(scaleCoherence.values());
  const globalCoherence =
    coherenceValues.length > 0
      ? coherenceValues.reduce((a, b) => a * b, 1) **
        (1 / coherenceValues.length)
      : 0;

  return {
    scaleCoherence,
    crossScaleCoherence,
    phaseAlignment: crossScaleCoherence, // Simplified
    inResonance: crossScaleCoherence > 0.8,
    dominantFrequencies,
    globalCoherence,
  };
}

// ============================================================================
// FRACTAL METRICS
// ============================================================================

export const FRACTAL_METRICS = {
  TEMPORAL_SCALES: 6,
  SPATIAL_SCALES: 6,
  ORGANIZATIONAL_SCALES: 6,
  FLOW_DIRECTIONS: 5,
  PHI_RELATIONSHIPS: 5,
  FIBONACCI_TERMS: 17,
  DIMENSION_RANGE: { min: 1.0, max: 3.0 },
} as const;

// ============================================================================
// FRACTAL CONSTANTS
// ============================================================================

export const FRACTAL_CONSTANTS = {
  /** Golden ratio φ */
  PHI,
  PHI_INVERSE,
  PHI_SQUARED,

  /** Pi relationships */
  PI: Math.PI,
  TWO_PI: 2 * Math.PI,
  PI_OVER_PHI: Math.PI / PHI,

  /** Euler's number */
  E: Math.E,

  /** Maximum recursion depth */
  MAX_FRACTAL_DEPTH: 10,

  /** Branching factor for fractal trees */
  DEFAULT_BRANCHING: 3,

  /** Coherence threshold for resonance */
  RESONANCE_THRESHOLD: 0.8,
} as const;
