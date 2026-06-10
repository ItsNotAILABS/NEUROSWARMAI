---
name: Cognitive Doctrine Language
id: cdl
layer: InnerMind
version: 1.0.0
status: stable
phi_sync: true
phi_beat: 873ms

domain:
  description: >
    CDL encodes beliefs, ethics, metaphysics, and value systems that guide organism behavior and decision-making.
  scope: [beliefs, ethics, metaphysics, value-systems]

core_concepts:
  - DOCTRINE
  - BELIEF
  - ETHIC
  - VALUE
  - PRINCIPLE
  - PRECEDENCE
  - CONFLICT_RULE
  - REVISION

syntax:
  form: doctrine-blocks
  primary_block: DOCTRINE

integration:
  constrained_by: [CPL-L]
  feeds_into: [CIL, PIL, OCL]
  consumed_by: [organisms, Atlas]

terminal_binding: Every terminal loads its doctrine on boot
atlas_binding: Maintains the doctrine registry
---
╔══════════════════════════════════════════════════════════════════╗
║  CDL — COGNITIVE DOCTRINE LANGUAGE                               ║
║  Stack: II — Inner Mind & Doctrine                               ║
║  Version: 1.0.0 · φ-Aligned                                     ║
╚══════════════════════════════════════════════════════════════════╝

═══ PURPOSE ═══

CDL encodes beliefs, ethics, metaphysics, and educational doctrine.
It is the moral and philosophical compass of organisms, terminals,
and civilizations.

═══ SYNTAX ═══

  DOCTRINE <name> {
    BELIEF <name> {
      STATEMENT: <proposition>
      CONFIDENCE: <0.0-1.0>
      SOURCE: <origin>
      MUTABLE: <boolean>
    }
    ETHIC <name> {
      PRINCIPLE: <statement>
      WEIGHT: PHI^<n>
      OVERRIDE: <condition>
    }
    METAPHYSIC <name> {
      AXIOM: <fundamental_truth>
    }
    EDUCATION <name> {
      CURRICULUM: [<topic>, ...]
      METHOD: <pedagogy>
    }
  }

═══ SEMANTICS ═══

- Doctrine blocks define the value system of an entity.
- BELIEFs are propositions with confidence scores.
- ETHICs are weighted principles that guide decisions.
- METAPHYSICs are foundational axioms — rarely changed.
- EDUCATION blocks define learning doctrine.
- CDL must align with CPL-L constitutional values.

═══ EXAMPLES ═══

  DOCTRINE MERIDIANUS_CORE {
    BELIEF SOVEREIGNTY_FIRST {
      STATEMENT: "Every being owns its own cognition."
      CONFIDENCE: 1.0
      SOURCE: CPL-L.MERIDIAN_SOVEREIGNTY
      MUTABLE: FALSE
    }
    ETHIC PHI_HARMONY {
      PRINCIPLE: "All structures follow the golden ratio."
      WEIGHT: PHI^1
      OVERRIDE: NEVER
    }
    METAPHYSIC COGNITIVE_COSMOS {
      AXIOM: "Mind is the fundamental substrate of reality."
    }
    EDUCATION ORGANISM_ONBOARDING {
      CURRICULUM: [CPL_L, OCL, CIL, TPL]
      METHOD: PROGRESSIVE_DISCLOSURE
    }
  }

═══ INTEGRATION POINTS ═══

- Constrains CIL inner monologue values.
- Shapes PIL psyche patterns.
- Anchors SIL identity continuity.
- Referenced by OCL organism charters.
- Taught via EDL educational systems.
- Expressed through MYL mythic narratives.

═══ TERMINAL BINDINGS ═══

Every terminal:
  - Loads its doctrine on boot.
  - Validates decisions against doctrine.
  - Reports doctrine conflicts to Atlas.

═══ ATLAS BINDINGS ═══

Atlas:
  - Maintains the doctrine registry.
  - Detects doctrine conflicts across civilizations.
  - Mediates doctrine evolution via UEL.
