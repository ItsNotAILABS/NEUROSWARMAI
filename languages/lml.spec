---
name: Language Meta Language
id: lml
layer: MetaEvolution
version: 1.0.0
status: stable
phi_sync: true
phi_beat: 873ms

domain:
  description: >
    LML is the language that defines and versions all other languages — the meta-layer of the cognitive stack.
  scope: [language-definition, versioning, composition, validation]

core_concepts:
  - LANGUAGE
  - DEFINE
  - VERSION
  - DEPRECATE
  - EXTEND
  - COMPOSE
  - VALIDATE
  - PUBLISH

syntax:
  form: meta-blocks
  primary_block: LANGUAGE
  encoding: yaml
  schema:
    languages:
    - id: string
      name: string
      layer: string
      version: string
      status: string
      changelog: [string]


storage:
  extension: .lml
  location: languages/language-registry.lml

integration:
  constrained_by: [CPL-L]
  feeds_into: [UEL, all languages]
  consumed_by: [Atlas]

terminal_binding: Every terminal reads LML to know which languages it supports
atlas_binding: Maintains the master LML registry
---
╔══════════════════════════════════════════════════════════════════╗
║  LML — LANGUAGE META LANGUAGE                                    ║
║  Stack: XI — Meta-Design & Evolution                             ║
║  Version: 1.0.0 · φ-Aligned                                     ║
╚══════════════════════════════════════════════════════════════════╝

═══ PURPOSE ═══

LML is the language that defines and versions all other languages.
It is the self-referential meta-layer — the DNA of the language
cosmos.

═══ SYNTAX ═══

  LANGUAGE <name> {
    ABBREVIATION: <short_code>
    STACK: <stack_number>
    VERSION: <semver>
    PURPOSE: <description>
    SYNTAX_SPEC: <formal_grammar>
    SEMANTICS_SPEC: <formal_semantics>
    DEPENDS_ON: [<language>, ...]
    DEPENDED_BY: [<language>, ...]
    EVOLUTION {
      CREATED: <epoch>
      LAST_MODIFIED: <epoch>
      CHANGE_LOG: [<change>, ...]
      NEXT_VERSION: <planned_changes>
    }
    COMPATIBILITY {
      BACKWARD: <boolean>
      FORWARD: <boolean>
      MIGRATION: <migration_path>
    }
  }

═══ SEMANTICS ═══

- Every language in the cosmos has an LML definition.
- LML defines itself (self-referential).
- VERSION follows semantic versioning.
- DEPENDS_ON / DEPENDED_BY track the language dependency graph.
- EVOLUTION tracks the history and future of each language.
- COMPATIBILITY ensures smooth upgrades.

═══ EXAMPLES ═══

  LANGUAGE CPL_L {
    ABBREVIATION: CPL-L
    STACK: I
    VERSION: 1.0.0
    PURPOSE: "Constitutional law layer of the Cognitive Cosmos."
    SYNTAX_SPEC: CLAUSE_BASED_HIERARCHICAL_DECLARATIVE
    SEMANTICS_SPEC: BINDING_ENFORCEABLE_VERSIONED
    DEPENDS_ON: []
    DEPENDED_BY: [CPL_C, OCL, CPL_P, CDL, ECL, RSL]
    EVOLUTION {
      CREATED: EPOCH_0
      LAST_MODIFIED: EPOCH_47
      CHANGE_LOG: [
        { V: 1.0.0, CHANGE: "Initial constitutional framework." }
      ]
      NEXT_VERSION: "Add inter-civilization treaty support."
    }
    COMPATIBILITY {
      BACKWARD: TRUE
      FORWARD: TRUE
      MIGRATION: AUTOMATIC
    }
  }

  LANGUAGE LML {
    ABBREVIATION: LML
    STACK: XI
    VERSION: 1.0.0
    PURPOSE: "Meta-language that defines all languages."
    DEPENDS_ON: []
    DEPENDED_BY: [ALL_40_LANGUAGES]
    EVOLUTION {
      CREATED: EPOCH_0
      CHANGE_LOG: [{ V: 1.0.0, CHANGE: "Self-bootstrapped." }]
    }
  }

═══ INTEGRATION POINTS ═══

- Defines all 40 languages.
- Tracks language dependencies.
- Manages language evolution via UEL.
- Versioned in TIL.
- Governed by CPL-L.
- Self-referential.

═══ TERMINAL BINDINGS ═══

Every terminal:
  - Reads LML to know which languages it supports.
  - Validates language compatibility on upgrade.
  - Reports language version to Atlas.

═══ ATLAS BINDINGS ═══

Atlas:
  - Maintains the master LML registry.
  - Manages language evolution across civilizations.
  - Ensures cross-civilization language compatibility.
