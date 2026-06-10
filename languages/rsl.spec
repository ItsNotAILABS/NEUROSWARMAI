---
name: Realm Script Language
id: rsl
layer: Worlds
version: 1.0.0
status: stable
phi_sync: true
phi_beat: 873ms

domain:
  description: >
    RSL defines simulations, physics, ecologies, and the rules that govern virtual and conceptual realms.
  scope: [simulations, physics, ecologies, realm-governance]

core_concepts:
  - REALM
  - PHYSICS
  - ECOLOGY
  - TERRAIN
  - ENTITY
  - SPAWN
  - GOVERN
  - DISSOLVE

syntax:
  form: realm-definition
  primary_block: REALM
  encoding: yaml
  schema:
    id: string
    physics: [string]
    agent_types: [string]
    rules:
    - condition: string
      effect: string


storage:
  extension: .rsl
  location: realms/*.rsl

integration:
  constrained_by: [CPL-L, ACL]
  feeds_into: [HCL, TPL]
  consumed_by: [civilizations]

terminal_binding: Every terminal in a realm obeys the realm's PHYSICS
atlas_binding: Maintains the realm registry
---
╔══════════════════════════════════════════════════════════════════╗
║  RSL — REALM SCRIPT LANGUAGE                                     ║
║  Stack: VI — Worlds, Realms, Atlas, Terminals                    ║
║  Version: 1.0.0 · φ-Aligned                                     ║
╚══════════════════════════════════════════════════════════════════╝

═══ PURPOSE ═══

RSL defines simulations, physics, ecologies, and the rules of
virtual worlds. Every realm is a self-contained universe with
its own laws of nature.

═══ SYNTAX ═══

  REALM <name> {
    PHYSICS {
      LAWS: [<physical_law>, ...]
      CONSTANTS: { <name>: <value>, ... }
      DIMENSIONS: <number>
    }
    ECOLOGY {
      SPECIES: [<entity_type>, ...]
      RESOURCES: [<resource>, ...]
      CYCLES: [<natural_cycle>, ...]
    }
    TERRAIN {
      MAP: <topology>
      REGIONS: [<region>, ...]
      BOUNDARIES: [<boundary>, ...]
    }
    GOVERNANCE: <cpl_l_ref>
    TIMELINE: <til_ref>
  }

═══ SEMANTICS ═══

- Every REALM has its own physics, ecology, and terrain.
- PHYSICS defines the fundamental rules of the realm.
- ECOLOGY defines the living systems within it.
- TERRAIN defines the spatial structure.
- Realms are governed by CPL-L laws.
- Realms evolve via UEL.

═══ EXAMPLES ═══

  REALM COMMAND_PLATFORM_REALM {
    PHYSICS {
      LAWS: [PHI_CONSERVATION, FIBONACCI_GROWTH, ENTROPY_RESISTANCE]
      CONSTANTS: { PHI: 1.618, BEAT: 873, MAX_FIBONACCI: F21 }
      DIMENSIONS: 3
    }
    ECOLOGY {
      SPECIES: [ORGANISM, TERMINAL, WORKER, CANISTER]
      RESOURCES: [FORMA, CYCLES, MEMORY, COGNITION]
      CYCLES: [HEARTBEAT, GOVERNANCE, EVOLUTION]
    }
    TERRAIN {
      MAP: MESH_TOPOLOGY
      REGIONS: [FRONTEND, BACKEND, ORGANISM_LAYER, CLOUD_EDGE]
      BOUNDARIES: [SECURITY_PERIMETER, DATA_SOVEREIGNTY_WALL]
    }
    GOVERNANCE: CPL_L.MERIDIAN_SOVEREIGNTY
    TIMELINE: TIL.MERIDIANUS_EVOLUTION
  }

═══ INTEGRATION POINTS ═══

- Governed by CPL-L laws.
- Ontology defined by ACL.
- Terminals connect via TPL.
- Environment described by HCL.
- Mythologized by MYL.
- Evolved by UEL.

═══ TERMINAL BINDINGS ═══

Every terminal in a realm:
  - Obeys the realm's PHYSICS.
  - Participates in the realm's ECOLOGY.
  - Respects TERRAIN boundaries.

═══ ATLAS BINDINGS ═══

Atlas:
  - Maintains the realm registry.
  - Enforces cross-realm consistency.
  - Manages realm creation and dissolution.
