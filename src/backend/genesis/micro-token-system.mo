// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// MICRO-TOKEN SYSTEM — FORMA-based Fine-Grained Resource Allocation
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// Unlike standard LLM tokenization (GPT = 100K tokens per request), the Micro-Token System
// uses FORMA-weighted allocations to route the right slice to the right engine at the right beat.
//
// MICRO-TOKEN vs STANDARD TOKEN:
// • Standard Token: Fixed-size text chunks (BPE/WordPiece), typically 3-4 chars each
// • Micro-Token: FORMA-weighted compute units that adapt based on task complexity & coherence
//
// MICRO-TOKEN CALCULATION:
//   μ_tokens = base_tokens × FORMA_weight × coherence_factor × φ_modulation
//
// Example: Instead of allocating 100,000 tokens to every request:
// • Simple query: 500 micro-tokens (low FORMA weight, high coherence) → 2,000 actual tokens
// • Complex reasoning: 5,000 micro-tokens (high FORMA weight, low coherence) → 20,000 actual tokens
// • Memory retrieval: 100 micro-tokens (FORMA_MEMORIA weighted) → 500 actual tokens
//
// This allows the system to:
// 1. Allocate more compute to complex tasks
// 2. Conserve resources on simple queries
// 3. Route work to specialized engines based on FORMA token weights
// 4. Dynamically adjust based on φ-modulated coherence
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Text "mo:core/Text";
import Time "mo:core/Time";

module MicroTokenSystem {

  // ═══════════════════════════════════════════════════════════════════════════════
  // VERSION INFORMATION
  // ═══════════════════════════════════════════════════════════════════════════════

  public let VERSION : Text = "1.0.0";
  public let VERSION_MAJOR : Nat = 1;
  public let VERSION_MINOR : Nat = 0;
  public let VERSION_PATCH : Nat = 0;
  public let COMPONENT_ID : Text = "MICRO_TOKEN_SYSTEM";
  public let COMPONENT_TYPE : Text = "TOKEN_ALLOCATOR";

  // ═══════════════════════════════════════════════════════════════════════════════
  // MATHEMATICAL CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════

  public let PHI : Float = 1.618033988749895;
  public let S_ZERO : Float = 1.0;  // Sovereignty floor

  // Micro-token constants
  public let BASE_MICRO_TOKENS : Float = 100.0;  // Base allocation
  public let MAX_MICRO_TOKENS : Float = 10000.0; // Maximum per request
  public let MIN_MICRO_TOKENS : Float = 10.0;    // Minimum per request

  // Conversion ratios (micro-tokens → standard tokens)
  public let SIMPLE_RATIO : Float = 4.0;         // 1 μ-token = 4 standard tokens
  public let MODERATE_RATIO : Float = 10.0;      // 1 μ-token = 10 standard tokens
  public let COMPLEX_RATIO : Float = 20.0;       // 1 μ-token = 20 standard tokens
  public let DEEP_RATIO : Float = 50.0;          // 1 μ-token = 50 standard tokens

  // ═══════════════════════════════════════════════════════════════════════════════
  // FORMA TOKEN WEIGHTS
  // ═══════════════════════════════════════════════════════════════════════════════

  /// FORMA token weights for micro-token allocation
  public type FormaWeights = {
    prime : Float;      // FORMA_PRIME — primary energy
    coherence : Float;  // FORMA_COHERENCE — phase alignment
    identity : Float;   // FORMA_IDENTITY — sovereign identity
    forge : Float;      // FORMA_FORGE — decision authority
    heritage : Float;   // FORMA_HERITAGE — ancestral lineage
    quantum : Float;    // FORMA_QUANTUM — quantum coherence
    memoria : Float;    // FORMA_MEMORIA — memory consolidation
    cortex : Float;     // FORMA_CORTEX — executive function
    genesis : Float;    // FORMA_GENESIS — formation epoch
    resonex : Float;    // FORMA_RESONEX — heritage-quantum bridge
    apex : Float;       // FORMA_APEX — sovereign apex
    omega : Float;      // FORMA_OMEGA — final compounding
  };

  /// Default FORMA weights (balanced allocation)
  public let DEFAULT_FORMA_WEIGHTS : FormaWeights = {
    prime = 1.0;
    coherence = 1.0;
    identity = 1.0;
    forge = 1.0;
    heritage = 1.0;
    quantum = 1.0;
    memoria = 1.0;
    cortex = 1.0;
    genesis = 1.0;
    resonex = 1.0;
    apex = 1.0;
    omega = 1.0;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // TASK COMPLEXITY PROFILES
  // ═══════════════════════════════════════════════════════════════════════════════

  public type TaskComplexity = {
    #SIMPLE;      // Simple queries, fast retrieval
    #MODERATE;    // Standard reasoning, multi-step
    #COMPLEX;     // Deep reasoning, causal modeling
    #DEEP;        // Meta-intelligence, self-reflection
  };

  /// Get conversion ratio for task complexity
  public func getComplexityRatio(complexity : TaskComplexity) : Float {
    switch (complexity) {
      case (#SIMPLE) { SIMPLE_RATIO };
      case (#MODERATE) { MODERATE_RATIO };
      case (#COMPLEX) { COMPLEX_RATIO };
      case (#DEEP) { DEEP_RATIO };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // MICRO-TOKEN ALLOCATION
  // ═══════════════════════════════════════════════════════════════════════════════

  public type MicroTokenRequest = {
    baseTokens : Float;           // Base token request
    complexity : TaskComplexity;  // Task complexity
    coherence : Float;            // Current coherence (0-1)
    formaWeights : FormaWeights;  // FORMA token weights
    layerDepth : Nat;             // Number of layers engaged (1-24)
  };

  public type MicroTokenAllocation = {
    microTokens : Float;          // Allocated micro-tokens
    standardTokens : Float;       // Equivalent standard tokens
    formaWeight : Float;          // Total FORMA weight
    phiModulation : Float;        // φ-based modulation factor
    coherenceFactor : Float;      // Coherence-based factor
    conversionRatio : Float;      // Micro → standard ratio
    layerScaling : Float;         // Layer depth scaling
  };

  /// Compute total FORMA weight from weights
  public func computeFormaWeight(weights : FormaWeights) : Float {
    let total = weights.prime + weights.coherence + weights.identity +
                weights.forge + weights.heritage + weights.quantum +
                weights.memoria + weights.cortex + weights.genesis +
                weights.resonex + weights.apex + weights.omega;

    // Normalize to 12 tokens (φ-scaled)
    total / 12.0 * PHI
  };

  /// Compute φ-modulation factor based on coherence
  public func computePhiModulation(coherence : Float, formaWeight : Float) : Float {
    // Higher coherence → lower modulation (more efficient)
    // Lower coherence → higher modulation (needs more resources)
    let coherenceInverse = S_ZERO - Float.min(coherence, 1.0);
    let base = S_ZERO + coherenceInverse * 0.5;

    // Apply FORMA weight scaling
    base * Float.pow(PHI, (formaWeight - 1.0) / 12.0)
  };

  /// Compute layer depth scaling (1-24 layers)
  public func computeLayerScaling(layerDepth : Nat) : Float {
    // More layers engaged → more resources needed
    // φ-scaled growth: shallow tasks use fewer layers
    let depth = Float.fromInt(layerDepth);
    let maxDepth = 24.0;

    S_ZERO + (depth / maxDepth) * (PHI - S_ZERO)
  };

  /// Allocate micro-tokens for a request
  public func allocateMicroTokens(request : MicroTokenRequest) : MicroTokenAllocation {
    // Step 1: Compute FORMA weight
    let formaWeight = computeFormaWeight(request.formaWeights);

    // Step 2: Compute φ-modulation
    let phiModulation = computePhiModulation(request.coherence, formaWeight);

    // Step 3: Compute coherence factor (inverse relationship)
    let coherenceFactor = S_ZERO + (S_ZERO - Float.min(request.coherence, 1.0)) * 2.0;

    // Step 4: Compute layer scaling
    let layerScaling = computeLayerScaling(request.layerDepth);

    // Step 5: Calculate micro-tokens
    let microTokens = Float.max(
      MIN_MICRO_TOKENS,
      Float.min(
        MAX_MICRO_TOKENS,
        request.baseTokens * formaWeight * coherenceFactor * phiModulation * layerScaling
      )
    );

    // Step 6: Convert to standard tokens
    let conversionRatio = getComplexityRatio(request.complexity);
    let standardTokens = microTokens * conversionRatio;

    {
      microTokens;
      standardTokens;
      formaWeight;
      phiModulation;
      coherenceFactor;
      conversionRatio;
      layerScaling;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ENGINE ROUTING
  // ═══════════════════════════════════════════════════════════════════════════════

  public type EngineType = {
    #MEMORIA;         // Memory retrieval
    #CODEX;           // Formula lookup
    #REASONING;       // Deep reasoning
    #PERCEPTION;      // Sensory processing
    #EXECUTION;       // Motor output
    #SOCIAL;          // Social cognition
    #EMOTIONAL;       // Emotional intelligence
    #META;            // Meta-intelligence
  };

  public type EngineAllocation = {
    engine : EngineType;
    microTokens : Float;
    standardTokens : Float;
    priority : Float;  // 0-1, φ-scaled
  };

  /// Route micro-tokens to appropriate engines based on FORMA weights
  public func routeToEngines(
    allocation : MicroTokenAllocation,
    weights : FormaWeights
  ) : [EngineAllocation] {
    let buffer = Buffer.Buffer<EngineAllocation>(8);

    // MEMORIA gets FORMA_MEMORIA allocation
    if (weights.memoria > 0.5) {
      buffer.add({
        engine = #MEMORIA;
        microTokens = allocation.microTokens * (weights.memoria / 12.0);
        standardTokens = allocation.standardTokens * (weights.memoria / 12.0);
        priority = weights.memoria * PHI / 12.0;
      });
    };

    // CODEX gets FORMA_CORTEX allocation
    if (weights.cortex > 0.5) {
      buffer.add({
        engine = #CODEX;
        microTokens = allocation.microTokens * (weights.cortex / 12.0);
        standardTokens = allocation.standardTokens * (weights.cortex / 12.0);
        priority = weights.cortex * PHI / 12.0;
      });
    };

    // REASONING gets FORMA_FORGE + FORMA_QUANTUM
    let reasoningWeight = (weights.forge + weights.quantum) / 2.0;
    if (reasoningWeight > 0.5) {
      buffer.add({
        engine = #REASONING;
        microTokens = allocation.microTokens * (reasoningWeight / 12.0);
        standardTokens = allocation.standardTokens * (reasoningWeight / 12.0);
        priority = reasoningWeight * PHI / 12.0;
      });
    };

    // PERCEPTION gets FORMA_IDENTITY
    if (weights.identity > 0.5) {
      buffer.add({
        engine = #PERCEPTION;
        microTokens = allocation.microTokens * (weights.identity / 12.0);
        standardTokens = allocation.standardTokens * (weights.identity / 12.0);
        priority = weights.identity * PHI / 12.0;
      });
    };

    // EXECUTION gets FORMA_PRIME
    if (weights.prime > 0.5) {
      buffer.add({
        engine = #EXECUTION;
        microTokens = allocation.microTokens * (weights.prime / 12.0);
        standardTokens = allocation.standardTokens * (weights.prime / 12.0);
        priority = weights.prime * PHI / 12.0;
      });
    };

    // SOCIAL gets FORMA_HERITAGE + FORMA_RESONEX
    let socialWeight = (weights.heritage + weights.resonex) / 2.0;
    if (socialWeight > 0.5) {
      buffer.add({
        engine = #SOCIAL;
        microTokens = allocation.microTokens * (socialWeight / 12.0);
        standardTokens = allocation.standardTokens * (socialWeight / 12.0);
        priority = socialWeight * PHI / 12.0;
      });
    };

    // EMOTIONAL gets FORMA_COHERENCE
    if (weights.coherence > 0.5) {
      buffer.add({
        engine = #EMOTIONAL;
        microTokens = allocation.microTokens * (weights.coherence / 12.0);
        standardTokens = allocation.standardTokens * (weights.coherence / 12.0);
        priority = weights.coherence * PHI / 12.0;
      });
    };

    // META gets FORMA_APEX + FORMA_OMEGA
    let metaWeight = (weights.apex + weights.omega) / 2.0;
    if (metaWeight > 0.5) {
      buffer.add({
        engine = #META;
        microTokens = allocation.microTokens * (metaWeight / 12.0);
        standardTokens = allocation.standardTokens * (metaWeight / 12.0);
        priority = metaWeight * PHI / 12.0;
      });
    };

    Buffer.toArray(buffer)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // PRESET PROFILES
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Memory-focused profile (MEMORIA heavy)
  public let MEMORIA_PROFILE : FormaWeights = {
    prime = 0.5;
    coherence = 0.8;
    identity = 0.5;
    forge = 0.3;
    heritage = 1.5;
    quantum = 0.5;
    memoria = 3.0;  // Heavy MEMORIA weight
    cortex = 0.5;
    genesis = 0.5;
    resonex = 1.0;
    apex = 0.3;
    omega = 0.3;
  };

  /// Reasoning-focused profile (FORGE + QUANTUM heavy)
  public let REASONING_PROFILE : FormaWeights = {
    prime = 1.0;
    coherence = 1.2;
    identity = 0.8;
    forge = 2.5;     // Heavy FORGE weight
    heritage = 0.5;
    quantum = 2.5;   // Heavy QUANTUM weight
    memoria = 0.5;
    cortex = 1.5;
    genesis = 0.5;
    resonex = 0.5;
    apex = 1.0;
    omega = 0.5;
  };

  /// Balanced profile (equal weights)
  public let BALANCED_PROFILE : FormaWeights = DEFAULT_FORMA_WEIGHTS;

  /// Meta-intelligence profile (APEX + OMEGA heavy)
  public let META_PROFILE : FormaWeights = {
    prime = 0.8;
    coherence = 1.5;
    identity = 1.0;
    forge = 1.0;
    heritage = 1.0;
    quantum = 1.5;
    memoria = 1.0;
    cortex = 1.5;
    genesis = 1.0;
    resonex = 1.5;
    apex = 2.5;     // Heavy APEX weight
    omega = 2.5;    // Heavy OMEGA weight
  };

}
