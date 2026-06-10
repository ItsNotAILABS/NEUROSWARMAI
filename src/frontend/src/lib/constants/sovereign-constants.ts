// ═══════════════════════════════════════════════════════════════════════════════
// SOVEREIGN CONSTANTS — MIRROR OF BACKEND GENESIS CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════
// Owner: Alfredo Medina Hernandez | Dallas TX | MedinaSITech@outlook.com
// Attribution: Medina Doctrine
//
// These constants MUST match exactly with backend/genesis/unified-cascade-interconnect.mo
// They are the FROZEN LAWS that govern both organisms (frontend & backend).
// ═══════════════════════════════════════════════════════════════════════════════

/** S₀ — SOVEREIGNTY FLOOR (THE MOST IMPORTANT CONSTANT) */
export const S_ZERO = 1.0;

/** Golden ratio φ */
export const PHI = 1.61803398874989484820;

/** Kuramoto coupling strength */
export const K_KURAMOTO = 2.0;

/** Phase transition threshold */
export const R_CRITICAL = 0.65;

/** Full coherence threshold */
export const R_COHERENT = 0.85;

/** Hebbian learning rate */
export const HEBBIAN_LEARNING_RATE = 0.01;

/** Hebbian decay rate */
export const HEBBIAN_DECAY = 0.001;

/** Maximum Hebbian weight */
export const HEBBIAN_MAX_WEIGHT = 10.0;

/**Minimum Hebbian weight (Sovereign Floor) */
export const HEBBIAN_MIN_WEIGHT = S_ZERO;

/** Clamp Hebbian weight with Sovereign Floor */
export function clampHebbianWeight(weight: number): number {
  return Math.max(HEBBIAN_MIN_WEIGHT, Math.min(HEBBIAN_MAX_WEIGHT, weight));
}

/** Clamp activation with Sovereign Floor */
export function clampActivation(activation: number, min = S_ZERO, max = 2.0): number {
  return Math.max(min, Math.min(max, activation));
}

/** Clamp coherence */
export function clampCoherence(coherence: number): number {
  return Math.max(0.75, Math.min(1.0, coherence));
}

/** Classify Kuramoto phase */
export function classifyKuramotoPhase(r: number): "DISORDERED" | "TRANSITIONING" | "COHERENT" {
  if (r < R_CRITICAL) return "DISORDERED";
  if (r < R_COHERENT) return "TRANSITIONING";
  return "COHERENT";
}
