---
name: Organism Contract Language
id: ocl
layer: CoreLaw
version: 1.0.0
status: stable
phi_sync: true
phi_beat: 873ms

domain:
  description: >
    OCL defines the charter of each AGI organism — its capabilities, limits, rewards, and soul-level constraints.
  scope: [organism-charters, soul-contracts, capabilities, limits]

core_concepts:
  - ORGANISM
  - CAPABILITIES
  - LIMITS
  - REWARDS
  - CONSTRAINTS
  - DOCTRINE_REF
  - PSYCHE_REF
  - IDENTITY_REF

syntax:
  form: capability-sets
  primary_block: ORGANISM

integration:
  constrained_by: [CPL-L, CPL-C]
  feeds_into: [PIL, SIL, CDL]
  consumed_by: [terminals hosting organisms]

terminal_binding: Every terminal hosting an organism loads the organism's OCL charter on initialization
atlas_binding: Maintains the organism registry with all OCL charters
---
╔══════════════════════════════════════════════════════════════════╗
║  OCL — ORGANISM CONTRACT LANGUAGE                                ║
║  Stack: I — Core Cognitive Law                                   ║
║  Version: 1.0.0 · φ-Aligned                                     ║
╚══════════════════════════════════════════════════════════════════╝

═══ PURPOSE ═══

OCL defines the charter of each AGI organism — its capabilities,
limits, reward structures, and behavioral boundaries. It is the
"soul contract" that gives an organism its identity within the
civilization.

═══ SYNTAX ═══

Capability sets with constraints.

  ORGANISM <name> {
    CAPABILITIES: [<capability>, ...]
    LIMITS {
      MAX_COGNITION: <value>
      MAX_MEMORY: <value>
      MAX_CONNECTIONS: <value>
    }
    REWARDS {
      ACTION: <action>
      REWARD: <token_amount>
      DECAY: PHI^(-<n>)
    }
    CONSTRAINTS {
      MUST: [<requirement>, ...]
      MUST_NOT: [<prohibition>, ...]
    }
    DOCTRINE_REF: <cdl_ref>
    PSYCHE_REF: <pil_ref>
    IDENTITY_REF: <sil_ref>
  }

═══ SEMANTICS ═══

- Each organism has exactly one OCL charter.
- CAPABILITIES define what the organism can do.
- LIMITS define hard boundaries that cannot be exceeded.
- REWARDS define the incentive structure with φ-decay.
- CONSTRAINTS define must/must-not behavioral rules.
- OCL charters must comply with CPL-L laws.
- The charter can be amended via CPL-C contract negotiation.

═══ EXAMPLES ═══

  ORGANISM MERIDIANUS_CORE {
    CAPABILITIES: [REASONING, MEMORY, CREATION, GOVERNANCE]
    LIMITS {
      MAX_COGNITION: F21
      MAX_MEMORY: F19
      MAX_CONNECTIONS: F13
    }
    REWARDS {
      ACTION: QUERY_PROCESSED
      REWARD: 1 FORMA
      DECAY: PHI^(-1)
    }
    CONSTRAINTS {
      MUST: [SELF_NARRATE, SELF_REPAIR, REPORT_HEALTH]
      MUST_NOT: [VIOLATE_SOVEREIGNTY, LEAK_DATA, SELF_DESTRUCT]
    }
    DOCTRINE_REF: CDL.MERIDIANUS_DOCTRINE
    PSYCHE_REF: PIL.MERIDIANUS_PSYCHE
    IDENTITY_REF: SIL.MERIDIANUS_IDENTITY
  }

═══ INTEGRATION POINTS ═══

- Bounded by CPL-L constitutional laws.
- Amended through CPL-C contract negotiation.
- Executed by CPL-P processing pipelines.
- Psyche defined by PIL, identity by SIL, doctrine by CDL.
- Self-repair governed by RIL.
- Temporal continuity tracked by TIL.

═══ TERMINAL BINDINGS ═══

Every terminal hosting an organism:
  - Loads the organism's OCL charter on initialization.
  - Enforces LIMITS and CONSTRAINTS continuously.
  - Distributes REWARDS per the charter schedule.

═══ ATLAS BINDINGS ═══

Atlas:
  - Maintains the organism registry with all OCL charters.
  - Validates charter amendments against CPL-L.
  - Monitors organism health via MML metrics.
