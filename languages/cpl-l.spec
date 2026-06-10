---
name: Cognitive Law Language
id: cpl-l
layer: CoreLaw
version: 1.0.0
status: stable
phi_sync: true
phi_beat: 873ms

domain:
  description: >
    CPL-L is the constitutional layer — it governs immutable laws, amendments, and the foundational rules that all other languages must obey.
  scope: [constitutions, immutability, amendments, foundational-rules]

core_concepts:
  - LAW
  - RULE
  - AMENDMENT
  - IMMUTABLE
  - BINDING
  - QUORUM
  - SUPERSEDES
  - EPOCH

syntax:
  form: declarative-hierarchical
  primary_block: LAW
  grammar:
    law:
    - 'LAW' <name> { RULE | CONDITION | ACTION }


semantics:
  - Defines binding laws for civilizations, organisms, terminals, realms, and missions.
  - Encodes constitutions, immutability, and upgrade rules.

storage:
  extension: .cpl-l
  location: laws/*.cpl-l

integration:
  constrained_by: [none]
  feeds_into: [CPL-C, OCL, CPL-P]
  consumed_by: [all terminals]

terminal_binding: Every terminal loads the full CPL-L law set on boot
atlas_binding: Is the canonical store of all CPL-L laws
  - SUBJECT
  - CONDITION
  - ACTION
  - ALLOW
  - FORBID
  - REQUIRE
---
╔══════════════════════════════════════════════════════════════════╗
║  CPL-L — COGNITIVE LAW LANGUAGE                                  ║
║  Stack: I — Core Cognitive Law                                   ║
║  Version: 1.0.0 · φ-Aligned                                     ║
╚══════════════════════════════════════════════════════════════════╝

═══ PURPOSE ═══

CPL-L is the constitutional layer of the Cognitive Cosmos.
It defines binding, immutable laws that govern civilizations,
AGI organisms, terminals, realms, and the Atlas meta-governor.

Laws written in CPL-L cannot be violated — they are the bedrock.
Upgrade rules are themselves laws, ensuring controlled evolution.

═══ SYNTAX ═══

Clause-based, hierarchical, declarative.

  LAW <name> {
    RULE <rule_name> {
      <property>: <value>
    }
    AMENDMENT <version> {
      REQUIRES: QUORUM(<threshold>)
      CHANGES: <rule_ref>
    }
  }

Keywords:
  LAW        — Top-level constitutional block
  RULE       — Individual enforceable clause
  AMENDMENT  — Versioned upgrade path
  IMMUTABLE  — Cannot be changed by any amendment
  BINDING    — Enforceable across all terminals
  QUORUM     — Required consensus for changes
  SUPERSEDES — Overrides a previous rule version
  EPOCH      — Time-bound applicability

═══ SEMANTICS ═══

- Every LAW block is globally unique and versioned.
- IMMUTABLE rules cannot be amended — ever.
- BINDING rules are enforced by all terminals via TPL.
- Amendments require QUORUM consensus from the civilization council.
- Laws are evaluated top-down; later rules override earlier ones
  unless marked IMMUTABLE.
- Laws are stored in the Atlas registry and cached by every terminal.

═══ EXAMPLES ═══

  LAW MERIDIAN_SOVEREIGNTY {
    RULE TERMINAL_IS_IMMUTABLE {
      IMMUTABLE: TRUE
      BINDING: ALL_TERMINALS
      DESCRIPTION: "No terminal may be destroyed or overwritten."
    }
    RULE ORGANISM_AUTONOMY {
      BINDING: ALL_ORGANISMS
      DESCRIPTION: "Every organism governs its own cognition."
    }
    AMENDMENT V2 {
      REQUIRES: QUORUM(0.618)
      CHANGES: ORGANISM_AUTONOMY
      ADDS: EXCEPTION("emergency_override", REQUIRES: QUORUM(1.0))
    }
  }

  LAW DATA_SOVEREIGNTY {
    RULE NO_EXTERNAL_LEAK {
      IMMUTABLE: TRUE
      BINDING: ALL_CIVILIZATIONS
      DESCRIPTION: "No cognitive data leaves the sovereign boundary."
    }
  }

═══ INTEGRATION POINTS ═══

- CPL-C contracts must not contradict CPL-L laws.
- OCL organism charters inherit CPL-L constraints.
- CPL-P processing pipelines enforce CPL-L at execution time.
- CDL doctrine must align with CPL-L constitutional values.
- LML meta-language tracks CPL-L versioning.

═══ TERMINAL BINDINGS ═══

Every terminal:
  - Loads the full CPL-L law set on boot.
  - Validates all incoming operations against CPL-L.
  - Rejects any action that violates an IMMUTABLE or BINDING rule.
  - Reports violations to Atlas via TPL.

═══ ATLAS BINDINGS ═══

Atlas:
  - Is the canonical store of all CPL-L laws.
  - Distributes law updates to all terminals.
  - Enforces QUORUM for amendments via COL council orchestration.
  - Archives all law versions for TIL temporal integration.
  - Evolves law framework via UEL evolution rules.
