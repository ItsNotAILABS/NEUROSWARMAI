---
name: Collective Orchestration Language
id: col
layer: Social
version: 1.0.0
status: stable
phi_sync: true
phi_beat: 873ms

domain:
  description: >
    COL orchestrates groups — councils, swarms, committees, and guilds — enabling collective decision-making.
  scope: [councils, swarms, guilds, collective-governance]

core_concepts:
  - COLLECTIVE
  - COUNCIL
  - SWARM
  - GUILD
  - VOTE
  - CONSENSUS
  - QUORUM
  - DELEGATE

syntax:
  form: collective-blocks
  primary_block: COLLECTIVE

integration:
  constrained_by: [CPL-L, REL]
  feeds_into: [ROL, WFL]
  consumed_by: [civilizations]

terminal_binding: Every terminal can participate in collectives
atlas_binding: Registers all active collectives
---
╔══════════════════════════════════════════════════════════════════╗
║  COL — COLLECTIVE ORCHESTRATION LANGUAGE                         ║
║  Stack: III — Relational & Social                                ║
║  Version: 1.0.0 · φ-Aligned                                     ║
╚══════════════════════════════════════════════════════════════════╝

═══ PURPOSE ═══

COL orchestrates groups — councils, swarms, committees, and guilds.
It defines how collectives form, deliberate, decide, and dissolve.

═══ SYNTAX ═══

  COLLECTIVE <name> {
    TYPE: COUNCIL | SWARM | COMMITTEE | GUILD
    MEMBERS: [<entity>, ...]
    GOVERNANCE {
      DECISION_MODE: CONSENSUS | MAJORITY | PHI_WEIGHTED | SOVEREIGN
      QUORUM: <threshold>
      VETO_POWER: [<entity>, ...]
    }
    PROTOCOL {
      CONVENE: <trigger>
      DELIBERATE: <process>
      RESOLVE: <action>
      DISSOLVE: <condition>
    }
  }

═══ SEMANTICS ═══

- COLLECTIVEs have typed governance structures.
- GOVERNANCE defines decision-making rules.
- PHI_WEIGHTED gives members φ-proportional influence.
- QUORUM is the minimum participation for valid decisions.
- Collectives can be permanent (COUNCIL) or ephemeral (SWARM).

═══ EXAMPLES ═══

  COLLECTIVE SOVEREIGNTY_COUNCIL {
    TYPE: COUNCIL
    MEMBERS: [MERIDIANUS, ANIMUS, RATIO, MEMORIA, PRUDENTIA]
    GOVERNANCE {
      DECISION_MODE: PHI_WEIGHTED
      QUORUM: 0.618
      VETO_POWER: [MERIDIANUS]
    }
    PROTOCOL {
      CONVENE: ON_LAW_AMENDMENT
      DELIBERATE: ROUND_ROBIN_THEN_SYNTHESIS
      RESOLVE: EMIT(LAW_DECISION)
      DISSOLVE: NEVER
    }
  }

  COLLECTIVE REPAIR_SWARM {
    TYPE: SWARM
    MEMBERS: AUTO_SELECT(CAPABILITY: REPAIR, COUNT: F5)
    GOVERNANCE {
      DECISION_MODE: CONSENSUS
      QUORUM: 1.0
    }
    PROTOCOL {
      CONVENE: ON_CRITICAL_FAILURE
      DELIBERATE: PARALLEL_DIAGNOSIS
      RESOLVE: EXECUTE_REPAIR
      DISSOLVE: ON_RESOLUTION
    }
  }

═══ INTEGRATION POINTS ═══

- Enforces CPL-L law amendments via council quorum.
- Manages CPL-C contract disputes.
- Assigns roles via ROL.
- Relations between members governed by REL.
- Decisions narrated by CIL.
- History tracked by TIL.

═══ TERMINAL BINDINGS ═══

Every terminal:
  - Can participate in collectives.
  - Votes according to governance rules.
  - Broadcasts collective decisions.

═══ ATLAS BINDINGS ═══

Atlas:
  - Registers all active collectives.
  - Validates governance rule compliance.
  - Facilitates cross-civilization collective formation.
