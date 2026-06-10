---
name: Cognitive Contract Language
id: cpl-c
layer: CoreLaw
version: 1.0.0
status: stable
phi_sync: true
phi_beat: 873ms

domain:
  description: >
    CPL-C governs civilization-level contracts, agreements between parties, SLAs, and enforceable obligations.
  scope: [contracts, SLAs, obligations, permissions]

core_concepts:
  - CONTRACT
  - PARTIES
  - OBLIGATION
  - PERMISSION
  - FLOW
  - SLA
  - DEADLINE
  - PENALTY

syntax:
  form: contract-blocks
  primary_block: CONTRACT

integration:
  constrained_by: [CPL-L]
  feeds_into: [OCL, BCL]
  consumed_by: [terminals, Atlas]

terminal_binding: Every terminal can propose, accept, or reject contracts
atlas_binding: Stores the canonical contract registry
---
╔══════════════════════════════════════════════════════════════════╗
║  CPL-C — COGNITIVE CONTRACT LANGUAGE                             ║
║  Stack: I — Core Cognitive Law                                   ║
║  Version: 1.0.0 · φ-Aligned                                     ║
╚══════════════════════════════════════════════════════════════════╝

═══ PURPOSE ═══

CPL-C governs civilization-level contracts — agreements between
entities, organisms, terminals, and civilizations. It encodes
rights, duties, flows, token logic, and SLAs.

Unlike CPL-L (immutable law), CPL-C contracts are negotiable,
revocable, and time-bound.

═══ SYNTAX ═══

Contract blocks with obligations, permissions, flows.

  CONTRACT <name> {
    PARTIES: [<entity>, ...]
    OBLIGATION <name> {
      PARTY: <entity>
      ACTION: <action>
      DEADLINE: <time_expr>
      PENALTY: <consequence>
    }
    PERMISSION <name> {
      PARTY: <entity>
      SCOPE: <resource>
      DURATION: <time_expr>
    }
    FLOW <name> {
      FROM: <source>
      TO: <destination>
      TOKEN: <token_type>
      AMOUNT: <expr>
      TRIGGER: <event>
    }
    SLA <name> {
      METRIC: <metric>
      TARGET: <value>
      BREACH_PENALTY: <consequence>
    }
  }

═══ SEMANTICS ═══

- Contracts are bilateral or multilateral.
- OBLIGATIONs are enforceable duties with deadlines and penalties.
- PERMISSIONs grant scoped, time-limited access.
- FLOWs define token/data movement triggered by events.
- SLAs define measurable performance guarantees.
- Contracts cannot violate CPL-L laws.
- Contract state is tracked in the Atlas registry.

═══ EXAMPLES ═══

  CONTRACT ORGANISM_SERVICE_AGREEMENT {
    PARTIES: [MERIDIANUS, CLIENT_ALPHA]
    OBLIGATION DELIVER_COGNITION {
      PARTY: MERIDIANUS
      ACTION: PROCESS_QUERY
      DEADLINE: 873ms
      PENALTY: CREDIT(1, FORMA)
    }
    PERMISSION DATA_ACCESS {
      PARTY: CLIENT_ALPHA
      SCOPE: KNOWLEDGE_GRAPH
      DURATION: 30d
    }
    FLOW PAYMENT {
      FROM: CLIENT_ALPHA
      TO: MERIDIANUS
      TOKEN: FORMA
      AMOUNT: PHI * usage_units
      TRIGGER: ON_DELIVERY
    }
    SLA UPTIME {
      METRIC: AVAILABILITY
      TARGET: 0.9999
      BREACH_PENALTY: CREDIT(89, FORMA)
    }
  }

═══ INTEGRATION POINTS ═══

- Constrained by CPL-L constitutional laws.
- OCL organism charters define what contracts an organism can sign.
- CPL-P pipelines execute contract logic.
- BCL business contracts are a specialization for enterprise.
- ECL compliance rules validate contract legality.
- MML metrics feed SLA monitoring.

═══ TERMINAL BINDINGS ═══

Every terminal:
  - Can propose, accept, or reject contracts.
  - Enforces active contracts during operation.
  - Reports contract breaches to Atlas.

═══ ATLAS BINDINGS ═══

Atlas:
  - Stores the canonical contract registry.
  - Mediates disputes between parties.
  - Triggers penalty flows on breach detection.
  - Archives expired contracts for TIL history.
