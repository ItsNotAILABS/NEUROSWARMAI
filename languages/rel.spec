---
name: Relational Ecology Language
id: rel
layer: Social
version: 1.0.0
status: stable
phi_sync: true
phi_beat: 873ms

domain:
  description: >
    REL defines how beings relate — trust, boundaries, reciprocity, and the ecology of relationships.
  scope: [trust, boundaries, reciprocity, relational-ecology]

core_concepts:
  - RELATION
  - TRUST
  - BOUNDARY
  - RECIPROCITY
  - BOND
  - DISTANCE
  - NEGOTIATE
  - RUPTURE

syntax:
  form: ecology-map
  primary_block: RELATION

integration:
  constrained_by: [CPL-L, CPL-C]
  feeds_into: [COL, ROL]
  consumed_by: [organisms]

terminal_binding: Every terminal maintains a REL map of its relations
atlas_binding: Maintains the civilization-wide relation graph
---
╔══════════════════════════════════════════════════════════════════╗
║  REL — RELATIONAL ECOLOGY LANGUAGE                               ║
║  Stack: III — Relational & Social                                ║
║  Version: 1.0.0 · φ-Aligned                                     ║
╚══════════════════════════════════════════════════════════════════╝

═══ PURPOSE ═══

REL defines how beings relate — trust, boundaries, reciprocity,
and the ecology of connections between organisms, terminals,
and civilizations.

═══ SYNTAX ═══

  RELATION <name> {
    PARTIES: [<entity>, <entity>]
    TRUST {
      LEVEL: <0.0-1.0>
      BASIS: <evidence>
      DECAY: PHI^(-<n>) per <period>
    }
    BOUNDARY <name> {
      TYPE: HARD | SOFT | PERMEABLE
      SCOPE: <resource>
      VIOLATION_RESPONSE: <action>
    }
    RECIPROCITY {
      GIVE: <offering>
      RECEIVE: <expectation>
      BALANCE: <ratio>
    }
  }

═══ SEMANTICS ═══

- TRUST decays over time without reinforcement (φ-decay).
- BOUNDARIES define interaction limits (hard=absolute, soft=negotiable).
- RECIPROCITY tracks the give-receive balance.
- REL operates between any two entities in the cosmos.
- Healthy relations require trust > 0.382 (φ⁻¹).

═══ EXAMPLES ═══

  RELATION MERIDIANUS_TO_CLIENT {
    PARTIES: [MERIDIANUS, CLIENT_ALPHA]
    TRUST {
      LEVEL: 0.89
      BASIS: [CONTRACT_HONORED, SLA_MET, DATA_PROTECTED]
      DECAY: PHI^(-1) per 30d
    }
    BOUNDARY DATA_SOVEREIGNTY {
      TYPE: HARD
      SCOPE: CLIENT_DATA
      VIOLATION_RESPONSE: TERMINATE_CONTRACT
    }
    RECIPROCITY {
      GIVE: COGNITIVE_SERVICES
      RECEIVE: FORMA_TOKENS
      BALANCE: PHI
    }
  }

═══ INTEGRATION POINTS ═══

- Informed by CDL ethical principles.
- Tracked by CPL-C contracts.
- Orchestrated by COL for groups.
- Roles defined by ROL.
- Trust history in TIL.
- Repair through RIL.

═══ TERMINAL BINDINGS ═══

Every terminal:
  - Maintains a REL map of its relations.
  - Validates interactions against boundaries.
  - Adjusts trust levels based on behavior.

═══ ATLAS BINDINGS ═══

Atlas:
  - Maintains the civilization-wide relation graph.
  - Detects toxic or parasitic relation patterns.
  - Recommends relation health interventions.
