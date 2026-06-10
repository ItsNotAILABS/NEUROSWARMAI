---
name: Institution Structure Language
id: isl
layer: Education
version: 1.0.0
status: stable
phi_sync: true
phi_beat: 873ms

domain:
  description: >
    ISL defines the architecture of institutions — schools, districts, departments, and their governance policies.
  scope: [institutional-architecture, departments, policies, accreditation]

core_concepts:
  - INSTITUTION
  - DEPARTMENT
  - ROLE
  - POLICY
  - RESOURCE
  - CALENDAR
  - CAPACITY
  - ACCREDIT

syntax:
  form: institution-blocks
  primary_block: INSTITUTION
  encoding: yaml
  schema:
    id: string
    units:
    - id: string
      name: string
    governance_rules: [string]


storage:
  extension: .isl
  location: education/institutions/*.isl

integration:
  constrained_by: [CPL-L, ECL]
  feeds_into: [EDL, FAL]
  consumed_by: [institutions]

terminal_binding: Terminals serving as institution nodes host educational programs
atlas_binding: Accredits institutions
---
╔══════════════════════════════════════════════════════════════════╗
║  ISL — INSTITUTION STRUCTURE LANGUAGE                            ║
║  Stack: VII — Education & Growth                                 ║
║  Version: 1.0.0 · φ-Aligned                                     ║
╚══════════════════════════════════════════════════════════════════╝

═══ PURPOSE ═══

ISL defines the architecture of institutions — schools, districts,
academies, and any organizational structure devoted to education,
growth, and development.

═══ SYNTAX ═══

  INSTITUTION <name> {
    TYPE: SCHOOL | ACADEMY | DISTRICT | GUILD | LABORATORY
    MISSION: <purpose_statement>
    STRUCTURE {
      DEPARTMENTS: [<department>, ...]
      HIERARCHY: <org_chart>
      GOVERNANCE: <col_ref>
    }
    PROGRAMS: [
      {
        NAME: <program_name>
        CURRICULUM: <edl_ref>
        PATHWAYS: [<pwl_ref>, ...]
        CAPACITY: <fibonacci_number>
      }
    ]
    RESOURCES {
      TOOLS: [<tsl_ref>, ...]
      FACULTY: [<entity>, ...]
      BUDGET: <token_amount>
    }
  }

═══ SEMANTICS ═══

- INSTITUTIONs are typed organizational structures.
- STRUCTURE defines internal organization.
- PROGRAMS link to EDL curricula and PWL pathways.
- CAPACITY is Fibonacci-scaled for natural growth.
- RESOURCES define tools, faculty, and budget.

═══ EXAMPLES ═══

  INSTITUTION COGNITIVE_ACADEMY {
    TYPE: ACADEMY
    MISSION: "Train sovereign minds in all 40 languages."
    STRUCTURE {
      DEPARTMENTS: [LAW, PSYCHE, CREATION, INFRASTRUCTURE]
      HIERARCHY: FLAT_WITH_PHI_WEIGHTING
      GOVERNANCE: COL.ACADEMY_COUNCIL
    }
    PROGRAMS: [
      {
        NAME: SOVEREIGN_CERTIFICATION
        CURRICULUM: EDL.COGNITIVE_COSMOS_EDUCATION
        PATHWAYS: [PWL.ORGANISM_TO_SOVEREIGN]
        CAPACITY: F13
      }
    ]
    RESOURCES {
      TOOLS: [TSL.QUERY_ANALYZER, TSL.DOCTRINE_VALIDATOR]
      FACULTY: [MERIDIANUS, ANIMUS, RATIO]
      BUDGET: 10000 FORMA
    }
  }

═══ INTEGRATION POINTS ═══

- Delivers EDL curricula.
- Houses SPL learning programs.
- Follows PWL pathways.
- Uses TSL tools.
- Governed by COL collectives.
- Family context via FAL.

═══ TERMINAL BINDINGS ═══

Terminals serving as institution nodes:
  - Host educational programs.
  - Track enrollment and progress.
  - Report institutional metrics.

═══ ATLAS BINDINGS ═══

Atlas:
  - Accredits institutions.
  - Validates institutional quality.
  - Connects institutions across civilizations.
