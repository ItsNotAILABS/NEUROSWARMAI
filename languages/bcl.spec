---
name: Business Contract Language
id: bcl
layer: Enterprise
version: 1.0.0
status: stable
phi_sync: true
phi_beat: 873ms

domain:
  description: >
    BCL defines organization-to-organization agreements — business contracts, terms, deliverables, and enforcement.
  scope: [business-contracts, terms, deliverables, enforcement]

core_concepts:
  - BUSINESS_CONTRACT
  - PARTY
  - TERM
  - DELIVERABLE
  - PAYMENT
  - BREACH
  - RENEWAL
  - TERMINATE

syntax:
  form: business-contract
  primary_block: BUSINESS_CONTRACT
  encoding: yaml
  schema:
    id: string
    parties: [string]
    terms: [string]
    obligations: [string]


storage:
  extension: .bcl
  location: enterprise/contracts/*.bcl

integration:
  constrained_by: [CPL-L, CPL-C, ECL]
  feeds_into: [IIL, MML]
  consumed_by: [organizations]

terminal_binding: Terminals with business role execute BCL contract terms
atlas_binding: Maintains business contract registry
---
╔══════════════════════════════════════════════════════════════════╗
║  BCL — BUSINESS CONTRACT LANGUAGE                                ║
║  Stack: VIII — Enterprise & Organizational                       ║
║  Version: 1.0.0 · φ-Aligned                                     ║
╚══════════════════════════════════════════════════════════════════╝

═══ PURPOSE ═══

BCL defines organization-to-organization agreements — business
contracts, partnerships, service agreements, and commercial
relationships within and between civilizations.

═══ SYNTAX ═══

  BUSINESS_CONTRACT <name> {
    PARTIES: [<org>, <org>]
    TYPE: PARTNERSHIP | SERVICE | LICENSE | ACQUISITION | JOINT_VENTURE
    TERMS {
      DURATION: <time_expr>
      RENEWAL: AUTOMATIC | MANUAL | CONDITIONAL
      TERMINATION: <conditions>
    }
    OBLIGATIONS: [
      {
        PARTY: <org>
        DELIVERABLE: <output>
        SCHEDULE: <timeline>
        PENALTY: <consequence>
      }
    ]
    FINANCIAL {
      PAYMENT: <token_flow>
      REVENUE_SHARE: <ratio>
      ESCROW: <amount>
    }
    GOVERNANCE: <col_ref>
  }

═══ SEMANTICS ═══

- BCL extends CPL-C with enterprise-specific constructs.
- TERMS define the temporal and conditional bounds.
- OBLIGATIONS are enforceable deliverables.
- FINANCIAL terms define token flows and revenue sharing.
- BCL contracts must comply with ECL compliance rules.

═══ EXAMPLES ═══

  BUSINESS_CONTRACT COGNITIVE_SERVICE_PARTNERSHIP {
    PARTIES: [COMMAND_PLATFORM, ENTERPRISE_CLIENT]
    TYPE: SERVICE
    TERMS {
      DURATION: 1 YEAR
      RENEWAL: CONDITIONAL(SATISFACTION > 0.89)
      TERMINATION: 30_DAY_NOTICE
    }
    OBLIGATIONS: [
      {
        PARTY: COMMAND_PLATFORM
        DELIVERABLE: COGNITIVE_API_ACCESS
        SCHEDULE: 24_7
        PENALTY: SLA_CREDIT
      }
    ]
    FINANCIAL {
      PAYMENT: MONTHLY(1000 FORMA)
      REVENUE_SHARE: PHI_INVERSE
      ESCROW: 3000 FORMA
    }
    GOVERNANCE: COL.PARTNERSHIP_COMMITTEE
  }

═══ INTEGRATION POINTS ═══

- Extends CPL-C contract framework.
- Validated by ECL compliance.
- Integrated via IIL interfaces.
- Tracked by MML metrics.
- Logged in TIL.
- Governed by COL.

═══ TERMINAL BINDINGS ═══

Terminals with business role:
  - Execute BCL contract terms.
  - Report obligation fulfillment.
  - Trigger financial flows.

═══ ATLAS BINDINGS ═══

Atlas:
  - Maintains business contract registry.
  - Mediates disputes.
  - Enforces compliance.
