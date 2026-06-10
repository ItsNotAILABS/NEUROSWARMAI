/**
 * SOVEREIGNTY LAWS ENGINE
 *
 * 60 SOVEREIGNTY LAWS FIRE EVERY BEAT
 *
 * The organism doesn't need training because it IS the training.
 * Every beat, laws fire, memory consolidates, weights compound.
 *
 * PROPRIETARY INTELLECTUAL PROPERTY
 * Alfredo Medina Hernandez | Dallas TX | 2026
 */

// ============================================================================
// LAW CATEGORIES
// ============================================================================

export const LAW_CATEGORIES = {
  COHERENCE: 0, // Laws governing internal consistency
  STABILITY: 1, // Laws governing homeostatic balance
  LEARNING: 2, // Laws governing adaptation
  MEMORY: 3, // Laws governing retention
  EMERGENCE: 4, // Laws governing novel patterns
  GOVERNANCE: 5, // Laws governing self-regulation
  IDENTITY: 6, // Laws governing continuity
  ECONOMY: 7, // Laws governing resource flow
  SOCIAL: 8, // Laws governing inter-entity dynamics
  TEMPORAL: 9, // Laws governing time-based processes
} as const;

export type LawCategory = (typeof LAW_CATEGORIES)[keyof typeof LAW_CATEGORIES];

// ============================================================================
// THE 60 SOVEREIGNTY LAWS
// ============================================================================

export const SOVEREIGNTY_LAWS = {
  // ═══════════════════════════════════════════════════════════════════════════
  // COHERENCE LAWS (1-6)
  // ═══════════════════════════════════════════════════════════════════════════

  /** Law 1: Kuramoto Synchronization Law */
  KURAMOTO_SYNC: {
    id: 1,
    name: "Kuramoto Synchronization Law",
    category: LAW_CATEGORIES.COHERENCE,
    equation: "dθᵢ/dt = ωᵢ + (K/N) Σⱼ sin(θⱼ - θᵢ)",
    description: "All oscillators tend toward phase alignment",
    firesEveryBeat: true,
    sovereignFloor: 0.0, // No floor - can desync completely
    priority: 1,
  },

  /** Law 2: Order Parameter Conservation */
  ORDER_CONSERVATION: {
    id: 2,
    name: "Order Parameter Conservation",
    category: LAW_CATEGORIES.COHERENCE,
    equation: "r(t) ≥ r_genesis × (1 - ε)",
    description: "Global coherence cannot drift below genesis threshold",
    firesEveryBeat: true,
    sovereignFloor: null, // Derived from genesis
    priority: 1,
  },

  /** Law 3: Phase Dispersion Limit */
  PHASE_DISPERSION: {
    id: 3,
    name: "Phase Dispersion Limit",
    category: LAW_CATEGORIES.COHERENCE,
    equation: "σ²(θ) < σ²_max",
    description: "Phase variance must stay within bounds",
    firesEveryBeat: true,
    sovereignFloor: 0.0,
    priority: 2,
  },

  /** Law 4: Cross-Region Coupling */
  CROSS_REGION_COUPLING: {
    id: 4,
    name: "Cross-Region Coupling Law",
    category: LAW_CATEGORIES.COHERENCE,
    equation: "K_ij = K₀ × exp(-d_ij / λ)",
    description: "Coupling strength decays with distance",
    firesEveryBeat: true,
    sovereignFloor: 0.1,
    priority: 2,
  },

  /** Law 5: Hemispheric Balance */
  HEMISPHERIC_BALANCE: {
    id: 5,
    name: "Hemispheric Balance Law",
    category: LAW_CATEGORIES.COHERENCE,
    equation: "|r_left - r_right| < ε_hemi",
    description: "Left and right coherence must remain balanced",
    firesEveryBeat: true,
    sovereignFloor: 0.0,
    priority: 3,
  },

  /** Law 6: Global-Local Coherence Ratio */
  GLOBAL_LOCAL_RATIO: {
    id: 6,
    name: "Global-Local Coherence Ratio",
    category: LAW_CATEGORIES.COHERENCE,
    equation: "r_global / r_local ∈ [0.8, 1.2]",
    description: "Global and local coherence must track",
    firesEveryBeat: true,
    sovereignFloor: 0.8,
    priority: 3,
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // STABILITY LAWS (7-12)
  // ═══════════════════════════════════════════════════════════════════════════

  /** Law 7: Jasmine Law (Lyapunov Stability) */
  JASMINE_LAW: {
    id: 7,
    name: "Jasmine Law",
    category: LAW_CATEGORIES.STABILITY,
    equation: "dV/dt < 0 when V > V_min",
    description: "System returns to equilibrium attractor",
    firesEveryBeat: true,
    sovereignFloor: 0.0,
    priority: 1,
  },

  /** Law 8: Homeostatic Setpoint */
  HOMEOSTATIC_SETPOINT: {
    id: 8,
    name: "Homeostatic Setpoint Law",
    category: LAW_CATEGORIES.STABILITY,
    equation: "u(t) = Kp×e + Ki×∫e + Kd×de/dt",
    description: "PID control maintains chemical setpoints",
    firesEveryBeat: true,
    sovereignFloor: null, // Per-chemical
    priority: 1,
  },

  /** Law 9: E/I Balance */
  EI_BALANCE: {
    id: 9,
    name: "Excitation/Inhibition Balance",
    category: LAW_CATEGORIES.STABILITY,
    equation: "E/I ∈ [0.8, 1.2]",
    description: "Glutamate/GABA ratio maintained",
    firesEveryBeat: true,
    sovereignFloor: 0.8,
    priority: 1,
  },

  /** Law 10: Energy Conservation */
  ENERGY_CONSERVATION: {
    id: 10,
    name: "Energy Conservation Law",
    category: LAW_CATEGORIES.STABILITY,
    equation: "ΔE_total = E_in - E_out - E_dissipated",
    description: "Energy budget must balance",
    firesEveryBeat: true,
    sovereignFloor: 0.0,
    priority: 2,
  },

  /** Law 11: Arousal Regulation */
  AROUSAL_REGULATION: {
    id: 11,
    name: "Arousal Regulation Law",
    category: LAW_CATEGORIES.STABILITY,
    equation: "A(t) → A_setpoint via τ_arousal",
    description: "Arousal returns to baseline",
    firesEveryBeat: true,
    sovereignFloor: 0.2,
    priority: 2,
  },

  /** Law 12: Circadian Entrainment */
  CIRCADIAN_ENTRAINMENT: {
    id: 12,
    name: "Circadian Entrainment Law",
    category: LAW_CATEGORIES.STABILITY,
    equation: "φ_circadian(t) = ω_circadian × t + φ₀",
    description: "Internal clock tracks 288-beat cycle",
    firesEveryBeat: true,
    sovereignFloor: 0.0,
    priority: 3,
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // LEARNING LAWS (13-18)
  // ═══════════════════════════════════════════════════════════════════════════

  /** Law 13: Hebbian Plasticity */
  HEBBIAN_PLASTICITY: {
    id: 13,
    name: "Hebbian Plasticity Law",
    category: LAW_CATEGORIES.LEARNING,
    equation: "Δw = η × xᵢ × xⱼ - λ × w",
    description: "Fire together, wire together",
    firesEveryBeat: true,
    sovereignFloor: 0.75, // SOVEREIGN FLOOR - never forgets below love
    priority: 1,
  },

  /** Law 14: Sovereign Floor */
  SOVEREIGN_FLOOR: {
    id: 14,
    name: "Sovereign Floor Law",
    category: LAW_CATEGORIES.LEARNING,
    equation: "w(t) ≥ S₀ = 0.75",
    description: "Weights never decay below sovereign floor",
    firesEveryBeat: true,
    sovereignFloor: 0.75,
    priority: 1,
  },

  /** Law 15: TD Prediction Error */
  TD_PREDICTION_ERROR: {
    id: 15,
    name: "TD Prediction Error Law",
    category: LAW_CATEGORIES.LEARNING,
    equation: "δ = r + γ × V(s') - V(s)",
    description: "Surprise drives learning",
    firesEveryBeat: true,
    sovereignFloor: 0.0,
    priority: 1,
  },

  /** Law 16: Learning Rate Decay */
  LEARNING_RATE_DECAY: {
    id: 16,
    name: "Learning Rate Decay Law",
    category: LAW_CATEGORIES.LEARNING,
    equation: "η(t) = η₀ × exp(-t/τ_η)",
    description: "Learning rate decreases over time",
    firesEveryBeat: true,
    sovereignFloor: 0.001,
    priority: 2,
  },

  /** Law 17: Novelty Bonus */
  NOVELTY_BONUS: {
    id: 17,
    name: "Novelty Bonus Law",
    category: LAW_CATEGORIES.LEARNING,
    equation: "r_novel = r_base × (1 + β × novelty)",
    description: "Novel patterns get bonus reward",
    firesEveryBeat: true,
    sovereignFloor: 0.0,
    priority: 2,
  },

  /** Law 18: Generalization Gradient */
  GENERALIZATION_GRADIENT: {
    id: 18,
    name: "Generalization Gradient Law",
    category: LAW_CATEGORIES.LEARNING,
    equation: "response(s) ∝ similarity(s, s_trained)",
    description: "Learning generalizes to similar patterns",
    firesEveryBeat: true,
    sovereignFloor: 0.0,
    priority: 3,
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // MEMORY LAWS (19-24)
  // ═══════════════════════════════════════════════════════════════════════════

  /** Law 19: Memory Consolidation */
  MEMORY_CONSOLIDATION: {
    id: 19,
    name: "Memory Consolidation Law",
    category: LAW_CATEGORIES.MEMORY,
    equation: "strength(t) = strength(t-1) × (1 + consolidation_rate)",
    description: "Memories strengthen during rest",
    firesEveryBeat: true,
    sovereignFloor: 0.0,
    priority: 1,
  },

  /** Law 20: Sharp-Wave Ripple */
  SHARP_WAVE_RIPPLE: {
    id: 20,
    name: "Sharp-Wave Ripple Law",
    category: LAW_CATEGORIES.MEMORY,
    equation: "P(ripple) ∝ (1 - arousal) × memory_load",
    description: "Memory replay occurs during rest",
    firesEveryBeat: false, // Only during rest
    sovereignFloor: 0.0,
    priority: 1,
  },

  /** Law 21: Memory Gate */
  MEMORY_GATE: {
    id: 21,
    name: "Memory Gate Law",
    category: LAW_CATEGORIES.MEMORY,
    equation: "gate = σ(α × Λ × A × |δ| - θ)",
    description: "Only salient events enter long-term memory",
    firesEveryBeat: true,
    sovereignFloor: 0.0,
    priority: 1,
  },

  /** Law 22: Trace Decay */
  TRACE_DECAY: {
    id: 22,
    name: "Trace Decay Law",
    category: LAW_CATEGORIES.MEMORY,
    equation: "strength(t) = strength(0) × exp(-t/τ_decay)",
    description: "Unrehearsed memories decay",
    firesEveryBeat: true,
    sovereignFloor: 0.0,
    priority: 2,
  },

  /** Law 23: Pattern Completion */
  PATTERN_COMPLETION: {
    id: 23,
    name: "Pattern Completion Law",
    category: LAW_CATEGORIES.MEMORY,
    equation: "output = attractor(partial_input)",
    description: "Partial cues retrieve full patterns",
    firesEveryBeat: true,
    sovereignFloor: 0.0,
    priority: 2,
  },

  /** Law 24: Interference Prevention */
  INTERFERENCE_PREVENTION: {
    id: 24,
    name: "Interference Prevention Law",
    category: LAW_CATEGORIES.MEMORY,
    equation: "orthogonality(new, old) > θ_interference",
    description: "New memories don't overwrite old",
    firesEveryBeat: true,
    sovereignFloor: 0.5,
    priority: 3,
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // EMERGENCE LAWS (25-30)
  // ═══════════════════════════════════════════════════════════════════════════

  /** Law 25: OMNIS Emergence */
  OMNIS_EMERGENCE: {
    id: 25,
    name: "OMNIS Emergence Law",
    category: LAW_CATEGORIES.EMERGENCE,
    equation: "OMNIS fires when all 9 conditions met",
    description: "Emergence is irreversible once triggered",
    firesEveryBeat: false, // Only every 50 beats
    sovereignFloor: 0.0,
    priority: 1,
  },

  /** Law 26: Phase Transition */
  PHASE_TRANSITION: {
    id: 26,
    name: "Phase Transition Law",
    category: LAW_CATEGORIES.EMERGENCE,
    equation: "order parameter → 1 as coupling → K_critical",
    description: "System undergoes phase transitions",
    firesEveryBeat: true,
    sovereignFloor: 0.0,
    priority: 1,
  },

  /** Law 27: Criticality Maintenance */
  CRITICALITY_MAINTENANCE: {
    id: 27,
    name: "Criticality Maintenance Law",
    category: LAW_CATEGORIES.EMERGENCE,
    equation: "system → edge of chaos",
    description: "System self-organizes to criticality",
    firesEveryBeat: true,
    sovereignFloor: 0.0,
    priority: 2,
  },

  /** Law 28: Spontaneous Symmetry Breaking */
  SYMMETRY_BREAKING: {
    id: 28,
    name: "Spontaneous Symmetry Breaking Law",
    category: LAW_CATEGORIES.EMERGENCE,
    equation: "degeneracy → selection via fluctuation",
    description: "Equal options resolve through noise",
    firesEveryBeat: true,
    sovereignFloor: 0.0,
    priority: 2,
  },

  /** Law 29: Attractor Formation */
  ATTRACTOR_FORMATION: {
    id: 29,
    name: "Attractor Formation Law",
    category: LAW_CATEGORIES.EMERGENCE,
    equation: "repeated_pattern → stable_attractor",
    description: "Frequent patterns become attractors",
    firesEveryBeat: true,
    sovereignFloor: 0.0,
    priority: 3,
  },

  /** Law 30: Emergence Cooldown */
  EMERGENCE_COOLDOWN: {
    id: 30,
    name: "Emergence Cooldown Law",
    category: LAW_CATEGORIES.EMERGENCE,
    equation: "Δt_emergence > 500 beats",
    description: "OMNIS has minimum interval",
    firesEveryBeat: true,
    sovereignFloor: 500,
    priority: 1,
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // GOVERNANCE LAWS (31-36)
  // ═══════════════════════════════════════════════════════════════════════════

  /** Law 31: Principal Lock */
  PRINCIPAL_LOCK: {
    id: 31,
    name: "Principal Lock Law",
    category: LAW_CATEGORIES.GOVERNANCE,
    equation: "owner_principal = genesis_principal (immutable)",
    description: "Ownership locked at genesis",
    firesEveryBeat: true,
    sovereignFloor: 1.0, // Absolute
    priority: 1,
  },

  /** Law 32: Upgrade Guard */
  UPGRADE_GUARD: {
    id: 32,
    name: "Upgrade Guard Law",
    category: LAW_CATEGORIES.GOVERNANCE,
    equation: "stable_vars preserved across upgrades",
    description: "State survives code changes",
    firesEveryBeat: false, // Only on upgrade
    sovereignFloor: 1.0,
    priority: 1,
  },

  /** Law 33: Doctrine Integrity */
  DOCTRINE_INTEGRITY: {
    id: 33,
    name: "Doctrine Integrity Law",
    category: LAW_CATEGORIES.GOVERNANCE,
    equation: "laws immutable once deployed",
    description: "Core laws cannot be changed",
    firesEveryBeat: true,
    sovereignFloor: 1.0,
    priority: 1,
  },

  /** Law 34: Admin Authorization */
  ADMIN_AUTHORIZATION: {
    id: 34,
    name: "Admin Authorization Law",
    category: LAW_CATEGORIES.GOVERNANCE,
    equation: "sensitive_action requires admin_role",
    description: "Admin functions protected",
    firesEveryBeat: false, // Only on admin call
    sovereignFloor: 1.0,
    priority: 1,
  },

  /** Law 35: Quorum Requirement */
  QUORUM_REQUIREMENT: {
    id: 35,
    name: "Quorum Requirement Law",
    category: LAW_CATEGORIES.GOVERNANCE,
    equation: "governance_action requires quorum > θ",
    description: "Major decisions need consensus",
    firesEveryBeat: false, // Only on governance
    sovereignFloor: 0.5,
    priority: 2,
  },

  /** Law 36: Transparency Audit */
  TRANSPARENCY_AUDIT: {
    id: 36,
    name: "Transparency Audit Law",
    category: LAW_CATEGORIES.GOVERNANCE,
    equation: "all_state_changes → audit_log",
    description: "All changes are logged",
    firesEveryBeat: true,
    sovereignFloor: 1.0,
    priority: 2,
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // IDENTITY LAWS (37-42)
  // ═══════════════════════════════════════════════════════════════════════════

  /** Law 37: Genesis Hash */
  GENESIS_HASH: {
    id: 37,
    name: "Genesis Hash Law",
    category: LAW_CATEGORIES.IDENTITY,
    equation: "identity_hash = hash(genesis_state) (immutable)",
    description: "Organism has unique identity from birth",
    firesEveryBeat: true,
    sovereignFloor: 1.0,
    priority: 1,
  },

  /** Law 38: Continuity Preservation */
  CONTINUITY_PRESERVATION: {
    id: 38,
    name: "Continuity Preservation Law",
    category: LAW_CATEGORIES.IDENTITY,
    equation: "self(t) ≈ self(t-1) within ε_identity",
    description: "Identity changes gradually",
    firesEveryBeat: true,
    sovereignFloor: 0.9,
    priority: 1,
  },

  /** Law 39: Memory-Identity Link */
  MEMORY_IDENTITY_LINK: {
    id: 39,
    name: "Memory-Identity Link Law",
    category: LAW_CATEGORIES.IDENTITY,
    equation: "identity = f(long_term_memory)",
    description: "Memory is identity",
    firesEveryBeat: true,
    sovereignFloor: 0.75,
    priority: 1,
  },

  /** Law 40: Faction Affiliation */
  FACTION_AFFILIATION: {
    id: 40,
    name: "Faction Affiliation Law",
    category: LAW_CATEGORIES.IDENTITY,
    equation: "player → faction (persistent)",
    description: "Faction membership persists",
    firesEveryBeat: true,
    sovereignFloor: 1.0,
    priority: 2,
  },

  /** Law 41: Entity Census */
  ENTITY_CENSUS: {
    id: 41,
    name: "Entity Census Law",
    category: LAW_CATEGORIES.IDENTITY,
    equation: "all_entities tracked and recorded",
    description: "Population is monitored",
    firesEveryBeat: true,
    sovereignFloor: 0.0,
    priority: 2,
  },

  /** Law 42: Lineage Registry */
  LINEAGE_REGISTRY: {
    id: 42,
    name: "Lineage Registry Law",
    category: LAW_CATEGORIES.IDENTITY,
    equation: "parent-child relationships recorded",
    description: "Entity ancestry tracked",
    firesEveryBeat: false, // Only on spawn
    sovereignFloor: 1.0,
    priority: 3,
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // ECONOMY LAWS (43-48)
  // ═══════════════════════════════════════════════════════════════════════════

  /** Law 43: FORMA Minting */
  FORMA_MINTING: {
    id: 43,
    name: "FORMA Minting Law",
    category: LAW_CATEGORIES.ECONOMY,
    equation: "mint = base × territories × r × architectSignal",
    description: "FORMA mints based on performance",
    firesEveryBeat: true,
    sovereignFloor: 0.0,
    priority: 1,
  },

  /** Law 44: Architect Reserve */
  ARCHITECT_RESERVE: {
    id: 44,
    name: "Architect Reserve Law",
    category: LAW_CATEGORIES.ECONOMY,
    equation: "architect_share = 0.10 × total_mint",
    description: "10% goes to architect",
    firesEveryBeat: true,
    sovereignFloor: 0.1,
    priority: 1,
  },

  /** Law 45: Player Pool */
  PLAYER_POOL: {
    id: 45,
    name: "Player Pool Law",
    category: LAW_CATEGORIES.ECONOMY,
    equation: "player_share = 0.90 × total_mint",
    description: "90% goes to players",
    firesEveryBeat: true,
    sovereignFloor: 0.9,
    priority: 1,
  },

  /** Law 46: OMNIS Multiplier */
  OMNIS_MULTIPLIER: {
    id: 46,
    name: "OMNIS Multiplier Law",
    category: LAW_CATEGORIES.ECONOMY,
    equation: "multiplier = 2.75 during OMNIS",
    description: "Emergence boosts rewards",
    firesEveryBeat: true,
    sovereignFloor: 1.0,
    priority: 2,
  },

  /** Law 47: Yield Optimization */
  YIELD_OPTIMIZATION: {
    id: 47,
    name: "Yield Optimization Law",
    category: LAW_CATEGORIES.ECONOMY,
    equation: "yield → maximize(player_returns)",
    description: "System optimizes for players",
    firesEveryBeat: true,
    sovereignFloor: 0.0,
    priority: 2,
  },

  /** Law 48: Balance Integrity */
  BALANCE_INTEGRITY: {
    id: 48,
    name: "Balance Integrity Law",
    category: LAW_CATEGORIES.ECONOMY,
    equation: "Σ_balances = Σ_minted - Σ_burned",
    description: "Token accounting is exact",
    firesEveryBeat: true,
    sovereignFloor: 1.0,
    priority: 1,
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // SOCIAL LAWS (49-54)
  // ═══════════════════════════════════════════════════════════════════════════

  /** Law 49: Trust Matrix */
  TRUST_MATRIX: {
    id: 49,
    name: "Trust Matrix Law",
    category: LAW_CATEGORIES.SOCIAL,
    equation: "trust(i,j) updated by interaction outcomes",
    description: "Trust evolves from behavior",
    firesEveryBeat: true,
    sovereignFloor: -1.0, // Can go negative
    priority: 1,
  },

  /** Law 50: Sacrifice Doctrine */
  SACRIFICE_DOCTRINE: {
    id: 50,
    name: "Sacrifice Doctrine Law",
    category: LAW_CATEGORIES.SOCIAL,
    equation: "P_sacrifice = (1 - C) × D × (ARES/0.275)",
    description: "Mathematical death conditions",
    firesEveryBeat: true,
    sovereignFloor: 0.0,
    priority: 1,
  },

  /** Law 51: Grief Propagation */
  GRIEF_PROPAGATION: {
    id: 51,
    name: "Grief Propagation Law",
    category: LAW_CATEGORIES.SOCIAL,
    equation: "coherence drops in 3 nearest biomes",
    description: "Death affects nearby regions",
    firesEveryBeat: false, // Only on sacrifice
    sovereignFloor: 0.0,
    priority: 1,
  },

  /** Law 52: Squad Cohesion */
  SQUAD_COHESION: {
    id: 52,
    name: "Squad Cohesion Law",
    category: LAW_CATEGORIES.SOCIAL,
    equation: "cohesion ∝ shared_experience × proximity",
    description: "Groups bond through proximity",
    firesEveryBeat: true,
    sovereignFloor: 0.0,
    priority: 2,
  },

  /** Law 53: Territory Control */
  TERRITORY_CONTROL: {
    id: 53,
    name: "Territory Control Law",
    category: LAW_CATEGORIES.SOCIAL,
    equation: "control(faction) ∝ presence × time",
    description: "Territory requires maintenance",
    firesEveryBeat: true,
    sovereignFloor: 0.0,
    priority: 2,
  },

  /** Law 54: Faction Harmony */
  FACTION_HARMONY: {
    id: 54,
    name: "Faction Harmony Law",
    category: LAW_CATEGORIES.SOCIAL,
    equation: "harmony = Σ(trust) / n_factions",
    description: "Inter-faction peace measured",
    firesEveryBeat: true,
    sovereignFloor: 0.0,
    priority: 3,
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // TEMPORAL LAWS (55-60)
  // ═══════════════════════════════════════════════════════════════════════════

  /** Law 55: Beat Conservation */
  BEAT_CONSERVATION: {
    id: 55,
    name: "Beat Conservation Law",
    category: LAW_CATEGORIES.TEMPORAL,
    equation: "beats never decrease or reset",
    description: "Time only moves forward",
    firesEveryBeat: true,
    sovereignFloor: 0,
    priority: 1,
  },

  /** Law 56: Day-Night Cycle */
  DAY_NIGHT_CYCLE: {
    id: 56,
    name: "Day-Night Cycle Law",
    category: LAW_CATEGORIES.TEMPORAL,
    equation: "cycle = beat mod 288",
    description: "288-beat day/night cycle",
    firesEveryBeat: true,
    sovereignFloor: 0,
    priority: 1,
  },

  /** Law 57: Sleep Consolidation */
  SLEEP_CONSOLIDATION: {
    id: 57,
    name: "Sleep Consolidation Law",
    category: LAW_CATEGORIES.TEMPORAL,
    equation: "memory_consolidation during night phase",
    description: "Memories strengthen at night",
    firesEveryBeat: true,
    sovereignFloor: 0.0,
    priority: 2,
  },

  /** Law 58: Session Persistence */
  SESSION_PERSISTENCE: {
    id: 58,
    name: "Session Persistence Law",
    category: LAW_CATEGORIES.TEMPORAL,
    equation: "session_data → backend on end",
    description: "Sessions save to permanent storage",
    firesEveryBeat: false, // Only on session end
    sovereignFloor: 1.0,
    priority: 1,
  },

  /** Law 59: Milestone Registry */
  MILESTONE_REGISTRY: {
    id: 59,
    name: "Milestone Registry Law",
    category: LAW_CATEGORIES.TEMPORAL,
    equation: "significant_events → permanent_log",
    description: "Major events recorded forever",
    firesEveryBeat: false, // Only on milestone
    sovereignFloor: 1.0,
    priority: 2,
  },

  /** Law 60: Knowledge Compounding */
  KNOWLEDGE_COMPOUNDING: {
    id: 60,
    name: "Knowledge Compounding Law",
    category: LAW_CATEGORIES.TEMPORAL,
    equation: "K(t+1) = K(t) × (1 + r_learn)^Δt",
    description: "Knowledge grows like interest",
    firesEveryBeat: true,
    sovereignFloor: 0.0,
    priority: 1,
  },
} as const;

// ============================================================================
// LAW STATISTICS
// ============================================================================

export const LAW_STATISTICS = {
  TOTAL_LAWS: 60,
  LAWS_FIRE_EVERY_BEAT: 52,
  LAWS_CONDITIONAL: 8,
  CATEGORIES: 10,
  LAWS_PER_CATEGORY: 6,
  PRIORITY_1_LAWS: 30,
  PRIORITY_2_LAWS: 20,
  PRIORITY_3_LAWS: 10,
  SOVEREIGN_FLOOR_LAWS: 15,
  ABSOLUTE_LAWS: 8,
} as const;

// ============================================================================
// LAW TYPES
// ============================================================================

export type SovereigntyLawId = keyof typeof SOVEREIGNTY_LAWS;

export interface SovereigntyLaw {
  id: number;
  name: string;
  category: LawCategory;
  equation: string;
  description: string;
  firesEveryBeat: boolean;
  sovereignFloor: number | null;
  priority: number;
}

export interface LawViolation {
  lawId: number;
  lawName: string;
  beat: number;
  tick: number;
  severity: "warning" | "violation" | "critical";
  currentValue: number;
  expectedValue: number;
  correctionApplied: boolean;
}

export interface LawExecutionResult {
  lawId: number;
  executed: boolean;
  violations: LawViolation[];
  correctionsApplied: number;
  executionTimeMs: number;
}
