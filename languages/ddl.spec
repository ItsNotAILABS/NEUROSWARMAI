---
name: Data Definition Language
id: ddl
layer: Infrastructure
version: 1.0.0
status: stable
phi_sync: true
phi_beat: 873ms

domain:
  description: >
    DDL defines data shapes, semantics, and the ontology of data — schemas, types, constraints, and migrations.
  scope: [data-shapes, schemas, type-systems, migrations]

core_concepts:
  - SCHEMA
  - FIELD
  - TYPE
  - CONSTRAINT
  - INDEX
  - RELATION
  - MIGRATE
  - VALIDATE

syntax:
  form: schema-blocks
  primary_block: SCHEMA
  encoding: yaml
  schema:
    types:
    - name: string
      fields: 
- name: string
  type: string
  constraints: [string]


storage:
  extension: .ddl
  location: data/schema/*.ddl

integration:
  constrained_by: [CPL-L, ECL]
  feeds_into: [MML, IIL]
  consumed_by: [databases, services]

terminal_binding: Every terminal validates data against DDL shapes
atlas_binding: Maintains the data shape registry
---
╔══════════════════════════════════════════════════════════════════╗
║  DDL — DATA DEFINITION LANGUAGE                                  ║
║  Stack: IX — Infrastructure & Physics                            ║
║  Version: 1.0.0 · φ-Aligned                                     ║
╚══════════════════════════════════════════════════════════════════╝

═══ PURPOSE ═══

DDL defines data shapes, semantics, and the ontology of data
within the Cognitive Cosmos. It is how data is understood,
not just stored.

═══ SYNTAX ═══

  DATA <name> {
    SHAPE {
      FIELDS: [
        { NAME: <name>, TYPE: <type>, REQUIRED: <boolean> },
        ...
      ]
      CONSTRAINTS: [<validation>, ...]
    }
    SEMANTICS {
      MEANING: <description>
      DOMAIN: <knowledge_domain>
      SENSITIVITY: SOVEREIGN | SENSITIVE | INTERNAL | PUBLIC
    }
    STORAGE {
      ENGINE: <storage_type>
      RETENTION: <duration>
      REPLICATION: <factor>
      ENCRYPTION: <algorithm>
    }
    LINEAGE {
      SOURCE: <origin>
      TRANSFORMS: [<transform>, ...]
      CONSUMERS: [<entity>, ...]
    }
  }

═══ SEMANTICS ═══

- SHAPE defines the structural schema.
- SEMANTICS gives data meaning beyond structure.
- STORAGE defines how and where data lives.
- LINEAGE tracks data provenance and flow.
- DDL shapes are used by IIL interface schemas.

═══ EXAMPLES ═══

  DATA COGNITIVE_TRACE {
    SHAPE {
      FIELDS: [
        { NAME: id, TYPE: UUID, REQUIRED: TRUE },
        { NAME: terminal, TYPE: TerminalID, REQUIRED: TRUE },
        { NAME: pipeline, TYPE: String, REQUIRED: TRUE },
        { NAME: stages, TYPE: Array[StageResult], REQUIRED: TRUE },
        { NAME: confidence, TYPE: Float, REQUIRED: TRUE },
        { NAME: timestamp, TYPE: Epoch, REQUIRED: TRUE }
      ]
      CONSTRAINTS: [confidence >= 0.0, confidence <= 1.0]
    }
    SEMANTICS {
      MEANING: "Complete trace of a cognitive pipeline execution."
      DOMAIN: COGNITION
      SENSITIVITY: SOVEREIGN
    }
    STORAGE {
      ENGINE: SOVEREIGN_DB
      RETENTION: PERMANENT
      REPLICATION: F3
      ENCRYPTION: AES_256_GCM
    }
    LINEAGE {
      SOURCE: CPL_P_PIPELINE
      TRANSFORMS: [CIL_ANNOTATION, MML_ENRICHMENT]
      CONSUMERS: [ATLAS, TIL, AUDIT_LOG]
    }
  }

═══ INTEGRATION POINTS ═══

- Shapes used by IIL interface schemas.
- Sensitivity governed by ECL compliance.
- Monitored by MML metrics.
- Stored per DDL storage rules.
- Lineage tracked by TIL.
- Queried via CPL-P pipelines.

═══ TERMINAL BINDINGS ═══

Every terminal:
  - Validates data against DDL shapes.
  - Respects sensitivity classifications.
  - Reports lineage for data it produces.

═══ ATLAS BINDINGS ═══

Atlas:
  - Maintains the data shape registry.
  - Enforces data governance.
  - Tracks global data lineage.
