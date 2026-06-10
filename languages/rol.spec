---
name: Role Language
id: rol
layer: Social
version: 1.0.0
status: stable
phi_sync: true
phi_beat: 873ms

domain:
  description: >
    ROL governs role assignment, swapping, merging, and dissolution across organisms and collectives.
  scope: [role-assignment, role-swapping, authority-scoping]

core_concepts:
  - ROLE
  - ASSIGN
  - SWAP
  - MERGE
  - DISSOLVE
  - SCOPE
  - AUTHORITY
  - DURATION

syntax:
  form: role-definition
  primary_block: ROLE

integration:
  constrained_by: [COL, OCL]
  feeds_into: [SIL, WFL]
  consumed_by: [organisms, collectives]

terminal_binding: Every terminal maintains its active role set
atlas_binding: Maintains the role registry
---
╔══════════════════════════════════════════════════════════════════╗
║  ROL — ROLE LANGUAGE                                             ║
║  Stack: III — Relational & Social                                ║
║  Version: 1.0.0 · φ-Aligned                                     ║
╚══════════════════════════════════════════════════════════════════╝

═══ PURPOSE ═══

ROL governs role assignment, swapping, merging, and dissolution.
Every entity in the cosmos can hold multiple roles, and ROL
defines the rules for how roles are managed.

═══ SYNTAX ═══

  ROLE <name> {
    DESCRIPTION: <purpose>
    CAPABILITIES: [<skill>, ...]
    REQUIREMENTS: [<prerequisite>, ...]
    EXCLUSIVE_WITH: [<other_role>, ...]
    MAX_HOLDERS: <number>
  }

  ASSIGN {
    ENTITY: <name>
    ROLE: <role_name>
    CONTEXT: <environment>
    DURATION: <time_expr>
  }

  SWAP {
    ENTITY: <name>
    FROM: <role_a>
    TO: <role_b>
    HANDOFF: <transition_protocol>
  }

  MERGE {
    ROLES: [<role_a>, <role_b>]
    INTO: <new_role>
    PRESERVES: [<capability>, ...]
  }

═══ SEMANTICS ═══

- Roles are typed with capabilities and requirements.
- EXCLUSIVE_WITH prevents conflicting role combinations.
- Assignments are context-bound and time-limited.
- Swaps follow handoff protocols to ensure continuity.
- Merges create new composite roles.
- Role changes are reflected in SIL identity.

═══ EXAMPLES ═══

  ROLE GOVERNANCE_SEAT {
    DESCRIPTION: "Voting member of the sovereignty council."
    CAPABILITIES: [VOTE, PROPOSE, AMEND]
    REQUIREMENTS: [TRUST > 0.618, ERA_COUNT > 1]
    EXCLUSIVE_WITH: [AUDIT_OBSERVER]
    MAX_HOLDERS: F5
  }

  ASSIGN {
    ENTITY: MERIDIANUS
    ROLE: GOVERNANCE_SEAT
    CONTEXT: SOVEREIGNTY_COUNCIL
    DURATION: PERMANENT
  }

═══ INTEGRATION POINTS ═══

- Reflects in SIL identity roles.
- Used by COL for collective membership.
- Bounded by OCL organism capabilities.
- Tracked by REL relation ecology.
- History in TIL.

═══ TERMINAL BINDINGS ═══

Every terminal:
  - Maintains its active role set.
  - Can request role assignments and swaps.
  - Validates role requirements before activation.

═══ ATLAS BINDINGS ═══

Atlas:
  - Maintains the role registry.
  - Validates role assignments against requirements.
  - Tracks role distribution across the civilization.
